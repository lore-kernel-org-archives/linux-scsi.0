Return-Path: <SRS0=EtEA=ZU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1048DC432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 11:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCCC721781
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 11:41:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="Qej+pPg4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfK1Lly (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Nov 2019 06:41:54 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:12427 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfK1Lly (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Nov 2019 06:41:54 -0500
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
IronPort-SDR: Yyqjvq/BhBzfrdh4yNcVLUu3CkQ5tmF7HLp53wYK9E3zRYm1+DpfKfdOoO/IJnGFn6XqBc3k4T
 fdnW7RbWmLYzQrmRtFsenyaqW56YgHOXzcv8OS54Jnnkf3DZ2k2jGmnoDufCSRCpDR1xBhGmpP
 G+t1/B6xALSYCyuo2ITd265SA97DWkg0Wd99rcuyOjNljwEVX2dEcvFj9Q6Pf6B5oun/cstAEe
 rvC7wGPaXm8UezTQrMYGtkkTMSY2uMo+biMZxYsFQbIJNpJdUl7OsHTC2LMG5VP+FYVMMn12eB
 Ewo=
X-IronPort-AV: E=Sophos;i="5.69,253,1571727600"; 
   d="scan'208";a="56902567"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Nov 2019 04:41:51 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 28 Nov 2019 04:41:50 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Thu, 28 Nov 2019 04:41:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kQBFCJazy/A+J+CXK24OPNv9qz/4qNs+kHCGsxWdFC8L1x7eZb8Jr3oYDnVcdM8cPOfP6Mx8xoDkhprPCDklEIvneTwzmOyuzqSrmJWbhm/QlTpGzKyLzIN9OS7blTNRY6zndEiA/txOEghsEEk/ZLVcAz5BJjWORU3aiMhoKu67DV1BQEzrAkt/LOKaXr3ycER3c1vvwBE5v0ixb3ML6m4Xp8SBFEKbeW3YAWhDstWw65MJRm1uEeRmLOk+fcnD8ph2a5bfokQFmSlhAaW7qtI88gKAYQbuts7XUKdH4RG32lvbLjfJM8TdOQFkmIH4xwBsDBkA0RX3DDCJVqxmHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=19BSrYut4rvawLfQ8zTMQpL6egkba4D+RWsUwCQcy0U=;
 b=TT+gV0UXu+pGK1Cz4DTgKqQDy3Y3f8yZLHMvC6n/nKOPz89gNfuy+UnzB7j7HW9R5UYSpi7XY0O2TsPHqvS2WU+vKvJdWKpeer2JHE1V/w9YI4JJmBhKrvf5prDlIzglqM8eob0UinQF+YhFhmMmsa7hh2aSfCE370QpwGI17Pc1kHmusCElgt4Loo2DiGXELjeVVQUQ41pEqAvqKQF1zhP0hSOW/rr4WtCWwuubXTNzErTUudaU+d/mY6LdQy6sdHe97++jUvD/LK0uBuK1QmxOE1GDyUj54mi8Kura000e8Hn+Izhq1BITWccs2GOZ+lY7k503jNdjgMd/Iz1ptA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=19BSrYut4rvawLfQ8zTMQpL6egkba4D+RWsUwCQcy0U=;
 b=Qej+pPg4XsQk7bq2BWH/aZlP9n3qMooOeJP0jM41QkezBqj7n/M2RUxTn2rWqDZC9ocgixu3NTQvpBpcXNa7Lb9+Va7dAQUg5Pa4L307mYNDotdkSvcT5lIL14/C8g8OrIFi7HN8cvAG4iF4gOI35WJ6CjxWO6LG82QXtUQvBWk=
Received: from MN2PR11MB3821.namprd11.prod.outlook.com (20.178.253.216) by
 MN2PR11MB4143.namprd11.prod.outlook.com (20.179.150.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.20; Thu, 28 Nov 2019 11:41:48 +0000
Received: from MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19]) by MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19%7]) with mapi id 15.20.2474.023; Thu, 28 Nov 2019
 11:41:48 +0000
From:   <Balsundar.P@microchip.com>
To:     <hare@suse.de>, <martin.petersen@oracle.com>
CC:     <hch@lst.de>, <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, <balsundar.p@microsemi.com>,
        <aacraid@microsemi.com>
Subject: RE: [PATCH 06/11] aacraid: replace aac_flush_ios() with midlayer
 helper
Thread-Topic: [PATCH 06/11] aacraid: replace aac_flush_ios() with midlayer
 helper
Thread-Index: AQHVn43i8214RvAYHkmNPG5kFUiXS6eggnlw
Date:   Thu, 28 Nov 2019 11:41:48 +0000
Message-ID: <MN2PR11MB382114B6ED99F3F37584A1F7F3470@MN2PR11MB3821.namprd11.prod.outlook.com>
References: <20191120103114.24723-1-hare@suse.de>
 <20191120103114.24723-7-hare@suse.de>
