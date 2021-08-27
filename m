Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9756DC432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 17:00:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75FFD60FE7
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 17:00:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbhH0RBT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 13:01:19 -0400
Received: from esa.hc4959-67.iphmx.com ([216.71.153.94]:51494 "EHLO
        esa.hc4959-67.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhH0RBT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 13:01:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=seagate.com; i=@seagate.com; q=dns/txt; s=stxiport;
  t=1630083630; x=1661619630;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HoC+b0V44K0aBX6OkwESL50jSdYQNI/CcY0+uBZyoN8=;
  b=C9Ude+RrEbjglqIGTx2btLj+aY6xEvT7lTTdfDnqNbbf+2mzE81AbRni
   DQL6pY74HIv9L18ZwvdBGfpuK/QRGLshHeXKTIgIq6P4cqQgZmCEa1+dd
   ooPJ/VZvVBrMWP6PH6w7YAxQMeBbmJY6IU1fzkEqXsE+DUncrhu8XUiDD
   4=;
IronPort-SDR: MYwQlL1S2/QZoenDxSjq5z5QuDbOBEMuQz/nbNCRVhle/IRrf1F+3FQSP1JUB4ql78w13k/do6
 ODfo9/dhwOAK8OMUkEE4+TVwWBrEy6bIkhvnie296kpJAJkwG8L4w01JGy88w1PkVBiDLdNgtM
 W/0ZkM3dmUChzE5xewxsPMw1R8DV3sjJD1o8SL7817sqFldkjHv/kl2ayE6IvOwfEvDBrHZs4X
 f3MxT9u5Rfk4QDtpRQ1YfM0hgGJ03di9JYwhix/Sm09AxQ9nBRxyepk4WRnemxbIZUqY8reo4S
 +ek=
Received: from mail-dm6nam08lp2049.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.49])
  by ob1.hc4959-67.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 10:00:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b0L5CFhxX+F0FBQOaQRxx0Mpcn802/c8g7m0+XcD6UQ12RUsqygPB3UrxIujCApDjDqWYkeJ3IoQ0EYWUiQ9Rw9eze0wcIYpCjb67u3ATIU8QtgGHMeaG083CyZdJZuVggh0IkS51QbUAgRHMqLVFX232QP3q64wcYtZ17WisKqB/FlBy9Hx0SeP4TSBd4u7Kqm7c4MeZyx7et2Tmz11OdaKeYtlqnThqN6gchzuTohdkJuZKjUYCenV5otD/k6CfCxxsuj+dklTPYz/xdQGDUi3CWF21kqDb401UCaWBFhBERjs/irR4d0yfajkWgFbhit4PK4MHQRBlbTV1UZQuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HoC+b0V44K0aBX6OkwESL50jSdYQNI/CcY0+uBZyoN8=;
 b=E/1JkY8BSFMzRsDcPUqaFSelRdzpWAp+GCN0hCO6+8C2tQPgfV/Tt46p08892916T7RfsIXSBUzoNGaKuSG3lgnYDlOmVsaEMKkupO43KXJ6rrn3VXaHuFclZdhXcn/86CH7jx6ufsPisgNEbCO94FbnOOPEvsTcY4r8DuNhf34bSZ6BddBPDV0o0CtxVJrHS4dO8MH0NXwn/2SS+smUHuobERIpJhdqIi1lzaTBulHvMW1ly6CdYQQ4WURAl77Cong2V+xwcGDSMP4+NJWYwMmLVJSDZ6DSg3ZCRe3LlaWH9D5CfwYWmoJyOI5Ga11lroCFFmuAECo0bAM0fYnObg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seagate.com; dmarc=pass action=none header.from=seagate.com;
 dkim=pass header.d=seagate.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seagate.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HoC+b0V44K0aBX6OkwESL50jSdYQNI/CcY0+uBZyoN8=;
 b=AC0CH+lXz2S4/IYTUKzv3ci5Y9KSbGvbrLs5vX/xsY/70d7NaiN+OWHVZZufW+2gtpxrnj/bzFAggYXG27yNZV74JSqzQ8FwQxOYIc7l/4vCHlo/FiqqDBFidP/EchVCi4NKiotc+s+vaweV7cXHcESAsd7oGoOKe4jjt9AotPM=
