Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEDFEC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 11:49:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86ED764FD9
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 11:49:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhCLLt1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 06:49:27 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:56909 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbhCLLtA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 06:49:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615549740; x=1647085740;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FXz/4DpOu5McTF3l9lnOorn3v+px22RoCLX+RjTfZTU=;
  b=paSLoDHrs/fvLGQkGxtqR7uWU7K6rvUR8S+vvJd8c2/FPBew4Fq42me3
   Ri5mMt36Ubji3BqUQ3vO83vQQwHjcfXgrvXqNl2n13ljYXf1XS411rNds
   3yHDTO6JvuNfdeZnaQaJV0bB+4QiMEAU0TsUjly6YEbNwQwTGnMZilNOs
   hVcBZmZTQFKxUlMMcLMGzU5C6LFRWNbOI6nhhlp0Nu4NZ73xmzd9xtSkU
   oAOzJVO2CnVxlKkCM3fiyFeIWBr9yeppArjkCzmq9kFR1j/3Lk7KrecPB
   mAqIbwKeW9pWycQlDflvXVvPY/h3A8PKX6PRvFt8dAiwQM8uqiGGCBF3v
   g==;
IronPort-SDR: wY2PPLE7vIjTfbN06t8yMr65biZXI9CT5uBxLEFAemZ+uDDzirag0TTP6QD3hfe1RkdxK8r6o+
 jEdN1l0FAf5Wvn0NcwBSXQdPt8syfaUFKL3p1g6f4kwJ108iG5P5WlG4Zk5DbyOAUmuBK3o2Ay
 YM7sg8MyXDAxyNtLCCD28Nzwjca7x9mqw58nQ4tWkPxIFayQsbPsfwTcFUPq8xP0Cncz7Gk0dg
 JPuTHG0FWtX4+MFj1Sj9hWedFS1mCYd8xKr43NvUn3hhdAzJ2BsQqRE15VAZW1kN5DHcALSDur
 Tow=
X-IronPort-AV: E=Sophos;i="5.81,243,1610380800"; 
   d="scan'208";a="166501559"
Received: from mail-dm6nam10lp2102.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.102])
  by ob1.hgst.iphmx.com with ESMTP; 12 Mar 2021 19:48:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JL2+YQ/snckj2AhzDwv0Wy4fjHQjYuR+xiwxPZd8ehQ93v2L3PXDMxY2pGWEuWtiYEpN9qJII88rRQvO6CBr4jmJN/BF2yRkxotl/r7RtRARNg+iO6AFS7FcnzjJnfUFcXCaBw5C2uWgmA9znFTzHjBByjcoQkrExj52OkV5cp7XGA5sSx7j1Bk8JL2490zVsas4/yT1gW3eeK3eH+Sp7mW6tSNMeyTd9jZU+t2oXI+Gw9brtQyCi41oOQUiLIHc3KUqnN39FuLN2Uz/tE9tB9+LpfqY0sjlcGuasC+B/aGeOIDHEVtI8m0Ya0hZIF3xhLddUCwzWFDQCnM3j3OBDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G1me029nSa43fntaMaFgdFuabvsVx8+Gv8EnzPfg270=;
 b=az34xbvbdO1Klvj95jFV6Bz+Am+EqQ3gwfeyGKhQel4KbcTsuVq37LqCqGJzItlSFNsxNbr7LaL59PpwMLG/1A+6S/DYB/bcuoN5+H2FHAWPRo9fHHvCZGa8mqom6ZTBDbvRRgF0C3KZpRc8/+oPS7sbqrNoYjhw9q2djUgbxWYlqEbv0cRgfA9be/sIXYpEgJHSPXx73OHBHJiImONII1RunOv4EuuccB5cJ9GlOZfUqKA3DXCXabQLLMRckNiX2BtCksogpMghG09NWv2shZWJg9o5VpWSxiRvRGUWFjFLYnbcb5AOUKmwUcHSrgpXV7JQBxmBDyFYNPeFRJKKRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G1me029nSa43fntaMaFgdFuabvsVx8+Gv8EnzPfg270=;
 b=Ay6zi84FyX/U1EeKTjfN5NjAmEHljD6vlGOJ6RnUj5YNsk/yqnr0XxfezHbcr7TkWqQBdx8EFNmofx2l/oM27W+hDK+fP/1JqG8jTWetcOF5v3baxci1T8jEqbkvG5Gm3WJPO3qfpc+Q2TEtv63v9DAtznBVRgESQbE1TJ96fPI=
