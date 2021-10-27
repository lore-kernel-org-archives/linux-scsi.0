Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0756C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 02:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EE74610A1
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 02:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238541AbhJ0Csw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 22:48:52 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:42536 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238184AbhJ0Csv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2021 22:48:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635302787; x=1666838787;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=4CE7z+Xee3CazCnNjEh/PsY12ok7mn/5dG3bWbb0YU4=;
  b=Ks/tudgRtcuZdozuAkNC2KP2I0wn9MUJ7J6MqNPi0FKjT+9YF5NnpN4x
   A4epuj0fRQmsMiH71sfQHw5wk97klGW2/bPRHMv2KnJ2AGfPh9Di4bsNl
   Pp0ugDUCkfkzPBG6cOciKDAXCrfOmudp7/HRNmTs+uYJ67jlI2ucVB5AC
   e4u+gltQKAN//xTAJMwwlTwujhU6qh6JBPFIyiJ2QxeUwZCxonccKC+ms
   zbgVMgZUWFk+0uTeqoQqKtcKGaa+ijgonNosyUuQMTZ+FD+KhyhplkdZQ
   Od58zW3Gfq6fcMm3tl7cVWKJq4FHYjDiglxmKrnJlADHly1Uys9Lh/TuW
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,184,1631548800"; 
   d="scan'208";a="295669742"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2021 10:46:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hcceYThTo9zvX6Xx6LwB+XJuN1HbO6ESQ9I6P69hRLGpjtJ5dAfd1HkgTNj2Ldmjf0a4xpsG6HLv0DGuNnzhUMJBmfMjo3nWF3Gja84fl4ifTrjMjiXqYzQG0wCATDXhSaYWfgV8f69qP1+8RPEffh0iF/rcjQMw1drVk1gyf/kszIoFMuMViL9R+8Z+hxO++RMgmknzdTLTKqwk4U1xexjZ5YWrUpaRTjzwZP+xgUNXIzlJprrslmsUj1P3R+O6f35LmJazZqwUD6pAxnPL8t/Ek7/BagQEzKcIZpGxhcu8XY3ls15PHoaXMIQkjFBF7keC8GwaXEsx1dtI0aiPAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4CE7z+Xee3CazCnNjEh/PsY12ok7mn/5dG3bWbb0YU4=;
 b=gc2+z7155VP3uA/4mgYoXfSb0NuLYqkjtaN7VODF9QngRwUAg5jbBqK7nKCom9EhkNrZMDhjh6NgHsdWmlfQjwMzBfZqZdqMfD1PHNndB6JsSFCI1jU4qc4cUJ8yUKr7XMLIcwMebev67rW0ATC4672A6gTaunXlR2cZHM1KoiSpuck7lg6flBGsQ7/rAg4JauviFLSo3+Rvxqi0SLCm6wL8aihckdam451qeMsFya8FJUWj/Xryd+WZcxZGxo319jbQwt8WLx0Z0FdOcpyHZyVIpzPZG6bBY6x9kQvxY8I6isyf07PFOORtxIPMQSiybvz3aSIVlgW4SHFt0IbZsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4CE7z+Xee3CazCnNjEh/PsY12ok7mn/5dG3bWbb0YU4=;
 b=hGiB+yorjC9b9gPndJ+ZO13HVxsvxVKEWwpA4NFpXz7TnVaqgD+62lNyKKDJuyCCxKYrVAirOpVsUdsaFuuGLRpwU1hZjYgAmTgRXo0JKehpaT532sNnf5cjVr4ns/4rhFXWjSyYMM6WxgwspIaby8H1KYdN0cGIWjFpEyoJasY=
Received: from CH2PR04MB7078.namprd04.prod.outlook.com (2603:10b6:610:98::9)
 by CH2PR04MB6920.namprd04.prod.outlook.com (2603:10b6:610:91::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 02:46:24 +0000
Received: from CH2PR04MB7078.namprd04.prod.outlook.com
 ([fe80::a563:b049:4d85:6b35]) by CH2PR04MB7078.namprd04.prod.outlook.com
 ([fe80::a563:b049:4d85:6b35%3]) with mapi id 15.20.4649.014; Wed, 27 Oct 2021
 02:46:24 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v9 0/5] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v9 0/5] Initial support for multi-actuator HDDs
Thread-Index: AQHXytl/ihnWi6nd7EWMcej971tRpg==
Date:   Wed, 27 Oct 2021 02:46:24 +0000
Message-ID: <CH2PR04MB7078125DD9418A4B4410A485E7859@CH2PR04MB7078.namprd04.prod.outlook.com>
References: <20211027022223.183838-1-damien.lemoal@wdc.com>
 <cea34b2a-6835-d090-4f0c-3bf456a6ed00@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8547e48-71b2-429e-7a01-08d998f3f776
