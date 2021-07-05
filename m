Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F8D0C07E99
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 06:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 066AD613DD
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 06:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhGEGUt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 02:20:49 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:62542 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhGEGUs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 02:20:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1625465891; x=1657001891;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ID13VEA/dvIoeRtNj1hQu63X78lfZNUZ65JxOZUUZ4U=;
  b=jHdsC/TWoHji4ppvhi+Nt/T5dsfJj6nWS/ud9GWNMkihzhbv97UBWgkj
   5F12nT1sd/avzeTQwbr0W97QjxmgoMQ/BhzivxKjd3ZN6xcHq12ZBC45s
   X2KK2awVJzGwPhG4JQ+jHH9hTUtgXVCmjUhtl6naF68yjvpKVi13ssNl7
   CGqU0VEWizC2cyye4rx635Ah00if0oWBFJiF0O1Y7TpEbH68LTDn5G3AM
   joqVS4nKQvSG+0pR4xrtxpCQ5blTwrWuH+J4SBts+KLZAFNfzzvO7K3FJ
   YIIXBVU1isOwaC2zKgnjl/SSvjfByaKvDzlH3ezmWGpR1fk6zQbg7UqEN
   g==;
IronPort-SDR: gPP+d2TOPVYGMDwhIoFN3uZVe521yApXFS4WdF19uMMZlcbio7xDhVipE3t/tGJMTnv1hTx+eJ
 JjKruXVlxwuiyJ/rDInwJ600pqHmwA2TIyMt/A0JBu2GRNBK29qqR5tbgQz5AWNcknAc9+ZwFr
 z4aWh1FXwm0OTg+gNI5D3zSzZ+az+H5iWe/UcUszkqSJ48NiXnM5PzOaMLd6yNd3FVvZwZ2CAk
 2g4WZoVR3poQGjMmBvfcaSikvl3gSxuUokjeRqJHBt/35km++/0Q4jPnycdpScp484DO9JJm+D
 Chg=
X-IronPort-AV: E=Sophos;i="5.83,325,1616428800"; 
   d="scan'208";a="178503586"
Received: from mail-bn7nam10lp2106.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.106])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2021 14:18:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AFYdqa0wBs9POagiqGsmCNGZOBwfyMoL3+B7s03P6N5V6fnMXkMhMk7kKLjbWpEKfWdgv7qmpuer9tn5moJxrVktZ9F94Hc1epbOzp5Z25E3jPYQEAoq+syZ77IgUvCD8ZM9S2NZB4IQBHu3T/5I6IHvm+sQtwseu8p2rzMw1az1LqPNzes5KujMSN5dssRtmc4z1YskYE5LxE+H6QmqgYpzLcq9cQLu6cfnLPDRDDNtcWFju1nkHEdEgMog6Uol6lPtVYUfMS6LUcaJ7oz0QlJHCiGnD3RjecClh9RXwl5CN/6bF86aLXUEbSZ6Jicz06A/KfbzSgPHlDbCg7J62A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ID13VEA/dvIoeRtNj1hQu63X78lfZNUZ65JxOZUUZ4U=;
 b=OgvGnNeDz+1B97WrtHR1L+gCwI7BXURlmzqB0CXAwEv6RkT9qB2Mgqz1YTvh8zB9YbtqhPr07afU3mORXyxYL9IPNg4+rqKLPro8ECmPIWzqtp2qajITzzctcfwNnI1mOal6m8Gjc1Z4qU7b9o9o48uI5O9lKJM8206+gxAzH3fe/X7TNFCAwxVdX7TIoSyRaqbGhDLSdFUdWNuwG40lOibxgBZeFx9VLAfNjj11y1B4KoHsAkMiMxGfeFMYg2xj5Te9T8gVG/MUgnT6HHl50Gt3/BZRIdqz6U4ZqlVecb8JghKRthd+tfcyiQIC6oWAQgV8ZNlyUAUPRjLQu/3DRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ID13VEA/dvIoeRtNj1hQu63X78lfZNUZ65JxOZUUZ4U=;
 b=ecKmuP4eku+8o/Xixo1m6XYWIu93kJsIoeoptcdOYxhx3P2q8M+sKrN8iPY/cNBiUClzDZ4BRoivFQHwgTGCmJ6CMDgBzgEuRw1s+JOgwAXlHxtcwEsv8WSUNGbLCOB1TclUWQ2aWUZMaOExsS24dPjwNJJwDzKw9EEi6/DizGU=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5083.namprd04.prod.outlook.com (2603:10b6:5:12::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4287.22; Mon, 5 Jul 2021 06:18:09 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%5]) with mapi id 15.20.4287.033; Mon, 5 Jul 2021
 06:18:09 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bean Huo <beanhuo@micron.com>, Yue Hu <huyue2@yulong.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>
