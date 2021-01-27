Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C941DC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 09:06:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CBB020758
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 09:06:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbhA0JFD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 04:05:03 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:40107 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233844AbhA0JAv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 04:00:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611738050; x=1643274050;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bT6ucDrK4mUulaqU7rMsCPYQjV0SkeLyCvk2vxVp38k=;
  b=lbpHr6ZW1lJkzJLe3Z6oNqZXMDTZfd+v0tNvnPAOADjFQuEQ+ibz3vyb
   nGxYpbgHTV9S/jYIzAuVSqPJrICIEALCu9tYRf4t+L3+oDiPrmj19Vm6P
   JNIATpPaCg/llxfHJqw5GG9NCk2kCqoCR0VYXsAkwQ2CEhaaIIaR0IAmH
   FSEUeQivaP/Tr7Ng5w3+YIMh8OwRD12nOoRo71h2vKNzMXohy43odprfI
   LhqMRBhg1jO6LTkgWiNPvPR61AAWUK25TNSBdBb4jsZt+zTlDukT7o+uK
   dxqerYW9Bo5vMMzlV0LTvIjzUWgdZAVNpS7/C2q3RqnG4PBkmMZ+1owwv
   Q==;
IronPort-SDR: zCdTBmdfxtEBlMzSWGigy/1je4J81KGWwqbBx0rvA+DCUSa1xKYEo/DveKxjXpvJS+k/I1DVHY
 7uz1mo3JrSbgCeaQOSJWJSRq3Zb1ivn0VBagWPJu6xUHkvKm77L/NvZ2y6cLcvxKpgORhSb2NH
 muMTH7LJXcONy9yKf4M7RgO7Tc0SOfzeF6F6gg5B45OOanrgD0bbKoctLCqjs2V6+PdY5BLkCt
 IfBuc3vTZfdYizD5/8i1RyXQqwGEJRRlMI3jewA3T+ykG9fPkeItrvLAcm9J6eyrn+Iu0EsUww
 IwA=
X-IronPort-AV: E=Sophos;i="5.79,378,1602518400"; 
   d="scan'208";a="158431890"
Received: from mail-co1nam04lp2056.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.56])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2021 16:59:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nt9naxCXF3MxJe0LrIQ1qD61DfbFo2O4w+qKtIiJG36q9rqYAvaVt7dkVpk5rt7AYTyCTzszZAOMCowJVSkph1xtvTd0cKm9auL72iwLu408JkjNxvDFCi9ZW/TNm1s9reZrN8LJjCyTTbmz2B8sdlCU2j30VQReS81SG2ns4QO9J7268T/i/CsjKth2ghL67AVM2+nI50MxkTojgrJlglDA2YgftoOQSRxhF/ljqb0+T1HC6++AmJ24LL3CGzHYM3SBv7IjikDR1fXrqlUytrbIQLnSJ1991PNGfOHwjyqAK64E/IXmoPQD28S//leaHzkIFGpcl7WUoKp35fbdkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZJZDClwCL3iPV0VOvVTddVrSJuQAjC0BX0JG2TqGr04=;
 b=ikwkmd7oRaN8lEORS1GSylYaMqywv0nnJx3RD+WtY6SXN/0O872DKQhtB516T7i3D9OQhHdqaPQmOQXf3ls3u6U631k3oN7c4HA4o5I2M8ekCK1NtgGKXL+qAeHsK8vLIPVV2jSSviqRzGDRwttKXciFyXbxH3B7WQy3iYhI3qENqXOjVBoH3TMgdPmSF1lv+njIInErWXZ1pb8kJ39bC/Y+GKVr0b2BW8w/D0bz/CUZlSk3/zYNgwVkHcezE6DxjicXjC2TVeabsvkF948m38Zegcc3C6eMyP8dKUbd6Le24JSNvuGiznrlOMmE/kKLNsWjFq1nmVJa0g2ZgyCdpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZJZDClwCL3iPV0VOvVTddVrSJuQAjC0BX0JG2TqGr04=;
 b=LreOR/x+jGgORcMDYS/8srW+gem8l0SHrOdE9pGGYtNNBRJywB/MARxD0zoIEgHjuoy8XxIOHlks61uVc8JKMEQc/Mfxkm9rJCDhReOig5oQeB+SCdasrymPVF16DCOHEg1UvEAjAvI4/CoxQOZGOzyawarIM42XubDNzbJLB2A=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6969.namprd04.prod.outlook.com (2603:10b6:5:240::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.11; Wed, 27 Jan 2021 08:59:40 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%9]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 08:59:40 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Abaci Team <abaci-bugfix@linux.alibaba.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: fix: NULL pointer dereference
