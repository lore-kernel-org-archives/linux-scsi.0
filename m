Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E38C05027
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Jan 2023 13:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjAZNzQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Jan 2023 08:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjAZNzL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jan 2023 08:55:11 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5484AFF0F;
        Thu, 26 Jan 2023 05:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674741276; x=1706277276;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fohbq1dCwbf8JR/9/IKY+MC51wLjMuU7YG7GL++/VBk=;
  b=J1OKJpL55RmByp+/ktjOJq82DMPgRVbsCT33/mFakl90z4w0gXAg7oNw
   ljI6QgzN+e27hIzwdAJNuHhiGjaQugYgwrxbTDI70wt6hbwowRANgSrEC
   oXU4PVK0SPJXiP00OB1INyao5NrMQpU2S0n4Tf7bnrv58Yv8USmhu7ZXj
   dbYRjNK/PXSgmrwT+q/mgpl6LXgEWtrv/1BvVkXweLo8TdPyjCUekemgU
   GFldZBU3esv4bkGaAnRdOecsi3ts7XAoPMaz7zhSShWZWLsf6lzW4wxfs
   d4hHdtB7/EMVqFrEeUE5TL4MvgKaAUN7R5ZJqs3mqPEdRymN+M2zvrRiZ
   w==;
X-IronPort-AV: E=Sophos;i="5.97,248,1669046400"; 
   d="scan'208";a="333793369"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
  by ob1.hgst.iphmx.com with ESMTP; 26 Jan 2023 21:53:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fRwcBKGWSDlJ6GwrO981grLSP90Q0S81YPMLGDpZmjJ7uKv6fVJOMP1jlnXDOrNma5Gc09tq56ervuYc5TpbOMzMskGIqhGXIktUl4TvpiEYSFa68jGea+F7sbbulrjjl+ZrGn8JltxMARP9ucU8puEKOPLU/xrp68F4yWmJBy+e82Pd0A1FRJ89eJ4ZdWJnADmU+T6zTP+TpC+bAk7Zh5TYSHA4MFrEsR43PrSdOJ3+v6jv9P8PQbkHg7pGP95ovw/CQB4dtpwTXXBV9+f08ANbuKgxb0f7J+P/PGtW6156ZQI2Wppj/kqNXq0bxy9DskbZpMm60mACH4O18NNNjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fohbq1dCwbf8JR/9/IKY+MC51wLjMuU7YG7GL++/VBk=;
 b=QELBVPJ4dE3pi1z+zpfEYJY3cR3kBwvubpgAW6/uHPtJKDq5hxyuUPq3b+xKv64/2oVGXq9fvTkpRQV6oFLA91UwUioQps3rYbxgVPw/7brQqjNWVjEIElRkbQmS1CFte8jmwS5Ns1mE8lL0AStoOtjFl0fvHZhLbAKRqBiXWCTI693/5cVviW6D21s2Be8QYqktX9gVyn+fcuoOOzQlSKGjPWlSZPUslVSsI4/K8cu1kVKgoTlHQH+2BKhxPkOJNJtXpiOr23qUOPLVDcFIGNH3tsTFLymqbZ+dyHXPNPrtyzUzU5pbktqrr0LH2PKpxr5U+QfxHxUxJSG77Pn5dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fohbq1dCwbf8JR/9/IKY+MC51wLjMuU7YG7GL++/VBk=;
 b=GSesp2NfIUbpMkkJXxR0Ql+OuawQ/NWOOvLJ+h2GWLUlCS4riD963VXPCK4+c9B+tgDEOKNTYSrGwOBwsMCM84727wpMz8N15e4Iob87grdt04ck6b2536iDenmJB4FgP4CN8T6DFOWvNB6t7i2nQDwdLnCPdOOXmNOHylI0whM=
