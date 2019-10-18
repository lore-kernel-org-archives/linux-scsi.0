Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBACACA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 07:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76C0B2089C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 07:26:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="mDR4mvfy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394031AbfJRH05 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 03:26:57 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:60691 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390719AbfJRH04 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 03:26:56 -0400
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Balsundar.P@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Balsundar.P@microchip.com";
  x-sender="Balsundar.P@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  a:mx1.microchip.iphmx.com a:mx2.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Balsundar.P@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Balsundar.P@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: NIsXowA9SFznnVZDHO1GLPCAM3snDmBQeJNYbJBgBZWr8aLMSO5JBrX9fN0BCRnfvpdMHX6D1L
 6A7eHgxd6ipcSLINssjYlt/M2iY5qvK58DfhHCstlAu4ebWdnK9wvwK+VWQ6on2R1uofLnbX9I
 iLz3jIcnfyk+HKg5HgnvoAlji2r0k/uRtPcfXtcVLWsb2VwXgffEAH3rdLMaJ9UA09zvbuG25n
 DINw12LOm2BsOUmgwfQ26xRYIlJ2L8zV+u+xIPtG+FuXD8eFXQBjGDeLMLWmbI/jL+bvrel0yV
 c0Y=
X-IronPort-AV: E=Sophos;i="5.67,310,1566889200"; 
   d="scan'208";a="50590237"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Oct 2019 00:26:55 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 18 Oct 2019 00:26:49 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 18 Oct 2019 00:26:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aIN+bPsuXh9GtNHokWKFQlt7kWTGHh+G8ZBYHtyoWX1WvjHaol1OIfjH3BW3yPiLYlhE8Ii3Djehb1c6GVuVVZLWwzC3PS4H8gN/muts7ZN6vfM7iKJC5Wj7QEZoAJ/3B5ROzgABN1dzkNYN8Zp0pK1727d6cndK42rlmOyP398uvfCQ9oVCc657uJWvVbGQltoJPHzpanFaKAMCHXvpH9gEQUZcXVsLNcKryTX+TsFCDPbVCvPq5iD1SpHhS+vH9WYmJfSqxTO7Kmfv9yNf0LRuye8ffWtuhl9eXeVmgpfbV2X3tx2Os8XQeCavz9teglNDc8ShOxV/y/lvOgL16w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V73rSyYCeZImzlacOD+eGPzdqhovxCraknzjFGHiFmk=;
 b=Ik3GdzNQZ+WO/F0jymKn4wVtWKRGynZfBvX5r1OyI7RzjRN1X4sdx8ZtjpKAsAw/zC2bzB0dL2uPrZgArTm7CpCymwSF2bRLgceLv0NR7krSfaVCoBh5K3Yrf1+Yfwyw/nVlWQfbaa5SrOBI1JSKmJGbd/VQuE9wyFWKonzrC+ohVYxBtZadfDbQcHpto8B0a4MFF5614qiMdFOylNyGJ2xZdabYZbW5/a7kI47YmBcqb7FT/QYpiSF0RWFW1VvMkMjHJ4M3eoi6PHShA4iifEC+hyizZjf1tmygluBTnUPFtDqc6kTwe6ykG7ntg0x++7knCVXUe0VWzibs8JvM1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V73rSyYCeZImzlacOD+eGPzdqhovxCraknzjFGHiFmk=;
 b=mDR4mvfy5HXGdr9Odf8djcAYOhdnKx1fsYsJWeT2BQOTTwRGdMgOyy7aWdtYCWeEXMpFMJzTaHVydFdIAS3HHyOb4W7Ti14aS17pEPwV+W3hJoEiO+KnrJ8kfiB9xFD11UagLJXA6eC1vKVLn2CGNamN49bjbjGI5HQXqQltgzI=
Received: from MN2PR11MB3821.namprd11.prod.outlook.com (20.178.253.216) by
 MN2PR11MB4399.namprd11.prod.outlook.com (52.135.36.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.19; Fri, 18 Oct 2019 07:26:48 +0000
Received: from MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::a4a4:ec4a:a409:d907]) by MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::a4a4:ec4a:a409:d907%6]) with mapi id 15.20.2347.023; Fri, 18 Oct 2019
 07:26:48 +0000
From:   <Balsundar.P@microchip.com>
To:     <lkp@intel.com>, <balsundar.p@microsemi.com>
CC:     <kbuild-all@lists.01.org>, <linux-scsi@vger.kernel.org>,
        <jejb@linux.vnet.ibm.com>, <aacraid@microsemi.com>
