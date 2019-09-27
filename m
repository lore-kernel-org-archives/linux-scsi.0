Return-Path: <SRS0=gVs6=XW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC769C4360C
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 20:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9643C207E0
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 20:51:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="DYFDnMH5";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="eIQ5T8Zs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbfI0UvH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Sep 2019 16:51:07 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:49278 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbfI0UvH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Sep 2019 16:51:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1569617466; x=1601153466;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=pExdyhFlndem/pd1bZKqXdifUApGQhkkN158G7RW0xg=;
  b=DYFDnMH5vUFr9Uy4kW9v5yzzHK7uJDBQFQ+lHeeHOQ/ZziIJLplk10Sm
   tD79paKefmMGNMdqL4VAn74dpX6aipkefV4EcwW12BFP0IJeYf0qqV/qp
   Q0mdZiR88rzqKHvONjkpivKEUEiXHODledPkx/OZtYxlQKx3pzGgzdySe
   SAx3uaDb8dpq5d/BNS0abRUeSscxY1fleIDjdXSmqc9vLg8XgRMRFNziI
   b+c2ARj4XCBM348SaFpNp1h8MJLKZjCn6kIqekP2sOb3UYzqWGpgvE0yj
   BYMQQ+8cMh1nYZpWmkRbt5Vx4jSwS4WSFyRx36ZUR0mIQ+o174yIW7rm3
   w==;
IronPort-SDR: l+iHwfLhIXsPijH1G/8bXRE8V5AhFBDDQEubkh7+mhlSImHoYMXkIL4uK+1ecNvNI8klaihI8F
 iMsws4mFmYR5y8J238z+UfOXg5T1zVPKKvqnu4/ezbFMoXUhP2oEdXiVcdHh7FtBqPRuqfUIBP
 7Q/kXZr53aXAiFc8Zm01yCiwR6ndHI+mbWl+TDiAh34Jm80OakAORljb29+/MYLHiNbkWcwQ5M
 3RtaSxerf5lC2SH4qq6tzKhOMvQLHR2rEFc8z2jxhYUpfl7aT8ByMB8Tq0KN3KZnAnoC5SFX1k
 OE4=
X-IronPort-AV: E=Sophos;i="5.64,556,1559491200"; 
   d="scan'208";a="120886480"
Received: from mail-bn3nam04lp2058.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.58])
  by ob1.hgst.iphmx.com with ESMTP; 28 Sep 2019 04:51:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SpQKGOfTiEgVQnp4t4mIi9uuShH3abIJSWZgDsq8iQ/TtmKUwteTfemoRQuK6Kaix1kGe72VbtspfEV5wJDgJCUWDq4CBUH9nnnYQrO7HKSb/iDF6fcqiQS6sfL5ia/Wi1n0TB/H3OzeGb2BlFh8r4yT3jxiyRDdvAkkpci3rUdND6GbQCTd64rE5EPE3oYDTTwiUgwIgAheAq0BYmHoZZJ/BMICIQwf2va73ux3dPejo6R4Cnzt1W8jupbNOHI1dDd8jjp0x9HJ1enT1gsg72Et61+DfuyHRVa20LAR/ZRP+sYmIt6HBRBtDVb7nZ71orj0aycdH52UsLbAVnxRUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ve3kzHe/f7jUHNhaWe68G6Ebai/Iy0xBB1BfOgYhUs=;
 b=kTHbDy3GNzZEcnyKXcpuxF/XnIxt7BD6BPxVP5yYi3n8ALyeZfcXeqmAfVJgsrK9fLFzmCHzGeAxUF13FqwIdc/Fu/6oSHCsgOiU9ANf+xgoVrwHKATIY9xgGbNXfbGKOl4v8ws7/hu/NKNmQ1CdNoJtEfJ/ljYhoZO+zgO54PfX+/nht12M6w3M1iHc8PajgCkeLGtQyEVj7/wLVIczRgeocR5ilnuesycnxYbdeSCR0Tec0bMWWwYm6ILUoRzDpnM1n50sArF3K1k/JudnxbNGixPQML22HcEiDMsAKyND2C6zVyGdecCDm1Uqdzgx4delpoNWgNeDTYc3QMWWjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ve3kzHe/f7jUHNhaWe68G6Ebai/Iy0xBB1BfOgYhUs=;
 b=eIQ5T8ZssL17YmXAG6Iap/riVT1oBu/f7YQuJkSetUZ02ikoa/Evr6+/FfAcz0cQkUAdaIhZEEM+iYsFbFIxe4MPco4FsvTaOeBgPLDpe+xhE+j/m1sSM4GAgvJwoUWyJl/VBbXYxyrqq/SVZ+mq4lpk1oPrG57OrYQQvUooSBA=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB4696.namprd04.prod.outlook.com (52.135.239.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.16; Fri, 27 Sep 2019 20:51:02 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::9821:67e1:9799:b117]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::9821:67e1:9799:b117%3]) with mapi id 15.20.2284.028; Fri, 27 Sep 2019
 20:51:02 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Alan Stern <stern@rowland.harvard.edu>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "usb-storage@lists.one-eyed-alien.net" 
        <usb-storage@lists.one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH 0/2] Fix SCSI & USB Storage CHECK CONDITION handling
