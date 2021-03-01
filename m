Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,GUARANTEED_100_PERCENT,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C753C433E6
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09EA064E46
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235115AbhCAMnp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 07:43:45 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:20367 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233549AbhCAMnk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 07:43:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614602619; x=1646138619;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=SCOHv4H/qkm0aAHtI2X4oNrD2flh1DCLH5r85oW3Bic=;
  b=liS5OITf2i0sl6kzAoiNK6nu8zK909ytOsNPnTaFzTuXVFglqc2IPckT
   mcpNoMNT0kuQdCmpaRZz28Xy6iApBqRjTWeAhrqlaGvxHemEJKnfnxyI+
   3AgwXJ4Z8QCe/V56c1nt6l5GiWoBrBeHMOA0NjVkVFn+SkCgl/8igcaRD
   wrpaqPlt4QO5HV+dMpEHQsnYhUbCv27+QpAYgMwHimVJNVoTyys90TJ8U
   CI6aCD37meavD78Ey2rWZddl44K8evECXQrnfqTQhlB42JmwdiL/C9D1m
   UqCq/qooNw+zCtOLNlQb4Tp7Nn+1PLPe3IFNRzDkHuO2dX5vtJnhMdLS6
   w==;
IronPort-SDR: ZAuf0a/wQRVxyD4wPfoSusa8R34hIDy7cgJlqsUW2v5aN5tO6rm5+5BmAnp9N9JNKh/0sg1eRa
 vCzBjzY0QZeu7C6hwb7KASYsq/cJFKFGu6oKXjDPo4aZEYYttGy7LqvAnUqe+qfK/G3RjwK86U
 iXF1AKOzpAF2fK03lgFO+MEMswRQto1d4Y4Q67rKIrJtLhsfsVmbjbDfR/QCqDWWj+LntsQfr1
 bybW6aW9qOz1Q0DyhJQ/wEnEeHz/W1Tpr/CVmzryB1G9MJPc5rzV6F70h+0dvzJ7bZFoNCugQC
 ty8=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="165545056"
Received: from mail-co1nam11lp2173.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.173])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 20:42:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NrrXl/7P1iO8dDaTyT8VZmWJxWZV17ond1FpvJzsk6uu9PKjGIK03hCI8Bch331rI3+Q0VHLr2Xblzk2BZ8tOxzJ9j96ipscOKaknWg4IKZNuVhfbksURQxyloNdzBlzOQujiEqyO0iwXNsE9Dfm2yNSm9Y5UGnM50hgEOt1b13v81uayR3ZjP5C/dH9Sc6CeiP+4NA8xzjn9kWgLScr/VqAvkwzqAYfrUlszxteJs1d+dBiYu2R54zDWnuHpsmdzAF7fvDK3dmqbGPcZovhDoxhCvS28wEyn9pCNmhx5+cQBUnmFOsVEKyCl8MzD3DfioMSwP3zLJ0/ncJKS4tk6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OiilQharxz7iOYY4B2WCcDyacKpujufrduS/mvphZIs=;
 b=gKctf0tBk5qBwcV+CV7h0wdm5h64KhGuBfzpkNaLbyH8qsYgRWLhiIgopqlofBxvTxlIqThGz+2A5LOqyvVS7kUz7do5SpY3K7JJ2jamC6RG6CE+HIS+4xLfK6zJkGiPbDAsZJGPRtIJtOKb+Jg6EcZjr1lqSkSAZotcebg4OjMqxFYVhxl2iNmJ2AoiXkx41u21alplUf1YSYMXqi6AESIit98lO0JmqG8RWiUmKdTfWriVsqh66/P4LFfcJCeZu6QBUGdkOwALgwxf6Qe19zBaZRnBaDXSKlQx78jron8HYcZ27i7GjDV+vWxs80S4/XRivC3oGvZ6mKlIWx6Lzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OiilQharxz7iOYY4B2WCcDyacKpujufrduS/mvphZIs=;
 b=NuIp+we2YgJ24te1piwHR3VPekzGGkONLTxVKumb5uYl+7ZdJjthsbqAy87eAT84MpZRz1rzuJevXeaOh+keho9NFWQFDMNBrwva07is71Z1tWsnoJoK47VDJ4btWzSbLAIypEGJ45OcJ/SXkusnlzM0NzGSKMkHcjd779vffuA=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by BL0PR04MB6482.namprd04.prod.outlook.com (2603:10b6:208:1cf::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Mon, 1 Mar
 2021 12:42:30 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::e9c5:588:89e:6887]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::e9c5:588:89e:6887%3]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 12:42:30 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Guido Trentalancia <guido@trentalancia.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH RESEND v2] scsi: ignore Synchronize Cache command failures
 to keep using drives not supporting it
