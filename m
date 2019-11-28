Return-Path: <SRS0=EtEA=ZU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76EDC432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 11:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 946162178F
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 11:41:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="TVrjFF6t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfK1Ll3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Nov 2019 06:41:29 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:51191 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfK1Ll2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Nov 2019 06:41:28 -0500
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
IronPort-SDR: F/onTnD3Wv+RjbEThGrgu1KheChE7gdbGJBDE7kqEkTr819B2Ar1H8CrReL/PO7xI7jhUSUjQ4
 epmk3/Zf+FaatF4uLHsMLl4q8RN9Ai3+JN/LAkUy3NbJxo3UcQORgfnOBffJ3yKeK4fnAtkqE2
 s4uuw47KTfQlkQNmNQnlPfD3F+K7yA5lyFFSJyBp1NVAk3hUeAY7zhnn5JqQarMPeC8VrAWjEC
 OGN26j+BlapTrhKtBhgh97kRtXiLBinL0h3Qm2UVqZE8aFBIMswgZFWbmDXjoRj7X1tUXM5jE7
 rdo=
X-IronPort-AV: E=Sophos;i="5.69,253,1571727600"; 
   d="scan'208";a="57171342"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Nov 2019 04:41:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 28 Nov 2019 04:41:23 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Thu, 28 Nov 2019 04:41:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9Ai54cYHf8/iGbtCeJXOEwm/v++9BQIaYux0gmI1NnMTzU0wzuaFN5zrqCdc5RfkJ547dx/zcT+p3sHFuZuXxCtUygvdhC00e4AC84pAN0JiIA26m+XLjuyQrjLNwtjnBxHxucUhyFzCCYxzH9zSie66OiQmNJYCRWDb14DkzyZRbbTscqIXTY/cqvgoCw3cUfeiDyWjmnbDl6Xn/hEP4BxJLpbeyeQlEJw4PF5HzsWGHI/bVwIt7LhDrR37Jifl0sAyO91PGIyOk33CKva5Oh1ViTEWHm7E975GVrHphg1gEFW6x6hz6MgDDM8sKdCvvhmrlaLTx3AJ6qWm5dQPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zILojS0jDpx7JY1X22LNdbM7J91dSWUndxh3jVulPIU=;
 b=KW6G0JkUBbAVQpCKY/0cEZRFgNmiAAuyFpbm/HyAPsIaK0USl31IbQy59C1h3SkZ5QyGLjLxPKJwAUTpP5ktLaoQCWrNo1w4q3mhKRJSSrNjUf19nPtpSvoMsYfxZTGiezCiofde21/SEAHs+o18qz+zpZa83UHyKtGZbfGxRPOk7iq7q3K30cr2anrLdraO/q8YBtAtasZZspC+7CTLcbt0LYsCf+cAGM+BJZ51+fpMpuMa6nbNT1Dap8XzT0pSV0LjtQC24JK+28E4GPocKhyQiOBuVKdkzOkq6vEL4hNmNJe6g6A0RPgm4Z5Cjv2cuHaElVg2vwEgL7Pr7KWDEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zILojS0jDpx7JY1X22LNdbM7J91dSWUndxh3jVulPIU=;
 b=TVrjFF6tzYxXPFC7jem6Lx2Ijeb0Rg0o19XNKLonIe5SnMp8JzMVc5XGPaZjlu2ph3FDL1O3iI11bLJ6y383LAPhvPH5fb/JQUKzX6OzaBOjLU653zdkgugxyi3si4gcVzDyrCXP1WWyXtLVbxjsvQlEEPaZR/Ns54TkLf+AXGI=
Received: from MN2PR11MB3821.namprd11.prod.outlook.com (20.178.253.216) by
 MN2PR11MB4143.namprd11.prod.outlook.com (20.179.150.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.20; Thu, 28 Nov 2019 11:41:22 +0000
Received: from MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19]) by MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19%7]) with mapi id 15.20.2474.023; Thu, 28 Nov 2019
 11:41:22 +0000
