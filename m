Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 386E7C43334
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 23:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238276AbiGHXLs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 19:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237328AbiGHXLp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 19:11:45 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571DA41989;
        Fri,  8 Jul 2022 16:11:44 -0700 (PDT)
Received: from mailhost.synopsys.com (us03-mailhost1.synopsys.com [10.4.17.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A2FC545F90;
        Fri,  8 Jul 2022 23:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657321904; bh=KHlt4mNV69tOHNmREAOp14yd3R8osBo/zOBbn6tQ++k=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=XmH/PaJ6caEqMGE16oI1UTapwIfKgLfKL7r9IGtKaF8tzrHtdTs/iItVDqf8SsfvC
         tmTIYESAI1BaZQ0/I0DQEA6ayslwcmEhQoBvvPFl83gKIHcLyDJM4C8zF+wvtm1tvR
         FzKAhVxp0g78RWjeKkgtHsqlQhhMMbrrxqddtdDreGH9rQSLOqNHVaTAsyJj+RDfBk
         xemFlmIUrJD3wW21o8Uk667EQbjgakpSVt2P/9vKQ9MjB22rE7T5/CFcRlJooVOjNu
         8tjjMQYVOLDm/8JjOATOHrCJyKU719+bnS7bq3Yq+c8iXnwQgTNygxtJ8/kKWSpSI5
         eJ6jqs61ekIiw==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 750C1A0080;
        Fri,  8 Jul 2022 23:11:42 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id CA9BE80078;
        Fri,  8 Jul 2022 23:11:40 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="ias7gM8/";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NKjLoA01rvA/F/+5ygUiMm7goOf3lVR4ilD09suF03P+aoyT5jzMROxm9Mj0iEjujWC2Xl6Ybg4IUXuR7S8KDhGYMff188UIu4xBUuoXz2tBt4+v4G4ME4Sh2iHQ+LQwwTdgruhFiJ+SHDgkcEDejwuOBS9769BDpPEcO16A/otb1dCGmCRjSp7yRTfvuzywPdoK57vcmIkB7FQz8pfLD6hCfZydGjWpbOkAdescRwcK2nG9TltHzcK4EMU6b6/hpuP8YtBZu0Qg1qefcTXpK+ZexzZHgb63RMl2ustxlkBJ8+vFcFD5hg5Mzn1o0eqLqJBBo1lWuEe7TisCxFshgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KHlt4mNV69tOHNmREAOp14yd3R8osBo/zOBbn6tQ++k=;
 b=L4oI9V/mqwmt86JpFMzh1zP6/udhpLBf8QfvRhb4eId8aG0dXEd+En1V87ChTrYzRWtpVdvVW/k1aHqNy0uWOybQapvcjiXBXbD5wnCBhVz3U+aQWHTcYLEvk1dbbXtaiK43Z9dsY1SWZSY7PZHn6CKSjeFK8zygNv8FlWfzmwTyqyEYYAtUQrhkaw3DZ4T6lZ0pOBpn8aifyBkR6khVUAzHUXagYp+U3ATTAdQzyEuSHbvD1+kF4juFHCgX0ovl+W1Ki4CrOCQdNAcajOwXRk2KllBpwKU5YP+Y+WmnOHMhFzkFARHOiF2si3zVBLLbVTo54HNlY1owPn1DPJ1dsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHlt4mNV69tOHNmREAOp14yd3R8osBo/zOBbn6tQ++k=;
 b=ias7gM8/Z5G/jE28hFYZUZC7hJf2tde+p5CKxjaVOvdcMcBlWZ1/L/DVUoFvRbp6JA22idoFOMQ82SciCLoWi+/1cYmrfqmkEImIJuZjagsnnPvYVrjrgbZwIsedAsT+Ui2yoifLbj4BWiuJKdl56pXtQfjHawMxTu3I4Vl31Fo=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BYAPR12MB2648.namprd12.prod.outlook.com (2603:10b6:a03:69::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Fri, 8 Jul
 2022 23:11:37 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c%7]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 23:11:37 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 04/36] target: Does tmr notify on aborted command
Thread-Topic: [PATCH 04/36] target: Does tmr notify on aborted command
Thread-Index: AQHYkZD+KpUxHtfPikWfNnfwlTmL+K1y3vKAgAI+EYA=
Date:   Fri, 8 Jul 2022 23:11:37 +0000
Message-ID: <154d432d-b91d-d16f-d5d4-89fd8eb7eb7b@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <a15b6eb1fd62e7e8bc7ad65f77cd327a2afde07e.1657149962.git.Thinh.Nguyen@synopsys.com>
 <20220707125657.GB23838@yadro.com>
In-Reply-To: <20220707125657.GB23838@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synopsys.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8f38c721-822c-474f-7dc1-08da613735a1
x-ms-traffictypediagnostic: BYAPR12MB2648:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3KLByRq7HLw1o6xi3hOGeLKYzcFZxLad3OOdigQGZsPl9rMxuOpi0k2B/DQXpStPHH1xYV7aBSEvKQz7KH/7gqZpZMHphfVay2bwDwYia7dHAB3oBQ0ty7oUPjaNl9CpldLSPHfq69WliyIzjaPGGEfTNAGkTxDzPV/mUHe0sEDUAGxVn6VKQX9WIfTJIgls+hlXUm2qpEHj2Z+Jr1/pvHwrW43MDpaOxzUvanhKEMJwGekSEsOrz2ViDOZ3frHT7L1Hsu2ZxFvnSkCeJvmuO0ynkbnNQMsO4H1BFvntnev/qRYcHmARaA5TFGgLhEgGNUCbRF/PZe5nSahiikXaacOdfbUSV0YHc7cfF698PfY8akYv2dd8dC3VKd9xVTpNc1ILPjOl0cu7wtNNnQLpGxELFgwv/JwWHmRj40cKXWrn131W56m2beQiAOsan7iT0zu2OdwVSNdtnH29igLeaKcgYZBRU7342x6U5MCE0Fxw5xLViuEcpAZ2cLay5KZp0g28dbqQB+h4n/P4WI8/G/4K3zamlY1RxeuhMEvdvMR3sBd2Mo86tUtX8l3BCNlqXcSMCyaJHoUgo82VWPuFof9Yp8uNoCbLHrQmh1KbOshNxc2siJDlLHa/3ezWJxHwcvTZ3U4yzOtjeHkmkQNyxFUavcBphskpt98BQCl8ZB2+oFKsY97bncMG+JsBnxpvht5BLxdio1FCyEjDOb0rJ180E1jZEfvPlYtXh8DIXLSX8rmnfzXj7Ouy4v58TQpTILHB2+xbQiUi1cUtWIIeTGvHAP409826ZCDkJJW9DCoFeW6obzJFPFVEsbs7BhJ16CSCAKfP6mPotH12gCxgb6TXzixqYSDryNxIHwgil08yW0hawCoW1N+LtnI9NcYV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39860400002)(396003)(346002)(376002)(136003)(4326008)(8936002)(76116006)(64756008)(2906002)(41300700001)(6506007)(478600001)(66946007)(6486002)(36756003)(66446008)(5660300002)(26005)(66556008)(38100700002)(66476007)(122000001)(71200400001)(6512007)(2616005)(8676002)(38070700005)(31696002)(86362001)(186003)(31686004)(54906003)(110136005)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NHJ4VDJXRC91cjhyN2pPVFNGS0FKcFN5b1lQRmc4NmFiMkdqYlpScHl3dW9Q?=
 =?utf-8?B?OGJ0d1ZIdzAxcjFTVE0vTGZiS3NSVkR3TU1KMEhZQTYyeUdIUi9ONVphM2FK?=
 =?utf-8?B?SHgwVHVncHh5L0dTTE9uUVBNYXNKd3RoeG95L2tuakkyREduZXltMHlwZHpR?=
 =?utf-8?B?QVNBZUtVRU5WRm1USDdmdWJhRW43V2RuUGYxOUtTam4ydW03SUxSYmg3Z0NF?=
 =?utf-8?B?Q0ZQV3gwclJxVGttTklvUVlHNy9GdXRpaEtCVVRLVEpLcWlRclhKUk14b004?=
 =?utf-8?B?NmVsMWt4M1JSL0MySXc2YmxvcnFNNFBVei84T2QzaVN0KzVoYm9WUmJ6UGN4?=
 =?utf-8?B?MExYTlBTWWlydkR5aTRsVHZWeEErUnlsVVEwOEJHZzVQSWE4eXFNRW1XQzBQ?=
 =?utf-8?B?NkU1d1F4R00zWnNRc3hzU1FZNE1XVWlXWHRxcENKcmFCdXF2Sm5KRWZIK1Fi?=
 =?utf-8?B?ZnFjQlVnMGxKdWJvTXZMaEUvYnhVSG81REQ2SzR6dHpHdkV0RWZwaUJtR0JQ?=
 =?utf-8?B?NGRGZ2RTWjFyMkpsUkkxYVVrbmprdnJXUzRoQWJUY1M3VkpQMmtVSkFxb0xU?=
 =?utf-8?B?V2VsM1hybkw5WDNNZlUwNS9JR1NsdFVPcWp2aUhBV3JHL1RGZjhNQnlPNGZw?=
 =?utf-8?B?dnlqeDVpcjNqejJ6N2NiRENiOW9xVEk0ZDU5aGFLLzdGd1l6c0lWdHd6UkY3?=
 =?utf-8?B?QTB6VVNjdVdmcjIxWlJNN0hWc1h3NEZON3NXYzhQR2U3UkZTTms0YkdvVWIz?=
 =?utf-8?B?MjE5S2ZPWEFWcTJESktPSTdOc2RLK280TDJxSXArS2hwV1h2MDNhRHgyV2xJ?=
 =?utf-8?B?aE1zWXFHeWFuRWVYemRveUNQd0w5V0pIbUZBTW1XUGJjeTlGY1pMR1dwZVV6?=
 =?utf-8?B?a1dFY2llUzdDenBncWNpZEZiVS90b0hxUUNUSHNLR3hZclMxaksyaktuUFJp?=
 =?utf-8?B?cHFYclExN0tha0FoeTBXYlNMOFZsRWhhMmJiRVhvN0N5RzJXeWwwK0RmaGNF?=
 =?utf-8?B?a0dLTVA3aVdmTHQ3WVpFZzE0TGhzQkYvWm01dkNqYmEydWhGNXpOWmt2TkQx?=
 =?utf-8?B?QndrRWRRY1BZN0o0Zld5MklxT3hISTlCVE0vQjduUGZXS0JyckVCcWNadCs4?=
 =?utf-8?B?a3hKUnhXS2JrYVRNVmlSRUtLNU9jenJ1UmJVUlpWWnROTVA0akZMckxOQmNh?=
 =?utf-8?B?M2NncGl1Z0J1dXoxMXN5QWQ3Z0xISHVoUi85VU9yN3JMZjRrZHpubnVHc2tv?=
 =?utf-8?B?bGVYL3hlNnZ5TkIvQndaM3Q0QnZPNGcvdWVla3RBQ3pQekEvN3VGUS9aMzNh?=
 =?utf-8?B?T2lWYVRRU29pdHVMd0FCa0llQWhLSTB1NUpDUEZoc1g0NnBQa2tJV1JzbTJw?=
 =?utf-8?B?d3VtOEdYMFpRaitROGpuNnF3MEw2MVk0M1BvTXZnWXBmeDE5V3lqM3ZEVzFI?=
 =?utf-8?B?Q3ZHNFk4KzVtRWRTaDg4K1h6cnR3cHc1UzhrazBsQWdoQW5RdEhCSUdJbThY?=
 =?utf-8?B?ZFZRWGhsL1NmdjFRWWRNZjd6UnczNDlod0pkbFYvWWc3THNxWmRNWUN1RFAx?=
 =?utf-8?B?djIwcmhQMitpMHBuOXBpYnZxTGoya0JSUWdOOVFnazVJWWNqRkg5TG1pUFJq?=
 =?utf-8?B?bTJXaXBwM24zSjNnUGFrTTBQUDJBeWpOVVpZYUgveC9TQ3R5SlRBUkRiaE5V?=
 =?utf-8?B?NWdFNGN0NlgvRUgvWTNsTnB4WFVlN29zcTN4eW1tRGtjMDVKNUVjSmhuSHpp?=
 =?utf-8?B?QkxHdHc2bVBnSUp6VUphaUsyZmZ5ZXNOTTBTT1hKd1VHbkZUaGVYRERkMGt2?=
 =?utf-8?B?R21YbFIzaGRZMTMvU0F0VG5aM0dmNG9tM20vSDRiL1pUeDdwbTVaQVZINTll?=
 =?utf-8?B?WFkrSURRVGJMdkkyQ0lZYlRrb1Z0VllsZlluOC9hWGZJTlNNYTQ2UnBOaGJS?=
 =?utf-8?B?K1pyVWYyM3gveGdTZElhQjRnR0xWUTkxUWVtanZXZUxPOUQ5amJ1WnhBZmM3?=
 =?utf-8?B?SU1FdVNya2JuQ1duNkZtNXhwWitTOVlaWFRRcisveklWT1hORG5CWGx6TTVY?=
 =?utf-8?B?cVlDMTd3NURtN2xXdWY3WXFHcGxOajhiM0hwVmZpUHlDLzJ5eDd3ZHNwaXNp?=
 =?utf-8?Q?OodVPOokm4keMY4/fsQeFmJQb?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FF38C222DC039F45A10FE3A93DD6F826@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f38c721-822c-474f-7dc1-08da613735a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2022 23:11:37.6592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KNDdShTvxReFAm0NavvOxDiiQDEi8GVJ/TSAdJV/J3+bAxDi/lU86T8MKmhBob96WuT2CMp01Dku+GjCMB60zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2648
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy83LzIwMjIsIERtaXRyeSBCb2dkYW5vdiB3cm90ZToNCj4gSGkgVGhpbmgsDQo+DQo+IE9u
IFdlZCwgSnVsIDA2LCAyMDIyIGF0IDA0OjM0OjQ5UE0gLTA3MDAsIFRoaW5oIE5ndXllbiB3cm90
ZToNCj4+IElmIHRoZSB0bXJfbm90aWZ5IGlzIG5vdCBpbXBsZW1lbnRlZCwgc2ltcGx5IGV4ZWN1
dGUgYSBnZW5lcmljIGNvbW1hbmQNCj4+IGNvbXBsZXRpb24gdG8gbm90aWZ5IHRoZSBjb21tYW5k
IGFib3J0Lg0KPiBXaHk/IFdoYXQgYXJlIHlvdSB0cnlpbmcgdG8gZml4Pw0KDQpJZiB0bXJfbm90
aWZ5KCkgaXMgbm90IGltcGxlbWVudGVkICh3aGljaCBtb3N0IGRvbid0KSwgdGhlbiB0aGUgdXNl
ciANCndvbid0IGdldCBub3RpZmllZCBvZiB0aGUgY29tbWFuZCBjb21wbGV0aW9uLg0KDQpJIHdh
cyB0cnlpbmcgdG8gZGlyZWN0bHkgbm90aWZ5IHRoZSB1c2VyIHZpYSB0YXJnZXRfY29tcGxldGVf
Y21kKCkuIEl0IA0KbWF5IG5vdCBiZSB0aGUgcmlnaHQgd2F5IHRvIGhhbmRsZSB0aGlzLCBhbnkg
YWR2aXNlPw0KDQpUaGFua3MsDQpUaGluaA0KDQo+PiBTaWduZWQtb2ZmLWJ5OiBUaGluaCBOZ3V5
ZW4gPFRoaW5oLk5ndXllbkBzeW5vcHN5cy5jb20+DQo+PiAtLS0NCj4+ICAgZHJpdmVycy90YXJn
ZXQvdGFyZ2V0X2NvcmVfdG1yLmMgfCA0ICsrKysNCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDQgaW5z
ZXJ0aW9ucygrKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29y
ZV90bXIuYyBiL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3Rtci5jDQo+PiBpbmRleCA3YTdl
MjQwNjliYTcuLjJhZjgwZDA5OThiZiAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvdGFyZ2V0L3Rh
cmdldF9jb3JlX3Rtci5jDQo+PiArKysgYi9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV90bXIu
Yw0KPj4gQEAgLTE0LDYgKzE0LDcgQEANCj4+ICAgI2luY2x1ZGUgPGxpbnV4L3NwaW5sb2NrLmg+
DQo+PiAgICNpbmNsdWRlIDxsaW51eC9saXN0Lmg+DQo+PiAgICNpbmNsdWRlIDxsaW51eC9leHBv
cnQuaD4NCj4+ICsjaW5jbHVkZSA8c2NzaS9zY3NpX3Byb3RvLmg+DQo+PiAgIA0KPj4gICAjaW5j
bHVkZSA8dGFyZ2V0L3RhcmdldF9jb3JlX2Jhc2UuaD4NCj4+ICAgI2luY2x1ZGUgPHRhcmdldC90
YXJnZXRfY29yZV9iYWNrZW5kLmg+DQo+PiBAQCAtMTUwLDYgKzE1MSw5IEBAIHZvaWQgY29yZV90
bXJfYWJvcnRfdGFzaygNCj4+ICAgCQkJaWYgKGRldi0+dHJhbnNwb3J0LT50bXJfbm90aWZ5KQ0K
Pj4gICAJCQkJZGV2LT50cmFuc3BvcnQtPnRtcl9ub3RpZnkoZGV2LCBUTVJfQUJPUlRfVEFTSywN
Cj4+ICAgCQkJCQkJCSAgICZhYm9ydGVkX2xpc3QpOw0KPj4gKwkJCWVsc2UNCj4+ICsJCQkJdGFy
Z2V0X2NvbXBsZXRlX2NtZChzZV9jbWQsDQo+PiArCQkJCQkJICAgIFNBTV9TVEFUX1RBU0tfQUJP
UlRFRCk7DQo+IFRoYXQgaXMgd3JvbmcgYW5kIGJyZWFrcyBhIGNvbW1hbmQgbGlmZWN5Y2xlIGFu
ZCBjb21tYW5kIGtyZWYgY291bnRpbmcuDQo+IHRhcmdldF9jb21wbGV0ZV9jbWQgaXMgdXNlZCB0
byBiZSBjYWxsZWQgYnkgYSBiYWNrZW5kIGRyaXZlci4NCj4+ICAgDQo+PiAgIAkJCWxpc3RfZGVs
X2luaXQoJnNlX2NtZC0+c3RhdGVfbGlzdCk7DQo+PiAgIAkJCXRhcmdldF9wdXRfY21kX2FuZF93
YWl0KHNlX2NtZCk7DQoNCg==
