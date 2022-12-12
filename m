Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3037C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 12:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbiLLMP5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 07:15:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiLLMP4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 07:15:56 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41247D4C
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 04:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670847355; x=1702383355;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dlRoCd0/ZeKigal4RWG7/SFnrbYKo+gIz7jmznKLnLs=;
  b=hM8kSW2zTVKAKQmDQZ2s0NeGf82Fs+JOO7GOfbPe1MfBQXIuukzYM2D6
   mRsVgfHdtVzyK3EnQvaTcbuT0uOcME+H61ahbNmOJcBH7yTt2wHZQ4rzD
   1/moQqmTG3X87PKDSWfrF2DkDVD+H8wgYNz4EVMuaNwHysnApy/oDc68l
   F+5izpIyw8ZutDWo/mk8Te5BdXnOEftHYKckobsVZFTUzegmeQGn5QVMC
   p/jX6LFJmK9llJAM/6pLF317GrsvZPLdynCxT3X/UNrZuRqJjqfeTKiuY
   W8RVL0EWStT4Q6nI4Ulsywy+sRqNBVqiztfBcGK6B2l0iDqgUQ969KNmH
   w==;
X-IronPort-AV: E=Sophos;i="5.96,238,1665417600"; 
   d="scan'208";a="216645702"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 12 Dec 2022 20:15:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lz/Go+DjmnQpoWUtubth+3/mY8FXntufnuhucnIEiyrJjgCnLNupWbp+SCI8dcD+L5hbDBJSh2Y4jERuwpPVIDf+FKYb4Y2GQnmkXNY6ca5R3Dx3KWna1FjZTSYUfF5tO/Ddep/iiPZ5Olng+lqHX9onSBNEkpEw/cae99VxCX6xM1hG02o5CrtRf4apM1mOl5TKZkrqjJV2b/3HMEvAkEoup1oOEG86emiBrmfOWxjArtaTp0JFDAA+lv0TFIVMuzzinqJdnY4DeQeME8E92qtlhQzcbfezbTjVN+xUhackAcR4Wdm2bmwBHrv7Nj86rBSM/OKOwjQBO5Xz4qesIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f5Za+vc+GIp1KouPcM3z2b3BvTVKyfHB8s3Acub6BlE=;
 b=NIkIl09Q473MatalEr7idShc7uqWH6+OaSBNZrWif7Jc/KtSw8tuyvmI0NdL7quazTajtSE6xytUsXVmxuHnUcAb97NAZZPYUI/uhCM86z7HxItmtenVuTDHO8sZ0mDlMmobMTU14lkyASaZacai3kgJcXQbQz+OG3uSIqjvwijEI/pDJAoF82H2nRz3TAnHx+NBDNQ59ZiFZA5T6Rub/upqFv7j8Ka3YhgaheAFYdnDinwPWpl9o8fNhdXZlDlmT5C1KKQ0a8fUCagU1N5kRZkNV/QmF3YIrnLlmZ8OkpGJC6dTaCZmJWaAjft+9rlQvy9zYEKGG2dTHzh8GehfzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f5Za+vc+GIp1KouPcM3z2b3BvTVKyfHB8s3Acub6BlE=;
 b=PVyN0sWCmtnzFQvQMUJ8wfwWO0KYxVkfuqdN/9acle/ABtxKcwoCtVipIAYMqdXuR9ZczMfkOXNRGhJRmoB7us+5GJ3HtF5z6XS7KvHSo5nR+RwaJWrSNG1mkny4Px2WbvguUA8lEwg3VsqBs36aAHjfpBN/nMWusSlTq/PLn5U=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BYAPR04MB5319.namprd04.prod.outlook.com (2603:10b6:a03:d1::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Mon, 12 Dec 2022 12:15:49 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0%5]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 12:15:49 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/3] scsi: mpi3mr: fix bitmap memory size calculation
Thread-Topic: [PATCH 2/3] scsi: mpi3mr: fix bitmap memory size calculation
Thread-Index: AQHZDeuSQxIFp49mpEKUrYXt5KouZa5pvkGAgABs1wA=
Date:   Mon, 12 Dec 2022 12:15:49 +0000
Message-ID: <20221212121548.bf5pb6zmbbfdaadh@shindev>
References: <20221212015706.2609544-1-shinichiro.kawasaki@wdc.com>
 <20221212015706.2609544-3-shinichiro.kawasaki@wdc.com>
 <c65beb54-7ff3-1a95-f255-916c25ef03d3@opensource.wdc.com>
 <d16ef645-d60c-6b2f-7369-5b7f535631ca@opensource.wdc.com>
