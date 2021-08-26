Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C83C4320A
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 03:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33F8A610CB
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 03:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbhHZDKA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Aug 2021 23:10:00 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:36096 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhHZDJ7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Aug 2021 23:09:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1629947351; x=1661483351;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=y+2zwTh7+AG1SLI6+suZPMwoMolnTepaF36DqeB1RqQ=;
  b=QJoq8CaVX9YkoGHVZyArAvvSBzqsa2rD31QU2/IEjtlcBwljkqkMMWYL
   LwBUWX3UJo26ow+doPqxGMhcb8HzmFzU9/cYgRxiske1fRXocxtDwxkvP
   cYvWdsmSOwq+32LAAkkGyOu+FLeMlCoL6GqtplH8vhRHzlQjDQMtb2stn
   6ySc6Q5Qnlxj8h95SeZJj3JZDOTXJqvVFogTXLDIIGTvBBCcutNxCXeGC
   MsK9KEjgEllNm/+Mw8MdmyDANKkJjjGiOeLUZYh+iWi+diB9nw01Bmf3Z
   uBmoEL0fVwiA64ZnrQ+YF8zGwJbz6lu/qZ1PaIz626r+tFkbUCOvHeb6j
   A==;
X-IronPort-AV: E=Sophos;i="5.84,352,1620662400"; 
   d="scan'208";a="183208779"
Received: from mail-bn8nam12lp2171.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.171])
  by ob1.hgst.iphmx.com with ESMTP; 26 Aug 2021 11:09:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1zYZBuRCjKJgBiThq9sJOiWC0aZXUcyP1fwNd9otJpqhWw0zrQ0m5mJHWa/Aphg2YeE167jjmz54tmy95XTqQR7HlYoKO8kNaokBc5NnCuevwQuVDhfLWkukR5QxT3lvlv1jy89OTS8qGg1w/2YlWCRgy1okxUiFajqIXsxW+1lNCYLWcpTuVs5DAOM87cFbDS58e0AqTD2G69nXOnpuRcJzZEXgZrwU682nqvjB729mzwKBrGlBZN6udoPi59cPpsgE3DFlhelmqjItfSiHmE0NX5sTfODxvKtDdSj9+rSFlzPJN5W7h874kGpYMr9bTAAqr43j/uGH8eNBqmPgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+2zwTh7+AG1SLI6+suZPMwoMolnTepaF36DqeB1RqQ=;
 b=X6kESVn0oO6xdIMznqnXvfsjkzQ9GWSBvwY8rmXJI+Bp3q3fjEkpWsR8FcR3DdhQLyVI0vuzQj1baHm1Yt2+IiO7Oi2GnBHDjh0AEk37KBh29+i/70QOfydUhVLfwIh+dwURPddE8xf5sB1x2er9PMkFTIqFtaDPbrBkTrDosl78hjvByXZxUcaQQkHZ6FHu0QCs7h3F6VfgVjrYtVVynKfrsTPQHQ9DNpZBqzZJFw3WoCC2sU8rl2pQ4VC2ohQrbX616CXP8VTZPQw7fEbQwXHuujKlzMGeU/UR61AXHIH3PNEO4L/ZumJRC34eu9W4575/4rG7g2Bj07Lchf/3xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+2zwTh7+AG1SLI6+suZPMwoMolnTepaF36DqeB1RqQ=;
 b=ZM0Gaa/ldzba9oHDBITZYmU6su5GZeJB4F7r1Cwx1F9jC0G/5wSFnsOJAlra3uNdlWDhjqZsyr2pwFzZHvkxZEsbr4H+4ASg8iWDBqf1DIky4XHVtRHjTMtizuIQwT8+FsVa/ne4jVy3WPVuufOrhbRANYKXh3m98U6oteRZTuk=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB6828.namprd04.prod.outlook.com (2603:10b6:5:22a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 03:09:11 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%9]) with mapi id 15.20.4436.027; Thu, 26 Aug 2021
 03:09:11 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 0/5] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v5 0/5] Initial support for multi-actuator HDDs
Thread-Index: AQHXj060+x8p8fG9EkmgObG6vBUOOw==
Date:   Thu, 26 Aug 2021 03:09:11 +0000
Message-ID: <DM6PR04MB70818AEAA6539E3834519E9AE7C79@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210812075015.1090959-1-damien.lemoal@wdc.com>
 <DM6PR04MB7081E6B85744B1F86AC5E7CBE7C79@DM6PR04MB7081.namprd04.prod.outlook.com>
 <yq1tujd9bwg.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3d0ed9e-8dcb-4fbc-25ae-08d9683ee069
