Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F9A7C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 05:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C3C0224D1
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 05:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbhAYFdf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jan 2021 00:33:35 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:8124 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbhAYFdP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2021 00:33:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611552795; x=1643088795;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=2kzLejK3DAoptV3bjjQxMyEwuDoF4NbUxSH0CeFdaTw=;
  b=jtiqb7R9qKBaBOn70O55/h6f8pjDpSOQipwwiuEVnXWEbpR6/tHrb21F
   I/tmLvk+VB5zxkQoYcowFnhgvxt6CCFpdCxYmRjEZY4zIJy6/FA2ZX3Xm
   h02hL0lktDt1L1UFd/nqx7h4EsXRiZIP0At0u1wyFeQZ+iiBss/nuRLB6
   U0O4U/AiPRtUBag0Wm5DPgdt0jdnEdbpnMIHd6r7Xv+GEt7PZfgkTvdFm
   VKJfmYxArudEp7WtpzmBVYMtlynuGysMsNciQJjKzsJirbViwAHHzYhfQ
   oVVfTK3b79wkQVXDItYF80Os5OKkSqLdwj5l1G0f1stVvE9GX/7NdgOHv
   Q==;
IronPort-SDR: A6HOvbbiTwjxIine4fA1LHCW3AvNFWr6mH+HvPDiErN9l7ywZfMjFAva+MfUSdXBUpumvb9bgv
 Q4V82J4TbQePdx/r/uZ1Tjkx6r3E6i2PhhZsIQI287Ev0LnAqVA9y/FkDsv8aVdmSfxPlo9MYR
 sQgnIkqjetqrqbzwsmKFUKbz9MxyNJlYM7NfDDfAgdtgXmpgn8cQFymbODxwSKD4j642emYlpz
 BoyVwB/H3rJcEDuQ8BJPV++FgfoD4VaCelvPQWSugmqMQ1y3qzGK80D+DPQeuuduNVoZccZLRl
 BCw=
X-IronPort-AV: E=Sophos;i="5.79,372,1602518400"; 
   d="scan'208";a="159402822"
Received: from mail-bn7nam10lp2103.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.103])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2021 13:32:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3mhTV35g0QhTUEHQHua47aPCVOHNJqS20SnFuehKat9fiCa2MLKPDh9dPpptSt2P/JywLDC1nimg6JsrrtIcdM3WEb4QERaxsK4B064iUu20SdQQbtxMI1bL1V7WPF9dAH8vWTD7A/h5p1zvEdnjkwyEoN22zfYhej3qTVOHH2cLkdRfl4YsId7mlACuVwq+FRI2TPip56/4CBszGZsnkL2x7obLK8CdOt4P4pyEzylSwurBfarmhmgR7tpOx4vq9HK6EK9fiz3VyxSOuQxC7ZenUxnvUUE4XJAGN9I/D3Z8e9zCea056K9Biwti2Wi6L5eSDq6BhKgQ5l6BoxpSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MkRZ9lIdgF8wL39NSLj6NKDhgglOI7YDCTFelV9AGes=;
 b=oBgz2psSJwHZsBGq8wCzCL0jhQVvdtM/HffN3/jPszY06+VVN9mSkyTWdGg85X2r7StiVnz5c4ZBAhZsaiJDZZk3pOyIMtX/WflegPawjyyH+jNJhVRkCgX0L4kzl8m75KctFdcCHQg5446egtvo+Rc16WXxJ6WaYQn9l/lCLbnN3BsGq+HW17DdiwKChWGVaheU5lFigsw2eyJPiNQQQotAlbdg/n8DUYuulEWMERAJV59tG3u97/mUrOyFyWorsLbrQ51w5Sz1zqc9pxxNxaa8ItlusB8gteORkwE6otyKx0O9G5+XkaadJd00ZOtxkZIx6nG8PJ/ko+3i3C14sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MkRZ9lIdgF8wL39NSLj6NKDhgglOI7YDCTFelV9AGes=;
 b=fv5X7PB97dFUynqaAi65yqk9pB1MSBUUVmPRqGLoiiLQBMYr8rkCec3T5nEePEgo2GYM1UvDii8/7vXfpWvzCZN8FW+SpcGDvMX3r4H3a57qweQldvh5rdO0uauPSaW+CXw0LoRo7H/nvjYYkvaO1P3OSpgVH7ebMDD+TmctJ5o=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by MN2PR04MB6352.namprd04.prod.outlook.com (2603:10b6:208:1ab::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.14; Mon, 25 Jan
 2021 05:32:06 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d%7]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 05:32:06 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Keith Busch <Keith.Busch@wdc.com>
