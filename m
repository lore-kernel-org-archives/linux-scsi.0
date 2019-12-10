Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F94BC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 05:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5F3B20663
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 05:02:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="Mi6mUL6y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfLJFCk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 00:02:40 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:43769 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfLJFCk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Dec 2019 00:02:40 -0500
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
IronPort-SDR: YvTPzRnjnaT1GPCTDFv+giEK5riB+QzJ++H6yT0b2tis+lHGCI4cSAC7apSlKRhL8FeSu6uIg0
 +3/Ms5EKZxMzESLcfeWG5vJYgV9fGgrIG+PyeWdUoGf4d37uyIpBmYLI6rE0oRvhugMxne+DbJ
 WrW5g3IwXBwzuz2Ed7jRa0YtrTlKGmswbpyn82d7S9q57PYPLCLc8ar+aT0bZAJvVLNOWFY/w4
 5ESAuHpNgGjbcBkvlvkBeiJEMqcRmTWKZJsAnHjMGtAGvV9yarCZyNM4f3sZjgNh9YqtYRZx6x
 zV8=
X-IronPort-AV: E=Sophos;i="5.69,298,1571727600"; 
   d="scan'208";a="57196404"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2019 22:02:39 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 9 Dec 2019 22:02:42 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Mon, 9 Dec 2019 22:02:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dagZJ4YFNcMJ9/FNXxc0JkhhsNaRSKkYN/UbUV2VyWJhx0mycSkJi1YRkClgEuF9UKmdhA43yfSs5xdeAMWql0sOO4Wuj3qswUcqQJ2dMNccNh16mH1JRR/1kHAEXbdT2kbieOyLYMYF4LZQdNw1s2ZAocAbuV0obTFN13nfz/D/kNbeewF/zVl7CwXwXm7NfDWm0JMTb6leX8geSsEhbvAUGSop0Mu5np8tuzlIoZOmSVlXkzTlWAhM/+m+xryV3fb/a/j3cpCR5UjvxkI+pzOi60xXcbtFSiBLxTX8QvttdY9IHwOEiNtgoxDB43VQKr8eeJVYdNMJEGtu3voqGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3nBbrmaOWtMTYx6fde64rmS+sXclHJkf+XnJC3qmIY=;
 b=C2MEGQwP5l7tuAMsZ77vr6fqWRhZw0Hh53gaZs0iArUZ/J4D5EIdoiKH0UcDRiwatYhocifVoS86KoaphHwNTHlXhUgrUwvxi3ORRQu26HJMyf+Ij0vsF+TTtirLri9jEKFYq73vQrluO/zb/2d78hewa4yoNcsfdRgyuhRcd3x8iVfYSnBEcPFUWV20lqJVhBWE/IiIGdmC1pBC21WaufFUkUrgBIcz5Zf6B85srz30jiPknuY3Pi+j1x9trhSDBqSWADIgSSUX263XIyTVnGbMgFqh6BRV/B8I5VE9iaE877Ys517rcX7f6fdkvN+y6O8kLqZRFsH4MdvMYijlqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3nBbrmaOWtMTYx6fde64rmS+sXclHJkf+XnJC3qmIY=;
 b=Mi6mUL6yeX38v5pGmFwsqC+0KtfjAblcGLsPBq3eOj4yOgZmcA4n/LdJxcGLk86OQBxOJD5JWHSSJ9czCyPc5YfArTI+p8y0sdH+E2rs+FHlckQKktodzq8a8ewQTVrl/8Uz9uAaxd7BUSVAvvEYsAr3gZtsJ0GMvup1AZ1iNBE=
Received: from MN2PR11MB3821.namprd11.prod.outlook.com (20.178.253.216) by
 MN2PR11MB4207.namprd11.prod.outlook.com (52.135.37.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Tue, 10 Dec 2019 05:02:33 +0000
Received: from MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19]) by MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19%7]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 05:02:33 +0000
From:   <Balsundar.P@microchip.com>
To:     <hare@suse.de>, <martin.petersen@oracle.com>
CC:     <hch@lst.de>, <bvanassche@acm.org>,
        <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, <aacraid@microsemi.com>
