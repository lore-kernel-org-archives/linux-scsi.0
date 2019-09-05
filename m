Return-Path: <SRS0=/77Q=XA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52CBEC43331
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 18:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B7E8206BA
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 18:19:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="cTFYuPMh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389317AbfIESTf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 14:19:35 -0400
Received: from mail-eopbgr730080.outbound.protection.outlook.com ([40.107.73.80]:14541
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388864AbfIESTe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Sep 2019 14:19:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ixon2Oi2kCIeSgJnhY+E9SMWL661H4vWWWT4xsmUnhoBublDDWxHQK+H51IIOu1IZ77EKrA0TGQGF8XJUHlxWmm1DjWXFJxoeL6QL4T676Q+Tcle8kP6ZSQH+M2d0vjvx5/5i7ZrKPPfHVKP6tywnN/aa2LPH8sbRv7XAilxOKoa2oUzWNLCSaBzMLLSHgCL+6CiyVmU0lFPE3ysI5rGAU1DBa4XumeV2U8GMcFDXG0jSmIct/+nsSITQCSyCQW7yBV9h5wAir/L9N746zhIGszEuvWqe7vbDisu/L0CyzQ6I1sZShUklzbqQ3c/cX0WAZH+ls8tIH1bjEOxhKLWow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6FGHFWFwG/whq08uAwbvkCRHDkovXpoCkdsZh1yRnBQ=;
 b=lSRtOJML4CKvwxYZynornN2iOxKH79N4bY/oqhhrIef1tZSuOnxLL6MD6l7cGv7O4zkHWBn8zjxOs2u4pgodNzoyo4dh9grVwuyYIkiI8AA8cVQw/kfq6s8s0vWfGJmoR69bhxh2ZPqsWt59vWCvsQapMh1DmsCtMBHhpR+7NxMbbeLC3SHZZq/wPm54ohe/t7kk73uuha4Asf6Qgey3qU+SSnMX7uDM8D/JZ3VjdZZk7/0DMbyXTS7HnHATZKqis11X1K6NlhJtOlEeo32klV5Tw4c8sRZCUenXyZJQjQU009e769r1hf479+Jh7qgevqBZIrouyuPFxi0Wm1Cu0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6FGHFWFwG/whq08uAwbvkCRHDkovXpoCkdsZh1yRnBQ=;
 b=cTFYuPMh51HhkwPXkVFA2aj0sSjykNTvPqLDRfimDIQYn8EjXo05XjpbvsmIXUxA4bnpq6RlvcO5wQUY1+b8WFmu/13xP9I0bicoUKsQPaYyUQRKdYzE0Xda1qVF8MGeZoBKVQ09oVUtDkGtfPVuhDXetN/1wCmnAdk4bsP8W4E=
Received: from BY5PR19MB3176.namprd19.prod.outlook.com (10.255.160.21) by
 BY5PR19MB3858.namprd19.prod.outlook.com (10.186.133.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.13; Thu, 5 Sep 2019 18:19:29 +0000
Received: from BY5PR19MB3176.namprd19.prod.outlook.com
 ([fe80::844f:102f:5181:c074]) by BY5PR19MB3176.namprd19.prod.outlook.com
 ([fe80::844f:102f:5181:c074%3]) with mapi id 15.20.2241.014; Thu, 5 Sep 2019
 18:19:29 +0000
From:   Matt Lupfer <mlupfer@ddn.com>
To:     "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Lupfer <mlupfer@ddn.com>
Subject: [PATCH v2] scsi: virtio_scsi: unplug LUNs when events missed
Thread-Topic: [PATCH v2] scsi: virtio_scsi: unplug LUNs when events missed
Thread-Index: AQHVZBZ0SBt+68s4cE6LCFp/gX3vQA==
Date:   Thu, 5 Sep 2019 18:19:28 +0000
Message-ID: <20190905181903.29756-1-mlupfer@ddn.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN6PR13CA0036.namprd13.prod.outlook.com
 (2603:10b6:404:13e::22) To BY5PR19MB3176.namprd19.prod.outlook.com
 (2603:10b6:a03:184::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mlupfer@ddn.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.23.0
x-originating-ip: [107.128.241.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ceb08d0-c8c8-475c-e387-08d7322d9725
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BY5PR19MB3858;
x-ms-traffictypediagnostic: BY5PR19MB3858:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR19MB385867D2E7CFCE9C320C7327AEBB0@BY5PR19MB3858.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39850400004)(366004)(136003)(396003)(346002)(199004)(189003)(26005)(6512007)(186003)(7736002)(53936002)(3846002)(6116002)(316002)(36756003)(54906003)(110136005)(2201001)(478600001)(6486002)(25786009)(5660300002)(256004)(5024004)(2906002)(2501003)(6506007)(386003)(66556008)(66476007)(66446008)(66946007)(4326008)(64756008)(86362001)(1076003)(305945005)(6436002)(14454004)(102836004)(66066001)(71200400001)(486006)(71190400001)(476003)(81166006)(81156014)(8676002)(99286004)(52116002)(8936002)(50226002)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR19MB3858;H:BY5PR19MB3176.namprd19.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: ddn.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: itk4S/Yj9AA8oVjql+PPu1GaFYEOKJYMeeOEBOjaqOeNfTWzRyYDn9OsAZKlZ9KViQW9g7CjQ6hvWT0JKqtnb5PSFs9BSJPYcbPYo5f2S8p2uEAzrS60rbCvUSQTRvAIK64p7367xDr4MIHFIbgsEN9GIja0zvyWrC2eqoTEBHEmeNrbqOtprM5uip18QHNhVyTn1+c3Gz+XCy86qYFFPxT/Rb8Vi1MSa51CdM5JZzGBvfSU6DncyRPgZuDmFvVz1cq6daBxkZAdXFzf9DcdbIBAVMvykKlaSf5F9qUKpZDXXb/DFVcHr9NZdoM6fa9sotLdKuL4wvDDpD8Y94BJ1O/X77WWpxnY5tWVNovIQziPw6H/RqbNXk2mJbaeJct3Zq3BN+jWW7bSAxprHRE5ySwBtSQl5T5q7L4fdF884L0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ceb08d0-c8c8-475c-e387-08d7322d9725
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 18:19:28.9223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ExUThHPH46dwCIMgb01MnNnJP+4IJTwg1VwMjALmAzXKewGga48GFFmzlJDi/LKi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR19MB3858
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The event handler calls scsi_scan_host() when events are missed, which
will hotplug new LUNs.  However, this function won't remove any
unplugged LUNs.  The result is that hotunplug doesn't work properly when
the number of unplugged LUNs exceeds the event queue size (currently 8).

Scan existing LUNs when events are missed to check if they are still
present.  If not, remove them.

Signed-off-by: Matt Lupfer <mlupfer@ddn.com>
---
 drivers/scsi/virtio_scsi.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 297e1076e571..13a82b94b27b 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -30,6 +30,8 @@
 #include <linux/seqlock.h>
 #include <linux/blk-mq-virtio.h>
=20
+#include "sd.h"
+
 #define VIRTIO_SCSI_MEMPOOL_SZ 64
 #define VIRTIO_SCSI_EVENT_LEN 8
 #define VIRTIO_SCSI_VQ_BASE 2
@@ -324,6 +326,36 @@ static void virtscsi_handle_param_change(struct virtio=
_scsi *vscsi,
 	scsi_device_put(sdev);
 }
=20
+static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
+{
+	struct scsi_device *sdev;
+	struct Scsi_Host *shost =3D virtio_scsi_host(vscsi->vdev);
+	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
+	int result, inquiry_len, inq_result_len =3D 256;
+	char *inq_result =3D kmalloc(inq_result_len, GFP_KERNEL);
+
+	shost_for_each_device(sdev, shost) {
+		inquiry_len =3D sdev->inquiry_len ? sdev->inquiry_len : 36;
+
+		memset(scsi_cmd, 0, sizeof(scsi_cmd));
+		scsi_cmd[0] =3D INQUIRY;
+		scsi_cmd[4] =3D (unsigned char) inquiry_len;
+
+		memset(inq_result, 0, inq_result_len);
+
+		result =3D scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
+					  inq_result, inquiry_len, NULL,
+					  SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+
+		if (result =3D=3D 0 && inq_result[0] >> 5) {
+			/* PQ indicates the LUN is not attached */
+			scsi_remove_device(sdev);
+		}
+	}
+
+	kfree(inq_result);
+}
+
 static void virtscsi_handle_event(struct work_struct *work)
 {
 	struct virtio_scsi_event_node *event_node =3D
@@ -335,6 +367,7 @@ static void virtscsi_handle_event(struct work_struct *w=
ork)
 	    cpu_to_virtio32(vscsi->vdev, VIRTIO_SCSI_T_EVENTS_MISSED)) {
 		event->event &=3D ~cpu_to_virtio32(vscsi->vdev,
 						   VIRTIO_SCSI_T_EVENTS_MISSED);
+		virtscsi_rescan_hotunplug(vscsi);
 		scsi_scan_host(virtio_scsi_host(vscsi->vdev));
 	}
=20
--=20
2.23.0

