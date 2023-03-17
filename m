Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B73A3C6FD1D
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Mar 2023 09:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjCQJYD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Mar 2023 05:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjCQJX6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Mar 2023 05:23:58 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F880B4F43;
        Fri, 17 Mar 2023 02:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1679045032; x=1710581032;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vBtd6v/IzmdEsi8G+1eZhUD3INUBwEeOX+dzpqiLpfU=;
  b=jsoxw1BvSVfdX75PldxjVa9JsJKFWq8bpBMfC2LJwsNAizCq4k3OK/ex
   kbOmOs0Cid4lFg1f+B4rDZgNZJYgn69uuYSlzlbpsHnCntjq28C/t5y05
   hT4oGuEyDJZGITscwUGvLFYhDPkYfAPKXqpyONhMyD1oLgxgtU6Wc38ts
   dujhKlZqEhZM3Z7wWF0/czuqsc65oqBttAg1uKn4bIHsYpaPwJNUpnygf
   JEjottrCwOkJKsZFiEVBrH12NGYEz4A1F/M7c6QM/YrQRM7jnz9ggeTqM
   oGsfMcNg18RQrDrd1rY3vNstrSDqnh3WYxFG048hAfZR3E4/TWRfR1Jl7
   w==;
X-IronPort-AV: E=Sophos;i="5.98,268,1673884800"; 
   d="scan'208";a="230812835"
Received: from mail-dm6nam11lp2176.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.176])
  by ob1.hgst.iphmx.com with ESMTP; 17 Mar 2023 17:23:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXUe7W760vIKYfe5ZZlFJOc1JmRFLVBGmLXao3bAouSogo3dDcZbT2FiqxQeeF5gfdd6Kti7xcex9YCNe53ObCGKH6yAXaxVQtNBQGAhKhg/hX+De6K5NSWhKs6x68lzOeUaiNNWX90yorlJbxaJTWXW7IQm/fk7uomoCK0zG/yjWyqjmm9TxHkVghVwJVPB3TF1JHcaFtoTS4Em8DbFaqnliLdyzy0DW+YMjESqoemh16QZUxiS9BXQCcKFImUOlEn86S83qeCgYkVDbhFzB//wS3kaTM4ikEbJd26/+KnM6hAAMpNeVr2KUZnXX+5xkAFOYV3vrDFMhHQZxqMNew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vBtd6v/IzmdEsi8G+1eZhUD3INUBwEeOX+dzpqiLpfU=;
 b=kU4QMrMA9qeqGuD8zzE2dL1RZ4hW3kgzKrh9wnw6FCB9PlWMM/nnzbTFOwJECVDf1c7GSRPN8qgdsTrsvC3nW5/O3pZ/91Qh4UqLCqCH/odoBso7kJGPwB0nDgv9EKp1bNJmi0IzAyFy+EqRvr6SiX2NfLgs5QpisrdGvd1TfnuVdBSyROdXnvBjkMHwcTV2mZlTZkxiByN50cwtmWVSgBgXD/kATTnTwD+AmJsuXWsDpE+JWuNC9xdZ/oAEBdVJn0gzT9gbc90PJZxXCEUtBEIiaPeSLWWTyftBgsLO6v6RYO5XMZvIQvazauWbTZMhUdRLwKamaJQjAb1bImbzCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vBtd6v/IzmdEsi8G+1eZhUD3INUBwEeOX+dzpqiLpfU=;
 b=LV4hZa1mG/6iC42zEHjZfScWG5XP58EzoOfWWflhtgbCI6So6faIX554pPCTntyQtUpbYViSd6O8B8SFIwmpSiHRcSiF7BqLaWxG1Tu8yHN3SFDyWT5pqNaf+44Mjz1nRspEvZ9VHumZT+aYdrBcO7bwXgjt3PstOwpxnKpU6+8=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by SA2PR04MB7610.namprd04.prod.outlook.com (2603:10b6:806:135::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 09:23:47 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a%7]) with mapi id 15.20.6178.024; Fri, 17 Mar 2023
 09:23:46 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH v4 02/19] block: introduce ioprio hints
