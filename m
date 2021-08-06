Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2F1C4320A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 04:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21189611C5
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 04:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235416AbhHFEFt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 00:05:49 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:29579 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbhHFEFs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 00:05:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628222731; x=1659758731;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=aNefl16S5+RvnY/HSV9TuUOkCyVSAoWIY3Vz4/FjyKM=;
  b=A9nxARjzeBw/3oIfk+NqdX6KZwUr4+mbwBaxSi8IMBfmWPHnIg/Npq2A
   coiwWNiAVBY5RUAm1yzZ48r9yDijKEbjCxZAq+8EXNPfgLgRJpfyG/lOV
   m90EpitLbLGvuUsIF0aBReUZuYbwvwIcMi14jdApX75J0djATmkfmbLkJ
   DJHmDzmmrGoYMIrRExwkuNOSkneXREiSPIFXMYFUpjO0Mv2UiNqeP4Cl6
   3+ZxSfQ4Sc2HQvKsi6FF3X/la5xyTfo6iUY5wdk92hSMn1xcVFCnMo46e
   77VgtNEFJmeOoIgBrJvlu41TqTedgnhmXxBD0F22rvAX6fRAuTR7W99z6
   A==;
X-IronPort-AV: E=Sophos;i="5.84,299,1620662400"; 
   d="scan'208";a="181281151"
Received: from mail-bn7nam10lp2108.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.108])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 12:05:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndcUQ1k8mabQO6HeqscY6emTIPRh2uB85FA9kyqpIcW6x2fhyik0cSL23cdCbiHylW344M4iy25KFWZbMPVWBK3Y+oAvoGdVMXIyzSLVgd/FrWBP6OZrjsHrGe88bK9iF66MV/eXhZUFBfWzvMZ/a23UksGOIcQs7QTYdqMsEZFVejd+23JdAgjPngO+q+4x8wp9BUizdP/J8/Xdhyh0cLFGh9+HwI7YuItAPVfR5UdOxxJnuSNGJNTEf5SPRu89CNS/Qm7TAX05prvKUr5GT6iLlijuo8DCM1rGS9cFErHJ33Q/J/q15/f0tgFZpA6Pa3QxTKk3Uh28XusQiXVw0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNefl16S5+RvnY/HSV9TuUOkCyVSAoWIY3Vz4/FjyKM=;
 b=HNQPpBlLZSTrepxn75xvPCPC2hV5v1bbRkHdrFnowdWGU74rO+aqtK2apwVqacbwTIh/9S3RW9SsqLPM6QoxGIajrnjeYL/19txfaeQHDjGqMe4LDYG+vd33A902+3TZKcsCwtHohwDBx0Pricw4iIKrP33hDpCmpbQmjj7EbbiRG1C90G/1oZUppFS1tdwEyYy2zxhw0OZmWjTSbWnYSZTKZN+Enhs9SME74Ucuq0tQmUVW+L0ZtYESdhnKMYo8fsp3bf3wr+hMzin2ZNCIxP+Iptw9ItnsmQvQGyzDOumwPdRR7Fl++w4sd0S0Hmbvhb9X/zR/lbeQ+ca/h3awVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNefl16S5+RvnY/HSV9TuUOkCyVSAoWIY3Vz4/FjyKM=;
 b=te7c2ncUpqaL0x4I2x2OwNMivKVtX1U2WUppNQ+e2wQWDir7Ldfkj8M2zrjQsvH6aII2r4HvbITZCD5XZs5P58Zvb3Jeh/Py9F63HH0G/H63XOmjBjpqXKy0CbBxpGZL+vumyYd2SIOacM9O02O/7GzDgnb7Mq3115r8a3ySX64=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB6395.namprd04.prod.outlook.com (2603:10b6:5:1f2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Fri, 6 Aug
 2021 04:05:31 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%7]) with mapi id 15.20.4394.018; Fri, 6 Aug 2021
 04:05:31 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 0/4] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v3 0/4] Initial support for multi-actuator HDDs
Thread-Index: AQHXgb7nBT0SP/zb8kqWuIxTGXvQIg==
Date:   Fri, 6 Aug 2021 04:05:30 +0000
Message-ID: <DM6PR04MB7081398426CA28606DC39491E7F39@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210726013806.84815-1-damien.lemoal@wdc.com>
 <yq18s1ffdz7.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94943ed2-d234-4d20-2b79-08d9588f6ebe
