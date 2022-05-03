Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAB1AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 15:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238357AbiECP01 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 11:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238042AbiECP00 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 11:26:26 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A08114003
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 08:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651591372; x=1683127372;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=JVjq9sVq3VxZrASO+sJRZaWeBJK50uDrJxJDgw2elyhTlSPtTJfPvWxt
   GbXHOpXAcDUY6usA694aERaD7RBg2x3qPflIt4a/j4eqGa02KdqOcsWqd
   EtfAjnFc7aaijKGBaDnzBTFw+9P2P9usXhoi4tU3DsLzi7izDXLWzQ77L
   gcsD1hecx5aEffJzJ7DZFDsuHj1zLnTFVD7WFTmdUQ89ZQy56CtHkFPEZ
   l+C8Av5+WrUgmk9gfcsxOIrdyAfGzIzQdm+atTaZ4tOgld+cw8LLzXf0R
   cH/kL1cm4bORkpF4JCdBHvhG1UpD7jxE+qiE9n0V+LaQX8UnfOKoVIJyh
   g==;
X-IronPort-AV: E=Sophos;i="5.91,195,1647273600"; 
   d="scan'208";a="199429266"
Received: from mail-mw2nam10lp2102.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.102])
  by ob1.hgst.iphmx.com with ESMTP; 03 May 2022 23:22:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lxf7Uq3azMNycE2AwiaG/pIHjhejwzLBss6lxiW5r39mHrC3Pq0IcNRGBpXIOCaE0j/wxNfQTlUx9WQ18IYgIwqeJxHjkFyc2V63yJ6kT/z2wX0/S4kaqjwcFDb+diyGeTZYawdv5OJUHRNMMmXXMiITGR+dPHjUIO4K+u+PG2bi8oQLBinhwdzpy4hKQy1BOCBBJAukYnI/XQ6EVJni61LsnPAMfN+iUMh/sXcrm7CprOQynbcVXWvkKq5GLnYvgGOw4DbiZY/LBgfUq7Q8Ar9H6wW40tpVDJLLPVN0hWs+X8GkOOFGXuy7gN5yAvhNrrISuKtyZ5KfqMFSCRTLhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=cFd2CGfVmh13Eg5EDZ0xrWoXXxejdXPxgGdpWoacHFQ/fj8TkDc4fDET8KS786BdzXPxh/D5lYD/bKzta3KDbb7F/bV4ucBa4oSlE4jWpXWajqM/HNbu/Wl1ARQdT+798JIeWgklc3fQUReyUbuOKwKfiiKDmtQra8rRYQCNIvmb4yiDi0dW7sETfbDBd9jhXyhEE0Kh4MXYus+5ecjoh6f2reUF3OYK3keLhcWuyB8Fsx+40Rw+UE8q+ip+4BKoL95Xm4iGL8i2CiNeipSQg50wEH+Pj0tmpVm82ayZKBMRS+AIMhQ6KJYQ1ezpl1S0JC175Qyzq/IPDU7zLYkx5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=ppVYFq29wmOi98SH2sk20J0hYKlRO/Bp/SJqr9f4xsH5K7TkiPgpVlNBpB4NNBrKgBi9XONRSpStJAVVYcRRkevKEjLHORRNrZlqUVZW33x9HJ6Ikj4477bWHxU0BjzlWu5pMG95JIY7I0Fhxxm4uNRNebenCfnnyJ8EZ6Ll9is=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SN2PR04MB2334.namprd04.prod.outlook.com (2603:10b6:804:17::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Tue, 3 May
 2022 15:22:51 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12%3]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 15:22:51 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 12/24] fnic: use fc_block_rport() correctly
Thread-Topic: [PATCH 12/24] fnic: use fc_block_rport() correctly
Thread-Index: AQHYXm0OUbHC5MeSbE2UomtLr+iEnQ==
Date:   Tue, 3 May 2022 15:22:51 +0000
Message-ID: <PH0PR04MB7416AF0CA7C0CC873626D23D9BC09@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220502213820.3187-1-hare@suse.de>
 <20220502213820.3187-13-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ea64a00-aef3-49f7-ecdc-08da2d18c9e4
