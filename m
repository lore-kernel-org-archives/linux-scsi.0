Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12298C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 17:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbiBOROS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Feb 2022 12:14:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236215AbiBORON (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2022 12:14:13 -0500
Received: from smtp.digdes.com (smtp.digdes.com [85.114.5.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C1E11AA20
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2022 09:14:02 -0800 (PST)
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by relay2.digdes.com
 (172.16.96.56) with Microsoft SMTP Server (TLS) id 14.3.498.0; Tue, 15 Feb
 2022 20:14:01 +0300
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by
 DDSM-MAIL01.digdes.com (172.16.100.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.12; Tue, 15 Feb 2022 20:14:01 +0300
Received: from DDSM-EXED02.digdes.com (172.16.96.56) by DDSM-MAIL01.digdes.com
 (172.16.100.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2375.12 via Frontend
 Transport; Tue, 15 Feb 2022 20:14:01 +0300
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (104.47.18.106)
 by relay2.digdes.com (172.16.96.56) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Tue, 15 Feb 2022 20:14:00 +0300
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P87NATK/hrDjv9Ulseg+IvnqvimN6JcJuwEK7Rg6XDE6ELflqjQBlvBSidFlUkY6jRqAoFsDp4WKfL19bxuBKAALiFVPuWuNRKq8sVDHhddxdlG/qZ7NywYwy8KPQoe+cKdEunoV3NNOeBdMVJ87bqhW3kmnD6WbJQOLmBmLh6bOl2r7WRS/7asPYca0oeYaqEL0PP/zo4vP2fcMlTlcZtsFVjZCZltpYXd2cExtgZy7HIUKhQffmUX7HluO6rfKoQi1PtCK0avVW2PgEZWzWhXCln8XfM3OcP/g9pogUa7Gco7FxjA/SCUZJTNakdmiImR3C+pZjPFi2z4C0nGABg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vdnX9I0sIQYwm0K8PCuY2iwjJ7XzFMUpIaaFoDh+/RI=;
 b=QCU3ljqP74Pt80q/B5MZLZvMS7gb9IVY4WxyD/qNt8YQX2HwmscBukm0f7MhdmtwzYnQYfJQD9+dUmJ1GMLz8rvdUkEVXGfhKnc7aCnLpsEzPxLujaacWtg7wNlv3HxYqJCKowHE/mlNoD8DhpjIoleDLFQDp8NwM/eSCOmq3/UQ5wg8oUxLByTiWySa5tr7Xluvriz0GE5QWW8nsY3DAn05PWT4h6fjrTGM7vf0F8EXr/HmBqHMpwAzDobjJ/CB8IRWMYz9s25QZ7fdeNvRVFm9Yw5Vi2KzP0kGpVvJmKIQARTXYHGW9VFdhsyxYNpYHFlwIPKNreR1swJ86+t1dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=raidix.com; dmarc=pass action=none header.from=raidix.com;
 dkim=pass header.d=raidix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=digdes.onmicrosoft.com; s=selector2-digdes-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdnX9I0sIQYwm0K8PCuY2iwjJ7XzFMUpIaaFoDh+/RI=;
 b=TdOXHxxwd7lMsE8EGM8/rij1csfFcLjZHmoCk8TS7GKynxfFX/RXL8u/VHDJpMtRVlW/Uo/84svdS7CCiaweaQCFviJs/IJiXhA8F9+5iGR2TTyqeOHBt+7vTALhwJgmdYnbN8xJaJmf+vr6keeVcJwybpZUwA+mOoSeNb9dwlE=
Received: from AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:403::6)
 by VI1PR10MB2719.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:e1::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Tue, 15 Feb
 2022 17:13:59 +0000
Received: from AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::4878:86c5:8899:f1c5]) by AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::4878:86c5:8899:f1c5%7]) with mapi id 15.20.4975.017; Tue, 15 Feb 2022
 17:13:59 +0000
