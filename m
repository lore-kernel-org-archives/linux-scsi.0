Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD803C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 05:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A57CD20652
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 05:00:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="goLqf895"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbfLJFA0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 00:00:26 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:21806 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbfLJFA0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Dec 2019 00:00:26 -0500
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
IronPort-SDR: Y/FFgygA9IBiRBkawlxj7xTO0STr2CAxq2g6mgkixrHtXtkd0wRrouF3dlEfxRHrQofSrE5QjY
 eQXWdR5wjKHOYG9WRbCXfkNPBbk/LZjlGp8q2jMHNZZ5xSvNhoe/woZtzKJQg4QhDn4dV+O1oK
 jumGhC8fR9cfjZQPvPaI0GNf43uXqMqj+eoLE3ZXp5X0fgu8ZfuttQr4qzFFI/i1p4IDMkGrmw
 IM20E0SOXhCrpYUzFefJ9e9ow1RitMrBQyVSHoXs/rvEWx6vJFjQwOxrW2ojG12rHqd34xi+hX
 CTM=
X-IronPort-AV: E=Sophos;i="5.69,298,1571727600"; 
   d="scan'208";a="57978048"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2019 22:00:25 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 9 Dec 2019 22:00:29 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 9 Dec 2019 22:00:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AJWoWQEikOBrFF5oHQaqBBAofZrOCnmDbrKagi26WebuxJCAvaTHr0Ge7j0Jaw4YA5EgmJOIUI0nPiG8cR8P1U1/s6ev0GypWp8NYM2WMJnGNzN4dseFIBHqlDubxS0EokhQDoGEdffV1BBv/jhzrVkpcQ+PmplHv2JuVoNCilaZ7EnS+MaUJ8gI214ykeDPJ9LHTN042UkOu3/4b85peYU20zwAzGMJFbiWw9bkfGLk/jrNuPoKB9WSn4zQNP3DxsTyU6o3Ot9DLKa7aKGcLtMivC9rWZIsI0446SexMY0oZQeE6ceEP0q3jf3+SJji037OvMtUyKXYabnK7Isvgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ir5Ha7giqK7Q80RtTAD7R4jxDQ++iuWK5Qs2gNpjrSU=;
 b=KoDT+lgnG7gohGI6WOcfjb6/YOfdp7rvPeZZ1a4N/oi9ZVqe3m6r4qfmLG5C0z45cFGkBVT1oMAdvgSWcwRj2YTs9rVZ4VpH/xtb5T+yNrpFpn5AcoNWkK6kXB5CiLY+0aPFF/oLbxxFBgNqirLmQOd/lrCbbt36VHsiVT1J0snRKUlwPC694Ot6wM9AEH4EQhj5ByhL9swgWLdE1Ms0zKT70oE/Ql0qNJRrsNxp0C7J7KdeoRj5wiJcyyCraGv4IT7cCyz5a5Hey9Z6bNgbyw+I3P57Uk3mU8GHezB4XHPQId/yFb6sQPR4FES59zjwreHJnYrnp5jCN+0cKLXw0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ir5Ha7giqK7Q80RtTAD7R4jxDQ++iuWK5Qs2gNpjrSU=;
 b=goLqf895SuI5bi112W0x4R7/yKNrcvuFrEHmkHLtF9oEUe/8pe15UICdy9iyvxd3jPMYCTPSN5mI2VDfmkxH0bofRje8dCZb8MiMu7qL6gqCxba24guSli9N3CZyu0RRb5WA1nfjzVLUyApAXSSMWSZYF3ZLdhaibpsZLCGF2kE=
Received: from MN2PR11MB3821.namprd11.prod.outlook.com (20.178.253.216) by
 MN2PR11MB4269.namprd11.prod.outlook.com (52.135.38.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Tue, 10 Dec 2019 05:00:23 +0000
Received: from MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19]) by MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19%7]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 05:00:23 +0000
From:   <Balsundar.P@microchip.com>
To:     <hare@suse.de>, <martin.petersen@oracle.com>
CC:     <hch@lst.de>, <bvanassche@acm.org>,
        <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, <balsundar.p@microsemi.com>,
        <aacraid@microsemi.com>
Subject: RE: [PATCH 07/13] aacraid: move scsi_(block,unblock)_requests out of
 _aac_reset_adapter()
Thread-Topic: [PATCH 07/13] aacraid: move scsi_(block,unblock)_requests out of
 _aac_reset_adapter()
Thread-Index: AQHVqrNwskpNvsxcMUOn1QtikjRZr6ey1/eQ
Date:   Tue, 10 Dec 2019 05:00:22 +0000
Message-ID: <MN2PR11MB3821EE82132B0596C41ED6C3F35B0@MN2PR11MB3821.namprd11.prod.outlook.com>
References: <20191204145918.143134-1-hare@suse.de>
 <20191204145918.143134-8-hare@suse.de>
