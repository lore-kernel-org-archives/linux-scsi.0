Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91AB3C43461
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 10:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 395CA21D7A
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 10:15:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="oaKK+IW3";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="XwuCrtTv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgIIKPq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 06:15:46 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:60761 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbgIIKPk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2020 06:15:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1599646539; x=1631182539;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ydvzCPpMxHb0mX7CGzJITe8yols/6rllZkKKhbkbsLo=;
  b=oaKK+IW3TWEb4XNteuNy/2mnoCumzTDQdtW8Y6iPiVcG2qJhqXIAUc2L
   kAh1a03HFrzyyJEoXzViQuj+ANbHh5A1wiSzp+gt3IChvq0d9lqrV6R1W
   +7sriMlNFeXoaTEvzhjpQDDje6Evi2yJDAVGo9aMLTcg03IqfCveJxsOK
   kczjdPLe9wAGjBKG3MJZFxlynesCvMvTOZVOuT7WkAYCC5HA30coUYuOF
   bT+/vsH92nE60hn5Xwvllnf+mOppwXWE/g8iZj6ch/QS4UfJ4bRkeNL5p
   vYyAxTVTsHXJagIgngmJh8QxsyHZFl8mQ8k3zixMhWPLUcZ/fYErlu1BF
   g==;
IronPort-SDR: F5osyAmM7R5A3L7yL6Y278nra3AzpeS3mTylR4xPmcPNKjGbxxk/B7v5O+RhI5GuWC+arc6dw5
 0L+jzRfw79qx2SZVStmPMt41noMDL/bAYl6yeGmQ4C+B5QRz8TLP3lx3w+Yh5xJtwiE48BOd7E
 53xT01o9xIcQ+i6NdQsUi0o8rE5F5SFHpeb4W33jQ4Ti8LSPBwAmpQtgnjOaxWNJcbXXAz1/Y6
 sAxloMGK5JkbZkWxKQEB9xAazaXFXKyMIklXOfg6+XDy1Exim7SjCjysy/HT6gXGintLUfSPbM
 MJE=
X-IronPort-AV: E=Sophos;i="5.76,409,1592895600"; 
   d="scan'208";a="25774736"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Sep 2020 03:15:38 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Sep 2020 03:15:11 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Wed, 9 Sep 2020 03:15:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3kSJR8qjhZFEh5TOdluFpg9hiqg/2uynIpsRn+J+E0EdDjdDFTI73HpeoDyy9rKY42CVjGf/9y7mILbRZ9ML5O4PzPSQh8VAegbk9Lr5VjJoL3aqiNiZLCS0RsMYVggu0EGRtu51X6yYgowSAy15ANkuRMmJJ7NwybAg8MU2AqD7ez6BYsI+XczUJLXIVfC/dMHJRDnPDKxe0ymGg16/w2/lG/cygSGtoiC6MhlznYg10Jz+LlsrzJWUL7IIlzAZY9k1cVCDNc5UzJ03iX8STtI/kIz5IPL5IoWJTrtsLkHy9zRuBxxJVghfbapS6JQkT0Nw9J5OMg6XfbTmXrtxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3o5Y1BA3kmrb1vzyWVFYnn61CDOUHYotGWPYlkHh568=;
 b=bPen6q+7kmJa/AnMPEO77P5P9YPbhk76PVMY5fOygMLTF+6tqiEQ5CHiM8SWJfX1X9dxM2iCclKtEawLe6TI3YDTIodwdEDFPsRLCb1a1JxVJoEAfNjs6ZjOF6CIomI8HCMZhMJucnA39urkqln7C/YSTc/VNVPEAT5c6tOM3uNZl6jgNcZULOuHQZuXzGIkp2rKS+qgBnDuMkPMjtYTDQwIjdTk+WBg74yIFhKZNDypmDztLmUhhcWtcUTE0liv7Gq1SyBFt9Qpng0GopXK69n8ewPDmRK35lkCz+bc4WOXhHQV+09BFaf1zm5Dhd4EoUf7Di9Ho3z3lSW5XrRFFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3o5Y1BA3kmrb1vzyWVFYnn61CDOUHYotGWPYlkHh568=;
 b=XwuCrtTvX049jiRM69eQZoNL+wEV9k1gx/iwxXTt8gVtOCG2VoVOkRLNqc8gt9HTs1MySDbzi9Xy0Td/KczuGMVOPh7KMBsa1G5KgAdMYy9MsviKRfMIhJXCCsA1JbLdJS8o60qWsTB7s3PcrsQkPbKKUoDIRvAr0MeDkfT1V/c=