From:   Chesnokov Gleb <Chesnokov.G@raidix.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: [PATCH 2/2] qla2xxx: Use named initializers for q_dev_state
Thread-Topic: [PATCH 2/2] qla2xxx: Use named initializers for q_dev_state
Thread-Index: AQHYIo6lxTS1cOPenkSYe6rvU6E7bQ==
Date:   Tue, 15 Feb 2022 17:13:59 +0000
Message-ID: <AS8PR10MB495298515A7553C8D6D6E74D9D349@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 74ceff2c-5d2b-7cdf-9da8-62e4ed9dc0e3
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=raidix.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c874abe2-53ba-4700-d76a-08d9f0a68e62
x-ms-traffictypediagnostic: VI1PR10MB2719:EE_
x-microsoft-antispam-prvs: <VI1PR10MB27193F0C336A4F8C8FA585819D349@VI1PR10MB2719.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:52;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yL+Dc78yBRjdfKzlAZn5p9XGyM+FLymv3iemJvD90MJaX4K54v7fyhS2JZRxIdS1cH/nfr2dok6lCMX/b6eFq599uqQytcb408bQDeptRtrf0sMATI3lzFA5czg6TXlOt5CRi7fugVWuBC5rukXFoZdEMJZNgeAVeImAzy0Q4cVfUwdLWa64S6YCV8WM+cZ4qfrc0l1fl//hAtYhb+J0CNdEIiee1MDjsF1/f7ORdU2GEP7/w8t/0GLEGg15JYdNW+UXWNkCDojp4WMCtMkOGcTisNkMsGr5kBb7WVxjJbZWz9lxua78rRnhiWjd0fQQuZJVHfMVPVfJtqPXd0deOb2/5MKZs/eEKkcVHc3Wxe99QVqaytKVt2lC320dsVdsdPptXFYfosgp8lo4FISWkLU6qr+db/BwzCydzc4bT632RPi3GHmdp07lhftm2RA3ik/YWbbe3aYy1sehmqtGhOQFyP2tXroGP/0PWsPvkqA8lygfAmKkpCaxkZPwK/uYkNkBOBbEv/OyG00hTx/J2GSZXobfgEoFJFKVhqrb3LEMRFB2/Lj9QvlGY6Cm6xZlIAd/dNgB32CHrEOIBCxEzDNYkFktBJg4Ifl5g846RzcBDOKiztNG4u6LRHwVGcC/PLDEH8R6L9naZRYArIwPC9FefGwrRVRgkD0YUDUvTVfiQaVGqvVE+Lg8psadxuu9rsJ9GSXnqIN7yk3hq+2y3fFwR8eN97HKrHyg8j1NI/Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(9686003)(26005)(186003)(508600001)(55016003)(66946007)(76116006)(7696005)(122000001)(5660300002)(91956017)(52536014)(38100700002)(33656002)(71200400001)(6916009)(64756008)(8936002)(38070700005)(55236004)(316002)(83380400001)(86362001)(8676002)(66446008)(2906002)(66556008)(66476007)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?ZUmyw9bTR1lFHrPz0oSPXpuKX18L4fhDY3jgyRonB42LsVUZpwoH5iPneL?=
 =?iso-8859-1?Q?XjcNCuMHKDsj053b8DjQ7qlqXGKVLXL3pSlJMpBfRV14d9qYM/n3mYMD6l?=
 =?iso-8859-1?Q?ZLcnZf847Gy9wjNcthnOOAhCNRrDskHP17Oru6TUludvYUywplzAhyFuZ2?=
 =?iso-8859-1?Q?UBiALCXTCFXVigpfZVjqhDrt3oOVC3FkxZQrMtk4MWtIX+UjSGI8S/ABe4?=
 =?iso-8859-1?Q?UDjUMGXsWkaGTEIKwl3ElPOMeon1uNnfJG5M2yfbGJ/oCP7mpYTmMJiDA6?=
 =?iso-8859-1?Q?Js31X5vmJjj/2dtIV1h5lo+n2yW1guELFXkmdt3jG9c/ZdjkQuUTOcpM33?=
 =?iso-8859-1?Q?kpnFyL5JYcLmloOKg4f8ozqJtFESU3MqX8LOmoU0AEcZxJW6u41a+tLFRn?=
 =?iso-8859-1?Q?FVwdIzaB5h18YoiApPmA8esvjCic9afs5SAUxLKVX8I9AAYCKD1fyRr3KN?=
 =?iso-8859-1?Q?mdLqFh2jB+6JwGHLc1pR6P9SWAk3Iako1sCM7Z9FCE/JOhVTiK6zEebfrv?=
 =?iso-8859-1?Q?KaDNktQmU14T4t6ByC1IEy7C8IVwlR1ROQezHr9jCeTb1hdRfEWhtwE6II?=
 =?iso-8859-1?Q?00Pv+AlasQq1B4mNunDdZfXo9sEo3bNvy3d5KzEETgjsEsWF0qqETKt1QZ?=
 =?iso-8859-1?Q?xw7aAvhCzYpP1buUegUbZmgU8z5U4VY/qz3Zzf+RZf3oxLF11cydVY48+8?=
 =?iso-8859-1?Q?UF/neYFxjABJH8KYie2I21L0C3SrX0HCbOjpfJidZcP7EviniDUMhH9LDs?=
 =?iso-8859-1?Q?uFeCXvd5uzgPgR2rJl3KsT5oZhmEgRaVicCheqGQBchKNAvFcZg1kPgOoF?=
 =?iso-8859-1?Q?LKN/5x1TnMYVSeaKrpQHmXTQ1h+Mlm7uS0YxdI2GaxljCCgzCgrQ7FVgQe?=
 =?iso-8859-1?Q?Re4NKrRGxkyjwU//iaTvmhp45jN0FARRbaX3QHTFOTQOQRNk9mdB4uaQYp?=
 =?iso-8859-1?Q?s1mdQELBMqhRhiXZpv255qChmV7/q8ijTPBqHQsqSUb9dkhQktBM6ZlpY8?=
 =?iso-8859-1?Q?KsUVJcWWlhEmVOTeN8x8rzdC9Aogg6ZVpb7h4dXWJSdQyav6+8p+VvmiIU?=
 =?iso-8859-1?Q?QdoN7ZGtFd+O4QwyStsT2gqMj5AgW3gnAVHBqo+WKf+Xe/CX1E9Dup+OBX?=
 =?iso-8859-1?Q?QK9FMypzyoUSS91oAle2xYNjU4FsdgY1M9gI5jjRjI61jNzbeOYbImoiZJ?=
 =?iso-8859-1?Q?h8DW8bXtYLCj7gNa4yn7vA8usidsbpXyhRgkmRariTLGMpHj+Oy3oBbY7U?=
 =?iso-8859-1?Q?tPSeB6JDPUHKmDtPDJyzHolbgq+W7a88AoQNhshLWJS4mozBvr5zvmQJLh?=
 =?iso-8859-1?Q?KgdsBk05qE3us1suisK2EVYslpXneGZeDmAZnHvh2z0qzbKz4EeVRSAR2T?=
 =?iso-8859-1?Q?Yspdtm+1ofuZbdRJ8X4V79OhzgSPMqxkrHx7a1wg532MAXONVNldxVG9Kl?=
 =?iso-8859-1?Q?W0SJLiefwLC8EnPkHmeuwrkyabK+Dkw4visTGtUjJyqQU9uBVWpTxzCHFt?=
 =?iso-8859-1?Q?s8XVlvMaY01+J/xX96v0oKYy8rau3mxRjf3x8cZPxel5np5uRJmJu/DjkP?=
 =?iso-8859-1?Q?Ppf9yKDrMQiISmrkzP0RrkN6ummp1JChiJouFgOWI1KbpbMblIwgw/Q9vG?=
 =?iso-8859-1?Q?3b+awAv7EvAZqZFBhPaQIARIT6zP/z1Axs1fbUKTA6IUhdp+lzYnw8tA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: c874abe2-53ba-4700-d76a-08d9f0a68e62
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 17:13:59.3090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70c55e28-9cd7-4753-937e-c751128a9d38
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rTxPcsQVeGp3MTKUB2FT5p+8ywzNHkIvEHdx5ZPtbyi56wvLMPVJUtEzt5OJrQkQlR2BY+JNw/HsfwJSW2aKTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB2719
X-OriginatorOrg: raidix.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make q_dev_state a little more readable and maintainable by using=0A=
named initializers.=0A=
=0A=
Also convert QLA8XXX_DEV_* macros into an enum and remove=0A=
qla83xx_dev_state_to_string(), which is a duplicate of qdev_state().=0A=
=0A=
Signed-off-by: Gleb Chesnokov <Chesnokov.G@raidix.com>=0A=
---=0A=
 drivers/scsi/qla2xxx/qla_gbl.h  |  2 +-=0A=
 drivers/scsi/qla2xxx/qla_init.c | 28 ++------------------------=0A=
 drivers/scsi/qla2xxx/qla_nx.c   | 35 ++++++++++++++-------------------=0A=
 drivers/scsi/qla2xxx/qla_nx.h   | 20 +++++++++++--------=0A=
 drivers/scsi/qla2xxx/qla_nx2.c  |  9 +++------=0A=
 5 files changed, 33 insertions(+), 61 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.=
