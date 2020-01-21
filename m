Return-Path: <SRS0=h99Q=3K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 893C1C33CAA
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 05:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4913724125
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 05:33:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="EpKIUY5O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgAUFdU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jan 2020 00:33:20 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:45528 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgAUFdT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jan 2020 00:33:19 -0500
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Deepak.Ukey@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Deepak.Ukey@microchip.com";
  x-sender="Deepak.Ukey@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  -exists:%{i}.spf.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Deepak.Ukey@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; spf=Pass smtp.mailfrom=Deepak.Ukey@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: wBjQ4tZbFmzKxyEpngCFd0qCVplmaGG/j85jaDGDoLVT5T0uI9NnFvyBWIVlEOkPHCHx9C20Hn
 bdQ92KuwHEClpK/85Ks+8ZwSUNlT3s5DaSgQzBRgt2H6PXc8b07xpkrheDB924cnikjNY+RO4V
 IP0sX/RbCxU3OLCsLoHF0rGzM/qWJsw62H3Fo8Qll26BjQdZeKGeyWqXKJLibRnL7HsZyEC2VC
 m3RT+RoXsCLQm26gBKxlzYI5GsZrDFKmagGr6DntMVOt/N0rbixIM2zHk0y6W4vyv/Uzoc4eRW
 6as=
X-IronPort-AV: E=Sophos;i="5.70,344,1574146800"; 
   d="scan'208";a="61662097"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2020 22:33:15 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 20 Jan 2020 22:33:12 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Mon, 20 Jan 2020 22:33:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=miY754M5l7GKgvC9cvFWBVOF1jrUE8GjMLu394LU6ceCpTNRsAVWs37du3ldXJsLqLAbral9TBTo6pKICGyzloQJs30K7wdKswUMJ8KIyyiY1tTR+8zWjcx/S3P0XIHy45cyOzSgVhDt3HUIACDWfRd6NOc395ZhvXLfuCp9ZH14kgqhxgsMaeLVlFuJJGEPtks0Tj4+JnQmG0eVT+Uh+vDpfaDRx+f/30+bRu3W4t1be+12jBH+w+6HU3d72G9Bzhe8Gpk8TP064fcXlZMvdFgEkiLYYQbgMASX0DHNgJUU7wFln+ghVdnqhR1TE9BnKwysUbWvHM+4+sRdt8qpIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0RGjpl/jMcM8fFglfzfpYEXG9wJ1v+yvJiycjudSxb4=;
 b=KQqPDYO5syna4AjwDX+YcNGGYcR0WWOcyZJlhaidzVHl4LAush3ArnMarX4JgiIt+BzQ+8tmKGTz/qStadANDgN9NxueTFsayHE753acHPoqxlebEAltg2oMwcAndHQib/kFbR2eHyEMPg6kXLDy8gNjHheS5wFPn9GaPhjJQbTrBQkQJCd/7PCxrNSFSnA/ywepRcHW/6HWZWdlWgcLJyksZv/sismjW4t5yhFw6E4e198xEPeO3zshvtWw2MMbEZT4kvUw7+s5SXGqOKP2y5d1/9gRnBAffsfGUOjOcp2HaTO+YqPJzqkP62dQjARYz9VWw/dzquoncwxYDCpg6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0RGjpl/jMcM8fFglfzfpYEXG9wJ1v+yvJiycjudSxb4=;
 b=EpKIUY5OG13sMAwFZ9EwwAwaR4gK1nXdsnQFKI1LMX5dgJ2l4V1dxcqdJS0vWcB80wSKdAugTeM2OUnamR6MYYFdfpqP6SnibPnwnFbSndNvBDq2T2WDx5JIH+fkcAubkIXVbR0u1o6ZvqH4VPlX9GVVRSl4mfKOBhV8nelk+eI=
