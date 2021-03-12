Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F90FC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 08:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48C4764FD0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 08:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbhCLI63 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 03:58:29 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:27038 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbhCLI6V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 03:58:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615539500; x=1647075500;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=p+qWtefb5KTu6WS1vQQA4gM9+/zRTV/asAiIwWMj9gg=;
  b=rXe7bIvJnA1jLbQXM/aRdM6rvoCqC1DgpspPLbkOPtbk0TX2k9bhrafz
   phlo0axVcUWfhcT+ZuNxvnVfcTA20wuisQv7mxKcbN+QQtFZ3uw13VuPJ
   q8HTCLIp2pqTECN8IjwwcDGpfiK0S3WLOAsVm6UsFvd+AESbTwSZu2Pr6
   fTSqDHYU22qxMb4qAJI/0KZka92jVzWmdYSK0U50NyrJuLtyKAAML2Gmh
   +7a24tcHZyeS7OchE5jLG3aB73NVt00l8Xv5UKwY4c0FZWrnj0Ke+u5k8
   WEe7Mgp43SkszfdkjJgyNHPlzu6jLI/Vi9aBNbU2SCOa2Ww75HdmGl1zX
   g==;
IronPort-SDR: tYq9MWF8/O1kXgIkZxxV87JQ5hG86Dbjb+zYc3jiSfMA8fPc7XbeTsz9ggZa+Zy5QhnVUhAHHV
 kEh+EHoHqBs70nm8674m3b56bqjt0DPXP75J6dIkroWkpyZW+jVG18Y6im8IFNGKR4c2Bharxs
 /BXz3eNw3wUsYJw/OjXgO8eRjA7r4aIIQ5UV9YWNMxpjJNZAA02f4BXuEPsm0WvqvOtWGmapE7
 2NOOlrSvkQRpG4BhmxcDJ0QWzNrJxenmcsuLLV1czqUfdJoa4LL6aaJ+XcaMhXq5sOAM2z2FD0
 s60=
X-IronPort-AV: E=Sophos;i="5.81,243,1610380800"; 
   d="scan'208";a="161984848"
