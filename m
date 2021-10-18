Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C2AC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 14:26:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ADCC60F46
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 14:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhJRO3C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 10:29:02 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:15446 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230344AbhJRO3A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Oct 2021 10:29:00 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19IEEwci014683;
        Mon, 18 Oct 2021 14:26:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=C1MH1hG2mYBp+f87/BBi/mePDDbMxHmLF8h5aWEZYfo=;
 b=YNB+6SoxFrV282eeFy1qLODPzfQ0dR/SLLWO++ZqyZwEFtqbT58f+TAx3OUJHvxxs0GG
 jINA+N9j67BLWjTq3MCjUBM+Xl7GCTAe7YbKMb0vG381/9y9S3AoU4Ywdyh9eYCoF2ik
 L3/EsQB5ZQstgVjLpTmM/lB5uzJqU8Q+/9FHy8yNEFhjKuNrL7VNQdupgsNl4IY0+w+x
 f50LLSpy67JmAniW4q6TLG4qjioYFOgVXzMC0FWJ4w/BprwDekFj9rjw6HOAk1A94KLF
 lbCUhW8183L/i8K4XHFMnbnKORH9k/qcOgp74w46vU+rujhSY6bSXF8ya7NvM4nF1N4K WA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3brmkyc714-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 14:26:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19IEJ5qf005788;
        Mon, 18 Oct 2021 14:26:43 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by aserp3020.oracle.com with ESMTP id 3bqpj3tj7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 14:26:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n7nYaY6kywU9+DAuU/ZFFBWGj5aXY+nsehLuDraMcwBJToLK9CaAej/lXRmVror2C2qUkjPTY3goHS9FD3l62+sVrYzq8fEDixoUphlWX3naEOUVtTUZLaYlkeiVBl0Db5y3sHjtLsT8eDpauCYvPGjS8pMnLCYM17A+S7nEksZ0PcXugpd+37PMXtBMg4hkXZKzcst1Cb4aXeE4jvYUAmSmknaHP1UJgpCVn3MYf1H1JyXShCQpeyNpTTlfCOmquhFIF8KACj/+E/7ojDZ8RAhit4TGausEsyIPvBoSmauEhViVYAmgEKlNfmoeNXiyie4xHvO+dx3xWd0P74wTnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C1MH1hG2mYBp+f87/BBi/mePDDbMxHmLF8h5aWEZYfo=;
 b=YZa188kyb/HL5gWufeBtYR5DxmxYofjw0+/JMGCFYpH5SH2xuCBvbVZNsO5ukXj5iF6sCwqUddFO7jp1avyUnQXT7YB4Tr1j6x8KKjj+6s7R6Tkz0T/M7sixqSb4jUbouSwmB2/GUups7I+pq2eLFLp7l0XgKeEsKFtdbPlfPaSnhJxku6P3H+M5gG2HQmY2083P6ligfk0vW6zY50kF9DZdIavYHEZCTfMqcLvTtRUh0y19svv0cpHtrBcxmCtAZGC8d8wApXRsZPQHvppdclazMs+437n3Vjdbzn7RrgnsCPsx6C0nUK25R4EyjLQ+QOiYbHl03XlFP7bgCif5hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C1MH1hG2mYBp+f87/BBi/mePDDbMxHmLF8h5aWEZYfo=;
 b=dA0FBPkdChIxjot1AfX2Q8PuALMW2/U2jatj9xc11FSnZzYmz9YlYGtlkpbzbkBtHWNUARkY42jru6tFgnnO0TSMgEClXLA4hDGZz+3CtSeWT/P090HG2UwTeDermsiQ93B/jOpAY3KBEIJH6YvUiNWykleMUzVSIrMvlS0+870=