Received: from MN2PR11MB3550.namprd11.prod.outlook.com (20.178.251.149) by
 MN2PR11MB4414.namprd11.prod.outlook.com (52.135.36.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Tue, 21 Jan 2020 05:33:10 +0000
Received: from MN2PR11MB3550.namprd11.prod.outlook.com
 ([fe80::1419:7aa2:a87:5961]) by MN2PR11MB3550.namprd11.prod.outlook.com
 ([fe80::1419:7aa2:a87:5961%5]) with mapi id 15.20.2644.027; Tue, 21 Jan 2020
 05:33:10 +0000
From:   <Deepak.Ukey@microchip.com>
To:     <martin.petersen@oracle.com>, <jinpu.wang@cloud.ionos.com>
CC:     <jejb@linux.ibm.com>, <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <jinpu.wang@profitbricks.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: RE: [PATCH V2 05/13] pm80xx : Support for char device.
Thread-Topic: [PATCH V2 05/13] pm80xx : Support for char device.
Thread-Index: AQHVzQVM9vnazpqT4UOKc1DpjMmY0Kfu5wUAgAVhaJaAAExHYA==
Date:   Tue, 21 Jan 2020 05:33:10 +0000
Message-ID: <MN2PR11MB3550E72F0521F873F52AF671EF0D0@MN2PR11MB3550.namprd11.prod.outlook.com>
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
        <20200117071923.7445-6-deepak.ukey@microchip.com>
        <CAMGffEnc1sWgOB7PENtbBQUzJ6iRORHrJe4Y5FV1+WkgrhAwOg@mail.gmail.com>
 <yq17e1lk666.fsf@oracle.com>
In-Reply-To: <yq17e1lk666.fsf@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 80728900-05e4-4f5a-c411-08d79e336730
x-ms-traffictypediagnostic: MN2PR11MB4414:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4414934B26EBF896FBF426B3EF0D0@MN2PR11MB4414.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(346002)(376002)(136003)(396003)(366004)(199004)(189003)(71200400001)(316002)(2906002)(86362001)(110136005)(54906003)(4326008)(478600001)(66446008)(8936002)(5660300002)(81166006)(26005)(7696005)(81156014)(186003)(19627235002)(33656002)(9686003)(76116006)(52536014)(8676002)(66556008)(55016002)(4744005)(7416002)(6506007)(66476007)(66946007)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4414;H:MN2PR11MB3550.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: anYwICGcl+Jd7VmUxk4wam88tXzKqb9XKokdg/cgxGDvEnMt+8lOvSjYtdBhfp7vqY8GwGHMNlgCJGOK+Ap4sjXBraxY/7uX4eo+fZfzvp5yiJW8PLplllUjR0wocUDoUlUopqOL3E88ecAM0wtMY1sQve3dG8GjMTWku8rZGfGd5DQZx/tIOlyfl9q7YVCbUGANaS64z/bQqNrfz2lKc8ooE9VcVg1qFLaASJztblweKbRzX4xEs4Wm2fnNjzzk8KaUfqMYQRir3LnuTpJgxwy10f7kdKgm4sqqI7lsTeqJDx5mEZnrHm51epC8+xLmw1TpZJxKQcPQPIsDBSlfnnlJYxMJM8iGV7czbKVF0tfU0CSIIQQcorGdnNVyAoPmg/6mddumRBJ2mald5DXMHNEtml/5DlIA3QWfxPOgDZaaIdVqqIBjdsUIlM5BXW8q
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 80728900-05e4-4f5a-c411-08d79e336730
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 05:33:10.5515
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2hlUcp8g8in1L3K8qK1DGdFf+bnu8mHwzG3sjFreoBBzB78bfGAU9CY6PlBOMVaWmBWX1OraAFfIZ4M/yPu2nNnqMgFJHU2IUhR6beWNrLQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4414
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

Martin,

> Thanks for the commit message, looks much better. In the past, people=20
> are against IOCTL, suggesting netlink, have you considered that?

Not so keen on adding more ioctls. It's 2020 and all...

Given the nature of the exported information, what's wrong with putting it =
in sysfs?
-- We have some upcoming patches which uses this IOCTL interface and that c=
annot be supported through sysfs.
Below are the patches in this patchset which requires IOCTL interface.
0007-pm80xx-IOCTL-functionality-to-get-phy-status
0008-pm80xx-IOCTL-functionality-to-get-phy-error
0009-pm80xx-IOCTL-functionality-for-GPIO
0010-pm80xx-IOCTL-functionality-for-SGPIO
0013-pm80xx-IOCTL-functionality-for-TWI-device

Regards,
Deepak
