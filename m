Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59205C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Dec 2020 19:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09BF022B2C
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Dec 2020 19:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgL1T0e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Dec 2020 14:26:34 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:58433 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727244AbgL1T0d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Dec 2020 14:26:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1609183591; x=1640719591;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2u8q3UzGod6Ca7TY/BEasUEJaRWH/+Ah2kEPP4bJvhM=;
  b=IZBKGDc7YCTaAgzWtagazzMe88Z8ZAZ8rGHbqBqZcyQzbEmMuOcEvAQ6
   /qSUHSSeNF5pghlvAoOFc0yPQ71cfR2Gztl1RNPYck6ctr0ngRyDCdR+E
   QZJsM49OxugD0+dhLi6HPpmnsQhWqIGicAMkMwwLktwvKCPWcngmFZwDw
   NZkm5ubQx/kFY1C8Ek6aK0wIfQD2T82KFk8upllq3MG0D7WPeL+u20ztV
   K/PRp5Gdkc7gQ1QQau4uqUEmeWZK3HLxTyRjzpcgO3nzSxcO0h8EsmiDH
   V0buYI99u5yA6jwHx53G29tQwr6hvTHK4G9EZp0z3lWggbZJKgTYPe5MH
   Q==;
IronPort-SDR: UEDteeuC/sTQ4460oq+MHNZBs8n1KrWxdorgDELU/DJAgck/oNbThRQn1aEwTfqojwpaITuMio
 iLrPvLzr7vZRhbvOKKy16BaLRn+6to/bhWQzVPN8pCHBrrIQKPTh+l026oeTQqDlRY/DQ2bxSw
 zsqgarxWWjVX8tVMw98UHUny6P4b8w7J778z8a4yD6bCWvdzO/jB+juWy/Sw2pWre3ncbhwZ+o
 s2/rLNDfB3TjPSJyBI9blK59cxMvrzgJYgTQaWBdZ5S2HmfLENwpWOnwZy/JHOR1yKtCphtjMU
 qQA=
X-IronPort-AV: E=Sophos;i="5.78,455,1599548400"; 
   d="scan'208";a="98440617"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Dec 2020 12:25:16 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 28 Dec 2020 12:25:15 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Mon, 28 Dec 2020 12:25:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDDq3gByKU76f/4vVyrw/Mwwen2yxHRI74n4RaLGyiiCtyqdQdamODKZhQeG8D4xcD8f8dvXo7D0EMRT9lhlBeT/cVKikM4B8ULN0vQ/2SBcBSJQwqe4qW6oyHloL+fncbBENnWgjrJ0TGaIP6O6KnnMHEiZLoaeRVyOwalXrS4utiAxYTfZF/1Djsvlv7vFgmyY7+QqKv2e7P7REXpfhAO1K3nX/S1nsWcMCo+vvQ56IcCVffEn1a2srqBSA7Du7HYoJHmq7jswuGEhryxa8HrA+E2DMIy0Zcpe88RvQm+rRIuMpdxQBus3pWcjk3rMgAqet1Khlo46Kfw+m6hSEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zR0eil9fi4TaCgBpPoV8gnQ2ULpFflPJWq3WqhoeE08=;
 b=M32CzM/vMl1bEeo4nGvUtOaieaOOwQ4LhaD3I7eW8yQejuRd9qRe5UmN0ztiUvGVZ4L63hJtvkZtIsy3/WPrpj8m/Ai6ZkjUGhQvzZGADTdns8roetdfttCdssTjW4jQo8l3VlZ/6OQvJ4sIukYQb7PPzrOwuahkt3bBWM2TNVa7wjoW/Bph77N9qbVvBlgGcvb2KasuT0E6QROT/K4YFOSu9+n3/DiapF2SdTpcD1g1vmHOLGPjUAiIh+zn0zT/a2a67Hu3/1dY2WNseIM9878sAUyz/HP+kTsLKn72A2hSJEUQ9KMZrdzCAziDEClssq8xMceQKHkwZdeSOBGhfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zR0eil9fi4TaCgBpPoV8gnQ2ULpFflPJWq3WqhoeE08=;
 b=EkzwQKRKCDcM9R4AjYdWnE1po760tiLTusNiX19nWu84tEV7wMs4VyCVaSXWS8qfQUpopsqejCbcwhmKsN/ow8RRXCJJLFyqBgsBjjzl+KQFJw5zhKmL347rR23NAV/X8gQUjjDgcX9wmikYRE9n0Os4TEHbFHZX7jIRnazE5W4=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB3006.namprd11.prod.outlook.com (2603:10b6:805:d1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.31; Mon, 28 Dec
 2020 19:25:14 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::b54c:9e32:8548:9855]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::b54c:9e32:8548:9855%2]) with mapi id 15.20.3700.031; Mon, 28 Dec 2020
 19:25:14 +0000
