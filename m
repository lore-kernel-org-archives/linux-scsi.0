Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2078AC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 02:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E89032078B
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 02:17:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="imH8p2rG";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="r7oBKRXC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgF3CRd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 22:17:33 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:46472 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgF3CRc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 22:17:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593483452; x=1625019452;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=qQy6BsmzxHpiBSC3/+rlBRsH2Bbm74Pxi3v73AJacKY=;
  b=imH8p2rGJs2vXh5MizNUovNWlRqOE/5XcTtH6fi1cx5nT8VeEjvU4BBb
   lx50dGiTECp3rDKQECLGWCf9QaAOdWGBfzLgbzd8qjkq3UKaz9g7TEweN
   XwaAz1Pzh8vngNML88eTd8gMD7q+J8071/MJHgdjIdT5qg+dgmChlIzUd
   zNcmi/YTyq/ctGobrepUg+BFyxoYAGAQVz4HcYJ0vvomzpxI89sR2Yvdh
   h3cUe1J76W0c3vIZj/nV2SB0JHpGnyr0f86mvDoAglR9GOYcLxV9ZpNoj
   8QSxXdOjpXcsSgilgK3W7guLHJaqTSMJVd54NJaN68I5Jq5dqwrs8RMat
   g==;
IronPort-SDR: Bekc53BuuaZoqiza1RWAOxY9AwyE3F9eXCXVLr/rINe18GrGNyBNqt3argWlYmFspFQmK6W/q1
 x/3FmiDDY4V/J4vGJOD84CqZAJqxAOW6Fs1zs+iogp2If9KLWIaU108nG3kESeNTCOQ7T65Jil
 E7cy8XBjVnXXli4haII3FwK9CLhv9tQenyOT82QAITNMkYlsNdXrn5PA+A6sfewR6Nx4EC7xr6
 +bqj4T1sDj0gfmgbLjzbHjFdL2nahVQ8UxlU905hxGGD4qOZ5Gxhl/ljlizI/hkEJ6rlRYka/x
 /64=
X-IronPort-AV: E=Sophos;i="5.75,296,1589212800"; 
   d="scan'208";a="145556204"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jun 2020 10:17:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DdvrpgEZgUbVeK5ajVGraEOGcwnvrSgkCiX+KlggIAbXSNxJgqJmMIiU7is92Amo189ls+S3Ay2HET1si7UG7Wc1bmzEf81uOJ5s40rpwxn6xNiTvwTayRRys/AaIHuWMw9J6Ll+Z0q00egxpU2Yq7Ox22QreOj0bCZpo0OsG6BbfmvviwOrAji4amc++0P2tg9vGjCj/4qebL+nbjLTbFBRHY0z7cuPBYmFzOgbqGuOXiIgXT4kW5S0xa+JBIb9PCF6YPbdhh+MU/R7c7EJPYf84h0esvphu04AF6FrVxbURSxMRSHCJBDLUYVLCagIr/9WneZEKfvlz1qm15fpjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HPf5TterA0xKCq7OFJvncAJZ1pt/7XqBpDd/5TdKgIM=;
 b=F9KIGt+brbtrlAIAg5z3SGfMCN0tb+9QCZVxYhq6IILQsu59hxH3gUUnPLq3EcAMrBDYzZ7iRt4CG2Qgg6WkvvUj4f+BRCsh4BXNlSi8l7Ul0bsCKNgnHqRobIQbz4cZW0OY0LEsXS5Huis0S5jGvMQebSxHQ+XLc9F70ue5P6qFZiH9svLBFTRX3K2Vv09w5Eyd1E+oZLqpMv64uErKw/QEibo2JMwfVGdhyCTPvjr3R845Ms3GwORswu3Ld3G0FWHCKKOlJgxOtUcOm0b3QyvyziNaJI8WrThJKxf47MDZxr4wtwJcnWGo12E957QWdJbbehqULJK8cActMlV34Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HPf5TterA0xKCq7OFJvncAJZ1pt/7XqBpDd/5TdKgIM=;
 b=r7oBKRXC/SziRhuke+V4t7hJUhBaVFYQgcMTsWdglUBy5xBiscRz/oeiAgdMAzl49Mfd1fbNNx+OptHu3lAc0MTw1Xh1+sOZ3gcYSqtvrtkfa44x73w95d0kMqHFVQ549jS8VakuKdOM0G7/w4tYlqKBkaB1hKXnds0vchnTyEw=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1032.namprd04.prod.outlook.com (2603:10b6:910:50::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Tue, 30 Jun
 2020 02:17:28 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3131.024; Tue, 30 Jun 2020
 02:17:28 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/2] block: add max_open_zones to blk-sysfs
