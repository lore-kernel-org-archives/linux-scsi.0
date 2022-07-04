Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD148C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 13:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbiGDNe3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 09:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbiGDNcA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 09:32:00 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5461168;
        Mon,  4 Jul 2022 06:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656941309; x=1688477309;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=VJgrhlvy1NA+rALy3C+1FXQ4IWjAoTPOQjLXboV7T9GAWT5xl50EhcC/
   oDKaPYI9HzCQIHWW2idJqXeZQaEahaGup3RlIWt2+if4/BKlvpMxpJd4a
   m58W28nY6jIfOyDnIgyN1Mnqp7nQ9TpC31JmvE6d6Pvz6RfwLdCuzw3wQ
   +DXOuUh967Xluqm2JvETRDgSc5kU8LPZmTkEFUbPy4GRSjmVq5ef1CVZ8
   I067uMp0oKtQzOuSw67JyzhMtmP68fYRkoNkabfWFJwWpHdZUai26Wth9
   KatJNCTrtlu1S0LfH+I390dlGCSM38ZjPDMAuuLR6MQNIgx2ojK5Ud01A
   w==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; 
   d="scan'208";a="204767565"
Received: from mail-mw2nam12lp2046.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.46])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:28:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QcJJhqmksfK78J7zw00mFH/R7+CWBjHDsglKO+l7xh2B79e+oNdvq3Np5hbvsVb13NBT8j4i9RYKdL5Eqrlx64RJvm/bqJ6Muk+yhM2MJAxzbqqUgEISwQs1T5NlkrR+SOl18KkgxFY4hA5aKg8wSOSrYzVvQ+QjvyQ/pHD0Uo26vQrzzE2DmCyHi5IiuTCEucyqsh43uT2VXPmL44r3UIehUkPbyn2IN0eQFjg+vVX7hcnfpy/+eFZB1NjZzqHZPabIkhdwI1jCpJzdYsH3ZbhsGK1d6LPvL2GYWqRLSzfJD2RAaLHuJDTVljTOzE0d7Wqw4ZXD7MdIZsvmndTk0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=fVwZ/dyBEoWBVuXLqkpz0qIDM1fc1HCfRrFo9yf8C7q2DczyyLdnfH0yvqf7ZKrNoidFzSEEQ2r5h/MgeFdIG09J6n0EGnOZyyYi1ttY526Pt54hgcQMXPEOg6rEm1Xm7TX57gbwIRc/swzAGVXhNYkOtDScE5nGaIBJN2+tybpi/Rr3hzACMjcTMes5HvzmfM7Tv/wIlt9VNG/3XAVx8wkK1y51NIo38fPghCWPmwy3/Ol7H9Qm0wkF39htwm1uDJ0ZfFvwoKIk4vBjoqBpNHfh9S8aVQ9PG8G9M9ZHT8mGR4tRJVcEtGZUGFAtz6C5nkhNtPXHqMjMV+UscJJVsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=oFp3mcVo12Jf0TfhL9bEqC5yJ1IgvoY1OnxA9B9nBzByLeFRq8I2HUGdNpRchtSU2r7BzDRkCpdjV0ceCBv3K/ih3BLCQl/9SYcFODOlSDH5AAZa2ePg30m4Lmz8MzuMAPo7XET3rnzg8Zfeo+hSx2zVV7yihPNKifawLN9f+vI=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CO2PR04MB2152.namprd04.prod.outlook.com (2603:10b6:102:11::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 13:28:29 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:28:29 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 15/17] dm-zoned: cleanup dmz_fixup_devices
Thread-Topic: [PATCH 15/17] dm-zoned: cleanup dmz_fixup_devices
Thread-Index: AQHYj6QNR57Pa1MQKE+RuFMYfKVMlg==
Date:   Mon, 4 Jul 2022 13:28:29 +0000
Message-ID: <PH0PR04MB741686E3F46025901DDE5F209BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-16-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be0cb1ed-353c-45a6-7624-08da5dc11590
x-ms-traffictypediagnostic: CO2PR04MB2152:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e33nQ3QjIuxVtSAd1qHM9DDwkVmf6XSWKZ4yOEjR09xQStjBb7aq8H7/qbEn+8ZpyTyVDE0fvVf3NBTIVUmLIomMBn9YnX597+trKgfR6wtZq/ASj4fDn8PWdv/rEQDFYT81MatgsD46XOWnt9tuIy2HE6fCcgjJ3AdH/tbslOG8GOy6/fiv4DUN5LJKGIFt4CfY24lCKqjRVCFyNAOfnm5s3aUZytgabgXSijlY2u4ValQn+GN+8dd6MQLMGbevaVDOWrR7CS8leSvCPbhA9cJIZHj/Cn9Ay/lbIA5kv52fgD9PceH8G/ngA+0MhW/rc1N9LSVsEvOjovN+PZGZGZPInvfo9ZEqoISepidjedHopK2TgmX4LWj2QmY9rUnmY8JiQZydc9lHfJYtuORQjUBPq2kJVvWLQpVIU983AapoSTO8G1gB6JwZGBJFHm3RnRrXxUZi4i+2i5/PzvLW/SDhY+qaGV6V3BYywNKMewKPrIwgCY1XKSnjXTYvZkX7zHnp2jJJ9hJPXK4ly371nafxze9OdQRhlPz+xsFafgYALzNp9fiV3Rj3GELmfJshEmjS4X8IuvjOuSOlc4TLmL7MJxE9kSCz/lQGSnBl/Y8t1lUmzbPwTvF9/O7tqkXVi6yNOAvXQ9gca0mkJNrWh1TMEugeLDyjODjgKpSsAG6lJnGlLtHBAqxPyKoVVMHCCeFuHSa7thYQXsQaba/0Iw7XRFxkh/Fc+u2LMAaommsmLqpO+/+r5La7iyNhdahvEmA0jXQoALBid7aRiB6FWX0LkWq1dDHMeZ9LKxZCXJbazMbjSsJ++S0jXIGiSiOR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(55016003)(558084003)(4270600006)(38100700002)(186003)(33656002)(2906002)(19618925003)(66476007)(8676002)(4326008)(66446008)(76116006)(64756008)(54906003)(91956017)(66946007)(66556008)(52536014)(9686003)(5660300002)(8936002)(6506007)(7696005)(110136005)(86362001)(71200400001)(316002)(82960400001)(478600001)(41300700001)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5isNnPWIzrc3mblO8qymwg5g27PFlwnhX6XxtEpU2PYrwEOFuj5ZqF00FAO9?=
 =?us-ascii?Q?4CASnjK7vpXsOqKDQu64EiAROlJO2wnm95Dm66eG53VNvywHonSm6MjpE/os?=
 =?us-ascii?Q?81MXx3daUO7TOf14v/cRqy2dXfh6vu9cKh40VehWh8Zbuc77VPArVD//QLD0?=
 =?us-ascii?Q?7VnX/bPOLruNMED1jB6FpU5UaW5SbOQgASFMSgynb7ohcb6fqSURAaTCXxyt?=
 =?us-ascii?Q?Gokztf5Oop2iuquRkaU4JxqOnxuW5j6WlwnOcOXhR2oPbbSSo22VDyAtT/CM?=
 =?us-ascii?Q?EQPoVK/DyUWLqKMlB2Lrlfy8Vh41D5m0Yf1aCcl+XOEN2eHWUiT9lD5usNrJ?=
 =?us-ascii?Q?Vi2YgFEFj68sfRcC4NbISip4lW73D3nymhXW9RvxAdW5hHe4ISgrzzpDwGEM?=
 =?us-ascii?Q?86AooGoH1GTKehfTmYfwVkARmK8PDhXAHagvWdJVpTRNn6+2QJFAxN1oi7NB?=
 =?us-ascii?Q?Qskn/YSlRE16shWwVyOC1oPxSAvfYQ3wAiTQsWfm+teCTk/4uwUg/cMcG1By?=
 =?us-ascii?Q?0CW4c4ZeuqKn02ItxGt8O8LqQO8n1T1zpeHlhrpDRvOw/CqsbJ2/y5bwNSVK?=
 =?us-ascii?Q?fIP90kne69B0168rLQYfFtsXt2PcHAwuVV2maNo4VtRQHaSmOjPMjXtGbyQA?=
 =?us-ascii?Q?wgJd8wpOee/zOArpoBNABI1AmSdq0OhPNw4RMxEaPe6qLbWTn0EdDSrindt3?=
 =?us-ascii?Q?qb7hkgQN4+6/uHHRxgX3dr1RPAMRAiz7JZgVOdq1QzCxkfuPXvPXXg/5fG5j?=
 =?us-ascii?Q?KeMeyn053RheCvadqzC4GyPLw1xnAj3yLnSwVNrAp4vcp8clU+i4gEARhwEZ?=
 =?us-ascii?Q?gF4QFtlKXkPlPz8xI5XcLvZkC5ALSYbTLGWET2mT/TWOzvv4L4wFQXl/d6qh?=
 =?us-ascii?Q?o2HDEBuiM6X8pxO4UbUd9cQ5d+W2+RXybx2TWbRGFWwg8IiZdCjZirxaKAjl?=
 =?us-ascii?Q?u6rd+rsgls7bTXKAOM5H9Rca6bGVDEPiBIZQJx72UmQqxKdocSvaRYDFhBm0?=
 =?us-ascii?Q?voZNnSdZuolRdb+dN8SJPbqJ7ZXcFmasJAqxFdbbm04WTABYQYQ1r7VGbV5z?=
 =?us-ascii?Q?On7uH9PMJUwT7POEEhRNtjFYOIxVDvDzMb9eXUhn0D8U8B1oKoL3TkdZqLO+?=
 =?us-ascii?Q?626h/VERAB9ywAyTSRjF/XyI4SptzskznFw2VUVF0d9qEt10/xknh8ON6S/G?=
 =?us-ascii?Q?HNYZCov4YDeKFAs7VGCCMwiJH60oYsWbRcCMNVT1tu0uAKAEU1YwNYbniEbk?=
 =?us-ascii?Q?A/To3flpZLAalZEEuRzg5Wt/5opRCcckcNmsc6DljF3OCj1VlimKrR8C0q7Q?=
 =?us-ascii?Q?lPp7W7PFkcuJTYC4AlJHRnn6Iw2vqKyDgCL0WOD/5U5Qjpjv4CdnCAckd/pP?=
 =?us-ascii?Q?gF3lwNezWOPhmCvbL8HdZvIcseI32EFoItD6wM1WFnURWedLRFuYNd1Ek4Q4?=
 =?us-ascii?Q?hbykmlBDKi8SWDo58b9JU+mWax6HMFyiAvFt2oOf+6H+AN9QySFXew1qNtLA?=
 =?us-ascii?Q?4gv9xOR5wnGFy6XELmi3jB2WNXrw3jmWjlVoHHX5FEG0Y/3dhAGhEOBFzs7J?=
 =?us-ascii?Q?COu2zY18fwgrZUGYT/gdVyvlrOSMpAnGdFL8ro6jDEKdLHThc/r297+vBE4s?=
 =?us-ascii?Q?Vd9dctsOOP1A13z3aCmdHI3QoZ8bIsBGSDCl/OfrST19IZ5iy8qVJ5Pz6YJZ?=
 =?us-ascii?Q?Xu1/V4jyI9qNP3UOQ0ti0PqJqik=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be0cb1ed-353c-45a6-7624-08da5dc11590
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:28:29.7893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YUcTI4UFIhI2bb2YwyiZdZLpEHbUW8I1Ff5yNUpgOVZ8jUo7LBrberdSzZo9qFQnPwUvYJfe2akrrJokJKDWy8H3wKwep2rgYaK3m7Yi8ZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR04MB2152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
