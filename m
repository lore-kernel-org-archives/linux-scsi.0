Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC645CCA486
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 04:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbiGNEXS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 00:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234002AbiGNEWu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 00:22:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AD827B16;
        Wed, 13 Jul 2022 21:22:42 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E3n7QZ031495;
        Thu, 14 Jul 2022 04:22:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=AQIP3Kr3jggM3hJXgw7F4JdHsg/ef7IPlRVTX39AJ8M=;
 b=BcqAlDap+KKEV3geu/pc2Cd9bEkZY4Vc6uvK7KPBHKpUH0uJpeBhMnDlkoTHvoNKATLT
 zoNVQDP+aHBbqbk9yZP5AQxqnXLeG1vEhmXi5FrCLtn02tUxeYfkOgcLNkv+L84SrCfk
 dQkg7jn5Wpp3xQRP3doL22adJ14+lw5sogPEJ+N8HpsKcaF0aqzde/OfkWlFLAKs95Ik
 Bmpog3Cu/Uk3UrAT/J7pSFzny6dnOF31LEFHwD6lzi8SE15pfrBwJ32Ituizr6gEiSOS
 LvDPnO6V7OVuCyHdsBcYysgr9Ge5h3wKIKyTpaC9TcsxNWOZ21Hsm/zyYdNSkNYwAl92 AA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h727smbr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:22:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26E4Aiu1040064;
        Thu, 14 Jul 2022 04:22:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h70451jpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:22:37 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 26E4MWBt023864;
        Thu, 14 Jul 2022 04:22:36 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h70451jnc-8;
        Thu, 14 Jul 2022 04:22:36 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     target-devel@vger.kernel.org, hch@infradead.org,
        Mike Christie <michael.christie@oracle.com>,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/5] target: UNMAP/WRITE_SAME features/cleanups for 5.20
Date:   Thu, 14 Jul 2022 00:22:28 -0400
Message-Id: <165777182482.7272.8376985161704758204.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628200230.15052-1-michael.christie@oracle.com>
References: <20220628200230.15052-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 3qm1oBp7vfeX-zhZhse925kJ9x4yQwPI
X-Proofpoint-GUID: 3qm1oBp7vfeX-zhZhse925kJ9x4yQwPI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 28 Jun 2022 15:02:25 -0500, Mike Christie wrote:

> The following patches were made over Linus's tree and:
> 
> [PATCH 1/1] scsi: target: Fix WRITE_SAME No Data Buffer crash
> 
> They perform cleanup to target_core_file's WRITE_SAME handling and allow
> users to configure UNMAP/WRITE_SAME after we have done the initial device
> addition/configuration.
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[1/5] scsi: target: Remove incorrect zero blocks WRITE_SAME check
      https://git.kernel.org/mkp/scsi/c/036d8903f03b
[2/5] scsi: target: Add callout to configure unmap settings
      https://git.kernel.org/mkp/scsi/c/6b206a5a8c29
[3/5] scsi: target: Add iblock configure_unmap callout
      https://git.kernel.org/mkp/scsi/c/d7c382c51d03
[4/5] scsi: target: Add file configure_unmap callout
      https://git.kernel.org/mkp/scsi/c/33efaaf6e24b
[5/5] scsi: target: Detect unmap support post configuration
      https://git.kernel.org/mkp/scsi/c/34bd1dcacf0d

-- 
Martin K. Petersen	Oracle Linux Engineering
