Return-Path: <SRS0=gVs6=XW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA21AC4360C
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 00:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B1D420835
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 00:17:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Bhf6+OGb";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="lg72dhEY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbfI0ARE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Sep 2019 20:17:04 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:46934 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfI0ARE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Sep 2019 20:17:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1569543423; x=1601079423;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=9qlSTVUzRoP48VyNCMSB90Lx0jhUPzGD43EglivRXX8=;
  b=Bhf6+OGbKLdCXuxsDXQbt7FfJdh6iYLAj2K2vrwKxVc4Te0f6x2n7CZ5
   On30rxzElh21rUy1Med9IVcYPGTFc3brMSI0dEndbWWkHu/POBY6RmRCG
   I8ie7qbGoWfD05tQ80HW4vFB1yWayXlCy11JIDlI1t32+6fgOdlF3Cotw
   Zo6YCkkIGoebCp5zeMA4jERcaXPZU6YFRjVhS7vTek4nfAPxHz2wFut86
   r8zKbzkPHuxBJPdE09f+L8u26mnAVvFnVJvy/JuQ9RPHLl3qmeNZ+uKw0
   +FLTOJUysVxUAt9fh6NCoI0CjW10ZoEIcg0bqF1xUb7UrMZ7e6i9sthFd
   w==;
IronPort-SDR: v4voQ5LM5zJvk4nUHijT4iXPakS9pOgL+SMGjUZ1iPl3TKHAJFz2gd9GDEFgMj3ilb2G+cp5n9
 2PsR7FEYEO1Ah4AZFUwk4Tb5mscYktAWGhe3WRx+UNcQchx7DZXuNlxX0YXBDv8YytZ51SBAqJ
 jHn18qdHAitax+Mbwql7RATgsIo2yZJ2W0NW9R+QAc9DbyNt09DGX2WCzMoy2VfNb8GpcIoVUS
 I3lBJ6FGEgem7e7InfRMyKUsmTIhnfHQ3cEPaZsoXuzstDm+180rzaOiFZ5thmGkKQQoe1NNU6
 olE=
X-IronPort-AV: E=Sophos;i="5.64,553,1559491200"; 
   d="scan'208";a="120010187"