Received: from BYAPR04MB6261.namprd04.prod.outlook.com (2603:10b6:a03:f0::31)
 by SN6PR04MB4077.namprd04.prod.outlook.com (2603:10b6:805:47::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Thu, 26 Jan
 2023 13:53:45 +0000
Received: from BYAPR04MB6261.namprd04.prod.outlook.com
 ([fe80::e43e:309f:9b20:b721]) by BYAPR04MB6261.namprd04.prod.outlook.com
 ([fe80::e43e:309f:9b20:b721%4]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 13:53:45 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     Bart Van Assche <bvanassche@acm.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
Thread-Topic: [PATCH v3 01/18] block: introduce duration-limits priority class
Thread-Index: AQHZMCaLXQP7EDNJ90KbuyJrXRgwUa6t83MAgAAiHQCAABSrAIAABJMAgAASfYCAABSfgIABIgwAgAAuRoCAADJ+AIAA4i2A
Date:   Thu, 26 Jan 2023 13:53:44 +0000
Message-ID: <Y9KF5z/v0Qp5E4sI@x1-carbon>
References: <20230124190308.127318-2-niklas.cassel@wdc.com>
 <bd0ce7ad-cf9e-a647-9b1e-cb36e7bbe30f@acm.org>
 <731aeacc-74c0-396b-efa0-f9ae950566d8@opensource.wdc.com>
 <873e0213-94b5-0d81-a8aa-4671241e198c@acm.org>
 <4c345d8b-7efa-85c9-fe1c-1124ea5d9de6@opensource.wdc.com>
 <5066441f-e265-ed64-fa39-f77a931ab998@acm.org>
 <275993f1-f9e8-e7a8-e901-2f7d3a6bb501@opensource.wdc.com>
 <e8324901-7c18-153f-b47f-112a394832bd@acm.org> <Y9Gd0eI1t8V61yzO@x1-carbon>
 <86de1e78-0ff2-be70-f592-673bce76e5ac@opensource.wdc.com>
In-Reply-To: <86de1e78-0ff2-be70-f592-673bce76e5ac@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR04MB6261:EE_|SN6PR04MB4077:EE_
x-ms-office365-filtering-correlation-id: 6ac29b8d-af02-456a-9590-08daffa4bdf8
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xA+YQ8VoRKR4+Ay+rnfIhn8DwU5aIWDGvSK/Yxe2aJpn3rzN0mUXI3HcLLv2qYVzTTxdwYqo0RIRAw0P4gwEL0EY16veUd0IFkfNHp02uwFduRomZRZKSn8CUfbSxGGAZVEuyVA4MfLM9nt3aZ2DQcTr5WwUIeu6zUAPA5mfHM3Fnwt921cpb3hGev/4aBuQ42VoJOc3RQ6tIyKues1wZGV4IJCy9AKlRjDVUgRbOZt0m53Wppk8WbuzQh0qDOysqZfsZLLWuCiA8YJo3Qx8m1ilNIJnE2ktGNflP7LQS4BEzpWPJxcid3BfdXWkB2V/pEGqwRKNa866/OeMlbDrkwWc8fCH4FajoL8rxUKdsuCjkDVsDy8uLcK6A72eseoNTld+uh3mmCRnurn/wtxk/vJauPsuN+I/dCRumhKlZcY13/qrYT86Rfnb9bDOzn9Wxf2DKgERK6Z3FlcDQhs1vECITrYrZcX9eceiUfOoYqPGHpuaqwiazw0OqW7OAZIn6IRpSHDOnsWmhgcd/fJe1yX35SSDKVs/J7ymXb1txoJ3sq7Jdxm0+4QNVizj5/x3DJNza9lFYdkKpcn6UjK+2abkDRyiJTfcGEuQ19zZo4gazASs1TaysWfYCmGklBYy+NdJHT4+9BEQAypCBBhSHybjTq6fL2tF/Jp3CzEA7wlerBIW2P5jy5zDg2hBcKju9x0MJSlCYoPt54nYZUWilA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB6261.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(366004)(136003)(346002)(39860400002)(376002)(396003)(451199018)(66899018)(91956017)(26005)(53546011)(6486002)(71200400001)(478600001)(66946007)(66556008)(316002)(76116006)(86362001)(2906002)(9686003)(6512007)(186003)(82960400001)(6506007)(83380400001)(33716001)(4326008)(41300700001)(8676002)(66446008)(54906003)(66476007)(38100700002)(64756008)(8936002)(122000001)(5660300002)(6862004)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nUb1Xs9ywzrkcprUlvMWDgc06uveS7NxTfwr4f2EIeCpDyDUNORDFMJ4RWim?=
 =?us-ascii?Q?Thpzk9IdDoHeFVSJXtDMpWCXEomZBCqUJM7BH4L6bt4KqGB+zOpJQzen2zDP?=
 =?us-ascii?Q?tMWvMNVRAwor3nBF41XXumH8UP+7ukGQNungNUD6UO7urhEKRXIjk58LreK9?=
 =?us-ascii?Q?fhVrT+N2dykmZmXYD6tr4mlLtElJbPXChx6x2BONJifkhMomI+CBsy3sEnbd?=
 =?us-ascii?Q?XnqnPAArgVvzjABxSRbpp9GT8pIX7o+DP2MpUUGHgKoAXlENRMeftG4OR1Ey?=
 =?us-ascii?Q?mVJcMkIucCp6MbBOaumclbEuud7Z6KWZVLYKOzW+lEFChEkQMlqHHSEJfdTj?=
 =?us-ascii?Q?Y8daRbTVZLtUsR9ZVup3++Oi2V6V6DrwG1ZkkCwNw5/kRhEEpIQzKXL3CCHe?=
 =?us-ascii?Q?hI7gA65fxzmpPmrkRx3cVGURIm8giLvrE7jDxGQkoJ+u8Gf+3dQ4r7my3CZD?=
 =?us-ascii?Q?etKe7SsuvhMjoxKxa9QmyZp+ckFN3C9NQFVB6Xb+3hKYpe12GROVkcX+MISd?=
 =?us-ascii?Q?5DQZxQppekWFsOf8nLZIa5/6zfGzHiOnnTV6BF11Xyg/XKh3MUvQ0fnLAFAx?=
 =?us-ascii?Q?FF9hTeqVg/DheE7ASi/QOmjbcTuwy1pgB0LfK4kI5gQcG0JW6bdsYPm6rZlR?=
 =?us-ascii?Q?2oTmvRkSWj7ibRJ3q9772ns5nl5Yfd/LjhQ2+hIPArm9LgXk4CHf1GqpRwcZ?=
 =?us-ascii?Q?W5XnPdG7+lhmqS7iiZygtCIPo63kodNkD2kXEGogiEtZB7goFcd2NXvltz2N?=
 =?us-ascii?Q?FtLcxfZOy3fLCHDnfuXaRqgM1y/PVpXo8Z4/YOpwol+rB1BTRSibP8zxBj0D?=
 =?us-ascii?Q?Q45BU7KtuBD/djHTKC4Qw6NLoP0ljoHzXbc6C7h5QQXay8epZBePn/iPvcX1?=
 =?us-ascii?Q?AhoLm5+dZOCkqJYoeqZflQQ9rE3iHB/Wa8m0AUhyuUIhNPNRhTPYlJn4r9FF?=
 =?us-ascii?Q?hvnAWREu2VfQpSIM6AhFiyGB3Oq5lA03WdlbIuXI5CU493L7UIMB1ryp9epW?=
 =?us-ascii?Q?yC5WP83hAdFonInVmOjmWPmnrGbfiLudqeehV2by1vqS8Laco0NoqkisHo0S?=
 =?us-ascii?Q?CN6pBBZjft16s7K6RFVhl/P6gESc1iU5tXcF4+wmPVE7jJ269xgaKSlI7+r9?=
 =?us-ascii?Q?q1AIk29Rj5NyRtjEhs4zPDdN8tdwyPffGhVPyE8cq5twSaxvUtWWEKWYBPpg?=
 =?us-ascii?Q?8rNrKV0BIxZgnldi6kVlUHjkewmIgeLLmvAAcF+NhH7eygB8aR6SINR0wc9O?=
 =?us-ascii?Q?kDoIOQ8crL3UYOMvSpq7m94FiONwYqgc0FvjWemjFhm/ntkoCGT61O3vVjoV?=
 =?us-ascii?Q?CWpiBrbXLnSuNTutpeLDK7FAlclgP9B+2EOBkF7gODV+1gU7Y25FfmLlNr1u?=
 =?us-ascii?Q?RtQGQRLJFwlOinqIvyIrQSwc9VJfOrRZXGuP/DN31DXkhtIG2Q9HOZ8tCYZ6?=
 =?us-ascii?Q?t5ol+6Szg0pMkyGpyJ8C2P3d4LC6wLcyS0OvP1SyzOxuUP8v6WhIZQSSjkeb?=
 =?us-ascii?Q?z0R4nSUdd1qSrHVb/ohGY2E5vnBLEf8lQzKkQWZTq2lgFQhlpVJ3J0RhEzD+?=
 =?us-ascii?Q?FtW9Jtp1ehwe3djRkymhy0mkW6bgl67Nws4XagS313W6SN5t5vbfbghU7gi3?=
 =?us-ascii?Q?pA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <35FC48D5A0660049A0E7179A5A6F18DF@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 6ftEgNXlQOqx+/+pMz4UCq/WJgBCmxsBDWmURSV2pAkLp0r6k1X5St/Qok15/BA9+lT/gEfU+ml4t0Q9x9M+79ztIR4K70LA/mc4q4j3SslQj8nTQMFX6M1mTGzkoeD2JieUGxXcURd+2p5QRCb7qO7RKdrUzdLwyv1SL3W/9o3fEmSXNxctQdcSIkH28YZz9IjPMb6zHfNBIzE0qkvIPJs538q0JZxsVjmAmswo4gKHQouuspGBdRqTb+8y4EyH47G/+KvCRRpkYobc5YMuCurw4tGlvPMHtBfF/+IgL1AgqPuuZa86pqcvmsCh+RIWi/JaG/I6W2h5mNoVdD5MNS1t+TJAEo9sy0MXnqGggt+d44hSRK2eXgKiCXgRinxLhK8fLS2djNmZIxza3ZxwSVGSlsoV3SbdcictknnVM/Orn08vDqqYHqMoz+kB3MYlzJQDth5kxBh3m2yjZw2Q67cl7gx3mSyMpjEx9g1UQ/NhNCu3y7+A54ViabrC266ciiUGA7xJgoTn3XRbY3d3fIRiuDfgueYtZ0kdnI2xQ9DnUfMW6DcEu+UdF9XfkFbZTua3wQOUzNDaLeIH/uJANwLNb0CNnk7/GKGDsABDBK5oxdq1SoU+o38kdZPcWtKxIiDDuH/MT2nFqppPzKzqfvLytu/9/7bRk/QmuY9Vbd9cKHJSX/DUrWp3ItnjOMcWPm6yCkGVZeSISz1RabDbIw0DJlwVVORe4C8tfHmrHVihoYfnJZ5oeCJW4cCnaqvXAxTxJcFaAcCezc3SBK22ZQmHT3LBsb1fxgF2PGp5PUus6iAuWIQT8jtIFmSJbL5QLaJjT6vSkldE8xEsQzGTyQ5l8Rt1x7eJ/mvAnkl9Ap2e7Ppu0GxmOD9dz0Tda/etuscXba/KsQavEmAo4FPWaw==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB6261.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ac29b8d-af02-456a-9590-08daffa4bdf8
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2023 13:53:45.3094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m3Tr3JhWk+hRy7LM7mBerTzEP+8BYjR14YDvtSkcLSfRfrkL5vQrvn2iNCEtZk8r0fBgsf5AnxaXKjNhlEkRWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4077
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jan 26, 2023 at 09:24:12AM +0900, Damien Le Moal wrote:
> On 2023/01/26 6:23, Niklas Cassel wrote:
> > On Wed, Jan 25, 2023 at 10:37:52AM -0800, Bart Van Assche wrote:

(snip)

> > If we were to reuse IOPRIO_CLASS_RT, then I guess the best option would=
 be
> > to have something like:
> >=20
> > $ cat /sys/block/sdX/device/rt_prio_backend
> > [none] ncq-prio cdl
>=20
> No need for this. We can keep the existing ncq_prio_enable and the propos=
ed
> duration_limits/enable sysfs attributes. The user cannot enable both at t=
he same
> time with our patches. So if the user enables ncq_prio_enable, then it wi=
ll get
> high priority NCQ commands mapping for any level of the RT class. If
> duration_limits/enable is set, then the user will get CDL scheduling of c=
ommands
> on the drive.
>=20
> But again, the difficulty with this overloading is that we *cannot* imple=
ment a
> solid level-based scheduling in IO schedulers because ordering the CDLs i=
n a
> meaningful way is impossible. So BFQ handling of the RT class would likel=
y not
> result in the most ideal scheduling (that would depend heavily on how the=
 CDL
> descriptors are defined on the drive). Hence my reluctance to overload th=
e RT
> class for CDL.

Well, if CDL were to reuse IOPRIO_CLASS_RT, then the user would either have=
 to
disable the IO scheduler, so that lower classdata levels wouldn't be priori=
tized
over higher classdata levels, or simply use an IO scheduler that does not c=
are
about the classdata level, e.g. mq-deadline.

From ionice man page:

-n, --classdata level
Specify the scheduling class data. This only has an effect if the class acc=
epts
an argument. For realtime and best-effort, 0-7 are valid data (priority lev=
els),
and 0 represents the highest priority level.


I guess it kind of made sense for NCQ priority to piggyback on IOPRIO_CLASS=
_RT,
since the only thing that libata has to do is to set singular the high prio=
 bit
(so the classdata could still be used for prioritizing IOs on the host side=
).

However, for CDL, things are not as simple as setting a single bit in the
command, because of all the different descriptors, so we must let the class=
data
represent the device side priority level, and not the host side priority le=
vel
(as we cannot have both, and I agree with you, it is very hard define an or=
der
between the descriptors.. e.g. should a 20 ms policy 0xf descriptor be rank=
ed
higher or lower than a 20 ms policy 0xd descriptor?).

It's best to let the definition for IOPRIO_CLASS_RT stay the way it always =
has,
0 represents the highest priority level, 7 the lowest priority level (and w=
e
wouldn't be able to change how the schedulers handle IOPRIO_CLASS_RT anyway=
).

If we update the man page with a IOPRIO_CLASS_DL entry, we could clearly st=
ate
that IO schedulers do not care about the classdata at all for IOPRIO_CLASS_=
DL
(and that the classdata is solely used to convey a priority state/index to =
the
device).

So I think this patch is good as it is.

Bart, do you agree? Any chance for a Reviewed-by?


Kind regards,
Niklas=
