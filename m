Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C37A7C55186
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 04:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F35020776
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 04:16:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JLq5qanH";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="k1xFvgTO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgDXEQf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 00:16:35 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:65254 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgDXEQe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2020 00:16:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587701794; x=1619237794;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=j2QZ1uMFzf5ozHdOGcqmw6yu3MR0R9kI4g0ZZnxCJvg=;
  b=JLq5qanH5SjN8GUlcDGTCxcm1ZPyv5OPx4JRuwVRC0779O5VzuYkmd5H
   L/xr8ZQWHc2CMHxuEzZ+4RKNLne+ekB6bqLLCMNchLQcSwZ24cl7REPNn
   bPY+7Py+kTv/7fvPNl6YvLlpFuaoIAvZcMlit92lZHcxulJ+W0awD6cX9
   vhUrmNUGkiFbe0Id6x3GhM2vqRPX9WbHThayge18j5BzWUJTTE04AR16H
   iLtqLJ2+LDBQITrAighV+MevXg597RVffcmjHVBGFivlSSQ1cnRq6+J7l
   ngpSh4r4trzKdK7nWzkuvzV0fjuLhIai6/0VyAUC5RROej8hK1X2GkAuK
   A==;
IronPort-SDR: gCDKEzKDm9jJDDrlebbumily6CO2JR59k8pNEBSL2qstarnA/MMqq7cMKR6ZAUqMKt74p/pbnW
 UWL8oJVTtoaQJ5XXy4Ly4MecQh0bilq9vbiAYXlR/ZPlh6VNJCeM93wDVhHxG8Cv2eGGgoBz09
 zIz8QX5LwL0cCXEOxUZQLaxzmtkBhAMKsAtBo2XDn5NRm4ul50dt2L7zR8Yrtwk/pykxcntD+Z
 GBeupKQvXF7/l28CmjcXWezZnzRc6DSlU7+46Hpx8Rj2la1/uZDJWaLX+6nzU2CtDPL4OOecjT
 o2Q=
X-IronPort-AV: E=Sophos;i="5.73,310,1583164800"; 
   d="scan'208";a="136352315"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 24 Apr 2020 12:16:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CmByAh382kGxjxftUMNOpZfuRhUUJ8nu2AyIxVKjmK/3jhirtGgusPvEYgn6KHPJyG8Tn6xBpcdmZvihlENI29YSHGYURTHFZ0tSUhyZSb+/F6uWrK5dOF3M0ueMbxTWQebKDZK2ZC+NnSm9+3WJSJxm4tDkTYcEfaVtwcXwTV7lzCyySrJ8rcn7w/aN7qgF/aVsdAig2OEu23gDQH9KBI1qNBKjl1N0DMKuAuRSak0/o+aVLvtwivdjNlwtZ62UgAMhfN2fo6vmR5lMAkgYu8cpgcfpN4GQ7JwXufoCz3mWE5nDMQwbDanPnwiK2QU1bcESRhYgGK+1nqvu6j2G3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PPfw4i9tqHMNDJ50PWMr0ovofH/pNwNVZQNiEr4LXsA=;
 b=Q8/h0WzJiWng4RvAKAbM+RJjMjxvLQemm0SQ75NEGAi26ehOm5K49uybDunEeJ0qVpDSoHXuZZou8LxvNl6pZ/6eEjI1e10N8RLms6bSEUZyx4irgXuAdhjdh60I9O8P/s69yb5GEcyMDpq4181I9xy7JLQ0IdnS3izazLhSpQN6lFf3oFzCFamAWmIcOPPpqI3+6iGlavQpHXgEX+HrFDzAmWTUl1KKxWgiKqHGlWN2y0eYtKQsA+0T6lEUWAJNgBkbkMBOPjQlPTCrigLlZnUCmxEAOsERiQdfsylsYKKKA/J6/I2Vyf26sz7PDWqTN3cm7qYR90U5fal6xG6MtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PPfw4i9tqHMNDJ50PWMr0ovofH/pNwNVZQNiEr4LXsA=;
 b=k1xFvgTOj/a7tjpR8G7qmPGxcxtqg4eVFE938+N1Y6dR6zl7qBN7yxgsDnlQW8bZJTL+hP8pzIZgE4pQwVUNdE3wdUZ+tgMW3N3ctdUrPZOxhc2La4FkENFrK3WegxQ2Lhx6RU+TSwAAa69qt0RtG5KdeerNH81gGGUUktB+MLU=
Received: from DM6PR04MB4972.namprd04.prod.outlook.com (2603:10b6:5:fc::10) by
 DM6PR04MB4060.namprd04.prod.outlook.com (2603:10b6:5:af::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.29; Fri, 24 Apr 2020 04:16:31 +0000
Received: from DM6PR04MB4972.namprd04.prod.outlook.com
 ([fe80::6c49:dd56:97c3:3ae]) by DM6PR04MB4972.namprd04.prod.outlook.com
 ([fe80::6c49:dd56:97c3:3ae%6]) with mapi id 15.20.2937.020; Fri, 24 Apr 2020
 04:16:31 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Hou Pu <houpu@bytedance.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "mchristi@redhat.com" <mchristi@redhat.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] iscsi-target: Fix inconsistent debug message in
 __iscsi_target_sk_check_close