In-Reply-To: <20191120103114.24723-7-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8792481b-07d1-4c78-4a54-08d773f7f445
x-ms-traffictypediagnostic: MN2PR11MB4143:
x-microsoft-antispam-prvs: <MN2PR11MB414315912A288D172418BA86F3470@MN2PR11MB4143.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 0235CBE7D0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(136003)(396003)(39860400002)(376002)(13464003)(189003)(199004)(6506007)(53546011)(76176011)(8936002)(14444005)(256004)(81166006)(81156014)(8676002)(5024004)(7696005)(71190400001)(25786009)(5660300002)(305945005)(66446008)(33656002)(478600001)(74316002)(64756008)(99286004)(7736002)(14454004)(66946007)(3846002)(52536014)(86362001)(76116006)(66476007)(66556008)(6116002)(229853002)(9686003)(110136005)(6246003)(4326008)(6436002)(11346002)(26005)(446003)(71200400001)(316002)(186003)(54906003)(55016002)(102836004)(66066001)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4143;H:MN2PR11MB3821.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 86XumgCA2Tow/UAmAXPPSssnR5mFIGgVecEZ6MbB054Dv+fu/h4LpVicIjsuvqYw7CNqVt6h0+ZIwXgqBMxh0vKKN+at/qMvl9qy9qI24JePPDP6DHChHqM7p6FIUQ5RgdWdjlgzgply2hJ5uoTkx8MzQPZReNkJOOreRJ47y8eRfB8Y6u3VVIIVHDtreQU5zoax6GB1j9/Scz+y9t5huvTg5vuEmfnEfzzwV9MV3fpWHqSsc2Zm2/gGfPEygTUF8GciZ+iCJp+/4j4MmAbaqRqxynC070U3fbLarPw9lbYPvMyv5Op/3pIRs/EAftn2Du5zMstUniJJ/F72Gh5I3dfKoZp7PhBWOXHaP/AwrKCERf3E46OEQ8kos7lYNMqrFXfHqPxvb9UFdUhHKLCfDyBqZubSqCtvtTMOsepfhUIXjE/2VaGsEPPOKoHvV7bB
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8792481b-07d1-4c78-4a54-08d773f7f445
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2019 11:41:48.7203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hM5syK/5t4UB3WaUSEWBnWH7bb13zQiq5X3pu966QWdskjl8XtVSXOdCqHVFEqRjHiEP7ofy7bCITa5ZVXozU00l85v7+Eakm2AB4sybSnQ=
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
Subject: [PATCH 06/11] aacraid: replace aac_flush_ios() with midlayer helpe=
r

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

Use the midlayer helper scsi_host_flush_commands() to flush all outstanding=
 commands.

Cc: Balsundar P <balsundar.p@microsemi.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aacraid/linit.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c in=
dex ee6bc2f9b80a..847dac80defa 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1977,26 +1977,6 @@ static void aac_remove_one(struct pci_dev *pdev)
        }
 }

-static void aac_flush_ios(struct aac_dev *aac) -{
-       int i;
-       struct scsi_cmnd *cmd;
-
-       for (i =3D 0; i < aac->scsi_host_ptr->can_queue; i++) {
-               cmd =3D (struct scsi_cmnd *)aac->fibs[i].callback_data;
-               if (cmd && (cmd->SCp.phase =3D=3D AAC_OWNER_FIRMWARE)) {
-                       scsi_dma_unmap(cmd);
-
-                       if (aac->handle_pci_error)
-                               cmd->result =3D DID_NO_CONNECT << 16;
-                       else
-                               cmd->result =3D DID_RESET << 16;
-
-                       cmd->scsi_done(cmd);
-               }
-       }
-}
-
 static pci_ers_result_t aac_pci_error_detected(struct pci_dev *pdev,
                                        enum pci_channel_state error)  { @@=
 -2013,7 +1993,7 @@ static pci_ers_result_t aac_pci_error_detected(struct p=
ci_dev *pdev,

                scsi_block_requests(aac->scsi_host_ptr);
                aac_cancel_rescan_worker(aac);
-               aac_flush_ios(aac);
+               scsi_host_flush_commands(aac->scsi_host_ptr,=20
+ DID_NO_CONNECT);
                aac_release_resources(aac);

                pci_disable_pcie_error_reporting(pdev);
@@ -2023,7 +2003,7 @@ static pci_ers_result_t aac_pci_error_detected(struct=
 pci_dev *pdev,
        case pci_channel_io_perm_failure:
                aac->handle_pci_error =3D 1;

-               aac_flush_ios(aac);
+               scsi_host_flush_commands(aac->scsi_host_ptr,=20
+ DID_NO_CONNECT);
                return PCI_ERS_RESULT_DISCONNECT;
        }

--
2.16.4

