Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 257E1C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 15:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDDAB208E4
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 15:34:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UKzUCGkg";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="kxviENAj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgE0PeN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 May 2020 11:34:13 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:56392 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbgE0PeM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2020 11:34:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1590593651; x=1622129651;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Nf4orQM1uUi3IwcrOVZZyRej/L8siXb6ioyS87NB7m8=;
  b=UKzUCGkgQ7o2ZK+LC+dtGn7KCqUr1RYBr1DYtilW37JyBTcymPGee117
   3Wg2EUtcOJYH90v2wDen24mGjV2GOt3w/9RJ49Hau6OoeV66HgusTu1R+
   poDpVVKG9pF9Eu7Tw1MIQOyrsabSv5ptyKuS0CQE2zwVpxzgoxxJ1y9EC
   LLGb0B601yuhsvpjJrbxJYL1YurJE5Zc44NxDJfTQP56r+RYcZS2fTy0b
   AFhYQGc5rYqWU+l96Bwi7gpDyXPk+evOrtNqwXN1LudzLwifE8I/2iu0A
   S8mY8E4xgBrnY3RejSuC0NESSlnldisu38ky/Ww65GbjDiQnmIsHfeMn6
   g==;
IronPort-SDR: 5ztdwirIdP0nJMMGRCDwMrq16PdBiWL8CAWsqFxCIjrRlaoLOm9vk2ZnBQHXkUoE+7E9dtWNmF
 +xH6RKBolqVhRt/1HrPFEncyKaWNPOGmKA95hwH1E+Q/9CSDOeI3i04CmNFaK11V0AqEIvoF6A
 KySy4opKjqsNFbrv73m1k4pXDyMh1eWPSQqQkxaE0JjJAu/0XTxQ5u+wDgrh9kSMq3C53a+JCJ
 ZeTkpQ5JrE47TgdXT37Sf97TRqpxXcPAKwfKdFHfQnH5LUf+2K/aQEDKGJqd7afArD4GitNSx1
 6yg=
X-IronPort-AV: E=Sophos;i="5.73,441,1583164800"; 
   d="scan'208";a="138952435"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hgst.iphmx.com with ESMTP; 27 May 2020 23:34:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fOySdCtF1wO6lJxIY2WNn9lCG6aKPe7kBkbdNpHpjSNpHMXG9S3dbByWax+7OYu+WkdkgPxuTd+R4/DSYogAK3HZRySx0rnMUeyKiIzVVA4qX0VflCFPByomnDeQg5pfAoiuFiZs4rqxl59B4ZrEK1MLpLOnX2rgl6+vHe2SQHAvR99sXtaCxNSxJ5Pxh9N6wQjpSo8ZGVwO5dYMfy24LOcGzv32bfgr2ijU9pw1CvzAOJxQ6vd7tOrVQbZs4Iy/GsiG8EsSl/0je0X9CnsaAeSvK/VfkKoPokaRxhXR/cc8EUsvvzNyo/jbRjMso3SscWsY7TbEwEeE3ZF9cDt1QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nf4orQM1uUi3IwcrOVZZyRej/L8siXb6ioyS87NB7m8=;
 b=DEE2XTzQB1fhRd2R/9a/OnsK0BEYMBccHp5PULVizQvDREEmE1wN2+3x2y/eBs83JOQnPfTOMiIbo9CS1yVh/rh7lRNdNGTLuNfF9IUjuckObQpGYtgUVGrNS96JojZcdrjvp0bYXMR9KX3O2jjhbC7MlYCwxr3KT9H6mn45Tno3Bg6WFG5Djh0rmHcsjIXGcAQxp2jNexKfHxMO+Ooa46KbhZ1AZNQA3bfACMmb6J1eifjvFRufQgW6esgXvAMmNKH0d7IdzwczGTpO1vPieHHiBBHKOAlH4O6w9P9jBO3Eq/CVm0D7JSLJeh7jmD3Iitx8/YmxfQCgIDsQA6keZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nf4orQM1uUi3IwcrOVZZyRej/L8siXb6ioyS87NB7m8=;
 b=kxviENAjxkCJtKoIw8JbuOE/aSHnTBLOyScz61YBGJwPKuGaTUc55Uy+xAIGYG4RAh9GSVkaXRiOTVVng8ChMT5+2LFVMKcJLcTklnNfZmmRgmv7tyzin5sgPhKEwc9c6CS+V1/+xrUXDdi5eAPnWaTq+pfcyDrGZxwSZjsYhYk=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3584.namprd04.prod.outlook.com
 (2603:10b6:803:47::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Wed, 27 May
 2020 15:34:09 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 15:34:09 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 3/4] scsi: move target device list to xarray
