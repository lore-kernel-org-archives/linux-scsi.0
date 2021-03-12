Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9434C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 08:00:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFFF664F83
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 08:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbhCLH7n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 02:59:43 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:33613 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbhCLH7l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 02:59:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615535982; x=1647071982;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=hgjHwpwbMRZ/hIZAn+NlohH9J0vFvXlqhqnFN5AEBE8=;
  b=ehLLy6fojqUD2yzZXw+q2K6Gl72sbFzheMo5J9rxLxdMa40ecEsEMob/
   zRHTirdf/2S3T8Idf+Ko+aHgX2rPraZoHHUKihIu8kNg62oHcTVrqjRcM
   Qea/5iQEuF+gqVDpGYAWcwH8Y3GCor2XLlifIELoDs33THxhis6+RKoBm
   Yg7lAo4oEJfhIYjCx1SZI6zjVJ3glWmdgLx4MfFkRNExYUsLpX0mZQNUX
   00Ceu4PTUlAXKQNTmG9ZEMzSPzwpOqNWAJjg8ByLDD5TyYhXTpaWXXD7N
   FiIOChK0wBlAVUvsiyRXDEBm+jofrqTU/M30ascGJf/aVkeJPs+TXIE2d
   A==;
IronPort-SDR: 7i9cNE1Aesw0zvu/m8xWjx6CgBq/9vfL6vwcl1C/5Ife5jaEKLXOB29Cv+3ZJs5YQJe8Le3ViV
 6EzOx6bApT2NcuKFJLj7n3SnenmCAl7QHxTeY7yZBTlSkgCJJHGJy1QUMSzIoUWBxIVwJXsd0d
 K1ZvSI97IAgvaZ67+HXYGU++vDgsgNt7SU5s/+FWrrSC66UD+7gtxnvlqTsU29P+35UeD6MaqD
 BSpEJu3N6BUv0s36eGb5a24vATVTbKPO3QyenHcmd14NIyM/tuzypeu83RsrXd6acPxQFW3NMy
 9gA=
X-IronPort-AV: E=Sophos;i="5.81,242,1610380800"; 
   d="scan'208";a="266346672"
