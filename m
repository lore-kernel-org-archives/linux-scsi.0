Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CB46C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 02:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24C0A20734
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 02:30:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="C2XMdWGU";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="LWuD4/Fn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgFJCaX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 22:30:23 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:1616 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgFJCaW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 22:30:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1591756222; x=1623292222;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=jBaaUh7fAC2suPYhkstV0L0pxUYVu3CCpGrMNrW3X84=;
  b=C2XMdWGUjGGfNr/qgQQ32jQpNUcq+dJgkwxnYqekkEuytwY1Gwee0eX6
   nsjLvfKUR4+XvlHIy949GKXlqumKyHlnWwLIGDeROAkka/GPle/qlSoPj
   fRfqeMpmmCXPtJUxdO4MFllY+eHodB0cgO0jG/t3Q55x7tt3doe882BPr
   dTaw5HZN8N6Ib/VMEQotRSGLwizpVlo4BENSpSu+HlRLBjg8c3cy2grJS
   CdBhzFdOd22s9da2bmTJ2rgC8aSJNZYKObb9tYOYcel5pALp1Ffrf4+yP
   NAqVAMIsRO1YHYJ4XXEFenfnqhDhavlZbyJi33iGKnNTX1an/vyjxa7fw
   w==;
IronPort-SDR: RDQFZLuweFfWJuSkePugvLHi3XMJtVkBt7XqGu1Rd7UdNn5Ho8FnNDGDyovQh/j1knX6YmPsUh
 B/TK50xutrIYpCJmuzUmTI2xv2iB5PxOqdg8AN1BAy/Gz3kDUM/eIj00g1Y6P9Yp/MpRFG73IF
 51Tanz07r+KAu3oYrAeJL7ZZ6tS+muvFlTzsGLULrbPLOe4ix9i3b2iIrCOUa409hItU8t26MK
 Bmpd07jO+1ZOoUc2KvVusMgBmFKEL+xoUZ6ynfsNSUDmZ3Q40U8xHVS0JzYNkIqX0m3gNPTf/b
 TkE=
X-IronPort-AV: E=Sophos;i="5.73,494,1583164800"; 
   d="scan'208";a="141010129"
