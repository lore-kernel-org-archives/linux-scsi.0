Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A67C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 02:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03FB5610D2
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 02:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237467AbhHTC0B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 22:26:01 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:64611 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbhHTCZ7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 22:25:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1629426321; x=1660962321;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=aeriKpA/fgX6bvN/k5KK0myC4AfDJFIRGyCz88YuSOw=;
  b=KCHn6N8B+J+b6VhBAxTvVmb6lZm0DShb7E5fYsA9+jhro5PEa3BIqkoo
   llKO8vaRjC7LLhq2xHqAzQnO2fFBVYLcuD7k/pWlef5RIphXby0ljK4Nh
   KgChZUQMOp/OXgi30JkzGDl3jbGNqeTd433xAJYesQC2rQhEr+P/bHb3F
   F4MtK7iW8Cb8tYUAobAtpP93gtVCcs8bgLhtFYycYLE0hSmcW/QOCVwQm
   9fO/Tcs0Iv9HKHSx5lTbv5V8mSHswImpzfjP5pqbT/dwafEUQAWbN2hHB
   EU4SeX9Si2p6tu3SJvuA3q5/2G6HMTOpx4vns7WZGWQnyBooYwo3rxj1R
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,336,1620662400"; 
   d="scan'208";a="182639031"
Received: from mail-mw2nam12lp2045.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.45])
  by ob1.hgst.iphmx.com with ESMTP; 20 Aug 2021 10:25:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0Jyaf0oC+eqGDt9zipc8n7kBucEywHgOHoIvuYbC3L4ZhldRYxSIEMSSV4pfsllu+FA2nWVCprpX2BeiSn55FgZO53Z6FdWRFLcTMhKMwbd6P5trVNyYF2+2A9kTpTwwS3SeuSEIXM57/OJNyWlNsjSuUtBGREnL63m6EOD8adB5ApkpTUpKz3NC2ozFe+vI0FeUg2Thyf4OMYwvpiLViP+6cAoFcgga8uVbz+LtHmsXbEnHhPUsEsFBkE1flQ11v0UuBVFfB1TzRLJ/zpnllWtwKtp2Hw7xOLJ4dN808sQt+tsRs1usqnnyvbXXtoL41kg/KftvPTI9r8hk6kDAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0KRxT7ckjUkE6vdrTBkx9s6+TF2rT9fwXwfrhINSzzM=;
 b=Ui5MmvElO86t3xjGe8nrGKNa77fpTwdZZ2Yr+LXPdMo4RUpztp3vJwh56JVIwrz7T3CfxapOkv79HqX5iaLhiu3Z1aabdrLMzCcNTCAnzQsUOgXPUz5I0trrTtimovdFXjlpaAtkg/uTniwg/O6K5LfI5LHKoWlGl4ift8W0FNq1DXHhjL2weG4m7QZViUFfmNF1N3lSi139GmHYb4+VFwOzM8pmm41SXA+hMXmmCTzi7CLcWNTPtUreLvQcE6805Dyx0Xs0QN1zkBtWdCKgHi31B9aGGz/4wKRBQ7qRDKdx7RFoS0c8ue/STSrfDggCeRK2ENpiRnYndt5DRjNsCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0KRxT7ckjUkE6vdrTBkx9s6+TF2rT9fwXwfrhINSzzM=;
 b=lRTLWGO19p3LG/H9q06648ydZ8/VY5jIRPO0X3gGo+cbp7fGcrMaJDHN3VZFfoiddm/+YxrcUSsSOTXbLD0c64quL2+PkpcKs6w3kTGL0OKlAjo472c0qhVsbajrBM8NCRJpfMijTCpn00FGuDDc7bkQpXjqjx36hLf5dZeJ0pc=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB6779.namprd04.prod.outlook.com (2603:10b6:5:243::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Fri, 20 Aug
 2021 02:25:19 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%9]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 02:25:19 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: fix scsi_mode_sense()
