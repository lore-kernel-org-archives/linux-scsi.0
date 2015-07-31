From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target/iscsi: Fix double free of a TUR followed by a
 solicited NOPOUT
Date: Thu, 30 Jul 2015 23:10:16 -0700
Message-ID: <1438323016.16598.11.camel@haakon3.risingtidesystems.com>
References: <1437516477-30554-4-git-send-email-sbaugh@catern.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437516477-30554-4-git-send-email-sbaugh@catern.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Spencer Baugh <sbaugh@catern.com>
Cc: Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Andy Grover <agrover@redhat.com>, Alexei Potashnik <alexei@purestorage.com>, Christophe Vu-Brugier <cvubrugier@fastmail.fm>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

Hi Spencer & Alexei,

On Tue, 2015-07-21 at 15:07 -0700, Spencer Baugh wrote:
> From: Alexei Potashnik <alexei@purestorage.com>
> 
> Make sure all non-READ SCSI commands get targ_xfer_tag initialized
> to 0xffffffff, not just WRITEs.
> 
> Double-free of a TUR cmd object occurs under the following scenario:
> 
> 1. TUR received (targ_xfer_tag is uninitialized and left at 0)
> 2. TUR status sent
> 3. First unsolicited NOPIN is sent to initiator (gets targ_xfer_tag of 0)
> 4. NOPOUT for NOPIN (with TTT=0) arrives
>  - its ExpStatSN acks TUR status, TUR is queued for removal
>  - LIO tries to find NOPIN with TTT=0, but finds the same TUR instead,
>    TUR is queued for removal for the 2nd time
> 
> Signed-off-by: Alexei Potashnik <alexei@purestorage.com>
> Signed-off-by: Spencer Baugh <sbaugh@catern.com>
> ---

Very nice catch on this bug.

>  drivers/target/iscsi/iscsi_target.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index a4cf58c..ebb1ece 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -970,7 +970,7 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
>  	conn->sess->init_task_tag = cmd->init_task_tag = hdr->itt;
>  	if (hdr->flags & ISCSI_FLAG_CMD_READ) {
>  		cmd->targ_xfer_tag = session_get_next_ttt(conn->sess);
> -	} else if (hdr->flags & ISCSI_FLAG_CMD_WRITE)
> +	} else
>  		cmd->targ_xfer_tag = 0xFFFFFFFF;
>  	cmd->cmd_sn		= be32_to_cpu(hdr->cmdsn);
>  	cmd->exp_stat_sn	= be32_to_cpu(hdr->exp_statsn);

One small nit.  linux kernel coding style says conditionals should use
matching brackets.  Since it's a single line body, no reason to use
brackets at all.

Applying the updated patch below to target-pending/master with CC' for
3.1 stable.

Thanks!

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index cd77a06..fd09290 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -968,9 +968,9 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
                cmd->cmd_flags |= ICF_NON_IMMEDIATE_UNSOLICITED_DATA;
 
        conn->sess->init_task_tag = cmd->init_task_tag = hdr->itt;
-       if (hdr->flags & ISCSI_FLAG_CMD_READ) {
+       if (hdr->flags & ISCSI_FLAG_CMD_READ)
                cmd->targ_xfer_tag = session_get_next_ttt(conn->sess);
-       } else if (hdr->flags & ISCSI_FLAG_CMD_WRITE)
+       else
                cmd->targ_xfer_tag = 0xFFFFFFFF;
        cmd->cmd_sn             = be32_to_cpu(hdr->cmdsn);
        cmd->exp_stat_sn        = be32_to_cpu(hdr->exp_statsn);
