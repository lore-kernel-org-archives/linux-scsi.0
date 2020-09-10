Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660CFC43461
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 22:07:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DA2A207EA
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 22:07:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="EqRVbPZI";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Hit4FbRt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725379AbgIJWH0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 18:07:26 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:42792 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgIJWHY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 18:07:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1599775644; x=1631311644;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=u2WJ/htWQpW9/sz9Y7peGDmBPr/tF1wp0sW1ZZ4FoUM=;
  b=EqRVbPZIS62zU2yYgFTp0uaPaDm8R9pN3kZj0u8tZ9ckBJoDSf97JdA6
   P+Rk9u3vh4kkwwOPomL2e3isuNRqmuyNW10V65oAxo6acZI9IXBZYmsdp
   o/OsuYWcW/VcxhyTlXhG6FQfEVidImHe4E+/PebHRx92Dk7bxN9vlntYp
   +ILK2zmxLDfrR9doiUqLmc+iqD80+7IyjlVVHkPpkVAKyca2pds8/H5Db
   KIYV8S8Nf6odWorNPRbc7vdvyYe6SucJ9YKjNSyO4aZ6MQKp9CVsTUys/
   SVB5K9vh1DuPEEAB+ESlCCo/s6n4iHmC3nZ0Lt2UIL5/fCcpBBq9Dsytz
   w==;
IronPort-SDR: waClmzeWOb+xmaBOcYEgKFTrpCNmbwr94caS+fi9JjE0x4NCehRjeobCzg83J8OwAAvfJVzxMy
 NRAUPlvrza/XFWWMp/pbZv6o8uIyYjXIZw0ynazY4lbwbl1FV4FAU1JmkafnjrNNLmNT08sSI+
 rAEqk+PVEmNdGdq966ya7keMxTLMfuJlwq3bVLx1kcCfnPmPjzVM/TldPWKWQrS7EW17msSPat
 n2FWtlXEmfxF8apNgUS6dCL3ULr2xc7Exo/Q257pK+YPncAIWX3xdjdB+Fi2lSWVNIQ+t8hFkZ
 azc=
X-IronPort-AV: E=Sophos;i="5.76,413,1592841600"; 
   d="scan'208";a="256666707"
Received: from mail-dm6nam12lp2170.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.170])
  by ob1.hgst.iphmx.com with ESMTP; 11 Sep 2020 06:07:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WaHqN6Y4J+xsLSpSEUHJFOZOuNlAuuIh2WLw2Mn5YryJokZ7DVh8oNz1+q/IA5NnG9OawidLmW+B5Qpmm4J3+mSNJLsYMF/pu+UDe7i6cXKa0HKjnnLjc5EohUYSZKNEaS9/oSEPnt9fAc2A6Z1fVO4kBjbKfUiOe0CSOPML/qC9L8FJ2oxTTczNO95eAuTa12d6Wdkye1n3bmREXN32WG82tFksVH9tyEeJ24CRByXDJWQZwVVuIKpkoR/U0s7lxFSWkOHBPasbh3J8CfFFrmFOsKARBJICm1IRgND0q0bbhkbppwGsdue7bgDGD8j3DwDOLNM9fivQ3RwaNP7APA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5bjWtbAOpJ7Aig7RtAvSzZ2zRHsOKvf+xpWK2kqf/84=;
 b=Cc1oYEfGvgEisV9Nyo1YMbQ/XWzsI3llCuGTmTpZd+cvIJnMDkdZXnwnmcuLlee7VF9UM+ratDx+N+p2JtoO1SldLTrfzxY4ywEQhFMkuD9yKyfJH9cL+wFzfQV+3zxPfhzVfOkKxsCqd0OtRzjB/P8jKGI7ammjBYRL64VJnNtLJknCjs2BvV/tlnh11C5crcOtlWgIcoVgPTa9tI//DUFNJwFLSu5WM2CYgoKSmoWYDhgyHysAyQuWcWlP5lNTRWXoWvQ6oX0lkgtVRhjxObMd50/1QeTzcgl10RinoxgGtUpBU2uED5EfDkwZ8rOPu3KlNZff7+H+uw+jTSGDmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5bjWtbAOpJ7Aig7RtAvSzZ2zRHsOKvf+xpWK2kqf/84=;
 b=Hit4FbRtwJPqLVAVAQMfdGVsBXA6YXoaP5fbyegMPoUNnLreZIfrg9lbwMpIuEK5QaOzRNUgMcaZV/ONc7Yu3U9ua39uv/djiSZCxcIXpNuTeVjkMaI/ktOnBzO+OyNShRHZH/E4Vqc5lOMTsP7oh2JjWXzHeDZwMBfiK6dds8s=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0247.namprd04.prod.outlook.com (2603:10b6:903:3c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Thu, 10 Sep
 2020 22:07:18 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7%12]) with mapi id 15.20.3348.019; Thu, 10 Sep 2020
 22:07:18 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] scsi: Cleanup scsi_noretry_cmd()
Thread-Topic: [PATCH 1/3] scsi: Cleanup scsi_noretry_cmd()
Thread-Index: AQHWh0Wjb6SHiqQDU0OIXWjloEHLWg==
Date:   Thu, 10 Sep 2020 22:07:18 +0000
Message-ID: <CY4PR04MB375194FFD7BBC9D51B44F5E7E7270@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200910073952.212130-1-damien.lemoal@wdc.com>
 <20200910073952.212130-2-damien.lemoal@wdc.com>
 <34de7f72-3b26-951c-8f09-cb67c3583538@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:dc48:bbfc:f5cc:32c6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 867dcbc6-0747-4a85-cd5f-08d855d5e233
