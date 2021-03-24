Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81ED7C433C1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 18:38:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 581AC61A25
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 18:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237471AbhCXShw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:37:52 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:26363 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237181AbhCXShp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 14:37:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616611067; x=1648147067;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qac98krGbLr8jFZy1EBqQeq5HKqbFc8dK2iKkfQT77w=;
  b=mnDzkANvw5aqu9EX1QRCKE6Vf8smAlMfVjCJEYUEzWkhIhLupdt3OMU0
   56bGlSHC6ZKn14Obt2kfrAO/n7h24Obye6X4ttkUtytGADbFk6Y7yui69
   SF8d7T2rc1yrcOU3JE8MaX6FwyPXd1Yqmm0ux36TYTGeS4tRTPaoV5zu9
   Vy2Dkl+SdD7/1nBODqYZFdWBs3U4LiU+7Kb2+dLMZKKXYmgodkabpyOFh
   ZoCwDapbqppHOuhsyvFF3vXppsc/hi5yYiqZvXjCiSwrDPMJcin5PNQ6x
   l3VkoGtaRD5rqKJY2MwJNhUUGly/RFEpo10+2bnlkegxrR9+hz6vw29eh
   Q==;
IronPort-SDR: plwDcCOczkxyjBXDzxI0ZNcx7wTGeuJc0978UyfZYUz9iz5Vo2ZVvh5QPBdo9xG2F/M+SxRVdE
 X8sFCVf/9hGHTfFWTWyCSDhkVpjTn5Sgw+bNuVn3ATXvO5WubXo5P6ouT1fOjiwdRlsVozG6OK
 YpETKnU7ZOwQfgtj3Jk+r1dIzA3o2CAMRH4Lm4Uw+2Cfv4dM7/7Jo4ek4XKqJh1E/EIab9UDNO
 nXz1HCOxFh+b43rL37wO8Nj43wi3JlM8+3TYD7TGJ0PRQ949FCIgy1MMULwpv7SCsdJBnsX0Ti
 y9k=
X-IronPort-AV: E=Sophos;i="5.81,275,1610434800"; 
   d="scan'208";a="114011906"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Mar 2021 11:37:46 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 24 Mar 2021 11:37:45 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2 via Frontend
 Transport; Wed, 24 Mar 2021 11:37:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZtxD3n3fx9e1LiCEGSz/rj8uRG4dU0ERQE2V2FZfoW+MFIOOkOquE/fyrAKGz0uIP4tVLS5dYuZVwyNW2GMq4TaFTtLlQrUD9n6131MqDuN8LIqrxQRguawBM8i247NQfZdIqMiprkUgGKvb2bgsPWrjQTyxuYj/bn/lJRPPjMS3dHPq1wGhwvb5kSRAQVFM+5WdxX38tyoH0OcYiIg/q/zAguQ3VF6JH7y+WZDKYos+6+aWYFxbBoYikBtKv8i8uK1TDalfGJBG/KEi50PbH3W6L2XY3dEMVIBi262dvRw2CAH74aBIxLtHmHq+Jin+VnlZhlX101vGUukQ2VPO2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94lIOSb1OKk/rST3m7500dXzNppX6LOY/V9H/JB7P5Q=;
 b=OjI9bAHE0DI9knbjqjKAb2cGqlgB4VGY6s+ULRMlKhICxHTtw46dDe+XCWdPkO9pPYM9dd1pj9uBVRfnFZOEQRIGf1H2mgQyM46anXfnO1AD84CszAZr4LemwPNziZIraOah9YQi38BTR4iAhRbdzlZJbXgeQ+oeVb8c5SN7FPInV3MFpqcWyDqDG8EV7OD6ACXuOdJxY42yz+GbBaqntFXjm/1ZSv83AvUDYKYAyGcsF18MkoU03lSqfYJ3bx88ihGHcZoMvjsXBdWcSH3ssDvsSTKyeeaUX6lr0snuiRqmaIxq3Vm/WhLsk7yCRtM1xqvcu1tsyveT9ryL3W67Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94lIOSb1OKk/rST3m7500dXzNppX6LOY/V9H/JB7P5Q=;
 b=O3gnXFu0N6UUs49ELV/vYJoRpeL/Doih/cCZ5qUea94+8eYnka60hcQuqPZE+/swoSk2ZbsB4cOVr9BRNnU8VPA2ZgO9tbIbK4AOe5Q7ECi2tjI1GCJqE/J3Mqw91GkEEfWXoD4m3qmpVQCNqR71qrQK3IhEgJvpQF5jcZEf2tY=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA2PR11MB5017.namprd11.prod.outlook.com (2603:10b6:806:11e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 24 Mar
 2021 18:37:43 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::a002:6253:12fe:2d2e]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::a002:6253:12fe:2d2e%5]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 18:37:42 +0000