Thread-Topic: [PATCH 3/4] scsi: move target device list to xarray
Thread-Index: AQHWNDEbQP5omx7jFky0s56nnP8orA==
Date:   Wed, 27 May 2020 15:34:09 +0000
Message-ID: <SN4PR0401MB359850310F8CBDC29FF3460D9BB10@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200527141400.58087-1-hare@suse.de>
 <20200527141400.58087-4-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 857b36bd-7a83-45db-5fcc-08d802536674
x-ms-traffictypediagnostic: SN4PR0401MB3584:
x-microsoft-antispam-prvs: <SN4PR0401MB3584DA0C31F1AF2EE8721AF19BB10@SN4PR0401MB3584.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 04163EF38A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1e8IgI7tn6xTMp2G9d6/34ZgtAW5XkBOIkV1yCQtl2i/+0oDn1GCV0OBYHFua/TCP7mfMbdowBnoMV6vKgdU8GN+ziyqfLUZUHf84HGPonvD9dzFjjIaLc6SY4+50jE+BB0g5yz7KrHGiDpgCjCW5l9j3VRlz/L2260AEoyR5rxdRpYpVXUKGYhJ1mJTLYRIFd/eksw6L3hHCYEqKF3VgtgQRy9kUyBhOOF1xGe+0eJldSxElQPisKftzCIeyPc+b8OBKYSCBWnlRqn+5UbmsotwERrlmjyY2wde5FH1lIS7M3vaL6KOW8snA60pkiSuU5N6q/Aftc3lDVSnG1nmdg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(2906002)(8676002)(52536014)(8936002)(76116006)(558084003)(66446008)(66476007)(66556008)(4270600006)(71200400001)(86362001)(316002)(64756008)(110136005)(54906003)(33656002)(66946007)(91956017)(186003)(478600001)(7696005)(4326008)(26005)(5660300002)(9686003)(55016002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: BwigN/l8WQHhGvrFuv4AAxBodbrya9ae5CBkmeLaYw55ZCy23393D8Nn9cyZ2NzgebmlRXWq1PFWmdlNny9IBwGVFwUJLbTpJnaB57n68qNSdJozKjinx+FfNec2zrb0Y2EVGxSfO1sHlaK5HfBZs277elpNhckysAmnoIlccTUzLFnu+W+RBqTGh5QEYe8IzkP28kbJM3+yEDR5JEXjllzRgx81eOpzecPCLM/0IS6fMkWdQXBjl8UCVs7XsrYeUvoB0nDpbqm3ScOWvrhEtr2Rz2fu42qgbbQINzjYgXZ7QkeXc563EPyZb/gaS3Y68R1gPnPKU9Je2hj9me+sc24J2QnEspRb3kkVxWE+91L0oVrf2WaSwud0elzVMJMdha0b0q4qbZRrSxn5b/AJHPi1F3EnPfNVPpRvpZeJKyftq4VF5xWD9lydkvXT8zpj5O5jwN2dS9iQUhVxYwCiD4x/MFbgg7Jn7PbAwFfb8lE0higUVuY6nCjPwIir47jo
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 857b36bd-7a83-45db-5fcc-08d802536674
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2020 15:34:09.5779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fR5JbI1y/xZqibbbq3Ryd/WnKHhrBhSRVXae6mC3V3TaUpDWhY8uZTtBMI4VofzvI9iGobINyRXx50nsrNsNd/CALFnJ3y5CgU9ey0UwzW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3584
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good (I think),=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
