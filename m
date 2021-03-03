Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CF7CC43381
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31AE064F38
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355751AbhCDAd1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:33:27 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:29770 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1575242AbhCCRen (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 12:34:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1614792878; x=1646328878;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version;
  bh=wbg3qQFmSolLr/HKsUwCVk/9+HzgKxejzXF2XWDeSe0=;
  b=JC/FOQHQ92iZ/85gpGtv3Hb78M0wmn20loI2nqssqYaG/JEsM1z0CkLX
   QOJAGiybprMt9FfP7nQOKoR6WeL+tq1PPhzgSWGQQj+s712KhIKnLt0lw
   pp2PtkQUxhqK9rnWha/Lu2K0cm1+h6KzNHzNUfBwAd/BbYOn2w4nS/Ym+
   llXjotfVOcNj/RAQtxYI26B38w+Khq8ssJaep4Gk78yQpUVJRV7mBgL40
   piNvP4T0GWV5dcgD10JLy25Gjp5BHDGOMEJVCShG75PRzxM3+rtZWoZwg
   UYiFN4xybWhofc/vT5r7rALYHU8ZP9nt8MtmXjXVv3GCKsvx8gc66uApI
   w==;
IronPort-SDR: yg7mAFe7KVV4qCCsTzO/+tQ9vZC7cLhJAkyqfbhA+NMrm16hYBzWUKTyKYZn6UYRy4r4n1TOyf
 ST8mR0m2r8zXdDGJ5/Rwy8YrYNp4CUAxysQCxKuvPuokdNxpAW8VcKBziiCuhXz50pFw39YlM5
 3RHBDHUvJDnfvyt1l4uAtiS7u25UNDewc1GX9udXXTUoJERGq8k84B0OWaJ/zTq+D9bKl+P6NT
 DdkqgSXJdJJM4vHG+Jw5BkQbdHq5Qdqw57nP3tmstHvL1/xojYsfjL23yGnROtBKN+GusFJ1Ks
 wVU=
X-IronPort-AV: E=Sophos;i="5.81,220,1610434800"; 
   d="scan'208";a="111823294"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Mar 2021 10:33:18 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 3 Mar 2021 10:33:17 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2 via Frontend
 Transport; Wed, 3 Mar 2021 10:33:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oQJdqHrUlLTtQ01uRS31OVHpdwW9F53/Iw59U0qe64UGoZN6VwfAOQYSKgP/k/uVu2psfs7URpG5QhjzaOKKlMju0CDLcOIKTDNtlrnSNAn4cMDFUnCXHehf5N612TywgJdAy8+5uTZGdkoWdcXRSttri27CQiIVCROOUPh+tuqNg2F9hRxhXN82+K0p6FSJpZYlJeCyPxcu/dQTwUoZwFKMBx+ZvNk+QCo29HuJoWVHAhlrRG7ogUYe+55FZVcsKiyda9Uro1Xbe9ld3U2YJ7/B6FTavlqvGv6Y72VI6JR6TAqjbiiQDqMUeFvDsgPRslmVASGVqVlmhHd7JgzZ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqbATchxMzB3aFA8ugCdanuKfq+u/MA/cBZMZ4/B1bs=;
 b=XKvD7NROTcHBOu04IIRfDYEd6U6K+Q5slf6mV8g13pWLvtT5k+T/+46TiscKTgQ5zv2P22++VLqjhwG98rr1ZDhu9t2UA8ttUShNJ52jBcYEVlICONpux08oAXuvBfOjM2ImYDu94qlcVRoedHN9Rd1ayr2w0nR8QxOHMTAUBFmPQ3oCW7mIJnKemhbJWPXD/E1xiabwFBepqEiotjMKMb9cpA6KUBuHxzzGJ3d9xaA9LuD9Xte4q/LEqFNp7ChKkQdg3lQ9N+GnrpMbkeraUU1YTCVIgtuVlVeBs651NVB0pp3wi36hzVc4vv3LEDfTARZ6FkDZjSDjR+lB0JFvxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqbATchxMzB3aFA8ugCdanuKfq+u/MA/cBZMZ4/B1bs=;
 b=mXC3OgYy33tC2mTadad9BVeGXCbA4r0gCmkfhIidvv2R2paeCJMFIKTUog8xiTVFs8k7j1Wv/6kpw3CEYsrbx9ms43ILlnK9UQl3RFS5ICxq80UZWJO6bXLmJ/QW86dQ7sc7kBQVgwgzyz9mF5j9xbudWqT+b3m79pVJXCFBZac=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB3520.namprd11.prod.outlook.com (2603:10b6:805:cf::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Wed, 3 Mar
 2021 17:33:13 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3912.017; Wed, 3 Mar 2021
 17:33:13 +0000
From:   <Don.Brace@microchip.com>
To:     <slyich@gmail.com>, <glaubitz@physik.fu-berlin.de>,
        <storagedev@microchip.com>, <linux-scsi@vger.kernel.org>
CC:     <linux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jszczype@redhat.com>, <Scott.Benesh@microchip.com>,
        <Scott.Teel@microchip.com>, <thenzl@redhat.com>,
        <martin.petersen@oracle.com>
Subject: RE: [bisected] 5.12-rc1 hpsa regression: "scsi: hpsa: Correct dev
 cmds outstanding for retried cmds" breaks hpsa P600
Thread-Topic: [bisected] 5.12-rc1 hpsa regression: "scsi: hpsa: Correct dev
 cmds outstanding for retried cmds" breaks hpsa P600
Thread-Index: AQHXD8NYByGFLRaE+E6Jw8YXZ2Cxsqpx9mmAgAB7hnA=
Date:   Wed, 3 Mar 2021 17:33:13 +0000
Message-ID: <SN6PR11MB284885A5751845EEA290BFCFE1989@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20210222230519.73f3e239@sf>
        <cc658b61-530e-90bf-3858-36cc60468a24@kernel.dk>
        <8decdd2e-a380-9951-3ebb-2bc3e48aa1c3@physik.fu-berlin.de>
        <20210223083507.43b5a6dd@sf>
        <51cbf584-07ef-1e62-7a3b-81494a04faa6@physik.fu-berlin.de>
        <9441757f-d4bc-a5b5-5fb0-967c9aaca693@physik.fu-berlin.de>
        <20210223192743.0198d4a9@sf>    <20210302222630.5056f243@sf>
        <25dfced0-88b2-b5b3-f1b6-8b8a9931bf90@physik.fu-berlin.de>
        <20210303002236.2f4ec01f@sf> <20210303085533.505b1590@sf>
In-Reply-To: <20210303085533.505b1590@sf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 326d3f17-72e3-4aa8-882c-08d8de6a6c3a
x-ms-traffictypediagnostic: SN6PR11MB3520:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB35205FE84A9F1DA8B07FF696E1989@SN6PR11MB3520.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +H4N4o6RNwX5DF3anbFIMhhD+YuwA24gUWvR1BBUPuUXfNqAWBGfbSEWrTY+zArapK2F4LyavOxmcILYiXTqA6O3DraGqGxxDGQfZKDbAZ0m0mAXND/MOy4VrTLb7ApYbdcvKgaQfRpeFLIq8Ks8XGbXhVfdrcPvz35Jy1WCot4Cnx5Y69qMvQ6kUY+Ao3ZFyli20ZjsVxljPkYfkpbDsVeiRNpHZHQ2DNLWDr7SEW1PsRIjeExR1Rvw5PxBrp1NKYTXI03QGyn21hXP/KQUGqEw+m1R2L5jLMBKzIQwTLxuQfO/4zkvYiaAq7HTCRNr3+oVygC+Xai49ERUwcWOEzOvYyRY2wlr5Z/9qUNSFsToDGeU6hnrFigxjHoka6PG8PQwlFuhfMLy3Q5hzs7ruBvV1xwUKjn4rEAhFKw/pC75n0gQRuJu3wRBqkC+6PmKtlU0JI7VGvmPJAtmf3usO+C6w5ivwoP4fGbkcetwAQ0ux9uuTOfQyt8eOgE4Y7XXnj4zUgaEioeC7LR7N9P9NhFitlQWuCMmd/3hPX/Xjsw6OpYVa53psASrvngBY7bJiXeZ3n0Y0Rws1BXUZF6hHidMR6yW5Ab5YXBCKtr0VK4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(39860400002)(136003)(346002)(478600001)(316002)(66616009)(33656002)(66476007)(64756008)(186003)(7696005)(71200400001)(2906002)(55016002)(66946007)(66556008)(9686003)(76116006)(86362001)(4326008)(53546011)(6506007)(8676002)(26005)(54906003)(8936002)(66446008)(966005)(110136005)(52536014)(99936003)(5660300002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?VWde3jT7ZXczNp+15qcbM6v4SQ08BrDDQ9GNmFDx0e1nJPXKOgdsbk9u0aQP?=
 =?us-ascii?Q?NuALBpsnW5mD0igMmusH5gBQGHXe+t7LzW2bqQ+HcoWgiUp1W6eI+4bwOMTZ?=
 =?us-ascii?Q?SS6jDcF9FwsEw3l6LTEBDFkF+jBigOGC2hRSQOXHWSxF83qg1+eGb/eYRV99?=
 =?us-ascii?Q?o1gTBQDd/X1RDHdPNk8ePfCaKOtZCAysXtah8QfK+PJijDLUOhSLpI21NJjA?=
 =?us-ascii?Q?iWGOBf8Wx7rs6xdhAVEa6veQt1N2A6Dh2aCh126Gk8rmLv9tKIJwUU16EAJJ?=
 =?us-ascii?Q?SGZ1U4Ba39Osqr6pGYgmc7pvpqyi02Wf3sU1rP6yGNOIofQH/3VT9/NHeuIw?=
 =?us-ascii?Q?FEcq3xVxfNyNm0PHTSKBWxR5dozYOTMkBI1EZHXaa+0MQUofW/epURsqPepq?=
 =?us-ascii?Q?mpunEbLVvKgpGEYWYmlmVyfiU1RFKyeC4Bv0rw/qLSjRLZa3inWZUDGyo6Ge?=
 =?us-ascii?Q?1VcGF2FVrR9TJXkTn12G0o0NI0UJOcSFlZrdSaiYvwy9MsTVrEL/5IyWXhkJ?=
 =?us-ascii?Q?r7TcxTH4fuzmsVYi5D6cHzP3uhkm58DWN/LLgwI49Wka777ZYUrh0Bg9l8lb?=
 =?us-ascii?Q?IbY48qERTsyHfPu8KD9ZM498ooBLMNqZzWQ5Xby9Y7ojUVG99zDHuORON8Er?=
 =?us-ascii?Q?EmnNn6kn7sBnTuh9a014HYoXuFiby96JzcUDEClckLwhM5E4R3UhjhGxKtzC?=
 =?us-ascii?Q?0p3pK1k2LZHg8WdqzZo/VLGcwTafvsgUVQKRBhx3Osv8wNDY58wZHNe6Y6J9?=
 =?us-ascii?Q?kr3qpBUOR5n5bC889P/ym1RvJ6XLYEhFP14ynQf3yzkGYjm1dDx3h7RaR/9r?=
 =?us-ascii?Q?Nt/I0/eoqchvGBNEo+MNMNEv8nG7I/qCVHJ+WYHhwv1Xffi7EMEVsMfNWxY0?=
 =?us-ascii?Q?Sf6+2ZiFuWxZHWCyhBPYAMJ+IlqsI1dyp8m/C9SYNtnIxxK6lhenKw8kBFfK?=
 =?us-ascii?Q?jA2hVjcQupO9WTvV3GB+jBb84QfySZPF72fcx789UUb9PHDqMS/FybAZAc++?=
 =?us-ascii?Q?Vxf3fhLjSsO0TUahhn4zx5KuQLzi751NRKJjUi8Z83WvwxksdIrxBnpk+r1r?=
 =?us-ascii?Q?sgT+DaXDgSe2xrUetgqkjXE1jClgmYeWhbPJ5cNAKJDF6WYE2PW38LYU4twv?=
 =?us-ascii?Q?/BUZ6q5EMNykmAxzkGe4xueUkWxIyw3s5sQrhyBUxVD9GQ9dCsqEwFH41J4F?=
 =?us-ascii?Q?CBtWhJMVT0l0pPBzGpmAwh5BWsa2lInfCknVJzZR4ixeegc4y2Y+xYwv/mO5?=
 =?us-ascii?Q?NGRvvOBrBWH8Eqb+C/DGmdZSGu5PFi7+uC1/Uuw9x0IytyNXRhbEfeOGMPE2?=
 =?us-ascii?Q?+c4=3D?=
Content-Type: multipart/mixed;
        boundary="_002_SN6PR11MB284885A5751845EEA290BFCFE1989SN6PR11MB2848namp_"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 326d3f17-72e3-4aa8-882c-08d8de6a6c3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2021 17:33:13.5880
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GTzc3ziuj/y7roVwXRgZCmoKz0MAnExXafNmjZt7rnSMVVgevhQ9ZWzxZO3ovHdOIoBFb5fYsv4vay42BUq30g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3520
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--_002_SN6PR11MB284885A5751845EEA290BFCFE1989SN6PR11MB2848namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

-----Original Message-----
From: Sergei Trofimovich [mailto:slyich@gmail.com]=20
Sent: Wednesday, March 3, 2021 2:56 AM
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>; Don Brace - C=
33706 <Don.Brace@microchip.com>; storagedev <storagedev@microchip.com>; lin=
ux-scsi@vger.kernel.org
Cc: linux-ia64@vger.kernel.org; linux-kernel@vger.kernel.org; Joe Szczypek =
<jszczype@redhat.com>; Scott Benesh - C33703 <Scott.Benesh@microchip.com>; =
Scott Teel - C33730 <Scott.Teel@microchip.com>; Tomas Henzl <thenzl@redhat.=
com>; Martin K. Petersen <martin.petersen@oracle.com>
Subject: Re: [bisected] 5.12-rc1 hpsa regression: "scsi: hpsa: Correct dev =
cmds outstanding for retried cmds" breaks hpsa P600

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

On Wed, 3 Mar 2021 00:22:36 +0000
Sergei Trofimovich <slyich@gmail.com> wrote:

> On Tue, 2 Mar 2021 23:31:32 +0100
> John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de> wrote:
>
> > Hi Sergei!
> >
> > On 3/2/21 11:26 PM, Sergei Trofimovich wrote:
> > > Gave v5.12-rc1 a try today and got a similar boot failure around=20
> > > hpsa queue initialization, but my failure is later:
> > >     https://dev.gentoo.org/~slyfox/configs/guppy-dmesg-5.12-rc1
> > > Maybe I get different error because I flipped on most debugging=20
> > > kernel options :)
> > >
> > > Looks like 'ERROR: Invalid distance value range' while being very=20
> > > scary are harmless. It's just a new spammy way for kernel to=20
> > > report lack of NUMA config on the machine (no SRAT and SLIT ACPI=20
> > > tables).
> > >
> > > At least I get hpsa detected on PCI bus. But I guess it's=20
> > > discovered configuration is very wrong as I get unaligned accesses:
> > >     [   19.811570] kernel unaligned access to 0xe000000105dd8295, ip=
=3D0xa000000100b874d1

Running pahole before the patch:

struct CommandList {
        struct CommandListHeader Header;                 /*     0    20 */
        struct RequestBlock Request;                     /*    20    20 */
        struct ErrDescriptor ErrDesc;                    /*    40    12 */
        struct SGDescriptor SG[32];                      /*    52   512 */
        /* --- cacheline 8 boundary (512 bytes) was 52 bytes ago --- */
        u32                        busaddr;              /*   564     4 */
        struct ErrorInfo *         err_info;             /*   568     8 */
        /* --- cacheline 9 boundary (576 bytes) --- */
        struct ctlr_info *         h;                    /*   576     8 */
        int                        cmd_type;             /*   584     4 */
        long int                   cmdindex;             /*   588     8 */
        struct completion *        waiting;              /*   596     8 */
        struct scsi_cmnd *         scsi_cmd;             /*   604     8 */
        struct work_struct work;                         /*   612    32 */
        /* --- cacheline 10 boundary (640 bytes) was 4 bytes ago --- */
        struct hpsa_scsi_dev_t *   phys_disk;            /*   644     8 */
        int                        abort_pending;        /*   652     4 */
        struct hpsa_scsi_dev_t *   device;               /*   656     8 */
        atomic_t                   refcount;             /*   664     4 */

        /* size: 768, cachelines: 12, members: 16 */
        /* padding: 100 */
} __attribute__((__aligned__(128)));

Pahole after the patch:

struct CommandList {
        struct CommandListHeader Header;                 /*     0    20 */
        struct RequestBlock Request;                     /*    20    20 */
        struct ErrDescriptor ErrDesc;                    /*    40    12 */
        struct SGDescriptor SG[32];                      /*    52   512 */
        /* --- cacheline 8 boundary (512 bytes) was 52 bytes ago --- */
        u32                        busaddr;              /*   564     4 */
        struct ErrorInfo *         err_info;             /*   568     8 */
        /* --- cacheline 9 boundary (576 bytes) --- */
        struct ctlr_info *         h;                    /*   576     8 */
        int                        cmd_type;             /*   584     4 */
        long int                   cmdindex;             /*   588     8 */
        struct completion *        waiting;              /*   596     8 */
        struct scsi_cmnd *         scsi_cmd;             /*   604     8 */
        struct work_struct work;                         /*   612    32 */
        /* --- cacheline 10 boundary (640 bytes) was 4 bytes ago --- */
        struct hpsa_scsi_dev_t *   phys_disk;            /*   644     8 */
        struct hpsa_scsi_dev_t *   device;               /*   652     8 */
        bool                       retry_pending;        /*   660     1 */
        atomic_t                   refcount;             /*   661     4 */

        /* size: 768, cachelines: 12, members: 16 */
        /* padding: 103 */
} __attribute__((__aligned__(128)));

So, I did replace abort_pending field (an int) with retry_pending (bool)
Can I send you a patch to just rename abort_pending to retry_pending using =
the same type and position?
It will mean some minor code changes in the driver...

With the above changes, pahole is the same
struct CommandList {
        struct CommandListHeader Header;                 /*     0    20 */
        struct RequestBlock Request;                     /*    20    20 */
        struct ErrDescriptor ErrDesc;                    /*    40    12 */
        struct SGDescriptor SG[32];                      /*    52   512 */
        /* --- cacheline 8 boundary (512 bytes) was 52 bytes ago --- */
        u32                        busaddr;              /*   564     4 */
        struct ErrorInfo *         err_info;             /*   568     8 */
        /* --- cacheline 9 boundary (576 bytes) --- */
        struct ctlr_info *         h;                    /*   576     8 */
        int                        cmd_type;             /*   584     4 */
        long int                   cmdindex;             /*   588     8 */
        struct completion *        waiting;              /*   596     8 */
        struct scsi_cmnd *         scsi_cmd;             /*   604     8 */
        struct work_struct work;                         /*   612    32 */
        /* --- cacheline 10 boundary (640 bytes) was 4 bytes ago --- */
        struct hpsa_scsi_dev_t *   phys_disk;            /*   644     8 */
        int                        retry_pending;        /*   652     4 */
        struct hpsa_scsi_dev_t *   device;               /*   656     8 */
        atomic_t                   refcount;             /*   664     4 */

        /* size: 768, cachelines: 12, members: 16 */
        /* padding: 100 */
} __attribute__((__aligned__(128)));


> > >
> > > Bisecting now.
> >
> > Sounds good. I guess we should get Jens' fix for the signal=20
> > regression merged as well as your two fixes for strace.
>
> "bisected" (cheated halfway through) and verified that reverting
> f749d8b7a9896bc6e5ffe104cc64345037e0b152 makes rx3600 boot again.
>
> CCing authors who might be able to help us here.
>
> commit f749d8b7a9896bc6e5ffe104cc64345037e0b152
> Author: Don Brace <don.brace@microchip.com>
> Date:   Mon Feb 15 16:26:57 2021 -0600
>
>     scsi: hpsa: Correct dev cmds outstanding for retried cmds
>
>     Prevent incrementing device->commands_outstanding for ioaccel command
>     retries that are driver initiated.  If the command goes through the r=
etry
>     path, the device->commands_outstanding counter has already accounted =
for
>     the number of commands outstanding to the device.  Only commands goin=
g
>     through function hpsa_cmd_resolve_events decrement this counter.
>
>      - ioaccel commands go to either HBA disks or to logical volumes comp=
rised
>        of SSDs.
>
>     The extra increment is causing device resets to hang.
>
>      - Resets wait for all device outstanding commands to complete before
>        returning.
>
>     Replace unused field abort_pending with retry_pending. This is a
>     maintenance driver so these changes have the least impact/risk.
>
>     Link: https://lore.kernel.org/r/161342801747.29388.130454959683081885=
18.stgit@brunhilda
>     Tested-by: Joe Szczypek <jszczype@redhat.com>
>     Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
>     Reviewed-by: Scott Teel <scott.teel@microchip.com>
>     Reviewed-by: Tomas Henzl <thenzl@redhat.com>
>     Signed-off-by: Don Brace <don.brace@microchip.com>
>     Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>
> Don, do you happen to know why this patch caused some controller init=20
> failure for device
>     14:01.0 RAID bus controller: Hewlett-Packard Company Smart Array=20
> P600 ?
>
> Boot failure:=20
> https://dev.gentoo.org/~slyfox/configs/guppy-dmesg-5.12-rc1
> Boot success:=20
> https://dev.gentoo.org/~slyfox/configs/guppy-dmesg-5.12-rc1-good
>
> The difference between the two boots is
> f749d8b7a9896bc6e5ffe104cc64345037e0b152 reverted on top of 5.12-rc1=20
> in -good case.
>
> Looks like hpsa controller fails to initialize in bad case (could be a ra=
ce?).

Also CCing hpsa maintainer mailing lists.

Looking more into the suspect commit
    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3Df749d8b7a9896bc6e5ffe104cc64345037e0b152
it roughly does the:

@@ -448,7 +448,7 @@ struct CommandList {
         */
        struct hpsa_scsi_dev_t *phys_disk;

-       int abort_pending;
+       bool retry_pending;
        struct hpsa_scsi_dev_t *device;
        atomic_t refcount; /* Must be last to avoid memset in hpsa_cmd_init=
() */  } __aligned(COMMANDLIST_ALIGNMENT); ...
@@ -1151,7 +1151,10 @@ static void __enqueue_cmd_and_start_io(struct ctlr_i=
nfo *h,  {
        dial_down_lockup_detection_during_fw_flash(h, c);
        atomic_inc(&h->commands_outstanding);
-       if (c->device)
+       /*
+        * Check to see if the command is being retried.
+        */
+       if (c->device && !c->retry_pending)
                atomic_inc(&c->device->commands_outstanding);

But I don't immediately see anything wrong with it.

--

  Sergei

--_002_SN6PR11MB284885A5751845EEA290BFCFE1989SN6PR11MB2848namp_
Content-Type: application/octet-stream;
	name="hpsa-correct-dev-cmd-outstanding-for-retried-cmds-alignment-update"
Content-Description: hpsa-correct-dev-cmd-outstanding-for-retried-cmds-alignment-update
Content-Disposition: attachment;
	filename="hpsa-correct-dev-cmd-outstanding-for-retried-cmds-alignment-update";
	size=3733; creation-date="Wed, 03 Mar 2021 17:31:38 GMT";
	modification-date="Wed, 03 Mar 2021 17:28:02 GMT"
Content-Transfer-Encoding: base64

Y29tbWl0IGVhMTcyMzA5MmQzNTZkYzRkMTI2Njk0MmFhMTMyMzQwNjc3ZTc0NjAKQXV0aG9yOiBE
b24gQnJhY2UgPGRicmFjZUByZWRoYXQuY29tPgpEYXRlOiAgIFdlZCBNYXIgMyAxMToyMTo1OSAy
MDIxIC0wNjAwCgogICAgaHBzYTogY29ycmVjdCBkZXYgY21kIG91dHN0YW5kaW5nIGZvciByZXRy
aWVkIGNtZHMKICAgIAogICAgUHJldmVudCBpbmNyZW1lbnRpbmcgZGV2aWNlLT5jb21tYW5kc19v
dXRzdGFuZGluZyBmb3IKICAgIHJldHJpZWQgY29tbWFuZHMuCgpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zY3NpL2hwc2EuYyBiL2RyaXZlcnMvc2NzaS9ocHNhLmMKaW5kZXggZjRkMzc0N2NmYTBiLi40
M2M4ZjdlMjVlYjUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2NzaS9ocHNhLmMKKysrIGIvZHJpdmVy
cy9zY3NpL2hwc2EuYwpAQCAtMTE1MSw3ICsxMTUxLDEwIEBAIHN0YXRpYyB2b2lkIF9fZW5xdWV1
ZV9jbWRfYW5kX3N0YXJ0X2lvKHN0cnVjdCBjdGxyX2luZm8gKmgsCiB7CiAJZGlhbF9kb3duX2xv
Y2t1cF9kZXRlY3Rpb25fZHVyaW5nX2Z3X2ZsYXNoKGgsIGMpOwogCWF0b21pY19pbmMoJmgtPmNv
bW1hbmRzX291dHN0YW5kaW5nKTsKLQlpZiAoYy0+ZGV2aWNlKQorCS8qCisJICogQ2hlY2sgdG8g
c2VlIGlmIHRoZSBjb21tYW5kIGlzIGJlaW5nIHJldHJpZWQuCisJICovCisJaWYgKGMtPmRldmlj
ZSAmJiAhYy0+cmV0cnlfcGVuZGluZykKIAkJYXRvbWljX2luYygmYy0+ZGV2aWNlLT5jb21tYW5k
c19vdXRzdGFuZGluZyk7CiAKIAlyZXBseV9xdWV1ZSA9IGgtPnJlcGx5X21hcFtyYXdfc21wX3By
b2Nlc3Nvcl9pZCgpXTsKQEAgLTU2MjMsNiArNTYyNiwxNiBAQCBzdGF0aWMgdm9pZCBocHNhX2Nv
bW1hbmRfcmVzdWJtaXRfd29ya2VyKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAkJcmV0dXJu
IGhwc2FfY21kX2ZyZWVfYW5kX2RvbmUoYy0+aCwgYywgY21kKTsKIAl9CiAKKwkvKgorCSAqIFNN
TCByZXRyaWVzIGNvbWUgaW4gdGhyb3VnaCBxdWV1ZV9jb21tYW5kIGFuZCB0aGVyZWZvcmUKKwkg
KiBnbyB0aHJvdWdoIGNtZF90YWdnZWRfYWxsb2MuIFNvIGEgbmV3IGNvbW1hbmQuCisJICoKKwkg
KiBTZXQgYSByZXRyeV9wZW5kaW5nIGZsYWcgZm9yIGEgZHJpdmVyIGluaXRpYXRlZCByZXRyeSBh
dHRlbXB0CisJICogb24gYW4gZXhpc3RpbmcgY29tbWFuZCB0byBpbmRpY2F0ZSB0byBub3QgaW5j
cmVtZW50IHRoZQorCSAqIGRldmljZS0+Y29tbWFuZHNfb3V0c3RhbmRpbmcgd2hlbiBzdWJtaXR0
ZWQuCisJICovCisJYy0+cmV0cnlfcGVuZGluZyA9IDE7CisKIAlpZiAoYy0+Y21kX3R5cGUgPT0g
Q01EX0lPQUNDRUwyKSB7CiAJCXN0cnVjdCBjdGxyX2luZm8gKmggPSBjLT5oOwogCQlzdHJ1Y3Qg
aW9fYWNjZWwyX2NtZCAqYzIgPSAmaC0+aW9hY2NlbDJfY21kX3Bvb2xbYy0+Y21kaW5kZXhdOwpA
QCAtNTY0Niw2ICs1NjU5LDcgQEAgc3RhdGljIHZvaWQgaHBzYV9jb21tYW5kX3Jlc3VibWl0X3dv
cmtlcihzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJCX0KIAl9CiAJaHBzYV9jbWRfcGFydGlh
bF9pbml0KGMtPmgsIGMtPmNtZGluZGV4LCBjKTsKKwogCWlmIChocHNhX2Npc3Nfc3VibWl0KGMt
PmgsIGMsIGNtZCwgZGV2KSkgewogCQkvKgogCQkgKiBJZiB3ZSBnZXQgaGVyZSwgaXQgbWVhbnMg
ZG1hIG1hcHBpbmcgZmFpbGVkLiBUcnkKQEAgLTU3MDgsNiArNTcyMiwxMCBAQCBzdGF0aWMgaW50
IGhwc2Ffc2NzaV9xdWV1ZV9jb21tYW5kKHN0cnVjdCBTY3NpX0hvc3QgKnNoLCBzdHJ1Y3Qgc2Nz
aV9jbW5kICpjbWQpCiAJLyoKIAkgKiBDYWxsIGFsdGVybmF0ZSBzdWJtaXQgcm91dGluZSBmb3Ig
SS9PIGFjY2VsZXJhdGVkIGNvbW1hbmRzLgogCSAqIFJldHJpZXMgYWx3YXlzIGdvIGRvd24gdGhl
IG5vcm1hbCBJL08gcGF0aC4KKwkgKiBOb3RlOiBJZiBjbWQtPnJldHJpZXMgaXMgbm9uLXplcm8s
IHRoZW4gdGhpcyBpcyBhIFNNTAorCSAqICAgICAgIGluaXRpYXRlZCByZXRyeSBhbmQgbm90IGEg
ZHJpdmVyIGluaXRpYXRlZCByZXRyeS4KKwkgKiAgICAgICBUaGlzIGNvbW1hbmQgaGFzIGJlZW4g
b2J0YWluZWQgZnJvbSBjbWRfdGFnZ2VkX2FsbG9jCisJICogICAgICAgYW5kIGlzIHRoZXJlZm9y
ZSBhIGJyYW5kLW5ldyBjb21tYW5kLgogCSAqLwogCWlmIChsaWtlbHkoY21kLT5yZXRyaWVzID09
IDAgJiYKIAkJCSFibGtfcnFfaXNfcGFzc3Rocm91Z2goY21kLT5yZXF1ZXN0KSAmJgpAQCAtNjEw
Nyw2ICs2MTI1LDcgQEAgc3RhdGljIGludCBocHNhX2VoX2RldmljZV9yZXNldF9oYW5kbGVyKHN0
cnVjdCBzY3NpX2NtbmQgKnNjc2ljbWQpCiAgKiBhdCBpbml0LCBhbmQgbWFuYWdlZCBieSBjbWRf
dGFnZ2VkX2FsbG9jKCkgYW5kIGNtZF90YWdnZWRfZnJlZSgpIHVzaW5nIHRoZQogICogYmxvY2sg
cmVxdWVzdCB0YWcgYXMgYW4gaW5kZXggaW50byBhIHRhYmxlIG9mIGVudHJpZXMuICBjbWRfdGFn
Z2VkX2ZyZWUoKSBpcwogICogdGhlIGNvbXBsZW1lbnQsIGFsdGhvdWdoIGNtZF9mcmVlKCkgbWF5
IGJlIGNhbGxlZCBpbnN0ZWFkLgorICogVGhpcyBmdW5jdGlvbiBpcyBvbmx5IGNhbGxlZCBmb3Ig
bmV3IHJlcXVlc3RzIGZyb20gcXVldWVfY29tbWFuZC4KICAqLwogc3RhdGljIHN0cnVjdCBDb21t
YW5kTGlzdCAqY21kX3RhZ2dlZF9hbGxvYyhzdHJ1Y3QgY3Rscl9pbmZvICpoLAogCQkJCQkgICAg
c3RydWN0IHNjc2lfY21uZCAqc2NtZCkKQEAgLTYxNDEsNiArNjE2MCwxMSBAQCBzdGF0aWMgc3Ry
dWN0IENvbW1hbmRMaXN0ICpjbWRfdGFnZ2VkX2FsbG9jKHN0cnVjdCBjdGxyX2luZm8gKmgsCiAJ
fQogCiAJYXRvbWljX2luYygmYy0+cmVmY291bnQpOworCS8qCisJICogVGhpcyBpcyBhIG5ldyBj
b21tYW5kIG9idGFpbmVkIGZyb20gcXVldWVfY29tbWFuZCBzbworCSAqIHRoZXJlIGhhdmUgbm90
IGJlZW4gYW55IGRyaXZlciBpbml0aWF0ZWQgcmV0cnkgYXR0ZW1wdHMuCisJICovCisJYy0+cmV0
cnlfcGVuZGluZyA9IDA7CiAKIAlocHNhX2NtZF9wYXJ0aWFsX2luaXQoaCwgaWR4LCBjKTsKIAly
ZXR1cm4gYzsKQEAgLTYyMTAsNiArNjIzNCwxMSBAQCBzdGF0aWMgc3RydWN0IENvbW1hbmRMaXN0
ICpjbWRfYWxsb2Moc3RydWN0IGN0bHJfaW5mbyAqaCkKIAl9CiAJaHBzYV9jbWRfcGFydGlhbF9p
bml0KGgsIGksIGMpOwogCWMtPmRldmljZSA9IE5VTEw7CisJLyoKKwkgKiBjbWRfYWxsb2MgaXMg
Zm9yICJpbnRlcm5hbCIgY29tbWFuZHMgYW5kIHRoZXkgYXJlIG5ldmVyCisJICogcmV0cmllZC4K
KwkgKi8KKwljLT5yZXRyeV9wZW5kaW5nID0gMDsKIAlyZXR1cm4gYzsKIH0KIApkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zY3NpL2hwc2FfY21kLmggYi9kcml2ZXJzL3Njc2kvaHBzYV9jbWQuaAppbmRl
eCA0NmRmMmUzZmY4OWIuLmU4NmFmNGU5ZWVmMCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL2hw
c2FfY21kLmgKKysrIGIvZHJpdmVycy9zY3NpL2hwc2FfY21kLmgKQEAgLTQ0OCw3ICs0NDgsNyBA
QCBzdHJ1Y3QgQ29tbWFuZExpc3QgewogCSAqLwogCXN0cnVjdCBocHNhX3Njc2lfZGV2X3QgKnBo
eXNfZGlzazsKIAotCWludCBhYm9ydF9wZW5kaW5nOworCWludCByZXRyeV9wZW5kaW5nOwogCXN0
cnVjdCBocHNhX3Njc2lfZGV2X3QgKmRldmljZTsKIAlhdG9taWNfdCByZWZjb3VudDsgLyogTXVz
dCBiZSBsYXN0IHRvIGF2b2lkIG1lbXNldCBpbiBocHNhX2NtZF9pbml0KCkgKi8KIH0gX19hbGln
bmVkKENPTU1BTkRMSVNUX0FMSUdOTUVOVCk7Cg==

--_002_SN6PR11MB284885A5751845EEA290BFCFE1989SN6PR11MB2848namp_--
