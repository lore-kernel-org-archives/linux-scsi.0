Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA1EC5DF61
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 14:58:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0159C21A4A
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 14:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389739AbfKEO6o convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 09:58:44 -0500
Received: from m9a0003g.houston.softwaregrp.com ([15.124.64.68]:33761 "EHLO
        m9a0003g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388842AbfKEO6o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 09:58:44 -0500
Received: FROM m9a0003g.houston.softwaregrp.com (15.121.0.190) BY m9a0003g.houston.softwaregrp.com WITH ESMTP;
 Tue,  5 Nov 2019 14:58:04 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Tue, 5 Nov 2019 14:56:02 +0000
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (15.124.8.14) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Tue, 5 Nov 2019 14:56:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RG9oJWqY+WxoidmAWUalfn5htIZOQmQpyDxEZMeL3OUjAshN5spCmpVaDUHhH6dv3nMAhIP2xbZ/8VW1EYTUVoo6doQb/xF7Ao/W8h9FUlbIWsoomFVlPz4dRfwCQX8kjeFqeYuY3bBzuqPmcd5VQ8cd3mJ0BCMaxhxzGc5pwXoRCg47heT+uekmiAO33xxwdueiVqgBvq0T3d9INgxMehUG7L2BJ0iOKqleJqTa+PAfuTGtRUhUrm741uvYyam4tkz5d1DSCt9sAf0UQAhcmrCjieecTyVoh+cTlcd1CpKMhH8QRVWQBgA17DC12oVqUxw4+PYqK3Uh+2TVnZXOtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f3YTcZf/ho+LU+EuLRriuZdqNHR4KcYr5FlRu/Q+bis=;
 b=X+iuO7OH7iHURJDyUpAo+3C8WSLdvy3RTehpsxIJIgts/c15QNsl/CTZ7zbxvG7efQftgWoPxEfszkLrkPq3L/BG7bjVwSsbzsjV7oj5oVzjiUyt7g3T381Lw7ABLr+/zc1mrY/MAdqu4ICyTy9lUq/ZBEx9VetcMRjSVox1nTTC7qrlfJdwJtVupU/NomQhCJN3xDLmPeVNcESM+pwwUT1KDucK2puXGbAqAZ6S///bklqqUMpgMOXQI7WYzAHaeYKCJf8wfSEM/uCJ5Hv5p6b7mO5HmUvKAjW3ZNz91gXfzpcvps7SizcIWU7az+5DcF9UPVVJGkSQkyUMCKKBtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from CH2PR18MB3349.namprd18.prod.outlook.com (52.132.245.83) by
 CH2PR18MB3175.namprd18.prod.outlook.com (10.255.155.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 14:56:01 +0000
Received: from CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::9917:1509:5d1:6f89]) by CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::9917:1509:5d1:6f89%6]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 14:56:01 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>
CC:     Quinn Tran <qutran@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Martin Wilck <Martin.Wilck@suse.com>,
        "Daniel Wagner" <dwagner@suse.de>,
        James Bottomley <jejb@linux.vnet.ibm.com>
Subject: [PATCH RESEND v2] fixup "qla2xxx: Optimize NPIV tear down process"
Thread-Topic: [PATCH RESEND v2] fixup "qla2xxx: Optimize NPIV tear down
 process"
Thread-Index: AQHVk+kjrebV27kmXUOXVa1+ECU7zA==
Date:   Tue, 5 Nov 2019 14:56:00 +0000
Message-ID: <20191105145550.10268-1-martin.wilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR0701CA0021.eurprd07.prod.outlook.com
 (2603:10a6:200:42::31) To CH2PR18MB3349.namprd18.prod.outlook.com
 (2603:10b6:610:28::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.23.0
x-originating-ip: [2.206.153.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92ff47ed-8082-4eee-8a6b-08d7620045aa
x-ms-traffictypediagnostic: CH2PR18MB3175:|CH2PR18MB3175:
x-ms-exchange-purlcount: 1
x-ld-processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtFwd,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR18MB3175688744C7801B88F8B30AFC7E0@CH2PR18MB3175.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(189003)(199004)(6506007)(3846002)(1076003)(86362001)(25786009)(966005)(186003)(7736002)(6512007)(256004)(64756008)(44832011)(486006)(305945005)(66446008)(66556008)(66476007)(50226002)(99286004)(8936002)(476003)(66946007)(5660300002)(4326008)(14444005)(6116002)(8676002)(2616005)(36756003)(386003)(478600001)(52116002)(66066001)(2906002)(81156014)(6306002)(81166006)(26005)(6486002)(110136005)(54906003)(14454004)(71190400001)(71200400001)(102836004)(316002)(6436002)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR18MB3175;H:CH2PR18MB3349.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: byjj/QJCcRIVDOrkKoDYyBdonzrQM09ahNFZ7fvDMdTcrM0Yv0x3odU2CZ/L6l7Qq9J7lauZCTBwBEKOWk0nAmBrqX4aIrIMJ9Kfy5JX5Ubbz0wVKULI7xZWFwlHJLnRYkInmCWhtB6W+44ybfBqdStbp6eW4QR+K+o4WXiwhCZUk7BgDgjxaawWCEE8co0/TGjrBZGVfCmVtibRyGCIpa+o0B5lOab9/S2se/AcdX20NurzzCzv+Xfgy7+p68YP+3wmzar/V2vj+YWnkHwNlN1sQVWQUsEGwqVIQqhLp2zSIMuqI/4EMfcCxUbRMCe5BcmZUIdABMtW5WY2NckARoqEMvQIso9NEwnp6wXv5dF/lobzm2TDS77bxxYsq5k9S2JsYRlHXCooTJ5+nl4dY5qJ3F7gQjE1k1CAUEhKd4qC6+hWE45VPH/gm05RDxrTAfT32GSJso8OKKZZleKxc/XBYZUVgu/KW08zYSZuV4M=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 92ff47ed-8082-4eee-8a6b-08d7620045aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 14:56:00.9927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /nAJSYOJMpauGUXiRO0GB3dGx5TLti8rx8ppVWVAejPtUT+KLMOR7sa+1Wc0pzI2ZK1AU5up9CC3G7cBKkuxiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3175
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

