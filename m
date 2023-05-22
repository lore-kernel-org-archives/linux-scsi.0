Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A07C77B75
	for <linux-scsi@archiver.kernel.org>; Mon, 22 May 2023 22:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbjEVWrK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 May 2023 18:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234937AbjEVWqv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2023 18:46:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76A2188
        for <linux-scsi@vger.kernel.org>; Mon, 22 May 2023 15:46:45 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34MKOKni021213;
        Mon, 22 May 2023 22:46:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=fuGfaLn/UfFRgli0lSWCdBLNrgoAsC2hgv4mcG4NMtY=;
 b=apfoOWZzVXl63Bc3NJ1vPxLRr9RM8YqLzcPbfooILWwoKHkI87f6iUN2Gajbw7qfvPva
 wCg0Kku9Xlz7of5pu0v+AsNGh/rKVEfTic/hoZjJ9bT1jH1HCvlRt8fjzEY0jnQ+ebzY
 igEsJQfkahIyVL1cQpawXOh5nqXkcNaAGQPXluCMvEMhNU8zqiLx1B6SEtFNRJNbCFTJ
 ptPnGNN8OE+UBgnKXWJD8pd9HSzclBcs2AyS8nunhUOFjlbO7mCKey9CiZonG73MUZOP
 PLZ+IFwq5G0hy/OZ96lpHnmX9mtjL2fVTA7728u/YFdwVnpvfEUvp6KJin9z2lU+uCK6 Sw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp5bku4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 May 2023 22:46:33 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34MLosEZ027328;
        Mon, 22 May 2023 22:46:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2ctfd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 May 2023 22:46:32 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34MMkPxe017332;
        Mon, 22 May 2023 22:46:31 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qqk2ctfa8-6;
        Mon, 22 May 2023 22:46:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, chenxiang <chenxiang66@hisilicon.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH 0/3] scsi: hisi_sas: Some misc changes
Date:   Mon, 22 May 2023 18:46:17 -0400
Message-Id: <168479035939.1118074.11163967324929913355.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <1684118481-95908-1-git-send-email-chenxiang66@hisilicon.com>
References: <1684118481-95908-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-22_16,2023-05-22_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305220192
X-Proofpoint-GUID: L2_kcCwQaLAbhXWZKlWWzBi-hBvvmMRX
X-Proofpoint-ORIG-GUID: L2_kcCwQaLAbhXWZKlWWzBi-hBvvmMRX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 15 May 2023 10:41:18 +0800, chenxiang wrote:

> This series contain some fixes including:
> - Configure initial value of some registers according to HBA model
> - Change DMA setup lock timeout from 100ms to 2.5s
> - Fix warnings detected by sparse
> 
> Xingui Yang (2):
>   scsi: hisi_sas: Change DMA setup lock timeout to 2.5s
>   scsi: hisi_sas: Fix warnings detected by sparse
> 
> [...]

Applied to 6.5/scsi-queue, thanks!

[1/3] scsi: hisi_sas: Configure initial value of some registers according to HBA model
      https://git.kernel.org/mkp/scsi/c/b68daae9660b
[2/3] scsi: hisi_sas: Change DMA setup lock timeout to 2.5s
      https://git.kernel.org/mkp/scsi/c/a090fc97617b
[3/3] scsi: hisi_sas: Fix warnings detected by sparse
      https://git.kernel.org/mkp/scsi/c/c0328cc59512

-- 
Martin K. Petersen	Oracle Linux Engineering
