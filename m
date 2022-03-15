Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C675C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Mar 2022 05:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236782AbiCOFTF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 01:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233863AbiCOFTE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 01:19:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8686A643B
        for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2022 22:17:52 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22F39A6i008015;
        Tue, 15 Mar 2022 05:02:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=1RgW0cjUuB6ERpvLNdXE7h2Y29V6CuESfRF7toQfAfc=;
 b=PVgM6ogsWFRyGUh85K5pBvjfa1MgffASrlgc2MeRuguEmhaDgIu5rSEoQz6da+C2DpIX
 jNxPVkQExp4uGjMEyzl3MnwiNUWwwX8+UQoDB7GT3ZZASqj3/R19ec0rh9yxoHSQckQZ
 FT1nQ1S5EZ4OXjGHd6T3jahg3DXp4tUqiueMvPWid09N/1bETHTiUa1ZoyiqO9cDN7HM
 STchkuQtwxSg/5qyD3yFsdLLYNUyAE8Qgevq4ItoQyNiGWqQvy0LusqvrgLdULP37bAg
 T4pBXZ/CYP+RMR7+WJmElSk70S/huwTwyUNBuj+6Fwjbac1u2imOQNTfDOZ8UHbPvhON hQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et5s6j20m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 05:02:45 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 22F51KHe004976;
        Tue, 15 Mar 2022 05:02:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3erhy25wwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 05:02:44 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 22F52cqD007094;
        Tue, 15 Mar 2022 05:02:44 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3erhy25wts-6;
        Tue, 15 Mar 2022 05:02:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas: Remove scsi_dma_map errors messages
Date:   Tue, 15 Mar 2022 01:02:36 -0400
Message-Id: <164732052813.23186.5277228738704812053.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220303140203.12642-1-sreekanth.reddy@broadcom.com>
References: <20220303140203.12642-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: Gga0oyTIZfrAT7oSVIKmh7ImWi2y10VK
X-Proofpoint-ORIG-GUID: Gga0oyTIZfrAT7oSVIKmh7ImWi2y10VK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 3 Mar 2022 19:32:03 +0530, Sreekanth Reddy wrote:

> When scsi_dma_map() fails by returning a sges_left value less than
> zero, the amount of logging can be extremely high.  In a recent
> end-user environment, 1200 messages per second were being sent to
> the log buffer.  This eventually overwhelmed the system and it
> stalled. Also these error messages are not needed and hence
> removing them.
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/1] mpt3sas: Remove scsi_dma_map errors messages
      https://git.kernel.org/mkp/scsi/c/0c25422d34b4

-- 
Martin K. Petersen	Oracle Linux Engineering
