Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F12C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 19:16:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBA736124B
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 19:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242422AbhI1TSY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 15:18:24 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:48103 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237134AbhI1TSX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 15:18:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632856604; x=1664392604;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SVY3lo75JdBu5dOgeQJyLQpPYBkjgpo8sRzXlwi/iBg=;
  b=F4t4Q8dNMpEOMFA5zT1YMaqxzgxv9+s9XzXeGpI6VLBC1UMQGNuuWayb
   Xdo6BWf2m/8w6hcoL5UloWIYiB7J/hlZBB8pm0EEKf66zjb3tbD76wY8R
   iRVERxEE7jpgGvTkCddUhGijwpUCFWeh2j4K3541BQPSF8k2bgLsSptgG
   0O0ai38EsJHDT/hpngpfnr+ZZ7OpVW8IKh2ZQIjTYBCnARu3EjdeTMVG/
   Do4feXaJ4NHsdpRNd6TEBywBQKWMk1zq3We4iu5G4mDrq6bxHTvc6u8Cj
   5FPq11bu15W+12/k0Gbd9wZreXZUiKVgNRO5DYOx5+TCwPukWTisfJro2
   Q==;
IronPort-SDR: jcofGTiTzHYmaA+LiVrok51XvU4ZljNiRXS4wOfIH7x2lewGdNRU9UmgnW4+qBab9r7x2bbgg6
 u5dXIQp/C7uU4re3cKuWtKJHJstnis2WID6qoHQZo3GpFRIc19nRs4RjiflsLWUH+RWXDVOFhr
 v4JP2NGEFCv4hGNdvojTCZGUXRcCtNBs4KkEq+EJ4+hAP/GADDLmoRuiavU8ENohVe0npaWuOD
 S/9vYaFg9ugM8jLsKRk9GK/d0mmjB6y69zG4k/5FJNjbSBUzIgU1i8Aj6cCk4lQCvfll0lQVnz
 bkyC3kR0yhAyE01Ss9VAZLIF
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="137718369"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 12:16:44 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 12:16:42 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 12:16:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ChqwvF7R1koXRvVYvlm4a16ESbk5I78xeFi+/tESLEhtNkZrKOA8hW+uyxDWge7Z6bU7UjCnbCgPlfLgkMfX0g44jyryLI4WfplwynFwm6fCIcpN4mhrbdydpTgGLbtW+sNahuODPl4tPp4TqspixjvMDiKfdIPHqK/y9fbvABsY79W0yQPh1678GRJV/GRHRt6igk+/rL3qlWGXCBxwsSr3x4lLm1z+DgMO/XTledbp+l6u+R1HY2LHAkkqJSsoqpk7O+hWgLq8vOhq502XDmhAVmC06pZ5KKisF8Sj1n7Ui3MZevT6WFUK+Kl0Ki3bSSwNYLd0wusF0C3Sp2Oysg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SVY3lo75JdBu5dOgeQJyLQpPYBkjgpo8sRzXlwi/iBg=;
 b=dqOQoAhrLR8XwNKP2OYCboHTndUbb3gR7faLG+C+H+eXkIC8ve0v/2/oGVDga1tj4ZHxtqb+l0bWqRUZvaSwMcDWaioNa2u2UZCCWVYzJe29lxCMSEtmGcnlJpK+CG6T5TyzwaSleuG2kz/yFFJ+zO6y+3JC2cRSWyaQA/9Aq48fOSmsZndhF/wdlRwikVwmEijqTtJFDcleUDQtvHDt+6NOeDZQJnKBuy7W0vWu+2weIsX+QvQyvOtp1iYohlxvnLf6IQSuyPFgrCa8k4EKeWf4ziCF14EM837N1MvW353p8Y4oqqMCoA8+cnS7uxAR6o66uqSQ5XF0WKv1PbUw5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SVY3lo75JdBu5dOgeQJyLQpPYBkjgpo8sRzXlwi/iBg=;
 b=T8r4gGpBAS0o9AWUBigYIY25QknWl4HB0n3oNjoyToSOJdxVhO/JFUHAKVVSC18cZhG9u0SwmF3713ai1r9tYGe6F0oz9pLPSE0BLP3rspqH2FKwwFFXSfw1icxxd2hi0pRqo7yBFH6BjTH7sP+0PulACkhG4GX0H6RndMU8aNo=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB3280.namprd11.prod.outlook.com (2603:10b6:805:bb::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Tue, 28 Sep
 2021 19:16:41 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::5858:b334:4b44:e7b1]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::5858:b334:4b44:e7b1%7]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 19:16:40 +0000