From:   <Don.Brace@microchip.com>
To:     <slyfox@gentoo.org>, <linux-kernel@vger.kernel.org>
CC:     <linux-ia64@vger.kernel.org>, <storagedev@microchip.com>,
        <linux-scsi@vger.kernel.org>, <jszczype@redhat.com>,
        <Scott.Benesh@microchip.com>, <Scott.Teel@microchip.com>,
        <thenzl@redhat.com>, <martin.petersen@oracle.com>,
        <glaubitz@physik.fu-berlin.de>
Subject: RE: [PATCH] hpsa: fix boot on ia64 (atomic_t alignment)
Thread-Topic: [PATCH] hpsa: fix boot on ia64 (atomic_t alignment)
Thread-Index: AQHXF4722AqRbCqQukSHQNjL/VV846qTikpA
Date:   Wed, 24 Mar 2021 18:37:42 +0000
Message-ID: <SN6PR11MB2848C136F6CB4EA66D42FFAEE1639@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <5532f9ab-7555-d51b-f4d5-f9b72a61f248@redhat.com>
 <20210312222718.4117508-1-slyfox@gentoo.org>
In-Reply-To: <20210312222718.4117508-1-slyfox@gentoo.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gentoo.org; dkim=none (message not signed)
 header.d=none;gentoo.org; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1a84527a-da55-4042-ab69-08d8eef3e91c
