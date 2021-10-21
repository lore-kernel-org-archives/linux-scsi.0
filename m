Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C53BC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 13:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CFFA611F2
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 13:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhJUOAo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 10:00:44 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:55270 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230072AbhJUOAn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 10:00:43 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LDr6Im013139;
        Thu, 21 Oct 2021 13:58:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=DZuR6oa+mTpAIGyaQnkR+J826mEx7oQGWkY0wYIp6+c=;
 b=bF7B71NkC2nsURUxEpq7JfUHMMpHVIU+3uOVo+oLWwioZazjGlUwLIkw3J7MpuY18xMb
 RJHEFSMh427JarTBj0OsnJteJhCMk6LHhmK2cZ+B0KHCxM6sTNxTCMWJQvXUat6MPQOw
 uz3HxLXCJM839nHEhpAIMQNBF3JKM8dXBDnLJXGSR+7J+K9DfUkbyMboesv5iGZ9Uaty
 TxjVfU11EyUUYT9SEsuSHPCwQSsPIhVcG/k49bv4j/rudfBFLkIaOohAh6SWW4+x8dY8
 eG1/xsaclFeSX/aRObkft3J50lL+soTt8pCTnFqAFda7i9Y3H66UvLYvwQFPg2m+SpfV SA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkx9xy0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 13:58:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LDpe8G137574;
        Thu, 21 Oct 2021 13:58:24 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by userp3030.oracle.com with ESMTP id 3bqkv1xhdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 13:58:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FDNFvs2+dUa6/+SJITYmJuMBs5OrN1do+7UqRgduQ9aPw4fa9A1N7sGVZ+gRJ308sW3jHoR4jisK985ifnlmkvB45vzXtMyMmwEQV+bt3VVmvqjOlshXkaxcAhP/TX34z+RVTPJ+VZ5WuJUM9BdYToeomoLneHkpfHEF+82EGHYz67L4mxV1RuKiDsOc0AXCatDHA86kG7zuVEXAB3EQNXysXg4karRxWlVOK0t8TqMq33VMXMihBqPRBGyxb8zqJyWFFGaSqQDzh4VWZ6BrFtOIwy+dl2vwdhNSd8XMK+Li/3cQpQdual1DvKsmkJ3LMe5DCXbLPYk9I44DceKF4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DZuR6oa+mTpAIGyaQnkR+J826mEx7oQGWkY0wYIp6+c=;
 b=MoCDHQ46dvMaowpHJm8YhP0wNO9MWLZRgIeMa7aTxTUHFNL8+R0Ab7tSjn7MbPAVbdBDg6HerlqHShJnW+ux8fhVTcPYXIwbFfJqg/DyxMvANMp8uLB9ph4KfhLLrSxUFB3Jrb92PGEgXmPO7rvSenOKETOL9qsKsLJ/jwVqmvlg5zBG+08xqgzXVbX7XTF8R0EapAzt8yZawpw9+VDQPFsMrITbyii9UUo+EPfQBu/jQFWJ4dDHBU12PcPo7N6jfZNIDTyioi0JhIa37tTYvDyNs0/kt1ssR1nJJ2XxHRs0C3B+/6II/M75ECoFom5EcH15EaoP1AxKjbv9ymOtbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZuR6oa+mTpAIGyaQnkR+J826mEx7oQGWkY0wYIp6+c=;
 b=iaWXNwSGtsnd1odhraROVwrTLUmH+HmNZVU0mZEw1IYGnS1Ae4JkfKSvd8CPxBASiMtHkHVXmnooNkAMJaJ3CNhSWBy+nG2OpNeZeNWfk6o9MNLa+DwMsecuhIYopXJEC627LR9y4AGlSc34wUa5UadQY/YzHPNluaNbtMBb2/I=
