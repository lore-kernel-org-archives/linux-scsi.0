Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5924FC53210
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Jan 2023 08:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbjAHIU0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Jan 2023 03:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjAHIUY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Jan 2023 03:20:24 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7221513D69
        for <linux-scsi@vger.kernel.org>; Sun,  8 Jan 2023 00:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673166022; x=1704702022;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qKmd7gCYWewxwqKlhEJnkcWfBCloCz1QGxLX5InM/wQ=;
  b=r5//5GBGrv9UciZylF29Aq81Y5ybmEAIgIUXZAD1fS29z5N1cuHCmd7G
   zCiD/YYysjO9dXIfijgLaIicDE55tGpAGWcpCYPU7K3jnYkKcQyOpxGFp
   hiBhqMBudjDKRIS3Rye1VAgAcNZWvEUFp17TSnCeS5JIq9Eqg/dBbLNh3
   yEWoQI1OuXkczIsFrsh2bcRK2UH3hgnexJZyUZJD4bS80JaxeOL3E24DM
   O4ramFTAKh2x7LeMiIx647EdnMzk8fCuu50yh6pteYD9RMDjyGlPRsDbe
   fuxpZPJdl10RVB4kIiCG1sngnXWfdlxH0Ayh6s24CFBNxCTQQCjI7iwAi
   w==;
X-IronPort-AV: E=Sophos;i="5.96,309,1665417600"; 
   d="scan'208";a="324567310"
Received: from mail-mw2nam04lp2173.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.173])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jan 2023 16:20:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bn/W2Muy+gPcDJWN2Fhnrkwb9nnItHsTRwLZN67doUYxTpwJ3IiDXsm3RcLzqFoOOlWITJXnctXbAnjSKfeFEJiQubbLvEMEApt7PVpsRmx/8T5or500SfH8YejPD7Vg5sxMzjSGi0FwtKxipc0CiCpmFk2JPpd+4+9eQPE1dpTRPC+oOmUGdE5ebj71GRnT3sEmk/8nGVj0NvjQGPrB7x60N3q0XhU6u9L1DXxvYUu9gXZJdN9m2l2IEmKwPcvikfZ2pjc6X9n9VIzPwajLTzIHuNLheVXQYOM9bz7oaOAAzxff3m6m7N7/za0UoptEsgDnCHyDcv8p1aSoP7fF1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OcVev8wwboklqY5lj25KnL5coFyg4vzNB0rUwiAtaYA=;
 b=WppGFzQK1X604fvfn1YzU9WkafnJJllL8DB4AxUqboRi8UfbAuaUsbM5iyB3LrXiGGMDzXbanw7lNLSxL+ZnNj0JWDO77k/zhDz4y2iV64UEAzJtfedoWX9ETf2nwai3Ljc5td9QbziUJ/xpimED2UxU6OAijPbgDtkeNfqxdIXPaqgx1sbNkFihWVjblyCwDls34r7h1XHLuilXY8d9PkjWniKCwxgsczaeCLKRYXYd/fxHL/DnE0nPma0pczuFkCKQiZA5yoBJJiFPkPrJEb7wFvR3gV12a+JMFS2bMLAOSvyp7Upd7URuKc6z64530o1SHDLJ/E7GOo7bS+uxeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OcVev8wwboklqY5lj25KnL5coFyg4vzNB0rUwiAtaYA=;
 b=yx79dDdhj9hqxmB4bqoJmhnZeLAWDeRXefyJqU3t6pM+BtPfPAXBdQhl8EGQqP/3+Jo85yULpOm0MtoiwRczW5GofwgN3GY2BWQgEs8cXn0tHbQLK+6qJ/nNsWbVYJc9/quoqCE++RsPAfG7iXNtYVgplajTBjfsWuoGOCHpeAg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CH2PR04MB6646.namprd04.prod.outlook.com (2603:10b6:610:90::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.19; Sun, 8 Jan 2023 08:20:18 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ee92:8a0e:803f:4244]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ee92:8a0e:803f:4244%7]) with mapi id 15.20.5986.018; Sun, 8 Jan 2023
 08:20:17 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: RE: [PATCH 3/3] scsi: ufs: Enable DMA clustering
