Return-Path: <SRS0=8h8k=DT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7065BC43467
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 19:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 094D920E65
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 19:07:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="U6roAXla";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="unxSlh7p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391598AbgJLTHd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Oct 2020 15:07:33 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58750 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390896AbgJLTDa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Oct 2020 15:03:30 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09CJ0ttf005598;
        Mon, 12 Oct 2020 12:03:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=QVx721mSgBJD/lyh/h5gL2O/zdX1UmsS9EJ1YL19jFM=;
 b=U6roAXlaACnkpw4bm/3fpFGvga3C+O9Cj/JlHUN6WbZmZn1T0o9xGv26XyUx/ajHX36D
 7rxgldCHcQsFTCa7uJcKVxUDrmFF7LZ04wU8liqUOrMDJy2elW0JU7Ib/3lMqk3QUyCr
 2D6qhlrX8MoEc6u7my9RFdcQl6WCEwkf1ZabitcuA8Kn2/MIe5vyGF/uheAhmUTbFvCh
 fX8FMmeZdT+jHMm7EGPLQ8Upfk9f4brZlS9h6ZusCwj35K3M2gD/vGNDDeCFBvJX3ZNI
 OGqzDsNssN4C/pRA5r0UuKhctR6L9fTUqvfutC839qMkc4yQ6oYcgEBt8w5SvG+6M5or 3g== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 343aanfeu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 12 Oct 2020 12:03:28 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Oct
 2020 12:03:27 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 12 Oct 2020 12:03:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n1SNLVnVSnxyIXohSbFsek5sJGny9Q2Kci5gyTxwC38YWc/yFlwcwItQghNmXNifTBexp5tI9fX42QQB5WVWAOnHmUnxCkKZtS+mE3n2zl3qu7dsDM6yRkOCLIQ+XHMveFKg9Y1z7faSa5ogrz4B0z/4O9Js9SW5HmXVC/HLWjGvPP0tn1AHq5HI72CC5g9Jivq7v8mPMSrhyq3rIjVftF7uubOmSdbFL8PikP4qfECmjZQWQavKVmlE5W16fJnnGcfTOuOwbOWAC4n1+XrqhFSNCsGkhCxBcB73Z1j57RsZ5mjPB10ysqw5U8xLZ27PShNysiNzyA6IhMr7Z0eT0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVx721mSgBJD/lyh/h5gL2O/zdX1UmsS9EJ1YL19jFM=;
 b=LyCxSp/gv9KvDvmUuiEHv24Y9FEFKSX8mpFem2ozjOreCwkmsSIzNneahgNv8bJWx1kk+YW7UT5o0fRTeqrXhXk1rxqGD+ryyfzEJ4F/MDoRXW8AiDEMu085uKP90WGrAlTrbkT9Y/eZwYIyqAPsj8tHjms02IgzIfEsEG36NldIeFBJ/R23FDNSZcNeN2TO0u36HA5OX2OwAaxcnuV6IIsZ0Pv2fMPxMZh0/Vu0V4e0Sw9KjxXG/JC8NXtyHarwy398u3dgqu1LfxHNOgXGqtGGEGY/edCjedVaOXi0Xjb3vYlBC1cV3+OI3KBRindCTRYmPVoWhsg8WlBzHqFeGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVx721mSgBJD/lyh/h5gL2O/zdX1UmsS9EJ1YL19jFM=;
 b=unxSlh7pI+81GE/EE1VjQHu/f29sQ+nqTmtqiz9U/YNGsEoiIVZLd5wE5tDTaT5cnBCkvP5OgIWO83s6uF7nqVrHOH0P7592xJotfX99FvNVgt9BEip9XvRMmn0JjnVV2vKgrphrIAkMmv+ODFM3Tbj8lXE6W+fcz7rtO00rCVk=
Received: from BYAPR18MB2805.namprd18.prod.outlook.com (2603:10b6:a03:108::25)
 by BY5PR18MB3169.namprd18.prod.outlook.com (2603:10b6:a03:196::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.28; Mon, 12 Oct
 2020 19:03:24 +0000
Received: from BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::fc12:a6a9:5e02:cfa9]) by BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::fc12:a6a9:5e02:cfa9%6]) with mapi id 15.20.3455.030; Mon, 12 Oct 2020
 19:03:24 +0000
