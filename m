Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45BDFCA0EC3
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 08:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbjILIGB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 04:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbjILIFo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 04:05:44 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C046868D;
        Tue, 12 Sep 2023 01:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1694505699; x=1726041699;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=ITiRWSgdyg/3Bs5/ajFXyDw2vxfA4EwBeTy/1SUckQw=;
  b=nLuJ4mmtZbIQ5ZFehMDddV1JNcpAsWqAKK44c9oIIyxymsdJyRBuouyd
   9XkTigQUgG7BFPUpaK5H4OyvJwg5Upag4LHb9/BF95h/P72Yb/iJEaPMJ
   GZhNX+G5ee6SM40ibM+Nr9k79tItqPYcAb+z9u0y+s8RLil+8oj70jueg
   pL+/ZRk2rLYA+cthmNgLTUssWfv7JSc8UGwl/5RyRCuDp13OCUXhcrQaa
   XC+767VDi5M1ipO94EMRSF1lnNyWzGHGCM0Iy2THXUljj2mttMSNFuV/j
   UyvnrJQt3Tcu2wSNeC5ZETcMlg4x9AFcwSphfJxxsjAfuEQQuR4m4Cda4
   A==;
X-CSE-ConnectionGUID: 9m+814UCRNasmlhNwhaJQA==
X-CSE-MsgGUID: /ujHMaHuQy6w1MwuwOp4qw==
X-IronPort-AV: E=Sophos;i="6.02,245,1688400000"; 
   d="scan'208";a="241947485"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 12 Sep 2023 16:01:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=coq1TUMKFBsKM8qeVEDqcYkizyHwCKxBTASf4SPwTZ+tvY0ybKIw+tASjgytCjfeX6pidQQWyTKu0mF3++ucK+clGutnKCgqmOeOgnDapv3wKvMhVDT521ME8WcY0a/89t2ym4RpPvQRBj8/T70PG78S5gCuq/j8s12U2YaCP5jT7zS4U/4kM190Z4zgR7B9eLRU8QQ5myVlwFkbP+FXXjdC1NB4HSKEL/0hNtGTA0ZDPk7+TLnWQWson7sBgxWwihVHp8SphwoDYZ5qRiVj7ZPA9iGtbqHRZRSESRZNrmJHMv77AdRF2WZeGon0+stdobeVOonzPNcnWzarYQDhhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c2fhmjDoosiCf9BSYl28gD0J7KLyzxG8PiehqhzQNEo=;
 b=d6VzrSOk9DylUmMNqQw+ob55I5uxXuyLvV61RJI6iYJirc3BX16EZP14mnsKmvUmBvOk6B0BIbOB6QZqjYxbnofj5IiLxJw5N8FYHeUkdOvF2Dvtm3oL3+83Ep085iwSk/xy0ijt3AoIEGm4vFv9tBTvjLfIi0Q1rRdHUkcr0eQoFJiPFqkGQKipkJAg3hwmsfedEAvUCuLrdxJZoy01JjJDcJFNVetjO1SQwZOD+ghZSaaMrbM0kvywypxgklv4cq5eXnjBd7APwNpbT0G38eJ3z6xhpPRJ1E70yyVZ6ibd+n0vmuxDjVvaKN7fcAjBg9JD8cKs3MBRaBc337WGqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2fhmjDoosiCf9BSYl28gD0J7KLyzxG8PiehqhzQNEo=;
 b=rCLASB6D5PCYiieeDPXPTahO4StQ1k6DX6DB2mypuBT+rHuiCC02ljTb3af7Zs8AXTQS5vogZimUJTgdwlOs13+lAJAHifmwX43elrVMc5uNVe9G+CniM4pNASJRmc107osl1BSmGtFFe0NT1tZ3L+wWPvzIXibqA6Q+KVNg0m8=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BN8PR04MB6308.namprd04.prod.outlook.com (2603:10b6:408:df::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.16; Tue, 12 Sep 2023 08:01:35 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::f92a:6d40:fe94:34e9]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::f92a:6d40:fe94:34e9%7]) with mapi id 15.20.6792.016; Tue, 12 Sep 2023
 08:01:35 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: blktests failures with v6.6-rc1
