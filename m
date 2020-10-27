Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01634C71156
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 16:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8748421707
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 16:36:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="yNcebOCo";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="bGSkfnaW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764298AbgJ0Pon (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 11:44:43 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:32057 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368720AbgJ0P1J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2020 11:27:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1603812428; x=1635348428;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4dIBGw+FipiGhEuFweOo7nZUFvJn3MxR0AbD8TiRDRE=;
  b=yNcebOCoDZlpjm2bAzHvU79xxnSpyInUTbKPc2lvKZA9iRZ2C7BqDLRz
   CNlMAUIQYeAUs/tbgXIrZBNPIwh4audCssmF5GdcUJPk5DpLKW3j7A/fR
   O6MSWweuSjyzkYTtG7Q35BX39fya7a0Q8iAqdF5tH8c3MOZdHPLdqiGsc
   CSDw+hhY4wVmEzbTQni706J9H/ZK1aHG+dclSW0/0i8BMe1o/CSn7JBJc
   77zy/fcghhnfj62iDEJ6inadxDFUdUyj8CMaAy4QKCugSbhzCUgtXqX6m
   4hkrNZPUOrOXcJxUPpFkg1lLt90Rt9izRKjXGWHidySznfiEcdoCagtJK
   A==;
IronPort-SDR: 1hYJPHj1HMBjwLv2LTRMHmmRtuggrrQDX/k/Ms2Zr+SNtrWETgtdsgM/S8lDvGDrXva5FkiGjP
 8nBNBHOGfuROedPV3AcfoBQQaeutwsl9dM+KKsgF833PX52gqPutyWOsXVry/vJsO44G38ZZZ/
 vg0wI6UOVH8Lu8E47QQxM+a1hAzQdSgoAJXbi3NgGVP9bSii02I3q0LnNWbHq7ptDKqwE3wv21
 SQKfONKw/b0RqrgQDHhFW4VaBwPHZhy1B+d5m5oMayySVMxUBixrX0jC5H2/RZyrt2HmgrT2PN
 /dM=
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="96783572"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Oct 2020 08:27:07 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 27 Oct 2020 08:27:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Tue, 27 Oct 2020 08:27:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/LvmizyjGjRZQZEzRDtk/DM8IVEIkt92oxhzdjVvHHUEOhFNxWn26PdKj/wOtcCy1LeUQ4hLd8w/CeWPKo6jDFEqjiaupnuJMY7VtOsMyedpk1+ltmZrxrSJNFqwXHetwyHAjXqDO6Anirjk1MYuUUx8cLzArGwk4IBx5lMpfuw7m+JmJPlEGM3QSr3ZLOGUdo0RkbH2AYPIQcifo2GU/3/Ruz3ndM1spe6pWkwGQ97I2RtAWr/cn6IV7608vJSRi8n0278VcyD2WIaTx7JI3zVYq3v6vt/3WPqhlt75bc7MKQOxf11DdubEKSLk35vBcC4NLtYgIz1cf8uFnjR3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCugLmb0g5xwJ7POHk8/FjANMJiLFPG5yvQkG86WrhA=;
 b=nVAQLe62LfE45VXuf14ZF8sawtar6d7E7ypOUdB/x7ZrDZXzkWBi5JNbgMYtip4OXvnQOy8mKD29zShgrTTEsOP8a01khWk2t3ibX4qKq3RaAqLmp2mBtAwe3iseGkdR7zGc3gXhUWZPfgxop6pKZNYK2QqTzIKQISJeS0BkqHr4jNNyd1ndEYjz8u8NaxggofezAAzqkaTNKWgPK7fUkUrgaFfX5t8z6e5NGWK+sXAmgAuf4Is+Dw8NOT1vd+zERut7ocdu+7+/n+DSgqhCYObswTpbHqviugt0b3nkokVl+1gur2uNKYp7hIMtxBZfc1NAmCxlSqWYV4Uojl5VDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCugLmb0g5xwJ7POHk8/FjANMJiLFPG5yvQkG86WrhA=;
 b=bGSkfnaWCNBzLZnDqxXf37f79/nPExl4oCLPqv/XjiLvsum+lUhQG/jdidMdkYUT7SKU9TPTBG1k37WfwaGOroYQj6Nku29aN8+fq5ZtgDXkW64ih4P98VpvHKsTlz/74gug3up0BtQT6FhFCQfXI7w430ZzriGh6Na9eOz7yJ4=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA2PR11MB4826.namprd11.prod.outlook.com (2603:10b6:806:11c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Tue, 27 Oct
 2020 15:27:05 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::cc4c:c230:c557:d721]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::cc4c:c230:c557:d721%7]) with mapi id 15.20.3477.028; Tue, 27 Oct 2020
 15:27:05 +0000
From:   <Don.Brace@microchip.com>
To:     <keitasuzuki.park@sslab.ics.keio.ac.jp>
CC:     <takafumi@sslab.ics.keio.ac.jp>, <don.brace@microsemi.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <esc.storagedev@microsemi.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] scsi: hpsa: fix memory leak in hpsa_init_one
Thread-Topic: [PATCH v3] scsi: hpsa: fix memory leak in hpsa_init_one
Thread-Index: AQHWrDNWBhz7JdHQ006d7jd8TgCKpqmrkivQ
Date:   Tue, 27 Oct 2020 15:27:04 +0000
Message-ID: <SN6PR11MB2848C63D9D1A86AE45EF0975E1160@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <CAEYrHjmJRmcKX+F8R_wjd146FXnSHekodauG_eNQBXArE4OBeA@mail.gmail.com>
 <20201027073125.14229-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
