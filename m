Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 174CAC55185
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 22:10:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC7072077D
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 22:09:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="t1zPSjyr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgDVWJ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 18:09:56 -0400
Received: from mail-bn7nam10on2084.outbound.protection.outlook.com ([40.107.92.84]:6209
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725839AbgDVWJz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Apr 2020 18:09:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mRsL2m5DdhPUG2IQ7Y9/ghGIHAOfbBNGZXgb6pD3QS6UG/+RjWCs7eZ1b3/zJergB4yIGBZv5NneuJn6jKTA6Ir0ETvT/Hbc2XVAZcWtK74hcoipAqjiXva3CgZQn46qbNVtluO6uRiVSqdR14sM5bv9OVG7T+biQblxtYp8Y+QBCes4hvrbYkVdyP77TEYzfEpTj1EhU9olobOTlMaBmhbdF0/RiYe3+/gLrkBDxsep356HNyshg6T4u/D89mQsHQLaIeKraFEL82iUtbGLegyhBY5HLSx2kw0ohd2q+C3N35VOy1vhW8IQPzY8UflPaVBlJrHOF7eadzEb9w4UoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XhEQHdFy3wo+4M1Guxjc205YW+7KVFqiF5NFv2VbqSQ=;
 b=Pcv3WCmh1sR7uZ1eEtgecPClmNmLCK+LOwYS0QNpWYyrGk/DJzj6MfgtdiuspT+m2IRrzCyZWjj+clq0x+xI0x9iiEt5ile2h5yxsKOxve5dF9ypraX0h1UBnewCc4eQU8UIMZ5Wv9Q9YA0pK3bSh5TQlEssi8smvHImZCJlg9r+wbx9dqAr1nFApAawj8wSQv6P0HSllYrSaW1WBLxRzHumoN+KlYNu0HF+6QPSVFY8vP7jrBlp3A4x/AIdvNhQ+ss53TRQ1trx2Wb6xunOUB7X4FcxRSp9yLDbLCKjleYtkODgcyBGHIGtJre3xM7X4EeI3hpDqP5rscwSOYPGng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XhEQHdFy3wo+4M1Guxjc205YW+7KVFqiF5NFv2VbqSQ=;
 b=t1zPSjyrr6pOBIbiLCtE7mNvOR7lEwSlJaHKOljf/UfR9qS+n468r2KUXzGx2u0iT8p0TnI9BH/8pOFSnhvJKPie0BybVfPqcNBduT/CUbCKisLkf+hkSLllSq/WMCRfm0VFwEQfjWMvAV7ST01YPtGJPgcJqUnxiA7pCaDx48w=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (2603:10b6:408:35::23)
 by BN7PR08MB5105.namprd08.prod.outlook.com (2603:10b6:408:2e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Wed, 22 Apr
 2020 22:09:44 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::5dbb:4fb8:f0ca:6988]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::5dbb:4fb8:f0ca:6988%6]) with mapi id 15.20.2921.030; Wed, 22 Apr 2020
 22:09:44 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v2 0/5] UFS Host Performance Booster (HPB v1.0)
 driver
Thread-Topic: [EXT] Re: [PATCH v2 0/5] UFS Host Performance Booster (HPB v1.0)
 driver
Thread-Index: AQHWGHFaOlBFIchFpkCk1ppibzNpUaiFs+/g
Date:   Wed, 22 Apr 2020 22:09:43 +0000
Message-ID: <BN7PR08MB5684489A31196E4490A38DA9DBD20@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200416203126.1210-1-beanhuo@micron.com>
 <20200422064324.GF20318@infradead.org>
