Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79596C433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Apr 2022 07:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233237AbiDCHMH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Apr 2022 03:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbiDCHMG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Apr 2022 03:12:06 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA8A29CBE
        for <linux-scsi@vger.kernel.org>; Sun,  3 Apr 2022 00:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648969812; x=1680505812;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ayez22CL/CBEau9Wl1m18aVNcSqLKioHjG4peuJYyqs=;
  b=kPFDYQpwBHkJfChe315ytkANn30/++6/XxgURSa1oP0Z7AlJx8jD9UF0
   Xwb2nvUMk92poM7c1q2+pkpSIq6h0eCyreLL2caGp+K3io4A1IhKe/zUc
   pNmlSw/G75qWMAhWbGbyQ4ePg9FrhJRPajO2F4o5hZ4iet+6+KPsOzRKM
   cYR5me5fQld3zKxu0ifTfOy0CUSljqeGLKhgsw1rCIo8jjAhiPg+O3InX
   /uTSkVTAK/yzq5ESsp8D9wFGyZhzZoUCHQb8Pd1X0Jd4I+SXIoyfAtkoI
   ij/Vuua6pUMgFoHw1Ez3qVvOrrAia3porSsyy4TLMTbjk5p70Jk8qTxIh
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,231,1643644800"; 
   d="scan'208";a="301106991"
