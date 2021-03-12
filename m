Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC620C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 10:28:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FC4C65002
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 10:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbhCLK2L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 05:28:11 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:1724 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbhCLK2K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 05:28:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615544890; x=1647080890;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=HnxPmpuB9AONQz4T3DMA07qirwosX6HCTuo8XN5vz5I=;
  b=q47DXQjN5f0XgGcNny7266/cdro0knXNo+0WsFQWUOdhHncSFEbWMKIv
   IjIfOXyo29KbEWGoET/q3y+o/BJRexKrJs/prNaKA/akWxkArCEUety+i
   Ugm3SlamUOk+O8r8ZPL4FCXQliAPfcSkDwMWIgb90qA//kNKM6//s+nSf
   5cJ8ds4Ux8cxIaLj5m16+j+IfoSHYsS/Q+M1SB1Ky5PvlvOd0yl/OFVWB
   a6AlC1XCZDyEONeHHOzBQZ7wt/zdQvYVhWEZ1XwriuotVWrqoas9BWVY5
   nwv2PdA50wsA8/Cw+fr3h0dlDRTl7vY9SKtrPBJ+74j1ixsHgPO+ZY49Y
   A==;
IronPort-SDR: AAtZKubry0bvbRtm7l1HBaGmpmdBWCqV2Od3baDuciyco5Q8GEZafYEc0+RrQPApAO2Bap1+kX
 t2+AuFV7pyO0K6qyDLxI7XiHmClmE5BGaonJ93Y7D+KuWKmrGhYw21jOflnPNg5dqza4zsAV9D
 XcHES8y6CXDKwOcMNm+siv1rCKoSZ5nOIpBu6zWhTV4dZhPRw6XwytsapInKanbo9qU872YChN
 KIcYI416AmOy7s/hhbwgSxmyqrThXUGwT9FthzqxS6obUkAtXpB4M7Jd2833HvLI/x2XR2O9CJ
 bRk=
X-IronPort-AV: E=Sophos;i="5.81,243,1610380800"; 
   d="scan'208";a="166498072"
