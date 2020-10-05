Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4075C4363D
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 09:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77D1C20776
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 09:51:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jUKAnhJq";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="PDtwRd3m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgJEJvN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 05:51:13 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:37690 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgJEJvN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 05:51:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1601891649; x=1633427649;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1C2i8xG6dG/aUIfkGWtvvNqQXkQR+HbAFWGH2iI61Jg=;
  b=jUKAnhJqn55HZ5eoygHxxfqBU0wQt3y+EKvXOPKdktpQZtWjWeYK9OeQ
   ADqUn0aiu5pmdxlQYJufimS5SaeCMDpkxd6J6tWfr6bWK5I+GwjgUq9Cr
   +dGIvHxEm07YqjjP7hApXrW0qsngV3hQdLyAfTCIFTQYzRZXFvB7NZYlr
   l3/tAsp6mA/FPZFGykFreXJw+no2CvL+bE0lKD2vdk6NnIP3vkxr1lEGz
   RvTgoHSOGSYPMk3FeeIfa0jAmS6eDr7s5HG2PUc/fhbfssVwvQ04K0gKO
   LiaDmpmbzSo6JuyZ/bHAVV2y/XhqlHJl9RF6iXWaWre5EdewHHaCLCXP8
   A==;
IronPort-SDR: iF0/SYhR689Kyhywi0lR5s+XKBvYvNsc4Cm3d5OwYBdq3hOjl80NfkJVRuwp0Lg+OqoHd0I9ms
 B4JfdUyOMU6XM7fxhHyhtz/avWtujqvZMH5017eoehjY8QznYW+xTDJxv9qLVTx/ASG/4RoHkA
 xYhLJOC6eNlRypoaO5nQBTWLqB4A5373y/mHP/KmMNSq5AlifpxK4L+M6gIr59KlRO9hDJxd2l
 mkABgdHFoAUiIx+dxtNso+wbAhhi9iE7GH+4P8ElPVHdtlGPNFnSJYVFlyL2tjEBD09DG4y6OR
 ZR0=
X-IronPort-AV: E=Sophos;i="5.77,338,1596470400"; 
   d="scan'208";a="252491008"
Received: from mail-sn1nam04lp2052.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.52])
  by ob1.hgst.iphmx.com with ESMTP; 05 Oct 2020 17:54:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MUyTi9kYyVOYVABdnSlw+yyA1pIR449zXoWAuhuUUjpFv/pGNzozmvVEEoMDsjQkdGLMSWOqlh+lktGL+IxaApIWPIMh6ug7P8s40Qw9ojP7EQKveFRgUTCe49tDesBKVajpKWRFrh4NiqZLdQE/B8NMnw6HSunKfg7x5oknpTY/M57+8vlHC7PEnDupHUeqQT8K/vl4rp7+PYejbrp/k3DCbQDtj9xJygslddXkkxuDH6fkZm9RjaKGiYkhZKolfQDUyByeUWfR9f5IUyzXwsDRJpQLk6qSHoJ/zTweZZrKUzYUaHUWUajGNyzk9LVa3GhMaBnKGKAUZmbaZyuxAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1C2i8xG6dG/aUIfkGWtvvNqQXkQR+HbAFWGH2iI61Jg=;
 b=HkY6qIsulEpk/d8dE5owLQAG7paBf4cUX1EqKs5fSQgjufYx1mPBg1Wz8KUu5kmhiZGwXk3ESL0BKktAmXaiTRT3KiK2XRjR0dMh6PWnokaGW4ufHc/De+TmhEOTIWrfvftGOOW80KOQmuvEknGzlSUsvPpkfHoWOU5QaS91oWW/gDJVS18a/EMlHHlTm7G+H/ayqLcIY6NDzC8BLIevIeP8hTcRwhDUEtksKvbbyumb+81tOfptvS5osHIzyNbBcUp669Jd+uNszLZKxerWjbnkf8ayhczUhHtbX029WqvxVjdLrjK1uN4eY0VURaRUx6rsmfNLqmbe9PEYWrczRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1C2i8xG6dG/aUIfkGWtvvNqQXkQR+HbAFWGH2iI61Jg=;
 b=PDtwRd3mhY3ejBQitl0Gl4R1O+ljBzXbzvXy6hCOAwnsrKoo3PfQDMeWbZahs22Og8pyXz4SOxZNMq5YtG37tDlCY345vSAZxgjUpeGfImifiHUBKKkrIcTpSCAx+p1A20kGhBArf3r4B/t5N5stS0lYc+Pgz0Qjl8KHBEFFxdM=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BYAPR04MB4087.namprd04.prod.outlook.com (2603:10b6:a02:a9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Mon, 5 Oct
 2020 09:51:09 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::5567:207e:4c1b:3ce1]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::5567:207e:4c1b:3ce1%8]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 09:51:09 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: RE: [PATCH 1/2] scsi: ufs: Add DeepSleep feature
Thread-Topic: [PATCH 1/2] scsi: ufs: Add DeepSleep feature
Thread-Index: AQHWmLlX/36ef3l9WEy26/6zpaIUz6mIpxKwgAAOnICAABKTMA==
Date:   Mon, 5 Oct 2020 09:51:08 +0000
Message-ID: <BY5PR04MB6705E5FFEDED858772890DDBFC0C0@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <20201002124043.25394-1-adrian.hunter@intel.com>
 <20201002124043.25394-2-adrian.hunter@intel.com>
 <BY5PR04MB67054C67CCA53AB5FC5CBCFAFC0C0@BY5PR04MB6705.namprd04.prod.outlook.com>
 <a3cd3d32-0dcf-ebaf-d6fe-e8f21539dff1@intel.com>