x-ms-traffictypediagnostic: SA2PR11MB5017:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB5017CBB98C97E8F470EE2346E1639@SA2PR11MB5017.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cKrdQKxZ30laKkLHyoIThbNsAjSivumReSXSKwelM5GTgtiOEERruerMv/oFEdytnjQmEHiz+wk48xBPvy7nLSqSAU+7WQWW1zrFdL+Q46xQo4mw/qwHxdSwcsstFTV303rLonAGB/x5STie3wATjILoZJ0Mz0T/Mchw7SZnMv3Y2nS8SVwm3De2zZA16eGdg5syHjONw4oXAL0dPN+FpwWosZIto+v3cH3llrmbwoDvSsZ0kDI8RkDWv3uMc5voL14hsfI3qtYqTvVR5srsKZ85oTxDPLU2WmisEeyajYdNzFxzOqPtFGj9JYEwjMsrJrP0/woVVFLTIX6WN5+B8RNSKLwjNxuCXXql+5tdz985p2gIUs8DxfSnGZQjdxHuuTOjxF+fGTVsjFGcOQlz5Q5ESqboRQ0LHOAGsanspo9VblKQUphErGZoJaZkyA5LREyOl/PTfuFOgL5EpW7XPkl5xn11bTWP2aK6CH66qEvZXXTpIA1DgiaGXtuLGv/B4Qq/OcIEhgxEqGJOAw83NXWPeOOExmbGqM7uLAujWz5dzWaZdkGy9LIVcAklRO0/6DrzXYW8xrqL+UgxU6bAFjlIxhGnExnSyNuRF+xZ3801XaIhizoquOBOgaV5K6mU5jtF+qOj9CYgHRvAB7ru2y3cCGkek+B2SOFQwpBNgYg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(136003)(376002)(6506007)(8936002)(8676002)(478600001)(7696005)(4326008)(54906003)(110136005)(316002)(38100700001)(86362001)(33656002)(26005)(66556008)(66946007)(66446008)(2906002)(71200400001)(9686003)(76116006)(55016002)(64756008)(5660300002)(83380400001)(52536014)(66476007)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?KQQnAwb/yWDJT/MWL6hWD4LslDOakwtcLigRxfj9sVUv4kuKak+7M2YqAr4h?=
 =?us-ascii?Q?hbxfERaGhh+7GFs31n67uE5EwmHGwJpgdoZAOKVOGrZaIMiMzNrgVreLrxu0?=
 =?us-ascii?Q?4jgeU6fkpeK9mb1YeCv4KeFKb42ua+S+gYBDkFbeJZ4jyPme7fMBIo0d1cKD?=
 =?us-ascii?Q?YD6kk+dvREtJmVJlH2iRDwrZmKO8F44A+qyp+BT9smPW5wspJ7U4TF0LrlM2?=
 =?us-ascii?Q?0ZM80IZ/gf8x21+H5vDhV/DezaWRXNgqyjh87qp9MfR4DfMRHB7QssFeDi0p?=
 =?us-ascii?Q?Kt0a7cnmV2QclnxdN/ZYCwPfckwjzvWLwwOxgjNsuqxnp1rBYu4etmnnhoZ7?=
 =?us-ascii?Q?kSvI+Hpeo+XdzVVI1H3QCy/s03P9js6KlP8UCpJM/NyR6ZJWiYn4T2G3wZCN?=
 =?us-ascii?Q?xDEsWNtNNIulM/zvlXymmYrQ6tJ3aCj5MBHSbCc5RxT6flDwvhwlKBUDE0Mo?=
 =?us-ascii?Q?uaxeoBoyML4dCw5drdSuZeaxtKgNzlU4ETrrxk0TUQm9f5+kvPaktCMa0UhB?=
 =?us-ascii?Q?iGhMQOSMIlvtVVValu5coA0gzPy/oBPEt0fpjVhP98EYiV7URUHD51EtCqjd?=
 =?us-ascii?Q?jXof+SJ/7SXNA52yy1XQD10vHbOHCPED07wL6OVoBqIXoROwSQLGx3eHdlno?=
 =?us-ascii?Q?p1NEJk7YazaRPiq7fWItvxLiAcdasJ1CwgBJo/Lf+KnZ0MHYSZ26JgISvhKR?=
 =?us-ascii?Q?2eASEuxFy2YgZAytG9m9IOJ47ZSaC6OeyUakc6LoP8m+ftohqoYeYsH6pxPK?=
 =?us-ascii?Q?vUOwKmxgFrdzWjFMGSzU0I4mzXF9/SKe6/pl/VKF5LORG2tG+Cguzk0EKukO?=
 =?us-ascii?Q?PN69at8LcK6AmA34zgY18ViiGf0h1YtxPZm8/oYFKJqd43rOzMNHjcRiRpYB?=
 =?us-ascii?Q?Sr2CYMePCPOObjtT1nbHk/tF7VZh8vweAtrX8/22/QIpmf0fN8ARfGq7vBdK?=
 =?us-ascii?Q?LgY5BBINMBQ6v050ZNxXYb7CQ5q25rleQJr8Ul2rC6m9rNh5FkvCWJWYIS0b?=
 =?us-ascii?Q?BNE+HSj+7hQ2AgHyjLl+ncTU2Ctij+NTzFVMyYHliWOetiI/1Snu4TrJPopq?=
 =?us-ascii?Q?1iPL8FtBaLnnxJnQkOskmzY2bqL+1fymUiTEcJlnIAHdYF5DQ8KGArfGLjpf?=
 =?us-ascii?Q?mXfriC9KNhjPBO91IxBhh7jJTauVQedYAhHZhnK581Nnr/gBVIxSlN5QME7C?=
 =?us-ascii?Q?RrUqhyQxgIQXs52IWSdO5Zz4hOiI3uWuyMagdvuQUA0WzTA7isrx9mL2kXHW?=
 =?us-ascii?Q?XVp1LUXFw9qQJAe2bOm/M5Cs1XnL9nvQTLrCO4xYi2c83S42xHf00ZrcaRD1?=
 =?us-ascii?Q?OOg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a84527a-da55-4042-ab69-08d8eef3e91c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2021 18:37:42.7179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LnFQQiBfxgK/aeKXhzgpwN8lGwqUh/Ve8xV/TWISgfXwcBLo5mYD7Oc3xwBZbpPsnHBPMPtQYrtTIWo8z8RxxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Sergei Trofimovich [mailto:slyfox@gentoo.org]=20
