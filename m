Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 936E2C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 00:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67321206DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 00:53:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="DqBma3Wt";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="jNwBG9iE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbgGHAxf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 20:53:35 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:27068 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728397AbgGHAxe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 20:53:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594169615; x=1625705615;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=clSAGmlBmjfboZW8M/2lBGCiv4n2RapGSdlYooShIh8=;
  b=DqBma3WtLuB5B19DLyh+tYIGpMaptODkHbHPsNKJBYbyyEuKsbSkIdj1
   U8lp1Wk8Txr5pi1qbjjuBKgbC2Xnx+8AtIJMd6h2Y5goAY6rfv04OsLV5
   7kiMbPNXq19BcSJq2yaQxDfAWixGwHVR0m6Rp1CLTdG4bBIebMiz7odgs
   03nMHclh76yv4zNza6B8aBsgdO0giA57xNnRYO+mC2YLrsHhdfxdE7VMq
   DQuR3iaPogFHBYcniEJAuHby74Q/NXr6Su2FTZ1tSZUeMWaGfAQnsYsQM
   L1jUswDJKf+WLh+olB4vyPPjXMkpqMde9+bGp4HoEIoAs9/emFfL7FoXI
   w==;
IronPort-SDR: 5+Q2cb471rMuEq4RhXP9yKLzZ0yh5Mpvl1EJB6KhncyVZzD8HQCz+1HniAyimPD9nxkn5epn+j
 bV+zk5JNRLxPIiDOatLhqUgg54giV9nYQgO6901GGSqMUnLTZdUKP83Lw52MzHyqKW09N2+Dzn
 x0NTyvzJDRWog2IoulXybD7EvOYlpnFcv50+qC2AblX0EuWaT9jTPE79y9uOFa23KJMd7+77r4
 ZInCHrAEu6he5hsGCx77GpkjkAFf7+gJGe6/mPf5tnE2lElkAxJDD8R24pBT3wmOT9HIdbYcsA
 VFA=
X-IronPort-AV: E=Sophos;i="5.75,325,1589212800"; 
   d="scan'208";a="146189227"
Received: from mail-mw2nam12lp2042.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.42])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jul 2020 08:53:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fkEaAJNkssnkU4hSRa5A4ViD2Vbv+ekjczNtoBH8mXK5bo+LFIvOpCnJ0oIFVJ2pwQltbBtNas5dhff4u61ttZyhaDaEars7QU1hGfrdYPuqVvJHXvS6JaqPW9qV8IwP253eAiKNGTSvCE46/t0mWon0oxJoAoW3JbrmkmJYAX35/7NQoFFd79skH4vIA5hnxe5jB1jiCVSMaSA1IztiMTH9S2PvLqzRN9xtapeAzHELW7leojKkaFPODlZuHMT7xq2rjQtL1vCcQSdNRwP17mGGiuKZ07QaOE9pMH1lFc6SpzgdiJo54nf5cD23+v+sWPx1wx3HhOgVXLFcC/c/dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4DChKgcbQDZSpZ2A4Yp/dK8eAFVlE6ZSSwtdQ83hcLo=;
 b=cJYCS5nb7v4+IYMA+v7QLP2OLJ57oL/a9zxBrF+ziQcoxdQMsHKLI2oPO/FFwdZmpkAMldKsOSsOJpy6bV1j7LFBhfpW4dONup3g1NSjiiNJ+hKCiW/9Oq7EkLoOlUtUOktwuG+cYItjLS+BdaNRpjGR71kKsaL6D28lPK8t05fc1pip13TzFXbCx8BXKJPyUlj9Gx0quoSH+d94C8IGds+6ioVtDNM+0yMJ5c7eh+ga2pSoJRatpzXdkuWp614SPi4jmgRZueFXZBKyOJAWxicyPMksxT63XyUqQ+R1ClPStNrk84/I2ZMtUDWe0JJTbjtTswAawM1tzKeVnOdI+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4DChKgcbQDZSpZ2A4Yp/dK8eAFVlE6ZSSwtdQ83hcLo=;
 b=jNwBG9iErO5+v6JcOlZa1sGhgsxVzMsIZE8Iz0XH6XbOHQuIwJOxzwwiwcQ8l5kNbkHDMW0Vxkkfa+BJ733pwJo0dJ7Ng7prA1oK7ZYllaB3QZwSgEijRjQwKPl/KDslXB4vekmuiC+6yiIHEM+t6j6q/CVzdujnIMH9hD71E/c=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1048.namprd04.prod.outlook.com (2603:10b6:910:54::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Wed, 8 Jul
 2020 00:53:31 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3153.022; Wed, 8 Jul 2020
 00:53:31 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Lee Jones <lee.jones@linaro.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 00/10] Fix a bunch SCSI related W=1 warnings