Thread-Topic: blktests failures with v6.6-rc1
Thread-Index: AQHZ5U9ZuDCF6u+mDk+567SJxCFuZA==
Date:   Tue, 12 Sep 2023 08:01:35 +0000
Message-ID: <u4g3jh6dnowouthos3tdex2pflzo3hat55e5dc4j6pul3a3uov@y2axtbiura2q>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BN8PR04MB6308:EE_
x-ms-office365-filtering-correlation-id: a7bfeafc-856e-4109-81e3-08dbb3667c31
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8KYqu3kRJxRVETtrT97Ix5ACBtYqMXva5kCy7oH+JG89KHfmdxgCIvweDB2Wj7J9cWUmaaqwhV0LUPJvX+ccVyDGR5qdGsRDxiMnV/ENsuWVURwIjNHABMs5Pa6zTmKN9cM6y/h9BPrpXW5qVpxq7O/kwnid6TH2Vr20D4wCmgoYsKLM3KvqXXBfIXhDjkTKRxN3x2AuWX69EGe48zP9eGPwcE3qAMwNZLHNh7xHfwH3eKvEWbgl+NXkZMDlxuaX2mzHlZvvzVL0RRoz7H4JX/9TOl7bfvtUPx1uneasl4BDPQjwMynHVZls7sRw9h5SxBXm22fVmC/2HznLr3J/+1ic20/S857EpI14azQy8ZoqpxbO9DHLG7bluFmzMCoWEkjI6vQfAEHw6J1pqMiXvjmJDpjWzCgTd9H1KpQgdUC+QZpYoR9oYVpsghl4ZeGnAtU9QY27zPAXPGAi/u5p9uKJJZbJ9fm0ZOoloceomWuOIk3olmr8mDQmKRagpD4KpnHqJMQln+7Tzkg8FyzPBE4NrpRfy+Jf3AUIoU1X9eBabcvUZ1z7N12EQNYm/BBgTJyIEA0CsKeVGaoEypjJ8q2rXxHbqHGTjBzXGjw4+j5fIw/ywZ4GC0MD/IA0b1sv5SRrbvGdC7l5nsJ0PlgsvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(346002)(376002)(396003)(136003)(366004)(39860400002)(186009)(451199024)(1800799009)(41300700001)(6486002)(71200400001)(6506007)(6512007)(83380400001)(478600001)(966005)(2906002)(33716001)(110136005)(44832011)(66946007)(5660300002)(64756008)(66446008)(66476007)(66556008)(76116006)(8676002)(8936002)(91956017)(316002)(26005)(86362001)(9686003)(82960400001)(38070700005)(38100700002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AH25u7ePrUb1+6Qc54Ca0inVaXXve9VEBX5x9EF5/W0h0kBdZwMPXXIkuGw2?=
 =?us-ascii?Q?G2b0oR2Ro+49+VdnB+1k2FWHQ3LcxHiBisfDElR1nA6qtgGB6WboUTjU179U?=
 =?us-ascii?Q?8RpVoJdIleQX+8mLsfnfjWFQ+BbpF4CjU7e1keGQCCCRzDBfXrWdbSz8PVrY?=
 =?us-ascii?Q?2fK+ci+FkYLFuhrUjtMkhTvM1lMdBktH+V9XELqdXbhYbrMU+LB2C7S+Zauv?=
 =?us-ascii?Q?QiXXO2CuNyOx95Ti9GlUfeIIIBBvI9AcLf3byP3qv2AxQao+dsmTiwXIcF31?=
 =?us-ascii?Q?cYgpIV1ZtmQt9pVxpl5vv6zpcknvFIYOHUfauli81IdVafJEoP5RH5z0HgI6?=
 =?us-ascii?Q?0Zzd9JDG2eqm7r9zIKZ+XfjdcFxsEnb+bQRE4PIwC7e530HL8V6y0zYOv0Ib?=
 =?us-ascii?Q?UXnH4kwpumrFWzBysuKrM5tJK7EBRN60Kp7jFsYLHclPfsTDfA1nQdDC1J9s?=
 =?us-ascii?Q?wT+Ma8AObRVAuVtOrApt4NjhRAZtFbFwkmDbUSfgivzwx1qaRwz+FfsOUw/k?=
 =?us-ascii?Q?x7EV+njzbqo+7SH75xSG/XTZ2ycX/VMCrBxMdGm8e3kRgh0Tm35FuK+X4hjL?=
 =?us-ascii?Q?LPV080CXuVYgPfdP7TGVEWdUpTHmU0KOatN8bc2NuLQX468TUzccRrzrW4EL?=
 =?us-ascii?Q?4mBoQcGIkWToDHFSjak2VLunvh0wv5+erp6J+aQyahdjAt6t4iM3SMSKCd4L?=
 =?us-ascii?Q?2GZqYZiRGTRXnP0CG5Pmiz3vnrPjd+bHrHBj/EGA0/YlWzLBFmCRJ6UwNrVK?=
 =?us-ascii?Q?xlITi9DnU9rFYg7/OHn8roFYW2hX7FCNAx/9rADoXFK1zo2eKpt0xTMdEi/K?=
 =?us-ascii?Q?AqAEzu2zGAyJiU2tDQ7NkpU1HXLFVnIX8MG3DFpL3iT0NFBm0mTqxjIFLD7L?=
 =?us-ascii?Q?QWQOh3UvcslpllxqplZLIdoM76rRzPfdD2HFH247QaBd1hjZgaZkL4MX0JzC?=
 =?us-ascii?Q?WwSAQsttmxapFogXCmA959cL/4NW813i3W2Ah7WegWx25rM6WBJeJZvTv03B?=
 =?us-ascii?Q?dAJA34t3xmNeNYAbscVZEmrbuX2DrcWB/jrWjL2qiPWPUn1X6CZqbk6/N82O?=
 =?us-ascii?Q?Avu/0CkXHj0dcuGAEUQuaolm5QPoLY1xSf78179uw4p6ml7DIfJXfrS+q/+X?=
 =?us-ascii?Q?3titKlwnGT5Sy0RlpCwDghKvQftPrW6X0FgD+4NYxj/tGIwsuPJQlVlGJk23?=
 =?us-ascii?Q?3P9gquuEa0VmtlOK0P3HPdvNxlU2M8m8a7DolaMkjhZHCFadeL/6bHmt+ioy?=
 =?us-ascii?Q?JqRhve2PtsQZMS5F+xzNWu36ufj125JkT78tTGrFwY/wVKUqR1HomGcbeCZT?=
 =?us-ascii?Q?h5hxUq/BF4C7FB2d3VKdzWkSEjYbZsw1szQ4SUp+5ZNk5BYQ8a0bk9/A+7RL?=
 =?us-ascii?Q?rBl8ei/F1iW3/GGtN6XKY5/QHlr6F7fzuqZWfnX/7ip4FX6XlJr4qUbEPLWJ?=
 =?us-ascii?Q?JucZK9ViiiXjwCCvJRcRchHzeSSy483L1eo0FtxKJWUuQpIT6gTSESY05fMt?=
 =?us-ascii?Q?NJnk3zBWTQfpfBzUgZZiOCsKCAUrLuoc+Z17AmkJRXroUVACk3tjA+v4AI0g?=
 =?us-ascii?Q?AGvjcalExj+d4baqlE9n1x6QcXt2VMKA8bkCmQZlOhWbFsg7ZKBYeRnSXjkN?=
 =?us-ascii?Q?dYi7xTWiRScbeqOtx5Ww1jA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0CD2427E9F62AA4D86456A3D9110941B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: kmhcnPCFp0ygOvRNBMIyxjMrLoRm7AJnihPvmYiP0UFXNIG2iTM3X/j9aZGA7L7QkrlO6uSopy0NsTHxq24PMTCEIoUBJ7VtpS+n3nTOr4dNQf3eWHIc530O78C4UYJ+ZNjjS2BfBoLVyWiljmUwqSFssTMo8KWyJ4hDrjcLe5E91+Uvo8WiPhyDxyKVTHDAcP/x5r4538SmlQmIb38OkH1v5rjirGyGknpKjonVeVnXwcl0guObM6Eqwg/2M2hUp4eYEkYH1pEc+7lUaFwC91nmjDFpfjOaUpBdeMGbHbng0+URKE5qA9zzMaUWxFtCl+8CoL8t7bBZhmPUvxpNpbRAnDxQ4OEEUnX+12K0m8WMpUsZITYG4cHJeQdX4ccSeYC3LNtV0cBevg2YMzq3NlGN0ZE1qUAGI86e/znm1HMMrBfGl3R4CT9MWrHEp1Wwt76VjyT7RdnabI+ia4RXv63rQ+/3cRRr+DY1mp/S2ptpcM5gMiBdGfJ4Ly6gBR+xBM9qZKRU7lyOHWFl4rI3Tys+47vuUckVOdCrIy4bS4zPojsURxIMHjaSk6x8Xr5s8HduOpaiJ+voTd50jPc6D2x2UoLpk0rBDy/d/3ALMgktISXON2C66g2eK0y4qtHcizrpSMqDaI7taK9sXuI6WinEgKbDPpkPP1f6x7PweCGpX5SyPHkdg1CQOLuLJD0o7RFrKDO2CNDaQrKFOxHqnsLql9F/R6REb9YLuf7EaZGQVTNFszTE8IbJpfxArcW1D+xF4Tp0VhjVMaXHRWaEYRrgMaTtKTZFNg15qBWZnPbi4NgpJ+VquJNcI7GSaPOm9tQ0nl2Y04SLlegdNlrT5A==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7bfeafc-856e-4109-81e3-08dbb3667c31
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2023 08:01:35.4275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fpL5iLeTED8n37ZGmPPGfyajRCQQYR0FOFgc0sJREBx9u2GnhpzKRiMqLSRQcYsqB0PianvibuLgsY++TFU76+Vosxg0P38IHugY/aDbniU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB6308
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

I ran the latest blktests (git hash: e0bb3dc05bc7) with v6.6-rc1 kernel. I
observed a couple of new test case failures which are listed below.

Comparing with the failures observed with v6.5 kernel [1], the failure at
zbd/010 is no longer observed (#4 in [1]).

[1] https://lore.kernel.org/linux-block/dycg2iltyeezp6y7bqfhfke6bb3dantkk5n=
syk6qjfg2o55esu@liixlkhgtqy3/

List of new failures
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#1: nvme/048
#2: nbd/002

Failure description
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

#1: nvme/048 (rdma and tcp transport)

  The test case fails with "BUG: KASAN: slab-use-after-free". Yi Zhang obse=
rved
  it with linux-next kernel and reported [2]. A fix patch has been provided=
 [3].

  [2] https://lore.kernel.org/linux-block/CAHj4cs_CK63uoDpGBGZ6DN4OCTpzkR3U=
aVgK=3DLX8Owr8ej2ieQ@mail.gmail.com/
  [3] https://lore.kernel.org/linux-block/20230908005702.2183908-1-chengmin=
g.zhou@linux.dev/

#2: nbd/002

  With kernel v6.6-rc1, nbd/002 fails with the messages below. I reported i=
t
  to relevant lists [4]. Kernel test robot reported it also [5].

  nbd/002 (tests on partition handling for an nbd device)      [failed]
      runtime  1.620s  ...  0.369s
      --- tests/nbd/002.out       2023-04-06 10:11:07.923670528 +0900
      +++ /home/shin/Blktests/blktests/results/nodev/nbd/002.out.bad      2=
023-09-11 12:03:30.901246261 +0900
      @@ -1,4 +1,3 @@
       Running nbd/002
       Testing IOCTL path
      -Testing the netlink path
      -Test complete
      +Didn't have partition on ioctl path

  [4] https://lore.kernel.org/linux-block/jvlrypdkye74nea4iys2akwfyvskvpw4x=
3a2zewwxx3qde22rj@jykkoadmb2m5/
  [5] https://lore.kernel.org/linux-block/202309121232.767ff8c4-oliver.sang=
@intel.com/=
