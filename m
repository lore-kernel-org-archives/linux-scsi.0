Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A719BC55186
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 01:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FA292074F
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 01:33:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="g7WzROQr";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="BM3OMxNE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgDWBdo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 21:33:44 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:51116 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgDWBdn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 21:33:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587605622; x=1619141622;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=rGZ7sQeFXwzBnJXGYT1+Xq0s3wC8m062o7nJGx2PIdY=;
  b=g7WzROQrHEWuALP73SqM393iyo5NwZK016VNxOqQ25PEYluAwf33r8FJ
   Kup86nt6pcePLUMCCTW7NWuf/61vf6GJYiIxKD343fixRrsnloG6UrKAP
   Dws9rWc8ODsQuIISRuwPR3apj9qI3bR5KuXxSyKK+x6xHOs2VuTcVc20A
   LWnlnhCnngwgE2Y1UaLUXw1NybZ0i1nta1Q7rboz5b2loAGjQci62QmIx
   tYFjf8KpxJ/ktVyQlirh8+7YH6Li0b2qsy5oovyE34L31eytT0YaUkNKL
   5q7w69Wt9bWDyFSojTv0uVJX/52P+vAZ7NNivnDOf6BzkQdWFor33wy5y
   Q==;
IronPort-SDR: 6og1MBPX6NYhebultZP4TQibzdIb1r/8PI1hWPjmME1KobTyfdyMYEE0bOrh9hZuGrSWEwCu08
 z19pV3UU+D0EqbhKpshFb6F8XJ5N2mYPO7Ybm34B2UBWHunnxmnkv7U23iP2BJ5PWhjods+d38
 VRgHB17CW6I8tpU9j8VzHHtr/egcVAN+croo3I7JDsvpu3UiYDcBh/QN99y3hMYouNj6/t6l2R
 cpE/fA3LhNsh0QWJcn8TLsh9/mswcDkjJWFAJWoQ8r9qIVuRywkrt+795dDGl7hLkPjpJK13Lm
 jXY=
X-IronPort-AV: E=Sophos;i="5.73,305,1583164800"; 
   d="scan'208";a="136239469"
Received: from mail-sn1nam04lp2054.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.54])
  by ob1.hgst.iphmx.com with ESMTP; 23 Apr 2020 09:33:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkZfk9uu9UwXhG2Lcus4ytMtE8BaqaGW5r1NJU23BIZLGQIDgajBjUZxtQFeYo4ZEhUcbDgutGt+OdnrE/uD/Z6m9A1Vu/HoHqzVQtLmZj7VcBV5OWPemA/n4PFrR9xIebCLDUJ2JPG/X2WWjv7B/veJ2nGORKNVIncjtR6kj6VVd8v16VvYhOLzIqPVUVOWco+JgYqbHTrI4YC3v+soLq+gLy20co6VNyECDNwlZUaguuIMZ5SF7gZGPamhCGaoWSY7FbE3vbPfQSVFFQh5adAFytEqCR8K2MLxZcXOxTIhPD3VPZYWa6d9utNpV7qBC+fJE21O2scA5NQ9j04Znw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4aNYSTw44j8GMy7HgEvMonUJA+EQyf26RlN/1hmB5Y=;
 b=CMJwamOE6KF4bLJJOI363InkHVCxHzxyrzSBOoAv0G1/R7aOrVCr6dMhLw5/J0l0tPo587dYP/pdSVRrF6ab9oqbMRbS2uzyDg5KV4caVnBaKZNFmChYKbuQrx0kUw98c48EtN9u2K2X+t+AwCOj+UP7FORWYLLK/CKq0TTEonTyKU44n10G5tiHMgpkSgWUBM1BlN4yHSkFmP+sleVuo/mvTwy0FQ0VAwSBwZI4E5V4XzyjOzMZFtGeTZhvBC4nQ1A8iu4MU0pZdsXVXJlrzmPAp8BXyfyZ11MdrLQtDjjSm14OjQE+IXGUqT+KiP3b90LaGbt4acYyOpJhIwCchA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4aNYSTw44j8GMy7HgEvMonUJA+EQyf26RlN/1hmB5Y=;
 b=BM3OMxNEvHZuZ3geKUAOxT0wmkALV6cvuOp9dOm6gMLip6eFqZJFv7wAVjv/wjTs8MW6j6oxdW2G2gRoGb6Fe3+IN+Hl26oXJh0t8H/ZBSHF+4dBDgW7BcfQYi+/1k0rH8Ee18VQIvwGfhVob8/+xclqT0uSwA6YbJBi7J985aA=