In-Reply-To: <a3cd3d32-0dcf-ebaf-d6fe-e8f21539dff1@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2a4a6b48-d8be-425d-1eab-08d869142f9a
x-ms-traffictypediagnostic: BYAPR04MB4087:
x-microsoft-antispam-prvs: <BYAPR04MB408712A699A9ACE3E566DD35FC0C0@BYAPR04MB4087.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /eFFEQ9dGDO+rg0f1NHrCI/gVpAGDLXGXk5KElQFCvxE/MMq5ZrUBkU7dxBNG6SCfCTBRnv7pN4aYGqdxegs9wI0G8dLBUTxEk5aNeubRMTmlOYEsgE/5cHku6FJU9zh/maG9E2Z9B+5++xq6ZjgMKmkJYCmMgt5Ll56ommAl4GbplM+gvnq7y5NYxcMAotOUnuut9exJWhEA61ufpA6gmCHVJc88lG9aPXA8lcpW7zWopEb3sC8qu+L8LwlsTMguG9zEzUMFg3F7O1lE9CLtXMjoaGlVBKSqABTydsPWxiJrSdE27JFNA2vGz+Gu8XM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(76116006)(52536014)(5660300002)(86362001)(7696005)(54906003)(83380400001)(8936002)(110136005)(316002)(2906002)(8676002)(4326008)(53546011)(6506007)(4744005)(33656002)(55016002)(26005)(186003)(478600001)(9686003)(66476007)(71200400001)(66446008)(66946007)(64756008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 3pgQMJ832phaox/sC6YUNx3Y89/RZCpwvcCjYHaG5taC0IUFYGn5KjARDiUQSx6Suh4C1doj4WyFgfAHU+oVUexWy5spwsbi10fVZQxnpIsyTloS4t47deSoqg2YJADAAnnNy7dUO5ZojXx+WYw69Kgghp830T7zJAnNU6BEIAhVxrxsBBMy1zx4+5umc2qG1v2Bo0yoQstbA95Z/CypXWbjsVcZ9nFAPMZVZj1H2mT5RRsQnijxVEz3P+ByCJzOeHtV23b4WHbCiO/rCly470YBZvIxPmIcz7k9uspw9u3kKCejvSWSVJKW5cuU7Vhmli9qg6aFaZJlefNneLMlOYnRQ2DUYh3bnhYCneLdxc+2dybVNoE6YI80HHEAZDeQmkzLUl5pJOQ/rn1pDEUTb8lQaQW7o7paNDynppODG46TSYHE9NGZsE6M0z4zAO5x4Mhw/r9qJBXeWq/H4sscxRjXhFlrQx+S/jkPF9QJ1raWW9xSQ40V+0SnY5j52aOWiC25KKpuQZlTNHBDZHH9oCL9gkI1hk6SBMO8v7KUey3fv/yhFceqSdhqN8uzlv1nI6bpiEgZaVq1f9XZ3VT7x7BRnK9AZbA4CdnzNeC49PAD4zR7ZA6uJ8pBlMe2C4i3a9HXzSkOvqkLlLflc5aSmA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a4a6b48-d8be-425d-1eab-08d869142f9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2020 09:51:09.0273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9djiUv7p9x+1ASuApIlDhGZoVHzQdwSTH6whX0k6Huyu6ua3QXH9pAIGF2MLqa0AC5glgJMk0n50WwRLole7hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4087
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gDQo+IE9uIDUvMTAvMjAgMTE6MDIgYW0sIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+IEhJ
LA0KPiA+DQo+ID4+IERyaXZlcnMgdGhhdCB3aXNoIHRvIHN1cHBvcnQgRGVlcFNsZWVwIG5lZWQg
dG8gc2V0IGEgbmV3IGNhcGFiaWxpdHkgZmxhZw0KPiA+PiBVRlNIQ0RfQ0FQX0RFRVBTTEVFUCBh
bmQgcHJvdmlkZSBhIGhhcmR3YXJlIHJlc2V0IHZpYSB0aGUgZXhpc3RpbmcNCj4gPj4gIC0+ZGV2
aWNlX3Jlc2V0KCkgY2FsbGJhY2suDQo+ID4gSSB3b3VsZCBleHBlY3QgdGhhdCB0aGlzIGNhcGFi
aWxpdHkgY29udHJvbHMgc2VuZGluZyBTU1UgNCwgYnV0IGl0IG9ubHkgY29udHJvbHMNCj4gdGhl
IHN5c2ZzIGVudHJ5Pw0KPiANCj4gVGhlIHN5c2ZzIGVudHJ5IGlzIHRoZSBvbmx5IHdheSB0byBy
ZXF1ZXN0IERlZXBTbGVlcC4NClNvbWUgY2hpcHNldCB2ZW5kb3JzIHVzZSB0aGVpciBvd24gbW9k
dWxlcywgb3IgZXZlbiB0aGUgZGV2aWNlIHRyZWUNCnRvIHNldCB0aGVpciBkZWZhdWx0IHJwbV9s
dmwgLyBzcG1fbHZsLg0KDQpUaGFua3MsDQpBdnJpDQo=
