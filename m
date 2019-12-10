Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B5EC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 05:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D41A20663
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 05:01:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="prWNKKck"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbfLJFBH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 00:01:07 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:21890 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfLJFBH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Dec 2019 00:01:07 -0500
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Balsundar.P@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Balsundar.P@microchip.com";
  x-sender="Balsundar.P@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  -exists:%{i}.spf.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Balsundar.P@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; spf=Pass smtp.mailfrom=Balsundar.P@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 3ahnhebOPeio9Pb8lCui40oy31hr5lLkNShWg2quCw74a5AbNfoQXgyI4jLN8VkPsDAe8fdIvW
 RCaKTM7GF2UdmILkiaE1rDRBWYllCexFJqv1UlW06PAzY6HMnEWX5/GzO0gDSj/Gmowvvtx6UX
 eYnks0un5F5aw58alHZQHl9/+cu7Q/Q/utU5ufVEnXeHkjD+J8InU9NBMOfprLFLsoNGmezULr
 hL4+zbZcYvVAL/4wMF7DqPTde/0BLsLc0vkWuijQjRu/7u4z2YloQOqryvW/2uSqrDKsdr+h2T
 Nto=
X-IronPort-AV: E=Sophos;i="5.69,298,1571727600"; 
   d="scan'208";a="57978150"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2019 22:01:05 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 9 Dec 2019 22:01:09 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 9 Dec 2019 22:01:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jMwjBj4hreab2Z5yoIusW9BOZMjXE2sYGmKP98uoQ+K/ZqX8Q06zKDZaIMOSZmoVZufVMuEIhb+oXF6vihVnEzVmCH3O4kTrnFsY0CxZno3osyS14xVNXLGzWCpW5R8UF9jVzvV6cr+4SfjNrTqQcsth1zdBcssmRv4GJx2r/I6Z3K2+puEuqEP0v7eMJiT15osXSLy0TYBVcuFSw24HSUcmdlso5baL6GHA+FtVpmTzO0C2L79p9w2OiP0nld+MfWRpoxtFdJBJJBOImWZWftHaQfTqIlZFOBsx0GkMD3JVDwQBvYtXtJYaKQrCIG/YdibE5eY8ytDTfvUHXsJPGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q32A2cr+SGiILsKjEKjNnDBSivh8bzxUvghF006D9is=;
 b=ndu0MMbdAr4mQ9fnJOqzCAi1Fg1XuSLizC10xDmEomiEW7AGzt0/jQz7H05Ib9YAyf2giJhx04JaJVFgo2voYNG7hNh2TjpaXxW6VsTj8FzZEda/yoGcgvCrhf5D1N3F03YMHJCuYdr5s+HUJ5tIr5xoxRZUiS41TUPdAPBygixDw139DnVqUuWkpjCr+OkwU6+vNs9LYVArcrAbedSI472uIRwZ3jf1DLlKd5mhiz0aLWGl2lULmHUXgI+vxpGmEKqM3lJoXebbpyssyR9+8RKUWhbHgFONwA9Q8w6a37icnKK9K2L+mAqsiGO8t3wsIPdKwQeSJc5CcZrz0LXIIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q32A2cr+SGiILsKjEKjNnDBSivh8bzxUvghF006D9is=;
 b=prWNKKckuO4+UE/2KQQitAuY/pyRP/yDqYxM9wtP8MDRT25DnWo3cUx/E5kq589znsyLby8D/5N4RNqDbIFHHf8AUoqpd9rgnlHBu9GrXlkR6KlNDHl9xUCUt8x9DL2KkKCYQZIdQXrFsHS7HZj1SNi+dhtxanMXvM6LJZKtKTM=
Received: from MN2PR11MB3821.namprd11.prod.outlook.com (20.178.253.216) by
 MN2PR11MB4269.namprd11.prod.outlook.com (52.135.38.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Tue, 10 Dec 2019 05:01:03 +0000
Received: from MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19]) by MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19%7]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 05:01:03 +0000
From:   <Balsundar.P@microchip.com>
To:     <hare@suse.de>, <martin.petersen@oracle.com>
CC:     <hch@lst.de>, <bvanassche@acm.org>,
        <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, <balsundar.p@microsemi.com>,
        <aacraid@microsemi.com>
