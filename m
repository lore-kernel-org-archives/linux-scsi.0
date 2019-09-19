Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 216FEC4CEC4
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 10:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E883121A4C
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 10:03:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nFCaom0w";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="M5ubx9yi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388956AbfISKDk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 06:03:40 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:5731 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388905AbfISKDk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Sep 2019 06:03:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1568887420; x=1600423420;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=auHXAEAwBINywtpZelMMMDrChFksnpQgQ+pjBbQiG2s=;
  b=nFCaom0whGmRprPQ1dkbWME+mdknsj504euH2StNOQOzJGjAjx6JhTB5
   bHBF6YAnXJnLee5WaPWCfRpF05bjFB405Ik3tpEtZN1YvMEj9DqIQON8y
   rSi9OH/8VsVUnOuqg0ci+F6/7MN0jeisDNqjnWUw8FP5Y2EvYNLctKVPb
   i5HRNixX4xmPVfjRyw77FixvZSaT8YxL+Yq1OVQE1YoiOLyhB4T0NXP2y
   ZU5LIjRwGGzJDCMRFciJM3cXseio6CBO/v5lg9Djm0UHNMgAG3cJYRxZx
   epWP2fTSLB5tevx0DkXCfQLTS2/+PnfNsGF7AfQb2Yx48qTyfIpEassXM
   g==;
IronPort-SDR: c1GQw16bxjwgYZDwNKWDf/a6MMccplrgfIAZ8KALnEceaPOjUt/K/mk0YY5fMLWwxV7u9XPcQi
 bGoTPayTKpOifjS10oZBmKMINAVnSBaxMbyZtD1+9VnwTJb0TdrmYvTY2AOEC0ep6XXh4T1NoG
 j76+w9fg83FcXHVEI8V6CmNWmiV1YcN33gX3Y3Xi58wQRPTeCyKfTu1g1Mq+QHNtui4Agsb4lO
 p84jPAGD8NQJKZ7PBbtv+DJkah4bQYOcuOW0faX2eNFaJvW++D/3/6q222VZoQGGUrTdvgxiJh
 HrE=
X-IronPort-AV: E=Sophos;i="5.64,523,1559491200"; 
   d="scan'208";a="123097922"
Received: from mail-bn3nam01lp2059.outbound.protection.outlook.com (HELO NAM01-BN3-obe.outbound.protection.outlook.com) ([104.47.33.59])
  by ob1.hgst.iphmx.com with ESMTP; 19 Sep 2019 18:03:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Szkt2Kv60Y0oIf+ktH2MElcOcwmhK+fBjrX61+utGd4JBXdxrnI9up2kNetyVoY3/aa0YYnu2GXTv/ahTWetx/gmQUKKjHAQojgIy+GT07XesbXO/LZis3puDeO7uun3Ecf+myGNnrVbNeQM9bEnKvdO0xhyAOWEBptanyzWO7mooXM5zm1GIZOUz/QLaBnjcrFJ8bKM5ULQPsaVZq7w16JpA5UzrBgwWdQZV7L/1blr6hgqwbh8J3RJWG63IpOCX81n3im0ZcBg34y6swtFHnbhw6yVLGqtiHF/lUA/p7XtSbj+U0Pl9ympdh2yxoqE4h9Rxob0bQUVne9HT5cm0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=auHXAEAwBINywtpZelMMMDrChFksnpQgQ+pjBbQiG2s=;
 b=FAFnPu+hHUYD2SFIlCha3K3mNkLTyj8Qwsn4HACbrAE8IpAYAs+RHGVOGdnmqwV9nVGTtLxDhOl/3h6x4/4sRG005SBuGL1C06IWMnjriFKpbRPzHZPPusJlPgPd15oQ6ycF17VJZnrqgOhNmbYD1YW63CyqvEBZFImNBomt1Nvpaes1wYctub3Nun+DjiXaCmYzudkU7odIzSsIvXVEY4bsn9hG9IU64g0yAIio/TFvnZndEQZ7SRCKYVkBJxEmQHMY4xfqslRlSeRtwjuc3yg4Gr/6aH17CODcvOaeibaOVpqArIgXJMJ/c2Ij2geQLaa7+aUX9nBleCqANIMawg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=auHXAEAwBINywtpZelMMMDrChFksnpQgQ+pjBbQiG2s=;
 b=M5ubx9yi0ryQH318ET4BliY1mjYf4OXr745ujP44X4W57//B3Y+ZEr8lo567OiDfGXdeb6KamFuugXt77W9ThDhmTzKiPGBugVT511zAzyPf92jlZVJE3Qbf9lePWrdcmjruXU+/tCdSy6UKCtF5Bdq8eRep+IkkHdAhzUR0gWQ=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB5237.namprd04.prod.outlook.com (20.178.48.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20; Thu, 19 Sep 2019 10:03:36 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::9821:67e1:9799:b117]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::9821:67e1:9799:b117%3]) with mapi id 15.20.2284.009; Thu, 19 Sep 2019
 10:03:36 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Liu, Sunny" <ping.liu@lenovonetapp.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: Re: [RFC PATCH 0/2] blk-mq I/O scheduling fixes