In-Reply-To: <20201027073125.14229-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: sslab.ics.keio.ac.jp; dkim=none (message not signed)
 header.d=none;sslab.ics.keio.ac.jp; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b9e9571-326d-41ea-bfde-08d87a8cc27e
x-ms-traffictypediagnostic: SA2PR11MB4826:
x-microsoft-antispam-prvs: <SA2PR11MB4826D44A99DF7CD86B9EAA8BE1160@SA2PR11MB4826.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:655;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fOvoNOwHBs8E9J0CGlbQaWdJni+3VvHYvK9k09SXqn2pwXVXfSRcrTF9jIzUcSNK+UZZ1poqy3aZT4RpallDtr26Q3QPs8sPkHCetLJJRpp7+ahDpWp78ztiScTISJK4+0iDYfxr0fBmc1Ez4MDcJTXC1rm7KMB+5XlVPRb1eO3cXZDI7iEi+ydQ75s37y311/pQC8oeN3GZwqBqXpV2GePr/KyBmyrQSfFsABrkacPY328TrPxFdYPrfI3vjcq8B2INABtul8egR77uteASktE307OBeFhFrACRtr+qA/YwH0w6nclFpIXr/lMdgHo6mGGHYXjnNJp8269xa4WlXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(366004)(396003)(376002)(346002)(136003)(54906003)(4326008)(478600001)(5660300002)(8936002)(71200400001)(86362001)(2906002)(9686003)(316002)(66946007)(64756008)(6506007)(7696005)(76116006)(52536014)(83380400001)(26005)(186003)(6916009)(66476007)(55016002)(66556008)(33656002)(66446008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: waXou0gotKKx8ZCKVkXXUwQpaMmwwWLSd0Z0GlzHrl6c7Fdenr+q1VEd8kpUjs9ic8gHxHCYJdp1mysru+Qsse6MfWlFAslZ8ICAvE5n/UJOPkNdh0AXCGecQAKCs68p2v6DfBNyaVicFzgva2kOPSUcE/iw1v7myuJjHtivou2TDoULvUoniMUmhptEmvQ+JSFrCcw09c4Ut9rPe0tbv3XGIlmTU1r3DlLvtZsYIC2HSjB11Slf+QLAAN9xUE8emUrAY/nnUxjNKhsrbeGLdpwZVp4oaBXbPlvd6Kh5t35TV9Cm02iCUKvssiK3H1WH05MQA5j6DKx47YgJhevuqz7X071KUiiRki4CqCZ08hf/wWk7HPNz33u1uWnWp1tk2PreQKF8+uJBA876v+HOtVnMfr9X4vqd8/5B5V8+uIyN/2Q87whCWogjpyrLzBBWa/IFht/wtiGEgE9bsfG13Q/EFfcTEj0iwggmK/pH1Yzc35Xc9iI1t93HyuI7eo7qToNtSe1vhPSyzLefpWhlwDyla8ipbi5NzYKIT1LbFqjnXQC0GCtGklw4Our3RDnPSdGIO0xOPf9QoAFdO974D8CtmlGxJBn3oAvamgCAKrLbOTqNd1CydZVhMFoUCRlZAIii4y2qMwJyHMvvxx0MMQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b9e9571-326d-41ea-bfde-08d87a8cc27e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2020 15:27:04.9362
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TfiPTuIlQ6st9/hZOvRCnmXtyXhHw0/XDYRPGnaQnkh3awrD1PAkjCOg2S3You7Wp5z9KTljMVWXUQaWeMeCIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4826
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Keita Suzuki [mailto:keitasuzuki.park@sslab.ics.keio.ac.jp]=20
Sent: Tuesday, October 27, 2020 2:31 AM
Cc: keitasuzuki.park@sslab.ics.keio.ac.jp; takafumi@sslab.ics.keio.ac.jp; D=
on Brace <don.brace@microsemi.com>; James E.J. Bottomley <jejb@linux.ibm.co=
m>; Martin K. Petersen <martin.petersen@oracle.com>; esc.storagedev@microse=
mi.com; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [PATCH v3] scsi: hpsa: fix memory leak in hpsa_init_one

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

When hpsa_scsi_add_host fails, h->lastlogicals is leaked since it lacks fre=
e in the error handler.

Fix this by adding free when hpsa_scsi_add_host fails.

Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>

Acked-by: Don Brace <don.brace@microchip.com>
Tested-by: Don Brace <don.brace@microchip.com>

---
v3: revert label name to numbered labels
v2: rename labels
 drivers/scsi/hpsa.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c index 48d5da59262b..=
aed59ec20ad9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8854,7 +8854,7 @@ static int hpsa_init_one(struct pci_dev *pdev, const =
struct pci_device_id *ent)
        /* hook into SCSI subsystem */
        rc =3D hpsa_scsi_add_host(h);
        if (rc)
-               goto clean7; /* perf, sg, cmd, irq, shost, pci, lu, aer/h *=
/
+               goto clean8; /* lastlogicals, perf, sg, cmd, irq, shost,=20
+ pci, lu, aer/h */

        /* Monitor the controller for firmware lockups */
        h->heartbeat_sample_interval =3D HEARTBEAT_SAMPLE_INTERVAL; @@ -886=
9,6 +8869,8 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct =
pci_device_id *ent)
                                HPSA_EVENT_MONITOR_INTERVAL);
        return 0;

+clean8: /* lastlogicals, perf, sg, cmd, irq, shost, pci, lu, aer/h */
+       kfree(h->lastlogicals);
 clean7: /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
        hpsa_free_performant_mode(h);
        h->access.set_intr_mask(h, HPSA_INTR_OFF);
--
2.17.1