Subject: RE: [PATCH 06/21] ufs: Reduce power management code duplication
Thread-Topic: [PATCH 06/21] ufs: Reduce power management code duplication
Thread-Index: AQHXbr3fytLyarrvrEu1K4Rwp7AUcKsz7Ivw
Date:   Mon, 5 Jul 2021 06:18:09 +0000
Message-ID: <DM6PR04MB6575AC8BBBC1738F46BBF22FFC1C9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210701211224.17070-1-bvanassche@acm.org>
 <20210701211224.17070-7-bvanassche@acm.org>
In-Reply-To: <20210701211224.17070-7-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a948748-e7a5-442b-c399-08d93f7ca8fa
x-ms-traffictypediagnostic: DM6PR04MB5083:
x-microsoft-antispam-prvs: <DM6PR04MB5083D36A88DB071513F983E2FC1C9@DM6PR04MB5083.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tzRAidAni6mgVBLiH7xTCUXcDPRZXJFruqd6LPWnjBnQ3EaRvVIl8/I9c+I0j7yMbF3aYFsYypVd2F9U0Wrjmh+CM+wn+Wnt+ah+NvYmCy9JYPVheVWCBE4M6skP9ERIpNDBuhLYU3aHJi1bTHBz6Gus7yRnSgUadOVmQ7UtUMDSln01W/PJskAFBDGWdlAi7UaDeNV3oSxmkxBEe7ozWBs+Sk0ucP1n9Z99hcF+LenRH7brffwZzF2qDQnHjWkTfWeseaye+pk1iC5P/Q+vySoz1joLTFGmWa62R/ul7rfYkssh9XiWPrK1bg9I2w+bExbp2z1z5EEzBEfnMS21u1MXOhs5gQb8YFqoodRUboQNkNMwnaqdLXu6CVzhDAtxgIKi6T7sK3nCjfR8C+UjSIo5QOlj8Lg1hVCM/uthwykFIg4Q1hm2GFb67Vj8wxQV3rh2+pEkANV/LdHjnHkmRsN53EU68i/QCUIfPzSAQCXrqFeevPONacEmDLhKxVQ1PszbVJZfKLMUTEdSRYtgnpfKHwKj+HGsDnSrH9Emk1B6tpkXQNUPtOnITrYp7NvVehhTD4xGfOg8SlMuG9VDNkGxzfZCvnu4P2F+DL8ip/vzFIl5KXzpjjii65suNphogAaOieO6eauZhWTx5YNX7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(366004)(396003)(478600001)(2906002)(76116006)(52536014)(316002)(86362001)(122000001)(38100700002)(66446008)(4744005)(71200400001)(6506007)(7416002)(66946007)(5660300002)(66556008)(66476007)(4326008)(9686003)(55016002)(7696005)(110136005)(8676002)(8936002)(186003)(54906003)(64756008)(26005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qpGHgrxw4U8O7t25/2KbIiAYtmez4sDAlwxWJYUhC+bmEpCMsuLtuVUmI7Wu?=
 =?us-ascii?Q?NpRdV23zbtXDCs1RfzsYcvnncRXIUlFy+73b12tKhcVcSifkWZ16y+S/gbw4?=
 =?us-ascii?Q?MGVZpRo2BZspDfKBXthYCyPxYum5LgI/pF4sAiBTnGXCV/+4aW6NRkvCC4F7?=
 =?us-ascii?Q?siTLW9hhjDMrJdR68ZSNDOu/g3jWtua3VIYncqEWogm38jF6BniUQ4ilU6mK?=
 =?us-ascii?Q?kDnEoqVsH05GQUA8bvBfEzuoBD4Hzwh9F8N921MypdriW+27xehi3e4ycBwN?=
 =?us-ascii?Q?SBD2H+nl5QBpzIIP7Ksol2Jb+D5p6554N1R2EcsghR2BjOqW3Iw0Rhy7+Dc0?=
 =?us-ascii?Q?LF4sUtA2/0FVAkwioHfguVJsKEhB3LLomyVMckUs0Miatsrz+BL29mkT1GsJ?=
 =?us-ascii?Q?KvHK9gvhHYb0V00tdEUqyVYDfw4brsMuV5augt/+RebeVN/CldZjanV4DeBj?=
 =?us-ascii?Q?5vj5308O6OlYUeryvi0Gi0G3kbw2jSQfvCPJh6RrDbn9DyCu8pHBqjatlXPQ?=
 =?us-ascii?Q?EpeI9wqF0fvCW/9bMJfDojrAyKH5QLtK0dDR30px0AKpGFfmV777mAG6DPdr?=
 =?us-ascii?Q?04Sz2D+2b4dymlXFbQS3Xlz2n5h5UedfulnuyC0mbawAKqSW8nTzZSVmMLiC?=
 =?us-ascii?Q?g9+X2Jrq8yc4fT5KT+LP7kUhtXpPQ/Bma8v0t7o88/ts8yguVtp5UBPi/8qR?=
 =?us-ascii?Q?Fu/+adJwk2EUnkqnSh6y9tQ11ocS8dtLidUJCqtmQeJeUnJewnbPob1OSKOe?=
 =?us-ascii?Q?qTjCIXfWVmdDcOl+LLnZUtv2ZxXUQ9AK1ScL3yQzH5ut9xAUCqlw/avfKIbO?=
 =?us-ascii?Q?2JI2skms5dXyIQoV0HqluPaQDM7PaX4kUSygIBj4v07jWihOf5uQxyC+zxSv?=
 =?us-ascii?Q?lwfs4+i1sMMOoP+w9FCyHcNstxjFNOzbzjvR2fJyr7iecqcd6n2oM0hrljE1?=
 =?us-ascii?Q?Vl7qH37SVAiUmBRiIrFaW6R0FKR4+wbXTm/qg0g+uSy2ek69xbYD+ThtpsJd?=
 =?us-ascii?Q?f4fa4er2aQvb8NsEr5XsJIngAPoCSw3s7iR3ftAdbmqz9ZoHqSr9tNkA4dsk?=
 =?us-ascii?Q?+ICKnDJzU2q8JFVSjw8hsUh12naVPTz2B8RzUC/6dZDdM5lYJxB0NJazrDTu?=
 =?us-ascii?Q?b+LxvSnoHULWqV+pHD1c6t1cW5bXwkq3U024sC1yWxbzndup5BRbHGkwX4aK?=
 =?us-ascii?Q?97/7yEL+a79XWJY48lcp8tAQfgs7L6fx5vAbEPUUV30I66moMdCkCx8U3TP9?=
 =?us-ascii?Q?c5+5hR5bbxWxw500W2W4HVwXT/agEIMlC2IAM5ageKOSnXSuMKHQZ/goXaXA?=
 =?us-ascii?Q?vQm7+a4RKEA821330wSjcmUZ?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a948748-e7a5-442b-c399-08d93f7ca8fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2021 06:18:09.2051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JsWGv/Lj6N8wLiCEjvFEKticFqcdqUXsiuJwLMn+8ygJl3+n9tPjRXccNp4UVyEqNOcpR4wOw1Cjf6IIill4hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5083
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Move the dev_get_drvdata() calls into the ufshcd_{system,runtime}_*()
> functions. Remove ufshcd_runtime_idle() since it is empty. This patch
> does not change any functionality.
>=20
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

Thanks for this cleanup.
Avri

