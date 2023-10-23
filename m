Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C941C001E0
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 10:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjJWKCz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 06:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjJWKCx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 06:02:53 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D64E6
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 03:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1698055371; x=1729591371;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZDCi/CUSpBo42dWy4EqJoIqwA4D4r8staM8/3BvVaDs=;
  b=IO2cTekN/kVdgqF0N9I8tuggsh0JqBKfhK93uiihRnmQZdWr8EDJEa+L
   iaU2Nfjczi1IW56p09EIWCLBHi9QL18uQR8pYqBAM5xkUnL5Zk2cePj+w
   Qx2CWiQoIJotFVdCZO7SsrGtg38+gQmkY+8Ah1oJOkmtegjB2zm4QbRnM
   SHwEK19slNEwXFwtyG5Tv/spE8x4vScap5xOVopbvqwuizyI6mJw61OYS
   pK8/HofhG+ScakHlZGEa2IIJhnSGcJxClt+SumhfuTVP5v80LRfqC+ntV
   I/pavFP/TwEWoJ4xXkBjEngGEOgDZjxH42+067jAd18McC1bdgcJwpZK0
   g==;
X-CSE-ConnectionGUID: FQ6126fGQ1OxfdMIbswiWw==
X-CSE-MsgGUID: 3vJKir2ISyiKuWg/gu7hdg==
X-IronPort-AV: E=Sophos;i="6.03,244,1694707200"; 
   d="scan'208";a="368123"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 23 Oct 2023 18:02:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VhJThuyTutsBMC+AGY/W+zWB2kTTgA6xSpLNzXZmg4HTYXwd1seqY3bXx/cyxHrwo/sL18u/A5UXjvv4CtLO9b0mhu82cwBarYkkJlEyvYUX+nYz8WEWTGReg089yQ9xTeIk27MLQ1sWYx/XGCi7q5iRGagLfTVRHXKNZ0hHDYewPHXBPKrfqL1AFwfylI8ky4lrS+Awxl1/hllMxvjazRRqjLC+4Iau4tP2hDpB7yk5AlcH/X1pA1l7Mlnbq/q5C4wFh2paz9FUeZV2zzrE3vnnt6O8H/bI1ganhZQr7jK6oT6HT58C6VxihtAxM8IRU4wmS4guSbDBX3tWf+6eWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZDCi/CUSpBo42dWy4EqJoIqwA4D4r8staM8/3BvVaDs=;
 b=df7pDetl7H0/X+mGw3gVRaIO+/9Fk0H5ZEng/QTPO6N2wzUdJu+nKZn9sU5GagvxLtcx9rWjRd2EreP/GNrjw0p19nGrZt61IwasRenn+8i4GjzMNa7xwG0Tm9lcilGKZDS+RwEYIMF48pr/ilgtz1vXbsqYQa7KABEfdDRRVuL9lYBAbnfS0d98xOXKuB/ig3YbheL4E4Wt7Wde/hxoXe99Gfi03+Z+h+VNrFxgU+jkTJbbkNGzQ7EOuVYRXAWWZnOskTnhNpu0CRjuTzt8WmNIdPHQYo96vrgYTre0reQp+c1D65E5A8W5xZGkeUqFIf31SCQy7hZtTAkTaMj97A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZDCi/CUSpBo42dWy4EqJoIqwA4D4r8staM8/3BvVaDs=;
 b=G8Ym8IaBXG822nC4ok7emj8qzM+yn4eQ17vpT/aaQ5tUiKoV3mfghWS021MUcNl49pdpYI687FYjsvY6RPhkMmUmRDWTwVBeQrmrFId68cNJozOUsX8m6HN9/qlfeSZZd32xGDH79+QMVmhYIVVmQPYrFcd/hrCDJCJBZx5j6Lg=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by PH0PR04MB7334.namprd04.prod.outlook.com (2603:10b6:510:b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Mon, 23 Oct
 2023 10:02:46 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::6fb5:ecb:1ea0:3b1d]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::6fb5:ecb:1ea0:3b1d%6]) with mapi id 15.20.6907.032; Mon, 23 Oct 2023
 10:02:45 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kees Cook <keescook@chromium.org>, James Seo <james@equiv.tech>
