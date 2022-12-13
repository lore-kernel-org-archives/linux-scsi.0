Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB86C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Dec 2022 04:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbiLME7y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 23:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233688AbiLME7w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 23:59:52 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2075.outbound.protection.outlook.com [40.107.220.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9045F1DDED;
        Mon, 12 Dec 2022 20:59:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dox98Ko80+OwWMaz/4KU17D4tE9bPyzv7+qK0/QRAxq7RQIaPNUjvbrnvDq0/RbgVd4JiJdW458oAM540AiikSTTeSCLv4sM47iCYY/Z5fa5TIKHuet9FV/1BwcmUO4fB5mcKYb4Q7y6tKQ1C2nVxz7qOcEwCnIbIkoo9xfJHj5KiBHnFfNrgF8/obSdVo6gQag0XASeDHkQBgOxg+Rq2oUr8me1tpUR2y7SnEZPiM623OIuyA1XZCIxvgBSYI+KYewiwqqXAA7meg69fJqxx6S5d7gclcxWIg8C1OCAB3jH5OmqApry3v2fwx1/HymE/itpvx/nv0a69o58HNVwfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g6WvKufIZCro0/zCtpQL2D98d0WqH9kugL/ErhdNfVo=;
 b=UvomYaa8jpfYGSnYFypsCAoGoWqZS4k7wv5U0Mf8BywfsOu12TTzJrn1Sn1TI3iPYkgsNywbsuc1gPINd7Tm6zMeU7LeR+fSsLC5lcaaJWDW1jefxnPaPTBlv2CrLS2p0yhOgvUl0JutHBhRVBUOUpxIs7+66q+Z4ACPi2juGSPj7St+s/7szE4fwOWrMCW4dALGJ0zmFoZmayFHcPHJsD3wNOgwUd+KXRB3yqNJQ3W8E75fsLnfzWHm1WI8Zzkc4TKV59FSw3bNayhBjqYXqYit+6Bp1dbmIZpa0Uyb2tVq5VkKyvcfnX1BatVmPZRP1VpYu95IRL3Zm4g3oXImzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g6WvKufIZCro0/zCtpQL2D98d0WqH9kugL/ErhdNfVo=;
 b=XSsP8FMXC+3G8icrAXyfjZtALmh1K5qAzZ/rqeQxL7JZ4VVExYFriBpgbyEbTdYiXRPISzrYvf4zMnF0Ba67P1JHeMDR5qDBbE+3t41c4xevlVeQHvZWOZX2LtDV1gzRGs1o0825Ssdqh8EFd68OcmnCsT1AfCo8iUGbaO0mBNRqNSKS/cpBfnffIK/kzq9ttkrpEd/82sHKqNJyE8BjNxLITk5VVM8+oQlrqwMn1y76HFdQkwwwMhYOzBFc5mN/ksYaSWHdCiWNW4ZWNjQgiiOxSR4pE2qBt6OU96yHL5JftxRBiAidpxTPP7D4yyzdSiNvZMJYd7i9o3OwN6TxHg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BY5PR12MB4084.namprd12.prod.outlook.com (2603:10b6:a03:205::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 04:59:50 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.5880.018; Tue, 13 Dec 2022
 04:59:50 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     Christoph Hellwig <hch@infradead.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
Thread-Topic: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
Thread-Index: AQHZCMWIE493Nhwph0Wuxc84G3ju4K5iC2yAgAAudgCAAGdJAIAAQiIAgAWW8wCAAtOpgA==
Date:   Tue, 13 Dec 2022 04:59:50 +0000
Message-ID: <b560029e-e10c-5fa8-8648-e1b765f903fa@nvidia.com>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <Y5BCQ/9/uhXdu35W@infradead.org>
 <20221207052001-mutt-send-email-mst@kernel.org>
 <Y5C/4H7Ettg/DcRz@infradead.org>
 <20221207152116-mutt-send-email-mst@kernel.org>
 <CAJs=3_Bu+tZqQk3JDzP0JfNbPZ8FG7mRNnPE9RrWUs8VOF=FzQ@mail.gmail.com>
In-Reply-To: <CAJs=3_Bu+tZqQk3JDzP0JfNbPZ8FG7mRNnPE9RrWUs8VOF=FzQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|BY5PR12MB4084:EE_
x-ms-office365-filtering-correlation-id: af6f455e-24d4-4a63-f20b-08dadcc6dd69
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jydfVwWHeV+TIbPe09z27wjprzEyFD3B4k+coMBasobTiyqQvopvDlLw8O0jaZ9P115QylVIKzNQHfaNMH9uwJrew9LuwjIBidLjsRiyN0k94Dy7THe0FY/WuiISjpI+syLDkopw+qe/Sf9fgbpS49RaoPQG9ToGuvZf2ngg51lsYHLBwGQrzZFc+fx+lrcBXhvHG5xM+3ySfhq6POV3gpS/Hunk/R7YpJo6vYgmmRmmhA1jFjB5zWPGY+w2klMnRvYf8Qnn4GeRL0sXCPcTCn0K/RzMhnisUAQIY4vC3sFPI67Ty1hURz2ZaH/MzUTmHPI24jQI5h3/G2reWVHKsY5vacfAKM24VJ9qRqDJuUqjR082HyfGLFgyzGRCXe29uIVRR7EvhvwMe4nOrpl+eMRnMk8vVnL2QjClQrUW6sSel88Ph6Tga7l7ANdtiO5CcE0hWSGtlYlyD82kPaEwk/iRASc3aTcu8bxSCvYNUSCGYyPMVI1ty1r2na7fwj/MLB54hMHW0lFo7oIZ7wiCR+wTbvvpJ2Ycw6jV92oWqykKGh3h1ERnTeQDjRlnAGhBYoG0yHwD4TpCTqXM8QidxvxTNu8+kOsKhy9w/nTVr5CmnW3yJYFwCRIIQxtaQKfBD1MBn2fZ0lbcJ1TWVZVlzincWXHgxkXpW4E/Q/u8lcE+in7URgU8/EoPh3oz3rb4PtRft1P+7I8LNNG+7gFZcOatwXjRFBJccNtYmjCKEmbLxwWQ2tpKpibYPc9OAnjYrxnKGokAzVJvdm1III8eLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(39860400002)(396003)(376002)(451199015)(478600001)(2616005)(186003)(6506007)(38100700002)(6486002)(53546011)(6512007)(122000001)(71200400001)(91956017)(66446008)(4326008)(64756008)(66556008)(316002)(76116006)(54906003)(110136005)(41300700001)(66946007)(8676002)(2906002)(5660300002)(66476007)(83380400001)(8936002)(7416002)(4744005)(31686004)(31696002)(38070700005)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y1NjbFVuNlFQaWdvNEtHSjJRNm1xT1NwVlNGa1ZGY0E3WDNVUFNpNDBOL29j?=
 =?utf-8?B?bXdKV1ZpVjFBMmFpUUdUWXc4QjVtME5RckU5bGlRa21oTnpLNDRqaHhvdFhs?=
 =?utf-8?B?LzUzd3NVeUZRSmtyZFI0NTUzUkhnMU9kWGN2Qlk4QWY0VmZ5SWErVWNhdDJ0?=
 =?utf-8?B?dlY3bnc4QVpqcUp1YjloU0JGeTF3dlBxNkhKNFdUNWFrcG55S1ZKdUI4NmZt?=
 =?utf-8?B?QlJHNkRNWEZvK1hLU2NHUXJZamNlNEZLQ2NNMW14SGtQejBTZUFValBsaVM3?=
 =?utf-8?B?YURtT2E4QUs0RWx0Y2IzaVJUUG00UWxMbWZVOWN1cWZCMks5R3FWbGFyaDhY?=
 =?utf-8?B?Y2RrUnM0U2JPczVvZ0szRWUwWUVIR0E3QUppTUVYeWlWbjJDV0RBZHZEblB1?=
 =?utf-8?B?RXRZaHN6VDlWNWs5VXMzTVQ5OXVZU1laQ3gyUHRqSlgwU3lWVFZUUFZuc1JK?=
 =?utf-8?B?RWNrR1JNSkxJcEZGUXh4MkhJNG9sMkRGNGNWenVHZkpvSEtuZGpua3liVU1U?=
 =?utf-8?B?Z1pZaHI4dDlJYnVaa09ic3ZES000ZXBmUlRiQWozbFJJdHY4VnI5d2NSR0Nw?=
 =?utf-8?B?OWNtbkNJdlpITEpkTEs1VVVpVDByTkpYU25WeCtRZ1pNbTdsL3Q1UEQyQVZa?=
 =?utf-8?B?ekU1V3ZFTDZJb3VKeXM3VmhST21iWlRiYThFWU1pWXJZMDNTak4vam5HekFD?=
 =?utf-8?B?aWg3RVlWRERkR3oydXdhMnMvdk5iMklEQjVvL0I2V2l0WUx1NURvZExWbHlM?=
 =?utf-8?B?VTl4SHM3dWh4dFBqOTBrOUJLd01xVVlQQVZBdTh4TjUrRVJUSlNaUHVqd1NE?=
 =?utf-8?B?TzJ2RkZ0RldWWUZsN2ZGQXB0UE1oVUZBcmhyV3N3WldlYWc2SUZFdHNwTVdk?=
 =?utf-8?B?TktTaVVnSitLMnc4WmcyWklvdm1XaW1ob2RqaG54dkFJdjRScmdJOGFLZWMw?=
 =?utf-8?B?WDFNVHB2Z1FEYmpXVjFvbGFXR2o4UjBoUWk2Z0s2QnAwLzdCUEhGbW9OZmFP?=
 =?utf-8?B?U3RIdWJMUWhObzU2TVE2U1dqWmdYazU2OHNTQzhNcmJVaVpKSW0xTEtWZEha?=
 =?utf-8?B?VmtjNk9jaVBFaGxFTU45bU1qemZNei8yTmFGN1oxT1oxbjgxS1pqTWxUclQv?=
 =?utf-8?B?L1hhZ1ErRmlDb1BpL2Jjekl1OUY0cUh0dmFOa0RFMExNbnE3MitaMWI1UWZq?=
 =?utf-8?B?cnVMZE16blErNDU4SjA2NTM5Y3hreHNxbW5HYnFpZzl5dVNwZTN1UFRQRXI4?=
 =?utf-8?B?cVhyVlUyRWVhcEVJUjJoaW05ZGRhKzg2LzZQcGRYdTZ1SjUwMk9qc1U0cVF0?=
 =?utf-8?B?K3JNdDNSTmJCbFBPdlVvdUlNK3dYQUlZQTJldndvTm10ZnArNHF1ZW5pbnFQ?=
 =?utf-8?B?UWYvUHEraUFnUU1mTUZNckkyM1hGY1lqbDMwamhPZldaTmxvR3hEM2VxaSts?=
 =?utf-8?B?MEpkWWhsOWhEcHdybE5ieVBoVzZtaFo0Mjhvakh6ZEhON01VRjhETk0wUjVH?=
 =?utf-8?B?MzcwV3E5K0xEM0lRNXFBVGt2QWFIdThJY20vVFJiMXQ0d1d3bCtVVFNtdENw?=
 =?utf-8?B?dGd4c1QycGNnOGRTNjBZcjA5WnZHZnJxNjIxQ294NytNMHc3V1U1TDdqU2Mx?=
 =?utf-8?B?VW9YTFBwVytyOXhtc2loZ2k2aGs5ZlhlWElRcW5VNHJQUGpId0V4WUFoNWdE?=
 =?utf-8?B?T3BycU1FZWN6cGlwSzdnc2tPOTB3YzlBZkUwdzlHSS92UUdxcWhLbDlsOXVW?=
 =?utf-8?B?T3I2TGk0NU9pNGJ4c2EweUtjWkVEWlQ2VWZta3owQ29NSS8rZXM3SG5uMnFK?=
 =?utf-8?B?eFVYYnhMd1prc0NURzExandoa0lDbEZQeVBKdmhoQkJIU2d5QmtNeWNkL05B?=
 =?utf-8?B?YVVuZ2d4WVB0NGZGSEFyY3dYeWN4UGlFbTNuNHM2UjFubnRRUE1nbkRvS3gw?=
 =?utf-8?B?Z2p3ZlJwWlNSNG43dHlEak40M1ZROTdsc1dTelFPYXh5NzI4QjVDeWsvczJt?=
 =?utf-8?B?andiclkwRC9kMHIxWVllQysxTFc3dTNaN0l6OFNmRDdzek8xLzNodWdtZ2VH?=
 =?utf-8?B?K3JDdUJUalNFY2ZIQVJHVUlBSVFpSkxSYnBDM3VtZ3hxNmRnOEF3QnpDd04w?=
 =?utf-8?B?Y2s0WGE1VUROM1l4QXdzZnRPVnVUeXJPWk9lSG9OTk9pVW9oclFIbE1xS0tM?=
 =?utf-8?B?emc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FBA671671B41B84A991D83A8451696E0@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af6f455e-24d4-4a63-f20b-08dadcc6dd69
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2022 04:59:50.2221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wkccF09sEtFNHoUy5BZ7c+CZ0V7gmDsVCCYp+XnIRdBBD806IZeN13ROAT0QLS/5kxSanbOqw+PtDEBOvnLTPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4084
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTIvMTEvMjIgMDE6NDksIEFsdmFybyBLYXJzeiB3cm90ZToNCj4+IEFsdmFybyBjb3VsZCB5
b3UgcGxzIGV4cGxhaW4gdGhlIHVzZS1jYXNlPyBDaHJpc3RvcGggaGFzIGRvdWJ0cyB0aGF0DQo+
PiBpdCdzIHVzZWZ1bC4gRG8geW91IGhhdmUgYSBkZXZpY2UgaW1wbGVtZW50aW5nIHRoaXM/DQo+
IA0KPiBPdXIgSFcgZXhwb3NlcyB2aXJ0aW8gZGV2aWNlcywgdmlydGlvIGJsb2NrIGluY2x1ZGVk
Lg0KPiBUaGUgYmxvY2sgZGV2aWNlIGJhY2tlbmQgY2FuIGJlIGEgZU1NQy91U0QgY2FyZC4NCj4g
DQo+IFRoZSBIVyBjYW4gcmVwb3J0IGhlYWx0aCB2YWx1ZXMgKHBvd2VyLCB0ZW1wLCBjdXJyZW50
LCB2b2x0YWdlKSBhbmQgSQ0KPiB0aG91Z2h0IHRoYXQgaXQgd291bGQgYmUgbmljZSB0byBiZSBh
YmxlIHRvIHJlcG9ydCBsaWZldGltZSB2YWx1ZXMgYXMNCj4gd2VsbC4NCg0KV2h5IG5vdCB1c2Ug
YmxvY2sgbGF5ZXIgcGFzc3RocnUgaW50ZXJmYWNlIHRvIGZldGNoIHRoaXMgaW5zdGVhZCBvZg0K
YWRkaW5nIG5vbi1nZW5lcmljIElPQ1RMID8NCg0KLWNrDQoNCg==
