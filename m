Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4931CC4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 08:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiKII4Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 03:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiKII4W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 03:56:22 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2FA18394
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 00:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667984180; x=1699520180;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EmzcwmII31qtndPqVNHYZDEAuj9q9k2lPaojNFvKk0s=;
  b=AJy89KabbR5XakzPVWibdZRgJo3pCj5oioJ7tKiNP6mf8oRx9Pbi36AT
   HLDeHYSj7W/oVAIyMJv1pKG+KHoa6ZAvGeJXWiMri/ZWlr8sYGkaTr1Tw
   DZg1rrGlbp16Hh21FD8O+zE3D+PuxPd2RFOfIITH2k3g5utQUXHMelbdO
   r3PJRXCY0CXnlvI4rHOu6YDPBGulfNwHYNXZDwriCWXB0UiQWramdL36R
   JQ81gMM67HpWOOkfMuCuNuSyaH34HepF5K4pA5w07czinluWbr5LSqCPp
   YhPcrqyTxky6gbYCfiw6P3RHRm1KsV/jP8U6I1kgO8Hn8PAPgg5JmbtzG
   A==;
X-IronPort-AV: E=Sophos;i="5.96,150,1665417600"; 
   d="scan'208";a="216179057"
Received: from mail-dm6nam10lp2105.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.105])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2022 16:56:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UM79g7dHaT4tjyv9Q+ERyDiEn6hKzKB2GfVubWSOs9HSc9cooL2JbRtCYZXzPrt0JcCBeryLImK/ytGR9lwC4TwWqER0N58Pq8+uhIC2WtVRVU4s6/ISdd5QMNiCldnxuZfgJT2MHk4Ba9IJr2w+vIc6gf8gdSSFtEehT8cNYoIoLpBksjDOCMj4NmQDvoSD9cYjQ0803BTZ+iCNxntweUk6UxZmY2iFQQXjLBkc8zcjY5qZqRZPUOCFaF0v2CquE/WFALRjuTGPUCUo7VaMncWPcj3Aemup3rhAIK91YfBw3VQBMdFTF6vHBSBsQlpuOTAQB06BVHJukF1oyRahdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EmzcwmII31qtndPqVNHYZDEAuj9q9k2lPaojNFvKk0s=;
 b=Y4QKCkUor2RN3TuR5zUUNaA7rPLjKoBGUhWI0SagNfMD5sKDtju3gq8o68O/f7fSVmXGOO4z152JLq9x/l9eCw3U2U5/XOvUZZRfRB8jCh2Ii2dRcXXVqz5b8zBv2BxMb6OIGPNvRp9YqOAiwCIsZCO9Qfh4DBIea+yNIIug/3XNnD1Aduvv/3oyLNKdm7JjNKfc6DspXnIWB4Z5Ot8jzXz00CaydmELi4HLOAg1roqQmk6wqHTk+OOqbUpH94WpckdixmV769fHw97cnEyVk0GJXzuraLpjocXSMXRbK0ECjA7wdUKCtYF07gr/dWOKxaEYrSUigKoOmRkGkkYvsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EmzcwmII31qtndPqVNHYZDEAuj9q9k2lPaojNFvKk0s=;
 b=Ou/QKWXVaQNm2Ii4YYcDuN1N1/yekEiv/GUffJkx2r9T420sGx5wc753T6Jcbm4NzBp7nKjQt2t0XGNWDXSnpblTJzw7waTmKZOBsxq37vyhHVq1U0u0hp00KXIPoEjnqe6+CGRt5MoR9Npuol64bYbfECHrD+qCa2uMnyPuX5Y=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BL0PR04MB5057.namprd04.prod.outlook.com (2603:10b6:208:59::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.27; Wed, 9 Nov 2022 08:56:17 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::1afa:ab74:ef51:1e72]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::1afa:ab74:ef51:1e72%3]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 08:56:17 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH v3 5/5] scsi: ufs: Allow UFS host drivers to override the
 sg entry size
Thread-Topic: [PATCH v3 5/5] scsi: ufs: Allow UFS host drivers to override the
 sg entry size
