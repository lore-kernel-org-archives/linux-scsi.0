Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E112AC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF311600D4
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237121AbhHSJgC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:36:02 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:34164 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237005AbhHSJgB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:36:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1629365725; x=1660901725;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=17KyINitQCz4naqMvTLSO2427asThDAGHzPQbvS5qkU=;
  b=iqi8euUBnzTzRRJYvkaF/Kk5C+zIv2XDP13eP2FRiS9gLLsW431XikY1
   +gBjBe6MUHQBly1NuRXN1ItmSTSOg7dERnvItP0zHradXVxmY3U+m8nmA
   EVEFGgbNbAXojL8aHmhwEH4XyQb2yfnAj0MAcKikn1+YJj7Zmh85As+b2
   8Cb3JtoHh4/wbTQ+5FTRex+3T5LXaW3hh1XMRCBC+nVTZirI39SczMOoG
   d+U5LHLC53js1y96PAxjvFuDinDkSuPwK32Yxd4yQR3qpnXOMvwTHVmc6
   vprJSV8PJT4YnOK8YmaMVJkckPZqXhill3Y3SM0DFgYzvb52VsjOZTj90
   A==;
X-IronPort-AV: E=Sophos;i="5.84,334,1620662400"; 
   d="scan'208";a="177760199"
Received: from mail-dm6nam11lp2173.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.173])
  by ob1.hgst.iphmx.com with ESMTP; 19 Aug 2021 17:35:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l2GlTR+MAZJAhWONJuPnX6K7VmYFs8WgEIJhKblNi108BwtFBFKyrHyzuLzuDEuIU6lzQbvV9E22tEqWecp/SqLb8yAhUcRN81XON+mO/Il01jOgL/HnkEMiNAMp8rQhAa7crQC4qNA3nbJg/pxm97+vode+/4RdvzZB9Fd2r2emv9120K8Nz+Su6deUau2oaj8VvnKAJv92vuhEiUcm+PHwtGIdZamveMWN94OR+01HVXs1zJX92ICTD7pnfcijEcYCvXVoHH9pULXXJ9eNpk6ccgqr91j6oJhhi0aE9eu40txdNQmD5R5KQ8r3JaHnA+BKC6Z9gPmk7OjXW3t1Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHDOVcu3LHV7JSw9qrxSqr5F3RQVl14wggv9TKpqmi8=;
 b=cdn89xM58etVYnmd/yP/1IX/NOR2nD8GdkCzj/n6VfUrgA1O1kv9DykHUZCmeVFCadkunRHNm07xSBPcw3wFoiXWZMsiJCiBOnA+6x6q/Ae1DsNbPHJdOA9nRdDRvLkjbshos60lWUxGEw53hRQPwXrFBqE0n5M9jyryhRIx+A2Cg+ttRgXCgVmW/dd1prNuXJAdAIw1xKOEIZqqC2YYPS2ITgMMKE9efK3I/IxE4L4vsIRKzdUo/nD5HMER/vn0ua54ArzZWjGI9q3FvZQwEFbK5Q8636VjvR+A6r+8v1puE4zRs7j7cs9oNfSkGsOZRPVgedITGFXV9Gfg5bZoDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHDOVcu3LHV7JSw9qrxSqr5F3RQVl14wggv9TKpqmi8=;
 b=IEodahMVyR7TrBkRlkJyKpOhboACr6jWZjdi5abNIfMpUjRjnTejhxczWq0j357oRetyDXgaC7Rk96n2cSwRw5GR1qNX1pziGGtq7aofD7UMk4O9RboUAvSmcqk/f5hw9pH/0HRgTLdQfd4Ld/rOn/h1PMZuhLICB0ldmCUwAQ0=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB4827.namprd04.prod.outlook.com (2603:10b6:5:28::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Thu, 19 Aug
 2021 09:35:23 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%9]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 09:35:23 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: fix scsi_mode_sense()
