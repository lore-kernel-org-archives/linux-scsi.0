Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FBACC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 15:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46F0961A15
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 15:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236892AbhCXP5V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 11:57:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38910 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236884AbhCXP5H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 11:57:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OFs2Di135330;
        Wed, 24 Mar 2021 15:57:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=mjAR1ZwsTfASCNEZewPLTnb32XegtljjdLkfw6IlaVY=;
 b=JGRv8MyXabYxrswk0/rFaEizQ+yoqnk1v2FKL5Oynt2Bq19akIm7Yw1C7UYyq2ooHee/
 QxVRrmmMluj3+x5vwm6jraeHoPRjVnMHG2z8uJF2fGhwTt9Klp7NFzKKbebwP0TD+j9Y
 q5i8yhcKM/aRoKI37CkNggcFFezd+ZSuLAvS7VHvpDy0k+alGK8Q1yDIrx/5VXfeuZli
 PiwJpj3+ezPga9/qTowAFdzc5JXo5lQl8CMgx9o9818nAOsNRkWlIR6wzUfqLD0yHSXm
 ue++FabW/1kCBoDOuiOYsCaJ8SF6jvsQNEDKRMPrj+G6QGImT9tsnAJCsx5QRHfN/CEN NQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37d9pn37pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 15:57:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OFsrTD043985;
        Wed, 24 Mar 2021 15:57:05 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by userp3030.oracle.com with ESMTP id 37du000fcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 15:57:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+ddaOHQrF7DCGEt8wHHzzqsd+uphEHTLpxVawKuA7SWqKW652PpZdRvgm9gNfXnzkxd13I8IJkCgH8moVYZUE3YTbyjRsu8R981QI4VEt6NqPoTSV9PtMjRued/p4Y/8mN7OI2QKuoFKh+++o+n2vBPWICKZJ4c5ur7MSURIRrxV7slPiZ3zmYQl/RhviM6rqtCFNydoKPfy6XwuThCKo2Sc8mUooPUFgKe2s4DijVoVZ32AZjaCfl5318xy3ps20bz9sA8T4lctSvSa5fEK6Smpi/K/oKlRt270FE9CWiEkjHKjP7eYeoi3rhpk2X1RF0cDJn8VonA2R5SIsuGOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mjAR1ZwsTfASCNEZewPLTnb32XegtljjdLkfw6IlaVY=;
 b=hafVdGKrEmXUxRawaD30Hc/8n1SxmYz01onS3LrYE9+/OpMpW4nij3wCQ0vtTCbA267SLodrK3faljs1ooQ8+4RYngeNHOvigJPqS7efh7OcE7swJKm/HHMi9ozToMjD/iWaK8Yo6AxE6PMJ1054N5dFJsb5bnsQ9kbgx8CctpzfFsO8RMIN925QtV+OO0S+7xLNExeksnrJH0oMkz5asQua30tngNeZl5G6HWH+l0yFZXXEqvETd8a+0PJhOn0wlNCEBBTHnytP8a+kCbSN8FOEbhuJdPuCqj7vKLT5LB8pcn1UuTCSjIpnX+PeYrpwyWjoZqq6e46/4raQoUtZ4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mjAR1ZwsTfASCNEZewPLTnb32XegtljjdLkfw6IlaVY=;
 b=HFpCVDYa5jlGrfSVQ+qJPAwJu9LTPqdMoCvHAonBdc0xatyxaX8nBUa65oCqW/xlOO7DaztukHaDJSiFK6GDyCIHAnnkKKpcsdp5JwsjNJ0ossnhRP4FTfz0knqSqo+qRpHNPUy58zhdc2Jk9O+15+PcSxsrnP+/nESa8dl9Zy0=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2464.namprd10.prod.outlook.com (2603:10b6:805:4d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 15:57:03 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3977.024; Wed, 24 Mar 2021
 15:57:03 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 05/11] qla2xxx: Fix use after free in bsg
Thread-Topic: [PATCH 05/11] qla2xxx: Fix use after free in bsg
Thread-Index: AQHXH590vFTIBog6CESAkaTWc7sp8qqTTWkA
Date:   Wed, 24 Mar 2021 15:57:03 +0000
Message-ID: <B257AAA2-243F-45B2-91CB-DCE0A60A2548@oracle.com>
References: <20210323044257.26664-1-njavali@marvell.com>
 <20210323044257.26664-6-njavali@marvell.com>