Thread-Topic: [PATCH v2 2/2] iscsi-target: Fix inconsistent debug message in
 __iscsi_target_sk_check_close
Thread-Index: AQHWGezBdMQBK8Z0fE2P6bUz6hjIkw==
Date:   Fri, 24 Apr 2020 04:16:30 +0000
Message-ID: <DM6PR04MB4972B3BE33D83FE7BA78570986D00@DM6PR04MB4972.namprd04.prod.outlook.com>
References: <20200424035843.5914-1-houpu@bytedance.com>
 <20200424035843.5914-3-houpu@bytedance.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b359db47-8d36-4745-37e8-08d7e8064455
x-ms-traffictypediagnostic: DM6PR04MB4060:
x-microsoft-antispam-prvs: <DM6PR04MB4060CD685D3B199A90D36AC086D00@DM6PR04MB4060.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:454;
x-forefront-prvs: 03838E948C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4972.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(6506007)(9686003)(71200400001)(4744005)(5660300002)(86362001)(66476007)(33656002)(91956017)(64756008)(66946007)(76116006)(66446008)(66556008)(110136005)(55016002)(54906003)(52536014)(186003)(478600001)(2906002)(53546011)(7696005)(26005)(4326008)(8676002)(81156014)(8936002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ApDXNznNFHmO1b5A29gHuRpBBN0WNzHOvEm4dPs3wXEeevxeDVAIsRdFLk98uyU25J5PJ2ruDd/pmcz8Ao26P5Tn8tASpqs6xgtIVM0UrHx3/EzVzdFCriceEwhyZxor3OEJR/gabA7dOq878v9wR/1UBDJm63xVmtea7Tf7Pwrq7V4i/lqZTORPMUUAGylw0VIjV41uQx9+eyQNpZe38Rgqpv47zMtjzxbbo3Nq+9WZaXic4bwsUq43OndoxiGbcs3D8TnXXrmkN6wgG6tPcvJ5A4aY2bPPIWMF9rAm8nZimPK91Xvgs45+6HD5/IbmT07x2YoJQEq6hQ/5C2QdTwfZxH6sKJKIqkxrFeq24fawOs1hxMMcHeRvRoXKOcrv3/U0ej/dOBOqhur7pazwSxH2JeZbVdf/sGn3RG/n7VV6EttqbqS9B7CqcoR80C9t
x-ms-exchange-antispam-messagedata: vFlqkm41BJ61muLYp/M1R0UJSRAhAHChrGyyS0DDiyc9wioZUv7vBfT+q33fJ/1q2gCuzCNRGhjWAudfUw4g/WP2wXEGcxng364SozVD7sNJLUhTV3BrjvVNlHIxgAbEv18KpTM4MjRbXAETNrrR7HFVxgvUQYU1yUhpt7ZsXkDb0Zw4mXhcHOYTIdGL3z4ElKvrhJaJ1taN78ELS8SOyk8Ss1p95UwnjzexSGGuqaw+phHPpc5st9fDqLuBYinf7GjF48kND0lvpFzEULKhFVoGJUZTVId49fTcPwXApWnn2N6/ZtWL9zxPKhZDO2ZIKADchVX17VLGW4GXwKtRE0ts07y113jeZMaOpksTfLzhucoh1ttOSsKaD4A1Q0BKWrHqmyqtczPc5RNEW+jx6OLL876dTy0PnXAZ8k3EKdo9dvXubJe8f1CWeJ5eekH4b+WzPRGZJmHvlzxQNqAILxub6DDoPEjuxJRS6O5yiWBcsXZ5kVE/yo6WEjyy8P8VINVXbn42r+huIwXL8emkrIQ1f2hxIdryMEB6AmqWrZaVC5EFfgTen7IojfZKHPZCfm/fOJzzmJYX3dSXpmBV8r65h6k5Q2p7ghYzcdprGKzI98BO+07+D/VW46VnxaFWhV14vkCPnPtsaENZ6vcv8M+DqMo+e4uOCNxIyZO51RV3DmYko3azv/0hdEDAkXZFYPe9IBRHMpKpDznSl8uZDgeflOvHGDr1IIubABBOeFuHcmCMj2acSzjrGQTwrXisWGd82tb9yFh1XMp/yJilJVvSmXbHBlWkK//3q3rhA7A=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b359db47-8d36-4745-37e8-08d7e8064455
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2020 04:16:30.9238
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FfHk6oB+DgEYWfy2UufkNqsYuxpYx5XvUThmFSKSap+gBjFYWw2ksCnnIEpZu2L77z8CDI11L2cFGw2R+uoT2y2+6JB7qdaWTuKIEM07r6A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4060
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ho=0A=
=0A=
On 04/23/2020 08:59 PM, Hou Pu wrote:=0A=
> commit 25cdda95fda78d22d44157da15aa7ea34be3c804=0A=
> Author: Nicholas Bellinger<nab@linux-iscsi.org>=0A=
> Date:   Wed May 24 21:47:09 2017 -0700=0A=
>=0A=
>      iscsi-target: Fix initial login PDU asynchronous socket close OOPs=
=0A=
=0A=
Thanks for the patch.=0A=
=0A=
Did you get a chance to run checkpatch.pl on this patch ?=0A=