Received: from mail-co1nam05lp2056.outbound.protection.outlook.com (HELO NAM05-CO1-obe.outbound.protection.outlook.com) ([104.47.48.56])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2019 08:17:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/xhvl5eMIT0cOHmBwG0MiRCzk3kWu6VuZtaBSWCUZsIIlX1jroyq1zjEHedUyXXOb3tCaykOL3dTJKmgk6ulhNBxv/DUVIAIy60Zrq3to8pVuFYgqE+czwo6e5Tc+MIPnDYp+7ErgRZT2rjRNPrSOhVgJHqqZxLjCDfGo+tu+AiCfOovsNkT/sKRjAuhqbpG1HFX52crjSdfvrycStDtsNqCLxj3egCZ9LidjhtUIPUxUbN5DvUzdyZZQUJqlTzMHixiqyuh2QuMWLG8MpL2HvbwAQqmA4v4bFbFFaDc1O/delKIwgBvnphz7G+L+SIar1smjQCxm6L/iIYYOOBxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E9Ob639aVb846pEvlnsjW3v7OXz7GDaSSgoDGMCVo+8=;
 b=R5sFGFSC2tj9ZXusJFkyecMsTvX5oHLWzUnd4BC9ZzYqYq4X7uEYMtZ5+pS7LK0sm6yQ8AY1tWHO1fUpTze/6OT0ezWFdHUVkC1I4Y180HPc4mdKdcd8ynblDXwRnD8ZVnqWVKPhxslGAID9hjPM4fzusiOuFfzG93IMsBfD9CY2Me194hRp6Nc5lroXNaVHrz2vdYo3xd8Mbz4wqV3PUc+zzcUi7zeVDEyZ+l5GBMgMj0Wm+XbBQWinnJyLZgNUouJV3k8aJNWGHpqyWqLOTT8taiamJvuUXSVf52B6h9EoMtXN79/4I1/iUp+AgMPmsZjz0K5pM+x9vMkrABmNbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E9Ob639aVb846pEvlnsjW3v7OXz7GDaSSgoDGMCVo+8=;
 b=lg72dhEYqyuHI21H798zuA25iuDiR4XnsWNPmi+/ERYSDVLB+XyGUzr0QFFrgQFdilnVrtydLH17zhdrL+4rRdZRBPobEG/yr18VpbigTE5HNrgWW7wt18LRXlgRM0rXjjbUdsnNXEhAkXJaAt8F4x39nHz9/vOCb/zpakY5SZI=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB6054.namprd04.prod.outlook.com (20.178.233.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Fri, 27 Sep 2019 00:17:01 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::9821:67e1:9799:b117]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::9821:67e1:9799:b117%3]) with mapi id 15.20.2284.028; Fri, 27 Sep 2019
 00:17:01 +0000
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
Date:   Fri, 27 Sep 2019 00:17:01 +0000
Message-ID: <BYAPR04MB5816017131A10A32CC54D756E7810@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <Pine.LNX.4.44L0.1909261943230.24988-100000@netrider.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.44.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48be9023-86b1-4e37-cca9-08d742e0048c
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: BYAPR04MB6054:
x-microsoft-antispam-prvs: <BYAPR04MB6054D21AA7475F987507282DE7810@BYAPR04MB6054.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0173C6D4D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(189003)(199004)(14454004)(74316002)(476003)(66446008)(64756008)(66476007)(66556008)(66946007)(305945005)(54906003)(33656002)(66066001)(316002)(7736002)(446003)(6436002)(52536014)(486006)(9686003)(229853002)(5660300002)(55016002)(76116006)(25786009)(186003)(86362001)(6916009)(7696005)(14444005)(8676002)(53546011)(102836004)(81156014)(256004)(81166006)(76176011)(71200400001)(8936002)(478600001)(4326008)(6506007)(26005)(99286004)(6246003)(71190400001)(2171002)(3846002)(2906002)(6116002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB6054;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fDdJTBOVvpnp9kF6MYmC+Fs6/H46tFCwGiCKh9g8v1xfZvaf+SVS0csNLiSN1ChUPP0c8SuSSU4ThRlFR2dtLybcPxcym1uI9qW0BEmkyJ74FlSeK3tu299hoViATGiV9vscHriqtk1i6TJcbLAh2Iq6HoBfFyTmh92G//99WhPRUUn/FD93b/V36Uf/yV7LOHaxASp/C2TVecB6MZcGqU9L6eEG+I+ITk6I5wS6lrWGVfc2eNVhGroFcikjgnv43BCYn7r2XtPp7eAdcKGhrwoDrIKR6HOSOjMSKgQtMfYeuWLEgWNIBlIHsOsHuxNTlSWHnk0RBeKHiiR/Cj4Ujp9sYpDBzuejDLz7/xiuXAWNoyTQ/dl/A6VUTbMKlvYOjvskd+CbVLS7vSqy/QoG7OEf69ldh7bTIJNy+TiuKM8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48be9023-86b1-4e37-cca9-08d742e0048c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2019 00:17:01.1019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KKg1Ye9GyH+CHjoE6P4wQAkY5IlemQpwAngzae/hYc8PvpsMd+v5aICh0CUfoK+FmrBlyFce9PHNtM9nD4BlZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB6054
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/09/26 16:57, Alan Stern wrote:=0A=
> On Fri, 27 Sep 2019, Damien Le Moal wrote:=0A=
> =0A=
>> If a non-passthrough command is terminated with a CHECK CONDITION, the=
=0A=
>> scsi error recovery code reuses the failed command scsi_cmnd structure=
=0A=
>> to process error recovery request sense. To preserve information=0A=
>> regarding the failed command, the functions scsi_eh_prep_cmnd() and=0A=
>> scsi_eh_restore_cmnd() respectively save and restore the original=0A=
>> command information. However, the resid field of the failed command=0A=
>> request structure is not preserved and reused for the request sense=0A=
>> handling, leading to the original command having an incorrect resid=0A=
>> when:=0A=
>> A) The command is not retried and terminated with an error=0A=
>> B) The command completes after retry and the underlying LLD does not set=
=0A=
>>    resid for a fully completed command (resid=3D0)=0A=
>>=0A=
>> The first patch of this series addresses case (A) above by adding resid=
=0A=
>> as part of the command information saved using struct scsi_eh_save.=0A=
> =0A=
> Good catch.=0A=
> =0A=
>> Case B can be observed with a WD My Book USB disks when a read or write=
=0A=
>> command is sent to the disk while the disk is in deep sleep mode=0A=
>> (spun down) due to a long period of inactivity (~30min).=0A=
>> In such case, the following command sequence happen:=0A=
>> 1) The read or write command is terminated after a few seconds with=0A=
>>    CHECK CONDITION and an asc/ascq of 04/01 (LOGICAL UNIT IS IN PROCESS=
=0A=
>>    OF BECOMING READY)=0A=
>> 2) In response to this failure, the USB mass storage driver triggers=0A=
>>    autosense processing, reusing the command descriptor to issue a=0A=
>>    request sense command with a 96B sense buffer size. The reply=0A=
>>    to this command gives a NOT READY / LOGICAL UNIT IS IN PROCESS=0A=
>>    OF BECOMING READY sense of 18B, resulting in a resid of 78B.=0A=
>> 3) The original command is retried and failed again, with step 2=0A=
>>    repeated, until the drive spins up and becomes ready.=0A=
>> 4) When the original command completes after the drive has become ready,=
=0A=
>>    the request sense command resid of 78B is seen by the scsi disk=0A=
>>    driver sd_done() function and wrongly generates a warning about the=
=0A=
>>    unaligned value reported.=0A=
> =0A=
> But with the 1/1 patch in place, 4 won't happen any more, right?  =0A=
> sd_done() will see the resid from the successful read or write.=0A=
=0A=
No it will not because the USB driver does not set the residue when the val=
ue=0A=
returned for the command is 0, that is, when the command succeeds after the=
 disk=0A=
