Return-Path: <SRS0=821a=X3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E175C35280
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Oct 2019 14:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5AF521920
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Oct 2019 14:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbfJBOke convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Oct 2019 10:40:34 -0400
Received: from m9a0002g.houston.softwaregrp.com ([15.124.64.67]:50264 "EHLO
        m9a0002g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728119AbfJBOke (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Oct 2019 10:40:34 -0400
Received: FROM m9a0002g.houston.softwaregrp.com (15.121.0.191) BY m9a0002g.houston.softwaregrp.com WITH ESMTP;
 Wed,  2 Oct 2019 14:39:54 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M9W0068.microfocus.com (2002:f79:bf::f79:bf) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 2 Oct 2019 14:35:48 +0000
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (15.124.8.14) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Wed, 2 Oct 2019 14:35:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dVSBmnPs7Aj6oJddu2EEirKl2XmKp3DF3SGeQov+sXrXGxCkkvhD5BMyIL/lcUtDrRpjj9I20OSDC7oXJZHyCX3HdvTkT0baHGt0VPn/4ISjjmL6HTeIFfxMKJJab/JYDz4N7uM61f+qr00ITXSzUXC0JHkTPhZpQ0kEVSQsushCQ9cnquErmzDPyiFKMux9WZllbYjRkV0WPzGXkH7HE7jNjVFipj0Vnk47klZtrDSBJfNG64dl1Xx6zyEyrEAP/Y07qr+GfNfVeHO0pPQog5tmJESGjBin+FXhQ4lNTX7B0Ie59Oo0RSzk3Fl+81t9t3k4GQ2EbKPnpNbknMzJmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W061yiWgzL7iHCoYLqnch9dz6x2zJBJx0psqiZbY/3A=;
 b=YRgvLi+VDaFjHogaoS3SlxsoEUVrgD7K4GetDm/cmmG/jcD/O8Ka3La5BjR7jhHr2f1KdaxuJFWSDjLL/ToT75o0L9ETsJ/JaYbuF3AoyjzxBV6CDKS74Z/W4+fMq0hrsiB9ncAV/COdEyIjZMcPtVCUTm4WdXIV8I0GqI5NyZuEJbOM6Oc8Hc/oun3TrwpjgG3NwgQdgheaNKMf/hcxdE4j5/BDmnj7erGZErAAzC7KjPQEkipNlO29ckfxgkkbqfrLfFUpc4FSZOy1lJHmMGtg2RiJP6vw2CqQKZtoEDIn9QYZRKQrzOb2MWaqHv7uvgghSUFoTkPijFN/J+dxfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from CH2PR18MB3349.namprd18.prod.outlook.com (52.132.245.83) by
 CH2PR18MB3416.namprd18.prod.outlook.com (52.132.245.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.23; Wed, 2 Oct 2019 14:35:46 +0000
Received: from CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::1075:2453:9278:e985]) by CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::1075:2453:9278:e985%5]) with mapi id 15.20.2305.017; Wed, 2 Oct 2019
 14:35:46 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>
