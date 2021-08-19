Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28B81C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 23:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07E73610E6
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 23:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236872AbhHSX7v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 19:59:51 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:50587 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233972AbhHSX7u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 19:59:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1629417553; x=1660953553;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=9F9qpgtOLXhSh1OSbRk7hHZrEEnSuDmvEqeaCNMjAlw=;
  b=qIvkgyEE5XEkwufaH7KYvPFLm1FDIX6lZq4DAzz8FAcPLV67S75beJ1Q
   Rad/0noC7VFtecVlCF8F0gIdyf1aOTqQdvpT60wAuv0A2FBelGeFsqH2j
   blsN7lUFpuD4OCO1M5A2jLXRutJjFIZVKqDZeNQ52Kevdi/QkPxzIEG3L
   WY3shNNJMAIB1ykkeYFScD9pOuZCQLCNBmrreFkgut8zy0CwQWnCynvw7
   gi9DaYAzigR9Y4AlJq27PmRH4UpKN/0BSNNCqolL1G68yEHhRAj1s7pe2
   f8163NAOh/ZgtFaHbJ2XrNecuEN73p5jlugbqOOIWdeEeDMBY+cGT3qA4
   w==;
X-IronPort-AV: E=Sophos;i="5.84,336,1620662400"; 
   d="scan'208";a="289433144"
Received: from mail-bn7nam10lp2108.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.108])
  by ob1.hgst.iphmx.com with ESMTP; 20 Aug 2021 07:59:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Akd1B+x5RpZwYoI0qF8DHTqhga7xBG6o7HpzH9OzBfDW7gNQgwm7sARzb0SEk9Il3lqYSzv0VaIameEwjgbk3zAvgt9Y8eYq3Nq5jMuwjsqVqvn2dnVrQkzYye2MELUT2/2UYCiEohFmW4Kyv7kE9C4FSt1PnMiVp8vDTtArxAe0t+0f1AN9CtxFc8LUrwYDt1H4HCxRwGQYyaH0FWWlisS4c0ZkjxBYihQN9Z6xPk5uKI67HDzf425domYPR6mGpJPNt34yYKU+G0+MO3NU+pr814wISx6MM9oMtlBrODV8Lhs3wBhcCk1c8C1KQzYYS8dHhQ/zy6axSnws+STZcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTNQPjELPfvX7cRT5LJm/RNx4NMrG9VWEuK+cvlXA2Q=;
 b=SkxNk0ZMFePW6q4G2tY1k7VyTpXZuc4XNBJoQlvBCbB+o/YOlh7YHZoWwSGNT29vLLCSRjzjmNRXHZEQvZkhQm9HRbpO4oaa+G2VcC0/dJesm/YkwscMpJqq3L2BN1LM7a+Ox1/C30GZ7P6IhzAch89bKRz2NHwfnQ+LI91uJyS4/VRymowPb8/7NsXYmdkgRg+XqIbt+hpLyu939qpvJjwHtc4GanE4pAALcUHQbyvU2VTC5Qe9BGoQ7QkKLdYjCsBhP4NjW1/D7o+/YDdqi2Wk/sgzcKt7+8NaXNv4SoSCZTBN5EbvxzlV1Om7SnrqWeok9LGQdXU5tnIi5vYhvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTNQPjELPfvX7cRT5LJm/RNx4NMrG9VWEuK+cvlXA2Q=;
 b=ioljlzsjrxSrPBpuqNDmSHV/pK7ae3i7v463WbZBJ/VITx/elxC7oCAYARbAZyaEdABsgjlZNG1mrsMzljl9vkA/2Foon2Gwka4xbWH9eJb1EVUcHpNqIZNeYf5gv0KQJhJNQAX6lZiB555hQsXyrLQMCMNvKK/XLWErSvYHlCk=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM5PR04MB0443.namprd04.prod.outlook.com (2603:10b6:3:a6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.23; Thu, 19 Aug
 2021 23:59:11 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%9]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 23:59:11 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: simplify scsi_get_vpd_page()
Thread-Topic: [PATCH v2] scsi: simplify scsi_get_vpd_page()
Thread-Index: AQHXj9/IU1uam3DTrUWD/DUPNdTXrg==
Date:   Thu, 19 Aug 2021 23:59:11 +0000
Message-ID: <DM6PR04MB708121272070FE1012A4CE6FE7C09@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210813010738.1204219-1-damien.lemoal@wdc.com>
 <YR5t1OoLOEQ0zz4O@x1-carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 932f21b0-5eb7-4760-817f-08d9636d5732
