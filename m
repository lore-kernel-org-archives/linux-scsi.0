Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F665C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 17:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240018AbiBOROM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Feb 2022 12:14:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbiBOROL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2022 12:14:11 -0500
Received: from smtp.digdes.com (smtp.digdes.com [85.114.5.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19ED311AA20
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2022 09:13:59 -0800 (PST)
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by relay2.digdes.com
 (172.16.96.56) with Microsoft SMTP Server (TLS) id 14.3.498.0; Tue, 15 Feb
 2022 20:13:56 +0300
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by
 DDSM-MAIL01.digdes.com (172.16.100.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.12; Tue, 15 Feb 2022 20:13:56 +0300
Received: from DDSM-EXED01.digdes.com (172.16.96.24) by DDSM-MAIL01.digdes.com
 (172.16.100.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2375.12 via Frontend
 Transport; Tue, 15 Feb 2022 20:13:56 +0300
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (104.47.8.58) by
 relay.digdes.com (172.16.96.24) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Tue, 15 Feb 2022 20:13:56 +0300
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TEyVtfL7zj50y11aas96l7bafCdK/gSwkiw9opKXXbD/J/CmisCfbi+jSX8+RzDJLFzBpaHHsATA/+ucLJOkSTpQ058z6H784PX7VJS4EFbNt5U70kME+KZOAJ1NnxwqKjpVRREuHejgOiClEgwJJl3L27XzSvnfRECs2DDs8cnaydv0AVy2B4msGzC5NVu6Ik2n+qhIWzKZJkZ6HSSMNI/XjxykXMiDoLvDZvhmkOStSXRdICWAQLjvif8q20eTTNLQj7iEjxILf18iox290f7icd4AfADsqDDqhGHua76dgmvQhg2p8fDnA7JOCLWc4kICMEK8YrinFNB4Q/cO7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T0YeFyFnkH2aapPbEQ2vi8gTqbe699FtPXs26PGeFSQ=;
 b=LJJtGkw1zJYr0HJCL1g5ij97x9LPE3b+HtKZMBV6s6kq2Zt1BjwkRARZdcTXDRQ1DECI1n2DHLWba6BMhOyPM5Gw/gXAcVVcATSDp/n5rczM5n05P+SgtAjStfIwBYwfqOuGMgMAKivCrZGG2tVS4C73RNCWzsOTsRa4dOxQPINk/C+VMOTqr2RrW3eC0zGNycE4tOg+eAE5uIsYIGNj+RPS6VA4b49CAXonJRae8ys8Y6VW32bNFs+uGUH4cHjFQaO4H9khwAhSP49UZLNTwuKnu81dM1m/PTodVg70mbMIOCmHmvqx02W4O/NxFauie/LhkR3Cdy8+q+GyYtp0yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=raidix.com; dmarc=pass action=none header.from=raidix.com;
 dkim=pass header.d=raidix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=digdes.onmicrosoft.com; s=selector2-digdes-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T0YeFyFnkH2aapPbEQ2vi8gTqbe699FtPXs26PGeFSQ=;
 b=Evj4Ity4epclI0s/SH0bg+ahXNVGXhNfhxSp9P3hs7aDI+SJaHRxU+kkYvWFBA8WOduncY+5zIwxclRPdC8ryP6BJTEzppPZbQnmrzulzdN7Gbf+S7qwsZgx/ahW0o8X+zXOG/QbyrQpb2iGR7rPzlHcnVIagH1MIh9/fUuCHFg=
Received: from AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:403::6)
 by VI1PR10MB2719.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:e1::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Tue, 15 Feb
 2022 17:13:53 +0000
Received: from AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::4878:86c5:8899:f1c5]) by AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::4878:86c5:8899:f1c5%7]) with mapi id 15.20.4975.017; Tue, 15 Feb 2022
 17:13:53 +0000
From:   Chesnokov Gleb <Chesnokov.G@raidix.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/2] qla2xxx: Use named initializers for port_[d]state_str
Thread-Topic: [PATCH 1/2] qla2xxx: Use named initializers for
 port_[d]state_str