Thread-Topic: [PATCH 00/10] Fix a bunch SCSI related W=1 warnings
Thread-Index: AQHWVGcrhLvM8odGu0iXEs5vj7X/Jw==
Date:   Wed, 8 Jul 2020 00:53:31 +0000
Message-ID: <CY4PR04MB3751BE9A73158B811D163EADE7670@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200707140055.2956235-1-lee.jones@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1359bf35-c28e-4e0d-28bc-08d822d955c9
x-ms-traffictypediagnostic: CY4PR04MB1048:
x-microsoft-antispam-prvs: <CY4PR04MB104823A9C649DE0CF3DD4429E7670@CY4PR04MB1048.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p87655vbi9r+//VowYu2Z2lmtwqpgQWqCpMLl1x2YU4+J8vujsM6emXK7pbv5uH0fhtIXQ+bKiacQbNOFkMheT66RBPs2yFzDicnAxnk2o7D72jE3rL5PJd0gbfelV4KdX7i4SKE8YUFDg4Ks2VCJOdG4SOsNvmyvQynrRkjP42MQW52fBMjsJtAPznEFYvv4ONCmPuneo1WQOL0BrmoU+WIySu2iaScMPH9jD1nyZaQGdtXhB3OIxR0u6dsWapq1Uusjgxkna8/2mgrMNIOojJCgWcYxWAf4If0rJc1ON5r84q2JBUBXVJGeEXDTX1OpPH7z3rxDJ2dv9Sti4P8RCQZgmUHtBBTLgfD/ltdIHBSKMZd4IkklH3HEv9ysmwwBXYuCyQSNGJOFy9BkpXxnw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(39860400002)(346002)(396003)(376002)(33656002)(8676002)(6506007)(26005)(53546011)(71200400001)(83380400001)(76116006)(66446008)(66476007)(66946007)(64756008)(66556008)(91956017)(52536014)(5660300002)(86362001)(186003)(2906002)(966005)(9686003)(55016002)(478600001)(8936002)(7696005)(316002)(4326008)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: vMulLS5oAPtC6fp5WdLBx4uh6H5zXr2uTd5/lzFgm9HUMeoam6N3fYHXT3Tsg+JcU4HewRMOspNF/dqfVgtWSOkfTrfBabuWqObof1jWp1QgzHNW1bUeCZFZGmA9b5f1DJEq0YGXggGKJZzj0O/QX/eH/VOOxEHP39bEhpeQX48K6Xjm4uICMP/C8VoXByO9+9ZeEWZmi9KOBu+arHtJJR36QOmJ9GIHLIG2Cv4A+cuHxCUysCcxVS4qi2oOVEUyUmD/3FpcEqy1Z30QusDWscYYfVyL9MGZCVqCzDp/dp4xLm9FJSFPw39rXk2HJH1nq2dRgD5lnOSK3+1hmifEDX00fNfl7JKorVpvALa4fSybS3FZPlcQ2+7l68X5mWQXVpQjbzVTnyZPKH/LuLVsLs/UokFA5v2mwLvajW6UYCTCvTLS4rJgeOv4r9p4dFYrNP2zWYL027L+QqZF2/iEeWmoL2RmpDgfBIEMntEm/gpEm0dEwnArMBZ2RKh7W9NY
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1359bf35-c28e-4e0d-28bc-08d822d955c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 00:53:31.4569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ch3DEtVksP+2qdjWCCJlPcq8gyH9VRXMsW0EUXJ+/2p0n5ObSh3W+1uqI+HiRhyJ9C/w9Lo1P0y3KTUBVjCSDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1048
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/07/07 23:01, Lee Jones wrote:=0A=
> This set is part of a larger effort attempting to clean-up W=3D1=0A=
> kernel builds, which are currently overwhelmingly riddled with=0A=
> niggly little warnings.=0A=
> =0A=
> There are a whole lot more of these.  More fixes to follow.=0A=
=0A=
Hi Lee,=0A=
=0A=
I posted a series doing that cleanup for megaraid, mpt3sas sd and sd_zbc ye=
sterday.=0A=
=0A=
https://www.spinics.net/lists/linux-scsi/msg144023.html=0A=
=0A=
Probably could merge the series since yours touches other drivers too.=0A=
=0A=
> =0A=
> Lee Jones (10):=0A=
>   scsi: megaraid: megaraid_mm: Strip excess function param description=0A=
>   scsi: megaraid: megaraid_mbox: Fix some kerneldoc bitrot=0A=
>   scsi: fdomain: Mark 'fdomain_pm_ops' as __maybe_unused=0A=
>   scsi: megaraid: megaraid_sas_fusion: Fix-up a whole myriad of=0A=
>     kerneldoc misdemeanours=0A=
>   scsi: megaraid: megaraid_sas_base: Provide prototypes for non-static=0A=
>     functions=0A=
>   scsi: aha152x: Remove unused variable 'ret'=0A=
>   scsi: pcmcia: nsp_cs: Use new __printf() format notation=0A=
>   scsi: pcmcia: nsp_cs: Remove unused variable 'dummy'=0A=
>   scsi: libfc: fc_disc: Fix-up some incorrectly referenced function=0A=
>     parameters=0A=
>   scsi: megaraid: megaraid_sas: Convert forward-declarations to=0A=
>     prototypes=0A=
> =0A=
>  drivers/scsi/aha152x.c                      |   3 +-=0A=
>  drivers/scsi/fdomain.h                      |   2 +-=0A=
>  drivers/scsi/libfc/fc_disc.c                |   6 +-=0A=
>  drivers/scsi/megaraid/megaraid_mbox.c       |   4 +-=0A=
>  drivers/scsi/megaraid/megaraid_mm.c         |   1 -=0A=
>  drivers/scsi/megaraid/megaraid_sas.h        |  25 ++++-=0A=
>  drivers/scsi/megaraid/megaraid_sas_base.c   |   4 -=0A=
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 102 ++++++++------------=
=0A=
>  drivers/scsi/megaraid/megaraid_sas_fusion.h |   6 ++=0A=
>  drivers/scsi/pcmcia/nsp_cs.c                |   5 +-=0A=
>  10 files changed, 81 insertions(+), 77 deletions(-)=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
