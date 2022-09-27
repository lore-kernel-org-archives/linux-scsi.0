Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E99D0C07E9D
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 10:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbiI0Kl0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 06:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbiI0KlZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 06:41:25 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092DBFCA48
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 03:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664275281; x=1695811281;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GVWz3LFXyAIZXO2QCyi+w+BS1p63mmO5YudOfaKB5wc=;
  b=i1Gwncvavb8GyqOd+bo3cMJWW1d5r2QooZofc0lNMo9TzuZYyZBMBRk8
   F+x183vr6SrglyMLVRgKE+xfSge9mk4qFhNVtxVIP19gy2O2jPT50nX6h
   46ZV4PDvLJEVIHrhRdoYMe6HzN061ZjTy+OA4JLYqrETT/QDaKrLGUi3d
   dwKrO8clNL7Ut4C8gH5iMbrImHEo10nLLBP3a2J61GQnUlzvm8kmSbmxP
   iF07LbOmv8cYipb1KzEmqwscCDazkGW01KsfKy1w7V9QzP2js67aD15/0
   npW5Ddb/cIdWQwCLs/ONrrIDuS16m+xqOs4NQmpxxCosNCLxGEoa6KZYa
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,349,1654531200"; 
   d="scan'208";a="316652594"
Received: from mail-dm6nam11lp2171.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.171])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2022 18:41:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MCnaYy/+nqR35WiUTm8ssOaF91LzVXhB7RyQsNtudxM2h+TsdO8X4etsAnqNomJ4Z3cDd4Qn/U8Ea31oI9Uk9PpOOceSc4xFbZkrVgHoF5vyDZAMyDS5KhFggZZQPY4ldn+3UaUadmwLg+qLDSfsBn55a+yXxsXH34Z5aglU5D5V44bQSQCRXd4T9sH+EgLOzmyhLVp1ZV8MRYRpwwQFr6W6bKTRH4k8anZYFMUfnlaU+lF+ee9ImgnSzB8iaIXBG2NroBEvaq2vwlRDG7PrE9diRZQaTELnMRcNLRlq3vEGV4X4WTOSBx7Xo9xxl+JXpu81MDndIoDIXxEPpjafxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CxYrqiXkMGVNqXkZwnMRm2STzY/2rsplS28bW4HtQzk=;
 b=axwFL9UpnKB7Z6B2Mwot54uwKxo3YIxBoUGXupZcl8bJRfwooi5Iv4sCr3iEigC45g/rgv3ai1lcOB+GENWT5l0Wj3eys8os50u5yJRD0Ti5FglLm5xdicPPXnR5nfzG3cE8gbvARPsWQ7KVd/46UuX6xs1KwO7ngozYMXneV9eAzyvzegTFFJta+OTP0yguslLKR3Cy8RCoLigYOiaXFFCCuKv8VZ78lUbuhYjEgqfNHYqLLgkci9gvs5QZLHMByc1Of6bVqMVYZXjcqB6oO7Bxu2is6LRbuUkdKqX7ipD2U/ZPn16HExCmEb12VtFLIx5u3BTPdMk0mgfLHiqN2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CxYrqiXkMGVNqXkZwnMRm2STzY/2rsplS28bW4HtQzk=;
 b=L4oVPUbklTIiFgwQwrapiy+joC1PMjqXnJucQIEITfJOrvQmucDW17PJA4KMB2zMIxiKKrRL44YEDbPpZGP72M1AEg4CBOSim8p1z+mU65r+7bMf14oEkOCd+86Om/Uoa0NczfEAE8C1jTgj8NS5lsjaxFZr36OblQRurZkhgBY=
Received: from BL0PR04MB6564.namprd04.prod.outlook.com (2603:10b6:208:17d::11)
 by SN2PR04MB2349.namprd04.prod.outlook.com (2603:10b6:804:6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Tue, 27 Sep
 2022 10:41:18 +0000
Received: from BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::152f:249a:afc7:d6d1]) by BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::152f:249a:afc7:d6d1%9]) with mapi id 15.20.5654.026; Tue, 27 Sep 2022
 10:41:18 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: RE: [PATCH 5/8] scsi: ufs: Try harder to change the power mode
Thread-Topic: [PATCH 5/8] scsi: ufs: Try harder to change the power mode
Thread-Index: AQHYz4jTebvFRm1LCU6A4TC9BxtZLa3zG1tw
Date:   Tue, 27 Sep 2022 10:41:18 +0000
Message-ID: <BL0PR04MB65646BEA3CADD907E21C64B5FC559@BL0PR04MB6564.namprd04.prod.outlook.com>
References: <20220923201138.2113123-1-bvanassche@acm.org>
 <20220923201138.2113123-6-bvanassche@acm.org>
