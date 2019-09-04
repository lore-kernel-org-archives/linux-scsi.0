Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FE3C3A5A9
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 09:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFBCF2339D
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 09:02:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lZ8akT59";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="qfERnoW7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbfIDJCT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 05:02:19 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:9953 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfIDJCS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2019 05:02:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567587739; x=1599123739;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=270K4g9VJWIE29d48SZN06WZTImyI4+Ho5T+osx7M2U=;
  b=lZ8akT59pM+vc9Z2pSCgZq4a/98KCF9l+yIsHJg2BEVfBzN+IdHJ42EC
   ZOV9isJR9YAZ8jZNF6NygaZITvd1g7EjHLJk+yeePIubbO210ErlT7f6C
   yo8cYDM/JWYcMberu0b8mRsvgFTgnGeyxiNVPsWIYSCW3gVz9PsZlLgev
   KrCvZWmWm+FnFQ6SF+oHqJE1jQhXLDjFt2aT1Rw1ERmyjztmElD+rVMcG
   +4gW/PbIYKpFv51ARI/0nebzM8MRN8YuQExzXDvxxjekwFXAuUf78e/VE
   dDUNvA7JqIIyYdEJyIjj5yJZXRwCCOrQx5jfEsdjlkPy5g+KSewTUJg1B
   A==;
IronPort-SDR: Iuw+FcKbFtq8gCSOT6neaeRjihhG0PxrALEHYkJL6ngIPpF3b/GIP32bnwSz4KpV1FIF7gL6+1
 zTcldpAFTk+8bZApXYcXU19Ur0JxBVdUWqWCz+v5H11QyBCjoJkv7a7l3HiMrRtqJuIBtyGofr
 FFMc06vIrCRmQ2csCl65/bdo/NMr+wHTwDY3MVz43b4UKDI/DrYJe7ISjJhfR+rFHNVS0lg+hO
 TKRoJXtGtlNpE7+i4SbLal6FkYIeACOrY4cL/RSf70UsArnBLSmgCU7Ze/ngaDkdtEKrsuj1ua
 Qso=
X-IronPort-AV: E=Sophos;i="5.64,465,1559491200"; 
   d="scan'208";a="121947893"
Received: from mail-dm3nam03lp2056.outbound.protection.outlook.com (HELO NAM03-DM3-obe.outbound.protection.outlook.com) ([104.47.41.56])
  by ob1.hgst.iphmx.com with ESMTP; 04 Sep 2019 17:02:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cxGgN2liXSDV+nIoOVyVFHg6iMpg+CQdRq5oU8RaERv7z7ZvRn1HlyssPJo6y2KxplS+YiT40/l7n4gWv1s691QeHpxAmjF5gjtstvARzRwOzPouraDDL1AJn76aexVsoEBZ16cGLnZv/iacYE5IL0ciSvGGxJH6BmJwBbME3JpP+e63Z8nwT5lOB9FjbKdnLxZprlOc1ZsmaRYjZR1sncshu+cTMVa7Z97jFnhvP9bGVTrDkopKGbdALxejl/ufiO9WVHFE/sub4V2tvB1WOzlwDd5XGeFhcfVKFlHuscPN/fnwy7q71/HfUpU9l2/3tilcwh7wB9KTdVJTDcp87Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o1BQ8bOrHvBzLOydI3NUwsg1hWG4cxL5xY53aLB571o=;
 b=Zm7Ko5TaGFCf3TsXYIELMRvhYPB0cy2a2hawqgtME0+uoM2w8aR4yulNhsxQtz3b+gYKyURC3mxmImHyj/0Yp7JNSLvGu0BWmnc7+yU+/fWTZ7XONnEzxR+Ga3sKWDFUdhLkRSwrMqHFSug2uWmDL8+LYuuvsKLW7O9H8VzRvEkH6FyHpOuP0weZ5oWDR2/4CkwHePmVRu08Z1CTfBOei9wo6oAr3BpWN5yrp63Cp29smJOunMqLqgB7sOUGdp8mQoe0iv+B816Ql7IOi/dQQ6zjFqr8GxCQ1CdGuyUOOtBaSSpaC0N5bUDPUk7+pULP56/IH79MQboArgkYmgTfjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o1BQ8bOrHvBzLOydI3NUwsg1hWG4cxL5xY53aLB571o=;
 b=qfERnoW7Xsz42M/OCzN8PUScd+9dsiXD0QvuK9x0yzJSAV2wFhkABreOfbyGWWHGmLUDurEIZXHpCGSjoHRr4dI4btcrT94SRfenqf/N5i7Do8cjDXafi3Fsy7LWt1O1nIFcT6B+N0a5pqAC6lfwzt7r/29HXpl8IYsN3AXoRrI=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.58.207) by
 BYAPR04MB4088.namprd04.prod.outlook.com (52.135.215.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.19; Wed, 4 Sep 2019 09:02:15 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::50cc:80d2:5c1b:3a10]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::50cc:80d2:5c1b:3a10%5]) with mapi id 15.20.2241.014; Wed, 4 Sep 2019
 09:02:15 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Johannes Thumshirn <jthumshirn@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 5/7] block: Delay default elevator initialization
