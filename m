Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F57C64EC4
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 02:57:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjCGC5y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 21:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbjCGC5v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 21:57:51 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EA278CA4
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 18:57:50 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326Nx4To023360;
        Tue, 7 Mar 2023 02:57:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=kUmKTAEaDI9tfJvEL8nD3RlzGMzVIKyF4oWzJbAMf58=;
 b=oqyd1HdP8TBfT6LvSZyayTE2PJN2XOUC8RKmilcnTaztC1be6COaiLapKfq7OT5iF05z
 aUnUkWXce/+EY2dTnTxQaWkzb61hoVqFGZyB/z3YVdf96TRKd3KCB+aQwlKQnic7HVUl
 RY7C7Ssds9TF8gZ9iJ+SiFeqMfPVJCBUwJjgJ7kVt1eidOKyTl2CNauIuubBR6C+7m+9
 oeNKuLq57xdA50QUC725Yj0v94s0nApII1ei0U1hEYaM1lrgkHmesdoCY5bpLcg2raNR
 y5XxanlpEypzKIb+qp2ki0MlEGRHc7E9BojMMUbjzTHQTyhzzcL/viCXsCkLQ+O6Am/g Jw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p415hvhfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 02:57:35 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3271P0NQ037278;
        Tue, 7 Mar 2023 02:57:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p4txdvjhv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 02:57:34 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3272vY2A009567;
        Tue, 7 Mar 2023 02:57:34 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3p4txdvjhj-1;
        Tue, 07 Mar 2023 02:57:34 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Adrien Thierry <athierry@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: add soft dependency on governor_simpleondemand
Date:   Mon,  6 Mar 2023 21:57:18 -0500
Message-Id: <167815780198.2075334.6406565343205552078.b4-ty@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230220140740.14379-1-athierry@redhat.com>
References: <20230220140740.14379-1-athierry@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_14,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 mlxlogscore=563 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303070025
X-Proofpoint-GUID: Wc_Mtsvumvp0nEQpE1DwG9BrgEGgSRa2
X-Proofpoint-ORIG-GUID: Wc_Mtsvumvp0nEQpE1DwG9BrgEGgSRa2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 20 Feb 2023 09:07:40 -0500, Adrien Thierry wrote:

> The ufshcd driver uses simpleondemand governor for devfreq. Add it to
> the list of ufshcd softdeps to allow userspace initramfs tools like
> dracut to automatically pull the governor module into the initramfs
> together with ufs drivers.
> 
> 

Applied to 6.3/scsi-fixes, thanks!

[1/1] scsi: ufs: add soft dependency on governor_simpleondemand
      https://git.kernel.org/mkp/scsi/c/2ebe16155dc8

-- 
Martin K. Petersen	Oracle Linux Engineering