Received: from BY5PR04MB6900.namprd04.prod.outlook.com (2603:10b6:a03:229::20)
 by BY5PR04MB7041.namprd04.prod.outlook.com (2603:10b6:a03:222::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Thu, 23 Apr
 2020 01:33:40 +0000
Received: from BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606]) by BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606%8]) with mapi id 15.20.2937.012; Thu, 23 Apr 2020
 01:33:40 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "dgilbert@interlog.com" <dgilbert@interlog.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/7] scsi_debug: implement zbc host-aware emulation
Thread-Topic: [PATCH 7/7] scsi_debug: implement zbc host-aware emulation
Thread-Index: AQHWGJLWEm+QrqHvHU6XXBhTM+QDpg==
Date:   Thu, 23 Apr 2020 01:33:40 +0000
Message-ID: <BY5PR04MB6900D8D32C2FA1159B4E0968E7D30@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200422104221.378203-1-damien.lemoal@wdc.com>
 <20200422104221.378203-8-damien.lemoal@wdc.com>
 <7a673425-195a-bd5f-bcf9-66e2c6cdb3fc@interlog.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: faa46313-bc51-479e-46a4-08d7e7265a25
x-ms-traffictypediagnostic: BY5PR04MB7041:
x-microsoft-antispam-prvs: <BY5PR04MB7041BC467FF5AB590920C7AEE7D30@BY5PR04MB7041.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03827AF76E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6900.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(26005)(53546011)(6506007)(478600001)(7696005)(9686003)(81156014)(33656002)(8676002)(55016002)(2906002)(316002)(110136005)(186003)(45080400002)(4326008)(8936002)(30864003)(5660300002)(52536014)(66556008)(76116006)(66476007)(71200400001)(66946007)(64756008)(66446008)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qqq4lEZEG6IxIRB2hC9J7SSvuW2Jgi5DWiF07NIZfwjQpoaJsKq33gZok0XmDcs9uytlvk1ANXNTubsApPfpmsYVZhKY+SAtxw4Y4JgpTSwsOTsyYuJGbkUdIszzie4DIh7blFAEOJUKvYWFAzLfk/SuUz4kkbxuxLk7Jty9e6FrkcYaE2WLhH5FDZwHFfPHmIRyj7AOpbOpfLbBNbsJ0cstj9DV8NKxlPI2YMBL0Ym2TmlHLeLJbBtpvmPl0ddnx6MmkIPETzheQKEUiIWUzv+yDLRoFtcea+pQJKwmpOUpECUlvImy6FniYd0zGJe73OKparqokDulrO9DYUaCy7/L2QxMiwjqesTXgRQHwCx4tcIbMZrQRPOoOjfCMjjS8GiyBWuk24s696Oy+N0DY2JgjIXjm2qgN4ExiAwdODgZuyquhxIcnPPSV5rZVVQi
x-ms-exchange-antispam-messagedata: L1hZQTjFXBYgmdxvKAzaBv5E6ESysMU5T841/bbVoDmRkcz8OBTWwXMBtaBaFgzf/R4kcH9K424wfQoa8H10/jyfx/O2Mu1ciX4KPJyoIm99Cs0EvnMJhlgcq1X2bdk4x7SWygKKyu6WZcR1mjnezw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faa46313-bc51-479e-46a4-08d7e7265a25
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2020 01:33:40.1926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3jPfmDqk3K6l/CDqnuvWs27aYg+Kg6yeZsmIF6sK6x7cz2irGITqm+O7ufP3sb4LERjdCjsN0xGtiLU0VLuduQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7041
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/04/23 1:46, Douglas Gilbert wrote:=0A=
> On 2020-04-22 6:42 a.m., Damien Le Moal wrote:=0A=
>> Implement ZBC host-aware device model emulation. The main changes from=
=0A=
>> the host-managed emulation are the device type (TYPE_DISK is used),=0A=
>> relaxation of access checks for read and write operations and different=
=0A=
>> handling of a sequential write preferred zone write pointer as mandated=
=0A=
>> by the ZBC r05 specifications.=0A=
>>=0A=
>> To facilitate the implementation and avoid a lot of "if" statement, the=
=0A=
>> zmodel field is added to the device information and the z_type field to=
=0A=
>> the zone state data structure.=0A=
>>=0A=
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> =0A=
> This is an unexpected surprise and a chance to exercise previously untest=
ed=0A=
> parts of my user space packages (sg3_utils and sdparm).=0A=
=0A=
Yes, I decided yesterday to add this on top of the series we worked on toge=
ther.=0A=
The main reason iss to allow for writing blktests to test partition handlin=
g=0A=
with host-aware drives as some special handling was added for these recentl=
y. If=0A=
an HA drive has partition, its zoned model is automatically changed to "NON=
E"=0A=
and restored to "host-aware" only when the partitions are deleted. Having=
=0A=
blktests cases to do regression testing on that iss I think important as th=
is is=0A=
an unusal behavior. And you already had added the host-aware paramter cases=
 so=0A=