From:   <Don.Brace@microchip.com>
To:     <Don.Brace@microchip.com>, <buczek@molgen.mpg.de>,
        <Kevin.Barnett@microchip.com>, <Scott.Teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <Scott.Benesh@microchip.com>,
        <Gerry.Morong@microchip.com>, <Mahesh.Rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>, <it+linux@molgen.mpg.de>
Subject: RE: [PATCH V3 00/25] smartpqi updates
Thread-Topic: [PATCH V3 00/25] smartpqi updates
Thread-Index: AQHWzzSzGI7ouT8i+kC1pswzIdhAL6oBrZqAgACWNxSAAOZVgIAJl8zwgAA90RA=
Date:   Mon, 28 Dec 2020 19:25:13 +0000
Message-ID: <SN6PR11MB2848240CF95B791352737DEDE1D90@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
 <788f6ba0-2584-5109-0532-868e37e8f666@molgen.mpg.de>
 <SN6PR11MB2848D8C9DF9856A2B7AA69ACE1C00@SN6PR11MB2848.namprd11.prod.outlook.com>
 <6436abc3-7200-fb06-bd79-cb71f1fd1037@molgen.mpg.de>
 <SN6PR11MB2848F95706C20BFBBCCADFACE1D90@SN6PR11MB2848.namprd11.prod.outlook.com>
