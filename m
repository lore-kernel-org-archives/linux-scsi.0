Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E090C2D0DB
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 16:24:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF0BB2087E
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 16:24:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="pZvBFxz7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgATQYZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 11:24:25 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:30569 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgATQYZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2020 11:24:25 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Don.Brace@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Don.Brace@microchip.com";
  x-sender="Don.Brace@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  -exists:%{i}.spf.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Don.Brace@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; spf=Pass smtp.mailfrom=Don.Brace@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 4iDLFhaG2ispnJhPU6FSTVX35iAEXaZ7DG/SlDgIaSxNXEnINjNzrmBjUYScpP45e6IM+0/0CH
 eHeMQS7bKYRGHoR2o/EvCgi65V1gryM2PsfPgEdDQ79yhrqjgLVels48qnWOM/ayp+kSFjiNfv
 zlpwc5cZqxcgIEoEM/59msRXVI+Wv4Z7u5LyhvzKAFUBmK9roeAmQA1gHkfuPZmR9sCQSewgDI
 4dVBqPyI7+jgUvLqFJa0mQczgmjf/+8rbQKR2Kac9B4DHu0SyDK/jpea81SnxUxeGH8LRTiY8D
 vYU=
X-IronPort-AV: E=Sophos;i="5.70,342,1574146800"; 
   d="scan'208";a="63899866"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2020 09:24:24 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 20 Jan 2020 09:24:19 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Mon, 20 Jan 2020 09:24:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJOs2/8d3BlvoJvFIYTXw662aTikbs2+UgQay6uGEMd7J0RQwqBfWhXVT/DFcNQ0PyzKeyCDvddux0Cywjx6pWDwF+K/K/XB0/7Pf/5CljDYMJPjXaJ7yWYEyQofF/Z5ap8oLxNfnd1i/C5VLb+72XF32zJ/2XbKEsb5tMRDLPH1bUtUEwPfiv+BHaIuquP9QOD07ACWhbsZ+TnI4ABfE2h4xksAaQrEAuJEENcYggtgD4zwSdENjXftEpxIP/rPaSRvI/oUXIscJCnOHH/D4/nx2Cl2sdn7HCKxhkBJ4MewVl/XYR2jGq246X0z9V5wod7nykINPy2orkc6ms8W7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LIXoMzSsNSY1kxjyFdNWueEu66r/MCRjhggS2jJVqzQ=;
 b=UsQ/QP5O3NZdlN/DleReDH5+qf5SYb8YykbdM78OrQAibCqQfOlCEvqyFf38F1SmrOKx5XRzxcRcnaunfpkeII0PW9/S+EvlkWugyzv4tB3lYbNAOZSMLF+k4f+jvDPjFwZHaOxyRu6Dza/YnP/yCzJZNbukEhhrg/gDrwViYQf4jehejHP7FbGrVCES4WZSTkVT1Lm9loL1JJYCUJVv99bp98qn4KA7LzeY/Vw5nprd2JXSpop/R+Nv+r/vMxIQv6gIpfzFmWlKhFFwKMCVLSHbRaOLvYZE9DHyJaGJVsltehkFE4watBrCWatW7u/s3vaGw57kM85ObtON5YcSAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LIXoMzSsNSY1kxjyFdNWueEu66r/MCRjhggS2jJVqzQ=;
 b=pZvBFxz79kAVKD0UEHcLIdgYvQpodWjgXfE2mZb8hcPkZMmrtwu5qAR86VnvvRM6xU+QBsPWEouZw0ucQhiSSVqm+RZ54LOTM5sJnCp5p8ViLdldV2GB5yVfzBoFcHbNC+YV6LW0xJ5mpwR50JoPao1lxbCKfbjqbOdKKjNN04A=
