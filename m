Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83233C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Dec 2021 04:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241760AbhLAE0J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 23:26:09 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26338 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229590AbhLAE0J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Nov 2021 23:26:09 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1B134YIO011160;
        Tue, 30 Nov 2021 20:22:44 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3cp0tyg7uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 20:22:44 -0800
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 1B14MiJm019083;
        Tue, 30 Nov 2021 20:22:44 -0800
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3cp0tyg7ug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 20:22:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQKEsvEVCERc8wWAWFIaKFrHf0Yvi6Fg8mnP41WC6Bd16pu1kRO7pXhp/XhjT83LWx6KBZv4XqiAD+tptTSTy8s71w6wiDlmYHZZyehn7cbhk5+6rlDU5dw0v8mh0t4fljjf8VcS+Xvy4TR42SdiM1UcOy9qv2Cv1tTzvZKK+IKmnB5DXlXQ5ZxK3e8K363ZSws9h4KQlS5PCE9a6FJUdQIpK/MdN46iFHT9uIBtyNGUmsmJOaD3ZH3NoXeuMgBCh/G/oZYzll1+mXxdYNDBZDP45R+1bbWtzRt2TOPpMnpTKnUB1CRVCCshRTJWRnGKBGuBtmxQRmFopg8Q3Gskqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VRQl29djtYx9GC9N9mvuUeoIeytZmI3vjrb00OZLHmY=;
 b=hDiV4SBFmzaxyhnwU0k0Qg/ntoEVMz0Of5jXA4fb7Y/p3skynV8Zip8OxDPugkv2hOssVEAsC+7yCsDKWdLaOikH3La16IBOAjkaU4WM42YYiVQQ+gJdzB299GwnYDzyqW0j2o1lNSbHunZfPdZKVrximU/xBxkR6IB1/ZVXlsA/Qz+KqiDuqvuQqMmRocMKxgoHxpkvgGHT2SImwm/ylwbCQ5VowHBMFMnNrRkP4UEK5LOZtO1KryYusZlXoUWB0RBhuNRYzPY8cIYyB38l3MLHPHmQaqVLvNhhakd5MiwShzXu2/I6smhm4Ky0uGNiYkwcE8nBdmw3CNotHiBmKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VRQl29djtYx9GC9N9mvuUeoIeytZmI3vjrb00OZLHmY=;
 b=gFByg9g57gGqxTqSDnv5NXwQw9Mo86pHaS1QcGDuGMbxY48+Nh+Poy+2wtbqVaABtZ45AcuH/qeRfKMPhZytODNkoPC2dnrgt97yM6pMt76ym27Iux1r+9ke+MwqLcRvQt0OCDcLiBDXCsM4NZ86fGibpLY+RFDRUGe5r2KfkV4=
Received: from CO6PR18MB4419.namprd18.prod.outlook.com (2603:10b6:5:35a::11)
 by CO1PR18MB4620.namprd18.prod.outlook.com (2603:10b6:303:e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Wed, 1 Dec
 2021 04:22:42 +0000
Received: from CO6PR18MB4419.namprd18.prod.outlook.com
 ([fe80::f960:c2cb:8ca4:e0cf]) by CO6PR18MB4419.namprd18.prod.outlook.com
 ([fe80::f960:c2cb:8ca4:e0cf%4]) with mapi id 15.20.4755.014; Wed, 1 Dec 2021
 04:22:42 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Manish Rangankar <mrangankar@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "cleech@redhat.com" <cleech@redhat.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH v2] qedi: Fix cmd_cleanup_cmpl counter mismatch issue.
