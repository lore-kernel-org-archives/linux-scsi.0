Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B8DBC001DC
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 21:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjGZVHZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 17:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjGZVHY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 17:07:24 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE3919BE
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2023 14:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1690405644; x=1721941644;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rcH/ZT6DGD1ZRu0kC05mW9sjMSVDFn29WGOfy0AN2HE=;
  b=dM6Nqt71rqka8EDrj1Y109RsG1nmD5ek7+AukKqUKod+HdknnIJHf37j
   vj9/8r72AGBh6ArH+zN1HQ9l2hmnvzLu3yORjqNilUjvGb1axCY7DkCSx
   EQlDV++nTizHxPOYm1khrK/hGz0Az3ltpgTopXXOI6UdbvQC5KpcWkDVN
   afjEQpjD2t7XM+Sdjp0Y/TYTW+z0YVXVyjA9ZvKJS/wjohX+dWVxxePP1
   9s0rLVBWu6SXogP8BVrMHeychj5p8sxqELzmvRJF8FYDmnEuL+OVO0STg
   ih7p1LRm4UsG9WUC5Mgx3hPSnMcpSm9peW/GuTakZj31dMtMazCnQS8Oi
   w==;
X-IronPort-AV: E=Sophos;i="6.01,233,1684771200"; 
   d="scan'208";a="238989362"
Received: from mail-mw2nam12lp2048.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.48])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2023 05:07:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFEWzhO1YDNtCBbFbHcEgADJsXDFITny6n02GgIWG5Tu6O1i1biOL0zwlp8kp87Y6YfH1xm+hZkS4nSpLYIEIfE+jB2z0Jw2J1Wf8mjxKM7OPrRNPGlAOhZeqJPUNgnaaJqNPMyOi4GLPfY50avuWX/2pTBMlYAzJL/N/re4iL7aXJSTMgMNDIFV7ES7JXeRBUufIhZTW4OfwGy4iha8cKPsGE2Ij6VO43KfJ8SFui6cC16ESA94eVwthV0OSrSSEkclEbXR7paE+vnhdugUG+gbVrr9e+/JRVirS/lHH91OrfoVevz+A7TK5X1RZvR6WOixc9UfBJ97WV05bWS0GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wT/HsSaCveWLS9i7dIki8jfK/W4PdgMGwN3AkJZ+svg=;
 b=g2LZ6K/gEWADoArvvTGWWopzPxSQjAlo/qTFqoQdSgA7H9MDSovQ7jUZEKF0DPLWo8Gtp0alpiDeRz6yDDSQBRXk5bDw6Ab8dwnfdKfoThhHZWT7yyO3MdK9HZBzqXbIEOMohgu+QB5L6x31stn1FvbGI+v4SpWa8f6Fgz+oqvNhX+hNJ91wpwW529cAq/O63GrIG/17nTdA6A76Ttd8ukrebZFtERre+hQDO+IREcSgjNeQjmGmR/sTmME19TUot9QLp1JCsRTnyOpSrMUIwUBzYwWzqJoOhr2ViUxH32YTj3HyZr2OYxJYoqN1yhlNj38xWVVn7aLjbH7js3yOlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wT/HsSaCveWLS9i7dIki8jfK/W4PdgMGwN3AkJZ+svg=;
 b=UM1mA2QcbmI+CKPyU4ILOYqWkFqi/wLksZmo07RX0Yig4H+AXvqH1JFfvRfB+L1IFcTDvX2SRlNELxGp65IKNXeG1lk+kgSVG9gMVjSW/M2ATuFcn2CrkDT3DYEw2YHxOxXs5s+qM+3W5VCk7ilCSH52k95m/pPixJXVKJpdZaM=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SA3PR04MB9001.namprd04.prod.outlook.com (2603:10b6:806:398::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Wed, 26 Jul
 2023 21:07:19 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::4781:1e0e:9df8:940b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::4781:1e0e:9df8:940b%7]) with mapi id 15.20.6631.026; Wed, 26 Jul 2023
 21:07:19 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        Eric Biggers <ebiggers@google.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Alice Chao <alice.chao@mediatek.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH 11/12] scsi: ufs: Simplify transfer request header
 initialization
Thread-Topic: [PATCH 11/12] scsi: ufs: Simplify transfer request header
 initialization
Thread-Index: AQHZvm2Cufqn2FPn9UeEzlU8isDZ5q/MgNoQ
Date:   Wed, 26 Jul 2023 21:07:19 +0000
Message-ID: <DM6PR04MB65753C9475B5D27FF7AB2FDEFC00A@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20230724202024.3379114-1-bvanassche@acm.org>
 <20230724202024.3379114-12-bvanassche@acm.org>
