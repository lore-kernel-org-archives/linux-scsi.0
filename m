Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A19C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 05:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADEE720652
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 05:01:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="EZoNsCCP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbfLJFBh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 00:01:37 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:43665 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfLJFBh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Dec 2019 00:01:37 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Balsundar.P@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Balsundar.P@microchip.com";
  x-sender="Balsundar.P@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  -exists:%{i}.spf.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Balsundar.P@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Balsundar.P@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: kdIwtTtWY4lFxxUhUTRmSJRkqOLMS5vn565mqmblBYkQ5sR38I1e6SgdPg44znjns/aTkyNwPh
 TIQbSvn+E27yA9cicWr2utRUubeeG7JU3s6lNKKaSjL4zSDKpIYcDYpGkwVjBbImH9R1ZUDUU1
 e8WtEOgd//ylotnkliC5HQjp0gAsU+tFY2aG0XMwtKw43mRf3oZ7my1vMR6+CG2IGV6TLJ0VSi
 popFg1usOgasibeoXuWXIXG0/YTb8NdGOSrK6fhVxPUaQLx2wJZ3tqqtjct8lsL/HQp3p0Zqw0
 jYQ=
X-IronPort-AV: E=Sophos;i="5.69,298,1571727600"; 
   d="scan'208";a="57196306"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2019 22:01:35 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 9 Dec 2019 22:01:35 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Mon, 9 Dec 2019 22:01:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXJKlmtcg/III+BJz9auyyTZ/8qja7CnECWFa9j4t3LEjBV3OO9FwUASDpYTaWjNkRkHKnyfj/oRuKu8go7TCzYaTu2Y9ID1N8sP0Is12atYZX+Tjs5ly36wgL9PqtW2pDa4wXHBFw2idYk5gxz7cpqb82FMEKodfdc/iDaY/ZPdi04ZrnlG8szVxDJukzoA6UMabn0TeeksTRifqFrMIKUvAZlHqWR/fCUZN9/hgj0UeecwBrIpo0mFMmlHwXguBxXhtDRTd+ZaXpag4b1/TXTlLp32s8ni0DWkKSZU+1GmPRd2xsrPUkSUrraY7aoJTwkj9X+PPi1h1V8az5toOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BIjqJzg2IXoB8znmLAB4qf8aExfW6L66xYJFjOn7meE=;
 b=KlK0QQYnmsP9MVi1aD1a4VGOAUmCI8/TH5wQmb1EN56UVT+f3k4x+SOntCxZlQdwYzMPlbfH00bdwBtzCJe8sP5C+UQ2T2u0OgKNqYcZSiEXGQ2+loSbLy7A+hc5+CO79Z+7KwSh57GGeVjJqzjcaQ1bVrvBiFRcf97noVBJ881uzkPrrzl6kpL82khtK9lZXcRQasuLYArTuiRkWSTJz+F63R8EOZ7t6/32mE2ke/yoyiDelzUoVyWxNYb1Q4RL+Xm2/Ww48o1RWoSAFWtOtooexA7d/wmODuTyTn/Y4k9/CgnpDieAKDgqLjPixFi3l6aKZOOUWaVuOh2eHt619A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BIjqJzg2IXoB8znmLAB4qf8aExfW6L66xYJFjOn7meE=;
 b=EZoNsCCPd4dVMQc9uYdxILKqBKnjzo2Es4Sy9Ykgo9+ibqwirlzwiyjo7xHXxxXjfcNrBzKK4AV3NtWuI4hpQv6UAzmND57MvNKtT31PlUikOCT7aJZbTPNnGSzW3BOO8MWdfuj3Er8QV+U7ge08DfcLH1jJxm4s5z6cjOHeRfA=
Received: from MN2PR11MB3821.namprd11.prod.outlook.com (20.178.253.216) by
 MN2PR11MB4269.namprd11.prod.outlook.com (52.135.38.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Tue, 10 Dec 2019 05:01:33 +0000
Received: from MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19]) by MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19%7]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 05:01:33 +0000
From:   <Balsundar.P@microchip.com>
To:     <hare@suse.de>, <martin.petersen@oracle.com>
CC:     <hch@lst.de>, <bvanassche@acm.org>,
        <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 11/13] aacraid: use scsi_host_busy_iter() to wait for
 outstanding commands
Thread-Topic: [PATCH 11/13] aacraid: use scsi_host_busy_iter() to wait for
 outstanding commands
Thread-Index: AQHVqrN9lvSlymPaa02lYoIAejjvIaey2EqA
Date:   Tue, 10 Dec 2019 05:01:33 +0000
Message-ID: <MN2PR11MB3821D38A3542650C3D920000F35B0@MN2PR11MB3821.namprd11.prod.outlook.com>
References: <20191204145918.143134-1-hare@suse.de>
 <20191204145918.143134-12-hare@suse.de>
