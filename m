Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44CCECA9EBD
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 05:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A23F21D82
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 05:15:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mR3yJh0W";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="k9hqFaxq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392719AbfJYFPP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 01:15:15 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:45545 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729081AbfJYFPP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Oct 2019 01:15:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1571980515; x=1603516515;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=WnGA0HSza/g+orrzy1jAXxajW5w4lAWmBl2hwP1vINI=;
  b=mR3yJh0WzuI1pRPWfjeeFCPni+s+AW4zwgyFmbDcYhD9HY4FQVFkjqJi
   ojuv64vmvIaI4DHdVXb/ZjDmZudN4l+g/cD/A8di3VddnnEF7DEtiKpmU
   LkJF6cEceGnlJW7ncr6F3lDywWxszftE587trRcCzJNb/+cnEPITfWDJu
   F2v5gsSL32gQsODkoh3kGpwEej3dTWyK25NyDYTo67F+XJGgIi2zq71JC
   KWY0nuMQsHD67T+LZwYHewZN3yU/IODPpd70adG/UbOJnrW3xDe4tODji
   KbEl6hQE4g2bqP603z4wRUQMQcauss+k+5qN1Vks0E3AzUTae8v1/rRdh
   w==;
IronPort-SDR: uSIlbJyyq31tpf7gWq1fh5AqLhRVVGKaZMjBCMeKzA0GkzXPr0fbPAQwg4e4CgjvhewbxpeFzS
 OM8BP19rWH7BIQjztjhii9Gi70/QMBfAQ/EM8olFooM8YNto+kCvj923GwpNA8QRGQ4cGxzJHo
 Ed2F2XK7K0bM6HWNSkmZS3I7ek5AhHrFF/rtRwHTHMiE7H/cpcDxWe3Cu8oz000C866RPS+aGl
 Bz/YafmazDe0c2fvT71vs9puUoo4QwwD4/1+/6o+s0wq9tORP+m50Rk3Vx5FTjT27Hbgb0KJLi
 Cq4=
X-IronPort-AV: E=Sophos;i="5.68,227,1569254400"; 
   d="scan'208";a="122084298"
Received: from mail-by2nam01lp2051.outbound.protection.outlook.com (HELO NAM01-BY2-obe.outbound.protection.outlook.com) ([104.47.34.51])
  by ob1.hgst.iphmx.com with ESMTP; 25 Oct 2019 13:15:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LgjvvjI+RgWIEVijOSTRmVbBEV2uaVtrt0qvIExopzNHm0bBCE2XRoVeLNhJxFfznTXFCiT7MLQAyRAV0EYuFgNLwGgRAhH53pZ7lFdB7TUSAHz/sz8K3oLqJprIdyKZGl3qJeLRmqy5+REMQxwg0WJRyj2rv3hSPWFyTigYEZWS6nHsDcR+WabqMKipX873xw+gplZT83y0ugAOa0D712GsxuQIec2SYik646OoBdq5wuK6QOPft+EQw+yrobL0/uI/++unABX7FrT1Xmget9inUlRy4qzjsEU4axTeaVFO2TFZQMa6ne9reGP9RkHe4rkEX5KSNtaSoI0x4a5vMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Djb63i0ZBLdTsPqaKJ4PK3EpT0GQiBsym5k3cahskXY=;
 b=l7WNDwe6pjX7rI1wd1P702Sn4uq8jnj94OneuUSs0/cqL96Pvgkaiisv7iAtuS6A6cL/jQYqcuOGPeJZIJvZ53VY9YlxuzVOCofyMJPQeD8Lw64vjlYOqcHjR74byf4Ezq6HKQS7hnY7dACkKYkjTAJy/lAwAPuDBlfmx/GQbvVBSYiO1/FMlCT0zCGc4zUflkyXy5r0/hd4wcTo9/bTkKYCbrwFWNvO66KXdPNomOiMsMTr9OUTzkgoKue9pEHZ6V4T4SodOE3WuN0vTWMQCFKyp0sAfSSKm9U/kklfb2oG8SgWZBByZN2eatrdxZpmRsRXRr5SYLxx73MrAyIaUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Djb63i0ZBLdTsPqaKJ4PK3EpT0GQiBsym5k3cahskXY=;
 b=k9hqFaxqdAS4VYCqV0PPOkAQpeEfy3sKu8aV/8Vw8r0nnuTAq4jdTFQ4xrw9L8Bi+YPuWmzEV49+yNHv3DeVPUw6tJMrJLZqWe05RXwX1myyNNGjBISq/b9dsrJaBxeqAfw12CmfKsTaQPaRY9Q/bDArLEuwwUOJARtu39ynNf4=
Received: from BN8PR04MB5812.namprd04.prod.outlook.com (20.179.75.75) by
 BN8PR04MB6052.namprd04.prod.outlook.com (20.178.216.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Fri, 25 Oct 2019 05:15:06 +0000
Received: from BN8PR04MB5812.namprd04.prod.outlook.com
 ([fe80::8019:7d47:2cdd:5e4]) by BN8PR04MB5812.namprd04.prod.outlook.com
 ([fe80::8019:7d47:2cdd:5e4%7]) with mapi id 15.20.2387.023; Fri, 25 Oct 2019
 05:15:06 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/4] block: Enhance blk_revalidate_disk_zones()
