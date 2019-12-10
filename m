Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF5D1C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 04:59:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9A6D20663
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 04:59:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="IoyQtxvO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfLJE75 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 23:59:57 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:21758 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbfLJE75 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 23:59:57 -0500
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
IronPort-SDR: a1Iu5ndUwuNdzv+gb66rFTXgazX8iLUzdazl/2haOGi+STXC8iTicyrg7bMNiltfoF6lsq+B6X
 wIrYJYYKCRoOo9eGAV2JJQgdZDjTAw9uiYwtVw6XFOlrR79v62MgMBnmHMSmgFYn3xLs6q8PxN
 UMP8g+NilCF9F5eKL0q8uHQ0mBCVBc9/a620VL7Ok7pNFf9HUD/z1b4mNM8yw8hc5MwKxgmy18
 FZ1h7cuzAVMID1DoBBXGmOfKHyGircSf+g8O8x50/54CeFGpB0pRR56H+ORPaqJWgfk8xmFVCP
 cyw=
X-IronPort-AV: E=Sophos;i="5.69,298,1571727600"; 
   d="scan'208";a="57977989"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2019 21:59:56 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 9 Dec 2019 22:00:00 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Mon, 9 Dec 2019 21:59:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=baWQcUIhj6c4z3Y4yboTJ/YCs+Yd31KzDmEZJMjLcwx9SJ6MApdL9ZvqvNZecj277dQ7cXKtfjwv+lTwxBH9Ij3Pq8UNtt/E3sghedPpXPj1NI6JNJtiO+hmBEDsvwovNrRRELKLLJO6HRlMMH3p86WGqDNOwgVkfeQjAnw2vDywOuhQO80auuL/WP/s+n87JEngTXd/haZZne4kygsUphQ/qAKj1N1MYvhT1pT/wM42ARXXnMnEA06WZWknCNgnWhUXGN0Z2Cd3DcgoowiBU/BGyc3FGV6Y2VJjYDZTqw9LbNovQNh/yNAhQ3ZDK3vYleYWx0bCcTWASMNM9G20EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0YeAfBj0byE3og3U5WIZo0ffEIpoE1Q2dssnzIMmy/c=;
 b=fEOT9pOWorirfLRQQt9K+9sDMXc1c79XRItDl5UFUnNyD79i4sQ2NZv7SzHC+wexc9PYrSNMVYhVVi1w75Y2F/kzKirsXWf9OWijx7DlzXpjAffdwLlr42P+DTBfH3WvkSLcDfJ3m2oS0J8JLSPiJJvWdSNOt70sEaLO/eZcMwNh6Oz5MFpUh7UNfOw21V3A8WYHPrgZ6IbXVNwgM6TTa2gTzy0AI+kOzmzYYH31WFntZYpfJwSU4TkTyl2ubg4CMGCxMk1h+ihh4mmPvk8rnkdiVG0jAHAnPsG9qNwWVaqEbskyFXLa2dCeu0qkHfGb3XBIcsGRmtODF4fXvrvd5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0YeAfBj0byE3og3U5WIZo0ffEIpoE1Q2dssnzIMmy/c=;
 b=IoyQtxvO3zujBMqi4UTE5ct5zmwkvfgDG+yCAzeDwFuiUgQGr+mU3MW+NJpMv9kiLE8CYU6hmlY8V2nZIaojqUol+iaPaCyEIA97nIGEPSc493t7ronRp5oa8RkksvI6rF0ph1xgjuWl9lbq2wzz8nU5yB2Dpip38+209FLntHY=
Received: from MN2PR11MB3821.namprd11.prod.outlook.com (20.178.253.216) by
 MN2PR11MB4269.namprd11.prod.outlook.com (52.135.38.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Tue, 10 Dec 2019 04:59:54 +0000
Received: from MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19]) by MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19%7]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 04:59:54 +0000
From:   <Balsundar.P@microchip.com>
To:     <hare@suse.de>, <martin.petersen@oracle.com>
CC:     <hch@lst.de>, <bvanassche@acm.org>,
        <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, <aacraid@microsemi.com>