Subject: RE: [PATCH 12/13] aacraid: use scsi_host_busy_iter() in
 get_num_of_incomplete_fibs()
Thread-Topic: [PATCH 12/13] aacraid: use scsi_host_busy_iter() in
 get_num_of_incomplete_fibs()
Thread-Index: AQHVqrNwunxDltUeWUG7YHjOci2tHaey2ILQ
Date:   Tue, 10 Dec 2019 05:02:33 +0000
Message-ID: <MN2PR11MB38214C9AAA99EA97A7F0F7EDF35B0@MN2PR11MB3821.namprd11.prod.outlook.com>
References: <20191204145918.143134-1-hare@suse.de>
 <20191204145918.143134-13-hare@suse.de>
In-Reply-To: <20191204145918.143134-13-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ad91012-8388-44de-8f32-08d77d2e2ac2
x-ms-traffictypediagnostic: MN2PR11MB4207:
x-microsoft-antispam-prvs: <MN2PR11MB4207B3BBAF12D35CE5999E40F35B0@MN2PR11MB4207.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(346002)(396003)(376002)(136003)(13464003)(189003)(199004)(26005)(71200400001)(305945005)(478600001)(71190400001)(186003)(53546011)(5660300002)(52536014)(55016002)(66946007)(8936002)(81166006)(8676002)(81156014)(76116006)(86362001)(9686003)(7696005)(6506007)(229853002)(2906002)(4326008)(64756008)(54906003)(66556008)(33656002)(316002)(66446008)(66476007)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4207;H:MN2PR11MB3821.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yq3kLkXQipveRKQ90eRssTKkAuMyr1r4UmF5mQfbPk0hk+6dEL4OpfrvgMxp2L/8YwiQi6tULz/wXqJ7fpQAc+gKAXzlfXVQpb8lEWXWkZYpr59U2l322QKfLIlBTeIw4KhIE6kxj8K+mEfuB6XJ4itgA1i6Irb4HZVhxDTmb5y+G3D8E6LY8ZymsUqR0JpU5QKykmvPqmB7NhrmKw1/VYhqEpnPRUwfLOGq/cjyoYEONic5Bjbka0LX4rkH6FV+XpbOICpNiTliYeRsO/IBeaL65A76twRhQTdYlfFb9s50ukyK5/P3+YlSelGYxlS0swCYnVLmANYKyk/7XQ20DTybF7U43i3xGvJiW/c91hnuoK2nKfH6mPpSr+rnGDEzutme+UGfgbSZs6Gactla2q65AMhzCu2xBDlGF0hN+IWDsMt9WwL4LMGyR4boA9TvilbofDV4AWAAm9hlFIkuCsjBvChBgA8WcUK4vyKAE3aBCcH/dosrrM9RvesDbmIg
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ad91012-8388-44de-8f32-08d77d2e2ac2
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 05:02:33.3916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i3EYSTYtUhEM/0ViEyBoOPMHjWMs6KNuc/a/ySsclVktGj9/B1Toc4y5OhFosD2Y+V80t9bnYepRk55MhfRUEJIduxtuFha3/fQ1BhPU9P8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4207
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
Subject: [PATCH 12/13] aacraid: use scsi_host_busy_iter() in get_num_of_inc=
omplete_fibs()

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

Use the scsi midlayer helper to traverse the number of outstanding commands=
. This also eliminates the last usage for the cmd_list functionality so we =
can drop it.

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Acked-by: Balsundar P <balsundar.p@microchip.com>
---
 drivers/scsi/aacraid/linit.c | 81 ++++++++++++++++++++++------------------=
----
 1 file changed, 41 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c in=
dex 877464e9d520..d0d1f3072c0c 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -622,54 +622,56 @@ static int aac_ioctl(struct scsi_device *sdev, unsign=
ed int cmd,
        return aac_do_ioctl(dev, cmd, arg);  }