Received: from BL0PR10MB2932.namprd10.prod.outlook.com (2603:10b6:208:30::16)
 by BLAPR10MB5028.namprd10.prod.outlook.com (2603:10b6:208:307::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Mon, 18 Oct
 2021 14:26:41 +0000
Received: from BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188]) by BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188%3]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 14:26:41 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: Re: [PATCH RESEND] scsi: qla2xxx: fix unmap already freed sgl
Thread-Topic: [PATCH RESEND] scsi: qla2xxx: fix unmap already freed sgl
Thread-Index: AQHXxBt79fCUI/4ogEaTqpq+rXQ156vY0B0A
Date:   Mon, 18 Oct 2021 14:26:41 +0000
Message-ID: <322ACCBA-6E3C-415C-B3CF-BFF52D33728A@oracle.com>
References: <20211018122650.11846-1-d.bogdanov@yadro.com>
In-Reply-To: <20211018122650.11846-1-d.bogdanov@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19a94f3e-6264-4a51-aab8-08d992434dd4
x-ms-traffictypediagnostic: BLAPR10MB5028:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BLAPR10MB50288E92BE3C16FDB358C7EAE6BC9@BLAPR10MB5028.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OP4UuaBGzujbMz75p3vRcQvi215jhWjDz9ZNFufQwRSl1IQETp4XIG94WoL5to0gF/DHLxzHPr2yg62A41nWEMBhmGCLzipMM8Jt5pIuAhQEDz8qrgYPL2YCuuCUd/xrqeP8iXLFjECB5iJAyJxjlNKyqs5FBu33wqTZYXgLskRg10l4UENu+vHe+rqGfopa8iJhBoZ8sEhV0wYZGvWDPTNfJVHqIEMHIV6gs+30ZrOGd3wZCwG9D8s7BTTUlxQ2MVCJlNQMzkDWuxNzwkgUxeDp/Ln8KXvlZJ5X7OVsDlI+8PvCSOsSjtGi7roh1cZEcnPUPoraONNs0Q85ZT1qHC5sxFQeKpvX3j7u9dka4cnbkRjmhzg2Z6MYu5lFAfOQPeqjBvzqgjbQE+aUCU9560Je/F265wlRk+IXEjrM1M2zRZJjC6bCgV+Z6M339vrJDI3mMHIYtBTRmtcBXkyBAi7BYYod+QtaCZ2zEgFy9yMK4/1RY25Fy/AdVTTS8a+XaNOcN5QpPaRJ59cwKlp5Do3yu7sSkwYEN8nzAoBzE1dyWBkb8N4abXoaRDQgYJu/HWIL9aNDyb6Q47JuGe9yOyoiyDVUKPYCH8dknuSitt4dy3lzJg1MUZ8GCizVZt8xxU2HOdmQmZP0aDalSUeBEAV5Tzfor+Tr1Cp/5AT5N3eKg08pr0iUGgvJr9VDyH1k/m6TSzdl9N1IwExFU3sMM2Z5NXGV/Y3IgJm1lO/XVZOBSnMhaRBoXQmVZskByYRm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR10MB2932.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(6486002)(508600001)(316002)(6916009)(33656002)(91956017)(53546011)(66946007)(4326008)(66556008)(6512007)(8936002)(64756008)(8676002)(86362001)(76116006)(5660300002)(6506007)(36756003)(66476007)(71200400001)(66446008)(38070700005)(44832011)(186003)(83380400001)(2616005)(38100700002)(122000001)(2906002)(26005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LQXmrmd+97vSTGOsHj2KYReWf+yTLI+qDzAmpRXIM6o1YxGrUupftqTVzYOI?=
 =?us-ascii?Q?irRM5EPcIl0O9Vgi9ttesSK5bgQW3fZQw3JuOS8bLBMIe7Q6Xc7BDrAqr1PA?=
 =?us-ascii?Q?q0yI/er/RaEur1tVgufTbhh8xmr1QiWGvKgyCQaG/fC4AdO7ZN54neG2l5Ta?=
 =?us-ascii?Q?o8QqqoC4wN7GLPVHEys+Br0d9rgs2spI/t6GdZsHWS9jZT0IV3JeZzGRW/fB?=
 =?us-ascii?Q?EdEWGrcDuXeJmqc+Td/UfYr687rMDNGi6peV88DOvcRE7XKc+eknXHOhLy6E?=
 =?us-ascii?Q?ddYw93XAQHL+h0s7xB6wR0Ll6tgm3yCbXORc94qGYpEBdWn/4IEh0ocn7gwd?=
 =?us-ascii?Q?+PD/nNi1QaOTBodxVOSGncXvVAHKnRH2e1eI2ew7IjIJcUU+TYl9qLu8lhOt?=
 =?us-ascii?Q?t3O6hSvS/MkFi3KZNzz1qTV7iY63RKdS0ADmXaE+mxyd80GPHwRIIyXwydX7?=
 =?us-ascii?Q?vDLAcs5HI14sjpqqALQOpTWATdJ38YdMfOKJf2DSibs7EXNNqfs+ynuv1lrU?=
 =?us-ascii?Q?an0nxxBTR+rc/+3kxQi30gyuucfT+kCcqb2g+NWqX49IV5M+YrZSanVbM19O?=
 =?us-ascii?Q?1K5XNpsr8IzmW1QIkNe9Ph1rSb+ym3u3/t+WkWbiAzb8u1dTUTyGwQEoaOv0?=
 =?us-ascii?Q?2MX+yy0jZZGVeQxKGG7IUoRHk0STP9QORZJd5O6K4f/hLUW6LXVW3Cc7Aq13?=
 =?us-ascii?Q?9ytkn3mAqgejYKBq0ZYo5krR9m85dx00dyzbqsMFo1RPTOpfeT9WebRuiPLP?=
 =?us-ascii?Q?AQFxEEb64TZwIWqy8cX1FE0jFwgt6vPSfROmHzPKubc7vY36E4YsEc51drrB?=
 =?us-ascii?Q?lgRC+x66jPapZIBGOICG0Fcm3MmeQkJ7cw7T5Ctz7AW7Il9/04dIOoU+ap1X?=
 =?us-ascii?Q?g28utXbpGOsoZeYi1WFDz1rO7lfEj0+j6qP4xUbse9mca/nFit+0L+Lw3l6N?=
 =?us-ascii?Q?JCuCau+10WKTAMO1m7etRn8J4RViAy0nSb7Evzckt74Sas7PveaY5jvhptut?=
 =?us-ascii?Q?B7O0fhKqCsTn47LExhMkFp6OiYbopyXe1qyrGXLi/SQZHNet/nuT2ikGLOeU?=
 =?us-ascii?Q?14GEHozRk2Hw5zVwFk3WCerYRa2v5VS0Eg+dT/wH0+Pi/G3jlpQj+jYdJefb?=
 =?us-ascii?Q?4kV9jvoaj3GRlt3/WONN6hP1OmsoM+9UegfNZi5hL5aOTqYVyIqBKAtrb09O?=
 =?us-ascii?Q?+ZKidwIUsEmY1XbAlcEId2aiiwViXIl3MBb4sFovPvx1b8hN4kPMoq3TlYmC?=
 =?us-ascii?Q?BnSYYHiSuSC1efPA0QoSg9hk1CGRR3qN5D933L6tCySV6ip1TGjAfC5B5dnm?=
 =?us-ascii?Q?oTk2YOt1tM/9pIQkfvprACWOmJKaM6u6WgY9x97MPEYomA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <717441D050CA114C887D3853B2AE4A60@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR10MB2932.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19a94f3e-6264-4a51-aab8-08d992434dd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2021 14:26:41.4583
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dqIEiJFYTfGJ7mhLEI0Dl+KRMaNxMFoDd031LOEXV1OXIR6QNPbZS8fMAjZj1E3IKuxSHgnvfqilqD1erInbCsA/YTEM+nkVDWhudC94pI4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5028
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10141 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110180089
X-Proofpoint-GUID: CYS3M_A84diyy13HdcmWOfYiTW3HSOKx
X-Proofpoint-ORIG-GUID: CYS3M_A84diyy13HdcmWOfYiTW3HSOKx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 18, 2021, at 7:26 AM, Dmitry Bogdanov <d.bogdanov@yadro.com> wrote=
:
>=20
> sgl is freed in the target stack in target_release_cmd_kref before
> calling qlt_free_cmd, but there is an unmap of sgl in qlt_free_cmd that
> causes such a panic if sgl is not yet DMA unmapped:
>=20
> NIP dma_direct_unmap_sg+0xdc/0x180
> LR  dma_direct_unmap_sg+0xc8/0x180
> Call Trace:
> ql_dbg_prefix+0x68/0xc0 [qla2xxx] (unreliable)
> dma_unmap_sg_attrs+0x54/0xf0
> qlt_unmap_sg.part.19+0x54/0x1c0 [qla2xxx]
> qlt_free_cmd+0x124/0x1d0 [qla2xxx]
> tcm_qla2xxx_release_cmd+0x4c/0xa0 [tcm_qla2xxx]
> target_put_sess_cmd+0x198/0x370 [target_core_mod]
> transport_generic_free_cmd+0x6c/0x1b0 [target_core_mod]
> tcm_qla2xxx_complete_free+0x6c/0x90 [tcm_qla2xxx]
>=20
> SGL may be left unmapped in error cases of response sending.
> For instance, qlt_rdy_to_xfer maps sgl and exits when sesssion is being
> deleted keeping sgl mapped.
>=20
> This patch removes use-after-free of sgl, and ensures that sgl is
> unmapped for the cmd that was not send to FW.
>=20
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
> This patchset is intended for scsi-fix.
> ---
> drivers/scsi/qla2xxx/qla_target.c | 14 +++++---------
> 1 file changed, 5 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
> index b3478ed9b12e..7d8242c120fc 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -3319,8 +3319,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int =
xmit_type,
> 			"RESET-RSP online/active/old-count/new-count =3D %d/%d/%d/%d.\n",
> 			vha->flags.online, qla2x00_reset_active(vha),
> 			cmd->reset_count, qpair->chip_reset);
> -		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
> -		return 0;
> +		goto out_unmap_unlock;
> 	}
>=20
> 	/* Does F/W have an IOCBs for this request */
> @@ -3445,10 +3444,6 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
> 	prm.sg =3D NULL;
> 	prm.req_cnt =3D 1;
>=20
> -	/* Calculate number of entries and segments required */
> -	if (qlt_pci_map_calc_cnt(&prm) !=3D 0)
> -		return -EAGAIN;
> -
> 	if (!qpair->fw_started || (cmd->reset_count !=3D qpair->chip_reset) ||
> 	    (cmd->sess && cmd->sess->deleted)) {
> 		/*
> @@ -3466,6 +3461,10 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
> 		return 0;
> 	}
>=20
> +	/* Calculate number of entries and segments required */
> +	if (qlt_pci_map_calc_cnt(&prm) !=3D 0)
> +		return -EAGAIN;
> +
> 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
> 	/* Does F/W have an IOCBs for this request */
> 	res =3D qlt_check_reserve_free_req(qpair, prm.req_cnt);
> @@ -3870,9 +3869,6 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
>=20
> 	BUG_ON(cmd->cmd_in_wq);
>=20
> -	if (cmd->sg_mapped)
> -		qlt_unmap_sg(cmd->vha, cmd);
> -
> 	if (!cmd->q_full)
> 		qlt_decr_num_pend_cmds(cmd->vha);
>=20
> --=20
> 2.25.1
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

