Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A7DC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 02:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEBDF600EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 02:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238608AbhJ0Cve (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 22:51:34 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:48324 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238561AbhJ0Cvd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2021 22:51:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635302949; x=1666838949;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Ln01uCHVu3sDfsUv+krbU0atVHYr89apMTPuHKgw7I8=;
  b=rT0wQW6+pLfcqvf41ZrG204WGy7tvKLCvgno/VR3LV3LrBaqu8ydfmLo
   JYfeDfo/1U7QnLXs+h8kcHVjiZKMMckyFiqRiuE8iCVHvn14GgHyZxTR6
   eY45B3qHY+bnX8fQGdv5/OfkfKJ709LuF2rARkIhrPeRXswC6pDtUTQK/
   wNdsDgPYQs6UdigvtgnsRrzvICQxHicEJx1yH7+oQidViHvY5pOqFf/yd
   Dm995F/m5CS4Np+x2+g3aDOwd4uVlt7ppOzkF4m3osmlryDp7TyknULbV
   HNSTeADUCsT4+lsDGOyvzJQT/Pxi+Y6kqxzLkcEA6KKkuxa1fyCKykXQB
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,184,1631548800"; 
   d="scan'208";a="183926466"
Received: from mail-dm6nam08lp2047.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.47])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2021 10:49:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3A/RU4PicXSmvLvAhBcPZJJT0OlWWgoYw5kV71ZsJ6vMg2hF0X4MLbXWu2mMmTSzJ8H4K45JsexDgMXl04tYepaSGGI6ZLZ/g3hcm5V1SZoM4ZxSwsL4qEf17GtnfVfgO+lsYMdqzCH9CWLr1wj1HP+4mOrLlliCrcXU8WWOV9Tg4YpFNwAqpL6ute9xQiI3PRc6hPnanq9Nlq4VVWlBX6f3CbuibSP4nAXO5ImLzbE767AUfn5Gq6ENQHLPvhe+PCCBLaKTeHUykiUvXvV3/xz0zwcWQhPzc7C6i0kn91/3JzSsFRQcDMyvc6O4kCN8K/v79XOODz2AOUv6IY/Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ln01uCHVu3sDfsUv+krbU0atVHYr89apMTPuHKgw7I8=;
 b=MN4DOjsDrWsxOdRee9o6S5z5r3YhU69azn8WvCeVDknHNJ1UJyef32AiGS7wmAghMyspY8cvmApFxIav+6QTOvJ6fvzyPHTobTk2sPyfuSrl7ypnQomaC82kNcSkOZX95VmIx0+5MyZFqhBhcG/TYInJsg8WqtFXWrTFTGRoFkaCpoP9fdb/DaBpq4ainOv+MzNbKYxip2GO4+MNUAPE4FRPRAzYMdrHF4fs8C5JhuGd8hWQHP57yNbOvGxSuOZvYV7mR8LXBchGuEI65/dfhHVc6Ggc/tosEKUZBlqgW8dQAXWO8KmKz9uAT8npF09UozUgocFbHEKQGD//meIQpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ln01uCHVu3sDfsUv+krbU0atVHYr89apMTPuHKgw7I8=;
 b=uRVvYUExBcl/sL6CUSiJb1IWAFPvEoX9KkK8v6RA/gO4KpBWv+WJfRwWrGHx33AI3hiThUK+ozNzWI+aJvEnpCqOh0k07Sq48E0HOG4VW8IMcMulPJpbal9W4e2DJDappuVccNjtKxxjz2OOsA+m9TA9PZvL3GW5J/tW3me+ViA=
Received: from CH2PR04MB7078.namprd04.prod.outlook.com (2603:10b6:610:98::9)
 by CH2PR04MB7096.namprd04.prod.outlook.com (2603:10b6:610:9f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Wed, 27 Oct
 2021 02:49:05 +0000
Received: from CH2PR04MB7078.namprd04.prod.outlook.com
 ([fe80::a563:b049:4d85:6b35]) by CH2PR04MB7078.namprd04.prod.outlook.com
 ([fe80::a563:b049:4d85:6b35%3]) with mapi id 15.20.4649.014; Wed, 27 Oct 2021
 02:49:05 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v9 0/5] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v9 0/5] Initial support for multi-actuator HDDs
Thread-Index: AQHXytl/ihnWi6nd7EWMcej971tRpg==
Date:   Wed, 27 Oct 2021 02:49:05 +0000
Message-ID: <CH2PR04MB70782D5877F24ECC9A0F644AE7859@CH2PR04MB7078.namprd04.prod.outlook.com>
References: <20211027022223.183838-1-damien.lemoal@wdc.com>
 <cea34b2a-6835-d090-4f0c-3bf456a6ed00@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 759a961e-7f34-4537-7679-08d998f4578c