In-Reply-To: <SN6PR11MB2848F95706C20BFBBCCADFACE1D90@SN6PR11MB2848.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c02c7fb0-aad8-4827-0de0-08d8ab664d0c
x-ms-traffictypediagnostic: SN6PR11MB3006:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3006AA744F9B7029C0A6987FE1D90@SN6PR11MB3006.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DGEkZP5bDMz+g+t3ot5OK0Yyw/hw7YDY7gz8JImbfRwRhDFOvnDK9LzCLFtH/Mf1ZjbMoEmfyaqoxUJx8dI3EpZvT3o4BXsrHl6vkwn1TcwnzOsMwIC6OAndTrFi2XTl7pgE159mfw7qj9TuIZmhH9hBeKSr4V5FljbsUCFDzDxE5gh+OxABZ2WHJ5dCvrKjApy7yXsVdhCa1N0ojYvWVsLMjsYRkyT1fXr3jp6JIb+DJkcRvxrxb1q81Jnwq7ZI+qmtS3lLWMMiEaHkdgEc8BYN5nHdvpIZeqXAa2FwG/PeVNkd68GiKBiXmHfQwO//8UhYpItbZpMBmL41UeAOZtddCEFiEjIFXODLRCKyAB8o5WoYfHwSv/EiwbKDNvO9C0UaJ43E+w3Hi0dqkC3wyrscZykkM4RFo4q3W1kEe8tdlGnPjMnj5FAvcBcU3HZftYJsZcA2Uj84wGvJHM0at+Ngx+QXS0G3/0+IDGtCeU+J5RqnJtmZTr3EODcUSEJ2x9/JA0ObOM57F+CCjlnS9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(376002)(39860400002)(346002)(9686003)(186003)(5660300002)(83380400001)(478600001)(66476007)(966005)(55016002)(8676002)(54906003)(110136005)(316002)(71200400001)(7696005)(52536014)(76116006)(66446008)(66556008)(2940100002)(33656002)(64756008)(86362001)(6506007)(2906002)(15650500001)(8936002)(26005)(921005)(4326008)(66946007)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?BTb+WufCqrqTgx1G2F1s5bW+1GXOiOV6kvhSEX+AymwjKP+8krQlRkRe/q?=
 =?iso-8859-1?Q?uGRjN48PwapC79pUbEC1gpcbKoR3IsTAhIbbJhuWmUXvUxQUOKim34yxfU?=
 =?iso-8859-1?Q?H1UBNAggu6joEwllZgc7igxbjJ6Z2eCq9sLeoYfVfGs8rjHygslVDlX2B+?=
 =?iso-8859-1?Q?kbhihyd2vNVIbRMPVsaiGCgs/34Ud1Cm7irHH9Q/Hvnj3XPfcwa900y6dp?=
 =?iso-8859-1?Q?FfRWPYY33/csI8gVjlOmY3TKTZ77xUO68OnX7snAADJxBjVJ/MvwkjPdNK?=
 =?iso-8859-1?Q?O/f8BqzGcgCRkrzHdek2slFE9cEXsIb/3d/s1JjCC93Q5fJfWNmF1lFWl1?=
 =?iso-8859-1?Q?2TvFl5h5HoCxlAqxLBJQjlGMI5prSOeyVXYnf/WOcZFGnZRVKJpYhDzBvA?=
 =?iso-8859-1?Q?KVKTT8AVRlundwvCyqtrKEJRH1ScVeC91Je5mSprVn8Tcqs79wctqXyiID?=
 =?iso-8859-1?Q?Pz8qXlRVvBSRzMEziuNbMWMqwZFafsU85CocDkLsg5CXReTCOxHuFnBJOL?=
 =?iso-8859-1?Q?GC6VQzohnsGQJrJu2BLDgmc8DDDeb/IEEP0KnpHUt/jIXObj95dXIUjxL+?=
 =?iso-8859-1?Q?W6QSz2b+u1nIuy7Z2kjzLNzEiB+yBh6KAzF8VdsFqH0IeO9kZhug+mil2W?=
 =?iso-8859-1?Q?euBBmFOlQ6jfp4moLYfGRsGD5000smfHP4y+zk/J6ZC9D7IemltF1xEw+b?=
 =?iso-8859-1?Q?/M1IOAxow3qUgZw9OUuGSrmJf/fNaA0SG7P6QUnubDfD1bqojyz/SUXAHT?=
 =?iso-8859-1?Q?3EmvhQxllHdccG6gqhzP1WGVMi2BDHam2XHlIvFGJgB+AtSXw5cZ+UCUsE?=
 =?iso-8859-1?Q?Wa9DVazSoKue9VhwvT4fsMui0i6TdoRS7AGuod3W4bVGT3b3dH91gfmmgz?=
 =?iso-8859-1?Q?20gzYDp4dKcXeAUVdHNpu3kODD1eUBMZtbh0XNalCjZO/N4KjoLXnnIN37?=
 =?iso-8859-1?Q?CYRV45VLPHsKeQtqq3xXOBDqAYcT5wIzkqmDmVUUO+/a/s1e1M9vncxTxc?=
 =?iso-8859-1?Q?t2jSeA8NAgOQLie3g=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c02c7fb0-aad8-4827-0de0-08d8ab664d0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Dec 2020 19:25:13.8845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zXR9zYUl8tw2+fDhREr0Do5hjBOWDLxob9MY4ztZzareA67lN3VXIl7mQico1h/D6HJ9Wtwm2xxEV2W4VCdi6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3006
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Can you provide the base OS that you used to build the kernel.org kernel?

Thanks,
Don

-----Original Message-----
From: Don.Brace@microchip.com [mailto:Don.Brace@microchip.com]=20
Sent: Monday, December 28, 2020 9:58 AM
To: buczek@molgen.mpg.de; Kevin Barnett - C33748 <Kevin.Barnett@microchip.c=
om>; Scott Teel - C33730 <Scott.Teel@microchip.com>; Justin Lindley - C3371=
8 <Justin.Lindley@microchip.com>; Scott Benesh - C33703 <Scott.Benesh@micro=
chip.com>; Gerry Morong - C33720 <Gerry.Morong@microchip.com>; Mahesh Rajas=
hekhara - I30583 <Mahesh.Rajashekhara@microchip.com>; hch@infradead.org; je=
jb@linux.vnet.ibm.com; joseph.szczypek@hpe.com; POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org; it+linux@molgen.mpg.de
Subject: RE: [PATCH V3 00/25] smartpqi updates


