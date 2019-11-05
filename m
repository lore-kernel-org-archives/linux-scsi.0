Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FB5EC47E49
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 05:08:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46AEE214B2
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 05:08:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oOitjuo3";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="RMQYRlgh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfKEFIw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 00:08:52 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:30024 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfKEFIw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 00:08:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572930532; x=1604466532;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=bvdHav/Jqon5hb8xotV+R4yFqJkb3f02isZtqC1SnNc=;
  b=oOitjuo3/kiIjRO5yZxyxvfRCyvWOHm+Lv6bCBDQRPFVJE7jxATmcX9q
   Gv+yikRf3jFD3RcoKor8FINq9Q+Xf6mmnn6dtC4NG9AeK9LGPsuTjrWh5
   hx9I8FmnskHvb2Ga/FSxeasFpqWavbisNbeia91uQ0IEK9I8uCZfWxJ39
   dHGT/6Do0DBtMGPOZF6vta7So3VHbN1MHRk11dbIe4qFY7ervmXfndlTd
   xllZEDKlinRbZrw9dUhvj9ikiOCw3jaZQ6J9pJyMcFxnA0iWZwkTIG0N/
   tFMHHuJIHv5y0hd4+nZfltXtzDlfVobVs+tztTIOInHS6uy///zmmNTmE
   Q==;
IronPort-SDR: 8jABEnZvoT/eli272uBmoEVZQOVxsfL3Tlx1rZtjAEArgk/E8sdLTT4csK5KMOZF9dUQ4xfon1
 hIiwDgcipl/5We22EtsCgX7kvOjAg2EHc2wCUO381zVgBMQ45/3kCUO+uTglVN5lWm7t7UfyDx
 wEGCRsMefQIP+ev4q/DODUtnenAtarcturJsx/I4vVEYm9fhe87EUuHJ8+JSgJKpK/KjOzB0cO
 Go1D79E1CR6cXlUCxMeGsA9BiucPfzJrF9YevYHpuGCFdmUsTuQ52z8X2YmrElysnJ8PuP8u7m
 SXg=
X-IronPort-AV: E=Sophos;i="5.68,270,1569254400"; 
   d="scan'208";a="123733967"
Received: from mail-co1nam03lp2050.outbound.protection.outlook.com (HELO NAM03-CO1-obe.outbound.protection.outlook.com) ([104.47.40.50])
  by ob1.hgst.iphmx.com with ESMTP; 05 Nov 2019 13:08:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yznbz8M+rjagfMyirZ5dFNNfjpkpdFdV3lYCJgLYHREdvuRjcRCQQiAglkFcvbfY1p6NCY+rpe2YHde47e20HCK0yhRFaqeP4WzGwlaslOoDeYObfgJEh3aeZtVSggUjneGw3imxWnuLFdwbhnKasQiWPEOsmlumLcGqaiQjjkLSGZUzBI/hZjBUcc9Qye3RkOh88Uul+dHbC9eQ0WBB6mOiLq+pJKZ8brZGYmoowkXNwn6MNHencsRIiojmDWa4rffGmMJB+3wfqei1JpyHFUnqsxXJYawILg5M3Oes4kdtRu7oXM48XnjfxvbPn3bh4vAlYvajAUwEAr4o4cvHzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bvdHav/Jqon5hb8xotV+R4yFqJkb3f02isZtqC1SnNc=;
 b=ZZddflgeq70ODj3QgHYjaY8Cf0e2u21yzOYL0RriRElEZy21pYhwWbCDT3F1xT0B4bMyBdwrNkovMttl32pk4wFpFK/OboH1olhNefweyXcebBFc/8LDUsqX98LuDyCJLXX6TK4C9ExKdk5f0TJEbmYa2GhaA5NxzV2TeiMG2buJvRYO0KUtd+ZMoW2tGgjHScmmpEw5YZxgc6PBz4NqFLrtaFBv7BXADvlllePIKGbrbld4EhzoZhK8Lw1rX9SDJ6LfHrcbrz7eEF7JqbF4h3n2eyqrj2fo9zv8jj1i9a0vavOAzZGb70sv8X18bkEq1RFuK2NVwhg9V/OTOteNYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bvdHav/Jqon5hb8xotV+R4yFqJkb3f02isZtqC1SnNc=;
 b=RMQYRlghAAJ8NvbdIjHuqF1GLcZrkdr6AqXkQ1RZQEhXyeQHC49XdwF2S1XXKvW4tG/YL1iZdboX+oUMEReOQqRY3ITil0JXZqYZ9uI9euk9DXZZ8xMC3SqvHPDfos8LM1Vtw2y7/KiXtRLBuPMoXECSmgWD6E4faRYxq5T1VyA=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB5126.namprd04.prod.outlook.com (52.135.234.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 05:08:33 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40%7]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 05:08:33 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Ajay Joshi <Ajay.Joshi@wdc.com>,
        Matias Bjorling <Matias.Bjorling@wdc.com>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 0/8] Zone management commands support