x-ms-traffictypediagnostic: DM5PR04MB0443:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR04MB0443A3AA4104730B4E1782D1E7C09@DM5PR04MB0443.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:785;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o6lHUdY2XRnvEMHWxsGQdC2YdOj8h++BfcYzKFLhD4JXo/U/26pFFFRQjKvs46Mfx7WFcx2UVrz1SwUB4lbIlbPY5jq0tz7NjxwJdt0l4VSnZU8vqY1psZiTGjSOK41hB/yrzdp+J1c8oMC9x0vumdt0EIcYTMh4kTQNkN67KBUZvuDs70qhM3dxCbAv61wI1j3jmm82x+4Hlh+fFGGJ78A2RtuhXjSn5YpW+q7lEPZEOJBkuo+zGM5MAJIQhQ5EyyVqBEND5UTK3zlKIFSHqOJ7IxdE3w/UFE42il0ARthdlopd1FJlIRA2xr/eZgSUpjwfFH2m3VWWyZk4LDLc9uRwBUWexslCCYEVglXljDJ3GlXjW+q73W50drk+pNJLhbV8heimCPk34n8kZHMiaXCpe64p7L15tHHKsQydFsPjUM5dLCa/g09Ob91ZQgo/2fMKKdpmQzXtPH2wfzAQN2MacyTORbnBaqcmo3CS9VG30UciL5OxHuDYH7LE7I8Pvvbks8iftpGxeXHwTtswEwdwY7vodfR8rckI6VNZVSBBWM+88pnFiZZs6dgLt2NgH5xswhasH0egimU8w7t8d3ahCIYkPPmlapIwcdlhBjojtVvcClZCE8xhNV/hWyR+CEiBMrCOopl8HWMq5JmovWNFkXxAXXb0sh+vwyzggcDXylUyidDxWEHbREyDM7ZT1qXA8BGG9AGc9kL/Wu+B1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(136003)(346002)(376002)(38100700002)(8936002)(6862004)(478600001)(8676002)(7696005)(6506007)(5660300002)(83380400001)(54906003)(6636002)(2906002)(38070700005)(86362001)(316002)(66946007)(53546011)(122000001)(4326008)(66476007)(91956017)(76116006)(55016002)(26005)(186003)(33656002)(52536014)(66446008)(9686003)(71200400001)(64756008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MHhSmvnHaDStNEookcwKmjJo5unsQpxjmUJ0Djne9vQtKH5LnX0J9xp6JOBm?=
 =?us-ascii?Q?sZCO3Og3UBFJSu1i7lCdAu4kcPgqRVEYboDGoUtWMMz62z1qgwXWcp8CyT8P?=
 =?us-ascii?Q?iUJttbSaSTJkJrTGQpOkANeE/O8uGPaQtrUXRSis8+th0bCRO3JvVdbrZmaA?=
 =?us-ascii?Q?mO9n3VcqfhXKwt8EOnYIr6P0U9ulYytehvMkGa9XQfKVsnz+Kn6sDCL8n35e?=
 =?us-ascii?Q?iFWFJlnhgd6BUvqcgd2EDHNfgfeK4uXDtSoSPOKO6ef15k08LGUlAx7ZbpiH?=
 =?us-ascii?Q?Rij1jdonxBPr98L9n49OEX6GbkzUQH9T8ZAp9Oz7WrcbhGyX7qGZGOfVJI21?=
 =?us-ascii?Q?XdgTBwEVS94Yqo6nKTof0Gc7cHtejdzbXTqpNwNPo8raiVlGpsdSzSXA8q6g?=
 =?us-ascii?Q?umY8HzWiJMFfAyn8399CHx9e06AAa1mLJT9V+KsmwZRizhyXBSYIvEWN5sL0?=
 =?us-ascii?Q?wFuK5qXvgluunOS32GQPMIU4TGUmgUHj9l0LseSfpRHpK/MwW4CPl6QVjeTk?=
 =?us-ascii?Q?i55iSmlOt3J11ZZdEdmATDsMHxJiWDuVX3xzBA+hrwN3uUn5CR541blATfL+?=
 =?us-ascii?Q?z9T3oFXzY9pOyEGyMa93EXO8U+Ct1GVH6VyzTkV87Q/mHA5DEiTTYg4j9nPw?=
 =?us-ascii?Q?BJ64vViAsLoOYx5BfMwDFvQGL1kiHTE/v05eZys0irwcA4d7wC1iGIXpRtfY?=
 =?us-ascii?Q?p9G8VBkzct7lU236VMzH+rgOe3MvGHO4mdtyEiFmbiXdSc7KQpXSg8bwue5K?=
 =?us-ascii?Q?eZ7m8HYqXfeL/DCsrRBh75KCqVwsnRK+gCl6EZgE0sNVk83a4tom72FG8KpR?=
 =?us-ascii?Q?ffzrkNisawaZvNGxz+2NYzBobkBI/w1notiSTM9nPDAWtYFja3MAPmiRH5xU?=
 =?us-ascii?Q?X0k29PO3yTn7663dnMW8CUDgLdaQ3jg3/1TYK+kn3/qlzedxDbdanG4Ywqfk?=
 =?us-ascii?Q?+RXXCd74idNOJvhpic2w4vALCkDY+I50A9ayy0wp2KSSu1b5FaATWD1bGFdG?=
 =?us-ascii?Q?8w23BsSZ7Ov/jupjQGM+BidiTkjUQ6L7+eqPpf9y7KxM+WyjZJeC4TAO4k4c?=
 =?us-ascii?Q?uazTOtY4HphLChC8/+EVnVvng6cdshVSOdaOEMAwHQUplJHNbCUsznPVrFty?=
 =?us-ascii?Q?v9YrGRXVpT+jqdlw7ydpmXRQtbBBbUE46OPDj0NpQ7BflZZPRgiyxbO5guUm?=
 =?us-ascii?Q?lxZYsNX/NmP6dkJW3sK9ddkwtMaZJu4K09IZEsApZrfjb3kwz6fMxZJr1mrj?=
 =?us-ascii?Q?JmZ2oqRkN8IAV6JEyS58ThA69utKWRAiT2jNaPirBAE1FPWcO/I6PotrW11R?=
 =?us-ascii?Q?LiKK6F5FG6wBSN4g161nGY0vMFFQkanPhtdbb10XK5vJUw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 932f21b0-5eb7-4760-817f-08d9636d5732
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 23:59:11.4222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fKlzpATFnXWFWgvbAxLXtDyKgQ1IQwaWQQtVr8faL3YVTe/X2EA9QOtmmNEbC43hfLmxgezsOjm39xtMTCYX7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0443
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/19 23:42, Niklas Cassel wrote:=0A=
> On Fri, Aug 13, 2021 at 10:07:38AM +0900, Damien Le Moal wrote:=0A=
>> Remove unnecessary gotos in scsi_get_vpd_page() to improve the code=0A=
>> readability. Also use memchr() instead of an open coded search loop=0A=
>> and update the outdated kernel doc comment for this function.=0A=
>>=0A=
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> ---=0A=
>>=0A=
>> Changes from v1:=0A=
>> * Keep the "found" goto and use memchr() in place of the page search=0A=
>>   loop, as suggested by Bart.=0A=
>> * Update the patch commit title and message=0A=
>>=0A=
>>  drivers/scsi/scsi.c | 30 +++++++++++++-----------------=0A=
>>  1 file changed, 13 insertions(+), 17 deletions(-)=0A=
>>=0A=
>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c=0A=
>> index d26025cf5de3..4946d8c4f298 100644=0A=
>> --- a/drivers/scsi/scsi.c=0A=
>> +++ b/drivers/scsi/scsi.c=0A=
>> @@ -339,47 +339,43 @@ static int scsi_vpd_inquiry(struct scsi_device *sd=
ev, unsigned char *buffer,=0A=
>>   *=0A=
>>   * SCSI devices may optionally supply Vital Product Data.  Each 'page'=
=0A=
>>   * of VPD is defined in the appropriate SCSI document (eg SPC, SBC).=0A=
>> - * If the device supports this VPD page, this routine returns a pointer=
=0A=
>> - * to a buffer containing the data from that page.  The caller is=0A=
>> - * responsible for calling kfree() on this pointer when it is no longer=
=0A=
>> - * needed.  If we cannot retrieve the VPD page this routine returns %NU=
LL.=0A=
>> + * If the device supports this VPD page, this routine fills @buf=0A=
>> + * with the data from that page and return 0. If the VPD page is not=0A=
>> + * supported or its content cannot be retrieved, -EINVAL is returned.=
=0A=
>>   */=0A=
>>  int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char =
*buf,=0A=
>>  		      int buf_len)=0A=
>>  {=0A=
>> -	int i, result;=0A=
>> +	int result;=0A=
>>  =0A=
>>  	if (sdev->skip_vpd_pages)=0A=
>> -		goto fail;=0A=
>> +		return -EINVAL;=0A=
>>  =0A=
>>  	/* Ask for all the pages supported by this device */=0A=
>>  	result =3D scsi_vpd_inquiry(sdev, buf, 0, buf_len);=0A=
>>  	if (result < 4)=0A=
>> -		goto fail;=0A=
>> +		return -EINVAL;=0A=
>>  =0A=
>>  	/* If the user actually wanted this page, we can skip the rest */=0A=
>>  	if (page =3D=3D 0)=0A=
>>  		return 0;=0A=
>>  =0A=
>> -	for (i =3D 4; i < min(result, buf_len); i++)=0A=
>> -		if (buf[i] =3D=3D page)=0A=
>> -			goto found;=0A=
>> +	if (memchr(&buf[4], page, min(result, buf_len)))=0A=
> =0A=
> Hello Damien,=0A=
> =0A=
> This will try to access data outside the buffer.=0A=
> =0A=
> When starting from index 4, you cannot search buf_len number of elements.=
=0A=
=0A=
Aouch, indeed, good catch. Sending V2 to correct that.=0A=
=0A=
> =0A=
> =0A=
> Kind regards,=0A=
> Niklas=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
