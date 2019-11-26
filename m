Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC8F1C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 07:13:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF9CF2075C
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 07:13:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="o4S9XYPy";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ZagN4TUu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfKZHNa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 02:13:30 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:43514 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfKZHN3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2019 02:13:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1574752409; x=1606288409;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6mOp3Nip0HYGSjxXiyMALRUvA2vW1VgRgJRcLm79V2Q=;
  b=o4S9XYPyFXmNAmTim7JcU0B6DtM5+rnTCDFNS4AKdXr3q4RydKoNCchR
   r8okjvb8VPa/ZVi57bbFc8LsLX3yoXa0svSZqii9N7OsZN03rz5GbQAKq
   MdOWXZyQ9fALNN1vYbVnpk1KCYvry62tRaAX5feqCz0HJIwsCtna+RXQQ
   QwXW+D94+avJqQ7jHDvdhFIPIbxES9itK6YpihcO5keesdxqhOg5GReLc
   rAIjBzgrVOAovb8KiFn7e8wv4BkNAfzNsfNhoQWPdHeFrsf8+tuHzW36m
   tFbIhKpxbgRrLd/DFXFD7cjIMTr5Nf2o2ywVtqci/i/38nvbTmOi58EV0
   w==;
IronPort-SDR: UGi7O9HV093dMxoAbUrWELkfSfPtgkKTLUeQ1Uy6aFsTtT5+GMUgjDClndBh/H6BJy0CXVZy8x
 F9ZEttu2Q8g1l98tFphSo6F1sb1Sv4umMsUp+vyo9iXCv5boxrRpv8OwInMHNNz6Got3h7MHI5
 wrDAUI8lMJKqwBNYLvw0+SMA0AW9Ynsch00C/6VU7/tPwyqqf0Jjw4jo7VoZvO7B9xxlyQMzD5
 D4j0NWw5eeW+w1hFyKQa1Im1s1jbUJQkn+SxlNo7GHsI6CsxIUb7PArl9qA6pzW3DonWYlP86C
 CA0=
X-IronPort-AV: E=Sophos;i="5.69,244,1571673600"; 
   d="scan'208";a="124773998"
Received: from mail-bn3nam01lp2050.outbound.protection.outlook.com (HELO NAM01-BN3-obe.outbound.protection.outlook.com) ([104.47.33.50])
  by ob1.hgst.iphmx.com with ESMTP; 26 Nov 2019 15:13:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTiChX8CSgmemScWmuPHvV0DiTbd6zNwL1O8mB/zZZuaCuGKVsJuZm/fJb0KzCVh6sC9naC1SAaUwSwFfdx6w+ZESlaJRjFp35HaEXxTguGBwmDI54KZxhwSgbL7kSz4IeOQ6G7/PIGKd0SbuBlQiFRKsNThM6FhPwXFXSDZ6t9bm1UuE9vyx2FqA1pgcxmUxxB5ACny7jXyRDy8ILFmpHqp/MtdvrUDTAw390pttHIaWHtgGM2oNtrQbC/tgHR2otL1fFQxZTOd6kDk1O+gRaQnJ+8qJ72TRtT6NlCSXRfBGPCiphdva/w4NxXJsZ+JJhC8na/R4inCy6ZTMXjHqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mOp3Nip0HYGSjxXiyMALRUvA2vW1VgRgJRcLm79V2Q=;
 b=nCcNYJvkTqF6otDuUy1vGh79KR6MAlgyMgrSXs87+Vj4JIejD93b4rllvQ4fQ+ahfqznGyvXalkw2vLG9eEnsZlcLjOPe+2AT/KHJv7Q4sD9zgBWpndrt9tGldQwxWS8Krokwwq04lrlaYp425YK9hsFHlDH2tMrPHGRNG2RDw9JGh9jytQPyJv/6sk7PrzAWc2ZrXB+0vXATOlkDg+Og+V9euAn5gFIE4RZtHuUUAozY+ix0y0EZjXWP7U7Lh8FP1/LW0C1raaI8SsAHNOUo0ZNg61gVT9lnGRnskVG+5tjxioeKHGzm3pv4XlFp+EA/8nfK5BjyFQfxjvuCE87LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mOp3Nip0HYGSjxXiyMALRUvA2vW1VgRgJRcLm79V2Q=;
 b=ZagN4TUuv2eAYptrS+Bo7In/RNnyELsbq/QngbMyKTlEwc8IS1c5UgO7qoCIJpi/y4nkQDgMVtxsVa1TmuEBesoE7keEiakfYSbM4SF6cogrKnbBMobFKhe7INx3kcW/odCmatMds+9+341YIdgimWZJ0ZR2Opq/fbZ34SWVYbI=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5869.namprd04.prod.outlook.com (20.178.255.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Tue, 26 Nov 2019 07:13:24 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2474.023; Tue, 26 Nov 2019
 07:13:24 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@qti.qualcomm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 2/4] scsi: ufs: Update VCCQ2 and VCCQ min/max voltage
 hard codes