x-ms-traffictypediagnostic: DM6PR04MB6828:
x-microsoft-antispam-prvs: <DM6PR04MB6828109B82845034F982C7D5E7C79@DM6PR04MB6828.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qQArqTHTLdBy7ycvmOHdesZUQCiuviyvQWDclygWjmYFedgK3Mz9tG2flwx3cd3+HGC26M8zYDq4HZIPBhx+64mB+/qG91Nlu6nImggt0Rh5r8byi2OCHIwCCIR8D2R+DVIPecaFkkaE/B0/4Y2yxubVEq2F+xuQod2wfJB/S3GYih55F8AqwSgjwPs5+o3q7Gia4qF0J3fwpa1FAW82JxxSuaNpRkJY4+qBKW8oBFFuaYDNodJVBgxw0mj2wHY0aX2y469/goRtN+q5H9SEmRQmNRKjOk4Ofgc0c8JM36ZIuCv+FnRqvT8vWacVqxsHVxhU1oMGFxr2+RuPlg+bbNN9pQP7Xx9uw5NgAphAF8Nz93pCO53p8FKn/Ejdrg/d9sztV5AZ7GzIixEbYHVdnfm63kY3kgEaGZ0Gcpt4M9tRgoDrXnCvKdX4qgCCPERqWxRl2E4jDWO8DK5XgnFDbA9BtikjyRo7J4MEEyW0rFN7hXwoMmMRkBIeSjXZCcKBb53SKOAauNXpeXy4FH5FEGz+HBweoLrUb8jpeVggF41HwySdtbR7RhYTW2pYkCxvLA26W70qbU+SJCIKuD/X4uEkZLNPjjV7tUHcy/EqcJhIMMb/H17eabaffPnMO8aWzJtbF/2WO3DxdQmwy3JrRzWsUnp8tDEJ+fClbsrVyAOAOXIMCa3KANRrtI3dsWSy8B2eYWLrJzKNmq/GlgqB23y6LaSBVVmFvFd1GlFTrUyzysmVFeHQBhtzjhP6JBg/5cLc0N2JB1/VkMPHuyoq93xlHDrXNG3i5jE1WDS4XSw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(4326008)(76116006)(966005)(5660300002)(83380400001)(91956017)(316002)(66476007)(66946007)(66446008)(38070700005)(122000001)(38100700002)(66556008)(55016002)(54906003)(64756008)(8936002)(186003)(71200400001)(52536014)(6506007)(6916009)(53546011)(478600001)(8676002)(33656002)(7696005)(2906002)(86362001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3u69uw0sVu59mOoZpk3DZ+rdYfd4pFb2XWP8Nqomm9VbFWFsxkOuL3qlPdGy?=
 =?us-ascii?Q?XGFeE/38GDW214brVESbLlDzyR/yvqhZCjSoBpjcphd4MF6gthSO2xaAOLb/?=
 =?us-ascii?Q?I1CX0VuSeBNFL9o7MYCG6WX6qAqQf8ByaygeeXk3X+/Ak6uQEO3J/9BtmN4Y?=
 =?us-ascii?Q?TwRF3+DgHqJEnUYypRYE9MUfxgAJK/bidV8wpXLnQqXSQT6GopNXICu/ujeo?=
 =?us-ascii?Q?oYoPUXSoUuQTXaqZtjcNDZrkiEvdmF/ht/zTxKEHtpd/vlsTkrqH7RLx/LL4?=
 =?us-ascii?Q?eVItFX19lRh17HnzTK2JpBinv0t0oOKA7lNVZxOom+/v4bQPDDwJo3MWC6YD?=
 =?us-ascii?Q?jx0O2y0p793eLZZmo0m4XiYJtgbJ2Cji94siYAmz06+KOsh0mmseElI/3Tqf?=
 =?us-ascii?Q?N0bKcN4gVq1giH9v+BJw9FBvKVW0JFkPxJVHkcHpGP2hYY21WsMZts7LDvWd?=
 =?us-ascii?Q?xW1kIlNCNe7bYeUoYubZT4lYDBXgv2dqo3U6Z/11V/PuKWxmiBsOXCFdiAfk?=
 =?us-ascii?Q?a5Mv+Qr+zJaEA+dV5RnuWcDVBCQuWFtTYAipDy57hDEUpytN6/bSso1adleZ?=
 =?us-ascii?Q?A9HwpAuWlZ01PtPShs0xyUGor/ITkFk360Z9OjVxypB7ONW0yk1tjAtuWtN6?=
 =?us-ascii?Q?uIVrieqUetDq8KT2fzUQGFN8YE8Zzf6jhttZkvNMQMfOSqEQr4UD/Lc32CJ/?=
 =?us-ascii?Q?NeML9225yxM9SRktDJIPcb712wvcb0nQaJXPnBN2UT8xrOvUDp3Qj9l7amuw?=
 =?us-ascii?Q?h/7pBz85AmsRpfRAdQp1hzdP0EM953gkycVaiOVtfxNtSMGbHeIPi3V7q+ZF?=
 =?us-ascii?Q?tJWeKUZ70XcIeesiXsrqDjvJ6z1NxdD+4DxF6hXYd1WUH3KYheL/H265A7Mk?=
 =?us-ascii?Q?zwVUR65/5N4hDJFIz8GEvkdtyHdMz4nwL93s7u7L1zGwGyFZ5P/ZCoLLprzL?=
 =?us-ascii?Q?UAtFwh1bkEeTzMUEjvAlKkK3GcYfkLeYn68iup/bc6b25vxlQKWFV0+3qerS?=
 =?us-ascii?Q?2mkf7DGuRs2eCcKxEy3zqxgdzhgtSvjZ5b09pxUfAKRu4o5cdTNrsv9gM0i1?=
 =?us-ascii?Q?BFvgoOXdRIj7klYeZ/s3+8uKTg7OpzwGSIyioUfWQEazGQus7Gl5jga8AXNW?=
 =?us-ascii?Q?dKQWVsXmqmfM6/SdKdKdKjm8WWrbN+atb8z6r2E2uE2HuIa6hbRWRci8lFjr?=
 =?us-ascii?Q?yLHPs1tvSP+Y+CC9BF2ycIIMDXFUQLv8RNXDcKthOsHaNcc+DyK6CYxnJfJc?=
 =?us-ascii?Q?t5nNVvJ19iV3C+L45NFUQcYYKFcjWeF1YRMERRWJwTMbI1uxp4JNjfkSod3P?=
 =?us-ascii?Q?9Uvb/R2L7cH5WoaaNL/5G5bw8efAuPI77TtkBHexhO86b6ZJcuKxjlcTmD1q?=
 =?us-ascii?Q?RSU+Ytzyu/yCz8zZ73J0lpvLmxkLiW1f1zi8ov2HsyQSwLQEtA=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3d0ed9e-8dcb-4fbc-25ae-08d9683ee069
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 03:09:11.0958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GwQf03ZEXxSQfnM0lG1qW5gUpOOI7E3KHielERC6iuGh5RBrEkEMmgifbXjJD1yXCKwOVfY0rkp5xQfvEAR1vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6828
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/26 11:42, Martin K. Petersen wrote:=0A=
> =0A=
> Damien,=0A=
> =0A=
>> Re-ping ? Anything against this series ? Can we get it queued for 5.15 ?=
=0A=
> =0A=
> Wrt. the choice of 'crange':=0A=
> =0A=
> https://lore.kernel.org/linux-fsdevel/CAHk-=3DwiZ=3Dwwa4oAA0y=3DKztafgp0n=
+BDTEV6ybLoH2nvLBeJBLA@mail.gmail.com/=0A=
=0A=
Yes, I have been reading this thread. Very good one.=0A=
=0A=
> =0A=
> I share Linus' sentiment.=0A=
> =0A=
> I really think 'crange' is a horribly non-descriptive name compared to=0A=
> logical_block_size, max_sectors_kb, discard_max_bytes, and the other=0A=
> things we export.=0A=
> =0A=
> In addition, the recently posted copy offload patches also used=0A=
> 'crange', in that context to describe a 'copy range'.=0A=
=0A=
Yes, saw that too.=0A=
=0A=
> Anyway. Just my opinion.=0A=
=0A=
Thanks for sharing.=0A=
=0A=
I am not super happy with the name either. I used this one as the least wor=
st of=0A=
possibilities I thought of.=0A=
seek_range/srange ? -> that is very HDD centric and as we can reuse this fo=
r=0A=
things like dm-linear on top of SSDs, that does not really work.=0A=
I would prefer something that convey the idea of "parallel command executio=
n",=0A=
since this is the main point of the interface. prange ? cdm_range ? req_ran=
ge ?=0A=
=0A=
Naming is really hard...=0A=
=0A=
> Jens: Feel free to add my Acked-by: to the sd pieces. My SCSI discovery=
=0A=
> rework won't make 5.15.=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