From:   Shyam Sundar <ssundar@marvell.com>
To:     James Smart <james.smart@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v2 3/5] scsi: fc: Parse FPIN packets and update statistics
Thread-Topic: [PATCH v2 3/5] scsi: fc: Parse FPIN packets and update
 statistics
Thread-Index: AQHWm6hwCuJkeMeXeka8qVCjJ2lue6mUVgsA//+SAoA=
Date:   Mon, 12 Oct 2020 19:03:24 +0000
Message-ID: <6CF0A113-E5C5-4C47-98E9-C02436AB76B1@marvell.com>
References: <20201006061615.28674-1-njavali@marvell.com>
 <20201006061615.28674-4-njavali@marvell.com>
 <d23c86d9-0440-242d-5713-918fe5917882@broadcom.com>
In-Reply-To: <d23c86d9-0440-242d-5713-918fe5917882@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.40.20081000
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2600:1700:6a70:9c50:fcb8:56d3:64fe:4991]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 163ed664-e2a9-4524-9986-08d86ee17e9a
x-ms-traffictypediagnostic: BY5PR18MB3169:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB31697599A5A5B1B3978C9FEDB4070@BY5PR18MB3169.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vYv8sJjFsWfbJuUvhKKVmacbqivTebUqDe06Hgaz36e/CX+n+Ybxhvnue18zLaX20BHG4GiuDMZFpamCmjKO1x+Wxzk7T53Lbw3ZkJdRb1fFIDw37aAnwC1ecJibWp9PJcUEJkbCSmR1jNsw6d3c5XVcwTy20hSrOBItDYKSSIOe8C1Zkqhh1vUp+FL1P/dqciGjPKJVwRn9HgAvLeg4MgeqAEx6BwLdnVTub/U60GRsjCKgdGOQyhgUBTt4zZOYN5Z1BO9x4wiJnp/uWgVA1cVtJqkvpAI7jrzl9uVLB6tyfKSINkx/yMWbY1mbUL18p3tN6BAyGhNAXEgY2r7Gbw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2805.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(376002)(346002)(136003)(8676002)(186003)(316002)(110136005)(36756003)(8936002)(5660300002)(478600001)(53546011)(6506007)(54906003)(76116006)(66446008)(64756008)(66556008)(66476007)(66946007)(2616005)(15650500001)(83380400001)(86362001)(6512007)(2906002)(6486002)(71200400001)(33656002)(4326008)(107886003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: NNzNVy+tD025SCx9e6ruSz/IJudIFqzr/BYqdcuCb/QLr2+4QdiOxpMfZbaEVeJkR7BPy8M5UvClsJZGW6eD7yhymtEv9gUBfDLxjUDHI1YWVw016GHdXBYkF+6s82W2eYUdc7GddKV9b1kSl6/E3DLsEz71VKht62HLkoCeMDGpOcN3h38OKOGDJjh/QUH3R4aCzjh72bHcCT3NCN3ohrjw8+Ltcej+AFJIfoV0Wey1nzwjgC5cC+bZmiYvTgLp+8qkk/a1FFpSG9rDLZzv+76N5Q8TdNlPXAFxEKV0bSxatfpaDzmbnalN5O+Ogw7NpwpnPXcs4BBYNxegL/5hobtZzL415bxVMeF1loTKABfeJoOk10UUt0SXmW1mBdlmLuryhDf5zKRN06tvksemsrl9Pfav70pTCyoxX1gKsH55fOo6mgxNBf6H5/V2PV/YDLzSVVljXXs6JN+h/ZGRBTPJTIhsxr64M1qYQh4F/85bxcLR8O9NkeuIH0ctEjL14aaRH+LxhkRoddiTdc8UW0TJFWaxfsoQgl//GHHaWS+WHu+maP2GPORz2aBljIpIIIhGcaZQM6sdFCcuUSFOCDSFIQQrFE3vH/wk0s0Vze9JXVF7mnW2I9WU3to6SYu72iNcU7rA7odd7oG5DmchpXcnp+a9D5I26brgUym2898lonDvIw8LJfQ+6SWRZdoFPaW7rS2Ps49KvopMHYqlBQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE8350476E5AE04BB5591FA2F0D0AE6F@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2805.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 163ed664-e2a9-4524-9986-08d86ee17e9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2020 19:03:24.1424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: avFEMjan9G1HF+oeLvMU4tRYewkitMam5ne6hPwO3HNUkyTP8HrB5UMWGnRb+UUZKM1W+uf0uD6HnkQwZI/I3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3169
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-12_15:2020-10-12,2020-10-12 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SmFtZXMsDQogICAgIE15IGFwb2xvZ2llcywgSSBtaXMtcmVhZCB5b3VyIGNvbW1lbnQvcmVzcG9u
c2UgYmVsb3cuIFdoaWxlIHJlYWRpbmcgImxldCdzIG5vdCBjaGFuZ2UiLCBJIGludGVycHJldGVk
IGl0IHRvICJsZXQncyBsZWF2ZSB0aGUgcGF0Y2ggYXMgaXQgaXMiIPCfmIoNCiAgICAgSSdsbCBm
aXggdGhhdCwgYW5kIHRha2UgY2FyZSBvZiB0aGUgaW5kZW50YXRpb24gaW4gdjMuDQoNClJlZ2Fy
ZHMNClNoeWFtDQoNCk9uIDkvMjgvMjAyMCAxOjA3IFBNLCBTaHlhbSBTdW5kYXIgd3JvdGU6DQo+
IEkgYW0gb3BlbiB0byByZW1vdmluZyB0aGUgYWNjb3VudGluZyBhZ2FpbnN0IHRoZSAiZGV0ZWN0
aW5nIiBwb3J0IGZvciBub3csIGdpdmVuIHRoYXQgY3VycmVudGx5LCB0aGVyZSBhcmUgbm8ga25v
d24gaW1wbGVtZW50YXRpb25zIHdoZXJlIHRoZSBOX1BvcnQgaW5pdGlhdGVzIHRoZSBGUElOIEVM
Uy4NCj4gTGV0IG1lIGtub3cgd2hhdCB5b3UgdGhpbmsuDQoNCk9rIC0gbGV0J3Mgbm90IGNoYW5n
ZSBjb3VudGVycyBvbiB0aGUgImRldGVjdGluZyIgcG9ydC4NCg0K77u/T24gMTAvMTIvMjAsIDEx
OjM3IEFNLCAiSmFtZXMgU21hcnQiIDxqYW1lcy5zbWFydEBicm9hZGNvbS5jb20+IHdyb3RlOg0K
DQoNCg0KICAgIE9uIDEwLzUvMjAyMCAxMToxNiBQTSwgTmlsZXNoIEphdmFsaSB3cm90ZToNCiAg
ICA+IEZyb206IFNoeWFtIFN1bmRhciA8c3N1bmRhckBtYXJ2ZWxsLmNvbT4NCiAgICA+DQogICAg
PiBQYXJzZSB0aGUgaW5jb21pbmcgRlBJTiBwYWNrZXRzIGFuZCB1cGRhdGUgdGhlIGhvc3QgYW5k
IHJwb3J0IEZQSU4NCiAgICA+IHN0YXRpc3RpY3MgYmFzZWQgb24gdGhlIEZQSU5zLg0KICAgID4N
CiAgICA+IFNpZ25lZC1vZmYtYnk6IFNoeWFtIFN1bmRhciA8c3N1bmRhckBtYXJ2ZWxsLmNvbT4N
CiAgICA+IFNpZ25lZC1vZmYtYnk6IE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlAbWFydmVsbC5jb20+
DQogICAgPiAtLS0NCiAgICA+IC4uLg0KICAgID4gKy8qDQogICAgPiArICogZmNfZnBpbl9saV9z
dGF0c191cGRhdGUgLSByb3V0aW5lIHRvIHVwZGF0ZSBMaW5rIEludGVncml0eQ0KICAgID4gKyAq
IGV2ZW50IHN0YXRpc3RpY3MuDQogICAgPiArICogQHNob3N0OgkJaG9zdCB0aGUgRlBJTiB3YXMg
cmVjZWl2ZWQgb24NCiAgICA+ICsgKiBAdGx2OgkJcG9pbnRlciB0byBsaW5rIGludGVncml0eSBk
ZXNjcmlwdG9yDQogICAgPiArICoNCiAgICA+ICsgKi8NCiAgICA+ICtzdGF0aWMgdm9pZA0KICAg
ID4gK2ZjX2ZwaW5fbGlfc3RhdHNfdXBkYXRlKHN0cnVjdCBTY3NpX0hvc3QgKnNob3N0LCBzdHJ1
Y3QgZmNfdGx2X2Rlc2MgKnRsdikNCiAgICA+ICt7DQogICAgPiArCXU4IGk7DQogICAgPiArCXN0
cnVjdCBmY19ycG9ydCAqcnBvcnQgPSBOVUxMOw0KICAgID4gKwlzdHJ1Y3QgZmNfcnBvcnQgKmRl
dF9ycG9ydCA9IE5VTEwsICphdHRhY2hfcnBvcnQgPSBOVUxMOw0KICAgID4gKwlzdHJ1Y3QgZmNf
aG9zdF9hdHRycyAqZmNfaG9zdCA9IHNob3N0X3RvX2ZjX2hvc3Qoc2hvc3QpOw0KICAgID4gKwlz
dHJ1Y3QgZmNfZm5fbGlfZGVzYyAqbGlfZGVzYyA9IChzdHJ1Y3QgZmNfZm5fbGlfZGVzYyAqKXRs
djsNCiAgICA+ICsJdTY0IHd3cG47DQogICAgPiArDQogICAgPiArCXJwb3J0ID0gZmNfZmluZF9y
cG9ydF9ieV93d3BuKHNob3N0LA0KICAgID4gKwkJCQkgICAgICBiZTY0X3RvX2NwdShsaV9kZXNj
LT5kZXRlY3Rpbmdfd3dwbikpOw0KICAgID4gKwlpZiAocnBvcnQgJiYNCiAgICA+ICsJICAgICgo
cnBvcnQtPnJvbGVzICYgRkNfUE9SVF9ST0xFX0ZDUF9UQVJHRVQpIHx8DQogICAgPiArCSAgICAo
cnBvcnQtPnJvbGVzICYgRkNfUE9SVF9ST0xFX05WTUVfVEFSR0VUKSkpIHsNCiAgICA+ICsJCWRl
dF9ycG9ydCA9IHJwb3J0Ow0KICAgID4gKwkJZmNfbGlfc3RhdHNfdXBkYXRlKGxpX2Rlc2MsICZk
ZXRfcnBvcnQtPmZwaW5fc3RhdHMpOw0KICAgID4gKwl9DQoNCiAgICBJIHRob3VnaHQgd2UgYWdy
ZWVkIHRvIG5vdCBpbmNsdWRlIHRoZSBkZXRlY3RpbmcgcG9ydCBpbiBzdGF0IHVwZGF0ZXMuDQoN
CiAgICA+ICsNCiAgICA+ICsJcnBvcnQgPSBmY19maW5kX3Jwb3J0X2J5X3d3cG4oc2hvc3QsDQog
ICAgPiArCQkJCSAgICAgIGJlNjRfdG9fY3B1KGxpX2Rlc2MtPmF0dGFjaGVkX3d3cG4pKTsNCiAg
ICA+ICsJaWYgKHJwb3J0ICYmDQogICAgPiArCSAgICAoKHJwb3J0LT5yb2xlcyAmIEZDX1BPUlRf
Uk9MRV9GQ1BfVEFSR0VUKSB8fA0KICAgID4gKwkgICAgKHJwb3J0LT5yb2xlcyAmIEZDX1BPUlRf
Uk9MRV9OVk1FX1RBUkdFVCkpKSB7DQoNCiAgICBuaXRzOiAgaW5kZW50IHRoZSBsYXN0IGxpbmUg
YnkgMSBtb3JlIHNwYWNlIHRvIGFsaWduIGVsZW1lbnRzOyANCiAgICBzdXBlcmZsdW91cyBwYXJl
bnMgb24gcm9sZSBjaGVja3MgKGkuZS4gdGhlIGlubmVyIGNvbmRpdGlvbnMgZG9uJ3QgbmVlZCAN
CiAgICB0byBiZSBwYXJlbnRoZXNpemVkIGFzIG9yZGVyIG9mIHByZWNlZGVuY2Ugd29ya3MgZmlu
ZSkuDQoNCg0KICAgIHNhbWUgY29tbWVudHMgYXBwbHkgdG8gdGhlIG90aGVyIHBhcnRzLg0KDQog
ICAgLS0gamFtZXMNCg0KDQo=