x-ms-traffictypediagnostic: CY4PR04MB0247:
x-microsoft-antispam-prvs: <CY4PR04MB02474424CA9DC9D5A0D79471E7270@CY4PR04MB0247.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wBDw3Gqhl8u90iLpYrc0bTFyv2kjUV2cumosqpOafodPbaXT2EvhUud60zL6kB0RmKctYIpm54cya5vh4nzvWX4HO5ALJdplbFapHcbmEFmiMKc9eV4yAQ81rFSolMt72trVp6zXPBixh7n4tMo7+6738AnR16MrWhugofj8czIIkh84HZ4k2s9KYV5D44wjr4WlQTlK4m1hYVvLDkNvyA2l4TzhaA+v+wmzE4WmbmR/QdMKftF2qbAqpXV8DAc35d0kV0w5V75CL4zqE5YAF9NDVngig9oKcChhIRZHpkrNpSEpbJQReDfmj6vCo9Wb5DiVr0DLLg6wujZdwPFhDA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(376002)(366004)(39860400002)(7696005)(8676002)(316002)(53546011)(6506007)(33656002)(83380400001)(478600001)(110136005)(66476007)(2906002)(91956017)(8936002)(76116006)(64756008)(66556008)(66946007)(66446008)(186003)(52536014)(9686003)(55016002)(71200400001)(5660300002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: wPy740YdykhFHLVoFZttKcwHvnGzmEC0YzixRU71JFue4cs9vwf+YH2zRC2n8u/YDWTkJNThHga5OTydtzSbYqpQd/7HNctwGiz6DJ5gTrRzsnjYPYVbrS7ldQkb1RV4DLHanB3z7wpO4l9rxX/44hjkXLdxDp+lIsFAi/Hpz06H5QF9z9VxLm1AZAIVacuSovMqQqiTv+KOeiHTXXca2uiKC5X/io6mmJjmjrOyFlgKGbbaKr/2M+mnur3MGoOe/UyrUWhQSlXQ2dMHSksr1Ig+EI4S7gaQ7zMohqYqhPcxCCe2IOKBAsv2yvLWcD2sNtqPM0dShlBllQ/DVOx8j+U7hGU3kUTe/awcPPsFmONn7nICH5VaSx7quy5lV0El1WBf7+BrWxHe2y5CCKeDqO8dFbgbqTu0u/cKMyN3AjiLR9sxDd+B4abfyrW0DT4kdGmyeVVMxr6D/5nOyxQLNRfjO9/IzbIKKAAH+oeoqJ4TGl1rA9IdZ3ijWqSXS4SCJmuTQ53001vy7+DD1OEjShhC3oY+eCr8kSDKLOGIdZNEuD7eIu1hAWpAG7/3tz+iUcoe0fOxEEaMEC/8Uu7UVTaJhFFDQd4mmIDvcAy7ruZuHt74ll79CWDH0oCPhPCj0RZrbhiFWHbkeLvTlx7ScwDBjYc0uwbyoRgNemnFe+HTzoaiblHqGMUViPtXoDm1Ax2K8Vy1A/9aQKJLyA2xzg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 867dcbc6-0747-4a85-cd5f-08d855d5e233
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2020 22:07:18.3436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZIepMZE/+DUnEHH6i6dkzFEzXctZZIcPrqcBINEmQU5gPBZwi9QR7y9jEo79rlbC9MUC8TVMQv7ij/JpZb6hOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0247
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/09/11 2:48, Bart Van Assche wrote:=0A=
> On 2020-09-10 00:39, Damien Le Moal wrote:=0A=
>> No need for else after return.=0A=
>>=0A=
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> ---=0A=
>>  drivers/scsi/scsi_error.c | 4 ++--=0A=
>>  1 file changed, 2 insertions(+), 2 deletions(-)=0A=
>>=0A=
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c=0A=
>> index 927b1e641842..5f3726abed78 100644=0A=
>> --- a/drivers/scsi/scsi_error.c=0A=
>> +++ b/drivers/scsi/scsi_error.c=0A=
>> @@ -1755,8 +1755,8 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)=0A=
>>  	if (scmd->request->cmd_flags & REQ_FAILFAST_DEV ||=0A=
>>  	    blk_rq_is_passthrough(scmd->request))=0A=
>>  		return 1;=0A=
>> -	else=0A=
>> -		return 0;=0A=
>> +=0A=
>> +	return 0;=0A=
>>  }=0A=
> =0A=
> Is this patch useful? Is it necessary? Or is it just code churn?=0A=
=0A=
Sure, you may consider it code churn, but I prefer the more positive view t=
hat=0A=
it improves code style. And looking at it again, I think the proper change=
=0A=
should actually be:=0A=
=0A=
	return scmd->request->cmd_flags & REQ_FAILFAST_DEV ||=0A=
		blk_rq_is_passthrough(scmd->request);=0A=
=0A=
A lot cleaner.=0A=
=0A=
But no strong feelings. If you really do not like the change, I will drop i=
t.=0A=
=0A=
Best regards.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