-static int get_num_of_incomplete_fibs(struct aac_dev *aac)
+struct fib_count_data {
+       int mlcnt;
+       int llcnt;
+       int ehcnt;
+       int fwcnt;
+       int krlcnt;
+};
+
+static bool fib_count_iter(struct scsi_cmnd *scmnd, void *data, bool=20
+reserved)
 {
+       struct fib_count_data *fib_count =3D data;
+
+       switch (scmnd->SCp.phase) {
+       case AAC_OWNER_FIRMWARE:
+               fib_count->fwcnt++;
+               break;
+       case AAC_OWNER_ERROR_HANDLER:
+               fib_count->ehcnt++;
+               break;
+       case AAC_OWNER_LOWLEVEL:
+               fib_count->llcnt++;
+               break;
+       case AAC_OWNER_MIDLEVEL:
+               fib_count->mlcnt++;
+               break;
+       default:
+               fib_count->krlcnt++;
+               break;
+       }
+       return true;
+}

-       unsigned long flags;
-       struct scsi_device *sdev =3D NULL;
+/* Called during SCSI EH, so we don't need to block requests */ static=20
+int get_num_of_incomplete_fibs(struct aac_dev *aac) {
        struct Scsi_Host *shost =3D aac->scsi_host_ptr;
-       struct scsi_cmnd *scmnd =3D NULL;
        struct device *ctrl_dev;
+       struct fib_count_data fcnt =3D { };

-       int mlcnt  =3D 0;
-       int llcnt  =3D 0;
-       int ehcnt  =3D 0;
-       int fwcnt  =3D 0;
-       int krlcnt =3D 0;
-
-       __shost_for_each_device(sdev, shost) {
-               spin_lock_irqsave(&sdev->list_lock, flags);
-               list_for_each_entry(scmnd, &sdev->cmd_list, list) {
-                       switch (scmnd->SCp.phase) {
-                       case AAC_OWNER_FIRMWARE:
-                               fwcnt++;
-                               break;
-                       case AAC_OWNER_ERROR_HANDLER:
-                               ehcnt++;
-                               break;
-                       case AAC_OWNER_LOWLEVEL:
-                               llcnt++;
-                               break;
-                       case AAC_OWNER_MIDLEVEL:
-                               mlcnt++;
-                               break;
-                       default:
-                               krlcnt++;
-                               break;
-                       }
-               }
-               spin_unlock_irqrestore(&sdev->list_lock, flags);
-       }
+       scsi_host_busy_iter(shost, fib_count_iter, &fcnt);

        ctrl_dev =3D &aac->pdev->dev;

-       dev_info(ctrl_dev, "outstanding cmd: midlevel-%d\n", mlcnt);
-       dev_info(ctrl_dev, "outstanding cmd: lowlevel-%d\n", llcnt);
-       dev_info(ctrl_dev, "outstanding cmd: error handler-%d\n", ehcnt);
-       dev_info(ctrl_dev, "outstanding cmd: firmware-%d\n", fwcnt);
-       dev_info(ctrl_dev, "outstanding cmd: kernel-%d\n", krlcnt);
+       dev_info(ctrl_dev, "outstanding cmd: midlevel-%d\n", fcnt.mlcnt);
+       dev_info(ctrl_dev, "outstanding cmd: lowlevel-%d\n", fcnt.llcnt);
+       dev_info(ctrl_dev, "outstanding cmd: error handler-%d\n", fcnt.ehcn=
t);
+       dev_info(ctrl_dev, "outstanding cmd: firmware-%d\n", fcnt.fwcnt);
+       dev_info(ctrl_dev, "outstanding cmd: kernel-%d\n", fcnt.krlcnt);

-       return mlcnt + llcnt + ehcnt + fwcnt;
+       return fcnt.mlcnt + fcnt.llcnt + fcnt.ehcnt + fcnt.fwcnt;
 }

 static int aac_eh_abort(struct scsi_cmnd* cmd) @@ -1675,7 +1677,6 @@ stati=
c int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
        shost->irq =3D pdev->irq;
        shost->unique_id =3D unique_id;
        shost->max_cmd_len =3D 16;
-       shost->use_cmd_list =3D 1;

        if (aac_cfg_major =3D=3D AAC_CHARDEV_NEEDS_REINIT)
                aac_init_char();
--
2.16.4

