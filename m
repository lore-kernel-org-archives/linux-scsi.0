Return-Path: <SRS0=821a=X3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7994DC352AA
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Oct 2019 15:44:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CEFD21D82
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Oct 2019 15:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfJBPoh convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Oct 2019 11:44:37 -0400
Received: from m4a0040g.houston.softwaregrp.com ([15.124.2.86]:55056 "EHLO
        m4a0040g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725935AbfJBPoh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Oct 2019 11:44:37 -0400
Received: FROM m4a0040g.houston.softwaregrp.com (15.120.17.147) BY m4a0040g.houston.softwaregrp.com WITH ESMTP;
 Wed,  2 Oct 2019 15:43:28 +0000
Received: from M9W0067.microfocus.com (2002:f79:be::f79:be) by
 M4W0335.microfocus.com (2002:f78:1193::f78:1193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 2 Oct 2019 15:42:03 +0000
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (15.124.72.13) by
 M9W0067.microfocus.com (15.121.0.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Wed, 2 Oct 2019 15:42:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SFlynEI0AsVhd3zgX+XV7Z055Z01nqm9n3DD1GoC2ePoEFhJJUiS7kgAGlBKr5zbcGM/706mD+aIFASBbjsC5NwMcFuGFicB78LUMent+dO0QOw7wV3gR37j50mSkD45NEudfqoVBFyrQBzgWOIy+++EBrbGz8jf0vNZj3dKc5wLHWSNVkIL6WeKEznSK43mD9bRwUzheoSZOXm9Hb5DUELA0j2ah3+d7NRP5L8B+mrYWrttqPp2y1e0qGNIBKcDKoP6c7/dFMHqdqYJntnlNmAd9Q4lLNvbJUTrJegO+5hmsw6RdkGZVu4UNf7rbQ//7nBBJN1Ip885cGKDUtf3nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f3YTcZf/ho+LU+EuLRriuZdqNHR4KcYr5FlRu/Q+bis=;
 b=hs7ymZw32f2ztcC3iyPFtsdR8CY7lL0IXbIdyHA39tyxdUdWarA0noQqAm/EpWvC+pS0m56fqjDxuDJzGktyUYuMkyifUTmRnlf6JGmx1uUmN8lm7xRWixmXWFRz9KvSKqdK4ZGjEfWEOyNeLcmvUSall4kkblLUCxmy5QqT9pCsoWdldhJygsZbVwypbUflKtVCzwi6rTWLkW/RiIwK5mivtP21/1g+bkMpgiSmSrvLKcmPARqFG2OQS6mxlGCr3r8VNNp2ClvYg7hkyyvAOZ+M8hELW28bQgslZ3YKYjL2xr47iRIgSycoaXPN8qCeBJq/r5S6Z/d4Zm4Imw6NMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from CH2PR18MB3349.namprd18.prod.outlook.com (52.132.245.83) by
 CH2PR18MB3351.namprd18.prod.outlook.com (52.132.247.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Wed, 2 Oct 2019 15:41:56 +0000
Received: from CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::1075:2453:9278:e985]) by CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::1075:2453:9278:e985%5]) with mapi id 15.20.2305.017; Wed, 2 Oct 2019
 15:41:56 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
