Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D30C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 08:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2E9764F8F
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 08:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhCLIVP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 03:21:15 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:15110 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbhCLIUo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 03:20:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615537244; x=1647073244;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=QRBbx6+9Qrcukb+yV6JpE+8EZr1mS6w25/evFIrvLOE=;
  b=QXsUHLOJuAa2kWZusap4PWwGhl+/SlbhGC4cFiEj3e/PMSGiI83GKA5C
   OCNai1GqdKfFnw/H85IZlL+7dTwpijkrTTzW8IoXk5H3+jnKaup4Rn1dY
   miLU01WpPtzeYvHYLLv29CFrzLunh7KX8plc7Yp20430+6T8e5m8VuDCo
   EAWDzBSH4Pe3ISiCZDKEwA1QWAIwKusICK4HUByr19tzTYYRfEkjWYvfQ
   q/IabDfITJYf5lJOORrcHHZXCSWUODlrwUmpVXDoVT0kG6nc2TpVnQvgK
   POsHMjUJ0ceEbTPEyj+tHS3WMTvZBgsONu5Ukf9XqrDu/uMxck+p0z67y
   Q==;
IronPort-SDR: 018J7zvV1i/yxjfsZWl+QtbhEJkNxBzr5znpGzD6+0YvmrgMbPKmdMT5Sw38H4V54ucSkxDsBK
 EXedoZh8ocUsP81tSnbqQv9I4CgKUghwvxFgpulxhtQYJQKU8LftUUMM12LnkgLDGbwcjzBOtG
 qBMIGhqXB1TYOMVWB82MPk4iVp99qJHLG+hn/q3uiwAOVLrImcKerCrQ8T9a/a/JOfN5EYLwd+
 dB+AN5J2fXztMIxafVFkfiII2HbnIaWX8pSXrGI6M74UGVokw8hMk0lf4C10Nmuk4YyUeWGVuJ
 Xmc=
X-IronPort-AV: E=Sophos;i="5.81,242,1610380800"; 
   d="scan'208";a="166490579"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hgst.iphmx.com with ESMTP; 12 Mar 2021 16:20:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWoZO4Zh9RblU94ypLdMCUqMesfbCa3M4s/cmEyc/aFdwq2HEHSqmoCrtpX2tPcYaAhXDCnv7/F0Zg5SvXxro7hLJDSk8BgnGvNLBAbfP2QfU/c54tk5/3Bn5eiUuC71YJGFp2lOGmWuuuSFKIUUOQ6eg+T5g7G2Y3gB1D+9Rl6X9yLHuuJqy/+zsYMlvLE4DKOh24ZKuh7lQd+qLl7KNOhprUBwbxHtFpTZcx8yAvtgzaVOlP/kn+3KWKMQ7mhHRsmZrryicCJerFjSxxtF7TVIRAIyo3lzNhEEjhFV7s+gKzjIxO5kFMtbL9GCPkNylGRK8wIGhWeCJS/qxFFI8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PzAklIZICOCvteWFW09zgCooeHPrgyjy2Lw2BJEXZk8=;
 b=VlqCmGzDXDMRTvQ8cPg5po4VSldhDTZVtfZR8NOhrOKY+IHs9qAYF8kJtBNmc/NmWWzJLQfoXbFK9/ayiswoTUA+BfWepSOfsR/Ona6yEku24tDoO0/KOwuuQIPv2dMo0xknkkzwFZbO18cn+VHObikO7C2PKCRvlmqJHWbhikC33vgNV9/K5bgv94XHQEHXuSexWd09wUTdvEVX+TVL3QeWM6pk9/0TbeF/yNKJaP/Ws7Rr5sAap2zXiZMUwOHZgkEV+EAY6hqAulh85C0kMWkZSFxF24R/7hZA0ZvTs682FOUi0LzO8Qj8sQAAzmhcm235YjgbWmWSmLNuwfWBFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PzAklIZICOCvteWFW09zgCooeHPrgyjy2Lw2BJEXZk8=;
 b=HKrWvBCDJoTVs8LrlxvJpMrXraLJ40rSM+ePh0Q8iQRgIPhLSLPK0jVF5GNVKmwukDkj602FYtjLZdLKNb0NtnK5LDIL5C5IhE3v7jvS8nSsqTkT36EP9Hk7F1GDCR439WNdmxvei32j7fCQlw6TIlYkvBbGhpwuv0Km+dhiSaE=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by MN2PR04MB6640.namprd04.prod.outlook.com (2603:10b6:208:1ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Fri, 12 Mar
 2021 08:20:42 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::e9c5:588:89e:6887]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::e9c5:588:89e:6887%3]) with mapi id 15.20.3933.032; Fri, 12 Mar 2021
 08:20:42 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Topic: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Index: AQHXFZJ927MRhl54FUuu2AgpdB7HQw==
