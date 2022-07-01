Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E92EC43334
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jul 2022 07:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234764AbiGAH0r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jul 2022 03:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234099AbiGAH0p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2022 03:26:45 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 01 Jul 2022 00:26:43 PDT
Received: from esa16.fujitsucc.c3s2.iphmx.com (esa16.fujitsucc.c3s2.iphmx.com [216.71.158.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85016B81B
        for <linux-scsi@vger.kernel.org>; Fri,  1 Jul 2022 00:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1656660405; x=1688196405;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2U95UnGTZj6AXlTr0HJJiaOM6PZYa5sYnvjoBUeWfL8=;
  b=dSyjXw/kcj6ul5P3N1FFJip9+IJCoQYUCh6aY68nT+BkVF5/uiIIagoi
   tXuoZL7fCOpXgXjdoSo6AUEOwKLykpsY+Yc/ahYqUoWEvUl/AtNQVzJI2
   StOiucSRZr2ttvht7Qozvfu80M3Y4aUA/9+iJ6m3us2dY2jQa6xHUci9x
   bk0oTXJO7ZMSXlMn8w0/2PmkheIUtp/VvR5ysrQZZFwwAwZBeTVFD4GwA
   jxKp4GQiFhAgAiiFnJI2ISQiz0tVNGDq1TarfiPTuVrrU/DmQEAgUmTiQ
   6vck0jotTKCUrOrZzPqJmjhlrRl9Sq7XH+9y6k6Gd5L9YKACWWub3fNfY
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="59331678"
X-IronPort-AV: E=Sophos;i="5.92,236,1650898800"; 
   d="scan'208";a="59331678"
Received: from mail-tycjpn01lp2177.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.177])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 16:25:38 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CNRbDT6nNY1KW1PsZpIgwmlM0vms6pUSJ5wGhzJMQPTJ+29rTDjpJ5pdH+g3FjgSGUjwCKgKv/+0fUfsWtGDzrph2mbvjkJ/MbI4JXV363HoBKlslQVoGD6zmTiwqprx0NtFe6Q7q0HliCzHAayHCFQoKtm1ul7iZABEJrAteuzcsmxsmWmtM0SRlx+yNSlTOYfDEZG1O9t1nXx/R7Y/GW8FrJWtvR7GMt41haHg9gNudVTD4LRUwwpUL0KMlzQlcuUoO4ytLyAuI6CaXljS6FmDhEKB/Rum3ASqmEBCASRFNFlOEToW3vOEd7A9xL2fwxJz6ekK5lsvSUkB6Cvtpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2U95UnGTZj6AXlTr0HJJiaOM6PZYa5sYnvjoBUeWfL8=;
 b=UaJoWCfeEVNsmApzPZs0pKy/ztNiBnshSp/SC0zVHy2cbJh5Zft69NlxkyoePK8Y481ZNIbLB0g+Fo1AeRD21ekJ8M4T7Pb/L9yQlRrFlm9LbUdnfv+AhrExbrub4+sy3NonjtdaOfwk1pT0Xt+nTS7ZXZj6WTjCfvg6JXMvm4D82YTzg3UC7t8zy2GdMSs31ArP4CS4QKg0fZ/VWyfiGNZjRcwmjUJrcXwPkHRiR7riJSkkxZBHj1nsCmt+e+EupWG/TSIKrTmPsxi89cObW5zvmqo6JCTiHam8zdD5iUgt1yyf2Y0SQEaLaZCfAhr0i5dC/0Q+u11TtiGO5YS3zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2U95UnGTZj6AXlTr0HJJiaOM6PZYa5sYnvjoBUeWfL8=;
 b=Z7Z692YRh3g4p/gBjAJofXHtQQrJee4pHGdEYHyBdMMbVugknFR79f05e8/4PjLqSl6f5g1uumM6jXMKlynaaHrK5UjGG5UjoYlu1Sj8lBPdMh4bj58eUyQdsN0m9K0trmnqpSwzp5BQcyaXBV5dxJmw/awLaWtVbSyjc+YRqzA=