Received: from mail-bn7nam10lp2108.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.108])
  by ob1.hgst.iphmx.com with ESMTP; 12 Mar 2021 16:58:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUtLHhWyFreEh9WOsvSqW6yaPoCo/dyStl4QqKtZA5fwAGWrBxSl7na1iNAqE5fm0EfysAmd2RPH3eWvrx/Jxn6+snKEAqsUhi7UBkmra5+qczS1I4+aB2e02fMwE7aaWFkmp0BclAJU772nj+LVfEfkctHmpJ82AexBSCk+OaY6TDwtrfS3sAdgV1g5e4uvC/X0dFJZqhVO8X1w77SFfXs0wXNAhEUteKIIL2BbTknM91MmhgxgrSv+RQaOZcrYbMwaN+znuI27rpkQzG7B5VfEJ5gqGpbzaDYsBIP4K4bV7KtAEoMjJGMULk10n/4zDlEIAZvOmmw9JqjNkvVQCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZBBS3fWt4YD5UZhOpoRQaJCwV0wBMv3TIe6ZK24/uZU=;
 b=iihWcq5j+xa+cEKWfvHmeYhQING2JVrS7dAINQJY/nbg+kF+VhQVFA+BNJ6BipzdCxLye2ygoSERToGZIO8LAZ5I3V07mTO9XYIkVA33grHfJcnpNKaiaajfjsgG3uXF5GYowpXukbrVeNtYFMXf9HXLh3qgLYADg+JHsDgBJNgoiBRZSfXUgBiEYI1QxAm3qpwbVTckHVjQJ62uIEKnTzWGLQOsIXo7slEsFH1E/tPUN6ZHsLVjVRu1B4g/p+7Jan1hUA4KpN+VqbLuywEZHlOivs5NpKFM7cexwN+WScyFEhM0RopFyRp3uJzD1821jlXAzWQhnkJhyNZvqFtYtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZBBS3fWt4YD5UZhOpoRQaJCwV0wBMv3TIe6ZK24/uZU=;
 b=B0/79/ama0txXXdIg1hCErcvVzuq3LiQHGrpLRJq2RJEbrbAHrECzYSIg64GAYdPCG1vozYYymdAfqQq3tb6DyL64KgtSsu56FF1dJ3ByEgOY0J9e6UhMLy2528wP8XC9yY2giT0RKc8fsAkJvCH9mBcZhuC0ymVtcjRqTMq3CE=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7670.namprd04.prod.outlook.com (2603:10b6:510:57::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Fri, 12 Mar
 2021 08:58:18 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3933.031; Fri, 12 Mar 2021
 08:58:18 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Topic: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Index: AQHXFZJ9Ugg++iEKb0KOzcBTGpFywA==
Date:   Fri, 12 Mar 2021 08:58:18 +0000
Message-ID: <PH0PR04MB7416C0E44B45C3FCDA7127989B6F9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
 <2a68a06c-7bcf-337d-b819-9e8f63f5e68c@acm.org>
 <PH0PR04MB7416733D30D20EA68EBBE0EB9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
 <87928742-6bba-1db1-1ee2-4d62188b2cbb@acm.org>
 <PH0PR04MB7416FFA8BC2332DB647FA12E9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
 <20210312043828.kl2olk2d7awfsi7j@shindev.dhcp.fujisawa.hgst.com>
 <BL0PR04MB651449ABC126A9FEA02CCB08E76F9@BL0PR04MB6514.namprd04.prod.outlook.com>
 <PH0PR04MB7416C8F6506400FECB7207AC9B6F9@PH0PR04MB7416.namprd04.prod.outlook.com>
 <BL0PR04MB6514879C187E6C81593F41B7E76F9@BL0PR04MB6514.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1542:e101:5840:9cdd:b1cc:ef31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7f5b64e9-bd0d-4409-7dd0-08d8e534fb0c
x-ms-traffictypediagnostic: PH0PR04MB7670:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7670C417D64E73A68CAEBF029B6F9@PH0PR04MB7670.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AD9/vsgwDK4scVemBgSxC85ccUhC7LDzQqqI9Ba4YG31XsgjnhAcrdcxb9FTQy9NH/p8rZ01ZN27fJ5hb0t6lf4JSRzKpuz//uwN6vCoFsggRBqyRMsKBdFyaL7h9U/8gIeKvkgsQZqwHLWAH2uVWu5rSfCYA3r3Pyrrf+AhGGNaBjL/kYq6/OyTrV37Z7ZJog26Vsb0nZBzELE00ioVYBwWzyU1u6yntW2+55T0ub379MoEJkR7jktIsrYRafRQ/mVUCJzSUKq+u9xSFFeB5HMFRpV+CnoIdFEP2D4Yob//N7EaziTxU57ZBdA6Lo1AcAMjRIfPwQsClhhFE/E0dXICg0vmHh338Kb+cyZThOYcl36zY0+wOgMg8F053764gAsNf8kzy+EMPTXhSf/tBdCSi9NtWZyfdnsoij1uP15g0LMOQXoGAxfHrZTKDUzDBGp/dlpu8wzEc0vXVx7Wxh7+Cp7gbv4t5EHGHrVR/xJn3NWO7IdW/6kNMEzcQ5u9zeNJbdYNic+QMwXdkt7R+QrQYrpiTYGX+me+C1b29mFRoQ6E6jGfypPrKYhBDbAc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(66476007)(9686003)(76116006)(91956017)(6506007)(52536014)(83380400001)(66556008)(64756008)(55016002)(5660300002)(478600001)(66946007)(4326008)(86362001)(7696005)(66446008)(71200400001)(8936002)(110136005)(316002)(33656002)(53546011)(2906002)(6636002)(15650500001)(186003)(54906003)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?qrzw7/qinzLqY/Q31emr/TjtgDTDixSRWBuII3mlZ1902hs2zU97f+x0M6BT?=
 =?us-ascii?Q?hamSyYFoeeenvH6CCzJhLJW0uxAAwrhDi4jW2ds5QDKPuwC6BBhYTr94lhsu?=
 =?us-ascii?Q?6KF/Aah+ur9P7fkjn9XCYFShEyoj5lUOxMNtdmSTQyT0RemoOa2QQSexHqws?=
 =?us-ascii?Q?jFMyOorbub6tXDwKQav/Pcg4gPVDREVVtiSb4uPuaX2Pwz4O4ALeRU/3eJ5N?=
 =?us-ascii?Q?+RfAIdU85BjH/segIEzHbUOWztOiVfBeqUrOX7teCEhBuReKsyK/uN24S9pk?=
 =?us-ascii?Q?mFd/AB2V5z/jDE6qNhGXQhZHbahI7l32nsttHFrkiGi8R1gwu2e3ddbW/QoO?=
 =?us-ascii?Q?Kx+o07PFS7rbGlc1VDX8Hn/TPqCggJEu1ZTx8csFRBxjZm6B1uwTlDlA1XVS?=
 =?us-ascii?Q?FvpWvHeDrrox1YeH6hfGu3ZYcAT4HhyY4Pgnr04GP7Dr4lS5CeTFDWCtUUGl?=
 =?us-ascii?Q?QQLbPYBbxQdZVVlxdsbRWdIA1CSUZmz7v7niDNmWLwysZs3Ybf+ONSRDzbtV?=
 =?us-ascii?Q?uPBrmSwHUjdwDkbIKadMsE/uvHkem0lNC48iwMAWdaGR7yoEWtoEaML0OmrJ?=
 =?us-ascii?Q?m3KF7inlGARJoPv9kynKOWuyHYUykPnFbMGQEgrgeoGOKEWh5l896ewKSSqz?=
 =?us-ascii?Q?77NuWQ/8d3qq8YbOv2Ymn/iiVyXkh4Appmf+9ydypdb0m1i+XQcjXH/R+7ww?=
 =?us-ascii?Q?HfUdHn1TLREP+BpoHY4N2baAIwcy0NOn/K3E6VtatJJkIcea2oML+c8pKAWI?=
 =?us-ascii?Q?2Xyl3S6m7eGZm0G2U0O4CBFJXS+fd6V91EpqXoNoKjT2KRZ7wTK7heHgUceH?=
 =?us-ascii?Q?NDo0TJupeHnhJKIHBEFMNPIwt8CzLPl3GZuQ3lyE7OCL5UPB2cXfuujmWlmO?=
 =?us-ascii?Q?4dWGg8tWI4JPZ7lQsz87PWxeYFjIt9DLUU4MKTwl1ACe9d14yyeSYKL8sIyv?=
 =?us-ascii?Q?AMcwDVaGUuKqfbaC53bmo4a52K6Z+6ULsNp/VrNRxqVDIFff0J/0hQwgJQcK?=
 =?us-ascii?Q?h8E1+ZwwMBw1JnR2WRUgoPgD178J20xAKO2tGQk/SmS7CYhHgp5HrNw0aWss?=
 =?us-ascii?Q?sIln2SiaVZzVSnXXffvAvR1ldpEdbJPsZl65gbqHqzWgDZbZiO0QuXPSRYvf?=
 =?us-ascii?Q?buKy9pU3Zlf3CFo/0wBsfFy15eBHMTU3V1x1Kc1TRGcsnMli3tTin8UhUFlt?=
 =?us-ascii?Q?BftZGLpPDU1LkXY73nsLN+acK5REXxnmo07a0e7lSTug0g1/I5w+W1RxH9os?=
 =?us-ascii?Q?PLf5q/4hGhwkRY7pStuuVjdVOB6SoUC4qln8JKK/2RMMeKvT70nYo61K59hX?=
 =?us-ascii?Q?oEVMekouCj/8KhfTLs+W7SPnuN3IbPfVsVnPOVWggrPknoPJX+NjGhBy3A0D?=
 =?us-ascii?Q?JEsNKdJ4emqpX71//LrNdAHiEkE3VSFCbOJgEdnztq7MWxZzuA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f5b64e9-bd0d-4409-7dd0-08d8e534fb0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 08:58:18.4481
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0r6oc/5JtRQ8djN1XJp3a/aNuUNacjze6EtL2HHnYAYpM9j1s5SLit73EplK96v4Pyl9ZR0XqODzM23vnN+u75/rWKVmupESIusHtmoaTLY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7670
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/03/2021 09:20, Damien Le Moal wrote:=0A=
> On 2021/03/12 16:59, Johannes Thumshirn wrote:=0A=
>> On 12/03/2021 08:27, Damien Le Moal wrote:=0A=
>>> On 2021/03/12 13:38, Shinichiro Kawasaki wrote:=0A=
>>>> On Mar 11, 2021 / 15:54, Johannes Thumshirn wrote:=0A=
>>>>> On 11/03/2021 16:48, Bart Van Assche wrote:=0A=
>>>>>> On 3/11/21 7:18 AM, Johannes Thumshirn wrote:=0A=
>>>>>>> On 11/03/2021 16:13, Bart Van Assche wrote:=0A=
>>>>>>>> On 3/10/21 1:48 AM, Johannes Thumshirn wrote:=0A=
>>>>>>>>> Recent changes [ ... ]=0A=
>>>>>>>>=0A=
>>>>>>>> Please add Fixes: and/or Cc: stable tags as appropriate.=0A=
>>>>>>>=0A=
>>>>>>> I couldn't pin down the offending commit and I can't reproduce it l=
ocally=0A=
>>>>>>> as well, so I opted out of this. But it must be something between v=
5.11 and v5.12-rc2.=0A=
>>>>>>=0A=
>>>>>> That's weird. Did Shinichiro use a HBA? Could this be the result of =
a=0A=
>>>>>> behavior change in the HBA driver?=0A=
>>>>>=0A=
>>>>> Yes I've looked at the commits in mpt3sas, but can't really pinpoint =
the =0A=
>>>>> offending commit TBH. 664f0dce2058 ("scsi: mpt3sas: Add support for s=
hared =0A=
>>>>> host tagset for CPU hotplug") is the only one that /looks/ as if it c=
ould=0A=
>>>>> be causing it, but I don't know mpt3sas well enough.=0A=
>>>>>=0A=
>>>>> FWIW added Sreekanth=0A=
>>>>=0A=
>>>> The WARNING was found in kernel v5.12-rc2 test with a SAS SMR drive an=
d HBA=0A=
>>>> Broadcom 9400. It can be recreated by running blktests block/004 on th=
e drive=0A=
>>>> (after reboot). It is also recreated with SATA SMR drive with the HBA,=
 but not=0A=
>>>> observed with SATA drives connected to AHCI.=0A=
>>>>=0A=
>>>> I reverted the commit 664f0dce2058, then the WARNING disappeared. I su=
ppose=0A=
>>>> it indicates that the commit changed HBA driver behavior.=0A=
>>>=0A=
>>> Can you send the warning splat with backtrace ?=0A=
>>>=0A=
>>=0A=
>> The warning splat is in the commit message:=0A=
>> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.12.0-rc2+ #2=0A=
>>  Hardware name: Supermicro Super Server/X10SRL-F, BIOS 2.0 12/17/2015=0A=
>>  RIP: 0010:__local_bh_disable_ip+0x3f/0x50=0A=
>>  RSP: 0018:ffff8883e1409ba8 EFLAGS: 00010006=0A=
>>  RAX: 0000000080010001 RBX: 0000000000000001 RCX: 0000000000000013=0A=
>>  RDX: ffff888129e4d200 RSI: 0000000000000201 RDI: ffffffff915b9dbd=0A=
>>  RBP: ffff888113e9a540 R08: ffff888113e9a540 R09: 00000000000077f0=0A=
>>  R10: 0000000000080000 R11: 0000000000000001 R12: ffff888129e4d200=0A=
>>  R13: 0000000000001000 R14: 00000000000077f0 R15: ffff888129e4d218=0A=
>>  FS:  0000000000000000(0000) GS:ffff8883e1400000(0000) knlGS:00000000000=
00000=0A=
>>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
>>  CR2: 00007f2f8418ebc0 CR3: 000000021202a006 CR4: 00000000001706f0=0A=
>>  Call Trace:=0A=
>>   <IRQ>=0A=
>>   _raw_spin_lock_bh+0x18/0x40=0A=
>>   sd_zbc_complete+0x43d/0x1150=0A=
>>   sd_done+0x631/0x1040=0A=
>>   ? mark_lock+0xe4/0x2fd0=0A=
>>   ? provisioning_mode_store+0x3f0/0x3f0=0A=
>>   scsi_finish_command+0x31b/0x5c0=0A=
>>   _scsih_io_done+0x960/0x29e0 [mpt3sas]=0A=
>>   ? mpt3sas_scsih_scsi_lookup_get+0x1c7/0x340 [mpt3sas]=0A=
>>   ? __lock_acquire+0x166b/0x58b0=0A=
>>   ? _get_st_from_smid+0x4a/0x80 [mpt3sas]=0A=
>>   _base_process_reply_queue+0x23f/0x26e0 [mpt3sas]=0A=
>>   ? lock_is_held_type+0x98/0x110=0A=
>>   ? find_held_lock+0x2c/0x110=0A=
>>   ? mpt3sas_base_sync_reply_irqs+0x360/0x360 [mpt3sas]=0A=
>>   _base_interrupt+0x8d/0xd0 [mpt3sas]=0A=
>>   ? rcu_read_lock_sched_held+0x3f/0x70=0A=
>>   __handle_irq_event_percpu+0x24d/0x600=0A=
>>   handle_irq_event+0xef/0x240=0A=
>>   ? handle_irq_event_percpu+0x110/0x110=0A=
>>   handle_edge_irq+0x1f6/0xb60=0A=
>>   __common_interrupt+0x75/0x160=0A=
>>   common_interrupt+0x7b/0xa0=0A=
>>   </IRQ>=0A=
>>   asm_common_interrupt+0x1e/0x40=0A=
>>=0A=
> =0A=
> Looking at patch 664f0dce2058, all that seems to be done is to enable=0A=
> nr_hw_queue > 1. I do not see any change of locking context or irq handli=
ng.=0A=
> From the backtrace, it does not look like scsi_finish_command() is called=
 from=0A=
> softirq... Probably a change in that area is responsible ?=0A=
> =0A=
=0A=
=0A=
In scsi_lib.c we only have these two patches in that area:=0A=
=0A=
684da7628d93 ("block: remove unnecessary argument from blk_execute_rq")=0A=
962c8dcdd5fa ("scsi: core: Add a new error code DID_TRANSPORT_MARGINAL in s=
csi.h")=0A=
=0A=
and none of them can cause the failure either. In block we have:=0A=
=0A=
0a2efafbb1c7 ("blk-mq: Always complete remote completions requests in softi=
rq")=0A=
=0A=
but this doesn't look guilty as well, all it does is raising a softirq for =
all=0A=
block completions local and remote.=0A=
=0A=
