Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9A7CDB474
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 01:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbjJQBMW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 21:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234336AbjJQBMR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 21:12:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFA4A7
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 18:12:13 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GKO8WV000703;
        Tue, 17 Oct 2023 01:12:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=Uu7W9GhwLqO9Eh/XqqlTXcDQZRlzw1NhV+Sp6KRwGdI=;
 b=knCRnyU1P2/XbrmoWvQB6DRiO649p92XZ0Y2ejGyF53NfCEwzUmfNdDyE+v9U+UT02+4
 qadm7zRVFkNWyvmsT0XwVkTPaT/nSC+E4X93iCgC4FSjbLFzBu2LQBSPxcDMar4nw6W+
 c+HOUx4pQ3Q0R0FkJ6uMXnJZOO7DBBhQDS9/PolPJfv6lHIqugq+aKRTzW2b1DPB8E3x
 ooESctI/bt9hvfwq/M+yiSgNNb7g26NgnBkWdVHjc/hv2NxthY8MSSNWQLD8jXdsKIhV
 0iPO9DwmdlArzCvBPTxFfP+wmTYUxLmbkbA/uBzh+GOh+HbbPCUAr/PTsBbFcDDkpWzH eQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk28m3cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 01:12:06 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39GModP1027187;
        Tue, 17 Oct 2023 01:12:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg5366p1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 01:12:05 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39H1C3sk039761;
        Tue, 17 Oct 2023 01:12:05 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3trg5366mf-3;
        Tue, 17 Oct 2023 01:12:05 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv5 00/18] scsi: EH rework prep patches, part 1
Date:   Mon, 16 Oct 2023 21:11:50 -0400
Message-Id: <169750286919.2183937.16978696852139346555.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231002154328.43718-1-hare@suse.de>
References: <20231002154328.43718-1-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_13,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170008
X-Proofpoint-ORIG-GUID: IoH2bVdab3SKjGN_orMoSUPNKHyaWKId
X-Proofpoint-GUID: IoH2bVdab3SKjGN_orMoSUPNKHyaWKId
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 02 Oct 2023 17:43:10 +0200, Hannes Reinecke wrote:

> (taking up an old thread:)
> here's the first batch of patches for my EH rework.
> It modifies the reset callbacks for SCSI drivers
> such that the final conversion to drop the 'struct scsi_cmnd'
> argument and use the entity in question (host, bus, target, device)
> as the argument to the SCSI EH callbacks becomes possible.
> The first part covers drivers which just requires minor tweaks.
> 
> [...]

Applied to 6.7/scsi-queue, thanks!

[01/18] mptfc: simplify mptfc_block_error_handler()
        https://git.kernel.org/mkp/scsi/c/d9987d4b9671
[02/18] mptfusion: correct definitions for mptscsih_dev_reset()
        https://git.kernel.org/mkp/scsi/c/e6629081fb12
[03/18] mptfc: open-code mptfc_block_error_handler() for bus reset
        https://git.kernel.org/mkp/scsi/c/17865dc2eccc
[04/18] qedf: use fc rport as argument for qedf_initiate_tmf()
        https://git.kernel.org/mkp/scsi/c/ade4fb94578a
[05/18] bnx2fc: Do not rely on a scsi command for lun or target reset
        https://git.kernel.org/mkp/scsi/c/6a137a967bc7
[06/18] aic7xxx: make BUILD_SCSIID() a function
        https://git.kernel.org/mkp/scsi/c/958230bcdda2
[07/18] aic7xxx: do not reference scsi command when resetting device
        https://git.kernel.org/mkp/scsi/c/10f5aa018f94
[08/18] aic79xx: make BUILD_SCSIID() a function
        https://git.kernel.org/mkp/scsi/c/9cc9ef28199d
[09/18] aic79xx: do not reference scsi command when resetting device
        https://git.kernel.org/mkp/scsi/c/c67e63800446
[10/18] ibmvfc: open-code reset loop for target reset
        https://git.kernel.org/mkp/scsi/c/397ff21a962d
[11/18] megaraid: pass in NULL scb for host reset
        https://git.kernel.org/mkp/scsi/c/5bcd3bfbda02
[12/18] ips: Do not try to abort command from host reset
        https://git.kernel.org/mkp/scsi/c/c8102e421e7a
[13/18] sym53c8xx_2: split off bus reset from host reset
        https://git.kernel.org/mkp/scsi/c/4980ae18c37b
[14/18] sym53c8xx_2: rework reset handling
        https://git.kernel.org/mkp/scsi/c/c7c559d2b39a
[15/18] qla1280: separate out host reset function from qla1280_error_action()
        https://git.kernel.org/mkp/scsi/c/bffebc1993a0
[16/18] pmcraid: Select device in pmcraid_eh_bus_reset_handler()
        https://git.kernel.org/mkp/scsi/c/09df4697223a
[17/18] pmcraid: select device in pmcraid_eh_target_reset_handler()
        https://git.kernel.org/mkp/scsi/c/c2a14ab3b9b3
[18/18] mpi3mr: split off bus_reset function from host_reset
        https://git.kernel.org/mkp/scsi/c/82b2fb52d6ec

-- 
Martin K. Petersen	Oracle Linux Engineering