Subject: RE: [RFC PATCH] scsi: aacraid: aac_schedule_bus_scan() can be static
Thread-Topic: [RFC PATCH] scsi: aacraid: aac_schedule_bus_scan() can be static
Thread-Index: AQHVg4qcyeKxLPRCm0arbSwIryW5U6dgAvAQ
Date:   Fri, 18 Oct 2019 07:26:48 +0000
Message-ID: <MN2PR11MB38217556308DD6E511D49E24F36C0@MN2PR11MB3821.namprd11.prod.outlook.com>
References: <1571120524-6037-7-git-send-email-balsundar.p@microsemi.com>
 <20191015185807.gkfkf44bc7accjua@332d0cec05f4>
In-Reply-To: <20191015185807.gkfkf44bc7accjua@332d0cec05f4>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08843f9f-e049-4410-9e77-08d7539c89b2
x-ms-traffictypediagnostic: MN2PR11MB4399:
x-microsoft-antispam-prvs: <MN2PR11MB4399649D86BB0BDBB2A0563AF36C0@MN2PR11MB4399.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:469;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(366004)(136003)(346002)(396003)(13464003)(189003)(199004)(305945005)(8936002)(81156014)(54906003)(3846002)(52536014)(2906002)(6116002)(25786009)(7736002)(110136005)(8676002)(2501003)(316002)(7696005)(81166006)(229853002)(186003)(102836004)(53546011)(6506007)(26005)(76176011)(476003)(99286004)(486006)(4326008)(5660300002)(66066001)(11346002)(14454004)(74316002)(6246003)(33656002)(14444005)(4744005)(478600001)(6436002)(66476007)(66446008)(9686003)(66946007)(86362001)(55016002)(71190400001)(71200400001)(76116006)(256004)(66556008)(446003)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4399;H:MN2PR11MB3821.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7vTRmCv4rtvY8O+91JcqemyhotzEc6heL7J1TCnhzaf/VfHhjAn4JfvU2SDbXuMnF3xIvBhcEablMeK0N2x/8uJLgYg1XZec8uHlyEm6dY0k2kQ0o96PqtIQclMouOHgUgN9Z/rDPFxAiIYJNLl3D5UJszoI2euXIGBkiU7edgenOtjr6vflxaAao9LILl0KwOqlxqzOIuRzrvlfmS+OB80A+Wo9xGBjUF6ke2Gj5iYiiuKSYMxEPG/DpaHxHmFsNNPp2TnPMgP5HL/yFY87fFmpagudpCB3cwdkoJ8c4Me4nGXtue035znUL3gTLt1pKS9IEWgLfpQL3HSN5BncYrHzu4HcPWw9wDn14a+JSvmapMxoVE2MEnQKnDV53z9q2s+W7I4I+g9raNpN9RNf0wweC0Uo+6p3iUEK8jHybno=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 08843f9f-e049-4410-9e77-08d7539c89b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 07:26:48.4503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kr0pO+Ad+xJIDxoriO8Z0aAF2YjDj3DvKGQwO8BLmhg9nPfhUaEUJYyRCYQfvQd5QqacLx5YlI2k7RAelF3bJZGHegW5xH+eQZHbm+UfqpQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4399
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Acked-by: Balsundar P < Balsundar.P@microchip.com>

-----Original Message-----
From: kbuild test robot <lkp@intel.com>=20
Sent: Wednesday, October 16, 2019 00:28
To: balsundar.p@microsemi.com
Cc: kbuild-all@lists.01.org; linux-scsi@vger.kernel.org; jejb@linux.vnet.ib=
m.com; aacraid@microsemi.com
Subject: [RFC PATCH] scsi: aacraid: aac_schedule_bus_scan() can be static

External E-Mail


Fixes: ffcdda7d81b4 ("scsi: aacraid: send AIF request post IOP RESET")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 commsup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.=
c index 1c3beea2b3c57..5a8a999606ea3 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1464,7 +1464,7 @@ static void aac_handle_aif(struct aac_dev * dev, stru=
ct fib * fibptr)
 	}
 }
=20
-void aac_schedule_bus_scan(struct aac_dev *aac)
+static void aac_schedule_bus_scan(struct aac_dev *aac)
 {
 	if (aac->sa_firmware)
 		aac_schedule_safw_scan_worker(aac);

