Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 490EEC43465
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 00:56:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB406208DB
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 00:56:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ppZa7vQP";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Otj+otm8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgIRA4b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 20:56:31 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:22824 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgIRA4a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2020 20:56:30 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 20:56:30 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600390590; x=1631926590;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Mp9dTDqKFM6XEjLjRA/16WMqL9oWh2BLRR6lriUCKBE=;
  b=ppZa7vQPWwiB49VZL+rZsA+202e/e4bqCct1KraA6bBvngyf7OjqzVVa
   S6/i9YdZWLEeVtPu4kAZnAe6u6rKl7of0X7OrWSAvMeEQaYWltpTG+1FP
   0V0rcmQO94Lj0RPDzRv1pxX9+1PT3B/+ddW8AxapLWn9rkWBE9MckjG90
   Skpvog/StNr0PiQ9K8JQLlAj/3YfhsObKG6O6FQJa3lfhOyoeW6hgct7/
   qw30JiUwtmuSjTWkBTMz5r9L+NdMfXoS5yc3rn40PwJr6qz/nHg/wXX4S
   aHXUM2W4yQgKgsXA2WRitzB9wn03N1m3eiE6V9Jx+cnpSYbTD3YPt7d+h
   g==;
IronPort-SDR: vKiCDCfUXuzHVcpF/ngag3cLKM7RS9YW/E76HE0n5M/jQ0vyTQO4/u+DDgW/09HpqwHlapBH77
 11JosnVN8Pqf7vBa+HL7XLiDKWmN3cW3CY14MGhsmaH471fCCjjTYOlcRD7EO5MOjHdNqM0M1u
 /vba8wgzYnvTXQUzQZzB9ylo6SZSmHiiXGhzY6KMUkpndkRiALi3Vv2/45wukQp/dCAJh+GIxn
 Tq4yegnyfyjr/Nc0hyTP1zT98gpxzS1PwRBgYHAs0J5BFauSKc6gADkAjRoHxgTL9zDBjj6MYm
 MNQ=
X-IronPort-AV: E=Sophos;i="5.77,272,1596470400"; 
   d="scan'208";a="257345782"
Received: from mail-dm6nam12lp2175.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.175])
  by ob1.hgst.iphmx.com with ESMTP; 18 Sep 2020 08:49:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bA6waQ7xgaMQit/l2EDxUeNWURS4fymrwj+xF8lGFEx1mfEHMGcPItY33VSnxlFT/T7GyG4mB+Iv1qUbc/DcghvQOgU4WBW30mQDUXdhSNebnZUbcfjicYV6W7NlIzGkrbiOE/739+zzbvgNzmkOdUcX6DjrMo9hGA9woiqIOSFfPrF6E6ik4bjFxhqwdQfBPOzzZh9EDfgdRP+cSMHA/4MTMVij/v2e63TgV+Ojd1MDRoHlPT89NWMhbtWyTt08eXzvoBroEQvHuzVtOGKe0Pi2flRkgMiveoDZ8QrdHPqPS3SYWlDUc+OTbdcLrq3pXG6prwvza1RPB5u0eFDBkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7JqR7pXh+Xz6PKBzCPTporzsN35nwkn5FNiRuZJmZlA=;
 b=caMnVtmHSxdrwzUwsBNTISvUjeSy8/fZaj9s/1eJOwoOEwE2byvjXZ84kiGdygxLQvVIILjcxBB1lkVjgVPU7bK2SpliFCQwuKk3uPKTKC8euHVB83NaxPfyPaC5+DNubPWEig7g/FjoRDpA/3mcSUt20P+B8n9SjomXX3o6bwMODJ7ycn4lhIncnebxEWf2hzlEcearoSLTMwNqoCMVYj58Ck2d1TNGiWmkRNdm2WmsvCacpzyVB1lBgKkUsQdxAy1D6UeDN/EDHV9Yjsve0Bj/DvQJLIov4GwUzNCHvaRXkX6ae0CPqgUHOF+mG+dOQqn6Jp5m4mi0R8418UgIVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7JqR7pXh+Xz6PKBzCPTporzsN35nwkn5FNiRuZJmZlA=;
 b=Otj+otm8AhRGFHhTowg9UXAxqLIMPAdwySvn9r16g+wEw6N3ILJJOZ/EBsQ8c/O7fVxGNDpbcIK2EJHU4tADoRlD1emLS8S4WgF7Mtgh7JoxL29xrJeQ80MnHhIjkW+3QU7NjDdzNuX82bUWCmZyq9Xkx04ea8ACDrrJB26bORc=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0424.namprd04.prod.outlook.com (2603:10b6:903:b3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 18 Sep
 2020 00:49:22 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7%12]) with mapi id 15.20.3391.015; Fri, 18 Sep 2020
 00:49:22 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Keith Busch <kbusch@kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: [PATCHv3 0/4] zoned block device specific errors
