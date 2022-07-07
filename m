Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE33C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 10:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235277AbiGGKQD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 06:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235276AbiGGKQC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 06:16:02 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A234F650;
        Thu,  7 Jul 2022 03:16:01 -0700 (PDT)
Received: from mailhost.synopsys.com (badc-mailhost3.synopsys.com [10.192.0.81])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4F5E040E8C;
        Thu,  7 Jul 2022 10:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657188961; bh=f8JUHbYcAirVRN3vH0VtuSo7+LVD3y5o1yxUerA+s+I=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=DXuaCjMZGop6VnGw+ObH2itAmoT12uerXTxwukWW+bSPbr2yMYloalg1vD+IR4O08
         z+lFu0jJt1BoHYE0riDJIRPP4KWU3kIW0tAafiweKsufjRlx52GbJZ2shdWRozMW5N
         Kb2cLvN0U6HgGhi62h5+svBouLTXWO0gFVFvdAXiqyAGnTovAy6XXt+vowjBy9Cfg9
         8eRTY49jVZ2yKdI7TsqxUX4zsOcUPvnZSsDmu0kRETadAlEatpazaj9fZ/CqXznah/
         HyXsN9EDOCCBAXpuks3pCjJb09kAOnyRAsWCQNH8jgWMh/zmtIS/Ebp+EgTQuJeBUC
         fg/pP6FIKAK1w==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 49A46A00EB;
        Thu,  7 Jul 2022 10:15:58 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id B5E6A4002C;
        Thu,  7 Jul 2022 10:15:55 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="jMM+sPKU";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a9NsCyYcVsrMIit4k9ApLtUNt5AqRj5azwHWkiAy3RHdJUnWQyGXaP4GKidIWUUKPuJ42f40OqYW3N8yi8KdHUEMyRoqlN5y4qqd4KfDmLMRgiavzJN9NHwXcXu0X7YlvbZmV9YpDadXalk7tNpcTVeMM2PWLqmpcnydSgq4VI4Remp1+2eBzick01bQAfE3dD7tVzmWamTs3+RVouQShRB/M1qKnp+78Zw7pZXtQ1HO4ViC/Rm5RqGFFF6s39NQqg582unA88MFffIIJPUYjeHgDKEq+fAGA/1vN6zx3d0/qzFJLEdUSsRyI/KqIJllym/166ZzbZ2wMbf3AXpEDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f8JUHbYcAirVRN3vH0VtuSo7+LVD3y5o1yxUerA+s+I=;
 b=D0lVaY6huAX7cOg/f5mrAnhMHpzGLNCriTbmBN5kogPgdbnfcsCZJOaxekTdtSt6if43EoEZJF7eMS8fZ1BPvwWptIkI6F3nY74/dLTT0U3Km9npQpJN8azHpKd2CZrjpyJ4ycuqPU92jeBlb4iw/7vYpLwjEYb7WGox6QUFigQmd6HHKG46OJcK66EEn/LItIr6/3krYaDCl12jd5kM/CB30fyDzKrUU76+bdO33xyLLU8FHgY2C3cP7UJN03KUALL3/XH4j7VwSnyUcbXSAmVAPL9EnUHT0TQ+y2z1qySslRagBqTCOsrwEmLqecKKmfezhWbnsQMlWTFLD/gC6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f8JUHbYcAirVRN3vH0VtuSo7+LVD3y5o1yxUerA+s+I=;
 b=jMM+sPKUcqUzvFlXul9sUkX3TeIEpJKr8FCHknHEv/LmR/st5jcgIgd74ssh1nngA3CLG6AJIHlCaNfy7B/XMTnHN6eidxaMzu1Z/XyZYKZmNdJ+Ph1Wvz3MBPo0MfxeNTnQUR72z4zXnpOvR+bvMokgEa39GpYmrtbtXzYb/r0=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by DM6PR12MB2617.namprd12.prod.outlook.com (2603:10b6:5:4a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Thu, 7 Jul
 2022 10:15:53 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c%7]) with mapi id 15.20.5417.016; Thu, 7 Jul 2022
 10:15:53 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     Felipe Balbi <balbi@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Mike Christie <michael.christie@oracle.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        John Youn <John.Youn@synopsys.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/36] usb: gadget: f_tcm: Enhance UASP driver