Thread-Topic: [PATCH v2] qedi: Fix cmd_cleanup_cmpl counter mismatch issue.
Thread-Index: AQHX4pdthljPqRP9y0ORteg5rxzDZawdEH4A
Date:   Wed, 1 Dec 2021 04:22:42 +0000
Message-ID: <CO6PR18MB4419DA9AF111D1A9DF136A4CD8689@CO6PR18MB4419.namprd18.prod.outlook.com>
References: <20211126072853.7862-1-mrangankar@marvell.com>
In-Reply-To: <20211126072853.7862-1-mrangankar@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 008d2241-f593-4b08-aad9-08d9b4823803
x-ms-traffictypediagnostic: CO1PR18MB4620:
x-microsoft-antispam-prvs: <CO1PR18MB4620235B63A5C8016E2C251BD8689@CO1PR18MB4620.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dZ1HYVHjGcmoP/DwMZjeUx47X1Dl3TtLHBmFCINZ7bgT+RgLu4Hn4YCqk8TMfNdgjOSP6iLkmXpGwn18/Dl+TrZ84GKJJU8rDvJTu8JB014ohUtO9DDl0qUgRYDFDgGVKLgOSAsKq/3RdnExk2XQoSw6Sl3arRVMXZdtAqiatV6sp2NMIrazbN78C4nofnsI+V+ZCAbHlm2cJMPWes9OGAIMervtgEA4ZXR9x7+G4DLMtTTu/2KumTdVsdkmGRHo32/1taNJ01njS97NKZrGE8XPfgjrW9QWiRi69Fso79q5yc4ELl9vSF6QC5997drX8KEP4Yrq7HEC6Jua21l1nUhUWBVe3SUnMimdCRXMFjHaEkWHo8jFvwdrX8m6fFvCT8bOwYdyEf/J00ADajnza33VatqtM24ZCbWyWYpPPI3twfCobMSwJ0NGPOzfJ/FY0TznAdfY+lzWsLIihaeXvbA8wvaxhsTEJaIiLths6Dhw/JrXZ670mEmk8c90nEuJca5WFio35uWa+EScjp81U8qgu1hFXNZf1u4LLhQIBWU6QoM6ByzYtON1y6VjE4VkNvhaohovakJwmKY4STRZGeqABpYuc20g1St3F8vALPv2JBZIgrKvUMh+1SROZdgROsOUoK09gmGNLEVV9973BHFUL5fNL23aBGZb6kSx6aLZ+L84QxJZS1CB0wtThFITZww5C76qrirgk8gAHi5+Qw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4419.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(86362001)(66946007)(107886003)(316002)(54906003)(7696005)(66446008)(110136005)(66556008)(64756008)(122000001)(66476007)(26005)(38100700002)(9686003)(55016003)(33656002)(52536014)(83380400001)(53546011)(38070700005)(4326008)(5660300002)(8936002)(8676002)(71200400001)(6506007)(186003)(2906002)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pPiLpED0+e7St4fRhCT03Vwgxct9cToxhzNEdSeVXNrjq0p0SAYvgSwxZ3OS?=
 =?us-ascii?Q?4eO/mjA7jbKhoi/Q4oM5R9U59RrqFB11I67XwEkpggs9EX/wpFvFflCWGmCX?=
 =?us-ascii?Q?v8rdYKwA5mmb4jjHeFATDzkDh/3i5hZYRVGPyie6x0qmqO1EQUZogH8mbGcS?=
 =?us-ascii?Q?dI+dZ94Axso+5KTRVWtn6W07JLz9qJYHUcqz9jyCm+evpEQPPPcsXHVNnTjB?=
 =?us-ascii?Q?j4c/Eh15IWOwNSPkAD2aUXlnow4uoNxoSS+iXBWep9NXmZUBIq3Ic3Mfl/Pu?=
 =?us-ascii?Q?W/8qfSXMhbcYiYBxFo4s+Pq9delY/C4UQVbx2MvvsBS4Syo8n3UUE9Q6Dn7f?=
 =?us-ascii?Q?j4TwR4m92h9/arA4+sjAtgW2waDwpINRvuJoS21Ccm9G5Q7LwZg9GSzdYBVB?=
 =?us-ascii?Q?pjf+qGS9+o1IPe95fThJ+vOZp4m+BPk/gktU9Xkw5D7jC7bnGsrbrKhIh1nz?=
 =?us-ascii?Q?JI8zpR8GxRm2mYwSV64JffZUmmCWnDbHMua4+AnBpAd8z7XbHxC/DskeXmGI?=
 =?us-ascii?Q?tf01utVqGF1iQ+Q2g2b+DhQ/cbKbKJuiAqd1LGTf0mGTCTfyjktAOOg53osa?=
 =?us-ascii?Q?VvHg7zXZUAYWeXZzw83zOQMSxQva49uWZymB+xtmlDwrxWHF7UttfAiP6Fe+?=
 =?us-ascii?Q?ySVWp5Q27X8q8K1WPN1+RJliXVkKpk357pRDlYFV+TQEk/vq+XXebi09oiaT?=
 =?us-ascii?Q?A40WaT0Zr/kK/Oc14Q4PYypjlu2j/03eHiCMVYKaj854DyxRfQsldOQzJgOR?=
 =?us-ascii?Q?BW6cPEbUTI4JxQcK6wARnOIlTENWTr7wlvfWVWvs27FNOMznfBlLmGpulQIM?=
 =?us-ascii?Q?JR2dqEgJLNPCpE5aScO6V9XH5Pyh7pbLHHtDysQEJQvqXVBtquZ9i6GrkXI9?=
 =?us-ascii?Q?iHlppG7THSdPPzzeeLW1nCzmZhbDput8PEazrihCgBl9/WQ52zMbfnAyfS6m?=
 =?us-ascii?Q?QEjW07QruB42Y8duIpLUVVhbbbB1THagv+HmAydlh6hPi69S1fu1MR5EDI/r?=
 =?us-ascii?Q?aPAkWZAlDQfGBUM3aKhCvGlZiwhnVZBd7CxNCqKU7imTJtD5/+qbUBMlNLc/?=
 =?us-ascii?Q?4xFmwJ4A+1+QO/cmaN9ZYqEaa5RKmn6WHUR2W3BlXUjDNYiJTeteybb1nqdM?=
 =?us-ascii?Q?vq7Un1PgpTb9apm3IMsq5soT5uaHafCnkDBPoKMTwYxHDQTnBBA9NTTH55iv?=
 =?us-ascii?Q?vui1Zo12/Y5YspMhJKkJEuL4lqy0rRHp/UKxr/9AgWjHSKk5maBGjL9mHGBF?=
 =?us-ascii?Q?0LFzva3qevON0kdjrm+jps6yCAOgckCuhwDBB0TEIkeLh5I5CzP6RfwaWX8j?=
 =?us-ascii?Q?0hznGamNYJWkkv+fyPeC/hmDEdiXveBuX0rlYPL6Ciau3IoS/sXzX81EiLU8?=
 =?us-ascii?Q?+yPsUE9uit5SgKN7x5veTJXwldMo6IayEqxagF7e0UX6eYRM1PosUYRbLXK/?=
 =?us-ascii?Q?f/enL3iKmg9bcWngJ6AbdCfBPf1I6cdiosXt7zVxomZPQ2Ngwb1S4R0nuRXs?=
 =?us-ascii?Q?hoM5q+CtHWTMNzopaDrcRVL1m5VqwV4In68kt+WsoOEry2A2ipNmTq9tDhMF?=
 =?us-ascii?Q?ZcjMyb9zsF6m8xIGDKF77AKFmegv9Na+iV6BWorjkpgATK7HKRdjyWNizRxG?=
 =?us-ascii?Q?eA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4419.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 008d2241-f593-4b08-aad9-08d9b4823803
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2021 04:22:42.6346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 51H4jaA52q2h8zjhMauI7K0CjFFm2SkQhv9NIMBqoKU+WzzoMaXsIjb7w6Qmdxme3qRtZgUjUlb11lKGetKo+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR18MB4620
X-Proofpoint-ORIG-GUID: laxTTjODnhEt6HvwjPDA-WViO4wWmBJy
X-Proofpoint-GUID: aedogZt_ZHVvF8GX7nIGakpNFOFr-u3-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-11-28_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Can you pick this one ? It's a single patch fix.

