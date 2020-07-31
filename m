Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC47BC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 08:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC73C2074B
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 08:08:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hDbAtXP6";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="N9ENAsda"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731524AbgGaIIc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 04:08:32 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:49076 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731861AbgGaII3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2020 04:08:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596182909; x=1627718909;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=hDbAtXP6aTSceMeK3ubrim7JJYdpHgTXN2Xap/2GMmmzkLr1ouXLKlvp
   1YuIc8OAtI6nR8AaRPlqNZL8l14Zec2Y7ZBS2XkdyGghRXXZjrX5vqjbD
   7a/vYaGyMpPQnOM1D06iBCgs7dPUXn/i6EXGiwO4yhW9FGMX+Ypoah9xt
   rbQ9k4ZU6ObEoIqt1PTGc/DDCTPMK9EV+bFdBsEFEHcgMHa7iH6NDK/Vo
   3agh4+R9mllb2wdnJ16cF7JJcy1BNxDcVCkB34/yaU+wL08y9Q/052/+8
   28ynZX1CEj1e8kvAlWx8uBcwFphR6j6FAgrqDw/1DNw0tCD0N4zlLY15k
   A==;
IronPort-SDR: ZyztGC/C/cFgnBcYTgshDZtUqJ8kclCH+IOiv7xF9yekDs/NnedTmV8Hyz5U9Jp2yr9AFe1B7U
 O+wH0UCbtGZ//EZk2mP0wap2DTsaFWaOYIl7wAPvFtIAuABrP94TTAkM7m39SI3jE9eGuYBJGc
 1pFkw+9RXKlRQw6n/lpNRFh8fHLeQNCNQn/JiHc3UGFP/UQtiGW9tlKeOQ30NxkDkSAcqeDbGj
 J/1Qaibqlfm2AGpImx9XqmvcKBn5vUr+ExeTAkp0wpKDvqsr1lGpQndeYWg/Ci2tT+H58Jwm5y
 Sio=
X-IronPort-AV: E=Sophos;i="5.75,417,1589212800"; 
   d="scan'208";a="143822428"
Received: from mail-sn1nam04lp2052.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.52])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jul 2020 16:08:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jis64WZhPFrc9HxdyVPQw510IjtYcGddZtyMrtufKVu65wl7EXae+Ub12qNQi1Ml+mzjocP5Cjm0nVZROO7n8jU6oXQrDHN7dnC+I/NyCYVdfOAZ2WqzZzKcHt6Sbid4C3P/MzVjc7M5269kefC+54l7P3Kotgqci+e6+CmceyIQ4HnAj7mlz06FyySFxVnFmpYUBUDP3YKHqdUAqLexpumvu9fpL4lIk9V3Qb+BOzpajAQJYMMbe/tTrPlxfEjYwUGuPV+FIygjdWwdxeFhC27/FcuUg4/EeN52ZX4BLVcLcP2FhV8S0DM0nBC5nIVZ8mgUsKgI7qxW3DG7bXoIKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=hVM4ZjsPXGyUX7wU5ykOqoWkiKgP/v4qnvDJxKi4xmAGZTYpVazYwxof/EJS/FEefqkrIOJbk0/vxsXtUpa3LoV0621vUwmjiWQB2rK4jwPyIDMF2S08ACbShkdBzsb4wj5CBMX2MlK6umMXkLdDh+Z8ENcRIo0GjdXCPCkhDWisO1fQMKLqhaKKdjvZehNmKDuv24k8EHiQMoIA9tkmuFLqCvlWhcGOPkAHTJaYeFyk2eTO9RCRkkT3EnrOsP4AWxtfMZhKrOOp1hBLPLJ97gUxP828KN2Y0e509Y/uINpYxMJKw4ZjRZ1rBMjf3xDIRrQ1XBmZNJjH+GybzfuPPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=N9ENAsdaIPM7u60nm09dfD93Hd1I4CJVbgelaYLBYOSfVArZPCVkkLKneU/zcG3uUcGP9qQ+36fIFnWqjklCxbjIPwJ5nDr6TTi8azljJNAl4SEjPYXWZkHTdMhRC326jiu9x5r43l1P/ydPzFdV1aSv7jR9eZeZrUCFiJhTdTk=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB5117.namprd04.prod.outlook.com
 (2603:10b6:805:93::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Fri, 31 Jul
 2020 08:08:27 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738%7]) with mapi id 15.20.3239.020; Fri, 31 Jul 2020
 08:08:27 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: sd_zbc: Improve zone revalidation
