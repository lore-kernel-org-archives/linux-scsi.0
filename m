Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA25C07E96
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 19:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E640E61879
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 19:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhGHTHK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Jul 2021 15:07:10 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:59784 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhGHTHK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2021 15:07:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1625771067; x=1657307067;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N+KX1Iwb2cTXXRV4ZnpsSP2nxEg+7gwvhZEQ8K5NypE=;
  b=Nf9dBg6VokVgYDhZAvw65LlxY+BIJC9OmSP1jjOcBxwDk0cJaKpoquai
   O8fS7fESBjoPaw3kJnkI/4enEg+q5bMvQ0ZkpRVsgBvUAKQa+E0yp8t/5
   a9UuuZdoaT62H/WnJ90PL7/Y4jAW2iBPUj32c0TpNbPPBl0wWF3jE1DGE
   6vU0I4ZXhQ8O14ZYTzHMKIEMkr/fdX/SE8l2vQ8UK5EwOy+3x8eFaIwMm
   nbxeV4BgLiXrvJq2l7+uVKsZbgYaMTr0roOw4ZrDyxG2V2ev5oMjLNXhZ
   L/Ids7rByiCMDVN6HdT4zF2xdsA6gXIQZErpsNHfMgiXTm46rpkFWXMlN
   w==;
IronPort-SDR: Rq6aNefVJ+tTYM7CYZ9EzduugkpuiETJU5vnH9+elW44V1mW7TwPH/m7V10Ah5ieIIxejfgwkE
 CjYnmGAFfn96r0+46aG1LtuHX3LXpwyHWTRivp1c19+DpjRHQABhCYwa0hKX454HuwTJJOYBJk
 XAdkJVDjNO+jSc8drlNoTJGFxKtwC+bt/Z8+trgA1bE+XrpTQy7HgksbPRXGciKLa1YEr6rqth
 KHsMeErjxQcY+oiBBUGtaLEdAGX4zG+4O7s4am4WCULxww1D+uyrLlvLZaZjB2UP4KCAbdemxP
 coM=
X-IronPort-AV: E=Sophos;i="5.84,224,1620716400"; 
   d="scan'208";a="128148805"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jul 2021 12:04:26 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 8 Jul 2021 12:04:27 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2
 via Frontend Transport; Thu, 8 Jul 2021 12:04:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HIRDOr9GS6ILuho5/EZBmHHSNl977iWwz+M0efoIW4gOUNDmTki259r9pfOcRn8rWe2gulH048F75kDm/hYLL1wBxG00+8uUYuPX69sT2pe6y2SnkUObujc2+zAwg0Y6KFlIMGhRzWrLRKQ2j3fZfpBHL3wspLl7gQ6GB08qvwBfqFl0L4pqrsIeaswLcO8ughROJ3Ydg4iWENEvUEKf8AecGtYz+hUNL2QcTU0N55cMQj7fay5HMCl3kUlEK70sZjjNykI7guSOQqSOiO3198BhoKdjnmvrOZ5t/Sq2/KIz/RmQyDQh7ocsg7NpAHQ4Whd+cyDFQK5238CYAHXqHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N+KX1Iwb2cTXXRV4ZnpsSP2nxEg+7gwvhZEQ8K5NypE=;
 b=ZvLNznGzpSyyCfoHyvJzGwpuhSoFPznMcU5qXefqMJQVNjLzzNrCA9kK1a2nOOXY8UPqtN/0J0e511qLJa/SaOq3qab2hoPAevQCennz2dEp79vRH78ZoTfi4FY28h0sps7+Cr2ijvHYKDLm05qJNYhdcPzfxlANSxDX/uJ0GW2Pj6BhJnNrutr1HFjorfIPUXPKFXjOwXr9hX69bnuR43ZjlsYDhk62bPj7i4sOjb3AL/YJwC1D9GXiF2P7788YTpMNczYD8AgFHNcrC9/rgCtQZmkrJL79qPJnKts3Q/CXmdxY9ZOt4aJ52usQxByiB4S72q48qwbkyk19lPp7MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N+KX1Iwb2cTXXRV4ZnpsSP2nxEg+7gwvhZEQ8K5NypE=;
 b=Tr68v3nzVMmEVhV9vrLqlvrU/htqo3+kzYhDIiFxacg6WO9DijO/e+xRA4T4ygP9FRbHM/HVIgrw1gwrGWX89Mf9BMQMx7nOuVpxZOtvB3a8Oul9ChuK+Llb7EeVm826rpNgqsbB6jaGng2EZKLDOe8WI/0MXfeVwLXzWvIb7Lg=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA2PR11MB4921.namprd11.prod.outlook.com (2603:10b6:806:115::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.31; Thu, 8 Jul
 2021 19:04:25 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::e0af:535:1998:c7ac]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::e0af:535:1998:c7ac%3]) with mapi id 15.20.4287.033; Thu, 8 Jul 2021
 19:04:25 +0000
