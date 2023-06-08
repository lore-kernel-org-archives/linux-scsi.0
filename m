Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CE22C7EE23
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jun 2023 21:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235118AbjFHVJS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Jun 2023 17:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234190AbjFHVJQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2023 17:09:16 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0F730CD;
        Thu,  8 Jun 2023 14:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686258550; x=1717794550;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=RncqYze2HOgt91FOc79bDUHd9oc029/mQS3PnzSSM0s=;
  b=qO4LVg5pgu43AjYQp0K6/ERfcIp9XkJ/wp3shlG01PRA0/HhuE1hVTnB
   3v1TVaxdaLMmPM5EF8xUz0oDUP0ZeKurcGA6yflw+Q6i6GHNg+bXkeINB
   0e6Sbcr/D2cpAOHg2uThGzh0EvcYbxKL4i4K/ZJU6ppsd+gySqIz0a4s4
   Y2jPvdlZypej/P1elNhzBalV1YEj5EphLcbE5WBh5/1KISKkV9UE9gWvx
   m7hWT+1sR+PFJIznKah9gc0z163reRVUAkIovL4ZF0R0ebQohm+OTtFub
   whBY7d435X8hR0BH10ZAfuhsV+Gm8x6ROYedtLID1N4E3DFPfa9N1GEVK
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="229204187"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jun 2023 14:09:10 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 8 Jun 2023 14:09:09 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Thu, 8 Jun 2023 14:09:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+iQr11n3YvVJTOv7jGUA1pOMgyFrNXA0+pIplnV1gC/99i3MS+8+9jSSdD9A9ZaRJSE6YdpNVGJHnk/6bNiC0jzhXezd4tkzpRZgAylOTN/dvToFWIztoUCgTrzgj8KNQN4LnGDuDP4ylY3YURuQVjCetEBV9d6gx9wWYhwKlyiIUT8yzwmdxVGpzgCDIh3L6v47NMh4ZnJcdGAV1mokmg7R+I2JdXzPhrOMDgZE0gXsl4pDgWgeVOl0e30Q+xhbvJ3oFVbrkin8L3xGCEWOfTUBs8iwUvN3wzk3ZgY6FMkeqWxElhOm2AfWeTOy6BA5QJc5NvGa0u0kvKvUvwU9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tEPS7a4jBPCX9wuCCZC3dQQDkqeJlN3sdqKOK8ihzmg=;
 b=fU0J4S69gIIy+NYTCaMX44ZGRvU/oF7KKO0ki6m/A+X0nI3LfcqEv2VsiBBL73oVrmAr8xQ7Tg3uzf5jDLmqBjqXWc8YaydVNvCGV567p0P8RS7P2BTLjiEz/AXOja0tcjIiPslheS9xs643o9kMhYIUG2tDBUO4PXzvXsH4cJ7lsN2oPnFCmA3NCE7QxpSsdDWeV0RjtiSB7HuJxsZZWUzbv5XvCk4nvpY3EfCGsIQE3cOyc+UgO3R9TmeeoWpfZdzNhCTOEgR4S+SAa3DyvchwWOD6yAAAAP+IIPQwYVEVG11bXojuVjDy8AqVsBJ39frlf+jvTSLNEjOrXEiNFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEPS7a4jBPCX9wuCCZC3dQQDkqeJlN3sdqKOK8ihzmg=;
 b=Rs+Fuu3+V7Iuw2GcOvSSJBZ4YpCyHbmF6AHic0niysm1HYomirJZmGWibdqvj3TNz4TyG4gkTwaeExCtgL9hdAZb4h8u1rT1m3jncMpmcVUCewV116/5+u570Ru6YgMQ3bm/7Oscb23Zhjd2aHppkbQnCzxdFMKTgkNbZFpSxzk=
