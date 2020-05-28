Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CDFC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 13:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9FF9207D3
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 13:41:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="e5agzHWJ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="JHYQ02z8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390485AbgE1NlY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 09:41:24 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:40131 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390335AbgE1NlW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 09:41:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1590673281; x=1622209281;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hNOc8hDjxf52veFfYYbmOjA5mjcHiLSY+L9gUExg5I0=;
  b=e5agzHWJMRspdE2Yy+W8xiGudtvO7J/G1C5mXR8ZT+lXKRJqMHQ6OhfO
   bqewbA8eEY53qpRfihnrrsctw94zAxqcbFHj2o4085m65ArdC6jhZFxwd
   BJoJkopknlrL8rgtHf/xgTQ8E1I5NqodMIVsiWZAJbsacZFSgMeh9+R9M
   YewPVRVG9ooY1NAS/jRqWKtqN4F0r0SbFf2wBx8SNwN0gIpYixOMWtZJc
   xnd7n5C/p1d2PpgYhxqv52iempgdDKcTr1p4JmWAJOPXwC2O7hJAMem8t
   JjPS5KcC5TC8DltkEoRfu3b2xbPkrur1NEUBenjErEleowowJDh4TMmo1
   g==;
IronPort-SDR: zXbybdNbs7mo/zE1cUj9tFXTVC5gvlxad7HmpIalcLoxtr4LIE60SqQW/qPPR3y/v0NebpuAIZ
 XzyXPEKM8RP2nuOaJBOZKW40vj/irwEidV49xiALvh5D0wVkILVu/bkCP8vghcoUJS9RmoQWAT
 NStjPC9hVKrxY2po3/phzybnLlKORQMYGGPEuBZUE6KU2rXIOgGV+rGVbDDE+PV4fwTWcxuPts
 dnZ2KgcNbGHaYYQybpVEgv59kuEyuaj4N8joK1nz7O8rAySfKsLo5Nn04ojhCBH/OqMWsgxKZN
 534=
X-IronPort-AV: E=Sophos;i="5.73,444,1583164800"; 
   d="scan'208";a="138705417"
Received: from mail-dm6nam11lp2177.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.177])
  by ob1.hgst.iphmx.com with ESMTP; 28 May 2020 21:41:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=myT6/5zIFPFBdiyl07OBZ8kzxFrbMarWjdZY2xN8cJadas6MJOPinMV6E6tJTbwgXS6ILo8A0xEFDk9JdIKmapBeJyCO8FvXl2IfO0n24m/jGxzX+wwSJGZSeQYlvge0uuk4UMz+i597x/bOhAoTEMryrqdRB6QzLO3Orxi8YQVckzzFBxWaggEMrxLfCL1aalLXdyZDojPF2zyEQbU1D5r+GtSfxdkDRdv6fALFSngIfl8StjSC/Ga3MtzH4uvbQHdaQvxvABQDZyj4h26v+aR5K7QL/ar9TvFvDlKV0lrQoURfsAjN5/WNGo8wEuM8HQVP3l22Eji1LotIyXotSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZFUVOgrtovIiI0A6kUjnm+QnXs7V4PmFXgSMKKiR5gU=;
 b=G85NFVntt8j9eElHoT2C/q2HTng/dDvK6WjNnALfHqi8EUHDH9SGV484Pk+RGadd7InK+5NOP686YczN709p2g/NS6346Od9SpsZkFyCG+WwmGoQnCo1Kjr33WVz1BejjcI1JJR2rFWHMUDaxwRIpHE+Eh7ZeWwESw2ordn/g2JUufmQQ2Bt9YFGv7Xv1Rfen3tUJ0/F1oNi9Pf8svXcbRYl0nbA67LMoA4n2sCVxRpFZlVlXyCwQvcLNBfGSO5/G8F0Eot/i/J/+uRESyADl+SA75OwRtXQlAlVyMvukg3Iv2gOQpxovxZA+8jcPD5c3+HnDQq6XlJ9OhZ6eCKWxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZFUVOgrtovIiI0A6kUjnm+QnXs7V4PmFXgSMKKiR5gU=;
 b=JHYQ02z8ubcRoMbDCDaldoqVXNtfn8abSs0fx4wZXR2bXKIhLtgg4bMB4/YB2TeWD54MghZ/lSoImO8XkDs763MTsoRilbbxmh5ZDgly73jzVrbFwZ/R73zTmYK5qJ2MPwNsJZkjdSEZZMUyMBvLqKUJfSGJ98s2FgjHfTPZJgQ=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB3933.namprd04.prod.outlook.com (2603:10b6:805:4b::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Thu, 28 May
 2020 13:41:11 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3045.016; Thu, 28 May 2020
 13:41:11 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/3] scsi: ufs: remove max_t in ufs_get_device_desc
