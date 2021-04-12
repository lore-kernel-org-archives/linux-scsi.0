Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BE9C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 10:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B9326101B
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 10:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239343AbhDLKbv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 06:31:51 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29274 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238970AbhDLKbt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Apr 2021 06:31:49 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CAUjYU001634;
        Mon, 12 Apr 2021 03:31:27 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 37ubhqm3kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:31:27 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13CAUpqW001685;
        Mon, 12 Apr 2021 03:31:27 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by mx0b-0016f401.pphosted.com with ESMTP id 37ubhqm3kq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:31:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GAAbEeCmJgX/iMzQ/QPS/fQWGyan6++rhINt2y/C6jBQDj+aENY9jIhefhGFaGcXUMA/frmuyo3PLsgeGzxQ/FjhxMGqJQ7BeCAz2O1NqAFUWSJ4fNNRhslcsJyjOf6+sfwFneSbRtsq/rDiQ2kFNu3F2Wet4Neh4TZr+Lm1HnvF8cAtnBB+ONbRCvb7ksQAFHwfsFBrwLMRJX8SaZd52j/qmuQvek2R2XTXtGuI6NpL21uW7vlKzs5N7pjHDQBozP/nKd+KhGFsEsjJvEO81EhD8cTokIQeYVsYtyawOQ91m5jsf1ypsqB1onymxxogaT3w3jTrCINHKrAk4hNdzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KqM34CETAk1nAe5hUiPlYXG//OLZuc7tV2UCgX1uI/w=;
 b=lSpDBi4/IF1SDtFwaXun01Jzowa1jquHmYkyeuuNU7UW1YAe+M4+lBAtLVk0pHDLHnb/tgHsz9mBgLyLHIUb0fQzhXMVrfJjjswF1P61mNkio15h4Jt8UYB/OIwMB2Iml20WXWBW4onnnMGiph9AkSiE8lFa77yGnnziGvfi9eS8WheV8jia3y34z5Ud0nMtJv4kiBX4tQgqcNjDPtFkjHc1+mC8MnzRywMmlTnYo+K6M8uVpPzEzRqYIYyAdo+PPE9Eay3oyU5XrNmXDQcsaCNHcCQ/Gj0YY//ykGUCRyV0iH3IFvWlS7qG5Hk5XSYCplk44iZTXvonxvFcodA/PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KqM34CETAk1nAe5hUiPlYXG//OLZuc7tV2UCgX1uI/w=;
 b=c8ua9s5aGlg7LBGuYZ56FsVsutbAFiJKfgI8KL/yc3zDaoIyK0vehYm9Uyjnsiugh64xtXltGIG0H4KpbLLQr+OXDqRUqFqoVWTA67bBVHbxmGmTgbfIqGdQx0o/rf9E4ZHWnZdhE3gqkVSQ5HjvPgFADnAwB/RcVLdii1NaTck=
Received: from BYAPR18MB2998.namprd18.prod.outlook.com (2603:10b6:a03:136::14)
 by BY5PR18MB3348.namprd18.prod.outlook.com (2603:10b6:a03:1a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 10:31:24 +0000
Received: from BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621]) by BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621%4]) with mapi id 15.20.3999.037; Mon, 12 Apr 2021
 10:31:24 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Santosh Vernekar <svernekar@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: RE: [EXT] [PATCH 09/13] scsi: qedi: fix session block/unblock abuse
 during tmf handling
Thread-Topic: [EXT] [PATCH 09/13] scsi: qedi: fix session block/unblock abuse
 during tmf handling
Thread-Index: AQHXLjkCfW0cpbBkHEy5yiPDOI6lbaqwsXKg
Date:   Mon, 12 Apr 2021 10:31:24 +0000
Message-ID: <BYAPR18MB2998F8F875F0D2749A38D60DD8709@BYAPR18MB2998.namprd18.prod.outlook.com>
References: <20210410184016.21603-1-michael.christie@oracle.com>
 <20210410184016.21603-10-michael.christie@oracle.com>