In-Reply-To: <20220923201138.2113123-6-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR04MB6564:EE_|SN2PR04MB2349:EE_
x-ms-office365-filtering-correlation-id: 74206648-e99f-42e3-74c6-08daa074cf49
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r54BH5i54711CM5owy3GQFok3iNTlxj3CbPPV0aGvGVGJDjwpiMLIRKapprKlgcVuUQQ2akt/cNPbaU3dTA7/lIRp43TEpuHPtZ2B7H2VRpf2AdDp4cPsZa46x5LT0w2NFhKh8p31DhXXTp8SgHhLbzGBNsDVd75i3wdGq89uPZ8SfkK8Xa0JP50mj3O20Zw84xdhHgnt/tSMoIO4CMWymORuCFRNYeqpexmQFhsdqokakOnksp7YqFSn8i2JfdP/2jKKJxpgb+x4srxL8k1hiKZT5byVuySq96H3ImsHjGmTzF8BkiQR45YgTPZlRvxAf4TzAcibfIbHcuYSfz3eW9DI/tqcqOv4urCu48wQ/kPvt5a+i9hU7U4UJjvJm6mtPN6qVFGPVtwOYuouuQ5Z8BwvxzSvysROa/HotilrFm5PkUdynvTZe2ExturBiZ11aLtcHz4le0n4QGUF5aVd4k7hWpD7ZsjxjRxrE6IvkGBjMLNqRkcUo7wkBKImmxqBtmVbK8rKAhpXnfrxGxCBSD0F3UbVlimcY//4vqcDC7gvKtv9mwpGjF434SYQ7EURv1nnhbeUXxkAGLcckGqD91+qGVW78fO4GDUrF5xNINXOktCH9GA0N7dNDAq1AFboQwN62PcbtRqQIhqRq/Pk+Z3D4BhgDDRb1g65NVFL16cJaGvHiguj8h+Kb7LwxPAZjGuX4RB4Fu7HTxJ4IzulOi3Ak1ZEte2yuzR6pMqXzhf00Brte3jSLePCuMGDK9AD3/Xyw6W/A9wPgFI1S6O77K3h0RwQ2F4r8YciBitQLDdNFko+tAJg3SMz5lio1Gl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6564.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199015)(66446008)(66556008)(66476007)(66946007)(64756008)(76116006)(38100700002)(186003)(82960400001)(2906002)(83380400001)(54906003)(86362001)(110136005)(8676002)(41300700001)(26005)(71200400001)(38070700005)(33656002)(9686003)(55016003)(478600001)(316002)(7696005)(6506007)(4326008)(4744005)(122000001)(52536014)(8936002)(5660300002)(34023003)(148693002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ca3mRJfFOd4l1W5Hu5xTDKxnZ4ZYsLU2gzbLd5mfM8eMEeE+FGzuu1K40DnT?=
 =?us-ascii?Q?QIfVgQZP/eUJEjm8yUgqLCCt/m4N1Yxz24+2Ijq6SHYAlSsuW/zYaLkhzMvc?=
 =?us-ascii?Q?RGRCfRDKR1DX5kWZgrv05Yqt9caHnNH8GN0TRvopVX3qCy30QHj2DT2TjEzq?=
 =?us-ascii?Q?GQBXfj2rIQcikmb20fYB6bN2GILCe1aKyMKro22bK/i8wIKaV3D+hmxpXytX?=
 =?us-ascii?Q?Jk00Lxf/Nt9bgRKZfPN1QZHug/SRR94vkJdI7qSVt+UHkC+yct+4mp2467RQ?=
 =?us-ascii?Q?qjSeYkNerJtZ86xLoBhEhCkjJ6JCqB0/bitkK7MqHZTfEDMu9ep6gf93VvzX?=
 =?us-ascii?Q?P3yEP2AfQ9w2KM728Hy3Y9EnpYGGxVUL84PYBVHMezFDeNzjQuL5Y0EVzStv?=
 =?us-ascii?Q?Gx9T/62rt3WAVgKzVoB256P39sP24oInkqYOmA7ybuc1WP+zJWhuUr+bfD1O?=
 =?us-ascii?Q?OBxY/UF8QlIh8Di7rY9ZwlfosMmvoqH496H0eeL/4ssSiCdd+yrt0bZppPhY?=
 =?us-ascii?Q?DPtt3KuDAWaK9ol7Q+gKct67Fc/Xh2KueUABX0+6vD17gWkIudJNc2nL5BDc?=
 =?us-ascii?Q?OgpBAJHqqeyCNd7Ug0M+lKghnXhS/tv7yrToXsSNGfXmBagWqcU3Dj/d5P2x?=
 =?us-ascii?Q?nwzmsY7Bs6M3ULfFnB+nzJqN3AqEA+gSQicroKp3Y3mF3bZ28zWCIrayqwJC?=
 =?us-ascii?Q?NGsnY52EH8Zj32eq5WcbANZ59Te7TJfVb0DkBGbJMXosMGn4btcCEvm2apTZ?=
 =?us-ascii?Q?NcIjNYXjQwaMERJO1pHF4+k+kUmeKSrBUxrWjV76ip2qWyclEyjoqjrSaV3u?=
 =?us-ascii?Q?cRh1o9yKu+MHJ0BgggCSvchgPVFglGpcmWGVkElQkWCIgWdu3UdBlLgvsN2T?=
 =?us-ascii?Q?3/+ZVr6hJTIKzyPEJ2M6mbs0KMMsA5idBd7YhnlIJcFrx4SzNm8GJChmCeRv?=
 =?us-ascii?Q?zY5MZOFiaGXzbYlOF66TzQuposMqqOo+T3ZgCUFGlsEYYXEMZwQR97Xh49hj?=
 =?us-ascii?Q?F1mcy+3ilbmGzpOoIuw5N6cG8mCi51o9tKXm9nf85l2zkrjFeP1iUDV2VnLG?=
 =?us-ascii?Q?hliHk2Aix+b9+XZ8k0PaXHn2E5ubJTxBrWoHBroKgL45FZ1DoS3e0IrF+P5T?=
 =?us-ascii?Q?trQVQVhMN4FhnpQjg3NWypvRviT9a1yWpnALM52jko+055lftRgpAxJ5LnDB?=
 =?us-ascii?Q?8LZebbJA85Sim98xEpm79lNXwD4kdOLdEnht1Tu/1Jm1AfdiufqdABm/NclQ?=
 =?us-ascii?Q?w/Fd2A4k91QgbDREPsWUfzkt2r4kpNRUt4GqL2F6CQohwqBhtCPLZBz5RtRw?=
 =?us-ascii?Q?5KRKnL1nXIlmNn7rvYnaYqKVsgLTzrvQzVlAtT0138cEeI9S2ZSHU2+vWikv?=
 =?us-ascii?Q?w/fFrjeT3Qwkh1J++xGr/ZG/+PDlhwiCO+13VVGt60CHnxWOtcaqST4dC0In?=
 =?us-ascii?Q?BSHaaLukuX7lbuJF2nMVyvGYgi9P8NyhvUKTIlnx0sdLRcHyFKJTe7aEYrdG?=
 =?us-ascii?Q?Ewm+cUlmwypf1CVDqMWfvQYDAl4wp7tu+eXmnBD5tMXLFZC/uoSNEquHKoSI?=
 =?us-ascii?Q?kt59aTqvOg//hw8dNZ41cZqP748v0SeDRjoOjZmC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6564.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74206648-e99f-42e3-74c6-08daa074cf49
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2022 10:41:18.0382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: awlw3iyDI7JMkD4eq5/cAhygjpTVYn9S33sAh8yT0AE0Gp1bfK4hQQxUVKq05dnnrMQJfBSWjgTXZH2V2FNUzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR04MB2349
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Instead of only retrying the START STOP UNIT command if a unit attention
> is reported, repeat it if any SCSI error is reported by the device or if
> the command timed out.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 02e73208b921..e8c0504e9e83 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8784,9 +8784,9 @@ static int ufshcd_set_dev_pwr_mode(struct
> ufs_hba *hba,
>         for (retries =3D 3; retries > 0; --retries) {
>                 ret =3D scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &=
sshdr,
>                                 START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
> -               if (!scsi_status_is_check_condition(ret) ||
> -                               !scsi_sense_valid(&sshdr) ||
> -                               sshdr.sense_key !=3D UNIT_ATTENTION)
> +               if (ret < 0)
> +                       break;
continue?

Thanks,
Avri
> +               if (host_byte(ret) =3D=3D 0 && scsi_status_is_good(ret))
>                         break;
>         }
>         if (ret) {
