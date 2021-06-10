Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ADC8C47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 04:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9490613B3
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 04:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhFJE4r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 00:56:47 -0400
Received: from smtprelay0087.hostedemail.com ([216.40.44.87]:47808 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229529AbhFJE4q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Jun 2021 00:56:46 -0400
Received: from omf12.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 572B7181D337B;
        Thu, 10 Jun 2021 04:54:50 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf12.hostedemail.com (Postfix) with ESMTPA id 8007A24023F;
        Thu, 10 Jun 2021 04:54:47 +0000 (UTC)
Message-ID: <e0950e65c5e7f8f0db132cfd22bdd24ee27c63e7.camel@perches.com>
Subject: Re: [PATCH] scsi: ufs: Add indent for code alignment
From:   Joe Perches <joe@perches.com>
To:     keosung.park@samsung.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "satyat@google.com" <satyat@google.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Wed, 09 Jun 2021 21:54:46 -0700
In-Reply-To: <1891546521.01623299401994.JavaMail.epsvc@epcpadp3>
References: <CGME20210610040731epcms2p7533bc62d13b82a0e86590f30ac4b6c30@epcms2p7>
         <1891546521.01623299401994.JavaMail.epsvc@epcpadp3>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 8007A24023F
X-Stat-Signature: 1rrt63hpehtiueafoipnuh41kncp1i97
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18yOD5I0kpqbzHqufp09I0M3g46l2YLBuQ=
X-HE-Tag: 1623300887-154885
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-06-10 at 13:07 +0900, Keoseong Park wrote:
> Add indentation to return statement.
[]
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
[]
> @@ -903,7 +903,7 @@ static inline bool ufshcd_is_intr_aggr_allowed(struct ufs_hba *hba)
>  	else
>  		return false;
>  #else
> -return true;
> +	return true;
>  #endif
>  }
>  

Perhaps a little refactoring instead:
---
 drivers/scsi/ufs/ufshcd.h | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c98d540ac044d..ed89839476b3b 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -894,15 +894,11 @@ static inline bool ufshcd_is_rpm_autosuspend_allowed(struct ufs_hba *hba)
 static inline bool ufshcd_is_intr_aggr_allowed(struct ufs_hba *hba)
 {
 /* DWC UFS Core has the Interrupt aggregation feature but is not detectable*/
-#ifndef CONFIG_SCSI_UFS_DWC
-	if ((hba->caps & UFSHCD_CAP_INTR_AGGR) &&
-	    !(hba->quirks & UFSHCD_QUIRK_BROKEN_INTR_AGGR))
+	if (IS_ENABLED(CONFIG_SCSI_UFS_DWC))
 		return true;
-	else
-		return false;
-#else
-return true;
-#endif
+
+	return (hba->caps & UFSHCD_CAP_INTR_AGGR) &&
+		!(hba->quirks & UFSHCD_QUIRK_BROKEN_INTR_AGGR);
 }
 
 static inline bool ufshcd_can_aggressive_pc(struct ufs_hba *hba)

