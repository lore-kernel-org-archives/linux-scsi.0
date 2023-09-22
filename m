Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58DE6E7D0C2
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 05:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjIVFP7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 01:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjIVFP5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 01:15:57 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963BA192
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 22:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1695359751; x=1726895751;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Roy61ynNVHSDJZwQ7CysSuBBzvVMTWSn07L8wSDW3tI=;
  b=rcNPSWYkrZ6L2ERxCDEODH3snY2ap+V82xJU1jumFXNns7ZXX3qgB5xZ
   zEU3rxlNITchr82C5h0lAvvBnBhvxYN8QhAEdH6mLbDnJrusmJzXJ2Bog
   DXlG+fc1udYT/F/RI22yK9CdzUa9WMf6hbBtHxCIoZJ3ksVgU/juKiryD
   iBKyS26KdkiVGATWLnTFEIyIiADI0hPqb8HHhIx9xfSGiiqdKW09oOahH
   nW2eQeztxK52tk1H20oLQb6o63Y/Cv0YQU05b40nUSkAIQlq7vblR5fYV
   DiOVADWJmYE+bZnj68Ec6xr2Fs9cDhh65jM6D8moirM6/qeiur/moj9cn
   g==;
X-CSE-ConnectionGUID: e7B7POj5T06XUxv2LvKIWw==
X-CSE-MsgGUID: ZwlDTyDVRDmKOPiK9nLwXA==
X-IronPort-AV: E=Sophos;i="6.03,167,1694707200"; 
   d="scan'208";a="244921785"
Received: from mail-dm6nam04lp2045.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.45])
  by ob1.hgst.iphmx.com with ESMTP; 22 Sep 2023 13:15:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UMOkkKbo+8xpdGv71cdaYzjHLbuL9FkuwGGdQrKRqedZhSrG5cIhoKOsgoK/y6nBV4s5/gGDeeB5ubtUSPO1ZDLclrg7zu2C6itTOcTa7HNtMUhBmYlx0G0qdNg21Z+i3NEYtj47tAOaXGKhRSxDriBhob+WhfvKHWYnWhTWZ02iemRTPPkoxWTblm83aRr5UMe49QKeFbbEW5WM9Xc6VgLrOKfnQG1E6yxRxPys3wn8CvyeUqXpbjEax8/8yR4tNEOpu+9vtqyJY3EzVOPiJQt/E9P1BhEZJAxBRSr3f5Hc6eVdXy0L58fE+jYnqb3rEVnD/DXBIayLuy46PSIbnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AO+9BwhrsFcdeD4JPN8ARC2jxT+0yH9MD0xwPnP7YSI=;
 b=fU3LZnLve8/eLsQ3LwvHLrsXjFxWb3BbBTHxOqakMEl5klbGi3i/r7FdREFQXXcS7AqUwrDrBtGQSATqDPl/shRoyxHibaCaEvr9o0mofmicnnOJ+bXZjCHXIoAynw7+QQvfDcuV4zuboODN2QGAgjxrGXMCMETlckE53+O+JVZ4cuB0JbQrka0u9nPAjLhb3ZpIHhsCQmctI2ldN9W0UywlB3JahT/CtdwRWOOucRxOiakDjTY5GAx6EAakUeZ32nwxP5QQ7u7EqfuiIpP/KJw57sbeJyPzxPJP0rDWPB1r19dKJNeBQIYpAis46r6m/E6UOG52JH+N2dWN8gK0kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AO+9BwhrsFcdeD4JPN8ARC2jxT+0yH9MD0xwPnP7YSI=;
 b=oTPKRewZBkk4L+mHDK88bPWCfdHNFUU9T8ghG2jULgR3HuLeP4cwFOtl2DFUPDBQwqXh+lCKNcQ8G2WHhj0BSkVGDpzntmualsp515PZ5X2A6oP4KFmMirTWMK2sQmLVHc3v/q5YIi65DArNfH63V+yQ7UG2gj9v4tVcVuFNCqI=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SJ0PR04MB7374.namprd04.prod.outlook.com (2603:10b6:a03:290::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.10; Fri, 22 Sep
 2023 05:15:44 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::8e15:c9a8:1531:8fbe]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::8e15:c9a8:1531:8fbe%3]) with mapi id 15.20.6838.010; Fri, 22 Sep 2023
 05:15:43 +0000
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
Subject: RE: [PATCH v2 4/4] scsi: ufs: Set the Command Priority (CP) flag for
 RT requests