Thread-Topic: [PATCH 1/2] block: add max_open_zones to blk-sysfs
Thread-Index: AQHWQ8jtlLWiiEumE0+QMSt8tXUnYw==
Date:   Tue, 30 Jun 2020 02:17:28 +0000
Message-ID: <CY4PR04MB375135B0E421C421EBAD3C06E76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200616102546.491961-1-niklas.cassel@wdc.com>
 <20200616102546.491961-2-niklas.cassel@wdc.com>
 <CY4PR04MB3751C2C03ACCA263541DA348E76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.47.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 32c6fa78-8a8c-4ecf-86eb-08d81c9bbccb
x-ms-traffictypediagnostic: CY4PR04MB1032:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB10328CB3778F25695BED2BBAE76F0@CY4PR04MB1032.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: //u+AGoqWn4r/0txNg2HiPZ9P+U6YV8tZUJdPMTO7sKGnReVO7gY9CVhYef70FmcxrhlBxbgGxNkApGmH1pRrZTG2c7IVuw3l2SYFKI4xVGsvCXM4VtZDi4RAa6aVbawdqN4+1IOqF/TnCAkN3r/ChGnjDC9WO0dmMxodCXaTmzjLR+71TG/N23e8CkTREvF2SLONEsZ0TMJ0mJh6+ctYg5ULHlG5aLsdi0Qlc/BJU65sAyYgjYTvfpwH+KhBzKBEc4lYnaj/iyiTnAOVVUBPGEHNsBYdS+wA3NCFZsZirgaOVLYn12OL3FOA9GY4fUJbHiUpJSvoDXPbELVoeoiCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(4326008)(2906002)(8676002)(54906003)(71200400001)(110136005)(316002)(8936002)(5660300002)(478600001)(83380400001)(7416002)(186003)(6506007)(53546011)(33656002)(9686003)(52536014)(26005)(7696005)(76116006)(66446008)(64756008)(66556008)(66476007)(91956017)(55016002)(66946007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: KQsI6L3FEarlL39CaJf2VCp0dvdyIU8LCg0a0IcPhOyePwGOQZMP0EuoxmKVjUGOiaziJ1mkh5D3XJx0u+hhsW4/+wkV9uw4A0d8QE3fbYbhvd0UBj82KWgYsfKPX2ygr5WNWeDQ2HYXDD1H9bZJNrh9fCBOrZIhwf3VESr6Jue3kjOJnmOK0IbuOXUOfp6pcAzKSbO20jVts81fJqpGbEw8eW39WI2U7DAogz4Ss5STDGwDkEEyESr93PtZDzSy90oBgw5g3jP4Dirz7N+tTtqpcdBbThqcOAjeO2opTLx3LYeTVh2SjxQZPZiorbxM2hSXoSG+fxPIPl+F3foJPhhhNFx64YpEGiC5TllOSh5YvTAsN+ewbmJEglyec25VouM2mc6T+hKET2lbJR0A5DbR6KJyB7Vbwi06rgSwD+hvCEursgcLFhnlUeU31CWyTDUSN8TQ15PL6VS/8qpIY6VVYK6kZPGn5yGqm8w+Tec=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32c6fa78-8a8c-4ecf-86eb-08d81c9bbccb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 02:17:28.5468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: suJGY+u8SS0pZ6HoW2lowzZ3nmlfdhhdavNt1p494bqnXcY8R+ZdG3inrmDeN88togLT4vJOkPUE6Pnx3xtbjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1032
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/06/30 10:49, Damien Le Moal wrote:=0A=
> On 2020/06/16 19:28, Niklas Cassel wrote:=0A=
>> Add a new max_open_zones definition in the sysfs documentation.=0A=
>> This definition will be common for all devices utilizing the zoned block=
=0A=
>> device support in the kernel.=0A=
>>=0A=
>> Export max open zones according to this new definition for NVMe Zoned=0A=
>> Namespace devices, ZAC ATA devices (which are treated as SCSI devices by=
=0A=
>> the kernel), and ZBC SCSI devices.=0A=
>>=0A=
>> Add the new max_open_zones struct member to the request_queue, rather=0A=
> =0A=
> Add the new max_open_zones member to struct request_queue...=0A=
> =0A=
>> than as a queue limit, since this property cannot be split across stacki=
ng=0A=
>> drivers.=0A=
> =0A=
> But device-mapper target device have a request queue too and it looks lik=
e your=0A=
> patch is not setting any value, using the default 0 for dm-linear and dm-=
flakey.=0A=
> Attaching the new attribute directly to the request queue rather than add=
ing it=0A=
> as part of the queue limits seems odd. Even if DM case is left unsupporte=
d=0A=
> (using the default 0 =3D no limit), it may be cleaner to add the field as=
 part of=0A=
