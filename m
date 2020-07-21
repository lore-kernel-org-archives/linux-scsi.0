Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6703EC433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 11:31:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41A7F20B1F
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 11:31:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kUg35GFq";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Bie0L6GX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbgGULbO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 07:31:14 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:37720 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbgGULbN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 07:31:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595331073; x=1626867073;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=m0p35NIssA5AOML2PWxm0js9e1Oongh6EVmxbW5ScaM=;
  b=kUg35GFqAqd38g11Hu88/oLCO5AkR+1IN1q3F+FfByamPjLqwg4ZqCcl
   K3ZQubjJgDGxZjamVXokAb0WC2yF8pKS/vNF/rze39JFHPsfAgL8yA4wI
   2wb6J39uxQBwUnkeU2CaGHjq/lmrHj9wmznyuisF0TPM/KpTcKZyQe0zl
   f1O/dEjAlQv1sRh/MaPORDww3LciXkfcGNVz0BM2jsdXsBIHEhrwU5Ubz
   /nKjSVqZCfHKrSkVFUXr1Of5WzOiM8fpdyM3n6DhAgWfQI97Js92ynVDy
   2v/csNUD4v+Tfy+gNjBwwOqRdypQvIRRWURMG41wfOwpRBKL113aoPLgq
   w==;
IronPort-SDR: rGJQAhneiP4UshgKM2y+mLpjqpW0XWJqEjwQ7dF6PNQk70Z7Fyp/kQ2rGuE+rKifz1+OtlAyeb
 nBpJshpiYXegznq5wlzTlnPCA7mRyoF0e/02JHqAtEvNQz2quP0KwsHJ4CSUXKV1eJDb0HTWl8
 CfA6AAn77Agspv0e4FDiUzVDTGV8kRfXlDhUR4sVyFUfct+Gz4sB9+9Bpy174WT45hal06Idzo
 WOeYO1L5t1e8BJdtP2+QMKlnd5smn8YC6PdaATNMRHyKb19Q4abkhyOr084iWrM8gNbTlYgxUw
 lDs=
X-IronPort-AV: E=Sophos;i="5.75,378,1589212800"; 
   d="scan'208";a="252290203"
Received: from mail-co1nam11lp2172.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.172])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2020 19:31:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R/4pzPaarRDm5kY27ikCGheY4aKh+moqFNEYwjc1IixXapABQ/xw4yYz7HPnxzZselJQ7uv+dBA1qYfbxPoKh8kFxaj6lcs/Lr6QVZ2//Z7MpDRF3BQvW3M2KRhKAM1uUJw+HpadV4IqEXPwbFrPWFfNfO9ZdZe4+8odfGV0H24zn06aVgtG/vQPcpIM3MSPL6Maw9EyP5tXS8KqXnd9n2ZAQEteFFd23GYaOrKtnOH3sJRcBSk/+aHhIbkyN0U02BD49tZLut/jT1m77H78iMbK4x9mLMgXHzNjmX58ZifYRZve7kC/eU+uvFifwlFOdRxLy/lNAPjUzu6YgdzDIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+vtV/Ushrn0O+ECod7x/5Y90ynao4a8kGegcG2c0/gY=;
 b=YwzdKooeaRbKSrTwwrvA+jTX4vqF4qFheFxRuZMKofogotc6M8AN2I6VhbjDuOyZR/wBC+AKiHxPedAoydLmPKXx7mIIbBUeLV09GrEs7byvqaEXfZiRRgd8SBBf6pHBZRfk152IpSFMi4Y/lGX9wk9LtzlQhTUHaPfLAY6qjzr6jMxni7kgL5Nr7l8eSDpJ2MZurLBMOFA1cXMIdAtCShsZtPg90kjSJu3AjSKetYBoQl0WAN625kMOD5Osva8ww8zQtfVy6e4J9v3/nYCb7yl7ZiNhaKCXboEdDVIJJMPymQzItIHhU9dUIG6l+IAE8j5IyWCY12EJq0AdbqZ2Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+vtV/Ushrn0O+ECod7x/5Y90ynao4a8kGegcG2c0/gY=;
 b=Bie0L6GXRJeWmmTJpowFGDDYZASwYEzUzVTd4WrcPxCUWNl4ahF4h5e+PiX3hDplajSTCoPd7uffv5TZjp43t3k5B72POzCJQonISc8Wel2UjqFDKJFfJxtwFTfyrblTTe9A0ZGBi31Jx9R81L0t6an6OHaBvRuHjQwEYAWBd3A=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1176.namprd04.prod.outlook.com (2603:10b6:903:ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.24; Tue, 21 Jul
 2020 11:31:10 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0%7]) with mapi id 15.20.3195.025; Tue, 21 Jul 2020
 11:31:10 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Keith Busch <kbusch@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        "open list:BLOCK LAYER" <linux-block@vger.kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        "open list:NVM EXPRESS DRIVER" <linux-nvme@lists.infradead.org>,
        "open list:SCSI CDROM DRIVER" <linux-scsi@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Ajay Joshi <Ajay.Joshi@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        "open list:SONY MEMORYSTICK SUBSYSTEM" <linux-mmc@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Satya Tangirala <satyat@google.com>,
        "open list:NETWORK BLOCK DEVICE (NBD)" <nbd@other.debian.org>,
        Hou Tao <houtao1@huawei.com>, Jens Axboe <axboe@fb.com>,
        "open list:VIRTIO CORE AND NET DRIVERS" 
        <virtualization@lists.linux-foundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 01/10] block: introduce blk_is_valid_logical_block_size
