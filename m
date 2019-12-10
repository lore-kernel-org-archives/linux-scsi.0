Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A1CC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 04:59:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CE6220663
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 04:59:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="jir/KUvF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfLJE7C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 23:59:02 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:50500 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbfLJE7B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 23:59:01 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Balsundar.P@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Balsundar.P@microchip.com";
  x-sender="Balsundar.P@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  -exists:%{i}.spf.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Balsundar.P@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; spf=Pass smtp.mailfrom=Balsundar.P@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: NEkHr9PNeUJMqOzRsVuMmvkYoYh2XhZu/kBuoN+2wJoYO6DVUlOB+oa6fzJWXPiCTtYZx9GZA/
 O+3nEUhuvk4kpx1nsoUPS3gDsKUQBONWcvlKXANcF7soDDhu2LRrbgsZt/kaQlEaqzdoHejrOC
 k4OfD/hBesd1AjKlM+LvSGNewmRErS4q4r6x2PPXvHRjZ4Qt9rkcar14Brv7ZRGRYcHRzVrGgh
 BmT6WkAOnEB07t5+T+L6kyZqySfcVAFWz2eo1ul2kt4s+KmDIhFRB7tMeKezkndxO9pVj1iR9C
 T0U=
X-IronPort-AV: E=Sophos;i="5.69,298,1571727600"; 
   d="scan'208";a="59805442"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2019 21:59:00 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 9 Dec 2019 21:59:00 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Mon, 9 Dec 2019 21:59:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dwb2Ah/SDIVWo9u8xniNkLe++TYvAvmcP1G5L9goi4Ef0GEFCItNtdvojzHaljgY/fU45upyVl7ZRWBN4F1RHSj807HJ8eDXJWETVZxS9Y3TEmJWVy1Bqko4/QYliL7+3VysajcZRZKKEK/nsLXPmcbUF1iqwaJzVmlXpCrIHsQ1GjeBeW8mLg7KKeBY3P3c7s1F935ScSoDEW7kTY2LOfvuawnpEVW2pFBRrzZ4wLC7vSy4q9z8vYT/i2jskvIdzzEIZVA4/m/CIDWZrLj8HcGnWEMfbfsxzpuk7XgxCxqUEYFdgsVfkI390zuWKAimzT5UO6B6Sr0KsWC0+JyG4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ST6sDXdS3Ng8s3ylSU16o+ojF8+OTgJj6BLi0U1Igk=;
 b=fxq+oxwSshYsNKzkFS1fhlCW+VLG6tynbJUFxjgRyyqFRFlsABeng2qjAwGSg2D5b7HskOHLuibGzxsys2t8Wsupb7XujYnhS66h/5PEfe68N/ISZdVYc/oLnBOwrTzuSkscQ+zBsw+NCwclZwze8PfMMp1ROzvMeZPY7ckrwUaO4AUWGLyOwH1jN9yKXTUoAVfEdA6GTNYUbGQXdRYcQF8RLU0k2IcCHV+bKnxgjV5UmdcYCapUA10ftn9YDRE+OAiorXz8UPsCHYyk6uGv47mZoJrEK3FT+p5uKqvSaTLQbka43ERiOkd7NOs1cKH4RLsHg9qZNsqoJDfGh065Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ST6sDXdS3Ng8s3ylSU16o+ojF8+OTgJj6BLi0U1Igk=;
 b=jir/KUvFrfTMJTae7YlriHWTtHaMeAUE1hNu8Wg3SuPiaX08wgY3H6G+lVzYMLyRYStWu1b5CaZRlP9Hd7qou5NaVl5uV+NXBJ97TLldGs/73puAYPHvmMcMEtaMLifCVNZVlqIHfL09mMhtjODpanOGtsSXUvwEBBmm1qXwYFw=
Received: from MN2PR11MB3821.namprd11.prod.outlook.com (20.178.253.216) by
 MN2PR11MB4269.namprd11.prod.outlook.com (52.135.38.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Tue, 10 Dec 2019 04:58:58 +0000
Received: from MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19]) by MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19%7]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 04:58:58 +0000
From:   <Balsundar.P@microchip.com>
To:     <hare@suse.de>, <martin.petersen@oracle.com>
CC:     <hch@lst.de>, <bvanassche@acm.org>,
        <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, <aacraid@microsemi.com>
Subject: RE: [PATCH 05/13] aacraid: use scsi_host_complete_all_commands() to
 terminate outstanding commands
Thread-Topic: [PATCH 05/13] aacraid: use scsi_host_complete_all_commands() to
 terminate outstanding commands
Thread-Index: AQHVqrNvxQny4CeWGEe329HrdzEuCqey15NA
Date:   Tue, 10 Dec 2019 04:58:58 +0000
Message-ID: <MN2PR11MB382139BDDB6262B762F5B579F35B0@MN2PR11MB3821.namprd11.prod.outlook.com>
References: <20191204145918.143134-1-hare@suse.de>
 <20191204145918.143134-6-hare@suse.de>
