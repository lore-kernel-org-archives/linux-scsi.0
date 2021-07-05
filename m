Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5A6C07E99
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 19:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B76C61978
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 19:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhGETEL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 15:04:11 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:30769 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbhGETEK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 15:04:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1625511694; x=1657047694;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=c1FF9ULuwgU9odj1cItj1UOIbZenA4vFKeGC4IznjLY=;
  b=Uf3qPLy+XoQFsxQZJaDCp6pIZienJTJQCL7WwidahKlKOeGuFo5MC/JE
   lKHKzqcNKieibbeG/IADQQ1+Mgs946C0xQip4yw3OAwx1JBSjMTWfmpG8
   VdwsaSV1Q6OoAS/Kfb5W0pSk6Z/jPRS4HElWj/5y1g+DemBHc0YFxPwMx
   3Uf25qchL156HLd2+ivLn9TwcDOU+DIkxk2U4l8IBi3YQZ2b8R++Neydp
   jnJVPN9WNH8a+VQy1l4HmgcA7aS/K/v8zrcemJBLNU/UQWlrlupBq/Y6h
   yN5BP82afiEao75fcXmudxq9VaNBxR6qOGnP9hM609Bvci7xmbkN/fMRo
   g==;
IronPort-SDR: fesgevoY/x1vsPYyr+I2E0IRucs2PcGluFoeoQQRTE+XlApT2i8OcOBTBS50C18VMgmRWl7R3t
 1CTDDCpqxf4cG/Zk3IYcDADnZ19+RO/zcJ05OHu1Z5AmQZsx5zzfGOX0PCXioQ8HKOKBdeqeSp
 uSrf5mEv1hRcryqhz99Y3GD/vQ7SANU5K3+zc8kNFVilkqY2bPQ14DQmnwA7PeGTS/Myi0xWMH
 T8dGbaAFulIEYG/B/w9TUdDa3DzcyP5wDZuX0wDx1Wgj8hrUFcF4SPXK1P+KBDqLH3GRyhKO6q
 m7c=
X-IronPort-AV: E=Sophos;i="5.83,326,1616428800"; 
   d="scan'208";a="174332451"
Received: from mail-bn8nam11lp2172.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.172])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2021 03:01:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T9ZV8XELgnAjCPh/6PEu3nP/5tvWtQVFCLbOMu5o5oC4s4UVdL5Qe7VJ885e7ZLumCn6bSe1Gc1xH68gAoW/Faxry1ClwhNc+vpuOhOM6YHD6DlCBVUBxdfAUUnnGF49z+wNmWzQo/6vMbnlAdGI8JnE8jzkHGF/zDacWD/v6C+pvQ2hrBFYWM4o0pGyx/DSDKEhLawbv1yGMfRV9s2maMqtcVm8DDX3rJX+XqbcHrPEp4W0Dsx4PALtX8E/wM/F330WVMbCi9+3FF4ByQO2BjtcBVml6XcO+c+hhhEP9JTD6tkr2Fw5kwDcIKYCiKwk+e5bhYYK/4Mro7Rc6IEhug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1FF9ULuwgU9odj1cItj1UOIbZenA4vFKeGC4IznjLY=;
 b=MLYrkV0iScW+646WasjXHMMA9iPzdnDzwYc6v0MTmgyIdVHSA9CkkRtJw8STC/g64SfS9MAnMDgsosFlTUvKsXU5DuNlfIsLozQJHv294WS/IhP3ppFpdtr6sM8BVSEPg9mh67ofOSVVh+1mMuWyrK1/c0WOmxuhI3O9gaVT7yjiCkqQS9tMzWX2bHD/2AtBN15CzMi0ckaLXNjCWWFXJoT56gdxF0EiMoncxiZkBMstpeaeSNDzsSK3M030WmkRSltzO0dBox6kaydhgWzxe4BqGkQpPitpn73OEvEA80OCx4e7VPZFx7MjtA2+X24QYzfQp96CNHTRLSrmHECdZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1FF9ULuwgU9odj1cItj1UOIbZenA4vFKeGC4IznjLY=;
 b=cs0SfhLxrQ4WmidirCvQDhTzbEB0nATixGVsHEf42xPLoCyRY5IPzyAbGZrxwl4JWPEq/CRcDlbCDvk38i35YmGFO9zzupHqIzhVKwuVUg9dpUxw62CaQDJgZBJZcRF1uw+e3F4XWkz0z/JwAHlztWMDCq91bDy+n2Q9D2FTKmg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5626.namprd04.prod.outlook.com (2603:10b6:5:167::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4287.23; Mon, 5 Jul 2021 19:01:30 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%5]) with mapi id 15.20.4287.033; Mon, 5 Jul 2021
 19:01:29 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 10/21] ufs: Remove ufshcd_valid_tag()
