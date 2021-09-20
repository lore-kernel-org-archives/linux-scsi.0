Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E04C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 07:22:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6438260FF2
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 07:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbhITHYD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Sep 2021 03:24:03 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:25015 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhITHYC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Sep 2021 03:24:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632122556; x=1663658556;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=CREi4X0QAIirB0urj94o7vGcSEBNmSqgmBH353K5VS5cf30PvsVbu7n3
   JEk2eDao9KBO67cHPR2fQcIN0AROhk35+bcIp+D983dc4tHBL/33oAkkb
   zJYxbRoY9cP+rOxgzAIHxR/22TPfELiiU+IHKXm6xsFRW1J9J/++l2a4P
   pHV0x7JQCPunklRALdTPRGtzEhE91F579YgFGimrKHNyqmvUTcARInu2f
   1CY/EXlVw8Rf9hyn4tw9XQH1oOJ5+T2ofMWueiA5hKuKE6pelK4CKBlN7
   AId1LgTf95AqYhRKM14Z2AmfLamCdHjdmB+t55OtzeT9Bax55JS2IIqwZ
   g==;
X-IronPort-AV: E=Sophos;i="5.85,307,1624291200"; 
   d="scan'208";a="292048334"
Received: from mail-dm6nam12lp2173.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.173])
  by ob1.hgst.iphmx.com with ESMTP; 20 Sep 2021 15:22:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K9wrOblIn3oTalRJqYymU9eRtFA/ErupWC89O1/el7IHZ+11MP74YayjWhEkLMRXPD9/9lPmcnugh+dsNH34hJNvu3HFeN78Syqp0vrICxp/eajv4YgPVP5VHdUwG3ZsvP03+ZFjjF8t+4rZdbkNRSm97yKtQzErM0/4NCKrc8oCDYjL/L1pNeDFNFDVXN2sJ7Iol3V1I/LW1RleN+VQHB1M5RtH+sHG+zoR34IruLx+bel5KSfWh1WTm9ClETE/Fk28iP4fZmXNu92zMlViRYwtHrIeCsgHBQ6boz1MEpYc9zEtUrFEUqcyAesjICm3BzQHR/RGxq/bRlLFBK3tdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=AK9Vc4mxV3R0jGVD5g6F6fHeubYnnDx04UZpT8vZ/NsCkPMsh612skMNLDG/is5rJ4780C1zfDXQDk1s2+dy+6GQoeLm6wjog1bAywHtDbw5GsVWuL0KjchkiLrPp/6MNa7jjoIgZwZUNrTt16Vy/9qslKzgouQMciMZoZ/o+3Yh/LB6WJPk4ecRR2FsZLBxeGTUB2YCz1OKI7/XEsnr0enTCZmOIX2YiEuK82O0syY4UaAtmUwCp66u4n/yhxkxGxZewUhUQexVIoFS2hBTcUjgy+aollgec1jvP1Ms57rehnMtPeSZUEfmTq8/WaGVire4LgoflGtgiECRC3uiVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=RSO5ZmEfrSsC1WXgA/VhYg1cXUDDBWBl47dK0Au28cTm4ES2LFCFLHrREjCA18OAY/RQql870c365qzFfIXtupq4Mk0y9pAcwG0nnnPdC4wG5do+PnBh4BQbaQEdnaDQXkCBvgs/sRDqrLiq5hmqb0bVP8Tlv73iPyzenVxAGQQ=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7350.namprd04.prod.outlook.com (2603:10b6:510:b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 07:22:33 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::5d0d:3d52:2041:885a]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::5d0d:3d52:2041:885a%6]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 07:22:33 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: sd_zbc: Support disks with more than 2**32 logical
 blocks
Thread-Topic: [PATCH] scsi: sd_zbc: Support disks with more than 2**32 logical
 blocks