Thread-Topic: [PATCH v4 02/19] block: introduce ioprio hints
Thread-Index: AQHZUtHk8t9/qx5VsEKDtKU2R4U+Ha78sIcAgAEXo4CAAPaKgA==
Date:   Fri, 17 Mar 2023 09:23:46 +0000
Message-ID: <ZBQxoRQ4/7au/1ou@x1-carbon>
References: <20230309215516.3800571-1-niklas.cassel@wdc.com>
 <20230309215516.3800571-3-niklas.cassel@wdc.com>
 <c91be70e-14a9-7ad6-ba7c-975a640a34d3@opensource.wdc.com>
 <70b757f9-cc0c-ebd9-a597-f6ea14acbedb@acm.org>
In-Reply-To: <70b757f9-cc0c-ebd9-a597-f6ea14acbedb@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|SA2PR04MB7610:EE_
x-ms-office365-filtering-correlation-id: 42d93017-fa50-4cb9-32b9-08db26c94f3d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vEqVfrCrQl1LPEu9QcSoVaiHd1gsBU/5hI9tYYSx5fbz6oaFBqwPxaqIgN/HXfuwyv81qDXzMRfizp7wGTGbchTPpaKFU8oLZ0axFhG8UfrqxqmaHiNZPQlr8KIEobqju7/1bwJVV8JtNqKdX4VQilUsTHdTuZaWBjeG8s0uwa4R7rl8a4G9Cp3BlMbOhT2Yg564vMcyeVMKSyINAATtHkI8I/BoRd843z3vAnKUjJbUsIEPZF04YIXuHZfHGfpMj5GvZa18cHvXmzCFWHC4f/0FYBdVUYHsql4gdIY5xle5Az494blL45nwPRl0zby9KsjSbQD6bIVzpCYg4J4RAG/JkfuWTzvFA8EcUv82boFfdmxJmlIffJsCgT7wpb1oRSIfFpNrxcOKgyuhxkYwitv+F3kirCmYFjOna2KuK52xUt3jIVNG+6jJoRWc6DTFSh9b1j7Tpo9aMXijHMYmh+fpeoJjNKBKeusL7AM/lfVO3WFaH6jfh/2eqdd9ly0WVg8l7BuIGjjJ06CB88SyLQgb8XUgtwCeQKWmsrffrS+wz4n/tbTdi3W9qzFZKtsignUhlWQ/r8qZnfuj/xwNtC6OJuC9D2gxmq5YB3PCzw09FGFa+X6qIq7Bu6Cxs1h8WrNekNu9u+YAHXUXGZwqVLXRTiNZRjyadiTN+oSPJYlMJ3Zt3vG1dFGcDSo+28oI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(376002)(346002)(39860400002)(136003)(366004)(396003)(451199018)(82960400001)(6512007)(53546011)(66446008)(66556008)(41300700001)(64756008)(33716001)(66476007)(6916009)(4326008)(8676002)(8936002)(6506007)(2906002)(38100700002)(71200400001)(76116006)(86362001)(66946007)(38070700005)(91956017)(478600001)(966005)(6486002)(122000001)(26005)(54906003)(5660300002)(316002)(186003)(83380400001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZxvS9kRMIO/MPIOsCTUUQfOnDRZhDUto6SPEebc/IViVA5KRjWNCk/IN6hRd?=
 =?us-ascii?Q?HzwyMgEEGY+5/MnsPV9uTR1ZlOPdq/k1Lw2Mu3xQ2WoG0DUj4jGGzPvgvygT?=
 =?us-ascii?Q?TRTfEjDsw1lXwsWXMkEJaGmmd9A5uMJSIWrHO3EG8zHMCFyZoOhHNApT31CK?=
 =?us-ascii?Q?4zmmg4DrmqWIFwG+GE0NkzAz6Dc7bCUFyAjRP139n/FWcKMf7Hr0AtjgDgGO?=
 =?us-ascii?Q?gkMOoA8gCojgYiC9orcLeMLj74ECRTWjNS4EldSI4DNr/MFJ4C6yQbO7wxX0?=
 =?us-ascii?Q?XoA4KXXKofXrd1Bn34Jz943Msni2ErTga0LsND2e3H77JQlImKnkN6KfnGxV?=
 =?us-ascii?Q?Dk1Bc2xzcdyc1bLlIgOMDZ+h/cQ/8hPHqC4ZcB3rfvPr97T6lqen1i+45iV/?=
 =?us-ascii?Q?3bpsZUGMecBEh7dPDlJM4E0uijH3727AqDT1IWYRFYKVA+i+xvCvJVmkRe0Q?=
 =?us-ascii?Q?ngZIOzv/FlEn0U/wwLdVYHOGk6M+hsNLTWpAXNZVyi1zfHDDY22RmFVL+LrO?=
 =?us-ascii?Q?iaMC/En8rUFEc2e1CHyoxNPaw1F7JUnitujuJdqt2UUBezE3UaL4DzDBrRIE?=
 =?us-ascii?Q?BSk5zBGllEcPy327aakuvpmCzDJ2TqjLbCC7/S93ig7a8AQg218kYpQfJljh?=
 =?us-ascii?Q?5CacEkVPYdIMHb4lku20TH4KeFXAT1XL1FLCMAcQBzPfP93D4PYuCIsMrj5m?=
 =?us-ascii?Q?mY6XaeW8u0+2X/M/BUoCqgNq7Zh/Xk8Z+gtFC3htR7UCUaGgd99BZlDg8fnh?=
 =?us-ascii?Q?emADvfz+nAJx1iVXQOjIpXFz5vIEvVejasmht/Ss7vfoUdApg4CW2kGmpApU?=
 =?us-ascii?Q?9Xl2tIhJVWJ12EU+ssGC3OYQDfRmYnzCnQNaVGOLgzk4zcqiZ0H9eRJ8YwLt?=
 =?us-ascii?Q?JEXtkgIGLeyojZcXcOZD93bz601Cs0VOFobySCvEqvmwa9Qj8X6MNcY62MYg?=
 =?us-ascii?Q?8zNfSIOkYRFMcT8AqlbmrVSCvUsEEeMymzy44LwXaBf2I2xMC8hjmuHF0b8i?=
 =?us-ascii?Q?zKL2EEraAvwhZC0QjDqH/YLrsWH+sMNrV1wX433VDz2c37YDvenFcrvR7EAT?=
 =?us-ascii?Q?6nPiQJe0k8fzMPz+9od3dwDZfvcqugZaDjF0GHehMfhKgGtQI797Yx+BstJ+?=
 =?us-ascii?Q?hNyvTUqnxNv0vy/uMd96VXrk6EAMLBa4mlvTAJLpx70bQ9qTmyULDnrGumZd?=
 =?us-ascii?Q?jW2T+DgPggvjcYEkGdUGokFTgDNlnx6RS2vpFLNpgx5TTexmbSaRZk3QoV1r?=
 =?us-ascii?Q?jSkODoR42mtPoidouYMZ0tZ8jQrKk1OJw60QWPhHvPYEYgAfoK4NpsvhLc+Q?=
 =?us-ascii?Q?BIDXcuWKm9sOIQ1OfWD868j2uPRM83Hq7nTEA9HQ/RZEAxIombkJJu/Luy4K?=
 =?us-ascii?Q?RxslpRqk0GaEZGsv9ihdu/xGcEi42eqkvNOTaWWrZVdD6Yb2Ni1nBpWeoevh?=
 =?us-ascii?Q?EdBN+FT9aWzatmuvcpVkXYoULFH3jXey3HyfrgDhzIJQrlcs+IeMWU/ZBNCH?=
 =?us-ascii?Q?PUirCEOqIYMyS9f+dt0hLtvqFjhcz0t+wvJp943Mc97KRaxKkH9XvLRZDyEE?=
 =?us-ascii?Q?zGJTNF3JAGEjtLbOTlDKxmUtCXfgVw4V4Z7uPmgFaDXJIOBuneSAcCu1kqki?=
 =?us-ascii?Q?xg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7198548641CC39458AB70AACEEE7904C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: U/1FYpWxVeWCZWzLkCruJsnPTYLZijXgXHhk5riKjNAm7yzkuSCq3ryDwdRLlFDcETrPD+EJkDGHBC4JssAAuA2mMwYhYGAe6cpuFKipYGrQgv2zv9q7/HMfq1wQ0mC1qPlfxTxtLcvO3wyws7lMsmht+Jg1E03LSbu4p+zgjgd6EAgJIuwidpMXPtYzDB2/UAaYJYNar8gWSmzSXuItTGaEe4eHbFZmQwqh9whvb9dwcvvmEhr5gXaPa6XEB08gBCDLTkxOv5ca0p9OCAjBbLt8FxuMxoO9CbvaFn6YCseblr2WEDFiGlkLedUe7s4TVGa4vXwMt+DmSTHdzvoiP/j+1DIcocVc9toy3YW38ZVaCADj8V/FiY4SlTZ9fCl7GnDhBVTKhd8qemq9v98Ejm5WmCYlO0xBv5gr4Rk7Rl0bwHdPswlJNz5EWGOYjGIvletab5f9bsq4TZIjYJrBbSZs8sKq6PbfVy95mFk+7sP/FCAc23HiV4vEmJ+TtQhr7vGj507RtMAihs0vKm2Me9Db6f+WwAygbLnfAxkg1B4xDFKFNRoy19hUf7WbYP8SMX71vuAhqZqcatubwvqNhnlQxF0iKOfdGLAMnl37+cxUO7KigZ51f2+8hZDrFPZ8sys/wDykx1FnzyNbJ4FcCBPyU7MwS6vx6DBeH3gPqIxwjYd6PEu4eYi8shaG8afXF5Pmlt2YIwig3K1E7ontxUk+vsa9aqgG86on+NCV1/DBVAVri7Vt3PiNGHmyNAXQ6tGBuSRWP+CXT57TzGHAyax2Id0bDXk4Ic0MjFhT5OV7ss0n9v6gySl3seqmpOM9/ReoDvyHDtAdhrVoOi6wWTbV57OOMFFeoXArPPIdjv5nVxQKSQnkVHi4JZcJ3MrMDg7viduiLw+jegTwv8Sbqg==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42d93017-fa50-4cb9-32b9-08db26c94f3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 09:23:46.2593
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CgQ/L+5YHN++FFXEPO9nW7fj2EoQE5RKoSTly0jkXfll9RdzGg2Q3DJBap+erpLTNXq49nMZH7SPzSnBoOfgDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7610
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Bart,

On Thu, Mar 16, 2023 at 11:41:21AM -0700, Bart Van Assche wrote:
> On 3/15/23 19:00, Damien Le Moal wrote:
> > Bart,
> >=20
> > I would like to hear your opinion as well.
>=20
> Isn't sending a ping after only three days a bit soon for such a large
> patch?

While I was never really any good at math, I'm quite sure that 16-9=3D7 :)

Which is the recommended (minimum) time to wait before you ping someone:
https://www.kernel.org/doc/html/latest/process/submitting-patches.html#don-=
t-get-discouraged-or-impatient


>=20
> Regarding your question: I like the block/ioprio.c changes in this versio=
n
> of this patch series much better than the changes in the previous version=
 of
> this patch series.
>=20
> No objections from my side about the changes in this patch (02/19).

You are one of the main people who didn't fancy the old user facing API.
I think that you (and Martin) gave some really good points, we listened
and came up with a new user facing API.

When you have the time, we would be very grateful if you could provide
a more thorough review, i.e. provide a R-b tag or give some feedback.

Your help is appreciated!


Kind regards,
Niklas=
