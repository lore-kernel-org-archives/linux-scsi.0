Return-Path: <SRS0=UMfj=7Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56B59C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 09:41:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2253720792
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 09:41:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="RU5o2DG3";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="Rv1EXRnH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgFLJlD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Jun 2020 05:41:03 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:38222 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725911AbgFLJlC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 12 Jun 2020 05:41:02 -0400
Received: from mailhost.synopsys.com (us03-mailhost2.synopsys.com [10.4.17.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id EE120C03B7;
        Fri, 12 Jun 2020 09:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1591954861; bh=lyijdtCvncNAglhv/dDCL+KU99SnrMZgSj8Og0iQgT8=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=RU5o2DG3+MqLtVgKjM+9ZnRDVvLvyqN6IUswXNuSHRy/SacE+ML2G4dpoq92NdUzi
         LWx9MsALZzUkwTrvOFG14yPEQbEOmX1b1j496w0MB63x4o/PtUyJz6XxaJ3L0pKykZ
         NVRkI9hXtdUvV9rytKjGaYln1R7eG/b3zFVWyY04iepONM0HbPgCW7extk+4A+Lltz
         zKXkx8svqoeOC3uqyeP0TbpdeusMho+sWJPvfyQjAA7fECjS9smqqtTXIGve36YrCg
         NMk5IfBaydbwjLy5wG1+0uKzmLqos6lB9QNS4V9eIsTT9SRdkCied4kuA67aPzi5Tr
         gHrnGMGyro63g==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id F04CAA0081;
        Fri, 12 Jun 2020 09:40:59 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "GlobalSign Organization Validation CA - SHA256 - G3" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 3E5A7400C5;
        Fri, 12 Jun 2020 09:40:59 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=joabreu@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="Rv1EXRnH";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmGgztsWwyxyxnfxNSutcuZDZIk7GKGIJyMFIkpwW+FKIMKz/+yBV3JqvFo/ANaQEQULNduchmCeL7C42+5TJoCj27UQ6+IU48HYz42w/sKL9CAG5ITWqfeSbKg+cclaeYI38drmYW6tqDzvGNMBAr2A4tl2HrnHztdgGusULswyox/G7jI7tsrcx5A8Ww3TpOW9q8FJ1CtYNpstH6hh0mOsi+bO3nGw2Eovx1UpuPB8hRqgIVEamqVkJWcofgY8Gv0xRkbknbYNLuHfKKrcxR8iwVFRiZQfiFbxwaygMNpuGhKSPh0fjkKQAaMiCJlVdjSPb7wQNEbwsGRlLjjpNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lyijdtCvncNAglhv/dDCL+KU99SnrMZgSj8Og0iQgT8=;
 b=PsvvQlM8BAfaEObSrPuzAmerHi8A15bMnF47wejd0mPMdKfXChGm9T2bOb6PGqxEcbGTs8cPGjePkeqy+yQfbKLQK+KzEhy9sdY89nq0gSwQV++5pMUF850aGqBbNvVOFS0iLmiBQartJpYuHR2lA+3icbesKP+i3FXOtOlYLpk5k2m5O/4RSC4lO+LuefiuA6frfiVorhIxB+nwDsf5zd24fpbmD2EOdt7lAadDXMcbGNFonS7fhGCHKhqGli5ZXdY14iAgfbrZqFhfDItZY0GHHjT1uuex915FYnQn3GaaC5+DJaXO9jDN48qwz/v8wZg1AzghJ4l3NAyvtNok5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lyijdtCvncNAglhv/dDCL+KU99SnrMZgSj8Og0iQgT8=;
 b=Rv1EXRnHXUX2QjLKQ54g5FyWRWHGZX2szHuxItK6Y2TCSdkMCjSedPB9mKyjHQEsj4ORif37pt1oVcLTsy+4UsT4nBVeeHlmVtg6sxqyvgPEJn0+Ae0k7zDqVApM/E1x14hVRxuQjowkFPjptAjrVaVF43McCPYPocYRyYYmzZk=
Received: from BN6PR12MB1779.namprd12.prod.outlook.com (2603:10b6:404:108::21)
 by BN8PR12MB3204.namprd12.prod.outlook.com (2603:10b6:408:9d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.24; Fri, 12 Jun
 2020 09:40:57 +0000
Received: from BN6PR12MB1779.namprd12.prod.outlook.com
 ([fe80::f0ab:1cc3:95dc:caa4]) by BN6PR12MB1779.namprd12.prod.outlook.com
 ([fe80::f0ab:1cc3:95dc:caa4%8]) with mapi id 15.20.3088.018; Fri, 12 Jun 2020
 09:40:56 +0000
X-SNPS-Relay: synopsys.com
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Alim Akhtar <alim.akhtar@gmail.com>
CC:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Joao Lima <Joao.Lima@synopsys.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Subject: RE: [EXT] [PATCH v2 1/5] scsi: ufs: Allow UFS 3.0 as a valid version
Thread-Topic: [EXT] [PATCH v2 1/5] scsi: ufs: Allow UFS 3.0 as a valid version
Thread-Index: AQHWGj6lcVDTF+IaKE20nlDb1NNdr6iIbYWAgAdCRuCAAGeoAIABQo2wgEAjFwCAA4lhoA==
Date:   Fri, 12 Jun 2020 09:40:56 +0000
Message-ID: <BN6PR12MB177957E93D2ED229C76A24B4D3810@BN6PR12MB1779.namprd12.prod.outlook.com>
References: <cover.1587735561.git.Jose.Abreu@synopsys.com>
 <c006813f8fc3052eef97d5216e4f31829d7cd10b.1587735561.git.Jose.Abreu@synopsys.com>
 <SN6PR08MB5693C397D88D16EC43E85490DBD00@SN6PR08MB5693.namprd08.prod.outlook.com>
 <BN8PR12MB3266D1F9B038EF821FA8D503D3AD0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BN7PR08MB56847531D0EC603DD2C7B349DBAD0@BN7PR08MB5684.namprd08.prod.outlook.com>
 <BN8PR12MB32664256580771FA9102EB14D3AA0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <CAGOxZ50qPoC0HPUdTiOzA+NhTo5FRZVk01uq40AaDNn4JkHi3Q@mail.gmail.com>
In-Reply-To: <CAGOxZ50qPoC0HPUdTiOzA+NhTo5FRZVk01uq40AaDNn4JkHi3Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?utf-8?B?UEcxbGRHRStQR0YwSUc1dFBTSmliMlI1TG5SNGRDSWdjRDBpWXpwY2RYTmxj?=
 =?utf-8?B?bk5jYW05aFluSmxkVnhoY0hCa1lYUmhYSEp2WVcxcGJtZGNNRGxrT0RRNVlq?=
 =?utf-8?B?WXRNekprTXkwMFlUUXdMVGcxWldVdE5tSTROR0poTWpsbE16VmlYRzF6WjNO?=
 =?utf-8?B?Y2JYTm5MV05sWm1NME16TmlMV0ZqT1RBdE1URmxZUzFpTmpSa0xXWTBaREV3?=
 =?utf-8?B?T0dVMk5tRTBORnhoYldVdGRHVnpkRnhqWldaak5ETXpaQzFoWXprd0xURXha?=
 =?utf-8?B?V0V0WWpZMFpDMW1OR1F4TURobE5qWmhORFJpYjJSNUxuUjRkQ0lnYzNvOUlq?=
 =?utf-8?B?TXpPU0lnZEQwaU1UTXlNelkwTWpnME5UUTJNamcwTlRJMUlpQm9QU0lyYkRs?=
 =?utf-8?B?TVlWTkRibWQzWWsxb2EwbEhXR0prWkdOaVRWQmlhalE5SWlCcFpEMGlJaUJp?=
 =?utf-8?B?YkQwaU1DSWdZbTg5SWpFaUlHTnBQU0pqUVVGQlFVVlNTRlV4VWxOU1ZVWk9R?=
 =?utf-8?B?MmRWUVVGQ1VVcEJRVVIwWlRGVFVtNVZSRmRCVTJKbFVXdHBTVzVWVUVaS2RE?=
 =?utf-8?B?VkRVMGxwWkZFNFZVOUJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlNFRkJRVUZEYTBOQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UlVGQlVVRkNRVUZCUVc5YU4wTkRRVUZCUVVGQlFVRkJRVUZCUVVGQlFVbzBR?=
 =?utf-8?B?VUZCUW0xQlIydEJZbWRDYUVGSE5FRlpkMEpzUVVZNFFXTkJRbk5CUjBWQllt?=
 =?utf-8?B?ZENkVUZIYTBGaVowSnVRVVk0UVdSM1FtaEJTRkZCV2xGQ2VVRkhNRUZaVVVK?=
 =?utf-8?B?NVFVZHpRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZGUVVGQlFVRkJRVUZCUVdk?=
 =?utf-8?B?QlFVRkJRVUZ1WjBGQlFVZFpRV0ozUWpGQlJ6UkJXa0ZDZVVGSWEwRllkMEoz?=
 =?utf-8?B?UVVkRlFXTm5RakJCUnpSQldsRkNlVUZJVFVGWWQwSnVRVWRaUVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlVVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVTkJRVUZCUVVGRFpVRkJRVUZhWjBKMlFVaFZRV0puUW10QlNF?=
 =?utf-8?B?bEJaVkZDWmtGSVFVRlpVVUo1UVVoUlFXSm5RbXhCU0VsQlkzZENaa0ZJVFVG?=
 =?utf-8?B?WlVVSjBRVWhOUVdSUlFuVkJSMk5CV0hkQ2FrRkhPRUZpWjBKdFFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRa0ZCUVVGQlFVRkJRVUZKUVVGQlFVRkJTalJCUVVGQ2JVRkhPRUZr?=
 =?utf-8?B?VVVKMVFVZFJRV05uUWpWQlJqaEJZMEZDYUVGSVNVRmtRVUoxUVVkVlFXTm5R?=
 =?utf-8?B?bnBCUmpoQlkzZENhRUZITUVGamQwSXhRVWMwUVZwM1FtWkJTRWxCV2xGQ2Vr?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVUZCUVVWQlFVRkJRVUZCUVVGQlowRkJRVUZCUVc1blFV?=
 =?utf-8?B?RkJSMWxCWW5kQ01VRkhORUZhUVVKNVFVaHJRVmgzUW5kQlIwVkJZMmRDTUVG?=
 =?utf-8?B?SE5FRmFVVUo1UVVoTlFWaDNRbnBCUnpCQllWRkNha0ZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRlJRVUZCUVVGQlFVRkJRMEZC?=
 =?utf-8?B?UVVGQlFVTmxRVUZCUVZwblFuWkJTRlZCWW1kQ2EwRklTVUZsVVVKbVFVaEJR?=
 =?utf-8?B?VmxSUW5sQlNGRkJZbWRDYkVGSVNVRmpkMEptUVVoTlFXUkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZDUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVsQlFVRkJRVUZLTkVGQlFVSnRRVWM0UVdSUlFuVkJSMUZCWTJk?=
 =?utf-8?B?Q05VRkdPRUZqUVVKb1FVaEpRV1JCUW5WQlIxVkJZMmRDZWtGR09FRmtRVUo2?=
 =?utf-8?B?UVVjd1FWbDNRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlJVRkJRVUZCUVVGQlFVRm5RVUZCUVVGQmJtZEJRVUZIV1VGaWQwSXhR?=
 =?utf-8?B?VWMwUVZwQlFubEJTR3RCV0hkQ2QwRkhSVUZqWjBJd1FVYzBRVnBSUW5sQlNF?=
 =?utf-8?B?MUJXSGRDTVVGSE1FRlpkMEZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVkZCUVVGQlFVRkJRVUZEUVVGQlFVRkJRMlZCUVVG?=
 =?utf-8?B?QlduZENNRUZJVFVGWWQwSjNRVWhKUVdKM1FtdEJTRlZCV1hkQ01FRkdPRUZr?=
 =?utf-8?B?UVVKNVFVZEZRV0ZSUW5WQlIydEJZbWRDYmtGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVKQlFVRkJRVUZCUVVGQlNVRkJR?=
 =?utf-8?B?VUZCUVVvMFFVRkJRbnBCUjBWQllrRkNiRUZJVFVGWWQwSm9RVWROUVZsM1Fu?=
 =?utf-8?B?WkJTRlZCWW1kQ01FRkdPRUZqUVVKelFVZEZRV0puUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkZRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRV2RCUVVGQlFVRnVaMEZCUVVoTlFWbFJRbk5CUjFWQlkzZENaa0ZJ?=
 =?utf-8?B?UlVGa1VVSjJRVWhSUVZwUlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VUZCVVVGQlFVRkJRVUZCUVVOQlFVRkJRVUZEWlVGQlFVRmpkMEoxUVVoQlFX?=
 =?utf-8?B?TjNRbVpCUjNkQllWRkNha0ZIVlVGaVowSjZRVWRWUVZoM1FqQkJSMVZCWTJk?=
 =?utf-8?B?Q2RFRkdPRUZOVVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRVUZCUVVGQlFrRkJRVUZCUVVGQlFVRkpRVUZCUVVGQlNqUkJRVUZD?=
 =?utf-8?B?ZWtGSE5FRmpRVUo2UVVZNFFXSkJRbkJCUjAxQldsRkNkVUZJVFVGYVVVSm1R?=
 =?utf-8?B?VWhSUVZwUlFubEJSekJCV0hkQ2VrRklVVUZrVVVKclFVZFZRV0puUWpCQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVVZCUVVGQlFVRkJRVUZCWjBGQlFV?=
 =?utf-8?B?RkJRVzVuUVVGQlNGbEJXbmRDWmtGSGMwRmFVVUkxUVVoalFXSjNRbmxCUjFG?=
 =?utf-8?B?QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGUlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlEwRkJRVUZCUVVFOUlpOCtQQzl0WlhSaFBnPT0=?=
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [82.155.99.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9dbe4ff6-38d8-491d-daa8-08d80eb4b50e
x-ms-traffictypediagnostic: BN8PR12MB3204:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3204E7B5CA6B8FBC4FB42FC3D3810@BN8PR12MB3204.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 0432A04947
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dlv639UWeMkBzH9IBVvXnCX9DD3UAuGRw8FplvEg+m94w7KCItnZyPJlv5KCQCp0ebzHRlUOJkL9KyvXpgpv8z0lKeFnz1mcm3L1C+GetvhkkxYZ2bAUrE/xvq8JhUxHGU4f4oVsFGnPkndTdC8i/HhrVbVgDe6+EctC/yYTwQ3V1g74Av/skKRNL7rpoxWchzzsuKkMx53FTHmzn1BqHxXyBdNjbOTFG8qK14aebwg05Adt7Pr+tkG8A/O7fIPoNl06eCoJgFLmijXTd0yKR70zpXd+pWS+BB51XFLJuZXpD3omFRnEW4eYO1Y9+fxyVbzOXLOXboLjdyPLQpdS1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR12MB1779.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39860400002)(396003)(376002)(366004)(346002)(6916009)(26005)(8676002)(316002)(55016002)(54906003)(9686003)(186003)(8936002)(86362001)(33656002)(2906002)(558084003)(71200400001)(52536014)(5660300002)(66946007)(76116006)(6506007)(66446008)(64756008)(66556008)(66476007)(7696005)(4326008)(478600001)(107886003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 6KlG0RxeNaP2fuiXDzC9bL+Ceb2ASmOTRU4zyxrO2nGrmSEEwNLQLUYCyca37sAwsMHhVU1G+Zw62lniynXsKFoyADZQpXURyEUaSF2JmAeleoMPD2Tz2wXxQVxRuKs4OpvCAF0pDR4s0bIl5xo62LtfWyNy9dz0n6jBojDxOk3fQiLuHR8HtmC4yft7gixeNjWRQC2WARA8Se3OkC0C1cQpc/WJdhDkWrJVZbdL1G3cyOJGy+bQfB4Z9ZsrQfI1KkmZjn4yjJsrwro2VsV0jA+Icy5fTh8iZZ5ECz2prN3HNyOs8sIVhknU2+J9UVnIC38xPVb1YmmIijSA9Z16Dp7ICOM+j5hRTYfbwOy80wgWnK29nu6xEKRjpzwFDA7/X101XNaK9V+fcohtV98AH3B1Y5mFGrlishDiipwYpB9aWZTFCX7wy9xlgFLVWut2/B3txs5Wc3Tg7bfaeHlGgITpQGGQhTSBMDV8QqNUVtA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dbe4ff6-38d8-491d-daa8-08d80eb4b50e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2020 09:40:56.5018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4hm1xVd2T4wuS+mygrrpjbe5PPPWqm68uANgdjufPXr9dP5/TrbuW/9wf8lyBvkbW/oSGtAmLamPxSrZiD6LWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3204
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RnJvbTogQWxpbSBBa2h0YXIgPGFsaW0uYWtodGFyQGdtYWlsLmNvbT4NCkRhdGU6IEp1bi8xMC8y
MDIwLCAwNDozOTo0OCAoVVRDKzAwOjAwKQ0KDQo+IEFyZSB5b3Ugc3RpbGwgb24gdGhpcz8NCg0K
WWVzLCBhcG9sb2dpZXMgYnV0IEkgd2FzIGNhdWdodCBvbiBzb21lIG90aGVyIHRoaW5ncy4gSSds
bCB0cnkgdG8gDQpyZS1zdWJtaXQgb25jZSBwb3NzaWJsZS4NCg0KLS0tDQpUaGFua3MsDQpKb3Nl
IE1pZ3VlbCBBYnJldQ0K