Received: from BLAPR20MB3954.namprd20.prod.outlook.com (2603:10b6:208:331::13)
 by MN2PR20MB3368.namprd20.prod.outlook.com (2603:10b6:208:266::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 27 Aug
 2021 17:00:25 +0000
Received: from BLAPR20MB3954.namprd20.prod.outlook.com
 ([fe80::b136:c626:f470:9c11]) by BLAPR20MB3954.namprd20.prod.outlook.com
 ([fe80::b136:c626:f470:9c11%8]) with mapi id 15.20.4436.024; Fri, 27 Aug 2021
 17:00:25 +0000
From:   Tim Walker <tim.t.walker@seagate.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     Phillip Susi <phill@thesusis.net>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v6 0/5] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v6 0/5] Initial support for multi-actuator HDDs
Thread-Index: AQHXmxikLMXwHJHQ7EuVsznHq+0e5quHYRMA///FawCAAGgegP//wjIA
Date:   Fri, 27 Aug 2021 17:00:25 +0000
Message-ID: <D2424B1B-8EAC-4A12-B92B-B469DA38E3A7@seagate.com>
References: <20210827075045.642269-1-damien.lemoal@wdc.com>
 <874kbbugtw.fsf@vps.thesusis.net>
 <63D90989-AFAF-410B-AD11-EDF71CEEE666@seagate.com>
 <YSkVwSfQ/9RCKfEG@infradead.org>
