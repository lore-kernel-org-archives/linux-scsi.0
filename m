Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF4E1C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 08:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 707A520748
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 08:29:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="e39GNmbH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbfKZI33 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 03:29:29 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:31052 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfKZI33 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2019 03:29:29 -0500
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
IronPort-SDR: N/y8w1xo9EpSzDzXK7I6rBs2q6hYVShiRlJoA2B5GScDtzVc8jB2S2ZgfydbUBBTrK/2oInW3b
 DeRj2zX6708OO/XOch+FNpIgwLQDG9R97GV0fwcBnXKAabVeIsoLmRzSgDX3/LwJGPh5Xv9P0t
 cWTmSe+grZ2senLdB/+hPxhyy1Krl2M30ch+D1xCaFQR9BJbCqKuk0koGlnpFKPE0+2DO8kT9p
 iY483OWKgnTp8JTeL8AUq1B9WRNfUFgGK8Nd4JxrVOcr+xJIg4duY5yh9MzMAS8Y7/sFPxDZaN
 CYQ=
X-IronPort-AV: E=Sophos;i="5.69,245,1571727600"; 
   d="scan'208";a="58363801"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Nov 2019 01:29:27 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 26 Nov 2019 01:29:27 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 26 Nov 2019 01:29:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jyNIURbwjHRwL/qwj8KuziDsz2/XPJabvnEC+dEfAX/G+xD/GDM0g2KQnKIiFq+Wdq+7FdxL4DGUJbDNTfojSf4ZbI4AcBCXQi+rqXdg3bsQv7hpzeYX6Nj4Apl+ay+50uHrAsAqwVBHFDeksgIDHpK1epafrrR+oi1GuTs5OO+CVetKyNeBUvuAO2gkKxal8VKxq6aIH2bJPxEyXaneFFa1Ddn11FfaiAGzpq2VO4tC53z+eYX8rnJvayCtoOLdbr8iH16RZMmaTgwJZ8UuyCx7JEigMfn1Sco692HR/LpFkIFw7PR0ZRMlrGFNmWd1uPYkizjMvpDiemN6a0d4Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cKdeOUsqFTcQYj1Bh8b4e0cZsgNtCzx2S0S69bdBdFY=;
 b=mrs/HUXvhqD86+Cgq12B/KyUvfDYrjSPxi9p/YeB2aRH91bij8qFcuT4u8baSrbyWuk3E5WrgDYwXGEee4KzOWg0ldRH7FrSrzvY/YDYWTXPJES1vM0cX5Vdarh6ELXdTLl0WSm9eQLehvgoS4pAkI1M8zbVGTQ6VJeKCLXM1XORYIeXwSpZ7DVZMUHkrNfHBMH7nWHF/iK4dBklJYNHHs7UJXb9FtYShCnJ+S/IbkDpoWKSaiATk/pqPKsP+ZRfT2VHz3vdOcPE4/oD39cNbdeWvP6kb7ujPCB6BBiwfY0GuowMh+Aq3SrkVuIQHula6G4nt87lV3w22qFa9IHiQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cKdeOUsqFTcQYj1Bh8b4e0cZsgNtCzx2S0S69bdBdFY=;
 b=e39GNmbHUbbWxfDDNYdsu/wZqcQ70+MnHZtXoMA6mVupo7GSZa7IwPz4DuQRU6PZyW+kb6W8BsfmbXzvSf0wI4ClD1IzBnZldKHlBPcpoEE62dTdV0s3EkiOgh+6dvze3RvsEA5PKoAzcOg1VRsWxNcHwmOBspJaOdJvBguWqZI=
Received: from MN2PR11MB3821.namprd11.prod.outlook.com (20.178.253.216) by
 MN2PR11MB4397.namprd11.prod.outlook.com (52.135.38.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.18; Tue, 26 Nov 2019 08:29:26 +0000
Received: from MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19]) by MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19%7]) with mapi id 15.20.2474.023; Tue, 26 Nov 2019
 08:29:26 +0000
From:   <Balsundar.P@microchip.com>
To:     <hare@suse.de>, <martin.petersen@oracle.com>
CC:     <hch@lst.de>, <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, <balsundar.p@microsemi.com>,
        <aacraid@microsemi.com>
Subject: RE: [PATCH 08/11] aacraid: use scsi_host_quiesce() to wait for I/O to
 complete
Thread-Topic: [PATCH 08/11] aacraid: use scsi_host_quiesce() to wait for I/O
 to complete
Thread-Index: AQHVn43E4UMeXCqcZkONCjITSdrIN6edJ+Lg
Date:   Tue, 26 Nov 2019 08:29:25 +0000
Message-ID: <MN2PR11MB38217B04BBC69A0D26B17398F3450@MN2PR11MB3821.namprd11.prod.outlook.com>
References: <20191120103114.24723-1-hare@suse.de>
 <20191120103114.24723-9-hare@suse.de>