Thread-Topic: [PATCH v2 1/3] scsi: ufs: remove max_t in ufs_get_device_desc
Thread-Index: AQHWNOcPauoOqgCrCUantWXAGfrp16i9fnSg
Date:   Thu, 28 May 2020 13:41:11 +0000
Message-ID: <SN6PR04MB46402C75D4CBDA85A3628BB5FC8E0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200528115616.9949-1-huobean@gmail.com>
 <20200528115616.9949-2-huobean@gmail.com>
In-Reply-To: <20200528115616.9949-2-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2a00:a040:188:8f6c:a5cd:360c:eac5:60d4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2f313a4c-a456-4d3f-c452-08d8030cc8b2
x-ms-traffictypediagnostic: SN6PR04MB3933:
x-microsoft-antispam-prvs: <SN6PR04MB39331D8936B49BACD61BE651FC8E0@SN6PR04MB3933.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:639;
x-forefront-prvs: 0417A3FFD2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N+uUEbBKK1xOd3LqJmnMVu6TqLOVM73zZgObUczaPgpPwsl/AWor9vsmHVJ/mrQHTUfxU0o8m4rxjzPmC6wMnzjrOUUYmGV8GKNh0uqOOwVywuI8vqVV4mWi/TaNGsD0Z+OSbcjms2YWC6hVAVEcWro054okzU3lNea4hcauGaF+9xbYfugJWCHZWwX3PQWFmpx8mZVjYxO95m01N3QwTxIQVq+8CRIRZSCEmCtXK2vGx8iviv0+hfIWd3UI3YfeUYQwU412ZMH6wciQB/zz/2BPC2Z5bdTHaEUg3yP+6F3qN/Jsw4JgrHoPNTrBlnARrt5wW4Zd5rAjWjY5/QHdculXhev2/sE5S+FGF9OuHuMzcD5bJz7FythBTGUZV9sX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(136003)(396003)(346002)(366004)(6506007)(4326008)(71200400001)(86362001)(316002)(478600001)(55016002)(54906003)(83380400001)(7416002)(9686003)(110136005)(8676002)(186003)(52536014)(66556008)(66446008)(76116006)(66476007)(64756008)(2906002)(4744005)(66946007)(5660300002)(8936002)(33656002)(7696005)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: AYDk4QQ/B5373TSPlwyNohCx2igx99tKYVongY26XRUMU5ia7HDL9a+j9ygGLW7XfEpuUNvbrNnKHGQtEImRGoOWlAAc1EuC2OaKn8BBNzPMSCzoGUQnNZ2yLPI3wxzDuoTY7lU6DWyi9/k96oMYbLkSQttV5taPrxSxX8SUOF1jAle123P19ONrbCq48gDnk3WwGZnORG5XkWVqoFZ78GegGefcg24qAdQe1zA/UhCViqkltQeKxbNVZ7rvCW03CR+t8SIu0ZPjY3xV7c6v8o5d4SFPBQL4DR4o7Fo6kifgXwpmmSf+SLSW5+WT6cPiYKv+urhsUUGR+YNuKM5HmYFNrpX0UtlkHOf8wtkAtFWMyfr4YeYNifwCm+6lTZTUcc8T2z7AEWbc5TwhlnyENyKC2T3RmKr3oYZoeO6HAf4W3KUcGch3z7tsveMXNNBs+78d4+nDGw8i7z71dFsJhOlxbCBa7gO5vjTpNuI9kVbpKAyQw6hY8jO8Ygx8c5xqoNx9Fi2muwRB7FfX8yWtWbIHeTndjvHAnqFGuJU64LsOq+1HqG+2tzZtBvhlhUET
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f313a4c-a456-4d3f-c452-08d8030cc8b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2020 13:41:11.3155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PG7M9XHDIXVX3mxDZMiCW6TlPP5eUQ4B9C5TMJkHjuHgH/Mf8AvfnL7cfLhHQQz4BTAAOOSpDN6urONJZ28f2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3933
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> For the UFS device, the maximum descriptor size is 255, max_t called in
> ufs_get_device_desc() is useless.
>=20
> Signed-off-by: Bean Huo <beanhuo@micron.com>
Acked-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/scsi/ufs/ufshcd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index aca50ed39844..0f8c7e05df29 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6881,8 +6881,7 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
>         u8 *desc_buf;
>         struct ufs_dev_info *dev_info =3D &hba->dev_info;
>=20
> -       buff_len =3D max_t(size_t, hba->desc_size.dev_desc,
> -                        QUERY_DESC_MAX_SIZE + 1);
> +       buff_len =3D QUERY_DESC_MAX_SIZE + 1;
So why the +1?
Originally it was used for the '\0' terminator, which is not needed anymore=
.