From:   <Don.Brace@microchip.com>
To:     <pmenzel@molgen.mpg.de>, <Kevin.Barnett@microchip.com>
CC:     <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <Mike.McGowen@microchip.com>,
        <Murthy.Bhat@microchip.com>, <Balsundar.P@microchip.com>,
        <joseph.szczypek@hpe.com>, <jeff@canonical.com>,
        <POSWALD@suse.com>, <john.p.donnelly@oracle.com>,
        <mwilck@suse.com>, <linux-kernel@vger.kernel.org>,
        <hch@infradead.org>, <martin.peterson@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
Subject: RE: [smartpqi updates PATCH 2/9] smartpqi: rm unsupported controller
 features msgs
Thread-Topic: [smartpqi updates PATCH 2/9] smartpqi: rm unsupported controller
 features msgs
Thread-Index: AQHXcwHAUDlfVz7mEUGnZ/7ayWT+AKs5cWuw
Date:   Thu, 8 Jul 2021 19:04:25 +0000
Message-ID: <SN6PR11MB284877FDAB929F223AEC14B5E1199@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20210706181618.27960-1-don.brace@microchip.com>
 <20210706181618.27960-3-don.brace@microchip.com>
 <17eeaf22-4625-d733-dcfb-ec2322dd0ca6@molgen.mpg.de>
In-Reply-To: <17eeaf22-4625-d733-dcfb-ec2322dd0ca6@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: molgen.mpg.de; dkim=none (message not signed)
 header.d=none;molgen.mpg.de; dmarc=none action=none
 header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 709896f7-ab61-4358-09f6-08d94243344d
