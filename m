From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [patch] potential null deref in lpfc_els.c
Date: Tue, 8 Dec 2009 13:01:23 -0500
Message-ID: <1260295303.6096.21.camel@wookie>
References: <1260295121.6096.19.camel@wookie>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46003 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936609AbZLHSBr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2009 13:01:47 -0500
In-Reply-To: <1260295121.6096.19.camel@wookie>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: james.bottomley@suse.de, linux-scsi@vger.kernel.org


> This patch is against 2.6.32-rc8.
>
> The issue was found by a static checker.  If cmd==ELS_CMD_PLOGI, it
> is possible for ndlp to be NULL.  We do check ndlp further down the
> function so that would also indicate that we should check ndlp here.
> 
> Compile tested.
>

Dan,

Thanks. We never hit this as it's code specific to using debugfs, which
we don't turn on except for very rare occasions. Anyway, it is an error,
so it's worth correcting.

I've updated your patch to change the default value - I wanted to D_ID
to be a non-valid value.

-- james s



 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2009-12-08 09:43:11.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2009-12-08 12:36:56.000000000 -0500
@@ -2562,7 +2562,8 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"Retry ELS:       wd7:x%x wd4:x%x did:x%x",
-		*(((uint32_t *) irsp) + 7), irsp->un.ulpWord[4], ndlp->nlp_DID);
+		*(((uint32_t *) irsp) + 7), irsp->un.ulpWord[4],
+		(ndlp ?  ndlp->nlp_DID : 0xFFFFFFFF));
 
 	switch (irsp->ulpStatus) {
 	case IOSTAT_FCP_RSP_ERROR:


