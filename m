Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7BE7C10F29
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 03:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB0ED215A4
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 03:48:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="i7cjaa4x";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Fdl9ciNr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgCKDsF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 23:48:05 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:52667 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727659AbgCKDsF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 23:48:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1583898485; x=1615434485;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=HTX1YJZYArn98vtMKPz+/XNH0ZAzYHVgJmpvlXbXyC4=;
  b=i7cjaa4xVH4y8ufRLoLGz+oiObKaMOiaHyMUKg6fXaXicCsTVp4z7k3f
   S4ZBjGEBL3UdRGoViCI65QZQqlW1kRXjdjXvCGIdVjilsQHtcFPZ2HkTR
   WdILfEZftam2ElVjGWETSH+Gu9ZH89EERpZ6RH3390IXS4eHL3AjeFoye
   9GIemmhC/SztyQEOF5I3ndjmh9GWyRTHSDfRFV9BILxzdvo0TLKcKBXbe
   5GkjYvB2uOkqAtDr3ZJaa7A6SoYTbgF/V7bxrudZrgAwENBgBD23RB57q
   n08krNwLzUz2AAqTx0A/zCDH3OfAVf6v4rjU6lL1oDb/Khk47rYtLtI72
   g==;
IronPort-SDR: flAW0wlUXdOlxJP17y9mqPYTaM/M7NvWVdwBBAYowd5kFLgeJUm7ZFDbf1+Syimu2INe1MUS+F
 b7Cz62hzSlr7fzuy78fXBYAFw+P3uOqz59+Jg7oLVZF7JHUJKXewq4AACNDUjF/eKbY+vN3n9A
 4qT5ApLKeQdhfHlOit2SLc1KUYhm4KT1/jZhX3GJVYz3LMmjxIdPjifmm1zlX6v7WE05AQxvZw
 TzC7dEQ8AoO6XD3Op714gLW/cJ71RW1OzGsGVIx4UO98MBDlXXXrU5j97Q5u3mfcsxGzQb4npS
 1Os=
X-IronPort-AV: E=Sophos;i="5.70,539,1574092800"; 
   d="scan'208";a="133584651"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
  by ob1.hgst.iphmx.com with ESMTP; 11 Mar 2020 11:48:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jCq1ItM74jvZmevWsIQSUUgD3OpjrorWta2WonUCyP3wroQBaGHmbFG2VGvEKHe7W9Z3ItyEQBzfxG/0a+WJsGHR18Iq/ttuwdOqNILuJ+R/nb6v+3fiVYVDHsPC1MX7TUsWAO11LKfq9QxeIp83Lj1xaJuYRSnR0vWFonvAqrwo6LbtIK1qY2osq3XWTi1sn8TO2UWmp8WGwMVLJakl1yBneJR23fp2RkEEaFFCHPKEVEGvKy8Jtlq6fM2y60ybaeYylB4APkYU3SiEbsYoUELG0Ud4PU8Qz0TL9STEHBCPuzgBQGa40dN9DkRTBNPxUXhktUmTZEbDFnO51Bj+vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=prgW4ymH586Jia4Es0jVZ7qxUIHePrDqjEHhfGRQOn4=;
 b=IGezAQHR5iMdOmLpWNW8qzliRwRr6GBdP6/FheasfG/2LfuT4eKQTIEdbd8fN0RWYvqy56mUh5b3KKH+mkITflnb/q4iNWpETnswOjfpLBaqflZ1nGtu7L+ucHZKVZvc87pnt3EgNmCrjWWBFzbWIFmkjroiEK46nZ8EMjeKiV8TDg9oqfGMqEjdcmy+Bt97rWT66cSFPT09NHRqdSgP9ENwkOFAxA8Ow5/qJHqghZGMd9ZAlGmq+jh36tuCIhdVS2KiLumzaqhlE7M6AT0x7/7iVHOLuI9CqhsSfWMPBF0stYrKO2ybXW06F79D7H1Y1WF/Cc5kVucan9I/aeZzZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=prgW4ymH586Jia4Es0jVZ7qxUIHePrDqjEHhfGRQOn4=;
 b=Fdl9ciNruiWyg+lhv7ZZi/dhn8RafWrE6p8YfId/DKcJek1C8fYBUQ6vfTLiinrly7fu91XNL7KoyQqZ6GS0VaEx6xmtYFSAlDdh9inbc+H0EIBGzBn5gqtdFjBZiekjB2lXY4mDjjfXice8S32LNkd05PlWT/Ngl7NJi6lbTWk=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (2603:10b6:a03:10e::16)
 by BYAPR04MB5400.namprd04.prod.outlook.com (2603:10b6:a03:cb::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Wed, 11 Mar
 2020 03:48:02 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::6daf:1b7c:1a61:8cb2]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::6daf:1b7c:1a61:8cb2%6]) with mapi id 15.20.2793.013; Wed, 11 Mar 2020
 03:48:02 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        Ryan Attard <ryanattard@ryanattard.info>
Subject: Re: [PATCH 1/1 RESEND] Allow non-root users to perform ZBC commands.
Thread-Topic: [PATCH 1/1 RESEND] Allow non-root users to perform ZBC commands.
Thread-Index: AQHV7MkPT+ILs7gef0yFYcD78Zslhg==
Date:   Wed, 11 Mar 2020 03:48:02 +0000
Message-ID: <BYAPR04MB5816FF7BB34C0E94CCB9AB86E7FC0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20200226170518.92963-1-ryanattard@ryanattard.info>
 <20200226170518.92963-2-ryanattard@ryanattard.info>
 <yq17dzrr3gy.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 99a14f2b-63ba-4eb2-eaab-08d7c56effac
x-ms-traffictypediagnostic: BYAPR04MB5400:
x-microsoft-antispam-prvs: <BYAPR04MB5400B035749AB7321FB26CF7E7FC0@BYAPR04MB5400.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(346002)(366004)(136003)(376002)(396003)(199004)(9686003)(2906002)(6506007)(86362001)(5660300002)(478600001)(33656002)(54906003)(6916009)(7696005)(316002)(66446008)(53546011)(91956017)(66946007)(4326008)(26005)(186003)(8676002)(66556008)(55016002)(81166006)(52536014)(81156014)(8936002)(66476007)(71200400001)(76116006)(64756008)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5400;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R7cLlWi3cwAXjgxLBa30wNq+Vaa+UHwZfFSWFE3Rh8peKiJsR6Mc5Yl7KvE8ebai7F/GRslt1RjwKciWx0eLRNukjY2UhoEbeJ4QIFBrNPMx4u4Iv0uimXUAvCMyhLO302VSHqGhgt5j81ppjdrPzBrhIvdH/17w69hIbw2J4Rabqo9oArhPLBeUNrtc2eVwQjdfXX7yX2dQE/vNyHA/w5Z/ulbk8oQENPVhN+qtJZN0e5ukwLo0au3ImrJ8XuDmxagR6UCTn6hcDyGDzbRPLTOzoabIcwScufIcppN2J7kfhT1WRZd79Ju8be3fM97SomesbBfSImoYEdOeekgZbAMjsTPYybzU1pxt5DJqDFGFJlj2vW3qcnHV5F7BrGYPIBPTEmXVr/tywJK49IgUnSG78wRmuPg9DqjLluiPg8MfUB9ndcL7I2gI/cmzTVQJ61DRyJZoMOa0gfru8KioeSND/i+oV0YsQAnAnvF/KcjrQk2kbE5qT1MMfriQyfTb
x-ms-exchange-antispam-messagedata: 3u0ypyd8g57Y0Dq/P9/ZH+MYjjlvjHDBYAIFYtcyBM4bxS9yaeiAUTzVTuTaDw8hDazhuGkYmtLPf5qVmsBh6mfixGThzfEVxXGfsqleZemFQwBBVk8ixZEIJ7pCw0d5tuu3VgrMTxzNQmwyesOpGQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99a14f2b-63ba-4eb2-eaab-08d7c56effac
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2020 03:48:02.0762
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oGkBwca2bR9NWaeCzIe7McxvjfCT4TDDijOLkgPDf97p70bv28iiPFy4h90M5nqKQ1LDnLVhj34nVnnlK/B0uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5400
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/03/11 12:10, Martin K. Petersen wrote:=0A=
> =0A=
> Damien: Please opine.=0A=
=0A=
My apologies. This one slipped through the cracks...=0A=
=0A=
>> Allow users with read permissions to issue REPORT ZONE commands and=0A=
>> users with write permissions to manage zones on block devices supporting=
=0A=
>> the ZBC specification.=0A=
=0A=
I think this is fine for SG_IO ioctls since other SG_IO commands with an im=
pact=0A=
on the device data (write) can be done without CAP_SYS_ADMIN as required by=
=0A=
block device file ioctl.=0A=
=0A=
>>=0A=
>> Signed-off-by: Ryan Attard <ryanattard@ryanattard.info>=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
>> ---=0A=
>>  block/scsi_ioctl.c | 4 ++++=0A=
>>  1 file changed, 4 insertions(+)=0A=
>>=0A=
>> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c=0A=
>> index b4e73d5dd5c2..ef722f04f88a 100644=0A=
>> --- a/block/scsi_ioctl.c=0A=
>> +++ b/block/scsi_ioctl.c=0A=
>> @@ -193,6 +193,10 @@ static void blk_set_cmd_filter_defaults(struct blk_=
cmd_filter *filter)=0A=
>>  	__set_bit(GPCMD_LOAD_UNLOAD, filter->write_ok);=0A=
>>  	__set_bit(GPCMD_SET_STREAMING, filter->write_ok);=0A=
>>  	__set_bit(GPCMD_SET_READ_AHEAD, filter->write_ok);=0A=
>> +=0A=
>> +	/* ZBC Commands */=0A=
>> +	__set_bit(ZBC_OUT, filter->write_ok);=0A=
>> +	__set_bit(ZBC_IN, filter->read_ok);=0A=
>>  }=0A=
>>  =0A=
>>  int blk_verify_command(unsigned char *cmd, fmode_t mode)=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
