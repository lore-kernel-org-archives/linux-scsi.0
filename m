Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD823C61DA4
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Mar 2023 21:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjCEV0d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Mar 2023 16:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjCEV0b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Mar 2023 16:26:31 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD3FEC59;
        Sun,  5 Mar 2023 13:26:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnyGYbQBo+No82WY0lXqE348F3TRA4i8BwAL8EtZSmLqEVCA4HouMTf3gNcjrxrg3tksJT2WQWq4MwVPzgptMyiVEwMxNr3wC+Cu4pzuqF5UzgB1XJjWx2SvORN4ICjUU+k3ljrjADn2EfzDg4nV7/MNHyzzKhjrCE7WKaJZuYefTRlZOP743h1ODbXdO3LqqWO0pADZS2Mtrb6WBfVeyeg5m+DP/ZFiPxrOPOHRoenUtGO8iQg0VdoEuBwU41FkB5q9xmvqRcDvmqVI1rB2Mfnr4Iy+I13lhFnWLeiYZCfkFRSdaYhvGqDirKJM85NlqJPdIzpXc72nf2lkrKsE7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nI7l3W/Up2YJsDA4SRRLA4vz6An0bou4pDVCgNQDWqs=;
 b=DOOp6+UjIZaVxWxO5aqabweHurjFBtlX1ouER/a6edSEJIKJ4Kp23Pyq1trFs/gaZ9Ub6RcDqPNOqEdtK2Pm6XSuUH+ukWQMgF53cVCSdnumtaLRN18/CDsyz+GgZ9nAOB2yTolxvBtU4bnC8L34marZTx29beUWkwB8F/0KpaDYXod5qkeMI5Jk+5I3i+Dw5RCUf2ysdevqGVCanr4DuUC+MMwy9YIdyJtbrU0CYsxZsGBCSVHTObs5rWXF4vb0AG7JX0wKfXVaf9E5AZpH8sPGMat9TfI47CItj//0SK4ck1f33vBk7zx7QGD5eQGaK5bersp4w7sCb7cGLVzpLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nI7l3W/Up2YJsDA4SRRLA4vz6An0bou4pDVCgNQDWqs=;
 b=QG6mGSpocFDVzHS9KSgyS3wwyfCjHlfQMXjAAquWBOJUdFDF6/0bGH8LeIDh5pJiYmFYke2s5EY4DZRfRgpKBxhDFevVYkTNETbRG7ybS9+7UcL7XzavEmo4r3Qmh0A/pjDY5/vh60o4UhkMZ7YKL2nixVwYn8LFhawVYOcqphof02Xkza3udivZEqdv9ji00vDTVe9S/pyojPvk3AkQQM3nS8ZZ3Kdo9lrFBxFQo6qLuf7AnAHRWy0YdxarPHUGEvVkoJVrybGRF5VGrIgsT/9sNHd/kDZtC96HEUlPzhIgGax/7xykrddgARHs+FY07PmCqY217hWk0rQoLbBNqA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH0PR12MB7864.namprd12.prod.outlook.com (2603:10b6:510:26c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Sun, 5 Mar
 2023 21:26:27 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c%3]) with mapi id 15.20.6156.025; Sun, 5 Mar 2023
 21:26:26 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "hch@lst.de" <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "james.bottomley@hansenpartnership.com" 
        <james.bottomley@hansenpartnership.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "snitzer@kernel.org" <snitzer@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Subject: Re: [PATCH v4 07/18] nvme: Fix reservation status related structs
