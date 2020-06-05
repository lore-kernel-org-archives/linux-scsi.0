Return-Path: <SRS0=+N3d=7S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A9CC433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 17:01:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4707C206DB
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 17:01:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="qZetru8T";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="EnFBrK5q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgFERBM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Jun 2020 13:01:12 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:28153 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgFERBL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2020 13:01:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1591376470; x=1622912470;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OtpMg8hFwAbCWWOYjwX8LrdkXX+6NddEj1gETC8ktPQ=;
  b=qZetru8TUe/6cwTY+2/kE9fXo85zpD7sfEG7lNYaNHFuu5GUOtAgYjJP
   3oX6Ucwx0eX123ojt3z9Dn8bEg19Z5hPMp2iNM9Nixhv9IvDVT3nzx7or
   rZcOEyj97hOTUtqD0Hr63ZOp4bY8OGaLMOUdRGxZK7GaYmxvh5EfRPUiE
   XVxlD4EB3nPMiyYVg3UBQxXoR7sGbr0nYyBJChZ3EFtnis0M16snQzzjL
   krem201rn+eIgRyoaSSdDW0Y7XjKi0EIygnAAIDpo4n7yibehuGSw1Utj
   5PL2mEiWoZMlZEd72DBumF2ppgyGrmp/QOoCUlwa5Sa+B+AWTkAyxesu5
   Q==;
IronPort-SDR: 3V6wv6aKgm4n+h/hf4c6qnQA4yhUTyqnKxrdWDaxMuG7DA71j9eRQmEEAAe7Qekio7v30oJ59H
 lyu61f8UtMnAMS8Zr+ABddAmPeZDWxXNrR4P/pa2y/4mtSOXygJgOBpLD/fM4MWcA4Jn9HNjCG
 8vHWUuCp0qQK744GBsY4v/MrUQvPpRFJgmsg2qn2U1og+j6IuMODq5g23zGdV501WTaQTg/8ko
 9VJkPMChtDUqRY6egXKmdtaOifZezIPAswjtDqNy5rlQhHvC/fvDAugGQqdjmQZcZJc2kPg9OC
 TFQ=
X-IronPort-AV: E=Sophos;i="5.73,477,1583218800"; 
   d="scan'208";a="77515659"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Jun 2020 10:01:06 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 5 Jun 2020 10:01:05 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3
 via Frontend Transport; Fri, 5 Jun 2020 10:01:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VqJndtHwd8FuBwH99CpdtW+jEDpM3LLDy1JkLVfJp30ozDHp5Z046ummq8kThJa3DhZ0cqqoDtuMHvbjEfHJ6/15Hd8dVM11zNGmvEHW32v7u9mzNGe4/kFidwoBuIJ7HoRf0DaKJN/0Qke3F15wQGbr4SFv2Z8+NG+MQIlf5c+m/ClLo1/U2XLXezbRe6pAQn4/2pnjWVUvSr433rdO53FSA4SAMibXcu9ZOw2Ih20CM9bw1flupdgFGoZCqamMohhgZczPf1vMbXS0blvhkJ6Xd9t/zOiaYoClEBO92gGx9yKF+KFabAvUVlXBclC+sUIvl0B7PrTv2LV62Rvy/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=48P4NnGkWdWpbx8eeSHAkPdbk+c1UhEy04L0Z2YEy+I=;
 b=gKLQ2zESVCCS3+DT05X/+8nwM2W7DPovWIozwIAVj9vqdtRIxe+MNc0PSQG5tODqFqONBDfWQWksq1XnrJPx8wZ6Q1IOKZBN06gTEEOPIcQlLjiHxpkdOVV/xaTv6+uenTVnziRr3vh/KxT7eT6jQtnl775yuBs6S7qWL4UQeaF+SlN3vRye6OYtVMMSsIpI4/76OwGeGnTBqp5Eqs7HPBvH0E784cAi+gBUTzRIAtKeaV296Fv8amaRV773q3ybMT0BkcR+ZtIa3eFy5QJ6jmjNkUNDXJrBZsQZy1zOlC9VhSTg2tWi3Ext5jFZJ9ffDN0i3pO/1L76d2rBNo2a+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=48P4NnGkWdWpbx8eeSHAkPdbk+c1UhEy04L0Z2YEy+I=;
 b=EnFBrK5qAi6zT4GFi2n7geCBCeSaRbvNZoXaNSOi/W019BV19eDsACFmLwC6Isk1eQSEHvrRC/088jC2OMjVZBbOQyrkk9aGy5ebpaqe8Q4Pnnk47uqlBDasx1NA5cms83h+fHDXLbjpLLeZ+XC9ESaTwQtWOSqa3o6rdsZ+wLc=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB3264.namprd11.prod.outlook.com (2603:10b6:805:bd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Fri, 5 Jun
 2020 17:01:03 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::5907:a4c5:ee9b:8cde]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::5907:a4c5:ee9b:8cde%7]) with mapi id 15.20.3066.019; Fri, 5 Jun 2020
 17:01:03 +0000