Received: from BYAPR04MB3800.namprd04.prod.outlook.com (2603:10b6:a02:ad::20)
 by BYAPR04MB5736.namprd04.prod.outlook.com (2603:10b6:a03:10c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Fri, 12 Mar
 2021 11:48:57 +0000
Received: from BYAPR04MB3800.namprd04.prod.outlook.com
 ([fe80::61ad:9cbe:7867:6972]) by BYAPR04MB3800.namprd04.prod.outlook.com
 ([fe80::61ad:9cbe:7867:6972%7]) with mapi id 15.20.3890.041; Fri, 12 Mar 2021
 11:48:57 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
CC:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Topic: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Index: AQHXFZJ9Q2LbIxWjkkW7HLcT3Xe81KqAQDgA
Date:   Fri, 12 Mar 2021 11:48:56 +0000
Message-ID: <20210312114856.iqeguiup5lrzgeha@shindev.dhcp.fujisawa.hgst.com>
References: <PH0PR04MB7416733D30D20EA68EBBE0EB9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
 <87928742-6bba-1db1-1ee2-4d62188b2cbb@acm.org>
 <PH0PR04MB7416FFA8BC2332DB647FA12E9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
 <20210312043828.kl2olk2d7awfsi7j@shindev.dhcp.fujisawa.hgst.com>
 <BL0PR04MB651449ABC126A9FEA02CCB08E76F9@BL0PR04MB6514.namprd04.prod.outlook.com>
 <PH0PR04MB7416C8F6506400FECB7207AC9B6F9@PH0PR04MB7416.namprd04.prod.outlook.com>
 <BL0PR04MB6514879C187E6C81593F41B7E76F9@BL0PR04MB6514.namprd04.prod.outlook.com>
 <PH0PR04MB7416C0E44B45C3FCDA7127989B6F9@PH0PR04MB7416.namprd04.prod.outlook.com>
 <20210312100545.cf5m7yd22prkbdx6@shindev.dhcp.fujisawa.hgst.com>
 <PH0PR04MB741654F7E0919E8416F072559B6F9@PH0PR04MB7416.namprd04.prod.outlook.com>
In-Reply-To: <PH0PR04MB741654F7E0919E8416F072559B6F9@PH0PR04MB7416.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1034d846-24ce-4e7e-c5cc-08d8e54cd1b8
x-ms-traffictypediagnostic: BYAPR04MB5736:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB57368F60561FC7FCFE390F9DED6F9@BYAPR04MB5736.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Kj6v5ZMMGQkjgG1ILpXWmMOFJIco8rGpouLnoPheOVI3oruXNoBO0QurX42GUUo0tYAYSLcpgVoUkbr9hj6wxDWrKTtWSStYm/prSEd2NMems+XtIBqAFpPqoMdOihGqDo11w6tGH2QOQWG4EvkVuZT2ZZEvvH9lYe3mfDEhw0jYIoB4a8X2t15jAKE4BICpoRNyKZvXsFFbRu/gLdTths+dox5OHA2/OmZ3O3Itm4vaiZ9vSzRRHIA8nfYarWsl0itsZ+IHbtQpW/XfE2G/UVe2NYKkEyIgSISv9TcSIpZHSLYMPF58PsgFG3uGEQA8ljxBat1NJ8BkUHA4E6+ff3vda847SMGBYQX26lpStfIAxP5k8os6Y4jH33erDkgdSezZpxx2Y2KV+9EbeygoABikCfrE2WbZsx8nmsAOe3J3h/c97DsZluAZ0dJPznUwscCc2/0P5nGP18hwOkUWKp7iuB2gJAeMtlxi2Pcn/0w9f4h7RJjoOTb8IjPxiDe9Qw2Hast+X456BaKrD240zJ+Fc/DbHGB6gSAKDwG/uMZE6dRnPJFjMfLOdRdhDXq0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB3800.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(6486002)(316002)(9686003)(6512007)(91956017)(54906003)(8676002)(5660300002)(1076003)(15650500001)(66556008)(86362001)(6506007)(53546011)(44832011)(66476007)(83380400001)(2906002)(66946007)(66446008)(8936002)(76116006)(71200400001)(64756008)(4326008)(26005)(478600001)(186003)(6636002)(6862004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?xIUDLtw3dkhMAOVKCx28rcrhiN1zx55Cw0HEAYLy+a++2MEsY31DF+OnVpb2?=
 =?us-ascii?Q?Zu1bAWFLTcoMKZkcjWM6FGmuCzxjNL0DDT2alVKKQXKBK2gkzvDa+p8Qiwly?=
 =?us-ascii?Q?67RJl4ZzsguovIPdHOP/mDZu7KEBrrr/tXPhO5oMJ840Y1Id6G+hrqbGOQkI?=
 =?us-ascii?Q?ENUbIvN/c0eIzdiI8jBE24zwCAP2C72Y9LdnP90QNoX9WMyQ48RcaM43TUHM?=
 =?us-ascii?Q?+OHL4j2BCWDPavXDDnCvIBUAHAW+LdXQCOUPWvlWt/119tWQgyJPQN/PLh+z?=
 =?us-ascii?Q?FwBQATe6AgTxbL1ocnlRFIaryruCJaND0EflQFNW7S91oS05L7HSuSbBEFPl?=
 =?us-ascii?Q?cJ8zOqEzTGQa4/hpdOm5/h/5Y7PC1uEuYHAbkuZZYwqjQJ8v6/M5dZpuw+tF?=
 =?us-ascii?Q?SWus40wM38ra22kTqrnYjF2SocjKMG+hSbTV0TRZXixAtXmTgz/MBZ0Cg4eT?=
 =?us-ascii?Q?k/1qeKWzwZb4f1FfS261hveBLvyJIx38wEkiAqkdlNlKv+uVlG0NGfUCW/Yb?=
 =?us-ascii?Q?lQTZupy07Wo1pMXqdTWGgu4Cvfr4bbgj/W4czUcCGJcO2BrwnwfEXOkDmZWB?=
 =?us-ascii?Q?uo21gde0O6yJObcvqCMWtOrtKF7lttbVAUo46/6RxgeR6iTOV9CPz7/sciaP?=
 =?us-ascii?Q?ZaYNMacx4WntqZiK3bSx6fvgpARmEaGmhi9DKL/y/ZBt4ywY6sIw2VpoVxgH?=
 =?us-ascii?Q?GY09G8VUX0SgJoT060aS8Qis55jO8kHBn370OnMWG1R+uFtOAkUDvq9WGUbh?=
 =?us-ascii?Q?f9vej0PvI95EI8C2BeouhF1IK2GSs+cvqTFSQXGlVFO5ib5ehIxQ2f62tmFw?=
 =?us-ascii?Q?U5z0mwrYGCcqMRFhNjDqckwbMzX31H+zkgrEUEJ5aY4liDzcvgtTLGeTYbsq?=
 =?us-ascii?Q?6fzNebv5BSAlqcG0Zrb4W5CJHwjJhjwksN02qpMnKMisRURyGWDupYQr4fMB?=
 =?us-ascii?Q?s79yQYM/L/Svyg4vzAaP/bVUkLQfMjscpCZ2hDFlYY9xcKYv8IuaRuiLW1EO?=
 =?us-ascii?Q?B0jeq/qYYvXfiHDF/gNGAiAwqMLrTIU2ElEAPi7YpQa25H74xmp7a/BHkU9I?=
 =?us-ascii?Q?d9RXzG7ALyQdCccQS3pem5EXHK61D1J+s2r7fp5FdTbW+rYek+Iyv0Qo67M1?=
 =?us-ascii?Q?DEa3JDKG0rSVH/azkOLMRQCHBI4C6TuyIMVakTbo1eRioEepc44ULQ9Pfwgr?=
 =?us-ascii?Q?c4HbeGuZXk4tnrsi+UkzwkqkbUmCgcSZtu13RLKjmdKwi7H6NMbsHV2JCYQ5?=
 =?us-ascii?Q?g00xXryAWyWMbtJZLKTE/xs7NPb9PJx0hqflRGK+we5E217A2B9ROlE7cwKW?=
 =?us-ascii?Q?6REYXG9Wcq8TYkCbfH/Vv4VVVuE1kWAFmBEmzb0glpdilw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9DE0952C44FC3E45AD36D6D4B01662A4@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB3800.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1034d846-24ce-4e7e-c5cc-08d8e54cd1b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 11:48:57.0428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YCqeK3CN8PeY8FnurX6xhITzGL2FOJmUXQ3E2sCEjO3KqMzAX0rc5crqG6z8OwkYYME/TDtj3u4dX+DMJRCr6Tiy9bdSRqSn49M6uUC737E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5736
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mar 12, 2021 / 10:28, Johannes Thumshirn wrote:
> On 12/03/2021 11:05, Shinichiro Kawasaki wrote:
> > On Mar 12, 2021 / 08:58, Johannes Thumshirn wrote:
> >> On 12/03/2021 09:20, Damien Le Moal wrote:
> >>> On 2021/03/12 16:59, Johannes Thumshirn wrote:
> >>>> On 12/03/2021 08:27, Damien Le Moal wrote:
> >>>>> On 2021/03/12 13:38, Shinichiro Kawasaki wrote:
> >>>>>> On Mar 11, 2021 / 15:54, Johannes Thumshirn wrote:
> >>>>>>> On 11/03/2021 16:48, Bart Van Assche wrote:
> >>>>>>>> On 3/11/21 7:18 AM, Johannes Thumshirn wrote:
> >>>>>>>>> On 11/03/2021 16:13, Bart Van Assche wrote:
> >>>>>>>>>> On 3/10/21 1:48 AM, Johannes Thumshirn wrote:
> >>>>>>>>>>> Recent changes [ ... ]
> >>>>>>>>>>
> >>>>>>>>>> Please add Fixes: and/or Cc: stable tags as appropriate.
> >>>>>>>>>
> >>>>>>>>> I couldn't pin down the offending commit and I can't reproduce =
it locally
> >>>>>>>>> as well, so I opted out of this. But it must be something betwe=
en v5.11 and v5.12-rc2.
> >>>>>>>>
> >>>>>>>> That's weird. Did Shinichiro use a HBA? Could this be the result=
 of a
> >>>>>>>> behavior change in the HBA driver?
> >>>>>>>
> >>>>>>> Yes I've looked at the commits in mpt3sas, but can't really pinpo=
int the=20
> >>>>>>> offending commit TBH. 664f0dce2058 ("scsi: mpt3sas: Add support f=
or shared=20
> >>>>>>> host tagset for CPU hotplug") is the only one that /looks/ as if =
it could
> >>>>>>> be causing it, but I don't know mpt3sas well enough.
> >>>>>>>
> >>>>>>> FWIW added Sreekanth
> >>>>>>
> >>>>>> The WARNING was found in kernel v5.12-rc2 test with a SAS SMR driv=
e and HBA
> >>>>>> Broadcom 9400. It can be recreated by running blktests block/004 o=
n the drive
> >>>>>> (after reboot). It is also recreated with SATA SMR drive with the =
HBA, but not
> >>>>>> observed with SATA drives connected to AHCI.
> >>>>>>
> >>>>>> I reverted the commit 664f0dce2058, then the WARNING disappeared. =
I suppose
> >>>>>> it indicates that the commit changed HBA driver behavior.
> >>>>>
> >>>>> Can you send the warning splat with backtrace ?
> >>>>>
> >>>>
> >>>> The warning splat is in the commit message:
> >>>> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.12.0-rc2+ #2
> >>>>  Hardware name: Supermicro Super Server/X10SRL-F, BIOS 2.0 12/17/201=
5
> >>>>  RIP: 0010:__local_bh_disable_ip+0x3f/0x50
> >>>>  RSP: 0018:ffff8883e1409ba8 EFLAGS: 00010006
> >>>>  RAX: 0000000080010001 RBX: 0000000000000001 RCX: 0000000000000013
> >>>>  RDX: ffff888129e4d200 RSI: 0000000000000201 RDI: ffffffff915b9dbd
> >>>>  RBP: ffff888113e9a540 R08: ffff888113e9a540 R09: 00000000000077f0
> >>>>  R10: 0000000000080000 R11: 0000000000000001 R12: ffff888129e4d200
> >>>>  R13: 0000000000001000 R14: 00000000000077f0 R15: ffff888129e4d218
> >>>>  FS:  0000000000000000(0000) GS:ffff8883e1400000(0000) knlGS:0000000=
000000000
> >>>>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>>>  CR2: 00007f2f8418ebc0 CR3: 000000021202a006 CR4: 00000000001706f0
> >>>>  Call Trace:
> >>>>   <IRQ>
> >>>>   _raw_spin_lock_bh+0x18/0x40
> >>>>   sd_zbc_complete+0x43d/0x1150
> >>>>   sd_done+0x631/0x1040
> >>>>   ? mark_lock+0xe4/0x2fd0
> >>>>   ? provisioning_mode_store+0x3f0/0x3f0
> >>>>   scsi_finish_command+0x31b/0x5c0
> >>>>   _scsih_io_done+0x960/0x29e0 [mpt3sas]
> >>>>   ? mpt3sas_scsih_scsi_lookup_get+0x1c7/0x340 [mpt3sas]
> >>>>   ? __lock_acquire+0x166b/0x58b0
> >>>>   ? _get_st_from_smid+0x4a/0x80 [mpt3sas]
> >>>>   _base_process_reply_queue+0x23f/0x26e0 [mpt3sas]
> >>>>   ? lock_is_held_type+0x98/0x110
> >>>>   ? find_held_lock+0x2c/0x110
> >>>>   ? mpt3sas_base_sync_reply_irqs+0x360/0x360 [mpt3sas]
> >>>>   _base_interrupt+0x8d/0xd0 [mpt3sas]
> >>>>   ? rcu_read_lock_sched_held+0x3f/0x70
> >>>>   __handle_irq_event_percpu+0x24d/0x600
> >>>>   handle_irq_event+0xef/0x240
> >>>>   ? handle_irq_event_percpu+0x110/0x110
> >>>>   handle_edge_irq+0x1f6/0xb60
> >>>>   __common_interrupt+0x75/0x160
> >>>>   common_interrupt+0x7b/0xa0
> >>>>   </IRQ>
> >>>>   asm_common_interrupt+0x1e/0x40
> >>>>
> >>>
> >>> Looking at patch 664f0dce2058, all that seems to be done is to enable
> >>> nr_hw_queue > 1. I do not see any change of locking context or irq ha=
ndling.
> >>> From the backtrace, it does not look like scsi_finish_command() is ca=
lled from
> >>> softirq... Probably a change in that area is responsible ?
> >>>
> >>
> >>
> >> In scsi_lib.c we only have these two patches in that area:
> >>
> >> 684da7628d93 ("block: remove unnecessary argument from blk_execute_rq"=
)
> >> 962c8dcdd5fa ("scsi: core: Add a new error code DID_TRANSPORT_MARGINAL=
 in scsi.h")
> >>
> >> and none of them can cause the failure either. In block we have:
> >>
> >> 0a2efafbb1c7 ("blk-mq: Always complete remote completions requests in =
softirq")
> >>
> >> but this doesn't look guilty as well, all it does is raising a softirq=
 for all
> >> block completions local and remote.
> >=20
> > In blk_mq_complete_request_remote(), I found the following code.
> >=20
> > 	if (rq->q->nr_hw_queues =3D=3D 1) {
> > 		blk_mq_raise_softirq(rq);
> > 		return true;
> > 	}
> > 	return false;
> >=20
> > My mere guess is that the commit 664f0dce2058 changed the shost->nr_hw_=
queue
> > from zero to a value larger than 1 (with my test system, it is 8), it i=
s
> > propagated to rq->q->nr_hw_queues, then blk_mq_raise_softirq() is no lo=
nger
> > called.
> >=20
> > The call stack I assume is as follows: without calling blk_mq_raise_sof=
tirq(),
> > there are all executed in IRQ context, probably.
> >=20
> >   _scsih_io_done()
> >     scmd->scsi_done() =3D scsi_mq_done()
> >       blk_mq_complete_request()
> >         blk_mq_complete_request_remote() ... did not call blk_mq_raise_=
softirq()
> >         rq->q->mq_ops->complete() =3D scsi_soft_irq_done()
> > 	  scsi_finish_command()
> > 	    drv->done() =3D sd_done()
> >=20
> > Will confirm this guess further.
> >=20
>=20
> But commit 0a2efafbb1c7 ("blk-mq: Always complete remote completions requ=
ests=20
> in softirq") changed it to:
>=20
> =20
> -       /*
> -        * For most of single queue controllers, there is only one irq ve=
ctor
> -        * for handling I/O completion, and the only irq's affinity is se=
t
> -        * to all possible CPUs.  On most of ARCHs, this affinity means t=
he irq
> -        * is handled on one specific CPU.
> -        *
> -        * So complete I/O requests in softirq context in case of single =
queue
> -        * devices to avoid degrading I/O performance due to irqsoff late=
ncy.
> -        */
> -       if (rq->q->nr_hw_queues =3D=3D 1)
> -               blk_mq_trigger_softirq(rq);
> -       else
> -               rq->q->mq_ops->complete(rq);
> +       blk_mq_trigger_softirq(rq);
>  }
>=20
> So to my understanding, we will always complete in a softirq.
>

My understanding is the change above in __blk_mq_complete_request_remote() =
is
used for IPI (it is triggered in blk_mq_complete_send_ipi()). Let me quote
blk_mq_complete_request_remote() below (similar name but without underscore=
s).
If blk_mq_complete_need_ipi(rq) returns false, blk_mq_complete_send_ipi(rq)=
 is
not called. In this case, the commit 0a2efafbb1c7 does not affect.

bool blk_mq_complete_request_remote(struct request *rq)
{
	WRITE_ONCE(rq->state, MQ_RQ_COMPLETE);

	/*
	 * For a polled request, always complete locallly, it's pointless
	 * to redirect the completion.
	 */
	if (rq->cmd_flags & REQ_HIPRI)
		return false;

	if (blk_mq_complete_need_ipi(rq)) {
		blk_mq_complete_send_ipi(rq);
		return true;
	}

	if (rq->q->nr_hw_queues =3D=3D 1) {
		blk_mq_raise_softirq(rq);
		return true;
	}
	return false;
}

With my test environment and some debug prints, I confirmed these two:

- The commit 664f0dce2058 changed q->nr_hw_queues value of drives on HBA
  from 1 to 8.
- The commit 664f0dce2058 changed the blk_mq_complete_request_remote()
  return value from true to false.
  This indicates that blk_mq_complete_need_ipi(rq) returns false.

So now I believe the commit 664f0dce2058 changed scsi_finish_command()
context from soft-IRQ to IRQ.

--=20
Best Regards,
Shin'ichiro Kawasaki=
