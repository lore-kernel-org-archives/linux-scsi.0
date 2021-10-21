Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D62C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 14:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD73561038
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 14:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbhJUOob (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 10:44:31 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:57000 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230072AbhJUOo3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 10:44:29 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LEYpR0023668;
        Thu, 21 Oct 2021 14:42:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Bu7JoW+e4lJAIqvEKLLofdPok1um9bEc4GwbODgLZh4=;
 b=oigVQ39Ek1w+otvPQoxPdZ85wmX3NxodPykKZAklI0O/AYXAPijKx3uKPJVCMteAOLVy
 OxpAfEFXnQMUPut0qJJt2VQrMSkCkxzodVbpdc4icaDNse8DLlztURj0XdPAoGF/2XLc
 qDYJTLLDkxx4hiULPGC0yoHIYWalr2C2DmyUwg5t97UjuLzVaOq6/u+Syml5SUa5kLTI
 jDfKRzVxOWXby225WbdJYxk8zi+dfqpp5LLR+xbQ0SbpA3w58xDzS+SW0Gt6gDgunf8M
 UEB48OoLWG/rex499a3g5zc3bpVHLZYPZIzw6daS3TFV5UBSL6/j3I1cA0XKeFn3JQAU +A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkwj6nh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:42:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LEZNFT173473;
        Thu, 21 Oct 2021 14:41:59 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by aserp3020.oracle.com with ESMTP id 3bqpj8wvty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:41:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eFwiwxdszUUTrZnIrSDx53DPCViITzhNfawbpChMK0gxF5GabdQNcL25ut7zsaOmBPNuJo1M5ID57YcahUnU/4AWN7Ob6StDmKbLI/bpU+EN0K1Yx8BJywFGTXi4uAzfMkfzsPRz4LeitIC90yfpfnC4lnshpYrJDVZ39E1imanJh4fWHxAtqb7lxjYO+reOi1vb/OrRu4e+GkGL9gIanuBkP9hD2tmLdjOQYsUrX4OsficmrPf5BJmP+7sF6YgFj8rDb/oWZeqAXgEosyRIQs2wBctwAJ9RjOXSp50uV7+xt0KMKMmv+bxMWtSmHNFV+yeDz/XRt4zNKFQ9C7r9Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bu7JoW+e4lJAIqvEKLLofdPok1um9bEc4GwbODgLZh4=;
 b=Gb1ehrsHJfABu9HQVrusn5DZZyUvN4Kb7tDJioKcGrvg9evX4Ln0yOC8UArvYYJWHJPDnMx8zJBa9xxoP2Fflwi4ol5YIa6SRx2NwtX6s1VTxbFdxjr94Un7WEWpb/nS0HA2v4hG92kUmJDqhpmN3NQdDmMYfr+FkOklqgoqlzzTsv1fDKgcTx4vHTlTD4aVngd04S6qTiFn8fCX6DOwDnGo82w6UUSnoF6ZfwXLqcYoZnCgXh9ytXSvlZAVNBs029tGB45nVRanxRWGgrKSDhRVzVAovJfYY6NrikKZ3XWGH9/Ly0jTuNlXpDM2lrmlwhKXlzuppV9I8mqDT0680g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bu7JoW+e4lJAIqvEKLLofdPok1um9bEc4GwbODgLZh4=;
 b=kt5mEIg5OUbVfsV/05MbwM7ZY7UamHrDzmkvcwufUxsdw3ZZxpHeyB95YBy5uAYqmF1WVzjK+sCK+mUQsIdbPbilK5HjeNqT2MfbsLlaPkk61XdVp9nyVP2pD0hHUVUeWAnL49cETCXqWGHqiWStC60QSTMfLypiYEbgIF8bu4I=
Received: from BL0PR10MB2932.namprd10.prod.outlook.com (2603:10b6:208:30::16)
 by BL0PR10MB3026.namprd10.prod.outlook.com (2603:10b6:208:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Thu, 21 Oct
 2021 14:41:56 +0000
Received: from BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188]) by BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188%3]) with mapi id 15.20.4608.019; Thu, 21 Oct 2021
 14:41:56 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v2 10/13] qla2xxx: edif: increase ELS payload