Thread-Topic: [PATCH v3 2/4] scsi: ufs: Update VCCQ2 and VCCQ min/max voltage
 hard codes
Thread-Index: AQHVpCZIZTJgFdv/r0O4vZ8y+z7ltKedCXxg
Date:   Tue, 26 Nov 2019 07:13:24 +0000
Message-ID: <MN2PR04MB6991F3919641BB0F60BAA03CFC450@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1574751214-8321-1-git-send-email-cang@qti.qualcomm.com>
 <1574751214-8321-3-git-send-email-cang@qti.qualcomm.com>
In-Reply-To: <1574751214-8321-3-git-send-email-cang@qti.qualcomm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ea55dbc4-4b14-4730-9cb4-08d77240207f
x-ms-traffictypediagnostic: MN2PR04MB5869:
x-microsoft-antispam-prvs: <MN2PR04MB5869A8DAACA72659114BBB14FC450@MN2PR04MB5869.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0233768B38
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(189003)(199004)(4744005)(66066001)(4326008)(6246003)(9686003)(54906003)(25786009)(55016002)(5660300002)(8936002)(86362001)(110136005)(2501003)(14454004)(14444005)(99286004)(7416002)(256004)(316002)(305945005)(186003)(2201001)(66946007)(11346002)(81166006)(2906002)(446003)(76176011)(66446008)(64756008)(66556008)(66476007)(52536014)(8676002)(6116002)(229853002)(3846002)(478600001)(33656002)(81156014)(102836004)(7696005)(74316002)(6506007)(6436002)(71200400001)(26005)(71190400001)(76116006)(7736002)(15650500001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5869;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: icwhcg4+sSP1WRYYqUNts6W/OGD7r3/TNMn7z4MgLHW8EjwZ6t0jjspbNmFiDdeBQVBxb9B8TD07e/vML9CBeakCauPshWCFeWR+gCbKok6u65we9/2Chvsu/RZfSLi5yM7Al8jew9UIc4R5HZfcaYlGx8wMXFcoY3yycA5VfLz4XVHyu9Fhzld+c0t6yvuGkFvy193xp4QYfB6jPkvPduDqV0PZCrl//od2PreM0zx68fBQJISq+XExKvYLXhJH9DY/z0mkU/OS7vLLEgX+E8W91fcIkw+mrIiMpJUcuXVTuxpAiIJF1eprZ8h2INEOxRp+dXIjSY7tE6n/0c0Txb7HPyCRnT1/IAKbT0quBrYb54Inhtc//PNgNcMa1XZKHIEy4gasxjbG08ksSyjV1sLviJFSWnw6T+aVPtBLRI8fAIMm8W+lVvMZxoJAMVl1
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea55dbc4-4b14-4730-9cb4-08d77240207f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2019 07:13:24.4195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AlAYh/hi9OpAJhbUov8JrOYJUM8XhjyUGA4jNxw7Xp4056Eh9ogZMNIG6f3syxulxD0OVyy6wep2rQHtRBhWcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5869
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> From: Can Guo <cang@codeaurora.org>
>=20
> Per UFS 3.0 JEDEC standard, the VCCQ2 min voltage is 1.7v and the VCCQ
> voltage range is 1.14v ~ 1.26v. Update their hard codes accordingly to ma=
ke
> sure they work in a safe range compliant for ver 1.0/1.1/2.0/2.1/3.0 UFS
> devices.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by Avri Altman <avri.altman@wdc.com>