Thread-Topic: [PATCH RESEND v2] scsi: ignore Synchronize Cache command
 failures to keep using drives not supporting it
Thread-Index: AQHXDbGOoQvSctH05k2iblGBdDcQpA==
Date:   Mon, 1 Mar 2021 12:42:29 +0000
Message-ID: <BL0PR04MB6514DA80936D19A42FC9073AE79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <1614502908.6594.6.camel@trentalancia.com>
 <443d92dd844e329bcd40a1e59b7cc3784ed3db94.camel@HansenPartnership.com>
 <1614582394.13266.11.camel@trentalancia.com>
 <BL0PR04MB65146856C07649917652E540E79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
 <1614598394.4338.18.camel@trentalancia.com>
 <BL0PR04MB651420859C04C068419711FDE79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: trentalancia.com; dkim=none (message not signed)
 header.d=none;trentalancia.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:347a:bb00:3286:307b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9361489c-30b5-4636-3c6b-08d8dcaf7a2e
x-ms-traffictypediagnostic: BL0PR04MB6482:
x-microsoft-antispam-prvs: <BL0PR04MB6482CDBA7A66D0A3A1A021BAE79A9@BL0PR04MB6482.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y9YMDDCk+h0SrYkoMBDvOBOCzuxtRLYsGnKl9SGobmFrBLl6wCefrihkzYyNYIBPF5d6ceEdXbaReRxwVUKSuDmVwue27V7utm+e1J7+wwCSSXgkyGXD76l6cyGZKOj0mXSJYFVIil3kzZirBsAtnWrbsQxhH2Xkpmj+UB3dxyF80pOSzE0z9p4UbJuMcHZ2Xx8GdEZV4vUiQsHSY2EaGB0Vzt+BOy6SVFT4yQ614041PtSuNwSY+PIuL4aj09jO0+hPYY2+LQIKm0NT432T5/bl0zhm9Iwl/+exKeg8lQOi/EMPYsFcI8VdFjXi7eTM1bZBKAoA3vjPRUhKxyS5VwZ4vTm+r4taYaz+9Z12cAXlUVYD80doljQRFJ/ITOiwgaL/hSImpdRIfzcwzNOw1KWVqHvVIlQ8pRDwJNpJ1l7U1F4CIS0KQAfPJo44ag/imUgKLiWs8U9iATw2GU57PoQpveJ+ZLvLiGsZfpZyaVIxrWySk01gr5KY9huYnv+wJCIhKTyWJDhKVmxfZJghaCWVV6FZzYFlDwDTE8N63wIeRpAC0Dbd2/TlIwmHRNum
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(136003)(366004)(346002)(66946007)(55016002)(76116006)(478600001)(52536014)(316002)(66446008)(66476007)(91956017)(64756008)(66556008)(5660300002)(110136005)(83380400001)(6506007)(53546011)(86362001)(33656002)(186003)(71200400001)(9686003)(2906002)(7696005)(8936002)(8676002)(6314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?OU/aDValwhqM9pIO9K+cnqy/x9lPBAwvdLsq3Q47XTNvKy1Hp8osBRrXOO7z?=
 =?us-ascii?Q?DD8w18ChNs5q8YbEVwBE5F8BxONxBdlO7TVPQNfimMejjVG5iMqt9Dp/6XER?=
 =?us-ascii?Q?UXQCKzh1f862l6NpvAYEy7TgebLA2jHN79XbvqJWq/9xAD45VTDWvFzQO4Yx?=
 =?us-ascii?Q?nTv0hAe+BPDd1y+D5/jmj4FeSpqlI5qjcdB0/lYehWpvl1rfFux9hryUsVXA?=
 =?us-ascii?Q?wl3DpPcdEfLzAHdHFnJY9hkr8zZJzzD1VrJilr9jMfROY76LU4PTXrKEE+Ij?=
 =?us-ascii?Q?0iMn9BAchRpAzbdlmbNUB2wPcNMYG0U/N9veNmhh0LGPhOgqV5JuGuU6Tmsq?=
 =?us-ascii?Q?pAn3Om/xPKcPwcZLCcYGScZfD8YpvPak8E4wFc5XY0C0JCxwVwa68p6nkXcN?=
 =?us-ascii?Q?GhIBqFc8sUZR/QFGD+sVcQLdRVC3tgKy4tyU34i3fpxqTpWvWBFXAQYoSlrW?=
 =?us-ascii?Q?d8s244NR1HckglVpyHlsSEmE0lZRm6CKamJ8Acr1UZh5czwrcEBG7zUH5K5U?=
 =?us-ascii?Q?xJpv3LRWYhSOCO1y11DRP4DWt2gU6rYXFNtbOQly3KXJB0aNL46SrcE/fDFd?=
 =?us-ascii?Q?RVXjnKNOAIeJrF6aK44zuLNyXr3dwwY6UjuXq2OSjtSXK+afp2veLh6s+udz?=
 =?us-ascii?Q?qMsqqkHKj9PjIF0byiwxfP39DxRLA7IRfnq84DtnpXKzHlx16Z6ihdz2ScDn?=
 =?us-ascii?Q?hmlBeY79Pxc/rwfhdJbuRUiD5Z+8utQs68sifmNaXN6LuS4eBX//p2skFLSI?=
 =?us-ascii?Q?f8c71Z0WcT4b2H9l4U54dk5rQRGx8WO8ICNt4KkME7LX5DiuIVSpOz63QjY5?=
 =?us-ascii?Q?dfkYteTJFUTiQkQma5JyXRp/u1N140y7rQpNxiHIFdDM8udPF5VxALu+vpIe?=
 =?us-ascii?Q?VtVdp3nqphv/PJCcYi2/Egn/uAL6zojQx5R1OSh9pR9FjvpuhXAPmy/dQ90q?=
 =?us-ascii?Q?3GVVH84NkJyGeXd6DueW6AUxRj+yB87lkRBKXpcNkpAT7KVbHQMP9yT2+Lnt?=
 =?us-ascii?Q?gi6d1lGOs2KrKO0AitvgzPBZrdRTR+3K5FiESd0XTgPP+Zjt2Es2tIauGrLw?=
 =?us-ascii?Q?STZrdEj/C2x2hM0cMcsyVg94ps3sEOIJiMHq4DxdI2QZuHKVsHUWP2dSIyKW?=
 =?us-ascii?Q?SGSszLVwQGRB5ygChEBo2zd5EgXOCGBobgsEU9wPNILeHomJMQge4W/PNB8l?=
 =?us-ascii?Q?eoLSaeb0+NGPKQ5lYvxvdQVBBw2uYg9b3OL4J92+RzSq5a0Y1+43nmEl/yR+?=
 =?us-ascii?Q?72Ihqan4OkZqLpNJcTtJokYxTP0d2pk02fts5IrBzZlDB1NGVsH/IkToT2AW?=
 =?us-ascii?Q?ng2So2TT6Nh9RNMhZi2avDD3PDEbgUEsteu9QkKGiSQREQHo5/OULRwKpct8?=
 =?us-ascii?Q?q6RaMWszhZsOqcvg8RPCoMwWOrae+zH+GhykrSHqyj0vFHiubA=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9361489c-30b5-4636-3c6b-08d8dcaf7a2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 12:42:29.9316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hEbWpjVhTp+dwrjAo0IWKH+HjU82Ha9KVPouspi6nQXwYd7eHyu37XfRGxHJ0BndWu5dZ4af5KRZdjfsb/Ixzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB6482
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/03/01 21:30, Damien Le Moal wrote:=0A=
> On 2021/03/01 20:33, Guido Trentalancia wrote:=0A=
>> I have just checked the drive and I can now confirm that you are right=
=0A=
>> about the capabilities reported: it is indeed reporting Write Caching.=
=0A=
>>=0A=
>> However the point is that the current kernel behaviour is wrong and=0A=
>> leading to data corruption on such drives, as the sync function fails=0A=
>> due to missing Synchronize Cache command.=0A=
> =0A=
> Without sync working, how could you ever guarantee that even a clean shut=
down of=0A=
> the host does not result in data loss ? I am not even talking about power=
=0A=
> failures and crashes here. A simple, clean "shutdown -h now". Without iss=
uing a=0A=
> synchronize cache command after flushing the page cache and unmounting th=
e FS,=0A=
> you will loose data and corrupt things. 100% guaranteed.=0A=
> =0A=
> As James explained in different terms, it is the other way around: the ke=
rnel is=0A=
> correct and behaves according to the fact that the drive is saying "I am =
caching=0A=
> written sectors". That implies that synchronize cache *is* supported, per=
 the=0A=
> standards. The corruption errors you are seeing are due to the drive bein=
g silly=0A=
> and failing synchronize cache commands, resulting in the cached data *not=
* going=0A=
> to persistent media, and loss of data on power down or crash. This is not=
 a bad=0A=
> behavior. On the contrary, not seeing any data corruption would only mean=
 that=0A=
> you are being lucky.=0A=
> =0A=
>> Once again, this is because of very old HD specifications that were=0A=
>> implementing Write Caching without that command.=0A=
> =0A=
> If the drive is scanned and initialized by sd/libata, it means that it is=
=0A=
> reporting following a supported standard version (SPC, SBC, ACS). Probabl=
y an=0A=
> old version, but still a standard. Synchronize cache command (for scsi) a=
nd=0A=
> flush cache/flush cache ext (for ATA) are not recent additions to SCSI & =
ATA.=0A=
> These have been around for a long time. It does not matter that the drive=
 is old=0A=
> and following an old version. It should support cache flushing. Refer to =
the ACS=0A=
> specs. It is clearly noted that: "If the volatile write cache is=0A=
> disabled or no volatile write cache is present, the device shall indicate=
=0A=
> command completion without error.". Get the point ? That drive firmware i=
s=0A=
> simply broken and missing a critical command.=0A=
> =0A=
>> The way forward is to treat the command failure as non-critical (see=0A=
>> attached patch) because clearly it's not implemented in all drives, but=
=0A=
>> only more recent ones.=0A=
> =0A=
> Nope. Simply disable the write cache. Try "hdparm -W 0 /dev/sdX" or "sdpa=
rm=0A=
> --clear=3DWCE /dev/sdX" to disable it. And a udev rule can do that for yo=
u on boot=0A=
> too. Failures and data corruption will go away. But the performance will =
likely=0A=
> go to the trash bin too...=0A=
> =0A=
> A little bit of history: it used to be a thing, many many years ago, to s=
ee=0A=
> drives that had synchronize cache commands implemented as "nop" or not=0A=
> implemented at all. Unscrupulous vendors would do that to get better perf=
ormance=0A=
> results for their drives with benchmarks. Because synchronize cache can b=
e very=0A=
> costly and can take several seconds to complete. Using such drives in big=
 RAID=0A=
> arrays with power failure protections would be fine, but any other use ca=
se by=0A=
> any regular user would create data corruption situations very quickly. As=
 noted=0A=
> above, even a simple clean shutdown would lose data ! Such bad practice e=
nded=0A=
> fairly quickly. For some reasons these bad drives failed to sell very wel=
l :)=0A=
=0A=
=0A=
I checked the standards again. It turns out that SYNCHRONIZE CACHE command =
is=0A=
optional in SBC... Aouch. Got so used to have that one on any drive that I=
=0A=
thought it was mandatory.=0A=
=0A=
Well, it certainly is mandatory if the drive has a write cache, which seems=
 to=0A=