x-ms-traffictypediagnostic: CH2PR04MB7096:
x-microsoft-antispam-prvs: <CH2PR04MB709614ECBB1C98B2C816F213E7859@CH2PR04MB7096.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aj2kxXpgiyuAtH+sG7EsNhqtT7JgYR0c8RAjUkRtEDZACM0hrYN6Qm7Gj4ocsjxVpMj1qPy5I59L03cf7NQIbx/xCep1roIzsyHiCwTcVCoF1orukGm5zYM3xwJ9WoyU1yIDlA+seRAjq9/hbWIX6tDpmf62YLPIx9/MQSoRlddBxB5OYeY7FNF4FazwhexUgZsQCK0XLwFkcqT4m0ZiPw6ZYc878u8zD+FpmDnOHoaIZAUG4zjIlL/7RHh341URM+UfoYNHhOTJ574W7+Dz8V6QH04guptI5SG5eyww9ccSzoeZ2wa28oZik9oaoZy6lJXFWUrMzchUSxdsduoM0cn/Ylpx3uOzOmlLt+wmZv/YPjPKu98DToAr8/ubdkDaw8muRom6MJ4ztPqJz3pme/MR5s/6y1ZEJ3chyhasQGycK4VKn+riOcnBuDVoykKqTFph9+OLsMKsU3SAWY1JLa55jMdBcUNjiZP8gNNX8LwqVGaCzzXNiFjZRF9L5fj+Bb7kZM7SY9U2NWD+11gQEt/LzpmiKNovllVLNDEqsYss4sA2seKfigA6g2J5vkr7/vycKy5mk/fu4acI9lbnn/Ey3MwHKTpgoI4a8W/1cbPJw57HRuojZUEvLsx8ZoPFGkvxlqONHOFcK6QkzibuS7b006cuHX0kJxxenE4RyaHLyUeLv4C4BeAm86SeVxKT05eTR9JpSARkCxXXK5baPA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR04MB7078.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(26005)(186003)(8936002)(8676002)(82960400001)(38070700005)(316002)(7696005)(5660300002)(38100700002)(66446008)(52536014)(76116006)(86362001)(55016002)(66556008)(66946007)(66476007)(110136005)(64756008)(508600001)(2906002)(122000001)(71200400001)(6506007)(33656002)(91956017)(53546011)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UQu1OL8ozMVt665akdCWkuuP+k8b0wxbGXZMB8T9yn3qGlaNVG8kvy+WyRUS?=
 =?us-ascii?Q?6fsnxFn6QmbWo8ot5e71iVJYKh18CJYnvGHGcZ8xVZ5OakSEe140W2NGPNhG?=
 =?us-ascii?Q?Z0mUG6iq9bULcadd9GgkQxXLy7DMf+xJSCeDhyEQjYxFaENTh3h6ktEVXQ+X?=
 =?us-ascii?Q?8QEgfCmzHF7q3GcVu45smmNOjzCz/i68ehNoqZQq4HMCJwNBCVhmY6kc/AEE?=
 =?us-ascii?Q?79YyZs7jxcw/EQDKem+1yt9+2MIRKBUvXooewR+t2Ue8mOS8S3mS3ahK84nQ?=
 =?us-ascii?Q?RWCV9m/nWHpoW3axvYhvSus0KYL21kPPsZJt4+WxfyJDnH8MIvCvGZhOkz1v?=
 =?us-ascii?Q?Ttei6W5Et3YuVb+8sVwZm2F2YRZB4EDcw/ONymFcZ3kQOo/DUARjwV3DpdXR?=
 =?us-ascii?Q?UVwPWgk9rttjgn1/3DQ8euh9PHjI3jdelYC4D+owI1Z//6X1jHIXfA/3GkAS?=
 =?us-ascii?Q?5BmIrubgmIX/bu4mC8VqzE1hDQzfqbHnWWO+4F82ooz+dH16lS/PJdVNm/UZ?=
 =?us-ascii?Q?P0xhhB+HM2gmAcBcqmLA3y/SXC3KSHgyAuzqGzQHAAzDMy8psn20y7jrru0T?=
 =?us-ascii?Q?DlqW5talVXsvZbreQlKHvQraXCRf/u2cwdSC4nbb5A8JrHmCiVIllAFe9sqs?=
 =?us-ascii?Q?PM3y+HXAG5Hfe5NK4nFrVhzewQiQKO50UxJsh4ulmJIQ5WREvJN582tOuvv9?=
 =?us-ascii?Q?DOVq/VdegNXjo8Wu9mZKECfHGsBSi4aRTtKFwCeSamAiUbi5ykrcvRWKdFS3?=
 =?us-ascii?Q?YTiZAVP4Nai5df2/oQULE+7ivtoiSLoT8PvYdU1xHyZ8ZtElSXJ9j6g2Pff7?=
 =?us-ascii?Q?YPKqPYRse8Dk42ODJvjnDG4loN541hTvq0gBLcL11oU0SBN7LRJZc2XzkUU5?=
 =?us-ascii?Q?HcMzFP8Cklq0yeYza5AIy/TMk/ehW1bCpgS8rUe5TFBFwewgd/1Ae8PMlz4t?=
 =?us-ascii?Q?NpqJVf3cICAgalz90KIInD0jWpoDQJgb326JgAfmjt2vhOkc58zEjTuJdbl+?=
 =?us-ascii?Q?KaKidcBDVyWRdTM8ZKfuG+D/FWDvwdy7SFjC/Vphkn318L0g3M8a5raHIp3I?=
 =?us-ascii?Q?4X1nBzfqh+Xy/C6tQn/qsDWUV78uiVDuiLekZgIB/jLM3bv1kjGbWjvTIM0w?=
 =?us-ascii?Q?c5ik9l/Tf2uTlAf40oa/Cu9b8K+XwjuFqxO09bzv/by0qnX2SQelvN6lB1mV?=
 =?us-ascii?Q?Ux/K/t6fy4/cp8ok5dlfF83U/NMVEqNiHcFPXH2Dgc+bmDHjjuhvl9N9nQTR?=
 =?us-ascii?Q?FfITxrgkQP7KasWSIReSjDTINI9QNZxWXQx5+ns5DgX1LO9T92pQdyI1F9XU?=
 =?us-ascii?Q?5b0+lAdMgSN+neVrdbVb6I1DmyiLbIhfmkhqqYwezQwgIS8+3nNqDfBjc8Zx?=
 =?us-ascii?Q?kK6Rkms74PUFtcQVQFj/1r8pRwgWQltstzz+uPBf/bHQ5LMEznShZIzrfjGT?=
 =?us-ascii?Q?zTb60Ws4HjJAmYFnkNcgRyPQeJA3WPKd/Q42vLfTyxQiqzIQQu/0FLa8pG+c?=
 =?us-ascii?Q?0lyGWNLz12yynqT+pricdeSnRmJhnEusXbXgE9bi80y9mN2iqV0I50lAB4+s?=
 =?us-ascii?Q?IHCTnXsGvqNWFr3L8JRT96AbZ3oZjqftXqx+ipw/vOlnnAbURdDb0ku4Qg1C?=
 =?us-ascii?Q?S/tPG/5CTqKUONpM8QgbAON2mNRf5o+XoU0Q3IWumTps?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB7078.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 759a961e-7f34-4537-7679-08d998f4578c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 02:49:05.6517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QMKiI0ESLUpKtFgeV7C6wASBYUFD2Rfx6a0c2ueI1JFZkMMc3vZ9Zm2x2pJD3Nb0FriSEnlwFJnJZHUFc3xQFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7096
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/10/27 11:38, Jens Axboe wrote:=0A=
> On 10/26/21 8:22 PM, Damien Le Moal wrote:=0A=
>> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>=0A=
>>=0A=
>> Single LUN multi-actuator hard-disks are cappable to seek and execute=0A=
>> multiple commands in parallel. This capability is exposed to the host=0A=
>> using the Concurrent Positioning Ranges VPD page (SCSI) and Log (ATA).=
=0A=
>> Each positioning range describes the contiguous set of LBAs that an=0A=
>> actuator serves.=0A=
>>=0A=
>> This series adds support to the scsi disk driver to retreive this=0A=
>> information and advertize it to user space through sysfs. libata is=0A=
>> also modified to handle ATA drives.=0A=
>>=0A=
>> The first patch adds the block layer plumbing to expose concurrent=0A=
>> sector ranges of the device through sysfs as a sub-directory of the=0A=
>> device sysfs queue directory. Patch 2 and 3 add support to sd and=0A=
>> libata. Finally patch 4 documents the sysfs queue attributed changes.=0A=
>> Patch 5 fixes a typo in the document file (strictly speaking, not=0A=
>> related to this series).=0A=
>>=0A=
>> This series does not attempt in any way to optimize accesses to=0A=
>> multi-actuator devices (e.g. block IO schedulers or filesystems). This=
=0A=
>> initial support only exposes the independent access ranges information=
=0A=
>> to user space through sysfs.=0A=
> =0A=
> I've applied 1/9 for now, as that clearly belongs in the block tree.=0A=
> Might be the cleanest if SCSI does a post tree that depends on=0A=
> for-5.16/block. Or I can apply it all as they are reviewed. Let me=0A=
> know.=0A=
=0A=
Forgot: They are all reviewed, including Martin who sent a Reviewed-by for =
the=0A=
series, but not an Acked-by for patch 2. As for libata patch 3, obviously, =
this=0A=
is Acked-by me.=0A=
=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
