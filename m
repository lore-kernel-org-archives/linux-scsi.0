Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9D32CA9EC7
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 05:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62D582084D
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 05:24:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="pyQ4Z3zW";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="NKymBmaG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387443AbfKEFYN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 00:24:13 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:18993 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387421AbfKEFYN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 00:24:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572931519; x=1604467519;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=nNpg/DUAi3ZPTGpMhEs6llqrA+4xa77GTilkDhFTV3Y=;
  b=pyQ4Z3zWK3S849u3dsZ4wIsZsdwUOebQJQ4h5ZMBnSaM2VyaW/DysBTL
   bHGbdvL5TLpVMuvF2DZ+FYRwFVaXMJCPMecmzTbTqpXmUJuF7AmSgMyCK
   kJLFGxxwhafUB5tki/k+J56qEudGdiokvHYuZzouU44WIWQ9dXgMkBE7P
   +X7FZcutCwKy1qmN4t50aPTnSIQ0J7p7m2avWsAVemvhm3kMVQfuYykAk
   rk/vqhj1vnmOrFOZy7aqoHxqoxv4D1/NMIBIbbG+1hyDPsBsY3EEzvdje
   BgsHOuX6FmBSyjIqpP9AEfWpIu9to4Fpbj22VDxGxtlGhyfBPbof+h87X
   w==;
IronPort-SDR: YSuPxDkg6zrmt7b7utSaWPU/tIXhOGpyKwZGfXisrUCZaUbxfh1MQpVZs79/8xWYSUK/GVvdVv
 AWHCOwUipqvU2v/7VS2evCnsro2+TqUTrM6XgsJdKN755ARm0p6w9V1VmHZvz0q/dgJXP7naDz
 s5qBQteGcxjC1q3gC0yiwcAdLsBWFgJv+qvGJlhxpMHQPBzlvDK+lgNO5nzZ+5DMZqedBpITP9
 /p9SRaoYNrQCI2uai+7EdVY7wjWQHe9qz2H1fUs5lwAMHe1+9Pd7bMNtR8STz3WKScRf6hwQRY
 zw8=
X-IronPort-AV: E=Sophos;i="5.68,270,1569254400"; 
   d="scan'208";a="223321582"
Received: from mail-sn1nam01lp2055.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.55])
  by ob1.hgst.iphmx.com with ESMTP; 05 Nov 2019 13:25:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QnUKTs1avwPNQptBfPGsuW5g9wOUa5dFnXdMTgmWEIMv++r/RI29wiASFVMRQ8NZvaxeRYdnAyxyDP80eF7l7GefwpzsyhHJriPAwmD+/nJuOBI+3SZPb3nYBFEgebyLsOwD7UjorZdY8l7zmsFBgGJWqS7NbhTQhUdDIsiJeO+/pF884lTl+QS8tRLJVZqLIS/0NGOAvxmYGsF2p6DQ3gZdh688f3w6lGdvFwj5gvG7ktxhUCMqMGulkyxMDG+I/IDnQsk/K9TrLXlPXPbhzD8WRjQ8lOMhsqxi1+hBk3CouTFs3Q8A+G/JSQB5YTsuEsomU+vTcCM1tXUkFA5gjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNpg/DUAi3ZPTGpMhEs6llqrA+4xa77GTilkDhFTV3Y=;
 b=ZoPVyQ18lgqVBI2eIsWShQuhMD77PUtmZmZFlqk+SBRV19WXawPBn/SNPZi+tnCDnrDFQ3nAStzYiTFdCT0a1TuJB7yWoHO8ADYXHf5P4OrpqODFCUJXWiXjz3m9z+plHci3Ik19Sx67W512y25thw+Unbwxxjqylr8GJw4xaary8JCwtqJUZdH3ZApfA/YQXCnRPyZTWxcGiwbCOZv+xvTiWkaxhwKojRt/NgrXHWs47xfhQlw5CfCTULFeqQTaCMP9+fD8L4YQiLAkVRyWqK01diyh/FRrGLXhvbuRHk/0e4ge8gzJWcSnJkG9s2fjHoe7l/RA46ie6NSdbToWIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNpg/DUAi3ZPTGpMhEs6llqrA+4xa77GTilkDhFTV3Y=;
 b=NKymBmaG7bIGXgqXsbiL5P41Y6rs1RzK7KQXIsmBhAn8hmPJsaqO0cqb4tl0GlcqbVtBH0xsmbqk+VEKErTGI0kepzgG2oeO0UJiJ5LU+GFLj1AcTi5N4sCrKmmth4lpIF9gpkL2HnWHbxC4Ldu6+kub1ulozT+/oFUJv5LKFv0=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB4231.namprd04.prod.outlook.com (20.176.248.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Tue, 5 Nov 2019 05:24:04 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40%7]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 05:24:04 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "usb-storage@lists.one-eyed-alien.net" 
        <usb-storage@lists.one-eyed-alien.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH v2] scsi: Fix scsi_get/set_resid() interface
