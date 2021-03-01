Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,GUARANTEED_100_PERCENT,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AF2C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C67164E37
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbhCAM3L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 07:29:11 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:49968 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235020AbhCAM26 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 07:28:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614601737; x=1646137737;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=1B84sIMdEQKYzmp+/e9OH/BRLXhEpNt187I2u9RtDvo=;
  b=RmGTwwhqbpgOYBrST5V+Xi5pq+8eOnNEeeI8wU5IBbgl44IHpIHNJvti
   pCqN06N4V7xN6EPSeeEwAnDjpf1ketchyVuXhkCdM5XWbG4NoT9zjshjG
   aSNmXPQwMswWlKk7adJ/w6RqpHNA8pUoecDzpyubaNjwr7GJG8N23d5aC
   uMmXGA4dmZCr0noDpnkKtHh1LYt99kosRrS99R90IznXZ2/yDIOHlWNsE
   dUaph93MKtCj/T3fTeB+YBg3s239panUNidiudKTr1yHP+noev9miILk1
   hes72V/Ik7n6aDGJFzvpaBdwbzgdEUJDUQg6ByY98TTx68Qr3Uti7SYs0
   Q==;
IronPort-SDR: BQCt63b5g9An5pe43EjDa70uhZUKK1cvqx0zNc3v3KonH2kStNwwIlNaz+6VLr775EZdwkf6S3
 ymmNgFtkyxxNZKmUj+zrIHJ433ERmtdqf1Nmywz+JuoS4/gtYgX/yI8EuE9UwataHcYtmXsfXx
 EO4MZMikDSH5JypzrzjJhP1BYe4oFzEkv7XQVb+aZaZc0Mnl2isHNIYHQjgyQGPXReRGt14qKs
 3/NoSwRzUqYcHDh8iWtguxsSrZezEXsJzIf7fWcdjhpUeQRcPEwIY86GhHZrP9rUh5NzQ8ShqV
 Of8=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="271658968"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 20:27:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/RsNU6MHnPcYTZITKHKsWngR5GBPJO5c3fMLYf41CGHhlALgfEutRsgtwk5N6AN8qEPwLEWb/Ysjh3ZIZKLBd0JT2EE6Q0vXZThW8RqK35eaqsZILbMnCotgxls37/Fo9WrVLRU4+dEEmqRBJjN2D9K+SZ+uaRCOrqPrpmw+ysp/jkF4HbBgFyOLqaTF2liYh8RJONHXaGPzahqB1IcwEI8flymPU0SMMwFbg3zBTq2lcagd6SS3KlC0p6qp/tL2NkglgwfNo9nHqaTAB6zRpMG0bpn4/BWdqTnUiDVFqi+EEu1A5jBDvyK7YEceS0as+aq9DGM38/HOD85/Ppx1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ElAcOVY+x4uG1GcLX9rLWKRIGORbC+sbbcjFACgkTU=;
 b=nAg/SKr0i6hz8UsCkunEGfoFezIhZElzyzfMYwVrX9eb+KcoANWbna9HdA/Ux+6rY2BvQpRlLaCyK5XETCi/tOlEOThLfBK94gc1EC5F8RrBUc7O0qS7HAnfdN3WOmRS78GJYgLvYXzA5CujxccFuYzDxXup7YxFuNpKjqUr5b1BFFC4j0KhYn9706GH2jI851vQftP9HxN5No6ruSHQRdHwcGY7Yzn0/QuhZ29YajizzZmGoRuXHOIrB2L6IjTu6kRuK7oRLqsy2I7PrmQKUsbWWjdp7BKK9gXa4YNjoqZs7jHmNTECgqQoZAY5kEhvftl/a2idQkjxAeitM28KxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ElAcOVY+x4uG1GcLX9rLWKRIGORbC+sbbcjFACgkTU=;
 b=TXv/g3YP6w7NLwNhH3NykTgSaCdI3Dqcj5E3f74gylJFdtFonjOoVR/m8RPTXxLfFzdsQdzRcBiFwbXP0kATM5gFhArLLWBQE1nzZEZXl3iFaJUFzK5mEPsgE8K4m9RVlYrUrw5kuBEbUx30rF5BqlY9F0MaAnrUQRv+nhwI71E=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by MN2PR04MB6414.namprd04.prod.outlook.com (2603:10b6:208:1ac::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Mon, 1 Mar
 2021 12:27:49 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::e9c5:588:89e:6887]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::e9c5:588:89e:6887%3]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 12:27:49 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Guido Trentalancia <guido@trentalancia.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH RESEND v2] scsi: ignore Synchronize Cache command failures
 to keep using drives not supporting it
Thread-Topic: [PATCH RESEND v2] scsi: ignore Synchronize Cache command
 failures to keep using drives not supporting it
