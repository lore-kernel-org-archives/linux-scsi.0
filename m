Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78357C432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 23:27:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58DD660E74
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 23:27:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbhGVWqc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 18:46:32 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:53475 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbhGVWqb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 18:46:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626996426; x=1658532426;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=rJDFdb1ceLupBt2ZqSYyiP47mtgkDiZfv2JTJct5NJc=;
  b=LqfXP+jT6yQfIkY856ye1xAdAjYM+3deOLzqjTjbKu/YaJPqRUbGIpsD
   GaU44Uh0XRBRgXKF329GKfvaHklUrpkhGyDqzmI98Miuowx7sd+Aih9g9
   xS1teM7zVfYpwv6DvGWR/tPlZqxNhYbbihpBjtdRfCXMdIOKfbGlc4bcz
   PBSff+/phRsoNQqOSA83OpaDAOJ+htcNu9N99b2g6+mCAN4ZGPQ6flc2X
   dBS1Q9nDZGLtgmctBvz2AFQlkoXSRm6mD3flPZAi7XbAqFheoFiNMQ0cA
   rQ0kbHiRjB+QULljRS0CMQTo7//k4j+aeGjvOlZz9y17ReXHEo1O3StH6
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,262,1620662400"; 
   d="scan'208";a="286844666"
Received: from mail-mw2nam12lp2040.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.40])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jul 2021 07:27:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PCZtzYFN7xmRqhMnE4w2+DhPm3M565lMs6wVyrPN/kwPw5tzq0Am/f0DH3ww4UbT+6X6lZ8Zm9nxRUg/PeeFCuk0ed3WnR+bmuPUrLBgem6jTeIJBORdFhCkSLsOkE894umIlnHlQK9s8zJ3m35oE3rkASR0ENKx1ibhHqt8aSCFJMaN1gRiI5RgQNIekHzlsGCaxDrMR78s0vUuS5uJNQIQw/V6xWjk7RS0j7D08BNBtoXAa+QBsFeEXuJCy9rAyBYOs1vjf4qmldtXDYmV7ctngwjn1h06u2Tbr/W2WFBZ58xTEiA813Mkrk5WIRRIbM0616DtxuOCHbfwygxA3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDvSqZFnbheBAyipDyMacFbRvdg1lMZ+9Y4uf+MA5sE=;
 b=DdI+d24ZszyfxCwNDU8SkBZZDkSeV2MUX8vlXhyBd7PurkUqjncX1PiwtiqJxT2gwp33W7PN3RXeaX9eubGFcM8kR4wPKiZkOWq2v74W6jhsa3qPlCwtnc2+Z74dCe5Ymx8YDPgKJxQ/nvknZQ6hp1l9mQuOZuCooe8NhaK1FioFOwDBWU0ORWKXuyqCsR540MmUImUi/dvhKGLo8ekKojrkw3iZahGFhfZ68ANLT1dCkQQ+wgGHMoBxFTNyUEk1BFtAIk1oWwdykHFTA5BbKSVoneD4pUkP7SJe3W5z0rPSctk4s0G9Jv+onbxNibQiXrRGmZFYgEs+1hgj3WDqAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDvSqZFnbheBAyipDyMacFbRvdg1lMZ+9Y4uf+MA5sE=;
 b=xbBz9YB+8zZVsokWdA922EYMRW9kff46qqzvLgf+FHoIEEi8FxWLHd8k2e4Z9sIEP/RAk+03xVcTeKyAxOTmQRcqA5o2jMezy4T7F7joZg1MwlKne7WmmqnchYLHzhYBZWYOXumtvnSRDP0H/M8mWlNbtdWXxVHWSQ09MwkUhZk=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM5PR04MB1244.namprd04.prod.outlook.com (2603:10b6:4:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.31; Thu, 22 Jul
 2021 23:27:04 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::44e6:14cc:4aab:3028]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::44e6:14cc:4aab:3028%8]) with mapi id 15.20.4352.026; Thu, 22 Jul 2021
 23:27:04 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 3/4] libata: support concurrent positioning ranges log