Thread-Topic: [PATCH] scsi: fix scsi_mode_sense()
Thread-Index: AQHXlM0hwMoiis7/DEWJrnc4nHa0Eg==
Date:   Thu, 19 Aug 2021 09:35:23 +0000
Message-ID: <DM6PR04MB70814F1CC3642AE1625985DFE7C09@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210819073750.132601-1-damien.lemoal@wdc.com>
 <YR4kuT0Rg+sQiKJK@x1-carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91d06a42-a278-4b16-94c2-08d962f4ab77
x-ms-traffictypediagnostic: DM6PR04MB4827:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB48278F519001C9A808E4833AE7C09@DM6PR04MB4827.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iewPuI4DZZZnH7A3lbKt8tvmIR9ur0p9iBGrJ3AzlAT0bUdTCFwFrE9EDd+cKx3ptu+CDAQ3VAS0RtWO0wxFfG5UMUgW0Sh9HY/vjMCKZkvfq6wNXdFXH/gZCX4tQJK4/JZOU24o7/g/gBSGupGiPcqP1Tc9XprzZuoeYUZDjpfAKlyGsG8Ok5T3U5HyiwGlCYdOdlAHrji8IfnRRbm4PEw79ifChAuVMRvrt5tTe33rx/TIdvbPyZkV8901TE5/l1HGzUFWNHkR5m/iLHiO3khbx1CFR57f2qwJvwTdQA69RnZguregKMxJID7sRZ3d2vgQnXJSka9aaIo+BmqenjrwXJAk8HYBsHJS6nmBRVOvxwCeWFGsxv/ZOv3iZoFA74HZR9xF0pNc35p/vw4nZoj8gaYR2o4Qzun2BI09+A11X+IF2q3gFCiaaTChD5fHanQaZ5YPK4zXutr05xyIpie9Lo094fY2z7q9NTE064qLHfAOweOzhfkg5d1cZcXfxbqx04HKNpXCwlMhbiNytNf/4KjJ1hE/ZIh8/IstkQJZPR8vplBqOPewTSKFkLD+cGRmhLh7hp3tcazThOeXnps+sQT6oLbMASLcMPtH0jEsph1ALyr4oofpIiAKWTtkm4Z1Bz+4AYnB416Z3et3XkytfEJvlOore7QQPUGI2iS0/wA2BeTynp2sR+7bVcgVTAIpnFy2EBlWVZ0S+BEd4A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(86362001)(5660300002)(316002)(7696005)(6636002)(478600001)(54906003)(2906002)(55016002)(9686003)(52536014)(8936002)(6862004)(122000001)(83380400001)(66446008)(186003)(33656002)(66476007)(66946007)(91956017)(76116006)(71200400001)(66556008)(64756008)(38070700005)(4326008)(6506007)(38100700002)(53546011)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jKEryUA4RHRKnem2LbOmUwdUg93wtlXj3Y9Wk65jHDMj+Yb+1sDXe/sgsA/l?=
 =?us-ascii?Q?GfEBFOOpKo9kUsgCuBd3Ksy8/0r2yItGwG87B2gdd6dwIyH8L1NGpMSre7GC?=
 =?us-ascii?Q?+tP4VMZzuQXAZhF2hoA4PuWc1rW5t4RsLgjLmi7R5zgWuWCIMCjPwjOjLidZ?=
 =?us-ascii?Q?F5wthYIcHTYF1w/fdoNvuOxypm8vXTuKhk94XrNBk5/tI9I69Z6O3IYCkOQN?=
 =?us-ascii?Q?dsVX3JYed8LaR55alIiAMOivTxsM3Q/fDYFFVD13448tYriZ3AMucOfDoD3f?=
 =?us-ascii?Q?bcsVL+q5h8iEaARWfP00+fX/dZBLn2rREj/MH5IrufifpUKf131hFq/mbk4d?=
 =?us-ascii?Q?8Ol4NIeTtm1ydNbzeJ6YgvUezE5DI2rJ+Z/cDpmNxjvz4WE2q+W/Ui098KVB?=
 =?us-ascii?Q?EryMin8oKRpsJCZcLZeevJPd5tS+8JLUV5nfvIA6pvpzz/NDhxWzoHZyz5Re?=
 =?us-ascii?Q?p3L6e2fMp6ZH7sMYU5zByTUjy4NiXIHsOFWt3ZW7E0kKVLNA2K6fuDnm7iOo?=
 =?us-ascii?Q?LOHBDzZZm6JBsVB4QBp0ahZLA9ZXfsxRw3pte8SD1fN5T3RDP1tFZRDCsr0s?=
 =?us-ascii?Q?PvVfASrBYCtOEQJy+eqqySKHUosOZmx1y/2CBB5zKA4plEAooReqpVbx9cPF?=
 =?us-ascii?Q?AdGWFVq7BiNvgh2Q7f17Juki221MTIb8jkQwebYY/6rv+O4NkMuO0sn8eBqP?=
 =?us-ascii?Q?kX9ntQlwbvGH4BkcTQgyYC5LmMSNh9RtfWu5a32kan2Upn1/WNm0KZGbt3hJ?=
 =?us-ascii?Q?jdpDc5/etbsFlKUH9z77uD0MO0pHIwFKCtqarz0wVaCPob8uWZqthWFWues6?=
 =?us-ascii?Q?qt5FaHuqvyd7DL3dm2JLM5kHQBA6FCPyWwrSmA7oJL5sNLJLPlyFXyofugtW?=
 =?us-ascii?Q?T8eCo3n1bS1E0vktQlqlXr9HobyjSSZNhoMCrkbnCwH8JXqFyvg0cY+6oJQa?=
 =?us-ascii?Q?1LvGLm99+7LDwDpsc+g4x/N+lA+hcm3glIa4Kr2B1ILDHhnYwxOQBvFtMYZY?=
 =?us-ascii?Q?lshcyVBYQD+BDgchz64P/zW9Jb+u7PT/RblNheFrTafFo2RS4VLC0w4J6t8a?=
 =?us-ascii?Q?HHeqDoXX3GR+sfOsNczBTVGGEwLsorzbEI3EHzkYOuWdZQdvcQk2bJJ8pfVb?=
 =?us-ascii?Q?kdeqMepBBZHGvMlSyUcsBeZl95tt1e2+JsUoHlbsc6ynSGcylx1LlB9eNkZL?=
 =?us-ascii?Q?2qziGKxE+zncOTPRsstY22bXWUO0GLaVlKh92rh2gupN82aF1Mzo+GpU5Jgi?=
 =?us-ascii?Q?CbFDBUP3xkoVRRdFjmHe2BWlnGl3B4Ynjjps7bEe/fjO+H2lh3uyN0Y5/YEg?=
 =?us-ascii?Q?ia+Y7oeMexD6cv182Xw/b/bFJI+FnZQ6eRSmNc6Z2YaSCBUA+YyAisaa0ZLk?=
 =?us-ascii?Q?UwcQ18sxRJhhkSyQyvntNjh3bWrbRRjAxVMDHoFlHB7Jlv9OSg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91d06a42-a278-4b16-94c2-08d962f4ab77
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 09:35:23.6773
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6BlmfvtlDH5amyqEy8NHpDYWCXbZLGvbJZfFeqitNEGGwGLgFEk5jGlZqWWqEYNyoz34SKJs5/1ym93BGDdmvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4827
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/19 18:30, Niklas Cassel wrote:=0A=
> On Thu, Aug 19, 2021 at 04:37:50PM +0900, Damien Le Moal wrote:=0A=
>> The allocation length field of the MODE SENSE 10 command is 16-bits,=0A=
>> occupying bytes 7 and 8 of the CDB. With this command, access to mode=0A=
>> pages larger than 255 bytes is thus possible. Make sure that=0A=
>> scsi_mode_sense() code reflects this by initializing the allocation=0A=
>> length field using put_unaligned_be16() instead of directly setting=0A=
>> only byte 8 of the CDB with the buffer length.=0A=
>>=0A=
>> While at it, also fix the folowing:=0A=
>> * use get_unaligned_be16() to retrieve the mode data length and block=0A=
>>   descriptor length fields of the mode sense reply header instead of=0A=
>>   using an open coded calculation.=0A=
>> * Fix the kdoc dbd argument explanation: the DBD bit stands for=0A=
>>   Disable Block Descriptor, which is the opposite of what the dbd=0A=
>>   argument description was.=0A=
>>=0A=
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> ---=0A=
>>  drivers/scsi/scsi_lib.c | 9 ++++-----=0A=
>>  1 file changed, 4 insertions(+), 5 deletions(-)=0A=
>>=0A=
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c=0A=
>> index 7456a26aef51..92db00d81733 100644=0A=
>> --- a/drivers/scsi/scsi_lib.c=0A=
>> +++ b/drivers/scsi/scsi_lib.c=0A=
>> @@ -2070,7 +2070,7 @@ EXPORT_SYMBOL_GPL(scsi_mode_select);=0A=
>>  /**=0A=
>>   *	scsi_mode_sense - issue a mode sense, falling back from 10 to six by=
tes if necessary.=0A=
>>   *	@sdev:	SCSI device to be queried=0A=
>> - *	@dbd:	set if mode sense will allow block descriptors to be returned=
=0A=
>> + *	@dbd:	set to prevent mode sense from returning block descriptors=0A=
>>   *	@modepage: mode page being requested=0A=
>>   *	@buffer: request buffer (may not be smaller than eight bytes)=0A=
>>   *	@len:	length of request buffer.=0A=
>> @@ -2112,7 +2112,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd,=
 int modepage,=0A=
>>  			len =3D 8;=0A=
>>  =0A=
>>  		cmd[0] =3D MODE_SENSE_10;=0A=
>> -		cmd[8] =3D len;=0A=
>> +		put_unaligned_be16(len, &cmd[7]);=0A=
>>  		header_length =3D 8;=0A=
>>  	} else {=0A=
>>  		if (len < 4)=0A=
>> @@ -2166,12 +2166,11 @@ scsi_mode_sense(struct scsi_device *sdev, int db=
d, int modepage,=0A=
>>  		data->longlba =3D 0;=0A=
>>  		data->block_descriptor_length =3D 0;=0A=
>>  	} else if (use_10_for_ms) {=0A=
>> -		data->length =3D buffer[0]*256 + buffer[1] + 2;=0A=
>> +		data->length =3D get_unaligned_be16(&buffer[0]) + 2;=0A=
>>  		data->medium_type =3D buffer[2];=0A=
>>  		data->device_specific =3D buffer[3];=0A=
>>  		data->longlba =3D buffer[4] & 0x01;=0A=
>> -		data->block_descriptor_length =3D buffer[6]*256=0A=
>> -			+ buffer[7];=0A=
>> +		data->block_descriptor_length =3D get_unaligned_be16(&buffer[6]);=0A=
>>  	} else {=0A=
>>  		data->length =3D buffer[0] + 1;=0A=
>>  		data->medium_type =3D buffer[1];=0A=
> =0A=
> (Nit:=0A=
> When the subject contains "fix", I think that people automatically look=
=0A=
> for a Fixes-tag. However, AFAIK, there isn't a caller that sends in a=0A=
> length > 1 byte. So a slightly better subject might have been:=0A=
> "scsi: allow scsi_mode_sense() to read more than 255 bytes")=0A=
=0A=
Indeed, that is better.=0A=
=0A=
Martin,=0A=
=0A=
Can you fix that up ? Or should I resend ?=0A=
=0A=
There is also the fact that the argument len is not being checked against 2=
55.=0A=
So if the device does not have use_10_for_ms set, weird things can happen.=
=0A=
I did not add the check because this code has been like this since a long t=
ime=0A=
and no problem is being reported...=0A=
=0A=
> =0A=
> Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
