Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A9AC3A5A6
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 10:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAD27207FC
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 10:32:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=lenovonetapp.partner.onmschina.cn header.i=@lenovonetapp.partner.onmschina.cn header.b="JqU+qHay"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732030AbfISKcX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 06:32:23 -0400
Received: from mail-bjbon0143.outbound.protection.partner.outlook.cn ([42.159.36.143]:29578
        "EHLO cn01-BJB-obe.outbound.protection.partner.outlook.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728519AbfISKcX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Sep 2019 06:32:23 -0400
X-Greylist: delayed 1092 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Sep 2019 06:29:18 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=lenovonetapp.partner.onmschina.cn;
 s=selector1-lenovonetapp-partner-onmschina-cn;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0A8hvNDeZiTleZ0B0ViIDEkC4Ms72QO9EnNn5b8wMI0=;
 b=JqU+qHay12Ung8x0ELxIE/N+5PvGTrYJhTfg/Fg+7sJMUwXucSXx0qD2HO4AsBNrWBAZeCUG19q9zDA0cPpTAlUUmQq98g6+aqvlDRk0YXhL1vTCIBDIWlUIkm0W5H+j7SKSPvvb8EdrGvITwqUSZkfDsI/k7m0mFC06LZ/HryU=
Received: from BJXPR01MB0296.CHNPR01.prod.partner.outlook.cn (10.41.52.28) by
 BJXPR01MB165.CHNPR01.prod.partner.outlook.cn (10.41.52.15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.17; Thu, 19 Sep 2019 09:56:45 +0000
Received: from BJXPR01MB0296.CHNPR01.prod.partner.outlook.cn ([10.41.52.28])
 by BJXPR01MB0296.CHNPR01.prod.partner.outlook.cn ([10.41.52.28]) with mapi id
 15.20.2263.028; Thu, 19 Sep 2019 09:56:45 +0000
From:   "Liu, Sunny" <ping.liu@lenovonetapp.com>
To:     Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hans Holmberg <hans.holmberg@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: RE: [RFC PATCH 0/2]  blk-mq I/O scheduling fixes
Thread-Topic: [RFC PATCH 0/2]  blk-mq I/O scheduling fixes
Thread-Index: AQHVbs8LyY2G9x3K8EyyFDHixOiOBKcywVSA
Date:   Thu, 19 Sep 2019 09:56:45 +0000
Message-ID: <BJXPR01MB02964BA1F5E67B7B6CB39EE7F4890@BJXPR01MB0296.CHNPR01.prod.partner.outlook.cn>
References: <20190919094547.67194-1-hare@suse.de>
In-Reply-To: <20190919094547.67194-1-hare@suse.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ping.liu@lenovonetapp.com; 
x-originating-ip: [36.112.23.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da9285b2-e192-4137-1dab-08d73ce7ae22
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(4600270)(4652040)(97021020)(8989299)(711020)(4605104)(1401327)(97022020)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(4601075);SRVR:BJXPR01MB165;
x-ms-traffictypediagnostic: BJXPR01MB165:
x-microsoft-antispam-prvs: <BJXPR01MB165B0711860E5424BAB610BF4890@BJXPR01MB165.CHNPR01.prod.partner.outlook.cn>
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39850400004)(396003)(366004)(346002)(53754006)(328002)(329002)(13464003)(199004)(189003)(76176011)(11346002)(446003)(486006)(59450400001)(6116002)(3846002)(476003)(26005)(102836004)(95416001)(4326008)(66066001)(53546011)(7696005)(55016002)(9686003)(6246003)(86362001)(33656002)(76116006)(54906003)(66556008)(66476007)(71190400001)(71200400001)(478600001)(8676002)(81156014)(316002)(5660300002)(110136005)(305945005)(8936002)(186003)(229853002)(2906002)(7736002)(14454004)(66946007)(63696004)(66446008)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:BJXPR01MB165;H:BJXPR01MB0296.CHNPR01.prod.partner.outlook.cn;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: lenovonetapp.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LNz3PO0/bKPSW//H3PjYj/KBJU1aBchpjh+xsQ1jg7wmYT9M8gOVd0na9XN9NgZsogW54KO0d1iSbNXdESXsgJ5OMWKMaMj268/l2ECbeLxqIaZoiPwTzUGAoaIxnpZEJN+8mUiem2lYvQCZzdA4qUmnXPiguB1dsDv2bqq1nF/etOQegMVt32YELB60qe8WSFNYKSxpTAybTxfUrHuCWuG61Pr91/paDORcTJMWY6k0zB3rVGGkW2zr4LKTWanDnRTknt6Dfk4PZncVijKOcgDdXl566mUql1bUotIcVInbvnD2SYuJ3pTeQDxv0mMICK/uzbOwT2VwyvIrbUH/K1CfhtsdcSVl3bRowkCVkN/GHL2DtkHsg0ruOiGwMzpsu8lMEVPQE0xRSujdXcUu1Ci5+VBzd2tLtnpypdBMVAA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: lenovonetapp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da9285b2-e192-4137-1dab-08d73ce7ae22
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 09:56:45.2228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 927e186b-5306-4888-8faf-367d5292e481
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g9nfs7ocOy1PlwgIaqBYs9iXvZmgjLrWMcttHcGF7e06vREIAgP3FaxKTdyLvv+oz4UYTa+MwHgiI23WEojYSWh5uapiCKJAI5GzCSytj4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BJXPR01MB165
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGVsbG8gU2lyLA0KDQpJIGhhdmUgYSBxdWVzdGlvbiBhYm91dCB0aGUgSS9PIHNjaGVkdWxlciBp
biBrZXJuZWwgNS4yLjkNCg0KaW4gdGhlIG5ldyBrZXJuZWwsIHdoaWNoIEkvTyBzY2hlZHVsZXIg
c2hvdWxkIGJlIHVzZWQgYnkgbGVnYWN5IHJvdGF0aW5nIGRyaXZlPyBTdWNoIGFzIHNhdGEgSERE
Pw0KRHVyaW5nIEZJTyB0ZXN0aW5nIHdpdGggbGliYWlvLCBJIGhhZCBjcmVhdGUgbXVsdGlwbGUg
dGhyZWFkIGluIHRoZSB0ZXN0aW5nLCBhbmQgdGhlbiBmb3VuZCA1MTJrIGFuZCBiaWdnZXIgc2Vx
dWVudCB3cml0ZSBoYWQgYmFkIHBlcmZvcm1hbmNlIHJlc3VsdC4gRXZlbiBJIGhhZCBlbmFibGUg
YW5kIHVzZSBCRlEgc2NoZWR1bGVyLg0KDQpUaGVyZSBoYXMgbm8gc3Egc2NoZWR1bGVyIGFueW1v
cmUsIG9ubHkgaGFzIG5vbmUsIG1xLWRlYWRsaW5lLCBreWJlciBhbmQgQkZRLg0KTXEtZGVhZGxp
bmUgYW5kIGt5YmVyIGlzIGZvciBmYXN0IGJsb2NrIGRldmljZS4gT25seSB0aGUgQkZRIGxvb2tz
IGJldHRlciBwZXJmb3JtYW5jZSwgYnV0IGl0IGNhbid0IGtlZXAgdGhlIGdvb2QgYmVoYXZpb3Ig
ZHVyaW5nIDUxMmsgb3IgYmlnZ2VyIDEwMCUgc2VxIHdyaXRlLg0KDQpDb3VsZCB5b3UgZ2l2ZSBt
ZSBzb21lIGFkdmljZXMgd2hhdCBwYXJhbWV0ZXIgc2hvdWxkIEkgY2hhbmdlIGZvciBtdWx0aXBs
ZSB0aHJlYWQgYmlnZ2VyIGZpbGUgc2VxIHdyaXRpbmc/DQoNClRoYW5rcyBhbGwgb2YgeW91Lg0K
DQpCZXN0UmVnYXJkcywNClN1bm55TGl1KMH1xrwpDQpMZW5vdm9OZXRBcHAgDQqxsb6pytC6o7Xt
x/jO97Gxzfq2q8K3MTC6xdS6MrrFwqVMMy1FMS0wMQ0KTDMtRTEtMDEsQnVpbGRpbmcgTm8uMiwg
TGVub3ZvIEhRIFdlc3QgTm8uMTAgWGlCZWlXYW5nIEVhc3QgUmQuLA0KSGFpZGlhbiBEaXN0cmlj
dCwgQmVpamluZyAxMDAwOTQsIFBSQw0KVGVsOiArODYgMTU5MTA2MjIzNjgNCg0KLS0tLS1Pcmln
aW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IGxpbnV4LWJsb2NrLW93bmVyQHZnZXIua2VybmVsLm9y
ZyA8bGludXgtYmxvY2stb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBCZWhhbGYgT2YgSGFubmVz
IFJlaW5lY2tlDQpTZW50OiAyMDE5xOo51MIxOcjVIDE3OjQ2DQpUbzogSmVucyBBeGJvZSA8YXhi
b2VAa2VybmVsLmRrPg0KQ2M6IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyBNYXJ0aW4gSy4g
UGV0ZXJzZW4gPG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tPjsgSmFtZXMgQm90dG9tbGV5IDxq
YW1lcy5ib3R0b21sZXlAaGFuc2VucGFydG5lcnNoaXAuY29tPjsgQ2hyaXN0b3BoIEhlbGx3aWcg
PGhjaEBsc3QuZGU+OyBsaW51eC1ibG9ja0B2Z2VyLmtlcm5lbC5vcmc7IEhhbnMgSG9sbWJlcmcg
PGhhbnMuaG9sbWJlcmdAd2RjLmNvbT47IERhbWllbiBMZSBNb2FsIDxkYW1pZW4ubGVtb2FsQHdk
Yy5jb20+OyBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4NClN1YmplY3Q6IFtSRkMgUEFU
Q0ggMC8yXSBibGstbXEgSS9PIHNjaGVkdWxpbmcgZml4ZXMNCg0KSGkgYWxsLA0KDQpEYW1pZW4g
cG9pbnRlZCBvdXQgdGhhdCB0aGVyZSBhcmUgc29tZSBhcmVhcyBpbiB0aGUgYmxrLW1xIEkvTyBz
Y2hlZHVsaW5nIGFsZ29yaXRobSB3aGljaCBoYXZlIGEgZGlzdGluY3QgbGVnYWN5IGZlZWwgdG8g
aXQsIGFuZCBwcm9oaWJpdCBtdWx0aXF1ZXVlIEkvTyBzY2hlZHVsZXJzIGZyb20gd29ya2luZyBw
cm9wZXJseS4NClRoZXNlIHR3byBwYXRjaGVzIHNob3VsZCBjbGVhciB1cCB0aGlzIHNpdHVhdGlv
biwgYnV0IGFzIGl0J3Mgbm90IHF1aXRlIGNsZWFyIHdoYXQgdGhlIG9yaWdpbmFsIGludGVudGlv
biBvZiB0aGUgY29kZSB3YXMgSSdsbCBiZSBwb3N0aW5nIHRoZW0gYXMgYW4gUkZDLg0KDQpTbyBh
cyB1c3VhbCwgY29tbWVudHMgYW5kIHJldmlld3MgYXJlIHdlbGNvbWUuDQoNCkhhbm5lcyBSZWlu
ZWNrZSAoMik6DQogIGJsay1tcTogZml4dXAgcmVxdWVzdCByZS1pbnNlcnQgaW4gYmxrX21xX3Ry
eV9pc3N1ZV9saXN0X2RpcmVjdGx5KCkNCiAgYmxrLW1xOiBhbHdheXMgY2FsbCBpbnRvIHRoZSBz
Y2hlZHVsZXIgaW4gYmxrX21xX21ha2VfcmVxdWVzdCgpDQoNCiBibG9jay9ibGstbXEuYyB8IDkg
KystLS0tLS0tDQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMo
LSkNCg0KLS0NCjIuMTYuNA0KDQo=