Thread-Topic: [PATCH 3/4] libata: support concurrent positioning ranges log
Thread-Index: AQHXfh3/i1ZMW1rvH0KP0zGkOY+KBw==
Date:   Thu, 22 Jul 2021 23:27:04 +0000
Message-ID: <DM6PR04MB708194880D37C9E52C2AAA9BE7E49@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210721104205.885115-1-damien.lemoal@wdc.com>
 <20210721104205.885115-4-damien.lemoal@wdc.com>
 <a53b07da-f012-ccfe-05a9-88a79abe6721@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 238b317a-aa86-4a10-c447-08d94d6836eb
x-ms-traffictypediagnostic: DM5PR04MB1244:
x-microsoft-antispam-prvs: <DM5PR04MB12442A7A915A863914E5E57CE7E49@DM5PR04MB1244.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rX2/5CpxkSVECkHG9zUD35rvE1rV4yFWzpLDhMg3MB2UoTCBKxWthChw0RLbeeN03QIFjJ6aQOcX63UONjUGmtqHb4NaF5z4pCYPT41ZhsO37meqSp+P7Tdk1aXjylnp99jmcq4dmg4m31yL+1+PGdNeURk3T3ssGjWQg7fG6xlxwF4Dt7l/K7bMJGAAfDrCl0odvLblZMSw+6+fPg6EtvFmw5EinJOJ8XAvxiuVRSW+wx5w5M1GB56MrVJOgAmgPfMBnbiW71+F6+KayQytHN4c5G4bofe9Kg1211JXe/MOPskzm2d+WflquLpzHB1+u+pHRtiZgnc4oq1KG6vWjFc8uvXiKGiYF58ZnFSPTV0bIb4v8/PEAmHmAP92zUwKE6DmEwt7n2qssHReNp9UlUTkMHNDSQ9+gu1rY0cnhtCOsRpftijQuMXyDN9vyFL4+XmEy4YXlWr35ylYYY50xmhDMxj4cPARKcxCf2PqtevA4GPUy/MXf9dhgvATJKmu0oL4wZ/scNWGbxHgSFK6FoTshzi95NHbymkYSCuVpq97GyLNlmrwkQl0OUTrtAEX3McwxstY5aQYgd8IePDJslf02bV/rH6/kGFsf8/+WV4roHu1k5I7B10uaM690JQGGIfbGMzJai2jNZy61aog63oVshME7YMrcU1JbZS2jvbsyyTFjFraaXOKz7Z8ma/zaYC0FnvgF5akluPSrGG0NA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(91956017)(66446008)(186003)(122000001)(8676002)(53546011)(66946007)(52536014)(64756008)(5660300002)(66556008)(66476007)(6506007)(2906002)(76116006)(7696005)(55016002)(83380400001)(9686003)(8936002)(110136005)(33656002)(38100700002)(86362001)(316002)(508600001)(71200400001)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZbeSUvHAp4LSaFfjEExJ9G9idtUJXxb0v4Fw1epjlAc6wTq5wtXFaprfNd1G?=
 =?us-ascii?Q?WLygbdKXogkvxrhMXHU6foEwMC+rtU9lVAZZblr8yMmjpEnaWqtj3PKBYilm?=
 =?us-ascii?Q?CI8oMQq67XXSkOLmYXiVwvJROgxoqPOqVWJO7NmHe7zriRLTSIEsL9oGNyh6?=
 =?us-ascii?Q?dHNrmqf4q4uS9KABS2o7hliL+tcAmaY6+bhxjt86UoKbezrRvm4uwWEITazo?=
 =?us-ascii?Q?jxVHuBCIy/e2bcZEr6E4NJmqrA40wPNwCnSPtayPO4QUxa3FxTrIvu2cAIpH?=
 =?us-ascii?Q?+ar/dTCvnynRf0edmNi7/LvmL57w2a8HhfoyEgKNAX3diViQlGHiz0Vfjj2T?=
 =?us-ascii?Q?QbPdm/MUjqdLS1C81dYkaDZhXKJen5EryoECzByvFTWeCY7tr9OeVN0t3toY?=
 =?us-ascii?Q?cnpddsV+N9xqgtUah01CGL+YJKF/c49liZU86JdRDgvBoVhh6cHynAl/UDFG?=
 =?us-ascii?Q?uM0Jj4RlQu/TqEkbos6mSOfV08z69/fducrNE44JLeA9sjOyuggLFuIkM5VE?=
 =?us-ascii?Q?Rk4wsecTEH6QT4qQfO47npJQHEvOV8aX1ngoNk2DGp9J4FrdfpkQg5iqsTtz?=
 =?us-ascii?Q?eJC0b0lDi/x9es2L7JCOf8OvhfIfJPWP4mswbaE7xB1vfEukgOnCB7Ynnbrl?=
 =?us-ascii?Q?9t7o1AS4LQfMEgp2MVTeC1V2Sb4XiUXhZeg71mBi68KJkf4eT7uKlf18Xd5i?=
 =?us-ascii?Q?lG/8qYRqIhQ1y1Q/cWuOI6lg0CwS7dbvNYS1F9uHOtIvz436YBUH9kNpd199?=
 =?us-ascii?Q?q71PPWfIM+DklZXPsSQja8GW23RF8i3xO9+q1ydp3wiYmhnsF57eeBxaqGvP?=
 =?us-ascii?Q?1Dyhxji/4fYhmNGbsRBrt0A7dowCdkSQJ7vn+b3fNfHUDve1UdULqGWJB7RC?=
 =?us-ascii?Q?3Is4JKX5YObjWfaMMWaRrdS0IFr72s2JelbTRLIy0KGqwR8z0qJw0e/vT9pL?=
 =?us-ascii?Q?VGvVLcfpodyWt5lowV3lhN5T3jXfavx2Hk1wFe+InT2kgFjDWZTqAU+e+ysL?=
 =?us-ascii?Q?zzaBl9Wp4h6eb6R3qbifO9FRSRarVAaCSf9A1hlou+Ocp9ZQdYGEOFbuY3SC?=
 =?us-ascii?Q?EoiQqcwPqkkjlFJ5V4gKIDh0ZS+SGMvRpcUEaNwUmKgiNH70kAW/WwGg6uDV?=
 =?us-ascii?Q?0JBuO+0nNcjppJAfS8AiN06Wf/5lchn3vB3KxWe/CEoBCeVRVKVLvDGnkl04?=
 =?us-ascii?Q?npT8Xl6s1mZ0KDAPXoAlDgJPtw/PMXfR1S+hNmJR2kyYEwViDGbhSBcvTiZG?=
 =?us-ascii?Q?LCrkjcHYjoCmlcTvdsRgcEGPzi2kVTc2HRCdRxt49TMF9jBBw5rArJdo3Mpn?=
 =?us-ascii?Q?KHlp1uaTIJhEzJSs0D5wOPv3o/A7N7oeavLt9fw2q2N/+nEslLyJnA/CYOyO?=
 =?us-ascii?Q?0ZJB7jS1lquI+RpAgvnZWPUzo7UF779P506mknbamJchHe7QvQ=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 238b317a-aa86-4a10-c447-08d94d6836eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2021 23:27:04.1570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gXHtakFKxXXRfo2+Hyu91S5xIZmlOvQ0uHTwJ2HQiUXfG3WtdsypirmMZcrPktTP4bAxOxFMQq9CIP8yYTakCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1244
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/07/23 2:34, Hannes Reinecke wrote:=0A=
> On 7/21/21 12:42 PM, Damien Le Moal wrote:=0A=
>> Add support to discover if an ATA device supports the Concurrent=0A=
>> Positioning Ranges Log (address 0x47), indicating that the device is=0A=
>> capable of seeking to multiple different locations in parallel using=0A=
>> multiple actuators serving different LBA ranges.=0A=
>>=0A=
>> Also add support to translate the concurrent positioning ranges log=0A=
>> into its equivalent Concurrent Positioning Ranges VPD page B9h in=0A=
>> libata-scsi.c.=0A=
>>=0A=
>> The format of the Concurrent Positioning Ranges Log is defined in ACS-5=
=0A=
>> r9.=0A=
>>=0A=
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> ---=0A=
>>   drivers/ata/libata-core.c | 57 +++++++++++++++++++++++++++++++++++++++=
=0A=
>>   drivers/ata/libata-scsi.c | 46 ++++++++++++++++++++++++-------=0A=
>>   include/linux/ata.h       |  1 +=0A=
>>   include/linux/libata.h    | 11 ++++++++=0A=
>>   4 files changed, 106 insertions(+), 9 deletions(-)=0A=
>>=0A=
> Reviewed-by: Hannes Reinecke <hare@suse.de>=0A=
=0A=
Thanks. But I will change this one, bringing in the misplaced hunk in patch=
 1.=0A=
=0A=
> =0A=
> Cheers,=0A=
> =0A=
> Hannes=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