In-Reply-To: <20191204145918.143134-12-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77cee21e-9499-49cd-55dc-08d77d2e072e
x-ms-traffictypediagnostic: MN2PR11MB4269:
x-microsoft-antispam-prvs: <MN2PR11MB4269877EF2BB5DEEE8DEB3BCF35B0@MN2PR11MB4269.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(13464003)(199004)(189003)(81156014)(8676002)(498600001)(81166006)(2906002)(6506007)(305945005)(229853002)(54906003)(110136005)(55016002)(86362001)(53546011)(33656002)(26005)(7696005)(66946007)(64756008)(76116006)(71200400001)(9686003)(186003)(66556008)(66446008)(4326008)(5660300002)(8936002)(71190400001)(66476007)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4269;H:MN2PR11MB3821.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +7VaLMRNxuG6LXrx6Fcmq8DSBEC2OsjhO4oJEu83oK+3r9WOKi5aGavkeJ0EIZt7qmltKvfPYTC5uwvODTndOyg4YrDEw5d7oTsKns9v2VazL53a5ZzXxjr8TLU5B/Zy0Sm1r/j86kIX5jBKV+jXCoaW6C0pj24/o+WfiYiWA/cNnLeVdDIfChbLo+le637GmQ603kQpa6DKfpodCMmJp4REprHDMe/Z+W8i+aGmWwiXZyMPnDeIKM0+VNIjxCE0G/iwphDqFngRtloHZBtVAhRh3RZudwYCCL41yNuQzQxVMyduA8tvYm07ms1qpP9DM5Mpj1tkjyK5A46dGXNqbquajJgBZ/mHM123vloirPQcP/2sVojCh8SjvRi18lvYHauedt2rzSZzbEbKUdpiM7kgTjOsKbWbUbObaoQlKizT1ENJA7kbUNHEP/nIfb7U+PZln24ye/ReOe0ycb1Nat1vDWNxa7lCoLMZVphR49ln6uCgCg3e7q8ZRzJpBMFZ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 77cee21e-9499-49cd-55dc-08d77d2e072e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 05:01:33.7310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dHfntPPq5oqUE/XK4sSt7dltbbeqbBd81gOzCGNokaq9bVdaFrIttgfki0xdbsrUPAN7HEFLwRR6qnhlBZPZifeeUa3ZsKjCUDOYU1VgV7Y=
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
<hare@suse.de>
Subject: [PATCH 11/13] aacraid: use scsi_host_busy_iter() to wait for outst=
anding commands

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

Instead of traversing the list of possible commands by hands we should be u=
sing scsi_host_busy_iter() to figure out if there are outstanding commands.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aacraid/comminit.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/commini=
t.c index f75878d773cf..355b16f0b145 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -272,36 +272,35 @@ static void aac_queue_init(struct aac_dev * dev, stru=
ct aac_queue * q, u32 *mem,
        q->entries =3D qsize;
 }

+static bool wait_for_io_iter(struct scsi_cmnd *cmd, void *data, bool=20
+rsvd) {
+       int *active =3D data;
+
+       if (cmd->SCp.phase =3D=3D AAC_OWNER_FIRMWARE)
+               *active =3D *active + 1;
+       return true;
+}
 static void aac_wait_for_io_completion(struct aac_dev *aac)  {
-       unsigned long flagv =3D 0;
-       int i =3D 0;
+       int i =3D 0, active;

        for (i =3D 60; i; --i) {
-               struct scsi_device *dev;
-               struct scsi_cmnd *command;
-               int active =3D 0;
-
-               __shost_for_each_device(dev, aac->scsi_host_ptr) {
-                       spin_lock_irqsave(&dev->list_lock, flagv);
-                       list_for_each_entry(command, &dev->cmd_list, list) =
{
-                               if (command->SCp.phase =3D=3D AAC_OWNER_FIR=
MWARE) {
-                                       active++;
-                                       break;
-                               }
-                       }
-                       spin_unlock_irqrestore(&dev->list_lock, flagv);
-                       if (active)
-                               break;

-               }
+               active =3D 0;
+               scsi_host_busy_iter(aac->scsi_host_ptr,
+                                   wait_for_io_iter, &active);
                /*
                 * We can exit If all the commands are complete
                 */
                if (active =3D=3D 0)
                        break;
+               dev_info(&aac->pdev->dev,
+                        "Wait for %d commands to complete\n", active);
                ssleep(1);
        }
+       if (active)
+               dev_err(&aac->pdev->dev,
+                       "%d outstanding commands during shutdown\n",=20
+ active);
 }

 /**
--
2.16.4

