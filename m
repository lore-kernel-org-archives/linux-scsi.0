Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4949C76196
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Apr 2023 02:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjDCCPY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Apr 2023 22:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjDCCPX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Apr 2023 22:15:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4630E9758
        for <linux-scsi@vger.kernel.org>; Sun,  2 Apr 2023 19:15:22 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 332MALaD015180;
        Mon, 3 Apr 2023 02:15:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=t/Y2mkn21wVdZnB3jmpy7QDjTqoEMm+aotbJXDNHpcI=;
 b=hiXK6j3MfBZWC9jQ5tg+KMa5qMpqrc1vmSRBQVn757fB5v01/kYDnuTJP3zvLhhYsa9V
 R+dLLj8+KzusXV4/BT2kLSAZv+57FRJ36s1a+C6x2XrpGueImBCCSQwuRKVvP5HmmETP
 8co6sxAo00uYdOyGZ2j1IrD39L4HNfCdVl+fSxxr/QjEM3fi6mfoESUfPvqIR0I/2CVg
 3BB+sfXHJj08ByAdYxUZuW5mNOFDek7rHYQAIIZD9udu/79B6uNqBoNSVjjmzixvCV1I
 p6yE3awAGnTVDf0Skhl2G8QB7N/UNwVGeqqJ9cMx23UAM20oB5/LDmsQ/CsjOhUXeFA5 2A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppcgaj012-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Apr 2023 02:15:18 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 332M3KFw014689;
        Mon, 3 Apr 2023 02:15:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ppt3ddbnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Apr 2023 02:15:17 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3332FHwf010318;
        Mon, 3 Apr 2023 02:15:17 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3ppt3ddbn7-1;
        Mon, 03 Apr 2023 02:15:17 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 00/80] Constify most SCSI host templates
Date:   Sun,  2 Apr 2023 22:15:02 -0400
Message-Id: <168031383547.650124.276618527747025484.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_07,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=691 mlxscore=0 adultscore=0
 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304030015
X-Proofpoint-GUID: 3zKv-PEropkJASphLzn2YCja4HrGm24I
X-Proofpoint-ORIG-GUID: 3zKv-PEropkJASphLzn2YCja4HrGm24I
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 22 Mar 2023 12:53:55 -0700, Bart Van Assche wrote:

> It helps humans and the compiler if it is made explicit that SCSI host
> templates are not modified. Hence this patch series that constifies most
> SCSI host templates. Please consider this patch series for the next merge
> window.
> 
> Thanks,
> 
> [...]

Applied to 6.4/scsi-queue, thanks!

[01/80] scsi: qla2xxx: Refer directly to the qla2xxx_driver_template
        https://git.kernel.org/mkp/scsi/c/a07be936d923
[02/80] scsi: core: Declare most SCSI host template pointers const
        https://git.kernel.org/mkp/scsi/c/31435de97466
[03/80] scsi: core: Declare SCSI host template pointer members const
        https://git.kernel.org/mkp/scsi/c/e0d3f2c694e5
[04/80] ata: Declare SCSI host templates const
        https://git.kernel.org/mkp/scsi/c/25df73d93323
[05/80] firewire: sbp2: Declare the SCSI host template const
        https://git.kernel.org/mkp/scsi/c/0ca31ecacfe5
[06/80] RDMA/srp: Declare the SCSI host template const
        https://git.kernel.org/mkp/scsi/c/4281af9d9f13
[07/80] scsi: message: fusion: Declare SCSI host template members const
        https://git.kernel.org/mkp/scsi/c/95a24cf170ed