Subject: Re: [PATCH V3 00/25] smartpqi updates

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

On 22.12.20 00:30, Don.Brace@microchip.com wrote:
> Can you please post your hw configuration and the stress load that you us=
ed? Was it fio?

Testsystem is a Dell PowerEdge R730. with two 10 core Intel=AE Xeon=AE Proc=
essor E5-2687W v3  and 200 GB memory.
Adapter is Adaptec HBA 1100-8e, Firmware 3.21 On it two AIC J3016-01 Enclos=
ures with 16 8TB disks each The disks of each jbod are a combined into a ra=
id6 software raid with xfs on it.
So I have two filesystems with ~100 TB ( 14 * 7.3 TB)

Unfortunately, for the time being, I was only able to reproduce this with a=
 very complex load setup with both, file system activity (two parallel `cp =
-a` of big directory trees on each filesystem) and switching on and of raid=
 scrubbing at the same time. I'm currently trigger the issue with less comp=
lex setups.

I'm not sure at all, whether this is really a problem of the smartpqi drive=
r. Its just the frozen inflight counter seem to hint in the direction of th=
e block layer.

Donald

>>Thanks for sharing your HW setup.
>>I will also setup a similar system. I have two scripts that I run against=
 the driver before I feel satisfied that it will hold up against extreme co=
nditions. One script performs a list of I/O stress tests (to all presented =
disks (LVs and HBAs): 1) mkfs {xfs, ext4}, 2) mount, 3) test using rsync, 4=
) fio using file system, 5) umount, 6) fsck, 7) fio to raw disk.

>>The other script continuously issues resets to all of the disks in parall=
el. Normally any issues will show up within 20 iterations of my scripts. I =
wait for 50K before I'm happy.

>>I have not tried layering in the dm driver, but that will be added to my =
tests. There have been a few patches added to both the block layer and dm d=
river recently.

>>Thanks again,
>>Don.



