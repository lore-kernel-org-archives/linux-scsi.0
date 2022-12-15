Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F9AC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Dec 2022 17:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiLORAz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Dec 2022 12:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiLORAv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Dec 2022 12:00:51 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35AE26D1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Dec 2022 09:00:50 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFEn5UG026614;
        Thu, 15 Dec 2022 17:00:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=rAv+yfoNhJa2miomPNAcXYPerh0ix4w8yUf/scFiNkM=;
 b=wcnQRPCglGr4l8prTa67NlJ1RPHwsb2g7USJh9bYLk1rCRCci2XInLlsJe7RTVM+P8Wg
 2R4mF0S/kXrEp9+kjy34WixPdNrkPWwJtYC6N1kmHa73xidTjikOG5n3kE20BPVpoK3y
 FIZbdvVidLrQxvK2lBrowFBl3pA1hK3q3SVnmrzT/Ykji7UTEC9OgXnZ0pRc0R9YnoSI
 6+4HxovTE0ZLP3B9dScq1Ukj0lZxxnxqtmFzHHSNV+lYrnWbuEiwPhRY0C1hMWLi65oH
 AuTQh0rn9B261nwJpTbS3wGZWwxf6boXYhfiM7zaXHpowK/7kx2FiW3mQ1X6mf6NGxIs yA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyex5nge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 17:00:48 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFG6HYn033014;
        Thu, 15 Dec 2022 17:00:47 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyer0h70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 17:00:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+Umuc8lhodgzDdxFjynlGIqiqAjd9fHz2m+iio/gQCNngZhoEVZ44DOBOcjJ3K455B9qd8EC+aSbHaJM3ANSeNyjXaczgjdYURhqUmN0d4PZgTfqL9jASe4O1fH40m9SR0RXdlf1xKRovbfVhgpmZacnDaPaqrOznQF4QrgdRynnsrWNG3R9WfNJt/uIUFIRrsH/EIlEy48onmYSHWCN82YxHkIEQJIYB8DnsjIBugp9Bv9GFG/2FYn/5B2C6i3cf6Uty5g7G1f2zcjKhPAqVwCAdCJr8AnxZ3ELcGDSwyJJIhCLxo/QK8auqlhpKpBp3IfOVm5loSTAAkUyg3MAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rAv+yfoNhJa2miomPNAcXYPerh0ix4w8yUf/scFiNkM=;
 b=W9BALtP5WdHCMRv+g/9+eMuBgDdT6/Ruhm8ww/NRtmJlcUqfOCohFJRzNEcyDjlZcHpNfzzh/96K/HVeU3Cb2u4LxQWnpAjyooi/i9k/ms2PpeVW0hi5QVbgZvKjt9UeY0vuiTOG+rKTEdAraVIcp6QvHw9cZggaFOAI/ZaACV1nHWKjx2Q5+9XeiRZdQS6JZFbTrxdFq2apBfpWkkJGUZTL2ewU9OvLGZsn1s3JbTIPjR3fLI70kiVbFGlIiI9DtYI/kRmfRrB7U6UIQ+wV35+sL9dewMSnfr3otjPq2o80/M7g5AjGYkXCNg3RqF3JL0gEQsBDrvdH89a+CK35/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rAv+yfoNhJa2miomPNAcXYPerh0ix4w8yUf/scFiNkM=;
 b=t00gzc8n33dL5DJmGSkWiuT5b/ZTJLSNggX+qiHHqnmCtTLkKSbNu20BHcBAl6aW3jRos3ugKYvUdOoAN3lko9G3f/pR0DBvXjY826lZrmtzgtt1ZsGUzLcsn+Lzd5OesN7I2uIllkK+XBK8aE0sRfmguBNAR1oKRaN8BwpQwLI=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DS7PR10MB5168.namprd10.prod.outlook.com (2603:10b6:5:3a0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 17:00:46 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762%2]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 17:00:45 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>
Subject: Re: [PATCH 03/10] qla2xxx: Fix DMA-API call trace on NVME LS requests
Thread-Topic: [PATCH 03/10] qla2xxx: Fix DMA-API call trace on NVME LS
 requests
