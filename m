Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A2A9C00528
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 02:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjHHCnr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Aug 2023 22:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjHHCno (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2023 22:43:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB6D10C4
        for <linux-scsi@vger.kernel.org>; Mon,  7 Aug 2023 19:43:43 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3781iOhF030950;
        Tue, 8 Aug 2023 02:43:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=7NITKGssSwWWjQHyvje4Xvw7Owa3YbNpB91GIdB88UE=;
 b=3C7jWYZEZy79t/0ECgY6vra8fzvxkNcsPMJClXN4Wa34cAXM+u/oKE9dgKXWIdJbBxQ2
 Iw/aLVLBbGXSNWawdxJ9GtPm4Qq+SVP+9UoZN/dMOZxBa7vEY449wdTBcdI3iwZGQTki
 kc0k1FGZ/bpYBagqb/3KAjmq4KWlorJEcVtY2SMMVxr0yhXHzREeM3b9F+kXNR6mRhcn
 dUVx+3DwznlDisWvjDJz2thGrhsvhUZPjHYsYbP6WOoC755B2NSrqoIoqBohcrBIpnsC
 fs9HV1iUWBsYrRwgP9lw/D2/LHqVdfAEtNY/9PhDe3vvr+dhSnVdrA+UopZH58tISw3j Og== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9d12c5qv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 02:43:37 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37823WRg027686;
        Tue, 8 Aug 2023 02:43:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cv55wg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 02:43:36 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3782hYGn038171;
        Tue, 8 Aug 2023 02:43:35 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3s9cv55wfu-3;
        Tue, 08 Aug 2023 02:43:35 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com,
        Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        jmeneghi@redhat.com
Subject: Re: [PATCH] qedf: fix firmware halt over suspend and resume
Date:   Mon,  7 Aug 2023 22:43:24 -0400
Message-Id: <169146257051.4040705.3288512658805351231.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230807093725.46829-1-njavali@marvell.com>
References: <20230807093725.46829-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-07_28,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=594 bulkscore=0
 adultscore=0 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308080022
X-Proofpoint-GUID: flMUooCuYdEH6XTFAlyTD7QSf9YD-Xv6
X-Proofpoint-ORIG-GUID: flMUooCuYdEH6XTFAlyTD7QSf9YD-Xv6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 07 Aug 2023 15:07:24 +0530, Nilesh Javali wrote:

> While performing certain power-off sequences, PCI drivers are
> called to suspend and resume their underlying devices through
> PCI PM (power management) interface. However the hardware
> does not support PCI PM suspend/resume operations so system wide
> suspend/resume leads to bad MFW (management firmware) state which
> causes various follow-up errors in driver when communicating with
> the device/firmware.
> 
> [...]

Applied to 6.5/scsi-fixes, thanks!

[1/1] qedf: fix firmware halt over suspend and resume
      https://git.kernel.org/mkp/scsi/c/ef222f551e7c

-- 
Martin K. Petersen	Oracle Linux Engineering