Thread-Topic: [PATCH v3 5/7] block: Delay default elevator initialization
Thread-Index: AQHVYvzHEKIbafAg9UipJ8XeLfwVBA==
Date:   Wed, 4 Sep 2019 09:02:15 +0000
Message-ID: <BYAPR04MB5816ADDE69D61A3CB47DCC3FE7B80@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190904084247.23338-1-damien.lemoal@wdc.com>
 <20190904084247.23338-6-damien.lemoal@wdc.com>
 <22bc754b-541d-3c72-6bb0-68cd841faee5@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30fff441-7807-4dcc-0a82-08d7311694ec
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB4088;
x-ms-traffictypediagnostic: BYAPR04MB4088:
x-microsoft-antispam-prvs: <BYAPR04MB40885D438CBC31C5FA0942ABE7B80@BYAPR04MB4088.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(199004)(189003)(66946007)(8676002)(74316002)(52536014)(446003)(53936002)(81166006)(486006)(76116006)(4744005)(91956017)(8936002)(66066001)(81156014)(71190400001)(71200400001)(66446008)(64756008)(305945005)(256004)(26005)(478600001)(33656002)(14444005)(5660300002)(66556008)(99286004)(66476007)(9686003)(102836004)(25786009)(14454004)(7696005)(186003)(7736002)(6436002)(316002)(2906002)(55016002)(3846002)(6116002)(2501003)(86362001)(53546011)(6506007)(6246003)(476003)(229853002)(76176011)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4088;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pWIO4nURhLAGlIpG/YL8hkV5Zn4pz8S+mCSqZuPzd8xGheE1mfZZnNhGki6dlvHufH0No+JBuPRCTlv724rC/9BaVAiJQpibtaUMQMmSyJNGpzOqytvXMNFkhJxTtmLe02m2qI/gAZAXo8fEL20fCFyH7XkTsVdmMNBB81YT6cgtpv2OdENOYQED0WyOQYwCI+4OAsETATFgjNRzxAg/t8PU1n05YkrFS/sKfgIl2FMYB6h558F76mLbrsoWT3FrssDVhUim9fbmLRoh74Wh4QhgB0jjrZWORPuToZ1j+l4oR9LcnKVIHwZLcMbXAlUsGZA2l3dQo/F3UhSrt+CVzgMZjW9H8xHE5PH2w7wUMg9iTS56VywWnxCgQrNRZNaSDIEn0gA8UePHK5JoMGV/pBMO0gfH8EeUzeafrWS5TuM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30fff441-7807-4dcc-0a82-08d7311694ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 09:02:15.2144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gZJawA652sdHaGvxzi+QIdk1lsFvymMWqYUXV4nzn99KCxNTi5qtdMTfaz5CrKp0FFJ//QVv1V13xUPvLaj4rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4088
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/09/04 17:56, Johannes Thumshirn wrote:=0A=
> On 04/09/2019 10:42, Damien Le Moal wrote:=0A=
>> @@ -734,6 +741,7 @@ static void __device_add_disk(struct device *parent,=
 struct gendisk *disk,=0A=
>>  				    exact_match, exact_lock, disk);=0A=
>>  	}=0A=
>>  	register_disk(parent, disk, groups);=0A=
>> +=0A=
>>  	if (register_queue)=0A=
>>  		blk_register_queue(disk);=0A=
> =0A=
> That hunk looks unrelated, but anyways:=0A=
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>=0A=
=0A=
Oops. Yes, did not delete the blank line when I moved elevator_init_mq() ca=
ll.=0A=
Jens, should I resend a v4 to fix this ?=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