From:   <Balsundar.P@microchip.com>
To:     <hare@suse.de>, <martin.petersen@oracle.com>
CC:     <hch@lst.de>, <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, <balsundar.p@microsemi.com>,
        <aacraid@microsemi.com>
Subject: RE: [PATCH 05/11] aacraid: use midlayer helper to terminate
 outstanding commands
Thread-Topic: [PATCH 05/11] aacraid: use midlayer helper to terminate
 outstanding commands
Thread-Index: AQHVn43gGhePwIPBy0qOxb1cxLu9Haeggl1Q
Date:   Thu, 28 Nov 2019 11:41:22 +0000
Message-ID: <MN2PR11MB382179C80FA39AF3A8CCC380F3470@MN2PR11MB3821.namprd11.prod.outlook.com>
References: <20191120103114.24723-1-hare@suse.de>
 <20191120103114.24723-6-hare@suse.de>
In-Reply-To: <20191120103114.24723-6-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 50206677-d1be-4f9f-fe4d-08d773f7e47f
x-ms-traffictypediagnostic: MN2PR11MB4143:
x-microsoft-antispam-prvs: <MN2PR11MB41430297D99D8FA624EC3831F3470@MN2PR11MB4143.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0235CBE7D0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(136003)(396003)(39860400002)(376002)(13464003)(189003)(199004)(6506007)(53546011)(76176011)(8936002)(14444005)(256004)(81166006)(81156014)(8676002)(5024004)(7696005)(71190400001)(25786009)(5660300002)(305945005)(66446008)(33656002)(478600001)(74316002)(64756008)(99286004)(7736002)(14454004)(66946007)(3846002)(52536014)(86362001)(76116006)(66476007)(66556008)(6116002)(229853002)(9686003)(110136005)(6246003)(4326008)(6436002)(11346002)(26005)(446003)(71200400001)(316002)(186003)(54906003)(55016002)(102836004)(66066001)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4143;H:MN2PR11MB3821.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y8Zl7NktJjlLaXp1IrHQHCRzjFrYJgp/8NmFo8d+J7aStfGFF/hRQxFg0nTKHBaTQmXMc17t6Wzb87McnZdW3IdmF0uFFd7GM0OnCxCDuPxa+cl0B4pTy4Twau6kNQ3vzg1Dy90pqZfQiwlMaqBQKGtTyZsGcY4G/wVJOYcISzAbLeB8pW0WkIH7rGD/aFMz7EA69pFnfW6FSZ4Y8iXcDnjOAyUX9K1lBkwGU8Ydw93S9+mN+OiyA32N8d5WO1YZTQOaoUa1ED+pfPpQdZoGJVqxN9RSWij8OIamHOrx8mFpeWdaw0+GIAXT7nbj/fyK7il4OChOGuu40comOsbgbrHhVWfT0/t2x1EBoMkflV8mY4icSrzXH8EQ2wpvzemO+FxlUET1ZEPDI5PEI4lDUnBg3xXsWUKXq3pK2ojdr7KbsNrwh3HupEDeWqQmPOiF
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 50206677-d1be-4f9f-fe4d-08d773f7e47f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2019 11:41:22.2535
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uClNIXfstZN/ShGf8luwzK2n8nuZTKBqneVxpcOT9n5xJ4yTNwA4XoAUEAtiAsm0zAUqLm5XtR+y4gkKu5H9GU8yNHVZDUfNZUOm3/trXtY=
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
Subject: [PATCH 05/11] aacraid: use midlayer helper to terminate outstandin=
g commands

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

Use scsi_host_flush_commands() to terminate all outstanding commands instea=
d, and change the command result for terminated commands to the more common=
 'DID_RESET' instead of 'QUEUE_FULL'.

Cc: Balsundar P <balsundar.p@microsemi.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aacraid/commsup.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.=
c index 5a8a999606ea..e413b784a8d0 100644
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
+       scsi_host_flush_commands(host, DID_RESET);
+
        /*
         * Any Device that was already marked offline needs to be marked
         * running
--
2.16.4

