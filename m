Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AF1CC4743D
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 19:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D054613D2
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 19:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhFDTrc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 15:47:32 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62754 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229810AbhFDTrb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 15:47:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 154JZwuf020875
        for <linux-scsi@vger.kernel.org>; Fri, 4 Jun 2021 12:45:44 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 38ygesa4nr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 04 Jun 2021 12:45:43 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 154JeV50028053
        for <linux-scsi@vger.kernel.org>; Fri, 4 Jun 2021 12:45:43 -0700
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by mx0b-0016f401.pphosted.com with ESMTP id 38ygesa4nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Jun 2021 12:45:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m66sUdQUSgTzvMCyhsOWVpYH/Avi3VE2f/7pPkcTS97Zwy0q1dltKb/qREQRcU60+RRT4ImN69RTzMxm4/0s/Q2U7fvqxoz3p9BLw31PVCJ1iP6x7VE3n4F90KINzTGjRGlacImwy5mMT96e5goN9u7NTzId5Yz8AdlL/82aIygttXUk8iTMD3nwF4sN3OfWlk0h8A7cy0mGEwJ8GXb8VAXuVzMtDg8XS3cqJ1pWuZ+DhYHmW9B15VomZpamSPZifCwS/o09/lUOCvoxFDFoAWzXZwRtAMI+IuT0LrGpNW6O5xPA7fID0/2DcNqA4OUorScE8Dkwcz+oW34ZIskveA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dp4zTR8Bk7YesOKFVp5t9n9DUG68MY5OW3vEq7OwGmU=;
 b=YkYaKMjwwr1tYkcypxj5Qt6wjP6sSsm0ap7Wz5esDBKR3WB4toQm+yzkT+Xrl9mi315Ge05kyOGjs9fSXTc/RIyKAmGR6xJ+4F3A/N6SIi8VkvEFIjvN3GWf5szNR55o+Of4lNNtGaK3wpeqcLwEKlMoNlH5DvUr01RnKZfZoCNW8YU/owHnVyvsJwR+jJONzp2tDAM0K6bMB4+M8XeGWV60FK1tpNQL4Gl3zNQ51phROaGcGFuHtkjb4WHFoMaJqxwaCreRNfJB4f66RPe9mirCqLtELpeRvGPlpt25M+hTo3Kl/VXU56+5Ib3b320271ydGqnJ+mxGjxM6x4Bmyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dp4zTR8Bk7YesOKFVp5t9n9DUG68MY5OW3vEq7OwGmU=;
 b=kRbZOu3d7cS/o9e5Jh4BWgu+ExQP/6rXqRjlN4VnbuCx7G7eLDZ/NI+43h3XDoF22ZJuUAJn+jRUgJSEXmRC0TZAygoVuzEoBKDCbYz4omXsl9+2hvYzYbu7zrlYTuu8oGMd7bOtE3TYQdjnPq4WY7zzdNRntj3SBNvGFvonPVM=
Received: from BY5PR18MB3345.namprd18.prod.outlook.com (2603:10b6:a03:1ae::30)
 by SJ0PR18MB4107.namprd18.prod.outlook.com (2603:10b6:a03:2e6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Fri, 4 Jun
 2021 19:45:41 +0000
Received: from BY5PR18MB3345.namprd18.prod.outlook.com
 ([fe80::a543:d35e:d4a3:579e]) by BY5PR18MB3345.namprd18.prod.outlook.com
 ([fe80::a543:d35e:d4a3:579e%5]) with mapi id 15.20.4195.025; Fri, 4 Jun 2021
 19:45:41 +0000
From:   Quinn Tran <qutran@marvell.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH v2 02/10] qla2xxx: Add getfcinfo and statistic bsg's
Thread-Topic: [PATCH v2 02/10] qla2xxx: Add getfcinfo and statistic bsg's
Thread-Index: AQHXVeuOxQOvu1itqEmOKYizbfc1FasCoosAgAGlWQA=
Date:   Fri, 4 Jun 2021 19:45:40 +0000
Message-ID: <BY5PR18MB3345E8C320F6F8D9D683560ED53B9@BY5PR18MB3345.namprd18.prod.outlook.com>
References: <20210531070545.32072-1-njavali@marvell.com>
 <20210531070545.32072-3-njavali@marvell.com>
 <9d265473-0e14-eeb8-d5ce-558daf8b2ffa@oracle.com>