>
> Dear Don,
>
> just wanted to let you know that I've tested this series (plus the three =
Depends-on patches you mentioned) on top of Linux v5.10.1 with an Adaptec 1=
100-8e with fw 3.21.
>
> After three hours of heavy operation (including raid scrubbing!) the=20
> driver seems to have lost some requests for the md0 member disks
>
> This is the static picture after all activity has ceased:
>
>       root:deadbird:/scratch/local/# for f in /sys/devices/virtual/block/=
md?/md/rd*/block/inflight;do echo $f: $(cat $f);done
>       /sys/devices/virtual/block/md0/md/rd0/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd1/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd10/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd11/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd12/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd13/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd14/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd15/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd2/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd3/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd4/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd5/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd6/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd7/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd8/block/inflight: 1 0
>       /sys/devices/virtual/block/md0/md/rd9/block/inflight: 1 0
>       /sys/devices/virtual/block/md1/md/rd0/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd1/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd10/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd11/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd12/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd13/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd14/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd15/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd2/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd3/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd4/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd5/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd6/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd7/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd8/block/inflight: 0 0
>       /sys/devices/virtual/block/md1/md/rd9/block/inflight: 0 0
>
> Best
>     Donald
>
> On 10.12.20 21:34, Don Brace wrote:
>> These patches are based on Martin Peterson's 5.11/scsi-queue tree
>>
>> Note that these patches depend on the following three patches applied=20
>>to Martin Peterson's tree:
>>    https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
>>=A0=A0=A0 5.11/scsi-queue
>> Depends-on: 5443bdc4cc77 scsi: smartpqi: Update version to 1.2.16-012
>> Depends-on: 408bdd7e5845 scsi: smartpqi: Correct pqi_sas_smp_handler=20
>>busy condition
>> Depends-on: 1bdf6e934387 scsi: smartpqi: Correct driver removal with=20
>>HBA disks
>>
>> This set of changes consist of:
>>=A0=A0=A0 * Add support for newer controller hardware.
>>=A0=A0=A0=A0=A0 * Refactor AIO and s/g processing code. (No functional ch=
anges)
>>=A0=A0=A0=A0=A0 * Add write support for RAID 5/6/1 Raid bypass path (or a=
ccelerated I/O path).
>>=A0=A0=A0=A0=A0 * Add check for sequential streaming.
>>=A0=A0=A0=A0=A0 * Add in new PCI-IDs.
>>=A0=A0=A0 * Format changes to re-align with our in-house driver. (No=20
>>functional changes.)
>>=A0=A0=A0 * Correct some issues relating to suspend/hibernation/OFA/shutd=
own.
>>=A0=A0=A0=A0=A0 * Block I/O requests during these conditions.
>>=A0=A0=A0 * Add in qdepth limit check to limit outstanding commands.
>>=A0=A0=A0=A0=A0 to the max values supported by the controller.
>>=A0=A0=A0 * Correct some minor issues found during regression testing.
>>=A0=A0=A0 * Update the driver version.
>>
>> Changes since V1:
>>=A0=A0=A0 * Re-added 32bit calculations to correct i386 compile issues
>>=A0=A0=A0=A0=A0 to patch smartpqi-refactor-aio-submission-code
>>=A0=A0=A0=A0=A0 Reported-by: kernel test robot <lkp@intel.com>
>>     =20
>>https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/VM
>>BBGGGE5446SVEOQBRCKBTRRWTSH4AB/
>>
>> Changes since V2:
>>=A0=A0=A0 * Added 32bit division to correct i386 compile issues
>>=A0=A0=A0=A0=A0 to patch smartpqi-add-support-for-raid5-and-raid6-writes
>>=A0=A0=A0=A0=A0 Reported-by: kernel test robot <lkp@intel.com>
>>     =20
>>https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/ZC
>>XJJDGPPTTXLZCSCGWEY6VXPRB3IFOQ/
>>
>> ---
>>
>> Don Brace (7):
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: refactor aio submission code
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: refactor build sg list code
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: add support for raid5 and raid6 writes
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: add support for raid1 writes
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: add stream detection
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: add host level stream detection enable
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: update version to 2.1.6-005
>>
>> Kevin Barnett (14):
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: add support for product id
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: add support for BMIC sense feature cmd an=
d feature=20
>>bits
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: update AIO Sub Page 0x02 support
>>=A0=A0=A0=A0=A0=A0  smartpqi: add support for long firmware version
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: align code with oob driver
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: enable support for NVMe encryption
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: disable write_same for nvme hba disks
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: fix driver synchronization issues
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: convert snprintf to scnprintf
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: change timing of release of QRM memory du=
ring OFA
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: return busy indication for IOCTLs when of=
a is active
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: add additional logging for LUN resets
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: correct system hangs when resuming from h=
ibernation
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: add new pci ids
>>
>> Mahesh Rajashekhara (1):
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: fix host qdepth limit
>>
>> Murthy Bhat (3):
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: add phy id support for the physical drive=
s
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: update sas initiator_port_protocols and=20
>>target_port_protocols
>>=A0=A0=A0=A0=A0=A0=A0 smartpqi: update enclosure identifier in sysf
>>
>>
>>=A0=A0 drivers/scsi/smartpqi/smartpqi.h              |=A0 301 +-
>>=A0=A0 drivers/scsi/smartpqi/smartpqi_init.c         | 3123 ++++++++++---=
----
>>=A0=A0 .../scsi/smartpqi/smartpqi_sas_transport.c    |=A0=A0 39 +-
>>=A0=A0 drivers/scsi/smartpqi/smartpqi_sis.c          |=A0=A0=A0 4 +-
>>=A0=A0 4 files changed, 2189 insertions(+), 1278 deletions(-)
>>
>
> --
> Donald Buczek
> buczek@molgen.mpg.de
> Tel: +49 30 8413 1433

--
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
