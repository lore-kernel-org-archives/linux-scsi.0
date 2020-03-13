Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0DADC2BB1D
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 05:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7212B2073E
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 05:47:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="IfLpsNXc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgCMFra (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 01:47:30 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:24672 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgCMFra (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 01:47:30 -0400
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Balsundar.P@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Balsundar.P@microchip.com";
  x-sender="Balsundar.P@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  -exists:%{i}.spf.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Balsundar.P@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; spf=Pass smtp.mailfrom=Balsundar.P@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: fYYb8roW9A52GncSgH1Rj9L6tJJEnyc2VivjJVvgmeWiwJqMj/X+dV0IRiuskcEGkKp3nigAbN
 dlrUS7w8E4rCY7WONF0ec8p7s/u5jr/dtdfHbyfBefO0eZNOXzsrUXu7xQtMnKt35zmBNCxNTa
 /DgNSHRBvQvVq/DMZ9VZm/ltpdLF7VOPLAd3yFpkfVWtvqhcUYoWWUJJMAP9AnJtnoZKETbvI+
 NUz2w5yTUyGSgepOl+N1AI/3/NjBIDT3fGvk1AURuhJcWVKR+1ap6jeU+sjEMD5fsxPlbHTAwb
 qBk=
X-IronPort-AV: E=Sophos;i="5.70,547,1574146800"; 
   d="scan'208";a="71905622"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Mar 2020 22:47:28 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 12 Mar 2020 22:47:30 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 12 Mar 2020 22:47:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PgDoxeELJ3WVNI6RTEOsXB2XqI7LE3oPqPAUe8L2sARVF/hXkiKP95I9vj6qClLBcMWFqytUUlhdFgdVCvxfbKyMeWv0lfdvvqKvG5YiIrf8qnGIoUQd3STfj4pyoXazxsNRlmGhM3selIDQD1Maf9EaTBixbZr7PAbxLzbU1Qwkp//P+RnJxo6hwt0KvAsmsrZ5f89YDVCAed6Jh4/3TnbdINsQ7tOE03glz4eyM4I63BLLsCiamcbjQRDXDpgiUmhVY0SR6lRALXjI1F3Pgvvc6QwF2giMQG4gOQN9xLusbcRlWWj0KDVfkp0rY3LCokznxxLdCdYJ7NLfQsDCRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUqskvncqgLd0C42kaunLXSWCIj1KLkdFmeqaT7E9YA=;
 b=YlfYJJjp46p/i+7JKciPnBIcsecUvy51sMbcYkEEmtYkXH45godoBd5VxxmTyOPA1C/rdW8EC/iioVVvjXetmFF1oOxt20I1bDJrv20AApw/Ay2IUFxStf/ZzezwTvquFNqdkeOKuwtdDWfE+oBmQHH9z9PqdhHYFrThdduBiDNZw25iHg5zdWrAtAQ2GxU8d2HLVqIXYgV63VRJIFY7DsWwDYEZ6YRwzfCsxDCaDtuthTeJEwErTtdj+oCBm+0o60PmsVrX58eL+78swqyR/20SrrJejFh1GouSc5NlcGL6j81lg2qS/9WEDc9Oo0UQ5z72gG+R4t015mR02ILtoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUqskvncqgLd0C42kaunLXSWCIj1KLkdFmeqaT7E9YA=;
 b=IfLpsNXcMQPdQoxWd/XfzzCa2/Fpwnya72uaX1uLBNuAa/vU8p8i3S6BzcQ5zkxAi6rp8DHC7c72appkr+PJiyaxjHdTN3NGtK9YOEQjpZuXxz3xCkwCQ0RtRb7IFJAAXcBzY/Vx8laepAim/GkOu2ZfLJvwoRikJm/iypijAjE=
Received: from MN2PR11MB3821.namprd11.prod.outlook.com (2603:10b6:208:f7::24)
 by MN2PR11MB3600.namprd11.prod.outlook.com (2603:10b6:208:fa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Fri, 13 Mar
 2020 05:47:26 +0000
Received: from MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::d9f7:7681:fa62:8afa]) by MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::d9f7:7681:fa62:8afa%2]) with mapi id 15.20.2814.007; Fri, 13 Mar 2020
 05:47:26 +0000
From:   <Balsundar.P@microchip.com>
To:     <tiwai@suse.de>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <aacraid@microsemi.com>
Subject: RE: [PATCH 1/8] scsi: aacraid: Use scnprintf() for avoiding potential
 buffer overflow
Thread-Topic: [PATCH 1/8] scsi: aacraid: Use scnprintf() for avoiding
 potential buffer overflow
Thread-Index: AQHV94XSbTeBS8/mjE+DnNtCghdB+ahGBlMQ
Date:   Fri, 13 Mar 2020 05:47:26 +0000
Message-ID: <MN2PR11MB3821299620978543C7E9B572F3FA0@MN2PR11MB3821.namprd11.prod.outlook.com>
References: <20200311091630.22565-1-tiwai@suse.de>
 <20200311091630.22565-2-tiwai@suse.de>
