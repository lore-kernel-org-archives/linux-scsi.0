Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4B2AC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 07:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 299BD2237B
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 07:19:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="STQ1NFFB";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="Y1zOAHPw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730758AbgJTHTI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 03:19:08 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41148 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726348AbgJTHTI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Oct 2020 03:19:08 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09K7GJoF024537
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2020 00:19:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=wquDiPrXA8NTY89MvVzMtunMkzjUKq6uxThFdRJWmO8=;
 b=STQ1NFFBXJtUGlKSYBy95Y7BhaA68ckFFBucIH2XfpfKMCQ6u+2Xc9w9kT6yOs6zXOrv
 i2hj8AonRpPckON0I3cEm2Y9HtXD3bcQYHRONtkD9+GWoyNpdD9OVGk3efLZQol2ukYF
 hMyuF7RDKj59iwMTmC4lfV3aJW8sgrBOiigI5TXQs7SRPBo9VDSfR+gb2OAahrnrBdZI
 bU0w97BwuS6MrpTynxqmuylaKMNTdTwu7wFdEUdwlIoaRHmVp5VvP9xLUDYBvNaCxJGB
 xk2XGv19701HbWFOzebANJSFUTIU/c1ERL+aVxfT5mEuFT10AZh1hmvISxraQ2L2aU9+ Hg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 34804nqtku-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2020 00:19:05 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Oct
 2020 00:19:03 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 20 Oct 2020 00:19:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Es7rNa1SboE5ZH5WjsjALWtCU24Go4X19M1oCtSQRb1aPwaA5M6xQ2UPiHTjhrnbfbvqVBmoY9m3yAU9+nXMjOCr++3RFJYHQy8NGWp872FpKHmeffwus24WnqnZNm8VaZuZNL98B1N0dqTJp1/Z07Tyzv0WmN8Yx/WukJsu5AwM0YiYURxZGuOEtGsOJI1ABZ7u9AG8mWCpQc5R49lKWoNzaXEslsk6PYdrkyidkA1G/cyAY209fxL5iMM3/ItpWfXompYYQgs3F8tgNF+KyxIJqgfIDxxh/imI//P/EG6xV1d7a0XCUC8HXvhgiEgHal+vcf4ELlFP4lYqV3uS3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wquDiPrXA8NTY89MvVzMtunMkzjUKq6uxThFdRJWmO8=;
 b=cg/xGd1XZFcYwd49ib4qlbbQqcF8EnFwbkR+beZTFkM1UyJXpYHw8Tr/8MTnhiPOAnZFZEz/46V4HLTHUNzs9oLvL6VrZwfN6lwoHmZmeSnCnzRb2mKOJjQPH+2wUwpo/UIaWiuxBEM01yIs4cFBcl0yRysvK9lJxBju7lsoFHHFjQzK7mkzJDDHByFApBJbjnKy4KPGtQxUde92Rv9VNCtDCOlGG6zNMtxvQ1lme32lrFKTT7pXlIdfdTUkpRB4dieGOlzclfjIZP+GXcinY+gaZnis2wgDGfpOXIMaWSQr4Lf/vWwARD602PzcQ1x0UYJ/bXpcKQ9Tm8tLMwU+FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wquDiPrXA8NTY89MvVzMtunMkzjUKq6uxThFdRJWmO8=;
 b=Y1zOAHPwag53s4y1r1/l1xjtii4dtkuUvoxjP08GZgKv7MUCIAoCStVxKdZz6Sj5lHZPIxPVJg6EDj3opu/511kvx8x32cQYbUnPAwY5rCRIyT1GCi8IqNvvLmpbbXhMS0EaMZkU+1Ttip5CVwpF5bAx8fduxn+/SXFXQV042nU=