Thanks,
Manish

> -----Original Message-----
> From: Manish Rangankar <mrangankar@marvell.com>
> Sent: Friday, November 26, 2021 12:59 PM
> To: martin.petersen@oracle.com; lduncan@suse.com; cleech@redhat.com
> Cc: linux-scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-
> Storage-Upstream@marvell.com>
> Subject: [PATCH v2] qedi: Fix cmd_cleanup_cmpl counter mismatch issue.
>=20
> When issued LUN reset under heavy i/o, we hit the qedi WARN_ON because of=
 a
> mismatch in firmware i/o cmd cleanup request count and i/o cmd cleanup
> response count received. The mismatch is because of the race caused by th=
e
> postfix increment of cmd_cleanup_cmpl.
>=20
> [qedi_clearsq:1295]:18: fatal error, need hard reset, cid=3D0x0
> WARNING: CPU: 48 PID: 110963 at drivers/scsi/qedi/qedi_fw.c:1296
> qedi_clearsq+0xa5/0xd0 [qedi]
> CPU: 48 PID: 110963 Comm: kworker/u130:0 Kdump: loaded Tainted: G        =
W
> Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40
> 04/15/2020
> Workqueue: iscsi_conn_cleanup iscsi_cleanup_conn_work_fn
> [scsi_transport_iscsi]
> RIP: 0010:qedi_clearsq+0xa5/0xd0 [qedi]
>  RSP: 0018:ffffac2162c7fd98 EFLAGS: 00010246
>  RAX: 0000000000000000 RBX: ffff975213c40ab8 RCX: 0000000000000000
>  RDX: 0000000000000000 RSI: ffff9761bf816858 RDI: ffff9761bf816858
>  RBP: ffff975247018628 R08: 000000000000522c R09: 000000000000005b
>  R10: 0000000000000000 R11: ffffac2162c7fbd8 R12: ffff97522e1b2be8
>  R13: 0000000000000000 R14: ffff97522e1b2800 R15: 0000000000000001
>  FS:  0000000000000000(0000) GS:ffff9761bf800000(0000)
> knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007f1a34e3e1a0 CR3: 0000000108bb2000 CR4: 0000000000350ee0
> Call Trace:
>   qedi_ep_disconnect+0x533/0x550 [qedi]
>   ? iscsi_dbg_trace+0x63/0x80 [scsi_transport_iscsi]
>   ? _cond_resched+0x15/0x30
>   ? iscsi_suspend_queue+0x19/0x40 [libiscsi]
>   iscsi_ep_disconnect+0xb0/0x130 [scsi_transport_iscsi]
>   iscsi_cleanup_conn_work_fn+0x82/0x130 [scsi_transport_iscsi]
>   process_one_work+0x1a7/0x360
>   ? create_worker+0x1a0/0x1a0
>   worker_thread+0x30/0x390
>   ? create_worker+0x1a0/0x1a0
>   kthread+0x116/0x130
>   ? kthread_flush_work_fn+0x10/0x10
>   ret_from_fork+0x22/0x40
>  ---[ end trace 5f1441f59082235c ]---
>=20
> Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
> ---
>  drivers/scsi/qedi/qedi_fw.c    | 37 ++++++++++++++--------------------
>  drivers/scsi/qedi/qedi_iscsi.c |  2 +-
>  drivers/scsi/qedi/qedi_iscsi.h |  2 +-
>  3 files changed, 17 insertions(+), 24 deletions(-)
>=20
> diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c in=
dex
> 84a4204a2cb4..5916ed7662d5 100644
> --- a/drivers/scsi/qedi/qedi_fw.c
> +++ b/drivers/scsi/qedi/qedi_fw.c
> @@ -732,7 +732,6 @@ static void qedi_process_cmd_cleanup_resp(struct
> qedi_ctx *qedi,  {
>  	struct qedi_work_map *work, *work_tmp;
>  	u32 proto_itt =3D cqe->itid;
> -	itt_t protoitt =3D 0;
>  	int found =3D 0;
>  	struct qedi_cmd *qedi_cmd =3D NULL;
>  	u32 iscsi_cid;
> @@ -812,16 +811,12 @@ static void qedi_process_cmd_cleanup_resp(struct
> qedi_ctx *qedi,
>  	return;
>=20
>  check_cleanup_reqs:
> -	if (qedi_conn->cmd_cleanup_req > 0) {
> -		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
> +	if (atomic_inc_return(&qedi_conn->cmd_cleanup_cmpl) =3D=3D
> +	    qedi_conn->cmd_cleanup_req) {
> +		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
>  			  "Freeing tid=3D0x%x for cid=3D0x%x\n",
>  			  cqe->itid, qedi_conn->iscsi_conn_id);
> -		qedi_conn->cmd_cleanup_cmpl++;
>  		wake_up(&qedi_conn->wait_queue);
> -	} else {
> -		QEDI_ERR(&qedi->dbg_ctx,
> -			 "Delayed or untracked cleanup response, itt=3D0x%x,
> tid=3D0x%x, cid=3D0x%x\n",
> -			 protoitt, cqe->itid, qedi_conn->iscsi_conn_id);
>  	}
>  }
>=20
> @@ -1163,7 +1158,7 @@ int qedi_cleanup_all_io(struct qedi_ctx *qedi, stru=
ct
> qedi_conn *qedi_conn,
>  	}
>=20
>  	qedi_conn->cmd_cleanup_req =3D 0;
> -	qedi_conn->cmd_cleanup_cmpl =3D 0;
> +	atomic_set(&qedi_conn->cmd_cleanup_cmpl, 0);
>=20
>  	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
>  		  "active_cmd_count=3D%d, cid=3D0x%x, in_recovery=3D%d,
> lun_reset=3D%d\n", @@ -1215,16 +1210,15 @@ int qedi_cleanup_all_io(struct
> qedi_ctx *qedi, struct qedi_conn *qedi_conn,
>  		  qedi_conn->iscsi_conn_id);
>=20
>  	rval  =3D wait_event_interruptible_timeout(qedi_conn->wait_queue,
> -						 ((qedi_conn-
> >cmd_cleanup_req =3D=3D
> -						 qedi_conn-
> >cmd_cleanup_cmpl) ||
> -						 test_bit(QEDI_IN_RECOVERY,
> -							  &qedi->flags)),
> -						 5 * HZ);
> +				(qedi_conn->cmd_cleanup_req =3D=3D
> +				 atomic_read(&qedi_conn-
> >cmd_cleanup_cmpl)) ||
> +				test_bit(QEDI_IN_RECOVERY, &qedi->flags),
> +				5 * HZ);
>  	if (rval) {
>  		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
>  			  "i/o cmd_cleanup_req=3D%d, equal to
> cmd_cleanup_cmpl=3D%d, cid=3D0x%x\n",
>  			  qedi_conn->cmd_cleanup_req,
> -			  qedi_conn->cmd_cleanup_cmpl,
> +			  atomic_read(&qedi_conn->cmd_cleanup_cmpl),
>  			  qedi_conn->iscsi_conn_id);
>=20
>  		return 0;
> @@ -1233,7 +1227,7 @@ int qedi_cleanup_all_io(struct qedi_ctx *qedi, stru=
ct
> qedi_conn *qedi_conn,
>  	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
>  		  "i/o cmd_cleanup_req=3D%d, not equal to
> cmd_cleanup_cmpl=3D%d, cid=3D0x%x\n",
>  		  qedi_conn->cmd_cleanup_req,
> -		  qedi_conn->cmd_cleanup_cmpl,
> +		  atomic_read(&qedi_conn->cmd_cleanup_cmpl),
>  		  qedi_conn->iscsi_conn_id);
>=20
>  	iscsi_host_for_each_session(qedi->shost,
> @@ -1242,11 +1236,10 @@ int qedi_cleanup_all_io(struct qedi_ctx *qedi,
> struct qedi_conn *qedi_conn,
>=20
>  	/* Enable IOs for all other sessions except current.*/
>  	if (!wait_event_interruptible_timeout(qedi_conn->wait_queue,
> -					      (qedi_conn->cmd_cleanup_req =3D=3D
> -					       qedi_conn->cmd_cleanup_cmpl) ||
> -					       test_bit(QEDI_IN_RECOVERY,
> -							&qedi->flags),
> -					      5 * HZ)) {
> +				(qedi_conn->cmd_cleanup_req =3D=3D
> +				 atomic_read(&qedi_conn-
> >cmd_cleanup_cmpl)) ||
> +				test_bit(QEDI_IN_RECOVERY, &qedi->flags),
> +				5 * HZ)) {
>  		iscsi_host_for_each_session(qedi->shost,
>  					    qedi_mark_device_available);
>  		return -1;
> @@ -1266,7 +1259,7 @@ void qedi_clearsq(struct qedi_ctx *qedi, struct
> qedi_conn *qedi_conn,
>=20
>  	qedi_ep =3D qedi_conn->ep;
>  	qedi_conn->cmd_cleanup_req =3D 0;
> -	qedi_conn->cmd_cleanup_cmpl =3D 0;
> +	atomic_set(&qedi_conn->cmd_cleanup_cmpl, 0);
>=20
>  	if (!qedi_ep) {
>  		QEDI_WARN(&qedi->dbg_ctx,
> diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscs=
i.c index
> 88aa7d8b11c9..282ecb4e39bb 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.c
> +++ b/drivers/scsi/qedi/qedi_iscsi.c
> @@ -412,7 +412,7 @@ static int qedi_conn_bind(struct iscsi_cls_session
> *cls_session,
>  	qedi_conn->iscsi_conn_id =3D qedi_ep->iscsi_cid;
>  	qedi_conn->fw_cid =3D qedi_ep->fw_cid;
>  	qedi_conn->cmd_cleanup_req =3D 0;
> -	qedi_conn->cmd_cleanup_cmpl =3D 0;
> +	atomic_set(&qedi_conn->cmd_cleanup_cmpl, 0);
>=20
>  	if (qedi_bind_conn_to_iscsi_cid(qedi, qedi_conn)) {
>  		rc =3D -EINVAL;
> diff --git a/drivers/scsi/qedi/qedi_iscsi.h b/drivers/scsi/qedi/qedi_iscs=
i.h index
> a282860da0aa..9b9f2e44fdde 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.h
> +++ b/drivers/scsi/qedi/qedi_iscsi.h
> @@ -155,7 +155,7 @@ struct qedi_conn {
>  	spinlock_t list_lock;		/* internal conn lock */
>  	u32 active_cmd_count;
>  	u32 cmd_cleanup_req;
> -	u32 cmd_cleanup_cmpl;
> +	atomic_t cmd_cleanup_cmpl;
>=20
>  	u32 iscsi_conn_id;
>  	int itt;
> --
> 2.18.2

