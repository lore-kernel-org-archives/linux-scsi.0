Return-Path: <SRS0=EtEA=ZU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 419CFC432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 11:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A6AC21787
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 11:42:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="GWbdiFQ/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfK1LmY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Nov 2019 06:42:24 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:51293 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfK1LmY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Nov 2019 06:42:24 -0500
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
IronPort-SDR: CozVF/zXJmCgwXSe45BnAGyHuei1m2awTJtu9tp8HbYLrLF/Cx4WPrs5mf/4/V8k/AKWwP5JY4
 6mCw+7sOusoOvav7UmHLgZP2m1JgTaJvL5T/CELDx2l4pbKMnB0rr89BesAsbFg2e2dhGPO2+V
 Nn9ganW19RybTJa5rFe1wbKLEHbHv6RFu4V3coC1E2hF73ozGviF2EoGrKQlsyHH4N2vp88AJm
 yHueRavG59iqg2jHCQW9iopCP2iftp4Ogwz68osc21QuM1roPJsHUdEEtJ7c7Q47RoAHtYSdZg
 +Rs=
X-IronPort-AV: E=Sophos;i="5.69,253,1571727600"; 
   d="scan'208";a="57171464"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Nov 2019 04:42:24 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 28 Nov 2019 04:42:22 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 28 Nov 2019 04:42:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ecKaMWjS+YQ/Uhb6vzqGRuZVEvilCzAMwbgyvohGqorWJE+ZvoK1vWtp7/KAJMFXa+eZYErGH7FcRdXv1tV6946jC1EOOa35f5NSIwo4N7mq9r9g9SmBUKT57Kk27Uy2axR7pvRF/rMbgjVqNA/8Z5OJfXNfleHYwq2uIpstgLTqJxuscRo5SaoTnZkXCYYtltLPhrBtxQJXmZvfpc+/jovqk/dZmJA/0pRKPpQ8d/+VVF2W2IDgnpq9/EUU2IH/ObsZSM4MlSXnhUC7XkugsG80CPz0n0J4k/UTFxEOjMN5RWUc0EwxByB53C6w2VQMnF8koUof67vDMT4TML4v+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+Yeb/uWUSodA9HbQ9K9xWPgyZSDZ3/qHM4U1YFwdlU=;
 b=Pc1AuGZuorl5E5LqCbEd7mbpBiXBZLluGj+U2Z27z1sHZVicfRPHRKHgVk8XL8xm/18HszcUkLl0f3N/DLsjSWTsEM1DsRv429G0GbqPPdsTsUU01hxHdBZzXqZdpPVLQUZyrlGgaKRZRSE8IDxu/uOtIMseL9KLYecP8OfGuyVD8AWZwj/XRXltQIgVCRa4GppRoIlfWYlhVa/9SkbuzCc2Lc3PVTJbLrJCslTUSqrsjtpkG58lyE7l7ca4QX2pSpZn5PtIc1kTHLnrdjsz4ZA7A6dJa4Nr+thNPRKpqkEaZtD0AnrkQoBb1qBwCf7RxoHDp8H9mZ84yvmSVcUJsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+Yeb/uWUSodA9HbQ9K9xWPgyZSDZ3/qHM4U1YFwdlU=;
 b=GWbdiFQ/cATPLP6wtLgbVTs6zZRRNQrh+7X3UKWhmHGcodTKq0mQImIxfnQRpAMJFxh/O2Psi2qQKu9FWST3Gno8khml9XIGkMssv7po2PwEcfsMZDfuTNxrCvnJOCcTWCe868txNJIG0Qt6PmzPNqo6HABTlMfXYbRZWS/VfVQ=
Received: from MN2PR11MB3821.namprd11.prod.outlook.com (20.178.253.216) by
 MN2PR11MB4143.namprd11.prod.outlook.com (20.179.150.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.20; Thu, 28 Nov 2019 11:42:21 +0000
Received: from MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19]) by MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19%7]) with mapi id 15.20.2474.023; Thu, 28 Nov 2019
 11:42:21 +0000
From:   <Balsundar.P@microchip.com>
To:     <hare@suse.de>, <martin.petersen@oracle.com>
CC:     <hch@lst.de>, <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, <balsundar.p@microsemi.com>,
        <aacraid@microsemi.com>
