Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93384C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 23 May 2022 14:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237094AbiEWOVT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 10:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237101AbiEWOVA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 10:21:00 -0400
Received: from smtp.digdes.com (smtp.digdes.com [85.114.5.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C03117
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 07:20:57 -0700 (PDT)
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by relay2.digdes.com
 (172.16.96.56) with Microsoft SMTP Server (TLS) id 14.3.498.0; Mon, 23 May
 2022 17:20:55 +0300
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by
 DDSM-MAIL01.digdes.com (172.16.100.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.12; Mon, 23 May 2022 17:20:55 +0300
Received: from smtp.digdes.com (172.16.96.56) by DDSM-MAIL01.digdes.com
 (172.16.100.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2375.12 via Frontend
 Transport; Mon, 23 May 2022 17:20:55 +0300
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (104.47.2.51) by
 relay2.digdes.com (172.16.96.56) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Mon, 23 May 2022 17:20:54 +0300
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eHZcjIOhKIDU5VvnvQ1q6abOwUDFQQ+sVEUJlqFe+68ildBiTrmN0RyDQSH+irZKU8V8GJVxqrwIaH/HtLcBSnB4YYcQDF/dAXwwpqjzI19qysMmbqIRn/v/QWhHP+T/rX1wf/wgYEwjaaKsZmttr2sBC42o6OoOPs8B8a7L4SJmoXWozZ3JmE27LdtrrXKYBjxmLuyMLl7Xm9Rmv9RYA1W6mUtrXiFVrEDBhQFLuLu5GMoEth0koHFBtFn28v9wHSO/RYP3NIF27tNlyT/27hjCagipyH/OuBJ4St6JcPZ7B+2zMpfrOSMXOI+ir0AP06jHmfbBI44/pn6dCOAT6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HsKc7bz0laLxtni+XgiM5Aa8OUM2ZtEm7KdN+vts5lE=;
 b=LVn8+gYm6FZ69JroXB2+6pFzfajR/+qOEEQhlXodb7D++fdf0r7iLDTmT8VGEkjEn7+iwt3elGgQh799G/5Em9O2DTGGeoiuOwUe4quwbsMWHuwjgCGWkceMse0LfDtmWWh/pL2d+zHFaGPxtabz8fSxOTneAL4aj2v9FyD1X/pV1PrLR6/fMADtRIeAC1JvluqeUsIhpHtrd46zxziDvd80WUElOBlFEkNUf7zRbJ7vncbFie7+ukMcyrQo612S0x4p6FIBoart95Vm2riB/S/NfQJkdstckk2zhkeJ5n0FPM1XKP6BM3oi0edn7IC++kYd4NopfB40RDM+7y5WEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=raidix.com; dmarc=pass action=none header.from=raidix.com;
 dkim=pass header.d=raidix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=digdes.onmicrosoft.com; s=selector2-digdes-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HsKc7bz0laLxtni+XgiM5Aa8OUM2ZtEm7KdN+vts5lE=;
 b=YmEmuuiurogIYFnK10hhwfHJI6FlcsNbTthSsCoQglhBcfOrrZz9igJCvLBhy0BP0YOfgb94kxk6i0LAc0fa2a1RK3gZNMbln0Smzzps6NtTV3bhyIjiCbYOPQKSFJfVuMXKkkEJ8stZLs6IMkl5ihKQ0CNWlolkpbGGVN2cBmk=
Received: from AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1ff::5)
 by DB7PR10MB1929.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:5:6::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.16; Mon, 23 May 2022 14:20:53 +0000
Received: from AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::6047:e205:1bca:5d29]) by AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::6047:e205:1bca:5d29%8]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 14:20:53 +0000
From:   Chesnokov Gleb <Chesnokov.G@raidix.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/1] qla2xxx: Remove unused ql_dm_tgt_ex_pct parameter
Thread-Topic: [PATCH 1/1] qla2xxx: Remove unused ql_dm_tgt_ex_pct parameter
Thread-Index: AQHYbobah7S1K+EECUWb/HaurQb5x60sgrbT
Date:   Mon, 23 May 2022 14:20:53 +0000
Message-ID: <AM9PR10MB4118C108A0DFFF23D790BF8F9DD49@AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM>
References: <AM9PR10MB41185ADE95B92B4E6926BE639DD49@AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM>
In-Reply-To: <AM9PR10MB41185ADE95B92B4E6926BE639DD49@AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: b3ee7050-d80c-ee3d-a1e1-a831a5ff499d
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=raidix.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ccfac801-6d89-42fa-9d31-08da3cc771da
x-ms-traffictypediagnostic: DB7PR10MB1929:EE_
x-microsoft-antispam-prvs: <DB7PR10MB19294C7EC5735E436F11E3FC9DD49@DB7PR10MB1929.EURPRD10.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZgsUGkodxcwV1IsYdBl1+IiM6rPzg/x/8Tlrg9SUY2O6htGD07u3ryLFc3LvahGLLrF2ClOuqDY1gMDpvAH3+wwTQbOox/Ci1qaIFRqPmTMD+hNKHUe8ZJzcuENJIldx19B9PBKu9MGixLsC4aiUA6cTzL4biswNIfNsqLGojP65/tytpCcSn0Xu4j3zssRvNc+9445P9gA1dR1S4Ww0xphPA7GLiUMFk7E5Mf1DckmO8nVLwhYcgHYy3O1wzL9nKsSgEZGdmTFHTZtXdWVf+d/ayCIp4EKSb2r3C3G48YR1rI0wdaQCPO33bNGrP16QiZiOYryWf7ofb01hDrAiJotUnORNo/Jsq7VRCEbRwI9R+sRZr+DHHf+RPbGWSu31HD5MOsqhSA/h5tMSiUpckWBniyj14rh8LM1C0NIZ5ms0X68TP6AO/NN/oFaJZMxmQVfmHhCf2dKNHXuSY+zVRQeZZNGoFsM+JvG4fcUkXkEfAK2F0Yrn5EXjte6qGM56V0FH/xN3FUuYucNbFuaA+yoAT5sRASaiIZmROA4UoZZ3da/PpA2Vxw30msEKPhD1oeN1MwPuYrzRTxDNpBtdvZxOJKKVRrRW5Aun5LdW0/eHlY8xr3UJqIsb0pp59CYOhvBU+5S7IzH23MrtGndBQpsMjzw2ELq3VRIQVo+KRA3+01dPdyRvvAtfy/okBf03kpXVIcrVtzRpFftLhNdjUQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(8676002)(66556008)(66476007)(64756008)(66946007)(66446008)(83380400001)(55016003)(52536014)(38070700005)(76116006)(71200400001)(8936002)(508600001)(122000001)(2906002)(2940100002)(316002)(7696005)(86362001)(38100700002)(186003)(91956017)(6916009)(33656002)(26005)(9686003)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?lbKHK9D/nZrTyfzPPYSGEW7Ah1uuS89h4/XRRsxyeTUC+kv+sW2BUEKhz/?=
 =?iso-8859-1?Q?JaFHgJI3P6GIhn2D3IE4KrZzQdveOZewMgMolyb03LQPoKu4lPUvT4OUPM?=
 =?iso-8859-1?Q?ETAnTbzkERb0btIK4wcGJ9440qV/sOZp5b1nvoFnWPUQvJMxjRWnKvTIBE?=
 =?iso-8859-1?Q?Gs6ozBr0z50aiCBTiIUU8foNvu3jXWKv/E63Bqugmx7Jd3HBQOQNPFis9E?=
 =?iso-8859-1?Q?7N0DDLtZDUgo21zdY3w6JnW7cBj8L2d4YJHzET+dgWsIy9fxWEsMqVe7AO?=
 =?iso-8859-1?Q?7ptCLfH2ggkG7lNpmEzPiPoz9MxiFiGjH2ejRo8MZM/vkCfdsK1jbTTOUu?=
 =?iso-8859-1?Q?hntYSzbqxwSewlVrDTZ6uqDP6FtyaYfZTA9GjgJOjraLNscBZeMRsf2czZ?=
 =?iso-8859-1?Q?koK2S5jkJKG+TrJZ1zNiXGmBeDeZe9CIBGuHIZDsTQzEWDbvgw9UFi+y0X?=
 =?iso-8859-1?Q?YX7lJNTaXfTr3kCcpIAmy+Bb2lhfzAedm1AgK5fKXa0qL7rlEuXGhqhpfd?=
 =?iso-8859-1?Q?wg7JZhSTyQ31yyDclchVwUQ6KoPUiQoaEy2C/AjYBFMC4wTkjHRE9DMRHZ?=
 =?iso-8859-1?Q?LHGGyuF2t9lybWL6u73R7UQRHRHEMYmgyi0eVya44neAisLSQPPSA6E2HR?=
 =?iso-8859-1?Q?Fprb5Bsq37vLWjYD2JavjALT1dqSqSIumMw573yiMFOLh5TYeWnNVWhyhp?=
 =?iso-8859-1?Q?zmVnMDxjG5bNZVzvQaJNNS5EocdTi46RS7Q5SONDodZ0Z5PdAoBCRFYJGJ?=
 =?iso-8859-1?Q?MzsOftxu4/GUHZA2RW0TO6tXAFqGgKVThoZy0QArMTMSWunBFrm7xcL/cA?=
 =?iso-8859-1?Q?hEjUug98oQYeSJUFSGAJk2cvA4SfRyXce7rrMsd0bNq8eEjCPavwLnRjY+?=
 =?iso-8859-1?Q?sRve5or4/B4Foyp7VlP1XGF2QJI/VYC2b7XMU4kkeCkf9WIp6wyFaQ1STy?=
 =?iso-8859-1?Q?1cRgr9lq76ty1ePg0PzoDiq3h/I6/7WtIOvlr9lU41PFYcghzX9bAM1xjT?=
 =?iso-8859-1?Q?AWV7ynwqMjjaO4nuxbtxL7HKsR79gZ3pUwWMrCzRToBhgAKKJy+D8Jqw10?=
 =?iso-8859-1?Q?l4xEtSAB6NOv51vB/dIqNJEQo1rWcwEpsGxOnBNxKXW3GHR6JUb/geOBMJ?=
 =?iso-8859-1?Q?jploFC6f1y93GmrTddNCUTNCACIBjrT0bILcMcEcuXiHl6CSYNuVel8DLq?=
 =?iso-8859-1?Q?6P2RgbtY3CDuqYKrn1NJZaowQKOboSN7Qc4Idevgi8WgeTQCY15y30hA86?=
 =?iso-8859-1?Q?aXimNXYmfe7YxfAvK4AKgHQQ0RmhS/GiJW3D9a0F8/rZvldzAqR15yNW+h?=
 =?iso-8859-1?Q?stOKKXhVajjN5F1+i6X0Jl6ufcyiGuZ901tWUY8AFw14bNm9Fgs2Daz0C0?=
 =?iso-8859-1?Q?g3Sx8J6Kp5EwPSHdPE///rSozY5hP22TWHTmM7vUKM6bp1UVD1iOUWqNc/?=
 =?iso-8859-1?Q?5rnB6QD4U71KAUfwIB1BiPisrGgmNnoo1WTNCtHARV/GXP32ryOF3PTtkY?=
 =?iso-8859-1?Q?deDANZ9vJnOmUOUT62glNO7eNnkDQYkVx5T86+Lf8PTxE9bakdM/knpC6l?=
 =?iso-8859-1?Q?ltBMTuIXFVLhONOU1/BwT4dv6Jo+p+TpEjq+H2iDbZ+ExITd/iXrZaSWZb?=
 =?iso-8859-1?Q?8lI7FBODT11zXgpUas2oqoD9R84iahLOkyOD8n3puMt9eTZcQGudPfP7Yy?=
 =?iso-8859-1?Q?MRMJeCgFWGZZs7c8yc302RgvhqGvR2gshkyDpu9HVoxfMC5u1KnFoWvzrh?=
 =?iso-8859-1?Q?gkBHJNILfR4CpZi7cD9PEccCJJ1d+C0zmc4A07EKvkZey1yvX/9cUUjGUT?=
 =?iso-8859-1?Q?/tdLRFxzIQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: ccfac801-6d89-42fa-9d31-08da3cc771da
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2022 14:20:53.2501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70c55e28-9cd7-4753-937e-c751128a9d38
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oPmfRm9O0vOiR/kGwALBh79SWomFn2hgqP0sVTouaT9Y26SNCUunF+JRCrG+4o/ruUzZ3UimKr8H4tSUJ5dJdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR10MB1929
X-OriginatorOrg: raidix.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> The ql_dm_tgt_ex_pct parameter was introduced in commit ead038556f64=0A=
> ("qla2xxx: Add Dual mode support in the driver"). Then the use of this pa=
rameter=0A=
> was dropped in commit 99e1b683c4be ("scsi: qla2xxx: Add ql2xiniexchg para=
meter").=0A=
>=0A=
> Thus, remove ql_dm_tgt_ex_pct since it is no longer used.=0A=
> ---=0A=
> drivers/scsi/qla2xxx/qla_target.c | 7 -------=0A=
>  1 file changed, 7 deletions(-)=0A=
>=0A=
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c=0A=
> index 6dfcfd8e7337..d03b9223b75e 100644=0A=
> --- a/drivers/scsi/qla2xxx/qla_target.c=0A=
> +++ b/drivers/scsi/qla2xxx/qla_target.c=0A=
> @@ -48,13 +48,6 @@ MODULE_PARM_DESC(qlini_mode,=0A=
>         "when ready "=0A=
>         "\"enabled\" (default) - initiator mode will always stay enabled.=
");=0A=
>=0A=
> -static int ql_dm_tgt_ex_pct =3D 0;=0A=
> -module_param(ql_dm_tgt_ex_pct, int, S_IRUGO|S_IWUSR);=0A=
> -MODULE_PARM_DESC(ql_dm_tgt_ex_pct,=0A=
> -       "For Dual Mode (qlini_mode=3Ddual), this parameter determines "=
=0A=
> -       "the percentage of exchanges/cmds FW will allocate resources "=0A=
> -       "for Target mode.");=0A=
> -=0A=
>  int ql2xuctrlirq =3D 1;=0A=
>  module_param(ql2xuctrlirq, int, 0644);=0A=
>  MODULE_PARM_DESC(ql2xuctrlirq,=0A=
> --=0A=
> 2.36.1=0A=
=0A=
I'm sorry, I forgot to add Signed-off-by: Gleb Chesnokov <Chesnokov.G@raidi=
x.com>=0A=
=0A=
Best Regards,=0A=
Gleb.=