Thread-Index: AQHYIo4mcTFVAdEJS0WML5Qqc+V4sQ==
Date:   Tue, 15 Feb 2022 17:13:53 +0000
Message-ID: <AS8PR10MB495215841EB25C16DBC0CB409D349@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 5cca74a1-3ebf-2e42-86fd-63d08a230b9c
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=raidix.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a256dc68-0cc2-4299-6461-08d9f0a68ac5
x-ms-traffictypediagnostic: VI1PR10MB2719:EE_
x-microsoft-antispam-prvs: <VI1PR10MB2719C1B384C404716ACD7A839D349@VI1PR10MB2719.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:80;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6/zdFSoOjFdp9S9BHbRtDgYJerjgyuKqFcj6sE53vg1Z3tFvcIXOkqlje+OE/qsBQM35xZIT17+pz9a4kneQZmtlSMflMEcQgWtLZ2XsMXdXCCU+cLQeaYVufxfnvjkMdmZh0NVlBhnDAbN/XPyaK0gfENlefFKvOHRqhg7tTXzONyrOibBYqmkAuxy84OR1bJ0uniKpucfjQqKXNvVx3qAiBwzrMQ1lz94EANJky5mLE/1VaL0uJ3IK8dJFXtYh5bGVj9JTvWe1Pe3BJkU6E+pTxAa0wkjglBBNsjd1oephxKbN3UP9UsErAkJeI1g6zgK9+O+RrGmyX46XHddQSUSoPdqc1cIFzHXw3xNSpyce8JqvbpRf+SSsSAY7eX5FLhsViHlwayNomrvUP8dRT72tZ9mn7oD228cJ6rSWcUTOG6tFMGy2auyVFFj1R7r8AESosZShz6lu8c3x3R5eyDUsLYHuxo6KARLpfOhv/gr4UFpY15xJigaakCVVsTEQSADWFiebLcfQExFs5Y4hubnS852d0MPlC8yoeZ4NXjO71vLCKF7BIo7AwnF5lYRBLfWXQkcyXDx2/wHlu0Z97f/q11SLieM8iL/3NllqF8+NIsM4tfrw/mVQnAH5YowLw/O9OeGqhtIm1p8esffrGbhuqcY+cCu334+PoRbemraILs7iujRp06qVc5tEsl0lRYzpY0ziDVR9v4roywE1Vg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(9686003)(26005)(186003)(508600001)(55016003)(66946007)(76116006)(7696005)(122000001)(5660300002)(91956017)(52536014)(38100700002)(33656002)(71200400001)(6916009)(64756008)(8936002)(38070700005)(55236004)(316002)(83380400001)(86362001)(8676002)(66446008)(2906002)(66556008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Uf7LxH+r9VRkZC+Dqg5aA+csg17nWuSCDY0tUUclbD8baDkHJYn2cRX67J?=
 =?iso-8859-1?Q?zUk917dij3BTFyChuF53xodLJspon93JkphrKSIQNS270w7eWcjcLPBq2r?=
 =?iso-8859-1?Q?EQhZnfqS7/aDQku7Tyl7Xz3NkBFNxIIo7IZY7q0XqmarS8Movko0mjqik7?=
 =?iso-8859-1?Q?lmsZWJYFLLVitA595GzneKqDRN4G3ZkMWdErsQVXQvFJCrxJ9VIv8VDqMK?=
 =?iso-8859-1?Q?xwovfW/7q6YuXcMSk4uniyw+llghSYgNrfMFCZY8zRNfSn3g+Cxift+RV1?=
 =?iso-8859-1?Q?V38qE36fyZd9MqgGEwghgzLMnVnhTDqT6dRs4Tg8ZB73n1erFeLdnT35uv?=
 =?iso-8859-1?Q?vZe1UTmAYz2iL3Hf5ua0iKdqxO+UCIktvenfzOHljajUn63O6Q1xjyU8cO?=
 =?iso-8859-1?Q?V4nOIj6haH57TyBCNt3ZtW0sRcKYH8rPCNQuVwHOYphdMQc+bboVtiPXuL?=
 =?iso-8859-1?Q?x5OOeqzVKIZf3aEl5jBP2M6VgYHExPle70teYSsqMuSo8d7H6JZKnw/1r0?=
 =?iso-8859-1?Q?mvB5AityLqI9W2KHZeQITSOnP0v+Q4lv62o3fBp/t4SslADUnB2UDkb1Ln?=
 =?iso-8859-1?Q?yYHRnjuoAbjacEdJazQW1nGblaiJzrN0cRSjcNpl/6zFKOW0aUJvkgYuXD?=
 =?iso-8859-1?Q?eYRPW4IBqf+2BKDdy6aYMkcUpBxPfpYAkHZmaf5PjK0Au/vt+moDef63ke?=
 =?iso-8859-1?Q?RNqfMCP8wbWDGitkXQp7SGoTy8lolYTF1mhXQ3bZ2LbKnnJwvZM201B5W5?=
 =?iso-8859-1?Q?aqAVfgjWuN0x3BS9vDQ//7JipJgbe/n9rVjDTWJ1RJJpi13h8s8zCLeWyK?=
 =?iso-8859-1?Q?8jeBJhjiSulKl3t5EeeQFyEG46IdS53wSZWhQJsdr5sNBhkQwwxPm8m9iK?=
 =?iso-8859-1?Q?NTMvKm5z4J7ZBqdzVbTlig+XZFYiQx0+019PbrQJKmavkjlsHQakcXYEeJ?=
 =?iso-8859-1?Q?psN0O9dtonJlJ7JtfP8ITZEiyQRYten0FS3CqFSxRW8ay07kvK4kH8QXQu?=
 =?iso-8859-1?Q?IGvUvRnoKLwEL/C5IN79aE9xy1v4TcomA/vfkB9/QIx9x++EJLT3tgnacw?=
 =?iso-8859-1?Q?X/W1o6jQjBizlnqugxrqTgZLfLMTkGJKeu2HkB76ilF0lnLjR1MY6E3fCi?=
 =?iso-8859-1?Q?i+PQ+lqkENaNcLQmRDfjSwePKMv/eUzUu5Su7Ir6tCei5drxq7aDfVIpPU?=
 =?iso-8859-1?Q?YKjiHiPpnL0Bd2rOXGzQD1yB5Uiso94HOs1gYKyHIMM2sIGIHzUzMHYUnD?=
 =?iso-8859-1?Q?wh52+b3ydWP89efdIOp6CZzYHuU4DbWWd2e+6LSmhwPO6CEiKG1zzBGbFp?=
 =?iso-8859-1?Q?r+BhgpFSK1ZADLR2VM+JdIqGuXQzuQutadV8/Xyi9Xk/0B7zBQJ3pPbs4Y?=
 =?iso-8859-1?Q?mCj5vak1+PIdxHAE4gqo+fyuZMrQ0blBW2q27qVeqAJjrqrK1/NDdA/XbU?=
 =?iso-8859-1?Q?kl66lc0FX3+5ewhbPyYqc4PfNnS5P9jP3u+TNrJwkgR3GJf6qdyb6Ek9/n?=
 =?iso-8859-1?Q?zGWNvLSyIfHCqg6wTcpid9f8EwUr3xYXW4qcXE9t+tG3O0MAR9NpcpVIaV?=
 =?iso-8859-1?Q?YEiPHML/cbPPiTDaplW65ZP8VpQ1VCvtPghJ4JNJTqgYW6lEmECD93njdr?=
 =?iso-8859-1?Q?52RMlDMUjJ3TZ8dGFcoElxVmEAdu4Jdl8Khhk8e+kMtghrrlp2kheyKA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a256dc68-0cc2-4299-6461-08d9f0a68ac5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 17:13:53.2596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70c55e28-9cd7-4753-937e-c751128a9d38
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pUeWlyCtGtR+8KqdULcvDDaVOAHPXEAuWQy2POeS9qdcsdYnFTuzxpZ7QgemaVQeyLmavoOUJr5px1XXsVrJrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB2719
X-OriginatorOrg: raidix.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make port_state_str and port_dstate_str a little more readable and=0A=
maintainable by using named initializers.=0A=
=0A=
Also convert FCS_* macros into an enum.=0A=
=0A=
Signed-off-by: Gleb Chesnokov <Chesnokov.G@raidix.com>=0A=
---=0A=
 drivers/scsi/qla2xxx/qla_def.h | 35 ++++++++++++++++++----------------=0A=
 drivers/scsi/qla2xxx/qla_isr.c | 10 +++++-----=0A=
 2 files changed, 24 insertions(+), 21 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.=
h=0A=
index 9ebf4a234d9a..b0c40f6ab25d 100644=0A=
--- a/drivers/scsi/qla2xxx/qla_def.h=0A=
+++ b/drivers/scsi/qla2xxx/qla_def.h=0A=
@@ -2666,25 +2666,28 @@ struct event_arg {=0A=
 /*=0A=
  * Fibre channel port/lun states.=0A=
  */=0A=
-#define FCS_UNCONFIGURED	1=0A=
-#define FCS_DEVICE_DEAD		2=0A=
-#define FCS_DEVICE_LOST		3=0A=
-#define FCS_ONLINE		4=0A=
+enum {=0A=
+	FCS_UNKNOWN,=0A=
+	FCS_UNCONFIGURED,=0A=
+	FCS_DEVICE_DEAD,=0A=
+	FCS_DEVICE_LOST,=0A=
+	FCS_ONLINE,=0A=
+};=0A=
 =0A=
 extern const char *const port_state_str[5];=0A=
 =0A=
-static const char * const port_dstate_str[] =3D {=0A=
-	"DELETED",=0A=
-	"GNN_ID",=0A=
-	"GNL",=0A=
-	"LOGIN_PEND",=0A=
-	"LOGIN_FAILED",=0A=
-	"GPDB",=0A=
-	"UPD_FCPORT",=0A=
-	"LOGIN_COMPLETE",=0A=
-	"ADISC",=0A=
-	"DELETE_PEND",=0A=
-	"LOGIN_AUTH_PEND",=0A=
+static const char *const port_dstate_str[] =3D {=0A=
+	[DSC_DELETED]		=3D "DELETED",=0A=
+	[DSC_GNN_ID]		=3D "GNN_ID",=0A=
+	[DSC_GNL]		=3D "GNL",=0A=
+	[DSC_LOGIN_PEND]	=3D "LOGIN_PEND",=0A=
+	[DSC_LOGIN_FAILED]	=3D "LOGIN_FAILED",=0A=
+	[DSC_GPDB]		=3D "GPDB",=0A=
+	[DSC_UPD_FCPORT]	=3D "UPD_FCPORT",=0A=
+	[DSC_LOGIN_COMPLETE]	=3D "LOGIN_COMPLETE",=0A=
+	[DSC_ADISC]		=3D "ADISC",=0A=
+	[DSC_DELETE_PEND]	=3D "DELETE_PEND",=0A=
+	[DSC_LOGIN_AUTH_PEND]	=3D "LOGIN_AUTH_PEND",=0A=
 };=0A=
 =0A=
 /*=0A=
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.=
c=0A=
index aaf6504570fd..092e4b5da65a 100644=0A=
--- a/drivers/scsi/qla2xxx/qla_isr.c=0A=
+++ b/drivers/scsi/qla2xxx/qla_isr.c=0A=
@@ -49,11 +49,11 @@ qla27xx_process_purex_fpin(struct scsi_qla_host *vha, s=
truct purex_item *item)=0A=
 }=0A=
 =0A=
 const char *const port_state_str[] =3D {=0A=
-	"Unknown",=0A=
-	"UNCONFIGURED",=0A=
-	"DEAD",=0A=
-	"LOST",=0A=
-	"ONLINE"=0A=
+	[FCS_UNKNOWN]		=3D "Unknown",=0A=
+	[FCS_UNCONFIGURED]	=3D "UNCONFIGURED",=0A=
+	[FCS_DEVICE_DEAD]	=3D "DEAD",=0A=
+	[FCS_DEVICE_LOST]	=3D "LOST",=0A=
+	[FCS_ONLINE]		=3D "ONLINE"=0A=
 };=0A=
 =0A=
 static void=0A=
-- =0A=
2.35.1=0A=
