Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88520C4321E
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 03:45:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiLADpt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 22:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLADpt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 22:45:49 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C10F9075D
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 19:45:48 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B13POsI016265;
        Thu, 1 Dec 2022 03:45:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=dn/bh+1pO/12NyqUsvhoI+gMWRI2cPvnKXRWSrRlbz0=;
 b=hdxf0uq0RUoCqoZ64gdzoFJs0Gz5iyzTHec8Ih6CCD+LXxNx5ansHmrnKyGPXgCTD4MY
 WMM4vAGZoY+GfhIQvUFDtsdUPokAJKx+fcbQkq87vUs7nkc9JE0y745N1GuL2AMt8lTQ
 SieV6n/j8knz7VQvHsPN/nI7o9fhad7idENVbk8UdCw1RzRMaUMkPOkq3vi5Az/AIkhG
 ytErL01jMhiu5Q64l3lxOEZzKAYXw2UJQHwz9QH6xPGWQo41eo5g0OOsxi3bZrTvpsQ6
 SBoTm3UzBJ8de1gYSFt0npRXWCQ2w6xfQVw8Dz8LfhfRIho0HixSLwvAnHFyTI1eBDz8 Xg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m4aemjjnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:45:39 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B1149Gw007732;
        Thu, 1 Dec 2022 03:45:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m398a2ckm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:45:38 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B13jbpO033801;
        Thu, 1 Dec 2022 03:45:38 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3m398a2cjs-2;
        Thu, 01 Dec 2022 03:45:38 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        linux-scsi@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH v2] scsi: ufs: Fix the polling implementation
Date:   Thu,  1 Dec 2022 03:45:03 +0000
Message-Id: <166986602295.2101055.5654422129059010458.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221118233717.441298-1-bvanassche@acm.org>
References: <20221118233717.441298-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_02,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=594 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010022
X-Proofpoint-ORIG-GUID: VvyJOxxMJAQcb9qm1qYXFUopQj3Z4_uD
X-Proofpoint-GUID: VvyJOxxMJAQcb9qm1qYXFUopQj3Z4_uD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 18 Nov 2022 15:37:03 -0800, Bart Van Assche wrote:

> Fix the following issues in ufshcd_poll():
> - If polling succeeds, return a positive value.
> - Do not complete polling requests from interrupt context because the
>   block layer expects these requests to be completed from thread
>   context. From block/bio.c:
> 
>     If REQ_ALLOC_CACHE is set, the final put of the bio MUST be done
>     from process context, not hard/soft IRQ.
> 
> [...]

Applied to 6.2/scsi-queue, thanks!

[1/1] scsi: ufs: Fix the polling implementation
      https://git.kernel.org/mkp/scsi/c/ee8c88cab4af

-- 
Martin K. Petersen	Oracle Linux Engineering
