Return-Path: <SRS0=EtEA=ZU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6514C432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 11:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E3BD21781
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 11:40:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="deZBSPC2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfK1LkR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Nov 2019 06:40:17 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:51054 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfK1LkQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Nov 2019 06:40:16 -0500
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Balsundar.P@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Balsundar.P@microchip.com";
  x-sender="Balsundar.P@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  -exists:%{i}.spf.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Balsundar.P@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; spf=Pass smtp.mailfrom=Balsundar.P@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 9ITpCXav2KM9fMpxaXspZlqYvNpsNCMhtKnKRytVPw/Mc7JfBeymSKG+5IUXy/2xMz24oBO861
 d9Nq1LUdg/ad6B79RxQwCr2Ym8dAjaj5JLW9KVeHA0B/VNIx1B7As3UpEt6wu9+iDiYfqC1ncX
 6NI1MtX0klhrfoUprqcUrYeISa6fEmN83FzA4vpUTQ9ne3qyMXN+k9m1FU3AHvirYxhnxvy655
 zJyo0CIwU0w4sFDpqVHBRSLZu1P7iaVc4t/7biXBaY8Qk3zr532ZE3MkKIuRwa61OsYmHjbrxe
 wqY=
X-IronPort-AV: E=Sophos;i="5.69,253,1571727600"; 
   d="scan'208";a="57171136"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Nov 2019 04:40:16 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 28 Nov 2019 04:40:15 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Thu, 28 Nov 2019 04:40:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RqJVT3KxsXbPb6Oi/j5+QshETmUtznEMU3mTY3B7lcHbnsnwgUbAiesAvYvUInawDsDbMHYi0IBwByCWzax2ykKjUKEFnvCq+jtG+AhlF6XjK1yXAVrqKaxExLRo1wQ6aMOFysyq65tpzh+XieIYCValQzEhddhsArMC6WzCCU4Xh60YRvBvvlUgqEpgv4t+zKGh+5mPA/zcuEIN96ngPV4E/Zxor/tOGJAXnaHHDP/o1TTcoC3c8uHY8wNIIKYfVDEfygYBx+mHl5itn/G2JPpzl4PW9lJk/wkzff69QarlI36nF2kHP7F0USCuYXMkmYAxpP5lEsdAPssq2KHdfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LdE2lMtCCG8/YdgwAejH3DvRxBMdf9TY5C7jqg5ric0=;
 b=e6PdWy83sE+vJIQOHN88wZM1w4tz8QJTwBsWTJwrUFv1sOfepEJjH2ramXCHjjxbxo1ulxtv0YXMvwIXE6+oykYUAVK2fEMAOwJauhLK1wlBs4Yi76ePnJ8C9vxvXh/SB7UzOeHI0Fm1vR5AjVlEZUOLRcaeTT47d8Yrr0J4/Z4WrBeUWr0VZEgpTu2J+Wc14EXK8hZIsZ8XJmvMQ6984i4DtC2fYlb4dwOL4nYT1CFLoLbKx9u2N6yABQ6GrTqLLpTzmlRgc0OtuHkmmVS/Yykclxvqk//9llg/emzAP68RMGdFy9UI2hF+l1FrLDa7yJCD2r+JaUy5BfDZfZf4Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LdE2lMtCCG8/YdgwAejH3DvRxBMdf9TY5C7jqg5ric0=;
 b=deZBSPC2o71R8IUYzNHuAPxYzgHLp4V3tU+HGIUzd/MKW02PgF/k6T/LGFTiE1QYGLGKWVuoIjrxRx217deKK7/vjRHSi5iYM03gzc2DskSP2xCfVNmRbDP/8bnq5fAZAHj39oU1A/Ba9CeG5XohPN3IVblMS+MfbmoORtpxfMo=
Received: from MN2PR11MB3821.namprd11.prod.outlook.com (20.178.253.216) by
 MN2PR11MB4143.namprd11.prod.outlook.com (20.179.150.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.20; Thu, 28 Nov 2019 11:40:14 +0000
Received: from MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19]) by MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19%7]) with mapi id 15.20.2474.023; Thu, 28 Nov 2019
 11:40:14 +0000
From:   <Balsundar.P@microchip.com>
To:     <hare@suse.de>, <martin.petersen@oracle.com>
CC:     <hch@lst.de>, <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, <balsundar.p@microsemi.com>,
        <aacraid@microsemi.com>
Subject: RE: [PATCH 04/11] aacraid: Do not wait for outstanding write commands
 on synchronize_cache