Thread-Topic: [PATCH] scsi: fix scsi_mode_sense()
Thread-Index: AQHXlM0hwMoiis7/DEWJrnc4nHa0Eg==
Date:   Fri, 20 Aug 2021 02:25:19 +0000
Message-ID: <DM6PR04MB7081A8741C88E72990BAB2B0E7C19@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210819073750.132601-1-damien.lemoal@wdc.com>
 <54cc6af0-67c2-5427-9952-230a7fbf4a76@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 537d04bf-dcac-45dc-2ea4-08d96381c17a
x-ms-traffictypediagnostic: DM6PR04MB6779:
x-microsoft-antispam-prvs: <DM6PR04MB6779E0DBB3950AC9C88C217EE7C19@DM6PR04MB6779.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kKBDOL+H3H0Z6bqG3XZQoevlVspMsMvM6xNJX4wqqkGGrxsHzk6f9LrbhB0OLWePuW0E5u+F/wQoYX1NTOnrLVuoKeoAbRf/jCXqxsZUPiabsHrCMI9Q76mrQwhuib97vZo9pQKPGa1vO+mWSUIF02sOwIEUiRPlRJDh64UGXt9JephKPB4E5C8CMs1825CdsSwrtV5ZiceRBryikFrtBTVHYxBhHyo5JieMD+HhJUBHVj85EL/3X75M3YRtaybuJu5/hClxkZNy2/7EC3W1GVzpn1BnHF8cMRo5t7CYpDsBJ+2/nCHDuOiWibixULwMOqVEld3eGTqa4d3MS7RLwGsegveJIoLxWwwO6ZHymi0V3UdUEauFuXuvtYSuw9yP8Q7uaUC+pMw3Hojohd24FtSwC4kNm+q8slG1UCQYiI4CA1C+nRsHF4g9UB6/CHekhY93D4YZIT581/FaJCHTdu0Cq/g4DxW65GHyhAE5eZiVeFWxEU9As50XPRvIL8LdjYdNe8fJg0dbSJOmTvFPrtwKescbmd3/kEJCoHPrn2XaTvOBuQE9QRn4iQonvCjxCGiJLDGIW3jCKvceP0dJE4CdmCyg7WO/qYcy9jZypAZz4UymUWAIna7gZY643Qn8ZFyxOTOXPg9cpKiGKflDg0erOPeEUaixYhF0VXJVfMNpcdsmI1XVtEUOB79VD0ppoKpx/gKX6quE1mV89UOUXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(53546011)(7696005)(110136005)(186003)(316002)(26005)(478600001)(55016002)(6506007)(9686003)(83380400001)(2906002)(38070700005)(71200400001)(8676002)(8936002)(64756008)(66476007)(66446008)(66946007)(66556008)(5660300002)(91956017)(76116006)(52536014)(33656002)(122000001)(38100700002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Tccr7pYHy+VbGBT0mWCqudsA8/kfiT+rGL9bXJQxiQm1snN4xNDzX2rJJ04i?=
 =?us-ascii?Q?jWzRXeLlPrMu7VmFfVgBs5L5n80eQxSiI2yRosNDupUkQ1G4cRZoTPEbiGsS?=
 =?us-ascii?Q?cG4gvir5qarjFDVjzzl9PcSvdq+rsRUhK2jI3pVRpZHO5SDlJqMrbRkHqmHk?=
 =?us-ascii?Q?DFiEw/hx/c8vnCBwCrMRRgrYmKbwDlZ6RlxsZ4frQmWYpD1pXsEgGYV20Ne5?=
 =?us-ascii?Q?MWCAmUSRt/JISIDI34hszHId192K++0T5FdZyze1UsTBTBveDdDlbJZzCfuN?=
 =?us-ascii?Q?mmwgsW0S1L/YpceA6P+n+udLKJI3k2xbUJ9MEGb1ukqBdo8XTqplfjBxWMDK?=
 =?us-ascii?Q?NtOemqXIeJ1I348mPV/z/taUVXqbFfSfbU7yypxV6weTn9ElIJemzss6xLaL?=
 =?us-ascii?Q?XRJ19lz4tQ+m9e1NhFpQt4JELgXUoQna/n85ytzmu+mkkFcGKCzauNwdlpSk?=
 =?us-ascii?Q?riiVcF3gxOo1Q4B/8WZe9SXzU2SWMH7zsNstzLEvWh2enlA/KUKXKG7erefY?=
 =?us-ascii?Q?Wi0ce91frBKa7XcaiBtvG9i6TlQFYg0r4hTEn9i4wrN9fL2eEfjhKTbOuwb6?=
 =?us-ascii?Q?g4uAus+lDhn22OCU1YB2QpW8N8l/Mnxk+WAp+a6ai2KN3fAgqynPFi4SBQod?=
 =?us-ascii?Q?hUlNNvx5npJqz4FWAPtf3n39WpNGAF4uSs/uEvmP22egycZZ+SD/A/BxFoy+?=
 =?us-ascii?Q?mTpFLpyGnZtyAskle0QqG//mvs3ORDvbjaxC459dfcFpDzw+Y9BLqA3+IfCh?=
 =?us-ascii?Q?bReNtKC1bCM+VMbvVBpcPUtqlxnAqQgSnCo1VnOQrP589hVNRSceiR7SVspb?=
 =?us-ascii?Q?5xcJyCKIwqLBW4OteRhbAZwx9J+L1piRDJL768BHuph1zscGRaPnp/mT4e84?=
 =?us-ascii?Q?UPF2MJybzrVy4+GWcVHNjmnDMXf8wgwgS0GbWY2mOZ2QVyHNJV2Sj0Q2Tc+W?=
 =?us-ascii?Q?J53BVOMzrddw3eItjZJHUo9/HPUfb4aoMJDECwNUhlFm+tdwcRpQc+VJcvu3?=
 =?us-ascii?Q?4tOT6FKdthIAR2qJiaPOtfCSVSzXr7aBCuDBh4u0osOrccE0d+FzLI9lDUE5?=
 =?us-ascii?Q?+TB2SzvkAxe9ZRJ2P6FZSCjptFHateNLEro9thgi7F62LFRJnbvCQr3xLjtg?=
 =?us-ascii?Q?TFr7UOvn8hrHYvOKi8I3M9cKMYmH/LtEXA6+pedGbQBV41XcZDkKq+R5z+U8?=
 =?us-ascii?Q?Riu2bwyrgVxqdnO1fhL389pjvWFEX4rmJ546TJgVuvzk84iE9mITAeG59WOa?=
 =?us-ascii?Q?N4pyHhypQBPqfqIWuxa497ZXtIMOGuUjcqfV/Nsww9Xyfvg8/fr5V4LE+Diz?=
 =?us-ascii?Q?PPVjd3Kjvz2Lk5tHn9RBYu3VuwfSue/HJaQ3xYQBWJcPfw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 537d04bf-dcac-45dc-2ea4-08d96381c17a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2021 02:25:19.6312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rsC3O2G7Rlr9grFBntR1vmncIKhs6ftqCuOscvZ2bHXsyaq/HP8+REFK5iDGCcjtrqd0njqVrOjutrG0AO0HaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6779
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/20 2:04, Bart Van Assche wrote:=0A=
> On 8/19/21 12:37 AM, Damien Le Moal wrote:=0A=
>> The allocation length field of the MODE SENSE 10 command is 16-bits,=0A=
>> occupying bytes 7 and 8 of the CDB. With this command, access to mode=0A=
>> pages larger than 255 bytes is thus possible. Make sure that=0A=
>> scsi_mode_sense() code reflects this by initializing the allocation=0A=
>> length field using put_unaligned_be16() instead of directly setting=0A=
>> only byte 8 of the CDB with the buffer length.=0A=
>>=0A=
>> While at it, also fix the folowing:=0A=
>> * use get_unaligned_be16() to retrieve the mode data length and block=0A=
>>    descriptor length fields of the mode sense reply header instead of=0A=
>>    using an open coded calculation.=0A=
>> * Fix the kdoc dbd argument explanation: the DBD bit stands for=0A=
>>    Disable Block Descriptor, which is the opposite of what the dbd=0A=
>>    argument description was.=0A=
>>=0A=
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> ---=0A=
>>   drivers/scsi/scsi_lib.c | 9 ++++-----=0A=
>>   1 file changed, 4 insertions(+), 5 deletions(-)=0A=
>>=0A=
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c=0A=
>> index 7456a26aef51..92db00d81733 100644=0A=
>> --- a/drivers/scsi/scsi_lib.c=0A=
>> +++ b/drivers/scsi/scsi_lib.c=0A=
>> @@ -2070,7 +2070,7 @@ EXPORT_SYMBOL_GPL(scsi_mode_select);=0A=
>>   /**=0A=
>>    *	scsi_mode_sense - issue a mode sense, falling back from 10 to six b=
ytes if necessary.=0A=
>>    *	@sdev:	SCSI device to be queried=0A=
>> - *	@dbd:	set if mode sense will allow block descriptors to be returned=
=0A=
>> + *	@dbd:	set to prevent mode sense from returning block descriptors=0A=
>>    *	@modepage: mode page being requested=0A=
>>    *	@buffer: request buffer (may not be smaller than eight bytes)=0A=
>>    *	@len:	length of request buffer.=0A=
>> @@ -2112,7 +2112,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd,=
 int modepage,=0A=
>>   			len =3D 8;=0A=
>>   =0A=
>>   		cmd[0] =3D MODE_SENSE_10;=0A=
>> -		cmd[8] =3D len;=0A=
>> +		put_unaligned_be16(len, &cmd[7]);=0A=
>>   		header_length =3D 8;=0A=
>>   	} else {=0A=
>>   		if (len < 4)=0A=
>> @@ -2166,12 +2166,11 @@ scsi_mode_sense(struct scsi_device *sdev, int db=
d, int modepage,=0A=
>>   		data->longlba =3D 0;=0A=
>>   		data->block_descriptor_length =3D 0;=0A=
>>   	} else if (use_10_for_ms) {=0A=
>> -		data->length =3D buffer[0]*256 + buffer[1] + 2;=0A=
>> +		data->length =3D get_unaligned_be16(&buffer[0]) + 2;=0A=
>>   		data->medium_type =3D buffer[2];=0A=
>>   		data->device_specific =3D buffer[3];=0A=
>>   		data->longlba =3D buffer[4] & 0x01;=0A=
>> -		data->block_descriptor_length =3D buffer[6]*256=0A=
>> -			+ buffer[7];=0A=
>> +		data->block_descriptor_length =3D get_unaligned_be16(&buffer[6]);=0A=
>>   	} else {=0A=
>>   		data->length =3D buffer[0] + 1;=0A=
>>   		data->medium_type =3D buffer[1];=0A=
> =0A=
> If the type of the scsi_mode_sense() 'len' argument is changed from =0A=
> 'int' into 'uint16_t', feel free to add:=0A=
=0A=
Bart,=0A=
=0A=
I would rather keep the argument as an int and add a check for=0A=
"len > UINT16_MAX" to return an error (-EINVAL) rather than having the inte=
rface=0A=
automatically cast/truncate len values that are too large. Doing so, buggy=
=0A=
drivers will get back an error and can be fixed. With the change to uint16_=
t,=0A=
errors may end up being hidden.=0A=
=0A=
scsi_mode_select() has such check. And looking at that function, it also ha=
s=0A=
problems with the buffer length max possible values as the added length of =
the=0A=
header is not accounted for. I fixed that too in a different patch (not sen=
t=0A=
yet). Thoughts ?=0A=
=0A=
> =0A=
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>=0A=
> =0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