> the limit struct.=0A=
> =0A=
> Adding the field as a device attribute rather than a queue limit, similar=
ly to=0A=
> the device maximum queue depth would be another option. In such case, inc=
luding=0A=
> the field directly as part of the request queue makes more sense.=0A=
=0A=
Thinking more about this one, struct request_queue has nr_zones field, whic=
h is=0A=
not a queue limit but still exported as a queue attribute. Device mapper=0A=
exposing a zoned drive target do set this field manually. So I guess the sa=
me=0A=
approach is valid for max_open_zones (and max_active_zones). So OK, disrega=
rd=0A=
this comment.=0A=
=0A=
The other comments I sent below remain though.=0A=
=0A=
> =0A=
>>=0A=
>> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
>> ---=0A=
>>  Documentation/block/queue-sysfs.rst |  7 +++++++=0A=
>>  block/blk-sysfs.c                   | 15 +++++++++++++++=0A=
>>  drivers/nvme/host/zns.c             |  1 +=0A=
>>  drivers/scsi/sd_zbc.c               |  4 ++++=0A=
>>  include/linux/blkdev.h              | 20 ++++++++++++++++++++=0A=
>>  5 files changed, 47 insertions(+)=0A=
>>=0A=
>> diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/q=
ueue-sysfs.rst=0A=
>> index 6a8513af9201..f01cf8530ae4 100644=0A=
>> --- a/Documentation/block/queue-sysfs.rst=0A=
>> +++ b/Documentation/block/queue-sysfs.rst=0A=
>> @@ -117,6 +117,13 @@ Maximum number of elements in a DMA scatter/gather =
list with integrity=0A=
>>  data that will be submitted by the block layer core to the associated=
=0A=
>>  block driver.=0A=
>>  =0A=
>> +max_open_zones (RO)=0A=
>> +-------------------=0A=
>> +For zoned block devices (zoned attribute indicating "host-managed" or=
=0A=
>> +"host-aware"), the sum of zones belonging to any of the zone states:=0A=
>> +EXPLICIT OPEN or IMPLICIT OPEN, is limited by this value.=0A=
>> +If this value is 0, there is no limit.=0A=
>> +=0A=
>>  max_sectors_kb (RW)=0A=
>>  -------------------=0A=
>>  This is the maximum number of kilobytes that the block layer will allow=
=0A=
>> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c=0A=
>> index 02643e149d5e..fa42961e9678 100644=0A=
>> --- a/block/blk-sysfs.c=0A=
>> +++ b/block/blk-sysfs.c=0A=
>> @@ -305,6 +305,11 @@ static ssize_t queue_nr_zones_show(struct request_q=
ueue *q, char *page)=0A=
>>  	return queue_var_show(blk_queue_nr_zones(q), page);=0A=
>>  }=0A=
>>  =0A=
>> +static ssize_t queue_max_open_zones_show(struct request_queue *q, char =
*page)=0A=
>> +{=0A=
>> +	return queue_var_show(queue_max_open_zones(q), page);=0A=
>> +}=0A=
>> +=0A=
>>  static ssize_t queue_nomerges_show(struct request_queue *q, char *page)=
=0A=
>>  {=0A=
>>  	return queue_var_show((blk_queue_nomerges(q) << 1) |=0A=
>> @@ -667,6 +672,11 @@ static struct queue_sysfs_entry queue_nr_zones_entr=
y =3D {=0A=
>>  	.show =3D queue_nr_zones_show,=0A=
>>  };=0A=
>>  =0A=
>> +static struct queue_sysfs_entry queue_max_open_zones_entry =3D {=0A=
>> +	.attr =3D {.name =3D "max_open_zones", .mode =3D 0444 },=0A=
>> +	.show =3D queue_max_open_zones_show,=0A=
>> +};=0A=
>> +=0A=
>>  static struct queue_sysfs_entry queue_nomerges_entry =3D {=0A=
>>  	.attr =3D {.name =3D "nomerges", .mode =3D 0644 },=0A=
>>  	.show =3D queue_nomerges_show,=0A=
>> @@ -765,6 +775,7 @@ static struct attribute *queue_attrs[] =3D {=0A=
>>  	&queue_nonrot_entry.attr,=0A=
>>  	&queue_zoned_entry.attr,=0A=
>>  	&queue_nr_zones_entry.attr,=0A=
>> +	&queue_max_open_zones_entry.attr,=0A=
>>  	&queue_nomerges_entry.attr,=0A=
>>  	&queue_rq_affinity_entry.attr,=0A=
>>  	&queue_iostats_entry.attr,=0A=
>> @@ -792,6 +803,10 @@ static umode_t queue_attr_visible(struct kobject *k=
obj, struct attribute *attr,=0A=
>>  		(!q->mq_ops || !q->mq_ops->timeout))=0A=
>>  			return 0;=0A=
>>  =0A=
>> +	if (attr =3D=3D &queue_max_open_zones_entry.attr &&=0A=
>> +	    !blk_queue_is_zoned(q))=0A=
>> +		return 0;=0A=
>> +=0A=
>>  	return attr->mode;=0A=
>>  }=0A=
>>  =0A=
>> diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c=0A=
>> index c08f6281b614..af156529f3b6 100644=0A=
>> --- a/drivers/nvme/host/zns.c=0A=
>> +++ b/drivers/nvme/host/zns.c=0A=
>> @@ -82,6 +82,7 @@ int nvme_update_zone_info(struct gendisk *disk, struct=
 nvme_ns *ns,=0A=
>>  =0A=
>>  	q->limits.zoned =3D BLK_ZONED_HM;=0A=
>>  	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);=0A=
>> +	blk_queue_max_open_zones(q, le32_to_cpu(id->mor) + 1);=0A=
>>  free_data:=0A=
>>  	kfree(id);=0A=
>>  	return status;=0A=
>> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c=0A=
>> index 183a20720da9..aa3564139b40 100644=0A=
>> --- a/drivers/scsi/sd_zbc.c=0A=
>> +++ b/drivers/scsi/sd_zbc.c=0A=
>> @@ -717,6 +717,10 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsig=
ned char *buf)=0A=
>>  	/* The drive satisfies the kernel restrictions: set it up */=0A=
>>  	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);=0A=
>>  	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);=0A=
>> +	if (sdkp->zones_max_open =3D=3D U32_MAX)=0A=
>> +		blk_queue_max_open_zones(q, 0);=0A=
>> +	else=0A=
>> +		blk_queue_max_open_zones(q, sdkp->zones_max_open);=0A=
> =0A=
> This is correct only for host-managed drives. Host-aware models define th=
e=0A=
> "OPTIMAL NUMBER OF OPEN SEQUENTIAL WRITE PREFERRED ZONES" instead of a ma=
ximum=0A=
> number of open sequential write required zones.=0A=
> =0A=
> Since the standard does not actually explicitly define what the value of =
the=0A=
> maximum number of open sequential write required zones should be for a=0A=
> host-aware drive, I would suggest to always have the max_open_zones value=
 set to=0A=