Subject: RE: [PATCH 06/13] aacraid: replace aac_flush_ios() with midlayer
 helper
Thread-Topic: [PATCH 06/13] aacraid: replace aac_flush_ios() with midlayer
 helper
Thread-Index: AQHVqrNwyI2KheBjV0CiR0ZB1OpYp6ey17oA
Date:   Tue, 10 Dec 2019 04:59:54 +0000
Message-ID: <MN2PR11MB3821A862300C77EC201FF0D9F35B0@MN2PR11MB3821.namprd11.prod.outlook.com>
References: <20191204145918.143134-1-hare@suse.de>
 <20191204145918.143134-7-hare@suse.de>
In-Reply-To: <20191204145918.143134-7-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e112c4e6-613a-4bf4-78d9-08d77d2dcbed
x-ms-traffictypediagnostic: MN2PR11MB4269:
x-microsoft-antispam-prvs: <MN2PR11MB4269679DF38CEB6D3347575DF35B0@MN2PR11MB4269.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(366004)(39860400002)(396003)(13464003)(199004)(189003)(316002)(81156014)(8676002)(478600001)(81166006)(2906002)(6506007)(305945005)(229853002)(54906003)(110136005)(55016002)(86362001)(53546011)(33656002)(26005)(7696005)(66946007)(64756008)(76116006)(71200400001)(9686003)(186003)(66556008)(66446008)(4326008)(5660300002)(8936002)(71190400001)(66476007)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4269;H:MN2PR11MB3821.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iNY2cqjChpIlJkwDbGCbIAHFPrLQ/UJMh2rb/67I9DvkQYBCan9mCq+ke2r/RvqEWyGfy4mVZVTk0Y9vE+m+BstZ/QSptYOSp9P2tiKA1MRc4IPvf0geUUk5aq6+eEeFnNYhKhDzSfhK1DbDnq94VTGXcAxjgGM8voRAS2seG6ttD+AXCiHrpizfNvy7Vj58bBQsIZS0ChYOXzUAk4ilzDrKs2umGQLuX+cmx7AYYyBMrBx3mKTjGcabsTkWL5kZwPUELTQ5Kf/I5/zvxSMC4+qoJDBXirwUlyyiEcXW00bakhiGhDLYeaXDsaXzEQBNFFEqXXGvIcqASniAK4FxP64z7bykduILJzdk/rtsW5UJ61R/IQ8f8lsnck/dczWhTmt9MSfggd2BkNS0BHEbNH13EhByZY1e3qqd16hITMsSeeAlQXwURhrQRdUbdydEgStPbq+YoTp2j1BViamg1KXx18QsHx97s3uy8Y8K5p4L2dhLdjaL4j6LvEcvRimH
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e112c4e6-613a-4bf4-78d9-08d77d2dcbed
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 04:59:54.2893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qnrxIaAY9kdJsgJ2Y+C6femiUx8PuKyOowrDb2q8mWkQC4/+ej/OH/LIVwRPpc9O+ppQBoOMt3u/pGzaWYdqr/RoKDCpabRNddCCDLTx2IE=
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
Subject: [PATCH 06/13] aacraid: replace aac_flush_ios() with midlayer helpe=
r

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

Use the midlayer helper scsi_host_complete_all_commands() to flush all outs=
tanding commands.

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Balsundar P <balsundar.p@microchip.com>
---
 drivers/scsi/aacraid/linit.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c in=
dex ee6bc2f9b80a..4d5b34e0d3a9 100644
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
+               scsi_host_complete_all_commands(shost, DID_NO_CONNECT);
                aac_release_resources(aac);

                pci_disable_pcie_error_reporting(pdev);
@@ -2023,7 +2003,7 @@ static pci_ers_result_t aac_pci_error_detected(struct=
 pci_dev *pdev,
        case pci_channel_io_perm_failure:
                aac->handle_pci_error =3D 1;

-               aac_flush_ios(aac);
+               scsi_host_complete_all_commands(shost, DID_NO_CONNECT);
                return PCI_ERS_RESULT_DISCONNECT;
        }

--
2.16.4

