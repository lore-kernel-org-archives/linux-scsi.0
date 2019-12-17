Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDDE3C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 05:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA0A521739
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 05:50:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lBoBBh2y";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="dPHw0IDr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfLQFuV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 00:50:21 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:64129 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbfLQFuU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2019 00:50:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1576561819; x=1608097819;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=2G8ll5IsKekyIHTrvkVYsoLIOyFHCqhuRYMsEQhrGI0=;
  b=lBoBBh2yi4jLqjzcB3hlJtbxRXwsfGWOtm0RKsIh2zyjaPf+K3tMX0oC
   FUMLlT0lIhc+Xzybhz9Uz+OG/bgywXqb3qeJth1eBCec99kGakFsw7Ji+
   yu5FYCkhVy+077xRitwRcW0ppPuc2QMJU9a6Vnc5pHqghvfeqlDJU5vnS
   1oD4gvPOPR/C36r42Yj3IDt1wpALioQbF9Y0eNOiCeDUtgBJ/I+lrsVf3
   fOXtmEAs6rvEKI+pkvZHG//8MxVGS2jtX/JuX/37d1VTcOH8jMBcNy5RX
   uimbNKAfkLZq3oiRVHAPTTfIGbpXhPtPFjIMk5x+2SLKmA2XoJrLAFBfS
   A==;
IronPort-SDR: lLJB3GSWuWeKHy+tkikr+/VOQ8KkMHuT7zJHxBSTD/GNXB6axqGCwThGPbospWVGcdAF8KXZQK
 RNOpyS+GYQUBdZlth8eraUjFE62SLbvpbkdpTfbZWlF4tG1XVuc0Kx108fQZmhSyLEvA+c1ieC
 vR+H7fQGntKA1AKdR1/492undX4ZOhga8gDTlLdnIlT4coqE1ng3SeMH/ryeTOF1ndpFFhzS2A
 dCqx1E79vKd2U5M/8vYQXAr7qixSinFRmg+T0qc2240LvlfbelgyNSRGucLgAHtyHMlF9GzV/p
 dyM=
X-IronPort-AV: E=Sophos;i="5.69,324,1571673600"; 
   d="scan'208";a="233115903"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
  by ob1.hgst.iphmx.com with ESMTP; 17 Dec 2019 13:50:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f6bOT0hbEkZ/o5H/RwV2U/Ol2SoYdFZjZ3DVl+GDeCKYI2PfazuQMbwm0z8hgQB3DkMno8vAFCHHVzPsoOmo2htLISTjqody4UtSFpJ1LM8at4mpbJ/TpU+YdqBfYS4uKHrc+I00WgI7ljM9++pjTZNXoMUPNSxtlYrXEYNvWISmKHtJ9KBtYylZ9Kh3NRivVE+q8++F8iIsUMCoQ4Q88DNKvF6Eogb8ME44FIKiBmkroBEk+o07Ar2ZRHNERdX3YUTCWNiEsHrFP7qwoNvOStHo8CeXtiO9dRXuYdk+j3Rht20OMIngqTqoPSFGSg2ok3ftf1bXUTTm8jmkQcsX4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jq8wKpTliDnrgfknlEkQPQYSxpm/BTz11Uel2zHNIMU=;
 b=ZWoVT1R7LWRf2xiIwpsxIBTVyVFzJ/QbQsba3C0k4dGLo2gfWs2R93OOM0kY1pVe3tnYfDV9hmzMVKlEgVB4t0ILs07x4sKXcEABZk47tERF5TdlwQROAQqe/CKjlhwbteKODiZ2CQIq71wx+Dsbr0EzGJVChzIu/YoJ4vAD6zLNLeI7ND7ndQEAvkXyQuJGpV6fQ1SYlx7ZL1lx/0tGbZuhaqm11kVf1hZ8nas6EDU3d13WOo7AAr+CW9129jxvyDO9cqfBRg0RmY3tnAqGVxwxbFAATerjVzo7XvjyxPs1J6AmizJXySc4WcfFzcrWpYUcK4fFKTcBbCqQT6/oRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jq8wKpTliDnrgfknlEkQPQYSxpm/BTz11Uel2zHNIMU=;
 b=dPHw0IDr8X66CW7usHEudD5ob+cUM3XGiw4k5XD3r16WJ2xtwPdGSHQ9Hg+0U3H3EomFaPBeDDfsRdyRosGsj/DBIIg5P9pZktTqLOERddex8iKMPkhIWfoXAA57r9s7MW3Ohb4rxTsP1SRVW7dZ+cggs3O0Un9m2wDX+6udBgA=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB3863.namprd04.prod.outlook.com (52.135.216.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 05:50:18 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::cd8e:d1de:e661:a61]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::cd8e:d1de:e661:a61%5]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 05:50:17 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Guenter Roeck <linux@roeck-us.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
        Jean Delvare <jdelvare@suse.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 0/1] Summary: hwmon driver for temperature sensors on SATA
 drives
Thread-Topic: [PATCH 0/1] Summary: hwmon driver for temperature sensors on
 SATA drives
