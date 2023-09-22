Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3197E7D0BB
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 01:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjIVBHo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjIVBHn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 21:07:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07076102
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 18:07:37 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LIsM1C011449;
        Fri, 22 Sep 2023 01:06:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=v27RLRrekXay6SMXlHSSV2R94TenIbgSyf5SqOrLq+E=;
 b=MIVQENlpLhxo/Af++rvbRozuslxV/n2iLXqbDoY50qJ7PPAo54woc5g5S0+nBuoSwpOE
 nU1zKIcVDseSmg3GI8wkEdTHEwW8VPLrZfA9JzqCg2knVup9YVGwBfrWSKIgvrx+X0lv
 1SUgd0UTFffq+mptacjMp3/KAGSlifo7Lx2Xf+At3T/MYrDJdZTIFiujLFWZ5/085T8N
 +mdH4Z88f5dHr4KT9352X8ZHfxwUsu1/udYsatU/y0RIf5nyOxqlS0oOJ57olD9HEE+Y
 nvqtH6xE2tDbVI3jKac0pftRFOOXrwxJ3XPRPsa6B34cHqOW/JvaSZND0XWqrbaWkw6/ Eg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tsvrkae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 01:06:07 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38LMddPa040653;
        Fri, 22 Sep 2023 01:06:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t8u19bn2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 01:06:06 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38M164sr032168;
        Fri, 22 Sep 2023 01:06:06 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3t8u19bn0m-2;
        Fri, 22 Sep 2023 01:06:05 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>
Subject: Re: [PATCH v2] scsi: ufs: Include the SCSI ID in UFS command tracing output
Date:   Thu, 21 Sep 2023 21:05:52 -0400
Message-Id: <169534443600.456601.10675222996423200767.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230907183739.905938-1-bvanassche@acm.org>
References: <20230907183739.905938-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_01,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxlogscore=700 phishscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309220008
X-Proofpoint-GUID: pDKJTsFnzhViw7L1VeikPpRrioKH9bPa
X-Proofpoint-ORIG-GUID: pDKJTsFnzhViw7L1VeikPpRrioKH9bPa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 07 Sep 2023 11:37:16 -0700, Bart Van Assche wrote:

> The logical unit information is missing from the UFS command tracing
> output. Although the device name is logged, e.g. 13200000.ufs, this
> name does not include logical unit information. Hence this patch that
> replaces the device name with the SCSI ID in the tracing output. An
> example of tracing output with this patch applied:
> 
>     kworker/8:0H-80      [008] .....    89.106063: ufshcd_command: send_req: 0:0:0:4: tag: 10, DB: 0x7ffffbff, size: 524288, IS: 0, LBA: 1085538, opcode: 0x8a (WRITE_16), group_id: 0x0
>               dd-4225    [000] d.h..    89.106219: ufshcd_command: complete_rsp: 0:0:0:4: tag: 11, DB: 0x7ffff7ff, size: 524288, IS: 0, LBA: 1081728, opcode: 0x8a (WRITE_16), group_id: 0x0
> 
> [...]

Applied to 6.7/scsi-queue, thanks!

[1/1] scsi: ufs: Include the SCSI ID in UFS command tracing output
      https://git.kernel.org/mkp/scsi/c/ccc3e1363069

-- 
Martin K. Petersen	Oracle Linux Engineering