x-ms-traffictypediagnostic: SA2PR11MB4921:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB4921BEB210303B2435AA8A50E1199@SA2PR11MB4921.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H1esEdzTMx9MzNOA02i5Z4CyLgjMhGCfdDz38QZ33fk1Wx8l1JdteOBdyho0XnFVQrDYwuhd7STkShQj3xkEGU9bzG7BDErr9kb9P+lHLyBGWmOVKr887FI0r5GwV1XjulRsC4jmOaEcVzp4sbPU9J7KU0vnRdPJi/lLAsfWWLpLXZaHX+m4Opc9r+Gc50Jgk4aKO8LUMvCc4AcbyEG0x1kb1AsZjxD/AhGFOs+Pjp0U9dKzgQ0s3wzHpr23fZ8Hx0P6TIOqbRsaipUvJUCcFrIB/qAOlPS01ig7XB/8545ihMdX7DaT/JxWIvXmx5f2jC6KvZteiq9gEM1WQMAUMUToM9satjjG/LKgvLmtrmjaF8aEDO81C295/6i4hCevcB5SjGElPcFED7z12FajY7luKoHRnAwvVctiNY0JP/2BRWAuf0yPSixpRctzE0FE+4FnTr5X9+KB6CF8QIBQaiqdcXIKDtFPk6KM3YlZRVP6P21z5aePIfsvVK+oM9dwtTfEGLOrRtJLye5UvO6vKDg9biWTJqDjlpJ/Wq3YW6ihFlhPy8YBXZXQGhmLyjk0sElSFAqfhw9+5VqbNQOUJkoOlBGXly2+W3BQXKJIDnvoW6Aonjjh9GkJXFqtG9D6+kWh0npibs3tQ0A4zgO8vw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(396003)(366004)(376002)(33656002)(8936002)(4326008)(38100700002)(122000001)(2906002)(186003)(76116006)(55016002)(6506007)(7696005)(316002)(53546011)(8676002)(71200400001)(52536014)(7416002)(9686003)(83380400001)(6636002)(54906003)(110136005)(15650500001)(26005)(86362001)(64756008)(66556008)(5660300002)(478600001)(66476007)(66446008)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q1Q2YTNkQWNIYlNhRFpCWU1sVDB0NWJVRkp6dUIzenR0L0xGUkRrZmFSbGxo?=
 =?utf-8?B?KzBiemZnS01rMUtQV1hpNXJkU1JQWFdUVFVKVE8zRy8xSFBVUm9wWkNMTElj?=
 =?utf-8?B?TTIwOEFWa0M3dWFJUm92a2RTcnVSbk5XN0IxeFlsbUlRQXBOaVFvVXMvSjJl?=
 =?utf-8?B?aXRnTXlWbWNEWVQyZ3liSkRSUW9RUkE1OVk2KzJmNEtuN1p6b2dBUmpPQzlz?=
 =?utf-8?B?U1dCT2JSUUNTd1lUbmpXc3g5RGlvMVBrYkc1OVRoT3NYdjJXbTFtSDd4S0ts?=
 =?utf-8?B?RkNlcm94MVFsaThaTlVxS3I0Z0ZQbGlpU1JsUVFjTHk0VnJrSjlZMlY1ZEd6?=
 =?utf-8?B?MzllRCtoTVQrQkhxVDI1ZlZGbG1rWGxWRDZaNjJPU0ZXcEhaUXBwYkV6OVhJ?=
 =?utf-8?B?STVvaGhLYUo2SEdSaTRGSjdkSGgzYnZNZGluL3hIQ2RxRVp0ZUd0Q01qWERp?=
 =?utf-8?B?SmQ0ZmtvVVRwT09TdlQ1OE9IcERGQS95WlpIVlB4V1k0SElQUTNyOHBoeko0?=
 =?utf-8?B?TW9LQzNTNTNKZFBFWGczVGlCODJiVXJ6a1lKYUx3eVZpWXF0akFacXQ4aTYx?=
 =?utf-8?B?azlUOHpTRU5NdzVZOXhkODdmb3NoK3p6QjJCdVJXRzNNSXc5YytNR3RyWVVY?=
 =?utf-8?B?bThEOUZEbG5qTVgySzVEYWJxVzA0bnhpZEpGODJwVSszTFFXSDZRek9vb0dN?=
 =?utf-8?B?Zm1nQ01uVnpSN3VTdUFLYjBuK2R0SklHU3Npb0lxK3RiNVA2YWF4MDZYczVH?=
 =?utf-8?B?MC9TYWp3YWtnQkZIdmw0b2liU2d5akZaZWJWcjdPc3dSZlR3UkNwZld2WUJT?=
 =?utf-8?B?VUtDdUZUNDAvRTV4ZWZsZGViZEFPRnYyUTNKVG9yem5YZlg4c3Jmd3JyNEpE?=
 =?utf-8?B?MElFN1pjYnNoQjZHbkEydE03NU9OdU5yS0Rpcmk3czlCTWRvemVRSFdxMUZJ?=
 =?utf-8?B?cytCaTBSQkF5WU1peHVyMXRhdURsTk9hanpybW4xeWlZSzU2TWV1TFZIRXpk?=
 =?utf-8?B?WEtmRWFrSkprTlhUTys0K2dyYUFVU0tGeW5ZUjlDb1BSd2Q0dWtLd3l6akpr?=
 =?utf-8?B?NTR1OVVEUFVzNUYvbTU1N0VQNEhOS2w1SHV0NUJveUJIbElqN1ZvZnRPclJt?=
 =?utf-8?B?MmhnRWluQW8zZFNtYzFRQ0NPS1A2cytORzNwWWNZMDYxUmhtWVlrUTFCOVJ2?=
 =?utf-8?B?eVFPOTczRHpKRmcySU8xMVJSWGlHUW9oOG1IR0tQWnVudmpDZUpWcHdnMmdw?=
 =?utf-8?B?ZlU5Z3AxMnRIL1ljc1M3M0gyenRVSXlDaGZCOENYRzZFeUVYZmpkY0gyaXhy?=
 =?utf-8?B?Q2VhenVGVHk4V2UvbklJK2ZYcHh4MzNTUHdSditIMkdETHBKQVd0TmNZS2xi?=
 =?utf-8?B?ZUg0dGk4S1BuKzJIdHRpQ3Z2eHhNYXAza1h4SlMyY2h0bHBVdFN5S3NiU0ZI?=
 =?utf-8?B?TlpITHdUYnVJeDJpcm52VTlFeFhwWi9ENDIzNjI4eTQvNkxpQ0NJQnRwTUo2?=
 =?utf-8?B?VUlpckpoYkU4YW1MejYvNU84NmMyYjlCYW41T1VYUldHQ25CSXo3QmJYcU4y?=
 =?utf-8?B?UlR1Y3N3M0U3dVRKbVRBR3hXUXFZWDVTQUdrSDRHQ09LRVpTNVRmQ3M3VXNO?=
 =?utf-8?B?WitnR3V3QVVjSnJ4NnFEU2RMSkkyN25wUVdHb0w1VnhzODgwSkhPSGtJcU1E?=
 =?utf-8?B?VHpmYzZkYis5RnJUT2JRaHRhRFNsT2JYZXRrYVVqcVNLZmR1WnV6R3lxci9I?=
 =?utf-8?Q?MMqmdSZrI9af8GJUY5QD3MIiG5O/DO9XhzCnOGY?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 709896f7-ab61-4358-09f6-08d94243344d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2021 19:04:25.5772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wA3nZE1+HCxa3gaeIBZohOGWpIHNFJMxzHO21265B3SSn7WBnZmUSc3tcbKdqOIzWuVvAQrcU81eoHWL3GCdzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4921
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IFBhdWwgTWVuemVsIFttYWlsdG86cG1l
bnplbEBtb2xnZW4ubXBnLmRlXSANClNlbnQ6IFdlZG5lc2RheSwgSnVseSA3LCAyMDIxIDI6Mjkg
QU0NClN1YmplY3Q6IFJlOiBbc21hcnRwcWkgdXBkYXRlcyBQQVRDSCAyLzldIHNtYXJ0cHFpOiBy
bSB1bnN1cHBvcnRlZCBjb250cm9sbGVyIGZlYXR1cmVzIG1zZ3MNCg0KRGVhciBLZXZpbiwgZGVh
ciBEb24sDQoNCg0KQW0gMDYuMDcuMjEgdW0gMjA6MTYgc2NocmllYiBEb24gQnJhY2U6DQo+IEZy
b206IEtldmluIEJhcm5ldHQgPGtldmluLmJhcm5ldHRAbWljcm9jaGlwLmNvbT4NCj4NCj4gUmVt
b3ZlICJGZWF0dXJlIFhZWiBub3Qgc3VwcG9ydGVkIGJ5IGNvbnRyb2xsZXIiIG1lc3NhZ2VzLg0K
Pg0KPiBEdXJpbmcgZHJpdmVyIGluaXRpYWxpemF0aW9uLCB0aGUgZHJpdmVyIGV4YW1pbmVzIHRo
ZSBQUUkgVGFibGUgRmVhdHVyZSBiaXRzLg0KPiBUaGVzZSBiaXRzIGFyZSB1c2VkIGJ5IHRoZSBj
b250cm9sbGVyIHRvIGFkdmVydGlzZSBmZWF0dXJlcyBzdXBwb3J0ZWQgDQo+IGJ5IHRoZSBjb250
cm9sbGVyLiBGb3IgYW55IGZlYXR1cmVzIG5vdCBzdXBwb3J0ZWQgYnkgdGhlIGNvbnRyb2xsZXIs
IA0KPiB0aGUgZHJpdmVyIHdvdWxkIGRpc3BsYXkgYSBtZXNzYWdlIGluIHRoZSBmb3JtOg0KPiAg
ICAgICAgICAiRmVhdHVyZSBYWVogbm90IHN1cHBvcnRlZCBieSBjb250cm9sbGVyIg0KPiBTb21l
IG9mIHRoZXNlICJuZWdhdGl2ZSIgbWVzc2FnZXMgd2VyZSBjYXVzaW5nIGN1c3RvbWVyIGNvbmZ1
c2lvbi4NCg0KQXMgaXTigJlzIGluZm8gbG9nIGxldmVsIGFuZCBub3Qgd2FybmluZyBvciBub3Rp
Y2UsIHRoZXNlIG1lc3NhZ2UgYXJlIHVzZWZ1bCBpbiBteSBvcGluaW9uLiBZb3UgY291bGQgZG93
bmdyYWRlIHRoZW0gdG8gZGVidWcsIGJ1dCBJIGRvIG5vdCBzZWUgd2h5LiBJZiBjdXN0b21lcnMg
ZG8gbm90IHdhbnQgdG8gc2VlIHRoZXNlIGluZm8gbWVzc2FnZXMsIHRoZXkgc2hvdWxkIGZpbHRl
ciB0aGVtIG91dC4NCg0KRm9yIGNvbXBsZXRlbmVzcywgaXMgdGhlcmUgYW4gYWx0ZXJuYXRpdmUg
dG8gbGlzdCB0aGUgdW5zdXBwb3J0ZWQgZmVhdHVyZXMgZnJvbSB0aGUgZmlybXdhcmUgZm9yIGV4
YW1wbGUgZnJvbSBzeXNmcz8NCg0KDQpLaW5kIHJlZ2FyZHMsDQoNClBhdWwNCg0KRG9uPiBUaGFu
a3MgZm9yIHlvdXIgUmV2aWV3Lg0KQXQgdGhpcyB0aW1lIHdlIHdvdWxkIHByZWZlciB0byBub3Qg
cHJvdmlkZSBtZXNzYWdlcyBhYm91dCB1bnN1cHBvcnRlZCBmZWF0dXJlcy4gV2UgbWF5IGFkZCB0
aGVtIGJhY2sgYXQgc29tZSBwb2ludCBidXQgd2UgaGF2ZSB0YWtlbiB0aGVtIG91dCBvZiBvdXIg
b3V0LW9mLWJveCBkcml2ZXIgYWxzbyBzbyB3ZSBob3BlIHRvIGtlZXAgdGhlIGRyaXZlciBjb2Rl
IGluIHN5bmMuDQoNCj4gUmV2aWV3ZWQtYnk6IE1pa2UgTWNHb3dlbiA8bWlrZS5tY2dvd2VuQG1p
Y3JvY2hpcC5jb20+DQo+IFJldmlld2VkLWJ5OiBTY290dCBCZW5lc2ggPHNjb3R0LmJlbmVzaEBt
aWNyb2NoaXAuY29tPg0KPiBSZXZpZXdlZC1ieTogU2NvdHQgVGVlbCA8c2NvdHQudGVlbEBtaWNy
b2NoaXAuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBLZXZpbiBCYXJuZXR0IDxrZXZpbi5iYXJuZXR0
QG1pY3JvY2hpcC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IERvbiBCcmFjZSA8ZG9uLmJyYWNlQG1p
Y3JvY2hpcC5jb20+DQo+IC0tLQ0KPiAgIGRyaXZlcnMvc2NzaS9zbWFydHBxaS9zbWFydHBxaV9p
bml0LmMgfCA1ICstLS0tDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCA0IGRl
bGV0aW9ucygtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3NtYXJ0cHFpL3NtYXJ0
cHFpX2luaXQuYyANCj4gYi9kcml2ZXJzL3Njc2kvc21hcnRwcWkvc21hcnRwcWlfaW5pdC5jDQo+
IGluZGV4IGQ5NzdjN2IzMGQ1Yy4uNzk1ODMxNjg0MWE0IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L3Njc2kvc21hcnRwcWkvc21hcnRwcWlfaW5pdC5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9zbWFy
dHBxaS9zbWFydHBxaV9pbml0LmMNCj4gQEAgLTcyNTUsMTEgKzcyNTUsOCBAQCBzdHJ1Y3QgcHFp
X2Zpcm13YXJlX2ZlYXR1cmUgew0KPiAgIHN0YXRpYyB2b2lkIHBxaV9maXJtd2FyZV9mZWF0dXJl
X3N0YXR1cyhzdHJ1Y3QgcHFpX2N0cmxfaW5mbyAqY3RybF9pbmZvLA0KPiAgICAgICBzdHJ1Y3Qg
cHFpX2Zpcm13YXJlX2ZlYXR1cmUgKmZpcm13YXJlX2ZlYXR1cmUpDQo+ICAgew0KPiAtICAgICBp
ZiAoIWZpcm13YXJlX2ZlYXR1cmUtPnN1cHBvcnRlZCkgew0KPiAtICAgICAgICAgICAgIGRldl9p
bmZvKCZjdHJsX2luZm8tPnBjaV9kZXYtPmRldiwgIiVzIG5vdCBzdXBwb3J0ZWQgYnkgY29udHJv
bGxlclxuIiwNCj4gLSAgICAgICAgICAgICAgICAgICAgIGZpcm13YXJlX2ZlYXR1cmUtPmZlYXR1
cmVfbmFtZSk7DQo+ICsgICAgIGlmICghZmlybXdhcmVfZmVhdHVyZS0+c3VwcG9ydGVkKQ0KPiAg
ICAgICAgICAgICAgIHJldHVybjsNCj4gLSAgICAgfQ0KPg0KPiAgICAgICBpZiAoZmlybXdhcmVf
ZmVhdHVyZS0+ZW5hYmxlZCkgew0KPiAgICAgICAgICAgICAgIGRldl9pbmZvKCZjdHJsX2luZm8t
PnBjaV9kZXYtPmRldiwNCj4NCg==