h=0A=
index 8d8503a28479..7e93ab9104fd 100644=0A=
--- a/drivers/scsi/qla2xxx/qla_gbl.h=0A=
+++ b/drivers/scsi/qla2xxx/qla_gbl.h=0A=
@@ -890,7 +890,7 @@ extern void qla82xx_chip_reset_cleanup(scsi_qla_host_t =
*);=0A=
 extern int qla81xx_set_led_config(scsi_qla_host_t *, uint16_t *);=0A=
 extern int qla81xx_get_led_config(scsi_qla_host_t *, uint16_t *);=0A=
 extern int qla82xx_mbx_beacon_ctl(scsi_qla_host_t *, int);=0A=
-extern char *qdev_state(uint32_t);=0A=
+extern const char *qdev_state(uint32_t);=0A=
 extern void qla82xx_clear_pending_mbx(scsi_qla_host_t *);=0A=
 extern int qla82xx_read_temperature(scsi_qla_host_t *);=0A=
 extern int qla8044_read_temperature(scsi_qla_host_t *);=0A=
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_ini=
t.c=0A=
index 1fe4966fc2f6..b07ebfb02ea9 100644=0A=
--- a/drivers/scsi/qla2xxx/qla_init.c=0A=
+++ b/drivers/scsi/qla2xxx/qla_init.c=0A=
@@ -6773,29 +6773,6 @@ __qla83xx_clear_drv_ack(scsi_qla_host_t *vha)=0A=
 	return rval;=0A=
 }=0A=
 =0A=