Thread-Topic: [PATCH v2] scsi: Fix scsi_get/set_resid() interface
Thread-Index: AQHVjwGpa2dwZOHBZEqGAzLsDczxpQ==
Date:   Tue, 5 Nov 2019 05:24:04 +0000
Message-ID: <BYAPR04MB58164FF9171FDA66879E7400E77E0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191030090847.25650-1-damien.lemoal@wdc.com>
 <af516590-58dc-0377-5c54-ac63cffbafc8@acm.org>
 <BYAPR04MB5816D4B866F2E7CC421E8488E7600@BYAPR04MB5816.namprd04.prod.outlook.com>
 <a33afd2e-a7d6-5584-dc26-79fb8f3d6a97@acm.org>
 <a640ee15-515b-6811-9883-48b49ead9276@suse.de>
 <BYAPR04MB581685E630A8EA91902B2F9BE77E0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <yq1eeym52a5.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 072bcb9c-4386-4371-2c39-08d761b05fc3
x-ms-traffictypediagnostic: BYAPR04MB4231:
x-microsoft-antispam-prvs: <BYAPR04MB4231DCA4184BC3033FEC1360E77E0@BYAPR04MB4231.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(199004)(189003)(5660300002)(6246003)(76176011)(33656002)(9686003)(316002)(14454004)(446003)(229853002)(7696005)(54906003)(26005)(53546011)(6436002)(6506007)(305945005)(55016002)(74316002)(71190400001)(102836004)(71200400001)(186003)(25786009)(478600001)(99286004)(7736002)(256004)(14444005)(6916009)(76116006)(52536014)(4326008)(66946007)(8676002)(66446008)(64756008)(66556008)(66476007)(2906002)(8936002)(3846002)(6116002)(486006)(476003)(81166006)(86362001)(66066001)(81156014)(91956017);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4231;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bq4jYsd4N0SV8QjZaY/tCP5s4KbSq/ehJ/O1n3ya91dxyRANo/iV89fe78wOC52jOXTBiGKwlsum0FDiqMJS1w9kznEYzT7hvLR5HbCsqcU6qZrbSM4FY9HzpmHA2tUyRSRKtvBClNwprTbPrrsysmrrA8o8rBxadBwkJXSkfq4OKcxK/Vlbb7qK9Q11E17/OzdGBDSdjkVuzjbKOY5/1KWACsJ1xNGs1QwVJxt5Sbkr/WcoeT/Lnpecf1rDm+oFcEgmCUIC9OlAZSgiKLdRl8ktaKBXLrYFLWEraxlZ004tch/SFkR1BYpj2prLMH5CcFLCUXsIFBxSr8LUiHFACXzDIMYquzSF0xFX5IixENpu9CyjZpU9OdGL78SITi/mNVy3LX2/wkivaqXPYcgiYRaA0lR0ZOsACIrmIVES/VQEZDyNie+xY+KboWxdIINk
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 072bcb9c-4386-4371-2c39-08d761b05fc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 05:24:04.3090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: smresKq5DiRrrNWqWcMTbbkdnrzX5WTJ20vaNv1K1t2TWrPfMiMuzVriurjE2GCB6ciuUgpS3cdfDGhOn29qIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4231
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/11/05 14:19, Martin K. Petersen wrote:=0A=
> =0A=
> Damien,=0A=
> =0A=
>> The SG driver can make use of this field to keep the io header resid=0A=
>> as an int, with negative values indicating overflows and positive=0A=
>> values underflows.=0A=
> =0A=
> I am all for synthesizing what SG returns to userland.=0A=
> =0A=
> That is also the case in the context of Hannes' SCSI result revamp. I=0A=
> would much prefer to have well-defined and consistent internal kernel=0A=
> status fields and then transmogrify those into something compatible with=
=0A=
> what userland applications might expect. As opposed to perpetuating the=
=0A=
> train wreck that is the current scsi_cmnd result.=0A=
=0A=
OK. But just to clarify, do you mean changing struct scsi_request=0A=
resid_len field to an int and considering positive values of it as=0A=
underflow and negative values as overflow ? Or keeping resid_len as an=0A=
unsigned int and adding a flag specifying if the value means underflow=0A=
or overflow ?=0A=
=0A=
I am rely surprised that my simple patch resulted in such a big=0A=
discussion. But if that leads to code improvements, then let's drop it=0A=
and work on a new series !=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
