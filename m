Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3622C2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 238C62244C
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:39:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="a1lJJEiZ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="zo/y/vx+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442436AbgJVAjO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 20:39:14 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:52973 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436466AbgJVAjO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2020 20:39:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1603327154; x=1634863154;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Z5baOU1NMnaQjp7bWlO1SeYgYlOTOQP2Z0HBYcJLrM0=;
  b=a1lJJEiZQA/7jOAz0GywODbHozrJgg2DpKD4DLFMaiDZ2ovp5ypg7g9Z
   cSdB3+lvKZSoEEDx2vE0+8P5SQ6MgCMQFea+UzewCBactr3pR2EbPvZkz
   0X5RSltjpemd2eViwTWjnFkwrW3IPkfJ/Z22otZUtRmJ98g4vC5nFB/x3
   q9vQsLd+yXa/hlP2K8TVky8gebZMiVypm2S07eepEAGt/k82qi4IGOWTi
   PdLDwawZLjU2zzy8x4nLdUEGw4jVB4g1IX8kaSHBIxvtbGbf9Rhcc4ori
   EP+0Su9SsE0PTFrYjhmj5dCTQGg6KwFrgzBrYt5bz7ZuXMyzRYYZL3P9x
   Q==;
IronPort-SDR: VnnJL1RGADPDQD9FkEban999IEkFV/FQVCKNKujkwpS98oSXE4n378w5kqdmlsUm4NMM9dzDLo
 m35UZVP6QGu5/rB8gDktEI8sDLBAgAkEfKazW5X3LzS0CksWCiCeIGW7EaAbyWmqEZGcTnZLmi
 /IzDRLL9cKQOjpnwRmb3Yagcyp1nRl3PVhmZMeAZoR/dL0XC2mN47RRix/aQSf9KL3JJWEPbAR
 XK+H8KKG6oeV6msw3nmezLu7D0oXBN3IgQb2a2PPdynDSydXHkpzJpny6m01y/2n+8xIe9nWtu
 mG8=
X-IronPort-AV: E=Sophos;i="5.77,402,1596470400"; 
   d="scan'208";a="150651482"
Received: from mail-co1nam04lp2054.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.54])
  by ob1.hgst.iphmx.com with ESMTP; 22 Oct 2020 08:39:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TjUYG0V6E27p5yb4Dhws96YW4RAfbZ1cWhLUdKqyrJBFfWaWfoqLDH7+XfZ3/cNL3mnP+QJDW15FRtEF+bui/FC9CmvkDooZ3tVFPLVoSDcvAG22aGSIpfLdcDrzr7x0F/3J5Tm9AB/6jCJQhm58dhGA8a6o2S09trzOAiWtlEz1FNAxOqh9zwCzRYg0geOQvGDLDDgzmRuJPOnN+DSo85qhw+WKGd9bmzYGqx9UTg8e28lt1kalp/HMKxMZEdKzqfrASADJkhthNC5aT/7afwMriqb3LRJk9HFkBAZkEsFCuegkpxy5BKcfiXMY1FVUoozqoOC5Roqb4UBc3AS0Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5baOU1NMnaQjp7bWlO1SeYgYlOTOQP2Z0HBYcJLrM0=;
 b=MTJXtszcXEZjjQJHpMDuU8EWmSPGZWyNyU7ozDZVIwsWHAto+ImtIqQwyIAyYdG2Hh4gipyNIlJcIBwWwjGZFVItpyilWqmqEYnBcD9VySFOxNQpcNpUPIxn+6jiSsy/KvObChkQBbBQCQKQ4eadxJNiMOLaI9obTIdPlXLztqIGFpSBhU3D4c6mjIsJSzJO6xXmUeSX0YzT9OzDWoo0MiSWciaiEgHN5N9nfIGWARSQ7U06ghwBCEK5ePamCCUsZN2y/Aon2pSyVkuhjlJH1SmXcOgS1t87jsOkGM7f2t/FSzfatiCzGRWOydCj//Fpn39Zv9lj4dAo8Emt5tIw9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5baOU1NMnaQjp7bWlO1SeYgYlOTOQP2Z0HBYcJLrM0=;
 b=zo/y/vx+ySpSCYUGRdz1zq25q8gfyChyjPC/CwY8+3mtja2E1ZL5HaDXDBO+rw7LPiH9H99q3P2nR3Pwrz6wI6tX4NEaxd0Pk8RLsJoewHJYtXskvTLTxvZsbeIZTEzjARDvzoAjZrOU9BuiYDeLA/R3OJfT3IRQTgM9cARKoDc=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by SJ0PR04MB7390.namprd04.prod.outlook.com (2603:10b6:a03:293::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 22 Oct
 2020 00:39:12 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::99ae:ab95:7c27:99e4]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::99ae:ab95:7c27:99e4%7]) with mapi id 15.20.3477.029; Thu, 22 Oct 2020
 00:39:12 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 12/17] vhost poll: fix coding style
