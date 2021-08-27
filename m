Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82D4C4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 14:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8099D60F42
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 14:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhH0Og7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 10:36:59 -0400
Received: from esa.hc4959-67.iphmx.com ([216.71.153.94]:42238 "EHLO
        esa.hc4959-67.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbhH0Og5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 10:36:57 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Aug 2021 10:36:57 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=seagate.com; i=@seagate.com; q=dns/txt; s=stxiport;
  t=1630074968; x=1661610968;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZlhEzMjuoD7zeWhjhw8DgdcOEPAZktdRQKryjx1buaE=;
  b=rbNGcVMvEAFrt5yiiqBOSSuLgeubu02je1Va6e+58SysgU0N6IvcbfM4
   wWnjjIGF2n9zDNnk1xTH/mg6/FV8mUHoSmP4/QOjqChf1Xeh4PS5Nk7VE
   M5coJzS3nJ6ikURVVfc/DQim1L+s4fxsnbdoeCIRIqJo8mNT17yCVqXLZ
   Y=;
IronPort-SDR: FMpodgS2KS94xHb5BpAkI4h/Ty0ScLGDG4J3UXDnIqTqzx83PmeO5hUddzhXnO1UC+DzFiZhtF
 WM01FGy2sTaS/yj+Pdi7B5wqVWFBLaLeRqvN4jV+KVrPTBct39esKUoVUorcZSel/ZrYfQGpQt
 vMInDGdccce21/PxgPc5eRp7iXWhKKQ+TC7h8Rsxtdh9BE1TSPjSbRGi1YK6E87YOYYf5wjx/G
 VNksE9BZ2jUGlLo1A0FPjNsdE+yixAeWzjCAIYqVrEbN7ubc2mebMr3Tt7Fm9yBOekkzm8o4Ri
 jvw=
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hc4959-67.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 07:29:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oDRf1Froh2wRyT/kmBML0/njHHxokeZXuNrUvytb2K0i5JY7Sdnwx52a+Um3vO5wF+7QiAj9RK7TpLfi6rRjkP8q62lcINP/BcOaEMdqg6Ti/imRWDSBCMW1mBdPc/bbhypYNYbUVIzBp9RH7TOrtlpHeaajnInV2y+d6U01kb1WaBhKCou8MObKT6GC5hv31/276k3iqYNtc++frqWQnkITszHiuSp/3xB/aRwFUSk0lCMcVCUQtn7X6Z0odgVoCA+9xB9cOgpWbNRvLkdwkofXD0oSulkwfWIMufdcWcW+k+Vn1u3aRVIm5ZQd7zYbOe5oszMSjlEex3c9x9ba7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZlhEzMjuoD7zeWhjhw8DgdcOEPAZktdRQKryjx1buaE=;
 b=VnKzq86jfiqvXBp/FtnkXIXD3mM9z/QHtVLtP06Bc0GWCjmHXu6mqlgSnKtYETWtKHE65HMZ8rFhukdY9FFr/GgZivuAfpO9u6l0joPVU+kWjlYtCM9UhpfUK79Vtaskv6rB8F1JJzbMcEQnA72jDaRCY3Yyjq26omHV9LhTY0NkURMG8Mw8ckURKKNLY1IfyNB0hineD6dAJj9ZvGHdszSDm+ESYEsZWSzB/bJlzFtmj8w4+TP+E7TPKfNofrjhrNImVeQIzkkDnGKEmbe+5pgZhfxGtk2TNcgE85RB8ZFN6jiqXUNkftAlFwqetPi7zRn2p7yR0JZoJeoC/W0QoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seagate.com; dmarc=pass action=none header.from=seagate.com;
 dkim=pass header.d=seagate.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seagate.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZlhEzMjuoD7zeWhjhw8DgdcOEPAZktdRQKryjx1buaE=;
 b=V/qjvfqStiXwG6dCQ/8NteXl30ZeTDU2fAqEIBxw1WEnCeVV5d8v7WH/wjVuYQYKoaU6+XBt8DGDnrtDTTHWm2vi/LI7ct4D0X6f4Ol3xXbtQ/wcfRo9k72EHBaSpqtoOOxjAomQML8kUpoMSOAbZsSDk9cQ44KMActdxtIUFRk=
Received: from BLAPR20MB3954.namprd20.prod.outlook.com (2603:10b6:208:331::13)
 by MN2PR20MB3102.namprd20.prod.outlook.com (2603:10b6:208:1b9::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Fri, 27 Aug
 2021 14:28:58 +0000
Received: from BLAPR20MB3954.namprd20.prod.outlook.com
 ([fe80::b136:c626:f470:9c11]) by BLAPR20MB3954.namprd20.prod.outlook.com
 ([fe80::b136:c626:f470:9c11%8]) with mapi id 15.20.4436.024; Fri, 27 Aug 2021
 14:28:58 +0000
From:   Tim Walker <tim.t.walker@seagate.com>
To:     Phillip Susi <phill@thesusis.net>,
        Damien Le Moal <damien.lemoal@wdc.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v6 0/5] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v6 0/5] Initial support for multi-actuator HDDs
