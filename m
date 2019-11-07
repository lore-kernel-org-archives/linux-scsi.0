Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDBE8C43331
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 17:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BF9A2084D
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 17:45:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="D8eIgrQV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730110AbfKGRpQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 12:45:16 -0500
Received: from mail-eopbgr770045.outbound.protection.outlook.com ([40.107.77.45]:48899
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727132AbfKGRpP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Nov 2019 12:45:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SfzD8vsVl35mzR+CtbDEPd6xfV5TFjbTaxDBV/3UQavl8AdH37k4dlOGOd9jaxHDA5lOxqgHH9TnKolIbsJ8P5aHt+ODOqVANd+W/tBmI1xT8ojX9V5kT5DazTFO0TKAvosU6zlx5ahjggQEgoQ6o7SsjgGDe+2oV0BqFU+j3HZVMfskpZDOTSJHZmAkXdAcQL8HriScFS0TPt6EOSB7bKwFjeWmPgAJ4I6JT3uKu1g0oPHLHTilZPY55jLT1jTMRRyR3l5r2lm2vFXDGjem0Si8le0u5hlA0zOIhuy0jgzhZqIW04faHqsX4SKgi7jCSgR0SvsleYZQ05If2tQJCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UbCLjbTZA8HKT4Vq7UF0YD0XjdzCdxllomTW6cERv0w=;
 b=VIRFW/5t7pQ+tHx5p2EDNn0p1Br8Hi7JPWR/Fvh/FPvihj3mMfZAVw8hq0QOJ4jWPH/hBuKN2emVjSBwj4S4u4ePQszocDFBEzZuqOF3Ev29xxWVSKCjTspG0QRBOyxcL991LrZAbquhWwAEO1DnrxnspE4EcTlyZRN0QGiJvy3gMxN6gMOf5l4VeESEOxhVDXEITjNGsn5o9LXCUeinkHL6J2NG7PbAvqBcmNdW8MRYUHiHDiZ5gGyK+aobQRAHv31gSZUr9+rdjCXtf1Op9VEswImxvwXz1zKbRxVVxFEHDlmcrBLEiRYLeWD2Eg3/DGeviJ3eTtoIwbMiAPwKzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UbCLjbTZA8HKT4Vq7UF0YD0XjdzCdxllomTW6cERv0w=;
 b=D8eIgrQVIsGvGdtziekbkY269sIiFs5ThNrNRxlLN69XZ9HaqNwjbYYEzuDAGIJ9/lItrausZL7VPh+HowL3EGOpXUL7Jyudfy74Gp7uNLQrJpX4KeXvFnD3+y7UAMd7CSfVnoIuuAAbiJJYT2qnZ6IegSFFEAfNJhU5wANDftE=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB3969.namprd08.prod.outlook.com (52.132.7.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Thu, 7 Nov 2019 17:45:10 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 17:45:10 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: RE: [EXT] [PATCH RFC v3 1/3] ufs: Avoid busy-waiting by eliminating
 tag conflicts
Thread-Topic: [EXT] [PATCH RFC v3 1/3] ufs: Avoid busy-waiting by eliminating
 tag conflicts
Thread-Index: AQHVlD5ynASFqKwKU0KcZftdEmcm+6d/+lmw
Date:   Thu, 7 Nov 2019 17:45:10 +0000
Message-ID: <BN7PR08MB5684850F31588AAF679F6B23DB780@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20191106010628.98180-1-bvanassche@acm.org>
 <20191106010628.98180-2-bvanassche@acm.org>
In-Reply-To: <20191106010628.98180-2-bvanassche@acm.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTU2NTRkNmM0LTAxODYtMTFlYS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw1NjU0ZDZjNS0wMTg2LTExZWEtOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjgxMDMiIHQ9IjEzMjE3NjIyMzA4NDI5NzQ4NSIgaD0iWXpCUXFtcDV2ZStGdWJqSW0rSjQ4eCs0ckdrPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 13acd614-b0f6-41e8-e993-08d763aa3c66
x-ms-traffictypediagnostic: BN7PR08MB3969:|BN7PR08MB3969:|BN7PR08MB3969:
x-microsoft-antispam-prvs: <BN7PR08MB39699AF4BC1EA9E9F5B97E60DB780@BN7PR08MB3969.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:820;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(366004)(39860400002)(346002)(189003)(199004)(64756008)(305945005)(86362001)(8936002)(33656002)(81166006)(5660300002)(52536014)(54906003)(3846002)(71200400001)(8676002)(66946007)(76116006)(14454004)(316002)(4326008)(6116002)(110136005)(66556008)(229853002)(66446008)(66476007)(71190400001)(55236004)(256004)(6436002)(11346002)(186003)(446003)(486006)(81156014)(6246003)(99286004)(55016002)(66066001)(476003)(2906002)(26005)(76176011)(25786009)(74316002)(6506007)(7736002)(102836004)(478600001)(9686003)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB3969;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kfZ+1Sgl5I6uiDbjGHo58gYlP0St+MTU8ZqJ1yH6FKTTFcLC6wJdLhTd/l1W+HdQmmCt8qp2YVgjWbu+sQWRDTKtnYjddPMs7mfzorPIe9WQzQTKbgqnK2HwML9Cop/Li+2AdFAI1jWzLUAjrYSBrY6tr13NKX/KCwFNHAU98HhalbUWg3WE2NswqGDzTfT84/quHo8t7NwzmZVXNH/2sWbu9bGS8vM4Q1fiSVmGhbeV1B/Rex6sLhOEvGBg3UpiFygS3HYFLIYRWwyFF3vqM+KSWAs/pV1q4l74WJUTt/Y/RjlNDoZl7zd/mw5tTrY+bjJj823eBpPPfq2BxA3DgcX9rcG6rt/7/dPzNI3TkFOmkVpu3GjC3skXX3nwBEQlnOhIBhVCXLlDsHIF5GHBOQoXCGXxVtPYpwNVemV8JPAFMB1zQ2g/Zj/gb+VxRFzO
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13acd614-b0f6-41e8-e993-08d763aa3c66
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 17:45:10.2442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yNkhfz5Ohc3VPTvrC0kTRwE34djpx82BkHO1nRcOmKIjmvzWGVfO2C28Fo8awdzad4F6ysE5ZVGATkQCZFcf1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB3969
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Bart
I tested it on my platform, no problem found.

Tested-by: Bean Huo <beanhuo@micron.com>

Below is log shows you the tags assignment:
=20
313.828168: ufshcd_command: send: ff3b0000.ufs: tag: 0, DB: 0x1, size: 8192=
, IS: 0, LBA: 2880752, opcode: 0x2a
313.828183: ufshcd_command: send: ff3b0000.ufs: tag: 1, DB: 0x3, size: 8192=
, IS: 0, LBA: 2880768, opcode: 0x2a
313.828194: ufshcd_command: send: ff3b0000.ufs: tag: 2, DB: 0x7, size: 8192=
, IS: 0, LBA: 2880784, opcode: 0x2a
313.828206: ufshcd_command: send: ff3b0000.ufs: tag: 3, DB: 0xf, size: 8192=
, IS: 0, LBA: 2880800, opcode: 0x2a
313.828218: ufshcd_command: send: ff3b0000.ufs: tag: 4, DB: 0x1f, size: 819=
2, IS: 0, LBA: 2880816, opcode: 0x2a
313.828228: ufshcd_command: send: ff3b0000.ufs: tag: 5, DB: 0x3f, size: 409=
6, IS: 0, LBA: 2880832, opcode: 0x2a
313.829654: ufshcd_command: send: ff3b0000.ufs: tag: 6, DB: 0x40, size: -1,=
 IS: 0, LBA: 18446744073709551615, opcode: 0x35
313.830324: ufshcd_command: send: ff3b0000.ufs: tag: 7, DB: 0x80, size: 409=
6, IS: 0, LBA: 2880840, opcode: 0x2a
317.713874: ufshcd_command: send: ff3b0000.ufs: tag: 14, DB: 0x4000, size: =
4096, IS: 0, LBA: 11976872, opcode: 0x28
317.755322: ufshcd_command: send: ff3b0000.ufs: tag: 15, DB: 0x8000, size: =
4096, IS: 0, LBA: 11976744, opcode: 0x28
317.756758: ufshcd_command: send: ff3b0000.ufs: tag: 8, DB: 0x100, size: 40=
96, IS: 0, LBA: 11976752, opcode: 0x28
317.758389: ufshcd_command: send: ff3b0000.ufs: tag: 9, DB: 0x200, size: 81=
92, IS: 0, LBA: 12239872, opcode: 0x2a
317.758396: ufshcd_command: send: ff3b0000.ufs: tag: 10, DB: 0x600, size: 8=
192, IS: 0, LBA: 12239888, opcode: 0x2a
317.758402: ufshcd_command: send: ff3b0000.ufs: tag: 11, DB: 0xe00, size: 8=
192, IS: 0, LBA: 12239904, opcode: 0x2a
317.758406: ufshcd_command: send: ff3b0000.ufs: tag: 12, DB: 0x1e00, size: =
8192, IS: 0, LBA: 12239920, opcode: 0x2a
317.758411: ufshcd_command: send: ff3b0000.ufs: tag: 13, DB: 0x3e00, size: =
8192, IS: 0, LBA: 12239936, opcode: 0x2a
317.758415: ufshcd_command: send: ff3b0000.ufs: tag: 14, DB: 0x7e00, size: =
8192, IS: 0, LBA: 12239952, opcode: 0x2a
317.758420: ufshcd_command: send: ff3b0000.ufs: tag: 15, DB: 0xfe00, size: =
8192, IS: 0, LBA: 12239968, opcode: 0x2a
317.758426: ufshcd_command: send: ff3b0000.ufs: tag: 8, DB: 0xff00, size: 8=
192, IS: 0, LBA: 12239984, opcode: 0x2a
317.758431: ufshcd_command: send: ff3b0000.ufs: tag: 16, DB: 0x1ff00, size:=
 8192, IS: 0, LBA: 12240000, opcode: 0x2a
317.758436: ufshcd_command: send: ff3b0000.ufs: tag: 17, DB: 0x3ff00, size:=
 8192, IS: 0, LBA: 12240016, opcode: 0x2a
317.758441: ufshcd_command: send: ff3b0000.ufs: tag: 18, DB: 0x7ff00, size:=
 8192, IS: 0, LBA: 12240032, opcode: 0x2a
317.758446: ufshcd_command: send: ff3b0000.ufs: tag: 19, DB: 0xfff00, size:=
 8192, IS: 0, LBA: 12240048, opcode: 0x2a
317.758451: ufshcd_command: send: ff3b0000.ufs: tag: 20, DB: 0x1fff00, size=
: 8192, IS: 0, LBA: 12240064, opcode: 0x2a
317.758455: ufshcd_command: send: ff3b0000.ufs: tag: 21, DB: 0x3fff00, size=
: 8192, IS: 0, LBA: 12240080, opcode: 0x2a
317.758461: ufshcd_command: send: ff3b0000.ufs: tag: 22, DB: 0x7fff00, size=
: 8192, IS: 0, LBA: 12240096, opcode: 0x2a
317.758466: ufshcd_command: send: ff3b0000.ufs: tag: 23, DB: 0xffff00, size=
: 8192, IS: 0, LBA: 12240112, opcode: 0x2a
317.758834: ufshcd_command: send: ff3b0000.ufs: tag: 9, DB: 0xff8300, size:=
 8192, IS: 0, LBA: 12240128, opcode: 0x2a
317.758840: ufshcd_command: send: ff3b0000.ufs: tag: 10, DB: 0xff8700, size=
: 8192, IS: 0, LBA: 12240144, opcode: 0x2a
317.758891: ufshcd_command: send: ff3b0000.ufs: tag: 11, DB: 0xfc0e00, size=
: 8192, IS: 0, LBA: 12240160, opcode: 0x2a
317.758918: ufshcd_command: send: ff3b0000.ufs: tag: 16, DB: 0xf90e00, size=
: 8192, IS: 0, LBA: 12240176, opcode: 0x2a
317.758925: ufshcd_command: send: ff3b0000.ufs: tag: 17, DB: 0xfb0e00, size=
: 8192, IS: 0, LBA: 12240192, opcode: 0x2a
317.758937: ufshcd_command: send: ff3b0000.ufs: tag: 18, DB: 0xe70e00, size=
: 8192, IS: 1, LBA: 12240208, opcode: 0x2a
317.758957: ufshcd_command: send: ff3b0000.ufs: tag: 19, DB: 0xcf0e00, size=
: 8192, IS: 0, LBA: 12240224, opcode: 0x2a
317.758964: ufshcd_command: send: ff3b0000.ufs: tag: 20, DB: 0x9f0e00, size=
: 8192, IS: 1, LBA: 12240240, opcode: 0x2a
317.758978: ufshcd_command: send: ff3b0000.ufs: tag: 21, DB: 0xbf0e00, size=
: 8192, IS: 0, LBA: 12240256, opcode: 0x2a
317.758984: ufshcd_command: send: ff3b0000.ufs: tag: 22, DB: 0xff0e00, size=
: 8192, IS: 0, LBA: 12240272, opcode: 0x2a
317.758993: ufshcd_command: send: ff3b0000.ufs: tag: 24, DB: 0x1ff0e00, siz=
e: 8192, IS: 0, LBA: 12240288, opcode: 0x2a
317.759000: ufshcd_command: send: ff3b0000.ufs: tag: 25, DB: 0x3ff0e00, siz=
e: 8192, IS: 0, LBA: 12240304, opcode: 0x2a
317.759005: ufshcd_command: send: ff3b0000.ufs: tag: 26, DB: 0x7ff0e00, siz=
e: 8192, IS: 0, LBA: 12240320, opcode: 0x2a
317.759011: ufshcd_command: send: ff3b0000.ufs: tag: 27, DB: 0xf7f0e00, siz=
e: 8192, IS: 1, LBA: 12240336, opcode: 0x2a
317.759044: ufshcd_command: send: ff3b0000.ufs: tag: 28, DB: 0x1f7f0000, si=
ze: 8192, IS: 1, LBA: 12240352, opcode: 0x2a
317.759058: ufshcd_command: send: ff3b0000.ufs: tag: 12, DB: 0x1f7f1000, si=
ze: 8192, IS: 0, LBA: 12240368, opcode: 0x2a
317.759063: ufshcd_command: send: ff3b0000.ufs: tag: 13, DB: 0x1f7f3000, si=
ze: 8192, IS: 0, LBA: 12240384, opcode: 0x2a
317.759068: ufshcd_command: send: ff3b0000.ufs: tag: 14, DB: 0x1f7f7000, si=
ze: 8192, IS: 0, LBA: 12262400, opcode: 0x2a
317.759074: ufshcd_command: send: ff3b0000.ufs: tag: 8, DB: 0x1f7e7100, siz=
e: 8192, IS: 1, LBA: 12262416, opcode: 0x2a
317.759104: ufshcd_command: send: ff3b0000.ufs: tag: 16, DB: 0x1f797100, si=
ze: 8192, IS: 0, LBA: 12262432, opcode: 0x2a
317.759109: ufshcd_command: send: ff3b0000.ufs: tag: 17, DB: 0x1f737100, si=
ze: 8192, IS: 1, LBA: 12262448, opcode: 0x2a
317.759131: ufshcd_command: send: ff3b0000.ufs: tag: 18, DB: 0x1f677100, si=
ze: 8192, IS: 0, LBA: 12262464, opcode: 0x2a
317.759143: ufshcd_command: send: ff3b0000.ufs: tag: 23, DB: 0x1fe77100, si=
ze: 8192, IS: 0, LBA: 12262480, opcode: 0x2a
317.759149: ufshcd_command: send: ff3b0000.ufs: tag: 19, DB: 0x1fef7100, si=
ze: 8192, IS: 0, LBA: 12262496, opcode: 0x2a
317.759207: ufshcd_command: send: ff3b0000.ufs: tag: 20, DB: 0x1f9f7100, si=
ze: 8192, IS: 0, LBA: 12262512, opcode: 0x2a
317.759214: ufshcd_command: send: ff3b0000.ufs: tag: 21, DB: 0x1ebf7100, si=
ze: 8192, IS: 1, LBA: 12262528, opcode: 0x2a
317.759245: ufshcd_command: send: ff3b0000.ufs: tag: 9, DB: 0x18bf7300, siz=
e: 8192, IS: 0, LBA: 12262544, opcode: 0x2a
317.759247: ufshcd_command: send: ff3b0000.ufs: tag: 29, DB: 0x38bf7300, si=
ze: 8192, IS: 0, LBA: 12262576, opcode: 0x2a
317.759251: ufshcd_command: send: ff3b0000.ufs: tag: 10, DB: 0x38bf7700, si=
ze: 8192, IS: 0, LBA: 12262560, opcode: 0x2a
317.759276: ufshcd_command: send: ff3b0000.ufs: tag: 30, DB: 0x60bf7700, si=
ze: 8192, IS: 1, LBA: 12262624, opcode: 0x2a
317.759304: ufshcd_command: send: ff3b0000.ufs: tag: 31, DB: 0xe0bf4700, si=
ze: 8192, IS: 0, LBA: 12262608, opcode: 0x2a
317.759308: ufshcd_command: send: ff3b0000.ufs: tag: 11, DB: 0xe0bf4f00, si=
ze: 8192, IS: 0, LBA: 12262592, opcode: 0x2a
317.759314: ufshcd_command: send: ff3b0000.ufs: tag: 15, DB: 0xe0bf8f00, si=
ze: 8192, IS: 1, LBA: 12262640, opcode: 0x2a
317.759361: ufshcd_command: send: ff3b0000.ufs: tag: 12, DB: 0xe0bc9e00, si=
ze: 8192, IS: 0, LBA: 12262656, opcode: 0x2a
317.759378: ufshcd_command: send: ff3b0000.ufs: tag: 22, DB: 0xe0f89e00, si=
ze: 8192, IS: 1, LBA: 12262688, opcode: 0x2a
317.759393: ufshcd_command: send: ff3b0000.ufs: tag: 16, DB: 0xe0f99e00, si=
ze: 8192, IS: 0, LBA: 12262704, opcode: 0x2a
317.759399: ufshcd_command: send: ff3b0000.ufs: tag: 17, DB: 0xe07b9e00, si=
ze: 8192, IS: 1, LBA: 12262720, opcode: 0x2a
317.759414: ufshcd_command: send: ff3b0000.ufs: tag: 18, DB: 0xe07f9e00, si=
ze: 8192, IS: 0, LBA: 12262736, opcode: 0x2a
317.759420: ufshcd_command: send: ff3b0000.ufs: tag: 23, DB: 0xe0ff9e00, si=
ze: 8192, IS: 0, LBA: 12262752, opcode: 0x2a

//Bean
