Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC5CC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 11:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 772E164E28
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 11:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhBQLTR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 06:19:17 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:27191 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbhBQLTP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 06:19:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613560755; x=1645096755;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=7coFM+mGE/VhYujmgb5381CD7SxFMAtO8g+MrZIBcYA=;
  b=M7Ul+mUC6nEqpCytz1O8jUFgM/GhakW7ADRP8IMIBrImCYTEpg8IJUhs
   AtssuHuw1Je4Z3ts3/vWtT6jRFPSW4uEyfx5wbmI+61GIw5SmQ4WznJD+
   f+Iz9MN2U8fU7klcOSH9aqhzr+qZVmaW/5QOhznN/LpnVZ+ocZEK7P3nE
   kIn4nrdBlsO7UP3SyXXvtaS0qLDuFU/pSl3flR0imjPjRvHXt4qjCFx8B
   0FnIb4y1gBbsIuufv9UKU4+FyM3zgOXg/rSFvQBDY1m8XdGVHvvZATLIr
   jfH/1liX4CotAv60jAMPM5SFI01VjAXaOfP7x+zSUZRi2lnBobZSngQqh
   Q==;
IronPort-SDR: azwbVfUxlCbiJHopuET9f02msEzZB+EBpeSgTIA3CRFsP6tScHHFWUJx1E2kwarXe0/tDhRWC1
 suNKtZHXeFNLS4QP5hlteKObpMap6O3kZhB8mDgGyeupyuyZs8Tets8Yd0NP9O3ShWV2H0ECEr
 2JxidTl6/d4MqaTzQxSnhhzP14RGhIKn5zNH2OlnvA7tGYBDtR5gtNYe9cCMXEWrifHxGC55NM
 JPJiximciwwgkrivqCWZEwJMBbu4kPIa3jhO390hkj53h3gXIhv+GICjZ0VFv0215PstV7eDJO
 vx4=
X-IronPort-AV: E=Sophos;i="5.81,184,1610380800"; 
   d="scan'208";a="270677410"
Received: from mail-sn1nam02lp2056.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.56])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2021 19:18:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gj1t6pcU1x0vBsSn8Mcw56lsUdP7s4W5jnb/QewgHqtw2ScKX5PfZ16YiAbkfM7YLk/g4fy6YLPPWwZOsQZm4mQ+S1lV/EHWdOPQ46Z1WxiU/HA3Tx/pL151QTazqv6jPFMQXmRviNfCbOsuzTNcFW5tBnJ/Z2F9JhlbO6iJgW0FkftHA28+4Qw9HY9z19Jbjjihsq1wyku97g0fjwr751JCOouwKHJd0/Ok2u/8e5I9kXOOSsklINCFBj5vBLm45LBV3NrkswvK478Pi704IOsY1b4ROY2XHdiDriWLch0sWQnOrQHkGregxyjirzNTKFdN6EdIdH8JgkoQGnLo2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e5qTd5+H8X7QTMh85/k5VZtHuxRNg+Gzwh8z0p21cAc=;
 b=Et6y64wrI3c3SKrjlM4fDwQHDp0nqn92VlCUdgJGNDsclOewx6/5cuqrNPIomp67jxOCAETGz2/qJfoySa0/WA1saC+5GUp0xfpcEFmsAuNmT+rgSyF96+cH/uG62DkIUCoI3xZ1FpiHKNeTkmNadLMKUXW1EgaKtrvAHGpbf3jsrUxOi2Y5b+aa3N41NCgXIa7WE/8DiuBzpWWjdIDG5JOiReoanwKoHraZrTdDFmFFvKF36KPfXEgNDWvFxTmadNS7s/3qoGg54KiqJjakX0JK+88tT9VCgRnBA7GVoJmajFAiht/wahRo4GsRZBrzjsgJ/QYnyT6AIgvtFxnSAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e5qTd5+H8X7QTMh85/k5VZtHuxRNg+Gzwh8z0p21cAc=;
 b=yAq0IOkc8SmaQ6SYylSe2zdsLL3D2C+gQoUsmLG9OlX1qOT9OR5B6d03acxWcgF5KKtM8ZH3NjjhFu4TJXTxxlGWADUvYL3oohxzoROFRTuuh0bGy9Dac1AaBY3RofpaLHUGCXfLVW7pB3qGSlV9uUW94MGlFYoNo02utCipaqo=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB3885.namprd04.prod.outlook.com
 (2603:10b6:805:48::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Wed, 17 Feb
 2021 11:18:08 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274%7]) with mapi id 15.20.3846.038; Wed, 17 Feb 2021
 11:18:07 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Michal Hocko <mhocko@suse.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [bug report] scsi: sd_zbc: emulate ZONE_APPEND commands