In-Reply-To: <9d265473-0e14-eeb8-d5ce-558daf8b2ffa@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [98.164.229.97]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f0c7af4e-400c-4bc1-fb1c-08d9279155a3
x-ms-traffictypediagnostic: SJ0PR18MB4107:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR18MB41071352EAC5709D1BA3E4C7D53B9@SJ0PR18MB4107.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bGwIFunK0rtTbAd/x3+uHE/GPhbkhccTCa8sQK2A3z7o6l7KxiDtv4EJWeiaHBQYwbso0qZQVPEf7Bi0HeeAGyPModzgA+aeAN+IiiXcaPAGifk8yZuloz64ptZBGAGAzNvbZOcnNC1G5R3N5kdfeTt4JgD0SExg63IcYajj2XCu5c9B/lHJkxCjLAkJXikuSDQGTomzBZKWp+Z29nqe/GW3IXYdTSannBZRqvQ2yBLl5uaPHvIVZMm0t+7QHCii/wXh/eqsrv0nDjYUQChnUm3/tJ+kxz26d2ZJTLR1VtG7AU5EhPaabo6qD7N8BVRG8TgqB5Ompak/DJhENL16TAkmdNeU73F80Cyu+K01aWmeFE9/sVpW2P2KQilQcfSZvoqdYGJJJ1r1Sv/Y2nBSH2j2Wqtd4zyyA4u1TfitP4R40mRJMGuTu/wCWiZF7hXOW//KbMbA3daiMZ5xhZ0bgVeOrJMHftobhZN72hGXBCqvHrBsfcbEi9tZg/JaUZB1kktTkVQUBnL/oj50IkXfpFfHGGUjghOQI9JxKVjPPm60OQ6MPY+qxT4qEsOPWwGv4IVtrUZAXBNX2gNLYXfuXx1z4CZvibY3IBUdcdT0md4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR18MB3345.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(8936002)(2906002)(5660300002)(55016002)(83380400001)(52536014)(8676002)(9686003)(4326008)(110136005)(64756008)(71200400001)(66446008)(66556008)(316002)(54906003)(66946007)(558084003)(66476007)(7696005)(478600001)(38100700002)(6506007)(26005)(76116006)(122000001)(107886003)(86362001)(33656002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VGRxdFdHK1AwZnZRTGlMUnVNaHhqV045akRmKzNrL1NIOE1LM3hYWHJNeDhU?=
 =?utf-8?B?NE44TUozSEtCZGhHZzhqeFJQVCtkUXlIcS96YldMQ21uY00xQ200dTAwVXdy?=
 =?utf-8?B?SDk4UXc1N1lWc3J4TjFUdUVDUnhSRFYybCtaV28vbm1saGVsbjVXaEoxKzFN?=
 =?utf-8?B?d0liT3V5WHkzaHI4VUNjZG1CRWtYeHBEWVBCS0EyaVlTMGVoTTBtSzlXN3ls?=
 =?utf-8?B?YTd4THBiZ09Ld2FvaU9BMWhXYzd1VWgzbTU5WFBBV0MycDh4Q0tHeGp6VVJX?=
 =?utf-8?B?bWhtZ0VuOHRDZzFPaUlIL1FaN3VHbk9qYTFqTVB5TnNKMWFYU2I2MVA2S3Ri?=
 =?utf-8?B?RFd6Q2tkUSsrbWFCcVJuZzBSK044djNoMldOcWpPaXdJcWk1emZYVytpM0Ux?=
 =?utf-8?B?bFdMMHVYeEs4WmlXb3dkd2VqYTU1TUo2cTZLOFhvdTJFQVpPZjZuNEkxcXp3?=
 =?utf-8?B?cEcrVm53RUVKa1IxNEl5QVpScVByZy9XaVIvM3FDaW00VkY4TWZ2Y2ZkZXZ1?=
 =?utf-8?B?N0xFYW94bllQZWRxeEJQanNCeUQ4WmZDa0VJVkJWcVpJbUZaRzRURG11VTU3?=
 =?utf-8?B?TGF6OWRUK3pUdmZZSG5hVENJOEU1d2RLdG9ld2xIeXdJU2s4c2ZHUXlERkc1?=
 =?utf-8?B?QWtNamJxTDlUMldEWG5DWGRIeGUvcnI3eTV6bEo5VTJUVDVvR1hnbWw4L1d4?=
 =?utf-8?B?ZUlQOFZFRDN0RTBNWFBPRHd3RVBxRU1oTi8zeUFKZVJLSGZrSG0rUUl1Rncx?=
 =?utf-8?B?RTdVSGhzQ3RST015NlFZQkFiUEs2WE1OUklKVXB3ei9kNlVtKzY0OEVUcXJX?=
 =?utf-8?B?VWJPNDFDUWhmaE9EMTFVd1ZVZjBEYUZmRHU2ZnNaRmlRdnFqOHkwV3RZeU1B?=
 =?utf-8?B?WjYycTlCdm55SFBTeEprUTR5b29WbFE3enF5Tk5WdCthOGNDamZISGpRSDly?=
 =?utf-8?B?RXFOUWVZZWlxSGdMY3F0TXFja0ozQzdveC9qazVxVk1HM1NqQnl6V0pMdm10?=
 =?utf-8?B?SFRvTVkwQnJxWFNRaXVvUi81WTk1NS8wQzZnVEZWYWptTk9ReUpQNEhyczU5?=
 =?utf-8?B?QzNPeWVoTzlzQ3ZPUFpoSTl2VWxGYUUrbmxmTVcrVjlzcEQyZFVBYVRTZzNK?=
 =?utf-8?B?L2MvaDhoNDBjc1R6emVtalVxeG9wNC9ZY1c2S3JsRm52VENqbzdiTTVHWGlH?=
 =?utf-8?B?S2dva3ZKR2RGckIrdU1aaDBKU1QzeHBGcHdBWXFRRWFOWXREU28xQ2QyM0g1?=
 =?utf-8?B?MmhkYlMyV2RnR3NIV2ZJZ2tJSzBzQXpMN1hxcEc2cEh4eEtxQmhaUkhYa0RI?=
 =?utf-8?B?N05vZXkxM3dQc08ydVdOVXp5MDk2Rm1xYjlodXBUMGVQeERWdTJ6S2pkMWVC?=
 =?utf-8?B?MnlzWCs0cnQrTE96N2NHTEZMbUtvVnhBb25acXlMc0tZRmc5c0VPWkpWTEM2?=
 =?utf-8?B?dE50NDI0MDlzcXZkT3Q5K2ZBSHpVUUpMeTBjbEcydnoxMTY1aEpiODJ6T21q?=
 =?utf-8?B?bWlpdytRRjhPOWlNRzFmaFFPVGc1QlRFa2g1dWtLTVYrbkNDT0MrZVdXQTJk?=
 =?utf-8?B?VG84V2ZzbU5iNzMzUXJ0aStCYmNIb2Zzdi9JUnNTUStVT1BEMGhjMUFTeGNn?=
 =?utf-8?B?UWd5dDBGUlU4S2N5aEo5TVpwQnFFdGxZbVA0UmU0SkV6Y0VEVEtHUUJVY21u?=
 =?utf-8?B?ZmdyRlFJelZBaTI5Z2x4VXpZejFUOHhVV0lPU1A0Q2ZWdUMvUTNZZ1lXblFk?=
 =?utf-8?Q?RQ94CiYQT5Y+2UHjl9Cmyt9jZ+H72zDJB/eXeO3?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR18MB3345.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0c7af4e-400c-4bc1-fb1c-08d9279155a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 19:45:40.7888
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EjTs06tomkOX+pCkBQuWpWC01h+MjXXfNoznKv7EVZmTMt8koLcNpchFPQNAoLOQswsrcoWPcKRmiiZ6Qym6Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB4107
X-Proofpoint-GUID: fggtZqYeZ0wRA9kSJcsuBxPRsE3ucE2H
X-Proofpoint-ORIG-GUID: P2gofV3PCVs0MIm9GGLtPgE3FHkvmFl4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-04_12:2021-06-04,2021-06-04 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiAgIAkJLy8gZGVsYXllZCByeCBkZWxldGUgZGF0YSBzdHJ1Y3R1cmUgbGlzdA0KDQpzZWVtcyBs
aWtlIHdpZGVzcHJlYWQgaXNzdWUgZHVyaW5nIHRoaXMgcGF0Y2ggc2VyaWVzLi4gcGxlYXNlIGZp
eCBjb21tZW50cw0KDQpRVDogQWNrIHRvIGFsbCB2YXJpb3VzIHN0eWxlIGlzc3VlLiBXaWxsIGZp
eCBpbiB2My4NCg0KDQoNClJlZ2FyZHMsDQpRdWlubiBUcmFuDQoNCg==
