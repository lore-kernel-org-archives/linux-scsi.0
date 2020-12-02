Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 561B7C64E8A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 07:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB9AA22206
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 07:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgLBHp1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 02:45:27 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41160 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726148AbgLBHp0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 02:45:26 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B27aLsb031979
        for <linux-scsi@vger.kernel.org>; Tue, 1 Dec 2020 23:44:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=yklUy6Z9qfV7zFheY0lWqhavjOun+AcKa/YKGj9SRcc=;
 b=GYs2qfqfEHO6uu/qSAr7PWE4W3KTbkHcMmq0zWqT74HAdqmb1JdzMpAubIGA6eVD6Yzd
 JyDNJUP3CrIAJT6WT2l6R8MZuss253C3NDvZg1wujHhnaXYRcpOdIha0fQrK8Od1+2Tw
 VWllbIVt3RvKWvNR97zsb+r3IFW4F5h4xspT/pcMdnkeKU0YXqXUSYCI+PLWx3UoiktA
 5Ws/NNkRioZen0ec/MKb7QLdbJdk8o3MVFSW+YAyF52uI9032tjg4eS9om7gkGdvLsk0
 M0jcApg3OQQvBRXEHNzNeISwkcUxqoxrDgX4dY+W7A8rAxMlalhsxg2BfqXjGQ2Fn/EU zQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 355w509efw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Dec 2020 23:44:41 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 23:44:39 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 23:44:39 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 1 Dec 2020 23:44:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b08LpPjluK3Nw7+/ZmT8iWao8nd7QzJwRJTQh17ie8U+sgM4XBO/OAWDb0PvVFySpbj2T+xCCGCQlKl+fOrXAVifH/6Nsc6zjVUoroV2rhCbI8YiQkQHeBsY9EgqmbQlmHHG9mbOTgNRh7Fz4FkqF7lt4Z1TTCkuk0hBoSvrkaAMhqs38Q8Q1X8aYxV+JMzuUE89VC1uxj/V4KBwCuz1qO8E5X5H4XgKBYR5r5USY1OE3+JOGI+uT/KwqK0lWwf2NWOLkCThK3cDKsnPdd6B/SnhgLK8O5ozSOp51BTsaEx/yATJbBruN5FpgRicJBnprDPjgA/v0vUfSeJKD7nQFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yklUy6Z9qfV7zFheY0lWqhavjOun+AcKa/YKGj9SRcc=;
 b=GufUhXMQ3fzxonyA90dZrP6DVEfghGRKE50tXj6mYhEhmRw5tMdL2lSGzUfpZawouP4tGBrz8VIXvddswP35/mkKdaAOSjSEiyzP93iYQ0FNaxFAieGjRW0w8WZQSuWxg2SfDCT3HPf0sUOj+VVMpy+kgdDHLl2zMEf6NMV70uu9QWnT2HI8Dd9c6ChrPRo7U+3rI/VwNqEwyGSA193fSFPf0rjVvkOf/zft778rcvc14gjynfoTDtmEcgAyO4Lu/ikOG1H29iNv85dy4pjIe8g5zyDwK72TyzFkATfex8oQIqUavCIKHUqhAXWozyVkkyBGLmHTh1yPwt5upeik3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yklUy6Z9qfV7zFheY0lWqhavjOun+AcKa/YKGj9SRcc=;
 b=i59qdD08SdmWmMwItqa4UVwxhyhpOzbBjS5vy8qLatAtfBKJnwpXLWmAuVXBt1Il7Cb0cy4ZFoMjwRllm2SeOOxEqwKr+aIphbKfshkLLnoYtCmAQ9edyx1rQvfUvF49/C4xR+jIYfILpDoexDRclee+6k6JR8vYZeC4QSacMoY=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM5PR18MB2133.namprd18.prod.outlook.com (2603:10b6:4:b3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Wed, 2 Dec
 2020 07:44:37 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::a087:2131:1284:66e7]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::a087:2131:1284:66e7%7]) with mapi id 15.20.3611.025; Wed, 2 Dec 2020
 07:44:37 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [EXT] Re: [PATCH 02/15] qla2xxx: Change post del message from
 debug level to log level
Thread-Topic: [EXT] Re: [PATCH 02/15] qla2xxx: Change post del message from
 debug level to log level