Thread-Topic: [PATCHv3 0/4] zoned block device specific errors
Thread-Index: AQHWjUjqfcSUOcFBsE6UeZD54mM7SQ==
Date:   Fri, 18 Sep 2020 00:49:22 +0000
Message-ID: <CY4PR04MB37517EE05467F208E3A395D0E73F0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200917231841.4029747-1-kbusch@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:c162:b6b0:12c6:8cc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 451f07ad-f805-4b6c-50e0-08d85b6caf43
x-ms-traffictypediagnostic: CY4PR04MB0424:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB0424960B52624E18A68EC5F1E73F0@CY4PR04MB0424.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F15kx66VT3RJEGMwXfdCP3htFikpJqFXKSZc3dHFzmE26vR0jpXNAnZEpWmqTfwgRS95sLLJzlChVjJtE5REIuDvmjC0whgZlLWQDPAqTr4vqTBi2j81sn8vEwBKZ3kK+xeX7knMe0oWELvBvSkRVGBZiS17GVFg+745rd0E78B57QVDclAPcmXdfLhMVJrFXyHQ/0ZOea9YYeIdxoMfVCn9x8t2jrIIP1nH1AJYbwIVawHSslKDKnB1IL/olk9b9c5CFt5hICZ9HsY2GkjPEHIFCeFDhukd2Y5dcA/5TpL15SH/Se8IwHS5nzU648AO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(376002)(39860400002)(346002)(71200400001)(66476007)(5660300002)(64756008)(91956017)(6506007)(53546011)(66446008)(76116006)(66946007)(66556008)(316002)(52536014)(9686003)(186003)(2906002)(8676002)(55016002)(8936002)(33656002)(478600001)(83380400001)(54906003)(4326008)(7696005)(86362001)(6636002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: NIrXdcsWUWlOc7APspJ9nd07bX3Jg7jhoWOhigg8i0DHLtLBg6wePWpkdRwuzXIlBUzdJwQXNOcs1QXYOn0RuYUdzKbu2Vm+bR/3hpV9lSKcPFt564OgwXNXRgWOFJ3NU4nifQ98qL/EsuPv0scE8uRcODASowTmEAvu2iyn17TXdvNyb4o4UGpmq/3kxgOOZrc9/6ryW9gHElnI5I8d7bKp1MEvAke+ewdgFsjH/hoUZ9iYOs1/JKw8FsROSn+UbvHa5/b7eXcO3Sks2anugwb0V2SBSAN35KmKcVndpc97yGU12gqu0QrgL3hTw6fB37v4WsXuutriLsqlByszL86+gaomEj0NsEFrJmWXR5ckEIeD4K9sFjqd16wlHUYkO/fDmzz/sSE31TPMkaTtIuuGEfqhflBgNgvHArULW6wKYWCixz3uV8mD6E1MlNiETAiwuFuUk+zB9FbrOcP/j7havSjFNMKYyMpzD7oi3mqBYjcOYyGOgwfwpLLpsIc3wLDv9OsP5gjvC5anf85ZnPx3j8X0wgKcBGDiLYCtTkCK0Fh2no+mIh5SPqooxr8uQhyrYAnqFLoFDlMFn67PIYOkxa5AlxruYDzR3Nb+8/ZYJyad08dFQuj3l+k+M0Nngec8KI6ijWKEiZqtI5omsT0zulzIgMtiWyuQ3uCqk4FY5ezPvhwbQ97u2dpHcmifyGk1i10UgFQwjxGp1l7PPw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 451f07ad-f805-4b6c-50e0-08d85b6caf43
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 00:49:22.6695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZWJNYzOTZChPL7vOsw4dsL06PDhJ4bAIkyVQhYG7QE2RjQfLltal2t+++8q8pFt5VLelQ1wdgPXZVWPVdUHUCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0424
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/09/18 8:18, Keith Busch wrote:=0A=
> Zone block devices may have some limits that require special handling.=0A=
> This series provides a way for drivers to notify of these conditions.=0A=
> =0A=
> v2->v3:=0A=
> =0A=
>   Split status for max open vs max active errors (Christoph)=0A=
> =0A=
>   Include scsi use for the new status (Damien)=0A=
> =0A=
>   Update documentation for the new status inline with the request_queue=
=0A=
>   properties they relate to=0A=
> =0A=
> Damien Le Moal (2):=0A=
>   scsi: update additional sense codes list=0A=
>   scsi: handle zone resources errors=0A=
> =0A=
> Keith Busch (2):=0A=
>   block: add zone specific block statuses=0A=
>   nvme: translate zone resource errors=0A=
> =0A=
>  Documentation/block/queue-sysfs.rst |  8 +++++=0A=
>  block/blk-core.c                    |  4 +++=0A=
>  drivers/nvme/host/core.c            |  4 +++=0A=
>  drivers/scsi/scsi_lib.c             |  9 +++++=0A=
>  drivers/scsi/sense_codes.h          | 54 ++++++++++++++++++++++++++++-=
=0A=
>  include/linux/blk_types.h           | 18 ++++++++++=0A=
>  6 files changed, 96 insertions(+), 1 deletion(-)=0A=
> =0A=
=0A=
+Niklas=0A=
=0A=
We will also need to send an update for nullblk on top of Miklas patch that=
 adds=0A=
MAR/MOR emulation, to have everything in sync. But Jens has not pulled that=
 one=0A=
in yet I think.=0A=
=0A=
Jens,=0A=
=0A=
We could add Niklas patch, modified, to this series too. Or do you prefer a=
n=0A=
incremental update for it ?=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