Thread-Topic: [PATCH 01/10] block: introduce blk_is_valid_logical_block_size
Thread-Index: AQHWX00wSEUVG8TRcky47gGqEX5tBw==
Date:   Tue, 21 Jul 2020 11:31:10 +0000
Message-ID: <CY4PR04MB37515A4950060845E5860755E7780@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200721105239.8270-1-mlevitsk@redhat.com>
 <20200721105239.8270-2-mlevitsk@redhat.com>
 <CY4PR04MB37512BDEFD7B977FCD32A10AE7780@CY4PR04MB3751.namprd04.prod.outlook.com>
 <cef747910431d81524e455e6380df1c610d1884c.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7864c567-2879-4189-aa3c-08d82d699125
x-ms-traffictypediagnostic: CY4PR04MB1176:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB11765C8145E64D5E655AB266E7780@CY4PR04MB1176.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H+cdYwzlG1gqDWCLOBZk+Qhhqaipm5xADkY2SLvQyB5pcq31wQf424l4v9y3EUjHar5tZB9QnOAvuwgWNH9Sgf81VxR2Buf7diD36P0sXmrA40wj2V3d+BnP2GYaJbqXw2AkD07mcQLICBBdlHwXZObS+96gNyKosXeRnPW4BFr5CNY1dgsuSxt/d/763EJv3Aia2eOGCxESg/rH5rsl3gQOmpyv1eMkRfnh4f9DGtcAkxDsVZghjUD/7g7dCkyrrPdJjeV6AjVFtcSqIc+8/Vka9h+O5+K05PR0SaoXIcTQARYGiv6MWbs+zzj0Az9uO3B0ZXpiBkl4PZ+j6y8ALg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(396003)(376002)(39860400002)(366004)(76116006)(91956017)(7416002)(86362001)(83380400001)(71200400001)(26005)(66556008)(66446008)(5660300002)(52536014)(55016002)(7696005)(478600001)(8936002)(6506007)(110136005)(2906002)(54906003)(53546011)(66476007)(9686003)(33656002)(316002)(64756008)(186003)(8676002)(66946007)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: FETAigmvrFLi+tMDT0laPSrYRNzyL15WFiO3MJu2w1sPjvhc7h5VOduvLKVppmUORkxkYr/Vi3AD3ffTJM7yUsG054zBWF3K5gjcdAxsHv6N6Uxz1lmxP3AWtkDfHUI8eVI4w2ffLmug99RDkmX3k5HXE8N/Oezxsg6Ee/XPTPjyydbHkrINQFGAltm79U2CkL4eHX6MeSKs3izXpKh+fmKRN5ceMH3USHOftthLBe055cBhEijQEe0kGt9ZekpB3jiqmTYtVbLgEyXDHzGNwcytfzrGPvtDmjASZFJgGowoCR1WhnJZD5+mNYUE22Mvxs3phTcqSbyoixQIo1zJo+6/sFjDoCHU5VBaW47cfyJNUkLG3nwPmqUl4SC/H4tk39L50XuAvB5J+fu6hsgWrQXX/rqNTlLg+q+ObYOGUvftoXfSLJUltaYrbOEdM8QBAgI3qqNasZb0BV4mNpFmSpStSCR0O2QNdLq1U1RZcpT8pHbv/Xmy9aZuItQfJRaU
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7864c567-2879-4189-aa3c-08d82d699125
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 11:31:10.0297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g3Rd0N9ktRlPFO/TECg2ASTK1CZUx2R6MZpF2OFQGAjh4bqEhlnqapi5PcTtjsKrpBCSjOg53ljVr68j8axx8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1176
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/07/21 20:09, Maxim Levitsky wrote:=0A=
> On Tue, 2020-07-21 at 11:05 +0000, Damien Le Moal wrote:=0A=
>> On 2020/07/21 19:53, Maxim Levitsky wrote:=0A=
>>> Kernel block layer has never supported logical block=0A=
>>> sizes less that SECTOR_SIZE nor larger that PAGE_SIZE.=0A=
>>>=0A=
>>> Some drivers have runtime configurable block size,=0A=
>>> so it makes sense to have common helper for that.=0A=
>>=0A=
>> ...common helper to check the validity of the logical block size set by =
the driver.=0A=
> Agree, will fix.=0A=
>>=0A=
>> ("for that" does not refer to a clear action)=0A=
>>=0A=
>>> Signed-off-by: Maxim Levitsky  <mlevitsk@redhat.com>=0A=
>>> ---=0A=
>>>  block/blk-settings.c   | 18 ++++++++++++++++++=0A=
>>>  include/linux/blkdev.h |  1 +=0A=
>>>  2 files changed, 19 insertions(+)=0A=
>>>=0A=
>>> diff --git a/block/blk-settings.c b/block/blk-settings.c=0A=
>>> index 9a2c23cd97007..3c4ef0d00c2bc 100644=0A=
>>> --- a/block/blk-settings.c=0A=
>>> +++ b/block/blk-settings.c=0A=
>>> @@ -311,6 +311,21 @@ void blk_queue_max_segment_size(struct request_que=
ue *q, unsigned int max_size)=0A=
>>>  }=0A=
>>>  EXPORT_SYMBOL(blk_queue_max_segment_size);=0A=
>>>  =0A=
>>> +=0A=
>>> +/**=0A=
>>> + * blk_check_logical_block_size - check if logical block size is suppo=
rted=0A=
>>> + * by the kernel=0A=
>>> + * @size:  the logical block size, in bytes=0A=
>>> + *=0A=
>>> + * Description:=0A=
>>> + *   This function checks if the block layers supports given block siz=
e=0A=
>>> + **/=0A=
>>> +bool blk_is_valid_logical_block_size(unsigned int size)=0A=
>>> +{=0A=
>>> +	return size >=3D SECTOR_SIZE && size <=3D PAGE_SIZE && !is_power_of_2=
(size);=0A=
> Note here a typo, made in last minute change which I didn't test.=0A=
> It should be without '!'=0A=
=0A=
Oh ! Indeed. I missed that.=0A=
=0A=
> =0A=
> Best regards,=0A=
> 	Maxim Levitsky=0A=
> =0A=
>>> +}=0A=
>>> +EXPORT_SYMBOL(blk_is_valid_logical_block_size);=0A=
>>> +=0A=
>>>  /**=0A=
>>>   * blk_queue_logical_block_size - set logical block size for the queue=
=0A=
>>>   * @q:  the request queue for the device=0A=
>>> @@ -323,6 +338,8 @@ EXPORT_SYMBOL(blk_queue_max_segment_size);=0A=
>>>   **/=0A=
>>>  void blk_queue_logical_block_size(struct request_queue *q, unsigned in=
t size)=0A=
>>>  {=0A=
>>> +	WARN_ON(!blk_is_valid_logical_block_size(size));=0A=
>>> +=0A=
>>>  	q->limits.logical_block_size =3D size;=0A=
>>>  =0A=
>>>  	if (q->limits.physical_block_size < size)=0A=
>>> @@ -330,6 +347,7 @@ void blk_queue_logical_block_size(struct request_qu=
eue *q, unsigned int size)=0A=
>>>  =0A=
>>>  	if (q->limits.io_min < q->limits.physical_block_size)=0A=
>>>  		q->limits.io_min =3D q->limits.physical_block_size;=0A=
>>> +=0A=
>>=0A=
>> white line change.=0A=
>>=0A=
>>>  }=0A=
>>>  EXPORT_SYMBOL(blk_queue_logical_block_size);=0A=
>>>  =0A=
>>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
>>> index 57241417ff2f8..2ed3151397e41 100644=0A=
>>> --- a/include/linux/blkdev.h=0A=
>>> +++ b/include/linux/blkdev.h=0A=
>>> @@ -1099,6 +1099,7 @@ extern void blk_queue_max_write_same_sectors(stru=
ct request_queue *q,=0A=
>>>  		unsigned int max_write_same_sectors);=0A=
>>>  extern void blk_queue_max_write_zeroes_sectors(struct request_queue *q=
,=0A=
>>>  		unsigned int max_write_same_sectors);=0A=
>>> +extern bool blk_is_valid_logical_block_size(unsigned int size);=0A=
>>>  extern void blk_queue_logical_block_size(struct request_queue *, unsig=
ned int);=0A=
>>>  extern void blk_queue_max_zone_append_sectors(struct request_queue *q,=
=0A=
>>>  		unsigned int max_zone_append_sectors);=0A=
>>>=0A=
>>=0A=
>>=0A=
> =0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