everything was mostly already wired for this emulation case.=0A=
=0A=
> A small nit: draft ZBC-2 has added the Zoned Block Device Extension field=
=0A=
> which should be set to 1 for host-aware (and 0 for host-managed). It is 0=
=0A=
> in both cases at the moment which is strictly speaking correct as 0 is=0A=
> defined as "not reported". IMO it is more correct to set it to 1 in the=
=0A=
> host-aware case :-)=0A=
> =0A=
> Ralph Weber failed in his attempt to get version strings thrown out at T1=
0.=0A=
> So we might consider adding a ZBC version descriptor in the host-aware an=
d=0A=
> host-managed case. [Version descriptors are in the standard INQUIRY=0A=
> response.]=0A=
=0A=
ZBC-2 is still in draft state. We should not yet implement against it. Last=
 I=0A=
checked with Ralph, the outlook for a stable spec is year end. I am monitor=
ing=0A=
that since yhere are a lot more changes that will need to be taken care of =
on=0A=
the kernel side. ZBC-2 (and ZAC-2) extend reset/open/close/finish operation=
s to=0A=
operate on a range of zones. At the very least, we will need that support i=
n the=0A=
kernel SAT (drivers/ata/libata-scsi.c).=0A=
=0A=
> =0A=
> Wish list: it would be good if lsscsi could indicate in its one line per=
=0A=
> device mode that a disk was actually a ZBC host-aware disk. lsscsi is=0A=
> restricted to datamining in sysfs and some other locations that don't=0A=
> need root permissions. So it does not issue any SCSI commands. To see a=
=0A=
> disk is ZBC host-aware it needs access to the Block Device Characteristic=
s=0A=
> VPD page, but as far as I can see that is not loaded into sysfs at this=
=0A=
> time. Hannes?=0A=
> =0A=
> Tested-by: Douglas Gilbert <dgilbert@interlog.com>=0A=
> =0A=
>> ---=0A=
>>   drivers/scsi/scsi_debug.c | 148 ++++++++++++++++++++++++++------------=
=0A=
>>   1 file changed, 103 insertions(+), 45 deletions(-)=0A=
>>=0A=
>> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c=0A=
>> index 9279ac9bb98d..46cd4e64bb9c 100644=0A=
>> --- a/drivers/scsi/scsi_debug.c=0A=
>> +++ b/drivers/scsi/scsi_debug.c=0A=
>> @@ -262,6 +262,13 @@ static const char *sdebug_version_date =3D "2020042=
1";=0A=
>>   =0A=
>>   #define SDEB_XA_NOT_IN_USE XA_MARK_1=0A=
>>   =0A=
>> +/* Zone types (zbcr05 table 25) */=0A=
>> +enum sdebug_z_type {=0A=
>> +	ZBC_ZONE_TYPE_CNV	=3D 0x1,=0A=
>> +	ZBC_ZONE_TYPE_SWR	=3D 0x2,=0A=
>> +	ZBC_ZONE_TYPE_SWP	=3D 0x3,=0A=
>> +};=0A=
>> +=0A=
>>   /* enumeration names taken from table 26, zbcr05 */=0A=
>>   enum sdebug_z_cond {=0A=
>>   	ZBC_NOT_WRITE_POINTER	=3D 0x0,=0A=
>> @@ -275,7 +282,9 @@ enum sdebug_z_cond {=0A=
>>   };=0A=
>>   =0A=
>>   struct sdeb_zone_state {	/* ZBC: per zone state */=0A=
>> +	enum sdebug_z_type z_type;=0A=
>>   	enum sdebug_z_cond z_cond;=0A=
>> +	bool z_non_seq_resource;=0A=
>>   	unsigned int z_size;=0A=
>>   	sector_t z_start;=0A=
>>   	sector_t z_wp;=0A=
>> @@ -294,6 +303,7 @@ struct sdebug_dev_info {=0A=
>>   	bool used;=0A=
>>   =0A=
>>   	/* For ZBC devices */=0A=
>> +	enum blk_zoned_model zmodel;=0A=
>>   	unsigned int zsize;=0A=
>>   	unsigned int zsize_shift;=0A=
>>   	unsigned int nr_zones;=0A=
>> @@ -822,7 +832,7 @@ static int dix_reads;=0A=
>>   static int dif_errors;=0A=
>>   =0A=
>>   /* ZBC global data */=0A=
>> -static bool sdeb_zbc_in_use;		/* true when ptype=3DTYPE_ZBC [0x14] */=
=0A=
>> +static bool sdeb_zbc_in_use;	/* true for host-aware and host-managed di=
sks */=0A=
>>   static int sdeb_zbc_zone_size_mb;=0A=
>>   static int sdeb_zbc_max_open =3D DEF_ZBC_MAX_OPEN_ZONES;=0A=
>>   static int sdeb_zbc_nr_conv =3D DEF_ZBC_NR_CONV_ZONES;=0A=
>> @@ -1500,13 +1510,15 @@ static int inquiry_vpd_b0(unsigned char *arr)=0A=
>>   }=0A=
>>   =0A=
>>   /* Block device characteristics VPD page (SBC-3) */=0A=
>> -static int inquiry_vpd_b1(unsigned char *arr)=0A=
>> +static int inquiry_vpd_b1(struct sdebug_dev_info *devip, unsigned char =
*arr)=0A=
>>   {=0A=
>>   	memset(arr, 0, 0x3c);=0A=
>>   	arr[0] =3D 0;=0A=
>>   	arr[1] =3D 1;	/* non rotating medium (e.g. solid state) */=0A=
>>   	arr[2] =3D 0;=0A=
>>   	arr[3] =3D 5;	/* less than 1.8" */=0A=
>> +	if (devip->zmodel =3D=3D BLK_ZONED_HA)=0A=
>> +		arr[4] =3D 1 << 4;	/* zoned field =3D 01b */=0A=
>>   =0A=
>>   	return 0x3c;=0A=
>>   }=0A=
>> @@ -1543,7 +1555,7 @@ static int inquiry_vpd_b6(struct sdebug_dev_info *=
devip, unsigned char *arr)=0A=
>>   	 */=0A=
>>   	put_unaligned_be32(0xffffffff, &arr[4]);=0A=
>>   	put_unaligned_be32(0xffffffff, &arr[8]);=0A=
>> -	if (devip->max_open)=0A=
>> +	if (sdeb_zbc_model =3D=3D BLK_ZONED_HM && devip->max_open)=0A=
>>   		put_unaligned_be32(devip->max_open, &arr[12]);=0A=
>>   	else=0A=
>>   		put_unaligned_be32(0xffffffff, &arr[12]);=0A=
>> @@ -1566,7 +1578,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, str=
uct sdebug_dev_info *devip)=0A=
>>   	if (! arr)=0A=
>>   		return DID_REQUEUE << 16;=0A=
>>   	is_disk =3D (sdebug_ptype =3D=3D TYPE_DISK);=0A=
>> -	is_zbc =3D (sdebug_ptype =3D=3D TYPE_ZBC);=0A=
>> +	is_zbc =3D (devip->zmodel !=3D BLK_ZONED_NONE);=0A=
>>   	is_disk_zbc =3D (is_disk || is_zbc);=0A=
>>   	have_wlun =3D scsi_is_wlun(scp->device->lun);=0A=
>>   	if (have_wlun)=0A=
>> @@ -1611,7 +1623,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, str=
uct sdebug_dev_info *devip)=0A=
>>   				arr[n++] =3D 0xb1;  /* Block characteristics */=0A=
>>   				if (is_disk)=0A=
>>   					arr[n++] =3D 0xb2;  /* LB Provisioning */=0A=
>> -				else if (is_zbc)=0A=
>> +				if (is_zbc)=0A=
>>   					arr[n++] =3D 0xb6;  /* ZB dev. char. */=0A=
>>   			}=0A=
>>   			arr[3] =3D n - 4;	  /* number of supported VPD pages */=0A=
>> @@ -1660,7 +1672,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, str=
uct sdebug_dev_info *devip)=0A=
>>   			arr[3] =3D inquiry_vpd_b0(&arr[4]);=0A=
>>   		} else if (is_disk_zbc && 0xb1 =3D=3D cmd[2]) { /* Block char. */=0A=
>>   			arr[1] =3D cmd[2];        /*sanity */=0A=
>> -			arr[3] =3D inquiry_vpd_b1(&arr[4]);=0A=
>> +			arr[3] =3D inquiry_vpd_b1(devip, &arr[4]);=0A=
>>   		} else if (is_disk && 0xb2 =3D=3D cmd[2]) { /* LB Prov. */=0A=
>>   			arr[1] =3D cmd[2];        /*sanity */=0A=
>>   			arr[3] =3D inquiry_vpd_b2(&arr[4]);=0A=
>> @@ -2305,7 +2317,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,=
=0A=
>>   	msense_6 =3D (MODE_SENSE =3D=3D cmd[0]);=0A=
>>   	llbaa =3D msense_6 ? false : !!(cmd[1] & 0x10);=0A=
>>   	is_disk =3D (sdebug_ptype =3D=3D TYPE_DISK);=0A=
>> -	is_zbc =3D (sdebug_ptype =3D=3D TYPE_ZBC);=0A=
>> +	is_zbc =3D (devip->zmodel !=3D BLK_ZONED_NONE);=0A=
>>   	if ((is_disk || is_zbc) && !dbd)=0A=
>>   		bd_len =3D llbaa ? 16 : 8;=0A=
>>   	else=0A=
>> @@ -2656,7 +2668,7 @@ static struct sdeb_zone_state *zbc_zone(struct sde=
bug_dev_info *devip,=0A=
>>   =0A=
>>   static inline bool zbc_zone_is_conv(struct sdeb_zone_state *zsp)=0A=
>>   {=0A=
>> -	return zsp->z_cond =3D=3D ZBC_NOT_WRITE_POINTER;=0A=
>> +	return zsp->z_type =3D=3D ZBC_ZONE_TYPE_CNV;=0A=
>>   }=0A=
>>   =0A=
>>   static void zbc_close_zone(struct sdebug_dev_info *devip,=0A=
>> @@ -2732,13 +2744,42 @@ static void zbc_inc_wp(struct sdebug_dev_info *d=
evip,=0A=
>>   		       unsigned long long lba, unsigned int num)=0A=
>>   {=0A=
>>   	struct sdeb_zone_state *zsp =3D zbc_zone(devip, lba);=0A=
>> +	unsigned long long n, end, zend =3D zsp->z_start + zsp->z_size;=0A=
>>   =0A=
>>   	if (zbc_zone_is_conv(zsp))=0A=
>>   		return;=0A=
>>   =0A=
>> -	zsp->z_wp +=3D num;=0A=
>> -	if (zsp->z_wp >=3D zsp->z_start + zsp->z_size)=0A=
>> -		zsp->z_cond =3D ZC5_FULL;=0A=
>> +	if (zsp->z_type =3D=3D ZBC_ZONE_TYPE_SWR) {=0A=
>> +		zsp->z_wp +=3D num;=0A=
>> +		if (zsp->z_wp >=3D zend)=0A=
>> +			zsp->z_cond =3D ZC5_FULL;=0A=
>> +		return;=0A=
>> +	}=0A=
>> +=0A=
>> +	while (num) {=0A=
>> +		if (lba !=3D zsp->z_wp)=0A=
>> +			zsp->z_non_seq_resource =3D true;=0A=
>> +=0A=
>> +		end =3D lba + num;=0A=
>> +		if (end >=3D zend) {=0A=
>> +			n =3D zend - lba;=0A=
>> +			zsp->z_wp =3D zend;=0A=
>> +		} else if (end > zsp->z_wp) {=0A=
>> +			n =3D num;=0A=
>> +			zsp->z_wp =3D end;=0A=
>> +		} else {=0A=
>> +			n =3D num;=0A=
>> +		}=0A=
>> +		if (zsp->z_wp >=3D zend)=0A=
>> +			zsp->z_cond =3D ZC5_FULL;=0A=
>> +=0A=
>> +		num -=3D n;=0A=
>> +		lba +=3D n;=0A=
>> +		if (num) {=0A=
>> +			zsp++;=0A=
>> +			zend =3D zsp->z_start + zsp->z_size;=0A=
>> +		}=0A=
>> +	}=0A=
>>   }=0A=
>>   =0A=
>>   static int check_zbc_access_params(struct scsi_cmnd *scp,=0A=
>> @@ -2750,7 +2791,9 @@ static int check_zbc_access_params(struct scsi_cmn=
d *scp,=0A=
>>   	struct sdeb_zone_state *zsp_end =3D zbc_zone(devip, lba + num - 1);=
=0A=
>>   =0A=
>>   	if (!write) {=0A=
>> -		/* Reads cannot cross zone types boundaries */=0A=
>> +		if (devip->zmodel =3D=3D BLK_ZONED_HA)=0A=
>> +			return 0;=0A=
>> +		/* For host-managed, reads cannot cross zone types boundaries */=0A=
>>   		if (zsp_end !=3D zsp &&=0A=
>>   		    zbc_zone_is_conv(zsp) &&=0A=
>>   		    !zbc_zone_is_conv(zsp_end)) {=0A=
>> @@ -2773,25 +2816,27 @@ static int check_zbc_access_params(struct scsi_c=
mnd *scp,=0A=
>>   		return 0;=0A=
>>   	}=0A=
>>   =0A=
>> -	/* Writes cannot cross sequential zone boundaries */=0A=
>> -	if (zsp_end !=3D zsp) {=0A=
>> -		mk_sense_buffer(scp, ILLEGAL_REQUEST,=0A=
>> -				LBA_OUT_OF_RANGE,=0A=
>> -				WRITE_BOUNDARY_ASCQ);=0A=
>> -		return check_condition_result;=0A=
>> -	}=0A=
>> -	/* Cannot write full zones */=0A=
>> -	if (zsp->z_cond =3D=3D ZC5_FULL) {=0A=
>> -		mk_sense_buffer(scp, ILLEGAL_REQUEST,=0A=
>> -				INVALID_FIELD_IN_CDB, 0);=0A=
>> -		return check_condition_result;=0A=
>> -	}=0A=
>> -	/* Writes must be aligned to the zone WP */=0A=
>> -	if (lba !=3D zsp->z_wp) {=0A=
>> -		mk_sense_buffer(scp, ILLEGAL_REQUEST,=0A=
>> -				LBA_OUT_OF_RANGE,=0A=
>> -				UNALIGNED_WRITE_ASCQ);=0A=
>> -		return check_condition_result;=0A=
>> +	if (zsp->z_type =3D=3D ZBC_ZONE_TYPE_SWR) {=0A=
>> +		/* Writes cannot cross sequential zone boundaries */=0A=
>> +		if (zsp_end !=3D zsp) {=0A=
>> +			mk_sense_buffer(scp, ILLEGAL_REQUEST,=0A=
>> +					LBA_OUT_OF_RANGE,=0A=
>> +					WRITE_BOUNDARY_ASCQ);=0A=
>> +			return check_condition_result;=0A=
>> +		}=0A=
>> +		/* Cannot write full zones */=0A=
>> +		if (zsp->z_cond =3D=3D ZC5_FULL) {=0A=
>> +			mk_sense_buffer(scp, ILLEGAL_REQUEST,=0A=
>> +					INVALID_FIELD_IN_CDB, 0);=0A=
>> +			return check_condition_result;=0A=
>> +		}=0A=
>> +		/* Writes must be aligned to the zone WP */=0A=
>> +		if (lba !=3D zsp->z_wp) {=0A=
>> +			mk_sense_buffer(scp, ILLEGAL_REQUEST,=0A=
>> +					LBA_OUT_OF_RANGE,=0A=
>> +					UNALIGNED_WRITE_ASCQ);=0A=
>> +			return check_condition_result;=0A=
>> +		}=0A=
>>   	}=0A=
>>   =0A=
>>   	/* Handle implicit open of closed and empty zones */=0A=
>> @@ -4312,13 +4357,16 @@ static int resp_report_zones(struct scsi_cmnd *s=
cp,=0A=
>>   		case 0x06:=0A=
>>   		case 0x07:=0A=
>>   		case 0x10:=0A=
>> -		case 0x11:=0A=
>>   			/*=0A=
>> -			 * Read-only, offline, reset WP recommended and=0A=
>> -			 * non-seq-resource-used are not emulated: no zones=0A=
>> -			 * to report;=0A=
>> +			 * Read-only, offline, reset WP recommended are=0A=
>> +			 * not emulated: no zones to report;=0A=
>>   			 */=0A=
>>   			continue;=0A=
>> +		case 0x11:=0A=
>> +			/* non-seq-resource set */=0A=
>> +			if (!zsp->z_non_seq_resource)=0A=
>> +				continue;=0A=
>> +			break;=0A=
>>   		case 0x3f:=0A=
>>   			/* Not write pointer (conventional) zones */=0A=
>>   			if (!zbc_zone_is_conv(zsp))=0A=
>> @@ -4333,11 +4381,10 @@ static int resp_report_zones(struct scsi_cmnd *s=
cp,=0A=
>>   =0A=
>>   		if (nrz < rep_max_zones) {=0A=
>>   			/* Fill zone descriptor */=0A=
>> -			if (zbc_zone_is_conv(zsp))=0A=
>> -				desc[0] =3D 0x1;=0A=
>> -			else=0A=
>> -				desc[0] =3D 0x2;=0A=
>> +			desc[0] =3D zsp->z_type;=0A=
>>   			desc[1] =3D zsp->z_cond << 4;=0A=
>> +			if (zsp->z_non_seq_resource)=0A=
>> +				desc[1] |=3D 1 << 1;=0A=
>>   			put_unaligned_be64((u64)zsp->z_size, desc + 8);=0A=
>>   			put_unaligned_be64((u64)zsp->z_start, desc + 16);=0A=
>>   			put_unaligned_be64((u64)zsp->z_wp, desc + 24);=0A=
>> @@ -4591,6 +4638,7 @@ static void zbc_rwp_zone(struct sdebug_dev_info *d=
evip,=0A=
>>   	if (zsp->z_cond =3D=3D ZC4_CLOSED)=0A=
>>   		devip->nr_closed--;=0A=
>>   =0A=
>> +	zsp->z_non_seq_resource =3D false;=0A=
>>   	zsp->z_wp =3D zsp->z_start;=0A=
>>   	zsp->z_cond =3D ZC1_EMPTY;=0A=
>>   }=0A=
>> @@ -4796,11 +4844,13 @@ static int sdebug_device_create_zones(struct sde=
bug_dev_info *devip)=0A=
>>   	}=0A=
>>   	devip->nr_conv_zones =3D sdeb_zbc_nr_conv;=0A=
>>   =0A=
>> -	/* zbc_max_open_zones can be 0, meaning "not reported" (no limit) */=
=0A=
>> -	if (sdeb_zbc_max_open >=3D devip->nr_zones - 1)=0A=
>> -		devip->max_open =3D (devip->nr_zones - 1) / 2;=0A=
>> -	else=0A=
>> -		devip->max_open =3D sdeb_zbc_max_open;=0A=
>> +	if (devip->zmodel =3D=3D BLK_ZONED_HM) {=0A=
>> +		/* zbc_max_open_zones can be 0, meaning "not reported" */=0A=
>> +		if (sdeb_zbc_max_open >=3D devip->nr_zones - 1)=0A=
>> +			devip->max_open =3D (devip->nr_zones - 1) / 2;=0A=
>> +		else=0A=
>> +			devip->max_open =3D sdeb_zbc_max_open;=0A=
>> +	}=0A=
>>   =0A=
>>   	devip->zstate =3D kcalloc(devip->nr_zones,=0A=
>>   				sizeof(struct sdeb_zone_state), GFP_KERNEL);=0A=
>> @@ -4813,9 +4863,14 @@ static int sdebug_device_create_zones(struct sdeb=
ug_dev_info *devip)=0A=
>>   		zsp->z_start =3D zstart;=0A=
>>   =0A=
>>   		if (i < devip->nr_conv_zones) {=0A=
>> +			zsp->z_type =3D ZBC_ZONE_TYPE_CNV;=0A=
>>   			zsp->z_cond =3D ZBC_NOT_WRITE_POINTER;=0A=
>>   			zsp->z_wp =3D (sector_t)-1;=0A=
>>   		} else {=0A=
>> +			if (devip->zmodel =3D=3D BLK_ZONED_HM)=0A=
>> +				zsp->z_type =3D ZBC_ZONE_TYPE_SWR;=0A=
>> +			else=0A=
>> +				zsp->z_type =3D ZBC_ZONE_TYPE_SWP;=0A=
>>   			zsp->z_cond =3D ZC1_EMPTY;=0A=
>>   			zsp->z_wp =3D zsp->z_start;=0A=
>>   		}=0A=
>> @@ -4851,10 +4906,13 @@ static struct sdebug_dev_info *sdebug_device_cre=
ate(=0A=
>>   		}=0A=
>>   		devip->sdbg_host =3D sdbg_host;=0A=
>>   		if (sdeb_zbc_in_use) {=0A=
>> +			devip->zmodel =3D sdeb_zbc_model;=0A=
>>   			if (sdebug_device_create_zones(devip)) {=0A=
>>   				kfree(devip);=0A=
>>   				return NULL;=0A=
>>   			}=0A=
>> +		} else {=0A=
>> +			devip->zmodel =3D BLK_ZONED_NONE;=0A=
>>   		}=0A=
>>   		devip->sdbg_host =3D sdbg_host;=0A=
>>   		list_add_tail(&devip->dev_list, &sdbg_host->dev_info_list);=0A=
>> @@ -6566,12 +6624,12 @@ static int __init scsi_debug_init(void)=0A=
>>   		sdeb_zbc_model =3D k;=0A=
>>   		switch (sdeb_zbc_model) {=0A=
>>   		case BLK_ZONED_NONE:=0A=
>> +		case BLK_ZONED_HA:=0A=
>>   			sdebug_ptype =3D TYPE_DISK;=0A=
>>   			break;=0A=
>>   		case BLK_ZONED_HM:=0A=
>>   			sdebug_ptype =3D TYPE_ZBC;=0A=
>>   			break;=0A=
>> -		case BLK_ZONED_HA:=0A=
>>   		default:=0A=
>>   			pr_err("Invalid ZBC model\n");=0A=
>>   			return -EINVAL;=0A=
>>=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