Thread-Topic: [bug report] scsi: sd_zbc: emulate ZONE_APPEND commands
Thread-Index: AQHXBJuZNMPC4HbBMEOENoattX2qog==
Date:   Wed, 17 Feb 2021 11:18:07 +0000
Message-ID: <SN4PR0401MB3598156D81DD8545467637579B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <YCuvSfKw4qEQBr/t@mwanda>
 <BL0PR04MB6514D3538AAAC001084C213AE7879@BL0PR04MB6514.namprd04.prod.outlook.com>
 <SN4PR0401MB3598A07D142B475A90BDBDDA9B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <YCzN4qPicujdSJ7P@dhcp22.suse.cz>
 <BL0PR04MB651453A8B57118B3C1818ECDE7869@BL0PR04MB6514.namprd04.prod.outlook.com>
 <SN4PR0401MB359823B2D42A6E31D5F6E5369B869@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <20210217111634.GL2222@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1542:e101:1923:7af3:ae74:5873]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3cd1e2c4-2044-4aeb-b81f-08d8d335b401
x-ms-traffictypediagnostic: SN6PR04MB3885:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB3885BD3088575012D2B99C479B869@SN6PR04MB3885.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a+GtiHNlamMyQrWXFMH/CX6rV6l1sa9PNlP9tQSFSB9yAhIZZxqL8gSFqL7MDLK8n/PylGUD1EMe8fcRqjWufGN56XTnhj3twz1RzVuLgNsFKjSx2turHrtCqMfzPyTNOE5y/jwe9q4fr5KaIRy+e+Lnl57eym48iptXZQkJofUzXIceY7M/lM8xt0INjcOdA5+9DUakTOmNdr9SFqU/ujQwMzXaHVPgp4wmMQgGf7hv2odiU/QGkrOVhrLR0Q1+p4HTlwinZ4ga3ni5U27pz84X3EW6SsLBI6Zw/6mVMzRIcuYHljjxTyQONM+8Apz6G9ZRSbU0h6o9BKmEP4ixNHpPcs68Jr0jblk/Wy0YTwLLh/fSQyVqLcSzs4Gku8uSYTJFhHur8yQMekDiimPJKzId+oReivHk6iU5LErmdCyFuCa70xEHajUtvunIhOYF184F4cdFVT/RiXFNA8Po2OTbACYoUiByOePZ/K8PNDwMBNne0YX515s9eG9NTBDR0rlDw3Av66wVOQX34Noohw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(136003)(376002)(396003)(66476007)(66446008)(64756008)(66946007)(478600001)(186003)(4326008)(66556008)(6916009)(52536014)(71200400001)(5660300002)(54906003)(8936002)(7696005)(4744005)(33656002)(55016002)(9686003)(76116006)(316002)(8676002)(53546011)(6506007)(2906002)(86362001)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?F8RKifyUD0kDXoc2C0IW8gAcKfobhfSGY8v2hhQVkGdhKMECLi4t80nqt0ba?=
 =?us-ascii?Q?T1AEc01L9KBH1JXQ9hpfVfoCLl0FXOc+iiH8Phc36ob30kxCbr5HxG3fbyPY?=
 =?us-ascii?Q?/kO7L5+oTUqqKl5Cli7Yglo09VclLMPbd7cQN5eAvRyQ6ilweUWJAZWzrk/i?=
 =?us-ascii?Q?KylaEi8KpMtkVbDG9cGuSmpMa8ANWKqFefYHDv9MDQQo0iC56YOmQKjWVfb7?=
 =?us-ascii?Q?R8zjhSaXxJ0D9SjMPhFx/H2ay6H1tL/QulCl13/BKPE/ylVtM9cYZsYoReka?=
 =?us-ascii?Q?3GrfZjVsgeHyPcgUTb42RjuU4yE6WcE8tcW9wxXBUGsUn2kLHrq/oWiP8qr+?=
 =?us-ascii?Q?VtYNL8AyBxpnLvKb48JIpI/3tG8pvJ+1g6ZOFyuMLgYlctll/QZ+2nBc6A8D?=
 =?us-ascii?Q?hnsP02l3j0HMu+oxy9U1dFnZs2tRN2UESZjx6cC8n/CLdv+snt//BudrGRKH?=
 =?us-ascii?Q?3ixyMqOkQopJHHVsi4gm9OnuTIeamcZkN9MG4u9mFX2EWRk59Bf3oyihhwL7?=
 =?us-ascii?Q?v3jHjH8JgFA22amZMlAHgE6Lhp2FegiASqiXiv50fBCV5p5IIOv++6B40N5x?=
 =?us-ascii?Q?KZZDtPuzqSK5JJVtLIbP/4PYYETl5aWUUFjTJ7lpjUYAqE1eu7SqLoufVns1?=
 =?us-ascii?Q?CNnN59k/1wa1BK45TmytRW4tIp6RHHs7/Y4pQFxPJki8UKqNjCW9d/PPochL?=
 =?us-ascii?Q?ydBR58Ry/Nov00OiVNP6iv3itj4+/J1TSueCy2FJVGXwByGv5hRU6DaVeSyi?=
 =?us-ascii?Q?LC+S2ZcjGq04IixinMhu4ik3fwQPcNrRA3EhXaf0jOSvhGWKpqX9TCgeeGXs?=
 =?us-ascii?Q?e9QlOKy6DS5zn6SclzE7AmnyD91ZI4KaxFa68AhlbBCngBymGo+L7QiCynHP?=
 =?us-ascii?Q?vJ7KQfUN0x1f3xtFZUJZqDjNBScsu3rO/8VI2QWTm30ol+Go4IsErjU1hEi2?=
 =?us-ascii?Q?25ckU/Hgxo0bfZla4d2E6jmPaGFtCc+4mmWY2a8m8CfT/6HrAX4dhVZyq7mn?=
 =?us-ascii?Q?Hm3fTjJyM1CJ4ypjTogQpaCOexEwTYnxVNsetGsA5BSJ8V3e8ts1SlTIt2/z?=
 =?us-ascii?Q?ltOd082GuXJit+zSxGRTzyh3AZu7MtsYnHyNIoUKxuz+VVovAw9OKfPAC3Vc?=
 =?us-ascii?Q?AgddOk+Gp5CZGFZ8jwOIve0ulddf/ik5Q3n2h8v0IlbIl2EipJg6WeNeBMM0?=
 =?us-ascii?Q?IkFyN7HuNHuC4ACoxtlgQDKRxeTOkLrmDfybVPx+Fdx8lYpa/K+t/HX0rWmZ?=
 =?us-ascii?Q?ARdpfJCd6a571AxFXhiqjQE0XBDTErjk+z4RhPxWSFIo5lG5hDGt1W5re+sh?=
 =?us-ascii?Q?ARrweUYxQGv71H1+X+WMyL2Id9eMZEk75GLVQTUmeWhd8VR0Mm7D5shHyHdC?=
 =?us-ascii?Q?V/zt+BJ8RfZ1QHWcngdw5pCqPsQpJ8Cf0PZ3GTwXrDLdEagT4w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cd1e2c4-2044-4aeb-b81f-08d8d335b401
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 11:18:07.8294
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XwOzrn0PcFkcli9vts4ZNPUuuF7H38uOZvwQx4GrzsTn3hG0aSmuQq6UTiUW/CGoWwW2BTFm6B+G2ZUAjNDH57Fi6r96eS4jcyk+/IoH4CY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3885
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/02/2021 12:17, Dan Carpenter wrote:=0A=
> On Wed, Feb 17, 2021 at 09:18:37AM +0000, Johannes Thumshirn wrote:=0A=
>>  * @flags: gfp mask for the allocation - must be compatible (superset) w=
ith GFP_KERNEL.=0A=
>>=0A=
>> So yeah, we should've read that before calling kvcalloc(..., GFP_NOIO).=
=0A=
> =0A=
> This is a Smatch check now and checks are better than comments.  :)=0A=
=0A=
Definitively=0A=