CC:     Martin Wilck <Martin.Wilck@suse.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH] fixup "qla2xxx: Optimize NPIV tear down process"
Thread-Topic: [PATCH] fixup "qla2xxx: Optimize NPIV tear down process"
Thread-Index: AQHVeS6tkAAP84/JtkK4/uhS49SL/w==
Date:   Wed, 2 Oct 2019 14:35:46 +0000
Message-ID: <20191002143426.20123-1-martin.wilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR0202CA0036.eurprd02.prod.outlook.com
 (2603:10a6:208:1::49) To CH2PR18MB3349.namprd18.prod.outlook.com
 (2603:10b6:610:28::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.23.0
x-originating-ip: [2.203.223.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18c23988-658a-4af0-ed83-08d74745cfef
x-ms-traffictypediagnostic: CH2PR18MB3416:|CH2PR18MB3416:
x-ms-exchange-purlcount: 1
x-ld-processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR18MB341692E27FE6C3260AC739AFFC9C0@CH2PR18MB3416.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(396003)(366004)(136003)(39860400002)(346002)(189003)(199004)(71200400001)(5660300002)(99286004)(256004)(14444005)(52116002)(25786009)(71190400001)(44832011)(4326008)(8936002)(6486002)(8676002)(50226002)(81166006)(81156014)(6306002)(6512007)(66556008)(64756008)(66476007)(66946007)(3846002)(6116002)(66446008)(36756003)(6436002)(110136005)(54906003)(86362001)(2906002)(102836004)(966005)(305945005)(316002)(476003)(2616005)(66066001)(386003)(6506007)(7736002)(14454004)(478600001)(26005)(486006)(1076003)(186003)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR18MB3416;H:CH2PR18MB3349.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OZHoQdfolVrRBmwE1tZOIkrA43iClrYN/MbyYkcDSTzXNOSYl+748yBaWbZj8ku8OE3rs0miSR9RlebekGCb6M235VGMXPPeeaGYghBbecTwIHQdcCTvMsfvbBzId3aqrjUxbf36YTN3/QlXdva304blIO8dZyWGKypt6jRWq4vQvTDd8mtHz3+civ7wlIrXySPM0LNAVME3ZuTXH/9Wnjn7VyLED+9OTE1sJFDe9HVZIaMul/8R8RQGzL9pWX9x+u1Oc2lB7jGwbmvmZ9CzwWK/8lqepBACP2/icqENgeMQrLsquKuVFRQKC/YVPcR8CQmApgIDBNMmVI7JkqLv6TZ2mWtpPpzTR95v74vOyNRQKUUQFjKPPnjXe5ebiktqpXb5Td7E7loeYYOrWl6itbb1Ywg0dM2BNYt0dvfmI4iE3AyVHkSxDMJvXr/0clB7ech5Tu4A4xmIDe2wkyA5iw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 18c23988-658a-4af0-ed83-08d74745cfef
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2019 14:35:46.6425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M1zoAaCeYclj6pH7sOfoKVqLQVF4Uf3qyokCHULQHADrH3EkZMHGK04F/yghLy0OyF5Lnyimt8VlmWUMNgr8fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3416
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

Hello Martin,

this patch fixes two issues in patch 02/14 in Himanshu's latest
qla2xxx series ("qla2xxx: Bug fixes for the driver") from
Sept. 12th, which you applied onto 5.4/scsi-fixes already.
See https://marc.info/?l=linux-scsi&m=156951704106671&w=2

I'm assuming that Himanshu and Quinn are working on another
series of fixes, in which case that should take precedence
over this patch. I just wanted to provide this so that the
already known problems are fixed in your tree.

Commit message follows:

Fix two issues with the previously submitted patch
"qla2xxx: Optimize NPIV tear down process": a missing negation
in a wait_event_timeout() condition, and a missing loop end
condition.
---
 drivers/scsi/qla2xxx/qla_mid.c | 2 +-
 drivers/scsi/qla2xxx/qla_os.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 6afad68e5ba2..b4e042c1bd2a 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -78,7 +78,7 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 	 */
 	for (i = 0; i < 10 && atomic_read(&vha->vref_count); i++)
 		wait_event_timeout(vha->vref_waitq,
-		    atomic_read(&vha->vref_count), HZ);
+		    !atomic_read(&vha->vref_count), HZ);
 
 	spin_lock_irqsave(&ha->vport_slock, flags);
 	if (atomic_read(&vha->vref_count)) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6e627e521562..ee8167517621 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1119,7 +1119,7 @@ qla2x00_wait_for_sess_deletion(scsi_qla_host_t *vha)
 
 	qla2x00_mark_all_devices_lost(vha, 0);
 
-	for (i = 0; i < 10; i++)
+	for (i = 0; !test_fcport_count(vha) && i < 10; i++)
 		wait_event_timeout(vha->fcport_waitQ, test_fcport_count(vha),
 		    HZ);
 
-- 
2.12.3