In-Reply-To: <20210410184016.21603-10-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [34.98.205.117]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6475161-61e1-4b4c-76c7-08d8fd9e1f1f
x-ms-traffictypediagnostic: BY5PR18MB3348:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB3348B9579456730E92FCB809D8709@BY5PR18MB3348.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ev485DGJXm+wR2JbShLYXRAlZiLefhWFgGsylh+zyO4WDfQwbqBi+uwKybz6AecGFHemEdWgTUOoTTbXJsEVhux6opZ+uVEpZtD9nDohgNY49Cw8VlwjX839cPs0ZGlLLPYQBE512UYNUa52KosSQ/oBhzjUKVNMuIHjDlzk/jCaiflGrV2cmDpiQ7MEiATJclx8dwrUV86K7yyeqNK20MFgGfjbpZBI7yKL+JlhGV6YxnlgS0oU8ITtjkGJgxj5jBiqXHfDmdf5xkUzoqdGPcaI10aosMQzslQXYqO8Btq0D/ecc67nKT6pukMmR6q/4pzjn2VfcLrev8G+APSllO7o5/iqagP5qjLhwG+uU1SsonB5RFoErbnrfFys3W2gXHsEDvVKryH1EQH7UbbJxg7LoLZPuZ852y1RoBNwaJh3ixwNZFiG8mz73gfulFZG90xwHncXHX1GaqueMTA7ZXv0PMcCi0A5g1q2wakmvnk6fkRxiMrLJbVH0Ax0D0IzRlGVw9YG+9dmmkFEZw17kN5swuWuA1ugGvXwdQmbyEDhtmTD8icFRzVrnjcFy7HQVEMYNGQt3G5Pelru1M+eAY797IDTZKXXXC8dYGCkX8E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2998.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(376002)(39860400002)(136003)(316002)(66446008)(66556008)(55016002)(6506007)(53546011)(66476007)(52536014)(33656002)(8936002)(86362001)(186003)(76116006)(8676002)(83380400001)(26005)(38100700002)(9686003)(2906002)(110136005)(5660300002)(64756008)(66946007)(71200400001)(478600001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?uBbqPuVXkldfDNx/yEjbaEtqmYl0EGZDj9J7b2THT7yPhgLpd5M+FaQnX0ZS?=
 =?us-ascii?Q?h2pAI5+B3J1AbdQGiIehivulRe5sesM1fpKTjQgK8ju5BO5/ysIZesHd4RLD?=
 =?us-ascii?Q?jTTPFg7kgOYBExiMI4RUhxw5Uwt+2QmWwhGEgC9aKkBWPXok6X2ezPipL2Wq?=
 =?us-ascii?Q?n2MBm/ryv5IlRZN7oFsKlfLPwfQsXpGyq7msuNLSDmc2A+vEUi/4rMq5JlCw?=
 =?us-ascii?Q?t1NHt/UxMJfO218QOier3GGSJajaATh0nwSeECixvmhyyMAxUfskduKLoqDq?=
 =?us-ascii?Q?u8oMYMljy9BR2G+XnZFuBzuzlA+oMjoSHfvYPXykYREFfbjK49BruXClTXr+?=
 =?us-ascii?Q?0rd3mG9wTIVPKfsvKpyeU5IFtCwqHO0BNtrNAkSwY9MuQmuFwijecIGaPd5T?=
 =?us-ascii?Q?0d8n4Rh0f4HQBHYQ0QtmJ3zKN6GlELdy51BSjggflNNiktCfcj7M0CDAfZVF?=
 =?us-ascii?Q?o4zy1CR3GCZYi1f3w8cIqAQwrqOxpMiwDlTYmBhbv+1unrrlBLRNTkKh8bZI?=
 =?us-ascii?Q?Kzrpw9C45EB4YnUIw9TxhqYq4CDDhwk+Lxz4c6salveVqkYL6103eetxOf89?=
 =?us-ascii?Q?xj8hrDmdt1aKvT5srXZFUGBWY6TARSQJNgCbF4ZRBDbM1HtDEteTGVcJBaBe?=
 =?us-ascii?Q?RPwDCQJoFO5ERo0Hm2Aj1R3HAj741jOEOXqSOYG3QPIc4lxlaGshH/C00Yz7?=
 =?us-ascii?Q?M6iW18Zqn3BeywAX4MdCTjb/A7dpXvIHB+81z/nsNbNZdSl9TJsOvCOOUvIS?=
 =?us-ascii?Q?R0KlAXDL1wHsXvqqJvESdzaKJ+wTJhkgMTVNhhhw05ckI3Q6WublnWu07cPx?=
 =?us-ascii?Q?4nl0zJAKs1IL6Xxd/WF4CHVbt1B5Ea7krLPsuHddY3kr3l1BHz8jiguFkHPZ?=
 =?us-ascii?Q?s4WLmuCu3wy9MxzH2gUeGKR4Y9aUIcPJK+WTjwIxhvBqeUBfbemO8xtuHBon?=
 =?us-ascii?Q?qR0Ap7khhnWnOxZFk1YKj+XhsnqdqDpiqycJHuOWURmm0wFQprHdfTk25pFw?=
 =?us-ascii?Q?phrJ/ipDBkPqeDKuM2Az4ww/g4Gsu4ZlfL3/Q/kRhIy64oGDJsonV9rA6UWr?=
 =?us-ascii?Q?MnNJFmm6/N9x4Wn0+YESiiUFv/W6XokJeap6Nf7dYiMyQl2IwkCBA/nScO9V?=
 =?us-ascii?Q?NWauHKPwDJ3T/vM48FyW7xNQsx9mo97K37ievhGx/JtuZkdhGGOEBN/b4MFw?=
 =?us-ascii?Q?YfOD04ulsmdcKdgQR6s8sqTiYSUS2quuG7vf30HCkeYblDIRKBOA+FmrVctc?=
 =?us-ascii?Q?rKye26GDkJ8ePyfaJv2IpFylbq4JcoBeYEdqDOWVRKRXUU56KkNNWUz7ZlYy?=
 =?us-ascii?Q?3FPW4g3tv9GAFBJnIr/MuT1h?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2998.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6475161-61e1-4b4c-76c7-08d8fd9e1f1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 10:31:24.0501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FRgwyvzhxPtCdgPL7X5Xhu/jNx44e2zJqidh8TXPCTpt34Cw2LXb4L1oM4gff3C0Hd7Z0UWcuWFfac2i2QGcXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3348
X-Proofpoint-ORIG-GUID: h86iciOfAX1X4Jelq48TpU2yRz7AsdPR
X-Proofpoint-GUID: RU9PrAmSOf5ZAhdW-hjLp0Sd-pAfThBY
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_09:2021-04-12,2021-04-12 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Mike Christie <michael.christie@oracle.com>
> Sent: Sunday, April 11, 2021 12:10 AM
> To: lduncan@suse.com; martin.petersen@oracle.com; Manish Rangankar
> <mrangankar@marvell.com>; Santosh Vernekar <svernekar@marvell.com>;
> linux-scsi@vger.kernel.org; jejb@linux.ibm.com
> Cc: Mike Christie <michael.christie@oracle.com>
> Subject: [EXT] [PATCH 09/13] scsi: qedi: fix session block/unblock abuse =
during
> tmf handling
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Drivers shouldn't be calling block/unblock session for tmf handling becau=
se the
> functions can change the session state from under libiscsi.
> We now block the session for the drivers during tmf processing, so we can
> remove these calls.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/qedi/qedi_fw.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c in=
dex
> 84402e827d42..f13f8af6d931 100644
> --- a/drivers/scsi/qedi/qedi_fw.c
> +++ b/drivers/scsi/qedi/qedi_fw.c
> @@ -159,14 +159,9 @@ static void qedi_tmf_resp_work(struct work_struct
> *work)
>  	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
>  	resp_hdr_ptr =3D  (struct iscsi_tm_rsp *)qedi_cmd->tmf_resp_buf;
>=20
> -	iscsi_block_session(session->cls_session);
>  	rval =3D qedi_cleanup_all_io(qedi, qedi_conn, qedi_cmd->task, true);
> -	if (rval) {
> -		iscsi_unblock_session(session->cls_session);
> +	if (rval)
>  		goto exit_tmf_resp;
> -	}
> -
> -	iscsi_unblock_session(session->cls_session);
>=20
>  	spin_lock(&session->back_lock);
>  	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
> --
> 2.25.1

Thanks,
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