Thread-Topic: [PATCH 0/2] Fix SCSI & USB Storage CHECK CONDITION handling
Thread-Index: AQHVdLb8KJ6R44yKq0u9gZ6abLEPEQ==
Date:   Fri, 27 Sep 2019 20:51:02 +0000
Message-ID: <BYAPR04MB581640C4D180F4699EA64838E7810@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <Pine.LNX.4.44L0.1909271218200.2054-100000@iolanthe.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.44.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4f4b7f7-9a2c-4966-7923-08d7438c6867
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: BYAPR04MB4696:
x-microsoft-antispam-prvs: <BYAPR04MB46964A7E563F9F15E39EE824E7810@BYAPR04MB4696.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0173C6D4D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(189003)(199004)(6116002)(3846002)(476003)(33656002)(14454004)(14444005)(5660300002)(76116006)(256004)(66476007)(64756008)(66556008)(66446008)(478600001)(66946007)(305945005)(74316002)(102836004)(8676002)(7696005)(7736002)(76176011)(99286004)(6506007)(81166006)(81156014)(53546011)(6436002)(2171002)(55016002)(26005)(9686003)(6246003)(8936002)(486006)(66066001)(2906002)(229853002)(316002)(86362001)(446003)(71200400001)(71190400001)(52536014)(4326008)(6916009)(25786009)(54906003)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4696;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /cj5dWPnS9X3kPPaYQGMUStuanXF6RKNYJ85ukwdhhfu53pCq0o0jLmrlLMmt3T1Moh4lrE6IeRfxDeHyjcNNYWeHV2aucQpoxTDt0sbVx0fdkQq/s//pfd6+Hk0qqoLwsBe3f3N94FHtFPzEeTi/ksIkACo8bAhgfl4RFM2qXHfLYj1bVBP/MjYJMtBTwCwrATauJqnet5XoUSogNOWB18kPVjVK1OQBelT62/6t09v/dLjPXW1fOmY/SANgboYcIbdK0Vz/PmPvhT465EZHfyS2vO6IiJnOhbwmRMSh2fzJ1dOYQROUdU4t5iWvNcZciXJmCZ+WstZnuksGXKuRzMAhYp7VFeSr2FkS0oWNl+0MnI5TaNWSo/OLmNbSuKReQzT1vDiCy4vyrNKqdlApjTx39VEpFgIyypEzM/gB8M=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4f4b7f7-9a2c-4966-7923-08d7438c6867
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2019 20:51:02.0779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IEFTyCKIpl+2m9XE0EpZ310ogT6sGU4g2KNnOxccGA2weed/YQoPnK79h4B1PcABXrp/BDm+76vNrukwF3VMJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4696
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/09/27 9:34, Alan Stern wrote:=0A=
> On Fri, 27 Sep 2019, Damien Le Moal wrote:=0A=
> =0A=
>> On 2019/09/26 16:57, Alan Stern wrote:=0A=
>>> On Fri, 27 Sep 2019, Damien Le Moal wrote:=0A=
>>>=0A=
>>>> If a non-passthrough command is terminated with a CHECK CONDITION, the=
=0A=
>>>> scsi error recovery code reuses the failed command scsi_cmnd structure=
=0A=
>>>> to process error recovery request sense. To preserve information=0A=
>>>> regarding the failed command, the functions scsi_eh_prep_cmnd() and=0A=
>>>> scsi_eh_restore_cmnd() respectively save and restore the original=0A=
>>>> command information. However, the resid field of the failed command=0A=
>>>> request structure is not preserved and reused for the request sense=0A=
>>>> handling, leading to the original command having an incorrect resid=0A=
>>>> when:=0A=
>>>> A) The command is not retried and terminated with an error=0A=
>>>> B) The command completes after retry and the underlying LLD does not s=
et=0A=
>>>>    resid for a fully completed command (resid=3D0)=0A=
>>>>=0A=
>>>> The first patch of this series addresses case (A) above by adding resi=
d=0A=
>>>> as part of the command information saved using struct scsi_eh_save.=0A=
>>>=0A=
>>> Good catch.=0A=
>>>=0A=
>>>> Case B can be observed with a WD My Book USB disks when a read or writ=
e=0A=
>>>> command is sent to the disk while the disk is in deep sleep mode=0A=
>>>> (spun down) due to a long period of inactivity (~30min).=0A=
>>>> In such case, the following command sequence happen:=0A=
>>>> 1) The read or write command is terminated after a few seconds with=0A=
>>>>    CHECK CONDITION and an asc/ascq of 04/01 (LOGICAL UNIT IS IN PROCES=
S=0A=
>>>>    OF BECOMING READY)=0A=
>>>> 2) In response to this failure, the USB mass storage driver triggers=
=0A=
>>>>    autosense processing, reusing the command descriptor to issue a=0A=
>>>>    request sense command with a 96B sense buffer size. The reply=0A=
>>>>    to this command gives a NOT READY / LOGICAL UNIT IS IN PROCESS=0A=
>>>>    OF BECOMING READY sense of 18B, resulting in a resid of 78B.=0A=
>>>> 3) The original command is retried and failed again, with step 2=0A=
>>>>    repeated, until the drive spins up and becomes ready.=0A=
>>>> 4) When the original command completes after the drive has become read=
y,=0A=
>>>>    the request sense command resid of 78B is seen by the scsi disk=0A=
>>>>    driver sd_done() function and wrongly generates a warning about the=
=0A=
>>>>    unaligned value reported.=0A=
>>>=0A=
>>> But with the 1/1 patch in place, 4 won't happen any more, right?  =0A=
>>> sd_done() will see the resid from the successful read or write.=0A=
>>=0A=
>> No it will not because the USB driver does not set the residue when the =
value=0A=
>> returned for the command is 0, that is, when the command succeeds after =
the disk=0A=
>> spins up. E.g., in my test, I used a 4096B read at LBA 0. With patch 1 o=
nly, I=0A=
>> see a residue of 4096 since the command is entirely failed with CHECK CO=
NDITION=0A=
>> until the drive spins up and becomes ready, at which point the resid bec=
omes 0=0A=
>> but is not set with scsi_set_resid(). Without patch 1 nor 2, I see a res=
idue of=0A=
>> 78B which is the residue from the request sense executed between retries=
 of the=0A=
