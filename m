Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,GUARANTEED_100_PERCENT,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7216DC433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A89560238
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235157AbhCAMwO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 07:52:14 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:63735 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbhCAMwN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 07:52:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614603415; x=1646139415;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Xd87f2TGm7YpHcF85JB2pmc9IYP3uYoJAdmYmUGDLng=;
  b=HcpwEwbDANrYIWHWMh2YPdgzKsjcl4mMIICwYaKbkewqfnsOtcGrjNuD
   x69jIvetUXLNE0IPUficmT8OvhaSdO0YZZgKx1Sb6dpYQab8q4PymOxwt
   qucmlWC1MNlCS3WhESFbpOtE1wPRhUiaR71O7MNiLio/tIg6ZE78BTHoV
   sJLaixZRuMYcfLmcDD8pgdWsgKmH3b988bZUSeq8FVySIumVP3woB1XnO
   j5iNz74G6HRabpVn/dL0u/WO963KGz/jckNLPVh0dqxhmaCHTawea2dsf
   X2YMcCtHgdinIPLIkA8Eq6S2rN3vi7RKvJlBH7NvocWASIsViaMI+xXDY
   Q==;
IronPort-SDR: UrNFQQmjqMQcHkhNqtP/0wnBT517eqInO/Vj9NCuPTn5lovpes2WGqFulIWw5O3ZtgrD3Xr+UP
 jFF4HfIBMibeIqqbZdCQlVoq8WBT+iKntmaG4D+4IvwClYLl/xakMhRQpjr913C421MpWXNBxx
 D2wu+hNll75OxxaswSabRh7oyaIWk+MbEvAqp1Sdk/3aoke60S6BPnHKKGqs0PdmK6+MkLITjR
 On74Dy3m2Ds9ptVAmWU//IPB0tI5w462twNDTt0MnWFTBk7s7VOAGyyeVlY/tO5r7tUOXzMDSg
 Fjs=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="265332193"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 20:55:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XI4/55lIS3LHiUYgIWYWNpZ9vGOb73d/wQQrXknI1bzYgNYL59VF7ySmCA4G4ibLX/sTi5EzPVrbmDPwV0uzFxOb8abd6t/X3dM8JsgE6q3PwYlslbDC3plxXqsPsViN5UWnYWJYPShnF0iNwzTLjjYo2TneI06w7eX7GCdgqGSS60Whb61R+Xx+MUhKNinKGrlYSdqZHwWdYlW0YmcqBtYIWDEANlQZ4D01BGcGNT1QsW/E9nifcuIiGVAg9cESnr6zVmErjJuxMNjsLwsTLLMjzjvYoZ3OPCl4Wod263DyF5+11AYWL8Ejuf6aNxRjkb+7WtqmCAYi4gk0pjPZ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qNWq/wECZ/0ae7TufPA7OjFoUUbGZ+DEKEHaoaaDYZM=;
 b=LWJ3SRwe4fR1l85z2LYG0ajadIrPH80qo8LOXGb2EM4eT29ONKENJU+9z5mGfQjYE9tPG9xnXXrb8hX+icvfAX8oYiksHtBK5D1attjpxUB+z9ldi3h+LPpWDaQ/fa3BskrTbprz26yX0p7JRJ95s6Nbi9HT1cJkiTI5L2zdtWOs5Au8wJAiHg686WSDMwXU6nofWBv017166AVazLFUGtG/AmXkIYzPqA12f220IAa4ppOK1HIaqEt347XMdDl6DIlLle9VNbdBNOnZqS/IiddawNZCHq0mM2k3EWPGEgv6wtZMoTLae/civW0NB+Zky4ALPjl4Z1hNbsymLlOiUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qNWq/wECZ/0ae7TufPA7OjFoUUbGZ+DEKEHaoaaDYZM=;
 b=oHUwqKUwcuklVj89DePwlOo0tYRid+FMSYGS3cR1GmrDYVhMJAQsFSksPgY9tf/sECCoJJe2bwHrv0+T/dYFUtLGUqZVVLAh0siwj1WPQAcFmoEquZoXmlObv1P0seUvlDeIeeXYxE73xXY4J3Fp9zWFYSfuqp07bRD3A70e7/Q=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by MN2PR04MB6445.namprd04.prod.outlook.com (2603:10b6:208:1a2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Mon, 1 Mar
 2021 12:51:04 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::e9c5:588:89e:6887]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::e9c5:588:89e:6887%3]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 12:51:04 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Guido Trentalancia <guido@trentalancia.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH RESEND v2] scsi: ignore Synchronize Cache command failures
 to keep using drives not supporting it