Received: from TYCPR01MB9305.jpnprd01.prod.outlook.com (2603:1096:400:196::10)
 by TY3PR01MB9811.jpnprd01.prod.outlook.com (2603:1096:400:22a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Fri, 1 Jul
 2022 07:25:34 +0000
Received: from TYCPR01MB9305.jpnprd01.prod.outlook.com
 ([fe80::8d7a:baa8:3b18:cd93]) by TYCPR01MB9305.jpnprd01.prod.outlook.com
 ([fe80::8d7a:baa8:3b18:cd93%6]) with mapi id 15.20.5395.015; Fri, 1 Jul 2022
 07:25:34 +0000
From:   "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>
To:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v2 3/3] scsi: core: Call blk_mq_free_tag_set() earlier
Thread-Topic: [PATCH v2 3/3] scsi: core: Call blk_mq_free_tag_set() earlier
Thread-Index: AQHYjMmn2AElkKA+/EW5VZo5drAXh61o4B0AgAA9z4A=
Date:   Fri, 1 Jul 2022 07:25:34 +0000
Message-ID: <b10714a4-02aa-6c31-2c0d-9000bca894f3@fujitsu.com>
References: <20220630213733.17689-1-bvanassche@acm.org>
 <20220630213733.17689-4-bvanassche@acm.org> <Yr5tlDkrTTldwjSq@T590>
