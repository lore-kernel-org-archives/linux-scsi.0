Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C3ACC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 04:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4826320652
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 04:58:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="I+t6JS22"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfLJE6e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 23:58:34 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:7906 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbfLJE6d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 23:58:33 -0500
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
IronPort-SDR: N99+65BYg6CmPy2TrRCZXMaYD5odxSPJSXMOBJkhD8s6XhfDq7nRnGxZS1Zukllk39ztQphm8H
 AiLC9G6jJXf0RSwTkut4hjHSJT0Ap1kN6PgAK9MXBe8PuWxj1+4H3LhP50wnjITIKH9R/6V1ne
 Wl13vjJOPesW9sPH+LPqaMcofqegf8NED7z4M5W+gC4rm63YhqD1mJA28UYJgYWjfWPys5JTUJ
 KeoKm8Kb23K72b81Z/AYNJ7N1Djbj73wuE/ZvVx8+VTRP4Mj0Jo7rkwVXrEgSbP5INsWh1VY+L
 AME=
X-IronPort-AV: E=Sophos;i="5.69,298,1571727600"; 
   d="scan'208";a="58386374"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2019 21:58:32 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 9 Dec 2019 21:58:30 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Mon, 9 Dec 2019 21:58:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mv+67opIy6sEh/GXJHenJQ5o5edDWlY3WiaxeyT6o1+4ffrcW/1QSip6QMrFqBsAuq5TKm8KgAJAzGj5UaUztR/sLYpmRKD6sZttMPlZlToStycJ4csNTinz83KV4wLAd8hnq1++udF0x7GD7vzvWzCQax0cU5uyvJh8fpX5qW0FOvV90l/Ysl8vwnrab73Y0+B4rqC+S36fSUvxka1kGcuPm8kHVADhq1rpAJceCcx3Vj2f8LJ1oBQJc4/UroiHAExMKNb1sjxbr2IJ5SqUnTh12n1dhQ/IEEdBPQAWg4NRr5JzL3Udug8ZRagCH0dI0kDUMDcEUI18f4qAmQRa8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cECcsqlS4vmzv4d5dhRPWfVDjAUhcvFPAgcNq/TCAKw=;
 b=M9kpEBnA++leaqMtwIr8LZ0fHoISNGBGlXDxJhRqamTXnx6S3QeZjZp+oKYUwZ29OZDAqIl3tuY35kbtlwX+ilDT8qvvc0znHfI7W7HVkDpipfnX0rG4DvrSNVr6EUI+3Ebto6zVQRrR9VPbMhgzTExPtdJNXsKSu83u7lwhoTfSWTIWGA8N0WmVkBmgmMqKoexTB7BD1L89qHVCg+pEt7oWklVXtvBA+V2TXs+EnQu1CIpBDZhQz9jq6/CNh8J0ZZHB+HR0R//KdQ3mbeLaffe2W8madm2QCw6gHTgwbinLJCse3CF/FlAKZWTMp25R/rgszl8XhnZOxk9sCN7FBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cECcsqlS4vmzv4d5dhRPWfVDjAUhcvFPAgcNq/TCAKw=;
 b=I+t6JS22ZwQGotMMUKqzZJH88VtT+frxqr6bdKpk34VlQ4AX8Fdf/+N5A9Ao2nYREpw/+oyTAMjse3Dlc71lccbp93dCWluJBcjx9/R5/qhY2s0s1qxf5wiFomP7BqmTYkLLvyCG6dodWb6s6iqZTUatRJdVVLjvG0i8RP8jucw=
Received: from MN2PR11MB3821.namprd11.prod.outlook.com (20.178.253.216) by
 MN2PR11MB4269.namprd11.prod.outlook.com (52.135.38.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Tue, 10 Dec 2019 04:58:28 +0000
Received: from MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19]) by MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19%7]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 04:58:28 +0000
From:   <Balsundar.P@microchip.com>
To:     <hare@suse.de>, <martin.petersen@oracle.com>
CC:     <hch@lst.de>, <bvanassche@acm.org>,
        <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, <aacraid@microsemi.com>