spins up. E.g., in my test, I used a 4096B read at LBA 0. With patch 1 only=
, I=0A=
see a residue of 4096 since the command is entirely failed with CHECK CONDI=
TION=0A=
until the drive spins up and becomes ready, at which point the resid become=
s 0=0A=
but is not set with scsi_set_resid(). Without patch 1 nor 2, I see a residu=
e of=0A=
78B which is the residue from the request sense executed between retries of=
 the=0A=
read command.=0A=
=0A=
Patch 2 is needed to make sure that the residue is set to 0 when the comman=
d=0A=
fully completes. If there is no failure/request sense/retry dance, resid is=
=0A=
already 0 (initialized value) so there is no problem. The problem shows up =
only=0A=
for CHECK CONDITION + retry patterns. Tests confirm this. Only patch 1 does=
 not=0A=
solve the problem.=0A=
=0A=
>> This problem is fixed in patch 2 by always setting a command resid to 0=
=0A=
>> when there is no residual in usb_stor_Bulk_transport(). Note that=0A=
>> usb_stor_CB_transport() does not need changes since usb_stor_bulk_srb()=
=0A=
>> always sets the resid for a completed command, regardless of the=0A=
>> residual value.=0A=
> =0A=
> Exactly the same reasoning shows that usb_stor_Bulk_transport() also=0A=
> does not need changes, doesn't it?  Which means that patch 2/2 is =0A=
> unnecessary.=0A=
=0A=
In usb_stor_Bulk_transport(), since scsi_set_resid() is only called under t=
he=0A=
=0A=
if (residue && !(us->fflags & US_FL_IGNORE_RESIDUE))=0A=
=0A=
condition, resid is not set if it is 0.=0A=
=0A=
Whereas in usb_stor_CB_transport(), through the call to usb_stor_bulk_srb()=
,=0A=
resid is always set, unconditionally, with:=0A=
=0A=
scsi_set_resid(srb, scsi_bufflen(srb) - partial);=0A=
=0A=
where partial is the command length for a fully completed command (the vari=
able=0A=
name is misleading), leading to resid being set to 0 as needed for successf=
ul=0A=
commands.=0A=
=0A=
Please let me know if I missed something. I can reproduce the problem 100% =
of=0A=
the time, even though it is painful due to the 30min wait between tests to =
wait=0A=
for the drive going to sleep (if I force a sleep power state, the problem d=
oes=0A=
not happen due to power control the drive USB bridge FW, I am guessing, whi=
ch=0A=
will wake up the disk before the command is sent).=0A=
=0A=
> =0A=
> Alan Stern=0A=
> =0A=
> PS: The correct term is "residue", not "residual".  I know that the =0A=
> code sometimes uses the wrong word.=0A=
=0A=
Thanks... I keep using resid but trying to write proper sentences, I mess u=
p the=0A=
word extension :)=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