Thread-Topic: [PATCH RESEND v2] scsi: ignore Synchronize Cache command
 failures to keep using drives not supporting it
Thread-Index: AQHXDbGOoQvSctH05k2iblGBdDcQpA==
Date:   Mon, 1 Mar 2021 12:51:04 +0000
Message-ID: <BL0PR04MB6514A85C4B56E1370406B97BE79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <1614502908.6594.6.camel@trentalancia.com>
 <443d92dd844e329bcd40a1e59b7cc3784ed3db94.camel@HansenPartnership.com>
 <1614582394.13266.11.camel@trentalancia.com>
 <BL0PR04MB65146856C07649917652E540E79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
 <1614598394.4338.18.camel@trentalancia.com>
 <BL0PR04MB651420859C04C068419711FDE79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
 <1614602388.6918.8.camel@trentalancia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: trentalancia.com; dkim=none (message not signed)
 header.d=none;trentalancia.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:347a:bb00:3286:307b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d3db9818-7f10-417c-492a-08d8dcb0aca4
x-ms-traffictypediagnostic: MN2PR04MB6445:
x-microsoft-antispam-prvs: <MN2PR04MB644517872EEA68627F700551E79A9@MN2PR04MB6445.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IcH0S9lx12nMNY1fjG1mUBwlBmandKPapSL8F/iDUIdhIjWx0UfYcu+tZs5itDGm8U5176uMahJk+TF1m9qT4vaL+xuqxeFg9zCV1hQc60ubslae65S2cXg7QH4699rI5HEls7y42tUohv4cz6o2AWUWgFW98OSyt+vmU29sFxq5nGofiqPprhQnY3hl3FzYRtgXUcZcFNp8XJKSxY4BK26zcsAC3SIH/BtivcrHd9qG9EzXN57n94x1mgZ2kJVsI+WYSBET9xhUmFHcIYyGBBqSuYArd2XpVt9KMXrLq4EmfJsHf4Vj9UxlEJPqydd89fJrOaowKV7gqRtv5W0pm4zUkZwGV2n3ymypowmJqcVQifGj3Od2/YWQjDyynLI7+MoNaKFQ7rumZJSbQPSoK/bFCyG7drGN1hVkDpiAOVb5nA03utVLgCDLLzLJ68hdjVuXCzG6rCeQzyFs/B4B40IXrzgZdi2mFTQoKhO5WPJ0zlXn8WsbND9YvONC0WEgl1RZ/sZ4RvagIb83DZ3FQF6Da6n8rmr4HVF9QUUNTI9Xsjs0YQM/OMM/bCjXEF8b
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(376002)(366004)(136003)(110136005)(64756008)(66946007)(76116006)(91956017)(66446008)(66476007)(66556008)(33656002)(6506007)(53546011)(316002)(5660300002)(52536014)(2906002)(83380400001)(8936002)(186003)(8676002)(86362001)(7696005)(55016002)(9686003)(71200400001)(478600001)(6314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?5SiZ/2WG9C7FHDIfxuqy0kx+MTF5mec2ye4oAO6gFka4o+kBIgTDd4k9pbBm?=
 =?us-ascii?Q?c+SD49vj+5gmZDPqf/RVkOMqWOdMoTKevsN+Ncn12qAm0V0/RVxbGUXOTURf?=
 =?us-ascii?Q?kbjhTFTWgXkFtUkps3+1yKReWv5wkXYy0uOaDKRzAMmR68Cj0B/pbeGacRTj?=
 =?us-ascii?Q?t55OKEY2e/tNjchKwQ2x2vYXuIarX6z667Ae8H8KE/pgmZE+adHB0QctXDJq?=
 =?us-ascii?Q?wzDh5ghlugfcJF6b/DYUZcnpWMmSgw5eU+yNH4x2NCLSjPrKsh/8NVMqDH8f?=
 =?us-ascii?Q?eZO1BERZw/DyvMIXBSzKMJ8icPPLj//wbLvbd/FGPcYydIo9rl4oJnyX16Y+?=
 =?us-ascii?Q?VE7u/XYDSyZ92K3BP/Ky8rXWBlXGOg2X3w8ktd5UYdXFTvCz+76IUaXxyeFR?=
 =?us-ascii?Q?OkI+rRlpiRn/EHg1jGL2mQUPhTkHmXvfUws1V2PTO/8r2q6mQk3j6t5KpCj7?=
 =?us-ascii?Q?RFihH8SSAeKT7lTx+1jfj9tPC9scHuCtbjI52km+UmfzURqmPJFDFLDQMmwG?=
 =?us-ascii?Q?dmfF2WX3Usw07CsZ2DQxYhRDnAP2uftTwZBYBIvwNKJw/uoP/r91TxV/9d+a?=
 =?us-ascii?Q?PPWAAmC8F0W1YyEpU+bDxD5PaF1yYNrV8M6G6DIfRq7cwUcMXJi/wzK2pQh6?=
 =?us-ascii?Q?uGnwlYlUfHjbn55N3Dl8y39MvojwWda/ERjBPIekCraFr8DtNLG1DA++StF1?=
 =?us-ascii?Q?HINooRDvCm/LcUWgy3o0Y6pfX2cgcjSeYhSFtAZb4BnTzlvqYUe5yFFA0yXk?=
 =?us-ascii?Q?bcVosmFcs4SmKtm6JfpoUE86TOIceW8AziK+Unz3IgLff1OfD6xsqAkQQ+wN?=
 =?us-ascii?Q?4PTvf9OPTPEsxE4U0KOXBUYbnFCAHTEyz1EMeTNXVSFyO6Wq11gYV534fcnw?=
 =?us-ascii?Q?c3bRZKx9Td7A2MzPF6fZFXVXXxz2wa8Fff87hud5zxCTEt5tRN1ayvIyjaTK?=
 =?us-ascii?Q?t7c85iIbrvlUMTU6NnTMDdcr7YUXSX/v3+q+ESTaxaqK0kdDjr5W8Jt4bYbu?=
 =?us-ascii?Q?oplSjAakEZsdkmHmRm6yGy49onEYIa19MxKJ7NZX0rXZ/f/0WfjQOZ6VXxhK?=
 =?us-ascii?Q?Pp2YbjKMcgtTtavcpPtdLX8IV4VJuTprYdxwq92zOfpNzdOabPOuVWWQJbZo?=
 =?us-ascii?Q?iPY6cxje1RUdVlf4mhWK2/LeHDQd73YHp4D/zfHOZHmD9fLHwRR4rYC16DoH?=
 =?us-ascii?Q?zBDRFWcuHnPh23d6LHxH7/XLZ2KTfXdti0a7S2cy0cVkcvPw0T0hBChCJcWr?=
 =?us-ascii?Q?x7yEGBD+8rYOJu+WpB3a4rjPMWWwS1MoH7e5ELXvk8ekF1NGOFJZ8ieq1tCD?=
 =?us-ascii?Q?alQ1Yo2yn163OibmdEGsB4hnzrNhPgO0gDxiSeZVAnJn+v+tK5gOWMiTj1Y9?=
 =?us-ascii?Q?ICmVzjLqoi9sa1SupBmiQaw7mYXhwM9Tm8VRDUuj5Sr3a0WFjg=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3db9818-7f10-417c-492a-08d8dcb0aca4
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 12:51:04.0582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dLD4OeXRQAnQ8hJpZ5/TNeGp+AIRRfzcaD0iYNf9mJgV189HDM41oZCgA6+8uyKhAC5xjqSOVxf56CwSrmRueg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6445
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/03/01 21:39, Guido Trentalancia wrote:=0A=
> If the system is shut down before the sync or drive unmounting and the=0A=
> write cache is enabled, there might be the loss of data in the cache,=0A=
> but this is because of the way the drive is designed.=0A=
=0A=
That drive is not usable. Even the best journaling file system would get co=
rrupted.=0A=
=0A=
> I believe the kernel should support the drive as it is - plug and play=0A=
> - without requiring cumbersome configurations.=0A=
=0A=
No. That would be lying to the user. The user expect things to work. Not da=
ta=0A=
corruptions.=0A=
=0A=
> Disabling the write cache for increased data security is up to the user=
=0A=
> eventually requiring an increased level of safety against data loss.=0A=
=0A=
Sure. Some do that, most of the time because their application does not hav=
e=0A=
journaling capabilities. But with your drive, that is mandatory to ensure=
=0A=
correct operation, regardless of the host software using the drive.=0A=
=0A=
> In those earlier days, most operating systems were giving the user very=
=0A=
> specific warning about the risks of write caching. Such warnings have=0A=
> now been removed because of the advent of more recent hard-drive=0A=
> specifications supporting new features such as the Synchronize Cache=0A=
> command, but in my opinion this has nothing to do with the fact that=0A=
> earlier drives should be supported in a plug and play fashion as they=0A=
> were in earlier days.=0A=
=0A=
As I explained at length, write caching and synchronize cache command are o=
ld.=0A=
The warning you mention are because of all the poor drive firmware=0A=
implementations of synchronize cache command that existed at that time.=0A=
=0A=
> =0A=
> Guido=0A=
> =0A=
> On Mon, 01/03/2021 at 12.27 +0000, Damien Le Moal wrote:=0A=
>> On 2021/03/01 20:33, Guido Trentalancia wrote:=0A=
>>> I have just checked the drive and I can now confirm that you are=0A=
>>> right=0A=
>>> about the capabilities reported: it is indeed reporting Write=0A=
>>> Caching.=0A=
>>>=0A=
>>> However the point is that the current kernel behaviour is wrong and=0A=
>>> leading to data corruption on such drives, as the sync function=0A=
>>> fails=0A=
>>> due to missing Synchronize Cache command.=0A=
>>=0A=
>> Without sync working, how could you ever guarantee that even a clean=0A=
>> shutdown of=0A=
>> the host does not result in data loss ? I am not even talking about=0A=
>> power=0A=
>> failures and crashes here. A simple, clean "shutdown -h now". Without=0A=
>> issuing a=0A=
>> synchronize cache command after flushing the page cache and=0A=
>> unmounting the FS,=0A=
>> you will loose data and corrupt things. 100% guaranteed.=0A=
>>=0A=
>> As James explained in different terms, it is the other way around:=0A=
>> the kernel is=0A=
>> correct and behaves according to the fact that the drive is saying "I=0A=
>> am caching=0A=
>> written sectors". That implies that synchronize cache *is* supported,=0A=
>> per the=0A=
>> standards. The corruption errors you are seeing are due to the drive=0A=
>> being silly=0A=
>> and failing synchronize cache commands, resulting in the cached data=0A=
>> *not* going=0A=
>> to persistent media, and loss of data on power down or crash. This is=0A=
>> not a bad=0A=
>> behavior. On the contrary, not seeing any data corruption would only=0A=
>> mean that=0A=
>> you are being lucky.=0A=
>>=0A=
>>> Once again, this is because of very old HD specifications that were=0A=
>>> implementing Write Caching without that command.=0A=
>>=0A=
>> If the drive is scanned and initialized by sd/libata, it means that=0A=
>> it is=0A=
>> reporting following a supported standard version (SPC, SBC, ACS).=0A=
>> Probably an=0A=
>> old version, but still a standard. Synchronize cache command (for=0A=
>> scsi) and=0A=
>> flush cache/flush cache ext (for ATA) are not recent additions to=0A=
>> SCSI & ATA.=0A=
>> These have been around for a long time. It does not matter that the=0A=
>> drive is old=0A=
>> and following an old version. It should support cache flushing. Refer=0A=
>> to the ACS=0A=
>> specs. It is clearly noted that: "If the volatile write cache is=0A=
>> disabled or no volatile write cache is present, the device shall=0A=
>> indicate=0A=
>> command completion without error.". Get the point ? That drive=0A=
>> firmware is=0A=
>> simply broken and missing a critical command.=0A=
>>=0A=
>>> The way forward is to treat the command failure as non-critical=0A=
>>> (see=0A=
>>> attached patch) because clearly it's not implemented in all drives,=0A=
>>> but=0A=
>>> only more recent ones.=0A=
>>=0A=
>> Nope. Simply disable the write cache. Try "hdparm -W 0 /dev/sdX" or=0A=
>> "sdparm=0A=
>> --clear=3DWCE /dev/sdX" to disable it. And a udev rule can do that for=
=0A=
>> you on boot=0A=
>> too. Failures and data corruption will go away. But the performance=0A=
>> will likely=0A=
>> go to the trash bin too...=0A=
>>=0A=
>> A little bit of history: it used to be a thing, many many years ago,=0A=
>> to see=0A=
>> drives that had synchronize cache commands implemented as "nop" or=0A=
>> not=0A=
>> implemented at all. Unscrupulous vendors would do that to get better=0A=
>> performance=0A=
>> results for their drives with benchmarks. Because synchronize cache=0A=
>> can be very=0A=
>> costly and can take several seconds to complete. Using such drives in=0A=
>> big RAID=0A=
>> arrays with power failure protections would be fine, but any other=0A=
>> use case by=0A=
>> any regular user would create data corruption situations very=0A=
>> quickly. As noted=0A=
>> above, even a simple clean shutdown would lose data ! Such bad=0A=
>> practice ended=0A=
>> fairly quickly. For some reasons these bad drives failed to sell very=0A=
>> well :)=0A=
>>=0A=
>>>=0A=
>>> Guido=0A=
>>>=0A=
>>> On Mon, 01/03/2021 at 07.38 +0000, Damien Le Moal wrote:=0A=
>>>> On 2021/03/01 16:12, Guido Trentalancia wrote:=0A=
>>>>> Hi James,=0A=
>>>>>=0A=
>>>>> thanks for getting back on this issue.=0A=
>>>>>=0A=
>>>>> I have tested this patch for over a year and it works=0A=
>>>>> flawlessly=0A=
>>>>> without any data corruption !=0A=
>>>>>=0A=
>>>>> On such kind of drives the actual situation is just the=0A=
>>>>> opposite as=0A=
>>>>> you=0A=
>>>>> describe: data corruption occurs when not using this patch !=0A=
>>>>>=0A=
>>>>> I do not agree with you: if a drive does not support=0A=
>>>>> Synchronize=0A=
>>>>> Cache=0A=
>>>>> command, there is no point in treating the failure as critical=0A=
>>>>> and=0A=
>>>>> by=0A=
>>>>> all means the failure must be ignored, as there is nothing=0A=
>>>>> which=0A=
>>>>> can be=0A=
>>>>> done about it and it should not be treated as a failure !=0A=
>>>>=0A=
>>>> If the drive does not support synchronize cache, then the drive=0A=
>>>> should *not*=0A=
>>>> report write caching either. If it does, then the kernel will=0A=
>>>> issue=0A=
>>>> synchronize=0A=
>>>> cache commands and that command failing indicates the drive is=0A=
>>>> broken/lying =3D=3D=0A=
>>>> junk and should not be trusted.=0A=
>>>>=0A=
>>>> The user can trivially remedy to this situation by force=0A=
>>>> disabling=0A=
>>>> the write=0A=
>>>> cache: no more synchronize cache commands will be issued and no=0A=
>>>> more=0A=
>>>> failures.=0A=
>>>> No need to patch the kernel for that. And if the drive does not=0A=
>>>> allow=0A=
>>>> disabling=0A=
>>>> write caching, then I seriously recommend replacing it :)=0A=
>>>>=0A=
>>>>>=0A=
>>>>> However, if you are willing to propose an alternative patch,=0A=
>>>>> I'd be=0A=
>>>>> happy to test it and report back, as long as this bug is fixed=0A=
>>>>> in=0A=
>>>>> the=0A=
>>>>> shortest time possible.=0A=
>>>>>=0A=
>>>>> Guido=0A=
>>>>>=0A=
>>>>> On Sun, 28/02/2021 at 08.37 -0800, James Bottomley wrote:=0A=
>>>>>> On Sun, 2021-02-28 at 10:01 +0100, Guido Trentalancia wrote:=0A=
>>>>>>> Many obsolete hard drives do not support the Synchronize=0A=
>>>>>>> Cache=0A=
>>>>>>> SCSI=0A=
>>>>>>> command. Such command is generally issued during fsync()=0A=
>>>>>>> calls=0A=
>>>>>>> which=0A=
>>>>>>> at the moment therefore fail with the ILLEGAL_REQUEST sense=0A=
>>>>>>> key.=0A=
>>>>>>=0A=
>>>>>> It should be that all drives that don't support sync cache=0A=
>>>>>> also=0A=
>>>>>> don't=0A=
>>>>>> have write back caches, which means we don't try to do a=0A=
>>>>>> cache=0A=
>>>>>> sync=0A=
>>>>>> on=0A=
>>>>>> them.  The only time you we ever try to sync the cache is if=0A=
>>>>>> the=0A=
>>>>>> device=0A=
>>>>>> advertises a write back cache, in which case the sync cache=0A=
>>>>>> command=0A=
>>>>>> is=0A=
>>>>>> mandatory.=0A=
>>>>>>=0A=
>>>>>> I'm sure some SATA manufacturers somewhere cut enough corners=0A=
>>>>>> to=0A=
>>>>>> produce an illegally spec'd drive like this, but your=0A=
>>>>>> proposed=0A=
>>>>>> remedy=0A=
>>>>>> is unviable: you can't ignore a cache failure on flush=0A=
>>>>>> barriers=0A=
>>>>>> which=0A=
>>>>>> will cause data corruption.  You have to disable barriers on=0A=
>>>>>> the=0A=
>>>>>> filesystem to get correct operation and be very careful about=0A=
>>>>>> power=0A=
>>>>>> down.=0A=
>>>>>>=0A=
>>>>>> James=0A=
>>>>>>=0A=
>>>>>>=0A=
>>>>=0A=
>>>>=0A=
>>=0A=
>>=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