Thread-Topic: [PATCH 00/36] usb: gadget: f_tcm: Enhance UASP driver
Thread-Index: AQHYkZDvNPvW3sRbaEm7K8DR0I8G9q1yewAAgAA28AA=
Date:   Thu, 7 Jul 2022 10:15:53 +0000
Message-ID: <9f9d35b1-8d39-7413-88f6-b26e61a75bf7@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <YsaEQto3Iygj1S2Q@kroah.com>
In-Reply-To: <YsaEQto3Iygj1S2Q@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synopsys.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: faf1c739-7985-4aa9-49a0-08da6001ac6e
x-ms-traffictypediagnostic: DM6PR12MB2617:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hAkgS4q76thcaHJRAbKzhj0epJKwbI7cuO84YZGmyimsZxco+YXgPzYxeTtgyvokDhrttd/507gBcv+3PM4jm/Wh3ABWr0y0T7n1PoQK8fVQ/As7unSNxdLcdkDnvn+UAJKfgDTNTNZp9Z+Y1o2wjWgQYB51FVeEc6XqcaOi+tQXajsi/keAoEodsAf36QZ2jncRfTbVYON2MJttAz2lNJ3a2hcUgnoU15imlxkkCcPg14QWKlUkWTYY7Zl7FU1B5UA/R5zGJpdQzaIlmZnBbPfZMaLJZlmQ2HgVr4BVUzZtFCW4srbyYbyqyhc/2rp8pURhrrECdhb5hd2z8gGVNAULaG0Ou2gDhXcaLfy3XMIh8q5LqdjP+dLzI5yTvjCLi3LhkA+6lF44q5F1uMssGVFDoeW2u5HilJA7EIRYlExZJibQnJdeoUrJLgqLlBo6qiA1xW4u+OHT7C09a2Zg4hJup0+SWoVD9mBXdo16mv27urBO6uQje+NDESkg0QvzH3ifY93JRP0WMhZf0weMdbhsRBPwGILQjRbAw2A0OREdOGQ27Rj7A8RGt827/qKFJQKUHFNLT1n3SZ4J4eEwtQohATFVt4vLy2F1mxLJnqNj3NKGqDdGZox+jIdXS+65IAN2FMEa8Siqp4egmezfcnHtEobhUfblTkOivBx3fB0EKeF967cV1XRZ1EfsTh9CyPED3WcrrKAlduhH+7RKCL+8z8K5Imv5C+gAuwZsNjWiX5YV3qacGQt/0BJRWGy6Pmh9VpuZAAQrfHkzUsMjY8T56WEaRQufP+TNFKZvs/iZ/OlEG1bPfvexn4VWyaMZ1wLKTO9WhWCnSF16RYdI0jkgrsA4BAh3rWO8cNpX35jrfOy6ax6u9PYOkiIg6kkQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(39860400002)(346002)(396003)(366004)(186003)(64756008)(36756003)(2616005)(6486002)(31686004)(83380400001)(66556008)(122000001)(2906002)(66446008)(8676002)(6512007)(41300700001)(7416002)(5660300002)(8936002)(86362001)(4744005)(4326008)(38100700002)(478600001)(31696002)(71200400001)(54906003)(38070700005)(66476007)(66946007)(110136005)(6506007)(76116006)(316002)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWZUMUIzMVBxQ1NLbThQYmF0ckJ3VXljNmpYYUF1cExQK0ZNaklKZGgyU05p?=
 =?utf-8?B?YWFicHlJSVczV2JRcmU0RmgrK0ExOC9QTWlHeitnTnU0QjRqNUJoVWNZMm1M?=
 =?utf-8?B?Mm9ZUHhtdXlSNjlGZDNvTmZOTlY0MVFRWHlRVGJmUkVHQ1Jjc1B1UHgvR3dj?=
 =?utf-8?B?TWFIZ09HWEFSYnJlM0Q1cDhDVXZZaVczYUZuNWVXVGszakxhM1N5QlFDRjNp?=
 =?utf-8?B?VnN2RG53ZnNiNHVUYmJZLzhMMGhPRzlxQ2w5blliN0k2YlYxeWMzUDI2WEU2?=
 =?utf-8?B?cGdGR3NraFV4WG51dlZzaUFMT2IzM25Fckl4S2N0SFBmN0NMdUR0Z1BVZFlK?=
 =?utf-8?B?Sm52M2pETVY0L21CYVIvTjFTVHM5MDgxQ05WUUhKSzlCTEtMRDBJdkZ0elNS?=
 =?utf-8?B?eVgxNUdnVzhWUk1yQUo4MVBWbk1IekRZRkhxdVEvUmEzTUh3Y2IwTXhhT29j?=
 =?utf-8?B?L0JkdkZpMCt0M0kvK0N6WDcrZjJmdzlaWjErTHovcU1leW1ZRVYzaE94VHlB?=
 =?utf-8?B?UEVId2ZPMXFxMG9Wd1hLUzcwMjlZeksyc05vZkZ1NHZzSWNSU01BcjR3YTMw?=
 =?utf-8?B?TWlqY3JFZmtKMVgrNlZVY2kvSnhQaStaMjFTRmlKckN0YTYwVk1Na015YTd2?=
 =?utf-8?B?Y2lIZnVXSlhDSXZNK3dIR3BlQ2hwbnZZT01yWVJ1cm1xNUpveHYrU0lVUEZI?=
 =?utf-8?B?eUM4TW5DeEtRcmNuK05SYURwd3NUNm96QnFvci9CZWRGRnd1d2lreFh0TUx2?=
 =?utf-8?B?TzMrUXRFV3ZoWHUxMGVMNzNhaHNLVFc3emJlc2VaWUFvVXdldWhCQ2Vmbm91?=
 =?utf-8?B?Y2NQSmgwNkZLczNEaWpQY2JtR0FGUTBvMGFUN1docU55Vi9XRDhvU1Ywc3ZQ?=
 =?utf-8?B?aWl2dkFKeTVla1N1WHg1SzZxWDdhQzB5NTZRTFRaWFoxdmxzMUY0OUxDbVRN?=
 =?utf-8?B?M2Y0Qld0bnFwa2RsMXZudGl2LzY5RGtxN2RDUCtlM0g0SlRyWDVCWEExVjY1?=
 =?utf-8?B?QklWMm9Wb2pBU01sTm1rVVdmZERKWlBtTXozR00ydU10dGNnUXpuR3RUdC9Q?=
 =?utf-8?B?ZWFob1pya1RKOFNzRmZSY3dlaDA1dUc0Z0J0eHIwcU53OG5BbDh2M2lENXZ6?=
 =?utf-8?B?Y1NBK2p6RjJCNHp0aWExbk9HYm0ycE56OFoyQjJ5MkNYS3dUYWFSdTFTeVY1?=
 =?utf-8?B?WmZTVzZCMCtpNlRUa0lOWWN1QVFyb1FtdnhRUnZPMG1hYSs0ZjlIelFVWmYv?=
 =?utf-8?B?dTRnTThaSXk3alJvK01CTGdMYzQ2Q0FPVEJCb1o3Yko2UTZYMHN3STJsM1Y0?=
 =?utf-8?B?c0t1WG5lMFEzOE1kZnNzdTlYT0Y0b0V0ZGt2UHA4ZVdUZFZFNSt2TjlhclN4?=
 =?utf-8?B?WmE5ZWk3TkdudGFZeENTVnhqWTg2RjA3WGJZTWRPMzBzRW1LeE95TkJoYTV1?=
 =?utf-8?B?bDhMaUpjclovN0huUzg1U0F1NlJvSUVkZmRrRXBTUVhjdWs3QnhEazI4b0dQ?=
 =?utf-8?B?b0Uxb3dJbStiT3FkUnZCRmc1bXNzcTA1RDFCOER3UStCVmtKaWFmTmdJTUNk?=
 =?utf-8?B?S0NIZk16OEtDQkNZU3JiOStKR3VId015eXNMcGNYOTl0U0RDL0ZJNlcwL1Zi?=
 =?utf-8?B?SFZHL2djYTR1RkNYQ0FIcnZ3MTIrRjFkWVVlQUpRWHZNdDRDeXRqaTZoa1lr?=
 =?utf-8?B?L2hUTmRmRWV1ODBBdVdZbVFpalpheng3WTg5Wmc5NUVWdUVUZzYxUlZSN3Jw?=
 =?utf-8?B?RTZkWGkxcXJDV1NVd1F6MkI1Umd6L0hqQUZWYmh0SjJHaGJFNnZ5TUZlOThi?=
 =?utf-8?B?eEVDa1dVdDBqMFNQaWk3R1FtM2M4Z3lIM1c0TURhTDUxaktRT3pCMTMvYU1Z?=
 =?utf-8?B?dFdHeGpzUVM5YlB5ai9DcWlEZ3FlOWJoZkJ2ZkVLUUgxbktabXBiREltdTQ0?=
 =?utf-8?B?MTFPajRwVjB3bFlQMmNVWmZ4ck0wdlY2a3VYcXF5ckpOcFdJejNhaW1tSmgv?=
 =?utf-8?B?Z0NRbkprMDgvYWo4ditkZXdHVjYrNkIrbEVxaFY4QnRXS3RGZm5oK1V2ZldT?=
 =?utf-8?B?V2U3VFhib2xGekNSM3M4WFE1Y0ovb2QycG5yUFcveTUrVVpzaWRUT09XVWFy?=
 =?utf-8?Q?j4onOwWBsx1hxo1kxs80JO9HJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2DFD16EE67E7944F953E003828049420@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faf1c739-7985-4aa9-49a0-08da6001ac6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 10:15:53.0333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kf1eH/7q+rxYYBCUueE9170qJNG68Gp1RTQO4A5ozL4xeX6a60+U92UfSgunFQO7k59sNly2G7W5kWINicIewQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2617
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy82LzIwMjIsIEdyZWcgS3JvYWgtSGFydG1hbiB3cm90ZToNCj4gT24gV2VkLCBKdWwgMDYs
IDIwMjIgYXQgMDQ6MzQ6MjBQTSAtMDcwMCwgVGhpbmggTmd1eWVuIHdyb3RlOg0KPj4gVGhlIExp
bnV4IFVBU1AgZ2FkZ2V0IGRyaXZlciBpcyBpbmNvbXBsZXRlIGFuZCByZW1haW5lZCBicm9rZW4g
Zm9yIGEgbG9uZyB0aW1lLg0KPj4gSXQgd2FzIG5vdCBpbXBsZW1lbnRlZCBmb3IgcGVyZm9ybWFu
Y2UgZWl0aGVyLiBUaGlzIHNlcmllcyBhZGRzIHNvbWUgb2YgdGhlDQo+PiByZXF1aXJlZCBmZWF0
dXJlcyBmb3IgdGhlIFVBU1AgZHJpdmVyIHRvIHdvcmsuIEl0IGFsc28gbWFrZXMgc29tZSBmaXhl
cyB0byB0aGUNCj4+IHRhcmdldCBjb3JlLg0KPiBTbyBJIGNhbid0IHRha2UgdGhlIFVTQiBjaGFu
Z2VzIHdpdGhvdXQgYSBjaGFuZ2UgdG8gdGhlIHRhcmdldCBjb2RlPw0KPiBTb21lIG9mIHRoZXNl
IHNlZW0gbGlrZSBJIGNhbiwgc28gSSBkbyBub3QgdW5kZXJzdGFuZCB0aGUgZGVwZW5kYW5jeQ0K
PiBoZXJlLg0KDQpXaXRob3V0IHRoZSBlbnRpcmUgc2VyaWVzLCBVQVNQIENvbXBsaWFudCBWZXJp
ZmljYXRpb24gdGVzdCB3aWxsIGZhaWwuIA0KVGhlIGRlcGVuZGVuY3kgaXMgbW9yZSBmb3IgdGhl
IENWIHRlc3QuDQoNCj4gQ2FuIHlvdSBzcGxpdCB0aGlzIGludG8gYXQgbGVhc3QgMiBzZXJpZXM/
ICBPbmUgZm9yIGp1c3QgdGFyZ2V0LCBvbmUgZm9yDQo+IGp1c3QgVVNCLCBhbmQgbWF5YmUgb25l
IGZvciB0aGUgcmVtYWluaW5nIGJpdHMgdGhhdCByZXF1aXJlIGJvdGg/DQo+DQoNCk9rLCBJIGNh
biBzcGxpdCB0aGVtIGJhc2Ugb24gY29tcGlsYXRpb24gZGVwZW5kZW5jeS4NCg0KVGhhbmtzLA0K
VGhpbmgNCg0K
