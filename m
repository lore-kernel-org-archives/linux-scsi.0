From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH-v3 1/5] target: Fix LUN_RESET active I/O handling for
	ACK_KREF
Date: Tue, 2 Feb 2016 10:37:41 +0100
Message-ID: <20160202093741.GA26933@lst.de>
References: <1454132222-29009-1-git-send-email-nab@daterainc.com> <1454132222-29009-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454132222-29009-2-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

> @@ -282,6 +305,16 @@ static void core_tmr_drain_state_list(
>  		if (prout_cmd == cmd)
>  			continue;
>  
> +		sess = cmd->se_sess;
> +		if (WARN_ON_ONCE(!sess))
> +			continue;
> +
> +		spin_lock(&sess->sess_cmd_lock);
> +		rc = __target_check_io_state(cmd);
> +		spin_unlock(&sess->sess_cmd_lock);
> +		if (!rc)
> +			continue;
> +

I still don't understand why we care about the session or sess_cmd_lock
here.  There isn't anything in __target_check_io_state that relies
on them (except for the assert checking the lock).
