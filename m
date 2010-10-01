From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Drop srb reference before waiting for
 completion
Date: Fri, 1 Oct 2010 10:02:11 -0700
Message-ID: <C8CB6223.9D55%giridhar.malavali@qlogic.com>
References: <20101001121844.4ABF3353A8@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:12936 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab0JARCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Oct 2010 13:02:25 -0400
In-Reply-To: <20101001121844.4ABF3353A8@ochil.suse.de>
Content-Language: en
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>
Cc: LinuxSCSI <linux-scsi@vger.kernel.org>




On 10/1/10 5:18 AM, "Hannes Reinecke" <hare@suse.de> wrote:

> 
> 
> This patch fixes a regression introduced by commit
> 083a469db4ecf3b286a96b5b722c37fc1affe0be
> 
> qla2xxx_eh_wait_on_command() is waiting for an srb to
> complete, which will never happen as the routine took
> a reference to the srb previously and will only drop it
> after this function. So every command abort will fail.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 1e4bff6..0af7549 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -883,6 +883,9 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
>         }
>         spin_unlock_irqrestore(&ha->hardware_lock, flags);
> 
> +       if (got_ref)
> +               qla2x00_sp_compl(ha, sp);
> +
>         /* Wait for the command to be returned. */
>         if (wait) {
>                 if (qla2x00_eh_wait_on_command(cmd) != QLA_SUCCESS) {
> @@ -893,9 +896,6 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
>                 }
>         }
> 
> -       if (got_ref)
> -               qla2x00_sp_compl(ha, sp);
> -
>         qla_printk(KERN_INFO, ha,
>             "scsi(%ld:%d:%d): Abort command issued -- %d %lx %x.\n",
>             vha->host_no, id, lun, wait, serial, ret);

void
qla2x00_sp_compl(struct qla_hw_data *ha, srb_t *sp)
{
        if (atomic_read(&sp->ref_count) == 0) {
                DEBUG2(qla_printk(KERN_WARNING, ha,
                    "SP reference-count to ZERO -- sp=%p\n", sp));
                DEBUG2(BUG());
                return;
        }
        if (!atomic_dec_and_test(&sp->ref_count))
                return;
        qla2x00_sp_final_compl(ha, sp);
}

All completions will check for reference count going to zero before
releasing the sp structure. Since the ref count is incremented by the
eh_abort hanlder, I don't see sp getting released unless ref count goes to
0. I could not see any other places where sp is getting released. Do you
have any stack trace or logs so that I can analyze more.

-- Giri



 




> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

