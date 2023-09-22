Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E0EE7D0C2
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 05:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbjIVFRF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 01:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjIVFRD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 01:17:03 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCBF18F
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 22:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1695359817; x=1726895817;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r1yvr9C8ggTTu82vuD2jUD0BjM+jarlUupfkNw0Yp8g=;
  b=Pj0Ns76HPsUF5fNJiHSH2zZAK7gOC1c+ijs4fvenbpabGjtU4sFbFeFk
   bA8pwXtFLdlRDBlwMdZIX0wGyjkc8Ed9HxxlECEncbqDkbS32ennuha6/
   CzvKkyY2xy0ZSEj+vkKSEF7/AjkUBmbJ6oGFES7kXY6EzpblpPCcT6hYJ
   djhBxCcABBtTuTfkFuA1xexhtNt3v/6rlJbV6HvntLgv9YtQg5cvempKl
   Vd4F9IxIMSjhr6B5DJlUri7qCxInN+Q8A3CgybIx+J383Ac+jv2J8e+hK
   TYMczPKI35cT8UrBXqIPHpDfQgg1cOCu+nIYTL321Xyw1aw85A0nvXrB/
   w==;
X-CSE-ConnectionGUID: xbHLDVuWReepM0Fd+AEYIg==
X-CSE-MsgGUID: E0nzkD5SQuKkwUiRTEMFYg==
X-IronPort-AV: E=Sophos;i="6.03,167,1694707200"; 
   d="scan'208";a="349914170"
Received: from mail-mw2nam04lp2168.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.168])
  by ob1.hgst.iphmx.com with ESMTP; 22 Sep 2023 13:16:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O0F9dyp8vmJ8P15GpHFchR+4sn2RwEsDdvnBIQBK1yTGJFtSu7n+ClUtbC5UpX8aF/0Y5BngRL3V915+fwwsd8ZaBPGheDE4rRLAszAyDVJGzxsTT4fI5h6gpTmh9ySUdzND1HCyrjIH4nXl1nnL5xsidUs/pj+IvB4BOReUe6NtXicn4jOmULh1HkAo6v8p0D1xm7mQr8m01MFX5ZKoHGC14VRyDsZ/FADgVAMED4ngl2cirKdY/j9JbcHN9aithI29qkdv9vIXr8du6M4luLgFbA9erl8edHT/iRkz+K551VwImX0nKQwapnQGf3mwYVjW+A14K3BEPQddfx7qVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RKml9Nt/IWyu9C8wpA2R9h6N4nPbvlRQN9aX56lgWl4=;
 b=ANc0U3Kx+N/uKO4E1l/w0xh/pkS8U6dZb2+Lwz7G4fB8kxIe0eLDKdcrhAsQ8PsPyJ20uSZRtAYoz229Sg7h4MKZcka0omBJvuiixM5cE6cz3PrmjvQqAXgZ/BbDJdu0dswmriGZgBWH2D+w6ikqjNaDxFV5MCkgoC2r7pEC1wMoOYcqK5mmk7mHJlhCqxwfk3tr6c7niXEBQs7aXkgOHEnyTeCPl8SpuOnUrNG0mWBdOX2ZNzLs3d4GsexauFBUWAQRKGYUf2BBuOStU80PrVNlPt0EvUPoYUFhYQHKiWD++6H0IEb9Jognyo8i/t8gw1zW95MRoSBNidzxNwlmkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKml9Nt/IWyu9C8wpA2R9h6N4nPbvlRQN9aX56lgWl4=;
 b=BkoqOqiWu35snerwWcprbW7uCX9m9ge07B+2PxgDs5bPOx3hyNwBiXebj/sIA2c8d2kPG7/0kI1YoWeBZUz9lyFEAVdzfqLVY8r36sASBjoE0a8rHeRcj/2UF6y5ZkoZAjNlQ/MiR7DIakQgigV0/fpepLI82K0Ji0OQnBHtBfk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SJ0PR04MB7374.namprd04.prod.outlook.com (2603:10b6:a03:290::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.10; Fri, 22 Sep
 2023 05:16:54 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::8e15:c9a8:1531:8fbe]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::8e15:c9a8:1531:8fbe%3]) with mapi id 15.20.6838.010; Fri, 22 Sep 2023
 05:16:54 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: RE: [PATCH v2 3/4] scsi: ufs: Simplify ufshcd_comp_scsi_upiu()