Subject: Re: [PATCH v3 1/3] block: introduce zone_write_granularity limit
Thread-Topic: [PATCH v3 1/3] block: introduce zone_write_granularity limit
Thread-Index: AQHW8JU6qVihsq4M3UKmhepNN6tFNQ==
Date:   Mon, 25 Jan 2021 05:32:05 +0000
Message-ID: <BL0PR04MB6514C3C43A5E3DA84632188CE7BD9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210122080014.174391-1-damien.lemoal@wdc.com>
 <20210122080014.174391-2-damien.lemoal@wdc.com>
 <20210122084209.GA15710@lst.de>
 <BL0PR04MB6514A2655635DFF482E4252BE7A00@BL0PR04MB6514.namprd04.prod.outlook.com>
 <20210124100724.GA27580@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:2db5:5c10:5640:816d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1fc6db22-8344-4cd0-9b24-08d8c0f28d8f
x-ms-traffictypediagnostic: MN2PR04MB6352:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6352C4FBB893FF5005BDBE92E7BD9@MN2PR04MB6352.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jMN6fEyF9WlvpnnY8NnjMJmyTr8DdIElB558OFfCN3CHIT4nZOhNU7z9vn3/ThpyLopwpP4gP8WVev1jnnmYbSAasdX9lKXCpO7d4/SAzyFn7ngcKV0fhixy85yJ+NeQ4BRdiyeRYfpFjEsX6xNzmgP8zlcgUtcJsGXbZODKLfpFYwrDK/yCWGhvghUuk3rdz6utoO8N/P+fCWb0L3tZvx6Gk8g5cOFWuV/h1PKc9IVvlYVoBHNo96sxUg0flPu13mhJDzQv7/EtYnMmIB+iUIytxE/n8v44cixwOI7gosM3AqBXdQ8j+ByyzAbQfHlZ650EtIEv4e/NSlYaNHoWZEm0z/MVoqSMN/ncU1T6KOQSz1qkvCZe25yoHCy4xSqffdkS7ATgtUYhVuX3zp0iMQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(5660300002)(8676002)(64756008)(86362001)(66446008)(66476007)(66556008)(76116006)(4326008)(9686003)(2906002)(186003)(6916009)(54906003)(66946007)(55016002)(83380400001)(6506007)(53546011)(8936002)(478600001)(7696005)(33656002)(71200400001)(316002)(52536014)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Se7P12tqHcEskIehSalCtsQpJvdeTsQpNkRbiu0bo62nBIbHNDiO6Rb7Q3J9?=
 =?us-ascii?Q?vgw16DCDLlyfTdBXw57xGh1wI/tCi4zTUHk1y1eVDI5lDuFg1J+XLwg+EaZ3?=
 =?us-ascii?Q?DvxULTeAFR/iHvEqnzoROJkJmqJ1ekb3AcHJKYaKbqpajjzO6mStyIBMTnjd?=
 =?us-ascii?Q?yTKGVvLFrO0apwB0b+zTP/YvXGZSwTrxxz4DhOch8FoOi+Z6CS2z3a0+LJmx?=
 =?us-ascii?Q?CdULtEUw1IgqO5LMZ8EqCmWzHxweS7WrEFpZSUuv5bwjEH5R0wy5IjN7kK0V?=
 =?us-ascii?Q?PyI4/KzWjDvJz4hnWqpVOMGiOPVMFZ7cwh+bjfmHjaA08R0PQt+mSgGOS/rJ?=
 =?us-ascii?Q?Zq/bgQfZ8s9XhvqjtUvF3vL6VJn8e4nJ5qQVgWrHGrtG6Ykkr8YlzSvnRWB4?=
 =?us-ascii?Q?T2OdqIlQSM5Nre3NA2HxLUq/swWqlfcooD1YH6RZeQNRfvqHMUoht86fBNab?=
 =?us-ascii?Q?syCH4wxgbaeU+n9nBIy7z3tpczZX7ig6CPcLv3Vqd0qYblmQ5nqrRPtWOJWR?=
 =?us-ascii?Q?qJBK4pGHUx5yiEGkdA0UynU1txfcbzRCf3QrvjG0agMzqWDPdp+OvzvZLpr6?=
 =?us-ascii?Q?se5hCwO/Tw6wn+0Cmf/c19VaNf6Wgcuubg4KMijZEvGNmQG0fSTZzR/Qo4Za?=
 =?us-ascii?Q?/os1Qr2fJkQdnSiwzEt/onfkmzpflVudF8elE+i7gUemzJHjgUgKMEChWyxR?=
 =?us-ascii?Q?IJSW5r8xvaFqf2eZ358Pkh9HzYigzlGWh3LPjzXyYug85AZHIFf+c8lOjQOF?=
 =?us-ascii?Q?7zMqgzhHZ2WQDlXZl40LDZEXB2wvBD0eGinj9cF8ULxzn3aVoTrHDvRBDagJ?=
 =?us-ascii?Q?+ffa0skbzOjeqawObDYvIYl4G95CaOqPoc5ORdCpyD1C2aphfwnR81i8Bs1L?=
 =?us-ascii?Q?sPqg0aILaXNDHG6GNanFhpWWEisdPslIDUOWpjrGhkKBxGvbVUuSkkG2Z3MX?=
 =?us-ascii?Q?7Kwuw0C1yIO4SzvvsgcV9vh9otqmnNKLxOeySKvyxpDj3YkITaJceXkeS4vP?=
 =?us-ascii?Q?+BCEmyd/4D9XIsD+j6WPt8C9AloQhTEgKlxsCGwYpVUPWFJMgdi2jBEHKWkn?=
 =?us-ascii?Q?eIY/xyLjBH/ytleEGKpd+xtx1/enPGGZPlQBTCnuoPB5k9nDRfmOT4pqT+NV?=
 =?us-ascii?Q?WshHvk2oBKwz5dxValFm4q9W2s8KCE+zAg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fc6db22-8344-4cd0-9b24-08d8c0f28d8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 05:32:05.9257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fKz9z1rmlKF6FNIKVH5DSaG6TOGNTOGkYDuwaRRBWR8wVHgpZOl2kddhUGoAuV0Rg6GPxQb9T/jGliBELG/iKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6352
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/01/24 19:07, Christoph Hellwig wrote:=0A=
> On Fri, Jan 22, 2021 at 08:56:58AM +0000, Damien Le Moal wrote:=0A=
>>> This looks a little strange.  If we special case zoned vs not zoned=0A=
>>> here anyway, why not set the zone_write_granularity to the logical=0A=
>>> block size here by default.=0A=
>>=0A=
>> The convention is zone_write_granularity =3D=3D 0 for the BLK_ZONED_NONE=
 case. Hence=0A=
>> the reset here if we force the zoned model to none for HA drives. This w=
ay, this=0A=
>> does not create a special case for HA drives used as regular disks.=0A=
> =0A=
> Just inititialize it for all cases if you initialize it for some here.=0A=
> That way everyone but sd already gets a right default and life becomes=0A=
> simpler.=0A=
=0A=
True for nullblk, and that also simplifies sd a little. But not for nvme,=
=0A=
blk_queue_set_zoned() is not used AND nvme_update_zone_info() is called bef=
ore=0A=
nvme_update_disk_info() where the NS logical block size is set. So some=0A=
surgery/cleanups would be needed to benefit. I could add a cleanup for this=
, but=0A=
not entirely sure if calling nvme_update_zone_info() after=0A=
nvme_update_disk_info() is OK. Thoughts ?=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