From:   <Don.Brace@microchip.com>
To:     <hare@suse.de>, <martin.petersen@oracle.com>
CC:     <hch@lst.de>, <james.bottomley@hansenpartnership.com>,
        <john.garry@huawei.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH RFC v3 00/41] scsi: enable reserved commands for LLDDs
Thread-Topic: [PATCH RFC v3 00/41] scsi: enable reserved commands for LLDDs
Thread-Index: AQHWHvI16e8yEMfm40m6UaRagmZt9KjI9ulwgAF97oCAAAKugA==
Date:   Fri, 5 Jun 2020 17:01:03 +0000
Message-ID: <SN6PR11MB28483D5AC2811689A8EAC36DE1860@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20200430131904.5847-1-hare@suse.de>
 <SN6PR11MB2848512EB578D01F981F8705E1860@SN6PR11MB2848.namprd11.prod.outlook.com>
 <1331858c-6111-aab3-ad6e-16e27661a35c@suse.de>
In-Reply-To: <1331858c-6111-aab3-ad6e-16e27661a35c@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.211.63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4534f610-e220-4cf8-95ab-08d8097207f7
x-ms-traffictypediagnostic: SN6PR11MB3264:
x-microsoft-antispam-prvs: <SN6PR11MB32642B7DCF30DC185BA1C52EE1860@SN6PR11MB3264.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0425A67DEF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YvuUIfy1ZUCSiBbjAyaukpwdke2g8/uQsHVffQO1WPQC1DODjGMgH1UoBknPNc+mHh8olKedvLFTmpnIfYOEfBhQ8GD4DNX5JwSLASz7GvExiUa0Ba6bUD3SqhuXDG6L8Nr98sPVWlzbmNZK+5s9kv6Akimt6Ji6RJGJzIW2IarwDZZCkyXkPob0H8nVdFsXNEnaHdQnXtDmqD4Aevr8CaZt86F7kMeXMPG9aOZBA/f3TX6cAPK1fIfkFZrrEyB/KTsIqvcMuz0UBH65+5kXGQvu6GCTefS2bpJ2sFGG+wSkYcAIzpMMr3HWh5Xw6FH1jr59jAfN2CLzOf0PZFvwag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(136003)(366004)(376002)(39860400002)(346002)(316002)(110136005)(4326008)(66574014)(66556008)(54906003)(26005)(66476007)(8676002)(8936002)(71200400001)(9686003)(2906002)(478600001)(6506007)(52536014)(66946007)(5660300002)(186003)(55016002)(64756008)(7696005)(66446008)(76116006)(86362001)(33656002)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ZqeGbFF0FOnOWfQxzfXy/M1QrBP5QtzXDIr5m0yVOuxgqEY0yswctWCgnN1ltx6nFIL757aaizIjEWpxyIlU9S263hm5JP1w2eTPNz3uTi+6rnFm8ZyDu/lG6T9ar19VOI4QlJBmmQxBzjl9tp2ywwk0INSSAIZXivSBO4SHrFRd9m+CqvgKfE0fwL7V6wja/1aS7YG8Ad7+LX99otnbKtfa1r7wu/Gmm+4wqztz+4kvZewFv1N2qrPp1+7338cIwhr4VwDYKVNgOYHE9SmH0D5DzozAhjo1yvpq0BrhICqrDxiHaM2kBKg18vGSMmOZLZfSGMP9j6D4cC+h/W64sRsRzL+w0NTFhNv3Ik+4WTzzE2uUN1LcKlAZsI0aSvFkWBSOTiq8TbLFVZfXSiPjzH+rMyC1xTXPGh1c5cdzUDPwBb7dZi9Pdf2owqIKrQh9AqLXU+sxpO+O0W84jhJOU/sk6weX4RUS5Xj56IgEFTc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4534f610-e220-4cf8-95ab-08d8097207f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2020 17:01:03.6203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jo1n0jdrqwwEXbBxcpDElY4b3eujATNaoLcSIX2jdVP8sM4hDLhu8kEnd4sd3ie7JGzZKfPf/rNxMEFfZBfC8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3264
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Subject: Re: [PATCH RFC v3 00/41] scsi: enable reserved commands for LLDDs

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

> However, my insmod/rmmod test causes a kernel panic.
>
>
Ah, right. Of course.

Should be fixed with this patch:\

Can you test with that?

Cheers,

Hannes
--
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=FCrnberg HRB 36809 (AG=
 N=FCrnberg), Gesch=E4ftsf=FChrer: Felix Imend=F6rffer

Yes, I'll start today.