In-Reply-To: <20191204145918.143134-6-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b79c7beb-8443-405b-7496-08d77d2daac1
x-ms-traffictypediagnostic: MN2PR11MB4269:
x-microsoft-antispam-prvs: <MN2PR11MB426938667131F72E381A3E56F35B0@MN2PR11MB4269.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(366004)(39860400002)(396003)(13464003)(199004)(189003)(316002)(81156014)(8676002)(478600001)(81166006)(2906002)(6506007)(305945005)(229853002)(54906003)(110136005)(55016002)(86362001)(53546011)(33656002)(26005)(7696005)(66946007)(64756008)(76116006)(71200400001)(9686003)(186003)(66556008)(66446008)(4326008)(5660300002)(8936002)(71190400001)(66476007)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4269;H:MN2PR11MB3821.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0eb4lbPOoyRdC20o159AaU6JAtjZjrZ7x1b7lHW1PbIfFGeA19IwbKgvsMzsmK7uXHWJW0Dm2mqtocfFdTouIPTq+/kyuX5yDB0ZT7mlSkGoAxcRCMrwMKCvrLeDMkEu+hltsQpgncfr8WuqqcaIrROP+UKi7fLISl4YCrwkoQTLJPMtld7dN5zXh4as6FT91Gde0ZEVvS96ytebLutoz8GMXNZW3t5uFjuaoYmlDKjMqkY3v8CQsqoze/9ZObJNdIx4Wc2fZ6hP5Rwq4eW8yLDsMFzkzqJbXhUUgj7HUWnK19Jfkb/aK0TsChprQwVPxsKvpS8ixWrtiZU6tJbk0kqQ80y8qpMsNXHYBN9GbpxDss6FT4VOb6qqRPdE0JvlR5cQ4Fw8onrJ4x4NLs48txDoloScy4DVPXxM01FMeNJcBlLbKEGh/YeDFiTsW6IRXq7q5PNtedH1jYE4veCdh47ntdVS3XHCi47Oo38AGvggpzW+D+DRG7vFjyV5got9
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b79c7beb-8443-405b-7496-08d77d2daac1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 04:58:58.6720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HmWFJcsPnSnj4GvyUjVLX8bQroA4o+wwxt09Ftuxl+eK3hen+tw3M85DkONQlVYm91UiNgCU6d2lvssTRqi37buGOu3Ng1K7Jm36WWTv678=
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
Subject: [PATCH 05/13] aacraid: use scsi_host_complete_all_commands() to te=
rminate outstanding commands

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

Use scsi_host_complete_all_commands() to terminate all outstanding commands=
 instead, and change the command result for terminated commands to the more=
 common 'DID_RESET' instead of 'QUEUE_FULL'.

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Balsundar P <balsundar.p@microchip.com>
---
 drivers/scsi/aacraid/commsup.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.=
c index 5a8a999606ea..8736a540a048 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1478,8 +1478,6 @@ static int _aac_reset_adapter(struct aac_dev *aac, in=
t forced, u8 reset_type)
        int retval;
        struct Scsi_Host *host;
        struct scsi_device *dev;
-       struct scsi_cmnd *command;
-       struct scsi_cmnd *command_list;
        int jafo =3D 0;
        int bled;
        u64 dmamask;
@@ -1607,26 +1605,8 @@ static int _aac_reset_adapter(struct aac_dev *aac, i=
nt forced, u8 reset_type)
         * This is where the assumption that the Adapter is quiesced
         * is important.
         */
-       command_list =3D NULL;
-       __shost_for_each_device(dev, host) {
-               unsigned long flags;
-               spin_lock_irqsave(&dev->list_lock, flags);
-               list_for_each_entry(command, &dev->cmd_list, list)
-                       if (command->SCp.phase =3D=3D AAC_OWNER_FIRMWARE) {
-                               command->SCp.buffer =3D (struct scatterlist=
 *)command_list;
-                               command_list =3D command;
-                       }
-               spin_unlock_irqrestore(&dev->list_lock, flags);
-       }
-       while ((command =3D command_list)) {
-               command_list =3D (struct scsi_cmnd *)command->SCp.buffer;
-               command->SCp.buffer =3D NULL;
-               command->result =3D DID_OK << 16
-                 | COMMAND_COMPLETE << 8
-                 | SAM_STAT_TASK_SET_FULL;
-               command->SCp.phase =3D AAC_OWNER_ERROR_HANDLER;
-               command->scsi_done(command);
-       }
+       scsi_host_complete_all_commands(host, DID_RESET);
+
        /*
         * Any Device that was already marked offline needs to be marked
         * running
--
2.16.4