Received: from mail-sn1nam02lp2058.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.58])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jun 2020 10:30:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RjhghmYGuQg68/yUmVJD70E143AApbGHM1wdlUM0py4Vp/8Y8v/kT+So76ConPwsrkbOh+mx4+d+cYZO2Ej8UtUb2w2VG4YLUWv496lKxSdf1w3fA8roImsLoVQDfl/835kp0GIBz0PQ/wvappierclO3vsO53jZjI/tke/i5JwRIxzj1Z20ebSH70EL+wUihnuj36QWuqhK9avb4B9igmHbAnUwRD5hqzvw7/rT0Wet5K9pJXNefrvtH7tSNDqybLYbj6JbVdxVlxPSUEjHx+CoNr4jIoIfpqoOImLtidbjJ+Vsw/1N+8Un96PbDCiWkz9iQamiXNIUyABUCxahgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBaaUh7fAC2suPYhkstV0L0pxUYVu3CCpGrMNrW3X84=;
 b=aaxU/gnePQbeoPaTpaScJrX+o1AVc7okp23tB5cvo65r/7nL2Foj1S2t6/NB6LPgscMsL9H1Qegq+094Ai02SLpG2h95fT8n7r3aH+rMLbmGOK05FwEwx42j7LX60fo3SWLg9qR3AgsOuavJEu6AwqFxPRyLzRCjLV6jV8Ee4GGRzWcEyFxHaURd6zod2CncJJ5i4xBbFPBZDtXtCjkPIAf+4D/YXfxB74ZwjLZgBEDgFWaJJcXG3+az2XJUeTr3+Z/0SntT0+6Mkk0QBGdvnyHrr0I39Wdjm7B1sShl5SamGb+NVPxLdMBNrCb2kBulqJCVePjxi+0DYmJKf3iT/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBaaUh7fAC2suPYhkstV0L0pxUYVu3CCpGrMNrW3X84=;
 b=LWuD4/Fn4OTn6zBEnSa25PaGStPT1k5C/pJLP0V6WQQpgPFdWafhoh71HfkXjbWJmZh4aJoOazQmDo+7+DTc7n5hdnVgXrI4rnpfsypw8iAF89mYEv28Q+Dt8C1pAY7Ko8m/luEfrlmj5o23bbybaDRmCnVeFXBY65yqAAN0x9w=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0616.namprd04.prod.outlook.com (2603:10b6:903:e1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.20; Wed, 10 Jun
 2020 02:30:20 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3066.023; Wed, 10 Jun 2020
 02:30:20 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd: Use sd_first_printk() where possible
Thread-Topic: [PATCH] scsi: sd: Use sd_first_printk() where possible
Thread-Index: AQHWPVF00GtaQzUxPU+nZyXX7NmjCg==
Date:   Wed, 10 Jun 2020 02:30:20 +0000
Message-ID: <CY4PR04MB3751F8DC1A293BB81F25E6BAE7830@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200608045746.1275523-1-damien.lemoal@wdc.com>
 <yq18sgvsllr.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4086a691-93b3-449e-ccba-08d80ce638ad
x-ms-traffictypediagnostic: CY4PR04MB0616:
x-microsoft-antispam-prvs: <CY4PR04MB06162BFD842290A13B51547FE7830@CY4PR04MB0616.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0430FA5CB7
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FQbeFVOThRcp5YyunQWCkFLRPL1aBLVT5Twd0vKcvOPd/WY5Eso5gJwlNl/UwAYxbP1XFyqJS/4GsQ8iMctZVWTti7YIHxR1uwNqbjjADyCrnH5CGVCSZ4IS/Ayj1rA+DWMUk5f6B/9NW9UbSpqBu+sq77yI9LPkicmjSJWsXsWfnQ5yXloZc0zJYSrUaG5EHyeigZ4ktG3k+5XX54oHadCyJc0obZVoLtlNrTQHjHI8+Pevl/BnAHTPg5z+zyPNnGFxkJh3fjUky6O9jxOIXwCsgODFDwryuKHEkilkaz8iSGx+V/SzaOVaqcz/r4Mb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(6916009)(186003)(316002)(6506007)(4326008)(66556008)(26005)(53546011)(2906002)(91956017)(76116006)(66476007)(478600001)(64756008)(83380400001)(7696005)(66946007)(8936002)(4744005)(71200400001)(9686003)(8676002)(66446008)(52536014)(86362001)(55016002)(5660300002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Sbc5Vyrb9jADW9+BrRS4VtP0nsDKMbHzLrdR9AtUuwZP5x6yJsEtvyB4TFaNfvtjHtY9vEMbAAlMAonf5hJZ6XIro0Q8Yk7XTE/9UmrC+BWkx3TrzcyqQnHxjMIdydec0yD0Ox5HiF5vJiFs5zsFBz/RgN77G2qj44xYhnKb6jPs0lgTAA9T5c5dnjHKLd1H5LKPfDdWkgvFvXfGWOjRLgCBSQg8nXYzJOjkLYbKMpVdQiZTtQ27mq8T3lYlqzOqnO6k4mFPpQNNLpUz0ZS2FXfGOL6Wy5jOKyoCMclvO3vzwcEODwIeonVTG21M7ADBS7p/iHxPR71kmsusX23LsIfZ2UqFoflmnArKhg7d7Oh71Uk40TutsVd5GyN7CgPymVyJdpklkq3FIi7yLFgz+TLHO35d44z2b14JjcFtwGHN5JphMg4LwiDlRBo1Z1MpwnAv+D5KM5uTjrv0QHUDPKMChuT5yNHboacyL9madcdrR4N5mLf5M7g9qL4tiyBK
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4086a691-93b3-449e-ccba-08d80ce638ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2020 02:30:20.3801
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LZjcMwbgAtinzWeJgu+DCmXhImrksObaiVBYogpciRtoUYbjnMyRXUAsRz5wIwsWP2+5/0XXaVypDyv0D+5i0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0616
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/06/10 11:27, Martin K. Petersen wrote:=0A=
> =0A=
> Damien,=0A=
> =0A=
>> In sd.c and sd_zbc.c, replace sd_printk() calls conditional to=0A=
>> sdkp->first_scan with calls to sd_first_printk(). This simplifies the=0A=
>> code (no functional changes).=0A=
> =0A=
> I'm currently digging in this area trying to completely revamp the=0A=
> revalidate stuff to accommodate a few broken devices we have come=0A=
> across. The first_printk stuff is going to change substantially.=0A=
> =0A=
=0A=
OK. Sounds good. Please feel free to let me know if you need help/test.=0A=
=0A=
Best regards.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