Thread-Topic: [PATCH v4 07/18] nvme: Fix reservation status related structs
Thread-Index: AQHZSHgaeFqAy/2h+E2H8v5iQqIgd67swVoA
Date:   Sun, 5 Mar 2023 21:26:26 +0000
Message-ID: <20f34709-0a44-5e14-2be5-f4aa7da24cab@nvidia.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-8-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-8-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|PH0PR12MB7864:EE_
x-ms-office365-filtering-correlation-id: a96c306a-7842-4cd2-5ddf-08db1dc046f3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZJS4+msYfNJdo90W6ilRTHv9Y3X1qxvEx3cdDdW0WhzE+eDG0TMUnpeq9GrU0siIHcmwbuio1uqVAdYkoI1Z6NFaWSoGt62vC7VnFavvm66ieYIYmmQJYEZC6l5b/fqD4KXeW1ARHMEyp0FIAK8knJMySOwe4aQ1v47thipFDNzIEu8FXioCcYzNJjcHvwq/hTh+04KG8OV6DAA1dqhlDbrLtxYmWTMar0PnAbgqg+7v0OzB0Ww5V2ki1H4j/IYBmQkNMszxENiBOhWruE41YrLRzKBb6OgoGQ9yGJ/9/RHwTLr0qglAV6Ib04icdOotIBuKYR4Prb0kWcBSH1jnIJl1AftRsvAROdDvKtFirWG+StyJNR/2nS2NVX9+J6HjpgDaDg+DkwBAoBNGv+mGGF6C1CXCYrXbrH9IYsC+gu1zUp4sJeHyF0/+Jamts6aZol+MOHvQftV9dW8qWbP7Wt3Aluw2uxRl8rzJf/Y3qsqGtVvBYH7pwV4PfNc/O2iaY/ylM/+0wQo7iW9ivhWfwLTvkY4dKzj2+HvDeJ6W2PvZD56Yt1MyVt6CG7vLYVbex1ggFyrrMcMIh6fFfaxw/h/hZVdYZljzw6E0pcBWILtkZ1seD+S6X4VGBtyBoAOGpvvdjjbrTyR6PTW9PnZ/mghUm+s0TgDPEIR7zMhB5qJOheuXu/OsXAfptzXidGkUfxIzsxeahOUYUahN41h/Vy2p+pzOQvDL3PNmsMUyWzoEU2gSPtsQw90+qnNBqJWEuX0QYLAiKT/mPPcHJ1U9Zg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199018)(186003)(71200400001)(6486002)(38100700002)(478600001)(91956017)(66946007)(110136005)(64756008)(76116006)(66476007)(66556008)(66446008)(8676002)(53546011)(2616005)(31686004)(316002)(6512007)(6506007)(41300700001)(8936002)(7416002)(5660300002)(4744005)(122000001)(2906002)(921005)(31696002)(86362001)(38070700005)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SlFXQUV1NmNwdGhPQk10YmR1SFVlcU84QkpsWUtKczJ1TzU2Z2xjRUd1ODFo?=
 =?utf-8?B?aWV6ZEV5L2NUR1ovY0VLZ3dRK01hc2tnbjZURE9zMW5GZHV0QURjSXk1YzBH?=
 =?utf-8?B?VGdvbHlsRHV3ekRRWFJ2aFdZRmZmNTVKYVhYdG55Q3NlVUFlWVArcWl5U3R3?=
 =?utf-8?B?ZDQxTWpOb2VoUVplSXZwWksySjIwU1Z2WTRGck8va09VMDFNUkFpZW1tUWR1?=
 =?utf-8?B?SWhQNHpJM3BscEl5NHpGaGtBTzR2UUY1UnRnQ0xpTEhrRC9VYzVaZVFaM0VN?=
 =?utf-8?B?MmZPYWNIR0VOOHQ1eTNLbWNvRysyY1JUL3FGMjNRL1VVWDdRTDc2VE94TDBK?=
 =?utf-8?B?QkNWT3BndlpFVW56VmJwOCtYQzZNUUp0WGkzM1JjUElkTVVOSW1CZjJjN3Ay?=
 =?utf-8?B?bmM2MXlaREp0bnZyQy94ZXh0RHJyNDdYQWZXR0F5L2VEcHBMVTVheDQxVFRF?=
 =?utf-8?B?Y2daNnNpd2huYnRaUDZwVTI3R1pRQTNjaTRzN3o2UjNiU2dYOGpJR2h3UjR5?=
 =?utf-8?B?b3V2aTFzTGNXTGxBSjQ4ajJDYjg4SXJUSUE0L0ZoaVhzaEsrQ29aQkhSQWRo?=
 =?utf-8?B?MU0rRGhNMEpDZk5SQU9jeXFrNmZJNjJlZGhPZGNndHZwa1ZjV21yNFFid2JR?=
 =?utf-8?B?NC9RaS93Q0NpcnhLUWRLRjRMcDhSbnlhOHFKTUpuNWc1Q0V0Y3N4RVZHellC?=
 =?utf-8?B?NmpBZWM4WXNOOWZISS94RmdZazdJWkVVZS9tZmJHMERkQmdWL0hESzMyQkhL?=
 =?utf-8?B?T1lBUnA3aGZmN2dvcStQUk8vS1VyQ0N5SkR3MnZSMFZNMDdnM2xFMUZTNFpC?=
 =?utf-8?B?UnpXNFgzK2hMWFVGUE50RE55L0VvR1VCZ25zNnl5cmZucThZbm9YS3hTQ0wx?=
 =?utf-8?B?SDRSRnVvYXp5NGV1eThvMUNKRjhhZzhaUVRudUY1SGFxL2RkczVzeGxiQkFC?=
 =?utf-8?B?VEI1ZDBhYnpYWUVWa05yMTVISTFBR2tGd2N6dGtMcGJnbmYxaHc5dlRqVmhG?=
 =?utf-8?B?a3JJajBSSXRzbG45SERlZm9jWGVtMUc0T1NSOTFGSzFLS0F4b1lQa21nUmtY?=
 =?utf-8?B?MjZFbEQ4djFwTFdKUzNsTmlNcjBCTm8rZFg1V0ZmSEhvbXVVQVlNbXg5YnNV?=
 =?utf-8?B?TlV3d01nZHZ1Vnd5SkRWVERzcXBpMmVPaCtDMmFCWXdlRW4rRVRScDFrVlhP?=
 =?utf-8?B?RnlQRVhPWHo1T1c3Wnl2TWRJcXQ5akJiVTZ3cDE0U3AvTGtJZi8rS0d1aU5T?=
 =?utf-8?B?U2cvWDBIaVFqd1VYTVVGK21hcHdKVG9mYnJpaGtHVU9ON3h6NDRmMnhUS3NG?=
 =?utf-8?B?enZJeU1qclM4M05VYXNSVFRvZUNTR1o3TkQyN3dzOHV0ZFY4ZVVpcjl6TkNQ?=
 =?utf-8?B?S21VM0MzbnhCUjFWdks1VkkzZGNBVHFlQ3ZMV0dHNjdUQmpkandsaHFmOFdp?=
 =?utf-8?B?c3AxejhVckJWcGlRYmhwOVhydzl4YnVEVVNPS0RUMThpdGRPRDFORmxqY1FZ?=
 =?utf-8?B?RVE1MCtwQ0R6d3Y5eFJjcVM1aTJTdGhqc29Pa09pSkp1QTJGNFpZU1N3VWlJ?=
 =?utf-8?B?dm8vVGdGdkYvK2pvQXBqY0IzMWZXR0dQVFVxaGNOZE1lWEMrU2Vrdzd4UG1I?=
 =?utf-8?B?ZzFQalFyVVg2UzliZW1ZUTVNa2FHN29UakVJMVdlNkFxbkxpcHZCQmV6Q3I4?=
 =?utf-8?B?KzNzcm5WdVlubW5jWUNGbTJiQUxDUmJDYmZvOFFHdkljN3FwZUNDalhYTTFI?=
 =?utf-8?B?NlpBdTllNm5Iam1UT3ZIRlVUbjN4cEFxZTNTVzUzUGJ3eUFNaGJSNmlSRUsw?=
 =?utf-8?B?UVJuSlpDRXovbkVaVDVTMk51OWFhbnlhaHFaSmhBalQ2MUxCSncxWC9oTlE1?=
 =?utf-8?B?Qjk5MUJBMFE2amdHN2R1VlRFUzF0aDd1YzFyTkNIb1RVSWJzODdqM3piZjBs?=
 =?utf-8?B?VmIzZEI4T2E1clRmeFJkYkJMbFh1TUZHK001a1k4ajlyaDRWdGRMY3dJbUxB?=
 =?utf-8?B?RnBCazdQQjdnTFd3Zk90ajZhZUg3MkZjMEcwQ2JKY05rMFd3M2gyTWZDVFc0?=
 =?utf-8?B?bVJZcEIrRDcrV3Z5Z3B6ODQwU0xQdmNZQmEzQnA4MlpoVDBQUVlmOGs2RUpG?=
 =?utf-8?B?YWgvM2E3T0JybHpVWDA2VUE1OFNOaGZiTUw2b0h3Y3RJOTdCTW42bnFVUVp1?=
 =?utf-8?Q?/mXAEl/KjWkNxq4bf5c1duv5GrQFGD7c851Mq1dYBdv6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9795C1DFB7905F468E6A0C799D934CFA@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a96c306a-7842-4cd2-5ddf-08db1dc046f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2023 21:26:26.4025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FjH7+ZvEKFKuCTBnaC7+lkVyhWi/2DFqeSjDGSKr02TFjxLmwJQu+qPiMZPRxRPo3E+mWaIxHPjpyHIIIQAmyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7864
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMi8yNC8yMDIzIDk6NDQgQU0sIE1pa2UgQ2hyaXN0aWUgd3JvdGU6DQo+IFRoaXMgZml4ZXMg
dGhlIGZvbGxvd2luZyBpc3N1ZXMgd2l0aCB0aGUgcmVzZXJ2YXRpb24gc3RhdHVzIHN0cnVjdHM6
DQo+IA0KPiAxLiByZXN2MTAgaXMgYnl0ZXMgMjM6MTAgc28gaXQgc2hvdWxkIGJlIDE0IGJ5dGVz
Lg0KPiAyLiByZWdjdGxfZHMgb25seSBzdXBwb3J0cyA2NCBiaXQgaG9zdCBJRHMuDQo+IA0KPiBU
aGVzZSBhcmUgbm90IGN1cnJlbnRseSB1c2VkLCBidXQgd2lsbCBiZSBpbiB0aGlzIHBhdGNoc2V0
IHdoaWNoIGFkZHMNCj4gc3VwcG9ydCBmb3IgdGhlIHJlc2VydmF0aW9uIHJlcG9ydCBjb21tYW5k
Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTWlrZSBDaHJpc3RpZSA8bWljaGFlbC5jaHJpc3RpZUBv
cmFjbGUuY29tPg0KPiBSZXZpZXdlZC1ieTogS2VpdGggQnVzY2ggPGtidXNjaEBrZXJuZWwub3Jn
Pg0KPiAtLS0NCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJu
aSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQo=
