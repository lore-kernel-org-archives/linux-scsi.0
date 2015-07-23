From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH] target: Drop iSCSI use of mutex around max_cmd_sn
 increment
Date: Thu, 23 Jul 2015 00:33:15 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295AA03CD1@G9W0745.americas.hpqcorp.net>
References: <1437602898-15229-2-git-send-email-sbaugh@catern.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1437602898-15229-2-git-send-email-sbaugh@catern.com>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: Spencer Baugh <sbaugh@catern.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Alexei Potashnik <alexei@purestorage.com>, Andy Grover <agrover@redhat.com>, Christophe Vu-Brugier <cvubrugier@fastmail.fm>, Roland Dreier <roland@purestorage.com>, Joern Engel <joern@logfs.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, James Bottomley <JBottomley@Odin.com>, Evgenii Lepikhin <johnlepikhin@gmail.com>, Hannes Reinecke <hare@suse.de>, Al Viro <viro@zeniv.linux.org.uk>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Spencer Baugh
> Sent: Wednesday, July 22, 2015 5:08 PM
> Subject: [PATCH] target: Drop iSCSI use of mutex around max_cmd_sn
> increment
...
> diff --git a/drivers/target/iscsi/iscsi_target_configfs.c
> b/drivers/target/iscsi/iscsi_target_configfs.c
> index c1898c8..29d5930 100644
> --- a/drivers/target/iscsi/iscsi_target_configfs.c
> +++ b/drivers/target/iscsi/iscsi_target_configfs.c
> @@ -706,8 +706,8 @@ static ssize_t lio_target_nacl_show_info(
>  		rb += sprintf(page+rb, " 0x%08x   0x%08x   0x%08x   0x%08x"
>  				"   0x%08x   0x%08x\n",
>  			sess->cmdsn_window,
> -			(sess->max_cmd_sn - sess->exp_cmd_sn) + 1,
> -			sess->exp_cmd_sn, sess->max_cmd_sn,
> +			((u32) atomic_read(&sess->max_cmd_sn) - sess-
> >exp_cmd_sn) + 1,
> +			sess->exp_cmd_sn, (u32) atomic_read(&sess->max_cmd_sn),
>  			sess->init_task_tag, sess->targ_xfer_tag);
>  		rb += sprintf(page+rb, "----------------------[iSCSI"
>  				" Connections]-------------------------\n");

Two calls to atomic_read could pick up different values; 
calling it once and using the same value twice would ensure
the arguments are consistent with each other.

> diff --git a/drivers/target/iscsi/iscsi_target_device.c
> b/drivers/target/iscsi/iscsi_target_device.c
> index 5fabcd3..a526904 100644
> --- a/drivers/target/iscsi/iscsi_target_device.c
> +++ b/drivers/target/iscsi/iscsi_target_device.c
...
> @@ -57,9 +57,7 @@ void iscsit_increment_maxcmdsn(struct iscsi_cmd *cmd,
> struct iscsi_session *sess
> 
>  	cmd->maxcmdsn_inc = 1;
> 
> -	mutex_lock(&sess->cmdsn_mutex);
> -	sess->max_cmd_sn += 1;
> -	pr_debug("Updated MaxCmdSN to 0x%08x\n", sess->max_cmd_sn);
> -	mutex_unlock(&sess->cmdsn_mutex);
> +	atomic_inc(&sess->max_cmd_sn);
> +	pr_debug("Updated MaxCmdSN to 0x%08x\n", atomic_read(&sess-
> >max_cmd_sn));
>  }
>  EXPORT_SYMBOL(iscsit_increment_maxcmdsn);

If there is another change before the atomic_read, this would
print a value unrelated to the increment done by this thread. 
atomic_inc_return would provide the appropriate value to print.

---
Robert Elliott, HP Server Storage
