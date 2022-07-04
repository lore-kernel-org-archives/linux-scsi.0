Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7BAAC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 13:13:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234735AbiGDNNt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 09:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbiGDNNr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 09:13:47 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8B525FE;
        Mon,  4 Jul 2022 06:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656940425; x=1688476425;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=MJaYBDYeLYp++C2d+BhLb4efNx6haZr0zu88k0qPrfv1ML5MQ3if0Dr6
   SWyLgedvlZ/ixjghWUw5hyoXuHlFF+WvaevWgMiQi70tVnQ+mSvlYB2AY
   BN4sQCk0/MKlNqUYTIyndDAUTghWUOy7G5lRG76kOsl/V2k4+OitPK4gu
   T0IsB1HoI6o9bBy71NKyBIRwAapw5dRmIokIPc/J+4FHmzdQhFbBdrRrr
   D12LGBR/sBo56KgqzdL93f+EzVWs93BSLK/b3Nv7rkVEmAgN/pVBgoao7
   jd47ibHCizfB64AUBMUEaqfBuEkzcXSy4rFkTE47buS8o/JHBzQem5YFh
   w==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; 
   d="scan'208";a="316885696"
Received: from mail-dm6nam11lp2176.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.176])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:13:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CjNA6ZARuVrUL7ucScGP+l9lW5K/Q8gzRtoMtsgxkT8/yasJSZy9wBw7L61ZZQDQrhMEiiAJoSyQt6/uUt4f8TtVzwyuDvlKJvoamzJjk07lfpH5pyZb0gTwQlwF4HYqH8gRCmoSP5d0NWjz6DeNZ4nhlTr3CHVXRTCG3OmrNdcx8yk0blmvGc4t1XpAmBbXsU1hlXt19M5VZsSvsSxb8WC6ROJHDJc1EyR2329NhO3dNqPy5KzZTpLzxDXLNrrPwuXYBgLcmf7jMHlL1h2FLC+NqSlU3dU+PJQ8Fd6HAltMQc5YFXZoC3mXEgEia4N4coOuUN+f+4CY6eDEdCkoFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=Cu2zPR7n3pYeiO6LAeWb5fwsTM5NcCF+vWT+YvLizMUa26EexyUL1RghOO4zaGh8nBS4YxULW2lZjwJO3eGgFEtXx3Jw4UTRMXn47ToRSI/ylVI2604b2uTBH1nqSOdyewCXy5sweCfTpk8ObTwKTBxNLA5Uq7t95PdOtZLGOZ1VfckzIkqEEjj1MGkFsSFX+bjKUFb7hF2fc4UY1cOOY33CYqKetnEK9vW6x8Edj6+ttSsyzaebYVkytY5M8oXRy79BqUblfhViuvvp0LlomVdzUXoxDA0dgBBhaTXomtE8C1fSogqWJnF2o+gCHtF/5muxgECRopv5UPE3v0QqyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=FIKTOstfM321d9E0vq7Ium8V47AijxQ+zR827tA25jQRV75QnzoJSmPN5cO3QbkQ9AEghK6pALsAAK/E2/obb6QICoaeCFJjhJuP7MpHvGMDMprEJw9AM9AJdqrhGUnRKasTgOaq+Y/JLLjPz8a48up+I0G88IgKkj2YFXpo6x8=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BL0PR04MB5025.namprd04.prod.outlook.com (2603:10b6:208:5c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Mon, 4 Jul
 2022 13:13:42 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:13:41 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 03/17] block: use bdev_is_zoned instead of open coding it