In-Reply-To: <d16ef645-d60c-6b2f-7369-5b7f535631ca@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BYAPR04MB5319:EE_
x-ms-office365-filtering-correlation-id: 81fd50e3-6821-40b0-c063-08dadc3a9b19
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YWaB2Z7+FQc8T0xGh6SSV7xtKd3OxDs/7IJZZJMgcgaQHAYwel2wx8XYEQ+Fu9NP+zdpJ2E35ZkB4EGcZOqgVrtzaj9gP06x5Ie12lfCED5oyAxXGKT5wZb6uBH9Dbw3pGDr+SlWJov2N6ocK88r/pr4l+xGOAEzt8wtdQwrlrtcpcEZYmq3btDcjyFBHb0gcTu/dl597BCBzRAceAq20LWIBa/WSn51uG8O18UfoLG61b5jiAApewRF0zHcHyFuU2domEAqeHIlNoZGdTodGM5SAsAbsoH6aWSYKdB0hcT6eG3ofO6czEjczyWuxbn6e6x0neG66lO1Jl9Jgrvfr5//VkPhXbcTOJxFaTezqaw5d9oOnSIc8IPZ6IXGjoflco1ljiiqtY6HQ3jqzckpn2JTavoEIgot2GPy2+bthPvOAGF55XPgi5wvzMIXSdywWCLwBJBOs9hxyqoPrlBvEfrEynC6cIIpJYPBfUS4Dsd2FhLbsa1oLhh7USyJlxRUOhlxUuSFj3uuiqicuj6WfcDU0Q2juZj1yr49LWrORnKsakB0wYn1Oz7QDuuiIAQf5liPi+70C99IK3tmvOF5SiV+UhF8zZ8YV1Vck9SG+3NK99pKzeMscgtVe4hTlYh2BhOckRLlwEMJubkmlWfeajaUVN7D0jpocIfHizz8ZeQEJCP5VIzqwv9hMYLYaCWRWfvS3Np+fSHMreSZNmuQb1I2LPW0wVdFX+mEc6fUkF4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199015)(66556008)(66946007)(76116006)(66446008)(4326008)(8676002)(66476007)(6862004)(41300700001)(91956017)(8936002)(1076003)(83380400001)(186003)(64756008)(54906003)(316002)(38100700002)(2906002)(86362001)(38070700005)(33716001)(122000001)(5660300002)(44832011)(82960400001)(71200400001)(53546011)(6486002)(26005)(9686003)(6506007)(6512007)(478600001)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WXPTBd2SA3Wrj5nTo/7NqEqVMNjmLaVeY6UbLH6Zd9OmbowVzLfpvxpegob8?=
 =?us-ascii?Q?hxCkvBanT7E5P51dxD0gPGecGmbzhi+fwbT7WlWJVBVt7FoJsg9E7XozuGny?=
 =?us-ascii?Q?vuOiGJOu6lR4jabj1mS6SqmZTV6UFmDIJhAGLa8UWd81pt5yfTsH/aZW4see?=
 =?us-ascii?Q?fMnvEvdQWhG1I0rm6f4uk/Qv4L9odYuHpwTl4szmyXSBLLCmWxO+5AYUTAXn?=
 =?us-ascii?Q?1xopHWmSrQJNxEKyocBGojSvFH1ApmUXBunFDZB9hF8jZmIladuGK9MGlLH2?=
 =?us-ascii?Q?2iPRk6W0HzQ2S8vwU3/3MkKBYbU/oUUBAoM4y8jkBhSyRHaMQAzp3OhnfH1A?=
 =?us-ascii?Q?khfx2uXislppsNuPBE5IOVGnpu0WPE5VgZ9b2d4TCY93gzDVXNN3gIcoDxjB?=
 =?us-ascii?Q?jRd2OxI42z6jDUvGoQNcict3DI5SnpQUd/5rjWv2cvaDhy3lg/743yTaFx/E?=
 =?us-ascii?Q?3k/Y5buMsQwKKITGKLOkRXq0TiFvvg+ngAuJ4+pvDrDYiI7rsuKvGFi6vyLs?=
 =?us-ascii?Q?ikF4og3H2rPvzEUXBrA1VmGii7hfmagH1C9+gZjyeq+JefQmjGRyhrhvYecU?=
 =?us-ascii?Q?DMtPKhw5PELD5RhUBsLpaqKxgZhZoPYRJz7bKOeIhczs4j9/eQh6i3FPy2Sq?=
 =?us-ascii?Q?3cHCpRVorliQZFKil7PYUbpKEzr0njdVcHkrarrBPxTGGZ7UZ7UYnp+DYfvv?=
 =?us-ascii?Q?zuokOhxOYnRZMIYPwWjcuMjCM4oQUFFpLCSF6jVG8v/Fw84kJ7cH91/PQwD2?=
 =?us-ascii?Q?tGsuvyFbEtEVjuqoYDg1poW9T3tcw3RI0PH2q6pXRfR3eghWrXa1dnPxWlqW?=
 =?us-ascii?Q?PSYJr8Lt+fzUs/of66FfK1qDsmk4G7nxWFmk7Xb03M11Ua3OsEZw/ukC9UA9?=
 =?us-ascii?Q?J9AsLh3Zcbb5VJDIYVPrm3rV4IE6i7qWZSOarcktYvDi/LfR3RTLRudsygvW?=
 =?us-ascii?Q?ZTdzOVAWvQFH3Mm/ZgmL32e1I4fn8kBEa7i3JIWio7LOrXVv6aF4JfTjXpdj?=
 =?us-ascii?Q?gYW3ITh4aEUX/G9xHTHqO70aoEnfSmhLZYXreJFRw4IHCDVcqPuWNlz0/ab+?=
 =?us-ascii?Q?142p1aCzLXnx1I0ZtEuLRLICFFwWu5l6TkHBzmIBhHtBdnAWvEnjlah9GYRv?=
 =?us-ascii?Q?K3aE7Em7/HgMg1tAo9Uaa6LYqA8n5Cqll8ltW/459vGOJoi19IxjMgiyDafT?=
 =?us-ascii?Q?WAXg3zrHIP3HZgtseumTHK+kmQXoC52AK+4EIY0lQhwYHhBfWHp3lE9WhJgM?=
 =?us-ascii?Q?/lVMvaiqiQBMzXj/X2ZEeOJahSV0zdve/VAyoofT4Un49DbrfHOFV504/1N6?=
 =?us-ascii?Q?LpxXxWExBRuTqLqAITBqbSo83C1LaQYUB+iyuWMCzoLNlbJgGpg6IQ38+CKv?=
 =?us-ascii?Q?spt5KWNteZUFLDwGzV5khazOjakhBwQv8UiCF7TtfseMrZCZw8Te3hBwpjS0?=
 =?us-ascii?Q?cp5+YTgCepEddw/pKRzoncttjU6jLENs+tnvK3ICjGpIhLRCKlm6SERlrsIM?=
 =?us-ascii?Q?j6cgjahRyPyqcxeeJuhxP5ia5kp/E46W54FOF9wQsMdCQYUDALDwUVysf6gX?=
 =?us-ascii?Q?g80qkZYFvY8+f2HF/6Q5kcpnkfJMoOf3tJWaCSsXRGaIYyRDW87XvF2xaKCP?=
 =?us-ascii?Q?9qQXOiZZ0lLGWA2yqM6zltI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2E06573095C1914AA048543235886555@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81fd50e3-6821-40b0-c063-08dadc3a9b19
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2022 12:15:49.4091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mANcGgCkZPO+cuh6ZVN6HkvJ2t6RkBja/p8g1eJpt7tPGe2ZEb4YtMwpjcyO2IIdHCtjeTCb+Z4U/AbLb1zsS9HijUdbr6/l+6Vh9fu3hCc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5319
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Dec 12, 2022 / 14:46, Damien Le Moal wrote:
> On 12/12/22 14:35, Damien Le Moal wrote:
> > On 12/12/22 10:57, Shin'ichiro Kawasaki wrote:
> >> To allocate memory for bitmaps, the mpi3mr driver calculates sizes of
> >> each bitmap using byte as unit. However, bit operation helper function=
s
> >> assume that bitmaps are allocated using unsigned long as unit. This ga=
p
> >> causes memory access beyond the bitmap memory size and results in "BUG=
:
> >> KASAN: slab-out-of-bounds". The BUG was observed at firmware download =
to
> >> eHBA-9600. Call trace indicated that the out-of-bounds access happened
> >> in find_first_zero_bit called from mpi3mr_send_event_ack for the bitma=
p
> >> miroc->evtack_cmds_bitmap.
> >>
> >> To avoid the BUG, fix bitmap size calculations using unsigned long as
> >> unit. Apply this fix to five places to cover all bitmap size
> >> calculations in the driver.
> >>
> >> Fixes: c5758fc72b92 ("scsi: mpi3mr: Gracefully handle online FW update=
 operation")
> >> Fixes: e844adb1fbdc ("scsi: mpi3mr: Implement SCSI error handler hooks=
")
> >> Fixes: c1af985d27da ("scsi: mpi3mr: Add Event acknowledgment logic")
> >> Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
> >> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> >> ---
> >>  drivers/scsi/mpi3mr/mpi3mr_fw.c | 25 ++++++++++---------------
> >>  1 file changed, 10 insertions(+), 15 deletions(-)
> >>
> >> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi=
3mr_fw.c
> >> index 0c4aabaefdcc..272c318387b7 100644
> >> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> >> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> >> @@ -1160,9 +1160,8 @@ mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *m=
rioc)
> >>  		    "\tcontroller while sas transport support is enabled at the\n"
> >>  		    "\tdriver, please reboot the system or reload the driver\n");
> >> =20
> >> -	dev_handle_bitmap_sz =3D mrioc->facts.max_devhandle / 8;
> >> -	if (mrioc->facts.max_devhandle % 8)
> >> -		dev_handle_bitmap_sz++;
> >> +	dev_handle_bitmap_sz =3D sizeof(unsigned long) *
> >> +		DIV_ROUND_UP(mrioc->facts.max_devhandle, BITS_PER_LONG);
> >>  	if (dev_handle_bitmap_sz > mrioc->dev_handle_bitmap_sz) {
> >>  		removepend_bitmap =3D krealloc(mrioc->removepend_bitmap,
> >>  		    dev_handle_bitmap_sz, GFP_KERNEL);
> >> @@ -2957,25 +2956,22 @@ static int mpi3mr_alloc_reply_sense_bufs(struc=
t mpi3mr_ioc *mrioc)
> >>  	if (!mrioc->pel_abort_cmd.reply)
> >>  		goto out_failed;
> >> =20
> >> -	mrioc->dev_handle_bitmap_sz =3D mrioc->facts.max_devhandle / 8;
> >> -	if (mrioc->facts.max_devhandle % 8)
> >> -		mrioc->dev_handle_bitmap_sz++;
> >=20
> > mrioc->dev_handle_bitmap_sz =3D (mrioc->facts.max_devhandle + 7) >> 3;
> >=20
> > would be a lot simpler...
>=20
> Actually, if the code is changed to use bitmap_zalloc(), no rounding up t=
o
> 8 or BITS_PER_LONG is needed at all, so the code would be really simpler.

Ah, yes, I agree that bitmap_zalloc() is the simplest way.

>=20
> >=20
> >> +	mrioc->dev_handle_bitmap_sz =3D sizeof(unsigned long) *
> >> +		DIV_ROUND_UP(mrioc->facts.max_devhandle, BITS_PER_LONG);
> >>  	mrioc->removepend_bitmap =3D kzalloc(mrioc->dev_handle_bitmap_sz,
> >>  	    GFP_KERNEL);
> >=20
> > What about using bitmap_alloc() here and keep the dev_handle_bitmap_sz
> > value as is ?
> >=20
> > (same for the other bitmaps)

It does not look good for me to keep *_bitmap_sz values as they are. This
driver uses various *_bitmap_sz to keep size of bitmaps in byte unit, and t=
hey
are passed for kzalloc(), krealloc() and memset(). It is not clear for me i=
f all
of the function calls are ok with numbers unaligned to sizeof(unsigned long=
).

Instead, I suggest to manage bitmap size using number of bits. The kzalloc(=
),
krealloc() and memset() calls can be replaced with bitmap helper functions
bitmap_salloc(), bitmap_copy() and bitmap_clear() which take number of bits=
 as
arguments. In this way, the driver no longer needs to manage bitmap size in
bytes. I'll prepare v2 patch with this approach.

--=20
Shin'ichiro Kawasaki=