In-Reply-To: <20200311091630.22565-2-tiwai@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48d6e635-c799-4244-fc16-08d7c7120299
x-ms-traffictypediagnostic: MN2PR11MB3600:
x-microsoft-antispam-prvs: <MN2PR11MB3600F7BDF514A3C30DD1BDC9F3FA0@MN2PR11MB3600.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 034119E4F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(376002)(396003)(136003)(346002)(199004)(55016002)(26005)(5660300002)(9686003)(8676002)(186003)(2906002)(33656002)(110136005)(54906003)(7696005)(316002)(71200400001)(52536014)(86362001)(8936002)(478600001)(81166006)(66476007)(66556008)(81156014)(64756008)(53546011)(6506007)(76116006)(66446008)(4326008)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3600;H:MN2PR11MB3821.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 94ctzBFXSVcaN6hH+bo6/+IwdGXL7ZfXHUj7/E00XrzqfXkOW+/D7TmUYHxkXUcZWtxQfL6XXmrm9Ct4MusbCCm6MwdyOcok95qtgUgFl7kaq5xcpxlXTNHtxWqIpSoYQBjvlxi8fLJ/KodURMrLOnukJaHIi0QyRigxhbyUe6r2B3yERwZUoshbY4WHd/Mc38F7+8K+/DdvFYnJdkn8QI1EN3bvRlrK2WG4/X0aD4x0cXU+Igc9CjsAKSgPIU+7a/sniq9FUERSmlvedSmYIvqKELAzBq8zJ5jl921lWtBAwwPj//baJcDF4iO/gCahH8i/T7RfZL3XBZnzCCNKf6uxMNLL/9HxZWKuM53CxQC9h3a/aHSxu1o6Y4aZ96WXh8lCQ3tQ8+9Yg+BH2y18xtezfxse4fzuI6/U4F9NoKy83eNtksz2jW4+xHJ/Pi3R
x-ms-exchange-antispam-messagedata: 3ZV6NGZ36B4+g4G+NvnVnUPfH4od/NYBbCIFlbPRqmyjuNpgJdl6sFWT8PV5OoZVCx+ZbO+R2RnSqbdrT0VLr2graKbPWJVq3kzB9aKZ+K5vrDb5dLTpRLU3IM7+MAtWyoSLEjjXNgbALCXOIypMgA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 48d6e635-c799-4244-fc16-08d7c7120299
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2020 05:47:26.1080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OIpkRD3V12Skz0mSBs23sIyDMxaOiED3tl93qtLMbCSK8bSUh+sphwYbcgPMMsuKbDJCf4YPl4Am/4b4ePfDTLc577Qk1XLISamgl3bxhHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3600
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Acked-by: Balsundar P < Balsundar.P@microchip.com>

-----Original Message-----
From: Takashi Iwai <tiwai@suse.de>=20
Sent: Wednesday, March 11, 2020 14:46
To: James E . J . Bottomley <jejb@linux.ibm.com>; Martin K . Petersen <mart=
in.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org; Adaptec OEM Raid Solutions <aacraid@microse=
mi.com>
Subject: [PATCH 1/8] scsi: aacraid: Use scnprintf() for avoiding potential =
buffer overflow

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

Since snprintf() returns the would-be-output size instead of the actual out=
put size, the succeeding calls may go beyond the given buffer limit.  Fix i=
t by replacing with scnprintf().

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/scsi/aacraid/linit.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c in=
dex b1d133de29ab..046fef4ff1f0 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1287,20 +1287,20 @@ static ssize_t aac_show_flags(struct device *cdev,
        if (nblank(dprintk(x)))
                len =3D snprintf(buf, PAGE_SIZE, "dprintk\n");  #ifdef AAC_=
DETAILED_STATUS_INFO
-       len +=3D snprintf(buf + len, PAGE_SIZE - len,
+       len +=3D scnprintf(buf + len, PAGE_SIZE - len,
                        "AAC_DETAILED_STATUS_INFO\n");  #endif
        if (dev->raw_io_interface && dev->raw_io_64)
-               len +=3D snprintf(buf + len, PAGE_SIZE - len,
+               len +=3D scnprintf(buf + len, PAGE_SIZE - len,
                                "SAI_READ_CAPACITY_16\n");
        if (dev->jbod)
-               len +=3D snprintf(buf + len, PAGE_SIZE - len, "SUPPORTED_JB=
OD\n");
+               len +=3D scnprintf(buf + len, PAGE_SIZE - len,=20
+ "SUPPORTED_JBOD\n");
        if (dev->supplement_adapter_info.supported_options2 &
                AAC_OPTION_POWER_MANAGEMENT)
-               len +=3D snprintf(buf + len, PAGE_SIZE - len,
+               len +=3D scnprintf(buf + len, PAGE_SIZE - len,
                                "SUPPORTED_POWER_MANAGEMENT\n");
        if (dev->msi)
-               len +=3D snprintf(buf + len, PAGE_SIZE - len, "PCI_HAS_MSI\=
n");
+               len +=3D scnprintf(buf + len, PAGE_SIZE - len,=20
+ "PCI_HAS_MSI\n");
        return len;
 }

--
2.16.4