Received: from BYAPR11MB3606.namprd11.prod.outlook.com (2603:10b6:a03:b5::25)
 by CY8PR11MB7290.namprd11.prod.outlook.com (2603:10b6:930:9a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 21:09:09 +0000
Received: from BYAPR11MB3606.namprd11.prod.outlook.com
 ([fe80::a28:eaf1:7b69:453a]) by BYAPR11MB3606.namprd11.prod.outlook.com
 ([fe80::a28:eaf1:7b69:453a%3]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 21:09:09 +0000
From:   <Sagar.Biradar@microchip.com>
To:     <Sagar.Biradar@microchip.com>, <Don.Brace@microchip.com>,
        <Gilbert.Wu@microchip.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <brking@linux.vnet.ibm.com>, <stable@vger.kernel.org>,
        <Tom.White@microchip.com>
Subject: RE: [PATCH v4] aacraid: reply queue mapping to CPUs based of IRQ
 affinity
Thread-Topic: [PATCH v4] aacraid: reply queue mapping to CPUs based of IRQ
 affinity
Thread-Index: AQHZiqbjVP9RCG1rZEOLnmJQTGe/gK+BfVcw
Date:   Thu, 8 Jun 2023 21:09:09 +0000
Message-ID: <BYAPR11MB36065C3532CB649BB348F70FFA50A@BYAPR11MB3606.namprd11.prod.outlook.com>
References: <20230519230834.27436-1-sagar.biradar@microchip.com>
In-Reply-To: <20230519230834.27436-1-sagar.biradar@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3606:EE_|CY8PR11MB7290:EE_
x-ms-office365-filtering-correlation-id: 98f6b6b4-68fd-4d27-26e0-08db68649a00
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DmKMg/GFBdnSCwkR1I6lDdBuch9gz4EjUzvglSAvKEjyladj6fZOR8K0YDSs6gGR1/X8oQDO5dmToDqRkdVCUfNQo0mBbWCKafCQpfLFq5tNtGjAlCdwfqUNyay6+NcRfjL0L64If324G7VkXunCkXFSX2gsF1WmIDhljU2i072t8KS1GC+MQfgZTaTrrTWUNXpDAm1/ujuSCt1wxR047nspdddBHqlhB96hKck3Ck80y97mJRJUeWbv3z80xRqOt7U3G66Rh1JGwHH9mS+N9Utmdsm/JP5sERxMHElHcjRcB2MFVmH68BGG7Z01OWyX5aAerpAll7QQF4yV0edKTSeJ3tuEWDG2AZTeTC3THFrg37qPvQYOulPBmWcga74v0SgvwRSBLXTETJEpHTN576Jehyj1JdXJVrH6nqOxrpg6bjeoR/ZilYvBJVp6eD8sOfDvDNCfCLRUWHu24aPDJxQtlJQlPb1IVWqPL8WpGAl/9vxstTRdt+5mkJEztljW89SaVzPuwqJQ41YUz8ejPylu/vkSqH0L3kYVgJVPMCA9jflDJVchd8fkWk02PE6aqTRSLzkW4epZE7llvO4nklFq08aNn5UTa6lNrEInNFjUgGZEzNa00wZ/WLo/yeM5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3606.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199021)(9686003)(53546011)(38100700002)(6506007)(41300700001)(7696005)(26005)(83380400001)(186003)(71200400001)(478600001)(110136005)(64756008)(122000001)(66446008)(66476007)(55016003)(316002)(66946007)(76116006)(8676002)(66556008)(6636002)(52536014)(8936002)(2906002)(5660300002)(33656002)(38070700005)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mUjo8a4yJnzQodpcI2GO1/mqEz64XKaPpGK3+35DvvL2FRgSvaIKUt58cqaF?=
 =?us-ascii?Q?6zAObuaphGT5ComY5fnvY0dGZk2G+jTqM4r8VG5VVIWB/pLXha7jijWLjG4p?=
 =?us-ascii?Q?rV2ZE3mROfGIeObWaOqbR410d9j0cTyifGNhjJ3blHze1e1Y6ZX5TYFzP1AF?=
 =?us-ascii?Q?ez08WZ3VYz/sB5hnlSrohSNCoyKoleZS2gnGr/8Wn2jjMT7ZRz4fj1mQP6Sj?=
 =?us-ascii?Q?y1wQpd3fiH/rH1jLi9/ixiFGyCl60P+LcxjQLofvvRcp3sC7Tr+fjZCnGHUf?=
 =?us-ascii?Q?FMj42ylDW47dZxu3WeRy3B7nleDCXAlHjUHeJiYGJrS6/wJek6Z5frfRAqdq?=
 =?us-ascii?Q?KgulnfrkbmRl/RwV8rAsP3sqdUjExdzcpiMoQ+UBVLV+TKRnLVQA+wPoa3GK?=
 =?us-ascii?Q?93GbRYlQ7GkEsXNKEfJe2hHlOqWS+MCGgocxYrf45DyZDyQSUppJZ5WsZ+kf?=
 =?us-ascii?Q?opuFNqPRIiQmPAikWjmHVe3J0TeaWZ9tNgyI+uLFWRuNxBb0oUpSmDnDmLwo?=
 =?us-ascii?Q?mMzr9MgwOD7jdQXnfk8M+JczrQeI1TQ5IgPleKVct2fl8+x2SqL6wm7dkb9P?=
 =?us-ascii?Q?Gd0BMAiE9NnAYTvBKMVPgOKgHwxCTOtaZqbRYFR3zpVnTV7+ie8l9P57jOF1?=
 =?us-ascii?Q?rR4qytoRHu7ytPXuzpXLbecdlDI0MHbeq40kywpyIYNDL6HwkhukzCa2ZZLB?=
 =?us-ascii?Q?ghtGI/zwGZqDYBVCoLm5vQuyhYX8g1D5Ks4L7qMpHGgMm1fB+t9A8tOTZfUb?=
 =?us-ascii?Q?EMCurEN5rFp1C4+z3J/df330timeA9weQ4kPtmP90wNJmAPYjaHOyyyT8+RD?=
 =?us-ascii?Q?hDWvI5wrFIK5F+ZIn7fOhZ5ZgXUqLYicrj5ge9R5XbL1oABP44a5Hhoprgvj?=
 =?us-ascii?Q?DMDSRE755NvqljAMBZpN7y7+syEYJapbdZOCZY8rR5dbwiS/DE/YVtMQIrBi?=
 =?us-ascii?Q?UTDScNj7ZXK+XBIUbbbzv2aba7JT/9TtUKsnUuCiL3IVOoS8ZyUBJdTYjyJV?=
 =?us-ascii?Q?DWEAAlJYgeGS1mQx0PBD/6fcPb36wAa74UlGiOUM5gcpA6yQiBDOonxXFD6r?=
 =?us-ascii?Q?muPJFXR/MfayPyHytD4Z29vecng56u8/zv+vndSfgEUPN9E4lY3kEU7gsklJ?=
 =?us-ascii?Q?AqUG1w7N2hHqR4H4FbpNok5Fdnwp0VB1s5fq/LY7ZGoLTCrHtIY2tBInWTkc?=
 =?us-ascii?Q?N1Sol/hRwDnFq7M37gPhCYJOzcmKTJLKuUZrAzVKJSuVq5Irj7shF3VP1wFd?=
 =?us-ascii?Q?XiO/7OfQwh3QwXog58D7D37qnXEP68Sp39zpi61WBVVnUtWU5r7+73oiOnXm?=
 =?us-ascii?Q?csI99LX2g73TOJCNwkh+VcRjA+ivIhumzqa1hN1nQ2os68+qkodXUE0/lVmB?=
 =?us-ascii?Q?V9NX2SioL5Nz/7LNx9Qv6sDONrSmt41JfVv6//qhfp/oAbqggu3EfKl81SVP?=
 =?us-ascii?Q?QOoIHenFBBw6UFiEPPeXEtzBNpjGCCcElxM+IW2KJtV8lfHs4aqrUC92ISnb?=
 =?us-ascii?Q?gpSAzsTs5IVgZzc8aPy5jxZdL00B1dKfGSlJyeQXf7XdItDZzVYYsQe0WgvN?=
 =?us-ascii?Q?YX6fh/tdrjXpozY53ja3Pux2mvVgJR/aVKT2/pFv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3606.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98f6b6b4-68fd-4d27-26e0-08db68649a00
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 21:09:09.2605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yb2/qVdgIPNShe+VEysfhVljJBMqGeHU2hdMNmlCx8J9l3Mlx4jpqUSzvU4nFTdV7eUgVlTyGimVtamgvyZKi3EP3LnajAIQsGb2Ccwjx7I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7290
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James et al.
Since there were no activity/comments - I pinged to check if this patch was=
 in line to be accepted/merged.
I have addressed the comments on the earlier versions of the patch.

Thanks
-----Original Message-----
From: Sagar Biradar <sagar.biradar@microchip.com>=20
Sent: Friday, May 19, 2023 4:09 PM
To: Don Brace - C33706 <Don.Brace@microchip.com>; Sagar Biradar - C34249 <S=
agar.Biradar@microchip.com>; Gilbert Wu - C33504 <Gilbert.Wu@microchip.com>=
; linux-scsi@vger.kernel.org; Martin Petersen <martin.petersen@oracle.com>;=
 James Bottomley <jejb@linux.ibm.com>; Brian King <brking@linux.vnet.ibm.co=
m>; stable@vger.kernel.org; Tom White - C33503 <Tom.White@microchip.com>
Subject: [PATCH v4] aacraid: reply queue mapping to CPUs based of IRQ affin=
ity

Fix the IO hang that arises because of MSIx vector not having a mapped onli=
ne CPU upon receiving completion.

The SCSI cmds take the blk_mq route, which is setup during the init.
The reserved cmds fetch the vector_no from mq_map after the init is complet=
e and before the init, they use 0 - as per the norm.

Reviewed-by: Gilbert Wu <gilbert.wu@microchip.com>
Signed-off-by: Sagar Biradar <Sagar.Biradar@microchip.com>
---
 drivers/scsi/aacraid/aacraid.h  |  1 +
 drivers/scsi/aacraid/comminit.c |  1 -
 drivers/scsi/aacraid/commsup.c  |  6 +++++-
 drivers/scsi/aacraid/linit.c    | 14 ++++++++++++++
 drivers/scsi/aacraid/src.c      | 25 +++++++++++++++++++++++--
 5 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.=
h index 5e115e8b2ba4..7c6efde75da6 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1678,6 +1678,7 @@ struct aac_dev
 	u32			handle_pci_error;
 	bool			init_reset;
 	u8			soft_reset_support;
+	u8			use_map_queue;
 };
