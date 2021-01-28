Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69303C433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 09:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38E4B64DEC
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 09:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbhA1J36 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 04:29:58 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:15336 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232599AbhA1J2t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 04:28:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611826128; x=1643362128;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=4QG8BfIzoaJiyvziUvgIlfTHkb/nU+Ud/ojtL0/UOFc=;
  b=P3NYsnCu3WAeTj6NrSY1VDwbevZgP/NVpyi62eJSO9RKWhDWeQydo18W
   uiGpj3F1YlIGVf7qUu8EfZOjkQYZFBbQ3cwob6uVfB6eiLJcTJ8MYUiG9
   80nw6rtYo886yDQRfkmiD+XELcPsLta235WW61PkwyKS1WXB8NjHjImNb
   fpGcxMCTRZiqHoQNh45zSRrjPoeNcNlGs4V97+X2UW2DTHb4RwEkEcnt7
   EjqhBmRft0GCr2r4gyXTvmt4E5PHMOsG17/Ww2qTiK68iU0qN/l0UnD+w
   7sIu4QMUs8XsVI0e8SfWe31KjvLvu9wBzaFHzH8XA+133PiPXsRL8x53Z
   g==;
IronPort-SDR: 6LPSzRpVwat3q/ezDQqa+mK6n9xjJhqjMaQtfTH0B3OS8SrFIlGDG0T1x53JSjYMP9xQ3in1Il
 wtUny3OaKs1FHue+dHgrrdjVqmni+3aBrn5DQW93InOO2eUEyoy7WMtEvyjCcsy+jukSn3aw+W
 w5c1kegBW16SvX4KHEufxUEQExIHWCTE4Krpr6GMkGF3EhB/c2M48OsLF+dzAMjdf3QRv3iHwB
 sV7T5H0Djoqk4QvgqBsXROKbGCNL9AhN9dcz/61a5azuVvnIGbCWMF03w3z24DturN5nKuLDhK
 FTo=
X-IronPort-AV: E=Sophos;i="5.79,382,1602518400"; 
   d="scan'208";a="268903708"
Received: from mail-mw2nam10lp2107.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.107])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 17:27:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMvDf+p7VNIIx2SkDgmdzNiAZrFwBmhb7vCi+YNVfoDABKzvLvNx63nurRuDbjM/boFe+UJV0owOfv4P+9ft1fAwq+w9fbXmR9H6XAwapjkIBrIbG70ClQ2BNBtIvuVqHrMO0+CikzY+zVuHjgYbMT0iVBrfp4iIJc5fHtPgQZyFnI5fBfUkygBtfQDVtN/orBRFyZmczvCTfuq1fgauJRQJkqjzrJKDL6E8Xi6xDRH39Hj3RTO4vLGyG7cg3A5ytajdhSUwYU6WW4sLHw4hu4c0evWXm1VjyNHWrECjshtNZowLhcA/6wnfCIFqvDkck7yMKsfhKFuIeIpiwc5slQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MZNxkTm5NHlqW1ic8cGE6UWnD0PuMV43Yb4q6oKqCVQ=;
 b=l65Rmz0S4C9qnQNT5/klZFc5mEijh7GvUnRW0wj1qKN45ZUdZKUHWzUuex2d0ETGHwE8OVdc2+i9lAoWh+592abgTNZto+A1GobQH3yAd5zZ1v+xrnscUJYe6jGofLhnGraAMZY3IZNNc0Ht0pbuDEfS5hp9uEj8E7DkM3RfohZ1Fq6clSkaukl65NuKQuNmtuMOLW/F06cKVIa8/YNy8eGRApLa45sLH+iIbbBaZ1o3fEH/SLMlBIU2PedwaVuOztEmq8EKDmlUigxBKz29LeOUzP8nYF6l3TOPyUwUAX+9vyfF9f6YFxALDk2xBnU3xX+Z7cuHQMqRMZLo9YYv5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MZNxkTm5NHlqW1ic8cGE6UWnD0PuMV43Yb4q6oKqCVQ=;
 b=c7ndW6vJCHb9whu2RxXkPcYXfagJAR37xSmUWqTLNut0WrKavGOYfIIGkSTtwtVZ4YS4UxVyy9gSwOiOmoCA3DEkSoYI0rBeGHxkiaaeBjx7KKztgUp7AevdolGK1Ex/8FHRMFpWUH7pIMyqwAlpKpCWXTJwFq/luW/fywJYzgA=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by MN2PR04MB7038.namprd04.prod.outlook.com (2603:10b6:208:1e6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 28 Jan
 2021 09:27:41 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d%7]) with mapi id 15.20.3784.017; Thu, 28 Jan 2021
 09:27:41 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Keith Busch <Keith.Busch@wdc.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH v4 2/8] nvme: cleanup zone information initialization
