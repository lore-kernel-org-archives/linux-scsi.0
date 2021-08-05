Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F69EC4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A95861151
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242608AbhHEPoI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 11:44:08 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3268 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242630AbhHEPn2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 11:43:28 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175FgGeP003237;
        Thu, 5 Aug 2021 15:43:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=lT7qIH4qmogoHhhJkL+F8kjYBEtZCReNyX7+T3fjSG8=;
 b=CXs/v2CdXybGeB+IpCyHFCT+fisAetAwNCIGO554StytvgiWHpXbXieG5ZXY6qDqCgO2
 qvrFKcM40g4hB9gr9WjqOUwwiYjPn5fmwK1K2QRdpZagE9/t+1hg9Px71pt34SuC+Cs0
 lxF46lRv7mpoJjokyajVOHHTcHHlL0aEPiKlniMX1d7MCpyt/YunXJUvpYyci+AqKIcv
 Crocu2FQjZIBm3pF55ctdqiLHgnBrrBHdcr1mr4A4OddzjXBgV0/XPP2etg2zx8ej25M
 1S0/3hMeMNQH+12zPBlSehgZZJkF9tkyhm0iBAmR/ppF9DX+hfhkkzUNDYG3+FjBaoeM Ag== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=lT7qIH4qmogoHhhJkL+F8kjYBEtZCReNyX7+T3fjSG8=;
 b=0Ehbp5Bk4+OzbC4FJ4oPWdCGV3V4mY6nfOGp3cnK7idQFWwgxOs9ZPyr/YqKOSSOtw51
 VH3lNzp2F3JIOp7QDbARGM0yRNj9Em+PFq8LCXf81vilj0K3cqaluz3kLYYEcPtHaeJf
 y1wI4n8hcmXIKH1PtBHJh8878+D0Yc/p8JBlZDh3mS9/RBaZKzfJp/OCwQIcHk6G+jLd
 0FLyHZpHC0XdW6knUt8Ima1FXJKP+3mJnLEr222s2WyJ7VrTcbOHHXCsNmjvvrzKWYg8
 aHFCuTicmY6AmxX1kHCbZB1t2RdurB5XnU/OVLziXK4RRV5vLFHSb11E6yGDsrGgBs0/ bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a843p9sn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:43:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 175FfVWQ125196;
        Thu, 5 Aug 2021 15:43:11 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2041.outbound.protection.outlook.com [104.47.73.41])
        by userp3020.oracle.com with ESMTP id 3a5ga0f0pw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:43:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gcaLtGR4kp+bTRQpwcbbrJsylzKf0yWDgoUtR1Nk/7hgfjIwPI4QzFOw4RFdJr3TCsGcMef6rtn/qXEmVRWq1102HULr8WRLYUdTboT/xzy9U+9aQrxsykW4X1Wqc704dgRB0wCaPSElMCpbsOlkrwq/EHd0cbHa7Fc2Df4upBthuwEhzoGr+WhBYxaJUNgz22xezb755R+MJYyPDU/k/M0tQwGvCrUCE1+5QWNC0+LA/GOeXTveVAwc0GHM6Qfw8iRlki04GxqJOAmMN2aw0uXS9cKG6GEzxbSI+b0tcbOrlB2/o9+kME5oTro7aLyyBCF1k69v7mHMZhvJlL8d3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lT7qIH4qmogoHhhJkL+F8kjYBEtZCReNyX7+T3fjSG8=;
 b=Brsy7+ysBg6gWI1G1BqWsdlcN2gnIE9295oC3NdaEzVfxgixgcrqYDqpRNWeALCypoUC3VMyzAYUVioDmSIEueakqgRSl1WSNGTQ87Qw8StlYWFsGvPsoLaR4EPqXRk7efWI5hVmMg1Dw/lc1Uqb8XHHJMKxLmPbMnpWw3D1p1u7B43Z3LfnW9tCQQodD7MO0jZCYwVLkzPTU0Qm2XE5dgUe9VBDP4X9/5UGofSLp4V6JrVWvhFQlwsdTU6685eoSCCEHHeK66UBHxmA48L+7IQEw3CPxH+tUcipmbudC2eoMe/i+AZjVnyfsD+fxyndmsbRqCihN9q4iFaDagHCLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lT7qIH4qmogoHhhJkL+F8kjYBEtZCReNyX7+T3fjSG8=;
 b=WIvxg/1nNeFRyrb/fWgP2AvIPd282z9SZQMz+31VtaVvhoYfAI02iz3fbmsZNlCsivGb8DetdUlN/eE1UQ4qAm3l9XVNGVUWoGdIzijMqoxu8jzbQWzbtcpCBUXV020g14mJZ1b9oRvzjn9Fn8sLVGym42sHI4K0QA7oRMwJoP8=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4796.namprd10.prod.outlook.com (2603:10b6:806:115::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Thu, 5 Aug
 2021 15:43:08 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43%5]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 15:43:08 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 10/14] qla2xxx: suppress unnecessary log messages during
 login