-static const char *=0A=
-qla83xx_dev_state_to_string(uint32_t dev_state)=0A=
-{=0A=
-	switch (dev_state) {=0A=
-	case QLA8XXX_DEV_COLD:=0A=
-		return "COLD/RE-INIT";=0A=
-	case QLA8XXX_DEV_INITIALIZING:=0A=
-		return "INITIALIZING";=0A=
-	case QLA8XXX_DEV_READY:=0A=
-		return "READY";=0A=
-	case QLA8XXX_DEV_NEED_RESET:=0A=
-		return "NEED RESET";=0A=
-	case QLA8XXX_DEV_NEED_QUIESCENT:=0A=
-		return "NEED QUIESCENT";=0A=
-	case QLA8XXX_DEV_FAILED:=0A=
-		return "FAILED";=0A=
-	case QLA8XXX_DEV_QUIESCENT:=0A=
-		return "QUIESCENT";=0A=
-	default:=0A=
-		return "Unknown";=0A=
-	}=0A=
-}=0A=
-=0A=
 /* Assumes idc-lock always held on entry */=0A=
 void=0A=
 qla83xx_idc_audit(scsi_qla_host_t *vha, int audit_type)=0A=
@@ -6849,9 +6826,8 @@ qla83xx_initiating_reset(scsi_qla_host_t *vha)=0A=
 		ql_log(ql_log_info, vha, 0xb056, "HW State: NEED RESET.\n");=0A=
 		qla83xx_idc_audit(vha, IDC_AUDIT_TIMESTAMP);=0A=
 	} else {=0A=
-		const char *state =3D qla83xx_dev_state_to_string(dev_state);=0A=
-=0A=
-		ql_log(ql_log_info, vha, 0xb057, "HW State: %s.\n", state);=0A=
+		ql_log(ql_log_info, vha, 0xb057, "HW State: %s.\n",=0A=
+				qdev_state(dev_state));=0A=
 =0A=
 		/* SV: XXX: Is timeout required here? */=0A=
 		/* Wait for IDC state change READY -> NEED_RESET */=0A=
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c=
=0A=
index 11aad97dfca8..6dfb70edb9a6 100644=0A=
--- a/drivers/scsi/qla2xxx/qla_nx.c=0A=
+++ b/drivers/scsi/qla2xxx/qla_nx.c=0A=
@@ -335,20 +335,20 @@ static unsigned qla82xx_crb_hub_agt[64] =3D {=0A=
 };=0A=
 =0A=
 /* Device states */=0A=
-static char *q_dev_state[] =3D {=0A=
-	 "Unknown",=0A=
-	"Cold",=0A=
-	"Initializing",=0A=
-	"Ready",=0A=
-	"Need Reset",=0A=
-	"Need Quiescent",=0A=
-	"Failed",=0A=
-	"Quiescent",=0A=
+static const char *const q_dev_state[] =3D {=0A=
+	[QLA8XXX_DEV_UNKNOWN]		=3D "Unknown",=0A=
+	[QLA8XXX_DEV_COLD]		=3D "Cold/Re-init",=0A=
+	[QLA8XXX_DEV_INITIALIZING]	=3D "Initializing",=0A=
+	[QLA8XXX_DEV_READY]		=3D "Ready",=0A=
+	[QLA8XXX_DEV_NEED_RESET]	=3D "Need Reset",=0A=
+	[QLA8XXX_DEV_NEED_QUIESCENT]	=3D "Need Quiescent",=0A=
+	[QLA8XXX_DEV_FAILED]		=3D "Failed",=0A=
+	[QLA8XXX_DEV_QUIESCENT]		=3D "Quiescent",=0A=
 };=0A=
 =0A=
-char *qdev_state(uint32_t dev_state)=0A=
+const char *qdev_state(uint32_t dev_state)=0A=
 {=0A=
-	return q_dev_state[dev_state];=0A=
+	return (dev_state < MAX_STATES) ? q_dev_state[dev_state] : "Unknown";=0A=
 }=0A=
 =0A=
 /*=0A=
@@ -3061,8 +3061,7 @@ qla82xx_need_reset_handler(scsi_qla_host_t *vha)=0A=
 =0A=
 	ql_log(ql_log_info, vha, 0x00b6,=0A=
 	    "Device state is 0x%x =3D %s.\n",=0A=
-	    dev_state,=0A=
-	    dev_state < MAX_STATES ? qdev_state(dev_state) : "Unknown");=0A=
+	    dev_state, qdev_state(dev_state));=0A=
 =0A=
 	/* Force to DEV_COLD unless someone else is starting a reset */=0A=
 	if (dev_state !=3D QLA8XXX_DEV_INITIALIZING &&=0A=
@@ -3185,8 +3184,7 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)=0A=
 	old_dev_state =3D dev_state;=0A=
 	ql_log(ql_log_info, vha, 0x009b,=0A=
 	    "Device state is 0x%x =3D %s.\n",=0A=
-	    dev_state,=0A=
-	    dev_state < MAX_STATES ? qdev_state(dev_state) : "Unknown");=0A=
+	    dev_state, qdev_state(dev_state));=0A=
 =0A=
 	/* wait for 30 seconds for device to go ready */=0A=
 	dev_init_timeout =3D jiffies + (ha->fcoe_dev_init_timeout * HZ);=0A=
@@ -3207,9 +3205,7 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)=0A=
 		if (loopcount < 5) {=0A=
 			ql_log(ql_log_info, vha, 0x009d,=0A=
 			    "Device state is 0x%x =3D %s.\n",=0A=
-			    dev_state,=0A=
-			    dev_state < MAX_STATES ? qdev_state(dev_state) :=0A=
-			    "Unknown");=0A=
+			    dev_state, qdev_state(dev_state));=0A=
 		}=0A=
 =0A=
 		switch (dev_state) {=0A=
@@ -3439,8 +3435,7 @@ qla82xx_set_reset_owner(scsi_qla_host_t *vha)=0A=
 	} else=0A=
 		ql_log(ql_log_info, vha, 0xb031,=0A=
 		    "Device state is 0x%x =3D %s.\n",=0A=
-		    dev_state,=0A=
-		    dev_state < MAX_STATES ? qdev_state(dev_state) : "Unknown");=0A=
+		    dev_state, qdev_state(dev_state));=0A=
 }=0A=
 =0A=
 /*=0A=
diff --git a/drivers/scsi/qla2xxx/qla_nx.h b/drivers/scsi/qla2xxx/qla_nx.h=
=0A=
index 8567eaf1bddd..6dc80c8ddf79 100644=0A=
--- a/drivers/scsi/qla2xxx/qla_nx.h=0A=
+++ b/drivers/scsi/qla2xxx/qla_nx.h=0A=
@@ -540,14 +540,18 @@=0A=
 #define QLA82XX_CRB_DRV_IDC_VERSION  (QLA82XX_CAM_RAM(0x174))=0A=
 =0A=
 /* Every driver should use these Device State */=0A=