Thread-Index: AQHZD3edsrz3Am/VuUegIZoc+tCyZq5vLpoA
Date:   Thu, 15 Dec 2022 17:00:45 +0000
Message-ID: <F808E34F-0788-405D-A391-091C26523C04@oracle.com>
References: <20221214045014.19362-1-njavali@marvell.com>
 <20221214045014.19362-4-njavali@marvell.com>
In-Reply-To: <20221214045014.19362-4-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|DS7PR10MB5168:EE_
x-ms-office365-filtering-correlation-id: b020e0d0-5435-4683-3174-08dadebde895
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GhzYLksERMO1NsXKGvd5dXhQI9KXBCyBhBs/7dp/a7kmZ33VxpAJEQXZtRkyVEEvnxlFBn1IECvzmTQFB9wtv4GdXEq1yZ9FY7jhXd2v+GJSK5/KH7EIvYF33qsHlePkVbtk+AkP4Qtq8fYzAS6NKZDy126inWr9sCDp0S5XTSy+tqcnTaBmYurDPDcWFgVva41lRH9huPn/69BnMnJ2jKGUt+l2uCIF6hdiWGwB3tGt6JLkqOckWg+HNgeR4e/h3GAx3M7bry7mZLMjgEwbfzPc15UGfIKIExO8Djlsk//YsEZXlKBQ20jnvG62PfEF+LG417TxOD6W4YzXriKS1FhgI24f4ixvfQfWXiB/QGpAPx56YOyJm1tW/ykNtLeHF3N5yTASpMG8vv5N+vpO/EiebVCyKFFQIujiNatkO4FKd7TSL7QttnZUjrjEJR48k2w+juEzK9XX3cPSfCAdd00k0MY9EiV5aBGu7CoTk8x0NbU4XbtwjZIRDQAylDziz5/Y+Jka5NGk0ZJFQ9SZXLK6e1gwnYlEfo5zJtPPi9NhKan6GPqDFUxodMsCAh+J7Pq/BQ1r1Ye4BDBN29nRQEu2gWevjp/G7IUVvwCwuFeoYB0LLWJxfsKZ/55dhLjQrtLYxHzWFaHASL99BXslKPVz30ogi7sStixBAwpvtQXmaQL8lWAFC5JPX14iET40EFBxTXi6YCu8i0iKX/IALOyGaOSVJpzTRpy0mz0zbKU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199015)(6486002)(54906003)(33656002)(6916009)(71200400001)(41300700001)(8676002)(4326008)(38070700005)(316002)(66446008)(36756003)(64756008)(76116006)(66556008)(66476007)(66946007)(91956017)(86362001)(2616005)(83380400001)(38100700002)(478600001)(6512007)(53546011)(186003)(6506007)(122000001)(44832011)(5660300002)(2906002)(8936002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PokixUEHz2rudx384vyzwSKDByNZgcyahTFgXdYTmvSdm1zy2vkvE8dw0PbI?=
 =?us-ascii?Q?OA1p1qjo9LMgIxSGF2m/22RAYOJPep+DJpF6trNI38hMU1rcJBpPkRKotXH0?=
 =?us-ascii?Q?hnmvcqJmnmt6pUPsqs7XyNmpe/zclSYO6HGu6juICcxR1N/TrKAIDCAi/s1S?=
 =?us-ascii?Q?rDmlL5Si6IpELUWddW2ekuMpjeFkCFZZ496wNSKDtUkWPbuIJZE8iLlhk4I5?=
 =?us-ascii?Q?QE/PL1ZXLJC0m6shYPVHBnuUNs8bsXNlU28V1SxzyxP8eiq2ibk7zJJCgTfz?=
 =?us-ascii?Q?tjfGrRzs2ufIj8PE9V0FnKnAfluPp66scpLOtkxKCVrvbn4VfQw0cGUvoovz?=
 =?us-ascii?Q?H/AcmSwU8H5/oVJfr2rjkt9ejLDPyNlb8gJfdOazUw/eGyoElD9DrnngQPPe?=
 =?us-ascii?Q?tzXM+l19mqKH6rrMi56oIDuApjMXuOb2XkYKnbiAmR4SzyVC3Xm4jn638uV2?=
 =?us-ascii?Q?zr1XR299rS+OST587ynJf0CuZKb/PHbY4WhQN56bBCVI96Fh3pqysmL2L0gv?=
 =?us-ascii?Q?R2Ggmfv1zYM0yFk8XDy9dnTNivot6GcMmbqYSIaUPAzAp0mro5QFWIXJDo8w?=
 =?us-ascii?Q?U/QT2B1xpteAMVbmDf471p9xM1SA2rFyCeFEnK8i0zJGGjkMOSHuc8vAk+ty?=
 =?us-ascii?Q?N+i6wssBJUzxKrylb9x6EwhoL+3D469pPyxf1wi6z1PS60ZJINhvhiNKJlkV?=
 =?us-ascii?Q?YUrcBw9P7sXgxsCRrPJFiuw1fJhhj/3y/TjjFnnkQf3dnfR0H9lYrypN5PP4?=
 =?us-ascii?Q?GY/0IK4yxAZi+/rS+/Zp8rA6E31BvI9KGL1sTfxdNjH59Q+OeZTilKNxVujW?=
 =?us-ascii?Q?5MySDW/ZVBK1asnmMjAf3mC0veqJJp/QVaF8vqLVI+E2ADHsKncnPJXY9v7f?=
 =?us-ascii?Q?BAStlt8Usqn2Zf37JJpKdfexH1iMsxR+JzaYAkV+3YDh18Kr3FtflgAuoqEj?=
 =?us-ascii?Q?gJtGiqV5HzvJWHtyN0X+mN1WiqVQoBqd+jG4wYU4jr/ohE5vvx/EoT8xcOnj?=
 =?us-ascii?Q?YUaZpl7BaIjjHwxzYKyLvw3OvthDw8/vLcQ7/owL5ClgquYt14aEcFEAAzZb?=
 =?us-ascii?Q?K/nqh+8g/G+s9Lt5Qj/4n7oeJBTbx9AYg7zgDv7KtQdTWdjRYgMfMZI+F34W?=
 =?us-ascii?Q?RT0DO4Lra8tEB7CdD8DeFJMWDattx97JV4yLZ3q/Reg6LvdAE9HPJs2cCmP5?=
 =?us-ascii?Q?bh89EWKc2aAIBbta1nkmQc06Kvy8gRa4dVkClEyKxtU9UTi5gJLnSFW9osTW?=
 =?us-ascii?Q?jS0bab7KOG3zUrnBPh+nnQ0W9dVo1CHAF7sV3bHMTn76hVZOylTbprpEVoN6?=
 =?us-ascii?Q?t6ydqhK6cOmNQS2lp4ACp3YqWaGu0cwezqjDlu5NE/r3ru9eIMH1RTzEW2kk?=
 =?us-ascii?Q?1Jf1WQZU0zOvNHGPm5Ce7l32tVRJcxqcW9oBi12I0hwXtlT9q7D+6Nj3Sm6Q?=
 =?us-ascii?Q?TBNAoHeDA7FFOSFFubudtXDGVTSVRNwVRD3pg5jGMr/3oJYrrh1yXQ74viZh?=
 =?us-ascii?Q?Zt6GRaE2gIlaDwocLfelIJSnGDiPvrEIpFuTooGQQqpYL9XDmNNKOWfWoONE?=
 =?us-ascii?Q?f+2dMITCR8yFCOAFxayAPj85DNE7njVvWa0fnqcfb2EBfXLOewPlCcfcMF6D?=
 =?us-ascii?Q?8hIJxjqB9KDrHy5hPifwqcWd+a+LkZelAQKhPlrFroDM?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <030FC2752B583841A68334915053D6F4@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b020e0d0-5435-4683-3174-08dadebde895
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 17:00:45.8310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c/VBDRNqDtYRZ69nYdg1waiygCYXUTZGvjB8eT0H+jLd0vEeNRUfyJMrEm1+CCOxmSgoecijoYrPLRbfovV6WWJXjfVOvnaL5eedtPQhnzU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5168
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_10,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150141
X-Proofpoint-GUID: lT_ZnHyCZcM8SPSQ9J7VR1XpntHAoeD0
X-Proofpoint-ORIG-GUID: lT_ZnHyCZcM8SPSQ9J7VR1XpntHAoeD0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 13, 2022, at 8:50 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> Following message and call trace was seen with debug kernels:
>=20
> DMA-API: qla2xxx 0000:41:00.0: device driver failed to check map
> error [device address=3D0x00000002a3ff38d8] [size=3D1024 bytes] [mapped a=
s
> single]
> WARNING: CPU: 0 PID: 2930 at kernel/dma/debug.c:1017
> 	 check_unmap+0xf42/0x1990
>=20
> Call Trace:
> 	debug_dma_unmap_page+0xc9/0x100
> 	qla_nvme_ls_unmap+0x141/0x210 [qla2xxx]
>=20
> Remove DMA mapping from the driver altogether, as
> it is already done by FC layer. This would prevent
> the warning itself to appear.
>=20
> Fixes: c85ab7d9e27a ("scsi: qla2xxx: Fix missed DMA unmap for NVMe ls req=
uests")
> Cc: stable@vger.kernel.org
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_nvme.c | 19 +------------------
> 1 file changed, 1 insertion(+), 18 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 02fdeb0d31ec..8927ddc5e69c 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -170,18 +170,6 @@ static void qla_nvme_release_fcp_cmd_kref(struct kre=
f *kref)
> 	qla2xxx_rel_qpair_sp(sp->qpair, sp);
> }
>=20
> -static void qla_nvme_ls_unmap(struct srb *sp, struct nvmefc_ls_req *fd)
> -{
> -	if (sp->flags & SRB_DMA_VALID) {
> -		struct srb_iocb *nvme =3D &sp->u.iocb_cmd;
> -		struct qla_hw_data *ha =3D sp->fcport->vha->hw;
> -
> -		dma_unmap_single(&ha->pdev->dev, nvme->u.nvme.cmd_dma,
> -				 fd->rqstlen, DMA_TO_DEVICE);
> -		sp->flags &=3D ~SRB_DMA_VALID;
> -	}
> -}
> -
> static void qla_nvme_release_ls_cmd_kref(struct kref *kref)
> {
> 	struct srb *sp =3D container_of(kref, struct srb, cmd_kref);
> @@ -199,7 +187,6 @@ static void qla_nvme_release_ls_cmd_kref(struct kref =
*kref)
>=20
> 	fd =3D priv->fd;
>=20
> -	qla_nvme_ls_unmap(sp, fd);
> 	fd->done(fd, priv->comp_status);
> out:
> 	qla2x00_rel_sp(sp);
> @@ -365,13 +352,10 @@ static int qla_nvme_ls_req(struct nvme_fc_local_por=
t *lport,
> 	nvme->u.nvme.rsp_len =3D fd->rsplen;
> 	nvme->u.nvme.rsp_dma =3D fd->rspdma;
> 	nvme->u.nvme.timeout_sec =3D fd->timeout;
> -	nvme->u.nvme.cmd_dma =3D dma_map_single(&ha->pdev->dev, fd->rqstaddr,
> -	    fd->rqstlen, DMA_TO_DEVICE);
> +	nvme->u.nvme.cmd_dma =3D fd->rqstdma;
> 	dma_sync_single_for_device(&ha->pdev->dev, nvme->u.nvme.cmd_dma,
> 	    fd->rqstlen, DMA_TO_DEVICE);
>=20
> -	sp->flags |=3D SRB_DMA_VALID;
> -
> 	rval =3D qla2x00_start_sp(sp);
> 	if (rval !=3D QLA_SUCCESS) {
> 		ql_log(ql_log_warn, vha, 0x700e,
> @@ -379,7 +363,6 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port =
*lport,
> 		wake_up(&sp->nvme_ls_waitq);
> 		sp->priv =3D NULL;
> 		priv->sp =3D NULL;
> -		qla_nvme_ls_unmap(sp, fd);
> 		qla2x00_rel_sp(sp);
> 		return rval;
> 	}
> --=20
> 2.19.0.rc0
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