x-ms-traffictypediagnostic: DM6PR04MB6395:
x-microsoft-antispam-prvs: <DM6PR04MB639554D99826934B72C28738E7F39@DM6PR04MB6395.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vod7nwOL+urW5iKb3dyQl6c5JDRCfFoOemWGRKcGxamXpe91GXQ9DcYJ6jB/tS52oMfJuR9JKPVb+z1LA6tIK2+nb2qohC7E2S4jcn1fKTTZ3KqoU6lCoCWteGtD8rpORBN2gY3LO/oGVnboseCfYyTZNMKoeHp0oGuo70iP6bXBZ6Ltu0HTc64GlPO8LlqtGQBY5VqvDCl+ddt/1iyzZArUotwclzDv0UyEJ8ORfS57LFWv1speBGE320KGJa21fBM8frzXcSCAQkaGr7+xAgOuxYE90LnQmdRXlHxG8ZM+vIpxVurcQtDYI0sqMdnynMlrn9ve0G/thGbekXOmol9Wuya7WqE2k+Tfyn9tovFSxBfRZwe3QrXvB5fWbWE3v2FiWwy6kCKFCT8UanFhN+CpsKEOTG7/E/1519ZknYXG7GcfdyicdDvaF4Pgkdn+c6de5yfc870tf3KCgNI7UJdnpTB0E1RfwrzW45izmO39WtsM2jzuBhtrJIlJAxGMZT4GtuDnUD2Yva3VBikcHb3F2iwuzENWOWt5ndFUFErsWMlSSLUInbi1A5zEHtmJJgdv8JAYh/l6IJ9QPMNZi6MPyMpJgyB0Vq+sh+1r6SysONndNaO4NRLcKkCe93e48tENYmJTloSjompMRAVKYjJwx9Bs53VxILQI4rKI0YA0Ps+LY8MWYi6YJFNg+66xrLVADcAt1CQyNKcPKg2ncQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(4326008)(6506007)(38100700002)(122000001)(53546011)(316002)(478600001)(7696005)(186003)(52536014)(8936002)(64756008)(76116006)(66556008)(54906003)(91956017)(83380400001)(2906002)(66946007)(66476007)(66446008)(71200400001)(38070700005)(9686003)(86362001)(5660300002)(8676002)(33656002)(6916009)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+k83HKj5+uGoU/NPzudiXCr4rou99e78hAGrIsQC5b2zMkm7L0XFTEcFOLzx?=
 =?us-ascii?Q?4uFm5l1WcV/IJy4oYiylgDbM48lP4vTEw7vnIftGNixF+M1SVLj47kaqTdAK?=
 =?us-ascii?Q?rtemuKhYTzjLLaHeydVGv1K0Z42MpFjkyFA4bLfsKuaSAIXP1DFoqYgJEW51?=
 =?us-ascii?Q?bX1jSfBjrHZcCIYZrQJYBJ4urhdAfidckbmyfmUlcnPCLrCWp3C2qgySYjEC?=
 =?us-ascii?Q?+JXxc60+2LD+lZU/FatlOhmIrurZ+x0Qvy8/7E0APfXHY1lo/g/sJxUDuLFM?=
 =?us-ascii?Q?iAJ8wZQFJTBGbrCf2zOWjWj9llhXSo2ywSZTrMnO2AD/TLSFmqEPfdZN9W0A?=
 =?us-ascii?Q?QcNC8DNqPyKE9RuUHq8UarQbE+usCFZtV1/3OJ6GM5DgK7FJhGsg6kCUSjvH?=
 =?us-ascii?Q?hgHinSyHqFzNRMCa5+ZTTwODb/DLwRTyjIa3coHwfNlC7he9r4Vs6QfM5gKu?=
 =?us-ascii?Q?s3UWA+ZGUK2kcbCLiMj87KwmwkTs/8Uxd+JkWGdjFoL11McVIMhzqmbzZ8BV?=
 =?us-ascii?Q?lLhZmKue21kaMotk1+OtZehIvHt/yBXAqkPDnHgYow+wFYJ0jyPZyulm6nOl?=
 =?us-ascii?Q?8nhePkD2hV+F8JmvS3Nl4Fv4qoRBZK1wbsfdmqjruv2hyI+aON19vYiPIEOg?=
 =?us-ascii?Q?ht+DgO2/w+6bS4iXxAWazVPse8dRbQD8b5Q8Qd5OC3c4RrbLByCEPGRNdR8U?=
 =?us-ascii?Q?9xblV5lYXg4i5Swsf2QtsKnOB24BVzYtAD5sOA5f33woqzdZUF4hliAMrMpi?=
 =?us-ascii?Q?/avuFSSuYLzrJBWIpp6EpkUXjux5nBmL51N77nEsdg56DJOTIrhn0XLjmm11?=
 =?us-ascii?Q?fVQ74nHouVC1sjNEfWBGepjs4XUOsvAMbJn3E3pG9v6BAxNhgkNaEhAC6ULm?=
 =?us-ascii?Q?V0iYh7ennHjvfwXsmfK1S1ueDbnVOuq/+ozOicXADE1ca/ERiY82UqhkFuTN?=
 =?us-ascii?Q?Hs+JCIuRZJjkTz4VhTG3cmqpKqUbyLx3HOXeZW/mZiqJjOzZ3g46v3rZmwgs?=
 =?us-ascii?Q?BaOQR0ShAREQLyBkuT6ugAD0w76YoOdqZcJXNaYLnzp8YBIAvvUHazG9BZ2Z?=
 =?us-ascii?Q?VE78fy/gjXN8+0twt1BVtUXhXPFo2M5yPSYMZ+UUjI6LVOPMW1MJHRnuozHm?=
 =?us-ascii?Q?Hh5+LNZjMUUlfTqUWax98Dyska++IyBlZBYqcZsSqP4KUO6NOB2dDZGhAVMp?=
 =?us-ascii?Q?U3INrnERg23ZyzSu0bywhBdhui7PiS7jvuMVZEKSY1Bi3r7/KMMWYgSggb0B?=
 =?us-ascii?Q?i7j+ILPKTdiafabz+ZSwTxJEpvH6jx1EzFjPIpAvyF/b3YNFfEVDCG6g/84W?=
 =?us-ascii?Q?OH+//BUl6wEPRGBG0JtCrBpXNW9xNSY+PJ+tl+gqmWGtUs/aF7K+6jKI8Qzk?=
 =?us-ascii?Q?5Gjw7bVYaZnaJSNb5TylRtn3TW5ppsS84rDG47+SlyoEGgaK5Q=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94943ed2-d234-4d20-2b79-08d9588f6ebe
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2021 04:05:30.9656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +wYXlJ9rVDMDyNwu9kl/PtwgJJWeZNpSh/ax1IHFySInMX6+sKflwkeIkQH4pJddLcwO1Fc0DHbDLfO2EXV9Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6395
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/06 12:42, Martin K. Petersen wrote:=0A=
> =0A=
> Damien,=0A=
> =0A=
>> Single LUN multi-actuator hard-disks are cappable to seek and execute=0A=
>> multiple commands in parallel. This capability is exposed to the host=0A=
>> using the Concurrent Positioning Ranges VPD page (SCSI) and Log (ATA).=
=0A=
>> Each positioning range describes the contiguous set of LBAs that an=0A=
>> actuator serves.=0A=
> =0A=
> I have to say that I prefer the multi-LUN model.=0A=
=0A=
It is certainly easier: nothing to do :)=0A=
SATA, as usual, makes things harder...=0A=
=0A=
> =0A=
>> The first patch adds the block layer plumbing to expose concurrent=0A=
>> sector ranges of the device through sysfs as a sub-directory of the=0A=
>> device sysfs queue directory.=0A=
> =0A=
> So how do you envision this range reporting should work when putting=0A=
> DM/MD on top of a multi-actuator disk?=0A=
=0A=
The ranges are attached to the device request queue. So the DM/MD target dr=
iver=0A=
can use that information from the underlying devices for whatever possible=
=0A=
optimization. For the logical device exposed by the target driver, the rang=
es=0A=
are not limits so they are not inherited. As is, right now, DM target devic=
es=0A=
will not show any range information for the logical devices they create, ev=
en if=0A=
the underlying devices have multiple ranges.=0A=
=0A=
The DM/MD target driver is free to set any range information pertinent to t=
he=0A=
target. E.g. dm-liear could set the range information corresponding to sect=
or=0A=
chunks from different devices used to build the dm-linear device.=0A=
=0A=
> And even without multi-actuator drives, how would you express concurrent=
=0A=
> ranges on a DM/MD device sitting on top of a several single-actuator=0A=
> devices?=0A=
=0A=
Similar comment as above: it is up to the DM/MD target driver to decide if =
range=0A=
information can be useful. For dm-linear, there are obvious cases where it =
is.=0A=
Ex: 2 single actuator drives concatenated together can generate 2 ranges=0A=
similarly to a real split-actuator disk. Expressing the chunks of a dm-line=
ar=0A=
setup as ranges may not always be possible though, that is, if we keep the=
=0A=
assumption that a range is independent from others in terms of command=0A=
execution. Ex: a dm-linear setup that shuffles a drive LBA mapping (high to=
 low=0A=
and low to high) has no business showing sector ranges.=0A=
=0A=
> While I appreciate that it is easy to just export what the hardware=0A=
> reports in sysfs, I also think we should consider how filesystems would=
=0A=
> use that information. And how things would work outside of the simple=0A=
> fs-on-top-of-multi-actuator-drive case.=0A=
=0A=
Without any change anywhere in existing code (kernel and applications using=
 raw=0A=
disk accesses), things will just work as is. The multi/split actuator drive=
 will=0A=
behave as a single actuator drive, even for commands spanning range boundar=
ies.=0A=
Your guess on potential IOPS gains is as good as mine in this case. Perform=
ance=0A=
will totally depend on the workload but will not be worse than an equivalen=
t=0A=
single actuator disk.=0A=
=0A=
FS block allocators can definitely use the range information to distribute=
=0A=
writes among actuators. For reads, well, gains will depend on the workload,=
=0A=
obviously, but optimizations at the block IO scheduler level can improve th=
ings=0A=
too, especially if the drive is being used at a QD beyond its capability (t=
hat=0A=
is, requests are accumulated in the IO scheduler).=0A=
=0A=
Similar write optimization can be achieved by applications using block devi=
ce=0A=
files directly. This series is intended for this case for now. FS and bloc =
IO=0A=
scheduler optimization can be added later.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