In-Reply-To: <20191120103114.24723-9-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6465fbca-354c-409c-6803-08d7724abf6e
x-ms-traffictypediagnostic: MN2PR11MB4397:
x-microsoft-antispam-prvs: <MN2PR11MB4397F46454AD4956165A1E50F3450@MN2PR11MB4397.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0233768B38
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(346002)(376002)(366004)(136003)(396003)(189003)(199004)(13464003)(66066001)(6116002)(71200400001)(66446008)(55016002)(25786009)(3846002)(66476007)(4326008)(66556008)(66946007)(52536014)(7736002)(14454004)(74316002)(5660300002)(316002)(71190400001)(2906002)(478600001)(33656002)(6246003)(256004)(14444005)(26005)(186003)(81156014)(8936002)(229853002)(81166006)(8676002)(305945005)(7696005)(102836004)(110136005)(76176011)(6506007)(53546011)(54906003)(99286004)(11346002)(446003)(64756008)(86362001)(76116006)(9686003)(6436002)(5024004);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4397;H:MN2PR11MB3821.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xi35YtJhyIS9YVeF4MCd5jwQcP7H72q805I2v442IK+m4V9l2H/BJuLHEvWgWTaiQbhiQwO1zLUk2ffPqmFsY/t7Q29FiuFdwcTVilXcOtVGJ8ulggOf07S4yo570O56tGuz+aNQnB2jYjvc2EQTGsk5B6JKY/JLWXFbTArjmKw/cLVPW5dkRxhaaenl8PaDXtqyAlf5BtCGelMHLHjAZ31Nh52ziTly3IfwlQBVPvNLgIaUM0OCgybVfbQBkN6er/DfzDEDle3TYEn86BqunN4MpMHmuyk6N02N+ehg259H5ZpovPh6J/sqNQ8G9V9FlZNAADlBueVQYDVSLRNBfvekZeRsxGFjDbAA1QrD89P4kWeJPqUXe3d5IDN9H99ZgqD7mhaKjzS/uw0FJ/FynPBL1/GKTooTBvbec/3K2p7CinzDCl3LNfAG6P5/tW9f
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6465fbca-354c-409c-6803-08d7724abf6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2019 08:29:25.9755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7E8xV44uWY7adBxsk/NqmTCaCVbwJtMTAli5bDjFADBclYZHMVvpUCqXW+O4BXAzlvhvty9AaaXjjP7fZSu6hjl4+SzLsnI6klKNl1MhFJg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4397
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks, Hannes
We are in the process of reviewing patches and will get back to you on this=
 shortly

-----Original Message-----
From: Hannes Reinecke <hare@suse.de>=20
Sent: Wednesday, November 20, 2019 16:01
To: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>; James Bottomley <james.bottomley@hansen=
partnership.com>; linux-scsi@vger.kernel.org; Hannes Reinecke <hare@suse.de=
>; Balsundar P <balsundar.p@microsemi.com>; Adaptec OEM Raid Solutions <aac=
raid@microsemi.com>
Subject: [PATCH 08/11] aacraid: use scsi_host_quiesce() to wait for I/O to =
complete

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

Instead of waiting for all I/O to complete by monitoring the request tags w=
e can as well call scsi_host_quiesce() and drop the hand-crafted helpers.

Cc: Balsundar P <balsundar.p@microsemi.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aacraid/comminit.c | 35 ++---------------------------------
 1 file changed, 2 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/commini=
t.c index f75878d773cf..a01dca86eb37 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -272,38 +272,6 @@ static void aac_queue_init(struct aac_dev * dev, struc=
t aac_queue * q, u32 *mem,
        q->entries =3D qsize;
 }

-static void aac_wait_for_io_completion(struct aac_dev *aac) -{
-       unsigned long flagv =3D 0;
-       int i =3D 0;
-
-       for (i =3D 60; i; --i) {
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
-
-               }
-               /*
-                * We can exit If all the commands are complete
-                */
-               if (active =3D=3D 0)
-                       break;
-               ssleep(1);
-       }
-}
-
 /**
  *     aac_send_shutdown               -       shutdown an adapter
  *     @dev: Adapter to shutdown
@@ -326,7 +294,7 @@ int aac_send_shutdown(struct aac_dev * dev)
                mutex_unlock(&dev->ioctl_mutex);
        }

-       aac_wait_for_io_completion(dev);
+       scsi_host_quiesce(dev->scsi_host_ptr);

        fibctx =3D aac_fib_alloc(dev);
        if (!fibctx)
@@ -352,6 +320,7 @@ int aac_send_shutdown(struct aac_dev * dev)
        if (aac_is_src(dev) &&
             dev->msi_enabled)
                aac_set_intx_mode(dev);
+       scsi_host_resume(dev->scsi_host_ptr);
        return status;
 }

--
2.16.4

