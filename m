Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 637B3C432C0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 22:19:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 397C82070E
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 22:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfKVWTu convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Nov 2019 17:19:50 -0500
Received: from m9a0001g.houston.softwaregrp.com ([15.124.64.66]:40810 "EHLO
        m9a0001g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbfKVWTu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Nov 2019 17:19:50 -0500
Received: FROM m9a0001g.houston.softwaregrp.com (15.121.0.190) BY m9a0001g.houston.softwaregrp.com WITH ESMTP;
 Fri, 22 Nov 2019 22:19:08 +0000
Received: from M4W0335.microfocus.com (2002:f78:1193::f78:1193) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Fri, 22 Nov 2019 22:19:22 +0000
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (15.124.8.13) by
 M4W0335.microfocus.com (15.120.17.147) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Fri, 22 Nov 2019 22:19:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XO1ZM5H/nUov4yj9kw+yD8X2fqzYHZlXhImz68CMPpolQuIm1pmvt56B3bYio5YD1HH2GZ94yI3y23kANv8d62qU27a4v7u6ViKTwaTDZX2ZDB9IrwhWbrDPV2JnR6mw8PoYYtPWZ9JSnvaUTMoJzVVkEBOVwjJ3f5QIASahkA/LkN3WjN2bq2RGgwNsFR5nNNj+8QFxXZs/vqauE+x1aMWKjk9aqUL99e8n4vQF1Tz64JCP9I6qnwzOn9pBu/C1ecrr3wtq7/Mxsj/WGB837i20XQOQbnHM26HD8BE8bwPJoTCDqiztqOXF0hQkftypqNzRxmzOzB0PtdiQfZuTXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WUcPgPoFRSw88eUBmy3FQcDiue53YHg5iNcmWs/N3Ro=;
 b=kkqycTCb5ST7JQZfIBTzBTZQ9m4vEEyeCsp/vQzE8uM9vD/7kdlekcsYLguttEJvzlOEH6ruUDHeALlHUNqw2gm8vKo4+X50HCQpknmspql+0DaWiwo2O4T+ZBUjPpjFbclfdacoB1TumCpcZU3ntceObAYUFxEJsICdGDtJdTAT2IGcfZYx741izDEmJmWejYpRjOIAc1s+B5DfwSeder34jKwQ30pucBYV7Cu9XH4IBXCctDw8o0adkDF7D8DsIweoCFc+R4LCU3ZstNqeDpfHkrIL4Gs0g0bFWcnVzIRGQQw8deGsxa4Xn3ivPfJDBeiB/ITjQWdzQWsqgGLGxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DM5PR18MB1355.namprd18.prod.outlook.com (10.175.223.16) by
 DM5PR18MB0937.namprd18.prod.outlook.com (10.168.120.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Fri, 22 Nov 2019 22:19:20 +0000
Received: from DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::b08c:34c6:ffb6:641c]) by DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::b08c:34c6:ffb6:641c%12]) with mapi id 15.20.2474.021; Fri, 22 Nov
 2019 22:19:20 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>
CC:     Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Martin Wilck <Martin.Wilck@suse.com>,
        "Hannes Reinecke" <hare@suse.de>
Subject: [PATCH 0/2] scsi: qla2xxx: Fix rport removal after unzoning
Thread-Topic: [PATCH 0/2] scsi: qla2xxx: Fix rport removal after unzoning
Thread-Index: AQHVoYLiALPZD9qKtkuioA7p8wEPgA==
Date:   Fri, 22 Nov 2019 22:19:19 +0000
Message-ID: <20191122221912.20100-1-martin.wilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR05CA0038.eurprd05.prod.outlook.com
 (2603:10a6:208:be::15) To DM5PR18MB1355.namprd18.prod.outlook.com
 (2603:10b6:3:14a::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [2.206.153.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb819f9e-9833-4005-a91c-08d76f9a04fc
x-ms-traffictypediagnostic: DM5PR18MB0937:|DM5PR18MB0937:
x-ld-processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtFwd,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB0937410683B4177A53E709CAFC490@DM5PR18MB0937.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(199004)(189003)(8936002)(186003)(26005)(478600001)(54906003)(386003)(2616005)(36756003)(3846002)(6506007)(5660300002)(6116002)(86362001)(305945005)(52116002)(4326008)(14444005)(44832011)(14454004)(6512007)(66556008)(81156014)(81166006)(66946007)(66066001)(256004)(66446008)(66476007)(2906002)(6486002)(7736002)(71190400001)(316002)(4744005)(99286004)(25786009)(102836004)(71200400001)(1076003)(50226002)(8676002)(110136005)(64756008)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR18MB0937;H:DM5PR18MB1355.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AGSBGgTPTGGQcrOHeb0cs9xfTIg40Dk8Q2L9ytAjo7bl/oRfKuJEfjAHx4OhAdO9LmIJVNLnWthEAOs0G7kbUsVbwVmHCMnW2uGU0rPTJwJkcZkNxklE4xjefTWJjd8AXAEoKUUWeeUN4JDaeRCMGRW8QniQvCLQ7z3NBkKOaP9Ff1s0QErppUditsev12kKoKUPZXlo3yDYW8otlzsCC/ow7in+DOy8NMta+yP0la8WAkY9s2XH/8WCpdkgVebPkBztLslZ/uttM1HRWgVlP0SPvuzpw6NAvfiR1wPbX5hHpmn5HdTkOIcf924eeCqu5/LT8tZeZQrTn0sVSei5loOlHX0tJG4j5KPsBVSCTSeM5k6ok0PVpkVzFAxgIUVoxrdfxe4Yde9VtdCF8AzpgncdFeaJY6yHzGgRg1/2sfVKSnDcxOczHAXC99PaMGBc
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cb819f9e-9833-4005-a91c-08d76f9a04fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 22:19:20.0796
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5Rq2j/3snb1g33Cd4zZ6PGBELEV6asjoonSi/FwpMvCPPvbo0JhiTvECnKFMu2ZQiqBxMjVC4TINNaubA9IlWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB0937
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

These two patches fix similar problems that occur if an initiator port
belongs only to a single zone, and this zone is removed in the fabric.
The driver doesn't notice the ports being removed, and the device nodes
persist in the host, yielding IO errors when accessed.

These are pretty old regressions, introduced before 4.16, qla2xxx
10.00.00.04-k. The "Fixes:" tags I provide are only approximate, because
the driver changed the RSCN handling in several steps.

The first patch affects only "legacy" FC adapters using synchonous
fabric scan. The second one is for newer adapters using async scanning,
and applies if the GPN_FT/GNN_FT commands sent by the adapter fail.

Martin Wilck (2):
  scsi: qla2xxx: fix rports not being mark as lost in sync fabric scan
  scsi: qla2xxx: unregister ports after GPN_FT failure

 drivers/scsi/qla2xxx/qla_gs.c   | 16 ++++++++++++++--
 drivers/scsi/qla2xxx/qla_init.c |  6 +++---
 2 files changed, 17 insertions(+), 5 deletions(-)

-- 
2.24.0

