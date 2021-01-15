Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F22EC433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 21:18:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02A1F2371F
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 21:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbhAOVSw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jan 2021 16:18:52 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:45801 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbhAOVSu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2021 16:18:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610745530; x=1642281530;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z1uKPxLPuaHc4RzMx1lVHoyGroJr97cWI8zpO8UXYL0=;
  b=FvopEBI3z6UqCRVErr3olRAyT5Io2mfgytW/x6nACiM54wBnihXntrgC
   BOdKtyJhzowk4rZFI5xVDHnE7e52Umq06cRNvkp+FWflF0Ebo5nNYS2AG
   P7BOdMLFbCKKCBR2hbFRthw9+NqN7pjLEAk9C3g/Ty8kNT+t5o6AizvYy
   lAlz71YTW/YaFTALQcb08pKs/pia6mRLYPHGgK1m82xqOwbaWcPf43EwB
   g93lZaksGPlmrS4UZX6wfQi9JQ+K80+RxcyScnRG8kvI3xdtrBsh8v53G
   CTW3Qvbu7WEdSDMeL/h3hi2OHgEDZ2WhVFkNgwE7jwtsJXXmIC1mEdd8o
   A==;
IronPort-SDR: 1iNpLgnIxWKlto4OGYpLhco8G1wT8doSCXJlIHakWe77DFyf9lic9V060l8PgPHcfDRbo86sH2
 Ked+IyUpUmoGhMRC6bXKwTjHb8mNnVxhtLlvl0Ppo6ZtV9fPEI5ZM07o7tQa7QncA0NjZwEN2L
 4rvEOLxyHwsx11pR5nbl0+VNhHFW7IB2muUCLn51A0rqSBGyB5lImb91BjEHsYE4XVLs4+BTtv
 PSmyUB2tvE+jalZd7pzO0FTpCXq5azurZCkLzftTdZsJyzU3y3230LF2USwzpRBzS01AzpMqcd
 zhc=