Thread-Topic: [PATCH v2] scsi: sd_zbc: Improve zone revalidation
Thread-Index: AQHWZv5eipJntaBdOECfz51AhPh9Yw==
Date:   Fri, 31 Jul 2020 08:08:26 +0000
Message-ID: <SN4PR0401MB3598D114255771ABC3E00D5D9B4E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200731054928.668547-1-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e992b46c-e5da-4747-1452-08d83528e76d
x-ms-traffictypediagnostic: SN6PR04MB5117:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB5117768DC37BAC73CA6FA3979B4E0@SN6PR04MB5117.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oXMXSTh/uWRWzKWlU22/X56rhHH29FCxW0Qf1SJpID7oj4QFMcLZw0O68BVJBESQIuUcSWQNTCeJkfzA5paUn1Ud9P2LUUNLfMNWF3cL8F71aPy/ULMi6oCVsuDTdtLjljpvkIboOQFXjM/NMXXTx6srMr4Uk73B7VPMfPi39i9zn4lXF+S4V7FYfBTifh6feCXdcFjc290zPi2PyNm2WyZjgwqmlknXHlKSkYvfdC3+TYRwd6xyHeRcf0qzN/o6E5LPKklK3BPS98CHqGsR6+Lr0UY1fepa1Rti1uvLb5fn4jntQclplzJwSUc5EGiNrQVyLs4nb/b1yt3UD5S9bw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(2906002)(76116006)(91956017)(9686003)(110136005)(316002)(55016002)(86362001)(5660300002)(19618925003)(8676002)(33656002)(558084003)(6506007)(478600001)(52536014)(26005)(186003)(66446008)(64756008)(66946007)(71200400001)(7696005)(66476007)(66556008)(4270600006)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: hhhAiqORC1tiJXYYZzZ7gFicxloR4jbuJaFSfeBFK8TTE6CrptW7NCB6BVtG2N5FS39V5LTJoIqPw9jilxoG+KpZnf/5NG9KS2JrzTJjWLDfQFQwwKvPU3VUdn1ASkRVp4+GLcyA5snNdXPWibMuGPZ1iEeQrkH0I6LtKGcNaM7HyWj/54pu219yHCS1i2CO4Wxu0a6xsvpYvJlOIkYrWkPYN7efgCif6qz9oHirln7e+N42c9YuqKxDiC75XuS2gL/ZHu/5OHyeUJ3yUQCEqJHLS8nWWp3Zx+BGGNjyWeT7F6I86KeZCDf6FYVuarlz//AJGMKfwCm/1HyljPFZsSjpB4o3OI9zb7iBpAkkgXmAFIAUb2dS0/GfT3Rr+5zi7ZPf3hSBMmI6oKUjipNqqv1OqBeWb7LjOUT21isAtxGBvgC2pua3u6T02HgW8Rlt1y5iohN5QV/xetBhvjA8EFXvx/K6Q/5e8Xtc3yitIy14XnzG1MmSQD63yEsm7V4IKRB7UZfLM9UzTh6c+wAVxKJRRge3t0IDwz85WjO2p+8bvK78AsdGZcPyHrkHDISb6xvE7WmajXajdGGUieLKPz45jmpvelAzCzpQ2Aj0dpxSWr5HZKjCUR/d2kYRd5tpocvnqCweVZAjJzbbS0/djw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e992b46c-e5da-4747-1452-08d83528e76d
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2020 08:08:26.8865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UJKw+kZNm+EByVlLFirhFxU9ep3q67/nXofo1ZWH/6+5spdBud68fXX2Qt4aiJRXIZgDAYkzREOurmfviBnGVFf2ZDjZF2fvBk0FIJR6KnI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5117
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
