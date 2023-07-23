Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C9A6C001B0
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Jul 2023 05:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjGWFcH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Jul 2023 01:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjGWFcF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jul 2023 01:32:05 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E681BD0
        for <linux-scsi@vger.kernel.org>; Sat, 22 Jul 2023 22:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1690090323; x=1721626323;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vVNkbUoFBTcnB1EXqfV2nZBe0TgHQ6Iyv4g/lPnzL6U=;
  b=Prtt+qt+OxgjM1iGPg13L4AYSj5d65oUdoKtdA7L2Z7ma1nH+RjDYdQw
   NE0mB0EusAAZj66dQzV9zqShDM9wfuNK8suQ9+SjhhAi6UAzOqSdGaoS4
   tAY6UdLw9mk75V/qLFcDT/KZI7BEwH12F99eDzP/WiIlJnBDAgrvx8x+j
   RPyg5AaxZ5sr7CA3PV50pIHWw2pskpc34G3e01+TGZBz2TnT0y45sljHG
   HG2q2R/0FPm78o7GfbpaAidQHgdLBXAV/WkNJnHnEOH0JBhK6hQT09tvX
   uRfIJRlGlZ47DsuTvkIKEBKWegMV9w9QrxZfCm9SQqy95IothmOHQ7jMK
   A==;
X-IronPort-AV: E=Sophos;i="6.01,226,1684771200"; 
   d="scan'208";a="243473383"
Received: from mail-dm6nam12lp2172.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.172])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jul 2023 13:32:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjFcPAtgAcx6nkH9dwUn3pjsvtMSdxEpVUmRIqARv12/zhSm9JbgzZRWuy1O3sJ3xgOQdcB430N8pY1Ipg4OmKYULEfXn3OovpBoAkncfBsflQc+mN/RGIBXMly0QsPziefQK/D0g4ngRSHG8Y5eGhSrQetmtcISUP/RLcVjFmLUOKEzhwB3nt9gZHokRpW/jM1d8QmYNrWYu+kQ5EG1uJQfrnHT+oj+loKXLmNWJogJ0Uqr96zzVYbJj7jFkb5c+RifIM9VSv9x+NUC3B/mTyWaggYpgXyFmo5uLfssU1O2Ktr7ydK2SnzXbt2fzs8+uxw+xgZGI+frRx7TKr668Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O96mJKqGLTKDFplf8Fy1ixqO4pYeHWbiDIoEu0xCXt8=;
 b=jLcbrMH73tYmQroX4CRQm6/Sa54gd8c6U8CXGkJB4IU+ANLqfc4vf85THrWeZCPZcLfuS0vepNY8HZNd6pG2mrSWNycT60z/TMuY/S0BujsZTBchtzJ5Gnm5MPdjd/3VSYceLssz2zZQvpHjbqJUYV+1cARw0lrrYsHytQPtaNYd4qB3d4C0Dyrlth0p4f5bK+tSc83XF9VXY47/VkPGrKfXbENmdeiN5rlCv4rLyexj8pb4o9QTmsip2YABWzJzuKKZf+HJp3HEDEXfPDUm9I2h0YhYrwjtTwmy62VAmEBlGAedaGaQpLntn6+AeQ0js7uHITzg5Or0x+fbBKK3pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O96mJKqGLTKDFplf8Fy1ixqO4pYeHWbiDIoEu0xCXt8=;
 b=zY3n+RdXdGA2JYK2xyKB8xEaPjzLQejsSqrs7c2MRIlEd/p9x9EqtIp/x4g9sihGZ5m1lsppR0tG3DqreDOLQZkRhflT3WcwoXLNrBytbq+zLfnUFpBdalp5cP1NOSrvFI79SWq9/lVqDEuoyjwasQEIcF4rBUisO2yX3rZlzrQ=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SA1PR04MB8564.namprd04.prod.outlook.com (2603:10b6:806:330::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28; Sun, 23 Jul
 2023 05:31:59 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::4781:1e0e:9df8:940b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::4781:1e0e:9df8:940b%7]) with mapi id 15.20.6609.030; Sun, 23 Jul 2023
 05:31:58 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Manivannan Sadhasivam <mani@kernel.org>
Subject: RE: [PATCH 2/3] scsi: ufs: Fix residual handling
Thread-Topic: [PATCH 2/3] scsi: ufs: Fix residual handling
Thread-Index: AQHZu+zD+jEYt436/EKvO0lXbPVAV6/G1DXQ
Date:   Sun, 23 Jul 2023 05:31:58 +0000
Message-ID: <DM6PR04MB6575C3A5197457FAE3F6C438FC3DA@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20230721160154.874010-1-bvanassche@acm.org>
 <20230721160154.874010-3-bvanassche@acm.org>