Thread-Topic: [PATCH 04/11] aacraid: Do not wait for outstanding write
 commands on synchronize_cache
Thread-Index: AQHVn43Aj6F61oGpF0SFrlgphC7GZqeggffQ
Date:   Thu, 28 Nov 2019 11:40:13 +0000
Message-ID: <MN2PR11MB3821202C19B74CB9D361EDEAF3470@MN2PR11MB3821.namprd11.prod.outlook.com>
References: <20191120103114.24723-1-hare@suse.de>
 <20191120103114.24723-5-hare@suse.de>
In-Reply-To: <20191120103114.24723-5-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b72f70ab-497a-475d-c73c-08d773f7bbc4
x-ms-traffictypediagnostic: MN2PR11MB4143:
x-microsoft-antispam-prvs: <MN2PR11MB4143857DAF47AE1F7E5B929CF3470@MN2PR11MB4143.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0235CBE7D0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(136003)(396003)(39860400002)(376002)(13464003)(189003)(199004)(6506007)(53546011)(76176011)(8936002)(14444005)(256004)(81166006)(81156014)(8676002)(5024004)(7696005)(71190400001)(25786009)(5660300002)(305945005)(66446008)(33656002)(478600001)(74316002)(64756008)(99286004)(7736002)(14454004)(66946007)(3846002)(52536014)(86362001)(76116006)(66476007)(66556008)(6116002)(229853002)(9686003)(110136005)(6246003)(4326008)(6436002)(11346002)(26005)(446003)(71200400001)(316002)(186003)(54906003)(55016002)(102836004)(66066001)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4143;H:MN2PR11MB3821.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SwRRu7she5AKg6TkV1fhwtsuguViKtk6T3S0twTnWw1FIdq5mOf5GzT/WddEGDShJXbVKm453Z1cW9dTKMzAWdFrPL0CauXm2ACH/kFZE2aYKZ/E2Lm9wl1zsE14SWcSyM3okUbmGHGUWIAA8VPUBu+oUy74h+N/tebQLsIRDBY5XwBZVmwdOyo7YJbE0WXUiPl4SK2k+7SZ+JY36SXideF4970RTaCH9s649XGF1Ph8Z9yaJuVkpawTIkxA4usPYL/kwnrAq+HnQPiPsc/EBNgVeSSs0n+93yLj4orKpflFYs7tDGBqLnZCE8nEQ6xJs9f9wB88YuyKOY5dDPsMpjAwr7qwwcWF7DCyKW36WJnHGj2YoSwhLf7MdSPe4Pn4qvG4l4QfVRq3lUMPgy3KSExs5xRRrgHedznbgDd49w+pDwBh2BZcIjICFDsKOYJ5
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b72f70ab-497a-475d-c73c-08d773f7bbc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2019 11:40:13.9037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KnPqmx6tI7K0wkN3iX8X07UNzQnqPh9d5qJkV1nzEPkrXD2RpnfgMFX/TjyFOiOju5zxP3s2q8CS9wBJBnEaVGgHN/SppFe4onlkFfwlyqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4143
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Acked-by: Balsundar P < Balsundar.P@microchip.com>

Before flushing the cache, raid firmware will ensure no commands are active=
.
This patch can be applied.

-----Original Message-----
From: Hannes Reinecke <hare@suse.de>=20
Sent: Wednesday, November 20, 2019 16:01
To: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>; James Bottomley <james.bottomley@hansen=
partnership.com>; linux-scsi@vger.kernel.org; Hannes Reinecke <hare@suse.de=
>; Balsundar P <balsundar.p@microsemi.com>; Adaptec OEM Raid Solutions <aac=
raid@microsemi.com>
Subject: [PATCH 04/11] aacraid: Do not wait for outstanding write commands =
on synchronize_cache

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

There is no need to wait for outstanding write commands on synchronize cach=
e; the block layer is responsible for I/O scheduling, no need to out-guess =
it on the driver layer.

Cc: Balsundar P <balsundar.p@microsemi.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aacraid/aachba.c | 76 ++-------------------------------------=
----
 1 file changed, 2 insertions(+), 74 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c =
