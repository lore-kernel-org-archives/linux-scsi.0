Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8677DC4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 22:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EEC061158
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 22:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbhHEWJG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 18:09:06 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:19928 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhHEWJF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 18:09:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1628201331; x=1659737331;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oEhrgO5UvjcMxSv2fbgh95j5cLdnFv8AOcxXqhlLHjM=;
  b=F5h+XQQq3uDH5u6sVLCanVNTYVpNHdIv8LjmcpULkjI1RW/eiFZ8iu0X
   htXOGDtVg1Hdt0HBZjaxzVN3yRKO0lO/hc5K9QvtuwnfspuviAp+e1NTS
   BShjlWwdoRyYC9TraMkuKXRc0TXBE1eXXA9p3O7Ay2qWinGejg6/ejXV5
   PURCgt6bh7VIBIRcJS9FQV0KS4DkWva6pOp5/kq3ZiH7h98UAoQEwr/GQ
   5QNXr9SrIYNNEB2s8tJyuIylh6KNPtG63N17FohvODRQp3wkEmFo8o9fH
   xrwppmxA0jiEhPF9m12eHBneHtdHSJ7Io5udDSaRKsKEyXdhtgN2b1U2P
   w==;
IronPort-SDR: zTMgvymPWXPd3ZkpUMCAlCqNxV7VWCPhkHYcf8LcILJ7CEhRAFR4ECFQtpga1mF/wOl9nFgxRq
 Q8+zqnnX4G8JX/PKY8aY8wurKCN0LssFBe92jTciNogDFFiSIcgnEPU1BiUAB2if/hieqd/t0U
 lXHWwYBGRGZpc5i6ClxJnWxjiNAlUVdG5R5SoLpDD6YV4k4TrZYv1sMgcd6MwwfQDEOj7Fj1h9
 iKJYt/K86brfkIGy613uwh6gwgbIyQVGVHQ3WmjeyqTW5SJhVrNyscnBmBQMza8m1wLB5d0VGs
 B2qM2ciTEMwS6QJmmKjuw/oW
X-IronPort-AV: E=Sophos;i="5.84,296,1620716400"; 
   d="scan'208";a="139003649"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Aug 2021 15:08:50 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 5 Aug 2021 15:08:50 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2 via Frontend
 Transport; Thu, 5 Aug 2021 15:08:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZDJcSUd7xOldXO19en1oab8UZn+mVrORUbeo9G/mNsfqBO0uxy4DPBfhwEhH4RmqFx6Q+zteE3h3D/hNwxo935r+WOtvXUEq6kxj6JdLpX0soO/Tqcl2x3uLTarE42V415uVXlITq6aAi0xrQHQQVseg2Q1gPRzUVNXXHH68d4Z8aOAFW/QnvtSwgM3saNWd06DPQQ+BomwIERpUVHBlnv+lBldmOXGoxFxAkV2mlDK/MgO+OGdlbFdSbNDbx1oxiwSG1zRbFeGM0hdhbS1PieKCn550bvUtND3XztS4xTVUyYeYDyJ3RgTXT24p37kmxFOWfldrCX6CP6mwF2YcwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpuOBMTwqWN5aw1LEOG4BFF9JV9gKIIU88z6OsRAYu8=;
 b=MxgOBdT5W9E7NWeEDKBCaZ33Wmxld196LYKy+8j3/NEB8Z/HBcQrWoJokRd/Jxy1fRoiBqb6M061v1B9Ax3qD7zcyM4gS2OBnTCSpnw/i4h6r3OD4P8T2/jttSyQTPxQnSpbamiE/1NFrRk49ILYe7IpSV+CmalSkIj1iK339xKD1MEr4R0YAnn62Q6jMs5nDlqE3a1mrNXKUZ1gD0aG6aqL32Mw9dt58P3agoWWgFuN5ia2n/Z+/AETu90KH5FpfW+kH7Dgy5jP5cu82jvRej3BMpnwGN7UJd4tN9cCxOGMNNTZDVhyPUIjwFEHbauOjI/RgOe3bekqUh3hYn62iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpuOBMTwqWN5aw1LEOG4BFF9JV9gKIIU88z6OsRAYu8=;
 b=eMi+XTpr4epykvrwIi0bgbQ5UkMPc0C7+h1o1rJI46yjtMLPfdeMDFeNtCCnaRcNuusUBi1hs4B0flf8Ihca9nWMfIkRi8QSRTsvNVMvETlfbaWZJfn1q0XvCmdqcjBKXyCNsqSEmXQAdqKZ6B44lowU4vKfPzzWzBiQ/Y6b7rA=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA2PR11MB4795.namprd11.prod.outlook.com (2603:10b6:806:118::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Thu, 5 Aug
 2021 22:08:49 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::8ae:eac8:48b5:292]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::8ae:eac8:48b5:292%3]) with mapi id 15.20.4373.026; Thu, 5 Aug 2021
 22:08:49 +0000