Received: from SN6PR11MB3488.namprd11.prod.outlook.com (2603:10b6:805:b8::27)
 by SA0PR11MB4655.namprd11.prod.outlook.com (2603:10b6:806:9d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Wed, 9 Sep
 2020 10:15:36 +0000
Received: from SN6PR11MB3488.namprd11.prod.outlook.com
 ([fe80::9464:652:6b4f:12e6]) by SN6PR11MB3488.namprd11.prod.outlook.com
 ([fe80::9464:652:6b4f:12e6%6]) with mapi id 15.20.3326.025; Wed, 9 Sep 2020
 10:15:36 +0000
From:   <Viswas.G@microchip.com>
To:     <martin.petersen@oracle.com>
CC:     <Viswas.G@microchip.com.com>, <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Deepak.Ukey@microchip.com>, <yuuzheng@google.com>,
        <auradkar@google.com>, <vishakhavc@google.com>,
        <bjashnani@google.com>, <radha@google.com>, <akshatzen@google.com>
Subject: RE: [PATCH v8 1/2] pm80xx : Support for get phy profile
 functionality.
Thread-Topic: [PATCH v8 1/2] pm80xx : Support for get phy profile
 functionality.
Thread-Index: AQHWdyGWrXbEKONvEEqLhfPGQkid6alUoL4/gABW2wCAATo7hYAKAPDw
Date:   Wed, 9 Sep 2020 10:15:36 +0000
Message-ID: <SN6PR11MB3488F126461CC2C8764A3F329D260@SN6PR11MB3488.namprd11.prod.outlook.com>
References: <20200820185123.27354-1-Viswas.G@microchip.com.com>
        <20200820185123.27354-2-Viswas.G@microchip.com.com>
        <yq1pn75f09i.fsf@ca-mkp.ca.oracle.com>
        <SN6PR11MB348809CB28AA66A7905490949D2F0@SN6PR11MB3488.namprd11.prod.outlook.com>
 <yq1a6y7ek7u.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1a6y7ek7u.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [63.216.172.121]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a322532e-9c92-4e91-5a13-08d854a94b99
x-ms-traffictypediagnostic: SA0PR11MB4655:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB4655A70D68F9480E372A4CD99D260@SA0PR11MB4655.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XIJeEYTEyiHNOXWzG6rSExL/FkFTPnOydrFXu0fd4Qx32gWZNEfJgTCzmoooSCqZQs4ux5iEZMtgGWpvVSYZVWgrM4ZZ55fPdwzH/hhkd2R9IHoWjLgbAs7FIEp+zJofZpwVSLkkmZVO14UyicqV3Jlnlj7MqIQwuXfdLvB+bhyDB3o/fVjlaR2UazFbEc3yVjCuUelQjd4a4V83TgrkKBB6SJ7bdDaNzIMa2GxQK4coRk8g5+xSHRkR3z4cZxNWoT/FY0H4bfjZHm0gluCSE2ONYUGpjKFq5dK4EmTJRReQXR2Xq1cKyDnfU4/vHDvZszRM96hmtuPkpXpu4skajw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3488.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(6506007)(33656002)(86362001)(83380400001)(26005)(9686003)(478600001)(316002)(76116006)(8676002)(66946007)(66556008)(4326008)(64756008)(66476007)(7696005)(8936002)(54906003)(53546011)(66446008)(2906002)(52536014)(6916009)(71200400001)(5660300002)(186003)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ehtAaz8KGopDTP8ax4fN2mAy0tJkeFoii8lpufj5YF+a2sDEZL7Wc6nCsYMXmf4BL7/g+ygxx/Ng57FmlW4jTg6SXni2U5NAvfv7TeeYH4vlV7yZl1nLgFI3CMFYP7b6AdOs6O9xddl8wVelVRQlHErSH/t4ZqGiLBzS10h3sqFw3lPV8o6TwOY/a/DO44s6ncF2471M8LZ7p2mGw6QWric7JenGstwHmcmJn73zkkNmW11HnvsSFR/D31eWV6oQriDPEIEyyRxyNHP/xrA6XIGH/uVlTKMzk+AUQ9tw64TJG3sRq8w68d5GDi0mpFGdwBbbusjUKWvC17zhQ/EYth2pt3rmVND3l1O58ljlr8deVB1cfxMdqgMUJ1lMl4hwpkKolZz7piP4iVf36wk90U70BPwQaVzOX1dhII6qSZszutptroeJVkSBq45d19prEuoquvc2PXAGZxXTBOXOcd84mAvytcC419NYvRNP4RqhzUHTWxbIQx7Enl1NPPE/5dVTDjjzw2C9c6J/OYQLImUOnd4T03oC37i+qKnTkspETTaIBnIGHJNyxFZbRQOyaA7oMbCrU730lQg084qE898GhkzbbsO75A5PTQoD8KN9moti7Ozsr6esFwwk97X3LFlpSIZEUdHRxdPPGPJEHA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3488.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a322532e-9c92-4e91-5a13-08d854a94b99
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2020 10:15:36.5923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ja3zR+vWOGH6WJWhcwBSuIn5XuflClqVJqKcAchJexS3liZP9OG/hSIZ4PJwHPIJqaTz1QYydtxwLeRORv4wkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4655
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This is not exposed to userland anymore. We have submitted an IOCTL support=
 in driver to=20
expose these information and later dropped it since similar functionality c=
an be achieved=20
through libsas sysfs entries. Controller exposes the phy error counter and =
status=20
information pages through IOMB. We retained this patch in driver thinking t=
hat it might be=20
useful if we want to query these information through driver sysfs or by som=
e other means.=20
We are okay to drop this. Please suggest.

Regards,
Viswas G

> -----Original Message-----
> From: Martin K. Petersen <martin.petersen@oracle.com>
> Sent: Thursday, September 3, 2020 6:48 AM
> To: Viswas G - I30667 <Viswas.G@microchip.com>
> Cc: martin.petersen@oracle.com; Viswas.G@microchip.com.com; linux-
> scsi@vger.kernel.org; Vasanthalakshmi Tharmarajan - I30664
> <Vasanthalakshmi.Tharmarajan@microchip.com>; Deepak Ukey - I31172
> <Deepak.Ukey@microchip.com>; yuuzheng@google.com;
> auradkar@google.com; vishakhavc@google.com; bjashnani@google.com;
> radha@google.com; akshatzen@google.com
> Subject: Re: [PATCH v8 1/2] pm80xx : Support for get phy profile
> functionality.
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know
> the content is safe
>=20
> Hi Viswas!
>=20
> >> Where are these parameters made visible?
> >>
> >> Also, why not make the phy_errcnt members __le32 instead of using
> >> __force?
> >
> > This was added to avoid sparse compiler warnings reported.
>=20
> Yes, but those warnings are indicative that your struct definitions are
> problematic. I suggest you have one struct with __le32 members which you
> use when querying the values from the hardware. And then another struct
> that's host-endian. Which goes back to my first question: Where are these
> phy parameters actually used and/or exposed to userland?
>=20
> --
> Martin K. Petersen      Oracle Linux Engineering
