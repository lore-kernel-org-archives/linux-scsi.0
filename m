Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2012DC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 05:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239710AbiCBFPW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 00:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239470AbiCBFPR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 00:15:17 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D239B1531
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 21:14:07 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222gofJ016793;
        Wed, 2 Mar 2022 05:13:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=j+kCFMGjieJ4h5nDQl3I+ljtYWlO331r6fDiPcSJFAk=;
 b=TksKw35p8jv0+Rh3sLaAar9fPb9ltzmGp63G4Id+tDlSupITFp6FFl9wztTBl05v5nWb
 JAHNjn+dqBSv1/2MM41fJ4Ib/z36jUyaX2P8DEazvVQ0q9oOk2M7A8zlVrTlfy1P+RvI
 Q+/BOitXfErrJCM9YU+dMfszNGuE15qvtnkovk0Q93XC3JeMv66Y7XktltA/gPaa3g3P
 qqcN4m36Ga8mQ8VAeNf4r2Phjp+PBFXbhdKWf54OOYXuZoWAptbMEL7n+cET1H5bPYyG
 Iwyef5XzoCJAtrlFb+4pFt21x+sSFSvLa9SIgq994lEJ3kKbQlo4AAo3pZCde/enw8xQ RQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ehdayu3fn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 05:13:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2225C0AB175173;
        Wed, 2 Mar 2022 05:13:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3ef9ayxgu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 05:13:43 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2225DVPa178145;
        Wed, 2 Mar 2022 05:13:43 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3ef9ayxgcv-11;
        Wed, 02 Mar 2022 05:13:43 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Randy Dunlap <rdunlap@infradead.org>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        patches@lists.linux.dev, "Juergen E. Fischer" <fischer@norbit.de>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: aha152x: fix aha152x_setup() __setup handler return value
Date:   Wed,  2 Mar 2022 00:13:29 -0500
Message-Id: <164619702113.16127.2101311533831532312.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220223000623.5920-1-rdunlap@infradead.org>
References: <20220223000623.5920-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: IQP_9t_Vw7JqVd0ku5pFsB5fxXmyw_sY
X-Proofpoint-ORIG-GUID: IQP_9t_Vw7JqVd0ku5pFsB5fxXmyw_sY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 22 Feb 2022 16:06:23 -0800, Randy Dunlap wrote:

> __setup() handlers should return 1 if the command line option is handled
> and 0 if not (or maybe never return 0; doing so just pollutes init's
> environment with strings that are not init arguments/parameters).
> 
> Return 1 from aha152x_setup() to indicate that the boot option has been
> handled.
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/1] scsi: aha152x: fix aha152x_setup() __setup handler return value
      https://git.kernel.org/mkp/scsi/c/cc8294ec4738

-- 
Martin K. Petersen	Oracle Linux Engineering
