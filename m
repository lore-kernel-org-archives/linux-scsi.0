Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA798C5DF60
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 22:00:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F37F21A4A
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 22:00:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="1cvwvH6b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730087AbfKEWAs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 17:00:48 -0500
Received: from mail-eopbgr790055.outbound.protection.outlook.com ([40.107.79.55]:28768
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730220AbfKEWAr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 5 Nov 2019 17:00:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNhXAwGVxX1Fh9uT99gEgKYKvITxQAYX41XsZNtspdRzkj3ndsGybKmh309MMECVDqscNB0NN+ndIenZOZ+imnWYR4vI7BxOgCSGmPbz1uRcy+7cXjkIjIow03SrDpDPut4YrBrWeh/S41w5Juf+uWLBw/YWDgDYz98to++rfZH1UonhTWYllLAZpS6edTQMH1QjTk3bOkKz4RDsd0ED0609VcBcYWuVNTPMXwmBYkQAnvpkgI3Pt+NtXcwU9c6bg50AgSgdnS12kU24M2dG8ou+BxluPOVxT2QlMHRM2uFU5dsyIqUXwwvyEQ+B0POuDjG3UnjDNOatrMal4bGXcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/CPAuYcS0l9BQ/3cgp8rx4dS5HP5DkEofkB82460OEY=;
 b=dNFKY9ONH+PkWpWjYrUuAuPq172j0PBF5+gEv03zbfeAdUIjn8ZxyCc3k4hPNxMS+o6ZcXAyZOmNkgXf3LFV1aSTURv33pvmXTRM3DFtqXzBXIM42comrZ7zy9JFOlV7cNhA6K4wzo0Z9zA1A+FToDt/N96judydjud6B6Pr0bVhpTMG4MQ4BU23gmWIT4htf5QtsSLI1MKbnIlAk5vmn4VkNhQiYWOo9XfzM7nxfOq91AUVKXRMLVfk7D8ILQDMo/dYWErsobutkSbackBWrNT+s2hPkHKz8BEW+nN7Zi0xlJVmpKYVygmgv84/VMj+IMFHuYqZLYnvOCkkxkqlOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/CPAuYcS0l9BQ/3cgp8rx4dS5HP5DkEofkB82460OEY=;
 b=1cvwvH6bVnvBFn78K9eLCE4upc2rKxZvUthouF0A+pfpUDIsauJvnOwcw+GFLse6oIlcYmZ06hay/JfMgjE2zfPcm5C5965/8IBTg944FrdMjJe8OvMgyU/g1omh9SE+lCM6/BsoQtFXVg/e+tm+oxGxDKQ0qImBUHs6NfUS/Bw=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB5060.namprd08.prod.outlook.com (20.176.27.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 21:59:58 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 21:59:58 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: RE: [EXT] [PATCH RFC v2 4/5] ufs: Use blk_{get,put}_request() to
 allocate and free TMFs
Thread-Topic: [EXT] [PATCH RFC v2 4/5] ufs: Use blk_{get,put}_request() to
 allocate and free TMFs
Thread-Index: AQHVk3HzaAE2ARtmo0Ge74jIZK0q1Kd8k4zAgAA8IQCAAE8NEA==
Date:   Tue, 5 Nov 2019 21:59:58 +0000
Message-ID: <BN7PR08MB56844362FCF882E810B5017BDB7E0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20191105004226.232635-1-bvanassche@acm.org>
 <20191105004226.232635-5-bvanassche@acm.org>
 <BN7PR08MB568437EAF8BF59CF9101C507DB7E0@BN7PR08MB5684.namprd08.prod.outlook.com>
 <85c20718-fb3f-8a5e-6873-3f313b862b80@acm.org>
In-Reply-To: <85c20718-fb3f-8a5e-6873-3f313b862b80@acm.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTk5YzgxNjMxLTAwMTctMTFlYS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw5OWM4MTYzMi0wMDE3LTExZWEtOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjE1MzEiIHQ9IjEzMjE3NDY0Nzk2MzMxNTU4OCIgaD0iWlNyK2VLQTczZzJmMmg1VDV6OXpkOWpEVGhrPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.112]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23ef2b69-e87d-4560-2e63-08d7623b800e
x-ms-traffictypediagnostic: BN7PR08MB5060:|BN7PR08MB5060:|BN7PR08MB5060:
x-microsoft-antispam-prvs: <BN7PR08MB5060F8B1F452A72BAAC25BF5DB7E0@BN7PR08MB5060.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(189003)(199004)(6436002)(81156014)(2906002)(66066001)(9686003)(6246003)(305945005)(74316002)(4326008)(66556008)(66476007)(66946007)(186003)(11346002)(33656002)(3846002)(6116002)(476003)(7736002)(66446008)(99286004)(64756008)(256004)(5660300002)(486006)(7416002)(86362001)(14444005)(14454004)(8676002)(229853002)(25786009)(71190400001)(81166006)(71200400001)(446003)(54906003)(55236004)(110136005)(316002)(76176011)(102836004)(7696005)(53546011)(6506007)(55016002)(8936002)(76116006)(26005)(52536014)(478600001)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5060;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8n3iEjzpv0q4prSj9MvcxvRFyti32AGs2aHHNar/lr8Zx9Z7gy8zH15lvgd69RlpiZKmANQgKaokPTbB866DeBOTkbOLfpY1jnGg8u+1ndn+KHR1wfyuro3HuDTsVGHrVfh+NjV/ambsV6LO7TMZWbF7RM1k+ugos5Y09E4B09+tDva2OsF/EHVC4BpS74u4gZ1qzQALJxbrYjVTTpqyHEGCl81Ylyi/4GkH5PqQbc3bJkVwfmPrDLn1J8A3vULgNXQQADXRzBivFk6VUhvsGg6DjDAuukW0QOqrbZeNZSAXwJF5C3BSIGE2al4YfT160H0+XRKQaIEPO6WhgXPOgBU6mLpcsFtW5zJH+QzyRCw9YJwuvqLfBRPBlCvolhJWjWXzBu32AibYy/b67KCvbI6YMMC78N00sRfCacQfAyjTEYrDSqlozdKFn2PlNaOA
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23ef2b69-e87d-4560-2e63-08d7623b800e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 21:59:58.5511
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NOUbQbT9AJs5lyhZDAc8DIFds42Tp8IyK5L2qZV+w4ijZBBRi+0N36vUETlLyaKKCtWWPI0vwoYWPL1PfV2ihw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5060
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+IE9uIDExLzUvMTkgNTo1MCBBTSwgQmVhbiBIdW8gKGJlYW5odW8pIHdyb3RlOg0KPiA+PiAt
CXdhaXRfZXZlbnQoaGJhLT50bV90YWdfd3EsIHVmc2hjZF9nZXRfdG1fZnJlZV9zbG90KGhiYSwN
Cj4gPj4gJmZyZWVfc2xvdCkpOw0KPiA+PiArCXJlcSA9IGJsa19nZXRfcmVxdWVzdChxLCBSRVFf
T1BfRFJWX09VVCwgQkxLX01RX1JFUV9SRVNFUlZFRCk7DQo+ID4+ICsJcmVxLT5lbmRfaW9fZGF0
YSA9ICZ3YWl0Ow0KPiA+PiArCWZyZWVfc2xvdCA9IHJlcS0+dGFnOw0KPiA+PiArCVdBUk5fT05f
T05DRShmcmVlX3Nsb3QgPCAwIHx8IGZyZWVfc2xvdCA+PSBoYmEtPm51dG1ycyk7DQo+ID4+ICAg
CXVmc2hjZF9ob2xkKGhiYSwgZmFsc2UpOw0KPiA+Pg0KPiA+IFVuZGVyc3RhbmQgbm93ICwgeW91
IGRlbGV0ZSB1ZnNoY2RfZ2V0X3RtX2ZyZWVfc2xvdCgpLiBSdW4gYSBiaWcgY2lyY2xlIHRvDQo+
IGdldCBhIGZyZWVfc2xvdCBmcm9tIHJlc2VydmVkIHRhZ3MgYnkgY2FsbGluZyBibGtfZ2V0X3Jl
cXVlc3QoKS4NCj4gPiBCdXQgVUZTIGRhdGEgdHJhbnNmZXIgcXVldWUgZGVwdGggaXMgMzIsIG5v
dCAzMiArIGhiYS0+bnV0bXJzLiAgSG93IHRvIG1ha2UNCj4gc3VyZSB3ZSBzZWUgdGhlIHRhZyBp
cyBjb25zaXN0ZW50IGFjcm9zcyBibG9jay9zY3NpL3Vmcz8NCj4gDQo+IEhpIEJlYW4sDQo+IA0K
PiBQbGVhc2UgaGF2ZSBhIGxvb2sgYXQgdGhlIGJsa19tcV9nZXRfdGFnKCkgZnVuY3Rpb24gaW4g
dGhlIGJsb2NrIGxheWVyLg0KPiBUaGUgaW1wbGVtZW50YXRpb24gb2YgdGhhdCBmdW5jdGlvbiBt
YWtlcyBpdCBjbGVhciB0aGF0IHRoZSB0YWdzIHdpdGggbnVtYmVycw0KPiBbMCAuLiBucl9yZXNl
cnZlZCkgYXJlIGNvbnNpZGVyZWQgcmVzZXJ2ZWQgdGFncyBhbmQgYWxzbyB0aGF0IHRoZSB0YWdz
IHdpdGgNCj4gbnVtYmVycyBbbnJfcmVzZXJ2ZWQgLi4gcXVldWVfZGVwdGgpIGFyZSBjb25zaWRl
cmVkIHJlZ3VsYXIgdGFncy4gSW4gb3RoZXINCj4gd29yZHMsIGFkZGluZyBoYmEtPm51dG1ycyB0
byBjYW5fcXVldWUgZG9lcyBub3QgaW5jcmVhc2UgdGhlIHF1ZXVlIGRlcHRoDQo+IGJlY2F1c2Ug
dGhlIHNhbWUgbnVtYmVyIG9mIHRhZ3MgYXJlIGNvbnNpZGVyZWQgcmVzZXJ2ZWQgdGFncy4NCj4g
DQo+IEJhcnQuDQoNCkhpLCBCYXJ0DQpZZXMsIEkgc2F3IHRoYXQuIEFuZCBhY3R1YWxseSwgdGFz
ayBtYW5hZ2VtZW50IHJlcXVlc3RzIGFuZCByZWd1bGFyIGRhdGEgdHJhbnNmZXINClJlcXVlc3Rz
IHdpbGwgYmUgc3RvcmVkIHRvIGRpZmZlcmVudCBxdWV1ZXMsIGFuZCB1c2UgZGlmZmVyZW50IGRv
b3ItYmVsbCByZWdpc3RlcnMuDQpTbyBhcyB5b3Ugc2FpZCwgdG8gaW50cm9kdWNlIGEgbmV3IHRh
ZyBzZXQgZm9yIFRNRnMgaXMgYmV0dGVyLg0KVGhhbmtzLA0KDQovL0JlYW4NCg==