x-ms-traffictypediagnostic: SN2PR04MB2334:EE_
x-microsoft-antispam-prvs: <SN2PR04MB23348CCA76E93B6E0BC41F8A9BC09@SN2PR04MB2334.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a4wGwxarY/uqCF6surMbOPo85crcVBQvMVCYEAFIrCHHzzHBXtd5lGcuqZwIqGhY2oTxe4CDMvpvKcQ6UE30paLHLVGdCuvqxiaHC788n45ZqlHbUnG8WMA+sonCnEo4qkSPb8SRTKVTD8Ymrampqs6roxC5hPo1m8rTBFR2/QpT5jWbc0UR8QYpNX5fdR5nxiqXHtj7ImTRLITMGVUN0KDPrOqaBJIFfim8WAd6cwu5G6DySePbqMBiFlSq8C1ygdtqQjRHm+aC/mzLz/usirPndUnR3WRLn4KLTBTMm1QTgT7oytiLEUH5/dyUdPlQ282oGxX4kR4udB5YQ2HxkvNlaH4V8xrAroQtrcsWkzd7cx9B/z9EnuejXshF6OFTJCjYgqixi1UGKdTCzlIJ9KCbwi55IkwQA4M5SksF95wQGisPcGABQe3ksDwHsSD0AZlr0KVFTtF9zQ/iIxjKMDludv/N5i1ru7jF6lzaopDfpL6Op4ln7Kyj3rux8yufXXR+bk7PHjuht9FF1JrISINGiYZqc1JCRsOYjh5+eoOhLqmfx6V//GOoV1MUVj1TI9TCVmdPS+vWyzImXdvi26cQgXdTpVLv4jwZh0KzuOEIcwvsol+T5G0GYQ04jGG1+c42ec7pYhtwfhHqAZ834rwTfCj2vSxOWhX2Ft6NOoeOFJEmIbvuZ6rYFHP7iFcuC1ZFsn/mvjqIG74eCn5vLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(54906003)(4270600006)(186003)(52536014)(9686003)(6506007)(33656002)(508600001)(71200400001)(110136005)(8936002)(5660300002)(86362001)(558084003)(55016003)(7696005)(66556008)(66476007)(66446008)(82960400001)(2906002)(76116006)(122000001)(64756008)(26005)(66946007)(8676002)(38100700002)(4326008)(38070700005)(19618925003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iAAjEoZThzH/ZuvCy1BYPPy/f/TQ0htn8NRzJ1j0+6U8+IZc5BU2a/Iq2LUa?=
 =?us-ascii?Q?4iXCjdszMS5Pzz7RBaA9Muo3pYgKemXjnErRsNiMFMMZUpyijH2IahfLBryb?=
 =?us-ascii?Q?VrTKe3dAaXoiDn34I+BidxegTqMj89pVfpdBiCnMqDM2YsX8ZMM4gw4WMGFn?=
 =?us-ascii?Q?BOLU0LBnN4o3A/R/Rsa5HrwNnVP6Gc+C3HwKiNwAXLkysBQDhWV4l98K84Nh?=
 =?us-ascii?Q?M7qfCYffiQhKnayZsa9tYsaVLoUFpZtCal9q3BMscZC7oVQJFsoBkoqouGt5?=
 =?us-ascii?Q?+wKe85p/8gS4aoJmJjm9TZXLWaMMBdBl6TnXBJ8mHAUiplzKwu56BOWmM2AS?=
 =?us-ascii?Q?ji+/THP0ekkGsJiM9nyHgHkDr2OAEHjb5sJdXqSaWN3+vL/RKMr9cAf7b785?=
 =?us-ascii?Q?/l00POoKA1YMwhIKX38Qkby/TmwSzfupw8LfSLuDWm8YjO2JqkDkymIPkq4h?=
 =?us-ascii?Q?NSgi8XYtBw2jHM+DLP+E6e4XjmxUtfvOLFwTlxSL1cqIFtRu475HQJarNLtz?=
 =?us-ascii?Q?MKh4GtSCNGTUF5I7oBYdymm7XzMjjX/Jj6+1JsRMnJRXaWbprpGrxI1AXqM5?=
 =?us-ascii?Q?+b5q7vnZte/Z37ugScHlRQI3iNBGXhByEomuOQh3HKh3xYAhFVeqKqv3rpAf?=
 =?us-ascii?Q?LLIsl419OrvzIzogHf+Oib2C0ZrraYHm25I5AaTku5Ukoo+748xJWniumqNu?=
 =?us-ascii?Q?sv6S9SZb7QJeOdAOQexOZQY1JiwwoLAzQUJ6zrwr8c2Eux0OjNyitmOR2sIq?=
 =?us-ascii?Q?Nmu8sTDZ7eWnI6rmK/7lWXGO4uxv2MvnR3wMI4jJWQNebw81/Lzg437biVse?=
 =?us-ascii?Q?kaDKx6IiLinBB6YsSiu2ESPFdFxl7noljgix3t5PAv0ehM+gzf5s2X9rzZQ6?=
 =?us-ascii?Q?AWaCcia/wtwZDaow5uxbHQtXEqhDeCVAuaF9uZdYL2topiu4zYl68Ar7PJVP?=
 =?us-ascii?Q?qQyuQ0BT+ixQvMSkMXEhGwaZT269fOBDTy9GrflMdCQ6AAstdJ1TiZRGpRcx?=
 =?us-ascii?Q?xOiVN6MigXATBAbVPULtckDysISkWW1N1G+1ZpQT/7Vqk5wVvNKN2/dK4gdc?=
 =?us-ascii?Q?zrg+8qPVSKRkFS69lE5cqcl53DInFDATJDrdA43iI13ydc5/1PgGqgOGJLGV?=
 =?us-ascii?Q?z//wSt39vDls2PmJVjBv3Yr6h0g/a38wVQSOv7xuLxzU3dQlhIF0PE6JfLAd?=
 =?us-ascii?Q?tOVu2rkqR3BJ9rGrKU+xJxQ9p9IIu9VedETIOPVBydGMHhOPkZi4++26EkQF?=
 =?us-ascii?Q?raYNx9qj0FqYRFTvqDIirhpPY4xksy7qHXI10H4+Q/k/tVIowg9IvO2UZ5M7?=
 =?us-ascii?Q?Fcs7h0qNYrKMagZr4nQK1G0Bb8UNxIX1I/WcRTOZjdwfu1eL12IpOwfxk9Mx?=
 =?us-ascii?Q?vdryr0xtergaqE/xjLjioEtdKzRmVMN/hJtK0f54/Zep7ma+bqoWhhLCoZfC?=
 =?us-ascii?Q?dcf84kKLc5QXfTu5OYbiTsjtsDJKs/dzO6uue4UXd/i0ycpnCSO5yh+VTo8a?=
 =?us-ascii?Q?MRTfyyKfUfXyEmTVm6gDn53SfnjQwlAFrGlq4BrAcqg3WnP2brDTJmk4U1Tu?=
 =?us-ascii?Q?YpcD/H+nIxS7QLeoAQkFMXyWE7bZ56YZjsjjlGbmRQy/ZWe1zhM0PhkCWP14?=
 =?us-ascii?Q?gvm0lDGV46GWOLHJGqSbVXHmFqwDuE4NnwnPcG32RnPi95ty9UGS2Wht2yLP?=
 =?us-ascii?Q?ezmnaTFQ/XH3iiJO3OZvKTwGhRQM9KF+ZuJJHNAuMJ2jRgNvS+9Rl0gi3Do6?=
 =?us-ascii?Q?W4xv5+dLvm/K9hQDhfSsZD3EfaoAbwk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ea64a00-aef3-49f7-ecdc-08da2d18c9e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2022 15:22:51.5409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mc6HNqIs8okqsSlx2H5p2bf7+YSFJ77hyqNpZZ8ea5BINCaczbcvjMhKbrZxpbfA/4fdSgp6gZVcr9QwNvyXHbtgraI0czTzrCTidJeigOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR04MB2334
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