In-Reply-To: <20200422064324.GF20318@infradead.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWY2YjA5YTMyLTg0ZTUtMTFlYS04YjkxLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFxmNmIwOWEzNC04NGU1LTExZWEtOGI5MS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjE0MzAiIHQ9IjEzMjMyMDY2OTgxOTYxODY0NSIgaD0iQlVhWFNQRXYvVVFBYnFFUHRaV0F6aUtIMTNFPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSEFBQUFCVlJRcTU4aGpXQVREaVJVckMwbk5LTU9KRlNzTFNjMG9BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQkFBQUFTNnRBZ0FBQUFBQUFBQUFBQUFBQUFBPT0iLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c5534b50-5073-4f02-0ca0-08d7e709dcbe
x-ms-traffictypediagnostic: BN7PR08MB5105:|BN7PR08MB5105:|BN7PR08MB5105:
x-microsoft-antispam-prvs: <BN7PR08MB5105E4DDF935CEE88ABB2575DBD20@BN7PR08MB5105.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-forefront-prvs: 03818C953D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR08MB5684.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(54906003)(86362001)(6916009)(7696005)(55236004)(7416002)(5660300002)(186003)(26005)(6506007)(2906002)(81156014)(8676002)(64756008)(8936002)(316002)(66946007)(9686003)(478600001)(66556008)(4326008)(33656002)(76116006)(66476007)(71200400001)(52536014)(55016002)(66446008);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WSmVv5oTmbXifrqtezjRa7JfWIl4KWjQCnyDp4iTQ5VaZUOfz7k8b0aqaiMrKUttAKPalr2Mf8TcP4oycHQvwdwBBngSdKFFz/MNAEfs8Gv5N/24nTpTULcN1QpinEIWk5zyAEojm4S2UTzjMLe2DlSU7vbJjLkxwMAv2/WU9W+Pj147TM+K5mowR1X/yQaVcQ3IeQW9YlqeI2PlIhdZncAl4KJfUEkwFUX8ZByuC9uElzSc4qiCYLo0DS4f0vaEmqhOM7g6+agikp7j0Zv30g8rkiYO4HoNprkb8Z9GbLP80VYXV9p8hMTmYSTrgXbRncteVri5lFewJJt9UvKLgcgnobdMse9ydaWoCfxzqqOwpDW9GsaotkkUJL8hFwo7qOlh6ULtf+mA1JE+9/27p+8rdhwM1KsSd0OO7W5RBw71GgIG94gC3xdcyypvAidd
x-ms-exchange-antispam-messagedata: 4WDclUtSHwFxwaMxepLb6ufHf1+hCUcnaSbZMbAdqS463ziYR9NxJhO62gOwSDiXyM/m4hWDjmLrVh0sfVJI0RPppWxnIgxFiGGnjXty8b+Ed3Jfd6xpZUzRga4/lYxwErQ8EVhIPA0XId0vYuHK/SmLW9v7C76UksIrBN+lnaJmg6uQ6te7GCc75uWfFck7yTNsH3Suze7Y0TUaVyoz4tqZH8jzQGoXTuLhEhtwQccUl7v3BWYpWhA8NHAKV1++tUMCLu+AZzoCoZDMyg88wWxjf43Sh8l3EQSSvLq9lOFHYO0eCORwRCQqF7bzgbSCev0XZAqnelpmfDQc3vU8SH6S5xDwsQ6FYtd+pnfr8F4VFH7cgnqLZraAjLBd4AybonGWx+HqxVY3WmeAFnHOR2YZ2dz7G65Mqa91dMVjQZGKmOn/uC5eH8f+YxsKMe71JqZ/GWrhdTzCypjVaTgN9oL8q8Ub5t7tZYOOa/PLTih/MexDoExnbR1qIFIpt5+PpH8K9faoM6/AvpmGgFTDK1JI/ddp5cuJc0xKRIVxwXN+NeKXkNfRHVbu0kGeuPMijhISZcqyZcXhPYI0Ykd0mQNWX08mTnT36n8/EwS7eccSYHZY4c9q1TClEkwq4/7i1XVMy4jTRZH0gZ05z+2yJX2INFfWNQO08VqfotX1pyIYHkO8l3kogaSUIoElVROOT5xU5Zim0zN8hfeuE5kUN+WRXYtb3y/vn3OfmpQOVvmStyB6t2ouegDI1iAl6Qb0DTV13eohw6oL6MlVKYL88NagGYHceXoD2bkQ6qwrihI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5534b50-5073-4f02-0ca0-08d7e709dcbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2020 22:09:43.9609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x3Y8NKeh+TATtTD7D0w8c7TIGdh6y4q0W0KkjqTojzcwBqzecGbv08ezZCmOQzmuavEIw2HCA1rJpHcPPCHl6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5105
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Christoph
Thanks for your feedback.=20

> > To avoid touching the traditional SCSI core, the HPB driver in this
> > series HPB patch chooses to develop under SCSI sub-system layer, and
> > sits the same layer with UFSHCD. At the same time, to minimize changes
> > to UFSHCD driver, the HPB driver submits its HPB READ BUFFER and HPB
> > WRITE BUFFER requests to the scsi
> > device->request_queueu to execute, rather than that directly go
> > device->through
> > raw UPIU request path.
>=20
> This feature is completley broken, and rather dangerous due to feeding
> "physical" addresses looked up by the host in.  I do not think we should =
support
> something that broken in Linux.
>

It Is not plain physical address,  has been encrypted before loading from U=
FS to
HPB memory, I think we don't worry about its safety.

> Independent of that using two requests in the I/O path is not going to fl=
y either.
> The whole thing seems like an exercise in benchmarketing.

I agree with you. This is my major concern. I have been thinking about HPB =
implementation in SCSI layer.
That will let SCSI layer manage HPB by calling UFS helper interface.=20
If you don't consider UFS HPB is an idiot design,  I want to  change in ano=
ther version.  Firstly, we really
want to hear your suggestion.
Thanks,

//Bean
