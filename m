Return-Path: <SRS0=3hcu=W6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B01C3A5A2
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 17:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1D27217D7
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 17:04:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="Fh7/Pj/T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbfICREX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Sep 2019 13:04:23 -0400
Received: from mail-eopbgr820047.outbound.protection.outlook.com ([40.107.82.47]:14198
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728571AbfICREW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Sep 2019 13:04:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEW3U1DrhnPq/q/gBkOWs/xb9KTcblgjxz1Xth7vc0LAA6vZLSCtvOInon/zzStnTfKQ+MYlhqaEVW9hGiZqX9sKE2SLGW9er/xrKYvcQdsUOOC2M+FDEG6SSew6A2khnGCrTrucSd3nmjDuUl07nWG/Q/O3z7uztSSlh1HT4xpBhEv5HtUcnZko6lw6r3TQNn1WK7xPCDG2HbsNPdPIeqZBRK7TG9f6NxzJ6Ou+y6pBBEOdT3/AF6wgqCXEIfPaaUXI4JPOYjrhuC49OwwXMe7Fx1nsL+Hb0B/4/TI6X+4+mJufNSPoP46EwwXYjTQR0CD7j9Ar/ZzrGusC2f1i5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FE1vkhZEcBTm/jJaftv+DejwqE1+7/QXcmbHN3bXq44=;
 b=BxBIxDSyWngWgnAnu4zY5SnlMgQO+dp4wYAr3yyX60f16TzBQ1ZVh0Dp2Yoa00eHhDWzVIpyx0GzxN+rAUikxSgcjCEOgUGh45A2+yyT2I47Jxu84JZdQi6FSTr5BGjSE8dXwxywbA8HvAhhqB76UUPXcvRszhH34HB2nTD1oFrnRuWes0kx1veRQvHG8Qie1enNtdow7TUPOg8xUfT6vu/j0C4kM2YktH785IbmP3oYr9VsCE6g5E+HmhF2GNnBKahsMp7d4m2BaD5QCWUbdTtDZF/SF33vdg4tn+5DMS9eGqcVLi6uX87ySKckPBCKenVcK9RPFLei+v3vM0hHQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FE1vkhZEcBTm/jJaftv+DejwqE1+7/QXcmbHN3bXq44=;
 b=Fh7/Pj/Tz6qTg6pwJFWwPoWjdGD4hjMuoFrrhuzUoGPXiWeVUI8YRCLfoNA+gLGOzhV/fZ2ATzYq486DYIL/HpIgdl2fE+6emFst9fUM+rLyRbDMS+qalTxEFacb6Y/GGpdENom0+juoWNAM6GSbUQk8Cma2Ysj4jJLNDvq0jXk=
Received: from BY5PR19MB3176.namprd19.prod.outlook.com (10.255.160.21) by
 BY5PR19MB3221.namprd19.prod.outlook.com (10.255.160.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.14; Tue, 3 Sep 2019 17:04:20 +0000
Received: from BY5PR19MB3176.namprd19.prod.outlook.com
 ([fe80::844f:102f:5181:c074]) by BY5PR19MB3176.namprd19.prod.outlook.com
 ([fe80::844f:102f:5181:c074%3]) with mapi id 15.20.2220.022; Tue, 3 Sep 2019
 17:04:20 +0000
From:   Matt Lupfer <mlupfer@ddn.com>
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Lupfer <mlupfer@ddn.com>
Subject: [PATCH] scsi: virtio_scsi: unplug LUNs when events missed
Thread-Topic: [PATCH] scsi: virtio_scsi: unplug LUNs when events missed
Thread-Index: AQHVYnmgUCG1mM4ObEKGSGCIQ1xBzg==
Date:   Tue, 3 Sep 2019 17:04:20 +0000
Message-ID: <20190903170408.32286-1-mlupfer@ddn.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN6PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:404:23::12) To BY5PR19MB3176.namprd19.prod.outlook.com
 (2603:10b6:a03:184::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mlupfer@ddn.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.23.0
x-originating-ip: [107.128.241.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc3df57e-7d38-49e1-eba6-08d73090c2ff
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BY5PR19MB3221;
x-ms-traffictypediagnostic: BY5PR19MB3221:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR19MB322198CDECF53BC0BF569074AEB90@BY5PR19MB3221.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(376002)(136003)(366004)(346002)(396003)(189003)(199004)(36756003)(71190400001)(71200400001)(14454004)(25786009)(4326008)(256004)(478600001)(5024004)(66556008)(66476007)(66446008)(64756008)(66946007)(476003)(6486002)(2616005)(86362001)(486006)(8676002)(81156014)(102836004)(81166006)(8936002)(50226002)(386003)(7736002)(6506007)(305945005)(6116002)(3846002)(26005)(5660300002)(2906002)(316002)(186003)(110136005)(54906003)(1076003)(52116002)(99286004)(6512007)(66066001)(6436002)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR19MB3221;H:BY5PR19MB3176.namprd19.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: ddn.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RUmvvb9EMpVdSOP5wT+r+RINhpPJNUTNk4b/DHOnu/M9IaKFyUuNdjjERa6bKk9Dlx7GAd/jpk+NfTC1NMisgz1/mRYDu88+JzI6xKs0bzTtIDN6z75g4F+4KINMOilhmac2lvQTI9JNkrG/AuJlorJQpAWs/VmufEgi+1MF7gm2PL8nKxRItYFYrAII8cjyZ63KzlJy7NrG7i+bnqZZ7jeyAMAjBQLAYopZwt58iONTQ8gzKDzdjEJz5rMgPePiTLnUErMmRrAQPHgZfOvTPblMYn+Ex9PjJ7pdsQliJTjN1cc7MX8Htfa9fXXFEm1Daa5eiQyLzn3roSXB/Ed9sHjYpOnbftguKWZalCSPcCGKgMuh1nG2vJWhClcL7Ex4iZ5sPeUhnsoe5mDBpc78zl0kfnlxDmUggZ3OQ5BzJR8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc3df57e-7d38-49e1-eba6-08d73090c2ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2019 17:04:20.2709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vt/yFrolFeFtItMqa33m8bCgerKq3VBWspQM6MbtqDFP9VNcOVTyV6OM4vFl5w1v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR19MB3221
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
 drivers/scsi/virtio_scsi.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 297e1076e571..18df77bf371b 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -324,6 +324,36 @@ static void virtscsi_handle_param_change(struct virtio=
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
+					  2, 3, NULL);
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
@@ -335,6 +365,7 @@ static void virtscsi_handle_event(struct work_struct *w=
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