Received: from SN1PR18MB2301.namprd18.prod.outlook.com (2603:10b6:802:28::28)
 by SA0PR18MB3469.namprd18.prod.outlook.com (2603:10b6:806:9b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Tue, 20 Oct
 2020 07:19:01 +0000
Received: from SN1PR18MB2301.namprd18.prod.outlook.com
 ([fe80::80c1:ad02:2a2:afba]) by SN1PR18MB2301.namprd18.prod.outlook.com
 ([fe80::80c1:ad02:2a2:afba%3]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 07:19:01 +0000
From:   Javed Hasan <jhasan@marvell.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [EXT] Re: [PATCH 2/4] include:scsi:fc: FDMI enhancement
Thread-Topic: [EXT] Re: [PATCH 2/4] include:scsi:fc: FDMI enhancement
Thread-Index: AQHWnh/Z4E2ovOYNwUWiFfrEYCAw16mfHE2AgAEHdsA=
Date:   Tue, 20 Oct 2020 07:19:01 +0000
Message-ID: <SN1PR18MB23014AC47337DC3867BAF20FC71F0@SN1PR18MB2301.namprd18.prod.outlook.com>
References: <20201009093631.4182-1-jhasan@marvell.com>
 <20201009093631.4182-3-jhasan@marvell.com>
 <7207E967-5713-4F67-8F06-7EA25C206F84@oracle.com>
In-Reply-To: <7207E967-5713-4F67-8F06-7EA25C206F84@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [43.248.153.192]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9070806e-761a-4e20-ef95-08d874c86b72
x-ms-traffictypediagnostic: SA0PR18MB3469:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR18MB3469F0DC67327FAD564E72ABC71F0@SA0PR18MB3469.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YOkgQLnSlsCYMl10LQb7XFa5jx+EE7p7SI5NrEzaBOU7sMkqFYML0V6AZ6XB9CLn9X+jFybgk02tD5V/toEWSeL2W3RKF4TlEwz/bgTHJ1J9dgVajNoip6v0/euH69gerhbSTaEDkR3f5jW24W8dz9cJL71sG6GfpRutM2ZA0uIrr5zumU4DuC0BdK8VSlsnvnLAhDrIclMjpbH7ctJYdp+/2QXxElgdImJU2mxutE6WSK9HImysjO2QHc7RTp1V0QAgnvVVpFMAesb2x5YUr//AiWkoLJBo1TC91kDDynpGIl5/+3zkE8/inmJhfTS911BjArH+W/gzL+Kgs2ko8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR18MB2301.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(366004)(346002)(396003)(186003)(6916009)(107886003)(71200400001)(9686003)(83380400001)(66446008)(2906002)(7696005)(76116006)(66556008)(66476007)(64756008)(66946007)(6506007)(53546011)(8936002)(5660300002)(26005)(316002)(55016002)(8676002)(4326008)(86362001)(478600001)(52536014)(54906003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: erZ+Z8R/9QtpOqobNd6k0bVyEtwQVMd917gEY4j6u4F/zLOQZIavrWFhQy30vC/1tpO0htN0h7m6k/T3ZSBZrAmAbmjD/nn1Ya78WcxmO90NJapbtFI/hWxUK80/lfaiSmN+KsifNsro+SURQMOpO0m3SDkLpqbT7yfBa55VrtxfErQWUO+mGdMzQtWRDX/fHawGJpN5HNOzk154eSIwUKUVCMstx5LuunqRO13z5r+qijxsFfEj3TLb5Q+NIYA8et4ssGSG8Y2hHxupbq4bB4/+XwA9KkHCDwSfnvVzimTr3TpWu1N+XAjuFCRN6h7PIxQjtTaDideDf45qWgBV8OHC1MFksgK9A3Mv/54EAZVxQ04qwmY9QGYpkIZSI3qntgM8Hj2c/6dOaLOu3hCgO4Dld/CFzMRFt2SPOho49IUhqHUiTYNuljdu1ZW7ESY6x3/fK6R+zb4oNfm1d/IVnjzEW7DtRO5HK1JypX/DYDnG2+cx3g1nU9cUFCQgYhGrm3Q2WOOK3RJcQjMdVXfckE5IeJU+Mbg01ywwLTorlBKDLAwbpmB1iYV/ea5Koq+oUM9MFzIeiDT2PBICQsHDF24fed0a5xGO7Md2JkdzzjSdCThJWHwUoTBBybOacyPhx/3K6B65sTA3aJzjrqOcSg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN1PR18MB2301.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9070806e-761a-4e20-ef95-08d874c86b72
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 07:19:01.6581
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qWMRfHvUDQiLoI0w1BLzPEg1ZaY3MkroNrRmqdb803fsN71o24oakqT62Yd5q0/PnkzuLWuRvCZvKTvM5eoxQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR18MB3469
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-20_03:2020-10-16,2020-10-20 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Himanshu,

Please find my response inline.

-----Original Message-----
From: Himanshu Madhani <himanshu.madhani@oracle.com>=20
Sent: Monday, October 19, 2020 8:57 PM
To: Javed Hasan <jhasan@marvell.com>
Cc: Martin K . Petersen <martin.petersen@oracle.com>; linux-scsi@vger.kerne=
l.org; GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [EXT] Re: [PATCH 2/4] include:scsi:fc: FDMI enhancement

External Email

----------------------------------------------------------------------


> On Oct 9, 2020, at 4:36 AM, Javed Hasan <jhasan@marvell.com> wrote:
>=20
> All the attributes added for RHBA and RPA registration.
> Fall back mechanism is added in between RBHA V2 and RHBA V1=20
> attributes. In case RHBA get failed for RBHA V2 attributes, then we=20
> fall back to  RHBA V1 attributes registration.
>=20
> Signed-off-by: Javed Hasan <jhasan@marvell.com>
> ---
> include/scsi/fc/fc_ms.h | 59 ++++++++++++++++++++++++++++++++++-------
> 1 file changed, 50 insertions(+), 9 deletions(-)
>=20
> diff --git a/include/scsi/fc/fc_ms.h b/include/scsi/fc/fc_ms.h index=20
> 9e273fed0a85..abbd6bacc888 100644
> --- a/include/scsi/fc/fc_ms.h
> +++ b/include/scsi/fc/fc_ms.h
> @@ -24,6 +24,12 @@
>  */
> #define	FC_FDMI_SUBTYPE	    0x10 /* fs_ct_hdr.ct_fs_subtype */
>=20
> +/*
> + * Management server FDMI specifications.
> + */
> +#define	FDMI_V1	    1 /* FDMI version 1 specifications */
> +#define	FDMI_V2	    2 /* FDMI version 2 specifications */
> +
> /*
>  * Management server FDMI Requests.
>  */
> @@ -57,22 +63,36 @@ enum fc_fdmi_hba_attr_type {
> 	FC_FDMI_HBA_ATTR_FIRMWAREVERSION =3D 0x0009,
> 	FC_FDMI_HBA_ATTR_OSNAMEVERSION =3D 0x000A,
> 	FC_FDMI_HBA_ATTR_MAXCTPAYLOAD =3D 0x000B,
> +	FC_FDMI_HBA_ATTR_NODESYMBLNAME =3D 0x000C,
> +	FC_FDMI_HBA_ATTR_VENDORSPECIFICINFO =3D 0x000D,
> +	FC_FDMI_HBA_ATTR_NUMBEROFPORTS =3D 0x000E,
> +	FC_FDMI_HBA_ATTR_FABRICNAME =3D 0x000F,
> +	FC_FDMI_HBA_ATTR_BIOSVERSION =3D 0x0010,
> +	FC_FDMI_HBA_ATTR_BIOSSTATE =3D 0x0011,
> +	FC_FDMI_HBA_ATTR_VENDORIDENTIFIER =3D 0x00E0,
> };
>=20
> /*
>  * HBA Attribute Length
>  */
> #define FC_FDMI_HBA_ATTR_NODENAME_LEN		8
> -#define FC_FDMI_HBA_ATTR_MANUFACTURER_LEN	80
> -#define FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN	80
> -#define FC_FDMI_HBA_ATTR_MODEL_LEN		256
> -#define FC_FDMI_HBA_ATTR_MODELDESCR_LEN		256
> -#define FC_FDMI_HBA_ATTR_HARDWAREVERSION_LEN	256
> -#define FC_FDMI_HBA_ATTR_DRIVERVERSION_LEN	256
> -#define FC_FDMI_HBA_ATTR_OPTIONROMVERSION_LEN	256
> -#define FC_FDMI_HBA_ATTR_FIRMWAREVERSION_LEN	256
> -#define FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN	256
> +#define FC_FDMI_HBA_ATTR_MANUFACTURER_LEN	64
> +#define FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN	64

These below value of 100 seems odd. How did you decided on this value?=20
<JH> In libfc we do have logic to split FCP commands but not for CT command=
s.
         If I am adding all attributes of RHBA then total length is going u=
pto 2750(approx),
         Which is far more than 2048 and that is causing problem.=20
         Practically all version/names get covered with in 100 bytes.

> +#define FC_FDMI_HBA_ATTR_MODEL_LEN		100
> +#define FC_FDMI_HBA_ATTR_MODELDESCR_LEN		100
> +#define FC_FDMI_HBA_ATTR_HARDWAREVERSION_LEN	100
> +#define FC_FDMI_HBA_ATTR_DRIVERVERSION_LEN	100
> +#define FC_FDMI_HBA_ATTR_OPTIONROMVERSION_LEN	100
> +#define FC_FDMI_HBA_ATTR_FIRMWAREVERSION_LEN	100
> +#define FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN	100
> #define FC_FDMI_HBA_ATTR_MAXCTPAYLOAD_LEN	4
> +#define FC_FDMI_HBA_ATTR_NODESYMBLNAME_LEN	100
> +#define FC_FDMI_HBA_ATTR_VENDORSPECIFICINFO_LEN	4
> +#define FC_FDMI_HBA_ATTR_NUMBEROFPORTS_LEN	4
> +#define FC_FDMI_HBA_ATTR_FABRICNAME_LEN	8
> +#define FC_FDMI_HBA_ATTR_BIOSVERSION_LEN	100
> +#define FC_FDMI_HBA_ATTR_BIOSSTATE_LEN    4
> +#define FC_FDMI_HBA_ATTR_VENDORIDENTIFIER_LEN 8
>=20
> /*
>  * Port Attribute Type
> @@ -84,6 +104,16 @@ enum fc_fdmi_port_attr_type {
> 	FC_FDMI_PORT_ATTR_MAXFRAMESIZE =3D 0x0004,
> 	FC_FDMI_PORT_ATTR_OSDEVICENAME =3D 0x0005,
> 	FC_FDMI_PORT_ATTR_HOSTNAME =3D 0x0006,
> +	FC_FDMI_PORT_ATTR_NODENAME =3D 0x0007,
> +	FC_FDMI_PORT_ATTR_PORTNAME =3D 0x0008,
> +	FC_FDMI_PORT_ATTR_SYMBOLICNAME =3D 0x0009,
> +	FC_FDMI_PORT_ATTR_PORTTYPE =3D 0x000A,
> +	FC_FDMI_PORT_ATTR_SUPPORTEDCLASSSRVC =3D 0x000B,
> +	FC_FDMI_PORT_ATTR_FABRICNAME =3D 0x000C,
> +	FC_FDMI_PORT_ATTR_CURRENTFC4TYPE =3D 0x000D,
> +	FC_FDMI_PORT_ATTR_PORTSTATE =3D 0x101,
> +	FC_FDMI_PORT_ATTR_DISCOVEREDPORTS =3D 0x102,
> +	FC_FDMI_PORT_ATTR_PORTID =3D 0x103,
> };
>=20
> /*
> @@ -95,6 +125,17 @@ enum fc_fdmi_port_attr_type {
> #define FC_FDMI_PORT_ATTR_MAXFRAMESIZE_LEN	4
> #define FC_FDMI_PORT_ATTR_OSDEVICENAME_LEN	256
> #define FC_FDMI_PORT_ATTR_HOSTNAME_LEN		256
> +#define FC_FDMI_PORT_ATTR_NODENAME_LEN		8
> +#define FC_FDMI_PORT_ATTR_PORTNAME_LEN		8
> +#define FC_FDMI_PORT_ATTR_SYMBOLICNAME_LEN	256
> +#define FC_FDMI_PORT_ATTR_PORTTYPE_LEN		4
> +#define FC_FDMI_PORT_ATTR_SUPPORTEDCLASSSRVC_LEN	4
> +#define FC_FDMI_PORT_ATTR_FABRICNAME_LEN	8
> +#define FC_FDMI_PORT_ATTR_CURRENTFC4TYPE_LEN	32
> +#define FC_FDMI_PORT_ATTR_PORTSTATE_LEN		4
> +#define FC_FDMI_PORT_ATTR_DISCOVEREDPORTS_LEN	4
> +#define FC_FDMI_PORT_ATTR_PORTID_LEN		4
> +
>=20
> /*
>  * HBA Attribute ID
> --
> 2.18.2
>=20

--
Himanshu Madhani	 Oracle Linux Engineering

