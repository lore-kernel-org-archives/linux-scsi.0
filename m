Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ABB1C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 08:18:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7AEF61957
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 08:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbhCaISQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 04:18:16 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:30936 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234202AbhCaISP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2021 04:18:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617178695; x=1648714695;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8q6mbLGgew0xYvKScg33csXfk1OaVa0VHUZ9WHQuiAc=;
  b=p85vvFfAk4WvYQvKITlHtZW75oxSgRe36repWA1WMKSNGB9Sefl6Ejqg
   k4n8QJPXeGg7psirh1Iczm9GlPMPI+vjLEXzlA8UwEtjV04l6ug+gIkNp
   u8vI00+ow7WwA6PnrYjHH9FZA9zJUAE8b2HQgoyzwOeyDHn1yR0LABEKV
   13Mfhbb6I9sbu0njmUwfqLpHug5kMR5oY6vDQycC1zZOccWg7c3qhH50v
   x4RJ18utq/G1pk4wwyMo8eMPHIrct180ntyeIMIub8FifN+jga6msEEBk
   iDYGk5X9TB7FMIK4mfo7EHkUdwcmBZbufj2lVwMPkOuhRAckR6MS9tyIR
   g==;
IronPort-SDR: ZU6ATdEa5z2rZ++oJanz6XQJGrGGGwf6TIyUxvkrnxscHn8/4nYa6MYCBGKkTEmuuCzj//XhVS
 TAdfI8yCRBOOF5qAA8YV0XTRqnCk8gAyXmdQK9vwVGNJ9xhaZawJQH/27eVoBGSy2Xma3dEuME
 KkSlF/gZSbhcZle7zwJMUs1Q7XvcqfpurT3VKqWIh81gxNZC5GvoUbhy+o63v0w1nRTrxiY0W4
 Chwlsx37tWdin5r++BHUcOxEONwGtE9c3nmQU6eBlu9ziSCYyfXJKTqGe/2j/yD6MnWAMZ54KT
 xmM=
X-IronPort-AV: E=Sophos;i="5.81,293,1610380800"; 
   d="scan'208";a="163424937"
Received: from mail-mw2nam12lp2042.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.42])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2021 16:18:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qwlz9x5wK7Va/I1ilLEcHkQ/QyyYQVp2pCCzm6/RdmHzqdbtcV7PgvMw3X/h/cVaba9zwO1877bXF9SC42QQ1GzX+cZLN7maHa1Wb84NyC5Oe85E+TkEsUYh97tDuG7HCgIl3NH1s1yZmkP8t+xtO6u4WrIPztnLHe1ley9h/9VqJOacuWfWt+70hTBwmPHLumso6B+fRuUoWmKbgm3NiXWIvu2krJR41TYHAKptbRigqwQxUkoJywtOerOGMZ3VlXYm2I3bi2sU1qJ94JS6DLoheSIZVlv1RQzZPXDm774rE33vG3GO3NE0XJUH1FaJOJiVWzZaSjOa2dv1V+Mf1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8q6mbLGgew0xYvKScg33csXfk1OaVa0VHUZ9WHQuiAc=;
 b=Olu5dwghSXbFv17zNZtRZOdvIq9ufF6iKw5DF2SbFifFqaMy5qL7yUHTOuMS2Y4vabi+jzjFYZXGS0sRob6uR05OwDhQssA1u+qX1dxDEL+0WZ/JbNFjNVAvfnaksPOr+7cGuIe6f1y6Wur0ZiWAGP1le76DtjvK/nQETTXd0Iqi9T0lL+f34UOdmZMpPy8EiLFNH0e21IwzkQ3LG+QrPnbPW9HTsgeaRKheIi4rzSsnMuZzWwWAbYzJs8AwzwBvQmjft+3pe/aBcYBZY6IAkRVuBt/dITWPZfA2aLtUp+Ts4DoE5DdacL7y4BYG2s/IXYd/Q3XCa2bfInLa65/c2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8q6mbLGgew0xYvKScg33csXfk1OaVa0VHUZ9WHQuiAc=;
 b=Wv67Y6LjLkpVpTpFFUA+ld0eCLLxMMQFQHnRwWs7KSWFMPcRpFPCoNdzZXmpAmLXWqhJMNQOrGM3potOsYHyL07VJwgPn/NF/grTu5LE7bTsMxTs9YJKXUmDi4a58Ln+Gh2MjI8BvbQVltny3s1TKIBOmaKYP0aQUdHdbEFJ3WI=