Thread-Topic: [PATCH v2 10/13] qla2xxx: edif: increase ELS payload
Thread-Index: AQHXxk3V3AaHOw3d6UiQTncTFUu536vdhvsA
Date:   Thu, 21 Oct 2021 14:41:56 +0000
Message-ID: <BAE509D7-D42E-404D-8982-3835FAA59EDC@oracle.com>
References: <20211021073208.27582-1-njavali@marvell.com>
 <20211021073208.27582-11-njavali@marvell.com>
In-Reply-To: <20211021073208.27582-11-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f97eb6ee-c129-462b-bb9f-08d994a0ee99
x-ms-traffictypediagnostic: BL0PR10MB3026:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR10MB3026AD7341372BE6E21C9FF4E6BF9@BL0PR10MB3026.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:83;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vS6lK1OCWPBZGqJmpYvyon1w6YyzM78E4UPxtaEEbdSoaQeCa+G6I54nEa9a03eky3m9EjPMVe44dGeXQSBnbX118rc6F9aSbccGRCWu8xTaBbnnUZ9REhC92qWQv7Z4KKuEasX9juhyEv6M5Dao4jBdQ6vf7MAtq348qC6amwSVDGq6N+/7rbdt+XXSFb8ATU2WucAue6eRh5VnRciyRWUuBmbMpQJVC4uDpGBkDNV7v4QGLw8YWhEi8G0JAw9FnktSnkFTwklh/EUYzQSzlcNnsQ6q4tR1qPn0Dzm0QMkFjpVC32drQ+aiA8x/94wUT9gU66efuiKj6VGvC0BnRKx+JWdheaWx0cLSC//8tR7rsl97UV+PWGbUTq38Led+vhebeVzJDGpggqTRpvy/q6ip9ayVioIefcFj9Rcp3Z8Cy1VTaN5/x1krviAOpSKOq/9JzpZmkY+BwtE3+mFQpSY/0r5JUIjK2UHdIFQX8ZmAH0lg9whBDikiz9UAA6mGf6SRk5fBbq0pqcqrKRPKBJ3IZfDECM3fONmHEnfTncWks6LtnibcmFK5JdT7CxT6pLRQBVqp3HN2F0Jxiklcxw3LiXDMHPMf6BFvOT+9okKWasdYJaiXON+d1cvkwE4u+qEQFB0ygRAJMNAMbenwVRX10ZjrzQo0RtqEEDZYGDrSxn+sWTwgbnFx3hWqDiXX4kW0e5WWjsOoMEjKDcrhC9Pyw5ghzY9t8GXHfZQeBW16WiDMJi+hO1whpAzvC1zs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR10MB2932.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(6486002)(8936002)(33656002)(53546011)(38070700005)(71200400001)(83380400001)(316002)(2616005)(76116006)(91956017)(66446008)(6506007)(66946007)(66476007)(26005)(6512007)(36756003)(38100700002)(86362001)(122000001)(6916009)(44832011)(64756008)(66556008)(54906003)(4326008)(186003)(8676002)(508600001)(5660300002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GZPHzidqGgPuWk4qvgW0a5be9SIgMjqA/z+hVkILqeUYK3EbG54zjnGYum+3?=
 =?us-ascii?Q?EvecwP3Kd5qAacHztMCQZBNoLi4zFXi7kxhXwmfgFuvtttO2NGtKgAlikSUt?=
 =?us-ascii?Q?ihLENgy0dyIWa05vFXcr0dmyj752rI93sFHdENOJU2CdEz4Fc2jAKRKOnl0B?=
 =?us-ascii?Q?LIci9yPPG86QNcHHdJ7zX+5o4P4JeL393m+A6FMH+m0Lcu2RmbW2QK+C3JKW?=
 =?us-ascii?Q?2DevaM9BLE39Tpxk8XwWDOPEkqcThTUCbwLY2Q70lRjV+1WYbnlS33g3ZEE/?=
 =?us-ascii?Q?qOW6VoikFQA37qurnx8M9zCYPJEj/g5IBzIxbv2FZWxJ14TaI6xMjyboQhtV?=
 =?us-ascii?Q?897uxBgU6ItDN8doNMZNB06M3Fx0/ibG4sC2Hyuce9IWRc9vdOTMBE/h36Of?=
 =?us-ascii?Q?eBGKut7yIcchU50V/5dNvXPk8tbo/jYvZT84Blffg/DF1R025yiqsJ33Sj1d?=
 =?us-ascii?Q?8w/0G+W7pRtj4TAyCq1Ce6j6nISLIanMVq3Vs8Pdk4F+s0mXwkggD8YI+Mw7?=
 =?us-ascii?Q?zRQon9EDi6V3WHeBJuFQbAgWVlGVKsKrXc+8nBFp1KDr0FUioeeC+999+BAz?=
 =?us-ascii?Q?7zfMn9e1OxCfR5J5RI1QD07hIhngF/rbXiv2Ml/u+9F2Xcu1IIoz3WqwTbPl?=
 =?us-ascii?Q?QhKfVU+M2L+C3OZyTcdJcN7ZmPuqyTBGjnQiMNg1P8wTHacnGHlYirnqP7T5?=
 =?us-ascii?Q?Wq0Qkzga4H+ukKh3REoNl0CGzUUEC8FvmPHjUlijT867Q4ENMnCBQ6SA0w0P?=
 =?us-ascii?Q?yR45Vh9nIBGq1EOxEOPiAwMhDZspCIjcdKJcCh1piKo08CXHaj/14ad1F4vb?=
 =?us-ascii?Q?n6rQQ8Gkal4nSb1BMqTa0GZcXN9Y9pwXGe+gufvKKiIg1K4IHG9DtLMcAdo3?=
 =?us-ascii?Q?1jOpTN3XhNcsK9M6Wrc6H4AjdpogNm67Xa6al5mRUnl0XSqaN0I4gCLFf6kb?=
 =?us-ascii?Q?1FOaLq8lx1rN3jOoEUBSi0ctKjqrEajKVEIHul/vsMUDC0a23NxtOvOMTPqm?=
 =?us-ascii?Q?vrLrATStYTp0WN+2Hu9d+7PA6tLSieRax0UrDR13tcz9GOYgK8l6x0Pyh7A+?=
 =?us-ascii?Q?JIcpv2dJMfdB/tKqGkO+TRtnS3ssmpAlddDwVfVQREiOsSXsi24t0OxweRQC?=
 =?us-ascii?Q?WzZJ3JZ3ZfCnDQ3FoqtVJyX4Lgd6QWMtjc3IXbw2GebGJtOWLpfpoWKeapt3?=
 =?us-ascii?Q?EJ6eIFTbYwnM4PB0nzLWxGxGERlPvd5FKwL4ND/AHuS6PsSHlmkSO6QSEuZz?=
 =?us-ascii?Q?ytL4FUcYVx1XzVaLUgbVeExxOcNJRFrrWMd5FSCuxrvQRl3SPp15RYJ5SH/P?=
 =?us-ascii?Q?Uyoijsg2QhiIl3Rk+lRBVluc0c//Y/JTRQZ+9oV4DRqLNg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1145101345C9E4408965482EE2BEBAC6@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR10MB2932.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f97eb6ee-c129-462b-bb9f-08d994a0ee99
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 14:41:56.6817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: himanshu.madhani@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3026
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210078
X-Proofpoint-ORIG-GUID: l-GK1d5fFtIhXC2kqVKnn_KZXvBBKodS
X-Proofpoint-GUID: l-GK1d5fFtIhXC2kqVKnn_KZXvBBKodS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 21, 2021, at 2:32 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Currently, FW limits ELS payload to FC frame size/2112.
> This patch adjust memory buffer size to be able to handle
> max ELS payload.
>=20
> Fixes: 84318a9f01ce ("scsi: qla2xxx: edif: Add send, receive, and accept =
for
> 		     auth_els")

^^^ Fixes line should be one line..  Please fix that=20

> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_edif.c     | 2 +-
> drivers/scsi/qla2xxx/qla_edif.h     | 3 ++-
> drivers/scsi/qla2xxx/qla_edif_bsg.h | 2 +-
> drivers/scsi/qla2xxx/qla_init.c     | 4 ++++
> drivers/scsi/qla2xxx/qla_os.c       | 2 +-
> 5 files changed, 9 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_e=
dif.c
> index bb3a1afb86a8..1ea130c61d70 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -2375,7 +2375,7 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **=
pkt, struct rsp_que **rsp)
> 		return;
> 	}
>=20
> -	if (totlen > MAX_PAYLOAD) {
> +	if (totlen > ELS_MAX_PAYLOAD) {
> 		ql_dbg(ql_dbg_edif, vha, 0x0910d,
> 		    "%s WARNING: verbose ELS frame received (totlen=3D%x)\n",
> 		    __func__, totlen);
> diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_e=
dif.h
> index 920b1eace40f..2517005fb08c 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.h
> +++ b/drivers/scsi/qla2xxx/qla_edif.h
> @@ -93,7 +93,6 @@ struct sa_update_28xx {
> };
>=20
> #define        NUM_ENTRIES     256
> -#define        MAX_PAYLOAD     1024
> #define        PUR_GET         1
>=20
> struct dinfo {
> @@ -127,6 +126,8 @@ struct enode {
> 	} u;
> };
>=20
> +#define RX_ELS_SIZE (roundup(sizeof(struct enode) + ELS_MAX_PAYLOAD, SMP=
_CACHE_BYTES))
> +
> #define EDIF_SESSION_DOWN(_s) \
> 	(qla_ini_mode_enabled(_s->vha) && (_s->disc_state =3D=3D DSC_DELETE_PEND=
 || \
> 	 _s->disc_state =3D=3D DSC_DELETED || \
> diff --git a/drivers/scsi/qla2xxx/qla_edif_bsg.h b/drivers/scsi/qla2xxx/q=
la_edif_bsg.h
> index 58b718d35d19..53026d82ebff 100644
> --- a/drivers/scsi/qla2xxx/qla_edif_bsg.h
> +++ b/drivers/scsi/qla2xxx/qla_edif_bsg.h
> @@ -8,7 +8,7 @@
> #define __QLA_EDIF_BSG_H
>=20
> /* BSG Vendor specific commands */
> -#define	ELS_MAX_PAYLOAD		1024
> +#define	ELS_MAX_PAYLOAD		2112
> #ifndef	WWN_SIZE
> #define WWN_SIZE		8
> #endif
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 999e0423891c..2bc5593645ec 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -4486,6 +4486,10 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
> 		    (ha->flags.fawwpn_enabled) ? "enabled" : "disabled");
> 	}
>=20
> +	/* ELS pass through payload is limit by frame size. */
> +	if (ha->flags.edif_enabled)
> +		mid_init_cb->init_cb.frame_payload_size =3D cpu_to_le16(ELS_MAX_PAYLOA=
D);
> +
> 	rval =3D qla2x00_init_firmware(vha, ha->init_cb_size);
> next_check:
> 	if (rval) {
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index df0e46ef3e96..814d082491af 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4352,7 +4352,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t =
req_len, uint16_t rsp_len,
>=20
> 	/* allocate the purex dma pool */
> 	ha->purex_dma_pool =3D dma_pool_create(name, &ha->pdev->dev,
> -	    MAX_PAYLOAD, 8, 0);
> +	    ELS_MAX_PAYLOAD, 8, 0);
>=20
> 	if (!ha->purex_dma_pool) {
> 		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x011b,
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

