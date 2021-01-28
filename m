Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE12C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 09:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B9A664DD1
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 09:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbhA1JgU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 04:36:20 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:55126 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbhA1Jd6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 04:33:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611826438; x=1643362438;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=GRHH9Fm8EZ2EQ5tWaY9qx/VyVEfNwapN7HaXpCFq6Qc=;
  b=RcK9uGvq9cC34x3u6gP8m782t3Ws0c16DloJ9fCR5e6vfCtPHAR4jUDR
   GGAaMfNpzmLByGgZgKNMZI8NMNTl/H5hGQrahJje9Yw56aPIk6HSLtWyC
   nEZJSxOX7E+XpOAGyjcAnEVpYcLL88LrZY14VmGZxrzwfYcjGAVBtgSeC
   g+KUtyA7wgE+XwJSmNpb86If5gYZxSRA6bNGa18dBZ09agY2rVSXiK7wW
   le/VZ4OOKXUvBLtvmNiq0AXAoUcTW44yyI7aVx1HH2kM6/ogThGbNugOY
   RlQDfYkJLquVtFJDeWLrxpXAYJQnSAbEj1HE247ykMhYxDGKsHw0wU5r5
   w==;
IronPort-SDR: tnt7W8wZu5rZsa/QRsHUN1W5CsxIFpWfEe+Ly4J83pRs1LXFakecjhAiUnn/kIPAeBMT8PDXsL
 LNzL9V0YJLT/4II2f2JmJkCKDr6qk9k43yhmrA4BxnZcQuxQpWT4YiftzgwVnvZnSE8dZ00d7l
 Wws3/A9f2YJdjNzFvDMOupYSb2pNzKsSXGkc0IoQAMqRqMeLqsHAPXA7PabEIrmGYFXv/Nshc5
 KNzef2omyaZuX6oTC/VlbukgnpQYAVpJufYGdEljwlBV8j9YMysX2wm32Y9lxq+TCJFWX9oyGn
 X7M=
X-IronPort-AV: E=Sophos;i="5.79,382,1602518400"; 
   d="scan'208";a="159705747"
Received: from mail-mw2nam10lp2107.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.107])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 17:32:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WsM4osFA8VOjtHq0KpGr9okVMFGMdLblMHc/UmOtQ85kIqNIWsUArs/hLpfAFC1moCiA7SDeqRhpCYshj731bak20nH+WMJ5dpKWCXgI/2RhVgKon3mN2232hZU5ZqchH+M8ho0X3YW/hbIHi/xFUEDUosz3Y6vkWVaeFCkGXK6BZqFJm+kLvcRwk8MucJIOfTp975r1IkWmZnCcBeBCh634crGcDvml+VxtLBhtprw+FRu0eDui1QklMTd5TKKLmYJxz41C2bq8XYA2qnj3v6KlXRmKhQ3I5y1dmmLREzrl4rO7QYczJ5hRZtXm2vX6Cnwmy7KV0f4g01TDLqjXPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TTs6nj2ZKEZRaOA8ERh2UwIYO2mg7mvewYK1ESsehhY=;
 b=j0Rl9Bi9kbbmkXYMSOBIohXd0izLpSHUW7iYo/Lg+9B/zOPR08P7CcpRFuUz8e/eG9SNgd6uNk9XeuNgIUkKdiFFvOa+B/NRFHZM1cGcGfKRNWSpebU9/UpcH+N1ya6AIMD2oY95lpuTozNuBw/esGdMwhkHMguPAoGitPFopj1R58wT2dyBCL1KuqhKtXf8aagSSvdaw65msETCsPD1ZJPolNgOzVQhIhkEPMX5SqDdlBuX7Omg9ldZhq9O5yqeaSlIk33T5zfnxIOULHcza7xdi/MtxkVs8xfFEIYtJBCm8vkPD/JbetM9H68+k9gcnKmodOIyavj6dWfOC5dEnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TTs6nj2ZKEZRaOA8ERh2UwIYO2mg7mvewYK1ESsehhY=;
 b=W1X90Qx3uwszqT0MVbqm4A6fXnkOD4KSekO6Wum8+fN7nBBD2wYhRz6cDixmlOHuxqIMCZP48shwb26uqxO2lhJMkt/3tDPWX7UEw5kLju7tzaWhpsZ29fX1gEiGfUX1FRNB66SncGKYiZtqmSxusJehdV1RE6vi45u8LG0cVn4=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by MN2PR04MB7038.namprd04.prod.outlook.com (2603:10b6:208:1e6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 28 Jan
 2021 09:32:22 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d%7]) with mapi id 15.20.3784.017; Thu, 28 Jan 2021
 09:32:22 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Keith Busch <Keith.Busch@wdc.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH v4 7/8] block: introduce blk_queue_clear_zone_settings()