Thread-Index: AQHVrlCHAuNmYmVDBkaZXwgHrVPrSw==
Date:   Tue, 17 Dec 2019 05:50:17 +0000
Message-ID: <BYAPR04MB5816CA0C1CAFC21F7955F79FE7500@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191209052119.32072-1-linux@roeck-us.net>
 <yq15zinmrmj.fsf@oracle.com>
 <67b75394-801d-ce91-55f2-f0c0db9cfffc@roeck-us.net>
 <yq1y2vbhe6i.fsf@oracle.com>
 <83d528fc-42b7-aa3f-5dd9-a000268da38e@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 761c4590-42ba-4d7c-fbe2-08d782b4fedc
x-ms-traffictypediagnostic: BYAPR04MB3863:
x-microsoft-antispam-prvs: <BYAPR04MB3863B0D4226724D375988B0CE7500@BYAPR04MB3863.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(21473003)(199004)(189003)(52536014)(71200400001)(33656002)(4326008)(66946007)(5660300002)(186003)(316002)(66556008)(8936002)(66476007)(66446008)(64756008)(55016002)(9686003)(53546011)(76116006)(8676002)(91956017)(81166006)(6506007)(81156014)(7696005)(110136005)(54906003)(26005)(2906002)(86362001)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB3863;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PM7emSCvLmG0d5cfQwpEpc7V8om8UQvSmTzulLD5kBy8MalNcAGqLvgpA+fArQzNJRYHFKbmof5brbn1/cUHMsNskAUYn4Bsh1XIpIWKx2kO76cfn6L9qUworThpBqqhnNPOxjeSzkmIwuyI0GTEQqxF8iwIONUtZmAitecSfTNbUqWPLBjPk8+0Lq9VmbtFn57qJ5i2VXzNA3P95LMGzwTl3d3BLf+v0VGKSMs5OmKBs1YQzGzvvi2Psiefy9bI1H+zWMHNri/XL/vyyjrNcgVWE+IhDkmQtXfXtKmq8D9T5MhoVufwSojfw98rLdVpapnbDPjgI/aWUAa8sL6i3rhqvMPRsioQ/LQCJXvpEQ8h8aX3bhSrCcQeVHE+IVu7D2xiilSOd/vy84KjCx+MxEPRbmXZSENUNyE+nl1eM8THKa4CLUWTVNGNNTJpYuXa3ixCkPRz2Z6LUzhn1YerlhRDxY08IjUtYfnYcRmq0YLWv/NLPKiSLi9/gP1LZEsp
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 761c4590-42ba-4d7c-fbe2-08d782b4fedc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 05:50:17.6424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gPNEwEt30nx0N4svW8lw8U5fesc+dzDdrFNfu9sfv9yacEZXoPtBE2uN4K1hhnpHF4eiQzKau7HsscA/+9wD4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3863
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/12/17 12:57, Guenter Roeck wrote:=0A=
> On 12/16/19 6:35 PM, Martin K. Petersen wrote:=0A=
>>=0A=
>> Guenter,=0A=
>>=0A=
>>> If and when drives are detected which report bad information, such=0A=
>>> drives can be added to a blacklist without impact on the core SCSI or=
=0A=
>>> ATA code. Until that happens, not loading the driver solves the=0A=
>>> problem on any affected system.=0A=
>>=0A=
>> My only concern with that is that we'll have blacklisting several=0A=
>> places. We already have ATA and SCSI blacklists. If we now add a third=
=0A=
>> place, that's going to be a maintenance nightmare.=0A=
>>=0A=
>> More on that below.=0A=
>>=0A=
>>>> My concerns are wrt. identifying whether SMART data is available for=
=0A=
>>>> USB/UAS. I am not too worried about ATA and "real" SCSI (ignoring RAID=
=0A=
>>>> controllers that hide the real drives in various ways).=0A=
>>=0A=
>> OK, so I spent my weekend tinkering with 15+ years of accumulated USB=0A=
>> devices. And my conclusion is that no, we can't in any sensible manner,=
=0A=
>> support USB storage monitoring in the kernel. There is no heuristic that=
=0A=
>> I can find that identifies that "this is a hard drive or an SSD and=0A=
>> attempting one of the various SMART methods may be safe". As opposed to=
=0A=
>> "this is a USB key that's likely to lock up if you try". And that's=0A=
>> ignoring the drives with USB-ATA bridges that I managed to wedge in my=
=0A=
>> attempt at sending down commands.=0A=
>>=0A=
>> Even smartmontools is failing to work on a huge part of my vintage=0A=
>> collection.  Thanks to a wide variety of bridges with random, custom=0A=
>> interfaces.=0A=
>>=0A=
>> So my stance on all this is that I'm fine with your general approach for=
=0A=
>> ATA. I will post a patch adding the required bits for SCSI. And if a=0A=
>> device does not implement either of the two standard methods, people=0A=
>> should use smartmontools.=0A=
>>=0A=
>> Wrt. name, since I've added SCSI support, satatemp is a bit of a=0A=
>> misnomer. drivetemp, maybe? No particular preference.=0A=
>>=0A=
> Agreed, if we extend this to SCSI, satatemp is less than perfect.=0A=
> drivetemp ? disktemp ? I am open to suggestions, with maybe a small=0A=
> personal preference for disktemp out of those two.=0A=
=0A=
"disk" tend to imply HDD, excluding SSDs. So my vote goes to=0A=
"drivetemp", or even the more generic, "devtemp".=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
