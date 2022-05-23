Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B47EC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 23 May 2022 09:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbiEWJZL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 05:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233054AbiEWJZJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 05:25:09 -0400
Received: from smtp.digdes.com (smtp.digdes.com [85.114.5.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28F5483AE
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 02:25:04 -0700 (PDT)
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by relay2.digdes.com
 (172.16.96.56) with Microsoft SMTP Server (TLS) id 14.3.498.0; Mon, 23 May
 2022 12:25:01 +0300
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by
 DDSM-MAIL01.digdes.com (172.16.100.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.12; Mon, 23 May 2022 12:25:01 +0300
Received: from smtp.digdes.com (172.16.96.56) by DDSM-MAIL01.digdes.com
 (172.16.100.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2375.12 via Frontend
 Transport; Mon, 23 May 2022 12:25:01 +0300
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (104.47.13.52) by
 relay2.digdes.com (172.16.96.56) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Mon, 23 May 2022 12:25:01 +0300
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRLIYbiMhu77KdkyBM0ONHH8owDDtGHZtbiDc3QwMwWpOUG9jViCosFtIro1x7wySH+NFXIGaEzHp21Es5ujoC5VQoBwwnpQOWOgGF6Cg5NP5FNYz+HAS50zZ1OHWCPZPnBH1pPQzindMmmz7TqO1OC2zSDS8PUcdkPGrQsQ3Z6rRC32mOpMLs7XDNghYm3s85w0zB1RjzkhEJSWDsLqFgYfZFngLkmWh1cvasEzr43w0q/3wVQKmhjRrfdPg1FQKY1Xy5ZMMOktT0pMpviuN44YupfPCRsJETW6UK2C+S4jTQqKgyOikcFeuAOtM2nXTKJRbydIql9fm353A9H77w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+nxBG9ET9wiEY1MZYQgesNScPJO4F+fZ5sPqcgJjn/w=;
 b=cK2ANcNPPdEcwNpLSEb5CXbiAn7VNmcoGemDWVqTTh+CHb+enZYuBa5hjhpH84NxZxYw7dlMBVJbaG/SgE7gkstgqjo+TDv2hSdQlvqReXwXrhEw+cUL4cxXwyR4eF8FIGWAj4JUZbtGMhHJRoe2nM1lny7D+R05Pck0/Qv5oAK3jtFovUPPgtNe7NZJ73NY/H5HLC5eFQ+9iqdDsGDGdxMqOKCfQ89KHQbP3nnfi50Sqfq23tqbFf7rPtTux8dhQ8H4929ibh+oznj4B9xN8IwrllaS+7MyAvm8noBWNupB9h2Dype/dZPvb222ggxdfOxao71F+/av7nb9oN+NZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=raidix.com; dmarc=pass action=none header.from=raidix.com;
 dkim=pass header.d=raidix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=digdes.onmicrosoft.com; s=selector2-digdes-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+nxBG9ET9wiEY1MZYQgesNScPJO4F+fZ5sPqcgJjn/w=;
 b=oeF6mQGIHB/kDTwN8UcC0Zbcs4K9go2Yf1esUroLKrbtCefjWx1FTlJMLgiwxfCFB1CPQHBpScKtEluTGHlQ01F3sYORpgMXLhCHijp1wbHFJzuONPLxI7wLx6L7kIXNlwHmx9qQN5mU6ZpvKsLO/7QQ6VPxm6rBk5DlQLExGos=
Received: from AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1ff::5)
 by AM6PR10MB3094.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:e8::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Mon, 23 May
 2022 09:24:59 +0000
Received: from AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::6047:e205:1bca:5d29]) by AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::6047:e205:1bca:5d29%8]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 09:24:59 +0000
From:   Chesnokov Gleb <Chesnokov.G@raidix.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/1] qla2xxx: Remove unused ql_dm_tgt_ex_pct parameter
Thread-Topic: [PATCH 1/1] qla2xxx: Remove unused ql_dm_tgt_ex_pct parameter
Thread-Index: AQHYbobah7S1K+EECUWb/HaurQb5xw==
Date:   Mon, 23 May 2022 09:24:59 +0000
Message-ID: <AM9PR10MB41185ADE95B92B4E6926BE639DD49@AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 34ad1621-d04e-e4f6-dfd9-a0c3639f62a6
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=raidix.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e3edfe9-6e32-4b17-3451-08da3c9e1bbc
x-ms-traffictypediagnostic: AM6PR10MB3094:EE_
x-microsoft-antispam-prvs: <AM6PR10MB3094EF9412A901CEB8A348D79DD49@AM6PR10MB3094.EURPRD10.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v6elp++j0tTaEttG0tne30kPPXPJ1NwKG+/z0Cm2EebDkzHUYHhR+KlXKtRyvX5wKaNiDbvNNwjVDrd9Fx1YyQHfTP2Y7C5klr8vt2VSa9FT1rgumgFSSgiWDzXKSHZkw0Az67/4xqjoP/q9Ol/xtboTicWKLWDWETYIAx10qshxRA2HxueVJb8tvOc76rSWKruGfZP90bgwI2wK2ipiBZdSul/LaoY8bYnaVUtaUjKYiiGZDhPw19C8nUvnljAokJc5a90rXZbjZPDk6d5KmJiONiMwvVsSU9QJr/2ezEPq6opGUWdLsaklR06KGKaQuJ6JBkgF7IruW0of7fJ93l9OcGeCVLZIn8mtITavBP7s6cl8SIjpn/jY101mSvPt3M9vO333yprjX5JmQ73+CkiHsO3SRZ3S7uoyojkY9Y7oTqCqLI+6x6lW/hMcacPQAe4pvvBrfIv4NZeq+FH5jKUJF+rNxwI+OMW8xy8nsshn2dooN8WQFxPVQFtBakswhSqYsdZJwGBE4BwVJx+3vU43B0UpgN+ZqKmy3NZmI39u3raBD/lKMEUMNKYEnwYuh6Wus8Jrh2a7eIU/7QwURLv7VRSTXo1Alac0Hb+JqLholzVPdb3IkC6Khby/IACYk9kI8bzMcyuQbN8gxW1+4IzysRwLLFGKW+K9Q5imbFwRJw4x6qlepNLfuEAMWT05LSueuvCCy+hqhk2sUWseug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(52536014)(38100700002)(7696005)(508600001)(9686003)(38070700005)(6916009)(8936002)(122000001)(26005)(76116006)(6506007)(86362001)(71200400001)(316002)(186003)(33656002)(66946007)(2906002)(83380400001)(66556008)(55016003)(66446008)(66476007)(64756008)(8676002)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?0myNP/0A0s1rz0g37uctFgDABVysePv5zJy+8Y5Aa7t+fYMeByTQ4PPt05?=
 =?iso-8859-1?Q?MTmMu2sR8DJZZNyZ8vkKcxXVomxRjzHXOMYQUq2DYENCArePIeIRb883Co?=
 =?iso-8859-1?Q?uJyamk/0QIHt1DCTG72AW2nwQbYvS8Dh1Q+KwhGScBdyYDkWwb/klywPoG?=
 =?iso-8859-1?Q?c/XwPw1e/VlnI2iyw9kUnIdA4xYSm7RQv1pGYjuPxILyeRMvNGbNLo5b4g?=
 =?iso-8859-1?Q?LwnGSD4ttviFPSkQ3hBYFFcpF4qJSulAaw8WQCQMtSajlSLgg0EluscLMI?=
 =?iso-8859-1?Q?qVg/q1gBA/3rz9o//d+jy/8uRJWq7RY6xKuVFjMSldqyQ8lzK/yhzqJ9sY?=
 =?iso-8859-1?Q?0rdXu9jcKxoCURkJFnrCWVGotwdzGLHYeQujjTcGkD7huZIWp6QU9JpO0r?=
 =?iso-8859-1?Q?JkC99/Bu+od0snw6njer2lJRCe/WmCajW4+b8FzJveQPedj7It8Z2tIRxE?=
 =?iso-8859-1?Q?ky5OSIvT+iZigyU2hg6Zk6Lijpk8i0nKOR7EYYTKHhxW8I1zKH/ooBeZbo?=
 =?iso-8859-1?Q?IX3GbP2VqcfDgPaL6jkl1jNPvqfS46A9yPy7NBYP8tCauMOz3hgdAnW2Rx?=
 =?iso-8859-1?Q?7sk0/VffiULxjY4vPvwnDKr0Ju7rVjxZtkgYIZPt0UAxBhxoeq+Rj7BrcE?=
 =?iso-8859-1?Q?8cq8DGcXWYjdhmT5R5p0sO/pZVQg8MzCk8J55kQ4LM/v+7wsjlBY1dZeSE?=
 =?iso-8859-1?Q?AlCQ80yFywC3gYjcJQXYbcv3eVkr0hx+ikwApqMpZZaoacia8zIl5gYgr0?=
 =?iso-8859-1?Q?WZZYc3uBvM6EW9sigoIFxlZiDcYzAO3dMCJYGgV/kC6pxQ0qR6w2BonvgA?=
 =?iso-8859-1?Q?Op8stQ0vI7CBgypuL42CT0TvqkAGiNcXSbCtsDOctOJw9vyUWzJ0JJnhHf?=
 =?iso-8859-1?Q?RY1yqLxXd1SNDySKy9gOxDI7WdsYCNjpNqEcZp/FWRiLhYNl2YYoINnhPn?=
 =?iso-8859-1?Q?EbcjMUbS2imz2XCSivWKRPNgxDpy5JAbOTjOuX2Jtqi82Kl0LvLLNfuvCu?=
 =?iso-8859-1?Q?2vqK9YJtd9t5l7oxrwC0SXrlYkZfywQbW1N/Gf/xCSkpG6bZVtZKBdSo6W?=
 =?iso-8859-1?Q?YlG6YV74g2P62SozU8XVW0UpGpZ0z6qZkc9RG+ICbbSrzqy/5tvW6xcT3S?=
 =?iso-8859-1?Q?sBng8OgfTLSJLTCSCfCCglus6UfP3SzcsLm3efiR8PV9bdvLphC4KnIDGB?=
 =?iso-8859-1?Q?27wAisteeCjz3s4OEPjsYAEcHhwY6jCM3bAwksAGmpoiBBlu6/9ioLAz9Y?=
 =?iso-8859-1?Q?CAWBZDPUtWHLWM8hFDoTELtCoTXzZpqyBP3zVWT4CMmMTZJy8qA2iyh0rA?=
 =?iso-8859-1?Q?LfVSCJPkcagtHpG624pWw1Fbgq4i8sQd+x3c0jAjXvjBt3zrK1oq55XUBB?=
 =?iso-8859-1?Q?xT03xwwiYRRfBcfqiJE7yWdJmd1sjIGLtZFgovQ983XzV/q2qNTlfk/40U?=
 =?iso-8859-1?Q?tKCGjjRt6bI9aVRfS3T5RR6nvpBKIHpuJw0NRM8UYQ5Kt2Akr+FAUxI6rL?=
 =?iso-8859-1?Q?Zaw1R8E1v/e41MuP+p0QNzxXoMpBdlcltTQiRz4btcssRnYWHIiNr6oTMt?=
 =?iso-8859-1?Q?f00iJev6CtEEL1FsYU5q7/epBMzyMthh7xA7gGZiFfqKMm/ghc0JXgyOum?=
 =?iso-8859-1?Q?gbQOa0+9O4CFImWbNzgZBEcCMQrymMnAidJLv3vMsm8mnNhevooU0SIaSM?=
 =?iso-8859-1?Q?so2HdfMgsPukmbeYtEAQ/Bl//ZRGbKBR5n98tbIx4huai7NdFqUr/KVU0x?=
 =?iso-8859-1?Q?XPCWomw1FUbZ4eGEzZe0B73jonBDwzqz0e1NeywLNMMIB5YV95GsilvMVJ?=
 =?iso-8859-1?Q?8B6Nq/b7nQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e3edfe9-6e32-4b17-3451-08da3c9e1bbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2022 09:24:59.4008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70c55e28-9cd7-4753-937e-c751128a9d38
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P6T0IiguTWdPM9BdHN7VJHqKvV7HM4FzJcnWU20oyk75bXvndaId0R26XP4qtE8MXASzmnW0ac8s9wl+xwn8PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR10MB3094
X-OriginatorOrg: raidix.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The ql_dm_tgt_ex_pct parameter was introduced in commit ead038556f64=0A=
("qla2xxx: Add Dual mode support in the driver"). Then the use of this para=
meter=0A=
was dropped in commit 99e1b683c4be ("scsi: qla2xxx: Add ql2xiniexchg parame=
ter").=0A=
=0A=
Thus, remove ql_dm_tgt_ex_pct since it is no longer used.=0A=
---=0A=
 drivers/scsi/qla2xxx/qla_target.c | 7 -------=0A=
 1 file changed, 7 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_t=
arget.c=0A=
index 6dfcfd8e7337..d03b9223b75e 100644=0A=
--- a/drivers/scsi/qla2xxx/qla_target.c=0A=
+++ b/drivers/scsi/qla2xxx/qla_target.c=0A=
@@ -48,13 +48,6 @@ MODULE_PARM_DESC(qlini_mode,=0A=
 	"when ready "=0A=
 	"\"enabled\" (default) - initiator mode will always stay enabled.");=0A=
 =0A=
-static int ql_dm_tgt_ex_pct =3D 0;=0A=
-module_param(ql_dm_tgt_ex_pct, int, S_IRUGO|S_IWUSR);=0A=
-MODULE_PARM_DESC(ql_dm_tgt_ex_pct,=0A=
-	"For Dual Mode (qlini_mode=3Ddual), this parameter determines "=0A=
-	"the percentage of exchanges/cmds FW will allocate resources "=0A=
-	"for Target mode.");=0A=
-=0A=
 int ql2xuctrlirq =3D 1;=0A=
 module_param(ql2xuctrlirq, int, 0644);=0A=
 MODULE_PARM_DESC(ql2xuctrlirq,=0A=
-- =0A=
2.36.1=