Thread-Index: AQHY88q/VqmOHdmxGkSI0uQCV/pSWq42SWFw
Date:   Wed, 9 Nov 2022 08:56:17 +0000
Message-ID: <DM6PR04MB6575A4065B76D03A7B6F8B5FFC3E9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20221108233339.412808-1-bvanassche@acm.org>
 <20221108233339.412808-6-bvanassche@acm.org>
In-Reply-To: <20221108233339.412808-6-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BL0PR04MB5057:EE_
x-ms-office365-filtering-correlation-id: d4214883-b2d8-4497-c475-08dac230439b
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UhZv4qXzDbbiHlUwamXhJKKWVGmbJeWjYzK8g/ugKr9A7vgcbdFZUGNu8GzEiWvgye+d/aq64p0kglL5kDE5WMqpBZWSz2vxyD28A5oL1o1u+bth1NiZ9ke/BmwUtIebl+SWpolAikligFIX4Jw+If8BgoH5v1IWLmcJjoFDFEq7okz7G2qFWc96p6Lr7I9RgFeE/RNhRQfY0qciNmUNj0WYd8HqBQi8z1MIReeM70klxjQi3WQtlKjraGKZS13Ox7ZUJ1sql4Bv5GWVT7/xftMyrxKc+9r6XXeDhuz362OSigYF9GfIBDnK3SsJvsxMNy1T2rCpQ5va/BxGKFpc5eXQ6cWXjUdnAfP2v1xxyMd+fCsfRfhvnIJ3NYuHhP/WZaWIdbw9b16e5CHAEdGB3HgPBU+wdGjx4c2d/Ptzjv9i9PgKNBdl0VHPJfwRGlYV3K7iyOmissEwf5yRtZdCfeDt6yy0tfQEJGKXIIHj5hZkE0YlSt90fjLNAgPdxjkMPrVxtYza9hK6qOrXBKtloTZiobHfAqnsoRl/+W8Q4RzeCbYpMp1smouwl3Jy86UxoDWkmxMxjljSfR+BCLuQkJLIFmjPM9QpomcVw4FG5I1Q2wG6bG4WfV0easqTOyAglzidg7L6iUbUILeU545Gnay/r+8g2G7UDic+JeWKf3AQTP7l5hY2BcaX5x+t89ctLldPGan5chRj8ZYkdqfGaB698Z6IBhgO4cadLg7E2t4viwCZejzIq2Fz4Saxklag8yovj6JpdUy0TZIsdsCZKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(366004)(39860400002)(346002)(451199015)(83380400001)(9686003)(7696005)(26005)(122000001)(38100700002)(82960400001)(186003)(6506007)(4744005)(7416002)(2906002)(5660300002)(71200400001)(478600001)(55016003)(110136005)(8676002)(54906003)(4326008)(41300700001)(8936002)(66446008)(316002)(66476007)(66556008)(52536014)(66946007)(64756008)(76116006)(33656002)(38070700005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zzqUoNokC4NRlygmBX3U6OY29dU7GSA29DMbI2+JUFwJA3NBLbWfN9u34coh?=
 =?us-ascii?Q?ZPWumKDHOXu7yA2rWfxa7oVNrwkMVynyJfndpFf+l03vyyqfwAShEYssUuSq?=
 =?us-ascii?Q?QsAQoeH6YzaydNf1VUSyxuYtcgKVHCrONulewlPIyRpJTepsEmBuUI9Mt311?=
 =?us-ascii?Q?LQYtvuJDhxwx+PUOAFKqnLOvJWfmX8Qejy/lO6OMj8KcB7PSozdbsGVHOC0E?=
 =?us-ascii?Q?AVOoHGLK7nw0IbEdefTvszVD5Q2t/ib9Rrf6m74SJOPsMmzwE1QGlBZJifw5?=
 =?us-ascii?Q?fIU7u55Rd/DxkyDfraWkSgH8QyZHjE7CO3WFZyrWwDJZbmRhQvuPc2RpZM3R?=
 =?us-ascii?Q?C4yxOrjxBo4W/GaUaxbQOHYLYhxWZLTX2HW8I8xXhIjYDWy4Hayg1smIC6xJ?=
 =?us-ascii?Q?SDa7WGbUlx/DLIWKlW+RX9G90yp0ilW7QcEdUWmk3VvIGYHnVdiWnd3dPmYX?=
 =?us-ascii?Q?izEgGLpv4IlFo5Fbf7WdTOh8CbnOE8h7Y0DH8Mqr4Mbo+ScSOjsF3g12cfqv?=
 =?us-ascii?Q?E0gE0/nYl/xX11KHSi1COriKLCVhFFBFE+OOXjGFwKNWe73vTsSMvzFHkYfy?=
 =?us-ascii?Q?WFHjty8ygNTZEkLhifEdYfB6lm4FU91zQTiRf9lYUNUFtCZxcvE/bVzp5TB9?=
 =?us-ascii?Q?JJMCbWuKCsCGRxi19BNa0ah19J7p4KHOA/ZP2wbilbSlTVJI0Nqjo2nCTgEK?=
 =?us-ascii?Q?2UMUz5mUFn9Dw+srmrim19PXjeFZ7oS9YM5nODg4pDKHHPGYfT35gwM4iMLl?=
 =?us-ascii?Q?ldg1Jpwahl3hHbNUwsJq14AE5QlwFkkDCriDMdmVhvwuAKNSz3CpjuNqDYlx?=
 =?us-ascii?Q?LNMoVE4cs1wzBIH547hYUR5leSY4Txw3kdbBxz+1f/2i6Wq+CLgEO425lmm/?=
 =?us-ascii?Q?lmjG+prf+RUPaVrJlY81C/aFpS3FVNrtZA0vBkYRuYL5L5DtOmPIK3vGGdk3?=
 =?us-ascii?Q?PMEQ6djAukflOvmzRlZCfM63vRn9Nw4nQ+2OlCkMyxuyYYgCg9tBHrTHYFa1?=
 =?us-ascii?Q?lSpLaN1u5opq6LIJvR2BVIE59bmj2EgmMvvTxNfGraTRLqljmZwqzZBk8D/8?=
 =?us-ascii?Q?XsQKQXHLjGBvmRYyh6AiHdZqsTOiWzn1Skx7q/B4puOpJsG/0C/iiGMEFWif?=
 =?us-ascii?Q?1jLI5dfOKT8bIBNjIZZrRkA7EkWlxpfpY6s3+pigwlzJ4Habo2GS2KeSSPsN?=
 =?us-ascii?Q?2mKdkGJBaBPoC/x+nDRa5VkdW7DdamfhhVhqJANYlyyEKl6jiuYQWPrfQv3P?=
 =?us-ascii?Q?yQxcWWAJRmdqmJ3wRTq9OS76fQ3zWCVdssg5UUf0G0qfX1uG37qghxTjT25h?=
 =?us-ascii?Q?NyOgd33GXgLGx3Co0Ot1cePVdvcge5IRXJKtGYw+VLdpDPA/wppyKVgjLsO5?=
 =?us-ascii?Q?ushSMzKLWz6aWKtXta9dMAhiNp29OA3vCfDkn4SHuf5Z3Plr/BH4YCObGpts?=
 =?us-ascii?Q?Q4/bCZCwsBkMIfdteJ7eIGOB1X8OnEcTMRTYR2rQikCscYPHL8aPaiMD77wZ?=
 =?us-ascii?Q?InBj4f9L2sil7/eS86cyX77Sxi2jwBbgIM74QPgRrWQxs6qmDLfJS20Ruyej?=
 =?us-ascii?Q?it1uhypkohmQ8qXyQjaBVX9TaSsVQIEVlQMtwoyT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4214883-b2d8-4497-c475-08dac230439b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 08:56:17.4378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mhNATA5Ff9HWO4x7lPSHd+vlUKgsWomshTR5SQaFUM05uvgIhnGtGpaZszvbVEpVSzv2O7w2cqXyOi+eNzbf2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB5057
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> From: Eric Biggers <ebiggers@google.com>
>=20
> Modify the UFSHCD core to allow 'struct ufshcd_sg_entry' to be
> variable-length. The default is the standard length, but variants can
> override ufs_hba::sg_entry_size with a larger value if there are
> vendor-specific fields following the standard ones.
>=20
> This is needed to support inline encryption with ufs-exynos (FMP).
>=20
> Cc: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> [ bvanassche: edited commit message and introduced
> CONFIG_SCSI_UFS_VARIABLE_SG_ENTRY_SIZE ]
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