Thread-Topic: [PATCH v4 2/8] nvme: cleanup zone information initialization
Thread-Index: AQHW9TE8Qz1Y83XHg0q7+29bC+5A+w==
Date:   Thu, 28 Jan 2021 09:27:41 +0000
Message-ID: <BL0PR04MB6514F6AD357E545CBCAB877DE7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
 <20210128044733.503606-3-damien.lemoal@wdc.com>
 <20210128091710.GA1959@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:47a:7b5a:7dfa:1b1e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 516253bd-cc03-4968-c1ac-08d8c36ef5e7
x-ms-traffictypediagnostic: MN2PR04MB7038:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB70388A0A2C0A3D103352C939E7BA9@MN2PR04MB7038.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bi38zY+3JLF5Jvt1fluF8hzifmSEXenVVRa1cQ0XpU6U9l5HbE8bJEHGN7FASRyRLzrXHeiDz6T1TmO6KVjZPgud5rekVUfVc9o4u+XdMXwW2YZIHyxNEoqjHcsNJfy6f7sASRTOa8mpkKRbeWl20QamB5qqgt6Dyjs/aBkqkk2dJ173RKdo4fLbXUkTUEOOi2AVtoYQ7G9lKUpRTEAYKe65HEy+RHytRuBzo3MsT66hTGSyHdbdi6LwfFPpxCDs2XhmRoVw7AYQwI9hTNHFSWokTLq0m90e/0Xou5UpjYZT/l06BiSduIV2KcXF6F+HhXJJLZWlpexGeHVEkhyIcCIuZSHkMq89Gai2+DEi3LibOUFQAIAwM51pbWAhw/udSKrQysynkAKFfoo4JZnk+oX0Qf1KWn+MB1X9PGuJYiTABxFDpsOh2Eabjh6VbENA56IKbSXghiPlKlhifg/pCfQ/yLv4Z/LY5t1SH9plOD/WNgS7UknDEDLuv9polOXrWlJjt868mHFS9BDbM7jF6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(478600001)(86362001)(64756008)(71200400001)(91956017)(2906002)(55016002)(6916009)(6506007)(53546011)(8676002)(7696005)(9686003)(54906003)(66946007)(4326008)(8936002)(316002)(186003)(52536014)(83380400001)(66446008)(5660300002)(66556008)(66476007)(33656002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?D5krP9oTkkDi7r/F2X7wNh5PfG3P7TPPc2kq+WM2KCU109hgpkRPioTSaf2y?=
 =?us-ascii?Q?PszPtJyNc2mltows+yO+1yclME08FRpnxA8UCAcz3BffMVlFTXLRDKlmnb5+?=
 =?us-ascii?Q?kXCxHRYUb1lHrDcLHr9Q0Sf+T+nwD3Q1EJ0NYxfJgyNI52jByCrhE46WfJEt?=
 =?us-ascii?Q?X660H0qmQrygSuPIzyRIGIq/Zvc5Z27Wb39TMjKjQPcSsMMAu4VkICYSjHAx?=
 =?us-ascii?Q?xthkXPHnUATXN8Xd9699JVCcxQBulwcAvbQbG1MtSIFDP3Y7xIsWUx6PQeaN?=
 =?us-ascii?Q?6gRCuqqTXHrqmXrUi0o/pkaJVCpRQABKwIlPwnwsmUxMh65tZRkwmE7ly2kN?=
 =?us-ascii?Q?QM8dlZY729JHIhQFgPNB5YNnJ4CnZccEHACBgaWDEclFAwBmVOYpV1EPA8D8?=
 =?us-ascii?Q?KoDL3FfUdBfv/GzWXydv/KCJ3DlaeY2SEl4UjIR7fAs+KPCNrMIK8sfYpHKg?=
 =?us-ascii?Q?ZbE0KvHfIwY8LnLmGFjcSSFg6oumHOzZV8WhWolMPZaZzWIeUmXCQoBY+g/d?=
 =?us-ascii?Q?b3qWDcDE0B+e7uj+d/dzlK9CKGGytCbhzvJry0xoBFggD07DIvVnuSi1Fr/a?=
 =?us-ascii?Q?DgUAGb2a3gs8Bk1e/hYt0L/yWnv7qnvwqZ0sreicPkQ3ZdZkqoc3NEAR/gRK?=
 =?us-ascii?Q?i4j2LrIe8+/rdatHSxSsL2qdje2vl30vcgVZknsCx0UYO/2dJIjaw1assct7?=
 =?us-ascii?Q?haO59A/BgfT65xORsfFJ13wtkZ2yXn7LCRpzgWn+UYaR91fz9K2DzmrIoKSb?=
 =?us-ascii?Q?QfN72RtyEa/k/jyscDWBqTu0iIWkgMWcpPbVItzYxYshZ+pCxdWQp0VyN9pS?=
 =?us-ascii?Q?gZoq4AcAS1h4fEooIUUArYLbebQsGN4KpyGBclJlzV5FgUYldWp88OysF7cD?=
 =?us-ascii?Q?IKTIA7Fz/GMATWIh+KnTlmcdI6EI3JiUVTRllG9YWFhgtIajwU1WZpaM3Oeu?=
 =?us-ascii?Q?mk3hj6DNwx4BdUlYenCSA8b2wLrNJgx/Bac+bwMgUr3+NWTzvhBK8UGC/sX4?=
 =?us-ascii?Q?stu+33ZZN6eNHq8bbZUUkMJIZuh0gPqY7CJyluL/X5Ye2xBsocdnYyG3s/nR?=
 =?us-ascii?Q?19uyolyvMki/C4pOXCMXpXNBPP4gvsl7HqOeBJKCZYkTOX/eBHHOrsLec+NR?=
 =?us-ascii?Q?Oc4jZonrxQHHhGUqwaIp6sVpUaIX6mUZ8A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 516253bd-cc03-4968-c1ac-08d8c36ef5e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 09:27:41.1359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3RhIG8p26vfR3Vu4gOGT14ET02j27SC6KUZt0EtaJC6Gqv914TZPzp+ZG8p6nCZKuD3m+VzCA/ecuNy618uW7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7038
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/01/28 18:17, Christoph Hellwig wrote:=0A=
>>  int nvme_revalidate_zones(struct nvme_ns *ns)=0A=
>>  {=0A=
>> -	struct request_queue *q =3D ns->queue;=0A=
>> -	int ret;=0A=
>> -=0A=
>> -	ret =3D blk_revalidate_disk_zones(ns->disk, NULL);=0A=
>> -	if (!ret)=0A=
>> -		blk_queue_max_zone_append_sectors(q, ns->ctrl->max_zone_append);=0A=
>> -	return ret;=0A=
>> +	return blk_revalidate_disk_zones(ns->disk, NULL);=0A=
> =0A=
> We can just kill off nvme_revalidate_zones now and open code it in=0A=
> the caller as the stub is no needed now that blk_queue_is_zoned always=0A=
> return false for the !CONFIG_BLK_DEV_ZONED case.=0A=
=0A=
I tried that first, but it did not work. I end up with=0A=
blk_revalidate_disk_zones() undefined error with !CONFIG_BLK_DEV_ZONED.=0A=
This is because blk_queue_is_zoned() is *not* stubbed for !CONFIG_BLK_DEV_Z=
ONED.=0A=
It will simply always return 0/none in that case. We would need to have:=0A=
=0A=
if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) && blk_queue_is_zoned()) {=0A=
	ret =3D blk_revalidate_disk_zones(ns->disk, NULL);=0A=
	...=0A=
=0A=
Or stub blk_queue_is_zoned()...=0A=
=0A=
> =0A=
> Otherwise this look great, nice cleanup:=0A=
> =0A=
> Reviewed-by: Christoph Hellwig <hch@lst.de>=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