Date:   Fri, 12 Mar 2021 08:20:42 +0000
Message-ID: <BL0PR04MB6514879C187E6C81593F41B7E76F9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
 <2a68a06c-7bcf-337d-b819-9e8f63f5e68c@acm.org>
 <PH0PR04MB7416733D30D20EA68EBBE0EB9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
 <87928742-6bba-1db1-1ee2-4d62188b2cbb@acm.org>
 <PH0PR04MB7416FFA8BC2332DB647FA12E9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
 <20210312043828.kl2olk2d7awfsi7j@shindev.dhcp.fujisawa.hgst.com>
 <BL0PR04MB651449ABC126A9FEA02CCB08E76F9@BL0PR04MB6514.namprd04.prod.outlook.com>
 <PH0PR04MB7416C8F6506400FECB7207AC9B6F9@PH0PR04MB7416.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:bccc:6f52:efed:4bfb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ed5fdb83-2e33-4109-7e77-08d8e52fba5c
x-ms-traffictypediagnostic: MN2PR04MB6640:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB664074D671B8A1579CAB20DBE76F9@MN2PR04MB6640.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O1gZc+I/mG9UC5v8fN8GK3xV6vbzXDAlKzbZOUf0Bjq6NQDW6w7klCFWHK7C0aS+LBb2/hkhTB7Ks6gPPm8BlaM5oFoONY28nlu/Y2r236GWTGuDzc7fSRGc1oO9rUUHcdIJ3crfPLDQYKdtuy+7InmZKjCqRiAWr1is/DxcuBQ9A4iyiZiwqXFsWfl6vY5uNtBdWCI17Gbw+15Oy0aEJ0asudLENathnyxSHIbb/NL+IYQorG6OXzUi3CdLmaezxRg1lAEWD2SPIiuLbPofO3csb7CXBMBbxcvkC4kkzFjyS1TfTsHBCbAVngz/1o4jP3kr7PYgI54gAnaa5XEa/jJ2QwpjNeauOE0YAjuKQFAwzqPE55NTFwKCZk6JJGpphIu+1vnyXO675ZRY461yN+W/8u4TpJefR39VnlH+2ptT+YmMkq9X1OEu9hSHJpvAiqQSFPF9qpMDeb4PBn4VBcU7poOWHY0c3OxXwZrc5/cLtuMN+JRvZ/IZE8HBcijI+jn3y+NLDTYuADdua35DrXUiTd1KMURhevoyfVKk3v6qOrmQbwoPVf04EGwGsFEh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(6506007)(478600001)(52536014)(316002)(110136005)(8936002)(15650500001)(66476007)(66556008)(66446008)(54906003)(76116006)(55016002)(33656002)(86362001)(7696005)(5660300002)(53546011)(4326008)(83380400001)(91956017)(9686003)(64756008)(8676002)(2906002)(186003)(6636002)(71200400001)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?9JMMy65AjsTY7mJA5Dh0VjpEHAI0DBCV13v6VsdyoSvKbZGw3kehQj7LxC+F?=
 =?us-ascii?Q?3FLZlAJEPlGQ17htMThiyj71pM5vJHWQOoOzgczazQgN7OptdquHMUXEFWzn?=
 =?us-ascii?Q?umxA1yuDFKUDfzgjPe1s1zWge2CBezndHH+MpPA75+JGN5TMuvs6I5ZJ5gGH?=
 =?us-ascii?Q?QRI8TieXTEow2QEKrz5jUCqppaFkprQPrJIsefWhb5FLt+B5PqCVJbZqJJt1?=
 =?us-ascii?Q?oWXMmIvOatBv0vT/Pjt3+rGg0cYeGMDjej92TQ5PXXGz6U84HwMpzjarJQUj?=
 =?us-ascii?Q?I1ECYOI9s+Q9WET/8SYg407ZFMNWe8L3grJVEXhmvs0lvPMegOead3pO/bIe?=
 =?us-ascii?Q?lL9WlD19Ulh7vqRuJelbJQxOI3kWsft8V2UHCTdI2vEr0vM/1PaSN5VE12tG?=
 =?us-ascii?Q?JnN5it/fLhv2lthPz3XZItqlfkAr4CDBH77bpz8nUEQX1wQoWs25LjOH7bG6?=
 =?us-ascii?Q?qJTHO8bY53yPx+62QkK3TQ/mLIjNAwMHK4BCMwe3c4ph45/f6a6xazriDiJH?=
 =?us-ascii?Q?uifVXu+5PUSaNEfqC8Foay4Uz5c1Y+oDnwuKiKJPbMS2/OJHeKVPVXuYo7g4?=
 =?us-ascii?Q?FD9QHo0uh36hoskZ4FeUSZsm2QXP2rE1w73aX7mpuSU1f56C3WLOI2wu3Cef?=
 =?us-ascii?Q?NdgdfuTXjURiETo5HIx8ks0RdyQi8XkKJnoYr7FZbVKL1QMD6/C7gPPydr9X?=
 =?us-ascii?Q?cILdeq0bYx4UwksK4hzhfoK0OpmpQPWoODkSZhT0k1AV4QcGUl5E9miXxKc2?=
 =?us-ascii?Q?x4zwBlZQ/myxOTevLDrlhesSndsvXc0BPR5U9rWgW/2ipftExT/84Ucvdwkp?=
 =?us-ascii?Q?h+4iEk3mrqWHVtek+A5xaveleH/G2NuyZM6LzwQDcXIGISVj5rSeGIMMYlwc?=
 =?us-ascii?Q?zrfhiHW34DMQEkazdGKi0r6b6HYnsd52NrBwUfZqYLZfIudLhPbR4f9prnUZ?=
 =?us-ascii?Q?72tFrnJgIjWLOoiAweX90N5h+p3kquVHw3VgyX3Q0XQLoSdkPXTTsafAtJdF?=
 =?us-ascii?Q?+3iOoe0dp7H7MvZMt1rPnwbJ0jqt2rNDByzL7YJIdonrgi6sEZTYP/ySYSRw?=
 =?us-ascii?Q?BjZptsEZLO5wM/RAH49N7MDIQMh1vhjnjzQ1zMlPzt8FvSJo1+4kATqVPs5p?=
 =?us-ascii?Q?2XVo3rqcZRsG/ePt6bXlBzu6bh3ZQW0swd00N9MS7unXOvqic0VRfrImAQn3?=
 =?us-ascii?Q?kzt/uDxrcpDwZ4dRsbLUjgeBddMucRZfA6l/blnp09TgL4NnrQcAzIzleRZn?=
 =?us-ascii?Q?OQkVGHsq9SS6e9wfBYFhHUvJH4i7zgNEnU40SQSk7cbJYYH1wvwPAIu0bIss?=
 =?us-ascii?Q?CFrWC3wkD3LdEwpqJH49+zIDf3b9WCyxdEdWV0uAWuHtSepdunh+gUKcXhP7?=
 =?us-ascii?Q?2abVRkNEHowteXTggaLPzTaltRHfFrkS+e7iLwQdiZqLYQcdgw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5fdb83-2e33-4109-7e77-08d8e52fba5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 08:20:42.4796
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J0nyYD8oAn0Tw9Vtgly8gS8DewnsdQJkn+OFOeu6NdheaH4RWPtWrN7m0jqWpebhMjrPM8IY+r8UKH6UWOtSdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6640
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/03/12 16:59, Johannes Thumshirn wrote:=0A=
> On 12/03/2021 08:27, Damien Le Moal wrote:=0A=
>> On 2021/03/12 13:38, Shinichiro Kawasaki wrote:=0A=
>>> On Mar 11, 2021 / 15:54, Johannes Thumshirn wrote:=0A=
>>>> On 11/03/2021 16:48, Bart Van Assche wrote:=0A=
>>>>> On 3/11/21 7:18 AM, Johannes Thumshirn wrote:=0A=
>>>>>> On 11/03/2021 16:13, Bart Van Assche wrote:=0A=
>>>>>>> On 3/10/21 1:48 AM, Johannes Thumshirn wrote:=0A=
>>>>>>>> Recent changes [ ... ]=0A=
>>>>>>>=0A=
>>>>>>> Please add Fixes: and/or Cc: stable tags as appropriate.=0A=
>>>>>>=0A=
>>>>>> I couldn't pin down the offending commit and I can't reproduce it lo=
cally=0A=
>>>>>> as well, so I opted out of this. But it must be something between v5=
.11 and v5.12-rc2.=0A=
>>>>>=0A=
>>>>> That's weird. Did Shinichiro use a HBA? Could this be the result of a=
=0A=
>>>>> behavior change in the HBA driver?=0A=
>>>>=0A=
>>>> Yes I've looked at the commits in mpt3sas, but can't really pinpoint t=
he =0A=
>>>> offending commit TBH. 664f0dce2058 ("scsi: mpt3sas: Add support for sh=
ared =0A=
>>>> host tagset for CPU hotplug") is the only one that /looks/ as if it co=
uld=0A=
>>>> be causing it, but I don't know mpt3sas well enough.=0A=
>>>>=0A=
>>>> FWIW added Sreekanth=0A=
>>>=0A=
>>> The WARNING was found in kernel v5.12-rc2 test with a SAS SMR drive and=
 HBA=0A=
>>> Broadcom 9400. It can be recreated by running blktests block/004 on the=
 drive=0A=
>>> (after reboot). It is also recreated with SATA SMR drive with the HBA, =
but not=0A=
>>> observed with SATA drives connected to AHCI.=0A=
>>>=0A=
>>> I reverted the commit 664f0dce2058, then the WARNING disappeared. I sup=
pose=0A=
>>> it indicates that the commit changed HBA driver behavior.=0A=
>>=0A=
>> Can you send the warning splat with backtrace ?=0A=
>>=0A=
> =0A=
> The warning splat is in the commit message:=0A=
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.12.0-rc2+ #2=0A=
>  Hardware name: Supermicro Super Server/X10SRL-F, BIOS 2.0 12/17/2015=0A=
>  RIP: 0010:__local_bh_disable_ip+0x3f/0x50=0A=
>  RSP: 0018:ffff8883e1409ba8 EFLAGS: 00010006=0A=
>  RAX: 0000000080010001 RBX: 0000000000000001 RCX: 0000000000000013=0A=
>  RDX: ffff888129e4d200 RSI: 0000000000000201 RDI: ffffffff915b9dbd=0A=
>  RBP: ffff888113e9a540 R08: ffff888113e9a540 R09: 00000000000077f0=0A=
>  R10: 0000000000080000 R11: 0000000000000001 R12: ffff888129e4d200=0A=
>  R13: 0000000000001000 R14: 00000000000077f0 R15: ffff888129e4d218=0A=
>  FS:  0000000000000000(0000) GS:ffff8883e1400000(0000) knlGS:000000000000=
0000=0A=
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
>  CR2: 00007f2f8418ebc0 CR3: 000000021202a006 CR4: 00000000001706f0=0A=
>  Call Trace:=0A=
>   <IRQ>=0A=
>   _raw_spin_lock_bh+0x18/0x40=0A=
>   sd_zbc_complete+0x43d/0x1150=0A=
>   sd_done+0x631/0x1040=0A=
>   ? mark_lock+0xe4/0x2fd0=0A=
>   ? provisioning_mode_store+0x3f0/0x3f0=0A=
>   scsi_finish_command+0x31b/0x5c0=0A=
>   _scsih_io_done+0x960/0x29e0 [mpt3sas]=0A=
>   ? mpt3sas_scsih_scsi_lookup_get+0x1c7/0x340 [mpt3sas]=0A=
>   ? __lock_acquire+0x166b/0x58b0=0A=
>   ? _get_st_from_smid+0x4a/0x80 [mpt3sas]=0A=
>   _base_process_reply_queue+0x23f/0x26e0 [mpt3sas]=0A=
>   ? lock_is_held_type+0x98/0x110=0A=
>   ? find_held_lock+0x2c/0x110=0A=
>   ? mpt3sas_base_sync_reply_irqs+0x360/0x360 [mpt3sas]=0A=
>   _base_interrupt+0x8d/0xd0 [mpt3sas]=0A=
>   ? rcu_read_lock_sched_held+0x3f/0x70=0A=
>   __handle_irq_event_percpu+0x24d/0x600=0A=
>   handle_irq_event+0xef/0x240=0A=
>   ? handle_irq_event_percpu+0x110/0x110=0A=
>   handle_edge_irq+0x1f6/0xb60=0A=
>   __common_interrupt+0x75/0x160=0A=
>   common_interrupt+0x7b/0xa0=0A=
>   </IRQ>=0A=
>   asm_common_interrupt+0x1e/0x40=0A=
> =0A=
=0A=
Looking at patch 664f0dce2058, all that seems to be done is to enable=0A=
nr_hw_queue > 1. I do not see any change of locking context or irq handling=
.=0A=
From the backtrace, it does not look like scsi_finish_command() is called f=
rom=0A=
softirq... Probably a change in that area is responsible ?=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