>> read command.=0A=
> =0A=
> I don't doubt your results.  But you need to do a better job of =0A=
> explaining how the existing code leads to those results.=0A=
> =0A=
> For example, you said the driver does not set the command's residue =0A=
> when the command succeeds.  But in fact, one of the first things =0A=
> usb_stor_invoke_transport() does -- before it begins transmitting the =0A=
> command -- is=0A=
> =0A=
> 	scsi_set_resid(srb, 0);=0A=
> =0A=
> So if the command is successful, even if the transport layer routine =0A=
> doesn't set the residue explicitly, the value should still be 0.=0A=
=0A=
Yes, you are right. I missed that one. Patch 2 is not needed at all.=0A=
=0A=
> So if you see the residue not getting set properly, you should explain =
=0A=
> exactly how that happens.=0A=
=0A=
I got confused in my analysis because I missed that the actual timing of=0A=
sd_done() execution is after every command retry+request sense pair, that i=
s,=0A=
what usb_stor_invoke_transport() does. Without patch 1, the resid is wrong =
on=0A=
completion of the initial command because of the request sense, nothing to =
do=0A=
with resid not being initialized.=0A=
W=0A=
ith patch 1, sd_done() sees a resid equal to the entire command size in cas=
e of=0A=
failure, and 0 (as set by usb_stor_invoke_transport()) in case of success.=
=0A=
=0A=
So as you suggested, only patch 1 is necessary. I will resend it with the=
=0A=
additional resid initialization for autosense for security, since that coul=
d be=0A=
a problem for a sense request that has no residue (the request sense is iss=
ued=0A=
directly using us->transport(), not using usb_stor_invoke_transport()).=0A=
=0A=
>> Patch 2 is needed to make sure that the residue is set to 0 when the com=
mand=0A=
>> fully completes. If there is no failure/request sense/retry dance, resid=
 is=0A=