Subject: RE: [PATCH 10/11] aacraid: use scsi_host_busy_iter() in
 get_num_of_incomplete_fibs()
Thread-Topic: [PATCH 10/11] aacraid: use scsi_host_busy_iter() in
 get_num_of_incomplete_fibs()
Thread-Index: AQHVn43efROlC57tFkGmv5Ot+j66UaeggqLw
Date:   Thu, 28 Nov 2019 11:42:21 +0000
Message-ID: <MN2PR11MB38211167DFB8161A6719550AF3470@MN2PR11MB3821.namprd11.prod.outlook.com>
References: <20191120103114.24723-1-hare@suse.de>
 <20191120103114.24723-11-hare@suse.de>
In-Reply-To: <20191120103114.24723-11-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5eae712-d14a-484f-873c-08d773f807c7
x-ms-traffictypediagnostic: MN2PR11MB4143:
x-microsoft-antispam-prvs: <MN2PR11MB4143DE7A319AC44D61E65647F3470@MN2PR11MB4143.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0235CBE7D0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(136003)(396003)(39860400002)(376002)(13464003)(189003)(199004)(6506007)(53546011)(76176011)(8936002)(14444005)(256004)(81166006)(81156014)(8676002)(5024004)(7696005)(71190400001)(25786009)(5660300002)(305945005)(66446008)(33656002)(478600001)(74316002)(64756008)(99286004)(7736002)(14454004)(66946007)(3846002)(52536014)(86362001)(76116006)(66476007)(66556008)(6116002)(229853002)(9686003)(110136005)(6246003)(4326008)(6436002)(11346002)(26005)(446003)(71200400001)(316002)(186003)(54906003)(55016002)(102836004)(66066001)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4143;H:MN2PR11MB3821.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0sXNomq5N8rXVFjVX4BR6K7T+nB9Wi6UXfW4Pv+EDgcUb5Owt4wbWSTVD3TQqDHDagiLm34U/DuUNXSfyuL6tRu/iqoW2wEoOw29R1l6z3zeG7vUjAbYx50P3OqtDwAPqSoRg4UzjY1a5kLtMcLjJgfAFMAlWZhlq6RnWhpQCJIBPfYpK3AZokg/Q/kk0BVEBmY0ssY4OiJ9T6CPcN6D+LjxP+sbXLgWj6eRKJ0VdeUWPIa6+gpxY8RwVUuclvmks/SITkzfZerYDOd++6C3sDYoKHfx7dxq2bNRDyAhTVSAZkMb2khWzi3mI0H4mmLXm99Ozr8abyx1awWToirWGi6TWBIQYhEnWC+GKSVtGAImSc8FTOTc5eh3O6YXP08RWQFyqaW8M/FQQ1wz6PLwKcnv3Vyc359NZ2qNsu1gEmxmeeFTmIpnlDzC0DkMhCT6
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a5eae712-d14a-484f-873c-08d773f807c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2019 11:42:21.4665
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +s93a9xgDnkJ9T7o0uhFGcBJts4kiMonv9kRDTRYkmVkwDM4dXzp3IVthqAM/aaxISfkntL1YKrQLGZ1q5B4iLqDoqAaf28TJQZfLtGGL9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4143
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Acked-by: Balsundar P < Balsundar.P@microchip.com>

-----Original Message-----
From: Hannes Reinecke <hare@suse.de>=20
Sent: Wednesday, November 20, 2019 16:01
To: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>; James Bottomley <james.bottomley@hansen=
partnership.com>; linux-scsi@vger.kernel.org; Hannes Reinecke <hare@suse.de=
>; Balsundar P <balsundar.p@microsemi.com>; Adaptec OEM Raid Solutions <aac=
raid@microsemi.com>
Subject: [PATCH 10/11] aacraid: use scsi_host_busy_iter() in get_num_of_inc=
omplete_fibs()

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

Use the scsi midlayer helper to traverse the number of outstanding commands=
. This also eliminates the last usage for the cmd_list functionality so we =
can drop it.

Cc: Balsundar P <balsundar.p@microsemi.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aacraid/linit.c | 81 ++++++++++++++++++++++------------------=
----
 1 file changed, 41 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c in=
dex 847dac80defa..b7b189672118 100644
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

-       unsigned long flags;
-       struct scsi_device *sdev =3D NULL;
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
+
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