x-ms-traffictypediagnostic: CH2PR04MB6920:
x-microsoft-antispam-prvs: <CH2PR04MB69206D51A49245BA28D0D950E7859@CH2PR04MB6920.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uB/5UDFmTFI+83+Vn81Jc7T0ukCMkGrG4rQFJK1PPNRgpqkoJdjYVfZhak5VomAKNZ+1M3t/eSRrK7+3hFzUoNjMPp59vfdErbo6awTGF+15oUzXD8njOCGJzCzGHuYtebYS816H3w/p/koFLbwdUqXj9TZhrs1tXGgY3i8RSWPGIdfnf6leUwi7gZDJNnntmgrdrhpYWRXrHZanZSuk7sKPwLoRnKMopZQ/kx74RlKuK58PCL5VFvOW2YapxgUFjcfPoDzjUm9jQcuSOhTIbq7mGimESMRzoBq8ThLA69jjfyPc+1g29/sfAuSYdpLj7utFa9i8P9zsc+Cg/ctzBgEsTfMxrOsP4wRyn3cde9BVO7l1mFLjdiMopcm5hM84FQtokpTC5DK1qvfvYRTLcuObKHK2r64peNa99po9ygWGGxtr2wm2F8FoLkhB3wIy6E/vXVr4sglWkGc/LCARsQeMpFeP4GVQGD55VVSoWkqZF6qK3fImZQbSPrSSh6U0SHTPY987tj93wGBA1PZez4EtMM+lp3KYZzXLxm0G40ZLulTXuk4XrkAAFTmTh9C7N5oNMCPGVzFXLtIOejuaXylDYEpRzHzGRyxhHJG+VQgD2h5mBUWAmJpyrqDdu0UUBaFqJ+SFWQKp1FPzAXs3IHcI905Tar1U1fKRZAlRo4VzKWIn17SrdX5TiFlPBFuQmDCFXyNQXTff/1tHbef8sA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR04MB7078.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(122000001)(86362001)(66446008)(66946007)(91956017)(71200400001)(5660300002)(52536014)(186003)(66476007)(6506007)(26005)(55016002)(38100700002)(8936002)(316002)(53546011)(8676002)(82960400001)(9686003)(2906002)(7696005)(33656002)(508600001)(110136005)(64756008)(38070700005)(66556008)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aYZ01zyaZSex6WtjPPqTVjx9EyAygyNM6m3xet4lmWV+iEhmNlLl600XDlvI?=
 =?us-ascii?Q?1RdPKYuP3EmGR5QzxOnyWyhZdxbplT6JuxIUKTGbDA5V9rKO+kKh6Yf7UdPk?=
 =?us-ascii?Q?zWXSxgnPnbdow4LFpFM+/7UQmHQ8oed/SFNGg234lB+Q5e6FndNYYWZJKJeC?=
 =?us-ascii?Q?6Rs3sjqqJL83wSzAZYG1SU8StTzKwzExYkrq79rHD3ejT354EZhm7fbYcSLR?=
 =?us-ascii?Q?xQ2oUAL6bsBebz1mqy2Jv7Z6X/oriExBFMLfB13i+MWmiqPXFXHjN9ySfKd3?=
 =?us-ascii?Q?+YucZMzrzWVJtjaqPkVZFtTWGt9lld3hMb1ez8NHqzxqtCIC+EtTx9ulfvMK?=
 =?us-ascii?Q?9x4US0X03PPl6BvMBvf4w0fKeNa97xLf7Y8ssxJ1tqB6vdZBbUSNpp1ZJiOk?=
 =?us-ascii?Q?gy+bVBa1MuRLA39Tyofa+Ix996fSuc7dzs4XflCeHd8Ezs3Esxsb+WngKBig?=
 =?us-ascii?Q?tnS5BjrQCZbAkeAkD6BCybdeu+c/nMKPkCuipjz5CLyloU+0gc+yB1S5HWAb?=
 =?us-ascii?Q?Vcq2CgvKSuUTtrOaKA3YWYdpFfXyRQ+Vp8ir5ItIcS84l3mQeA8fNQXEvEoD?=
 =?us-ascii?Q?r54+QuebMB+2uy3Hlf323wXWHVqCSlCWf91bCzhzWv16bEVNrNGhcW5KjMGG?=
 =?us-ascii?Q?U6fCsnSHIfKr0jc7ST8fqC/Hy2t6eUnssU2U530IUYXU/huK3zHfyVZySmbj?=
 =?us-ascii?Q?75zyX2uy1mZMu9QlqzmpOrYcx11Vv/MpHsWO5YNNCiQq71mBDF7/0jVDg+HK?=
 =?us-ascii?Q?Rus/mH64f8LmgdVYHAEtukAVyjEB0WKE8n93/J0oNc0MH+MENCOATkQ/d3h8?=
 =?us-ascii?Q?Pu6Z5yRHHI03b1H9MUNvA1EYrQasufzEVS2ngXJpRm6UztJHfBGMYdWL9Qee?=
 =?us-ascii?Q?cNDj6pldGUcneyBsJnWkn5nZyuCznn3Xr7g+T7+Pax57wEBh6z+1oOsUsGoM?=
 =?us-ascii?Q?wof0yk9GNWfN2KDKisuJtaGB2aWRbRiafMKyjAV02nvz/KyjYUKEoeyDhsbZ?=
 =?us-ascii?Q?9echk6lF5NfW+EX8X9r2Iigxfqq2cZraOJ8aGM/5hjpSaWCdXSkXVObVaDyR?=
 =?us-ascii?Q?FIgwpcI/pKyMLCjbUudVTUkgqiQK9k5K7xi2PCslLD4aszF5NC++pQdbsrMk?=
 =?us-ascii?Q?dEgCHAHrdM2SeZa6V/BhuOqRNK8aH4vS5dLb+RXxfWUSCt/7z7/b5Bk2TZy7?=
 =?us-ascii?Q?s4YHmCZ1nkeMzAXfdxOblWgXg7R+Mr5JahKlcXnSiEfh39v8qd81tcrWsgle?=
 =?us-ascii?Q?LJb2OIlEr56jLvE+kTBF7brqpawL70vSd4tokpJowigBf2EgNNDw9lc/UKOc?=
 =?us-ascii?Q?vEfgJol/1QaLAHzf6McyWtjNJXeByLKcSMjvKg/F/qHFnux5JjkmxnhbuCRv?=
 =?us-ascii?Q?MUQlXxv3BaoCXgvIlDPqLEW+Cq06MjhCFXI2nvVQW8qFTyvu3wimvrmhSnhn?=
 =?us-ascii?Q?ja2MM4afkpSmYrYWjf0F5dmhZrn3Ah1rGSopeZK5Id/Z1T8VUeALXWWdQRLo?=
 =?us-ascii?Q?6LtytvQqJmA1kXzME42EtzLGCH0fx6onlxljfvEzuisdNdyuvBV89g7VNSmE?=
 =?us-ascii?Q?Sfz//9k2SzJibnJdBu7WaYSjqWrC9S2/z4bvfcABhOmu+2QJKD6Z1cC1JqB9?=
 =?us-ascii?Q?4qcU7c3AVex+2MYrijK3mnQ/OlqEAXikpMoHllZSeAnv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB7078.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8547e48-71b2-429e-7a01-08d998f3f776
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 02:46:24.4433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wap3RRbcJLGaVt3VnrfKtQo8oI6RyrbMQHPOi5+BJj7ZWbey66hicfauRV8mj2uuj9POh9d/hYGTo4eDeDEwXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6920
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/10/27 11:38, Jens Axboe wrote:=0A=
> On 10/26/21 8:22 PM, Damien Le Moal wrote:=0A=
>> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>=0A=
>>=0A=
>> Single LUN multi-actuator hard-disks are cappable to seek and execute=0A=
>> multiple commands in parallel. This capability is exposed to the host=0A=
>> using the Concurrent Positioning Ranges VPD page (SCSI) and Log (ATA).=
=0A=
>> Each positioning range describes the contiguous set of LBAs that an=0A=
>> actuator serves.=0A=
>>=0A=
>> This series adds support to the scsi disk driver to retreive this=0A=
>> information and advertize it to user space through sysfs. libata is=0A=
>> also modified to handle ATA drives.=0A=
>>=0A=
>> The first patch adds the block layer plumbing to expose concurrent=0A=
>> sector ranges of the device through sysfs as a sub-directory of the=0A=
>> device sysfs queue directory. Patch 2 and 3 add support to sd and=0A=
>> libata. Finally patch 4 documents the sysfs queue attributed changes.=0A=
>> Patch 5 fixes a typo in the document file (strictly speaking, not=0A=
>> related to this series).=0A=
>>=0A=
>> This series does not attempt in any way to optimize accesses to=0A=
>> multi-actuator devices (e.g. block IO schedulers or filesystems). This=
=0A=
>> initial support only exposes the independent access ranges information=
=0A=
>> to user space through sysfs.=0A=
> =0A=
> I've applied 1/9 for now, as that clearly belongs in the block tree.=0A=
> Might be the cleanest if SCSI does a post tree that depends on=0A=
> for-5.16/block. Or I can apply it all as they are reviewed. Let me=0A=
> know.=0A=
> =0A=
=0A=
Patch 4 & 5 are doc updates and I think they belong to the block tree too.=
=0A=
=0A=
Patch 3 applies cleanly to libata for-5.16 branch as is, so you can take it=
, or=0A=
I can take it in libata tree too, whichever works for me.=0A=
=0A=
As for patch 2, it applies cleanly to 5.16/scsi-queue so I guess you can ta=
ke it=0A=
too, but I will defer this decision to Martin.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