In-Reply-To: <20210323044257.26664-6-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [71.42.68.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68d3ff38-e9f0-477d-4335-08d8eedd7785
x-ms-traffictypediagnostic: SN6PR10MB2464:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB2464B81066CE9674FD9FD5D4E6639@SN6PR10MB2464.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:348;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zm9r1/G0iVbEcjFKGzHZ/AYK6HlsflGPD1ecxfoAGE5ulZMgBqOTbgDAOPrc/KBlc4+yhQmEcBZfMzmAaqCHGbfEix+crGOJWLCzq9zlVP4LBG3US6xuv4Ug8wAuCj0zAqLamsQfrkGJg2himRg38X2GWEXwXHFFQzKzt976TTBBHzs4YqHxeNFhzAgsLlTx5mHEN9e05bTaxKTWE4lzI37xWQdZQ3zm98nq6vG45puBmDtbGCkGYBHXLZO4IC/FHMEfTlpmuhpuKxwy/u3qa6ZRsQ7MNdwfd7jAnzgeHcPZ3Z+eRWH8HG5Qleu24ipyRoqE5cR1YorkdWXEO6dlye0uGg+DFJNkc1voj009+AkEUiwO8ATvlSUTPbFd1ZD0LizsCcweIROPDc2t8NEq/xCE6xTxj2K+ofmNLYNiK6S0ao4jOijSIPmR1U2/ppi+sQJjEfhqmTMJ3xAr1HDCyBpShNbpc7wSsayb7gAjE5K0SKZ1vUblvRFX4ToV1A+QThH/UMIPC6v0aFyoyQsXkLyjXfBD61+TuF2PGQzQzjXuntU9aFLtUUi5ePU0VoEm6cD+K9fl8JGi9wwLD8ehM+XY9iuyYUWHZ9oEff1M2AtuojSa54Bcpko2+o3pRRJAOPFj1iGPQaWfhv4dh+TgEqoLcZ3mBaKx7gPzlUfnPJ3XvzgoFsHEIK0VnTvhzfzN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(366004)(136003)(346002)(4326008)(33656002)(66446008)(2616005)(8936002)(66946007)(6486002)(71200400001)(66476007)(38100700001)(66556008)(86362001)(44832011)(83380400001)(2906002)(64756008)(54906003)(316002)(36756003)(6506007)(76116006)(186003)(6916009)(8676002)(478600001)(5660300002)(6512007)(26005)(53546011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?aWLO2CYJLloNOz5HyFYcfNDJt67NC1yqzUJpdyGFwaNmxL5uclyf6tnRtIHp?=
 =?us-ascii?Q?RuhUWtS46CAjeYY/ULdTSeePFsPBiAtf5VPTrX2Z0qy/Lq+y1SpR+lX3shqW?=
 =?us-ascii?Q?x31Vlv37cHJyBiydAKbHgW743I/RNrnep2lBqsadJiFIOvzsY+4fVvinH6Hj?=
 =?us-ascii?Q?v3uDbgzXvMPaPOyWOUDBJ8RMxzgJIev7Rsgk6rDMIy+4c8+Fad9qxXB3S+Ik?=
 =?us-ascii?Q?0bTgko1VQ8wuAT8zDqIKWFPW82MTCTA3VwL7X27BSQUbYh/zE/kRgImUmog1?=
 =?us-ascii?Q?oF/GX1L3ksZ3M0RoBg1spu/HuqUNHIVrdcUWt/nHAxGfY/Y3ZegNTYBqgWox?=
 =?us-ascii?Q?me6sx/uNu7tGeLgM4q4sJyqvCqWSSGszygLzs9nQhbLA5uUV5DIurJbvfhRu?=
 =?us-ascii?Q?WrZtl4Afq3o0kUKUdaTubByZVpqEgwEqnmzTIec+XjsrOEWIp91JsbK1y3Fk?=
 =?us-ascii?Q?CQ7r+6rZuCcWJqZnnrgALfAnXBTjGZAhjgTtN/039CuYIEOo0rBe12Py523a?=
 =?us-ascii?Q?uxOz976lb5woPgVTD5MvN96A24BroUotACtsBRBy3JUm2GqBU8HIPG6ptjPc?=
 =?us-ascii?Q?218y3MTeImJ8dAUI4lAYzHT4XWluo28jz46PQPMXUno5m0ajUzdtFMtjyahy?=
 =?us-ascii?Q?OXaPwXThG2RwwZ3v5PZnzyxQ6fsYvw6eGgVORFGBm/tMta1w5kBFDUT0TT2H?=
 =?us-ascii?Q?KU+WjfUychlb0yh9hTxqBR1+wMtXRX6bKqsbL+N6on93o9Glq6d7kGjANwrt?=
 =?us-ascii?Q?LMPXbNqwqikiNucVm5wvPlsbOI/wPRA+a5hmLlRpzuTP/Etw/pFPeofqHKKL?=
 =?us-ascii?Q?m9mgaMqNkQYIS/Sr0srghy2Z5GbkOTU1iMSbQ5URZi1GnK70IYg7ynSUui2R?=
 =?us-ascii?Q?Wo9ybppTky2nDO+BdiEB4GHowm4l+7HeIrTKYYQsxv6VGo7TaMaINuu56XeT?=
 =?us-ascii?Q?Bn1LwuruBOw8qIYY3ORw+8ifpTg6lfz88oADDm4hMIGboof0CTONz8m3UvOA?=
 =?us-ascii?Q?0F1bh5U0u1Abz+0qtFxjD1x+Ui1NyETws+C5FDTHF6CuuFbFp/uE8O3RLN+J?=
 =?us-ascii?Q?caSGiUA0OiwuqotoCLeyBjBpWOzZhipBNnIxfzWOH4I4aRrSAfq0gKlaMvQS?=
 =?us-ascii?Q?SQAGELrUru7c8ehDZWxcn3Rb6IyjmMSsLSL+yegjg7FmmRLVQMjiDM/lFReK?=
 =?us-ascii?Q?Zo8mwZ2GDBaaxcHd6NTUhL3NS43QR33T/2U8dVEtQNzCzMdzst+1c9zhObm9?=
 =?us-ascii?Q?RWrwRBA73NisZw2cSUgc4bYO00aZCV1q4W7zIW+9QuvFRPjaVcSHEH+pFrgK?=
 =?us-ascii?Q?oV1oOcZNkC2XMTBY3YsdS2BP?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9A59F4686E5E51488AD8D46EE0CE0F41@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68d3ff38-e9f0-477d-4335-08d8eedd7785
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2021 15:57:03.1911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8S7B7mNwP533Ly67TS+4pjpoNpoYhmebLYXWHP7aQdFqbYrWw81uzrISY0XxNN7LSric8elCqziNH9DSE9E7t6vEz0RQw9g0Pv/0vJxwt10=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2464
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240117
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240117
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 22, 2021, at 11:42 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> On bsg command completion, bsg_job_done was called while
> qla driver continue to access the bsg_job buffer. The bsg_job_done
> can free up resources and reuse by other task, qla continue access
> of the same resource can read garbage data.
>=20
> localhost kernel: BUG: KASAN: use-after-free in sg_next+0x64/0x80
> localhost kernel: Read of size 8 at addr ffff8883228a3330 by task swapper=
/26/0
> localhost kernel:
> localhost kernel: CPU: 26 PID: 0 Comm: swapper/26 Kdump:
> loaded Tainted: G          OE    --------- -  - 4.18.0-193.el8.x86_64+deb=
ug #1
> localhost kernel: Hardware name: HP ProLiant DL360
> Gen9/ProLiant DL360 Gen9, BIOS P89 08/12/2016
> localhost kernel: Call Trace:
> localhost kernel: <IRQ>
> localhost kernel: dump_stack+0x9a/0xf0
> localhost kernel: print_address_description.cold.3+0x9/0x23b
> localhost kernel: kasan_report.cold.4+0x65/0x95
> localhost kernel: debug_dma_unmap_sg.part.12+0x10d/0x2d0
> localhost kernel: qla2x00_bsg_sp_free+0xaf6/0x1010 [qla2xxx]
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_bsg.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index bee8cf9f8123..d021e51344f5 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -25,10 +25,11 @@ void qla2x00_bsg_job_done(srb_t *sp, int res)
> 	struct bsg_job *bsg_job =3D sp->u.bsg_job;
> 	struct fc_bsg_reply *bsg_reply =3D bsg_job->reply;
>=20
> +	sp->free(sp);
> +
> 	bsg_reply->result =3D res;
> 	bsg_job_done(bsg_job, bsg_reply->result,
> 		       bsg_reply->reply_payload_rcv_len);
> -	sp->free(sp);
> }
>=20
> void qla2x00_bsg_sp_free(srb_t *sp)
> --=20
> 2.19.0.rc0
>=20

Looks good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