In-Reply-To: <YSkVwSfQ/9RCKfEG@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.52.21080801
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=seagate.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1357e49a-ca0f-484f-7d85-08d9697c2a1d
x-ms-traffictypediagnostic: MN2PR20MB3368:
x-microsoft-antispam-prvs: <MN2PR20MB33684ADBC149F7B1770C1EDCD7C89@MN2PR20MB3368.namprd20.prod.outlook.com>
stx-hosted-ironport-oubound: True
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hwRrixzv4jxN3lhFJlc6oN/F1GTJMw3EuQg8W89ddWnvIbJPxsYzMzalNdGtUJUPaqHk24XI5esvRlYNbYdBUaI/IrUSzOyKdEIWNZA6FozKJGmefhKT6V2BrkIK6QJc3x17QFo1pNiZ2mfO/YEGXgteA7uZ1tJReCmfwMinxGe1N83kq2EVCAwD7e0Seau4yFNMUcXQI7BSzNhnP5U3ZVsdzQHlDKFRNI971t7zzaWDmWizyk0h+U0A0hoS26mSqvbafoR3JX30/hsWp+dSIVP4dkC58QGclydPTzqKSEbwSCYpXoxL5LAhCY2S+aLYK3JnaKKxnEzSsf67JQjooPNRLdh20pkNk1pusN2Aptd2/8nCciRdWX0ikx5jJjZEVpNSS8jILR/6iJMnyWvF9e6v/stTZqtr4CmIfmhpGGv+Vo9LNJZWagqy380B014Kjpu3rDQWc3MfOr2PDgOGi1BSpJrgTh2O+PzTzEEIcdm4OUp8lv05BP08xRV3Qi3pCl3TzXVac9yZlPNhsaJWcKeTENKWMrFPdoGl6bVFsjeZgcnNsR9hl4YGkp/N0RZSMgzg2sHtKErlV4rBwu5/+KXThX9QkwglnfB/nxc31wnvA6Gy0CK/Km2cGJw0vU2OX56UnNVGnzYZr/hK1eqGWwtw05ZQ4t1wypx30LpnXFuTjXCKRY8021CWHwfJAALDIx6MlcULMIUbQ+UB8gNY5VgXy5bM/Auko2RaO46/Re3FtKzdhZkW67pjQ0ueetXW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR20MB3954.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(39860400002)(136003)(376002)(2616005)(316002)(38070700005)(8936002)(38100700002)(478600001)(6512007)(5660300002)(86362001)(2906002)(66476007)(53546011)(33656002)(66556008)(4326008)(91956017)(71200400001)(66446008)(6916009)(66946007)(76116006)(8676002)(83380400001)(26005)(6506007)(186003)(122000001)(64756008)(36756003)(54906003)(6486002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bmNqb0U5SDdQeXRVQ0dpbUJLMkNoQW8yeDVrcE9LRzRpUWYxeHBXNFlQcE1r?=
 =?utf-8?B?TkJQajQvT0RUd2Z1a1oyOTJVZ01LTjZhU1c4MnFITHpEZGRyTFROK2pydzFT?=
 =?utf-8?B?TzlaOTNMSWRXdTNsMkZnMThINlhzR21nZGJmMzJoM3dhbVpKVnlUcVNnYlBz?=
 =?utf-8?B?aHc1S3Y2NGttWVlwd3BKZitlQXVkUW5CVG9GOWpKdkRjNThpMXNkQ2tiQWFh?=
 =?utf-8?B?QUJaMDZTR2JWU0JxblNIRXVTc2V1SWZLMldlcGY0dWlIMjdHK3FVay9Ld1hT?=
 =?utf-8?B?NWpscTJWQkVZK2RLaGRZQXNBQU9vNk5RRHJIRkU4emw2VjA4UEs1WVN4OHRP?=
 =?utf-8?B?MHRSbjRoNFU4M2JtZUNTcytRd3FnMmtvemEyNjMrTWFqbDJIWGVCZjR2M2FF?=
 =?utf-8?B?WDhtR1hXYUd0TlIzWnZTMW5kc2xMZlZkOEJUejRSUDlKalVIQ3hqKzRXM0NW?=
 =?utf-8?B?SkE4dGlQS0Qzb1J2bVZsb2lISEI3ZG50UC90c3pSMWxaRnV6aURpU1dkcklE?=
 =?utf-8?B?RWJjU1BmOGJ3YnNsdVlNUkpDdnN2b2cxZlRtMmhScWlGNDBBd3EyaVFqeWxh?=
 =?utf-8?B?cDgvZWZtRlVaWk5iNEtxTzEzTFV6ZWxVR1NhV21uKzNvTDFLRVVsNHlhc0VW?=
 =?utf-8?B?V1Qwa0xHYzVVY2pCbFFvZ1lreEowZEY0b1VrVXpBWHpDZWJkRnZuVE5pQ0xr?=
 =?utf-8?B?T3ptUDVSTWgwRjdobWRNM3U2UzBwYUdWVjNLWTJmUDhYUnNrMWxSK05HZnNX?=
 =?utf-8?B?UENrT1RmRTFGTFdpWVNBWmhhdC93VkRNMXVFZDMySVZmM0huRG1WT2hhaFhW?=
 =?utf-8?B?N2pKM3NpSGg5ZTBteFFJNVI5Z3pDU0x0bEtqSjRsUzd4a2dzMGhCUjE0RStY?=
 =?utf-8?B?UkdhVS81emZGNDFFVFh0U3lPYzV2YlZVWWZDZHNCRExucXZENFVxeHBTNStu?=
 =?utf-8?B?cC9lcU9nOXdzZVZVT0JVV21LU0o4VVdzcmtVVkxrUHRKY0ZGNDBQUTdaVTBi?=
 =?utf-8?B?aXlYaFR3YWdLdThPblFMRHRwYStuYUNYTlo0QXF6RWRCM05yNXN0QnlWbEFS?=
 =?utf-8?B?UHlTdHV6MGI2bzI2YkkrbHp1bzN0UjNNbUZTMnNLeThUM3JzRGNCVk1kR1hY?=
 =?utf-8?B?WW1FYWUrVmVybmZNVnhvOU1iZWxHcmVoSmZEWmhIMC9Sc3pFNEV2S0E1eERF?=
 =?utf-8?B?dTdKcHdnbjlabEVYK3piVDJ0LzJyWlB0eTI2UUtlaVN0bHlMa2FrMHZDMC9K?=
 =?utf-8?B?K1NMQm45OEZUUzcyR2FCMFBQbTdqb2xRQlM0SldoSEZseTc3Q29CcDBXM05G?=
 =?utf-8?B?YnhKRllmOHRBYno5TUl2Y1hDZjMveC85VWNtOU1RK0p4Ulo5STdyR09qUFpk?=
 =?utf-8?B?QTNjWk9OR0ZiVGc5QmtQWUZSV0xjcHRuT2J2UUlRZ3UwRlJndXFLQ0lxWFdB?=
 =?utf-8?B?YldLdW5YU2IrT1U0YmFjbmJjOE9YMk1PVy9zN3dzYWFLZlN2ZGFWeVlDN1Fv?=
 =?utf-8?B?VlhwdUp5b2l3aGJ2YlAyR0xlQ3I4WkwzdzZPNnNsdTRqbzk2SUZ6NjQvMzJ3?=
 =?utf-8?B?bEFOWm5udWZKZUgzaUtxK2Z1ODdJVWx0N2xPWHZqVFo2S3BOZmViZURQNzNE?=
 =?utf-8?B?ZkJXZ1JZUUgyNm1wRDVWaTFKZXhTbXlFR2ZGc3ZnN0lISGREeUpUM0sxUGFD?=
 =?utf-8?B?R3hlN2d2R3ByQjgvR0w3UnNUYWZ6NmYxSzY1bkt6b1RDSGJpclQzWGlKVFRa?=
 =?utf-8?B?NU1qeWNoaWRkTk5jUlE1b21IdzBzQVVPVGUxZ0FiQ1VTcmdudkI3QmptMVRr?=
 =?utf-8?B?NHk5ZlZ3NHNZYXpwSE5MQT09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C6DFB0166375CE49AD35A8BDBC337FF1@namprd20.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: seagate.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR20MB3954.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1357e49a-ca0f-484f-7d85-08d9697c2a1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2021 17:00:25.0822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d466216a-c643-434a-9c2e-057448c17cbe
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Up5Q8nZVqoofoeLqzvPEsrBEuOAH6YCo8PLuqODmKL7yyQXIjTHlm58zFiqHc141x4qURX2Jea7X1PvBvW95yfQuHkZLbvlDa/arFQDeM4w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3368
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQpPbiAgRnJpZGF5LCBBdWd1c3QgMjcsIDIwMjEgYXQgMTI6NDI6NTQgUE0gQ2hyaXN0b3BoIEhl
bGx3aWcgd3JvdGU6DQo+DQo+DQo+DQo+T24gRnJpLCBBdWcgMjcsIDIwMjEgYXQgMDI6Mjg6NThQ
TSArMDAwMCwgVGltIFdhbGtlciB3cm90ZToNCj4+IFRoZXJlIGlzIG5vdGhpbmcgaW4gdGhlIHNw
ZWMgdGhhdCByZXF1aXJlcyB0aGUgcmFuZ2VzIHRvIGJlIGNvbnRpZ3VvdXMNCj4+IG9yIG5vbi1v
dmVybGFwcGluZy4NCj4NCj5ZaWtlcywgdGhhdCBpcyBhIHByZXR0eSBzdHVwaWQgc3RhbmRhcmQu
ICBBbG1vc3QgYXMgYmFkIGFzIGFsbG93aW5nDQo+bm9uLXVuaWZvcm0gc2l6ZWQgbm9uLXBvd2Vy
IG9mIHR3byBzaXplZCB6b25lcyA6KQ0KPg0KPj4gSXQncyBlYXN5IHRvIGltYWdpbmUgYSBIREQg
YXJjaGl0ZWN0dXJlIHRoYXQgYWxsb3dzIG11bHRpcGxlIGhlYWRzIHRvIGFjY2VzcyB0aGUgc2Ft
ZSBzZWN0b3JzIG9uIHRoZSBkaXNrLiBJdCdzIGFsc28gZWFzeSB0byBpbWFnaW5lIGEgd29ya2xv
YWQgc2NlbmFyaW8gd2hlcmUgcGFyYWxsZWwgYWNjZXNzIHRvIHRoZSBzYW1lIGRpc2sgY291bGQg
YmUgdXNlZnVsLiAoVGhpbmsgb2YgYSB0eXBpY2FsIHN0b3JhZ2UgZGVzaWduIHRoYXQgc2VxdWVu
dGlhbGx5IHdyaXRlcyBuZXcgdXNlciBkYXRhIGdyYWR1YWxseSBmaWxsaW5nIHRoZSBkaXNrLCB3
aGlsZSBzaW11bHRhbmVvdXNseSBzdXBwb3J0aW5nIHJhbmRvbSB1c2VyIHJlYWRzIG92ZXIgdGhl
IHdyaXR0ZW4gZGF0YS4pDQo+DQo+QnV0IGZvciB0aG9zZSBkcml2ZXJzIHlvdSBkbyBub3QgYWN0
dWFsbHkgbmVlZCB0aGlzIHNjaGVtZSBhdCBhbGwuDQo+U3RvcmFnZSBkZXZpY2VzIHRoYXQgc3Vw
cG9ydCBoaWdoZXIgY29uY3VycmVuY3kgYXJlIGJvZyBzdGFuZGFyZCB3aXRoDQo+U1NEcyBhbmQg
aWYgeW91IHdhbnQgdG8gZ28gYmFjayBzdG9yYWdlIGFycmF5cy4gIFRoZSBvbmx5IGludGVyZXN0
aW5nDQo+Y2FzZSBpcyB3aGVuIHRoZXNlIHJhbmdlcyBhcmUgc2VwYXJhdGUgc28gdGhhdCB0aGUg
YWNjZXNzIGNhbiBiZSBjYXJ2ZWQNCj51cCBiYXNlZCBvbiB0aGUgYm91bmRhcnkuICBOb3cgSSBk
b24ndCB3YW50IHRvIGdpdmUgcGVvcGxlIGlkZWFzIHdpdGgNCj5vdmVybGFwcGluZyBidXQgbm90
IGlkZW50aWNhbCwgd2hpY2ggd291bGQgYmUganVzdCBob3JyaWJsZS4NCj4NCg0KQ2hyaXN0b3Bo
IC0geW91IGFyZSByaWdodC4gVGhlIG1haW4gcHVycG9zZSwgQUZBSUMsIGlzIHRvIGV4cG9zZSB0
aGUgcGFyYWxsZWwgYWNjZXNzIGNhcGFiaWxpdGllcyB3aXRoaW4gYSBMVU4vU0FUQSB0YXJnZXQg
ZHVlIHRvIG11bHRpcGxlIGFjdHVhdG9ycy4gSSBob3BlIHRoZSByYW5nZXMgYXJlICphbHdheXMq
IGNvbnRpZ3VvdXMgYW5kICpuZXZlciogb3ZlcmxhcHBpbmcuICBCdXQgdGhlcmUncyBubyB0ZWxs
aW5nIHdoYXQgc29tZWJvZHkgaGFzIHVwIHRoZWlyIHNsZWV2ZS4gDQoNCkJlc3QgcmVnYXJkcywN
Ci1UaW0NCg0K
