From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v4 3/3] qla2xxx: Add tcm_qla2xxx fabric module for
 mainline target
Date: Mon, 09 Jan 2012 16:24:13 -0800
Message-ID: <1326155053.6802.40.camel@haakon2.linux-iscsi.org>
References: <1324173746-14361-1-git-send-email-nab@linux-iscsi.org>
	 <1324173746-14361-4-git-send-email-nab@linux-iscsi.org>
	 <CAL1RGDX-MR6pEwDN-vSjx92wUD3x5zk26UAG9QKpw1jp5-85mg@mail.gmail.com>
	 <1324677068.16979.103.camel@haakon2.linux-iscsi.org>
	 <CAL1RGDX2FkenDkJxkB2hcj1hyqfsTJF2O0tygpwHNRgHupSsBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43457 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933521Ab2AJAYV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2012 19:24:21 -0500
In-Reply-To: <CAL1RGDX2FkenDkJxkB2hcj1hyqfsTJF2O0tygpwHNRgHupSsBw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <JBottomley@parallels.com>, Joern Engel <joern@logfs.org>, Madhuranath Iyengar <mni@risingtidesystems.com>

Hi Roland & Co,

My apologies for the delayed response here, still catching up after the
holidays..


On Mon, 2012-01-02 at 13:38 -0800, Roland Dreier wrote:
> On Fri, Dec 23, 2011 at 1:51 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > So the (t_transport_complete == 0) check causing the issue above should
> > be safe to remove now..  The same is true for the !cmd->se_cmd.se_dev
> > check in tcm_qla2xxx_free_cmd() as well.
> 
> Basically you're saying the following is the right fix?
> 
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -401,21 +401,6 @@ static void tcm_qla2xxx_complete_free(struct
> work_struct *work)
>   */
>  void tcm_qla2xxx_free_cmd(struct qla_tgt_cmd *cmd)
>  {
> -       barrier();
> -       /*
> -        * Handle tcm_qla2xxx_init_cmd() -> transport_get_lun_for_cmd()
> -        * failure case where cmd->se_cmd.se_dev was not assigned, and
> -        * a call to transport_generic_free_cmd_intr() is not possible..
> -        */
> -       if (!cmd->se_cmd.se_dev) {
> -               target_put_sess_cmd(cmd->se_cmd.se_sess, &cmd->se_cmd);
> -               transport_generic_free_cmd(&cmd->se_cmd, 0);
> -               return;
> -       }
> -
> -       if (!atomic_read(&cmd->se_cmd.t_transport_complete))
> -               target_put_sess_cmd(cmd->se_cmd.se_sess, &cmd->se_cmd);
> -
>         INIT_WORK(&cmd->work, tcm_qla2xxx_complete_free);
>         queue_work(tcm_qla2xxx_free_wq, &cmd->work);
>  }
> 
> (I'm deleting the barrier() as part of this too because it's almost certainly
> wrong... an indirect call through a function pointer that gets here is just
> as much of a compiler optimization barrier anyway).
> 

Yes, this should be fine.  I still need to verify this internally, and
will push this into lio-core/qla_tgt-3.3 after testing.

Thanks,

--nab