=20
 #define aac_adapter_interrupt(dev) \
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/commini=
t.c index bd99c5492b7d..a5483e7e283a 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -657,4 +657,3 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
=20
 	return dev;
 }
-
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.=
c index deb32c9f4b3e..3f062e4013ab 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -223,8 +223,12 @@ int aac_fib_setup(struct aac_dev * dev)  struct fib *a=
ac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)  {
 	struct fib *fibptr;
+	u32 blk_tag;
+	int i;
=20
-	fibptr =3D &dev->fibs[scsi_cmd_to_rq(scmd)->tag];
+	blk_tag =3D blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
+	i =3D blk_mq_unique_tag_to_tag(blk_tag);
+	fibptr =3D &dev->fibs[i];
 	/*
 	 *	Null out fields that depend on being zero at the start of
 	 *	each I/O
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c in=
dex 5ba5c18b77b4..9caf8c314ce1 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -19,6 +19,7 @@
=20
 #include <linux/compat.h>
 #include <linux/blkdev.h>
+#include <linux/blk-mq-pci.h>
 #include <linux/completion.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -505,6 +506,15 @@ static int aac_slave_configure(struct scsi_device *sde=
v)
 	return 0;
 }
=20
+static void aac_map_queues(struct Scsi_Host *shost) {
+	struct aac_dev *aac =3D (struct aac_dev *)shost->hostdata;
+
+	blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
+				aac->pdev, 0);
+	aac->use_map_queue =3D true;
+}
+
 /**
  *	aac_change_queue_depth		-	alter queue depths
  *	@sdev:	SCSI device we are considering
@@ -1489,6 +1499,7 @@ static struct scsi_host_template aac_driver_template =
=3D {
 	.bios_param			=3D aac_biosparm,
 	.shost_groups			=3D aac_host_groups,
 	.slave_configure		=3D aac_slave_configure,
+	.map_queues			=3D aac_map_queues,
 	.change_queue_depth		=3D aac_change_queue_depth,
 	.sdev_groups			=3D aac_dev_groups,
 	.eh_abort_handler		=3D aac_eh_abort,
@@ -1776,6 +1787,8 @@ static int aac_probe_one(struct pci_dev *pdev, const =
struct pci_device_id *id)
 	shost->max_lun =3D AAC_MAX_LUN;
=20
 	pci_set_drvdata(pdev, shost);
+	shost->nr_hw_queues =3D aac->max_msix;
+	shost->host_tagset =3D 1;
=20
 	error =3D scsi_add_host(shost, &pdev->dev);
 	if (error)
@@ -1908,6 +1921,7 @@ static void aac_remove_one(struct pci_dev *pdev)
 	struct aac_dev *aac =3D (struct aac_dev *)shost->hostdata;
=20
 	aac_cancel_rescan_worker(aac);
+	aac->use_map_queue =3D false;
 	scsi_remove_host(shost);
=20
 	__aac_shutdown(aac);
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c index =
11ef58204e96..61949f374188 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -493,6 +493,10 @@ static int aac_src_deliver_message(struct fib *fib)  #=
endif
=20
 	u16 vector_no;
+	struct scsi_cmnd *scmd;
+	u32 blk_tag;
+	struct Scsi_Host *shost =3D dev->scsi_host_ptr;
+	struct blk_mq_queue_map *qmap;
=20
 	atomic_inc(&q->numpending);
=20
@@ -505,8 +509,25 @@ static int aac_src_deliver_message(struct fib *fib)
 		if ((dev->comm_interface =3D=3D AAC_COMM_MESSAGE_TYPE3)
 			&& dev->sa_firmware)
 			vector_no =3D aac_get_vector(dev);
-		else
-			vector_no =3D fib->vector_no;
+		else {
+			if (!fib->vector_no || !fib->callback_data) {
+				if (shost && dev->use_map_queue) {
+					qmap =3D &shost->tag_set.map[HCTX_TYPE_DEFAULT];
+					vector_no =3D qmap->mq_map[raw_smp_processor_id()];
+				}
+				/*
+				 *	We hardcode the vector_no for
+				 *	reserved commands as a valid shost is
+				 *	absent during the init
+				 */
+				else
+					vector_no =3D 0;
+			} else {
+				scmd =3D (struct scsi_cmnd *)fib->callback_data;
+				blk_tag =3D blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
+				vector_no =3D blk_mq_unique_tag_to_hwq(blk_tag);
+			}
+		}
=20
 		if (native_hba) {
 			if (fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF) {
--
2.29.0

