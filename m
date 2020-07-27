Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 632B1C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 10:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37A0C2070B
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 10:12:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rqqr0LRR";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="yEr/LvWu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgG0KMV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 06:12:21 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:14198 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgG0KMU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 06:12:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595844739; x=1627380739;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=3RsctufzmRv0aqbEhEXdsukbA7K00O1yq5cWG9nzOf0=;
  b=rqqr0LRRTDJRZqfSrHoFU8G+CMPkpIhrUjc0h8oyKd9gAkPxscvUSu0I
   s8eyV1Z3AQSbQFg61EvCREs2LClEmci1r6qVcncDuEHx1E9UxCzRuCIWh
   UP12zLB95Q+8gdW2ZXJWdyRWI5JWrDMDsti5W3bRw+Q1fpcsn0KFeQFEM
   trFQXWk5Umhp1nl9HRRsa2hvTUIQX2GBPS91mkA6UzeAWATSr75MAk0Rx
   HWE8TXi3OdbPqSxL0dUJghhr/to8oUJdAnxf9F4t8RxQsoCMi8GymkoR4
   On06+H48klrYmmuIAofXLVnXbDFQIFl7COP7mnUVrlT4NC9vvVd/CbRc1
   g==;
IronPort-SDR: Zi7Ljr8KG/L9KZvnys9qRLLs4EDP5F3wF3mpEtJs8HhYA0epHFcE9Bi4jM07N83DfOEs53oWzr
 k3argh1bxe+K9MaYqp7OfcqJM6LUv3XD5f84tPNzAHpNM1Fp3x3uVBJ9WGzWSkHQHc6CmEeE9R
 iTiB14lJSicDMvGoWiFMkYmxyBCI2l8NtaAdv/S2XKOPZOkmHI/VoIucbphN4JcQC6SVgjPuN+
 +5GiryGczdJZEOCB/FMuLIW7BC+UMaJD1bwBMBRIp2t6D9GmMU1T0TWFTRItRTwknMdxlggbXg
 Hfs=
X-IronPort-AV: E=Sophos;i="5.75,402,1589212800"; 
   d="scan'208";a="144717041"