> 0 for host-aware disks.=0A=
> =0A=
>>  	nr_zones =3D round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_block=
s);=0A=
>>  =0A=
>>  	/* READ16/WRITE16 is mandatory for ZBC disks */=0A=
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
>> index 8fd900998b4e..2f332f00501d 100644=0A=
>> --- a/include/linux/blkdev.h=0A=
>> +++ b/include/linux/blkdev.h=0A=
>> @@ -520,6 +520,7 @@ struct request_queue {=0A=
>>  	unsigned int		nr_zones;=0A=
>>  	unsigned long		*conv_zones_bitmap;=0A=
>>  	unsigned long		*seq_zones_wlock;=0A=
>> +	unsigned int		max_open_zones;=0A=
>>  #endif /* CONFIG_BLK_DEV_ZONED */=0A=
>>  =0A=
>>  	/*=0A=
>> @@ -729,6 +730,17 @@ static inline bool blk_queue_zone_is_seq(struct req=
uest_queue *q,=0A=
>>  		return true;=0A=
>>  	return !test_bit(blk_queue_zone_no(q, sector), q->conv_zones_bitmap);=
=0A=
>>  }=0A=
>> +=0A=
>> +static inline void blk_queue_max_open_zones(struct request_queue *q,=0A=
>> +		unsigned int max_open_zones)=0A=
>> +{=0A=
>> +	q->max_open_zones =3D max_open_zones;=0A=
>> +}=0A=
>> +=0A=
>> +static inline unsigned int queue_max_open_zones(const struct request_qu=
eue *q)=0A=
>> +{=0A=
>> +	return q->max_open_zones;=0A=
>> +}=0A=
>>  #else /* CONFIG_BLK_DEV_ZONED */=0A=
>>  static inline unsigned int blk_queue_nr_zones(struct request_queue *q)=
=0A=
>>  {=0A=
>> @@ -744,6 +756,14 @@ static inline unsigned int blk_queue_zone_no(struct=
 request_queue *q,=0A=
>>  {=0A=
>>  	return 0;=0A=
>>  }=0A=
>> +static inline void blk_queue_max_open_zones(struct request_queue *q,=0A=
>> +		unsigned int max_open_zones)=0A=
>> +{=0A=
>> +}=0A=
> =0A=
> Why is this one necessary ? For the !CONFIG_BLK_DEV_ZONED case, no driver=
 should=0A=
> ever call this function.=0A=
> =0A=
>> +static inline unsigned int queue_max_open_zones(const struct request_qu=
eue *q)=0A=
>> +{=0A=
>> +	return 0;=0A=
>> +}=0A=
>>  #endif /* CONFIG_BLK_DEV_ZONED */=0A=
>>  =0A=
>>  static inline bool rq_is_sync(struct request *rq)=0A=
>>=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