Received: from BL0PR04MB6564.namprd04.prod.outlook.com (2603:10b6:208:17d::11)
 by MN2PR04MB6319.namprd04.prod.outlook.com (2603:10b6:208:1aa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Wed, 31 Mar
 2021 08:18:13 +0000
Received: from BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::4c67:96fe:ee31:730a]) by BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::4c67:96fe:ee31:730a%6]) with mapi id 15.20.3977.033; Wed, 31 Mar 2021
 08:18:13 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>
CC:     Bart Van Assche <bvanassche@acm.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
Subject: RE: [PATCH v2 0/2] Introduce hba performance monitoring sysfs nodes
Thread-Topic: [PATCH v2 0/2] Introduce hba performance monitoring sysfs nodes
Thread-Index: AQHXJdwvUu29Yvoe8UOfBP3YUvFfMaqdcd4AgAAFBQCAACsjwIAAFbiAgAAIsXA=
Date:   Wed, 31 Mar 2021 08:18:13 +0000
Message-ID: <BL0PR04MB65648D7AA6A46EC4ECB44DDEFC7C9@BL0PR04MB6564.namprd04.prod.outlook.com>
References: <1617160475-1550-1-git-send-email-cang@codeaurora.org>
 <ce9a2333-437e-143a-a0f0-c5f532a2c423@acm.org>
 <6aeb31ca744b1232808bddb7397edf4f@codeaurora.org>
 <BL0PR04MB6564DA13DF093548E599DE9BFC7C9@BL0PR04MB6564.namprd04.prod.outlook.com>
 <55059457e37f949828104b6ee7491a9a@codeaurora.org>