Received: from mail-dm6nam11lp2177.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.177])
  by ob1.hgst.iphmx.com with ESMTP; 12 Mar 2021 18:28:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YtomIWqhPdDsMw54ZvBlmIQAKwwm/DHFV5ZBBS/EwdB1aJDaENHd6DM0g7BZ0AP6W8t5zejfvNhbUz2BrUSc3lqfMFeM1U1t6qfoQH3atvC+SOJ0rZry0POvqAc6sNa5u8i1+ND2jbx+i8O01hUOfZBs1yNvBg5nLLrDBsHhrbyzQiHXEO1yPWUqD6KBQsKpzAC5e7WI1EWqrPnmRDMw712bCwsIO1LfSOVQyXZweelJzlEaCeQFuosltOzT0219xaNF8eBEfAu3dJ1H51GvhnCA0RK33B9oQystmYoxyxB9eRtalbtrJcj7mHrTm1B7sg98d520UxpWltO6qC4cfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AhLdXI5EOFukYexTk+3ZSnH+M4hsdExRiVXBR7i+ky4=;
 b=VIdph0GqOR5A9qsNqKt9ZuTk0cmOd7leo7jp3KQ5nVUqwj2n1J2/vTB6U4QxG9BRtICVBT1Lrmb66BK2mc/VD9Cq5dEd9hjFoC8DBOFvo7rTcpwwIHH+tJQYSn/FSqP93X5LvK+ammOEZzBCGy0lUqM3uoPHUxDxBiexRbTtOg/Jxj7H7LuupysbZA5AxzfUgR4MOokAcUXvupSJJm7IDpQKWPg2+puIPZoJYGb3iL5hXfaiQ0kaCK81SdNhuKldRW/dmVDfqx2hMd5qwxtZAubz4JspgU2l4i1dQG2L+ia4xziaqCuVMkFHJ8Su/tGcPJTSq57UFFiIGhbTRvYsNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AhLdXI5EOFukYexTk+3ZSnH+M4hsdExRiVXBR7i+ky4=;
 b=E35v7p+/995LFZUKqROY14BUdYL/IrPHxEHvTEQ/XnojY0BkaU91s65eEHWZbrkwJLLGAjm8gK94PE0lzsVYZ5/YusXzErvfkQFvsuk0ChdW4iKo1aHzhdf2/BvwhGx+WWJLp2ID0vXk3czi5hI7wBJW9h04UTPbG9eoIQClC6E=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7558.namprd04.prod.outlook.com (2603:10b6:510:54::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Fri, 12 Mar
 2021 10:28:07 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3933.031; Fri, 12 Mar 2021
 10:28:07 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Topic: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Index: AQHXFZJ9Ugg++iEKb0KOzcBTGpFywA==
Date:   Fri, 12 Mar 2021 10:28:07 +0000
Message-ID: <PH0PR04MB741654F7E0919E8416F072559B6F9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
 <2a68a06c-7bcf-337d-b819-9e8f63f5e68c@acm.org>
 <PH0PR04MB7416733D30D20EA68EBBE0EB9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
 <87928742-6bba-1db1-1ee2-4d62188b2cbb@acm.org>
 <PH0PR04MB7416FFA8BC2332DB647FA12E9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
 <20210312043828.kl2olk2d7awfsi7j@shindev.dhcp.fujisawa.hgst.com>
 <BL0PR04MB651449ABC126A9FEA02CCB08E76F9@BL0PR04MB6514.namprd04.prod.outlook.com>
 <PH0PR04MB7416C8F6506400FECB7207AC9B6F9@PH0PR04MB7416.namprd04.prod.outlook.com>
 <BL0PR04MB6514879C187E6C81593F41B7E76F9@BL0PR04MB6514.namprd04.prod.outlook.com>
 <PH0PR04MB7416C0E44B45C3FCDA7127989B6F9@PH0PR04MB7416.namprd04.prod.outlook.com>
 <20210312100545.cf5m7yd22prkbdx6@shindev.dhcp.fujisawa.hgst.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1542:e101:5840:9cdd:b1cc:ef31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0250ffbf-8420-4e3b-09f6-08d8e5418731
x-ms-traffictypediagnostic: PH0PR04MB7558:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB755822347C01D420CF03EC699B6F9@PH0PR04MB7558.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zBEqrgtqaXqpTqFhQ5jpgjZ9Bj8KFdNenzzsk/eQKoegsFboAXBOLOXtnO/vR38/mmmWw8TU/SrVsgD/4ngJBYxyW04kOXl5zmDM5Ytm8HUP21XTByYWppindiKWdfdraMa0Pf5SLzr3Ufxs+NMg1vE7EvYciKvOYQppiPbkExx5jbw+IWqb6eqD+QV/Wfa4tGnJ2IYvDsNSP9dpJhUedz8Xgw8v7xKvPW+jArxxo5kBYQnkdLdzmFHwQf56sZTHmEDFoBhWk+c3VKr9JFEW2WZrRQfSw/lUjxshXlax+lbQ0V/AZtgGB20zkv1Yfi36sCJ6aObH1gNU1uNvosl9LD76imLymHH8/kBu4H/5ktvmBBMUVfy3UDTnnhLJQOfzLQUonhuxVr1dFnNK/VC9HHql54ik+digCpFOyBObJy09Xe8w8PFNoLj+iepqNZrpg6g99Y6GNxieAEbMhEygZwN3XzKlao97jwbH3J2u5E8wH69mHuk7TKugWILyUM509i40Y6hC9Shv0gkPTH+KuS+m6X1tmkB00v5i7rvaBWAXP5yR3CJSR1290+Xt5iGp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(6636002)(8676002)(6862004)(4326008)(2906002)(8936002)(33656002)(83380400001)(86362001)(76116006)(66446008)(6506007)(91956017)(55016002)(54906003)(9686003)(53546011)(64756008)(186003)(66556008)(71200400001)(66476007)(316002)(66946007)(15650500001)(478600001)(52536014)(7696005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?IuFrA8ed8I6uRqob1vY9T9odNs2TwCYuXD2g/mjtWDquMlvA45iezyWTZ31m?=
 =?us-ascii?Q?89X9nWoF6ClOxkj3Q6uqfDK3YKiCOAvY9FuydJWjBqkcI0gEowuoTXdfzNNS?=
 =?us-ascii?Q?Y4vd/0X7hcErb/1y5t9HSEyaLrwOuheO/yuLztnvUzH9LiejPkLtONO9kz9u?=
 =?us-ascii?Q?ASDvn8+BuhQWlQ7ZESfjFUbBvJiEmSVIOOhlPe3vAc73zX/tcmCwCQrKHiwQ?=
 =?us-ascii?Q?eDT5H3DFV/2W6jil9yhpBAtUpXFqiYUZI5x832XlRX7EIFjkUWMEyeoQ8tc1?=
 =?us-ascii?Q?8K04WRXDR5/+l3qld7IrVSmwxvo8fqGpVdwdvjyVLw2pOc4couIoYZOY3CP6?=
 =?us-ascii?Q?8Bkq1TBMLGlSwxa1oomH+wqN8g955CYdZskWqiKAVVyxyzpaEq3QEWcG7P/U?=
 =?us-ascii?Q?MD4ZKwfcpeYgOdmuDduoOGJsQ49fTwpl4cU9sMi6OtwHbRpFwtSWlxwqKsQb?=
 =?us-ascii?Q?eT85jLX/qxsvWr4VPyiUMhqzsVlW/azUGtCHgQl/ptuqK6u926YOrhI290kj?=
 =?us-ascii?Q?3diP0vB55zzAzq7/7+oh+jHyNdGHzIAOWj9PX9lqz77jDTKByJcjvVvOKjR5?=
 =?us-ascii?Q?OrbqRY0IGzt8lmM2xiRix4uXhg2bbN+Eh68sJiJj0ZK4+658Fwk1zwr2zonm?=
 =?us-ascii?Q?bdu4dlgCUwzd1G/LdEkYdFKiXLFoT+HeSZKGa2YBtiZuwKaRRVqz+3VdV7pT?=
 =?us-ascii?Q?PDFkVFMrzrVIf9JD8o0M/iOBgpRLRY7fbHpKObmuH0HkjI8GAVrbojcnfwfA?=
 =?us-ascii?Q?3Ft+gAwrfSDqgxinwRxcuoLptLhPpR26/iia7r+v5B1tm7hDJbIoOz3ZxbvY?=
 =?us-ascii?Q?1nYXC1TQ9/LHpXIzWhIZVrAgtWDxY7g0RRYTvLDCa2LwIonBlKYQZIFuR5Xw?=
 =?us-ascii?Q?OHfNFj5aWp0VDDup3BfRGPWf7nbU4rrsfIpol5LIcB9hZl/kOLx1K4tsDcUr?=
 =?us-ascii?Q?CfDZg3Dan48NoocjPg2CihK96o1C5fBxR0/h01sPF6FJDqCxWN4UCi8P8Fgw?=
 =?us-ascii?Q?tS4fuHhEb9fq67W2whI0utZw3IPCTkM6/DleEELwJYxzTtb2Stcp7XV+IEHy?=
 =?us-ascii?Q?d0RL8kmbOSoFXHyx/NCJY+mrGg87Vojsf7WZA+U33tM9Tw+PczyCxkwul2ap?=
 =?us-ascii?Q?p8nU8My3CaOxRJEl7o7tDsdJ7jMRI3ec4DYOGm1pUiUhjwsY+I7BGUISQkU1?=
 =?us-ascii?Q?31oXSHbDeVp5/IVX46FXFYfLp4BM8vIgsMAQV92MCr+Qb8Q6R0IRNQcDxKS7?=
 =?us-ascii?Q?S1z51DJjCeT78fGB1ZDOaVPB/uxYognZoRbN+vjnMQ4IXALDNr+x0HZ3mi8y?=
 =?us-ascii?Q?SiV1sUhHUxyvag7s9/PUXXjlSlEHQuII4ZrC3mjGS4myTkDVEAo3g+VqGHzR?=
 =?us-ascii?Q?ZRywTYyqk7uBhM9wFUXADB+glxV0oDzQbmcsYiy2Mo38ffJ0WA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0250ffbf-8420-4e3b-09f6-08d8e5418731
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 10:28:07.4876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OEr0soOFNfbpxqpT5g//JzcB3nXVh43dEqED5MJFfcZaHxOIqXhOTwv6dawMZwCDJCfSpeLoj2U72+Xep3NHmX+4xnkXC6yWnSI8LWifO/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7558
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/03/2021 11:05, Shinichiro Kawasaki wrote:=0A=
> On Mar 12, 2021 / 08:58, Johannes Thumshirn wrote:=0A=
>> On 12/03/2021 09:20, Damien Le Moal wrote:=0A=
>>> On 2021/03/12 16:59, Johannes Thumshirn wrote:=0A=
>>>> On 12/03/2021 08:27, Damien Le Moal wrote:=0A=
>>>>> On 2021/03/12 13:38, Shinichiro Kawasaki wrote:=0A=
>>>>>> On Mar 11, 2021 / 15:54, Johannes Thumshirn wrote:=0A=
>>>>>>> On 11/03/2021 16:48, Bart Van Assche wrote:=0A=
>>>>>>>> On 3/11/21 7:18 AM, Johannes Thumshirn wrote:=0A=
>>>>>>>>> On 11/03/2021 16:13, Bart Van Assche wrote:=0A=
>>>>>>>>>> On 3/10/21 1:48 AM, Johannes Thumshirn wrote:=0A=
>>>>>>>>>>> Recent changes [ ... ]=0A=
>>>>>>>>>>=0A=
>>>>>>>>>> Please add Fixes: and/or Cc: stable tags as appropriate.=0A=
>>>>>>>>>=0A=
>>>>>>>>> I couldn't pin down the offending commit and I can't reproduce it=
 locally=0A=
>>>>>>>>> as well, so I opted out of this. But it must be something between=
 v5.11 and v5.12-rc2.=0A=
>>>>>>>>=0A=
>>>>>>>> That's weird. Did Shinichiro use a HBA? Could this be the result o=
f a=0A=
>>>>>>>> behavior change in the HBA driver?=0A=
>>>>>>>=0A=
>>>>>>> Yes I've looked at the commits in mpt3sas, but can't really pinpoin=
t the =0A=
>>>>>>> offending commit TBH. 664f0dce2058 ("scsi: mpt3sas: Add support for=
 shared =0A=
>>>>>>> host tagset for CPU hotplug") is the only one that /looks/ as if it=
 could=0A=
>>>>>>> be causing it, but I don't know mpt3sas well enough.=0A=
>>>>>>>=0A=
>>>>>>> FWIW added Sreekanth=0A=
>>>>>>=0A=
>>>>>> The WARNING was found in kernel v5.12-rc2 test with a SAS SMR drive =
and HBA=0A=
>>>>>> Broadcom 9400. It can be recreated by running blktests block/004 on =
the drive=0A=
>>>>>> (after reboot). It is also recreated with SATA SMR drive with the HB=
A, but not=0A=
>>>>>> observed with SATA drives connected to AHCI.=0A=
>>>>>>=0A=
>>>>>> I reverted the commit 664f0dce2058, then the WARNING disappeared. I =
suppose=0A=
>>>>>> it indicates that the commit changed HBA driver behavior.=0A=
>>>>>=0A=
>>>>> Can you send the warning splat with backtrace ?=0A=
>>>>>=0A=
>>>>=0A=
>>>> The warning splat is in the commit message:=0A=
>>>> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.12.0-rc2+ #2=0A=
>>>>  Hardware name: Supermicro Super Server/X10SRL-F, BIOS 2.0 12/17/2015=
=0A=
>>>>  RIP: 0010:__local_bh_disable_ip+0x3f/0x50=0A=
>>>>  RSP: 0018:ffff8883e1409ba8 EFLAGS: 00010006=0A=
>>>>  RAX: 0000000080010001 RBX: 0000000000000001 RCX: 0000000000000013=0A=
>>>>  RDX: ffff888129e4d200 RSI: 0000000000000201 RDI: ffffffff915b9dbd=0A=
>>>>  RBP: ffff888113e9a540 R08: ffff888113e9a540 R09: 00000000000077f0=0A=
>>>>  R10: 0000000000080000 R11: 0000000000000001 R12: ffff888129e4d200=0A=
>>>>  R13: 0000000000001000 R14: 00000000000077f0 R15: ffff888129e4d218=0A=
>>>>  FS:  0000000000000000(0000) GS:ffff8883e1400000(0000) knlGS:000000000=
0000000=0A=
>>>>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
>>>>  CR2: 00007f2f8418ebc0 CR3: 000000021202a006 CR4: 00000000001706f0=0A=
>>>>  Call Trace:=0A=
>>>>   <IRQ>=0A=
>>>>   _raw_spin_lock_bh+0x18/0x40=0A=
>>>>   sd_zbc_complete+0x43d/0x1150=0A=
>>>>   sd_done+0x631/0x1040=0A=
>>>>   ? mark_lock+0xe4/0x2fd0=0A=
>>>>   ? provisioning_mode_store+0x3f0/0x3f0=0A=
>>>>   scsi_finish_command+0x31b/0x5c0=0A=
>>>>   _scsih_io_done+0x960/0x29e0 [mpt3sas]=0A=
>>>>   ? mpt3sas_scsih_scsi_lookup_get+0x1c7/0x340 [mpt3sas]=0A=
>>>>   ? __lock_acquire+0x166b/0x58b0=0A=
>>>>   ? _get_st_from_smid+0x4a/0x80 [mpt3sas]=0A=
>>>>   _base_process_reply_queue+0x23f/0x26e0 [mpt3sas]=0A=
>>>>   ? lock_is_held_type+0x98/0x110=0A=
>>>>   ? find_held_lock+0x2c/0x110=0A=
>>>>   ? mpt3sas_base_sync_reply_irqs+0x360/0x360 [mpt3sas]=0A=
>>>>   _base_interrupt+0x8d/0xd0 [mpt3sas]=0A=
>>>>   ? rcu_read_lock_sched_held+0x3f/0x70=0A=
>>>>   __handle_irq_event_percpu+0x24d/0x600=0A=
>>>>   handle_irq_event+0xef/0x240=0A=
>>>>   ? handle_irq_event_percpu+0x110/0x110=0A=
>>>>   handle_edge_irq+0x1f6/0xb60=0A=
>>>>   __common_interrupt+0x75/0x160=0A=
>>>>   common_interrupt+0x7b/0xa0=0A=
>>>>   </IRQ>=0A=
>>>>   asm_common_interrupt+0x1e/0x40=0A=
>>>>=0A=
>>>=0A=
>>> Looking at patch 664f0dce2058, all that seems to be done is to enable=
=0A=
>>> nr_hw_queue > 1. I do not see any change of locking context or irq hand=
ling.=0A=
>>> From the backtrace, it does not look like scsi_finish_command() is call=
ed from=0A=
>>> softirq... Probably a change in that area is responsible ?=0A=
>>>=0A=
>>=0A=
>>=0A=
>> In scsi_lib.c we only have these two patches in that area:=0A=
>>=0A=
>> 684da7628d93 ("block: remove unnecessary argument from blk_execute_rq")=
=0A=
>> 962c8dcdd5fa ("scsi: core: Add a new error code DID_TRANSPORT_MARGINAL i=
n scsi.h")=0A=
>>=0A=
>> and none of them can cause the failure either. In block we have:=0A=
>>=0A=
>> 0a2efafbb1c7 ("blk-mq: Always complete remote completions requests in so=
ftirq")=0A=
>>=0A=
>> but this doesn't look guilty as well, all it does is raising a softirq f=
or all=0A=
>> block completions local and remote.=0A=
> =0A=
> In blk_mq_complete_request_remote(), I found the following code.=0A=
> =0A=
> 	if (rq->q->nr_hw_queues =3D=3D 1) {=0A=
> 		blk_mq_raise_softirq(rq);=0A=
> 		return true;=0A=
> 	}=0A=
> 	return false;=0A=
> =0A=
> My mere guess is that the commit 664f0dce2058 changed the shost->nr_hw_qu=
eue=0A=
> from zero to a value larger than 1 (with my test system, it is 8), it is=
=0A=
> propagated to rq->q->nr_hw_queues, then blk_mq_raise_softirq() is no long=
er=0A=
> called.=0A=
> =0A=
> The call stack I assume is as follows: without calling blk_mq_raise_softi=
rq(),=0A=
> there are all executed in IRQ context, probably.=0A=
> =0A=
>   _scsih_io_done()=0A=
>     scmd->scsi_done() =3D scsi_mq_done()=0A=
>       blk_mq_complete_request()=0A=
>         blk_mq_complete_request_remote() ... did not call blk_mq_raise_so=
ftirq()=0A=
>         rq->q->mq_ops->complete() =3D scsi_soft_irq_done()=0A=
> 	  scsi_finish_command()=0A=
> 	    drv->done() =3D sd_done()=0A=
> =0A=
> Will confirm this guess further.=0A=
> =0A=
=0A=
But commit 0a2efafbb1c7 ("blk-mq: Always complete remote completions reques=
ts =0A=
in softirq") changed it to:=0A=
=0A=
 =0A=
-       /*=0A=
-        * For most of single queue controllers, there is only one irq vect=
or=0A=
-        * for handling I/O completion, and the only irq's affinity is set=
=0A=
-        * to all possible CPUs.  On most of ARCHs, this affinity means the=
 irq=0A=
-        * is handled on one specific CPU.=0A=
-        *=0A=
-        * So complete I/O requests in softirq context in case of single qu=
eue=0A=
-        * devices to avoid degrading I/O performance due to irqsoff latenc=
y.=0A=
-        */=0A=
-       if (rq->q->nr_hw_queues =3D=3D 1)=0A=
-               blk_mq_trigger_softirq(rq);=0A=
-       else=0A=
-               rq->q->mq_ops->complete(rq);=0A=
+       blk_mq_trigger_softirq(rq);=0A=
 }=0A=
=0A=
So to my understanding, we will always complete in a softirq.=0A=