be the case for you.=0A=
=0A=
The problem with your patch though is that you disable write caching when y=
ou=0A=
see an ILLEGAL REQUEST/INVALID OPCODE termination of synchronize cache. Whi=
ch=0A=
means that the drive was already used, written too and the cache has likely=
=0A=
dirty data and I do not see any method to guarantee that that data makes it=
 to=0A=
persistent media before shutdown. Imagine if that was the synchronize cache=
 sent=0A=
before shutdown.=0A=
=0A=
So the only reasonable solution for such drive is to use it with write cach=
e=0A=
disabled from the start.=0A=
=0A=
> =0A=
>>=0A=
>> Guido=0A=
>>=0A=
>> On Mon, 01/03/2021 at 07.38 +0000, Damien Le Moal wrote:=0A=
>>> On 2021/03/01 16:12, Guido Trentalancia wrote:=0A=
>>>> Hi James,=0A=
>>>>=0A=
>>>> thanks for getting back on this issue.=0A=
>>>>=0A=
>>>> I have tested this patch for over a year and it works flawlessly=0A=
>>>> without any data corruption !=0A=
>>>>=0A=
>>>> On such kind of drives the actual situation is just the opposite as=0A=
>>>> you=0A=
>>>> describe: data corruption occurs when not using this patch !=0A=
>>>>=0A=
>>>> I do not agree with you: if a drive does not support Synchronize=0A=
>>>> Cache=0A=
>>>> command, there is no point in treating the failure as critical and=0A=
>>>> by=0A=
>>>> all means the failure must be ignored, as there is nothing which=0A=
>>>> can be=0A=
>>>> done about it and it should not be treated as a failure !=0A=
>>>=0A=
>>> If the drive does not support synchronize cache, then the drive=0A=
>>> should *not*=0A=
>>> report write caching either. If it does, then the kernel will issue=0A=
>>> synchronize=0A=
>>> cache commands and that command failing indicates the drive is=0A=
>>> broken/lying =3D=3D=0A=
>>> junk and should not be trusted.=0A=
>>>=0A=
>>> The user can trivially remedy to this situation by force disabling=0A=
>>> the write=0A=
>>> cache: no more synchronize cache commands will be issued and no more=0A=
>>> failures.=0A=
>>> No need to patch the kernel for that. And if the drive does not allow=
=0A=
>>> disabling=0A=
>>> write caching, then I seriously recommend replacing it :)=0A=
>>>=0A=
>>>>=0A=
>>>> However, if you are willing to propose an alternative patch, I'd be=0A=
>>>> happy to test it and report back, as long as this bug is fixed in=0A=
>>>> the=0A=
>>>> shortest time possible.=0A=
>>>>=0A=
>>>> Guido=0A=
>>>>=0A=
>>>> On Sun, 28/02/2021 at 08.37 -0800, James Bottomley wrote:=0A=
>>>>> On Sun, 2021-02-28 at 10:01 +0100, Guido Trentalancia wrote:=0A=
>>>>>> Many obsolete hard drives do not support the Synchronize Cache=0A=
>>>>>> SCSI=0A=
>>>>>> command. Such command is generally issued during fsync() calls=0A=
>>>>>> which=0A=
>>>>>> at the moment therefore fail with the ILLEGAL_REQUEST sense=0A=
>>>>>> key.=0A=
>>>>>=0A=
>>>>> It should be that all drives that don't support sync cache also=0A=
>>>>> don't=0A=
>>>>> have write back caches, which means we don't try to do a cache=0A=
>>>>> sync=0A=
>>>>> on=0A=
>>>>> them.  The only time you we ever try to sync the cache is if the=0A=
>>>>> device=0A=
>>>>> advertises a write back cache, in which case the sync cache=0A=
>>>>> command=0A=
>>>>> is=0A=
>>>>> mandatory.=0A=
>>>>>=0A=
>>>>> I'm sure some SATA manufacturers somewhere cut enough corners to=0A=
>>>>> produce an illegally spec'd drive like this, but your proposed=0A=
>>>>> remedy=0A=
>>>>> is unviable: you can't ignore a cache failure on flush barriers=0A=
>>>>> which=0A=
>>>>> will cause data corruption.  You have to disable barriers on the=0A=
>>>>> filesystem to get correct operation and be very careful about=0A=
>>>>> power=0A=
>>>>> down.=0A=
>>>>>=0A=
>>>>> James=0A=
>>>>>=0A=
>>>>>=0A=
>>>=0A=
>>>=0A=
>>=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