Subject: RE: [PATCH 09/13] aacraid: use scsi_host_(block,unblock) to block I/O
Thread-Topic: [PATCH 09/13] aacraid: use scsi_host_(block,unblock) to block
 I/O
Thread-Index: AQHVqrN+mh5aBvIa30C9ZUYoUyJTKaey2CBg
Date:   Tue, 10 Dec 2019 05:01:03 +0000
Message-ID: <MN2PR11MB38213BE74CBEDD06EBF3106BF35B0@MN2PR11MB3821.namprd11.prod.outlook.com>
References: <20191204145918.143134-1-hare@suse.de>
 <20191204145918.143134-10-hare@suse.de>
In-Reply-To: <20191204145918.143134-10-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2694e1fb-3327-4770-bf80-08d77d2df525
x-ms-traffictypediagnostic: MN2PR11MB4269:
x-microsoft-antispam-prvs: <MN2PR11MB4269BAEE7F8BA26BC28A164BF35B0@MN2PR11MB4269.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(366004)(39860400002)(396003)(13464003)(199004)(189003)(316002)(81156014)(8676002)(478600001)(81166006)(2906002)(6506007)(305945005)(229853002)(54906003)(110136005)(55016002)(86362001)(53546011)(33656002)(26005)(7696005)(66946007)(64756008)(76116006)(71200400001)(9686003)(186003)(66556008)(66446008)(4326008)(5660300002)(8936002)(71190400001)(66476007)(52536014)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4269;H:MN2PR11MB3821.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vXUY3Yrdu4Ex8+vKqDyaJP+KeGeLupqluBgWMU202pNLceFxKwJdc0Ota1R7gouYditUfKXTvu8uv3BhJzFLP00woAvQlatpnS+3QixBBCxmxYws1CivEt3V33uNjjC8kcAamFCzQ0Ger5wAG6A7ppCwzS9aZpOGnP+dRtEAE2iFsDiyoTcVqki5kvfwsDhhRZML0k0yg1c8rEULhGP5cTx8OyWQAmSHTTGbk3eo/Kzr6sH8NC7BOb/oIxYSHf9Hz0XOh6wCgApOxtMPKLDs16lwa+yV+X+mNlPbFTHJOV1hDRMWbfKevjvs19nF0dO57pYZ2PZ/PIdmBJn2FDL0I1AqF21AGIF82jvohQQPTdW1pBI5FvSXH2pXZEfwFuotX8wDJALTqQr08CPxJ9V71dcmZU2zDa0eCPkq5darg0FFlgtC8NHwVis85DwwTTzYx89DqCZeh6HXGujjN9tqmWVE8X2VRPWgGHRdQZiQHoe/YYlPlmQL+M4mwiElilYKKM4gzPP5cSIUp1carRY/xw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2694e1fb-3327-4770-bf80-08d77d2df525
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 05:01:03.4717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uwng2JAJCeB4XeSMqITadTGNidvmor6w++m9YVEdrWOvGzkDXOyaEGhi3v6Pb8EUmYRjYo6xSwZOIbiVjYjytUlgvx8GXoQSQoGNoEobgaU=
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
<hare@suse.de>; Balsundar P <balsundar.p@microsemi.com>; Adaptec OEM Raid S=
olutions <aacraid@microsemi.com>
Subject: [PATCH 09/13] aacraid: use scsi_host_(block,unblock) to block I/O

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

Use scsi_host_block() and scsi_host_unblock() instead of
scsi_block_requests()/scsi_unblock_requests() to block and unblock I/O.
This has the advantage that the block layer will stop sending I/O to the ad=
apter instead of having the SCSI midlayer requeueing I/O internally.

Cc: Balsundar P <balsundar.p@microsemi.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aacraid/commsup.c | 14 ++------------
 drivers/scsi/aacraid/linit.c   | 15 ++++++---------
 2 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.=
c index 0d8c1ee40759..9c227eefd14c 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1477,7 +1477,6 @@ static int _aac_reset_adapter(struct aac_dev *aac, in=
t forced, u8 reset_type)
        int index, quirks;
        int retval;
        struct Scsi_Host *host =3D aac->scsi_host_ptr;
-       struct scsi_device *dev;
        int jafo =3D 0;
        int bled;
        u64 dmamask;