Received: from mail-mw2nam12lp2047.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.47])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2020 18:12:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Asi/l5BCf15YiygAFecWlPHcpbf3mtpb6wg5OuyRyvj8qLCSyKYlTDqugV0gusBMoHRdc4GNj5oIqp0f3BZJyGdmT6kD1OQTe7H3l5Vjt6YrG7i/Fn+irdCrJao87RE83+MV2QY+2JvsXaOTjk9EbWH85Q7qjd76VHtNexNr+VgJbGGyx1cW7+76aWsgML1SSDPRVBA7WhQ33cGwfuuYdEo4R9bgXKrHkP5JSjC50x40G4wbK2fK6opswHSYDnSEUTXbQ+FVCFyUkgLPRNsx1u1F1So7rkuM34oTYAzVyz+a2Ntz/3Fx4W6NCX6Et+BbUhvZ0QK8oVdLIletWP64LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RsctufzmRv0aqbEhEXdsukbA7K00O1yq5cWG9nzOf0=;
 b=MrjkK9Oxc7UbtmyV4Tt3T8TPVjr/qjF6iAjHhs7PU0twL15nw/MINHM7oNfUfhhq7KGkHla+mbQdSz8EAqZ8CZmEV/u93vI9N08A2bVSHUrj/Myt77boHTLs4y6RlNm+luseAtE9dtWLgMB0SFNsTy3tO7ZrbjtGJnxFEjo5LNvM0Z+risjONjWSStNqQ/QYwYJMbTNIY47A7ijOM0UV9oyQVOEArpv3+Bf90bGmfbZVDl7tw7j5AgJL6hvbQBlw6pvj9sgsXgKW4wuxlSVF5rd/p9DA8a+GXTdkqvYylYcLP55DaJm1HQ5q8QD8UYuyDSSKH/ivAPKf/AcSXttd7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RsctufzmRv0aqbEhEXdsukbA7K00O1yq5cWG9nzOf0=;
 b=yEr/LvWulkKPzVewt9YOs7wjfjsrWTrzPXr0wwAjAcegmR5hWw+Fbk081vN3M5z+QpkrH3OoO9qlBP/ZdaXOgWQgzXIvDDS1E6lBaYX703TFuBDN7Fib1lsB8GBSOgqmsT7D4eMt2OLZWTZ4rN5kRrY9nrwoyS7jAzMwvGIBvAQ=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4192.namprd04.prod.outlook.com (2603:10b6:805:3a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Mon, 27 Jul
 2020 10:12:16 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 10:12:16 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     =?utf-8?B?7ISc7Zi47JiB?= <hy50.seo@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>
Subject: RE: [RFC PATCH v3 2/3] scsi: ufs: modify function call name When ufs
 reset and restore, need to disable write booster
Thread-Topic: [RFC PATCH v3 2/3] scsi: ufs: modify function call name When ufs
 reset and restore, need to disable write booster
Thread-Index: AQHWX0VJqBHPLYVB10GjzhrbXFF0QKkZbgDAgAHNYoCAAAKckA==
Date:   Mon, 27 Jul 2020 10:12:16 +0000
Message-ID: <SN6PR04MB4640B30915D3D402B3B47F79FC720@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <cover.1595325064.git.hy50.seo@samsung.com>
        <CGME20200721095653epcas2p4575db5cbcd8897662ad19465339128b2@epcas2p4.samsung.com>
        <52e4453499a65ad276df5af9a0f057e960704f93.1595325064.git.hy50.seo@samsung.com>
        <SN6PR04MB4640E7CB5A7F2E406323CFBAFC750@SN6PR04MB4640.namprd04.prod.outlook.com>
 <071e01d663fc$f6bce010$e436a030$@samsung.com>
In-Reply-To: <071e01d663fc$f6bce010$e436a030$@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 379c1bca-9d1c-4202-a95b-08d832158a0b
x-ms-traffictypediagnostic: SN6PR04MB4192:
x-microsoft-antispam-prvs: <SN6PR04MB41920E0202857FEA8F9EADDFFC720@SN6PR04MB4192.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SHNCYWK4pZqGLy8b2d7AU370Qq/zcz80kLsI9WESNGYqmNRSuZy0YjIbpXi668umUc+yGq19iMdzclBCy5DW/oY2y74Pnhm/EG4q+1MiCjll5eeqUEBK2xlSLHde3b8j45G3KMGUw88vLEH46wIeTmlErceWXWwywkTT4uM/O3KjLzR5Zx8FstnMLwFZljTFsHs9lajE7DNTjpPkp7+IO31/Z14grFti4EksYgcGlJwL4Ui1RfwKtO6FVNz9LIdG8QczcIKnw7IK3bJLNb4j/CBNdbYNGKeaxsrdtcK4RMRJs3FgFuIu0rSIFZUMuzTQ7flnidWhcBtLtmHj2VE/kSmtw2iNbZKZMsvJsofugSkxEGJRPLRyjxPzxacv8BkE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(366004)(136003)(396003)(376002)(316002)(55016002)(8936002)(83380400001)(8676002)(2906002)(6506007)(5660300002)(7416002)(186003)(33656002)(71200400001)(9686003)(7696005)(26005)(76116006)(66446008)(64756008)(66556008)(66476007)(86362001)(66946007)(110136005)(478600001)(4744005)(52536014)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: H6RgbFD1/13zMj/b+8KWNNIdfmaarfrT9LQ8JJJG4pwBc7VfJIUJqJaOB1VxmsMDhrDqly7r1mzxePazDTQDfeIMQ+yti7QmEu6oGIACQeZ25tlCjuYhnwUhHHjCqSTriC2cBEbgCQl3FLHSoYD9GoT5wib4EEuI88ek2nXPuzESC0GlarAg1BMb6cxSwn0cYE+sanBsAtibcQB7X3vwftHsVRmOP3Dn4b1ThFjqftP4I+3I4g1rGxkoN9RLhKIW+Xn5wDNcYiXLjRDjOZ2GiaHq46LrTisP0tUO6JztZPGu41QTfJg9rCst3m4Xc/zbW11MP8eVzzScLwvK+owK9JIQrE9QrGmv4l7hZVio0vSx470do4q+7epN1Wi+8fNIwAIkfGweo7KQ+aWlmyl+oK5LEk/CP4Edi0aWnLQHHJVs2uDao2bt9KjdwMDKW9YoeUNw80eLMoMwid4bS86eCIrPvRvTo5SSVnigDu87xouI2Z0TNeMHYpwgoIu0uFzd
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 379c1bca-9d1c-4202-a95b-08d832158a0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2020 10:12:16.3607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TaHh8cGJkCVhedNr8ifAhuBdN56B0QRefcCBovB6aOd+l7afSEfUq7B1g2SrvyJ/HpCPJbvsMRrsi0ijfxLjdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4192
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gPiBUaGlzIHBhdGNoIGlzIG5vdCByZWFsbHkgbmVlZGVkIC0ganVzdCBzcXVhc2gg
aXQgdG8gdGhlIHByZXZpb3VzIG9uZS4NCj4gV2h5IHlvdSBzYWlkIHRoaXMgcGF0Y2ggaXMgbm90
IHJlYWxseSBuZWVkZWQ/DQo+IEkgZG9uJ3QgdW5kZXJzdGFuZA0KPiBPdXIgV0IgZGV2aWNlIG5l
ZWQgdG8gZGlzYWJsZSBXQiB3aGVuIGNhbGxlZCB1ZnNoY2RfcmVzZXRfYW5kX3Jlc3RvcmUoKQ0K
PiBmdW5jLg0KPiBQbGVhc2UgZXhwbGFpbiByZWFzb24uDQpUaGlzIHBhdGNoIG9ubHkgY2hhbmdl
IHRoZSBuYW1lcyBvZiBzb21lIGZ1bmN0aW9ucyBkZWZpbmVkIGluIHRoZSBmaXJzdCBwYXRjaC4N
ClNxdWFzaCBpdCB0byB0aGUgZmlyc3Qgb25lLg0K