Thread-Topic: [RFC PATCH 0/2] blk-mq I/O scheduling fixes
Thread-Index: AQHVbtGArbQxrIRB/UOO5+Jp36iGNw==
Date:   Thu, 19 Sep 2019 10:03:36 +0000
Message-ID: <BYAPR04MB581634BD1F85CA9768AC780FE7890@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190919094547.67194-1-hare@suse.de>
 <BJXPR01MB02964BA1F5E67B7B6CB39EE7F4890@BJXPR01MB0296.CHNPR01.prod.partner.outlook.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [193.86.95.52]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 237179ce-d7e8-4072-53f2-08d73ce8a304
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB5237;
x-ms-traffictypediagnostic: BYAPR04MB5237:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB52379CCE68965D730FD42F6AE7890@BYAPR04MB5237.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(13464003)(189003)(199004)(53754006)(66066001)(6436002)(71190400001)(8936002)(229853002)(81156014)(52536014)(8676002)(4326008)(110136005)(54906003)(71200400001)(316002)(81166006)(33656002)(53546011)(66946007)(55236004)(66556008)(2906002)(64756008)(66446008)(102836004)(66476007)(76176011)(6506007)(9686003)(25786009)(7736002)(74316002)(55016002)(305945005)(86362001)(486006)(478600001)(476003)(6116002)(5660300002)(186003)(26005)(76116006)(7696005)(99286004)(256004)(14444005)(14454004)(446003)(6246003)(3846002)(91956017);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5237;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kLJA137gfMwNLYEN7/wBcI0F78b3cWT2uv47zo8ufAw69bkq6Q38BSJkbyuE0F61VWZQ100Jou8sJzXS59K+Ro/sazm3plB3+BvstLNflptXuLf/EbcU+PqyS3geD8JeTv0lbWmoPnLW0afVYdXrhqO9MegaH12nh337tBisZvIiDKuYY5f0wvn4OcJr0MlIjnKCLrnT4DxS2ajh7ULG/mD709rV9jLCsvEFouHiRCKc/U+CW1Lb1XZwxsfq7Pp6dTPnav616QbmXKGcAj/s4Q8DPG3Ln3c+FxotZkxgYn6aetYMRraMoDochUHNzm6vnxUsfXTfx7hKD4rAKalUQlMBY3Ds+VmqAQzz5PUTsQU+r9dwtFwUQr5RQHTEeTnA7ez5gJxNZ4m8+dhjx5Cf+ogdPU8BDKzEPXMJ7AOpyRc=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 237179ce-d7e8-4072-53f2-08d73ce8a304
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 10:03:36.0843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZUUsak+nvlXrk7N4ZrsLPw0BJZDuez3dYTgSuTxLxV4yrdZxbF8/5J0o84AQ01C/gihdnRbRA7ZEPn2Sjx/Q/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5237
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMjAxOS8wOS8xOSAxMTo1NywgTGl1LCBTdW5ueSB3cm90ZToKPiBIZWxsbyBTaXIsCj4gCj4g
SSBoYXZlIGEgcXVlc3Rpb24gYWJvdXQgdGhlIEkvTyBzY2hlZHVsZXIgaW4ga2VybmVsIDUuMi45
Cj4gCj4gaW4gdGhlIG5ldyBrZXJuZWwsIHdoaWNoIEkvTyBzY2hlZHVsZXIgc2hvdWxkIGJlIHVz
ZWQgYnkgbGVnYWN5IHJvdGF0aW5nCj4gZHJpdmU/IFN1Y2ggYXMgc2F0YSBIREQ/IER1cmluZyBG
SU8gdGVzdGluZyB3aXRoIGxpYmFpbywgSSBoYWQgY3JlYXRlCj4gbXVsdGlwbGUgdGhyZWFkIGlu
IHRoZSB0ZXN0aW5nLCBhbmQgdGhlbiBmb3VuZCA1MTJrIGFuZCBiaWdnZXIgc2VxdWVudCB3cml0
ZQo+IGhhZCBiYWQgcGVyZm9ybWFuY2UgcmVzdWx0LiBFdmVuIEkgaGFkIGVuYWJsZSBhbmQgdXNl
IEJGUSBzY2hlZHVsZXIuCj4gCj4gVGhlcmUgaGFzIG5vIHNxIHNjaGVkdWxlciBhbnltb3JlLCBv
bmx5IGhhcyBub25lLCBtcS1kZWFkbGluZSwga3liZXIgYW5kCj4gQkZRLiBNcS1kZWFkbGluZSBh
bmQga3liZXIgaXMgZm9yIGZhc3QgYmxvY2sgZGV2aWNlLiBPbmx5IHRoZSBCRlEgbG9va3MKPiBi
ZXR0ZXIgcGVyZm9ybWFuY2UsIGJ1dCBpdCBjYW4ndCBrZWVwIHRoZSBnb29kIGJlaGF2aW9yIGR1
cmluZyA1MTJrIG9yIGJpZ2dlcgo+IDEwMCUgc2VxIHdyaXRlLgo+IAo+IENvdWxkIHlvdSBnaXZl
IG1lIHNvbWUgYWR2aWNlcyB3aGF0IHBhcmFtZXRlciBzaG91bGQgSSBjaGFuZ2UgZm9yIG11bHRp
cGxlCj4gdGhyZWFkIGJpZ2dlciBmaWxlIHNlcSB3cml0aW5nPwoKVGhlIGRlZmF1bHQgYmxvY2sg
SU8gc2NoZWR1bGVyIGZvciBhIHNpbmdsZSBxdWV1ZSBkZXZpY2UgKGUuZy4gSEREcyBpbiBtb3N0
CmNhc2VzLCBidXQgYmV3YXJlIG9mIHRoZSBIQkEgYmVpbmcgdXNlZCBhbmQgaG93IGl0IGV4cG9z
ZXMgdGhlIGRpc2spIGlzCm1xLWRlYWRsaW5lLiBGb3IgYSBtdWx0aXF1ZXVlIGRldmljZSAoZS5n
LiBOVk1lIFNTRHMpLCB0aGUgZGVmYXVsdCBlbGV2YXRvciBpcyBub25lLgoKRm9yIHlvdXIgU0FU
QSBTU0QsIHdoaWNoIGlzIGEgc2luZ2xlIHF1ZXVlIGRldmljZSwgdGhlIGRlZmF1bHQgZWxldmF0
b3Igd2lsbCBiZQptcS1kZWFkbGluZS4gVGhpcyBlbGV2YXRvciBzaG91bGQgZ2l2ZSB5b3UgdmVy
eSBnb29kIHBlcmZvcm1hbmNlLiAibm9uZSIgd2lsbApwcm9iYWJseSBhbHNvIGdpdmUgeW91IHRo
ZSBzYW1lIHJlc3VsdHMgdGhvdWdoLgoKUGVyZm9ybWFuY2Ugb24gU1NEIGhpZ2hseSBkZXBlbmRz
IG9uIHRoZSBTU0QgY29uZGl0aW9uICh0aGUgYW1vdW50IGFuZCBwYXR0ZXJuCm9mIHdyaXRlcyBw
cmVjZWRpbmcgdGhlIHRlc3QpLiBZb3UgbWF5IHdhbnQgdG8gdHJpbSB0aGUgZW50aXJlIGRldmlj
ZSBiZWZvcmUKd3JpdGluZyBpdCB0byBjaGVjayB0aGUgbWF4aW11bSAgcGVyZm9ybWFuY2UgeW91
IGNhbiBnZXQgb3V0IG9mIGl0LgoKPiAKPiBUaGFua3MgYWxsIG9mIHlvdS4KPiAKPiBCZXN0UmVn
YXJkcywgU3VubnlMaXUowfXGvCkgTGVub3ZvTmV0QXBwILGxvqnK0Lqjte3H+M73sbHN+rarwrcx
MLrF1LoyusXCpUwzLUUxLTAxIAo+IEwzLUUxLTAxLEJ1aWxkaW5nIE5vLjIsIExlbm92byBIUSBX
ZXN0IE5vLjEwIFhpQmVpV2FuZyBFYXN0IFJkLiwgSGFpZGlhbgo+IERpc3RyaWN0LCBCZWlqaW5n
IDEwMDA5NCwgUFJDIFRlbDogKzg2IDE1OTEwNjIyMzY4Cj4gCj4gLS0tLS1PcmlnaW5hbCBNZXNz
YWdlLS0tLS0gRnJvbTogbGludXgtYmxvY2stb3duZXJAdmdlci5rZXJuZWwub3JnCj4gPGxpbnV4
LWJsb2NrLW93bmVyQHZnZXIua2VybmVsLm9yZz4gT24gQmVoYWxmIE9mIEhhbm5lcyBSZWluZWNr
ZSBTZW50OiAyMDE5xOo5Cj4g1MIxOcjVIDE3OjQ2IFRvOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJu
ZWwuZGs+IENjOiBsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZzsKPiBNYXJ0aW4gSy4gUGV0ZXJz
ZW4gPG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tPjsgSmFtZXMgQm90dG9tbGV5Cj4gPGphbWVz
LmJvdHRvbWxleUBoYW5zZW5wYXJ0bmVyc2hpcC5jb20+OyBDaHJpc3RvcGggSGVsbHdpZyA8aGNo
QGxzdC5kZT47Cj4gbGludXgtYmxvY2tAdmdlci5rZXJuZWwub3JnOyBIYW5zIEhvbG1iZXJnIDxo
YW5zLmhvbG1iZXJnQHdkYy5jb20+OyBEYW1pZW4gTGUKPiBNb2FsIDxkYW1pZW4ubGVtb2FsQHdk
Yy5jb20+OyBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4gU3ViamVjdDogW1JGQwo+IFBB
VENIIDAvMl0gYmxrLW1xIEkvTyBzY2hlZHVsaW5nIGZpeGVzCj4gCj4gSGkgYWxsLAo+IAo+IERh
bWllbiBwb2ludGVkIG91dCB0aGF0IHRoZXJlIGFyZSBzb21lIGFyZWFzIGluIHRoZSBibGstbXEg
SS9PIHNjaGVkdWxpbmcKPiBhbGdvcml0aG0gd2hpY2ggaGF2ZSBhIGRpc3RpbmN0IGxlZ2FjeSBm
ZWVsIHRvIGl0LCBhbmQgcHJvaGliaXQgbXVsdGlxdWV1ZQo+IEkvTyBzY2hlZHVsZXJzIGZyb20g
d29ya2luZyBwcm9wZXJseS4gVGhlc2UgdHdvIHBhdGNoZXMgc2hvdWxkIGNsZWFyIHVwIHRoaXMK
PiBzaXR1YXRpb24sIGJ1dCBhcyBpdCdzIG5vdCBxdWl0ZSBjbGVhciB3aGF0IHRoZSBvcmlnaW5h
bCBpbnRlbnRpb24gb2YgdGhlCj4gY29kZSB3YXMgSSdsbCBiZSBwb3N0aW5nIHRoZW0gYXMgYW4g
UkZDLgo+IAo+IFNvIGFzIHVzdWFsLCBjb21tZW50cyBhbmQgcmV2aWV3cyBhcmUgd2VsY29tZS4K
PiAKPiBIYW5uZXMgUmVpbmVja2UgKDIpOiBibGstbXE6IGZpeHVwIHJlcXVlc3QgcmUtaW5zZXJ0
IGluCj4gYmxrX21xX3RyeV9pc3N1ZV9saXN0X2RpcmVjdGx5KCkgYmxrLW1xOiBhbHdheXMgY2Fs
bCBpbnRvIHRoZSBzY2hlZHVsZXIgaW4KPiBibGtfbXFfbWFrZV9yZXF1ZXN0KCkKPiAKPiBibG9j
ay9ibGstbXEuYyB8IDkgKystLS0tLS0tIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyks
IDcgZGVsZXRpb25zKC0pCj4gCj4gLS0gMi4xNi40Cj4gCj4gCgoKLS0gCkRhbWllbiBMZSBNb2Fs
Cldlc3Rlcm4gRGlnaXRhbCBSZXNlYXJjaAo=