CC:     Martin Wilck <Martin.Wilck@suse.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v2] fixup "qla2xxx: Optimize NPIV tear down process"
Thread-Topic: [PATCH v2] fixup "qla2xxx: Optimize NPIV tear down process"
Thread-Index: AQHVeTfrfC+NT3H/1k+pr5kqIwaaNw==
Date:   Wed, 2 Oct 2019 15:41:56 +0000
Message-ID: <20191002154126.30847-1-martin.wilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM3PR07CA0071.eurprd07.prod.outlook.com
 (2603:10a6:207:4::29) To CH2PR18MB3349.namprd18.prod.outlook.com
 (2603:10b6:610:28::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.23.0
x-originating-ip: [2.203.223.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56e909f9-2373-4b6f-f9cc-08d7474f0e2c
x-ms-traffictypediagnostic: CH2PR18MB3351:|CH2PR18MB3351:
x-ms-exchange-purlcount: 1
x-ld-processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR18MB3351915C76D72C4BDD39148BFC9C0@CH2PR18MB3351.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(189003)(199004)(66556008)(66946007)(66446008)(3846002)(102836004)(64756008)(2906002)(316002)(5660300002)(54906003)(7736002)(26005)(186003)(8676002)(25786009)(110136005)(14454004)(2616005)(44832011)(476003)(8936002)(6506007)(1691005)(36756003)(81166006)(81156014)(386003)(6116002)(52116002)(966005)(66476007)(478600001)(50226002)(486006)(4326008)(66066001)(99286004)(86362001)(1076003)(6436002)(6512007)(71200400001)(256004)(71190400001)(305945005)(6306002)(14444005)(6486002)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR18MB3351;H:CH2PR18MB3349.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qmA48l15xrAsd5g3PdWGCcn6b/U6Z86LmPt4TcFwrOMMxBvW8L0KOc09sN9xaUdikSf6oUeq4tBgeZCeUqf2I/XcVAfCFLrcrWdKxKQkjy50GGjrCQHkmGHKMPIhM7dM5v1Hg8J2+1UYVKn1wTexzjpS68hPJPIesBDG27ta3qH+zzOvJKINEaNkS6q8kUWpR5/cxY5xl/wIvDN49VqiS32kc91EODxQ4qgB923Fo962n4m3OYQgIlclB29UgBvhiFwIrqESSFsq7UmQEKX4+SuU/ILQ2JckHO/wvXXef9WSS5Tka6pJYlnQwuJzIOob5k1cQ2CKunBpVNw0Oq3d6JgVwoQqkutoH6i0DRxaXO0M6V5MywO/odfkePNzjasjmQvPG9nPtCHhJfTbncsT7V7r9n8QiV3vobKjNFEJx24K52Yui8jAKGSg4uo02nAJuNoMVyaP7YsMpxF9csNpUw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 56e909f9-2373-4b6f-f9cc-08d7474f0e2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2019 15:41:56.4100
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FaD3ujBU+9E1loMGVBLhvBc2gqMrN+Il6qyg+FwOXuhEvjIJQWRrvw1oHgGRpqGG/XElHOAaRlJzQL+WAxdxWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3351
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

v2: check loop condition only once (Bart van Assche)

Commit message follows:

Fix two issues with the previously submitted patch
"qla2xxx: Optimize NPIV tear down process": a missing negation
in a wait_event_timeout() condition, and a missing loop end
condition.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Fixes: f5187b7d1ac6 ("scsi: qla2xxx: Optimize NPIV tear down process")
---
 drivers/scsi/qla2xxx/qla_mid.c | 8 +++++---
 drivers/scsi/qla2xxx/qla_os.c  | 8 +++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 6afad68e5ba2..238240984bc1 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -76,9 +76,11 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 	 * ensures no active vp_list traversal while the vport is removed
 	 * from the queue)
 	 */
-	for (i = 0; i < 10 && atomic_read(&vha->vref_count); i++)
-		wait_event_timeout(vha->vref_waitq,
-		    atomic_read(&vha->vref_count), HZ);
+	for (i = 0; i < 10; i++) {
+		if (wait_event_timeout(vha->vref_waitq,
+		    !atomic_read(&vha->vref_count), HZ) > 0)
+			break;
+	}
 
 	spin_lock_irqsave(&ha->vport_slock, flags);
 	if (atomic_read(&vha->vref_count)) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6e627e521562..ee5b6cba9872 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1119,9 +1119,11 @@ qla2x00_wait_for_sess_deletion(scsi_qla_host_t *vha)
 
 	qla2x00_mark_all_devices_lost(vha, 0);
 
-	for (i = 0; i < 10; i++)
-		wait_event_timeout(vha->fcport_waitQ, test_fcport_count(vha),
-		    HZ);
+	for (i = 0; i < 10; i++) {
+		if (wait_event_timeout(vha->fcport_waitQ,
+		    test_fcport_count(vha), HZ) > 0)
+			break;
+	}
 
 	flush_workqueue(vha->hw->wq);
 }
-- 
2.12.3