>> already 0 (initialized value) so there is no problem. The problem shows =
up only=0A=
>> for CHECK CONDITION + retry patterns. Tests confirm this. Only patch 1 d=
oes not=0A=
>> solve the problem.=0A=
> =0A=
> But the residue gets reset to 0 every time before the command is=0A=
> retried, doesn't it?=0A=
=0A=
Yes it is. Checked.=0A=
=0A=
> Unless for your device, the driver doesn't run =0A=
> usb_stor_invoke_transport().  The only way that can happen is if you =0A=
> use one of the modular subdrivers -- in which case the bug lies in that =
=0A=
> subdriver and should be fixed there, not in transport.c.=0A=
=0A=
The device is using usb_storage (Bulk transport, scsi transparent protocol)=
. But=0A=
the problem is higher up in the stack anyway.=0A=
=0A=
>>>> This problem is fixed in patch 2 by always setting a command resid to =
0=0A=
>>>> when there is no residual in usb_stor_Bulk_transport(). Note that=0A=
>>>> usb_stor_CB_transport() does not need changes since usb_stor_bulk_srb(=
)=0A=
>>>> always sets the resid for a completed command, regardless of the=0A=
>>>> residual value.=0A=
>>>=0A=
>>> Exactly the same reasoning shows that usb_stor_Bulk_transport() also=0A=
>>> does not need changes, doesn't it?  Which means that patch 2/2 is =0A=
>>> unnecessary.=0A=
>>=0A=
>> In usb_stor_Bulk_transport(), since scsi_set_resid() is only called unde=
r the=0A=
>>=0A=
>> if (residue && !(us->fflags & US_FL_IGNORE_RESIDUE))=0A=
>>=0A=
>> condition, resid is not set if it is 0.=0A=
> =0A=
> But usb_stor_Bulk_transport() calls usb_stor_bulk_srb(), which does set=
=0A=
> the residue, as you realize:=0A=
=0A=
Yes, absolutely. Checked !=0A=
=0A=
>> Whereas in usb_stor_CB_transport(), through the call to usb_stor_bulk_sr=
b(),=0A=
>> resid is always set, unconditionally, with:=0A=
>>=0A=
>> scsi_set_resid(srb, scsi_bufflen(srb) - partial);=0A=
>>=0A=
>> where partial is the command length for a fully completed command (the v=
ariable=0A=
>> name is misleading), leading to resid being set to 0 as needed for succe=
ssful=0A=
>> commands.=0A=
>>=0A=
>> Please let me know if I missed something. I can reproduce the problem 10=
0% of=0A=
>> the time, even though it is painful due to the 30min wait between tests =
to wait=0A=
>> for the drive going to sleep (if I force a sleep power state, the proble=
m does=0A=
>> not happen due to power control the drive USB bridge FW, I am guessing, =
which=0A=
>> will wake up the disk before the command is sent).=0A=
> =0A=
> Please investigate a little more closely into what's going wrong and=0A=
> present more details so that others can understand it too.=0A=
=0A=
I did and realized it was my mistake. USB is not to blame. Only handling of=
=0A=
resid in save/restore of struct scsi_eh_save.=0A=
=0A=
Thanks for your comments !=0A=
=0A=
Best regards.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
