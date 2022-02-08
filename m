Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF7DFC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 15:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379910AbiBHPTy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 10:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379804AbiBHPTu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 10:19:50 -0500
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 07:19:46 PST
Received: from smtp.digdes.com (smtp.digdes.com [85.114.5.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887D9C0612BA
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 07:19:46 -0800 (PST)
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by relay.digdes.com
 (172.16.96.24) with Microsoft SMTP Server (TLS) id 14.3.498.0; Tue, 8 Feb
 2022 18:18:41 +0300
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by
 DDSM-MAIL01.digdes.com (172.16.100.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.12; Tue, 8 Feb 2022 18:18:41 +0300
Received: from DDSM-EXED02.digdes.com (172.16.96.56) by DDSM-MAIL01.digdes.com
 (172.16.100.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2375.12 via Frontend
 Transport; Tue, 8 Feb 2022 18:18:41 +0300
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (104.47.10.57) by
 relay2.digdes.com (172.16.96.56) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Tue, 8 Feb 2022 18:18:40 +0300
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=knHjtX+l1TnDlwSsBeLaZpJpd7LYP63vICHvgjJWSb7f60/Dvd0pdk6Kjw09raL6ffPJehk7ogSQQVgr04pgkKFYzVrxFicAOfPdowYYUadp1kek2LtPE0gSX2TITQ79UzObsI0YJNPUXRCvhMjlDKKbe/JrKTyHS0lZYO/kd8gsEc1Zvr0/Lct+QdqNlAZcsI52JH2d0sSBjOeGN0DntZ+WIBTD/IwuHlW9nfYfddovbvTj51C+mPtQyVyiFrJxwOKZfT/7VdE3Dak1tqhuHP21GA7CID3uMJBpyZNj3ta47o1WLrZOIo5zoMpBVsclzjanB7fHVUtoy/bnFBjvEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bl+ArISK1xfBTOkNEHOzMDUs9/p7x3D/l779KIA2NoE=;
 b=S8d66UdgY92jR/3R5ULnp6n/G616NYSu0Nf7St/gnax40QVGDgOLNBH2wJMX2sTqBWVOA1NQXybsZQITbOcn4ZSOg9AKlp/kBwlKGbroxm+NnvowGUjRurJZxsWr+lWBn5xmvduuk018NkcoldJjVikr3cacuXrAEzY51V+VC407Wh/GRLB7ascIYiLFtQr3SxBvssFzjbkH+ysjO1h0P15m4P86TNCDV5/TQeNXw2qv9lqqlWHnCkfeCbizjvtnleDim9545A9uWjcac8hiiVz4DcvROwL6XBgMK9io6FHTyUWMOxOoHl9BKqe8/lfbCXp/plMwfCNSP+lXo5ir2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=digdes.onmicrosoft.com; s=selector2-digdes-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bl+ArISK1xfBTOkNEHOzMDUs9/p7x3D/l779KIA2NoE=;
 b=oegviUqKaRz/kRsNZX4gyqfNN7hw9iRjpTrR0ElHy2aASoEQXHNiSrepJOuBskR/J/k+TUpYNrIU/uPBAK9FPrGtrREOye3WcVH8HpsbGKPt1gYnNjkhGDU1ffIF3oobmIWwyNq86vOzVKwyVTGthaDRAlr/lsa78h2Nphf35cU=
Received: from AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:403::6)
 by HE1PR1001MB1211.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:3:75::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17; Tue, 8 Feb
 2022 15:18:38 +0000
Received: from AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::4878:86c5:8899:f1c5]) by AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::4878:86c5:8899:f1c5%7]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 15:18:38 +0000
From:   Chesnokov Gleb <Chesnokov.G@raidix.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/1] qla2xxx: Remove unused qla_sess_op_cmd_list from
 scsi_qla_host_t
Thread-Topic: [PATCH 1/1] qla2xxx: Remove unused qla_sess_op_cmd_list from
 scsi_qla_host_t