Subject: [PATCH] hpsa: fix boot on ia64 (atomic_t alignment)

The failure initially observed as boot failure on rx3600 ia64 machine with =
RAID bus controller: Hewlett-Packard Company Smart Array P600:

    kernel unaligned access to 0xe000000105dd8b95, ip=3D0xa000000100b87551
    kernel unaligned access to 0xe000000105dd8e95, ip=3D0xa000000100b87551
    hpsa 0000:14:01.0: Controller reports max supported commands of 0 Using=
 16 instead. Ensure that firmware is up to date.
    swapper/0[1]: error during unaligned kernel access

Here unaligned access comes from 'struct CommandList' that happens to be pa=
cked. The change f749d8b7a ("scsi: hpsa: Correct dev cmds outstanding for r=
etried cmds") introduced unexpected padding and un-aligned atomic_t from na=
tural alignment to something else.

This change does not remove packing annotation from struct but only restore=
s alignment of atomic variable.

The change is tested on the same rx3600 machine.

CC: linux-ia64@vger.kernel.org
CC: storagedev@microchip.com
CC: linux-scsi@vger.kernel.org
CC: Joe Szczypek <jszczype@redhat.com>
CC: Scott Benesh <scott.benesh@microchip.com>
CC: Scott Teel <scott.teel@microchip.com>
CC: Tomas Henzl <thenzl@redhat.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Don Brace <don.brace@microchip.com>
Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Suggested-by: Don Brace <don.brace@microchip.com>
Fixes: f749d8b7a "scsi: hpsa: Correct dev cmds outstanding for retried cmds=
"
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 drivers/scsi/hpsa_cmd.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h index d126bb=
877250..617bdae9a7de 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -20,6 +20,9 @@
 #ifndef HPSA_CMD_H
 #define HPSA_CMD_H

+#include <linux/build_bug.h> /* static_assert */ #include=20
+<linux/stddef.h> /* offsetof */
+
 /* general boundary defintions */
 #define SENSEINFOBYTES          32 /* may vary between hbas */
 #define SG_ENTRIES_IN_CMD      32 /* Max SG entries excluding chain blocks=
 */
@@ -448,11 +451,20 @@ struct CommandList {
         */
        struct hpsa_scsi_dev_t *phys_disk;

-       bool retry_pending;
+       int retry_pending;
        struct hpsa_scsi_dev_t *device;
        atomic_t refcount; /* Must be last to avoid memset in hpsa_cmd_init=
() */  } __aligned(COMMANDLIST_ALIGNMENT);

+/*
+ * Make sure our embedded atomic variable is aligned. Otherwise we=20
+break atomic
+ * operations on architectures that don't support unaligned atomics like I=
A64.
+ *
+ * Ideally this header should be cleaned up to only mark individual=20
+structs as
+ * packed.
+ */
+static_assert(offsetof(struct CommandList, refcount) %=20
+__alignof__(atomic_t) =3D=3D 0);
+
 /* Max S/G elements in I/O accelerator command */
 #define IOACCEL1_MAXSGENTRIES           24
 #define IOACCEL2_MAXSGENTRIES          28
--
2.30.2


Acked-by: Don Brace <don.brace@microchip.com>

Thanks for your patch and extra effort.


