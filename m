Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F31C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 03:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbiB1Doa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Feb 2022 22:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbiB1Do1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2022 22:44:27 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07463C48B;
        Sun, 27 Feb 2022 19:43:45 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21RMWjOV008194;
        Mon, 28 Feb 2022 03:43:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=FkL5/zsuRBEvC3ZeADE9UQn/O+zBdg3TWhs3Q9D3QqE=;
 b=xl0HAL7h/NXdMosLgJB6BMfNUi5Qqazz3Ij0NVtZevnDIJ5fX97y1aqJ0bq+5pn4d7jA
 xgA8s4M8mEIIX3h5fJ9+OSQnHmV7nrCT1tg4GjZ4gDvpdSgDPC9AjhKiUPbOFel4JVy6
 f7as7deKbpLNs4XmXue+NTAnN73VRYbnA1qRm7YHPRfjj2ocMnAaFiLZ8V/9zJPuPSpQ
 2sB7BLxpEinkJtXjHSLxS9g7yVeKGQxKHQ+1dgvAQ084bU7YTM9LVs+NNNM0yKDjGIFa
 MhiMnw7JajgK5SCsX9fqk/uc+2joHLBOsWjPtGPgh9VQgXghSpW0CqvRex7OkErcH2GL KQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efb02k1qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 03:43:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21S3b93G157706;
        Mon, 28 Feb 2022 03:43:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3efa8bxnw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 03:43:33 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21S3hPw0165853;
        Mon, 28 Feb 2022 03:43:33 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3efa8bxnt3-8;
        Mon, 28 Feb 2022 03:43:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, adrian.hunter@intel.com,
        avri.altman@wdc.com, beanhuo@micron.com,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        linux-kernel@vger.kernel.org, jejb@linux.ibm.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: Remove wlun_dev_to_hba()
Date:   Sun, 27 Feb 2022 22:43:22 -0500
Message-Id: <164601967776.4503.4940676586153373665.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1891546521.01644927481711.JavaMail.epsvc@epcpadp4>
References: <CGME20220215114002epcms2p1eb4e53507c96e0f24770af16aedcf5c6@epcms2p1> <1891546521.01644927481711.JavaMail.epsvc@epcpadp4>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: jJS6ZSkMoWIJqKfxnb0BVxCDz9QPKw-x
X-Proofpoint-ORIG-GUID: jJS6ZSkMoWIJqKfxnb0BVxCDz9QPKw-x
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 15 Feb 2022 20:40:02 +0900, Keoseong Park wrote:

> Commit edc0596cc04b ("scsi: ufs: core: Stop clearing UNIT ATTENTIONS")
> removed all callers of wlun_dev_to_hba(). Hence also remove the macro itself.
> 
> 

Applied to 5.18/scsi-queue, thanks!

[1/1] scsi: ufs: Remove wlun_dev_to_hba()
      https://git.kernel.org/mkp/scsi/c/482dcaa1c91a

-- 
Martin K. Petersen	Oracle Linux Engineering