Received: from BL0PR10MB2932.namprd10.prod.outlook.com (2603:10b6:208:30::16)
 by BLAPR10MB5041.namprd10.prod.outlook.com (2603:10b6:208:30e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Thu, 21 Oct
 2021 13:58:21 +0000
Received: from BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188]) by BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188%3]) with mapi id 15.20.4608.019; Thu, 21 Oct 2021
 13:58:21 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v2 02/13] qla2xxx: fix gnl list corruption
Thread-Topic: [PATCH v2 02/13] qla2xxx: fix gnl list corruption
Thread-Index: AQHXxk3RjVNBNjkyRUO2vFDPv576uavdes6A
Date:   Thu, 21 Oct 2021 13:58:21 +0000
Message-ID: <62101325-2C34-431B-9579-06C5E1A2AF95@oracle.com>
References: <20211021073208.27582-1-njavali@marvell.com>
 <20211021073208.27582-3-njavali@marvell.com>
In-Reply-To: <20211021073208.27582-3-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9fca1ea-1646-464a-eb09-08d9949ad7e3
x-ms-traffictypediagnostic: BLAPR10MB5041:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BLAPR10MB5041224DE580D315C072372CE6BF9@BLAPR10MB5041.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:198;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f8BAl++g9vmdRRxrgfS30HuX9VIl+O8pgAxL8/moVh0p0+GxyAcd5LAn2TA2rWjnMBBISB+lK+WDvivpLpcsm5PdfWYQ/wXwZhrXc0Z7TYJjLBFvMYxb7f1egi3CXJyLi/xG51vl4bNQSe3ZVkT85Rq1uaTSlDbMVTl+KxDPOlxKiJMAJK4l3XGLAZ5Al3mYnHcSR+KC1T8unqvcJRvbAhMrPrlMU5yTo8ok7AWNRpM3iROZmCRsLcL4q0XcWJL5kIQkYvvZAZvU/8ofx9iMLvSsMUEmcDCrcsSvxduAHeGWOKOuHe/3/6l1L3R9sqm6ssFtS/Qj/oGchlL1UxKMteOdEg2YGc74SyoNajjowDt/gKDWRm1as7JjbWuBPrMOdBTnbKBU6VQc7UrOkLXSCxal76ZjloTgDdR7dQ0Bd1J89QX0TNxPh4B0WvXcCnHvGmT10/czdOSyaOD2Mlko93s0vzzdfKu+0Jx7MDZpZrHTJhPpaEmyFf82XsMzZ3G6uDPy8/93fj27zKc6ge4U3BdvVAR9h2/ASZv49aswWQeGzKjRWm79YhQRPIych+yju0k3/2CZDanIzDPQjChyFEZH7/GX1SwqfIX84MadZE5Egcr87C8ZV80GpBTs9yf298HU5IfoJnSwAPmPcMwmHE9fuq0ezrfjJq/rREDDBlX+Sq5DgeEYmyzJxTtd+ymd7ARlCXdb9AScFU8liSLqN7tGeJDB9gB0TwmS2TPzHndVmR+FwEQg8r1jkSFLQDZw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR10MB2932.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(38070700005)(5660300002)(122000001)(66946007)(8936002)(64756008)(91956017)(6506007)(54906003)(83380400001)(186003)(26005)(66476007)(76116006)(38100700002)(66556008)(6486002)(36756003)(53546011)(2906002)(6512007)(6916009)(33656002)(4326008)(66446008)(316002)(8676002)(71200400001)(44832011)(508600001)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0kFE+Sva/niYP9Jddwr/Sp6dEWKRT15LnD2WrryyC8uFxVjKUlASfAXUntlO?=
 =?us-ascii?Q?OLSEz9x01d++22Hm0NHBciyEt1U97TyBOtA+SiAdOPb3O96e9tPNtDdfzAIq?=
 =?us-ascii?Q?iPB71ZhTiA1mCaabKNxTW8Otr0Eb7oqlt9G0X0Qqo2UVsfJ9bkFdCvrYffBH?=
 =?us-ascii?Q?0scRf/mLRzAMmLvUMdGY20SGMTYsmEDRjC1Ast058K9KWcIVoXcyPjV5gVeZ?=
 =?us-ascii?Q?rpEHZbWAPD9SchvlqXzKQGFT3qLjMMqJQEWo//Jq/759zZD4qdyoGhWu/eL4?=
 =?us-ascii?Q?5IF2EvPvIfl7L/y2jhxgRBmtxmsnPZDAtP3FmOKyJUGK/0DI3vs/25Jb9IzM?=
 =?us-ascii?Q?V2AZqASKsAas/EGfXWvTMN8izHtMR4VFZC3HnImc74ktqQ6x+ERS5y3O9tYi?=
 =?us-ascii?Q?i+q4WNhp8D7Q4vsXIjZLa/8Cjhc8a38VQ5XMC6RxQeZK4hHnyV5gr6O24/Ag?=
 =?us-ascii?Q?U5z+MuE86BREf7vvbZSRC514DLFIiMpzeXjRM+uW12oKrc5j3+bpzAUv2Qtk?=
 =?us-ascii?Q?TVckqCnmtGvWQcxz8P26WrcOMWOuxji0O/aXCucN030LEJQsGiWNoWfFnjMZ?=
 =?us-ascii?Q?aVG7LX6ybavnG/yK8lQmk6BhLMXc1DH2icAOgerwsUfDULgAiX5RtUauKD4r?=
 =?us-ascii?Q?dcBa2B1D8do3ESS2gySTF94fE+gnaC5oaAB+rV2ZqXxjZwP4GxSJdI2tQRXv?=
 =?us-ascii?Q?xOw/zJymyqa3ZEXcIHWM8dZDPsOrGVLlUKMLzkM09IknZx6RzN3Vfi4tPkkw?=
 =?us-ascii?Q?zfMUOzvadHR6e7eJn5+sdQ7FFncnWOwc+LKUpcO20qrkt60D0ozdeUyherrP?=
 =?us-ascii?Q?pwEDUZlsj15gbyYxVUUYqURFymSqxfpmPSRt2bX/se3F4LD9ReB6Dhhy0TRC?=
 =?us-ascii?Q?Z2mSXQtDeDpI4q8qSEc2o2sjTDLrUsBv7GoFfqU9vUblITQsgfJXraPe9DQ1?=
 =?us-ascii?Q?nDh4tTsukXjm/5oQGEWTVxY32YASJ4v102YtjncaU2afZCXI1MyuXZbpBThg?=
 =?us-ascii?Q?+9L6EPJA/q3qNwG9rOCFOWDwtNHO8WtABrtSa1OVv/trQCTMukjQKEBAGmtU?=
 =?us-ascii?Q?/c5LJ+zA+z4T/s03Z3qXjIWsKaXtBIxWJeKD0D3oiVW2NRrEMIsvmHzNN6FQ?=
 =?us-ascii?Q?RCfnTHYbUdp9k6u6lVJC3R+wAv35+sn37TgpaqUV2dH9HmWnzioLNNBp8Sgd?=
 =?us-ascii?Q?rLEuDj3MGrkI5t5cCQlIuQkMmZY8z5vcxBar//yjCBT0yf1Tg+bM8fATqoUc?=
 =?us-ascii?Q?LwLWmgs+S/xevOeBliewWV4Wp3TN4O0izNG8Uis2IktDUJG1N9pScMmXs4e1?=
 =?us-ascii?Q?B5CXo+bFAI+WNvyePC52uBVjEHXVl08i8D1nO3gk3xhCYA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5BE2384E3B37EB4FBD63A649B39B690D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR10MB2932.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9fca1ea-1646-464a-eb09-08d9949ad7e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 13:58:21.6729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: himanshu.madhani@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5041
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110210074
X-Proofpoint-ORIG-GUID: OWU-Cpq3MjOl9HAPHxmA2Mu6ZPNK6QOl
X-Proofpoint-GUID: OWU-Cpq3MjOl9HAPHxmA2Mu6ZPNK6QOl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 21, 2021, at 2:31 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Current code does list element deletion and addition
> in and out of lock protection. This patch move lock
> deletion behind lock.
>=20
> list_add double add: new=3Dffff9130b5eb89f8, prev=3Dffff9130b5eb89f8,
>    next=3Dffff9130c6a715f0.
> ------------[ cut here ]------------
> kernel BUG at lib/list_debug.c:31!
> invalid opcode: 0000 [#1] SMP PTI
> CPU: 1 PID: 182395 Comm: kworker/1:37 Kdump: loaded Tainted: G W  OE
> --------- -  - 4.18.0-193.el8.x86_64 #1
> Hardware name: HP ProLiant DL160 Gen8, BIOS J03 02/10/2014
> Workqueue: qla2xxx_wq qla2x00_iocb_work_fn [qla2xxx]
> RIP: 0010:__list_add_valid+0x41/0x50
> Code: 85 94 00 00 00 48 39 c7 74 0b 48 39 d7 74 06 b8 01 00 00 00 c3 48 8=
9 f2
> 4c 89 c1 48 89 fe 48 c7 c7 60 83 ad 97 e8 4d bd ce ff <0f> 0b 0f 1f 00 66=
 2e
> 0f 1f 84 00 00 00 00 00 48 8b 07 48 8b 57 08
> RSP: 0018:ffffaba306f47d68 EFLAGS: 00010046
> RAX: 0000000000000058 RBX: ffff9130b5eb8800 RCX: 0000000000000006
> RDX: 0000000000000000 RSI: 0000000000000096 RDI: ffff9130b7456a00
> RBP: ffff9130c6a70a58 R08: 000000000008d7be R09: 0000000000000001
> R10: 0000000000000000 R11: 0000000000000001 R12: ffff9130c6a715f0
> R13: ffff9130b5eb8824 R14: ffff9130b5eb89f8 R15: ffff9130b5eb89f8
> FS:  0000000000000000(0000) GS:ffff9130b7440000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007efcaaef11a0 CR3: 000000005200a002 CR4: 00000000000606e0
> Call Trace:
>  qla24xx_async_gnl+0x113/0x3c0 [qla2xxx]
>  ? qla2x00_iocb_work_fn+0x53/0x80 [qla2xxx]
>  ? process_one_work+0x1a7/0x3b0
>  ? worker_thread+0x30/0x390
>  ? create_worker+0x1a0/0x1a0
>  ? kthread+0x112/0x130
>=20
> Fixes: 726b85487067 ("qla2xxx: Add framework for async fabric discovery")
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 4 +---
> 1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 339aa3b2737a..2ccdc76cf0d9 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -987,8 +987,6 @@ static void qla24xx_async_gnl_sp_done(srb_t *sp, int =
res)
> 	    sp->name, res, sp->u.iocb_cmd.u.mbx.in_mb[1],
> 	    sp->u.iocb_cmd.u.mbx.in_mb[2]);
>=20
> -	if (res =3D=3D QLA_FUNCTION_TIMEOUT)
> -		return;
>=20
> 	sp->fcport->flags &=3D ~(FCF_ASYNC_SENT|FCF_ASYNC_ACTIVE);
> 	memset(&ea, 0, sizeof(ea));
> @@ -1026,8 +1024,8 @@ static void qla24xx_async_gnl_sp_done(srb_t *sp, in=
t res)
> 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
>=20
> 	list_for_each_entry_safe(fcport, tf, &h, gnl_entry) {
> -		list_del_init(&fcport->gnl_entry);
> 		spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
> +		list_del_init(&fcport->gnl_entry);
> 		fcport->flags &=3D ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
> 		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
> 		ea.fcport =3D fcport;
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

