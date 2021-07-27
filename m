Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C8FC432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 23:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C51DC60F9B
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 23:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbhG0Xo5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 19:44:57 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:40885 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbhG0Xo4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jul 2021 19:44:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627429496; x=1658965496;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=YcpkloCzeKvH1lebKlzpEDVt4AkOjR1sLDkQ0TheegI=;
  b=E/7gp7AVXGnC3a5D01a2XPnPL5srPbfcmjgVhAhkqKJA9MZW3kl3MBLQ
   lL/2wepWR+idpWqIRlQOgSSm76Gpmrl90HSpnAs+46aVjrA7/2FIvqrjE
   vYu4+ctK6GC0TE0C9fzgtAj4t2//tYnOPFor8wbe7I0Uzp60Qf8C8WC4I
   vkR92192r0Bzyut7uAPKpyBEDsFzHV43D2UD9kAX5d3MZpMuVmbVcMY2h
   bdP1XwfQZrAYGptQ4hhDdRlS5KUVCI8GQwckNLosHvJY6lnFcIjQGlNlC
   gGSSXh61UCmAQg5V/Hku7MFZdFoaBV/rto+cQkVLJkLhSO+iOsht8Zv8Q
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,275,1620662400"; 
   d="scan'208";a="174861160"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jul 2021 07:44:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVNmxuqd56YjEn+qZThoKgNAI2s51u70TV0omvZ+XrIWfHrrSQxQnRqUe8w1+3k/MhQa5TMSOKOs+QclNWBLzCf107du616quJNlRa202p5htmdbRTQGHjD3isgIypWXYmRzb15r50/r6eJHIzR5BKtryiO7TZ4oFttOJmn6jbrSvV6aByj5cm+TYg0q9FPGpFbkncza7yKnzZ0bk6+4ODBc6MmIGNfhASUrFDnGHeT/vc94RdOxnSXpX8o3hI9PTq62h1sy9LMEc+ShYgqWQKQxumuWo8aS6QR8CIfxEWO81MNZ2pxizpAzRvZNclaSJm8xyQJv3X0nYPVmdscLTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j54Hiynt2qtlLg3ABqnrCZrcs27KbxiqpOXt17dukVg=;
 b=CQTZS09c3WWvEH7qennKgGIlRW6yfZO8LF2dQCuf6T4wvTNk9es7ySdyeecP2eK8waFXnAX7DwaGdsVsvA3UWHbtaLlpi6T2x6+6TcKZD8H+lPmIbQ82IWBxnDAAg2cYP9J+6us6CvE93GF4+EVp1wjifO4NOs4UydE8nKe17VyEmYT6XONm4bJVh8iOc3YukUUJBWioBtWrncBWqXGL08PGzNJ6CA0WMPFpsEJ+8SS6UvtXSf4j1783E/WWY0+ixU3H+xGJR3v6Oris6xO1cn9IOnuFi/Pmr3AXMuFFLBKfCgR6/1670/p134IntSb9hhUDe8CL0ly2YR3yaJFGXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j54Hiynt2qtlLg3ABqnrCZrcs27KbxiqpOXt17dukVg=;
 b=t6lCJHFJRmbB9W+U6OUBGCT7DTcSF++Bdkk+ueGZsVAro4v/8sTuvLs16uHZ7lBsPp9/JCkexYvvvr0BSgGiUHUx5SUE0xooPaOwkSUDRACH7LYNH2S/4U1UbNO86eu+N3hJeVOKre/vTrIbyq6hgdIXZUTagy8jx+cjL2aRfCM=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM5PR04MB0666.namprd04.prod.outlook.com (2603:10b6:3:f6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Tue, 27 Jul
 2021 23:44:54 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::44e6:14cc:4aab:3028]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::44e6:14cc:4aab:3028%9]) with mapi id 15.20.4373.018; Tue, 27 Jul 2021
 23:44:54 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Paolo Valente <paolo.valente@linaro.org>