-#define QLA8XXX_DEV_COLD		1=0A=
-#define QLA8XXX_DEV_INITIALIZING	2=0A=
-#define QLA8XXX_DEV_READY		3=0A=
-#define QLA8XXX_DEV_NEED_RESET		4=0A=
-#define QLA8XXX_DEV_NEED_QUIESCENT	5=0A=
-#define QLA8XXX_DEV_FAILED		6=0A=
-#define QLA8XXX_DEV_QUIESCENT		7=0A=
-#define	MAX_STATES			8 /* Increment if new state added */=0A=
+enum {=0A=
+	QLA8XXX_DEV_UNKNOWN,=0A=
+	QLA8XXX_DEV_COLD,=0A=
+	QLA8XXX_DEV_INITIALIZING,=0A=
+	QLA8XXX_DEV_READY,=0A=
+	QLA8XXX_DEV_NEED_RESET,=0A=
+	QLA8XXX_DEV_NEED_QUIESCENT,=0A=
+	QLA8XXX_DEV_FAILED,=0A=
+	QLA8XXX_DEV_QUIESCENT,=0A=
+	MAX_STATES, /* Increment if new state added */=0A=
+};=0A=
+=0A=
 #define QLA8XXX_BAD_VALUE		0xbad0bad0=0A=
 =0A=
 #define QLA82XX_IDC_VERSION			1=0A=
diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.=
c=0A=
index 5ceecc9642fc..41ff6fbdb933 100644=0A=
--- a/drivers/scsi/qla2xxx/qla_nx2.c=0A=
+++ b/drivers/scsi/qla2xxx/qla_nx2.c=0A=
@@ -1938,8 +1938,7 @@ qla8044_device_state_handler(struct scsi_qla_host *vh=
a)=0A=
 	dev_state =3D qla8044_rd_direct(vha, QLA8044_CRB_DEV_STATE_INDEX);=0A=
 	ql_dbg(ql_dbg_p3p, vha, 0xb0ce,=0A=
 	    "Device state is 0x%x =3D %s\n",=0A=
-	    dev_state, dev_state < MAX_STATES ?=0A=
-	    qdev_state(dev_state) : "Unknown");=0A=
+	    dev_state, qdev_state(dev_state));=0A=
 =0A=
 	/* wait for 30 seconds for device to go ready */=0A=
 	dev_init_timeout =3D jiffies + (ha->fcoe_dev_init_timeout * HZ);=0A=
@@ -1952,8 +1951,7 @@ qla8044_device_state_handler(struct scsi_qla_host *vh=
a)=0A=
 				ql_log(ql_log_warn, vha, 0xb0cf,=0A=
 				    "%s: Device Init Failed 0x%x =3D %s\n",=0A=
 				    QLA2XXX_DRIVER_NAME, dev_state,=0A=
-				    dev_state < MAX_STATES ?=0A=
-				    qdev_state(dev_state) : "Unknown");=0A=
+				    qdev_state(dev_state));=0A=
 				qla8044_wr_direct(vha,=0A=
 				    QLA8044_CRB_DEV_STATE_INDEX,=0A=
 				    QLA8XXX_DEV_FAILED);=0A=
@@ -1963,8 +1961,7 @@ qla8044_device_state_handler(struct scsi_qla_host *vh=
a)=0A=
 		dev_state =3D qla8044_rd_direct(vha, QLA8044_CRB_DEV_STATE_INDEX);=0A=
 		ql_log(ql_log_info, vha, 0xb0d0,=0A=
 		    "Device state is 0x%x =3D %s\n",=0A=
-		    dev_state, dev_state < MAX_STATES ?=0A=
-		    qdev_state(dev_state) : "Unknown");=0A=
+		    dev_state, qdev_state(dev_state));=0A=
 =0A=
 		/* NOTE: Make sure idc unlocked upon exit of switch statement */=0A=
 		switch (dev_state) {=0A=
-- =0A=
2.35.1=0A=