In-Reply-To: <20191204145918.143134-8-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be343a81-11b2-4493-9761-08d77d2ddcf7
x-ms-traffictypediagnostic: MN2PR11MB4269:
x-microsoft-antispam-prvs: <MN2PR11MB42699940F9F931A5506EE9A0F35B0@MN2PR11MB4269.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(13464003)(199004)(189003)(81156014)(8676002)(498600001)(81166006)(2906002)(6506007)(305945005)(229853002)(54906003)(110136005)(55016002)(86362001)(53546011)(33656002)(26005)(7696005)(66946007)(64756008)(76116006)(71200400001)(9686003)(186003)(66556008)(66446008)(4326008)(5660300002)(8936002)(71190400001)(66476007)(52536014)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4269;H:MN2PR11MB3821.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LNTgTDujpWWv/7ksyXuai70BSF+kEOgYe1HVTn271JDOXVNf48VU/FwC2frFyy1kEHQuMayGCj7iKs5QvRW2Cr7Ke7S085jyi5NQt0/nQGP6dasync7v1IBHH6x4XdBB7ZPal2sqrqPxoBRATHzERjMDEgAUQPCKBE6/p7fm5Vo4zVXbPlAW+wp4Ve4PUPZLrp1VwtpkFwDWECANxAhsdiGRbuNXEtfzHeqC3ck7lOYiLJgY0Bw4XOp8N9h0C35BK+5AJEei3HTeix6RAZY4nJuuzNCp8eHgBFVX4TH/0aDksgdp4CmbOdFzLw63dYpw1aOoy81W3WXjDXn43cyFYnnpZUJcNsV3tvDEQiNQVPoE6QspTrlH07aW61nY/CGeD+IuljftGEIw0HSKydBx3V537NneQLpAGNXct1fjEBCsvQIODhpBjV9D0A7gJPay/J9U+w3libNR+Ar6g5q+NoQYWvYwxsHPOg+++T9vB7q/ElmyPbNDPFLNfO+eAP4eGv/HubIfggdctHVIlM8KxQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: be343a81-11b2-4493-9761-08d77d2ddcf7
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 05:00:22.8559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MfH2LnsjybMJ2ZR8RLtImPWHzQo32OOKgR/E/ny4J2WwAiAEKduaJJqJ8WPdfoRK51i7tSpm0AjjsvRi8Muva4kScx7dJ+iz0G11KTQ4hL8=
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
Subject: [PATCH 07/13] aacraid: move scsi_(block,unblock)_requests out of _=
aac_reset_adapter()

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

_aac_reset_adapter() only has one caller, and that one already calls scsi_b=
lock_requests(). So move the calls out of _aac_reset_adapter() to avoid cal=
ling scsi_block_requests() twice.

Cc: Balsundar P <balsundar.p@microsemi.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aacraid/commsup.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.=
c index 8736a540a048..0d8c1ee40759 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1476,7 +1476,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, in=
t forced, u8 reset_type)  {
        int index, quirks;
        int retval;
-       struct Scsi_Host *host;
+       struct Scsi_Host *host =3D aac->scsi_host_ptr;
        struct scsi_device *dev;
        int jafo =3D 0;
        int bled;
@@ -1493,8 +1493,6 @@ static int _aac_reset_adapter(struct aac_dev *aac, in=
t forced, u8 reset_type)
         *      - The card is dead, or will be very shortly ;-/ so no new
         *        commands are completing in the interrupt service.
         */
-       host =3D aac->scsi_host_ptr;
-       scsi_block_requests(host);
        aac_adapter_disable_int(aac);
        if (aac->thread && aac->thread->pid !=3D current->pid) {
                spin_unlock_irq(host->host_lock); @@ -1619,7 +1617,6 @@ sta=
tic int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)

 out:
        aac->in_reset =3D 0;
-       scsi_unblock_requests(host);

        /*
         * Issue bus rescan to catch any configuration that might have @@ -=
1640,7 +1637,7 @@ int aac_reset_adapter(struct aac_dev *aac, int forced, u8=
 reset_type)  {
        unsigned long flagv =3D 0;
        int retval;
-       struct Scsi_Host * host;
+       struct Scsi_Host * host =3D aac->scsi_host_ptr;
        int bled;

        if (spin_trylock_irqsave(&aac->fib_lock, flagv) =3D=3D 0) @@ -1658,=
7 +1655,6 @@ int aac_reset_adapter(struct aac_dev *aac, int forced, u8 rese=
t_type)
         * target (block maximum 60 seconds). Although not necessary,
         * it does make us a good storage citizen.
         */
-       host =3D aac->scsi_host_ptr;
        scsi_block_requests(host);

        /* Quiesce build, flush cache, write through mode */ @@ -1670,6 +16=
66,8 @@ int aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_typ=
e)
        retval =3D _aac_reset_adapter(aac, bled, reset_type);
        spin_unlock_irqrestore(host->host_lock, flagv);

+       scsi_unblock_requests(host);
+
        if ((forced < 2) && (retval =3D=3D -ENODEV)) {
                /* Unwind aac_send_shutdown() IOP_RESET unsupported/disable=
d */
                struct fib * fibctx =3D aac_fib_alloc(aac);
--
2.16.4

