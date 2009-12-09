From: Dan Carpenter <error27@gmail.com>
Subject: Re: [patch] potential null deref in lpfc_els.c
Date: Wed, 9 Dec 2009 12:52:12 +0200
Message-ID: <20091209105212.GA20557@bicker>
References: <1260295121.6096.19.camel@wookie> <1260295303.6096.21.camel@wookie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39993 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbZLIKwx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2009 05:52:53 -0500
Received: by bwz27 with SMTP id 27so5096898bwz.21
        for <linux-scsi@vger.kernel.org>; Wed, 09 Dec 2009 02:52:59 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1260295303.6096.21.camel@wookie>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: james.bottomley@suse.de, linux-scsi@vger.kernel.org

On Tue, Dec 08, 2009 at 01:01:23PM -0500, James Smart wrote:
> 
> > This patch is against 2.6.32-rc8.
> >
> > The issue was found by a static checker.  If cmd==ELS_CMD_PLOGI, it
> > is possible for ndlp to be NULL.  We do check ndlp further down the
> > function so that would also indicate that we should check ndlp here.
> > 
> > Compile tested.
> >
> 
> Dan,
> 
> Thanks. We never hit this as it's code specific to using debugfs, which
> we don't turn on except for very rare occasions. Anyway, it is an error,
> so it's worth correcting.
> 
> I've updated your patch to change the default value - I wanted to D_ID
> to be a non-valid value.
> 

Cool.  Thanks, I should have asked you what value you wanted there before.

regards,
dan

> -- james s
> 
> 
> 
>  Signed-off-by: James Smart <james.smart@emulex.com>
> 
>  ---
> 
>  lpfc_els.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> --- a/drivers/scsi/lpfc/lpfc_els.c	2009-12-08 09:43:11.000000000 -0500
> +++ b/drivers/scsi/lpfc/lpfc_els.c	2009-12-08 12:36:56.000000000 -0500
> @@ -2562,7 +2562,8 @@ lpfc_els_retry(struct lpfc_hba *phba, st
>  
>  	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
>  		"Retry ELS:       wd7:x%x wd4:x%x did:x%x",
> -		*(((uint32_t *) irsp) + 7), irsp->un.ulpWord[4], ndlp->nlp_DID);
> +		*(((uint32_t *) irsp) + 7), irsp->un.ulpWord[4],
> +		(ndlp ?  ndlp->nlp_DID : 0xFFFFFFFF));
>  
>  	switch (irsp->ulpStatus) {
>  	case IOSTAT_FCP_RSP_ERROR:
> 