X-IronPort-AV: E=Sophos;i="5.79,350,1602572400"; 
   d="scan'208";a="111237785"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jan 2021 14:17:34 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 15 Jan 2021 14:17:33 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Fri, 15 Jan 2021 14:17:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LOZC6kMEqb6ZmRgbyB1YSq63T2e3S4we+6HfY60DgSt9OB4V5hCNqPUFOmGZq1eSdr7PmNR4I/cNeg+sgvXuirWweMqC8jlIOrFjdx5/pB7pnvUrufo9b2Z6sW0PoXLkDBqrZXPQ9TS5hlhC4Hu0eMUGj3i7h5YHotFa0VWU4/jOvaKmpS2/9c+k4xktAbcrgIXfXcRvy0o5gwL5UWsOfFrx2+WrHNBAQ5TsK3DZme80CBp5Afcy8LmV8aQH6Nhcmq+uzZt7rvMYtb2KGJ10V7DYRvmREzcuhhLRe/AGDq3h+78uPgdtnG5BsVzbzuXJahSbtl+GCw4Vdx1n5m5DcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJDE5adkL8ZVBAli3tL9UfmAHbS7NfnOp/TOyll2RoA=;
 b=bTtF5vmx0+LjOpuL+r/yb+3f6IECfn6yeAlshZLBmPM6GS36X3VzTEE6UxZwVRFpCirhi0fknWjQz9UsVeSRISUGvQ9Lwb9ZRjRcIG+USaqWe06DXP83yWx4s9VQr/oNONo91A2WkQGjIVzCaoAhRAuP//rW9cWZ/4BqKuTgF17xeYGe57PBlfjQN+LLxm4Kdxv5zLnH4v0474Nzfxbv46SHIqGsCnqAnaV6o42fl/ywJIs07dwjLuarfOKjnf0XIjkNNFqWPoWxPc7jQa7rFU4r8ovI1+jz7zvfPv1Bol51NLonuWVPVuJcGGEf/dxS2C2OfbOuly6c7GgcyvKnVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJDE5adkL8ZVBAli3tL9UfmAHbS7NfnOp/TOyll2RoA=;
 b=vfTuLM+xiAofY29bHWAe1xcfCz8C4VEKfQ/LBEkftKYyGt2nQutLYFungQ8M0JlX9PeiCFLbDbdT9VeVkWLDenlrgDeWVIr9tcWC6t06tCiLSicBhxKcffh3HO1zGPtyATYyBbvrnvG4DVmG4qVf+juogbC3pkUtI9RqqpHpV64=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB2797.namprd11.prod.outlook.com (2603:10b6:805:5a::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Fri, 15 Jan
 2021 21:17:31 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3763.010; Fri, 15 Jan 2021
 21:17:31 +0000
From:   <Don.Brace@microchip.com>
To:     <mwilck@suse.com>, <pmenzel@molgen.mpg.de>,
        <Kevin.Barnett@microchip.com>, <Scott.Teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <Scott.Benesh@microchip.com>,
        <Gerry.Morong@microchip.com>, <Mahesh.Rajashekhara@microchip.com>,
        <hch@infradead.org>, <joseph.szczypek@hpe.com>, <POSWALD@suse.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <it+linux-scsi@molgen.mpg.de>,
        <buczek@molgen.mpg.de>, <gregkh@linuxfoundation.org>
Subject: RE: [PATCH V3 15/25] smartpqi: fix host qdepth limit
Thread-Topic: [PATCH V3 15/25] smartpqi: fix host qdepth limit
Thread-Index: AQHWzzRlWOT1Tjrni0WYgyG85NUWaqn25dQAgAGyXjCAJGc6AIAMaNYw
Date:   Fri, 15 Jan 2021 21:17:31 +0000
Message-ID: <SN6PR11MB2848C1195C65F87C910E979BE1A70@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763254769.26927.9249430312259308888.stgit@brunhilda>
         <ddd8bca4-2ae7-a2dc-cca6-0a2ff85a7d35@molgen.mpg.de>
         <SN6PR11MB28487527276CEBC75D36A732E1C60@SN6PR11MB2848.namprd11.prod.outlook.com>
 <85c6e1705c55fb930ac13bc939279f0d1faa526f.camel@suse.com>
In-Reply-To: <85c6e1705c55fb930ac13bc939279f0d1faa526f.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9abad518-815c-473b-c9d5-08d8b99af88c
x-ms-traffictypediagnostic: SN6PR11MB2797:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2797A10E218B3CA939EAD78FE1A70@SN6PR11MB2797.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IBwddo2XRUd6Y3hjhGiWoJy3t5l/sVzDbH0pUKcIf748tsyuhPFpbEc3U7dOama/IKCMxmaGV0COcHbr9c8Jmav+BJaMONVRXoIZR1i5joYW/q//kWUU5vk6ZyEQMoR7JZWazSGnVIceQWt4Yd94usONai3MllTxAqr21TQ63RPgL69JzvZ2G12NB3oOCSLXmJN0PF2LgKNPNGiiJ+kjddqQerWD7hBDFj3VgpD6IHGDsA8lqO3Xk07IlsyQchvKPOo+70cxfQ/xjyTfInnkASZ2aWXjjR+eAjQlqGy9dCDc9Fbi8uk3inIArUUY8C1t1OG6qb8+OoIlzf43H5F3HEWrSof4Qsy8h/ReUa7kPcSucjDb6PcnCciiLnMDKIaEkXvraht8nMWvwt8mBKZp9E+sFLr2AppoQQSxiVRLOt+8UjHnvBYySooY9zCxbSfr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(136003)(346002)(83380400001)(54906003)(86362001)(53546011)(6506007)(8676002)(921005)(8936002)(52536014)(7696005)(5660300002)(76116006)(186003)(66556008)(110136005)(9686003)(478600001)(2906002)(66446008)(33656002)(4326008)(71200400001)(64756008)(66476007)(4001150100001)(66946007)(7416002)(55016002)(316002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?1ptaa3uTcDBdXivgjf1PpUx4sJY+uaTJkt3G+ddxJQxM0inrAULguacEFyXx?=
 =?us-ascii?Q?4Hf9fzEXeF+gUOgy+Hn5VRgaNTsFNjAGpUPFYppTCk27PFPfj+B7mM69Ozce?=
 =?us-ascii?Q?P5ru/rcj2kTYyRA7zkJPZV0G3vUBGw650qatm2MwHiP78tJejzA7qgrkkgyM?=
 =?us-ascii?Q?ceYl1a2l0MUUMe5Q/Ew0FQo9auAzPYjWum4m/m4/zrOgxc9Rb8c2O04sOLy0?=
 =?us-ascii?Q?MlIwHAFtJYhpxLpLWkFQ956qcpROkMuzwsLQ52ZUHFI7q18mqoZZcjjKpN3g?=
 =?us-ascii?Q?jWJWTDR4e/Cj/fHkAZv6wKLkLuTSLiK/fHlzhHEyBWti5pxKQk0xLGPUXk2F?=
 =?us-ascii?Q?dnJSORpN3IcYkCUDWU+eL2yl4/WR6RJ0jJ6sP0/ii9pf023glwHLtedNzCZk?=
 =?us-ascii?Q?gIG+glmpZrGJ6HV3/1HlNXlvQWJrJxCMqfUCi+3hzv7tI5seyk3fb7xMnRrm?=
 =?us-ascii?Q?2ib+eem0WPaBj5az3lN8661SH+0X9+BEJ6YdmzDmkWCtcUBCC53OlOyHKHBH?=
 =?us-ascii?Q?dcyZ5nXNzqZtoTI+XGoJeJEuZYpIkb3WnhTpIgK/tadpuQeCjObjnxt8pPxA?=
 =?us-ascii?Q?ZdCvQH4Z8kinalsLUaqM3FyjnYgcBRl0fVvglJF+WIzBWnqK3tbM9y4AIiwF?=
 =?us-ascii?Q?qvNQY3EnWcZLmz6B/OnMTimJmCKTrh2XIxrhPIcHCiaEyKFgXt8fQmIZUITX?=
 =?us-ascii?Q?NYblaoeklIoFHeSx/0NSvldllS/4KGfCRfLJHEH3ZMQ/JlRNYyaDMP//devF?=
 =?us-ascii?Q?NJQu3Fw0UYIRFi2AWEgHjRLRxwlP6CUTNyUEGawr6WMgLGeATcvdpkwxCIYm?=
 =?us-ascii?Q?TKMCvnJguRcTwKwp339x++k5dTc3OKkMXmBWpdqXdESoXhWIWyRWsbCvMkz6?=
 =?us-ascii?Q?IjfVp/j83w0E6Ndna3EObAlMpmqrG/dHIWS/wSXdhr7D9GT0AfnXbGi0ytkq?=
 =?us-ascii?Q?0Ev+B2WCstzBJNlPaS7Ju+H2TNaLhWeanMp13dzt7BQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9abad518-815c-473b-c9d5-08d8b99af88c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2021 21:17:31.6565
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RNXnf5MW9chiH1xcqU0qHZ4nWh5vtsjpJIY+GW0UVdzc6zaZCxUoPXxSBV+dyBzV8dv/O9CJ1UPc1EBbScZEZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2797
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Martin Wilck [mailto:mwilck@suse.com]=20
Subject: Re: [PATCH V3 15/25] smartpqi: fix host qdepth limit

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

On Tue, 2020-12-15 at 20:23 +0000, Don.Brace@microchip.com wrote:
> Please see answers below. Hope this helps.
>
> -----Original Message-----
> From: Paul Menzel [mailto:pmenzel@molgen.mpg.de]
> Sent: Monday, December 14, 2020 11:54 AM
> To: Don Brace - C33706 <Don.Brace@microchip.com>; Kevin Barnett -
> C33748 <Kevin.Barnett@microchip.com>; Scott Teel - C33730 <=20
> Scott.Teel@microchip.com>; Justin Lindley - C33718 <=20
> Justin.Lindley@microchip.com>; Scott Benesh - C33703 <=20
> Scott.Benesh@microchip.com>; Gerry Morong - C33720 <=20
> Gerry.Morong@microchip.com>; Mahesh Rajashekhara - I30583 <=20
> Mahesh.Rajashekhara@microchip.com>; hch@infradead.org;=20
> joseph.szczypek@hpe.com; POSWALD@suse.com; James E. J. Bottomley <=20
> jejb@linux.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org; it+linux-scsi@molgen.mpg.de; Donald=20
> Buczek <buczek@molgen.mpg.de>; Greg KH <gregkh@linuxfoundation.org>
> Subject: Re: [PATCH V3 15/25] smartpqi: fix host qdepth limit
>
> EXTERNAL EMAIL: Do not click links or open attachments unless you know=20
> the content is safe
>
> Dear Don, dear Mahesh,
>
>
> Am 10.12.20 um 21:35 schrieb Don Brace:
> > From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
> >
> > * Correct scsi-mid-layer sending more requests than
> >    exposed host Q depth causing firmware ASSERT issue.
> >    * Add host Qdepth counter.
>
> This supposedly fixes the regression between Linux 5.4 and 5.9, which=20
> we reported in [1].
>
>      kernel: smartpqi 0000:89:00.0: controller is offline: status code=20
> 0x6100c
>      kernel: smartpqi 0000:89:00.0: controller offline
>
> Thank you for looking into this issue and fixing it. We are going to=20
> test this.
>
> For easily finding these things in the git history or the WWW, it=20
> would be great if these log messages could be included (in the=20
> future).
> DON> Thanks for your suggestion. Well add them in the next time.
>
> Also, that means, that the regression is still present in Linux 5.10,=20
> released yesterday, and this commit does not apply to these versions.
>
> DON> They have started 5.10-RC7 now. So possibly 5.11 or 5.12
> depending when all of the patches are applied. The patch in question=20
> is among 28 other patches.
>
> Mahesh, do you have any idea, what commit caused the regression and=20
> why the issue started to show up?
> DON> The smartpqi driver sets two scsi_host_template member fields:
> .can_queue and .nr_hw_queues. But we have not yet converted to=20
> host_tagset. So the queue_depth becomes nr_hw_queues * can_queue,=20
> which is more than the hw can support. That can be verified by looking=20
> at scsi_host.h.
>         /*
>          * In scsi-mq mode, the number of hardware queues supported by=20
> the LLD.
>          *
>          * Note: it is assumed that each hardware queue has a queue=20
> depth of
>          * can_queue. In other words, the total queue depth per host
>          * is nr_hw_queues * can_queue. However, for when host_tagset=20
> is set,
>          * the total queue depth is can_queue.
>          */
>
> So, until we make this change, the queue_depth change prevents the=20
> above issue from happening.

can_queue and nr_hw_queues have been set like this as long as the driver ex=
isted. Why did Paul observe a regression with 5.9?

And why can't you simply set can_queue to (ctrl_info->scsi_ml_can_queue / n=
r_hw_queues)?

Don: I did this in an internal patch, but this patch seemed to work the bes=
t for our driver. HBA performance remained steady when running benchmarks.

Regards,
Martin