Thread-Topic: [PATCH v2 3/4] scsi: ufs: Simplify ufshcd_comp_scsi_upiu()
Thread-Index: AQHZ7MFkvf45g4hBiUONQBIrIDeHn7AmTlOQ
Date:   Fri, 22 Sep 2023 05:16:54 +0000
Message-ID: <DM6PR04MB65757E4FDE37EF5D144E8A9EFCFFA@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20230921192335.676924-1-bvanassche@acm.org>
 <20230921192335.676924-4-bvanassche@acm.org>
In-Reply-To: <20230921192335.676924-4-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SJ0PR04MB7374:EE_
x-ms-office365-filtering-correlation-id: 4dd810f7-e3e1-435b-fe29-08dbbb2b22bc
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nwrmM3NXYl+bcoPxmIQoMElf+34c/VX/5kEJrWu1iP4A6slT3/TIV0maESEuUyH+RsloLEyaLtctuNYmH7hU7Mgink19Y+xv030Io2K8fCzJoA9z3J6SP2N+FXmOQpW29m5lqj//A2Skp3a+SIHOyBpoueg7ZAsgI2OIAk+I6LId+/pbAlJII9fsHBeSrgJdbHcYjFPs5psLKodCWlO1USYXRjHtUom5Yl+MM19mFzYZhuEJ3icBq67FhzIhBOPcwDLD5QvT4UCBiONe31gkfRqtdpsGbSxp/V1tD/VB+eC/v2CTNK7oMVXtegK+yTCFUPAgo4AZgMavlK4db1paeMtOvuA58IFdflm1dE+UMB75WoDcfV5WlTxcTH5ilBVdps4FD82MRsT55y9nBx7D03Flm8ca8vPf8l0xdz288GgrtJvgholPewYCNzn6AZMJmtz1e2cvYoph8jpUBHqflFUsJMatINjmMeuwVHyrE1Rrt5vt8BZ7Kz34fHtD9/FwPOoA1azn9RclShCUZZ8YUCARnLHyNfR9DpH3TVor6wS3VZEv1eCpPx/wB2AwhA44hr2ujeFvljdVbNVdaXpzLsiyq9CBIfL4CEvHR75LLW4ivEa0T/5jl1jc5E/hcVyg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(376002)(396003)(39860400002)(136003)(451199024)(186009)(1800799009)(55016003)(478600001)(33656002)(7416002)(86362001)(41300700001)(2906002)(82960400001)(5660300002)(110136005)(52536014)(38100700002)(8676002)(4326008)(38070700005)(8936002)(76116006)(54906003)(83380400001)(66946007)(66556008)(64756008)(66446008)(316002)(66476007)(71200400001)(122000001)(7696005)(26005)(6506007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wRoCX9H5hLd34gUaDQdXLN28Z88ZZ6y/0jdHf7XeaFKYRN2wAp/pR1wdNmLV?=
 =?us-ascii?Q?TylUrut3l2IqB6uj7oBB5HsxWhWaDSnyweqKoQe1M1RHwySvZOlfSXLafZot?=
 =?us-ascii?Q?cnzOnAKM9qJS1mEssGGhL5AnRC18HJJadj6brYYES8i5DWwXU5PEX7GLTA6v?=
 =?us-ascii?Q?5S00Tj8VNb5vAkVIxgB9Ism8bV2ZPk7IzXF8RSOCEIKW0Rv5OxisuXqMqD4I?=
 =?us-ascii?Q?gjwnwk6cbOIOJxkGr0pr7Aq4fMVAY3MY6gQSv2MjfZOKizAKSSUMbEg3lm9r?=
 =?us-ascii?Q?C87TOLs2Lkn+Pzos/b5Uyq5PeG4YM7X8bcWNy47/RhLxeSh3zJodtDQPe65c?=
 =?us-ascii?Q?Cv3KYRwkG0OOCsc55uj+qqAcvE/XAd5aJc8ofFZ4BQwSTXHr/by2Rc8Be1hA?=
 =?us-ascii?Q?Cm4/5l0e9vEHkb5fW50R/guWRqE7t5Ah5Db6BrEzdCvbpeEkpS2IUT5q+2Ue?=
 =?us-ascii?Q?ql/qiWuMqOPiJ28jpAMxJK/oocXvAW6/dtt0s4wmni22M1JA4zmroRBvuoAH?=
 =?us-ascii?Q?InstBYBjdYaEwJGvGx8PPMlPgGN57rn3+bEy3Lh5ZQiYuZ5ucckx3Svmqlvp?=
 =?us-ascii?Q?cH92s58/mHsxOjEvPt09AR8Q3i3e/wKTb8vjAsrt/xvQcbROmr9UEKNCf8dy?=
 =?us-ascii?Q?QkC4yP+cdUGpS1ujAzX25znVQtF3cfE9V7cPhKgl11eJnUM9imfK64sjCUSo?=
 =?us-ascii?Q?4V8CgMixZPolddirFQPBaag3FMw5QL8ywjKaQ0W2SbrIfX4gKU+Gk5RKYWzm?=
 =?us-ascii?Q?BoafzB9gphLZkq2Hvse1ezxZrmutsq15fOAF7G34thGDgL9+sLT5/Mnn0JFJ?=
 =?us-ascii?Q?c68Xc1ayZu4avT0rwy6P1Pucb3c1eJzOAu7MKfzDTkTpTIu8kORw4iqmhKJp?=
 =?us-ascii?Q?So2HIcGBF5Fc0QWvX+8aoP+00PSNVBqoiHAvIpUAhps57ixeHQrs+LRJzE4G?=
 =?us-ascii?Q?M7kIjsNAwcFebczu7Vsd2E0sDXp3W1hh5jDgLAAK9vHZB95sfvmgsELysfmY?=
 =?us-ascii?Q?Bo6RP2tEFQ1cr9l6P9Okr1+q3yMwFxotSOyHdB3fXWl1l3enFuh/VpUuSecT?=
 =?us-ascii?Q?dguv5njNlBSLhuzH21k4xdOnyqO9BbKOuAgxgGyC8VjbyvoapxVBOxo7HolE?=
 =?us-ascii?Q?qHuZ43H41tKVE7zJR19xpsuv2GQMVxuajzQ9N8gWq/rqL66IVlsZZCD+yxc+?=
 =?us-ascii?Q?8rfoOQJyQXM3p0Znj0zvhgSnJ9vFo9WXnijuKUTEdutJM6Uw390/GOKeXgil?=
 =?us-ascii?Q?YOXdkaZvPZSO7LnMsO86hKIVNuivL1Fmn7/MxYl34zgLU+48SMXBXFjOkNpx?=
 =?us-ascii?Q?dZFhoLRynJ2B5fDnF2INvuNADsE3Txb01ZkhdftcX7Bc+kCfM6DZrYPnXXh5?=
 =?us-ascii?Q?T34++XZlv/1WDIHkOM3K1KHOxPC6esSlm9HMt82+Q9AWAv1V/H3258HyTpsv?=
 =?us-ascii?Q?TRZ6VSKk6N6PbUx16p+PdP8uS9Uo8DD/+CeoRJ8gEzQCqwZcPw9Y1Quw2rLm?=
 =?us-ascii?Q?2jOqIiLGXVUDCakCh0T6vZ7HNoitFGQjZZrr1nshFgbT1PaNRKLb5E6QuByo?=
 =?us-ascii?Q?2qTp8ZIJW2P8yMrSKY3NQXLwrce5IHMc/8q90dsc?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?dT6eEAv+m9iI4KdD891Q4rZ/OcEaPdnaBHOodoZRU47geeVAdYLgi3B1OZaq?=
 =?us-ascii?Q?4PoKQk7VxHcq2v1wCTnf+5kIzynpq7Ai661Fjr7aSqwETkkAdHNwsAQqhMwq?=
 =?us-ascii?Q?SczcVkFzynyRdBndGydG54XzI2ABKD1xFv7COw8+cH6M6TQJnN5wRkKuEV5E?=
 =?us-ascii?Q?duJMsOyZu/PWsYrdh3sf9LqjhWHIflkugYgocmnXp2+Tyas2PQyZDHTkXuGB?=
 =?us-ascii?Q?fkljfbK003QAfNObhJQeWJKnU8kQ9dPp7Q5z2cqIrLxHOM0krAPtyF0xk99z?=
 =?us-ascii?Q?uXKIE2Ps7aw3eVY1stgnMT4VCIXSwdFqNdf9e1E3rFQfFtMFbbTjqulxMDro?=
 =?us-ascii?Q?fP0IAwgg6S2EH8eoh0CqbQYUH0YcksQB47smP84XSDqU2z04mKuT0rc5lglO?=
 =?us-ascii?Q?95vQn395ElIqQFsYiTr8E/U/5avZR1R4TVi7u4gT/K8cFupRTkYApXWsRb/8?=
 =?us-ascii?Q?Xdm7jlX5f0Tc9vQH/M1z5wzmI64PSonaSCiu+CymakLlj+Mh3lhKOI7VP/gt?=
 =?us-ascii?Q?uSi5wkRfh2sFNke+5cGumYvTaTk/usZGw5cqp2dGKLAe7ozJSj/Ba2I7iIpV?=
 =?us-ascii?Q?aBkVizjqp+ATbvcENu2I2iF4SJExKv1xC2jyd9sr3xLFOFnemQQGHPKOlwhS?=
 =?us-ascii?Q?yd6/yRfWIF44DH8rYB/stby3gUx1mO4SzVLyu2GZ56Gzokoo8BfU64381rUJ?=
 =?us-ascii?Q?RPGWZWS0J23KiTUz6p5YjZFNeF1vVrtH0C7B/gcApYoS51vPvnuIQt3rQwFp?=
 =?us-ascii?Q?pveITLzbfHhCGy0NrJUlDEsGhlmcdLpWSTQrAi8+u70SY2C07s5FWaQYlckv?=
 =?us-ascii?Q?lAIt/rsklX5Rx0sFOgfKIemeX7q/keu3BDTLAWglCuKjSaIdxLj3c44QgBWU?=
 =?us-ascii?Q?zbUx8CFCnTupOlFfwO9MUiLDKC/PdRqsaDsywhMboxS063w3Yo9AtkVeNnx4?=
 =?us-ascii?Q?YVP1X2yrJRvW9vs/m5/Pk5oQVea3F4ZSyw49UU+8WlM60ITDS+pUSy2107Wh?=
 =?us-ascii?Q?4PWW?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dd810f7-e3e1-435b-fe29-08dbbb2b22bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2023 05:16:54.3794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OkVTJbMKgLHENZKHK8yGoJpudP7AFFASJCLkVjzxCC1b9lfjuWrzw3fZ+Fn+Q8vzN74TxnpPej0ucE2CsZQmmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7374
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> ufshcd_comp_scsi_upiu() has one caller and that caller ensures that
> lrbp->cmd !=3D NULL. Hence leave out the lrbp->cmd check from
> ufshcd_comp_scsi_upiu().
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/ufs/core/ufshcd.c | 16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> 379229d51f04..8561383076e8 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2714,27 +2714,19 @@ static int ufshcd_compose_devman_upiu(struct
> ufs_hba *hba,
>   *                        for SCSI Purposes
>   * @hba: per adapter instance
>   * @lrbp: pointer to local reference block
> - *
> - * Return: 0 upon success; < 0 upon failure.
>   */
> -static int ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb
> *lrbp)
> +static void ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct
> +ufshcd_lrb *lrbp)
>  {
>         u8 upiu_flags;
> -       int ret =3D 0;
>=20
>         if (hba->ufs_version <=3D ufshci_version(1, 1))
>                 lrbp->command_type =3D UTP_CMD_TYPE_SCSI;
>         else
>                 lrbp->command_type =3D UTP_CMD_TYPE_UFS_STORAGE;
>=20
> -       if (likely(lrbp->cmd)) {
> -               ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, lrbp->cmd-
> >sc_data_direction, 0);
> -               ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
> -       } else {
> -               ret =3D -EINVAL;
> -       }
> -
> -       return ret;
> +       ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
> +                                   lrbp->cmd->sc_data_direction, 0);
> +       ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
>  }
>=20
>  /**
