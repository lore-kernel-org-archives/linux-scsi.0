Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C325FC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 18:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1BD521D81
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 18:39:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="dBGZkDTd";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="JL0TTEX3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgF2Sj3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 14:39:29 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:42831 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbgF2Sj0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 14:39:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593455965; x=1624991965;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Fi4Qc1kyO4KhHCUDXadR5jElj0yT2HGsYPuWQV4SzOI=;
  b=dBGZkDTdkG3wO/bpr5ISIe4fuVTMRQW8bQhG7x0t1dwf3XYHKc2in0SC
   r9qBKujscBhQcD+eRyszQ2IqgYk0ZGkrPNlXV/02S4ROR1avMC4yu1n8I
   S6ROpE5g4AOYp80g+QUmPF3u9Wx9qxdUIrMtsMrnk2TcSPEBIjLJg1uly
   xO95znQmYFWTvJ38mHcWMfUW8TNtyO8N7H6r1Nlrub21UFbKH/lW+4o8V
   7GdxYiApWwwyU3O367I/aBOrfK/jVdeFXzyM8yTgD3F4eU7LZE8wSJdqO
   2z9eZx4Z4JE/9oigCFTMD/GZr0pybUTVKFUqN7ue1MxrFYMOAZ9uA1S5Y
   Q==;
IronPort-SDR: 1eQiwi1efRDukQ0HrELHc4bvpKQ9oz7YvehHVk/oyaLL8/p4Mp/6mHww9+Snms8LotAJ0mGnlc
 Wx3MdCkCXpq956ChezJV3rAgxFqJb5EcKIqRSDBnPuu5rnXooddE2ldh0rvzQWrzKz/TnV/qdf
 vVEoW7LDmVyKzSENR/P4LJDLd9CGZAJAbXV9mGAcyfb0dVyzZjEg7fUgaEWb+SFdDQ2O07wqzl
 GfisGIPYfcOciTVL8RNCS2G1+oO2mEY271BBZkDz8rTDWSOwWivnyxZgQDy6bwohQozy92qbaL
 Luo=