Thread-Topic: [PATCH] scsi: ufs: fix: NULL pointer dereference
Thread-Index: AQHW9IlrkIkg1cBFDUW2NGAVDvSjHKo7LCLA
Date:   Wed, 27 Jan 2021 08:59:40 +0000
Message-ID: <DM6PR04MB65753A28501B1AE8CB893102FCBB9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1611737384-49321-1-git-send-email-abaci-bugfix@linux.alibaba.com>
In-Reply-To: <1611737384-49321-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2be6f0ac-1ae5-4a53-4267-08d8c2a1e19c
x-ms-traffictypediagnostic: DM6PR04MB6969:
x-microsoft-antispam-prvs: <DM6PR04MB6969A10FC4506EE18C61DD3AFCBB9@DM6PR04MB6969.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:221;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4rVpnpGT9JpQ4opQYKjhyhu0GwB0KiZC2mieRCVjKuzdn9E92fjuYgdaGfN+4ecpIDRniokM721HRWtdZK++l4eVrz91raQCsQAcSilVlkdSMDC8xY+oXcu8/QR/nKdmvEEnj3xTtpvTPbKuSc5P255tIicpwxHjmakuctYXS+Zo9K5rNyaJsq2TcTdKSg8QdcKcvIyVPtmaiIGdwew3IfPJO31hXBcPRLwO6yQ3qD8LdJJ5Rdk9YFE1IPZptgQweDHbJ8dB0BHqkrw3rCE/T+8x0EToFSz9EbCTB0k4Hg+VkQHbA1i1L16zpp5zna5m0ZESJp7zot3EfudttwbKnm30ZdrJshfgUdyTFg9l6PC+OrYJrA4KOoDYHzOgG2NTLNO58Fo08nP3WJ9lNrXQYv4KQ5xOHSgh2MOWpSa1F/oIeGpZKPzWJjHVi4jLka+FukMlSdzvumAKkvwpnz9FeiDKK9SKmhpkst5IHskaAcnYY/1dzWWtkZorUiE9KYM1E21i5kI8aIPFQiwcM9gd6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(9686003)(66946007)(64756008)(66556008)(52536014)(316002)(4326008)(66476007)(2906002)(55016002)(66446008)(186003)(76116006)(478600001)(4744005)(5660300002)(110136005)(8676002)(86362001)(33656002)(7696005)(71200400001)(6506007)(54906003)(8936002)(83380400001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?435DL2UgmAdONVYfU7JDm1N7Q+Jz3+ghqO+Yn2nMZXLMwDO8/6lF119+Ds+r?=
 =?us-ascii?Q?a77TgO7YbQ4qK5fK+XlcaifXkDrDJxedVPWChWQD2DfNq5g9MZVNfj6xXxlG?=
 =?us-ascii?Q?Z8ttXbOpJXwCw0cmxknVn+6Zlas3js2HJUD/eBlIQLXiw2/UqoopAxViwCRo?=
 =?us-ascii?Q?EK4PrNx0agMb/zjByDDfdz0ZbF0g5VDdZ1eFo1YD9a08WgX53UnRNDtuYH0p?=
 =?us-ascii?Q?iljmIRsD1b2S8+Z7ntaT0IW+nHzf+UrOyPwoAaOGTx7zx7Kv8Jo+baqnkGtv?=
 =?us-ascii?Q?rKHxUZLpfxwO7AIYPgZSicrtmLcz0SMXUuSiRyL72VoxUnsjdzFBCMyi7gW7?=
 =?us-ascii?Q?QiK8Tyx+ivQ7Atar4rcL1ZoNcA5VL9zhMyl+etdz5s1HJegV8aeF2J4wmwy0?=
 =?us-ascii?Q?0/7O10awqe3XrtJ3kzsmG9hUoKZu7gmI/UVJbxDJv+FcO1MUUC8fiLeTmacH?=
 =?us-ascii?Q?4AJXecy7lNynUEl8EPJVrzQCQFitay5xbabA5M0oDHOpscRxrAc99Kd3e51c?=
 =?us-ascii?Q?NsDzVpiGF882FEj40Y94jJGBeS7YkFy95FDYdQ4s1qpcDxZc6qqIg0SKn1IP?=
 =?us-ascii?Q?61tZsHMZJFwYqXzkGMtW2OcAYQODg39TkuW+wetBG8grPg5h9YENGRJRvKT8?=
 =?us-ascii?Q?khc98kL/fdCkin3dXYIsojIDXYjxztq1gXiinnV/qK1vYbqyaBj4GuozQrE6?=
 =?us-ascii?Q?t/eEFtN1p0QFrpcp3+lpBqkmVz5qkpEVejSoBppu6engmY82tR/e6gRAUbW4?=
 =?us-ascii?Q?Hww2P1a/doDvHyWen5PJRcwmtkvRzWV0idfEub6ilS+j8BozlrwFIdu56cJj?=
 =?us-ascii?Q?GjJmsVpci0pvX7AeUcYLTuyacWrt71/1A5oklrZn+STkMzN4VC7QPhLPci23?=
 =?us-ascii?Q?D25ht2FecRRgFc0LiOeQb2KJ0NlsSH+mgUkKqscGTLbRDEai34m7Mi8BDqUt?=
 =?us-ascii?Q?y96UPEVcGXUrGJ9yD4pGshKjv32y4yC+4Sa3qTNXGkJ+8/ehNVBihn1Pt7K4?=
 =?us-ascii?Q?MFwxR37F4IQbpkf7ZeyhmYYAS955AKWOlmV9bbIVen10k0RRxHZy5ITxnPX+?=
 =?us-ascii?Q?SqXxqV84?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2be6f0ac-1ae5-4a53-4267-08d8c2a1e19c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 08:59:40.2761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d+9b4aYD7Vvj8ZHWWkNrRTIdGiG3Temk3nahHC0FjP2/AQPJOFR2YOO4U3HU0wslrhgoO4POY8GnETdBV7RwPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6969
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Fix below warnings reported by coccicheck:
> ./drivers/scsi/ufs/ufshcd.c:8990:11-17: ERROR: hba is NULL but
> dereferenced.
>=20
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Suggested-by: Yang Li <oswb@linux.alibaba.com>
> Signed-off-by: Abaci Team <abaci-bugfix@linux.alibaba.com>
This was already fix in commit fb7afe24ba1b (scsi: ufs: Fix a possible NULL=
 pointer issue)

> ---
>  drivers/scsi/ufs/ufshcd.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index fb32d12..9319251 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8990,7 +8990,6 @@ int ufshcd_system_resume(struct ufs_hba *hba)
>         ktime_t start =3D ktime_get();
>=20
>         if (!hba) {
> -               up(&hba->eh_sem);
>                 return -EINVAL;
>         }
>=20
> --
> 1.8.3.1