Thread-Topic: [PATCH 12/17] vhost poll: fix coding style
Thread-Index: AQHWqAtKk6mYtXytw0yA9UfBA2ma0A==
Date:   Thu, 22 Oct 2020 00:39:12 +0000
Message-ID: <BYAPR04MB49654D29552506A024896C32861D0@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-13-git-send-email-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b32a8ce7-915a-45f9-2804-08d87622e555
x-ms-traffictypediagnostic: SJ0PR04MB7390:
x-microsoft-antispam-prvs: <SJ0PR04MB7390881361CB5F4334691D28861D0@SJ0PR04MB7390.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8buyJvz8QREfKX7B0zDkON8XrBQPDL4cZVaC6jSJxbYMFrTDFnIMuSAAd6Kv1n2MZO17Wn2FZ+FOHBjlaTMOXy84ahdzqCSdzm6hTJnLPcLOBg8V5XOR1D9Qr2/AZGJpyHrqvocbAYeD4MSKRxb+nFJiJDoPFReXdxbfoJPP9yceSMXm9PjHBPCHgujACXi9SuWspUSNpn+jGJ7RoPLxNXblrX25Dsn23j5KH+pdc1M9uSdCVT99XiAjB6umJ4YyrMB2VpBCF0q10LjDW6iHTEh2Dri8lLm5Yc02VlaLWQ2btJq2ASc6o+SXItaLSRV7zmiHy2sH1Lw6xVPR/+QmrA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(396003)(136003)(346002)(110136005)(71200400001)(55016002)(186003)(66446008)(76116006)(33656002)(64756008)(66476007)(316002)(66556008)(5660300002)(52536014)(66946007)(8936002)(8676002)(558084003)(9686003)(2906002)(7696005)(478600001)(6506007)(53546011)(86362001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: TlZzJ8XKn7RnXMYreAgWMjnrzAdJU/5k4XpcYFyTcjn4W/IQcYMBLBtycq/PynGq/ZEPxJlBKTJxxQcp0dk5VK2fTlgMvUSWa7Qi+pkhVry9JBD6Ti6VDAAvtcsgrBJgQ9te48UHbWQGM2ZR3YxP9g88Pa+bvwSMrun4SWwBwjt4itbgd/sqW1RS4rp4WmOFmP6pzTx3rCbu0UzGd+2E6aeYCF/gNLhhG2N/W82nSmZ84gv4f/Vham9fld5omUs6rcwRXYz6kT5AAnIAZw3lxjLXWi/YI8Z7F+9H570p8l/1Jo9HU48KOTUpYrbo58XiGcG/MYMPlrMalNREpzwj/cYc0GJvI0P87SEJjyd+KBZiJGqoqTUfvZJidmAv2fGsmkh/YOxezxdJttY/iIq3kkjrAxYQ3anHMPom/0Kc0UoQ02MkSBuWrlkAcVr2a0XEJ/WTjh8PwMpzEv1UIi8g0v1o30sj7AB1m6OCNDWURw4tj3s/Gm+wM0ppBEOydbTShyLztbbXFosAw5Ab2HgHQoEiF1TuCFbd8Z8p+pRB731C8Hw5bSMmIFbhFOxGTdzrMMkql+XZINmT9J3IrEIz2y9nO4NObCYZIjAoG0woumgpo7dYZtTQMSlVkqOz+DgqLf5pyqC9FfIcHv9tRTm/hQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b32a8ce7-915a-45f9-2804-08d87622e555
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2020 00:39:12.0644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4f+dCTWOfssjvpFr12mIjseRtsiH0OnekyAKLI2vOY9u1rvf/iRQYgbuztBzzEqHuRi2XbNDJupWggIwJ6Iz022acM8xPnksc4OFHH4sFfg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7390
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/21/20 17:35, Mike Christie wrote:=0A=
> We use like 3 coding styles in this struct. Switch to just tabs.=0A=
>=0A=
> Signed-off-by: Mike Christie <michael.christie@oracle.com>=0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