CC:     Hannes Reinecke <hare@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] block: Add concurrent positioning ranges support
Thread-Topic: [PATCH v3 1/4] block: Add concurrent positioning ranges support
Thread-Index: AQHXgb7rfkYo5fvxW0aRSzaXyXSWfA==
Date:   Tue, 27 Jul 2021 23:44:54 +0000
Message-ID: <DM6PR04MB7081D6168AF0E59D4EC33011E7E99@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210726013806.84815-1-damien.lemoal@wdc.com>
 <20210726013806.84815-2-damien.lemoal@wdc.com>
 <751621a5-a35b-c799-439c-8982433a6be5@suse.de>
 <DM6PR04MB7081141B64D9501BDA876433E7E89@DM6PR04MB7081.namprd04.prod.outlook.com>
 <0ec2ea13-208f-1a5e-7b11-37317b5e56b8@suse.de>
 <DM6PR04MB7081B7619AAD7EB4236DACA8E7E89@DM6PR04MB7081.namprd04.prod.outlook.com>
 <F59D5B88-5CEF-4A61-A8AC-9FF572A462DC@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39a5fe03-5591-40e1-9f72-08d9515888ab
x-ms-traffictypediagnostic: DM5PR04MB0666:
x-microsoft-antispam-prvs: <DM5PR04MB0666B11CB4FA731F69983ABDE7E99@DM5PR04MB0666.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VEdSVwKbECV1sZRZJsIsSaI8UjEclJgzF2wjSBq7PSuebyxRLQil9sB7Gwot5tUGIOa/0K5zUsSizTiJyUCn4Vspwqqg/b3HyLsvn48rjjNXuciVatjxpeT8CKngTBiyaqo2iHJ8qg92RkcLR+HsgnPWhPBmlx7/jprazfwteU0PtPDDzBOYKWc8ubmqWOJWWiJrSMSIAwx7qj8vz3rN2sWLLrHTuWl9uTtVKxRFBA2sMwUZAo+Ud6izVqrYcGGrMMXrVMXAaIjComOMxts4NqkP/7UKTYYoy8xMVZwhb//UU4KcZ8UsEhKVkXvb5huaGIM5WFOL5zrsdpUS6AHHjjrfA3indidKkcM24GDYRSJHTcXzIisjPepCyBeqDVbycDut5TT/ZD6gLszKkKctolkAxAEJXnlXKYypVakjfxebJi7QWgbWDgjr6045Jl7SxaeK30h2op7BWhPbYHBo7DJjhSNya0Wv+yXBLFUQlnrhm73ZPgVbvGP0P/wgNatuZlrvncynyz+eT+yqB6LJo+H8Qup0XJ0cIuOz4YfGG7zpm5G2vDTroCRlMFjBH0MP4D+vNz8PbVBHwOr/OkpzX8hvbC8qrFpj/pND4t7lswF79UZeSE42vVYoDfEOlcQi+cFUvBhx5WN0ysQZs/qd1XBBGBW4Tga6WIijEG5DTxxD3498+Tmq5OxsjOc5G0zIctUEGbALsU1Os+rfUhF1jw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(396003)(376002)(136003)(9686003)(186003)(52536014)(7696005)(76116006)(6916009)(316002)(8676002)(55016002)(5660300002)(71200400001)(38100700002)(122000001)(91956017)(478600001)(66446008)(66946007)(83380400001)(2906002)(53546011)(4326008)(33656002)(54906003)(6506007)(66476007)(64756008)(38070700005)(86362001)(8936002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/s9TcCQ/fL3hvCxpqcwtZ3zsLZTkuiqhOF6QX35iKDSAgwbSCwgSkeV0yA3t?=
 =?us-ascii?Q?OFSToRnPh4R3RLegO8zLYlHFfPgJD8by17clkDU6AzX48irsjc67C7lZAo8B?=
 =?us-ascii?Q?yR9H0ZyJfyUadWukDx6vCtkh/D1w1nHRq1UECFT87yJOusOjQo7ShO6W81eP?=
 =?us-ascii?Q?MZgHF4v8OsR8vJNjp32LtohddCjGhf0Jpb4pjlUv3s/nnuwCa+QDwqmSpw8K?=
 =?us-ascii?Q?+nqse6TuWQ+JRMYFwf4u6lWrpLVqx8mldzyUlkcspNy+BvFf+I0LwhcLZNtx?=
 =?us-ascii?Q?EkZij4d/JaHKVVYJ0rxuJSbC/yW5WtAe2Ruvqyc/ieQdm6uVi3oCEackpq1c?=
 =?us-ascii?Q?g1TtS0OFST04nglfmDAMGBwiymEScIpZRVaglXUq5S47BdzkY8XARP1TJZ8/?=
 =?us-ascii?Q?vc9a6HO/iSNabMj2MekpR47TKujV7GiyweuooG6TG8XVSNI/T/QGChLtrWgm?=
 =?us-ascii?Q?qws3W7vWUADhPF+tqXB+1F5G7iHG2SwTLTKoSgHxQFH4XwYJUymBr4DKxPjq?=
 =?us-ascii?Q?0BUfOuhH0/Nm1C+wQGKOfFb+AQ9V+0d7WNHDQONdigFzzM0zomiAT7ihM8bp?=
 =?us-ascii?Q?2qeUkaQLaSilGG64iejlP/pJBN1VFeryzatXuL64V0in/ngJ411vbHSpR7n3?=
 =?us-ascii?Q?llE3LMSbREtYWUp1f2CZk59NfR4N1T/gBsz/V51mlbAf3i3WNC6DaH1Nx4YZ?=
 =?us-ascii?Q?nTbVUDIuD9fEvSr06KtRGzebB8qGzGartmWn+eSyC+i4Uh04amuWQC6uBbaZ?=
 =?us-ascii?Q?8CvtHE62hD1cdqzuQjydPHzwfm41z5SSKaGXLp/iOAs7IQXmbEq2c2rTWBt/?=
 =?us-ascii?Q?GqqTzu7WDbkwz8UHuYUYdMCEBavdJAvuZIxptVfGeql2vEegcnw1TM9krbxs?=
 =?us-ascii?Q?Ai9Uxo34lRdPqjbRUmQcdjZ0Szd+6l8IrK/9vJzQKsGpzEjRmeHCmfR8+4UG?=
 =?us-ascii?Q?IAAPd/lUNvhvnX/y8ZA1FEK5WeDNpwwnAeKdJiviWCEYjZqtQIhh0sbODE0n?=
 =?us-ascii?Q?NvnXfZiLv/gP50wZfjiECgBZ2u2pcyzo0Qxytl67yqDR1JQhm1oEdMvo+WUm?=
 =?us-ascii?Q?/pHLTBP4yCxjkVqXLRjSFo3HW1oiMCHog7Okra7eUu2lUwLAF2M7slxW5PZb?=
 =?us-ascii?Q?D6H5GBujwO1jCMy4rFujk6o5VxKdTBi7s/BP74of3EWmmNyabU+UBQtLc9Jd?=
 =?us-ascii?Q?LoYM0uPpU19LdEBu0xaEkmqRiUoeW62avMBsiot62jpd8XdMNR7Z0ih0Lfur?=
 =?us-ascii?Q?/lL3CJ2NNWd7Ki+FZspTROEX2Y7dzfdsbIUQR5u1wKwWfLCgpNup8vT49jwy?=
 =?us-ascii?Q?F8qpeYUe5Nf9cULNXlmBAUaZyJGtHgcdqMRgD0lAwiANgAuNAgcmMlIiT3Bz?=
 =?us-ascii?Q?siOyc8LwevZI+NzWETPwsAeFgDRkbleGlf2oN4CmMTsTN6HC+A=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39a5fe03-5591-40e1-9f72-08d9515888ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2021 23:44:54.0381
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b2pVYofR2/un5KHXIerHbL7exBMQJS6yVHo3eUdYSTsU9uT/44IzvLBWFB6YT7tXGHlB8qH8lAcBlIXbdQq+8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0666
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/07/27 23:07, Paolo Valente wrote:=0A=
> =0A=
> =0A=
>> Il giorno 26 lug 2021, alle ore 13:33, Damien Le Moal <Damien.LeMoal@wdc=
.com> ha scritto:=0A=
>>=0A=
>> On 2021/07/26 17:47, Hannes Reinecke wrote:=0A=
>>> On 7/26/21 10:30 AM, Damien Le Moal wrote:=0A=
>>>> On 2021/07/26 16:34, Hannes Reinecke wrote:=0A=
>>> [ .. ]=0A=
>>>>> In principle it looks good, but what would be the appropriate action=
=0A=
>>>>> when invalid ranges are being detected during revalidation?=0A=
>>>>> The current code will leave the original ones intact, but I guess tha=
t's=0A=
>>>>> questionable as the current settings are most likely invalid.=0A=
>>>>=0A=
>>>> Nope. In that case, the old ranges are removed. In blk_queue_set_crang=
es(),=0A=
>>>> there is:=0A=
>>>>=0A=
>>>> +		if (!blk_check_ranges(disk, cr)) {=0A=
>>>> +			kfree(cr);=0A=
>>>> +			cr =3D NULL;=0A=
>>>> +			goto reg;=0A=
>>>> +		}=0A=
>>>>=0A=
>>>> So for incorrect ranges, we will register "NULL", so no ranges. The ol=
d ranges=0A=
>>>> are gone.=0A=
>>>>=0A=
>>>=0A=
>>> Right. So that's the first concern addressed.=0A=
>>=0A=
>> Not that at the scsi layer, if there is an error retrieving the ranges=
=0A=
>> informations, blk_queue_set_cranges(q, NULL) is called, so the same happ=
en: the=0A=
>> ranges set are removed and no range information will appear in sysfs.=0A=
>>=0A=
> =0A=
> As a very personal opinion, silent failures are often misleading when=0A=
> trying to understand what is going wrong in a system.  But I guess=0A=
> this is however the best option.=0A=
=0A=
Failure are not silent: error messages are printed and will be visible in d=
mesg.=0A=
=0A=
We can always completely ignore the drive and completely fail its initializ=
ation=0A=
in the case of a failed cranges initialization. But I find that rather extr=
eme=0A=
since the drive is supposed to work anyway, even without any access optimiz=
ation=0A=
for the multiple cranges case.=0A=
=0A=
> =0A=
> Thanks,=0A=
> Paolo=0A=
> =0A=
>>>=0A=
>>>>> I would vote for de-register the old ones and implement an error stat=
e=0A=
>>>>> (using an error pointer?); that would signal that there _are_ ranges,=
=0A=
>>>>> but we couldn't parse them properly.=0A=
>>>>> Hmm?=0A=
>>>>=0A=
>>>> With the current code, the information "there are ranges" will be comp=
letely=0A=
>>>> gone if the ranges are bad... dmesg will have a message about it, but =
that's it.=0A=
>>>>=0A=
>>> So there will be no additional information in sysfs in case of incorrec=
t =0A=
>>> ranges?=0A=
>>=0A=
>> Yep, there will be no queue/cranges directory. The drive will be the sam=
e as a=0A=
>> single actuator one.=0A=
>>=0A=
>>> Hmm. Not sure if I like that, but then it might be the best option afte=
r =0A=
>>> all. So you can add my:=0A=
>>=0A=
>> Nothing much that we can do. If we fail to retrieve the ranges, or the r=
anges=0A=
>> are incorrect, access optimization by FS or scheduler is not really poss=
ible.=0A=
>> Note that the drive will still work. Only any eventual optimization will=
 be=0A=
>> turned off.=0A=
>>=0A=
>>> Reviewed-by: Hannes Reinecke <hare@suse.de>=0A=
>>=0A=
>> Thanks !=0A=
>>=0A=
>>>=0A=
>>> Cheers,=0A=
>>>=0A=
>>> Hannes=0A=
>>>=0A=
>>=0A=
>>=0A=
>> -- =0A=
>> Damien Le Moal=0A=
>> Western Digital Research=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