index e36608ce937a..cfa14e15d5f0 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -2601,9 +2601,7 @@ static int aac_write(struct scsi_cmnd * scsicmd)  sta=
tic void synchronize_callback(void *context, struct fib *fibptr)  {
        struct aac_synchronize_reply *synchronizereply;
-       struct scsi_cmnd *cmd;
-
-       cmd =3D context;
+       struct scsi_cmnd *cmd =3D context;

        if (!aac_valid_context(cmd, fibptr))
                return;
@@ -2644,77 +2642,8 @@ static int aac_synchronize(struct scsi_cmnd *scsicmd=
)
        int status;
        struct fib *cmd_fibcontext;
        struct aac_synchronize *synchronizecmd;
-       struct scsi_cmnd *cmd;
        struct scsi_device *sdev =3D scsicmd->device;
-       int active =3D 0;
        struct aac_dev *aac;
-       u64 lba =3D ((u64)scsicmd->cmnd[2] << 24) | (scsicmd->cmnd[3] << 16=
) |
-               (scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
-       u32 count =3D (scsicmd->cmnd[7] << 8) | scsicmd->cmnd[8];
-       unsigned long flags;
-
-       /*
-        * Wait for all outstanding queued commands to complete to this
-        * specific target (block).
-        */
-       spin_lock_irqsave(&sdev->list_lock, flags);
-       list_for_each_entry(cmd, &sdev->cmd_list, list)
-               if (cmd->SCp.phase =3D=3D AAC_OWNER_FIRMWARE) {
-                       u64 cmnd_lba;
-                       u32 cmnd_count;
-
-                       if (cmd->cmnd[0] =3D=3D WRITE_6) {
-                               cmnd_lba =3D ((cmd->cmnd[1] & 0x1F) << 16) =
|
-                                       (cmd->cmnd[2] << 8) |
-                                       cmd->cmnd[3];
-                               cmnd_count =3D cmd->cmnd[4];
-                               if (cmnd_count =3D=3D 0)
-                                       cmnd_count =3D 256;
-                       } else if (cmd->cmnd[0] =3D=3D WRITE_16) {
-                               cmnd_lba =3D ((u64)cmd->cmnd[2] << 56) |
-                                       ((u64)cmd->cmnd[3] << 48) |
-                                       ((u64)cmd->cmnd[4] << 40) |
-                                       ((u64)cmd->cmnd[5] << 32) |
-                                       ((u64)cmd->cmnd[6] << 24) |
-                                       (cmd->cmnd[7] << 16) |
-                                       (cmd->cmnd[8] << 8) |
-                                       cmd->cmnd[9];
-                               cmnd_count =3D (cmd->cmnd[10] << 24) |
-                                       (cmd->cmnd[11] << 16) |
-                                       (cmd->cmnd[12] << 8) |
-                                       cmd->cmnd[13];
-                       } else if (cmd->cmnd[0] =3D=3D WRITE_12) {
-                               cmnd_lba =3D ((u64)cmd->cmnd[2] << 24) |
-                                       (cmd->cmnd[3] << 16) |
-                                       (cmd->cmnd[4] << 8) |
-                                       cmd->cmnd[5];
-                               cmnd_count =3D (cmd->cmnd[6] << 24) |
-                                       (cmd->cmnd[7] << 16) |
-                                       (cmd->cmnd[8] << 8) |
-                                       cmd->cmnd[9];
-                       } else if (cmd->cmnd[0] =3D=3D WRITE_10) {
-                               cmnd_lba =3D ((u64)cmd->cmnd[2] << 24) |
-                                       (cmd->cmnd[3] << 16) |
-                                       (cmd->cmnd[4] << 8) |
-                                       cmd->cmnd[5];
-                               cmnd_count =3D (cmd->cmnd[7] << 8) |
-                                       cmd->cmnd[8];
-                       } else
-                               continue;
-                       if (((cmnd_lba + cmnd_count) < lba) ||
-                         (count && ((lba + count) < cmnd_lba)))
-                               continue;
-                       ++active;
-                       break;
-               }
-
-       spin_unlock_irqrestore(&sdev->list_lock, flags);
-
-       /*
-        *      Yield the processor (requeue for later)
-        */
-       if (active)
-               return SCSI_MLQUEUE_DEVICE_BUSY;

        aac =3D (struct aac_dev *)sdev->host->hostdata;
        if (aac->in_reset)
@@ -2723,8 +2652,7 @@ static int aac_synchronize(struct scsi_cmnd *scsicmd)
        /*
         *      Allocate and initialize a Fib
         */
-       if (!(cmd_fibcontext =3D aac_fib_alloc(aac)))
-               return SCSI_MLQUEUE_HOST_BUSY;
+       cmd_fibcontext =3D aac_fib_alloc_tag(aac, scsicmd);

        aac_fib_init(cmd_fibcontext);

--
2.16.4

