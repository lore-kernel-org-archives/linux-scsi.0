Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 037DDCA9EC9
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:11:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9ABF620848
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:11:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="d4ZKJJ0n";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="fLhcxaGw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387403AbfKEALF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 19:11:05 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:17826 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729443AbfKEALF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 19:11:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572912720; x=1604448720;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=IpGkrazEPo+7ww0J9GyOg8jzBIXRj4bsgBJ8Ld6s/60=;
  b=d4ZKJJ0nmyQWAfFdaPsG0SCqtP4amUOkevMQCVhq+2xtPdw+CWcKfxax
   PI3BEutveX3hY9bzI22eaBv20TR/pmKniIVJG35Bg8TVHjpvrS49Ct3jf
   UnStVFh7MYKVYeFz4qXQBT1YOfYUkoUxj7lhjEhLYLVLz3cMmRxVy46zl
   2RWkIm+oBhTiMoYkv7QbnuQvPKooaDr/Wu/uwGixkPk60IvQ/F8qBv1nw
   YjfX06J48ATnLz2obMn+lLpf880Q5+JT3+8QYmcqCX99V6gGMgqsYrUoa
   raabg+o0Zc/cZsioWObOu1EuWZNVDAhuWE4IKW4pNLDJNKyFBoW018f9I
   Q==;
IronPort-SDR: mmYGmcdYizFoFbLIdnlII95gHpO+DdJjq2p/MZ6TKhX4xEElokrrttk0oHBN8GzBHVOmQDOpIl
 hC4vw0jDClHcJx/CAmBzrhCU/67IIwdl1x6MWfgzMSjX955TZGibycciBxI5nmtj2PJ2VO4c0+
 BIClN8zGNdv5nvTYNdFyEri3T96Mx1oDGcuP4STnXxU5JoLZA2U+aOFwNtjnWbvLNYBgiUWkHX
 VOLV4xafnXCCVciUZ+SYri/ga4LSLGvQ//H4eJbN3px6pzYTXg/C1B0xtwfOsoHhyhPEa/e3v3
 FKw=
X-IronPort-AV: E=Sophos;i="5.68,268,1569254400"; 
   d="scan'208";a="223294772"
Received: from mail-dm3nam03lp2056.outbound.protection.outlook.com (HELO NAM03-DM3-obe.outbound.protection.outlook.com) ([104.47.41.56])
  by ob1.hgst.iphmx.com with ESMTP; 05 Nov 2019 08:11:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=McfkCcHe+krpHs2HQHJFm2mMejLuNhCIj1X+wyfdXb1rfjLJhGPpp2qH8S8xgUqCQ4zdPd9+bjjHWkXQH/aYSr5Gi7TS/3Ho+1iaR22zSqZKsU6VAmrrur7jfnMHqQO1Y50Nd7kzXgjE9CUqKXVb2rCClKNrXD1ucxlRyfFGCMDutFnkI2TpvTnDYBxGHLBp0tLliWB22Ow076ODnuU51V6W6gHxPBp00L53n5xE0/1rJRUCazsOF8Iiz+8ftnEdNvJS0oEKuqlGq8aPhKpP3LuhOi9+UUBqbI4fsFA5tDx/1qDCRuzHW+TtEWdxdc8jcWA5N7csgfDHgeczHtecrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IpGkrazEPo+7ww0J9GyOg8jzBIXRj4bsgBJ8Ld6s/60=;
 b=l544MpHTrOI7JFn/yD8zsF4jtAD6N2vT/ANyTQfRmgLj6fWIuaQKNBBgoL7IJkp8mNR2mQRKGBDmI396o2fFKi2wpXDoybuL+8/tzG+rL0Su9HXMo1AkpEMW23p6DvzDfWUGbu0pQQe3oiilwK0xF+2EdGHE2hVOqwiQa0NKqIlXq82rCvb48O/MVMuHBnwzGeRkmUq1Y2VKPJ8UGIvu2aA5FKmOj1pOVP9G/z35u7ubmsFarBNcPU1wHgUAiYrZjL48vlcM0v3SZ6iB7VuGfwe4GkPYsjY+wSIXk6czsmzoHOZ4YwrpxTeg5LFLFJFDtS5kFSnG17eQrl1QYANHRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IpGkrazEPo+7ww0J9GyOg8jzBIXRj4bsgBJ8Ld6s/60=;
 b=fLhcxaGwDif2Z/JDiO/Nrpi5v29LYM9BnhfwUGKrOK9PL+xP6CCukMvXToFLWE69VjBeur9MpE5fu0roSxuIAtO6IgYGiHw3TPXoF7xHUmy4xlGJGy2jfXFZKLwncg3T8pGstarJ8Mf7XLvHyBdy///SxhiJASHwD300AsLEwCw=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB5544.namprd04.prod.outlook.com (20.178.232.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 00:11:01 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40%7]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 00:11:01 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "usb-storage@lists.one-eyed-alien.net" 
        <usb-storage@lists.one-eyed-alien.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH v2] scsi: Fix scsi_get/set_resid() interface