[08/80] scsi: zfcp: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/2887b7a8e07f
[09/80] scsi: 3w-9xxx: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/682895797e56
[10/80] scsi: 3w-sas: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/e5be9953cb02
[11/80] scsi: 3w-xxxx: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/ca1b0e01f6b5
[12/80] scsi: BusLogic: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/83e479e12bfc
[13/80] scsi: a100u2w: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/157fc774cc78
[14/80] scsi: a2091: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/4412df387040
[15/80] scsi: a3000: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/88530b3ea902
[16/80] scsi: aacraid: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/0cd7324b9e9d
[17/80] scsi: advansys: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/8afc6e14a69b
[18/80] scsi: aha152x: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/11e58ceacfab
[19/80] scsi: aha1542: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/77168bd721bc
[20/80] scsi: aic94xx: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/dbb26f2b4200
[21/80] scsi: arcmsr: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/34f5d2dc0038
[22/80] scsi: acornscsi: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/5d94e575a1f1
[23/80] scsi: arxescsi: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/116e5de74270
[24/80] scsi: aha1740: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/4df23b30fa23
[25/80] scsi: cumana: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/202423c58724
[26/80] scsi: eesox: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/13c2e9647198
[27/80] scsi: oak: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/644d8d77eee5
[28/80] scsi: powertec: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/9db801178eb8
[29/80] scsi: atp870u: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/f44e1c639ef0
[30/80] scsi: dc395x: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/16c0a2db0c4a
[31/80] scsi: dmx3191d: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/b816c6bf69a7
[32/80] scsi: elx: efct: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/67791ce19f00
[33/80] scsi: esas2r: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/1f4e77dbcbad
[34/80] scsi: esp_scsi: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/3b465a149146
[35/80] scsi: fcoe: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/d15515f91801
[36/80] scsi: fnic: Declare host template const
        https://git.kernel.org/mkp/scsi/c/bf3614bd7e8a
[37/80] scsi: qedf: Declare host template const
        https://git.kernel.org/mkp/scsi/c/be8532d15342
[38/80] scsi: fdomain: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/8e6a87aa9162
[39/80] scsi: NCR5380: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/bd5e469a7f69
[40/80] scsi: gvp11: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/ccc54750f9b7
[41/80] scsi: hisi_sas: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/e8c0ced993dd
[42/80] scsi: hpsa: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/207761bf1a8d
[43/80] scsi: hptiop: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/9194970becd8
[44/80] scsi: ibmvfc: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/7bced3fc285a
[45/80] scsi: imm: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/09dce26c4a89
[46/80] scsi: initio: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/4ba116af0fd3
[47/80] scsi: ipr: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/4ea4394e7120
[48/80] scsi: isci: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/eb60d17a0e4a
[49/80] scsi: iscsi: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/80602aca4fcc
[50/80] scsi: mac53c94: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/5e328664ed0b
[51/80] scsi: megaraid: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/264e222b004c
[52/80] scsi: mesh: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/0fabb7fbad55
[53/80] scsi: mpi3mr: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/b85f82f3c92a
[54/80] scsi: mpt3sas: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/1785ced8bd4b
[55/80] scsi: mvme147: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/c9ac4e73b373
[56/80] scsi: mvsas: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/f01feece6b64
[57/80] scsi: mvumi: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/8a098ba4d996
[58/80] scsi: myrb: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/8e64d59d1f1c
[59/80] scsi: myrs: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/914fa37a8a54
[60/80] scsi: nsp32: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/36242912e24f
[61/80] scsi: pcmcia-sym53c500: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/54aefe23a6c4
[62/80] scsi: pcmcia-pm8001: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/8fe69e4abdb5
[63/80] scsi: pmcraid: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/4e9e0a51aa31
[64/80] scsi: ppa: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/d23901a8d700
[65/80] scsi: ps3rom: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/4fe61364e7d1
[66/80] scsi: qla1280: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/796e8f808298
[67/80] scsi: qla2xxx: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/421c20b7668e
[68/80] scsi: qlogicpti: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/7c7a1419179a
[69/80] scsi: sgiwd93: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/4517353a048e
[70/80] scsi: smartpqi: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/077126d6b941
[71/80] scsi: snic: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/8fb5b37e070e
[72/80] scsi: stex: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/08d6075192d1
[73/80] scsi: sym53c8xx: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/d2c16f8f1ed2
[74/80] scsi: virtio-scsi: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/273ab251950f
[75/80] scsi: wd719x: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/a5b78e81c712
[76/80] scsi: xen-scsifront: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/65e5447a1014
[77/80] scsi: rts5208: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/f8adf8e99a23
[78/80] scsi: target: tcm-loop: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/8e2ab8cda5aa
[79/80] scsi: ufs: Declare SCSI host template const
        https://git.kernel.org/mkp/scsi/c/f2e2fe3dec7f
[80/80] usb: uas: Declare two host templates and host template pointers const
        https://git.kernel.org/mkp/scsi/c/04d1fa4346cc

-- 
Martin K. Petersen	Oracle Linux Engineering