Thread-Index: AQHXmxikLMXwHJHQ7EuVsznHq+0e5quHYRMA///FawA=
Date:   Fri, 27 Aug 2021 14:28:58 +0000
Message-ID: <63D90989-AFAF-410B-AD11-EDF71CEEE666@seagate.com>
References: <20210827075045.642269-1-damien.lemoal@wdc.com>
 <874kbbugtw.fsf@vps.thesusis.net>
In-Reply-To: <874kbbugtw.fsf@vps.thesusis.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.52.21080801
authentication-results: thesusis.net; dkim=none (message not signed)
 header.d=none;thesusis.net; dmarc=none action=none header.from=seagate.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d830418-e266-46c0-f5b2-08d969670222
x-ms-traffictypediagnostic: MN2PR20MB3102:
x-microsoft-antispam-prvs: <MN2PR20MB31024B3408C90895CEC7AF3CD7C89@MN2PR20MB3102.namprd20.prod.outlook.com>
stx-hosted-ironport-oubound: True
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YLBQu+J27Q/NpFncF3/43E9xtFazU5aV1OqlGrrCIKR4XuJlVB6IQvbALw/pN+uavU824yubQnyWY6efqlG9CH+i32CKH7MDPjFoFzDZJrGjef1IRZsXGyJYO9vmB7PLfzhWgnN06hybHXgp6m3JReJKZoYhQKsGQELRmO9lMzXmp2dl/yFiubm0uMWNSNcDhloj32f9nW7QZayZg8Oj8w3LQbp3B4/U3eDXE5XDLJ/ehpEHacvZqlH7dKUwm4AX0+tTDBFpMDJNxJM2qg0KjSBGHUEgLMdDqt6iBT49vtXgn8npnETWjI9jQqJ6JpRcH6koGZMuTqSC68Y8sftipG8MNVZ2o2LMT5EeIsI+Mce4fVqG/zq7etrd70RSsAtSEu5Y+ufv/RlbApYTrukxLsZP//EUmfFy8kzR9VfpLo7e2K9iHH+z55RSWVdUPPiVwoKkdlCJKDcsbypsI7JDqpQm8N3+x3FPpw34RoJ7cT0jopMh58DLMIoWPnrgUq8DvjPnhjiHclyb44l0O7RjpyXx2RuEeFC0Q+5hOl+GAZf9e/5qvJ1kFAZcA8e9guE4jnpmNqOX1SOoJBZ1bNKF7L+a04KhrDC8QyszIGrwhliOxfzGpAQHuVmg2308+dVdn/FZTbmvkWznDkussQopVXUINyHclfXSEyAvjPF1knOQbIHqu9UO2HAbilRQMdzcdoZZWHI3Gfsv3IA8HY3cjmsVI9mVD55HsARjFRt9xE1JHYSQpCBsEAUQB9QQ0mlP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR20MB3954.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(366004)(396003)(376002)(110136005)(316002)(54906003)(86362001)(64756008)(8936002)(33656002)(38070700005)(66556008)(91956017)(5660300002)(4326008)(8676002)(66476007)(6512007)(71200400001)(76116006)(38100700002)(478600001)(26005)(122000001)(83380400001)(36756003)(66446008)(2906002)(2616005)(186003)(6486002)(66946007)(6506007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MUhhV0IrZW5pcmlCcnh1OFlVK1RMWXArTnkrK05KYmdnUEdXQWtBN29HV1VP?=
 =?utf-8?B?QmtHVElFT3FPN0RPMW1NSGFkSlNhNWZlUzFvbFFjWkNwR2tzRElIK2Jua0Qy?=
 =?utf-8?B?WkJqek40blBaYlhHcGVjU1l0eHJIUk1xSTdXZWJkbGdkZmZPK0JOc295cTBw?=
 =?utf-8?B?UWtNY3JTUk13TG1ZU2NoQTY4ci92YzZVSmRvZmNzOUNuRHR4dTZCQjN5QTdY?=
 =?utf-8?B?VEZjZytkVUVxcnJSSHBsd0YwRU5aamtKZjZ0NjU0ZzVFNk02cEdDY2lvZ0lV?=
 =?utf-8?B?bTkySWRpd0lrR1E5ZUk1c25yZjMxeDNCQlF1b2Z6SDJTYTFFemxZZkhuV0VL?=
 =?utf-8?B?M2tEQ2pMd0VxYWowVkFibGFpdkgrWmFWNHlsNm8wbjFjVkhNcGtROWI0MHp0?=
 =?utf-8?B?TUloMlAzREZrQncwdmQzbWlyYmtURjZqdjF3dzg0N1N1YlZod1k4M095MTU4?=
 =?utf-8?B?SmNIWFQ3MUJtbW5PWlBMYjlOcjZJME9OUGFUSVVjbXdQcklJMElSNVJrVmRF?=
 =?utf-8?B?dTRYa2k2TVduVVl4TWp0T1E1bDNKbmtuTzZGVzh0UEMzZE1kV0NDNUNSSmFO?=
 =?utf-8?B?TWxkN1M0QnVhUDAxV2tpUHdheG5DWEdjQnMycjFSR1BwSEhJbFBnM1l6Q1hE?=
 =?utf-8?B?SHlvd2hFVGhSQkJvVCtvaS85VEo2YWY0eXM3R3BCTk9oOUxjS00yN0dTbFha?=
 =?utf-8?B?NGtmSmp0c2hPR2EwMHJLOFJ3enEwL2kwNnBoSkwrNnpGRVFrVTJKcXdVRXZw?=
 =?utf-8?B?cmZmdFVzSkk0aENKcWdXeURTMFVhVEdzczUvVkx1SCtGMzBCTHJNWDRhQU9E?=
 =?utf-8?B?WnJrVVFoR0x4OS9xdkU2akJac2pZR2FYOUYzRk12eEtPSUpBWFQ2SnFsQ2xm?=
 =?utf-8?B?SEZHNjNISDF5TjJRdG1yZkVOTUJDRzNrVVFKQ2hyUlBsV3gwQ1hPOG9pSHFt?=
 =?utf-8?B?d3lVWjJXQ0g5dHJWNURBdXlDTlNQaFcyODE3WVBBeFREOTJ5NmprR2w3ZjZk?=
 =?utf-8?B?UmthNHZHL2pLTDI5eHg3bjNIT1F0aVRCMzBadXFRdlUrRmVxSlFXZFA3aWVa?=
 =?utf-8?B?N3hoMzI2SkczbUpvU3ppTWFnR3lrRjg3cjkzZ256MXRCSGNIWWhnVjdWdGNN?=
 =?utf-8?B?anR6WFFNSWUvUHVUVHNoUE45cEh3ekNBTEtXUTNlaTNSa3REdTFWZWQzM0pt?=
 =?utf-8?B?WXpxb3lMOVZLeHdPWS9yRklQQytiOU5XRFdWbFVlcWZHTWtYTm91L25nT3hP?=
 =?utf-8?B?aURlOUozTkgwQ3MveHZJTmtiaHJLRGxzandndXVjZGduaWhXYXltUDBOTGNo?=
 =?utf-8?B?NEJzQWpjT1hXdmxxN2JpWlRnb2hoNlNNMVhDVU1HOUJYcWVOWk1wQldPakhE?=
 =?utf-8?B?WFJLRFJIMm95WDFrWVJ6Ui9NM1BlMjY3MVBmVm1RU2hXcm01ZU9nUU85K3Yz?=
 =?utf-8?B?bTZSQ3BTM0RKcWVkRzRqbU5SUVRPVEI1WTFDbkRaOVBhMXRBN3Y1YzRuVG5L?=
 =?utf-8?B?d0tYY3pJcGlkclFGWVFtbk50YjBjOHF4ajZwMGJlN2ZTTlJBVm1LaDkzTjRJ?=
 =?utf-8?B?WDRjbE81QkNIbnZtQUtraUZHdHI0cHhBaXBXc2xqTzBMQ2JCRjQwZkU1UFZv?=
 =?utf-8?B?NE1YaTZ0NElMOG5FTFNnNEVBRk0xRVI2WWlzdjViM0xxU0lsUGY4THNhVFRT?=
 =?utf-8?B?R0tOd3Z1Qmtxb1Z1eDZ3QlN4cGMxVy9XTVVMYkRIM3FyTDBtbGJmMHlBZTNQ?=
 =?utf-8?B?S2pCeHFENFl2Y0VPWDdKenZ5Q1hyek96YnRLNmdVQTRSRnhxWHNhVWgzd293?=
 =?utf-8?B?WXBjVG1NcmVLNjAwWjZpdz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <4EEB951EA8914F438AC7009B51C97A5E@namprd20.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: seagate.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR20MB3954.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d830418-e266-46c0-f5b2-08d969670222
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2021 14:28:58.7003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d466216a-c643-434a-9c2e-057448c17cbe
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ni2kUjKLRtp/LRoR+8GoK/cp+hPRofeRHn9QFj9VMtdAvZqKbx0400/S0FhshIfPT7Gr8qHwbe3ZkgfQ2k/rqegRL8Uyiu/Pkfedx5y+YZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3102
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uICBGcmlkYXksIEF1Z3VzdCAyNywgMjAyMSBhdCAxMDoxMDoxNSBBTSBQaGlsbGlw
IFN1c2kgd3JvdGU6DQoNCj4NCj5UaGlzIG1lc3NhZ2UgaGFzIG9yaWdpbmF0ZWQgZnJvbSBhbiBF
eHRlcm5hbCBTb3VyY2UuIFBsZWFzZSB1c2UgcHJvcGVyIGp1ZGdtZW50IGFuZCBjYXV0aW9uIHdo
ZW4gb3BlbmluZyBhdHRhY2htZW50cywgY2xpY2tpbmcgbGlua3MsIG9yIHJlc3BvbmRpbmcgdG8g
dGhpcyBlbWFpbC4NCj4NCj4NCj5EYW1pZW4gTGUgTW9hbCA8ZGFtaWVuLmxlbW9hbEB3ZGMuY29t
PiB3cml0ZXM6DQo+DQo+PiBTaW5nbGUgTFVOIG11bHRpLWFjdHVhdG9yIGhhcmQtZGlza3MgYXJl
IGNhcHBhYmxlIHRvIHNlZWsgYW5kIGV4ZWN1dGUNCj4+IG11bHRpcGxlIGNvbW1hbmRzIGluIHBh
cmFsbGVsLiBUaGlzIGNhcGFiaWxpdHkgaXMgZXhwb3NlZCB0byB0aGUgaG9zdA0KPj4gdXNpbmcg
dGhlIENvbmN1cnJlbnQgUG9zaXRpb25pbmcgUmFuZ2VzIFZQRCBwYWdlIChTQ1NJKSBhbmQgTG9n
IChBVEEpLg0KPj4gRWFjaCBwb3NpdGlvbmluZyByYW5nZSBkZXNjcmliZXMgdGhlIGNvbnRpZ3Vv
dXMgc2V0IG9mIExCQXMgdGhhdCBhbg0KPj4gYWN0dWF0b3Igc2VydmVzLg0KPg0KPkFyZSB0aGVz
ZSByYW5nZXMgZXhsdXNpdmUgdG8gZWFjaCBhY3R1YXRvciBvciBjYW4gdGhleSBvdmVybGFwPw0K
Pg0KPj4gVGhpcyBzZXJpZXMgZG9lcyBub3QgYXR0ZW1wdCBpbiBhbnkgd2F5IHRvIG9wdGltaXpl
IGFjY2Vzc2VzIHRvDQo+PiBtdWx0aS1hY3R1YXRvciBkZXZpY2VzIChlLmcuIGJsb2NrIElPIHNj
aGVkdWxlcnMgb3IgZmlsZXN5c3RlbXMpLiBUaGlzDQo+PiBpbml0aWFsIHN1cHBvcnQgb25seSBl
eHBvc2VzIHRoZSBpbmRlcGVuZGVudCBhY2Nlc3MgcmFuZ2VzIGluZm9ybWF0aW9uDQo+PiB0byB1
c2VyIHNwYWNlIHRocm91Z2ggc3lzZnMuDQo+DQo+SXMgdGhlIHBsYW4gdG8gZXZlbnR1YWxseSBj
aGFuZ2UgdGhlIElPIHNjaGVkdWxlciB0byBtYWludGFpbiB0d28NCj5kaWZmZXJlbnQgcXVldWVz
LCBvbmUgZm9yIGVhY2ggYWN0dWF0b3IsIGFuZCBzZW5kIGRvd24gY29tbWFuZHMgZm9yIHR3bw0K
PmRpZmZlcmVudCBJTyBzdHJlYW1zIHRoYXQgdGhlIGVsZXZhdG9yIGF0dGVtcHRzIHRvIGtlZXAg
c2VxdWVudGlhbD8NCj4NCj4NCg0KVGhlcmUgaXMgbm90aGluZyBpbiB0aGUgc3BlYyB0aGF0IHJl
cXVpcmVzIHRoZSByYW5nZXMgdG8gYmUgY29udGlndW91cyBvciBub24tb3ZlcmxhcHBpbmcuIEl0
J3MgZWFzeSB0byBpbWFnaW5lIGEgSEREIGFyY2hpdGVjdHVyZSB0aGF0IGFsbG93cyBtdWx0aXBs
ZSBoZWFkcyB0byBhY2Nlc3MgdGhlIHNhbWUgc2VjdG9ycyBvbiB0aGUgZGlzay4gSXQncyBhbHNv
IGVhc3kgdG8gaW1hZ2luZSBhIHdvcmtsb2FkIHNjZW5hcmlvIHdoZXJlIHBhcmFsbGVsIGFjY2Vz
cyB0byB0aGUgc2FtZSBkaXNrIGNvdWxkIGJlIHVzZWZ1bC4gKFRoaW5rIG9mIGEgdHlwaWNhbCBz
dG9yYWdlIGRlc2lnbiB0aGF0IHNlcXVlbnRpYWxseSB3cml0ZXMgbmV3IHVzZXIgZGF0YSBncmFk
dWFsbHkgZmlsbGluZyB0aGUgZGlzaywgd2hpbGUgc2ltdWx0YW5lb3VzbHkgc3VwcG9ydGluZyBy
YW5kb20gdXNlciByZWFkcyBvdmVyIHRoZSB3cml0dGVuIGRhdGEuKQ0KDQpUaGUgSU8gU2NoZWR1
bGVyIGlzIGEgdXNlZnVsIHBsYWNlIHRvIGltcGxlbWVudCBwZXItYWN0dWF0b3IgbG9hZCBtYW5h
Z2VtZW50LCBidXQgd2l0aCB0aGUgTEJBLXRvLWFjdHVhdG9yIG1hcHBpbmcgYXZhaWxhYmxlIHRv
IHVzZXIgc3BhY2UgKHZpYSBzeXNmcykgaXQgY291bGQgYWxzbyBiZSBkb25lIGF0IHRoZSB1c2Vy
IGxldmVsLiBPciBwcmV0dHkgbXVjaCBhbnl3aGVyZSBlbHNlIHdoZXJlIHdlIGhhdmUga25vd2xl
ZGdlIGFuZCBjb250cm9sIG9mIHRoZSB2YXJpb3VzIHN0cmVhbXMuDQoNClRoZSBzeXN0ZW0gaXMg
ZmxleGlibGUgYW5kIGFkYXB0YWJsZSB0byBhIHJlYWxseSB3aWRlIHJhbmdlIG9mIEhERCBkZXNp
Z25zIGFuZCB1c2FnZSBtb2RlbHMuDQoNCkJlc3QgcmVnYXJkcywNCi1UaW0NCg0KVGltIFdhbGtl
cg0KU2VhZ2F0ZSBSZXNlYXJjaA0KDQo=