In-Reply-To: <20230721160154.874010-3-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SA1PR04MB8564:EE_
x-ms-office365-filtering-correlation-id: acbd975e-bd6a-4b01-0998-08db8b3e22a1
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EHSu7Lh1HClujUSFB0c2OhnCVdsGAnt3eg/jz+iK97jYWPRWFzPSPQGyxDVOyvJ2n+ue+vXfTie1khOv4+RIl7YllTYDPrORa7FWe4PQDNDBlNtR8JP2uw/nvWVY78vl9X/6ToU/84BB5gO9td4OkdgxbEjyZURAZ4UYM5MqujJdNfrtUUMNogJbx/bBmW4sqZihWkDR7/9k3TduWvS7yOKNQ5gurSPhqh2fHorW7JBZ4OacC9CtzsFPftl2en3dAylst5Hu4t/nY/vprPM0ykLeX0HWmdTc/U7Wg4xvtNsAJko5qjb1t+7ExXYK7JO0drYr7ulM4Ld3lEL/xLq1rlOn4C0JAEDkZW62r9L5u8lWZxYUWjXADWnb5JwyzpUCrdBJJq8cMTcmUG+MtkZzgPzvADGE+lfNVyHYzpM+GwIJ/GRafDL1Wv0SH0lxOvmQURtTsJqjYjX72ZfOhbJC/gLb+v0VmdHaIcQWyX0POaaTn+llj9qRyaUlWiUrKCr2qr6Yy1UKO1XWw9ywA/INxF/q1dKO2MXEmhrJ0iKpAkQm7E3eqvoEdB8rBDJvDBdZZlsYDVwKaIsxwx/6CO3oqp4P4XHXHWjygc6upMCBtthE3oJWSsGHCj1s56Purkoj2jb1+Q4N2L4S6yLBlMcXK7gv+JqvalGQ9nZzdcvqOjs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(451199021)(5660300002)(8936002)(52536014)(41300700001)(83380400001)(26005)(7416002)(8676002)(6506007)(186003)(122000001)(71200400001)(64756008)(66446008)(4326008)(316002)(76116006)(66946007)(66476007)(66556008)(55016003)(86362001)(33656002)(7696005)(38100700002)(9686003)(82960400001)(38070700005)(110136005)(54906003)(478600001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GEkCSFEtUEIfwT1JhEPLzaqBriReLHGjkeiGo1YpwRg/xLIJ+NgG0gmLEmqw?=
 =?us-ascii?Q?0jK8Osxzrh3K4/XOVtsPvxrzyqV3XgEe7/eLRvJOMw0x32Ii5bhio0fAu/My?=
 =?us-ascii?Q?f273hZAN4WEM3TL4cgX/XSQZTlg4252aHVgGJgP5KDUn9vtHASVVFTEQLFlp?=
 =?us-ascii?Q?6Fws7qEf39QSq50R1Blcl4EmENjOpA52sbM9xqrVHdK7I7N5EMFyaq5/jnzQ?=
 =?us-ascii?Q?DMLH5YRxdDas3vw7QJkcQnQ04AWspzyNsTg9sRhNAZuyeCPClEMZfgF7lhhr?=
 =?us-ascii?Q?cwAp+CMGAKrBJXqiq80HD/zqLOgYXAcPuulpDFXrpazZZw2HZwpnkkolB69k?=
 =?us-ascii?Q?43wRlF9c/Yp3YjBUHh/etHM67izCyJvgkJyWtNCfgEt9fuy3optc+JFZJwiv?=
 =?us-ascii?Q?ZPSmDVNiivKIYp6FQIaRz4TgP0oSDsN/0twe7i+8yOLAag0WPj1PlUmJbx1b?=
 =?us-ascii?Q?Q5NwMqRKunCWXi3WN0EZ9IXZwdVtgDzWRQsrwRxuLU49JC0Wj0WrHXy0G5pG?=
 =?us-ascii?Q?XRlZgbo9r1wSenp06WUbdTyesBrdSNo6+St+aAgYELZgTH6Upetam2OVp7kZ?=
 =?us-ascii?Q?9X7PaP6cIlDhgoeXI07PLqbxM7Wd66T/NOA8ghNy6QM2OtKWBwc5z692Aovs?=
 =?us-ascii?Q?SLNEum7DAZQNP8YktCVkOg8oDb8/j0qlFJ+GIjBk/iiUFGdNx6Qib83AWHAc?=
 =?us-ascii?Q?bT7eLJ01opQLYISAepaStwfq/8XGUbygcbRqAxfiomCn+uhwlL0pB+/0VOAV?=
 =?us-ascii?Q?x6PXW/4E05g5o79GEIkFf+L0IuaubZkAy/hP7z6WzFDsK90Dvq4RLL+alKmK?=
 =?us-ascii?Q?GPBQ4V40sjqMqP96nRejnJAslXb5NO/7Lw4GWXTnBlwdilwcNhfjCkjmBtHl?=
 =?us-ascii?Q?SqQVK3njszUUSn2l8K0BSI4iFyz6k8ZuLqxs3PAc0qwcShIjH4T00EG/YLXR?=
 =?us-ascii?Q?bd4onG+enj12iRlw0mRuwWSVOepxxpH9clBuo7GHlOC6jqB9BKP3hTU4OzG7?=
 =?us-ascii?Q?EF8wwlRCSWbjhWGjaVI+wr/qcXdYMAOxF8kVVpmJKOaniZC21FatIPKAQ+Dp?=
 =?us-ascii?Q?8XgCHpsZ4CFl3pVjBQ/Qt8FDfWDGiwMWLmx9EzDv/OvDBv/1/BZbk01vXL8V?=
 =?us-ascii?Q?bkwgybxVzCpfde/HG8n0wdjyARoI8Q3HVBs4RezsMa4xUTpB9aMC0J5TGPgZ?=
 =?us-ascii?Q?FvHZAp2m65hx6437vVU3LqMvsK6zCIvFbmOK23ScKInS60u5DzWenkmDalRV?=
 =?us-ascii?Q?B/UGEENty65iKKPbQFNxSKbZmktRp9a55zDH4dRYd6u+JawzlfeCwORcy7Fq?=
 =?us-ascii?Q?GQiQ1hEbEpc6EAq6tpR4Hho7MaRx9yfWLkbJ4AFWetxWcaylE1jpS1AYTDjZ?=
 =?us-ascii?Q?GN+Tb/d4gclk8VDYrk9BJz2m181CHF27wHjPbVsfCVbYS/u0aE4gRz3jlICT?=
 =?us-ascii?Q?G6Ma3VTJHfdI0YsPqJzvW/G5+q7NFNix3u5JuCNMX4djpZXib7l/5IHIYPC+?=
 =?us-ascii?Q?q2ML4x87ayBWSkJt0iAW817e3JvwGgtNnZMQmegS1r+QxyuNoMTNBRHEffms?=
 =?us-ascii?Q?3wxesnPN0ftnjRR4k9RVSl3tlYftqD/8NpRTEqeY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?lpkPu8l14vg00PtMyv/qCDMvhRK0x2cHEEimID0+w/cVLfUcoEUJnuQJ2/Jt?=
 =?us-ascii?Q?JVd7iucKg65KQuH3hEFX95cuXaw/YdAOP11Fbpdf+X2QyR+IXke4RxpVNm9T?=
 =?us-ascii?Q?jJQgQjeUYitX9SdrjSVUkyAMXNu1pF+hP6D3FeLG/MPyntV4uhyZeBoQNvjJ?=
 =?us-ascii?Q?SXVUKyYOQqwbZPlTckV+qmaGmFWtSzFw1QxI/bL/I6vzCTZFPwQ1+Xkunq8m?=
 =?us-ascii?Q?OyI2spQMqyCQGZernngg1PmnlwyaXQtYxp7GLX719UB4x8oH0K+87ZNRZKOT?=
 =?us-ascii?Q?SowstiJzTcFaYTMG9WQuryifTp1dBw5tPEAzrLyBL1L7IDQLUMyj/M9glI4/?=
 =?us-ascii?Q?ryBPO6VysV3qm88nuzyoi70/CEtwbFt5mRs6z0lYr0AguXoJQ7WkfB8eEeJf?=
 =?us-ascii?Q?aXAc/U8wCxTNLUAXYGt//p6FU9amYC3ymCR1h7+PrcQyKrSavSJnFAqkaJgh?=
 =?us-ascii?Q?twMAn+R30BkfaQVvkluUcGCjGbmaB+aXh+bUooz/UoQrLpbPF0THZcrgpYae?=
 =?us-ascii?Q?GA5qrVYZRsPQBr73mRdpsbkXCM51kZc9hCczUebO3bMPYcRYQlR95en/97vR?=
 =?us-ascii?Q?q0Qz65uy6VX+G8GknwP3JFQkxCdJDXjb5107CUlwc8TPpmbiOt62vZ79mJnV?=
 =?us-ascii?Q?E/9P9AaMbYMdyuuioKT/AVS1IJHTlZLogRh7UJbWq6kL5aME9/pCUTd/ewDb?=
 =?us-ascii?Q?+Zcp2GC25oLGZt0Qlp4xbTunn3J/AWz+MGp4vmJbXSSMcJ4meVXJDWelTpeF?=
 =?us-ascii?Q?2JChQ9S4mhXoemEzrzhXRiBKaBMkaxmnkuQf45J+51zj6LaJWU3qLlA7ruV0?=
 =?us-ascii?Q?YyXeht37NPETg47Z8EizsOQrLFZb25qDVZxO0hicGqXv5kaQwHnLxtVHQ6Gm?=
 =?us-ascii?Q?nn0cYeH/ZizvAk2e28G0elP/Urih3llwrHIx4Jvcfqld2TzpvQcSZKZWom89?=
 =?us-ascii?Q?7j1RvF3Gvg7GlgIOvu7Q7WreLuSgqGMmlD7WqG7QwB2Ekh8gfqgbo1KXrULe?=
 =?us-ascii?Q?iwPSd3KYX2doF3orJzkMdBvlXA=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acbd975e-bd6a-4b01-0998-08db8b3e22a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2023 05:31:58.7945
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FrhwHBD4nks1fWbEP8B0tFio6KHi+OlitKwO6dKCy31IrR8VU5FFuV+bBZakmAqFPA9NVN7WpZuqNpDtuOuMdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR04MB8564
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Only call scsi_set_resid() in case of an underflow. Do not call
> scsi_set_resid() in case of an overflow.
>=20
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Fixes: cb38845d90fc ("scsi: ufs: core: Set the residual byte count")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 19 ++++++++++++++++---
>  include/ufs/ufs.h         |  6 ++++++
>  2 files changed, 22 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> e31242fe0518..b27372f9b488 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5241,12 +5241,25 @@ static inline int  ufshcd_transfer_rsp_status(str=
uct
> ufs_hba *hba, struct ufshcd_lrb *lrbp,
>                            struct cq_entry *cqe)  {
> +       bool overflow, underflow;
> +       u8 upiu_flags;
>         int result =3D 0;
>         int scsi_status;
>         enum utp_ocs ocs;
> -
> -       scsi_set_resid(lrbp->cmd,
> -               be32_to_cpu(lrbp->ucd_rsp_ptr->sr.residual_transfer_count=
));
> +       u32 resid;
> +
> +       upiu_flags =3D be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_0) >> =
16;
> +       overflow =3D upiu_flags & UPIU_RSP_FLAG_OVERFLOW;
> +       underflow =3D upiu_flags & UPIU_RSP_FLAG_UNDERFLOW;
> +       resid =3D be32_to_cpu(lrbp->ucd_rsp_ptr->sr.residual_transfer_cou=
nt);
> +       WARN_ON_ONCE(overflow && underflow);
> +       WARN_ON_ONCE(!overflow && !underflow && resid);
Do we really need to debug the hw? - see Table 10.16 (3.1 spec).

Thanks,
Avri
> +       /*
> +        * Test !overflow instead of underflow to support UFS devices tha=
t do
> +        * not set either flag.
> +        */
> +       if (!overflow)
> +               scsi_set_resid(lrbp->cmd, resid);
>=20
>         /* overall command status of utrd */
>         ocs =3D ufshcd_get_tr_ocs(lrbp, cqe); diff --git a/include/ufs/uf=
s.h
> b/include/ufs/ufs.h index 8316e2408ac3..bee5ccc6e7ce 100644
> --- a/include/ufs/ufs.h
> +++ b/include/ufs/ufs.h
> @@ -104,6 +104,12 @@ enum {
>         UPIU_CMD_FLAGS_READ     =3D 0x40,
>  };
>=20
> +/* UPIU response flags */
> +enum {
> +       UPIU_RSP_FLAG_UNDERFLOW =3D 0x20,
> +       UPIU_RSP_FLAG_OVERFLOW  =3D 0x40,
> +};
> +
>  /* UPIU Task Attributes */
>  enum {
>         UPIU_TASK_ATTR_SIMPLE   =3D 0x00,