Thread-Topic: [PATCH 10/14] qla2xxx: suppress unnecessary log messages during
 login
Thread-Index: AQHXieQZJ1tkSvCFp0eRLFAEmgduC6tlDWQA
Date:   Thu, 5 Aug 2021 15:43:08 +0000
Message-ID: <B316A884-9725-4FE4-9E30-3A9531C58285@oracle.com>
References: <20210805102005.20183-1-njavali@marvell.com>
 <20210805102005.20183-11-njavali@marvell.com>
In-Reply-To: <20210805102005.20183-11-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 714c0002-41aa-4443-1e9f-08d95827b96f
x-ms-traffictypediagnostic: SA2PR10MB4796:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB4796E02903CC495BF34049FFE6F29@SA2PR10MB4796.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:38;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W/NmqO9Aba4issMoJrfG/zx4L5tghI86F4M/c8M+ZjYiinuI3kZgFGyM+kCGu2mOhR8lSxVaZTRjdv342HtXWiM5MCCJcYlnPKb2GrCP+BG/HGCUzdyebXBjuHkscH05UoGg5tee51G+CbTrGOL6s4RMoIOauA3+hS1rgcgoYjiZDb4uEzhrvx5gFylpcsloc8oZt4sbznAb65KeqOx6ity6hozKxXvA+kOPwlAmbDiNTcIlWqeAOjtBlEK4ltCdp+xzwYEwT6EOY3vt5pJPdcLjxEKJBDCTF3v6NRXyqrRr1WH4FkKfzzTtNJ+sL017vepMR/a2zNGYADuv6aRiO1JIZjzFXPlcJ9HXnKELTptPXb95L7rdsXwDwHDlASDUI+S1eVLemjJTGc6TM3C82g/3a2PCocumISL/vvkHzmHQworaPAG8mO3PGTl/XywiBUsFuslkETihoo+djV4cCTNBAnWymB2qKPUVJJEJloyPrX0gsrdBvzmE6T12xhjlzTh6IIDllw6OL6iPTqFUVj8LTRYsvapOm0pAa1CEd9AxS9u/4PNxXNkfNS15agiMeqN2nQCKF4jAklMvzgi3mypjhp9E6lepQA3RANEctRs8lUJ+m/I2w1gqDGzFiZ3/me9B/BWcdD56cJIKWEEc2qhBTDDAAqZrgwTFT/z+FZBAhuJQzbajNgIHma3ZEQH9jNcnGEDR39mT+ayVSllG9YpQnzJ4zso6KW/yp0tQACvJMK0vQMZzAo42QxnELP69
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(376002)(366004)(39860400002)(478600001)(6512007)(316002)(2906002)(33656002)(86362001)(44832011)(2616005)(186003)(4326008)(71200400001)(36756003)(26005)(53546011)(6506007)(6916009)(83380400001)(5660300002)(38070700005)(66556008)(8676002)(66946007)(54906003)(76116006)(38100700002)(66476007)(122000001)(64756008)(66446008)(8936002)(6486002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MwfQY7DuYAqYHxor08WrKKP41rxK7AajJecoDeya00yx2bjh5gyVjyiOfFer?=
 =?us-ascii?Q?f+IPORHK8V6AGOZ1k+wJxy1x+HI9/QSNCm8WLnEh+rTD1juoZub3V7v42Gwb?=
 =?us-ascii?Q?yAwlwr1Pxo6hvZhDUm3LME+Hd4cZlIvwRTqHC1/yBKPpyQtIPaix2FWpLv6t?=
 =?us-ascii?Q?ValEIpQLKl/NzTIAiMC/ctpcEaUlWq7LjRMZAr7SPoyDn2tzQLaVHf4H+eNU?=
 =?us-ascii?Q?cjMokkUkx0idRPvgIR0bQV6GFZLHucQvhbu2g7tmCMtibjgcH2RdmH8O+q2/?=
 =?us-ascii?Q?mnPE8k8tqcCn9fIFF7oKJb4Dews1dN6g4EckvvmqJiWz3H58y8hhv0B5ss3F?=
 =?us-ascii?Q?OCO+pkoWWBG4c48m7jiu6VaZXylxjqBZnh/MuAzKs9NIJ+0Aci90BFGB5fQe?=
 =?us-ascii?Q?42UNxEhUc49cTB05MyRZ52C1dQ1GPwH4UNyXvDt88PUXq7eNKJEsnTrjBO+m?=
 =?us-ascii?Q?Jpp0s99BH+VwediJ38tE8RwmWaQGPCTebBjvoaK457k9wFm9B6pb4c5mt4Hc?=
 =?us-ascii?Q?WEJFw103nnsmQ1KJSi66eJrNu3REvEyIJ7AJkLycXc4C3QUH/QKEPcmWuOf7?=
 =?us-ascii?Q?R5ueOCmd/mYfWteoPkWn5go7khm5GsfmhojPLLD1lPluA0zAPv/94ZyvuXxL?=
 =?us-ascii?Q?zyDOQkGVLI+CS0yvzzKqQXH29KBQwWBzrss53PtKluuIPNwq+DL3EKb2/iz0?=
 =?us-ascii?Q?7LlSbVpsO2WuSdA26kNzq6Ep+PPbAG+C3+1fa2SMod8CjjOU0kBbTjbksRah?=
 =?us-ascii?Q?WomEhtYA/VVxwKbAy+bDlKywkGiM4wfgIUw94GQMFM/K+6qEm0SvWeJ1t7FI?=
 =?us-ascii?Q?e8qRfKRhDGzDi1uJ/n9pbi3v6AvRMcoR3JT2SDKbil+ZX+9rGHWQr8yX6xJW?=
 =?us-ascii?Q?umUES+W74fCIGLzbfkvu9lNtpV859WIFTooqbxyyU82GJzMCvTfHF4pirUAl?=
 =?us-ascii?Q?UhK+XXoQlP4tPLs2IzGVdnrEjNC1J22IcYqPrl7oqSjSPFyfRn1ryCk9dy6I?=
 =?us-ascii?Q?2kqdMfl7XUpcG81kWbteMTRtEIOlDQpatdRpnY1LH0/9q4xbtVRtICI9eeFf?=
 =?us-ascii?Q?UkeiA6AdjzLfV+zia6W2ewpXtYHocMOvbH0n5WbTIrGFMDkMs42GmlVJhf6K?=
 =?us-ascii?Q?kuuWljyElrpkA3cG4s20WhDCIpQElvEU/6Eehk2npdpTmpyfv1+vOmeBse/o?=
 =?us-ascii?Q?f3BhxKzz8GVy23EtBlIihpKq6U1wcgorVqIb6NNiPVj458ud2T9cfnLOlRrE?=
 =?us-ascii?Q?9OZYO/gV6OoVrAea9z2HkVEW3ED0J5x2vQI46aEoxRsU0XxSFZ9v9WQdhAsA?=
 =?us-ascii?Q?hFoY81YmtRZomG6tXklK1LR2Ku+KHPtzpSz7CBcOM3a9dQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FDC37ACF0E6F9E4B91E7EA25AA6353B6@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 714c0002-41aa-4443-1e9f-08d95827b96f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 15:43:08.6992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hMdMOB+ywOSeBqSqnIY938ORQoFRYFJDA08QX0uru5UmC6vXwigo2R7F7rwl340MK3P/m1/GB8RgqB2zYCwYrAxX7j0bR2l/P4XuyaqHOnE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4796
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108050095
X-Proofpoint-ORIG-GUID: Iip4WRs7pHg-CvpkyKRswdMjTMKRGZxU
X-Proofpoint-GUID: Iip4WRs7pHg-CvpkyKRswdMjTMKRGZxU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 5, 2021, at 5:20 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> Suppress logging of retryable errors. These could still be seen
> if extended logging is enabled.
>=20
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c |  2 +-
> drivers/scsi/qla2xxx/qla_isr.c  | 23 +++++++++++++++++------
> 2 files changed, 18 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 266e9e06a6f2..6fc4fd8f5fb7 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -360,7 +360,7 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_por=
t_t *fcport,
> 	if (NVME_TARGET(vha->hw, fcport))
> 		lio->u.logio.flags |=3D SRB_LOGIN_SKIP_PRLI;
>=20
> -	ql_log(ql_log_warn, vha, 0x2072,
> +	ql_dbg(ql_dbg_disc, vha, 0x2072,
> 	       "Async-login - %8phC hdl=3D%x, loopid=3D%x portid=3D%06x retries=
=3D%d.\n",
> 	       fcport->port_name, sp->handle, fcport->loop_id,
> 	       fcport->d_id.b24, fcport->login_retry);
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 93ab686c7a30..b0b5af21781a 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2326,6 +2326,7 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct re=
q_que *req,
> 	struct srb_iocb *lio;
> 	uint16_t *data;
> 	uint32_t iop[2];
> +	int logit =3D 1;
>=20
> 	sp =3D qla2x00_get_sp_from_handle(vha, func, req, logio);
> 	if (!sp)
> @@ -2403,9 +2404,11 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct r=
eq_que *req,
> 	case LSC_SCODE_PORTID_USED:
> 		data[0] =3D MBS_PORT_ID_USED;
> 		data[1] =3D LSW(iop[1]);
> +		logit =3D 0;
> 		break;
> 	case LSC_SCODE_NPORT_USED:
> 		data[0] =3D MBS_LOOP_ID_USED;
> +		logit =3D 0;
> 		break;
> 	case LSC_SCODE_CMD_FAILED:
> 		if (iop[1] =3D=3D 0x0606) {
> @@ -2438,12 +2441,20 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct =
req_que *req,
> 		break;
> 	}
>=20
> -	ql_log(ql_log_warn, sp->vha, 0x5037,
> -	       "Async-%s failed: handle=3D%x pid=3D%06x wwpn=3D%8phC comp_statu=
s=3D%x iop0=3D%x iop1=3D%x\n",
> -	       type, sp->handle, fcport->d_id.b24, fcport->port_name,
> -	       le16_to_cpu(logio->comp_status),
> -	       le32_to_cpu(logio->io_parameter[0]),
> -	       le32_to_cpu(logio->io_parameter[1]));
> +	if (logit)
> +		ql_log(ql_log_warn, sp->vha, 0x5037, "Async-%s failed: "
> +		       "handle=3D%x pid=3D%06x wwpn=3D%8phC comp_status=3D%x iop0=3D%x=
 iop1=3D%x\n",
> +		       type, sp->handle, fcport->d_id.b24, fcport->port_name,
> +		       le16_to_cpu(logio->comp_status),
> +		       le32_to_cpu(logio->io_parameter[0]),
> +		       le32_to_cpu(logio->io_parameter[1]));
> +	else
> +		ql_dbg(ql_dbg_disc, sp->vha, 0x5037, "Async-%s failed: "
> +		       "handle=3D%x pid=3D%06x wwpn=3D%8phC comp_status=3D%x iop0=3D%x=
 iop1=3D%x\n",
> +		       type, sp->handle, fcport->d_id.b24, fcport->port_name,
> +		       le16_to_cpu(logio->comp_status),
> +		       le32_to_cpu(logio->io_parameter[0]),
> +		       le32_to_cpu(logio->io_parameter[1]));
>=20
> logio_done:
> 	sp->done(sp, 0);
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

