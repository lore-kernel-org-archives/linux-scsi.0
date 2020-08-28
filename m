Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B86C6C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 12:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 835A520872
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 12:24:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="BQCnXVWx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbgH1MYj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 08:24:39 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:20686 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729123AbgH1MY2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Aug 2020 08:24:28 -0400
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Aug 2020 08:24:26 EDT
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07SCGgwv004968;
        Fri, 28 Aug 2020 05:21:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=proofpoint20171006;
 bh=kd0l9gAP44RHMqQ/nvInM9sbiHcef79FhCx2FIcvLFM=;
 b=BQCnXVWxW5iVRjahjlNlHf+l45VZ5TTWt3uQZSSJh9DiZ/oKcp9gQsVBIE/vihDv3peV
 WtGGQjnT2uOfY0ulhv8WyajkUaBdsTt48Yoxc6exuSoqvANNRsfbXAA7eMSGA0TtsqSA
 M6dGUU0AoSjIVMv8QHE49ychIDh+7zg9wSkOn/xO2GZdmAMAXMJaoC9nC8ptO6xig81+
 EAkBrx4qBcpXgxb6gPJj+yikIDNtGaKEnysbeyfro/VvKwEhf1uziv4L6kjSfB/R/hkI
 tf+NRRALSu/4BJw0GQL8gcl2h/5JGKnibfB4q/jW62/BTBXvT7Ps7l3jHxSqCNcZsSsW pg== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx0a-002c1b01.pphosted.com with ESMTP id 332ypup94f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Aug 2020 05:21:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IlUz9Xn5sB99ZDsB3IiYbbqlOl6+M3wq0VOE42maO/JcxSKphRWrc4CceMtHIyeZOdJausruhpWp9DIl0mYx/bSckgubVZ2MbElElL6wAllzXJSEE7Ubr2DzzDfHQcrAZR5tvo+H7xHusgcNHGadqQMjw07FXo1MaJHQbgP2CvRlnAQNAXDXzlPK0BKjscSLDupqedOJd+yPB28Vj76GeeiOytD/hwdlJNcXFNsyGf/t0BnxMyYs/LbUIj0zqkaGCm6C99SIip2Uh31htgvqW4TpTd6UE+wKEyn7lnwBkmyhii7AZAFOtV9azNBvkHV0XmceWTlqKS6o6c0rUuQ4bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kd0l9gAP44RHMqQ/nvInM9sbiHcef79FhCx2FIcvLFM=;
 b=LJuCli3L5Etd+aWNhtnnDXzMGu4Q/yS1flVYD88XwqrCwFJF0UPrbDQ6bWwT3ZujZ0HSQ/ursxA01LyyBmjE1OyD7XaZ0M79JKvvnJlEcBacHeb9ecgAsuG9L3Kv6Z58yOI5GUKXvTb7G7j9K2HGCkDdOeg1rmTvheBReOrsPRr2pj07JOt6Dw/Qfr7zcI37xPSMINUGPJSSRff1d8KmOGGx5kjdDrmLvuwSg2lGExV5cqAr792iTnF4HVUpVrF80ABkObM7O9ObovfWh+sIFvzbjyLlqnhibvPmexF1qsVfKYLnDPq0stHan7i2JArPADPFAi3noXFYuIv0SkJn3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CY4PR02MB3335.namprd02.prod.outlook.com (2603:10b6:910:7e::32)
 by CY4PR02MB3269.namprd02.prod.outlook.com (2603:10b6:910:7c::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Fri, 28 Aug
 2020 12:21:35 +0000
Received: from CY4PR02MB3335.namprd02.prod.outlook.com
 ([fe80::11e:60f7:3f20:9464]) by CY4PR02MB3335.namprd02.prod.outlook.com
 ([fe80::11e:60f7:3f20:9464%7]) with mapi id 15.20.3305.026; Fri, 28 Aug 2020
 12:21:35 +0000
From:   Matej Genci <matej.genci@nutanix.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Felipe Franciosi <felipe@nutanix.com>,
        Matej Genci <matej.genci@nutanix.com>
Subject: [PATCH] Rescan the entire target on transport reset when LUN is 0
Thread-Topic: [PATCH] Rescan the entire target on transport reset when LUN is
 0
Thread-Index: AdZ9NZ5vwNLMSE8+SVisPIkQE+RzLg==
Date:   Fri, 28 Aug 2020 12:21:35 +0000
Message-ID: <CY4PR02MB33354370E0A81E75DD9DFE74FB520@CY4PR02MB3335.namprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=nutanix.com;
x-originating-ip: [2a02:6b62:d067:0:9415:9641:464e:41b1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53b6499d-649b-40c6-474d-08d84b4ce802
x-ms-traffictypediagnostic: CY4PR02MB3269:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR02MB326955278E3DFD244F486BF3FB520@CY4PR02MB3269.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xQd6IH3QZBt9wJALzppyvp/I7etQXbxHN13fiLyOizfmIPRPoTYbc6PYwMTIBkk5DdFo8XyfBeWJUf4i6eZxljT1uJLgTxmKd5DuckgAcDuTg4yoi/wBOsOrZOS/YswZLpSk4fDAj6NPH12JyOx09mcy0YQ7sfb+vxKD82DawDr4J0G8foyc78QMpEHJqZ+XwhL20Hank6ABKI3jEol1nmBphJq+bXXFUgqaLRfekCeudtBVaovlWOuJ7FJ2nrQb55VQiswk3nDUOcn+GwOSbN9y35yGvqDi2Qh+elAabzqgdE+TFYRgbBAScGLUklUb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR02MB3335.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(107886003)(6506007)(83380400001)(86362001)(186003)(6916009)(5660300002)(52536014)(71200400001)(76116006)(4326008)(66946007)(66556008)(66446008)(44832011)(66476007)(64756008)(8936002)(54906003)(2906002)(7696005)(478600001)(8676002)(55016002)(9686003)(33656002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: GTO3YcqZfRRTcK54BxAVN8n45RS6X4/nNVcoaz516z/EJQAIpfWf/Ma9M7LJNh2OxfSGhntdsjY0py3qh9DSWQQXRJ8BlwvQMum/bqVKc+uPMHmS7pT8iq1qx1ueS1aizKlMC5vbgUKsM+Cx8kN9z5j6fCVrykN1qmA6+UqqEsbL7uNi7UIrQruI8GgyvTZjH4AfWHsML+JzMzY3lFzr/JV34DO2NZ9ehTxtdVp1awCMOdYUK7/QqG0G5xaFxS4WU/AmtKmmPA5VwxzjjczNpyl+dJMErpCuN2UCy6WagiWRLc45/ExndxLi/wtU72OvlslZVMUfdm9+w1xxR+tYuljAOhe9fas9vctxcsAtmDs6TEGjr0zU5JvQ9zpt+tmIx7dz+V+Bix9Ae0ngBXi+Lozh78nlB9FCcPxzbpkPccWkj5C/7ZarbNgQxq8oNoOn2edlg59TThXGZko55ze+qMsqX+x6w0ZEQOH0A4mvrFW7hNcQ44iIV7tkSmIs6WYP7kjqb5rg79DRxyWiHkxzzS7t5qcaOAEYL82HrwC+ON3ZPSPzJ+xQTsPetcTd58CNS/FXQeVCGODlk1zCDzYR4nGtBgF1Vz/ksiiJ5XUIVMiRlv0g0xJ5/717SgJe7Z+a/jkWgJODpG9Tc68YOw86gA/5SGn8Su5bNk0/FvY7/oN7fczP2pEuZWgyIVdrEr5HaL+iGDWVR8A/Ggop/AvsHg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR02MB3335.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53b6499d-649b-40c6-474d-08d84b4ce802
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2020 12:21:35.3697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3+cQwhXBHoH44LXCmTRYzicy8gNGwLRcSzk7f9wTHGhf3Xu8WCoXZpmnTroytdpJAj4eT1t9JUSl8OlQ0WP4XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR02MB3269
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-28_07:2020-08-28,2020-08-28 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VirtIO 1.0 spec says
    The removed and rescan events ... when sent for LUN 0, they MAY
    apply to the entire target so the driver can ask the initiator
    to rescan the target to detect this.

This change introduces the behaviour described above by scanning the
entire scsi target when LUN is set to 0. This is both a functional and a
performance fix. It aligns the driver with the spec and allows control
planes to hotplug targets with large numbers of LUNs without having to
request a RESCAN for each one of them.

Signed-off-by: Matej Genci <matej@nutanix.com>
Suggested-by: Felipe Franciosi <felipe@nutanix.com>
---
 drivers/scsi/virtio_scsi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index bfec84aacd90..a4b9bc7b4b4a 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -284,7 +284,12 @@ static void virtscsi_handle_transport_reset(struct vir=
tio_scsi *vscsi,
=20
 	switch (virtio32_to_cpu(vscsi->vdev, event->reason)) {
 	case VIRTIO_SCSI_EVT_RESET_RESCAN:
-		scsi_add_device(shost, 0, target, lun);
+		if (lun =3D=3D 0) {
+			scsi_scan_target(&shost->shost_gendev, 0, target,
+					 SCAN_WILD_CARD, SCSI_SCAN_INITIAL);
+		} else {
+			scsi_add_device(shost, 0, target, lun);
+		}
 		break;
 	case VIRTIO_SCSI_EVT_RESET_REMOVED:
 		sdev =3D scsi_device_lookup(shost, 0, target, lun);
--=20
2.20.1