Received: from SN6PR11MB2767.namprd11.prod.outlook.com (52.135.92.154) by
 SN6PR11MB3183.namprd11.prod.outlook.com (52.135.112.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.24; Mon, 20 Jan 2020 16:24:17 +0000
Received: from SN6PR11MB2767.namprd11.prod.outlook.com
 ([fe80::89b1:1764:88f7:bbd8]) by SN6PR11MB2767.namprd11.prod.outlook.com
 ([fe80::89b1:1764:88f7:bbd8%7]) with mapi id 15.20.2644.024; Mon, 20 Jan 2020
 16:24:17 +0000
From:   <Don.Brace@microchip.com>
To:     <hslester96@gmail.com>
CC:     <don.brace@microsemi.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <esc.storagedev@microsemi.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH resend] scsi: smartpqi: add missed free_irq in suspend
Thread-Topic: [PATCH resend] scsi: smartpqi: add missed free_irq in suspend
Thread-Index: AQHVqcrK3AMbNjW5nEeQNYbWML5+Dqf0B2CA
Date:   Mon, 20 Jan 2020 16:24:17 +0000
Message-ID: <SN6PR11MB276708CE42A1B7B8FF6BDB74E1320@SN6PR11MB2767.namprd11.prod.outlook.com>
References: <20191203111337.13054-1-hslester96@gmail.com>
In-Reply-To: <20191203111337.13054-1-hslester96@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [216.54.225.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40ac5421-e420-4213-f29d-08d79dc53246
x-ms-traffictypediagnostic: SN6PR11MB3183:
x-microsoft-antispam-prvs: <SN6PR11MB3183D7C156B82E750D57CCB9E1320@SN6PR11MB3183.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0288CD37D9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(366004)(39860400002)(396003)(199004)(189003)(52536014)(478600001)(76116006)(15650500001)(4744005)(9686003)(6916009)(8936002)(33656002)(81156014)(26005)(8676002)(54906003)(186003)(81166006)(66446008)(55016002)(64756008)(66946007)(86362001)(66556008)(316002)(66476007)(5660300002)(2906002)(71200400001)(7696005)(6506007)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB3183;H:SN6PR11MB2767.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WjepupZgfHt0AwmwYzPRY+tf6pud/JFQWA8b0ocPegRXnRU5S3D31hFERjtLGV2cRywh3msAuNjD8Cjx6aPZ4PyZedpMN6XqEyDRBAzoAb6CNHDhE+YrqbUsYL/tGipY0749sxntv8jMWTU/ul1QqVoVTznDYyBGC9eVTF0GQeKk+IY9BItPj4xRknzvMWt9+SBpA8rMVwv7mLNo+ybRRBBWGhhM2KhQduHsdYUYlFGi859kYrt8bwCUGWHqyr5sI0lmkHNxlIP3GOnDuiLFdODYu6QykYgvTiuZrvhiQDgV4jTZmtaHdIw8yqo8trLAUcwF10vDYkdkkGZEOtNTFbbnC+LrZn94KsKVHrLspP76n6DXMLKmyGhFqepN5DtW9e/RcRuLYXIueXQ+J/5o1wpyjJa4UODVsCHNNmmUcEux27CVL5TiouVW8Tn+Fj+r
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 40ac5421-e420-4213-f29d-08d79dc53246
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2020 16:24:17.2204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e61ZLJF4NS3YozWIbv1r4zBSM5XJqdF7fEW4uk4mZvEFam/1HgjDfNlz2/EpJ7WnfZW9XQm747J65tU9r6Iw9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3183
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----

The driver calls request_irq in resume but does not call free_irq in suspen=
d.
Add the missed call to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

NAK: free_irq is called in pqi_resume after checking for correct power stat=
e change. (in pqi_free_interrupts())

Thanks for your review,
Don


---
 drivers/scsi/smartpqi/smartpqi_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/=
smartpqi_init.c
index 7b7ef3acb504..2251c39afb1b 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8078,6 +8078,8 @@ static __maybe_unused int pqi_suspend(struct pci_dev =
*pci_dev, pm_message_t stat
        pqi_ctrl_wait_for_pending_io(ctrl_info, NO_TIMEOUT);
        pqi_stop_heartbeat_timer(ctrl_info);

+       free_irq(pci_irq_vector(pci_dev, 0),=20
+ &ctrl_info->queue_groups[0]);
+
        if (state.event =3D=3D PM_EVENT_FREEZE)
                return 0;

--
2.24.0