From:   <Don.Brace@microchip.com>
To:     <Don.Brace@microchip.com>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <Mike.McGowen@microchip.com>,
        <Murthy.Bhat@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 00/11] smartpqi updates
Thread-Topic: [PATCH 00/11] smartpqi updates
Thread-Index: AQHXtJjvyz8dh1s440KM1RKRPuFcQ6u50Wbg
Date:   Tue, 28 Sep 2021 19:16:40 +0000
Message-ID: <SN6PR11MB2848ACCECACD96B7573463EDE1A89@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
In-Reply-To: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none
 header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aefcd631-7a22-4e7b-26b7-08d982b4805f
x-ms-traffictypediagnostic: SN6PR11MB3280:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3280F17CF5CCD1156038F9B1E1A89@SN6PR11MB3280.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DDcHzxppXklg+Mw3fiepCFE8PZ1OVS5NNH1J76LJ7J0+4NIeWUxqoMSBwOt5RnejLvSgdOF5ULHzgoyZuGP4x3jIZKAH8OrmFOmqH1FTfAgencILITIwr1hgAEKZhYWnA0tJg3bCKFrseFJz7y35DsFSnZx8JNnf/vWImVENvczz1vYp0+bfsQa+YeX6ODCNG0YyoNnOrtfQkLB7qmwd6dk5Rx5IBZUB3ddm84TuZTeia/NkBCxdDNdVoJNgR6IsSyvsR5GgXYH14qR4uc0UClq0kcd8951NIuNTIXbHAzRHNh4URVBHBeTHPJ4qNeFF7aiTV02Apvh6JL149nzTsNI9gWDZ4OUlk4pdANxMIFiX/Ds803fvemnVmhqfKbFm/Nw8tX1c3ZWeGTTYY5pGy6QqGlOGSY3Vc/zu18/T0To+9d4+MBV/VaX/9pJ3Hms/7NEx8ZkRAZNeXgtYprEE/h+T4S/xFM19GClw1HLb+oo2hnPgHPOz26wb0Kcqx+omgWzxPXUim9Cul7vokzCWBDEEzMfmFdIezE1EGH/k+yI+3lViMCM6wILjeS/Gf0cXwzjjeX4XGeCon4O6eIaVTEgX5UkI+LM3Lma0M0CKYk6zcE0e6egW8jZrTKzXyPqRodjfLjydtSahrf+czzaSiPhqsbeTwRrmr8FmhfDJvs1I+1vam7kDOdnukkLndS0bSMCCNMGIvjKiBSNZvrPhULjtj9rxpXDcHuSagCYMyaI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(110136005)(9686003)(76116006)(55016002)(66476007)(83380400001)(26005)(86362001)(5660300002)(38070700005)(52536014)(4744005)(921005)(38100700002)(186003)(508600001)(122000001)(66946007)(8936002)(53546011)(316002)(64756008)(8676002)(66556008)(66446008)(4326008)(15650500001)(33656002)(2906002)(7696005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NlByemVZcXNVN1piNkZ2WWpJWnlEeURiRkZKQVkzSERzVFcySm5FNWttbHhT?=
 =?utf-8?B?cmVPejR1aTNMZUVyd0ZwQjRBM3pCQzdjbDJMdE9VYllrVDFUT3lyNC85Uzhx?=
 =?utf-8?B?bjBkZnlrTk9MVENYQkJKK0pGU0RuNGNEM2UySHppMkxBdXlsQWlPTUszTWxC?=
 =?utf-8?B?aUpLSXRGUWJ2M2tmTUhXbDJ6aU96bGxTVXJia1pIZFEvdXNIV0xhK0l2R3ZY?=
 =?utf-8?B?a0pGUGRMYTJGOXMyR3BPMkQ5Z2dRd0RsekNPdG1Jbm5iekw1VXpXQmc0b282?=
 =?utf-8?B?NTlVUGdoMC92NlNuMnhVOFhIOHN2Z1V4Nkp4dENUMjNPRHd3VHVWQUI1Smx3?=
 =?utf-8?B?djRqZkZjUkFwNEllM1Z1SzVIOXJtcXI0eHBGUUdvd0d3MUZ4N1o5NE1rRXVJ?=
 =?utf-8?B?UUNHeVhMOVA3alNKL3gvc2ZxVHdpM0xsZnNkTHY1NG5la0tiOVZVMDJFaHVo?=
 =?utf-8?B?VHNOT21aTHkzRS9ZMnhoUEZZS2ZQbWo1Q0tRSEhUZm1iZ1p2MTZvMjkzbkV4?=
 =?utf-8?B?cDluejRGOTdTbEdvSGVqdldzbXpOa1Fod1VuWU5XZDRNYmt3MStqK1NXY3Zy?=
 =?utf-8?B?UFVycEVVU2RmQWwrczZPTHkvdUJ2NjZRK1VCYUExR3hyYVBCdkxpSmdGOTJ4?=
 =?utf-8?B?WFFiZ3JGR0pjTE1LMjZQcTc1dk9rSEkvalQ4ZjlJaHhrVW1hV2JVQWRxV3pF?=
 =?utf-8?B?WWdySlh4RjVDMVVzTVF4dkMxU0daa1VabG5zSWxFYVpLY3lLMlJuam1VVFk3?=
 =?utf-8?B?U1VOdHIyaDZRazh4YUg3MENSUWxCdUR2bjBvcnVUUm9XM0xqM3cxQ2xKekRl?=
 =?utf-8?B?RTUvcWdBQ0JDQ0pKWU1lc0dUWWsycExyWHMwOUlaNGJCRldSTXBseDVyS01V?=
 =?utf-8?B?SEdCYmNiNjVHOTNKcUo0QjhSeEJNYmx2SFNaaTl5QU9NY09PN1RBQ0VDYnhC?=
 =?utf-8?B?NkRpS01rNExTaU8rNHVhdytzalNDL1NjUXlXR0FBWDFjZjN5MElqT1VhdC9o?=
 =?utf-8?B?NDYyK21NNnpYZjZQMTV4OGJoVWhnb3RIcEpPQVE5dVFHUnFDZ2ZORmEzNHJ3?=
 =?utf-8?B?QmRLVzBQaGRBWXZFU3NUaU02eWRrQXlWZnBlNDRtUy83dmZMSEJpMjRuS3hy?=
 =?utf-8?B?anhLcmt0T2p2S0N0RzcwTk5oNURjemhWa1NHL2FVSFdnMGZkeXMveitOb3Fi?=
 =?utf-8?B?QndGZjliSzRqZkoyYzV6bEV4RG92QzIzQ0Z1YUlZZGlVNys2R21lUXRIaDZJ?=
 =?utf-8?B?azkzVGFSMTFZS0ZGQTg2ekhuQjJZZk1SalFBOGwwZXRJVktNdGRKN0lxUXhL?=
 =?utf-8?B?TlA3T2dqL1ROTWVsNnNHaFZGMkFHd3VKcU1xTGYwK2JZUUl5bmZTN2o2QUdM?=
 =?utf-8?B?R2c4WWJQeXdGTjIzbSt1N1oveG85eFhIdHlTM1gwNjlyK1FNdTlESVlVVkxD?=
 =?utf-8?B?K2FTTjBSai9Cd1F0L3Z6c0pUT3JkVWZVNHpJKzhrMDczeHkyOG1rMmhmbVVi?=
 =?utf-8?B?YnczUXFScW93S3pLZFNtK2tWRVVGV2dKRTJUL0R0TkprbHVpLzJ2K0ZXaEtt?=
 =?utf-8?B?TDZsbTJpaEVyclN4Sk5SNUpvZkJIVnJKZEtDUktOcFRDdWZwNzdRWFZ5Tk5E?=
 =?utf-8?B?aitPNTdKYmduVjBXUDRvdDAxN3NtY01jTjMwZDI4dW8xOHF4VnBqUXZLcDBa?=
 =?utf-8?B?SGFmYUVGaGo2OHZZRGRiQ042ZXBHekN5SUx1d1ZhdUF0dVNBTU9WeitPdXFH?=
 =?utf-8?Q?j+9k32I8KMYvK6twf9Xm0LN1duT3OkTRo57m29y?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aefcd631-7a22-4e7b-26b7-08d982b4805f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 19:16:40.6960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e8Ycl3KL1Ol9jeCAth31xMgGan30G6MFdl03FKtINzPx92aByAWP8nCkT2/l1ucWjl3wf4qf+o1TQxHie4gHLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3280
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U29ycnksIGhhdmluZyBlLW1haWwgaXNzdWVzLiBObyBhdHRhY2htZW50cy4NCkknbGwgc2VuZCB1
cCBhIFYyIHNvb24uDQoNClRoYW5rcywNCkRvbg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0t
LQ0KRnJvbTogRG9uIEJyYWNlIFttYWlsdG86ZG9uLmJyYWNlQG1pY3JvY2hpcC5jb21dIA0KU2Vu
dDogVHVlc2RheSwgU2VwdGVtYmVyIDI4LCAyMDIxIDE6NDUgUE0NClRvOiBLZXZpbiBCYXJuZXR0
IC0gQzMzNzQ4IDxLZXZpbi5CYXJuZXR0QG1pY3JvY2hpcC5jb20+OyBTY290dCBUZWVsIC0gQzMz
NzMwIDxTY290dC5UZWVsQG1pY3JvY2hpcC5jb20+OyBKdXN0aW4gTGluZGxleSAtIEMzMzcxOCA8
SnVzdGluLkxpbmRsZXlAbWljcm9jaGlwLmNvbT47IFNjb3R0IEJlbmVzaCAtIEMzMzcwMyA8U2Nv
dHQuQmVuZXNoQG1pY3JvY2hpcC5jb20+OyBHZXJyeSBNb3JvbmcgLSBDMzM3MjAgPEdlcnJ5Lk1v
cm9uZ0BtaWNyb2NoaXAuY29tPjsgTWFoZXNoIFJhamFzaGVraGFyYSAtIEkzMDU4MyA8TWFoZXNo
LlJhamFzaGVraGFyYUBtaWNyb2NoaXAuY29tPjsgTWlrZSBNY0dvd2VuIC0gQzYyNjI1IDxNaWtl
Lk1jR293ZW5AbWljcm9jaGlwLmNvbT47IE11cnRoeSBCaGF0IC0gSTMwNTc1IDxNdXJ0aHkuQmhh
dEBtaWNyb2NoaXAuY29tPjsgaGNoQGluZnJhZGVhZC5vcmc7IGplamJAbGludXgudm5ldC5pYm0u
Y29tOyBqb3NlcGguc3pjenlwZWtAaHBlLmNvbTsgUE9TV0FMREBzdXNlLmNvbQ0KQ2M6IGxpbnV4
LXNjc2lAdmdlci5rZXJuZWwub3JnDQpTdWJqZWN0OiBbUEFUQ0ggMDAvMTFdIHNtYXJ0cHFpIHVw
ZGF0ZXMNCg0KRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFj
aG1lbnRzIHVubGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo=