Thread-Topic: [PATCH v2 4/4] scsi: ufs: Set the Command Priority (CP) flag for
 RT requests
Thread-Index: AQHZ7MFrAcM1BUO+i0+ciG2yD8Jc8LAmTfiA
Date:   Fri, 22 Sep 2023 05:15:43 +0000
Message-ID: <DM6PR04MB65757DA3B693361CF4A9ED2EFCFFA@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20230921192335.676924-1-bvanassche@acm.org>
 <20230921192335.676924-5-bvanassche@acm.org>
In-Reply-To: <20230921192335.676924-5-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SJ0PR04MB7374:EE_
x-ms-office365-filtering-correlation-id: 894a246f-1793-47b6-53cf-08dbbb2af893
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l8wfNGf9ANTE7dwrrpIlx5qxdJCnp014jcG54K4AkTwAEVj2DiSWEb30rn08FpPZ9Qbi36IjnIQAW61JVZPJn8o7K1UT8X2dmCOVsPS8aH6yPinP7fkFTQ5NNudKchTTrnZsXrAdJ03IveL583SmbpyDim0TcYAmEFzk/OA9AVvwCvQrzknrG86q3LugpmzOcz4oamho3/4JR992ZQwIY1v9lWpLr9Ba6SDtxxeIZAgfNHp03BBLPN+evw1BJzZmDfK3ssjFzrIFIyzNFi98AltaGw+VGyMDkiZOlNGUHR4zUPiK0rJTyQ41mLQZJkYOi8PcP3KoN2Q2hA1bZSc+z4ncEGjQJC1x0mKdyplbTpd2ow/o7c6aGkJ8Tu1lbX9q+8Ds4zRlaEyLIZ0uiI0qO22+B/sFLtWBnhxRsBwYqS4PmTuX/13ZNjUq7+4iYXTLLp/Sn3c9uOYnKDvBvKyS8SXPN53hZxZJxNOe4ZfjaPTnTrzVwWl3mudfAeoy3KEINIB9pdHg572qPvYilVH2Wif+qS9Ve+AsS9MF0+qA34bt5h98naDbqMXDnhhyximv49iA1RI4FxlwQb+v1OVTR0yCClxXdagjijWEOLqrjZaXmzrWbiRvuVbc8hLZH7ne
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(396003)(376002)(346002)(366004)(1800799009)(451199024)(186009)(122000001)(71200400001)(83380400001)(64756008)(66556008)(66946007)(66446008)(66476007)(316002)(7696005)(9686003)(6506007)(26005)(478600001)(33656002)(55016003)(52536014)(110136005)(5660300002)(82960400001)(2906002)(76116006)(54906003)(4326008)(38070700005)(8676002)(38100700002)(8936002)(86362001)(7416002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YOxk5HPM47eM8jz7mXko+uuEOM/WzbCL7ZJgCsRS+tOryVVDK0FgrXsGc8fM?=
 =?us-ascii?Q?P2qowc8npfbcht02/VRlOtK6K8TwVtjStYI5ItgkpCvyuIzR7YJ6R9rqUSR8?=
 =?us-ascii?Q?EwmHrn91Xa7yUsIvHWQYDiQkgo2ynJLRDEWp3EyXQwy/8o0d6XSG/7JUBnZ8?=
 =?us-ascii?Q?xxgKpBWloDfuGBE6bLlucHgv90m5aA4ARtG75xle75E/gjfEidaMqzHu2gP5?=
 =?us-ascii?Q?kSd7hDOtFDvEjfYbFZy6PxY2r8nvy6Zw6y6OTbn/6GRAAd8uAs9hjovOugWn?=
 =?us-ascii?Q?PP9TOpkeNqThHVDLg+XwJOhcJ+wHdr7Exz1z6sWiZBZB0GQdLBSgLf30MeEn?=
 =?us-ascii?Q?PcCOPeisjW5fUnfS1MEaGVzA2cq2hQbpFk7LguwjROPfApd1tEGVUploOTeh?=
 =?us-ascii?Q?2Fj+mpgzQSsgoEUU8+7iQ8fJtYXi3CDYF/OfxDo8ITojO0e6EV7LYyD2/OAJ?=
 =?us-ascii?Q?NbsMnoS5pUPPLCwLvCOY9ogl1td12lRlNYUEIjSszfvcyZ8Raoll2+zMFA16?=
 =?us-ascii?Q?GDgrz8UoJQ9dRFJJ2eh9voVjcGFICsmp6juzQIKz/E6hYu3IlhHQR8ITQ8OT?=
 =?us-ascii?Q?Pxq91E/WJsiv9YxL1ytOzjX9khFJByWLHqjyryF7qXNxFsY63AQglMgEicfu?=
 =?us-ascii?Q?/uFAE9s4H4BN2gwksZ2FYq/J3Seg2QVJ62fmt2mF0ejgSuHBDWsGuOoVuYZA?=
 =?us-ascii?Q?aXhl/iJICINa+wLeiIwWeJxb2ltlRPejhh4CazCb6j7GzmWflpqjlyvpo7/L?=
 =?us-ascii?Q?C76DjKi82ECvcfmrPYA8IY4bwuuVQYXLXLV4bvZ9NXS4Ira/S1DvC1h72oNr?=
 =?us-ascii?Q?b9nmiQNy5Dg7yFdV64aFmOhkQ7LDt4BsDEZpDZEBIpjedQeRm1xSEJ+ZlCKm?=
 =?us-ascii?Q?poMp8Twefv31g35eTmz6INKkGgHBz+u783vxJtSBgOk1CIWa9jtKFW8H8O8b?=
 =?us-ascii?Q?Rii5hrPgoKf8yRrtX5jR8jZ5szuLtfR8uJuIu2L8NBSCScbvU+Vy6Nx9j4Jp?=
 =?us-ascii?Q?492vNmz2z+uTN3wYFCVTv4jNSJL9A4kk6reMHDxaP5YLa2lCngHfssDp40h/?=
 =?us-ascii?Q?v4R48lIBLEfpRNZ354cCmSBV0e+OUubTLtUpsahcXVqWf4F4cr29itG7oze1?=
 =?us-ascii?Q?gwlMqotkaFIScOKBArgvLNok4UcflPLr7tdLcS5IMlOTj7zT5iXL4Kn/6oRr?=
 =?us-ascii?Q?AXVeaW6jWstRa+bf1spzp60sNbARJQocxfpvpT89hm1nbRKZDM1SKXTiKoLy?=
 =?us-ascii?Q?64m9hOKSKJyBMeZOMNZVOSbqmrqk9tXiEDv58nAyK47va/74boQGK4F7Rqrl?=
 =?us-ascii?Q?YKgeQESF3HJnmk+ktCQDtHyCL4bVmOry9IQExq2PhQ/JBpzHIp/Ym8IGraEd?=
 =?us-ascii?Q?UfBUX6bI0cZjCsaDdNBsRtTWONjya0O+u6yW3DDKT2nf9tV0u7TJzNnRTld1?=
 =?us-ascii?Q?pdLVDk1c2zK659N1yxoOjpXSORSL1inj208voSXkfoocBzmwahI9Z4brIySC?=
 =?us-ascii?Q?D8zN+xugh1JoKe/RFz4/7K7Exr4wStLls01ZuHfR4OswaSqguN/9yKs6DAnJ?=
 =?us-ascii?Q?mpIDZ9x2NXcAJuqBtE/ANTLtH6hl+K5f2hooaTXH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?H3c0VIdA6MyZg1oBJJ8hDnGKxOY3EvyvPxWjQ4isQbmB1Nbs5uaINDJEFBou?=
 =?us-ascii?Q?X117PDen2Pg1FISidOJnK/tb+ZrbTFQaDxjzWx6BS1IyFSlRS9nJWcafydzz?=
 =?us-ascii?Q?Thcwc08mNKkDyQzejjOPVrNcC7PBjvgEWylD/KU/5j//q/jb0D3xSx1wu6tL?=
 =?us-ascii?Q?Fvrxjpyow26RDm76cJXv5eY//VCmG0Cy98IGl62qrG6PA3vLkXNUStD+9loG?=
 =?us-ascii?Q?DWLDH5Q0AAwgVSDR4mhshEbFTFoQacLvaA12HkSm4s2wTpPge2S2REYJoh7q?=
 =?us-ascii?Q?bNDxTn9Ds8PVuV7yJD0SMlttXk196pFI2VWRDgTMIKG9fwbsuRBguW9ZHD7W?=
 =?us-ascii?Q?JZ7zf79rgTs50tM4LMJAa/DdztzyB6TTeh1iVLtqakT5tb/DqMIJtmi8T4ol?=
 =?us-ascii?Q?pbxqSWQyShhRNPkzlAxcwQS1SbW6oaoF826IWKN96Ag9VwRXz6cEu5hK2FMF?=
 =?us-ascii?Q?vfJAdxMp4lbwTstVLP7jKkRJxkXmaptCpi3UU1kX0iFwLZg9kxs5t87mCtKX?=
 =?us-ascii?Q?DCj22a9B/mqtYwmBD3lUN5gnHadPLgARWKtG83T2JsJ9xQWurwNK0ceAbkOg?=
 =?us-ascii?Q?WVp5aPtyA9LMOHzWvgWCKhv9xB4z0IdQAmv8f5vmokLPP2OyXPctgtwFGtY8?=
 =?us-ascii?Q?3x61wQ4YIjRdPpgwTwzftI2DjHeikvh54gEycB/qeTCcJrxObELYlAzYCcll?=
 =?us-ascii?Q?zHbOURq2pO20IZcnPp9rsOecA5XxADgRCwNLqfbRYtvBBatkOFeauxAxXkWM?=
 =?us-ascii?Q?HEPVH8WzVBWyNKKlHSu49a+0ZCCEo6ecOPnk9Jd/KGVV1va45tSwAhAnZ9rt?=
 =?us-ascii?Q?xsrxADpZVJ/+7MQLKBXlwp5l0j2hrtbQ6uC6Ie1KHv8Ls6ip9CoGpETkgUhN?=
 =?us-ascii?Q?fQNPxGzKIZ/aaOJjy9mK50O1S+WRSqKwwIQry2RXKyGYAPOaMrM2hxC4O4dt?=
 =?us-ascii?Q?IWcajk+CxRrVF+WcymmyCbUy0NNxKpj3nKObP9Bfr6RhVlrzz9nOX4zK6nOa?=
 =?us-ascii?Q?iCNb?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 894a246f-1793-47b6-53cf-08dbbb2af893
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2023 05:15:43.5876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jkkgdJ5AzK2VKLNMrcWB2n/DlodOBK0MVK///6CMnaT80g2i0z9/2P55Ts1X5iLgWZvkh3ieBnCTGTxGQihjhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7374
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Make the UFS device execute realtime (RT) requests before other requests.
> This will be used in Android to reduce the I/O latency of the foreground =
app.
>=20
> Note: UFS devices do not support CDL so using CDL is not a viable
> alternative.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/ufs/core/ufshcd.c | 4 ++++
>  include/ufs/ufs.h         | 3 ++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> 8561383076e8..c614619f06bd 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2717,6 +2717,8 @@ static int ufshcd_compose_devman_upiu(struct
> ufs_hba *hba,
>   */
>  static void ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb
> *lrbp)  {
> +       struct request *rq =3D scsi_cmd_to_rq(lrbp->cmd);
> +       unsigned int ioprio_class =3D
> + IOPRIO_PRIO_CLASS(req_get_ioprio(rq));
>         u8 upiu_flags;
>=20
>         if (hba->ufs_version <=3D ufshci_version(1, 1)) @@ -2726,6 +2728,=
8 @@
> static void ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb
> *lrbp)
>=20
>         ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
>                                     lrbp->cmd->sc_data_direction, 0);
> +       if (ioprio_class =3D=3D IOPRIO_CLASS_RT)
> +               upiu_flags |=3D UPIU_CMD_FLAGS_CP;
>         ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);  }
>=20
> diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h index
> 0cced88f4531..e77ab1786856 100644
> --- a/include/ufs/ufs.h
> +++ b/include/ufs/ufs.h
> @@ -98,9 +98,10 @@ enum upiu_response_transaction {
>         UPIU_TRANSACTION_REJECT_UPIU    =3D 0x3F,
>  };
>=20
> -/* UPIU Read/Write flags */
> +/* UPIU Read/Write flags. See also table "UPIU Flags" in the UFS
> +standard. */
>  enum {
>         UPIU_CMD_FLAGS_NONE     =3D 0x00,
> +       UPIU_CMD_FLAGS_CP       =3D 0x04,
>         UPIU_CMD_FLAGS_WRITE    =3D 0x20,
>         UPIU_CMD_FLAGS_READ     =3D 0x40,
>  };