Subject: RE: [PATCH 04/13] aacraid: Do not wait for outstanding write commands
 on synchronize_cache
Thread-Topic: [PATCH 04/13] aacraid: Do not wait for outstanding write
 commands on synchronize_cache
Thread-Index: AQHVqrNwZKR6mA7ERUCGv2dNF++draey11xg
Date:   Tue, 10 Dec 2019 04:58:28 +0000
Message-ID: <MN2PR11MB3821D84AAB0BC4B243519377F35B0@MN2PR11MB3821.namprd11.prod.outlook.com>
References: <20191204145918.143134-1-hare@suse.de>
 <20191204145918.143134-5-hare@suse.de>
In-Reply-To: <20191204145918.143134-5-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ed3900e-27f6-4742-ca07-08d77d2d98b1
x-ms-traffictypediagnostic: MN2PR11MB4269:
x-microsoft-antispam-prvs: <MN2PR11MB426947CCA28AD4ABF29FA6F1F35B0@MN2PR11MB4269.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(366004)(39860400002)(396003)(13464003)(199004)(189003)(316002)(81156014)(8676002)(478600001)(81166006)(2906002)(6506007)(305945005)(229853002)(54906003)(110136005)(55016002)(86362001)(53546011)(33656002)(26005)(7696005)(66946007)(64756008)(76116006)(71200400001)(9686003)(186003)(66556008)(66446008)(4326008)(5660300002)(8936002)(71190400001)(66476007)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4269;H:MN2PR11MB3821.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aipLoWH+90OZPj0tys1l5fX1WZLJTImDEHUV+kJpvyevbavegkpCC7ApK9G2dneZKAw98TvkBooee3lrkCoZnEC/nfosMJB2CVxlvmfEhdlbNU+rPDa8izYMA9Gshd5nyGMrjNq0yUhv64XAuyPc/NtYBg+cpdcDAN3y6Q4ZoUASV7Btky761NZVUDK6WLdRM6uWRBqyzBtG7BkBh/CG38FYfgi6CkTIrM1IXklJIyNQ2qAfWhEuA1jIVWsN2moPkL7yToO5BSxGT18nAVp5R3xyoT9rqh0MJH/ljX7GpiqcgDv6dXeBpBrBwzFzWukfLen/rANtEMmZ5uuu0mMYbar4u9R51s1TYS1pTSEp9q1Rl34InRvxI68NqBZLmc2ad3Ms7CWsSbtY76ryNd85ZihQCx83dLy+rRJfC45KIwyY43ZReBRI4c/oP+O29FAfK75G7unC/G9QHsSYeDxKCaGaRez79AySLNWE3bK6D80iMVuq06g+sAMgzxEAUoK0
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed3900e-27f6-4742-ca07-08d77d2d98b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 04:58:28.3584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YvOhwTupZahAmGFQoEx/sNkQJqpytFphAwTmrUaWJFa5UG8rFyVdf4H5UMIHtPy3DBSGR8F/uMLeYaWCgvsc7iqn7WXoyUBcQqB3C2XqShA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4269
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Acked-by: Balsundar P < Balsundar.P@microchip.com>

-----Original Message-----
From: Hannes Reinecke <hare@suse.de>=20
Sent: Wednesday, December 4, 2019 20:29
To: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>; Bart van Assche <bvanassche@acm.org>; B=
alsundar P - I31211 <Balsundar.P@microchip.com>; James Bottomley <james.bot=
tomley@hansenpartnership.com>; linux-scsi@vger.kernel.org; Hannes Reinecke =
<hare@suse.de>; Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Subject: [PATCH 04/13] aacraid: Do not wait for outstanding write commands =
on synchronize_cache

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

There is no need to wait for outstanding write commands on synchronize cach=
e; the block layer is responsible for I/O scheduling, no need to out-guess =
it on the driver layer.

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Acked-by: Balsundar P <balsundar.b@microchip.com>
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

