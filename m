Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D3BEC6FD18
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 20:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbjDRUJO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 16:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjDRUJN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 16:09:13 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358C34205;
        Tue, 18 Apr 2023 13:09:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PXZTPQ4+AceNvsknskoz1EAm3ro+Bt0fjdPk9/BRwALnfWtRna4Jn5mo43aM9EZ3ZGuc/tq5+a4So7oaaDo4jH7J+HoA4wSKr2XTCACadJLOehiMvDG3hvfii+9iH/6BfACj1vb4DYaobIgwXuVvi6HeGi0N8et6RzCYmOYDvldnpBK3Irj1s3bK8ikIE0cN0rRgfn2NwXu30hckMnhkmHs01H+yWESLGgpC3ELGg3xtisdhejN5LQYa4m4wbiee4cpj0C3Xf7OfTZN+dnCMoBoceekkmX6s2QEDPqiVmHNae7KUG2huRjlye/olDcJzhPZHz6HZRQA3j5VOTEKiGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hWC25cKLtj3LiZuuzC5eBd3d62alnRkZ9mjswf0e2eQ=;
 b=jAT/KirtnDBUWGrPHXSr8ZxZxnx4493D7rWkEoD7T76cTUscQr7MuEIkvi/xDA91iLTjbp9OBReFn/cfitQCEizP4Vhh5GvDbUamXxTlBskEHv1bLAp/JggsU1qcwrCl0WTaOEv3I5JJ3VOyqu4AQ3Qk46/Hw8jtHk5KUcJVf82qgw2yL1n0j8OSNDEtKJK+gU+6TB5Mal1nuEtNXxlEWZdhbneF0rB3EE8wHRxN0u0OapUlmzV8cwv7WjmBwRxZWAB6v6fwhIMD7x2eUN/g2i/8UjpLMbn/3m+h1vWINn7AxmRdiGFXYPk1Y1xgo52lYqyd2sjF0eXVNoXuSuWsJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hWC25cKLtj3LiZuuzC5eBd3d62alnRkZ9mjswf0e2eQ=;
 b=i4/yZehXmKzh3CgNK/QAXQ20RQ4dTvft8mveFJI/rmSQhCJMKpS8z3VK8VTf9hdPgY//+NneFQimdklR+LKcuimQYpVhLNyhwgSXiBtpTVmKKr0D7ZEDP6o3Ig7AViVGn9ZFS34uD8q44uBbCbFMt/M7n3gKaKsjUczfdhABHRkor54bHOeG8JrL9EaSgZgWqWe6dhJ11v9RMjAYdQ1cpnq9TKCWeNHKD/8et1sJWmBG9YN85MhG/Q+Kykq+Mt081I7/Ko5ELBakKYgH+tnyUJ8Vwu8AgSAHFutRrwGqbCSJqB6y8b1ocXxGRrWxRwcmopV6lXQ0cALYsivSVuRl0Q==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CY8PR12MB8337.namprd12.prod.outlook.com (2603:10b6:930:7d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Tue, 18 Apr
 2023 20:09:07 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3%4]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 20:09:07 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH blktests 1/9] common/rc: skip module file check if modules
 path does not exist
Thread-Topic: [PATCH blktests 1/9] common/rc: skip module file check if
 modules path does not exist
Thread-Index: AQHZcSrj1d6axPqPb0qzWILuy2yJyq8xgOsA
Date:   Tue, 18 Apr 2023 20:09:07 +0000
Message-ID: <657ad089-c3b1-dd86-a51e-69985292231a@nvidia.com>
References: <20230417124728.458630-1-shinichiro@fastmail.com>
 <20230417124728.458630-2-shinichiro@fastmail.com>