X-IronPort-AV: E=Sophos;i="5.75,294,1589212800"; 
   d="scan'208";a="142510458"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jun 2020 13:17:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KhmktBnDvODW930R0sFMlbeU9QVcma3YmadFp8LjOOEoNIGB5B+6gn/q7ZbHBdoT7IUcqL0F/hdW/kjwvC2QqPH5gPpqwJcbJni/t8SLFU1Q4YJ5rSmqyIWqJU0nT9ZhDmx1rmyZk8tGRqeDxUElG+fE6kmwwqKoerKYUEGkWUCvkoVvD2QTuAu5YC+THg1ctNLDwq4faZvJn/zLH0/PPCkD3fX7ZyhGyoE0BnfR0G9rUMheh2UU//utt7HAt5j1zelUgBvO5T3aIblDtoQyD9WpOinBMbbhnnUhiOp8px4/RTHyKWvmf3fSHfacMO3zMA6hDau69HZfNqX44uk+AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fi4Qc1kyO4KhHCUDXadR5jElj0yT2HGsYPuWQV4SzOI=;
 b=esRfo5RcM+4B4iwImcSTinrrJ9y3c97wgkMGFNStyU2uHp2sBRp1zgYJVM6j1Bt1QdpBs1/5LZkAYKQpPTStKspa10D+SIBlEJgHZbObYJgCs2RFg+ek89adUqk5kGGIbtTBGvwC00gefFCOwfao8jz6EJQW+fRkcmxzSOtXwaSLHZMMqJe1GFdBPTjJqjLsb7p9xtbIKIXxksX+tWCdkdv6MbOTxw6DExlgp6dwzNMLL9ix7kyA+XccP8tvxlvXS7GEd6nMcwvJFySt0zWlepZxw5+CA5jnrAVV+81NSVePmgVmFlESRtFZS3Hs13fA0YbH7PO24MmB239IE81QgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fi4Qc1kyO4KhHCUDXadR5jElj0yT2HGsYPuWQV4SzOI=;
 b=JL0TTEX3yW7B8r5lFuoCV6w1bYBGHM/Z0a7Ph0IxLjY5+C5I+Koso5CafUx/Of4spQVx+58J5VR0YVr6yBh5VgpvkiCEgr3VGLGssBPslzqeH8Al934Xtwg5lxjaTF/jUS784r8a6lelv05cLbToYTZ2BbLohW6ydwRSUNytf1o=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4192.namprd04.prod.outlook.com (2603:10b6:805:3a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Mon, 29 Jun
 2020 05:17:02 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 05:17:02 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [RFC PATCH v3 0/5] scsi: ufs: Add Host Performance Booster
 Support
Thread-Topic: [RFC PATCH v3 0/5] scsi: ufs: Add Host Performance Booster
 Support
Thread-Index: AQHWSQaiS38tkGk5ikmxTYEvPlxKOqjvFlDg
Date:   Mon, 29 Jun 2020 05:17:02 +0000
Message-ID: <SN6PR04MB4640D6DD37E365DF02CC9D14FC6E0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200623010201epcms2p11aebdf1fbc719b409968cba997507114@epcms2p1>
 <963815509.21592879582091.JavaMail.epsvc@epcpadp2>
In-Reply-To: <963815509.21592879582091.JavaMail.epsvc@epcpadp2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2a00:a040:188:8f6c:213f:a600:6b7:4650]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e0af448a-05dd-43f2-d357-08d81beba7fc
x-ms-traffictypediagnostic: SN6PR04MB4192:
x-microsoft-antispam-prvs: <SN6PR04MB4192FA4E9429652B8AA4D9A6FC6E0@SN6PR04MB4192.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:309;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 62sUJVWZAYOTRUaH+J2V7994LXj5xwaR7RtJWKQF1098r4+JRcrSvwVIHx5MCsO6Bl5UYe7hJQF/TQVNQ8a79viGHJF8hFd5zyNzOJ5vsv9VaAFBk8HJlKSWRLQH0kx/AdX4+lYOWTjK8xAo+fgKfgnqnqJRhRd028SVMSgNv5F1wW0fmM4jpqe03dWwUl/meLTOu+dVIJJIrPkTZtuIaCIevIp9lJtje//w/A+ttKXBBLku++ZAFksnRke7DhUkXkwFY6jKJ7b/T3WfaZc8gZLDCVfItXRYKfitA4AeaBbRvsAP41k2T/JYDtF1irgaQvTDDvOP5oJb/tZ5e0iUe0Vf8dVyE+jltYcBYgT3jG9yER5M06aHg2ikC1TYLh49r24TgvQj5+kJex/piAkrddmEjrSZvUlULR29za6yoKlq2zJy9MLKysS5JpXz+DyN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(346002)(396003)(366004)(376002)(64756008)(316002)(186003)(71200400001)(9686003)(83380400001)(53546011)(6506007)(7416002)(5660300002)(86362001)(33656002)(55016002)(966005)(8676002)(4326008)(8936002)(52536014)(66946007)(66476007)(66556008)(66446008)(478600001)(7696005)(110136005)(54906003)(76116006)(2906002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: pq6ohv7PUcbLi9GbXLb0owpG5d1upR0FA1Mo0UwSm5ILg4E0tYyVPPKXyfgzW1DJqIwi0SVIZFt2qoDQhEn09iPaiICqw0DVFcW/HqHLZqpr3lSv5VA2XjodGXgZnufWCmGP03iplkuM79mHSj+CneChP7twqHj3rLpbMw7ElyxDiUs66xQDN3tstM2ghAK2d41yyNNgaKkq+iHYAtaOR2aPgowlQ8mTg7kVshgl8V3qa9AyuCMLELWCfuJi1LMqUZQCF2hgVANizmBQh4WoLwMJl+AG0Q1IStwUbasxd8wSFB1eONQdt/ZRFnuv2SAuwlIyHVhPGgXBZQ/zOQdpPQKrj9LDEMzVlONGF4Wq9xZ4MS//fBmrIh5+gbb4ZmCXZqK3r8qkNjXX4jAEYNI+HQx3zboRAOuTtEluH69K2X3e6fJFK6xfYGgUTAGm8TdUre21ZW+5dGB0s8zPcTqmdStzRNuqwIgj4hlXaSICj0iFS18MuClnEpkneqHa/Fsyh5mPIsnQNZV5IDiiacmJWG/mu7dMYYGYOJCPFh6YeXizHpz88fdMApMoImypG7YQ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0af448a-05dd-43f2-d357-08d81beba7fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 05:17:02.0695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8qq/jJtIIwYxZYrhKvYaexAy5BeZtnQl9+nGnEaL6pjCESqD9QTNg/eR8JvhuzIT6h//bOrr5gCmD/UObw5JTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4192
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SWYgbm8tb25lIGVsc2Ugb2JqZWN0cywgbWF5YmUgeW91IGNhbiBzdWJtaXQgeW91ciBwYXRjaGVz
IGFzIG5vbi1SRkMgZm9yIHJldmlldz8NCg0KVGhhbmtzLA0KQXZyaQ0KDQo+IC0tLS0tT3JpZ2lu
YWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IERhZWp1biBQYXJrIDxkYWVqdW43LnBhcmtAc2Ftc3Vu
Zy5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIEp1bmUgMjMsIDIwMjAgNDowMiBBTQ0KPiBUbzogQXZy
aSBBbHRtYW4gPEF2cmkuQWx0bWFuQHdkYy5jb20+OyBqZWpiQGxpbnV4LmlibS5jb207DQo+IG1h
cnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tOyBhc3V0b3NoZEBjb2RlYXVyb3JhLm9yZzsNCj4gc3Rh
bmxleS5jaHVAbWVkaWF0ZWsuY29tOyBjYW5nQGNvZGVhdXJvcmEub3JnOyBodW9iZWFuQGdtYWls
LmNvbTsNCj4gYnZhbmFzc2NoZUBhY20ub3JnOyB0b21hcy53aW5rbGVyQGludGVsLmNvbTsgQUxJ
TSBBS0hUQVINCj4gPGFsaW0uYWtodGFyQHNhbXN1bmcuY29tPjsgRGFlanVuIFBhcmsgPGRhZWp1
bjcucGFya0BzYW1zdW5nLmNvbT4NCj4gQ2M6IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyBs
aW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBTYW5nLXlvb24gT2gNCj4gPHNhbmd5b29uLm9o
QHNhbXN1bmcuY29tPjsgU3VuZy1KdW4gUGFyaw0KPiA8c3VuZ2p1bjA3LnBhcmtAc2Ftc3VuZy5j
b20+OyB5b25nbXl1bmcgbGVlDQo+IDx5bWh1bmdyeS5sZWVAc2Ftc3VuZy5jb20+OyBKaW55b3Vu
ZyBDSE9JIDxqLQ0KPiB5b3VuZy5jaG9pQHNhbXN1bmcuY29tPjsgQWRlbCBDaG9pIDxhZGVsLmNo
b2lAc2Ftc3VuZy5jb20+OyBCb1JhbQ0KPiBTaGluIDxib3JhbS5zaGluQHNhbXN1bmcuY29tPg0K
PiBTdWJqZWN0OiBbUkZDIFBBVENIIHYzIDAvNV0gc2NzaTogdWZzOiBBZGQgSG9zdCBQZXJmb3Jt
YW5jZSBCb29zdGVyIFN1cHBvcnQNCj4gDQo+IENBVVRJT046IFRoaXMgZW1haWwgb3JpZ2luYXRl
ZCBmcm9tIG91dHNpZGUgb2YgV2VzdGVybiBEaWdpdGFsLiBEbyBub3QgY2xpY2sNCj4gb24gbGlu
a3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IHJlY29nbml6ZSB0aGUgc2VuZGVyIGFu
ZCBrbm93IHRoYXQNCj4gdGhlIGNvbnRlbnQgaXMgc2FmZS4NCj4gDQo+IA0KPiBDaGFuZ2Vsb2c6
DQo+IA0KPiB2MiAtPiB2Mw0KPiAxLiBBZGQgY2hlY2tpbmcgaW5wdXQgbW9kdWxlIHBhcmFtZXRl
ciB2YWx1ZS4NCj4gMi4gQ2hhbmdlIGJhc2UgY29tbWl0IGZyb20gNS44L3Njc2ktcXVldWUgdG8g
NS45L3Njc2ktcXVldWUuDQo+IDMuIENsZWFudXAgZm9yIHVudXNlZCB2YXJpYWJsZXMgYW5kIGxh
YmVsLg0KPiANCj4gdjEgLT4gdjINCj4gMS4gQ2hhbmdlIHRoZSBmdWxsIGJvaWxlcnBsYXRlIHRl
eHQgdG8gU1BEWCBzdHlsZS4NCj4gMi4gQWRvcHQgZHluYW1pYyBhbGxvY2F0aW9uIGZvciBzdWIt
cmVnaW9uIGRhdGEgc3RydWN0dXJlLg0KPiAzLiBDbGVhbnVwLg0KPiANCj4gTkFORCBmbGFzaCBt
ZW1vcnktYmFzZWQgc3RvcmFnZSBkZXZpY2VzIHVzZSBGbGFzaCBUcmFuc2xhdGlvbiBMYXllciAo
RlRMKQ0KPiB0byB0cmFuc2xhdGUgbG9naWNhbCBhZGRyZXNzZXMgb2YgSS9PIHJlcXVlc3RzIHRv
IGNvcnJlc3BvbmRpbmcgZmxhc2gNCj4gbWVtb3J5IGFkZHJlc3Nlcy4gTW9iaWxlIHN0b3JhZ2Ug
ZGV2aWNlcyB0eXBpY2FsbHkgaGF2ZSBSQU0gd2l0aA0KPiBjb25zdHJhaW5lZCBzaXplLCB0aHVz
IGxhY2sgaW4gbWVtb3J5IHRvIGtlZXAgdGhlIHdob2xlIG1hcHBpbmcgdGFibGUuDQo+IFRoZXJl
Zm9yZSwgbWFwcGluZyB0YWJsZXMgYXJlIHBhcnRpYWxseSByZXRyaWV2ZWQgZnJvbSBOQU5EIGZs
YXNoIG9uDQo+IGRlbWFuZCwgY2F1c2luZyByYW5kb20tcmVhZCBwZXJmb3JtYW5jZSBkZWdyYWRh
dGlvbi4NCj4gDQo+IFRvIGltcHJvdmUgcmFuZG9tIHJlYWQgcGVyZm9ybWFuY2UsIEpFU0QyMjAt
MyAoSFBCIHYxLjApIHByb3Bvc2VzIEhQQg0KPiAoSG9zdCBQZXJmb3JtYW5jZSBCb29zdGVyKSB3
aGljaCB1c2VzIGhvc3Qgc3lzdGVtIG1lbW9yeSBhcyBhIGNhY2hlIGZvcg0KPiB0aGUNCj4gRlRM
IG1hcHBpbmcgdGFibGUuIEJ5IHVzaW5nIEhQQiwgRlRMIGRhdGEgY2FuIGJlIHJlYWQgZnJvbSBo
b3N0IG1lbW9yeQ0KPiBmYXN0ZXIgdGhhbiBmcm9tIE5BTkQgZmxhc2ggbWVtb3J5Lg0KPiANCj4g
VGhlIGN1cnJlbnQgdmVyc2lvbiBvbmx5IHN1cHBvcnRzIHRoZSBEQ00gKGRldmljZSBjb250cm9s
IG1vZGUpLg0KPiBUaGlzIHBhdGNoIGNvbnNpc3RzIG9mIDQgcGFydHMgdG8gc3VwcG9ydCBIUEIg
ZmVhdHVyZS4NCj4gDQo+IDEpIFVGUy1mZWF0dXJlIGxheWVyDQo+IDIpIEhQQiBwcm9iZSBhbmQg
aW5pdGlhbGl6YXRpb24gcHJvY2Vzcw0KPiAzKSBSRUFEIC0+IEhQQiBSRUFEIHVzaW5nIGNhY2hl
ZCBtYXAgaW5mb3JtYXRpb24NCj4gNCkgTDJQIChsb2dpY2FsIHRvIHBoeXNpY2FsKSBtYXAgbWFu
YWdlbWVudA0KPiANCj4gVGhlIFVGUy1mZWF0dXJlIGlzIGFuIGFkZGl0aW9uYWwgbGF5ZXIgdG8g
YXZvaWQgdGhlIHN0cnVjdHVyZSBpbiB3aGljaCB0aGUNCj4gVUZTLWNvcmUgZHJpdmVyIGFuZCB0
aGUgVUZTLWZlYXR1cmUgYXJlIGVudGFuZ2xlZCB3aXRoIGVhY2ggb3RoZXIgaW4gYQ0KPiBzaW5n
bGUgbW9kdWxlLg0KPiBCeSBhZGRpbmcgdGhlIGxheWVyLCBVRlMtZmVhdHVyZXMgY29tcG9zZWQg
b2YgdmFyaW91cyBjb21iaW5hdGlvbnMgY2FuIGJlDQo+IHN1cHBvcnRlZC4gQWxzbywgZXZlbiBp
ZiBhIG5ldyBmZWF0dXJlIGlzIGFkZGVkLCBtb2RpZmljYXRpb24gb2YgdGhlDQo+IFVGUy1jb3Jl
IGRyaXZlciBjYW4gYmUgbWluaW1pemVkLg0KPiANCj4gSW4gdGhlIEhQQiBwcm9iZSBhbmQgaW5p
dCBwcm9jZXNzLCB0aGUgZGV2aWNlIGluZm9ybWF0aW9uIG9mIHRoZSBVRlMgaXMNCj4gcXVlcmll
ZC4gQWZ0ZXIgY2hlY2tpbmcgc3VwcG9ydGVkIGZlYXR1cmVzLCB0aGUgZGF0YSBzdHJ1Y3R1cmUg
Zm9yIHRoZSBIUEINCj4gaXMgaW5pdGlhbGl6ZWQgYWNjb3JkaW5nIHRvIHRoZSBkZXZpY2UgaW5m
b3JtYXRpb24uDQo+IA0KPiBBIHJlYWQgSS9PIGluIHRoZSBhY3RpdmUgc3ViLXJlZ2lvbiB3aGVy
ZSB0aGUgbWFwIGlzIGNhY2hlZCBpcyBjaGFuZ2VkIHRvDQo+IEhQQiBSRUFEIGJ5IHRoZSBIUEIg
bW9kdWxlLg0KPiANCj4gVGhlIEhQQiBtb2R1bGUgbWFuYWdlcyB0aGUgTDJQIG1hcCB1c2luZyBp
bmZvcm1hdGlvbiByZWNlaXZlZCBmcm9tIHRoZQ0KPiBkZXZpY2UuIEZvciBhY3RpdmUgc3ViLXJl
Z2lvbiwgdGhlIEhQQiBtb2R1bGUgY2FjaGVzIHRocm91Z2ggdWZzaHBiX21hcA0KPiByZXF1ZXN0
LiBGb3IgdGhlIGluLWFjdGl2ZSByZWdpb24sIHRoZSBIUEIgbW9kdWxlIGRpc2NhcmRzIHRoZSBM
MlAgbWFwLg0KPiBXaGVuIGEgd3JpdGUgSS9PIG9jY3VycyBpbiBhbiBhY3RpdmUgc3ViLXJlZ2lv
biBhcmVhLCBhc3NvY2lhdGVkIGRpcnR5DQo+IGJpdG1hcCBjaGVja2VkIGFzIGRpcnR5IGZvciBw
cmV2ZW50aW5nIHN0YWxlIHJlYWQuDQo+IA0KPiBIUEIgaXMgc2hvd24gdG8gaGF2ZSBhIHBlcmZv
cm1hbmNlIGltcHJvdmVtZW50IG9mIDU4IC0gNjclIGZvciByYW5kb20NCj4gcmVhZA0KPiB3b3Jr
bG9hZC4gWzFdDQo+IA0KPiBUaGlzIHNlcmllcyBwYXRjaGVzIGFyZSBiYXNlZCBvbiB0aGUgNS45
L3Njc2ktcXVldWUgYnJhbmNoLg0KPiANCj4gWzFdOg0KPiBodHRwczovL3d3dy51c2VuaXgub3Jn
L2NvbmZlcmVuY2UvaG90c3RvcmFnZTE3L3Byb2dyYW0vcHJlc2VudGF0aW9uL2plbw0KPiBuZw0K
PiANCj4gRGFlanVuIHBhcmsgKDUpOg0KPiAgc2NzaTogdWZzOiBBZGQgVUZTIGZlYXR1cmUgcmVs
YXRlZCBwYXJhbWV0ZXINCj4gIHNjc2k6IHVmczogQWRkIFVGUyBmZWF0dXJlIGxheWVyDQo+ICBz
Y3NpOiB1ZnM6IEludHJvZHVjZSBIUEIgbW9kdWxlDQo+ICBzY3NpOiB1ZnM6IEwyUCBtYXAgbWFu
YWdlbWVudCBmb3IgSFBCIHJlYWQNCj4gIHNjc2k6IHVmczogUHJlcGFyZSBIUEIgcmVhZCBmb3Ig
Y2FjaGVkIHN1Yi1yZWdpb24NCj4gDQo+ICBkcml2ZXJzL3Njc2kvdWZzL0tjb25maWcgICAgICB8
ICAgIDkgKw0KPiAgZHJpdmVycy9zY3NpL3Vmcy9NYWtlZmlsZSAgICAgfCAgICAzICstDQo+ICBk
cml2ZXJzL3Njc2kvdWZzL3Vmcy5oICAgICAgICB8ICAgMTIgKw0KPiAgZHJpdmVycy9zY3NpL3Vm
cy91ZnNmZWF0dXJlLmMgfCAgMTQ4ICsrKw0KPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnNmZWF0dXJl
LmggfCAgIDY5ICsrDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jICAgICB8ICAgMjMgKy0N
Cj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggICAgIHwgICAgMyArDQo+ICBkcml2ZXJzL3Nj
c2kvdWZzL3Vmc2hwYi5jICAgICB8IDE5OTYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hwYi5oICAgICB8ICAyMzQgKysrKysNCj4g
IDkgZmlsZXMgY2hhbmdlZCwgMjQ5NCBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiAg
Y3JlYXRlZCBtb2RlIDEwMDY0NCBkcml2ZXJzL3Njc2kvdWZzL3Vmc2ZlYXR1cmUuYw0KPiAgY3Jl
YXRlZCBtb2RlIDEwMDY0NCBkcml2ZXJzL3Njc2kvdWZzL3Vmc2ZlYXR1cmUuaA0KPiAgY3JlYXRl
ZCBtb2RlIDEwMDY0NCBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hwYi5jDQo+ICBjcmVhdGVkIG1vZGUg
MTAwNjQ0IGRyaXZlcnMvc2NzaS91ZnMvdWZzaHBiLmgNCg==