@@ -1605,16 +1604,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, i=
nt forced, u8 reset_type)
         */
        scsi_host_complete_all_commands(host, DID_RESET);

-       /*
-        * Any Device that was already marked offline needs to be marked
-        * running
-        */
-       __shost_for_each_device(dev, host) {
-               if (!scsi_device_online(dev))
-                       scsi_device_set_state(dev, SDEV_RUNNING);
-       }
        retval =3D 0;
-
 out:
        aac->in_reset =3D 0;

@@ -1655,7 +1645,7 @@ int aac_reset_adapter(struct aac_dev *aac, int forced=
, u8 reset_type)
         * target (block maximum 60 seconds). Although not necessary,
         * it does make us a good storage citizen.
         */
-       scsi_block_requests(host);
+       scsi_host_block(host);

        /* Quiesce build, flush cache, write through mode */
        if (forced < 2)
@@ -1666,7 +1656,7 @@ int aac_reset_adapter(struct aac_dev *aac, int forced=
, u8 reset_type)
        retval =3D _aac_reset_adapter(aac, bled, reset_type);
        spin_unlock_irqrestore(host->host_lock, flagv);

-       scsi_unblock_requests(host);
+       retval =3D scsi_host_unblock(host, SDEV_RUNNING);

        if ((forced < 2) && (retval =3D=3D -ENODEV)) {
                /* Unwind aac_send_shutdown() IOP_RESET unsupported/disable=
d */ diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit=
.c index 4d5b34e0d3a9..877464e9d520 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1894,7 +1894,7 @@ static int aac_suspend(struct pci_dev *pdev, pm_messa=
ge_t state)
        struct Scsi_Host *shost =3D pci_get_drvdata(pdev);
        struct aac_dev *aac =3D (struct aac_dev *)shost->hostdata;

-       scsi_block_requests(shost);
+       scsi_host_block(shost);
        aac_cancel_rescan_worker(aac);
        aac_send_shutdown(aac);

@@ -1930,7 +1930,7 @@ static int aac_resume(struct pci_dev *pdev)
        * aac_send_shutdown() to block ioctls from upperlayer
        */
        aac->adapter_shutdown =3D 0;
-       scsi_unblock_requests(shost);
+       scsi_host_unblock(shost, SDEV_RUNNING);

        return 0;

@@ -1945,7 +1945,8 @@ static int aac_resume(struct pci_dev *pdev)  static v=
oid aac_shutdown(struct pci_dev *dev)  {
        struct Scsi_Host *shost =3D pci_get_drvdata(dev);
-       scsi_block_requests(shost);
+
+       scsi_host_block(shost);
        __aac_shutdown((struct aac_dev *)shost->hostdata);  }

@@ -1991,7 +1992,7 @@ static pci_ers_result_t aac_pci_error_detected(struct=
 pci_dev *pdev,
        case pci_channel_io_frozen:
                aac->handle_pci_error =3D 1;

-               scsi_block_requests(aac->scsi_host_ptr);
+               scsi_host_block(shost);
                aac_cancel_rescan_worker(aac);
                scsi_host_complete_all_commands(shost, DID_NO_CONNECT);
                aac_release_resources(aac); @@ -2044,7 +2045,6 @@ static pc=
i_ers_result_t aac_pci_slot_reset(struct pci_dev *pdev)  static void aac_pc=
i_resume(struct pci_dev *pdev)  {
        struct Scsi_Host *shost =3D pci_get_drvdata(pdev);
-       struct scsi_device *sdev =3D NULL;
        struct aac_dev *aac =3D (struct aac_dev *)shost_priv(shost);

        if (aac_adapter_ioremap(aac, aac->base_size)) { @@ -2071,10 +2071,7=
 @@ static void aac_pci_resume(struct pci_dev *pdev)
        aac->adapter_shutdown =3D 0;
        aac->handle_pci_error =3D 0;

-       shost_for_each_device(sdev, shost)
-               if (sdev->sdev_state =3D=3D SDEV_OFFLINE)
-                       sdev->sdev_state =3D SDEV_RUNNING;
-       scsi_unblock_requests(aac->scsi_host_ptr);
+       scsi_host_unblock(shost, SDEV_RUNNING);
        aac_scan_host(aac);
        pci_save_state(pdev);

--
2.16.4