Thread-Topic: [PATCH 0/8] Zone management commands support
Thread-Index: AQHVjM+oAfCMB+wY1ka3IBKYRZIZ0Q==
Date:   Tue, 5 Nov 2019 05:08:33 +0000
Message-ID: <BYAPR04MB58164F042DA0D67A3FC21686E77E0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
 <926948c1-d9a0-4156-4639-bbac1d0ba10b@kernel.dk>
 <BYAPR04MB5816539DCBED2D2C93254D36E77C0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <yq1r22n3ozf.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 440b03a1-960a-443a-b387-08d761ae34de
x-ms-traffictypediagnostic: BYAPR04MB5126:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB5126E00E040999E87E05E9D6E77E0@BYAPR04MB5126.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(199004)(189003)(8936002)(71190400001)(446003)(2906002)(76176011)(305945005)(476003)(229853002)(53546011)(6436002)(4326008)(55016002)(7696005)(558084003)(3846002)(486006)(6116002)(54906003)(6506007)(74316002)(33656002)(316002)(9686003)(6246003)(25786009)(6916009)(66066001)(26005)(186003)(256004)(71200400001)(99286004)(102836004)(7736002)(66446008)(66556008)(66476007)(91956017)(64756008)(478600001)(14454004)(66946007)(76116006)(5660300002)(81166006)(52536014)(81156014)(8676002)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5126;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nBc3sxM1DUQJPVH/rN1WNIUDd/1W4xrl8rsc2KDFD4JrwusBntCchfvFhkWCjjmtQuRy/8VTAFoAajYrMknYoZVBDpRo/FZCTD/SPajN3+vA7M54mMgnVCU5F7lGn2OSVbIIxx7e9N+OH4gdeNk7AZX2Bmw7papzGPo06mwIa06XQP7EERhLc2hdlaNwYnpiQ8l8c7iK8MJgEB/5UrCWLpbErJhwwuX/MX6rBAXaUOreUFfGDdQJmoWXjiHWT/GHOjn4BMn+ZaPxO3lBUvbO5DWWSQE755R78k38zlWFzhDxPoR+ekPASQjyVrUiI5wc4Zc66o//p7/vJq2MfsWZUQPgdzvWM+r8z1Duro8HNDKS5C9ElYLy8Jt+Cj0pFkeInInOEgBbjF5f6hQKXcKAsa1ifBpBlsegOUmHS7TyxvNvNl5iB9cq/lcsSQKpn9Ib
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 440b03a1-960a-443a-b387-08d761ae34de
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 05:08:33.3989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bExQhkTvdTcnDvjOC9Mjkp7q7csP1JzhdyRFQsW1ZVnI+iar04zpqnHZQR85IRuD+tF0wF4CYbiOb1rdAu/6Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5126
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/11/05 13:53, Martin K. Petersen wrote:=0A=
> =0A=
> Damien,=0A=
> =0A=
>> Can you take patch 3 now ?=0A=
> =0A=
> Yep. Applied to 5.4/scsi-fixes.=0A=
=0A=
Thanks !=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