Thread-Topic: [PATCH 03/17] block: use bdev_is_zoned instead of open coding it
Thread-Index: AQHYj6Pwri2MXPrOL0awgQAqxq+ytg==
Date:   Mon, 4 Jul 2022 13:13:41 +0000
Message-ID: <PH0PR04MB74165ED2BAAFABA4F936C6B29BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-4-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 724d90d3-e431-4d32-dae4-08da5dbf0451
x-ms-traffictypediagnostic: BL0PR04MB5025:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SeztDjb/TzuKKhAoh6aAMrzKv89wP2DDJwwOufCa301bultXd0/2h0jywTwYV2MYjTpQH9s6bGa5yxd1qkn/Z7NFWnXnrPEbcHkhO2DOVSuhevF+uFUHS5CLnLdObuxSGb8OFUGF9e6Iwxcf4s2fK4vTKWtHc9ekzO6Q+VkPCNxxKvUp9NwAIWjcTAe1t3YCp23tPp1U4Y1ANrDYmfV18YvARTnjyyvCbWMgJSrF7hrkiY3tuK31KDTZyR2cb6HCPjWlA7AjkZVGFlVFPaV2+yM/aTgQ6A/eVnf+K04r4Yc0YbNTHVufhyAKzhge4rJxDNhstRbxScG6DX2oKku/p2K76DONgLw8hBZGOOFiLAMjiWd4UwjBt/BET8fjs8ggxsonsY/zl2dLbhhwmnI497oyUhEA8NcQKT4XTFlNBJbGqAIGW18YIFnw94MSBC3uoV1PdJ79gEs30yNCv/blxId9VJccMILF6utrRnCghOimIxmvW7i6lBbn3ddiFSaRnysZ2MGuB08X7z25GV1XClaxgiA+ogSFiC2imCFEe7RV7O3pqi9+XzQ5znjUx9FKHG0SRO1XJqZCvCueONuD96AOmHAxewM0S5+uQyNxRGj8SlnB0swwowGAQPg/4oqlN4EUhwQWpHHOTbm7byKkHyubDmNuuv8Ob1gEhI6K5ts8ocYQVIc8+Ilkc0ad/vqk4DNQyF0LuD6pG7WTdpHGZqR92SYFeNpwQjVNiXfQRho7a1R/PrkEx/yaSVyP0iZgH/U9u9Fgw93VndN4+mofDNc8nklQzVd48m5rY9Oq4CllxM79jpt+TzkZwxteKMA+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(2906002)(5660300002)(8936002)(82960400001)(55016003)(52536014)(19618925003)(122000001)(186003)(33656002)(4270600006)(558084003)(76116006)(71200400001)(478600001)(91956017)(86362001)(8676002)(66476007)(64756008)(66556008)(54906003)(316002)(6506007)(66446008)(110136005)(38100700002)(7696005)(4326008)(41300700001)(38070700005)(66946007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NBriUyajM2TPl6b2DsBzvKAlbupxpOlOSGOTCKubbPqCqYau7XnHCLhUCXLk?=
 =?us-ascii?Q?aY+LYz1Mrgtm87ExPSB9W2mGcO3/b3yDwtn9U43nFZ8PAjjB7McDjg9O/2NA?=
 =?us-ascii?Q?6Ovenkqc6vjbKnAAjz7Yw5JA3+1Br1iaZz5HZrHDEa61vmYBF1IYGFCNlaCE?=
 =?us-ascii?Q?GJko+GeSY0UWDIlGNZXCklgLqolrKiezVTy+KMtPKnNEwoWvGVC4rLC/sFWf?=
 =?us-ascii?Q?q3EQ4CkYIq9WUExOpQKt7W4F2s0Gu6Og3qgQv8PG06zONNIcbVbnVMr5fXOk?=
 =?us-ascii?Q?kMYMjpFMArOIrgk+opwx6aUxWsTgcUO+ltzNhk7LdBAr4S/Ah27kprolEF5A?=
 =?us-ascii?Q?eorYvOpQToIKfRulfAyl5qcFRp0v5H9qcsrXsK3yTrkuze4P+PgNNcPoG7zY?=
 =?us-ascii?Q?7E/p3tPIhXwrFW7wwICM+pN8JD/um1NkQVnYNUKIt+BUgp4mVe+Rke/S0qit?=
 =?us-ascii?Q?JLu2EAYyEUsxE7l+mzRKQP7xP6doTNVmgAoANWcMiU+aDgxt+CrWsNh2Aj4d?=
 =?us-ascii?Q?e8164CZa8ZJsIOL5rCtmoEVOLhXeD+/uJjl3pa6YWm9BstDBpexrNsyPFoYt?=
 =?us-ascii?Q?JMCB4gdD1jgs4TEbsl9HmIRMio01y77zrcpYxHHSYcxxEW3zNxDhfMUogq0r?=
 =?us-ascii?Q?qptBNqPhHZjdaf/0y6jteLcgiZ/wxh3T/wOc6Fa2WIOeypzixCbN7WBDZHab?=
 =?us-ascii?Q?IhEbUrMwAvDKUOc54YpQwugV9jBQiz0tF8sh+iy886nMcWnC7FKmVpSTlTwd?=
 =?us-ascii?Q?9YplPTvfXI4WnL/RRtpYsPdoDAGN+eWw+1RmdPltc+a2ZK3948RMN2vpvaDl?=
 =?us-ascii?Q?ZKsrmHCdSpNMBDUGsTMIdbjCd4w1mUbdTGseI1EFYAdiZ9vN8rk2WY+5B4YB?=
 =?us-ascii?Q?ax19vXCClpXU7HmmWoKNvfuFRHy/wG34+1wOheE+kKsAHKEMsf9tNQAgTrtC?=
 =?us-ascii?Q?KpPgPU3Z/a9QR+1tN6tc+3faElhzdLDcjpOvVtwX031skNM4Bm0E+KIochm3?=
 =?us-ascii?Q?pXI0Jn66WpuZdOOuwCFJydlQT8heBkbw4u3xYGNWb3fjSJpnCHzOGFmn7DHW?=
 =?us-ascii?Q?zXSE2UY2etmM6gJUnaevaOn08uk9LSrFpMzo9LYg2RDkYFyEXVSE6sETf7Kh?=
 =?us-ascii?Q?+21bU22TAaghvel2GK5HK4WQbQUY2O+zuDHz5n29WRL2vugCHexAUrLL0mid?=
 =?us-ascii?Q?UpZVl5T1RTg7CkWKFFVHINjmrGZqhQldlQaVo6DsuJIUfsEPnLckWjCQchkv?=
 =?us-ascii?Q?Dc8VOC+EXzrBiSsjPGq3comYctNuCxR14vda0qpTe0scy5PKNuuAAuo2XcSx?=
 =?us-ascii?Q?zXJHTQfHjW2lyUiv7YAfPzGJc/b8A8DDg8gyLWxgatDBTzjcIeWeCQe90hku?=
 =?us-ascii?Q?qNBRXw4fFopN1/+w9G8Gl7Nm+PIFRywTtp/hrLpFcnr2DZHMznWYFPuJA3uq?=
 =?us-ascii?Q?0lkLwnYe8UYXDxgfQr3Gy7P/h5BZErJ/vRQBwi87gKO+xs3GeKFF21vI701H?=
 =?us-ascii?Q?Lozzc4+2UJGyaMlpJXIIkYHSFNvdRICsoYVZmyVzxonPGDaWjBAYEMMv+yXn?=
 =?us-ascii?Q?wR7/chkA1XtJFJ5jF794XKkuvS10WT6TwyvI0rqV2ujRTf2Dv43OGGo7jAgY?=
 =?us-ascii?Q?LE1mn/hgmYQKxvFCKOITisK7u1ALUbEYQnY+QHF/V8fq6Um7Px2ADfvRBm3z?=
 =?us-ascii?Q?8LBIxVUcAaZU6r6cJrXjHChs2aY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 724d90d3-e431-4d32-dae4-08da5dbf0451
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:13:41.8331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GuVvACM+lzs+Iiwf062d7tNxAU03YKt8Db9eUsvrIAcwN/SzkTAbYSSnI78sDRQstjqXg+7E2UbnNg7KyLYbaKWxUBhkKlGGkmqgmvRtDYA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB5025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
