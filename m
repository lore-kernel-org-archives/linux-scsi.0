Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F898C77B75
	for <linux-scsi@archiver.kernel.org>; Mon, 22 May 2023 22:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbjEVWqu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 May 2023 18:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234918AbjEVWqq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2023 18:46:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AC411A;
        Mon, 22 May 2023 15:46:43 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34MKOE78005218;
        Mon, 22 May 2023 22:46:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=2eHm7gbpumZnPmq+e7r9hJvzapIybSujAXlPYtRlv2s=;
 b=1msF/V/oHG9XpJC1qCLrcW37gE0SWjp+8rEgwhocnjQM1bFi1+/tqITUmPfUukpo4dbY
 IiyODVTOZOFdcRugz+3Vq2NCkmObd79VTvIxmv73fRZbcayEm3DrgNvDHGCeNyw0Q3d6
 Zn0cG3PbJSbeAbn/gc/v5RX2KQ+jmvhuM8sFc6aW+GMeoWdpQStd0dg3g7GxPxfi0Q5h
 1uxnbwVWJPnuPfT/iEWQ843UP6S13mLhNhd1NaF29FJ6bRyKMGiIQ6p7jncNTrTdudRS
 N6smaYP71woZ0vBX8BEOSWTmxh8nucDMH+meRjqvPor8hDdtdaJR4lR3suWuAF0hU7Af EQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpprtktn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 May 2023 22:46:36 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34MLIwgQ027109;
        Mon, 22 May 2023 22:46:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2ctfeh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 May 2023 22:46:35 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34MMkPxi017332;
        Mon, 22 May 2023 22:46:34 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qqk2ctfa8-8;
        Mon, 22 May 2023 22:46:34 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] ufs: hwmon: constify pointers to hwmon_channel_info
Date:   Mon, 22 May 2023 18:46:19 -0400
Message-Id: <168479035935.1118074.5662870535112078292.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511175204.281038-1-krzysztof.kozlowski@linaro.org>
References: <20230511175204.281038-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-22_16,2023-05-22_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=887 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305220192
X-Proofpoint-GUID: OTwfJG9Hov6HdMma7upJ9ankO0ugcVAt
X-Proofpoint-ORIG-GUID: OTwfJG9Hov6HdMma7upJ9ankO0ugcVAt
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 11 May 2023 19:52:04 +0200, Krzysztof Kozlowski wrote:

> Statically allocated array of pointers to hwmon_channel_info can be made
> const for safety.
> 
> 

Applied to 6.5/scsi-queue, thanks!

[1/1] ufs: hwmon: constify pointers to hwmon_channel_info
      https://git.kernel.org/mkp/scsi/c/7e79881d92e8

-- 
Martin K. Petersen	Oracle Linux Engineering