In-Reply-To: <20230724202024.3379114-12-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SA3PR04MB9001:EE_
x-ms-office365-filtering-correlation-id: 6ee95a27-0011-4aa9-dbd5-08db8e1c4c28
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Nn+iPdH2rPWICzKMLrlymJHssCmOWXF/xnYqU6NE43+nY2SIn8H2Yp4fnZ2PgVL1z6DQDpU9i2woxrI0DIj5kvGNko+ohwClzCXDNjcSqVAC9AQpbP1qf6muafz6q5s8tQA1jADp8Gn+q96yqvioVbx1BAuPaspGoaj0Xdoc1CqCtzP8/SJTLh4pXY1U8yjm7Qe9DF/qfVoFSBhItXObiRCKo/7EdnpbcgJwx0WGhlb0/07pJe5n3hhdHOhwWvr3Ex5id5LCP4BYKxgBUjIws34ZTk4e29aDNPaZJwhGyQ7fUkkju726jJWG+WkByShB0oHPoL8/SNHsdNR16XdnyYsSExd1lI5E/OlPw5hM1FZ5U+ah8bifQbR60L2ckuoNKDdnjnAY+kT7g2K5MlYkEukK4F6xpnhiBCooqpeTz1qRy8B0bbi+DzsyOpoFy5cDaJ8JD6kq6iHD0ASfm8ppU4AdDoJw8IIP5dYB16zW3WxkZmJ/a2GAFLeADm/Og1Se7nVpnBtLBRGkO+bWGHgmXfOtwwbS5jEHIK0lFUTpwpDPuw4f4xzOvILsYfh41GhzP9O854CtUO8aetmuE2ynCt2Faaa+LD/s/sabHkrBeU1moYlCcDuYMKzPXioXEG4L
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(451199021)(54906003)(110136005)(7696005)(9686003)(478600001)(83380400001)(33656002)(86362001)(55016003)(38070700005)(66446008)(2906002)(66556008)(71200400001)(66476007)(186003)(6506007)(26005)(64756008)(82960400001)(122000001)(38100700002)(41300700001)(76116006)(52536014)(4326008)(66946007)(316002)(8676002)(8936002)(7416002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?K69549Uqj8gxJ7ClTp+ZDfmCPAudOz2UivFqrxEmuX/KmERgfoS8AAYdEG7f?=
 =?us-ascii?Q?57hbP3DIZ+z98AwWB/BWK5hLunEDqWtCD2kPlcp1tCz3xiCyCkBGBRsyzycq?=
 =?us-ascii?Q?cJoNpyRku+KreeJXkeQyJRsw+TOWfT+/O9iOK1G0aJfEMtF+1sEipsuKU36k?=
 =?us-ascii?Q?C6FXtryIStZJnPIEF9HRuWL75iKNkf+TrmDuL9WIs5/7qjeoGvN8mGFqBLns?=
 =?us-ascii?Q?eSWbJeRGlWc14KZezDAkjncOMM7iXKzCTvImQTFS7EH6+Lkz3//g79gVoD8D?=
 =?us-ascii?Q?UvhEFhFJxcweizfbGtiNB7iWEtG+f42T0VzsGyDOtcxQ2tbwUcR5mZ2RMYU5?=
 =?us-ascii?Q?GGM5HUNOgD2ERgipIrXdQngR93KhkyY6quOcKk9cL4fYaZguIzOvyUEA1AB8?=
 =?us-ascii?Q?/II5YUI6Uv3towTi9ma8bontYL7Wt9eKhjdEnqSjceeplWwra0Ok602TFzN0?=
 =?us-ascii?Q?SLTmfqY3bGSwswT3JxEY2Jut7xNAazps8oc5WkGWNjhlVbEav292EbRCi24/?=
 =?us-ascii?Q?HHyGaBIIIZQrc/0MLiZj5Wh6BthVjDp4jXvAj3bNPrfaKMbp7Jyl20Pj9MiZ?=
 =?us-ascii?Q?JCiieEu6B9qa+sgX+/Qe7fX3veGPNFPr+r4PnqNdflK4R/Eis3wLhPOwrdsI?=
 =?us-ascii?Q?ATzHw2N080pHDbYbLY8PE5ZL0Kk6YyLNzXs3vdLUbuYzSm+HdKY+wuijLNX1?=
 =?us-ascii?Q?6bEoSr7+UkGS48EJy8U8k7dMsyg/03YXb9Bcd0c+ILFbvKnu/oGspOKa2dW3?=
 =?us-ascii?Q?HZzMrE207pyytwSQrQvooS6mqXmVlbFQs59MDQrJe7hQZkCXOwTdCtFE2pd0?=
 =?us-ascii?Q?bkzRVjACRAXqEQTBqpEN7yIN7VrntOMOMPJwAw8coYypTmTUvyFcYYEdII8M?=
 =?us-ascii?Q?1Cz+ygFFIHp11SFzl/CbMWhxeSCiZJY5m7A/yWpodzQwbMsfNr8N2KAxR9Ub?=
 =?us-ascii?Q?EIsse6nc0HlU/HM8t4Vs43A/+ury6Vp95TxOE5Ypdkm7O++GYJaekTVCPzp9?=
 =?us-ascii?Q?A6o5xPSr1lHoH5Y6hoULh7ZdyK9jUCHhrVhJ8mcMFWvHQw5RDmNAzrx5Ts9F?=
 =?us-ascii?Q?JGnEt+8maSk9nkqrI/iMU9ypDsfl7+Tic72VH9A+nThep25EtjYtoyX9kmZ/?=
 =?us-ascii?Q?WVQzYy9SQ7fe2z/PycHORXvcOwKA2eK5kMm8pMS7GjiIRaWb9jPazKDrRFTd?=
 =?us-ascii?Q?U5aUpNnNXms+T4sDVcl13KG0GH99idXKQUsibzqysBP/Y5iqbDW3KaGEuvZR?=
 =?us-ascii?Q?p0VbO0/wkULwCD+W+zHwFYpWPddTBrALZ3m1TcVeHdF+IR3lVxe5rkqG2BgQ?=
 =?us-ascii?Q?Dz2VgdujlzXYjKOYyCiYiwnG1g9QnOXBK1NPl7ti0DB6THyFozKldfu24Nme?=
 =?us-ascii?Q?MmEMpOdYHhd2G7JpggAdMV0PCAp9OY8Lsz25lcwt52syUdJ8HMRQAMhGJ7Vt?=
 =?us-ascii?Q?Ja4vl/uqq0/DCZXtmoNjkXOGP8pJUmYJiRE62iAlV0XTGs+tWGUgSkBfP6qI?=
 =?us-ascii?Q?P9dhoiyBbFw9ChRkn3f38M7gYj3o8EVE/EmwXZq0M2XTu7rBG+QfZlm5eOVi?=
 =?us-ascii?Q?yXW0e1p65epeJw8V4kXcs2Nowv/NxK3jrJJOsITz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?VYjMJXWydVKgKr0f3GITz9pjGaT63OZdHwjJbkO05Pa/rYZ/q1yjuczNl49f?=
 =?us-ascii?Q?VgizKBYr1LN/hJCGCdbGWoC3IuNhPPpJdRmq4cgZT8Mq/u0DWAetpPCEfAhF?=
 =?us-ascii?Q?a4kuqH+H5YtdlBBrkRDx23Dm/Ra00b/V9CXwvdoEb10lL+bsEX2zL1cnTbIs?=
 =?us-ascii?Q?9aZVYOnyhJubBiwgCM8Ri8AdpoQRW/B124nqEJSQpiom5RSgX7a+wWOdPX3D?=
 =?us-ascii?Q?wZh4d/uNVeqNOw9U03kvE53BbjrOLAUnDxVh/fiuTNgj2VeX1KvLP+QzZKWW?=
 =?us-ascii?Q?seQD6dCdCeqXeMn6vfTMjFp0x6qFXbDKFfHVXsZHENtCDrr3j5lFE8IP5Qip?=
 =?us-ascii?Q?sFQerHzdyvUbZWXPLC67FtdXZ4Bp0hemVFH2q9Pvup2F9q6zSPd95Izgloka?=
 =?us-ascii?Q?riFhh06uGAVR1MhWPdFxQCFN2pPSeZ3Zki8n8oAUEFwvOAHomaJUxt0d9ZQL?=
 =?us-ascii?Q?mSyQXnYRlDbsOjz4EB/hod/Tm56Tc1qqCEsEPAd69/O6sFafHm3sp3ZOEx6U?=
 =?us-ascii?Q?UDf/nW8nseGaoCmR01i9DXivOVDy1JHstqxECXGGsLOFBUPrsGd76uePlaWH?=
 =?us-ascii?Q?Fj9NSnGJSeUddXXQHMzwEWOlzFCiT2qud98GyHgkpxLXGrJaVZeB9Wz/reLo?=
 =?us-ascii?Q?tqlSMcYkyQoovgUWge6NZNkCxcO2RduvCWckbxbZEMiSWyOMjz4KIYqkWgPn?=
 =?us-ascii?Q?p3qseYiubtFWUOw/iylNjDFdkWHXh/eJx4T6lJ2XbormZ0i16UNVrt8QK65w?=
 =?us-ascii?Q?zH3vJf/ZDlIMe8Ce3Bn1p2+M2VqWxxUwflykMLuNZeDT7gW385tYfD1Jg47E?=
 =?us-ascii?Q?BY6jdQ/FsqsD9A1zgfDyLU7JGnNAbYhb3O9O3GGFLqdffUToxOuaO+bZEUlj?=
 =?us-ascii?Q?8lMe8xKL05S+amD2gW0SwWKkqHhMyB9kuP5zAS0Wvu/tAbPCtr6U4XKyUfgk?=
 =?us-ascii?Q?rIzq281KPLPceUlxkMktedW+ohhsycrM8+Pu+eawPpjs/eppKcXwEm457KWb?=
 =?us-ascii?Q?bRgI3Ck1G/b+giFvzK7aYJRSAuv9tN9Trg8Gtu5vlFFltnlp9KKKnW4wVV6A?=
 =?us-ascii?Q?q8nsSHgAcI/u+wDoN2jDFFG+0SbtpQ=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ee95a27-0011-4aa9-dbd5-08db8e1c4c28
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2023 21:07:19.0901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5cZXbBfaGZE4uqpqiGU8ol+0/7HvJf+9vBzw+zgLknWoEbPiIEOsUnmhv9goOnt+yZmMta8MUglnUYJvA5ThRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR04MB9001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>  /**
> @@ -2587,10 +2587,10 @@ static void ufshcd_prepare_req_desc_hdr(struct
> ufshcd_lrb *lrbp, u8 *upiu_flags,
>                                         enum dma_data_direction cmd_dir, =
int ehs_length)
>  {
>         struct utp_transfer_req_desc *req_desc =3D lrbp->utr_descriptor_p=
tr;
> +       struct request_desc_header *h =3D &req_desc->header;
>         u32 data_direction;
Maybe use the enum type as its strange to assign u32 to a nibble

> -       u32 dword_0;
> -       u32 dword_1 =3D 0;
> -       u32 dword_3 =3D 0;
> +
> +       *h =3D (typeof(*h)){ };
>=20
>         if (cmd_dir =3D=3D DMA_FROM_DEVICE) {
>                 data_direction =3D UTP_DEVICE_TO_HOST;
> @@ -2603,25 +2603,22 @@ static void ufshcd_prepare_req_desc_hdr(struct
> ufshcd_lrb *lrbp, u8 *upiu_flags,
>                 *upiu_flags =3D UPIU_CMD_FLAGS_NONE;
>         }
=20
> -       dword_0 =3D data_direction | (lrbp->command_type <<
> UPIU_COMMAND_TYPE_OFFSET) |
> -               ehs_length << 8;
> +       h->command_type =3D lrbp->command_type;
AFAIK the CT is always 1 in UFSHCI3.0?

> +       h->data_direction =3D data_direction;
> +       h->ehs_length =3D ehs_length;
> +
>         if (lrbp->intr_cmd)
> -               dword_0 |=3D UTP_REQ_DESC_INT_CMD;
> +               h->interrupt =3D 1;
>=20
..............................

>=20
> +static void ufshcd_check_header_layout(void)
> +{
> +       BUILD_BUG_ON(((u8 *)&(struct request_desc_header){
> +                               .cci =3D 3})[0] !=3D 3);
> +
> +       BUILD_BUG_ON(((u8 *)&(struct request_desc_header){
> +                               .ehs_length =3D 2})[1] !=3D 2);
> +
> +       BUILD_BUG_ON(((u8 *)&(struct request_desc_header){
> +                               .enable_crypto =3D 1})[2]
> +                    !=3D 0x80);
> +
> +       BUILD_BUG_ON((((u8 *)&(struct request_desc_header){
> +                                       .command_type =3D 5,
> +                                       .data_direction =3D 3,
> +                                       .interrupt =3D 1,
> +                               })[3]) !=3D ((5 << 4) | (3 << 1) | 1));
Isn't this checker assumes endianness hence requires the applicable #ifdef?

Thanks,
Avri

> +
> +       BUILD_BUG_ON(((__le32 *)&(struct request_desc_header){
> +                               .dunl =3D cpu_to_le32(0xdeadbeef)})[1] !=
=3D
> +               cpu_to_le32(0xdeadbeef));
> +
> +       BUILD_BUG_ON(((u8 *)&(struct request_desc_header){
> +                               .ocs =3D 4})[8] !=3D 4);
> +
> +       BUILD_BUG_ON(((u8 *)&(struct request_desc_header){
> +                               .cds =3D 5})[9] !=3D 5);
> +
> +       BUILD_BUG_ON(((__le32 *)&(struct request_desc_header){
> +                               .dunu =3D cpu_to_le32(0xbadcafe)})[3] !=
=3D
> +               cpu_to_le32(0xbadcafe));
> +}
> +