In-Reply-To: <55059457e37f949828104b6ee7491a9a@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [46.19.85.18]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 778efc32-8042-4eda-1775-08d8f41d8731
x-ms-traffictypediagnostic: MN2PR04MB6319:
x-microsoft-antispam-prvs: <MN2PR04MB6319BED8EC670FFCB3AC1635FC7C9@MN2PR04MB6319.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Exc+46EyW96/IOjxxSxv7hzepiQ8KdQu1lLYqW2UgGlEUvhwVJXB55YQKrH9g4giUn84VD+wHoiwGxlc6H1wPybJAqLnnPSPMA/l848fhf4sxvt/4giO6Foke/a57l3wes+x7+QKPjDD+GqZUzxGByKwA2tJdfZvj5uw8Ke33dFJ/+PpUkVoljgeId1Mw3olAQMKM58KnRr4HOJz3fV32CQVitk1YXpTilNZEpi147o2/YTnClFYgUV4+2v4PZFam8MLHl8FifWqpy/G3DRHi9AHfc1FvXqoV5a+g0mw78s1yEAVWj3qKhgeo7oZn3ptEkZeJVvSoaxj8B/natxqpM3gNLJ8hqMMd3wEv+OPBkK3G8+dk2EUz1+7um5gvyWoTgdkMiGtGUzo2z4jDxJ2iwTwff+GtxyQjV4CiGJzAmQgbvzyt5+qcdEf8AmQAd594PJK4IQoL8CJ5knd7U7Nep6xwTfnGs2jQvNjAPXfkvVFkUJnYF9404U4/LVhsVmaJAlkP4nDlhtxPzP4MtZ/yVpnUNtn+aHFcNj1UwemtghV3t2qGQKuW8mQIoc9wxcVTB+ARm+t1nt9xi6VkhiXY1qKYp/i7ngQjo5MHp9aY5Fg919lcOLFMqe/jOtwCs4jk3zOOAH9gY+aiCnV3r8jh54/iV2GFmTfRN1ITpkene4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6564.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(26005)(66556008)(186003)(8936002)(86362001)(66446008)(66946007)(33656002)(66476007)(76116006)(4326008)(64756008)(8676002)(38100700001)(498600001)(7696005)(2906002)(83380400001)(54906003)(71200400001)(6916009)(52536014)(6506007)(9686003)(55016002)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?rqmjkD3eh33xk400KaaEhGGPKtgRRlTyuv26SbPG7TU3XtgtZh8qTMpFWnas?=
 =?us-ascii?Q?VEXdpLaYq0FSNbcQ28++Csqe05vYCoOQ8Y7aHLrNa6VSAZ0v6+kzV2YYBVF8?=
 =?us-ascii?Q?R+IcLosSTSpfhIjCm0ubSJPV75+Qvc+D8QftwOFS+P+eLJpLjHR0hQWAaL1j?=
 =?us-ascii?Q?fl2signXWsIvC5yY/hrY//XdyZWyxj1brhZ5gjEyYjJ1mrJw0+2sk3a5AwX/?=
 =?us-ascii?Q?dUzxRERt72oy09KTqpjkOrAB9sohcwwECQX04NJYx2q9hpEFoxMo+B5Oq/YE?=
 =?us-ascii?Q?dztAX53LrpC+ytl0ZNsLT9tYgmuUMKupyqpZJ5N7sr2w1CZUM4XkVUXcAosJ?=
 =?us-ascii?Q?ph1CMs1B7VVE2LVgtE3HYkWE4pNDMsUhyJ+Ms5G0sHrAMJjt+TVL5H8g0X/b?=
 =?us-ascii?Q?obpsKwoGPxOEAR74SHL5v+0616QO7tN1mpFCYWXJ41OkKYIO56IzBmX/MemE?=
 =?us-ascii?Q?WuLpBU1XtkZQzXTx8/4MhJHuHnuZWxIQbIt2914rHcAxKP4W2MeY/U3B6JQX?=
 =?us-ascii?Q?573rfAmeUj9bKwFWGNb6SeCJXh10M1SCzQBsv8xS8x8ux/VG+Wq5nt4OuNzS?=
 =?us-ascii?Q?n4iUdNluPF+bdjZ3OBb8QnHD78srO92KkKMNoF0OiH00Npm4SJhG8A6TuGV0?=
 =?us-ascii?Q?AHcL68lGo0oQ6WZvmY0NdiJYmUnGCZs0AUPs2cZDnPwUJ7/wxCRgdU4O+4aI?=
 =?us-ascii?Q?dNOagjfzmqM9j0ZmAZZuCOYLGdXekI8WHkBDn6sre1Uk8Z/tdCLgqTQkJ+4s?=
 =?us-ascii?Q?K8lU4VhQ9mhtfxlIEYYzVVIFce9D0E8SHId4nudlORf7zXy5uuVjejr//Alb?=
 =?us-ascii?Q?Dl8aobZWN55bDKOpn8AsZdk8PXDzGschNb96xu8RUeDwvA4FJlq5RFr8Jp8F?=
 =?us-ascii?Q?HkcinuJJ76RRVnigH2S3Y5kvj+Nfy3oyTFyl/+GHL5hzB4EHnAfUZi1C8SfZ?=
 =?us-ascii?Q?chR/aCUubUsTHBjGFn2ik+1Za8gtCLuV8MM1aGMxQCKfOGCp7e1c0lwdoYFg?=
 =?us-ascii?Q?AwDvD+vV9yqEwRhBHYtj69bMKQdixBqd7S4swcYEP2k5HH3S6o5DL5u4x+Gz?=
 =?us-ascii?Q?VM4Wn0722Z76h7bCDE91J7HU2orN7t4b1EbFfkrw+EoZ3W9HuMhtg4cEfx/H?=
 =?us-ascii?Q?zf2JE7Tln1B3ZL5mA6tzJgg3aDpVwFpkH3ULAfIALh5+Y1SBBlbdLHg/U1z1?=
 =?us-ascii?Q?XsnJX8oKVJn5KaAVqx6KbIZRMlqbCtjUDL1DpBUUuyPqEWpHLScq20MtmZrf?=
 =?us-ascii?Q?9SiAOh66D8U5/YQuL1s5mDkOBMjGHgHFyAR5cL926fO/P4rSKKcQTqq7IWsE?=
 =?us-ascii?Q?Dbw=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6564.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 778efc32-8042-4eda-1775-08d8f41d8731
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2021 08:18:13.0891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2Y/aC2gibU1SRZi9bmyoRjuRnif1rwgnbyCsdvg4WrfYZirQ3mAJ64ooSVcC3Uh1zxQK4/UgyOMnLaRTK+IQkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6319
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 2021-03-31 14:35, Avri Altman wrote:
> >> On 2021-03-31 11:34, Bart Van Assche wrote:
> >> > On 3/30/21 8:14 PM, Can Guo wrote:
> >> >> It works like:
> >> >> /sys/bus/platform/drivers/ufshcd/*/monitor # echo 4096 >
> >> >> monitor_chunk_size
> >> >> /sys/bus/platform/drivers/ufshcd/*/monitor # echo 1 >
> monitor_enable
> >> >> /sys/bus/platform/drivers/ufshcd/*/monitor # grep ^ /dev/null *
> >> >> monitor_chunk_size:4096
> >> >> monitor_enable:1
> >> >> read_nr_requests:17
> >> >> read_req_latency_avg:169
> >> >> read_req_latency_max:594
> >> >> read_req_latency_min:66
> >> >> read_req_latency_sum:2887
> >> >> read_total_busy:2639
> >> >> read_total_sectors:136
> >> >> write_nr_requests:116
> >> >> write_req_latency_avg:440
> >> >> write_req_latency_max:4921
> >> >> write_req_latency_min:23
> >> >> write_req_latency_sum:51052
> >> >> write_total_busy:19584
> >> >> write_total_sectors:928
> >> >
> >> > Are any of these attributes UFS-specific? If not, isn't this
> >> > functionality that should be added to the block layer instead of to =
the
> >> > UFS driver?
> >> >
> >>
> >> Hi Bart,
> >>
> >> I didn't think that before because we've already have the powerful
> >> "blktrace"
> >> tool to collect the overall statistics of each layer.
> >>
> >> I add this because I find it really come handy when
> >> debug/analyze/profile
> >> UFS driver/HW performance. And there will be UFS-specific nodes to be
> >> added later to monitor statistics like UFS scaling, gating, doorbell,
> >> write
> >> booster, HPB and etc.
> > We are using a designated analysis tool (web-based, a lot of fancy
> > graphs etc.) that relies on ftrace - upiu tracer etc.
> > Once the raw data is there - the options/insights are endless.
> >
>=20
> Hi Avri,
>=20
> Yeah, one can dig out a lot of info from ftrace/systrace raw data.
> But, most important, ftrace/systrace has below disadvantages
>=20
> [1] Enabling UFS/SCSI ftrace itself can impact UFS performance (a lot)
> as per our profiling
> [2] One needs a parser tool (only if they have one) to get the wanted
> results
>=20
> So we usually use ftrace to analyze some sequences, e.g., cmd-response,
> suspend-resume, gating and scaling, but not quite suitable for analyzing
> performance, see [1].
>=20
> These nodes provide us a swift method to look into statistics during
> runtime [2].
>=20
> Please let me know if you have any concerns w.r.t the change.
No - not really.
It's just this sort of things tend to grow...

Thanks,
Avri
>=20
> Thanks,
>=20
> Can Guo.
>=20
> > Thanks,
> > Avri
> >>
> >> Thanks.
> >>
> >> Can Guo.
> >>
> >> > Thanks,
> >> >
> >> > Bart.
