Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9610DC433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Mar 2022 03:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242002AbiCSD6p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Mar 2022 23:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241990AbiCSD6n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2022 23:58:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC05103B98;
        Fri, 18 Mar 2022 20:57:22 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22J1Va7b017423;
        Sat, 19 Mar 2022 03:57:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=ZzqC69aMNoybtc6rTubeedjbC2mkw8ISGSTNmgrTWnI=;
 b=hrxa6sH2Ta7p/wl67EsXVPMiPsMiim+/w5q7oVElh0Z8EY1nlZAoyDYshwtlv5eEP+hh
 55TvEXw1RclpoGUYjgX9mwgRl183aHOC5Tt8cj17QRf3+WOpgMAMlQ6rIgtYobdBicF/
 bh08kRxFMdM+/cmIPKD83HJZP4vKYoYMmTBpUl2qUaFbU3ZWmHl6bpEQiW4929P2vtMD
 fic2/0YPMFobRanDv/mIVF4ePe9e3424WFfLackSblb1a9s7z3Vp4kVSVfvSSI2Q+IOo
 llzDbegObog1TrQ3HFzHEFrG5RGDoJGPdL/JAQe62ag2Ho5f1vb6U7vepstggD2QZRcH JA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5kcg2ku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Mar 2022 03:57:16 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 22J3v8HY007190;
        Sat, 19 Mar 2022 03:57:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ew5kyshp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Mar 2022 03:57:15 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 22J3v5Qo007126;
        Sat, 19 Mar 2022 03:57:15 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ew5kyshmn-7;
        Sat, 19 Mar 2022 03:57:14 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Joe Perches <joe@perches.com>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        James Smart <james.smart@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/6 v2] scsi: lpfc: use kcalloc
Date:   Fri, 18 Mar 2022 23:56:57 -0400
Message-Id: <164766213032.31329.7586542683502803593.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220313141847.109804-1-Julia.Lawall@inria.fr>
References: <20220313141847.109804-1-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 1oryhxHHBOkg7RQi_PlwBT-2J3zOXQuV
X-Proofpoint-ORIG-GUID: 1oryhxHHBOkg7RQi_PlwBT-2J3zOXQuV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 13 Mar 2022 15:18:47 +0100, Julia Lawall wrote:

> Use kcalloc instead of kmalloc + memset.
> 
> 

Applied to 5.18/scsi-queue, thanks!

[4/6] scsi: lpfc: use kcalloc
      https://git.kernel.org/mkp/scsi/c/dc2646417d54

-- 
Martin K. Petersen	Oracle Linux Engineering
