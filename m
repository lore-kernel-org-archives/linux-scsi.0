Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D394BC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 23:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiGHXxc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 19:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGHXxb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 19:53:31 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020D3BFA;
        Fri,  8 Jul 2022 16:53:26 -0700 (PDT)
Received: from mailhost.synopsys.com (us03-mailhost2.synopsys.com [10.4.17.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 531C445F96;
        Fri,  8 Jul 2022 23:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657324406; bh=xWxclkgL7lP5wk0VNB8w5bJoawl+aWU8BgwtkoSpVew=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=EB6r09I4ExbeGUz0EBPDFkmSs/Y4OROCDRSsNtTWjrJ+hgCB0W27MZzdmeqEHfGt0
         KeT8OVVo5bQAtB3P/RTiuCNqUixJhwOx44HJu3Uc9oiXILTd3H+yJmyPDHjwJMUBv9
         9BM6XTM3bLmHx67IyIqufDQy71WSecManmzU1AFyQkSPvl+4Kixp1a29t7aKJMi+yH
         vBGxoD1Uz1ObB4wQBY2eM9v72Ji+qDBe/uh9iuWKZNOaD0YDQCoE+PvnCGOndW5XBL
         aY1thf5GOG4W3mVTRdUK/XAHqzIAugiJgvRPomRxuQvT8kP4AQGWRuY8xKKmwvBMdS
         lhjD2wFWCytBw==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 75D8AA008F;
        Fri,  8 Jul 2022 23:53:25 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id B6AC6400DA;
        Fri,  8 Jul 2022 23:53:24 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="SYYO5Rxh";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ilLvQNczN+T0T1/ZtbEAi1vzukYiH7yaRQD5TwbC6mAFZSJSOv3xEB+waLaQbtuQ+C1erhCGdCfaJ6JgAJKIeohAfgg+tDzlJ5QE5uSPV3PMUYza9y4Lr8xIY3m9fE49mEPtrAw7l3HZxIqXzidADhRqeGybP/0skbJJr5j9BzzWkhiYXZQmMSv5Of819t7VZQkhUWMvP9Fy8SNvFa30mYO5BGgfdqgsSRCDOCTj4UkbhuPX/7nZxRBzxRWfG5WUltl7Ug7CaR7bX4F+ksXnAkMJoAdRMHxRJ8FsKcmz1SaMRUBkKogZbYIp8/HZg/8kMnNJp87Dmb0R18kDt+zV8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xWxclkgL7lP5wk0VNB8w5bJoawl+aWU8BgwtkoSpVew=;
 b=VKaglkvBZ4bej4sBedCUPFPqif8DMPROxQnfPKB8tl1Wg2mt6nUb9VdZdCNcnUzbPZv4KjM1ZGyep5xU1hy7wBYdIdTCSR7+m0HRKH/zlb7BU8WijLiFwM2XzNiVzIi3fRslevhPbs0/NgCm2vNWaSTlOeeJLauUPLwmkYH6/Fyz3wLpw/2O8YfRwSewzNleXLgXdyhEeXRbXY4MrpV7XJDze/Hr69iZFvMxVkYQGlDOutC1t3ad7Z/6C3+vU9QZf54FeG4xNupq9RyKeve7UE5BLINcQN1R1Td8A6+DCH4LbHSZ/MgW4bzXwCIVKo+w5l0rhY/Zx3CQe4MRe52C+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xWxclkgL7lP5wk0VNB8w5bJoawl+aWU8BgwtkoSpVew=;
 b=SYYO5Rxh5PJxRUEuaauO4nolEGjoymgofy4LQ/KrBmbNoD3luiLCobDNUVik4kkZg4/GTXm0YC32fJo5pmqm6YZt+YxInSgmQnTSkMUNf46hR7EcgEsg4k8sQqsytBai7B5TSNoVwWEyhgbULap8Pj5KAevIMmqIUd4JYGQgK58=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BY5PR12MB3889.namprd12.prod.outlook.com (2603:10b6:a03:1ad::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Fri, 8 Jul
 2022 23:53:21 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c%7]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 23:53:21 +0000
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
Subject: Re: [PATCH 07/36] target: Don't do tmr_notify on empty aborted list
Thread-Topic: [PATCH 07/36] target: Don't do tmr_notify on empty aborted list
Thread-Index: AQHYkZEJUCLWx4hntkK0dWU6sBESg61y6g8AgAI+nAA=
Date:   Fri, 8 Jul 2022 23:53:21 +0000
Message-ID: <f341d320-87c9-39d9-6f1f-215ab625e3e8@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <92ec6c71a200b42c1a70ba2054087da9715741c8.1657149962.git.Thinh.Nguyen@synopsys.com>
 <20220707133644.GE23838@yadro.com>
In-Reply-To: <20220707133644.GE23838@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synopsys.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0e62a5c-77f7-4991-e84b-08da613d09d8
x-ms-traffictypediagnostic: BY5PR12MB3889:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nrYNGgiMruYsdTkZoQSJ4rWgO44IG7j1zTPihVaLpgd8yBORS1KBxAhi30t2L9//t0yKufmMak6owJxoZqtu6BUxIzgKTpTQ6UFLfUakAUWoAC2EbJN+wz3GA/LsuCWcXKu2JTNz0t+/JMvyWN35Kqxly28IUR0yKqreUZntDKlM9E1xrkcE500T6K9+0D/A5O19PZ5WWED0/hGAdCefqTuC2uet6LXZKyBkUahlHv60YoEFP3v4kFfaQV2mRj9aJzzWsDRR/RR+E9KBAA++DihT/wQC2HrtsMEpisoEH8nWCJSXmQYcsxFuAyN1eeK8T5vYRES6tb6Qe5jy32dJ1BzQQEJS/m24Kj6Ai0tQoPjQd4lyyGgqO0LNch5aCPNc9dbsO+42mIQ+BT27mWr3vqbYPKY41V7pdzRFMTiQQK7c2BA+U+RuWsfdrcbIIFAwm27e21S+J6GATSPKC+yGXx5eHsidOcltJN9EcZoA3jQrNnBA8JKVE8ia+1UK/qNGMtxWxKGxFpDuSavxn7fWcFrfhZQIXr7J+lI+b06ZVryQHb4BsbzkYtAM8F+wk4u1mlE0LLwFR/Xt7mWr5hZyxMowTabCMYYkS2ZysF95IyRffy5o6ICX5y8fzKgIc5INx7IoojF9PF+t+Sh8SDPhHYac3fLXtTeEJ+BaHILn3mQwuR5DvtBKiNalpM0Qzh+Ccg+dZ3e2wKfCG3/Imer+t+gn6hiUJTlU3CcGTYLGL+us4qfbB+W1oM+VWQu7hBNbLNWYPABqwdkmIfGjqrNwlRz/fR8U9BWS/28WSk8YR6RXr8Yqge9Rs6phLtyss3WE3vCCsZmmgutY4FVu+UV5i43tAs3/wr+in+PPzcWPreWBxrVwrdL203xe/hnmq7Su190d3qGdiBsFCG3hN6rFoSGTB8u5nPjE918kIWwaHcU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(346002)(366004)(376002)(136003)(41300700001)(122000001)(31696002)(6512007)(86362001)(66946007)(316002)(26005)(66476007)(6486002)(966005)(66556008)(110136005)(76116006)(71200400001)(6506007)(64756008)(66446008)(38070700005)(8936002)(54906003)(8676002)(4326008)(36756003)(38100700002)(83380400001)(2616005)(2906002)(5660300002)(186003)(31686004)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eFB5TmV2enVjM3VGOE11Y085QkRPK1QyQnAyVzYvem80U1lDT1JOdzZZMjlJ?=
 =?utf-8?B?Y1ozekZNTFI2SysydUpnand5SVJKS1dWYUJVNldmMHBieVhPeWlhU1dkc005?=
 =?utf-8?B?ZVYwblk1MGVuNGpPYkZUQkVMYXByYWZXalpoVHU1RFM3OE5reUdPbUxWZy93?=
 =?utf-8?B?cEo2SHZNVXhwZW1qTmx0b3ViNGNRMHFBSTV5c0trVGYwRjQ2alJaZks2Z3lK?=
 =?utf-8?B?VTFqL1hIQ09jTFdheXNoSGUvWUFtTjQ4VzJvdk11dytyK0dqMkkzNlpMc0pJ?=
 =?utf-8?B?cXM5cmJSK21JNUNUUWk2SnJZbE9VTXBNakVKR1VRSWhsUkRoTkNBdzJzZmJa?=
 =?utf-8?B?WkVPWnd3dmdGUHZxNFpJWWRtYzdId2hLSUovZmtVK1dDallVY3M4MlRPNXlY?=
 =?utf-8?B?ZGo3TUF2TzlyTC9yVnlsOFpFL21raFkyajdOZ3dOYjdldDV1YklLOWNIMGxL?=
 =?utf-8?B?ODZDV01WOXVLRWJsazA3T3VtZXNlL3BtcklXazIwTXBma2Q2cS9aY3hhSzVB?=
 =?utf-8?B?R2hkczY1MU9DblFCNHI0ZkJwMzVkSFBucTRBTDNiUzBiUUVHVmYramVpOUw0?=
 =?utf-8?B?WjMzcTdBS3QvTW9FdUo4SE5EWjBEZkNUMkx3dmd3dmZiaVI3bkduNDVuQSth?=
 =?utf-8?B?UGlkd3R2dkFRaWw0cy9JbUtRK3NOaGZNbnJrT3E1TWV2bmh3aTlyd1dJeWcz?=
 =?utf-8?B?Y1Y3MFp0NExZRFZQNXppQU9KdnZ0VlZRRkdjNzAxdDVETkpOaWNqM1hRbTdz?=
 =?utf-8?B?MlpaeXlGM3c2SnRwSWdXeVZxM1graks3cG1IaTdBT0U4eVo1U0RCMUVraVpy?=
 =?utf-8?B?TmZ0dWVFRlhUYXd3WkN2NDNMTkIrWFpqWWhFY29nL1ltb1F1TDdxNUJLRmlL?=
 =?utf-8?B?YnBZbk1LV0dMR0tsZzA0am5IWXlYSTZqdS85NFVaSnhlc2g2VTNRTXZJWHln?=
 =?utf-8?B?T3UzbUpCSmtaN01UOTJJaE90Z0pWOXdQb205Wnl1ZjBkN0dLVnpvbU1OQUxw?=
 =?utf-8?B?RUFVZVRJZFgwdHpvVmJuODZFeDYrL24zMXpVVmRmbDZyajU2eXE4TCtuL0J5?=
 =?utf-8?B?YUhiRGQyeEY2TXpZZGh5MURldXNsNHJaSk5MUTBkeDN0bkE3ZU5oa2hmSHpu?=
 =?utf-8?B?bUhwRDBTTVpFaDFQTU1vaWJGc01hckdqem1jOHFpQmYxdnNWbHBUMi9WSWdY?=
 =?utf-8?B?a1lhc0JzT3FaTTRyQmIwV1I3d05YR25kbVlkT1hiOEdVVTRlYWNRRUtxNkdX?=
 =?utf-8?B?QkhENjhXaGlnU0JiNXYyenhhYlozK3FhaEFzeHdTMHFzMStrWXRzQURUZ3Vu?=
 =?utf-8?B?K3Vra1Y0TnNvOWg4Ri9FdjhBSXUyNkVDRXhYTU1HUXF4VVdlenJSbUlqTEVt?=
 =?utf-8?B?MjFNbXN4eGs2SGZpMEwwWk9UQnM2bEtaNnBWN0wrb1JpckRiekt2VElhR1lC?=
 =?utf-8?B?TXhmVUt2OFVlQjBQVG82clB5T3QvdGRMbzlTd1J4UFZxOTRhRVBXSFNmaGJS?=
 =?utf-8?B?alpNbEs4bzZ5YU5ZZ1p6Y1JRa2hDazdYMUVpNVVKUDlyYmdMZXFiNWNRWDBF?=
 =?utf-8?B?Mno3cWxVb0hzRGhMUWlwMXB2aDlmdTBaUy8vamNwSHJFUERGeENCZkszZUxz?=
 =?utf-8?B?S01jVEdYSXU5QmM1YldLQjM4UVdWaDVuWlJkSi8vM1I1Tng3R013WDJYKzNp?=
 =?utf-8?B?UUx3bkhLNkVuNmNNL0l0UkllODh1bThUbmFXeGlhaitub2FxMVUyM3B6L3dl?=
 =?utf-8?B?UTNCVmptdVVDUHFDNDNSeGZYM0lzL3dvOENlR0NXNUs2dzFjZ2xTOFlpajFx?=
 =?utf-8?B?UHlrcUtYbE4wR0RLeFBTcjFJUXRqdTBHOFlnSGhPZ0gzZUNsMi9QWjRRTlJ3?=
 =?utf-8?B?ZHJ2bWlEbUF6NG9YZFE1cWl0MWtIUks0YUtGOXA2c1VQNXRFaEdkQmx6Snlp?=
 =?utf-8?B?OHNuRTNMYU85ZmpLQlNVQ0tSSHU0YXFaVnZpR0hVME41N0N3anVEOFo2QWVU?=
 =?utf-8?B?UXRYZHdxRFljUnVSMGovcVdKSEtYTUJMcVJ1ZHFMU2gwbEpIbjJuRGEzYVl5?=
 =?utf-8?B?L1lRQ010NnJFbElnbGh0eUdIZEJaS1FicXd6ZFhubWZzT1dqNno0R3AvaTVZ?=
 =?utf-8?Q?lqga5f4aZqvnNktDcAtJ2fYOW?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1FD6BC9744DDD347BCE76548DF71146E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0e62a5c-77f7-4991-e84b-08da613d09d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2022 23:53:21.2299
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ceUcpgLJG4YrhnjwYIiptXBwPkfN/rzkhGeKRcP/RqLnWDYlFalsWTtZNtiBbJNbYt3wG1NsMdjg/oJfcASYpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3889
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy83LzIwMjIsIERtaXRyeSBCb2dkYW5vdiB3cm90ZToNCj4gSGkgVGhpbmgsDQo+DQo+IE9u
IFdlZCwgSnVsIDA2LCAyMDIyIGF0IDA0OjM1OjA3UE0gLTA3MDAsIFRoaW5oIE5ndXllbiB3cm90
ZToNCj4+IElmIHRoZXJlJ3Mgbm8gY29tbWFuZCB0byBhYm9ydCwganVzdCBza2lwIGRvaW5nIHRt
cl9ub3RpZnkgdG8gYW4gZW1wdHkNCj4+IGxpc3QuDQo+IEFGQUlLLCB0aGF0IHdhcyBpbnRlbnRp
b25hbHk6DQo+IGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwczovL2xvcmUua2VybmVs
Lm9yZy9hbGwvMjAyMDA3MjYxNTM1MTAuMTMwNzctMy1ic3Ryb2Vzc2VyQHRzLmZ1aml0c3UuY29t
L19fOyEhQTRGMlI5R19wZyFkcHZocHRISjY4Ym01YkNBYm90aGVrS3BjU2xuN25uZFgxb3FHN1Bl
c2JyS2Ezdng0UHk2OFh3S2QtU0FnOWhtWU1kbVc0QUFLOWNSZTd2T3ZhMndrTjUtJA0KPiAgICAg
J0lmIG5vIGNvbW1hbmRzIHdlcmUgYWJvcnRlZCwgYW4gZW1wdHkgbGlzdCBpcyBzdXBwbGllZC4n
DQoNCkkgc2VlLiBUaGFua3MgZm9yIHBvaW50aW5nIGl0IG91dC4NCg0KVGhhbmtzLA0KVGhpbmgN
Cg0KPiAgIA0KPj4gU2lnbmVkLW9mZi1ieTogVGhpbmggTmd1eWVuIDxUaGluaC5OZ3V5ZW5Ac3lu
b3BzeXMuY29tPg0KPj4gLS0tDQo+PiAgIGRyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3Rtci5j
IHwgMyAtLS0NCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDMgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3Rtci5jIGIvZHJpdmVycy90YXJn
ZXQvdGFyZ2V0X2NvcmVfdG1yLmMNCj4+IGluZGV4IDcyNGRkYWJkYTQ4OC4uNzE4ZDk4NWU0ODYw
IDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfdG1yLmMNCj4+ICsr
KyBiL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3Rtci5jDQo+PiBAQCAtMTY3LDkgKzE2Nyw2
IEBAIHZvaWQgY29yZV90bXJfYWJvcnRfdGFzaygNCj4+ICAgCQlzcGluX3VubG9ja19pcnFyZXN0
b3JlKCZkZXYtPnF1ZXVlc1tpXS5sb2NrLCBmbGFncyk7DQo+PiAgIAl9DQo+PiAgIA0KPj4gLQlp
ZiAoZGV2LT50cmFuc3BvcnQtPnRtcl9ub3RpZnkpDQo+PiAtCQlkZXYtPnRyYW5zcG9ydC0+dG1y
X25vdGlmeShkZXYsIFRNUl9BQk9SVF9UQVNLLCAmYWJvcnRlZF9saXN0KTsNCj4+IC0NCj4+ICAg
CXByaW50aygiQUJPUlRfVEFTSzogU2VuZGluZyBUTVJfRlVOQ1RJT05fQ09NUExFVEUgZm9yIHJl
Zl90YWc6ICVsbGRcbiIsDQo+PiAgIAkJCXRtci0+cmVmX3Rhc2tfdGFnKTsNCj4+ICAgCXRtci0+
cmVzcG9uc2UgPSBUTVJfRlVOQ1RJT05fQ09NUExFVEU7DQoNCg==