Received: from mail-bn7nam10lp2106.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.106])
  by ob1.hgst.iphmx.com with ESMTP; 12 Mar 2021 15:59:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RX0zfds36jkVUxJWIHfO0qMx5VEXD7ecCH4hz8jBhmyW17EXBy5jQ06EZLmuomasziGWnMADt1FymAjJoDYDWXnDPWpOiMn+TWFSVi/zJVAnIq9kgiIsYlZHrWUW7VjrneAy0K9j/J8R457619iasSEs/zxtZ9U1bDytSVWfmMAjY902Q/1WaDX9l2KRdXsCROEVTX+Cq+0hJh/I/fiNC5ucAWk/N/iKVfNqGuRxp/rRk3ZFC/EZAj97wynDDqEfnaW65QXVJLk8MkiPYKOTGyDEEVT0yGIl5OFdYggZmGJr3xYHe3juL+8gKgtQcyg3XZJx15v+/Cx8UwkN8xF17g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZLa4JYirbTbU8nUMc47IaI48NXOT2tjHffw+4N06V1A=;
 b=jE5wqOx7hsGaukUIT3sOdcLMgXADzgBGC/RtlZL6UBVKB4+zrYPRvutV3wjcAb+uXl9coGJNs/VzD6Cot1bufZNwUYYZNrcsH79ITG8rv5KQ4W6XVHCjecQX080RXZdYaelZnFe5tDnvd0BP3G1lqGGWfc5i+vX3UnyRnULXShftnIlZB+kUromeAKKGulv7QttSqv/SYCzILgH38R8ENlZvYSE7Hvx4Ne4zGADjWyHzuszNoSfVIK4Y1zrv4k7/JIdL1mB1VXvNrXEEULTDTxIPptRQiodb7v/SkNuEQ2R+3zJf6HqvslWgVdK1uImKuQ/8xLAMP9SY0R+FdzM1UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZLa4JYirbTbU8nUMc47IaI48NXOT2tjHffw+4N06V1A=;
 b=A6IGRK1g+Ap1J4a9q8/fG1E7Y9Fuc5aUDSvL+ij9amd0cegWEWO3E2HZVsrm0SY0GO24/HzMDl2oSc5kEphxE649o2o9fIqZvYFIqhkzdohZp31igXXFbORMmEZ+QXUtKgdviOUEMoeX74+ClxrJ0s9A2Rtb8zzfxB/o19zYLkw=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7381.namprd04.prod.outlook.com (2603:10b6:510:1a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Fri, 12 Mar
 2021 07:59:37 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3933.031; Fri, 12 Mar 2021
 07:59:37 +0000
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
Date:   Fri, 12 Mar 2021 07:59:37 +0000
Message-ID: <PH0PR04MB7416C8F6506400FECB7207AC9B6F9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
 <2a68a06c-7bcf-337d-b819-9e8f63f5e68c@acm.org>
 <PH0PR04MB7416733D30D20EA68EBBE0EB9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
 <87928742-6bba-1db1-1ee2-4d62188b2cbb@acm.org>
 <PH0PR04MB7416FFA8BC2332DB647FA12E9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
 <20210312043828.kl2olk2d7awfsi7j@shindev.dhcp.fujisawa.hgst.com>
 <BL0PR04MB651449ABC126A9FEA02CCB08E76F9@BL0PR04MB6514.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1542:e101:5840:9cdd:b1cc:ef31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 80f3ef2f-9e96-49fe-e625-08d8e52cc85f
x-ms-traffictypediagnostic: PH0PR04MB7381:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB73818BDA58C921192C5FC7BD9B6F9@PH0PR04MB7381.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gm6Z4hpQ8DsE/8nqmnlS2hJi57RD+S+yE87KO1wr3/dC8zAF6KrVYe0KdDTW6z45oljhY9UB3u7NBIbUCcSXjVtW4sVGIFYGyvRWtJdm5SUWAqP5ELlobOM+sDo80jRbyuQexurw2JZlVYBLWHhYqBNnb1eqhqCdQfBprYAdfwVPLFf00piIChH6SXTWZUOXE5HmphqqtMLusP3g56JAfi9dZKAaGzRrXTzGpX28TYXYSTWz+Sy9vnezFbUcaf05CyDM9w/c6aXRGE4KiJ2uUutjFT/ago49SohwSuEHQ7i8cLD56XzoM55RyZGlZ3FlpHZqVOIu/m4cwrOHNFWZTtUOZLLN70w27f6G2rWuPehhbF6PtfRGZLJ1FYVjj8F39u3GsDUy6LJLzZdearZ4uzYk9y7YLt5Vzd9ebhaoJHoDDawSubZviQGxhRWy/GEoSuyDCGPalYq5L7PtgsMiRwKOND5GSUK56Mo3PiDn2c3aFoDkpmulg4cEWbjrq7nKFaK0zVyinQX4BdxAmaG/ArhGe5emzv2jAdAh/Cmlv97I9mJyt3nLwG71ratYOfTz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(110136005)(2906002)(478600001)(54906003)(6636002)(71200400001)(86362001)(5660300002)(4326008)(52536014)(33656002)(66446008)(8936002)(64756008)(9686003)(55016002)(186003)(66556008)(316002)(15650500001)(66476007)(76116006)(91956017)(8676002)(66946007)(83380400001)(53546011)(6506007)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?/SbNWMgqowF0UPqy6s+bfAJzB3EwxKET1K5ay8fCNtpY771th8sQ0iyw4iuH?=
 =?us-ascii?Q?jmeiY+P2WB2B7VMYctqYZBMJpJWxJONRHs5gHKQ9+ZQDfM1F9tKyjOOJcTxg?=
 =?us-ascii?Q?/DSHVHkWVMg2l9WZMcXryYuMR/PNLmLfv66JyH4v2vzrvHDq23Q5UlBOdNV/?=
 =?us-ascii?Q?M2pZcbSZGFfiGIWTUp2CYpo3xU7JO/AoTOViE5JxFt+SfQLY6AWBqQ8pk91E?=
 =?us-ascii?Q?MGbQ5umPqqUarxDBaz0pm6VieyUH0avmEVfdlVUmQaWgcQ68rRaAqOQEg4Xu?=
 =?us-ascii?Q?arf3RUZ0M855r+sW3UcEyMny52QcqnhE8SD1k22UW9JnmkLUJRs6c0YFA2dM?=
 =?us-ascii?Q?+52qMKbxcTLxKDq6WrdA+rrQPUadjT/ZHjGZTSnF/Kw7wzj4RkQbCkBBHAnh?=
 =?us-ascii?Q?QtXNT/HJbkn9pnP/dYE50OwNbssi2oN+fBb06y/Bh+iS11moiGStJfUNwtRL?=
 =?us-ascii?Q?ePrV6ZB/4mtoKn9hF80FFgJVmXMG8gALmEbTBa4E4mOtKL+Apo+t/MRIAsdA?=
 =?us-ascii?Q?Ix9epq7IKBQlc0xHeuh+LCqoOzQ4BMjIKM0K1D13cjcn8gFSnweV733EdmWR?=
 =?us-ascii?Q?X6DkyUrKSfkA7EAYL4L9VVHSd1s3PpwkpiDAHoMB/5jOO4jOdBXjIfdOWrUa?=
 =?us-ascii?Q?vj3dIHpsfthejPxaeQHCrdC2xC6I47L9D4JGQVqr8Xevb1sTQF1hfgtUWG2f?=
 =?us-ascii?Q?Vg2VqLtHzF0qthCJLG1NuO4VBBoksQxL1GMqB43G8uTOhPjIo5nYUQtID+T+?=
 =?us-ascii?Q?dG1ncHJZoS/Kv9SKoEDO1mHXyqRWBE0cJ3dKTsvVc17t+mCOJR5AmTUICTNz?=
 =?us-ascii?Q?1kQTmnNH6IkO0H5caYLFKViK5cOaU3B8e9Lk9V5bCY04gUeLkAMzmykcDKBT?=
 =?us-ascii?Q?bygG7wKvbnmmR77cTCw2mry4jj6f6kU+hSOeAFOeV76CPn/roeNhxgi2LwjW?=
 =?us-ascii?Q?Ui+MIauzYj52Z6rLcGugv23rJVCaB3Ee7XjQnvLF3B1snHKC7W+jvLf3xoox?=
 =?us-ascii?Q?oAmXBVarwFCqyuohP4I7q91jOditE7OGCBLEd7eh/HSsIhTfYmg8aYRY7YZ0?=
 =?us-ascii?Q?uqVhMqWv6Njdy0VPpwUe8LG0k230Fc0tKPe43JZfhYyGkE/MdhQBbvYp47b8?=
 =?us-ascii?Q?8p7OVDWRJihkkwDNvEw1OiFxMywDaoTn4742Qa3kfuT7hMvlSRuZ8ycXyBBa?=
 =?us-ascii?Q?8ih9Roqd61JzXt6pCJ+eFBKREHozYIrp9YkMex1sNi663snvwsY60srcI+ku?=
 =?us-ascii?Q?116z+3hbCJiahrv+Qk8drC1qbu+eZJ3/gUE13Tf47vOgw4nYW5x2oL0gAisZ?=
 =?us-ascii?Q?fiAFcji4JeCBHbIEptd37LE19iOXNhAEUS/6fjmuDXePWsJ4VuI/jxKYNdYE?=
 =?us-ascii?Q?0ZAJlejam7jPQTpHf+I8luLMlyq8F+jGq0SNnyi0qeJNrXlj2g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80f3ef2f-9e96-49fe-e625-08d8e52cc85f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 07:59:37.4192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hfOsKcsnO4BKNfGs1hzaZpBvrGunGIl9f2ULBYUXTTMny8hLInYMTQ7JP300yd/ppwQyt8N0BGJmhuRd7gAXfks8yT4FaC8v4leS8RYDWUM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7381
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/03/2021 08:27, Damien Le Moal wrote:=0A=
> On 2021/03/12 13:38, Shinichiro Kawasaki wrote:=0A=
>> On Mar 11, 2021 / 15:54, Johannes Thumshirn wrote:=0A=
>>> On 11/03/2021 16:48, Bart Van Assche wrote:=0A=
>>>> On 3/11/21 7:18 AM, Johannes Thumshirn wrote:=0A=
>>>>> On 11/03/2021 16:13, Bart Van Assche wrote:=0A=
>>>>>> On 3/10/21 1:48 AM, Johannes Thumshirn wrote:=0A=
>>>>>>> Recent changes [ ... ]=0A=
>>>>>>=0A=
>>>>>> Please add Fixes: and/or Cc: stable tags as appropriate.=0A=
>>>>>=0A=
>>>>> I couldn't pin down the offending commit and I can't reproduce it loc=
ally=0A=
>>>>> as well, so I opted out of this. But it must be something between v5.=
11 and v5.12-rc2.=0A=
>>>>=0A=
>>>> That's weird. Did Shinichiro use a HBA? Could this be the result of a=
=0A=
>>>> behavior change in the HBA driver?=0A=
>>>=0A=
>>> Yes I've looked at the commits in mpt3sas, but can't really pinpoint th=
e =0A=
>>> offending commit TBH. 664f0dce2058 ("scsi: mpt3sas: Add support for sha=
red =0A=
>>> host tagset for CPU hotplug") is the only one that /looks/ as if it cou=
ld=0A=
>>> be causing it, but I don't know mpt3sas well enough.=0A=
>>>=0A=
>>> FWIW added Sreekanth=0A=
>>=0A=
>> The WARNING was found in kernel v5.12-rc2 test with a SAS SMR drive and =
HBA=0A=
>> Broadcom 9400. It can be recreated by running blktests block/004 on the =
drive=0A=
>> (after reboot). It is also recreated with SATA SMR drive with the HBA, b=
ut not=0A=
>> observed with SATA drives connected to AHCI.=0A=
>>=0A=
>> I reverted the commit 664f0dce2058, then the WARNING disappeared. I supp=
ose=0A=
>> it indicates that the commit changed HBA driver behavior.=0A=
> =0A=
> Can you send the warning splat with backtrace ?=0A=
> =0A=
=0A=
The warning splat is in the commit message:=0A=
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.12.0-rc2+ #2=0A=
 Hardware name: Supermicro Super Server/X10SRL-F, BIOS 2.0 12/17/2015=0A=
 RIP: 0010:__local_bh_disable_ip+0x3f/0x50=0A=
 RSP: 0018:ffff8883e1409ba8 EFLAGS: 00010006=0A=
 RAX: 0000000080010001 RBX: 0000000000000001 RCX: 0000000000000013=0A=
 RDX: ffff888129e4d200 RSI: 0000000000000201 RDI: ffffffff915b9dbd=0A=
 RBP: ffff888113e9a540 R08: ffff888113e9a540 R09: 00000000000077f0=0A=
 R10: 0000000000080000 R11: 0000000000000001 R12: ffff888129e4d200=0A=
 R13: 0000000000001000 R14: 00000000000077f0 R15: ffff888129e4d218=0A=
 FS:  0000000000000000(0000) GS:ffff8883e1400000(0000) knlGS:00000000000000=
00=0A=
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
 CR2: 00007f2f8418ebc0 CR3: 000000021202a006 CR4: 00000000001706f0=0A=
 Call Trace:=0A=
  <IRQ>=0A=
  _raw_spin_lock_bh+0x18/0x40=0A=
  sd_zbc_complete+0x43d/0x1150=0A=
  sd_done+0x631/0x1040=0A=
  ? mark_lock+0xe4/0x2fd0=0A=
  ? provisioning_mode_store+0x3f0/0x3f0=0A=
  scsi_finish_command+0x31b/0x5c0=0A=
  _scsih_io_done+0x960/0x29e0 [mpt3sas]=0A=
  ? mpt3sas_scsih_scsi_lookup_get+0x1c7/0x340 [mpt3sas]=0A=
  ? __lock_acquire+0x166b/0x58b0=0A=
  ? _get_st_from_smid+0x4a/0x80 [mpt3sas]=0A=
  _base_process_reply_queue+0x23f/0x26e0 [mpt3sas]=0A=
  ? lock_is_held_type+0x98/0x110=0A=
  ? find_held_lock+0x2c/0x110=0A=
  ? mpt3sas_base_sync_reply_irqs+0x360/0x360 [mpt3sas]=0A=
  _base_interrupt+0x8d/0xd0 [mpt3sas]=0A=
  ? rcu_read_lock_sched_held+0x3f/0x70=0A=
  __handle_irq_event_percpu+0x24d/0x600=0A=
  handle_irq_event+0xef/0x240=0A=
  ? handle_irq_event_percpu+0x110/0x110=0A=
  handle_edge_irq+0x1f6/0xb60=0A=
  __common_interrupt+0x75/0x160=0A=
  common_interrupt+0x7b/0xa0=0A=
  </IRQ>=0A=
  asm_common_interrupt+0x1e/0x40=0A=