Thread-Index: AQHYHP6uTkVvKKm8B0+U8wwXn2ISBA==
Date:   Tue, 8 Feb 2022 15:18:38 +0000
Message-ID: <AS8PR10MB49524AAB4C8016E4AFF17FFB9D2D9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 9c0ffd88-db9a-a874-7b69-c9ce9e8b2bff
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=raidix.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 275be1bb-6007-4d98-2f00-08d9eb164827
x-ms-traffictypediagnostic: HE1PR1001MB1211:EE_
x-microsoft-antispam-prvs: <HE1PR1001MB1211C798638B3ACB5CED2F119D2D9@HE1PR1001MB1211.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:328;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gSeKvb7hyDtUbOGYgoDF+wvLohHitJHhlSD3qNPXjcJ99a6idVP+Sq3N9uqqVuODgwcVvhPCwjui0q4ovbucWJAnoHeVE3yzoVjtUspF4FhB/akwRuDFucl4BBX9aWwy6pasxRrAnw9iydS6veRkI+7Gqq6TAx534SElHls3Xe/SGWyQ1d7vfcZxe3KTCJKzdfqsuwEMNguiaJMSXpAmf1xLtEwmw4h2hfeoovjlqFWI4QSJe4X49gUwtc0FP0Xr0hgNElda6uqGYzG+3zkuIyzBrCkiVAFnbH9oZs/TqCxzA8Q26N7Ku1DAdRMnmpccHuceuklLOVZ1C7bp88OzKweYsOvHtQZKY9AEh7ZWsXsn9082q6qyvD/EqOtJKH1n8qbcNC+9HrApSYURaFMcST71SRXT49MKOs6c8tZUXY82TyULriApISHzwxoucZHMVgKfx/Jrglk5rNB6sGZYWJHzhZmIDhkW53hf31VgHu+M9SYjXrpfCR42ls4NhFzR4h2jVulMyOrTcR7UxZo/MUtIhxm79+w12ar9nG3IHU4ESaFnQc4Sdu+GyKzH2NnRrWZZv8KEsFsnylwDS9FwSXW4DUAC/vlM/PaekSbDl8QDv58Aj8FPxC4h7HQYE4QmbuSZloELMmWTo07+mTk8RMp+JmGQb4gga/NvPKSYCHQQkMd7kcE9ZIuWXspbKp7dWJWtyhaRoCWjdeZ3wzahNg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(38100700002)(86362001)(6506007)(122000001)(38070700005)(71200400001)(6916009)(55016003)(2906002)(7696005)(9686003)(186003)(66446008)(66476007)(76116006)(66946007)(66556008)(8936002)(8676002)(64756008)(91956017)(52536014)(26005)(5660300002)(508600001)(83380400001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?+gcUaLkIdQX+aVFACJcelXVN8H5Exdzox/cdErW8TTAmhHjjuLIfgpglb7?=
 =?iso-8859-1?Q?WBTpo/rW6ZrCGL18JJqr9KBkKkcm56087pD8QqJZMp/LjmGohUQMSfnayA?=
 =?iso-8859-1?Q?40G17d6IsuHXv+OMDeDHf8iDAK5HqJGgknjfFfMPqKh9QoeYyIsIqPdtS1?=
 =?iso-8859-1?Q?LUmh44kE2cc9NnsS2k4CIepKEQd71PhQd/uqTbu0Xq1mYwlQf4xkjAm1/O?=
 =?iso-8859-1?Q?tDZKSuL7+9x/H6g/pJkuiNo5a12pUSgVfv1cWaBlJQcW3aWgaQApFda+N2?=
 =?iso-8859-1?Q?wPohNvdMD+NHtJuZFreiQTf55ILjK9afjsGDEKgEYLhJdV58DFMkXBRl5P?=
 =?iso-8859-1?Q?E46bPOzTsCNFa0IJHUqCjpawf2ChtivN9GCrJQPMAuLGXj8/T+9y96iqiq?=
 =?iso-8859-1?Q?E8/NgZhCIw+f/RGToazIhhbzLI2DQ4dsVbrcBx9LITDEHZoAXmskRBzIcO?=
 =?iso-8859-1?Q?x9CFYOIwvZr6ioAW9EaNeuTEeftUa3sQgo6xOevK9AmDztqnl8R6F6H/H4?=
 =?iso-8859-1?Q?zJubZri8I7IsaZxblijx0yv5t1ouNbrPtYSjZfvH5I2+NYnZRDp5J8QuAE?=
 =?iso-8859-1?Q?UZb0GYB49/wYyEej8YnwcUTM2qknCyHJfUfGp+i4WYso68wCuD8o8O149r?=
 =?iso-8859-1?Q?0yoKbTclhSP/LwpQoEvLvw2zzLncod6xHDV16iAnCnIS+qnxwlOZv9W5E5?=
 =?iso-8859-1?Q?MQS6M9aYoYd/IiffjtR2E3T17a6LFE20Pq3TmkbkzjGW+bZu7sfhoJYCeE?=
 =?iso-8859-1?Q?XiJD1tNkcXzCi4uchtnDTWumqxKzDtUATzgB+kVhHs66WB7Hoxg29L1FDa?=
 =?iso-8859-1?Q?g7HpwILllEBfrabfE51uY75By+1wBjMGa2SOT+sCWxjw3ycgbGuABwYurH?=
 =?iso-8859-1?Q?sikBpMGV8MnbOYaC/mC04o2qbZN0p/cXlnefTdfnPGMrNmS0GcqNq3T7PO?=
 =?iso-8859-1?Q?RTIepWMMke8ErrytD/jAcb6AW4lSdR/HM1z+M9eqxc6AnhDk3YJRRihv95?=
 =?iso-8859-1?Q?jr2XEzXQCgzmqAc+h3bgFGfgoxAPmb3faaG/ovDZaidGbxq7rs9zhc8sNg?=
 =?iso-8859-1?Q?nNwDqoN4tRmKK5HRcO3OQdCX8cOsS+7Xr9UlIZdBLRby9e3NrgfuIpVMJ9?=
 =?iso-8859-1?Q?fzJdpeo29cWUYUjJPOUYH8EzWxkPYZCfvFGm4pb5RK1wB7Tp1LplgSr2Qs?=
 =?iso-8859-1?Q?AEiY79ki85Ca/+QSFDeq9m112lzI51l+LiJcKMcNeN7tPKXU/Dm4Rtoxfh?=
 =?iso-8859-1?Q?ZeqDpkn0ERJwkDnn65ZO+98+litVaXnQK5LOOI3Q8ns3QhBTLXlKLKPGGA?=
 =?iso-8859-1?Q?I06TsV/gnppB3L4GuO5dwFNbwKjqXxxzF1ZFZ0IW897O3Oyo709mE5mMR8?=
 =?iso-8859-1?Q?s25fEPS/6lvbHnUJjy8zfMWXaGCQaBV/OCK9At6Qyv4PvW32uNVIoBeTgo?=
 =?iso-8859-1?Q?jZBlRu80Arfwga42K8pgvUN1wJAd2PJKRmBC+Er2jbVMr2V1IfJUdQeSez?=
 =?iso-8859-1?Q?RrKzFK6U6QOE87fLfDMBhoZN6HptiW9X2VxUjashqVmhzpqPkE2ni0HLsn?=
 =?iso-8859-1?Q?aHP+Lch1RTQaiJxuFqTzuhbynjfO80UE13e6GKkxt8HMvgfNkKwRmGCWEp?=
 =?iso-8859-1?Q?C0WDLy6zjwfVT3jciZ6yKMr4aM4m4fx9oyrOp/UPDEaYpxhxWLxDZTLA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 275be1bb-6007-4d98-2f00-08d9eb164827
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 15:18:38.1346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70c55e28-9cd7-4753-937e-c751128a9d38
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y40KChMRNwEV60GCu8Dnmguvd1fqceRze+oaIDtNYoE7vJrmudWVyKoITuy0QOBLg/nnLT3CHPh0v8IejUbwbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR1001MB1211
X-OriginatorOrg: raidix.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The qla_sess_op_cmd_list was introduced in 8b2f5ff3d05c=0A=
("qla2xxx: cleanup cmd in qla workqueue before processing TMR").=0A=
=0A=
Then the usage of this list was dropped in fb35265b12bb=0A=
("scsi: qla2xxx: Remove session creation redundant code").=0A=
=0A=
Thus, remove this list since it is no longer used.=0A=
=0A=
Signed-off-by: Gleb Chesnokov <Chesnokov.G@raidix.com>=0A=
---=0A=
 drivers/scsi/qla2xxx/qla_def.h    |  1 -=0A=
 drivers/scsi/qla2xxx/qla_os.c     |  1 -=0A=
 drivers/scsi/qla2xxx/qla_target.c | 20 --------------------=0A=
 3 files changed, 22 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.=
h=0A=
index 9ebf4a234d9a..7d8ebabb7b40 100644=0A=
--- a/drivers/scsi/qla2xxx/qla_def.h=0A=
+++ b/drivers/scsi/qla2xxx/qla_def.h=0A=
@@ -4906,7 +4906,6 @@ typedef struct scsi_qla_host {=0A=
 =0A=
 	/* list of commands waiting on workqueue */=0A=
 	struct list_head	qla_cmd_list;=0A=
-	struct list_head	qla_sess_op_cmd_list;=0A=
 	struct list_head	unknown_atio_list;=0A=
 	spinlock_t		cmd_list_lock;=0A=
 	struct delayed_work	unknown_atio_work;=0A=
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c=
=0A=
index abcd30917263..579379a3c554 100644=0A=
--- a/drivers/scsi/qla2xxx/qla_os.c=0A=
+++ b/drivers/scsi/qla2xxx/qla_os.c=0A=
@@ -4949,7 +4949,6 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi=
_host_template *sht,=0A=
 	INIT_LIST_HEAD(&vha->work_list);=0A=
 	INIT_LIST_HEAD(&vha->list);=0A=
 	INIT_LIST_HEAD(&vha->qla_cmd_list);=0A=
-	INIT_LIST_HEAD(&vha->qla_sess_op_cmd_list);=0A=
 	INIT_LIST_HEAD(&vha->logo_list);=0A=
 	INIT_LIST_HEAD(&vha->plogi_ack_list);=0A=
 	INIT_LIST_HEAD(&vha->qp_list);=0A=
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_t=
arget.c=0A=
index 8993d438e0b7..d5dad6e6d4cc 100644=0A=
--- a/drivers/scsi/qla2xxx/qla_target.c=0A=
+++ b/drivers/scsi/qla2xxx/qla_target.c=0A=
@@ -2026,17 +2026,6 @@ static void abort_cmds_for_lun(struct scsi_qla_host =
*vha, u64 lun, be_id_t s_id)=0A=
 =0A=
 	key =3D sid_to_key(s_id);=0A=
 	spin_lock_irqsave(&vha->cmd_list_lock, flags);=0A=
-	list_for_each_entry(op, &vha->qla_sess_op_cmd_list, cmd_list) {=0A=
-		uint32_t op_key;=0A=
-		u64 op_lun;=0A=
-=0A=
-		op_key =3D sid_to_key(op->atio.u.isp24.fcp_hdr.s_id);=0A=
-		op_lun =3D scsilun_to_int(=0A=
-			(struct scsi_lun *)&op->atio.u.isp24.fcp_cmnd.lun);=0A=
-		if (op_key =3D=3D key && op_lun =3D=3D lun)=0A=
-			op->aborted =3D true;=0A=
-	}=0A=
-=0A=
 	list_for_each_entry(op, &vha->unknown_atio_list, cmd_list) {=0A=
 		uint32_t op_key;=0A=
 		u64 op_lun;=0A=
@@ -4727,15 +4716,6 @@ static int abort_cmds_for_s_id(struct scsi_qla_host =
*vha, port_id_t *s_id)=0A=
 	       ((u32)s_id->b.al_pa));=0A=
 =0A=
 	spin_lock_irqsave(&vha->cmd_list_lock, flags);=0A=
-	list_for_each_entry(op, &vha->qla_sess_op_cmd_list, cmd_list) {=0A=
-		uint32_t op_key =3D sid_to_key(op->atio.u.isp24.fcp_hdr.s_id);=0A=
-=0A=
-		if (op_key =3D=3D key) {=0A=
-			op->aborted =3D true;=0A=
-			count++;=0A=
-		}=0A=
-	}=0A=
-=0A=
 	list_for_each_entry(op, &vha->unknown_atio_list, cmd_list) {=0A=
 		uint32_t op_key =3D sid_to_key(op->atio.u.isp24.fcp_hdr.s_id);=0A=
 =0A=
-- =0A=
2.35.1=0A=