Received: from mail-bn8nam12lp2169.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.169])
  by ob1.hgst.iphmx.com with ESMTP; 03 Apr 2022 15:10:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WuD9iz8SqSoLikH4GjmkklxNqwkClFIPnOXb5HfLrjFRfBUrL1f2Wq0mlagEGOVDv8iDCx/eR+qiGkguL0lpvOGlm4RRRvOXC5w9sZOrVnTbisG+GCwtMe9K0/AgOE9vuJ+FDWeOJ1SsYeYIuCM3AHIdSqOIM9BE5pLjC7LN2Puwk5LLnond/7Eyf5sineQRlsHK+7Cx31+QAI2nGd61mwadCagAr/RSyTOYFXErNqFmkwpCHUzI+ygAwbuDnmX/ZQLlW6X1IKuqU2ko14sP57ABIBZFKOXtscYFgw1ZDeexyKSE5Uvbu8+EIFKl+pvVK5qMHKZpESOoUvCmJdR+KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aSia4Gu0khL4u8iYZvLliRd2uc7NhHe0lhVCEVcdOo0=;
 b=DE0Pk7X3Gq9qcAPZGQX4/0kxKqww4BS1n/ZF5eBCDpINob1WxTeviGv12PBuxiGIXtBfYg2W87hkLMCpcoZfwbXZvEcTjrigefVpBULm5ApYexNUoSoFMfDvG3ETHeLrIt07xPRj9r5qhPOyASBy5joXuCVw1YFdpB2u7P1zuPj5r2wupa3vFTve9dTldlG8MxBgkUCejL4tBRe3Inh1I28M08xCu+0UBhlFO/rJCzdxPwstTR2hz+L1TM5HwBS6H2znfsdbC/U5ncLIgV8R+N2P36uXHkxTmn6HFz6H5dJH0hndm3s+z7juwIkXmTIkrll3oF+TZemq/wpS0VXGeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aSia4Gu0khL4u8iYZvLliRd2uc7NhHe0lhVCEVcdOo0=;
 b=ngK9YF6Smv1BfaSM7A7uFGB8RWu3wb7b0eJ0IIYbaPzGgcoD3G84+jiJlYvJvWFAFT1sV9d9PO+5uPSO3o1X566Mi0Ha+suyvWcKayIdjCiwaZwO3pgYnJ+gYqUj3Z3R71mYbWIPFIZJRCSNDLut+F7sAuWtaiOf/7GgbFbHhiY=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5275.namprd04.prod.outlook.com (2603:10b6:5:111::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.30; Sun, 3 Apr 2022 07:10:07 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.031; Sun, 3 Apr 2022
 07:10:07 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bean Huo <beanhuo@micron.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Can Guo <cang@codeaurora.org>
Subject: RE: [PATCH 15/29] scsi: ufs: Remove the driver version
Thread-Topic: [PATCH 15/29] scsi: ufs: Remove the driver version
Thread-Index: AQHYRU/aQ5I8Swht+kysSwu6M3Ud8azdyAgQ
Date:   Sun, 3 Apr 2022 07:10:07 +0000
Message-ID: <DM6PR04MB6575BCA70BAF3D87509AB923FCE29@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-16-bvanassche@acm.org>
In-Reply-To: <20220331223424.1054715-16-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e49576af-df00-4f9a-2aa4-08da1540fc09
x-ms-traffictypediagnostic: DM6PR04MB5275:EE_
x-microsoft-antispam-prvs: <DM6PR04MB52752A582B1503AA5B92A720FCE29@DM6PR04MB5275.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yLlgA2wRrIRtkc1Cj0olvFfZ/tH4X/ymCbA6yfaMjg3RIelybCTa97DPPWggc0CCPvldy9HByAZ167Dc/hJ8/umN/V1ZIzG7siU6YukpBNRQtkqXlOJbDj/W0rUJQuXJ4GuG1fMBaw4k44Iy75iDh8US/n6Z9oCncxb70pgJ2t96Q8Y+AxLSoOANnvimKspflz1UYunDW8sEVd0KxOljpzwF2tb7aAbOIp1+0gkv3jnMk8zNvtuEqdRsh3Xj984ilM5V+40bx5Tlo7bmDjTCz72V0vXnYGUOtraWKjfhoGO8QEhgnsY3z4KuCBIHydPUBtGsi4BHgzbCzzJTn2L9QMFML82I4ISfo39rPDgSGNs6Bh21nhXPg9HBDmG8sq2S6O7rdDXV6+BBeDbVWKxNx0lTfAjWLNbYKVNnPmbj0KhetLXBFArgejnk4VQcW/NiQJAQLAwpwti7Ads6aUZsisaDRLQ1H8ssS3sEB81DSONddf9YO6OF5BFnHU8TlqY2iFa6kvUvzIo/h7j37jw+GBeXeyBFzV+EKLXBYNHNf3U0voydmJtnTV3gxZgh78hC6UgEIcC3hfvWTQOCrKe+9ui1+jplNgsMM0FsVynuuzHbQoGWsGNHxgl/G0rc/1zIpp7lu7KcqO1lT8ZNPlhtWJoZ/fsVV2Gqr5NgIr2vB+G9+DgPpUIJIm3IqsHztgKsF05wrmzT13U1zzWxmKXuKg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66446008)(7416002)(66556008)(66476007)(64756008)(66946007)(38070700005)(76116006)(9686003)(71200400001)(5660300002)(110136005)(82960400001)(55016003)(8936002)(52536014)(54906003)(122000001)(7696005)(6506007)(26005)(86362001)(508600001)(316002)(4326008)(186003)(2906002)(8676002)(83380400001)(38100700002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ELRrgsJSoysi7Rg8w9cyJKa9uoZqILZSGLZXfEBuK9YR/yHPXpnG6W+foLcn?=
 =?us-ascii?Q?nzlQCcymcKoBIi4EVO/Inz9MhmPvhvPIB+QmFEHuGtoUnixtFo6qwR0cGvNt?=
 =?us-ascii?Q?cg0+F6Q0m1o11e6iwYIoCQLWe2UM2CPX7pU+J0yllO4VSn3saNRlwoTqrcoB?=
 =?us-ascii?Q?rM/w7bTVJPTiFuSEA0s6kT/8f5sJ/aa/DK3V4PddJZ6dFeu2kta+jC2H8lcJ?=
 =?us-ascii?Q?jhGFYNFUk57GpKVABoQu3TYbDiLCvdDARKvw1nuD5IpyAVNi6V4ZspPnZxQs?=
 =?us-ascii?Q?vehx5HARcaD4mFYZ6zbxPL8xdqkCk5QwTH8j+DPf8qWFlWweWr/dsdftwkhM?=
 =?us-ascii?Q?i2Ztwgm9HBM/T8z9FhBD3z0tv9pq9JMup4M1N53zKgSftjc+zlzGQzRW/+76?=
 =?us-ascii?Q?vr+08tIp1hyCDAszAf69362KIcRaO52zVOkyrA6rol4YbTxLpfdqLA0BPPYj?=
 =?us-ascii?Q?qz2QlC1T/jQDWDgLwTfu6EipwZr7oqJ1y0BUwdjsEXSxW85kNHSi4QBO56aS?=
 =?us-ascii?Q?1orBrMUwcE87Nsqkndl57xXygDzc62y85tZozcjmTaEtspeLO3gSNenaQffi?=
 =?us-ascii?Q?Fvu5gXdgUEfwNX3HT5bEqF712SHkz6fyZOycvlhoSfq8RBUV1LJx0r5BThBF?=
 =?us-ascii?Q?exOMONNqLCLtaG8a2wLLo4jalkzH3uaLUFS3t3LfFkOofviuLjlk3LO4qAe7?=
 =?us-ascii?Q?n1f6vJwAvJBUJNLg28DdTTSyFfRshZZbqQL6IOnZXMLn9ljpi+iHz94SDy/7?=
 =?us-ascii?Q?B6kaKBAW7/dwpv7u2ncf+7DxVNAX58zBZQBV7XPTKkr5LCPCQ85QCIaZlBPs?=
 =?us-ascii?Q?sKxn2XTHHpNW5zYdNikwjPkwIsg6255glWI16Ilkk9jmxyZELXsEs30rSEEf?=
 =?us-ascii?Q?CjD0x/IykMgxCsWDmIcm5uxci3UNs6UO7VuioKxSIXb1okwAuDIknaUNj0N6?=
 =?us-ascii?Q?rZ7wnBFLvISPRdoPzdfRVhkraOrV11lG+v8c3cJmHC4R3I/vziWdOqO2Pja5?=
 =?us-ascii?Q?ocxhmDD+zkWnNC7GiwEFVRQBHNjxmKmS/GTUvcrrfWP6ML+d8bKgLSomJDhh?=
 =?us-ascii?Q?L+ZUE5CJWUWZJ9F5yzMON+p8jDdLaP33sP8aiuhGeIDy9zdHgUhPSGqvLGlk?=
 =?us-ascii?Q?CSvXs6jrHg7PabupZW/DLQKesFIxpNe2jXHxCTW17S1cpVqXwOkHzE3U1Wzu?=
 =?us-ascii?Q?VwH5sn2qdzORYhg/afCAKcDw40PRHyBj3l7d6GhT+2b4m3NytvvHWMKkjXbw?=
 =?us-ascii?Q?HWM/y2Jsv3UC80UEecOVXJ/PrZItpEmMzwM2sdhvmRSNBkAlcJf+sJMas3QM?=
 =?us-ascii?Q?25C93H83l2nvB7+uJUwaH7v+ZQ12GJ4xPSyOFdgBB5/5RrMptzXKW6f4kLuQ?=
 =?us-ascii?Q?aOymYZNtvJ5ocX2uIRAzVtkkn2/gahBFHZaVV+c1lg302EV3ItoOTDKDjOTZ?=
 =?us-ascii?Q?cDORPKMWt/LzepZlwdz6MZeDJnDyNY8yJC3564Rg6fdUcV4QJfKCigQi4k1S?=
 =?us-ascii?Q?smEgKA5fbwqAgjp3nNeglWoFI6+N0RqEDssggqYob+GxIpYDNnWcX7PGOag/?=
 =?us-ascii?Q?EjRdShV4vlWnidE1NkTgiVmZmWJkidSDlTU7PjZ1k7L/SSXWltUziAb3lnSr?=
 =?us-ascii?Q?CFDZ5kCV2m2beaqhRVxAAWmwcLrNqxEDe5r/MS/+8gNdDB51v4L/Wt0YxadL?=
 =?us-ascii?Q?KFCBAi4fiqmarsnYKtyynJt1zqlnZ8yY4DO29sudY4T8Q5sIQf6y196MKjdk?=
 =?us-ascii?Q?g4AB9ZHY0Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e49576af-df00-4f9a-2aa4-08da1540fc09
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2022 07:10:07.5802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SDkdCq8+xCwhJCeYlt+XB8s21ATlOYEHIaW7mSgK0weVjlTgZW9eJ1Yyt9GFKkaJ/ynjtVzTrBt0A5Pp+K79EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5275
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Driver version numbers are not useful in upstream kernel code. Hence
Yet still - very common across the stack, and particularly in many scsi low=
 level drivers.
Why the ufs drivers is any different?

> remove the driver version number from the UFS driver.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/cdns-pltfrm.c   | 1 -
>  drivers/scsi/ufs/ufshcd-pci.c    | 1 -
>  drivers/scsi/ufs/ufshcd-pltfrm.c | 1 -
>  drivers/scsi/ufs/ufshcd.c        | 1 -
>  drivers/scsi/ufs/ufshcd.h        | 1 -
>  5 files changed, 5 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfr=
m.c
> index 7da8be2f35c4..e91cf9fd5a95 100644
> --- a/drivers/scsi/ufs/cdns-pltfrm.c
> +++ b/drivers/scsi/ufs/cdns-pltfrm.c
> @@ -340,4 +340,3 @@ module_platform_driver(cdns_ufs_pltfrm_driver);
>  MODULE_AUTHOR("Jan Kotas <jank@cadence.com>");
>  MODULE_DESCRIPTION("Cadence UFS host controller platform driver");
>  MODULE_LICENSE("GPL v2");
> -MODULE_VERSION(UFSHCD_DRIVER_VERSION);
> diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.=
c
> index f76692053ca1..81aa14661072 100644
> --- a/drivers/scsi/ufs/ufshcd-pci.c
> +++ b/drivers/scsi/ufs/ufshcd-pci.c
> @@ -601,4 +601,3 @@ MODULE_AUTHOR("Santosh Yaragnavi
> <santosh.sy@samsung.com>");
>  MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
>  MODULE_DESCRIPTION("UFS host controller PCI glue driver");
>  MODULE_LICENSE("GPL");
> -MODULE_VERSION(UFSHCD_DRIVER_VERSION);
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-p=
ltfrm.c
> index 2725ce4de1c9..81e458d31222 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -386,4 +386,3 @@ MODULE_AUTHOR("Santosh Yaragnavi
> <santosh.sy@samsung.com>");
>  MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
>  MODULE_DESCRIPTION("UFS host controller Platform bus based glue driver")=
;
>  MODULE_LICENSE("GPL");
> -MODULE_VERSION(UFSHCD_DRIVER_VERSION);
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ae08c7964f2d..9d433d2c616d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -9915,4 +9915,3 @@ MODULE_AUTHOR("Santosh Yaragnavi
> <santosh.sy@samsung.com>");
>  MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
>  MODULE_DESCRIPTION("Generic UFS host controller driver Core");
>  MODULE_LICENSE("GPL");
> -MODULE_VERSION(UFSHCD_DRIVER_VERSION);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index bb2624aabda2..49edbdb5ffd6 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -49,7 +49,6 @@
>  #include "ufshci.h"
>=20
>  #define UFSHCD "ufshcd"
> -#define UFSHCD_DRIVER_VERSION "0.2"
>=20
>  struct ufs_hba;