Thread-Topic: [PATCH v4 7/8] block: introduce blk_queue_clear_zone_settings()
Thread-Index: AQHW9TFLA1BaEhuEZEmCwFnZTwFt2A==
Date:   Thu, 28 Jan 2021 09:32:22 +0000
Message-ID: <BL0PR04MB6514021E07E861070BDD852EE7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
 <20210128044733.503606-8-damien.lemoal@wdc.com>
 <20210128092107.GE1959@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:47a:7b5a:7dfa:1b1e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6a27bb49-3d13-4191-21c0-08d8c36f9db4
x-ms-traffictypediagnostic: MN2PR04MB7038:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB70381CD831A57F388C23D213E7BA9@MN2PR04MB7038.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jqT5cYKnBwPjmuf0kSW2XlzoriNNyq2wJKe/OQfqt7z8+cxkjHpLwaR3UJJoj+GfkTa6P8WJF76SUgmXCcaXowbnR5RxtPbJP01bVm+9yqDAe0zoIZtaa5vkmyAlANd9wL8rU5GvSEaCyFBKo+C6kyzICvdU3d0xz2PvUYkU5ObRVHipLSlqyHU7bFCgmIeO3GvjbFUBe1BW0/YcpKKrsuoYuDCbXhTAK6mxOYE9zXl+8kQe63l/yty7u0WqLtLEzQMXZXAVSiExZ8CXe7VP9b2MHePEG4hySqxUgbifyx/h3sp1i8iMK1nl1URwZEDnmIcUMYXn6c6q12qqsC1bqVK9IYZTLUAF18HaarJlqZBm8WbXDcD+RGM9ajhiKE14Wf/ApqDQurDuFSZIvVAr3HCylU3lIUnByl+ONcLIWMAImSAICr+QPE9EhxgOB0Cqw4Tmm8rM8u99iIgx6xyKPpIMYagphQNniMdxUBJXjQOIxwU5JhauzoupO5J68pHe7SLmLkwks5bNqjhAX6IOyw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(478600001)(86362001)(64756008)(71200400001)(91956017)(2906002)(55016002)(6916009)(6506007)(53546011)(8676002)(7696005)(9686003)(54906003)(66946007)(4326008)(8936002)(316002)(186003)(52536014)(83380400001)(66446008)(5660300002)(66556008)(66476007)(33656002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?aKquCsdWXosg68I8csIGsZHH60E5fiORrYBVyugRXxv3O36YjrvXWt11YIy1?=
 =?us-ascii?Q?lA2caNPFHGxxtbaaRy0zSfpmPhnKffJIj9+OJzbKSOIoJ3sH3br9XgvzkxHH?=
 =?us-ascii?Q?qwrckk5ecynhdnQjd1uCpu92ui2H1NKZT9NkpQHBh4BuqlnxzioOrQrMSzs/?=
 =?us-ascii?Q?IXhxk5VhywZ/SVD8kAAFxxQG+xHOZ7pZsRg4h6/FViSvPzMmOuUfiypP4euO?=
 =?us-ascii?Q?bJAPdgCm8FRXxyiByVvAR1vZNe16VHaZW/oi7zq9OvQfMIqieujfa2O0rA/Y?=
 =?us-ascii?Q?EIiaki/dXUlGGB5NqdO9XBvGaq3fD5mClaESjsaIQYxBD6jLGvLxLOqaFYwW?=
 =?us-ascii?Q?Qzq32ekzStGPCyScvpnFktXpER7aP1SPfKg5Gad6naOXewoF4jPbV6m1Reu/?=
 =?us-ascii?Q?axG/hoEBNo1T9nYUduObb+5Yrpcl5vBah2K+/CBj+i8AvK1z8/hW+D0+0HQ0?=
 =?us-ascii?Q?E0vtdF7gjWelRwejU/b1LiYvquv2jRfi2xz1Y1PWYtjJbvUYscuVzeD/Ezwo?=
 =?us-ascii?Q?CL2cfCNkfUwHCYtZsplI5vdj66fGCEW3K/yfmtmJa2XcS8cq56QTEfuPMypj?=
 =?us-ascii?Q?YIcW9QWdGkEGpz80YURPhgIx9CJmIKThawNtI71oG9Uy7gZha8F/yWUgGHLK?=
 =?us-ascii?Q?IlOhDvwAEyY6hsEyscf38LKMUdjc8a9Myxr978Bbwhm5i9lugPMFeEHBiDqH?=
 =?us-ascii?Q?MPDdCsqejNatme2LfOPun3mNfdnDRUsfKDRA4IDvs9jC7J2xBDziH+3NlNDO?=
 =?us-ascii?Q?d2iS1PF0HIVYssfMEUxSjFXjAbbs+fuCICe8q13EeWA+iZPXvZQ8NgkS77Qi?=
 =?us-ascii?Q?TnGHvpy3IA6Vmv8Qc6mnENCyTZPdxcdrarMc2fRzbvZe3UlPqrPLEPctD7n6?=
 =?us-ascii?Q?zWrN7Z59J5TBgwbwgYgHQfVYoSULUyK0mCk/+BnRBKKIFHr23lq864k4OdDL?=
 =?us-ascii?Q?8PsLa8bY71ak7qI0cYAjMpXR/Iw1lvR7b9LzkWmim/uU+im2bnSV04GrZgpL?=
 =?us-ascii?Q?3y3u1jm7YtR6I6BjslB22aC3NxbP1j9IHsDbMvlB4k6Qe8T1KLn52w2WE2fD?=
 =?us-ascii?Q?2xmFCU/65FZ5gkEPZrH1Gugy37DNx3s1l4NH1T5t3J/3mwSAaSF5bqSNGYJM?=
 =?us-ascii?Q?mEPkA5Y5/2yybidsQokxGIJcLtwNwR6k6Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a27bb49-3d13-4191-21c0-08d8c36f9db4
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 09:32:22.6130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tbZL0RGETG3OXfA+lQSU524jfMNUcOBXULYjj3J4U/meWgZWn7WP7wHrT2xdJg3lV/cF5Q2NFHydxyWOI6IC5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7038
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/01/28 18:21, Christoph Hellwig wrote:=0A=
> On Thu, Jan 28, 2021 at 01:47:32PM +0900, Damien Le Moal wrote:=0A=
>> Introduce the internal function blk_queue_clear_zone_settings() to=0A=
>> cleanup all limits and resources related to zoned block devices. This=0A=
>> new function is called from blk_queue_set_zoned() when a disk zoned=0A=
>> model is set to BLK_ZONED_NONE. This particular case can happens when a=
=0A=
>> partition is created on a host-aware scsi disk.=0A=
> =0A=
> Shouldn't we just do all this work when blk_queue_set_zoned is called=0A=
> with a BLK_ZONED_NONE argument?  That seems like the more obvious API=0A=
> to me.=0A=
=0A=
That is what I did. blk_queue_set_zoned() calls blk_queue_clear_zone_settin=
gs()=0A=
for BLK_ZONED_NONE case. I simply did not open code the cleanups in that=0A=
functions because it is simpler to stub only blk_queue_clear_zone_settings(=
)=0A=
rather than having conditionals in blk_queue_set_zoned(). That also puts th=
e=0A=
cleanup function together with the code that allocates most resources in=0A=
blk-zoned.c. Easier to not overlook something.=0A=
=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