Thread-Index: AQHXrApCNeGyqlO69U6oERHr5VGZ9A==
Date:   Mon, 20 Sep 2021 07:22:33 +0000
Message-ID: <PH0PR04MB74165226DE6E41EC5A6D7FAB9BA09@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210917212314.2362324-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a244bde2-3c8d-41c1-1a99-08d97c076a05
x-ms-traffictypediagnostic: PH0PR04MB7350:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7350D2A3189E4730BA57F95E9BA09@PH0PR04MB7350.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zKheF8BL28elj10vdIzYkqKzym+UCwjSX4AGIkdpxEq4kNc/JyXJGuzlvvYTNjIq/aOAd9OBZ+pzLx2CPqF39k4Dw9lv1pGPYSd+aDPvsvM4M4KSZPJLokYu9BH1AM6iCMjqiOSvpcX54pCFvOLXo13ucCSPBA6EQCK+2gqT7JddDG/cF7cSt4FnPQWWgkqk+xsa68R4IWNvkVTAFUa0yInMoEvR2dhQqAqOEWQ6Xo9fUTBw94zDkNad+2c5tgz+crNkK5WiCwCDGOKNHq0H0AVn5OvRuKQvvSgWTH84HbOrLywM0PFvaL2s361RJFIiAdd7jZLIuSfr5Gf/G4mpmsCqGZAPiUJPWwF0adCZl18Azb7O62+RwQKhF2YD9nkiAWk/IZRnrLFf3gDMfiVGeHcbHteRirsIb2kmq1qkUwD4JfMbBemxp/RyGO4UHjX8qLFYLrrUdqeJZ7TZIO/mkX677bqzYLVEYWfWJ3lr3BPpGf2EOlQu+3C3IsfoRfbGADrglD/sIRPaMO/F5I3u2a5Skd1ctLy3ZNg21GDOOT8w72OAnhrXSQzUpNS3wdPyd1yCPnG/ev3socOeJHOkazubLHJ2Id2Xu4PSIWzlnPUJdTLPikJgq/EEUh32u6Hp3a5BfXnYZwo5QY4JGO3o6Me+gvKjVY10XYsSlEOn6SNdWHVZGBr2DjLk4Of0+XJFVJPnSx5ZCIVyYhhb77BCrQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(136003)(396003)(376002)(316002)(478600001)(19618925003)(7696005)(4326008)(33656002)(122000001)(86362001)(9686003)(8676002)(55016002)(38100700002)(110136005)(54906003)(91956017)(66446008)(64756008)(66556008)(76116006)(5660300002)(66476007)(2906002)(6506007)(8936002)(71200400001)(52536014)(38070700005)(558084003)(4270600006)(186003)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?049dxlyDYiIxbu1BsdQexK/0GengyC94frzIi1a/yQIJldn6c4E8Q1bPErK2?=
 =?us-ascii?Q?hiOQ3EHXSuT8uNX3BSpjV9qiYUMWdKmLG4SqtseL/Rd8whXAy0MBNEPSSFeF?=
 =?us-ascii?Q?UWNBTiTGxRZbE+fRa+lVFzCbCoG/+s2OGDB+guvsS8bDWoKTIRTaZNKTVaIj?=
 =?us-ascii?Q?Co6fgjsFgNm9BBGwaQM2IxOD/ijhOA9aFC1kXgmN1nu3i6jxEgIjnhqsA2CT?=
 =?us-ascii?Q?shUEqyO914fOzzCO7bdQFMn4mjBLzzok2G4zHdcdhMhqrub/SJbc3WZV0tT5?=
 =?us-ascii?Q?vWV4F8pJX7ogi9tVuJjGs0ALqdEw4q6P4L+7bp7MHS06n1KUeq+1VFdiyGta?=
 =?us-ascii?Q?VcSM3WGXOnLpk+QJ1VK5LtzvGGfK0RAfgLLBsFRT+B+2eZUZ17qL54QZmWBL?=
 =?us-ascii?Q?GScb2Om3wlh0X2oMeSgN1fHlu2UMM1I858LZ8RGFIy5XCXhRfFQQXCFYD/fh?=
 =?us-ascii?Q?j7tU8wfPiaOg45xGzyNwXe/6zEmqKlcd0+PBeGM+BMx5c+PF3nmz6SWUs3Rv?=
 =?us-ascii?Q?v4p7D0I8ycxaFFNS5C+A01BFY4PKLyRUaHQM3xxwQ2A1fhLRSXHYs7ckgtSd?=
 =?us-ascii?Q?YotFQ5kLeM8KyisbMUma09nhLZ36XmyeKgPwiKLBPJDLTTJYg8CTbpznIOwn?=
 =?us-ascii?Q?CpzORjuWBzRMkgdSX3u7UGz8llnu6uKX8F+gI9N0hA54r+TH5JBu9HPND1cO?=
 =?us-ascii?Q?Mv3d6dsKpRUKckgBcCgSpuKPrHDT+oj+F8lcVcQ0VjGtGWWPLHC0DJKHQFOQ?=
 =?us-ascii?Q?Xu4BjhStUVCXARas3j2G1yt9XeevXl0HhkKr0O/3xlCOrXm+cYzbeZ2fc/gc?=
 =?us-ascii?Q?Fk19aVnPp6oVe5ypOzvowx0rMXhIcfSS6GQqPHgL3KW3vi8oLFjRD/mpWok7?=
 =?us-ascii?Q?FkyiS1p0+U4WNOtXRMMQ4YanrJEa7a7rZ9VdxaNyxB4OKTcw1BT+/n41ZBQl?=
 =?us-ascii?Q?0d4ivlgK/5NT22LGAzoml595ptsEa8JpvQ9xTYYm0uEbYV8DkkVVqLF2/UkY?=
 =?us-ascii?Q?TSK+n2w4IXJQ+m/dfnCL44G5y2Czld4RDzZPc2Yko1ulbEbTw5x0SyAPkfqe?=
 =?us-ascii?Q?JbL2vgwG5DaDrkfoQNpV3UU+z979CgJLGYh/cCSkVnlVLwuq+kbkBOJCpabW?=
 =?us-ascii?Q?2+zaycqEaQfLpT7YQM8K4ZiV/2QtsCUdVxxEJP46lc7CYwNsYTXXw0zuWtx9?=
 =?us-ascii?Q?iaqHffxfkAPYe7t5ZA8cSKIEY2iSsmyWOPbw9dpGkvRCHzTCdWH2h1FrvDNt?=
 =?us-ascii?Q?CGZGNqhSppnaBOLI3ymKGJ8j0XrSHwQIxON/JdC0SXm3yOZ/AYN78MHfzj5q?=
 =?us-ascii?Q?VEzBF59REZlUYGNNhI2lw3M3ux1WDkutWiik0ilXW4plgNzrMQdKQDoUydpc?=
 =?us-ascii?Q?m541BaYrCQsQS026iqYa8AsvYvbN2+gXpQCy7M2VU0i1H0rYQA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a244bde2-3c8d-41c1-1a99-08d97c076a05
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2021 07:22:33.2780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6M4XTllJogMt+3O67Esc7RPDuQYoFNOMDr/rfQVhmCmjQ2WW8viDTPnDaeTknngdSev2QZukk6EwlrWbqUR+VZGXZ/z/boqqNAl3Qp0AVek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7350
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