Thread-Topic: [PATCH 10/21] ufs: Remove ufshcd_valid_tag()
Thread-Index: AQHXbr3pDv5CHVQeGUGFucgjqmDRHasz9OVggAC/KACAAA6YQA==
Date:   Mon, 5 Jul 2021 19:01:29 +0000
Message-ID: <DM6PR04MB65751A56C571C417686297C2FC1C9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210701211224.17070-1-bvanassche@acm.org>
 <20210701211224.17070-11-bvanassche@acm.org>
 <DM6PR04MB65756A3574F7857C2217BCAEFC1C9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <78c4342b-7758-a499-208f-393de8097a97@acm.org>
In-Reply-To: <78c4342b-7758-a499-208f-393de8097a97@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [5.29.60.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e573c95-ff14-47d7-12b9-08d93fe74c50
x-ms-traffictypediagnostic: DM6PR04MB5626:
x-microsoft-antispam-prvs: <DM6PR04MB56267B83F86B071AD943BC53FC1C9@DM6PR04MB5626.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xYn2Orh1nNXeAybRhWHYKgnGhsCHS7lVAji1HdObQPvJoAExtYtpLOydRJwGxJxE9qWbOQAQKooIz38X7CIVTpYICeBLo3zDUVLErt7dUHV15IghDwuhjbHNXzsBc+qj4rHNLa1mG6wlRHZHlo9NkR3zTETfToxcNFYuWPpteHI85STUDPuSOt0l5rHhzZhYLPxCeV6CFzcK1aXvdf/xjyAX/9bgKPxlX89/WJVN/5e3aJ2qGj7TF59c0g0flk7Pb9dX+xIdl+Vlh3uvRxRqWcS7Nffek/0N8REuFeWX7Hyzg+4mgP3XTKaDJ1aAoHtpa/JajfKMQmI4N4ec/wWgo0GbqSXW7PM70BHnKN4RhqTaBDs4RkIEgoKm0gfcfCsVyAcSzbmxx246gHlmF/Wxdc78z0FwiBKZxKB07Byc2lmTfg0ntAc8JU50Zq8FMu8ykvC7N0mTi/YcrQARh80vBWua2K8SjHWwoW4NOwZWioF62nS9Q+tX+bif8uI7RNAaBrKmMVAvCWPoZ/kka9egcHWeolxA3gkd8Y04ZBaKcwDVcc7LzU1uzzHeAMpYopXPkTZM8bHphwYZm2je5BnUNGaSU0wmyo25Dt9qLk68hs+WaSvRfm4omf1rpsTSMFkt62OH4C+0J8b0BqEeLCnNLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(54906003)(6506007)(55016002)(53546011)(110136005)(5660300002)(9686003)(8936002)(7416002)(33656002)(86362001)(4326008)(26005)(316002)(8676002)(83380400001)(478600001)(7696005)(122000001)(66556008)(66476007)(66946007)(38100700002)(52536014)(71200400001)(76116006)(2906002)(64756008)(66446008)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WHE5WGtkZ1d1QTVhMXZpUHVodEQ4OG56OEFFeEZ5d3lmamNNaWI5NGVueXhy?=
 =?utf-8?B?eURUYm1wL0w4ZW82UFYzSUxHb0hRWUk4NlhIQnd1NDVVTlZIOVZ2Vlg0Qlgr?=
 =?utf-8?B?djluYTFDOVpsdThRWGNNZytZWUpNUnNBNDA1TWhnaUJVUXNtQ3c1ZWhTKzJE?=
 =?utf-8?B?L2hyVXBpQXFEcGVUMUZndGVyWDg1ZUttOTdDWmtLK2Q1SXZDWHF3djNRbGl3?=
 =?utf-8?B?aElCb2NUU1FiUC9ZUEFvSU1kV2ZkVUp6TDg1aXZhbURrRVA2UG9BQmJBRmtp?=
 =?utf-8?B?Q2kxQXdPcDdBZ0xRdTNxOUlWK2ZCcUw1Q1MwWFU4dFNkdkNmcktEUFc4ZlNT?=
 =?utf-8?B?ZnU2bE1oTXVudkZsK2V6Z3BXbnN4WUM0UHlrMTY3M21BQzBZS2JqWjJxQlJU?=
 =?utf-8?B?ajU0a0FEWk9lVDJ3cVBYN1lKRHk1ZlFuY0xlRTlBbGVQWlBWQTFkdHBFNGd5?=
 =?utf-8?B?eEZFR3lVaUt3QTJaTUtqQ1NjRkZFTGtoUUpibVNkNWkyc3N2RCtuQWkzNURv?=
 =?utf-8?B?VU5ncVpLaHZRbmVRNDg0OUR5NzNjaVVZaUdMUlBWVjVydGFSSk9ZN0pEUGJK?=
 =?utf-8?B?ckgzem9HcDJNSUU0U2swMlMzSHJCVjNqemVFa3huWmdOTHBjaGdpTmNLd094?=
 =?utf-8?B?MnQ3OXIyZUxOZ0hxS01FNXVQQXBRbmx6TEJXV2JZTGs0NVNxWVNuQzVEYTFW?=
 =?utf-8?B?eVFyK1pOVDJPayt0K2lULzFmblFIUGw3eEV2U0JPYVJvcUpQZzlGdTR3S2Y0?=
 =?utf-8?B?RVZxK1hFQ2lpdHVGaDlOWlRzRkFXRDJ2dWU5TUF0ZlUwem9yTnNHMWNmUTR6?=
 =?utf-8?B?eGx5TGNtcGhNNEF3ZXVHdWtpVzhpRE1rMHJlVkJnWmIyL0VLQjNZNWhZTml5?=
 =?utf-8?B?NlBQMSs2dHNjdk9pSkh0TTh3YnZCejRBazNzZHBjbG5nU1dZMG5UdyszMW1F?=
 =?utf-8?B?clVDUEg3cGM0OHNBamdRR2wyZjhtTUluU2ZvUkFBL051S3dGNWRDbGhHVG5G?=
 =?utf-8?B?YnlOQ0JhOE9nU21Ud1UrTkxhS1c4THJyK1d5d3AvR1MvUnhUa2lSSGlPcHRI?=
 =?utf-8?B?MWtxd29tNWw4RVVLNlM2blNNMEJpUk14SFJ5REJLbVdKUjVSem1OMmNJZU1D?=
 =?utf-8?B?NXNEQmZJRlZ0ZW5mQm9KRHVod01uRUhGb1Zmd0dyTVRrSlBERFQ5a05sMEN4?=
 =?utf-8?B?YjRuK29XemorZUVvZllYWHRTeDdldXlJZlNlUzRKWTl3TGxYMk1zaUZtUFYw?=
 =?utf-8?B?RjI1QTA0OC9nY1psVkFuMEE5cEUvTmpVSi9vWGJ4WTdBNTltQ3RBWFh2ODFG?=
 =?utf-8?B?Wk8wdjIvRkV4bUY2UHdBOHJFdTNiNndJR2NrNXd0YWZpcEJUOUM4SHdyODhx?=
 =?utf-8?B?dU9PVlJWOHF1T2QrQ3YxT2ZOZThPUGtRNmplMS9GcCt6c0t3R1ZsL29GUG53?=
 =?utf-8?B?aDFtbkhNYnV1NGU3bFBWaG1NQ0tldWJGcUNVMnBpaXlRdUhQUWZzbVZCRENV?=
 =?utf-8?B?SW9RSXY0NlRMcmVkWGFmTHVYS0w3UlF1enZZM2w0Y09FZ244azRJVkJOeVQ4?=
 =?utf-8?B?S0ViY0FObkYrTUNjZG1KZ2JVelVLMzFKMUIybVh1dFlBSkhaRzgrRXVJQUpm?=
 =?utf-8?B?VWVtZENadGVkbmRiaXUxZVlXNERqQW9WVmc0SFpjamFma0tLWkZJR2RWWEVH?=
 =?utf-8?B?OWVtQWRsT01pcml5YzBZOEdWS0xqbFpHYVk0N1lxbENDYzFFck5sdUVMYlFm?=
 =?utf-8?Q?qBoYaBlCHlDWeI0gHE=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e573c95-ff14-47d7-12b9-08d93fe74c50
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2021 19:01:29.8493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 35wXeobUpWXCpfGDuDCWmPcgCeZYNw2wLpvC306l7bnogpc145uKTVuQxCN7oh382IMkWEaQln5kNgGm5YGEWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5626
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gT24gNy80LzIxIDExOjQ2IFBNLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPj4gc2NzaV9h
ZGRfaG9zdCgpIGFsbG9jYXRlcyBzaG9zdC0+Y2FuX3F1ZXVlIHRhZ3MuIHVmc2hjZF9pbml0KCkg
c2V0cw0KPiA+PiBzaG9zdC0+Y2FuX3F1ZXVlIHRvIGhiYS0+bnV0cnMuIEluIG90aGVyIHdvcmRz
LCB3ZSBrbm93IHRoYXQgdGFnIHZhbHVlcw0KPiA+PiB3aWxsIGJlIGluIHRoZSByYW5nZSBbMCwg
aGJhLT5udXRycykuIEhlbmNlIHJlbW92ZSB0aGUgY2hlY2tzIHRoYXQNCj4gPj4gdmVyaWZ5IHRo
YXQgYmxrX2dldF9yZXF1ZXN0KCkgcmV0dXJucyBhIHRhZyBpbiB0aGlzIHJhbmdlLiBUaGlzIGNo
ZWNrDQo+ID4+IHdhcyBpbnRyb2R1Y2VkIGJ5IGNvbW1pdCAxNDQ5NzMyOGI2YTYgKCJzY3NpOiB1
ZnM6IHZlcmlmeSBjb21tYW5kIHRhZw0KPiA+PiB2YWxpZGl0eSIpLg0KPiA+Pg0KPiA+PiBDYzog
QWxpbSBBa2h0YXIgPGFsaW0uYWtodGFyQHNhbXN1bmcuY29tPg0KPiA+PiBDYzogQXZyaSBBbHRt
YW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQo+ID4+IFNpZ25lZC1vZmYtYnk6IEJhcnQgVmFuIEFz
c2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiA+DQo+ID4+ICBzdGF0aWMgaW50IHVmc2hjZF9h
Ym9ydChzdHJ1Y3Qgc2NzaV9jbW5kICpjbWQpDQo+ID4+ICB7DQo+ID4+IC0gICAgICAgc3RydWN0
IFNjc2lfSG9zdCAqaG9zdDsNCj4gPj4gLSAgICAgICBzdHJ1Y3QgdWZzX2hiYSAqaGJhOw0KPiA+
PiArICAgICAgIHN0cnVjdCBTY3NpX0hvc3QgKmhvc3QgPSBjbWQtPmRldmljZS0+aG9zdDsNCj4g
Pj4gKyAgICAgICBzdHJ1Y3QgdWZzX2hiYSAqaGJhID0gc2hvc3RfcHJpdihob3N0KTsNCj4gPj4g
KyAgICAgICB1bnNpZ25lZCBpbnQgdGFnID0gY21kLT5yZXF1ZXN0LT50YWc7DQo+ID4+ICsgICAg
ICAgc3RydWN0IHVmc2hjZF9scmIgKmxyYnAgPSAmaGJhLT5scmJbdGFnXTsNCj4gPj4gICAgICAg
ICB1bnNpZ25lZCBsb25nIGZsYWdzOw0KPiA+PiAtICAgICAgIHVuc2lnbmVkIGludCB0YWc7DQo+
ID4+ICAgICAgICAgaW50IGVyciA9IDA7DQo+ID4+IC0gICAgICAgc3RydWN0IHVmc2hjZF9scmIg
KmxyYnA7DQo+ID4+ICAgICAgICAgdTMyIHJlZzsNCj4gPj4NCj4gPj4gLSAgICAgICBob3N0ID0g
Y21kLT5kZXZpY2UtPmhvc3Q7DQo+ID4+IC0gICAgICAgaGJhID0gc2hvc3RfcHJpdihob3N0KTsN
Cj4gPj4gLSAgICAgICB0YWcgPSBjbWQtPnJlcXVlc3QtPnRhZzsNCj4gPj4gLSAgICAgICBscmJw
ID0gJmhiYS0+bHJiW3RhZ107DQo+ID4gbHJicCBpcyB1c2VkIGJlbG93ID8NCj4gPiBpZiAobHJi
cC0+bHVuID09IFVGU19VUElVX1VGU19ERVZJQ0VfV0xVTikgLi4uDQo+IA0KPiBIaSBBdnJpLA0K
PiANCj4gVGhlIGxyYnAgYXNzaWdubWVudCBpcyBwcmVzZXJ2ZWQgYnV0IGl0IGhhcyBiZWVuIG1v
dmVkIHVwIHRvIHRoZQ0KPiBkZWNsYXJhdGlvbiBibG9jay4NCk1pc3NlZCB0aGF0IC0gc29ycnku
DQoNCkF2cmkNCg0KPiBCYXJ0Lg0K