Thread-Index: AQHXDbGOoQvSctH05k2iblGBdDcQpA==
Date:   Mon, 1 Mar 2021 12:27:49 +0000
Message-ID: <BL0PR04MB651420859C04C068419711FDE79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <1614502908.6594.6.camel@trentalancia.com>
 <443d92dd844e329bcd40a1e59b7cc3784ed3db94.camel@HansenPartnership.com>
 <1614582394.13266.11.camel@trentalancia.com>
 <BL0PR04MB65146856C07649917652E540E79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
 <1614598394.4338.18.camel@trentalancia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: trentalancia.com; dkim=none (message not signed)
 header.d=none;trentalancia.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:347a:bb00:3286:307b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 749020b8-197c-4d5a-1732-08d8dcad6d56
x-ms-traffictypediagnostic: MN2PR04MB6414:
x-microsoft-antispam-prvs: <MN2PR04MB641427D053110A0888483E48E79A9@MN2PR04MB6414.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PHO2tKFwx+4gpjKnJ+O9Ubpvbl8Uu2/1n4hLGQyF8G+PU2fTVnGqGbJx5zgOa2vVIb8oPhOw6rLfj1jyLVwqvp6kqXJe/w0ipsu/F1ymPn9Fs2j4KsU3sokigDK+oXeL8nDjdwnK0J873Tfkl3BN/6/XGHac8nFHUJeTdvAucFeuEvnQSTiAbb2asdy1es5Eh/xAOVk+9wxC/9xC5p4rCnoUDE0FieuWF2vsix9DzBxWqDkVuaMNgrqSXpBPtMuQdlso120vtHb0l08SlbWefjD7qwo8g2uhpTanqP+KuU80zWrmV2chmUhBtRDHhH0l2qGrBCPSkFO44G5sq1hoTiDnCQCEZcGQGLv81V9eVPLbciVfh2ZfRwVYbDEf/zc/JbyxiTyyK9JCv76kpAmsnt7Irnz0xj8ggbjiVCQHDCpt29i3TzuOVTXIQL01Ghdv7cK+4PFLpdpDBmLPyZfq3uhhTFxbTh9v23LO5i48WtHB8xYI0xWSQZjaneWx/JwUHLCBsRMCuNBwqxQ1mHxX/EBT+Ho05HuUXJ8709k9likdl+H+VkEChF9lTD7Hlqd2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(39860400002)(346002)(136003)(91956017)(71200400001)(5660300002)(7696005)(110136005)(33656002)(9686003)(76116006)(478600001)(86362001)(55016002)(6506007)(53546011)(2906002)(66556008)(83380400001)(8676002)(8936002)(316002)(66446008)(52536014)(66946007)(66476007)(64756008)(186003)(6314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?xhLh0K5buRATqMRfqVyhJPoswXWbn8E5jB90/zfaPvl1fyMlfMvW65CVrydJ?=
 =?us-ascii?Q?se7xKHylgTW7JdRukj/4lMInaEgzYCwgtKjW1Ote4XRw98ok9XMFWQAipByS?=
 =?us-ascii?Q?crNRlOHxbJJG2FbPPCI06DlW5aL2x9ozlmHWv2t0wchcX5j8Hk21HgfkudgT?=
 =?us-ascii?Q?HIBraFu73a+cGkMDizJr3C49HX9Wd6V3+4WzbZI/hrFAS4jsFSX1Tlz5f1eG?=
 =?us-ascii?Q?eMQ6HsmkESoENMUjd1xqlcSHlpmjseGZzZT9eKEYS8fHIPm5DTR7E3L3zqk1?=
 =?us-ascii?Q?S32n0kDhRs1jqTgb7p5BpG9oNHOlyQ/gfmTAFadYdiuz8j/KrxHty05r948p?=
 =?us-ascii?Q?oG2hR5xqt5LyWWdqIrIIgjdf6+D5YQkT33xrMECX50AepxuFu3qD05lb0QEv?=
 =?us-ascii?Q?8D1ffef5txNKEBKc7IttCZhBfsqn9ykp+LJKjQA2tc4c3aL7oi4idHsmTuF2?=
 =?us-ascii?Q?B6HQ0FdvnxPqzWdMwjxtQeRbVwDvPUdH4nVHla0WfPherVjD2to7pUdrZUwH?=
 =?us-ascii?Q?lKdt1sL0DDkalg3SHhmyjzyJMHsLxVGOTGGPXn+sS5BiSmgTsV+55OiI6ELA?=
 =?us-ascii?Q?FtE106KcAgsMcSmCsM9I3H9XqdsDG8tvI3kX56jSGlAQmkocdjXbFdEhe+QE?=
 =?us-ascii?Q?AZDkFpbqGUK8bZh4v/yPIwIMwkBPIB1esRpXvyr38os4cyAMHReEvASFqrNy?=
 =?us-ascii?Q?EDJU4pe3gKQtE/7D9Qvd5Dpa05qLxjWDtKYwHsQt+MbxZhdA9fW63KqhMVNF?=
 =?us-ascii?Q?h7wB2XnMuGlWEv8/T5ZvbbtlsY6VCTxVKMTGwpOxOvWZVG56pQzEaYCHMC+H?=
 =?us-ascii?Q?PCreqkhw29CfEtUeT/p4LvOcVyi7aRVXQXqZZvJGnxyPfVm6Ct8IIHuxol6Q?=
 =?us-ascii?Q?/C1fqSVaXUygpOmO1c/tqDvLd3L4yqM1nNSv8aUU73HK0dxysouwRCg/W774?=
 =?us-ascii?Q?fRU/cJbq7ElkyEodqZ9FdbftNsRMVn77zSUnrMNgXYIfKlpMU/ZH64Ys4lDm?=
 =?us-ascii?Q?8gO+5XxlbRBOIOvy72SmaUxA5V3iCQnuDllatTkClZAMDrJ6ZscvuBL2rRfW?=
 =?us-ascii?Q?92wOvjvkR75EYT4j05OgMdX9hzmBW/X9Z+Llw0wWG4rBpIu649IhGye+0tLD?=
 =?us-ascii?Q?FXzjDR0vRIUVFGbpRwvLbfN6xJDU7Cz2pmYxdu7jB40kJtoCX28tDsf9VBTx?=
 =?us-ascii?Q?cByZWYSkDxKg6ZVZ7L3lAu3gTWy07VywAkESf9GjacIwraUsle6BT3+rTVxz?=
 =?us-ascii?Q?xfEPDJaYDVPHu8oPRk9oXYJK7YbDYXY4If3iMwO+s3KP/nBax3Ns4h5PJxB3?=
 =?us-ascii?Q?nfhlbr/xesCguMafKJRKfS5deLkOOuQF6s+uw31KvaBrFgqqE+z0nJWRPriD?=
 =?us-ascii?Q?2160xuurL0XCUq1wstAAvWPmv7YtSwQawq6FARU9QbAQCBAbew=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 749020b8-197c-4d5a-1732-08d8dcad6d56
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 12:27:49.3830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZH+y2/w3RypflT6DsUP5vOowKh7w5yAe3GU1ZTPUB8HVoG8hQA2Du/3yY7DON5eX76OUz3VNFRKxzfXPLi9dGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6414
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/03/01 20:33, Guido Trentalancia wrote:=0A=
> I have just checked the drive and I can now confirm that you are right=0A=
> about the capabilities reported: it is indeed reporting Write Caching.=0A=
> =0A=
> However the point is that the current kernel behaviour is wrong and=0A=
> leading to data corruption on such drives, as the sync function fails=0A=
> due to missing Synchronize Cache command.=0A=
=0A=
Without sync working, how could you ever guarantee that even a clean shutdo=
wn of=0A=
the host does not result in data loss ? I am not even talking about power=
=0A=
failures and crashes here. A simple, clean "shutdown -h now". Without issui=
ng a=0A=
synchronize cache command after flushing the page cache and unmounting the =
FS,=0A=
you will loose data and corrupt things. 100% guaranteed.=0A=
=0A=
As James explained in different terms, it is the other way around: the kern=
el is=0A=
correct and behaves according to the fact that the drive is saying "I am ca=
ching=0A=
written sectors". That implies that synchronize cache *is* supported, per t=
he=0A=
standards. The corruption errors you are seeing are due to the drive being =
silly=0A=
and failing synchronize cache commands, resulting in the cached data *not* =
going=0A=
to persistent media, and loss of data on power down or crash. This is not a=
 bad=0A=
behavior. On the contrary, not seeing any data corruption would only mean t=
hat=0A=
you are being lucky.=0A=
=0A=
> Once again, this is because of very old HD specifications that were=0A=
> implementing Write Caching without that command.=0A=
=0A=
If the drive is scanned and initialized by sd/libata, it means that it is=
=0A=
reporting following a supported standard version (SPC, SBC, ACS). Probably =
an=0A=
old version, but still a standard. Synchronize cache command (for scsi) and=
=0A=
flush cache/flush cache ext (for ATA) are not recent additions to SCSI & AT=
A.=0A=
These have been around for a long time. It does not matter that the drive i=
s old=0A=
and following an old version. It should support cache flushing. Refer to th=
e ACS=0A=
specs. It is clearly noted that: "If the volatile write cache is=0A=
disabled or no volatile write cache is present, the device shall indicate=
=0A=
command completion without error.". Get the point ? That drive firmware is=
=0A=
simply broken and missing a critical command.=0A=
=0A=
> The way forward is to treat the command failure as non-critical (see=0A=
> attached patch) because clearly it's not implemented in all drives, but=
=0A=
> only more recent ones.=0A=
=0A=
Nope. Simply disable the write cache. Try "hdparm -W 0 /dev/sdX" or "sdparm=
=0A=
--clear=3DWCE /dev/sdX" to disable it. And a udev rule can do that for you =
on boot=0A=
too. Failures and data corruption will go away. But the performance will li=
kely=0A=
go to the trash bin too...=0A=
=0A=
A little bit of history: it used to be a thing, many many years ago, to see=
=0A=
drives that had synchronize cache commands implemented as "nop" or not=0A=
implemented at all. Unscrupulous vendors would do that to get better perfor=
mance=0A=
results for their drives with benchmarks. Because synchronize cache can be =
very=0A=
costly and can take several seconds to complete. Using such drives in big R=
AID=0A=
arrays with power failure protections would be fine, but any other use case=
 by=0A=
any regular user would create data corruption situations very quickly. As n=
oted=0A=
above, even a simple clean shutdown would lose data ! Such bad practice end=
ed=0A=
fairly quickly. For some reasons these bad drives failed to sell very well =
:)=0A=
=0A=
> =0A=
> Guido=0A=
> =0A=
> On Mon, 01/03/2021 at 07.38 +0000, Damien Le Moal wrote:=0A=
>> On 2021/03/01 16:12, Guido Trentalancia wrote:=0A=
>>> Hi James,=0A=
>>>=0A=
>>> thanks for getting back on this issue.=0A=
>>>=0A=
>>> I have tested this patch for over a year and it works flawlessly=0A=
>>> without any data corruption !=0A=
>>>=0A=
>>> On such kind of drives the actual situation is just the opposite as=0A=
>>> you=0A=
>>> describe: data corruption occurs when not using this patch !=0A=
>>>=0A=
>>> I do not agree with you: if a drive does not support Synchronize=0A=
>>> Cache=0A=
>>> command, there is no point in treating the failure as critical and=0A=
>>> by=0A=
>>> all means the failure must be ignored, as there is nothing which=0A=
>>> can be=0A=
>>> done about it and it should not be treated as a failure !=0A=
>>=0A=
>> If the drive does not support synchronize cache, then the drive=0A=
>> should *not*=0A=
>> report write caching either. If it does, then the kernel will issue=0A=
>> synchronize=0A=
>> cache commands and that command failing indicates the drive is=0A=
>> broken/lying =3D=3D=0A=
>> junk and should not be trusted.=0A=
>>=0A=
>> The user can trivially remedy to this situation by force disabling=0A=
>> the write=0A=
>> cache: no more synchronize cache commands will be issued and no more=0A=
>> failures.=0A=
>> No need to patch the kernel for that. And if the drive does not allow=0A=
>> disabling=0A=
>> write caching, then I seriously recommend replacing it :)=0A=
>>=0A=
>>>=0A=
>>> However, if you are willing to propose an alternative patch, I'd be=0A=
>>> happy to test it and report back, as long as this bug is fixed in=0A=
>>> the=0A=
>>> shortest time possible.=0A=
>>>=0A=
>>> Guido=0A=
>>>=0A=
>>> On Sun, 28/02/2021 at 08.37 -0800, James Bottomley wrote:=0A=
>>>> On Sun, 2021-02-28 at 10:01 +0100, Guido Trentalancia wrote:=0A=
>>>>> Many obsolete hard drives do not support the Synchronize Cache=0A=
>>>>> SCSI=0A=
>>>>> command. Such command is generally issued during fsync() calls=0A=
>>>>> which=0A=
>>>>> at the moment therefore fail with the ILLEGAL_REQUEST sense=0A=
>>>>> key.=0A=
>>>>=0A=
>>>> It should be that all drives that don't support sync cache also=0A=
>>>> don't=0A=
>>>> have write back caches, which means we don't try to do a cache=0A=
>>>> sync=0A=
>>>> on=0A=
>>>> them.  The only time you we ever try to sync the cache is if the=0A=
>>>> device=0A=
>>>> advertises a write back cache, in which case the sync cache=0A=
>>>> command=0A=
>>>> is=0A=
>>>> mandatory.=0A=
>>>>=0A=
>>>> I'm sure some SATA manufacturers somewhere cut enough corners to=0A=
>>>> produce an illegally spec'd drive like this, but your proposed=0A=
>>>> remedy=0A=
>>>> is unviable: you can't ignore a cache failure on flush barriers=0A=
>>>> which=0A=
>>>> will cause data corruption.  You have to disable barriers on the=0A=
>>>> filesystem to get correct operation and be very careful about=0A=
>>>> power=0A=
>>>> down.=0A=
>>>>=0A=
>>>> James=0A=
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