Thread-Topic: [PATCH 3/3] scsi: ufs: Enable DMA clustering
Thread-Index: AQHZIhob0g5afWfGl0KfvN1TNncD0q6ULzRA
Date:   Sun, 8 Jan 2023 08:20:17 +0000
Message-ID: <DM6PR04MB657596A68F5A93F22D6F6C66FCF99@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20230106215800.2249344-1-bvanassche@acm.org>
 <20230106215800.2249344-4-bvanassche@acm.org>
In-Reply-To: <20230106215800.2249344-4-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CH2PR04MB6646:EE_
x-ms-office365-filtering-correlation-id: 8e60c166-6330-4a2a-5e33-08daf1512d25
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: axhk95PNPAKCcegXVmd1NkWAD/IR6vPL++lzjwusmpJBFB6r+Um+99slmb2/FSzdhPS83ALP/FkPruc8+uiGHvaQvBEiRal6xAiSuUbxBo1KLZNejvndRxUN+AkkzwDzyutIchy+ptIlHnWRssujnTIFUeToC7t3YrIjQHKFsWfz3bAVgmIEat8laf1ct0TCdzVpidjmexBz+Bvj/ZA4sI7lm+fOHtKQJ/fNjG0XNYILk4ZWY+mu9u7aI5Sm3hgxMwazDdsvQV1xr3qpW8Z+tZlyCH90LB0cBFIX7/va+kRDCiL+cxBbxOUTIb0jkZk87GSOai5jOWadHJ657A4TQYAthXplAtvQBgX/3T5GllRpTzbUOij7XmCJ7caflBE2k8Z8oWtM1LOBlMVVARD4dbSn5DLJtjoVKAI6opuGV1dxFQkl3SqycYNY8/dHgs1ZdHg4DG3ckpamox/5ffihVgnJ+Vkie2w0TQ1ZtqkA3TZ4fhhIlaV9Ub+Ujztj9QHbt0MUDbL28mO0zUA2kQjaVZv1taBymaGMy2qFbP13bGHfiUipgnVl0To1Q6rmOEAMC5tTKe3KIxV895InuiaMb0YLjM9/My9Z7Jj2UXqG9vE3RcwqdAWSdrZaYRIJSiNQ7ROdPCqrA+JcuwbhMhldLiEE8yQSoBa7VvzGCz4DyvtwBzb07dyKXT7etGGUBhY9vHk9wJjY55FHUHPkMCfnFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(346002)(366004)(136003)(451199015)(83380400001)(86362001)(71200400001)(52536014)(82960400001)(38070700005)(122000001)(8936002)(66556008)(55016003)(41300700001)(5660300002)(38100700002)(4744005)(76116006)(8676002)(64756008)(6506007)(66446008)(26005)(9686003)(316002)(186003)(4326008)(478600001)(66946007)(7696005)(110136005)(2906002)(54906003)(66476007)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xl+lf5GxYFF2L36BzIo540m5K7befhM2eP6R26/sTvkCXXCiKckw7URboAtn?=
 =?us-ascii?Q?cziLIjxrcr9e4h04w/Ok0W8luLMRdVQi725r8sqMI8FjKDeab/ySj2a6DCRl?=
 =?us-ascii?Q?xsCLWeVro95GwDC792e/mbdUqO4q3ko6IxQWyag+4BIZwxdM/7cmqM+E2CxB?=
 =?us-ascii?Q?76Bfp+U2sLdua8EX2T+n+1iodN6PN1O4OCfpxa0JDrFaxoo7ZU4mmbJJWaDg?=
 =?us-ascii?Q?1dSDNPAr02eAT+aCuhn/zNNMqaWrT9VVmUJGHIA/0ODrHPcEcTCD4fEarXm/?=
 =?us-ascii?Q?HI3/AXmG24ym6Ula0oakvgh90yp324l8cTygYkWlf6LC7Df7oxpRXUHPsExo?=
 =?us-ascii?Q?TcO814gRJ3+4C8L53ACWoo2owLX7U09vBChotqCucMHOZMo5xNaxVjrFBzL6?=
 =?us-ascii?Q?Lp4U73iXr8NfARkUyFWrWh3/keTiMjxwyYnG+8wpUXHsmzFfJ4YOTSTZNmaK?=
 =?us-ascii?Q?cHn7haCddt8RF7E1tTfAl0a28XA880xe57pPrpGFFdFJRGJgfix4sOUaV6Rz?=
 =?us-ascii?Q?fVyy8fnrSsQhUG8b7rCnsjBkFg301on1HGtvJ+RbtWnDbW4ufgZGxBfqTcyW?=
 =?us-ascii?Q?9jz4ARteWsRh/IMpk2pWUa7d7W6XIrNVjj94+JYVhVTXbtrvYnqqkDuMEaAf?=
 =?us-ascii?Q?MvMOZ/S5tARisqTACluA4IZJdjw8ScH3jyFEMg0M+YU7u+XS8BzteKAB4p8l?=
 =?us-ascii?Q?kJeTCDA96BKfT22KnGFDYqEZpwdcBDUcqk3JsbhLOjnxkmPuWA3PVi55ZopZ?=
 =?us-ascii?Q?CCV/dYp4VsMJjpCqLzctieD4xPAE0u2jO8u7ZHkZrovdMsgYsv1xRQPAkGVq?=
 =?us-ascii?Q?QXubU9HO6LcTplRJCbTho5Yihz9dZqjZ3vbmHf3sIzIQhfKyyMiGjx6fDgz8?=
 =?us-ascii?Q?MjuRiUVeN4S6EpfMXjvdXLPRudA1cVBRhAdhieGHosRK0Z45/N2Dl++TEg38?=
 =?us-ascii?Q?I4+Zf9/uIkUiXMhZAU/sFxD6cleqwOyaAmQTT8sXHiY0ebHGd/SeZQDltaQG?=
 =?us-ascii?Q?y652uW0P0ESzqIJsChF3knmtvFgOBOMu3jrrTMDD7xui0egTp8NXvGG3A5DN?=
 =?us-ascii?Q?8A/+DCQX0vrKhse7BPEsnm+flFYYoCEtnV8ujdzDcVsGt0s0+Co075cVN3RT?=
 =?us-ascii?Q?7kk3kpbMqcu6c8zxDHT4J/DhcqePNCUB+YD2cEIB2jC+ofakSlwgaIRZrYK7?=
 =?us-ascii?Q?raF4A3gn23fQn86sYX63Yp+NvcVnb2TAA6k2j9jQi8ibkV3F0/ulEtbpaevn?=
 =?us-ascii?Q?gjWiBnw8pukoBRoiQhal8A+v79E5bcPmzL131R6XDBLTqiqu2c6NFDTrSfxM?=
 =?us-ascii?Q?Rj+tUXvytMpCKxVop+IeLapln3zSSLQiYPiODMRwtiIDimzudXuXybuWJJ66?=
 =?us-ascii?Q?+FqirfETTDYb07gqjLL2exGlx2uqWlbovO2gy+0G8GpxQvUZg8pFUItuN7qS?=
 =?us-ascii?Q?F8tyI0yVSDQ6fsAp/RCoQoeWsZBhufLlUSC24dyra2zcwa0WorZe0q2SPKOX?=
 =?us-ascii?Q?eLrMJ0+3eFF8u7WYTjnhxSb+CtaJiP36QgYYbkYVMRA8aUqiRk7n0SVMuvnq?=
 =?us-ascii?Q?nDi4iz36bseyJ00j8aiHzIiHByOKk/02J4Qlg2yn?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?3fzE8JWjWAGBzyikgzaWsBxztB9SPyO6fw/bO5P01EUbop2zqcJJfkTcYBBx?=
 =?us-ascii?Q?E+3Yu9cLyJy//zm+EqUVCRqHgd2pubSmbyBRwu7HehTyRzck8GQGKzsyzVky?=
 =?us-ascii?Q?Dap+ZgTdE0cxz00xHJDHjlW+iguxBvYEtyUqkHboU0dky+XxluUPUwSciCUX?=
 =?us-ascii?Q?8KeSsMl97VrRGSgv9ywnSYaD3b3IqrWt38epRznPvCovIQ3nRZDoVP/mu2SD?=
 =?us-ascii?Q?9lm1+LdEIK7BaAAdLvefjEZeCxBcd32LUcHgnmB0EFtUCX7pTTm2hdkSNwqq?=
 =?us-ascii?Q?VnmEpSSJ1Cx1yYJoCnMPjgNkvN0HCLU08T5zuVVS31mdRZJrT7hOR3R4yAiG?=
 =?us-ascii?Q?h3OmvI7OJud1UOwhpMd5+UiHsnkvRMmFaJ0//NKpxFg1INt9xwhJOIyujUij?=
 =?us-ascii?Q?fayLdF8Wd7ghqIUsWix0o2UMexWnGhENfg3y4qZgBdDZbcHpBw2yypl9r1B3?=
 =?us-ascii?Q?YMVkmIUxT429nHEAWYXmi4gc7gXip445luI580aaelfxyGYm2nv/wC7mQxyJ?=
 =?us-ascii?Q?IrukUAzVjWXd37+5lI6uLLd1LDcUQrnrjVvvGJ8cJQK6CkMuUTUDvB+LPQcd?=
 =?us-ascii?Q?oAaZwDSmwolnVNq1tPTjm8l3++uqGsqkfOJMn566+pw19YUoPyOb7r1XTPTy?=
 =?us-ascii?Q?+gRJimr2RgIlzNuQYSBUMu8rLc3UDaglnnbKRPdu9dj0iwRMDES+M0E5IeEM?=
 =?us-ascii?Q?DBR4SoOtiVRPsPMtI610RCEFhnyPrtzl0yh3fuCBIo7lT6JhGnFcjdLxQqd9?=
 =?us-ascii?Q?WslzUP1tivvC9WSDUkb0bfWNdFM/R1XdkQP7X8bn/pGKS+iO3uP1hgrWg/mq?=
 =?us-ascii?Q?dtVJ2Beak5+lWQqrI5/Ps3PlYOd9+xMy08zFBER8NvTkgcOCrku+sHfjpoQ9?=
 =?us-ascii?Q?LgFWODFgFAf/cyZVIZfI/eQk6/7fTVvf+IO3Dpq97K3e8sJIPN5W1RNzqJ9w?=
 =?us-ascii?Q?VWRkJktGUchyR4M0FbWSa8PVeYP/ZFq8mhwqnkGYGft8KhT3H+s4EW/KhuCi?=
 =?us-ascii?Q?x6lzhseZ4v58sEWCmeN3wn4NjQ=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e60c166-6330-4a2a-5e33-08daf1512d25
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2023 08:20:17.7946
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ll6k98/T3tYEayPAJe7tKbbPqix8NeoW0ev1MPkknbzGyIbFrwlCwZ7DL6WSb70ZM797mqun7g7FSAYz937m8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6646
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> All UFS host controllers support DMA clustering. Hence enable DMA cluster=
ing.
>=20
> Note: without patch "Exynos: Fix the maximum segment size", this patch br=
eaks
> support for the Exynos controller.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> be18edf4ef7f..fe83fdda8d23 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8429,7 +8429,6 @@ static struct scsi_host_template
> ufshcd_driver_template =3D {
>         .max_host_blocked       =3D 1,
>         .track_queue_depth      =3D 1,
>         .sdev_groups            =3D ufshcd_driver_groups,
> -       .dma_boundary           =3D PAGE_SIZE - 1,
Isn't DBC <=3D 256KB implies that for a boundary?

Thanks,
Avri

>         .rpm_autosuspend_delay  =3D RPM_AUTOSUSPEND_DELAY_MS,  };