Subject: Re: mpt3sas ubsan issues
Thread-Topic: mpt3sas ubsan issues
Thread-Index: AQHaBZgR/QK09waQ8EGtk0TU7dcOXQ==
Date:   Mon, 23 Oct 2023 10:02:45 +0000
Message-ID: <ZTZEw0NwY28foZPP@x1-carbon>
References: <20231023082958.GAZTYvBlIB2UPUCUyA@fat_crate.local>
In-Reply-To: <20231023082958.GAZTYvBlIB2UPUCUyA@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|PH0PR04MB7334:EE_
x-ms-office365-filtering-correlation-id: 3e77ae9a-5a24-40cb-d1f7-08dbd3af348b
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oaQ1w2qHvWG7FB0xgTUR1VuufYQKDB18qCRVzZMSXL/BipuDMkLXlbkhlHUSyJ6oAtfezmfw5xtO1AFZUxKwiEldoBOIz14oqm8T+gaDUS44TvfsH3GRv2RFqJBkE/v8E8gyz/w8LPkI0C/5Awvavj1ai+R+iIt/Ua+71AnMtNKSYTfwtMTWhYNbupFzs75dJFdBopYXg5RmcTYQMZ/r+PHeTxQRmLGTOieAnMP9OgPBwsGvdBpEQjuFyB+Xoah4GngGebvjonrcvCI1fSCXqOAYIwzLE/XF7jsgI+DcVemcFr/IxbT1UURr4gLyV8K7IcyL+NSfghK1emNemVTRwsFCkHh5aZrkO/GOEVrcrj1DHRzaa5j0bT27+JXsh4EVdYbuPWeg2eoy1iSNGpCXvX347eBFCEiBw2+hm4ILqPJWoMn4zaS83hhsDCHR9VKS/bDttzI/qKODaVsvC9oBwAOHDz8tFrqkn41DpBCGpHCyeeWe36IyAQFBr8lpqvKfz5SPsSzLBzJq3rNHGWzQ+wK+iRarR0PNbHon164Bd9NtgJR8jnwdsVFh7Ym6nOuWR5pOZ0nmG/N7791lmfh1EBefkWLuKyjN68QkbZlK6UYaxlDdYjR6oxDk1anujCIskm8XImHTcEcQNHBpR1qa3I4keTEozgtW3gqyJ5ap9QY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(396003)(366004)(136003)(39860400002)(346002)(376002)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(76116006)(91956017)(86362001)(66476007)(64756008)(54906003)(66446008)(66946007)(66556008)(41300700001)(5660300002)(6916009)(6506007)(316002)(9686003)(966005)(6512007)(478600001)(6486002)(8936002)(4326008)(7116003)(8676002)(2906002)(7416002)(4744005)(71200400001)(122000001)(38100700002)(26005)(82960400001)(33716001)(38070700009)(42413004)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jdqusEQH63YPspW3nPtccKisXGBPUsJyNtaJEQfseIbr5dz8++BgPyblfhtX?=
 =?us-ascii?Q?qHYDkO5Ku0RbJ5i2oHD03ODnv3sw57IY/SrPWI6gun29tczcV5yaKtxFUs+f?=
 =?us-ascii?Q?OCBhJF+ZjSOFlCL/EiKTr43C+0aEzLPX5ZmPrUwsFSCpCGGq2sPNYdvCPtQo?=
 =?us-ascii?Q?sYeG3iJ08FJrKAGPr8Li/ndnotoL66TxRfenwTtkLRpbOg5zVUw+CtHCJhQI?=
 =?us-ascii?Q?JK8FyI/2lI6vwy0KsAf7wQJ3OJcVG6wlBhWIuF87cz9MTjD3ke5MhjIbQHLV?=
 =?us-ascii?Q?EV8f0YJjMsAmb05bpLfYWPSQICaVajZL3qlEpp71WeskKp5L1cZwNKm+jCtf?=
 =?us-ascii?Q?LpYJbLG4e08OVYa3dF+nrFqsWu4mbcyBouqqY0+SlvpZ1flaZlQpxnKwZgKf?=
 =?us-ascii?Q?66bMDzRZltXNNgTZnqz1Ys2yuBSZuIgHZcHsBaiGLnoBuB3mIJtjvSmgHHCe?=
 =?us-ascii?Q?lHKKmGMTfbc33xlQnOQkTnPy2Y6O7fX/2teazdre0dhwgQmu+mMzfxhB7Wih?=
 =?us-ascii?Q?i/mSl2+bbqsNu1GueFa/0eL3HRblGOTXorCkm2y3yiQcpNJdNFYa9qj3hosN?=
 =?us-ascii?Q?V7P9tZEq3q0oqJkmkoCR6vGMSqDHQeEd0d9Sxo58azGEd94PaQWOfBPoSfdM?=
 =?us-ascii?Q?WeJe1+ptWV6uv+JyBgGzSyrrYwQRpsP1oywm52OxZVMeuXOE2F2I8gx+czuH?=
 =?us-ascii?Q?qv/Re13BvAZCO2n56BuzSVum1u4R38El3WTfNblSRckp6Tu9ZMCI5Ih18bWc?=
 =?us-ascii?Q?5sSMLVlr+vk/UlwKd975o8vS+MCMqSB6NiJ3PyhH4Ec2bjpOdHiF6O7ssaIs?=
 =?us-ascii?Q?FjvjaZChs02qjLGSpfPM2vsxXtw/VExRJV9CQcUbh83cjwEzBbj5WOgg9TKX?=
 =?us-ascii?Q?ovdgLzjyYbt1sGKlEWyYogsPkYTuk7xyNzDonpnMg6FC/+U9oHLmtcufEnHf?=
 =?us-ascii?Q?vtoT62Sy93If6wC5/YgRTCBH65L9UVo9I+GN2XOLhDpPvGVyXEIkGa5R1OjC?=
 =?us-ascii?Q?YEufvM303e48jjCEZNuo7OknJ5VnG97JLV0ew48mnKVMCo9PTgTXOUfly5Ez?=
 =?us-ascii?Q?jzutggjc4rRqXQ29n8NRLp29W/CdbPDgCxcAS/IhL/UxY6tVXrN+B9OeULrU?=
 =?us-ascii?Q?lVGiT45A6isYO6VDxewNFZ9RmSWYLetuWx7cg4SHmQcvmgzUtHSw07cZqiFr?=
 =?us-ascii?Q?r6k2/d7sZstjyzLjjS0Jd84NPnVJol7MU42ytnkprxLo/L57jZdXhNCzb9gD?=
 =?us-ascii?Q?6wkC9JdkRPrGs5Y9JDzrR/RNR+oecLRyg/8OR+gUA/bE6ffdUNW6GFZlNthm?=
 =?us-ascii?Q?NJbgObcEkdP1KPbyI4cmohp7cNRZA3UnT1QKox8HMYgMBkRs4weQ5OhfvZag?=
 =?us-ascii?Q?v20s0K1yRr9ruJO2iTI9hDr39rCCJ7ls3RSWMeidI/C2El9GH43D9wsW0PXv?=
 =?us-ascii?Q?QWZbY1LWAbH+jU1BYW+xfno32eP7fOkBWN9Eys4YjYccY4FwbkHaWi/WOasm?=
 =?us-ascii?Q?boTNqIa20UBsbWPl8TtWzazzaRNIeycGiXIJ7+pnMEg8TmhuWRiVGCSpsGa1?=
 =?us-ascii?Q?3Pul713gelAY1SnQWvfFMgg+qcpz8fGxOedM8tecKLdtkl8J17TH+yfwM5II?=
 =?us-ascii?Q?Hw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0C8686988BFD7B41B328E1C67657E015@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?Y3YQUbhBVPG43zELEXdAsFQZYjLQxiGgdxYehh/e/sjPDltdM+7lAMRctqiT?=
 =?us-ascii?Q?slWlz9RVCSZRHeZ/oGn8RZWWYRM62Zvzczfs3SlrEte7MWeKKNCTglRybSIX?=
 =?us-ascii?Q?Z4Dsn0HTOysDivNAkXLd5xX6STfgkd4uNvyP6evK//+DumpsstAaQ0RwxjVX?=
 =?us-ascii?Q?K89RnyXCyvXr2rS5jutoA/In+y3ci0qOr5JvaB04Fs8Jq81CQ+H1+NmIOcnf?=
 =?us-ascii?Q?2kkukAs18SYDaTKUBVrBjQHIDGMy2qjN7U0w8gvh8ooiWs2GYoIsbsNpurOY?=
 =?us-ascii?Q?iJEhNUmaVVwKqVoxBUz56LhnkqLkNdq7Z21pLeons+O+z7LwxbhGhIHtq96L?=
 =?us-ascii?Q?N1yrB8UCta4hKuq7IgtdEtvg4+eN1ZmTzJy0wuFGZWRb+Iy9gFASfAYMkDx+?=
 =?us-ascii?Q?0N9EtHKgZW8zAjVSIFFNiauyigz2BCcQAH/RojDvUEdCt9he65FHVZI1ZscU?=
 =?us-ascii?Q?CvVcjKWR65Hhjm2TcWa0SFLNGPh10RptatmG6euX7hlakEmh+eA1QoFmKDNx?=
 =?us-ascii?Q?B6OidrZ3vsfw8fxcO5caATme4e+6EYMynVNYvpvoogGJWr7zTnWPGXLZNvaC?=
 =?us-ascii?Q?zxxvBgSpWrUnZq+AWJSqjiHBzWshhbsC5KclPk42x+QGT1NyijbIJIi7cA83?=
 =?us-ascii?Q?0/C4KFrZBnTGS4aRO6VVCR6tiFTn22zXgm9YdgdRZjbF9mlBsScUNjFygLRM?=
 =?us-ascii?Q?uwQcx5ItFfj+wWCXRsBBwHG4gWQfoK/lauvR7Y0dqRXMrBHzqAFDUQla+Zjq?=
 =?us-ascii?Q?6Jl8Eb863WvFen3Myx0WLfeKmBGplfVyEHpCMJeyqf58OlPSHD9AiN6/hO0Y?=
 =?us-ascii?Q?IvJMTWbz05ApY8nKWldJ7CM6KNggNupJlo+jEjN7WI+ly/Kodj1x+9XLmy2D?=
 =?us-ascii?Q?uKUUmJQ5h9ToEu6pK9k0F0ELkehVN/qff+/GbzgQf92xDXuRibFlol5oWl8+?=
 =?us-ascii?Q?0T/uPN1/Mek9zA+clF5vu7GwBTs3awJedRxSDDlaVe4=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e77ae9a-5a24-40cb-d1f7-08dbd3af348b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2023 10:02:45.6907
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NFxA3ujUVw/GPKA96zD/Jd/8KuPDPx6ukrGwniXtKUuLy4DrpSzTtpL8HMz9JHe/7xfCBBIQY38hN8JlZ5rWKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7334
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 23, 2023 at 10:29:58AM +0200, Borislav Petkov wrote:
> Hi,
>=20
> I don't know how much I would be able to test patches on this box since
> it runs tests all the time but lemme report it still - someone might
> want to reproduce it on their hw and say, ah, yes, I see it. :)
>=20
> So this is with 6.6.0-rc7. And it floods dmesg with a lot more of those.

Hello Boris,

I think this series might solve your issues:

https://lore.kernel.org/linux-scsi/202310101748.5E39C3A@keescook/T/#t

However, the series hasn't been merged yet.
(Apparently because the mpt3sas maintainers haven't yet acked the series.)


Kind regards,
Niklas=