Thread-Topic: [PATCH v2] scsi: Fix scsi_get/set_resid() interface
Thread-Index: AQHVjwGpa2dwZOHBZEqGAzLsDczxpQ==
Date:   Tue, 5 Nov 2019 00:11:01 +0000
Message-ID: <BYAPR04MB581685E630A8EA91902B2F9BE77E0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191030090847.25650-1-damien.lemoal@wdc.com>
 <af516590-58dc-0377-5c54-ac63cffbafc8@acm.org>
 <BYAPR04MB5816D4B866F2E7CC421E8488E7600@BYAPR04MB5816.namprd04.prod.outlook.com>
 <a33afd2e-a7d6-5584-dc26-79fb8f3d6a97@acm.org>
 <a640ee15-515b-6811-9883-48b49ead9276@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e6662920-8224-45cc-d4e3-08d76184a415
x-ms-traffictypediagnostic: BYAPR04MB5544:
x-microsoft-antispam-prvs: <BYAPR04MB55443B85DF64BDF520CB50DCE77E0@BYAPR04MB5544.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(4636009)(396003)(376002)(136003)(39860400002)(346002)(366004)(189003)(199004)(66066001)(81166006)(26005)(2906002)(76176011)(2501003)(6436002)(6246003)(7696005)(102836004)(55016002)(478600001)(53546011)(316002)(229853002)(110136005)(14454004)(71190400001)(71200400001)(2201001)(8676002)(256004)(81156014)(305945005)(486006)(9686003)(5660300002)(7736002)(6506007)(3846002)(186003)(25786009)(86362001)(91956017)(74316002)(2171002)(446003)(52536014)(66476007)(76116006)(66946007)(64756008)(33656002)(66556008)(66446008)(8936002)(476003)(6116002)(99286004)(14444005)(4326008)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5544;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I8EjWxDohBi3M0WpwJZoR59Yhk/EyZMAPlfkuzu0PTd+nT1DDckJrspJs70NkdCSjyAtuqcZInOfTbTwnYUOm9DNHhD/bAYipGUIlXB+ovE/XOEneNFD20tnquXlhPLAxMAprikJHC0hTTMpEAQBD18cRgtO6oO15XNQ4YJzDuYjoZQwO98TYHKxSkziQ5GlrJXhWX2fIApOMblN7nFOzr9KZm+yt6NMYUoYzriBZ2kWYcNx8HDznOu0g8olFtNtVMRwcd/kg0fA4W5Rg57i3qpOLX31LFw7g/SKgBUg7cAp99h8KS/vdDhGMwuG+QPefpZ8vB8Dgr4zm5NcKKr5/lYLGLl730QYf3GLoKnn37M/2t1Wot+l1ZTp2UZwaA7Hqr+u1Ew69gbFhwqPhltKvZkvibtHuojSC9hKlNrhm+iBwvdsZGO4LHa4TQVDrnaJ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6662920-8224-45cc-d4e3-08d76184a415
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 00:11:01.0317
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kYw6fJvFqAqm1V8XiwHYPPZQ0HRZ7PeK1sGMai0u4S+Nn98yNPBDM1kihevU1/4Qh5lzuJcQISzkS1mPkFv+9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5544
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bart,=0A=
=0A=
On 2019/10/31 17:39, Hannes Reinecke wrote:=0A=
> On 10/30/19 6:01 PM, Bart Van Assche wrote:=0A=
>> On 10/30/19 9:21 AM, Damien Le Moal wrote:=0A=
>>> If you feel strongly about it, I have absolutely no problem with=0A=
>>> dropping the patch. I just would like that it be dropped for the right=
=0A=
>>> reasons...=0A=
>>=0A=
>> Hi Damien,=0A=
>>=0A=
>> What I'm wondering about is how the SCSI core should support residual=0A=
>> overflow. Should a new member be introduced in struct scsi_request?=0A=
>> Should resid_len be changed from unsigned int to int or should we=0A=
>> perhaps follow yet another approach?=0A=
>>=0A=
> Please introduce a new member to hold any overflow value.=0A=
> And document where it is needed.=0A=
=0A=
Yes, I also think this is the best approach. The current resid_len=0A=
member of struct scsi_request can be kept as is, encoding actual=0A=
underflow of a command (less bytes transferred than asked for). The new=0A=
field would only be used in the case of "overflow", which are not actual=0A=
buffer overflows as Hannes pointed out (otherwise, we would get memory=0A=
corruptions, iommu screaming etc). The SG driver can make use of this=0A=
field to keep the io header resid as an int, with negative values=0A=
indicating overflows and positive values underflows.=0A=
=0A=
Best regards.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