From:   <Don.Brace@microchip.com>
To:     <bvanassche@acm.org>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <jejb@linux.ibm.com>
Subject: RE: [PATCH v4 22/52] hpsa: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
Thread-Topic: [PATCH v4 22/52] hpsa: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
Thread-Index: AQHXii7MXUIalpT5zk2tJ9EDjpeiq6tleB7A
Date:   Thu, 5 Aug 2021 22:08:48 +0000
Message-ID: <SN6PR11MB2848C60FB1FC84AF2D7AB1FBE1F29@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20210805191828.3559897-1-bvanassche@acm.org>
 <20210805191828.3559897-23-bvanassche@acm.org>
In-Reply-To: <20210805191828.3559897-23-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f1ecc0c-c1fa-4921-57b0-08d9585d9a23
x-ms-traffictypediagnostic: SA2PR11MB4795:
x-microsoft-antispam-prvs: <SA2PR11MB47957FF58E04A3B347247003E1F29@SA2PR11MB4795.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WGmfwZ40gremfI+lS9LYC9zFvwd8hh6YkQ3eRxTzokJkEIOcBCg9CdADPR/Lcdg5GvddHUS6v6qGCHEXKYo6/pChSW2ePHdjDKgD0S5Tkwbp0ap1J3RF0cW3VEw3/tTeHhr9Zrl25pvVLcpz4HmDLuWMLx+V4h52b8UhgF0rtiLI5f6mhe69LRbth+mjTgC/iKFvM9EjQyp546Cbf79ChTnPWAVJMxIDWgg5Npr74PaeN2c5xvtgwKQJwrY4RC6TP5KpAI8i+i0mHn70+a/tfcdnzSyWc3AG1TBzlk24VtOdZlm/3idZ0EsYcTV3ukFXLeZfE0vj608KxOl7fQEGpZ3t4aa4ofajep9L1QalTC2m8ljmAe/0hf3fEzqAmxGaAo31trNN3OWC7jzbiEWEdpYCJM3jVrZI8H3A38LJp0CI+J7dnDSJEJybzV5hRu6v/ZVxTSg3rK+G19VC35DLEh0Tz89ep7dLtDgPgLekHwYJoNAxCMmU/a+sGJ8RZH7jNaPNTUZO4GUUMaIrYfc4D5EGauk3k1crSMnw/CTdTb0Kfi7UBttQYpngmfg6SGfdldhFNLWvEpdsDrG0Gi4LuovHf23nBTMMoKvjPZR5siU/FPy+nmEm2WYTWcv/LwASeLp7J102W5Hzi7z3FBsgzNOcj/xsG5RrGlrCMcf5rtjplQIDptW2yBM4VTtOwvyTMhi7O1H8RU2UEkIyR4Onsw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(39860400002)(396003)(136003)(186003)(33656002)(83380400001)(86362001)(52536014)(478600001)(110136005)(55016002)(8676002)(5660300002)(9686003)(66446008)(76116006)(64756008)(54906003)(66556008)(66946007)(71200400001)(66476007)(4326008)(122000001)(6506007)(316002)(38100700002)(8936002)(26005)(7696005)(38070700005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JojDxJ3OnqCYJyYZmoZhVZmkuZHSOmCHYHVrL24EF1UOSDSotHcBiPkTqmK6?=
 =?us-ascii?Q?CfGhQzYB7EtvDMB1MY9iwvGzaP0qZauxpE+1L6GALF/PYmRyBCiF1KhYUdm5?=
 =?us-ascii?Q?59+WInHbyVO03U072lT/IzURDHkIjR14lNPx8kj+aBNw+MiJtgYb6K4/6k3K?=
 =?us-ascii?Q?cFFbtw5f7+VczvUiFVzwGYsmnq0PZLOxBlw/Bub04UZXsfqiqb1oHwtEy71K?=
 =?us-ascii?Q?AxMIlPjWXtxmaeywLWnFrGp/K0oNb7JdIjtQ0i61bXkO1d4DcHEKuDhHI0Ki?=
 =?us-ascii?Q?QBUhWC3cl+aSHM6TiLUk9xgIRxwcM+bMvxUMYAZyQP3n5EK0i2d6etFFXujs?=
 =?us-ascii?Q?yyaAhpCZbmC5GOpztM3rJ/boEn31+o1nSuF8pye46eW6ZSOWCLmvWG+DSfr8?=
 =?us-ascii?Q?CdofbNLdDlv7YycN643zgzRcNftei1mmQCyDcLekzX92hnmBiLkEQ9QHeUIr?=
 =?us-ascii?Q?jlSeqBLl/6PUPpDabOl9B1a0zKhVDbOFM9Qs10deiO3GvaakGTt3iRlYjJuO?=
 =?us-ascii?Q?sZ+AoOabucBtXlVhrZCBbn7QhOEEncR06NfUcoHrULnStFnPjIz7gkyBfarD?=
 =?us-ascii?Q?E46sMY4X2i2aDl9iEIFKdJOQsq39dIoQiGXQuJjQZjTTUSWaB9NluimnPWM/?=
 =?us-ascii?Q?BsE6V/yOqHkK/dy+7euWf3bfcyCc0u3B5y4prng+zfMEN316W2FVW1Ac35+d?=
 =?us-ascii?Q?3ktEIkhNYh/BfM+19CPWU43d7KRZxIWPBpWpqvaOnZu3pWzS0GIgEkJM6aBl?=
 =?us-ascii?Q?OSnHikr+mXpJ6/cnb0pM41TeQyFyC70HdKv64rQ9tGXNBR6ATYdaZVKm0h+l?=
 =?us-ascii?Q?eCH+tfKTxQIJ08RVbvqWW9yEeomo/F3DOJn3xK/9cmZ25IfIBX3+4Ul4i9r8?=
 =?us-ascii?Q?u+on0yxaL6RYHzXqlNMAGg47c7Pr6MT0FsPe8d4wjrUw+kdzN5ghWmlTlCjt?=
 =?us-ascii?Q?C8Dbl9YwNmN3H7gF0fRzjAyMoz/MfcpS5SsQV96o+7XB0drdEGcIXwSXcYq4?=
 =?us-ascii?Q?KWYrRveJjQZoDHiV+pgKFYWu0FLI3gNe+A9UGzyp69uqtpElA9PBTPUtkPu9?=
 =?us-ascii?Q?0jYCgbma2pnm1QVsjLEWyLhR/4GV0JAYEPTLVIn8c1xaMnkajI1C+fwgD136?=
 =?us-ascii?Q?RMCATx+GJQfo/1iHWesKwY61rxfKw6dA5MQ8e8BGQu0dwCqqgoKvpgqnUuwn?=
 =?us-ascii?Q?/2I8OsNm1xDCPuudzQUrKQbaayTyR5pvh47rpCFBPyXlkYnPPrp/8M2UILym?=
 =?us-ascii?Q?zTzTg/WqvulOOpXEoODKZPc6ALB2TDXNw+57awgb1OGJJrytMo5ghJVKHpNY?=
 =?us-ascii?Q?gPxWo1Cb9rJIh1vbDUyHVad3?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f1ecc0c-c1fa-4921-57b0-08d9585d9a23
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 22:08:48.9786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cxDZMsLNYQGMRqNLErkPBOrN3VxHwRMtorZ6Ff2ICV2gNZnhNf9O6OripZDeAZWYJydN8zBU/Ee31tpe5H8zOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4795
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Bart Van Assche [mailto:bvanassche@acm.org]=20
Subject: [PATCH v4 22/52] hpsa: Use scsi_cmd_to_rq() instead of scsi_cmnd.r=
equest


Prepare for removal of the request pointer by using scsi_cmd_to_rq() instea=
d. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Acked-by: Don Brace <don.brace@microchip.com>

---
 drivers/scsi/hpsa.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c index f135a10f582b..=
3faa87fa296a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5686,7 +5686,7 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *=
sh, struct scsi_cmnd *cmd)
        /* Get the ptr to our adapter structure out of cmd->host. */
        h =3D sdev_to_hba(cmd->device);

-       BUG_ON(cmd->request->tag < 0);
+       BUG_ON(scsi_cmd_to_rq(cmd)->tag < 0);

        dev =3D cmd->device->hostdata;
        if (!dev) {
@@ -5729,7 +5729,7 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *=
sh, struct scsi_cmnd *cmd)
         *       and is therefore a brand-new command.
         */
        if (likely(cmd->retries =3D=3D 0 &&
-                       !blk_rq_is_passthrough(cmd->request) &&
+                       !blk_rq_is_passthrough(scsi_cmd_to_rq(cmd)) &&
                        h->acciopath_status)) {
                /* Submit with the retry_pending flag unset. */
                rc =3D hpsa_ioaccel_submit(h, c, cmd, false); @@ -5894,7 +5=
894,7 @@ static int hpsa_scsi_add_host(struct ctlr_info *h)
  */
 static int hpsa_get_cmd_index(struct scsi_cmnd *scmd)  {
-       int idx =3D scmd->request->tag;
+       int idx =3D scsi_cmd_to_rq(scmd)->tag;

        if (idx < 0)
                return idx;