Thread-Index: AQHWx/lkg4LKfycnQUap8eyy38ZRyqniZrdggAAD2ICAAQM+wA==
Date:   Wed, 2 Dec 2020 07:44:36 +0000
Message-ID: <DM6PR18MB303426FB6D23256D2BC60A66D2F30@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20201201082730.24158-1-njavali@marvell.com>
 <20201201082730.24158-3-njavali@marvell.com>
 <3CCE1C90-64DB-46C7-A49D-9378077CA083@oracle.com>
 <DM6PR18MB303442AE6B84810FE6604CC5D2F40@DM6PR18MB3034.namprd18.prod.outlook.com>
 <A1F83C12-6AA8-417C-AC24-31F6BFC56C43@oracle.com>
In-Reply-To: <A1F83C12-6AA8-417C-AC24-31F6BFC56C43@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [198.186.2.3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b801a0e-4906-41f4-0364-08d896961e57
x-ms-traffictypediagnostic: DM5PR18MB2133:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB213314625B6452215C473632D2F30@DM5PR18MB2133.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qe7KlmSVpwOhAzmQ/0Fb33XhrKq76e+eOrhDp5BQ+rBA20ycgATglO4z5VkCPQag0ZfX2V/cDnCwBHVDJUPG+fdsJVf46O/c1+SH8JU6i2b8auEDjg6vEUB8m5ITVTYu0Atyg3nZJ+Lbgjm0HGSJW1UoFPbiTw3P1gaMtdIhZvk4eXYWBuAIp5oOOO8xzwGf1tpTvrpkCmHwxgTVXcYVa5PSeE3eCxUESTrSfI6I8AMeAgQZw0P3pivF9wuD3cbm1m4RdXaWHP6Ueusaay6LgWcHWL/vDqz+Czwgchw1oBK5qbK86L1bQUX0xuGyQPR3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(366004)(376002)(346002)(71200400001)(33656002)(76116006)(2906002)(54906003)(55016002)(6506007)(53546011)(52536014)(15650500001)(8676002)(66476007)(478600001)(8936002)(66446008)(66556008)(107886003)(64756008)(316002)(66946007)(83380400001)(26005)(186003)(4326008)(7696005)(86362001)(9686003)(6916009)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?K1hYeXlGT09YWGIzbnl3RVo4SWVBb1pQQ0JMWm0zMDNzSmdJby8zaVBlbVgr?=
 =?utf-8?B?L2tMUTdIdEpqVzMvY2pTcTd4akcwYjljQllTa0ZsV3FpeFpPNmtLNFlET2hs?=
 =?utf-8?B?TEt5NWtNOTl4NkJGZjdQeXI5K2YrdXhDYlRLaXdEWGd3T2VXSmRkejlnUVlV?=
 =?utf-8?B?YU9ma0RSbldtZ1FqZGh4am9ITy9qbkxsNGhteUwxdk5pd2hmWGhrdXlpeHdm?=
 =?utf-8?B?TDBaVExkUHo2NkxObkdib2NIbEhkWk9WWUwwRHNYY3V4WjRnR0htb2lVM1E2?=
 =?utf-8?B?WWJWR3FweGVHc05ReEd3NGxacGhxVE1lcWtCc2Y3R2l6V0dHdWxLcitCWDJT?=
 =?utf-8?B?L1QydG9zZFZUQXk1N0dWZ0x4d0JWbCtZUVZXQUJ3R2pDM25QWW9pdWxwTTJa?=
 =?utf-8?B?ZWc2NGE1c0VxNnU4M2cvMXFSaFlXLzdJMnlzdVBUN2J1cHRWY1pOOHlqTzls?=
 =?utf-8?B?T1JZMWl0UEdSQVhrQ0NaUXF6U3RIRXVHRDQ2NGJtWEVuNkt1MC9VcVNpSVNw?=
 =?utf-8?B?d3cvZWZSSXBFcUN1eXYyNHVNSVNFOWkrcW9CRk5meklTWVJ4emhGSnoxMlVV?=
 =?utf-8?B?RFZDbmJWK3RlekZ0eEhmamFtTTlPSENIZGlzWGtjN1B6MmUrdStBRDZiUGVX?=
 =?utf-8?B?UnMvcCtJM21tRlY4UllUOTZzd21FbHFvMmNCdzN1K2dKamY1SjljaDNTcHU2?=
 =?utf-8?B?bmo1S1hnSzRKWWt4K2dBajROWkxkS0VjajNUSXFVbndiQVFHRHlYclJkZ2lT?=
 =?utf-8?B?RllETWtST1EvaHlxWG1ONWg1QnYyeHBEVVRmK0RnYTkxYzBRd2oyeU1pZTU0?=
 =?utf-8?B?N1dIRmlWTFFCSXlDNDdNbHAvdmo1MXkrZ0s1WHJTbTBJL3FYSVRpRU9CMlZD?=
 =?utf-8?B?VEJsNmJWcXc3ck00eTM3aDlmRTFmV2JobDE0cUxvYy8zZ0xKa0NWR3htSU93?=
 =?utf-8?B?YXVkeEx1R3NUZkdJZWhPdkVMZUlZUXR2MllOZjhPcWQwVGV1ZHJpcElIbHB1?=
 =?utf-8?B?UkdFdm9ncmFzbEttejhxSHJmWHpYZ1RldUxrZEgyNGh1VzM1YVg4WFRFTU5Z?=
 =?utf-8?B?RmxTTWEvQUtueFo1dlQrVys5ZzRCR1lxb29mRjJFVFlBcmdZbWR6VkRDL1Yx?=
 =?utf-8?B?VTFCNXRWMmJIVktlSEIxbnV5RGd4T1JvcDhsKzJ0WHlmTUdESm9iUEpWc2Vs?=
 =?utf-8?B?Mm5qMXhaeUpmNVFnRk9rTmU3YkRZbFF1a3B6TUllVVZETVY4TW9JVkk3K3pT?=
 =?utf-8?B?SEVxaWY5a0J4dXRMcEdDK29PQ0hlT3ltUVdoRE41Yzd4ZTVFb3BnOVVQY25C?=
 =?utf-8?Q?OvltMNKb0zH4Q=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b801a0e-4906-41f4-0364-08d896961e57
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2020 07:44:37.0605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KB5gnVT+EKgSitP92KC0Uf68tKnVjwpEhpC1dNYxbSuC6R0fXQTozzIgSfJenogsywqGFltomzm/jJsnM4t0uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2133
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_01:2020-11-30,2020-12-02 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgSGltYW5zaHUsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSGlt
YW5zaHUgTWFkaGFuaSA8aGltYW5zaHUubWFkaGFuaUBvcmFjbGUuY29tPg0KPiBTZW50OiBUdWVz
ZGF5LCBEZWNlbWJlciAxLCAyMDIwIDk6NDYgUE0NCj4gVG86IFNhdXJhdiBLYXNoeWFwIDxza2Fz
aHlhcEBtYXJ2ZWxsLmNvbT4NCj4gQ2M6IE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlAbWFydmVsbC5j
b20+OyBNYXJ0aW4gSyAuIFBldGVyc2VuDQo+IDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT47
IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyBHUi1RTG9naWMtDQo+IFN0b3JhZ2UtVXBzdHJl
YW0gPEdSLVFMb2dpYy1TdG9yYWdlLVVwc3RyZWFtQG1hcnZlbGwuY29tPg0KPiBTdWJqZWN0OiBb
RVhUXSBSZTogW1BBVENIIDAyLzE1XSBxbGEyeHh4OiBDaGFuZ2UgcG9zdCBkZWwgbWVzc2FnZSBm
cm9tDQo+IGRlYnVnIGxldmVsIHRvIGxvZyBsZXZlbA0KPiANCj4gRXh0ZXJuYWwgRW1haWwNCj4g
DQo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0NCj4gDQo+IA0KPiA+IE9uIERlYyAxLCAyMDIwLCBhdCAxMDowNSBB
TSwgU2F1cmF2IEthc2h5YXAgPHNrYXNoeWFwQG1hcnZlbGwuY29tPg0KPiB3cm90ZToNCj4gPg0K
PiA+IEhpIEhpbWFzbmh1LA0KPiA+IENvbW1lbnRzIGlubGluZQ0KPiA+DQo+ID4+IC0tLS0tT3Jp
Z2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IEhpbWFuc2h1IE1hZGhhbmkgPGhpbWFuc2h1
Lm1hZGhhbmlAb3JhY2xlLmNvbT4NCj4gPj4gU2VudDogVHVlc2RheSwgRGVjZW1iZXIgMSwgMjAy
MCA5OjE1IFBNDQo+ID4+IFRvOiBOaWxlc2ggSmF2YWxpIDxuamF2YWxpQG1hcnZlbGwuY29tPg0K
PiA+PiBDYzogTWFydGluIEsgLiBQZXRlcnNlbiA8bWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20+
OyBsaW51eC0NCj4gPj4gc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IEdSLVFMb2dpYy1TdG9yYWdlLVVw
c3RyZWFtIDxHUi1RTG9naWMtU3RvcmFnZS0NCj4gPj4gVXBzdHJlYW1AbWFydmVsbC5jb20+DQo+
ID4+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMDIvMTVdIHFsYTJ4eHg6IENoYW5nZSBwb3N0IGRlbCBt
ZXNzYWdlIGZyb20gZGVidWcNCj4gbGV2ZWwNCj4gPj4gdG8gbG9nIGxldmVsDQo+ID4+DQo+ID4+
DQo+ID4+DQo+ID4+PiBPbiBEZWMgMSwgMjAyMCwgYXQgMjoyNyBBTSwgTmlsZXNoIEphdmFsaSA8
bmphdmFsaUBtYXJ2ZWxsLmNvbT4gd3JvdGU6DQo+ID4+Pg0KPiA+Pj4gRnJvbTogU2F1cmF2IEth
c2h5YXAgPHNrYXNoeWFwQG1hcnZlbGwuY29tPg0KPiA+Pj4NCj4gPj4+IENoYW5nZSB0aGUgbWVz
c2FnZSBkZWJ1ZyBsZXZlbC4NCj4gPj4+DQo+ID4+PiBTaWduZWQtb2ZmLWJ5OiBTYXVyYXYgS2Fz
aHlhcCA8c2thc2h5YXBAbWFydmVsbC5jb20+DQo+ID4+PiBTaWduZWQtb2ZmLWJ5OiBOaWxlc2gg
SmF2YWxpIDxuamF2YWxpQG1hcnZlbGwuY29tPg0KPiA+Pj4gLS0tDQo+ID4+PiBkcml2ZXJzL3Nj
c2kvcWxhMnh4eC9xbGFfZ3MuYyB8IDggKysrKy0tLS0NCj4gPj4+IDEgZmlsZSBjaGFuZ2VkLCA0
IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+ID4+Pg0KPiA+Pj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9ncy5jIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxh
X2dzLmMNCj4gPj4+IGluZGV4IGUyOGM0YjdlYzU1Zi4uMzkxYWM3NWUzZGUzIDEwMDY0NA0KPiA+
Pj4gLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2dzLmMNCj4gPj4+ICsrKyBiL2RyaXZl
cnMvc2NzaS9xbGEyeHh4L3FsYV9ncy5jDQo+ID4+PiBAQCAtMzU1OCwxMCArMzU1OCwxMCBAQCB2
b2lkDQo+IHFsYTI0eHhfYXN5bmNfZ25uZnRfZG9uZShzY3NpX3FsYV9ob3N0X3QNCj4gPj4gKnZo
YSwgc3JiX3QgKnNwKQ0KPiA+Pj4gCQkJCQlpZiAoZmNwb3J0LT5mbGFncyAmIEZDRl9GQ1AyX0RF
VklDRSkNCj4gPj4+IAkJCQkJCWZjcG9ydC0+bG9nb3V0X29uX2RlbGV0ZSA9IDA7DQo+ID4+Pg0K
PiA+Pj4gLQkJCQkJcWxfZGJnKHFsX2RiZ19kaXNjLCB2aGEsIDB4MjBmMCwNCj4gPj4+IC0JCQkJ
CSAgICAiJXMgJWQgJThwaEMgcG9zdCBkZWwgc2Vzc1xuIiwNCj4gPj4+IC0JCQkJCSAgICBfX2Z1
bmNfXywgX19MSU5FX18sDQo+ID4+PiAtCQkJCQkgICAgZmNwb3J0LT5wb3J0X25hbWUpOw0KPiA+
Pj4gKwkJCQkJcWxfbG9nKHFsX2xvZ193YXJuLCB2aGEsIDB4MjBmMCwNCj4gPj4+ICsJCQkJCSAg
ICAgICAiJXMgJWQgJThwaEMgcG9zdCBkZWwgc2Vzc1xuIiwNCj4gPj4+ICsJCQkJCSAgICAgICBf
X2Z1bmNfXywgX19MSU5FX18sDQo+ID4+PiArCQkJCQkgICAgICAgZmNwb3J0LT5wb3J0X25hbWUp
Ow0KPiA+Pj4NCj4gPj4+DQo+ID4+IAlxbHRfc2NoZWR1bGVfc2Vzc19mb3JfZGVsZXRpb24oZmNw
b3J0KTsNCj4gPj4+IAkJCQkJY29udGludWU7DQo+ID4+PiAtLQ0KPiA+Pj4gMi4xOS4wLnJjMA0K
PiA+Pj4NCj4gPj4NCj4gPj4gSSBhbSBva2F5IHdpdGggdGhlIGNoYW5nZSBqdXN0IGN1cmlvdXMs
IFdvdWxkIGl0IG5vdCBmbG9vZCBtZXNzYWdlIGZpbGUgZm9yDQo+ID4+IGxhcmdlIG51bWJlciBv
ZiBzZXNzaW9ucz8NCj4gPg0KPiA+IFRoaXMgd2FzIGFkZGVkIG1haW5seSBmb3IgaGVscCBpbiBk
ZWJ1Z2dpbmcsIGlmIGRlYnVnIGlzIG5vdCBlbmFibGVkLg0KPiBTb21ldGltZXMgd2UgZ2V0IGxv
Z3MNCj4gPiB3aGVyZSBpdCdzIGhhcmQgdG8gdGVsbCB3aGF0IGhhcHBlbmVkIHRvIHBhcnRpY3Vs
YXIgc2Vzc2lvbi4gTW9yZW92ZXIgc2Vzc2lvbg0KPiBkZWxldGlvbiBpcyBub3QNCj4gPiB2ZXJ5
IGNvbW1vbiBzY2VuYXJpby4NCj4gPg0KPiANCj4gSW4gdGhhdCBjYXNlLCBJIHdvdWxkIGFsc28g
cHJlZmVyIHRvIHNlZSBtZXNzYWdlIGNvbWluZyBvdXQgZnJvbQ0KPiBxbHRfc2NoZWR1bGVfc2Vz
c19mb3JfZGVsZXRpb24oKSwgYmVjYXVzZSB0aGF04oCZcyB3aGVyZSB5b3UgY2FuIHRyYWNrIHRo
YXQNCj4gc2Vzc2lvbiBpcyBzY2hlZHVsZWQgZm9yIGRlbGV0aW9uLg0KPiANCj4gSSB3b3VsZCBw
cmVmZXIgdGhpcyBtZXNzYWdlIGFsc28gY2hhbmdlZCB0byBxbF9sb2dfd2Fybi4NCj4gDQo+ICAg
ICAgICAgcWxfZGJnKHFsX2RiZ19kaXNjLCBzZXNzLT52aGEsIDB4ZTAwMSwNCj4gICAgICAgICAg
ICAgIlNjaGVkdWxpbmcgc2VzcyAlcCBmb3IgZGVsZXRpb24gJThwaENcbiIsDQo+ICAgICAgICAg
ICAgIHNlc3MsIHNlc3MtPnBvcnRfbmFtZSk7DQoNCk1ha2Ugc2Vuc2UsIHdpbGwgdXBkYXRlIGl0
IGluIG5leHQgdmVyc2lvbi4NCg0KVGhhbmtzLA0KflNhdXJhdg0KPiANCj4gPiBUaGFua3MsDQo+
ID4gflNhdXJhdg0KPiA+Pg0KPiA+PiAtLQ0KPiA+PiBIaW1hbnNodSBNYWRoYW5pCSBPcmFjbGUg
TGludXggRW5naW5lZXJpbmcNCj4gPg0KPiANCj4gLS0NCj4gSGltYW5zaHUgTWFkaGFuaQkgT3Jh
Y2xlIExpbnV4IEVuZ2luZWVyaW5nDQoNCg==