In-Reply-To: <20230417124728.458630-2-shinichiro@fastmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|CY8PR12MB8337:EE_
x-ms-office365-filtering-correlation-id: 8ccf0d6a-e2b3-4708-7fdb-08db4048c3e1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IfK+TTd29kLYoJKPwKwq2JjQPnA5/2ezV/1pzl+mVY3AEsdNFEnX9rQeDSWb1xsZUVZKv9lDILgnSQdMU6LEW8Z4X9q+3zkrCx0IkxyxsozykrsB0s6EyTLqVa8iCmesyaNCTZsZxIT5T1eaMHAjXz2/7nRNxlWXQR9LiOxdRwjGuBtCcBlADV+9YkttfrapQ4n2INtZjJkn6g4nexYvATHLEqEDoTIamhiegD0RG5q7WmJjdp/hI8kKyvFPFQfR/Z2Nru5sqYQy/OW+BzviRXRBGbm/0kYFQmUbHbhE1nm4ImW7ApKDWJ2OUKr8TChi7RYOqVbrsJqFB4mvZrGKnH3OMKeiYc7+cWk1wrw47/idjtqf60/5S1RYvzVxHcYxOC6Tyj0IHoRu2Cm/C2vubvuJhHes7K5Ko4lf9AdU+aQapjEo59nyo0AA0sdI8SypfqrCn1+WaQKwkTEDY7YkdpVISzLGePbqgBJ6Fgn3qrhKfd5+dDdTZTwYw/y6VUxJ8Ihx6iVzTyg+z514QCIwnWjYhXbdWwxgvnqNbpZ7c+ZS9DYSJP3/udYbqkqxPZnGtmUaiRQSAPtDbKsb0O/IH7THh/8FQCiSeZ6lifFR/1OKRn98OojK3z3RqUcQf803eCNhrWvMu6cKGxciB1ETQS0WDUDtXIXhQvVyo0+lrjitAADYWXXxLvigobzl1vxl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199021)(86362001)(186003)(31696002)(2616005)(31686004)(6512007)(6506007)(53546011)(38070700005)(36756003)(2906002)(4744005)(6486002)(71200400001)(83380400001)(5660300002)(478600001)(8936002)(4326008)(316002)(110136005)(66946007)(8676002)(76116006)(66476007)(122000001)(66446008)(64756008)(66556008)(38100700002)(41300700001)(91956017)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dXphNmxUY2cyOWdaYkFKK1M2U1c5RVJPQ2JIWWJyTnZvTmlBb042NzlOVlJQ?=
 =?utf-8?B?MzlPNVRXRFFjN2VIL2RUcEg0YjBQQyt5akFNaVhhYjlDTzNoT1h1eWFZQ2x0?=
 =?utf-8?B?bmNwTXJJcXVjKzF6NGZ5Snc1UDAyQTl6a0tqN3NidzQ3djVjVUJCZk5ycE43?=
 =?utf-8?B?cGJTMENvL043OFBBUUFpMXlhZ2xqVm9NUzVtNnpRZ2dzKzFndkZ0Y2NSQmhl?=
 =?utf-8?B?MmpOUUlJOGtvVWhUWjVsN3ZiamEydE02eWdkcUlFczNQcC9WKzltck5MNGky?=
 =?utf-8?B?eWZtVXN1QnlFUmQ1TmRzQStWSVJmUE11czVOQUlqTTJaaWo3Ty9OQ0dpa24z?=
 =?utf-8?B?S0xNMXg4cTB1MW53UkxqcS82K2ZuOU9DemZtd0d1NmU2TkNRS3l3Tzg4TjBQ?=
 =?utf-8?B?U0QrTXRqTDRFdEQzVG8xUjVkY0IrcjFTZWFBWDR6UDdDU29ETCsvUHdOTFBn?=
 =?utf-8?B?bzZDMmEvbkUxOUE3NnRxOTlFSGE0UmVhSVpZa2xtSEs1b3krVHNhc1pUSFp6?=
 =?utf-8?B?U3MwNmJtM3lkTUV2YnVEOThtbVZQajFBVkNBcDAzV2VSNXNUcWx0a0FESkhL?=
 =?utf-8?B?R1Q0T1RocjlNbVZOdzBEQS84SU1ucGs1d1N5QWtLVnFFM0g1WDBYcTd0Wmho?=
 =?utf-8?B?eHpaS3NISENYREp5SXMzblJjbzd3QVFvbWlPOWxmY0k5UjlLaTQvTkxWSWs2?=
 =?utf-8?B?MlpGVDZuU2diTFVsVkxhVFpjTlo0bHJiVmdmOHp5MzZvcTV1SWJVbXdTMFNk?=
 =?utf-8?B?d1NHWEFqV0VwZVB6VzNyaWp4emNPZkNlYnNER2dpZTFxaW1hMmVQZmNMZDJH?=
 =?utf-8?B?K1oxaXBDVWlqbEdleERVN2IyNkQyRVRPcHJsQjlEME91bmRCVEl2VlJlRGRD?=
 =?utf-8?B?WDhON2ZxVEc4c0hFclBIUXR3aGNqMmNPQjRubzA1alVpWEFlVVdzbzVSOUtE?=
 =?utf-8?B?TVN3MDAwNmdSK0N6T0psMDJYeGgxK0FYUzEvMnp4Tnh4TEtSVHU4cmFVT2Fh?=
 =?utf-8?B?Q2ZxU2hMQ2FxdC9STVNwSXR2VnNEUjdoRGxFdVlNRlNvOHF6bkRyUmxTK0RS?=
 =?utf-8?B?dy9lakdsajVjMyt2L3N6c2VzT05WZkFyaGtWNWFvblc3ZXdtdTZRY0RxNHhF?=
 =?utf-8?B?K1RFNVY1d0IwanNKM1plWEtIVm1US0l0WitNaEZ4dkNiRHd5UnBQV3NSbm5n?=
 =?utf-8?B?b0h5a3N6cGRKUDQzSXZaM0Nna2NvTFlPWWRaUlRmWjM4R29oc1JGYk52T0NT?=
 =?utf-8?B?MTJnL1RyWGdITldQYXZyNklQaTN6QWtvM2poT1hDdFQzS2lEZURXSUZiL1A0?=
 =?utf-8?B?OVpmRURhSy8vbDh4SFBmMVQwZmtqK3ZoVi9HVy9GT1dtblZ3eEMveThLai83?=
 =?utf-8?B?RnRsSFk5RHRwSUlDZGt3ZTlrSmx6YVZ5YS9CbVRzb0RwUy83VzFvaGFnOXdh?=
 =?utf-8?B?YWM0dk80WE1sQ1NodUNkQm9WZDVNSXVhbDQzOCt6K1VBcEVwUlQ1MHdRNm5m?=
 =?utf-8?B?dTk5NUpTZmFPN2szKzk0STZudDdYZXdBWkxMZnZPdExsYldCVU5UMS8ya1ZU?=
 =?utf-8?B?SlZteUIwbmpVM1RmWW5JY25Wclk4Ujl0MXM1OUFHb1hzelc1dk5ZSDF3WHF5?=
 =?utf-8?B?UWlaRk5VdDNsMEJ5emJjeXY5dHB3OE1JaXBkTW83K2hEUUNVU0ZDVDljWi9m?=
 =?utf-8?B?NVpCT1B3SVNlK0hZOURJUDdZMVlQL0VJcHVSZkFFTFpUMEdsTVd0Q3UvSHNa?=
 =?utf-8?B?S2dWb2FoK3EvUG9JSHRibUdXbHFxeXpXWUlIY2t2cDFVcUd5Rzg5a2U2bHRt?=
 =?utf-8?B?MWZ5a1RxWThOcStKQi9pSkM4SEJvbWd5Z2Q5Y2pQdDluWXBnaFJITjdyRjIv?=
 =?utf-8?B?MGlOczJEakU2cVhuY21VN0FxNnJBYUkyZ0dyck5rMy9RblFvaHB4VnY5OTdZ?=
 =?utf-8?B?ajVpSm9Pa2VCUzFoaHZrMmNxMnljWEo2MmdIZndVZVc4cDlibWFyNGQ0Y3Zx?=
 =?utf-8?B?ZlYrQlp5d2tsaTVYM09RWFBsckIrYWVaTlEvZGpQeTgzMlUzOVBJTXZJVVln?=
 =?utf-8?B?TFNUVGdZVWN1M0lmcjRid05pMHFiRjlTdnBJQWJTdGg2OVFTSGN3S0hSUytw?=
 =?utf-8?B?eXZRbEVBUE5LNjNxd2h4WVJHa1paZ0wwenNjTnVvZU1ZSmM1bmx3K0NBRCtE?=
 =?utf-8?Q?XPqdW4brwp2ry6WNDh3jc/DA+k8IrGr15AEDXhMFPGVD?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2730C7BC5997C14598236DEE0B3C594D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ccf0d6a-e2b3-4708-7fdb-08db4048c3e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 20:09:07.0826
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ih9QIzeHfuNZONR8ClAtuSJCdmMfhYc+opL1HZJXlWfKe8XLqan/g2ChfXkcOmgkOOsm3qUjOvykrzQMDFZK4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8337
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNC8xNy8yMyAwNTo0NywgU2hpbidpY2hpcm8gS2F3YXNha2kgd3JvdGU6DQo+IEZyb206IFNo
aW4naWNoaXJvIEthd2FzYWtpIDxzaGluaWNoaXJvLmthd2FzYWtpQHdkYy5jb20+DQo+DQo+IFdo
ZW4gYWxsIG9mIHRoZSBrZXJuZWwgbW9kdWxlcyBhcmUgYnVpbHQtaW4sIC9saWIvbW9kdWxlcy8q
L2tlcm5lbCBwYXRoDQo+IG1heSBub3QgZXhpc3QuIEluIHRoaXMgY2FzZSwgY2hlY2sgZm9yIHRo
ZSBwYXRoIHJlc3VsdHMgaW4gZmFpbHVyZS4gU2tpcA0KPiB0aGUgY2hlY2sgd2hlbiB0aGUgcGF0
aCBkb2VzIG5vdCBleGlzdC4NCj4NCj4gU2lnbmVkLW9mZi1ieTogU2hpbidpY2hpcm8gS2F3YXNh
a2kgPHNoaW5pY2hpcm8ua2F3YXNha2lAd2RjLmNvbT4NCj4gLS0tDQo+DQoNCkxvb2tzIGdvb2Qu
DQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQot
Y2sNCg0KDQo=