Thread-Topic: [PATCH 1/4] block: Enhance blk_revalidate_disk_zones()
Thread-Index: AQHVijdM1MlBKY8uekurCnThmLcbow==
Date:   Fri, 25 Oct 2019 05:15:06 +0000
Message-ID: <BN8PR04MB58124835167609CED0AD69FAE7650@BN8PR04MB5812.namprd04.prod.outlook.com>
References: <20191024065006.8684-1-damien.lemoal@wdc.com>
 <20191024065006.8684-2-damien.lemoal@wdc.com>
 <20191024070838.GA19572@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 162ac725-f5c8-43c5-2fa4-08d7590a4c8c
x-ms-traffictypediagnostic: BN8PR04MB6052:
x-microsoft-antispam-prvs: <BN8PR04MB6052A44E45F549DD0F19FCE8E7650@BN8PR04MB6052.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(199004)(189003)(74316002)(7736002)(305945005)(81156014)(14454004)(229853002)(66556008)(9686003)(6436002)(14444005)(66946007)(81166006)(64756008)(8936002)(91956017)(66446008)(6246003)(4326008)(53546011)(7696005)(76176011)(99286004)(102836004)(25786009)(478600001)(6506007)(76116006)(186003)(316002)(26005)(71200400001)(86362001)(446003)(71190400001)(256004)(3846002)(476003)(6116002)(52536014)(5660300002)(55016002)(2906002)(6916009)(66066001)(33656002)(54906003)(66476007)(486006)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR04MB6052;H:BN8PR04MB5812.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dRTat0/fXg807r+FqIIvCo+YaojhYmjTWhSMU60eZ8FM93RxhAkz4vkRy9lz/+OTwH3lwUzD8NvtUoPedLYrWqdMnzpejO8khPRNrnDnHB4HP+2A7VMYDAS6f4s543xQmm2Q2Bqch7hPtHOk7uH1igMTflDjZMyvsTB7twZH4Y+kgpBFCr3G4dOeJn2Jy2ZRJwsQT2O+nUJNNbMZGdKTpdczL+RZUeduFX61mX2xq7iod8IV7Ip8r1OgBhscc13aXGRdcbPxw7vzRZ+t77tUC2ZnpRIO8joD3xEe+OUSSS9zEfPKf0TUSycnq+ebDLDKsd1/6joFiwQXDb0xEDv+Ed8IzxVOP+MkB2yxprRFD0IvmwlOOQnrVwhPuXrJEsUEW9kFY+wQr13mRzUGPsMmzfbjSsn3Q9GGzbbVgbchllwVmNnCELN+x9GBKGHXtv2P
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 162ac725-f5c8-43c5-2fa4-08d7590a4c8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 05:15:06.3126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rAbDL/jDSKYwKQMFa2dTZNi18tx7lTPDABj6KUuyMJm8GE5xJqdGF8TCF0TONfEHhZ3FM2NHJ7gl/QhAWQ6xgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB6052
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/10/24 16:08, Christoph Hellwig wrote:=0A=
>> diff --git a/block/blk-zoned.c b/block/blk-zoned.c=0A=
>> index 4bc5f260248a..293891b7068a 100644=0A=
>> --- a/block/blk-zoned.c=0A=
>> +++ b/block/blk-zoned.c=0A=
>> @@ -441,6 +441,57 @@ void blk_queue_free_zone_bitmaps(struct request_que=
ue *q)=0A=
>>  	q->seq_zones_wlock =3D NULL;=0A=
>>  }=0A=
>>  =0A=
>> +/**=0A=
>> + * blk_check_zone - Check a zone information=0A=
>> + * @q:		request queue=0A=
>> + * @zone:	the zone to  check=0A=
>> + * @sector:	start sector of the zone=0A=
>> + *=0A=
>> + * Helper function to check zones of a zoned block device. Returns true=
 if the=0A=
>> + * zone is correct and false if a problem is detected.=0A=
>> + */=0A=
>> +static bool blk_check_zone(struct gendisk *disk, struct blk_zone *zone,=
=0A=
>> +			   sector_t *sector)=0A=
> =0A=
> Maybe call this blk_zone_valid?  Also in many places we don't really=0A=
> do the verbose kerneldoc comments with the duplicated parameter names=0A=
> for local functions, as the scripts only pick up non-stack ones anyway.=
=0A=
> =0A=
>> +	/*=0A=
>> +	 * All zones must have the same size, with the exception on an eventua=
l=0A=
>> +	 * smaller last zone.=0A=
>> +	 */=0A=
>> +	if (zone->start + zone_sectors < capacity &&=0A=
>> +	    zone->len !=3D zone_sectors) {=0A=
>> +		pr_warn("%s: Invalid zone device with non constant zone size\n",=0A=
>> +			disk->disk_name);=0A=
>> +		return false;=0A=
>> +	}=0A=
> =0A=
> I think we should also move the power of two zone size check here=0A=
> instead of leaving it in the driver.=0A=
=0A=
We should not since the drivers calls blk_queue_chunk_sectors() first to=0A=
set the zone size and that function has a power of 2 check. So better=0A=
check that earlier than here.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