In-Reply-To: <Yr5tlDkrTTldwjSq@T590>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c673732d-aa4b-46db-efbd-08da5b32e342
x-ms-traffictypediagnostic: TY3PR01MB9811:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V69GEpVbEop4It+cH808JTv5hG9eqq0mdlnMqD50bh5Xr6HVU1KcpnzYOntvPKK+F9RNX87CXQeYZUCgfnfeZgKtiTUtmHmdujA6ebtEiGIXyMaYQEeMofCUbb8ChY+7WLNJHolJgjHBS3oDAiZLBd56tnqVXoqPDhBsnTbFmZQ5uBEsEnvzFfZFWFKU8rvecMJmvrVyYYHufnA1hNu06QSKpvGw8bvpCx0RASMGjIqFGv9bhT6nPLLn7WYU0hp3Kr1GqjriCzxbtiuJNjnghv4sMGl2F1UjzX4o9YHXY6wZaENrgkVYx12/cSHpsqZ5tj4uD88r/7Ack6xRuvMrlL5knc9gtXucXVAmeEebu7+DyCnhQj10lrbkpf71fPC8FQFGrEoX6Th9LRKQSnae7SBlo9pwACifIaVnoJfV5ATWQgpRRKibqUP+NyYgsjoRbIKndYn993pzFkIy7rFIz13RJtomtX94Ed4GM21DaxO+wAS0IxV486Oo4DyP1o9KnoTRaI15Y2G2RSC0XpVuQbbcEWR6oNC2EqQJME4lzeijYohPER73XbTvZWKM4lX/mZNF+DmmSMYZrDEyeLyZYe/7PuW61gUZA6v+DBfpQAYMd4So+p2O9bmYWJgmwpopPrmCUImOyZpi8j9zw4F1vfroKylUvZprnsaUdRJ8DCyTPDomtGZ9Rjf41FYw0OICQa0Bx3DsrIJXii0Fj0Ycpx1ON1D3fhe2H8YC29St2MiGI7VxfUzJAEXuOBttDwlgQHiUT92y1LKkTXagdHsCnGbi22pwa8m1MBVUnvz1HyklGntSINX9Tysxb4K38n2AlKXI48u6nVrM67v4H/Y8TqHvc9qDg1RVi4t+oaiOYguAInP9gXAkMqHgBfnjjwbl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB9305.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(186003)(64756008)(86362001)(71200400001)(478600001)(83380400001)(316002)(110136005)(91956017)(54906003)(6486002)(2906002)(82960400001)(8936002)(66446008)(36756003)(4326008)(53546011)(5660300002)(38070700005)(122000001)(6512007)(66946007)(8676002)(85182001)(31686004)(66476007)(76116006)(41300700001)(6506007)(2616005)(66556008)(38100700002)(31696002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aHUxZVpGTzZQNFM1RmFpbFR2MWQ0bGFranhTbkJ5RE5mMkZsSnVxQUp3Y21J?=
 =?utf-8?B?YWI5djlaRGZET3pEYkUxRDVsVWxGcmhGMnJ6eVQrSUFOb1JJS1BOSFdIK09J?=
 =?utf-8?B?OWIyRGwrOGJFSkVKRmhyYkVkUkdDYnIySzhiNDNMMVVvQXppVVNZc0ZDOWJC?=
 =?utf-8?B?U1NqL3VHZy9pZmIrNXZkd0xOcHZmODN6SHE4VGhlY21qYWRPN01EaDFTZng4?=
 =?utf-8?B?R0ZWVzVxQ0RZWXRTbU5oS0pvc01Ldi9JVUIrUTBSSnVmTHdQcC9BUlZSTVVR?=
 =?utf-8?B?MC9SZ0lwV0xYZ3hrSmhFcWpTVE9nc0paU0FkUitsM2k2VEFtb2xFOE1DOTZr?=
 =?utf-8?B?eFdBVlNOTWd5d0U3NklWdU1LSTJOSjVYUk5ZSCs1THNYN1dyVURjNDFwMnJD?=
 =?utf-8?B?K3NybWpoQVVIUit5Vys0MDlKRVNucFExalNMY2RzL0NwelVrRWZHSmlORm5W?=
 =?utf-8?B?WktuTithSGxsQVZxcnJNMjJyMEFoSlpVRDE4aHdwdW1nOG1CQUQ0cGhVWVR2?=
 =?utf-8?B?OWRjMUpEZFVyUVgxY3JIbEwvYmpOMkVvWFhQSnhwUDNPTW1wS0tRNEo0cFdH?=
 =?utf-8?B?eGpIeWVzdzcxbmR2dnovL3J5b1RmMTJjdVJydFIzYVBLTVhhcmx2MFhEZit6?=
 =?utf-8?B?ZjhtVHFsRWVjeTVKMS81UnpxdXhmcHJ5QXFFL0U3WTV5RGNmcVIrRm54UVJL?=
 =?utf-8?B?QjNuSzJkZGZVTlZ3UXpFR1hqQ21VRTY3NVo4NmNqSjh1bU5uQlA4ekVjdEJm?=
 =?utf-8?B?UzFEeUNURTlia1A2Z1BMVFVBVk5yTTVmTDl4ZExJdk1CMW14WnZHQ2MrbWdC?=
 =?utf-8?B?SzJUNjU5d2NpYWhGcHpxWUppWmhnRVVSZnhOaSs5bmd6MU9UU2I5cUpBQVdK?=
 =?utf-8?B?OHV5WHN3c1VjTlBCakxwMkFpekRzeHdBRW1DU1F1RjJUdGp1VUVBTUNVT3c1?=
 =?utf-8?B?T25PcmNzaWxTcC81VmhaU2xXYzJ6YjAxd0dwdXJSdVAzblY0RXJ1OTNvWnl5?=
 =?utf-8?B?UmpLRkpoSzJhckdKNnErYlU4cjJzV3U1djZtRzJETkJIZ01QTC9Od3hOV3hr?=
 =?utf-8?B?UVN2MWNsSkRnZ05ZVGtuOVVzcGUrMWtaL1JDd1ZqdWptamMxQnpYM2ozb0ND?=
 =?utf-8?B?SXNRNm9JQUVJdGhsTW42SnFlcml2UW5PTEdJSkJpZ0hZZTlWTUZNVzhNVUcr?=
 =?utf-8?B?bkVjclpKcU1YSnYxWm45SXQrZGFsdWtqeTFrRC9JRjBSSVptWHZwekdPSFlH?=
 =?utf-8?B?YVFRZVNnL00wcTd2MG1qRFlWYzAySWJ3Uzl3YUlFcXF5SkxLM2hQeTFWL1F0?=
 =?utf-8?B?VEJzcjZEbkRRYi9Vd1M2dlAzNDZ1bldYTmxlMTJ4b2ZlNlF6SGNXYlUrY0hO?=
 =?utf-8?B?VU5rNUE5dTFSZ05tOEgzWC80YjRMSnA4elhjeUZ1ckZGTnNINER6TS9HdERU?=
 =?utf-8?B?Z2J1dWVTY1hMYVh1THErTG1TUFlVaUU4T3JUUCs0ajErSmhjbUFxcGhXTTNV?=
 =?utf-8?B?aDJqeGRGajczRllCb2J3RlNmbitEWVNDZUxLK01xVmpSVk5LcG1rb0Z6ZTBj?=
 =?utf-8?B?azdJRTMvb0pvRmpMM1Zrd1d5WldDOUpvNjl4cEZUZ3FaQjhycWE0VnJlYmtR?=
 =?utf-8?B?VVhyRVIwR1ozQ1ZSNlE0ejRtby90V05JQy9EQ0swQVNEdEhOU0YwQVI4cnkw?=
 =?utf-8?B?UXB4cXFBOERjSWI5N0hwdlFXb0xjNFludWdwY3NTYVFzODJxUFpucGJVUktM?=
 =?utf-8?B?MmpacWZGSkNMUnY0ODkvVFpnUDVhUTVib1lOYlBDN0lFRUpqOHl1Y3Z6eE1x?=
 =?utf-8?B?QkpxRlJrOUNFejVIaUQ0ZzE4OGtwTmptc3RMaUwvaWRtZUN4cS9YQ1lFbVhz?=
 =?utf-8?B?ZkkwRnBrRmNQTVNBS1dKYmF0ZVZKeUtRRklXcjJpY2ZFVjRlZXdCTGFJU1hY?=
 =?utf-8?B?d3p2c1Mra1lxM1MzdWk4QVpIOXdzNFp5dkdoOWxMQWVFQjBHQzZ0Yndzd1ZO?=
 =?utf-8?B?ODMzbkVvRW1DaWJHMTZYaEtNaCt6S2MzZmhMN0JnZzVibHdLcGIrWjRPY3Vp?=
 =?utf-8?B?OUpYaCtzaDdpaFdPd1dvUzB3aytjUlByMHVFQ2xZcFlZUFVINTgvRzBuMVR6?=
 =?utf-8?B?b3dFV1B2RUhwaVBvQ3FrRWNmcW0rU2thWDc3aHRoMU4yUEtVQjNMOWlEVGV5?=
 =?utf-8?B?NWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9EF4BD90202F7C4E8FCD34D5EA0511F0@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB9305.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c673732d-aa4b-46db-efbd-08da5b32e342
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2022 07:25:34.5331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lgA7Gw685BUCqLA6Wf/wM85ei+Hn53zwzvJYNZg2gPPtDSipcUqk1fyGW6skMkFsyj5LkyFsjmDuei5tz5QC2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB9811
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCk9uIDAxLzA3LzIwMjIgMTE6NDQsIE1pbmcgTGVpIHdyb3RlOg0KPiBPbiBUaHUsIEp1biAz
MCwgMjAyMiBhdCAwMjozNzozM1BNIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+PiBU
aGVyZSBhcmUgdHdvIC5leGl0X2NtZF9wcml2IGltcGxlbWVudGF0aW9ucy4gQm90aCBpbXBsZW1l
bnRhdGlvbnMgdXNlDQo+PiByZXNvdXJjZXMgYXNzb2NpYXRlZCB3aXRoIHRoZSBTQ1NJIGhvc3Qu
IE1ha2Ugc3VyZSB0aGF0IHRoZXNlIHJlc291cmNlcyBhcmUNCj4gUGxlYXNlIGRvY3VtZW50IHdo
YXQgdGhlIGV4YWN0IHJlc291cmNlcyBhc3NvY2lhdGVkIHdpdGggdGhpcyBTQ1NJIGhvc3QgaXMu
DQo+DQo+IFdlIG5lZWQgdGhlIHJvb3QgY2F1c2UuDQo+DQo+IEkgdW5kZXJzdGFuZCBpdCBtaWdo
dCBiZSByZWxhdGVkIHdpdGggbW9kdWxlIHVubG9hZGluZywgc2luY2UgaWJfc3JwIG1heQ0KPiBi
ZSBnb25lIGFscmVhZHksIGJ1dCBub3Qgc3VyZSBpZiBpdCBpcyB0aGUgZXhhY3Qgb25lIGluIHRo
aXMgcmVwb3J0Lg0KPg0KPj4gc3RpbGwgYXZhaWxhYmxlIHdoZW4gLmV4aXRfY21kX3ByaXYgaXMg
Y2FsbGVkIGJ5IG1vdmluZyB0aGUgLmV4aXRfY21kX3ByaXYNCj4+IGNhbGxzIGZyb20gc2NzaV9o
b3N0X2Rldl9yZWxlYXNlKCkgdG8gc2NzaV9mb3JnZXRfaG9zdCgpLiBNb3ZpbmcNCj4+IGJsa19t
cV9mcmVlX3RhZ19zZXQoKSBmcm9tIHNjc2lfaG9zdF9kZXZfcmVsZWFzZSgpIHRvIHNjc2lfZm9y
Z2V0X2hvc3QoKSBpcw0KPj4gc2FmZSBiZWNhdXNlIHNjc2lfZm9yZ2V0X2hvc3QoKSBkcmFpbnMg
YWxsIHRoZSByZXF1ZXN0IHF1ZXVlcyB0aGF0IHVzZSB0aGUNCj4+IGhvc3QgdGFnIHNldC4gVGhp
cyBndWFyYW50ZWVzIHRoYXQgbm8gcmVxdWVzdHMgYXJlIGluIGZsaWdodCBhbmQgYWxzbyB0aGF0
DQo+PiBubyBuZXcgcmVxdWVzdHMgd2lsbCBiZSBhbGxvY2F0ZWQgZnJvbSB0aGUgaG9zdCB0YWcg
c2V0Lg0KPj4NCj4+IFRoaXMgcGF0Y2ggZml4ZXMgdGhlIGZvbGxvd2luZyB1c2UtYWZ0ZXItZnJl
ZToNCj4+DQo+PiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0NCj4+IEJVRzogS0FTQU46IHVzZS1hZnRlci1mcmVlIGluIHNy
cF9leGl0X2NtZF9wcml2KzB4MjcvMHhkMCBbaWJfc3JwXQ0KPj4gUmVhZCBvZiBzaXplIDggYXQg
YWRkciBmZmZmODg4MTAwMzM3MDAwIGJ5IHRhc2sgbXVsdGlwYXRoZC8xNjcyNw0KPiBXaGF0IGlz
IHRoZSA4Ynl0ZXMgYnVmZmVyIHdoaWNoIHRyaWdnZXJzIFVBRj8gd2hhdCBkb2VzIHNycF9leGl0
X2NtZF9wcml2KzB4MjcNCj4gcG9pbnQgdG8/DQpUaGlzIGJ1ZyB3YXMgcmVwb3J0ZWQgYnkgbWUs
IGxldCdzIGlucHV0IHNvbWUgZGVidWcgaW5mb3JtYXRpb24uDQoqQXR0ZW50aW9uKjogYmVsb3cg
ZGVidWcgaW5mbyBjb21lIGZyb20gYSBtb2RpZmllZCBzb3VyY2UsIHNvIHRoZSBvZmZzZXQgaXQg
aXMgYSBiaXQgZGlmZmVyZW50IGZyb20gYWJvdmUgb25lLg0KDQoNClsgMTIwLjQwMDU3Ml0gaWJf
c3JwOiBsaXpoaWppYW46IHNycF9leGl0X2NtZF9wcml2Ojk3NTogdGFyZ2V0X2hvc3QgZmZmZjg4
ODEwYjhkNjAwMCwgZmZmZjg4ODEwYjhkNjdlMCBbIDEyMC40MDA1NzhdIGliX3NycDogbGl6aGlq
aWFuOiBzcnBfZXhpdF9jbWRfcHJpdjo5Nzc6IHRhcmdldF9ob3N0IGZmZmY4ODgxMGI4ZDYwMDAs
IGZmZmY4ODgxMGI4ZDY3ZTAgWyAxMjAuNDAwNTkwXSA9PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0gWyAxMjAuNDAwNTkyXSBC
VUc6IEtBU0FOOiB1c2UtYWZ0ZXItZnJlZSBpbiBzcnBfZXhpdF9jbWRfcHJpdisweDZjLzB4MTA5
IFtpYl9zcnBdIFsgMTIwLjQwMDYxNl0gUmVhZCBvZiBzaXplIDggYXQgYWRkciBmZmZmODg4MTA3
NmIxODAwIGJ5IHRhc2sgbXVsdGlwYXRoZC8xNDE3IFsgMTIwLjQwMDYxOV0gWyAxMjAuNDAwNjIx
XSBDUFU6IDAgUElEOiAxNDE3IENvbW06IG11bHRpcGF0aGQgTm90IHRhaW50ZWQgNS4xOS4wLXJj
MS1yb2NlLWZsdXNoKyAjODUgWyAxMjAuNDAwNjI2XSBIYXJkd2FyZSBuYW1lOiBRRU1VIFN0YW5k
YXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyByZWwtMS4xNC4wLTI3LWc2NGYzN2Nj
NTMwZjEtcHJlYnVpbHQucWVtdS5vcmcgMDQvMDEvMjAxNA0KY3Jhc2g+IHN0cnVjdCBzcnBfdGFy
Z2V0X3BvcnQuc3JwX2hvc3QgZmZmZjg4ODEwYjhkNjdlMCBzcnBfaG9zdCA9IDB4ZmZmZjg4ODEw
NzZiMTgwMCwgY3Jhc2g+IHN0cnVjdCBzcnBfdGFyZ2V0X3BvcnQuc3JwX2hvc3Qgc3RydWN0IHNy
cF90YXJnZXRfcG9ydCB7IFsxMDRdIHN0cnVjdCBzcnBfaG9zdCAqc3JwX2hvc3Q7IH0gY3Jhc2g+
IHN0cnVjdCBzcnBfaG9zdC5zcnBfZGV2IDB4ZmZmZjg4ODEwNzZiMTgwMCBzcnBfZGV2ID0gMHhm
ZmZmODg4MDBiY2QxNDAwLCBjcmFzaD4gc3RydWN0IHNycF9kZXZpY2UgMHhmZmZmODg4MDBiY2Qx
NDAwIHN0cnVjdCBzcnBfZGV2aWNlIHsgZGV2X2xpc3QgPSB7IG5leHQgPSAweGZmZmY4ODgxMDZm
YWZkMDAsIHByZXYgPSAweGI2ODAwMTA5MDAwMDA3NDkgfSwgZGV2ID0gMHgwLCBwZCA9IDB4MCwg
Z2xvYmFsX3JrZXkgPSAwLCBtcl9wYWdlX21hc2sgPSAzLCBtcl9wYWdlX3NpemUgPSAxODE5NjA3
MDQsIG1yX21heF9zaXplID0gLTMwNTkyLCBtYXhfcGFnZXNfcGVyX21yID0gMTE3MTEyMDY0LCBo
YXNfZnIgPSAxMjksIHVzZV9mYXN0X3JlZyA9IDEzNiB9IGNyYXNoPiBkaXMgLXMgc3JwX2V4aXRf
Y21kX3ByaXYrMHg2Yw0KRklMRTogLi4vZHJpdmVycy9pbmZpbmliYW5kL3VscC9zcnAvaWJfc3Jw
LmMNCkxJTkU6IDk3OA0KDQo5NzMgc3RydWN0IHNycF9yZXF1ZXN0ICpyZXE7DQo5NzQNCjk3NSBw
cl9pbmZvKCJsaXpoaWppYW46ICVzOiVkOiB0YXJnZXRfaG9zdCAlcHgsICVweFxuIiwgX19mdW5j
X18sIF9fTElORV9fLCBzaG9zdCwgc2hvc3QtPmhvc3RkYXRhKTsNCjk3NiB0YXJnZXQgPSBob3N0
X3RvX3RhcmdldChzaG9zdCk7DQo5NzcgcHJfaW5mbygibGl6aGlqaWFuOiAlczolZDogdGFyZ2V0
X2hvc3QgJXB4LCAlcHhcbiIsIF9fZnVuY19fLCBfX0xJTkVfXywgc2hvc3QsIHNob3N0LT5ob3N0
ZGF0YSk7DQoqIDk3OCBkZXYgPSB0YXJnZXQtPnNycF9ob3N0LT5zcnBfZGV2Ow0KOTc5IGliZGV2
ID0gZGV2LT5kZXY7DQo5ODAgcmVxID0gc2NzaV9jbWRfcHJpdihjbWQpOw0KOTgxDQo5ODIga2Zy
ZWUocmVxLT5mcl9saXN0KTsNCjk4MyBpZiAocmVxLT5pbmRpcmVjdF9kbWFfYWRkcikgew0KOTg0
IGliX2RtYV91bm1hcF9zaW5nbGUoaWJkZXYsIHJlcS0+aW5kaXJlY3RfZG1hX2FkZHIsDQo5ODUg
dGFyZ2V0LT5pbmRpcmVjdF9zaXplLA0KOTg2IERNQV9UT19ERVZJQ0UpOw0KDQpUaGFua3MNClpo
aWppYW4NCg0KDQo+DQo+IFRoYW5rcywNCj4gTWluZw0KPg0K
