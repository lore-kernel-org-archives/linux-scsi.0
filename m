Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A34DCC6FD1C
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Mar 2023 21:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjCXVHc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 17:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbjCXVHW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 17:07:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9041F91E;
        Fri, 24 Mar 2023 14:07:21 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OL4la0030539;
        Fri, 24 Mar 2023 21:07:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=WR/cbOmGxzwRWCFiTkwyq5oPjtlZSlRg4Px8Runpbwc=;
 b=joVexcXxv2p4XG2E4Sq4LJV7qwAOXxX0zfj9VcN2pZhTCmY9vPLlTeGANjvW5cXGF7pT
 Sv+3QEHpe0QMWf1o7FXvKP2cQTn0DyIe878xsCbF51Q7Su34RG4AGxl9e2O2aNh4pAXP
 KzY52i2e5Iz6oiZaykgMCAa1kUJZ/VPlILXTeaLdf9tUSqn3dUReoSJ2U/FR3uB1ut5j
 STnpnaPeXiDWXye14DATRiTpbf/R8oMFL2BQdxOJVSGuSmrdxGHZCGBqr/Y3OZ0O8JfD
 NDUXESRo57/hAgr+pVE/FOSxcQE7zGdgI3kY3IUPxovuTE1SVO3ic/Zt61GzvLQ9/88Z ZQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3phkf2005r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 21:07:08 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32OK5Yvq027821;
        Fri, 24 Mar 2023 21:07:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pgxk4se3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 21:07:07 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OL76f6017159;
        Fri, 24 Mar 2023 21:07:07 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pgxk4se2p-3;
        Fri, 24 Mar 2023 21:07:07 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     target-devel@vger.kernel.org,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Chris Boot <bootc@bootc.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Juergen Gross <jgross@suse.com>, linux-scsi@vger.kernel.org,
        linux@yadro.com
Subject: Re: [PATCH v3 00/12] add virtual remote fabric
Date:   Fri, 24 Mar 2023 17:06:54 -0400
Message-Id: <167969123970.59527.3417468568519980567.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230313181110.20566-1-d.bogdanov@yadro.com>
References: <20230313181110.20566-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240160
X-Proofpoint-GUID: d7l5SSQ-vxkhfjqHj5QqgtRBEDgqf9pR
X-Proofpoint-ORIG-GUID: d7l5SSQ-vxkhfjqHj5QqgtRBEDgqf9pR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 13 Mar 2023 21:10:58 +0300, Dmitry Bogdanov wrote:

> The patchset is based on 6.4/scsi-staging branch.
> 
> The first 11 patches are just a refactoring to reduce code duplication
> in fabric drivers.
> They make several callouts be optional in fabric ops.
> Make a default implementation of the optional ops and remove such
> implementations in the fabric drivers.
> 
> [...]

Applied to 6.4/scsi-queue, thanks!

[01/12] scsi: target: add default fabric ops callaouts
        https://git.kernel.org/mkp/scsi/c/e5dc6e445c38
[02/12] infiniband: srpt: remove default fabric ops callouts
        https://git.kernel.org/mkp/scsi/c/aafa9bdd4d68
[03/12] scsi: ibmvscsit: remove default fabric ops callouts
        https://git.kernel.org/mkp/scsi/c/8ff1c3623d06
[04/12] scsi: target: loop: remove default fabric ops callouts
        https://git.kernel.org/mkp/scsi/c/2af6800f2135
[05/12] scsi: target: sbp: remove default fabric ops callouts
        https://git.kernel.org/mkp/scsi/c/c9593f4856f3
[06/12] scsi: target: fcoe: remove default fabric ops callouts
        https://git.kernel.org/mkp/scsi/c/515509855d1f
[07/12] usb: gadget: f_tcm: remove default fabric ops callouts
        https://git.kernel.org/mkp/scsi/c/55a42c313ec9
[08/12] vhost-scsi: remove default fabric ops callouts
        https://git.kernel.org/mkp/scsi/c/22ebaf61ecbc
[09/12] xen-scsiback: remove default fabric ops callouts
        https://git.kernel.org/mkp/scsi/c/355c3d61357a
[10/12] scsi: qla2xxx: remove default fabric ops callouts
        https://git.kernel.org/mkp/scsi/c/237f109ceee7
[11/12] scsi: efct: remove default fabric ops callouts
        https://git.kernel.org/mkp/scsi/c/df02beb9afd2
[12/12] target: add virtual remote target
        https://git.kernel.org/mkp/scsi/c/075a5d356103

-- 
Martin K. Petersen	Oracle Linux Engineering
