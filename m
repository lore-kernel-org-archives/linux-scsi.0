Return-Path: <SRS0=Zq1p=ZJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8022C432C0
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Nov 2019 16:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0DE520715
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Nov 2019 16:36:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="r1jodTxL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbfKQQgk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Nov 2019 11:36:40 -0500
Received: from mail-eopbgr700043.outbound.protection.outlook.com ([40.107.70.43]:38240
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726116AbfKQQgk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 17 Nov 2019 11:36:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTvWYrLz14zLeu0Jmwk4QphqBcKZN4S8z3d0zzNgn5ZJZ9s6uVn+lqce5rb5J0nOkQXkfzA+OvEPvmb83c6shUppaQ32NsWk+1K9OBVzHz5Lh6+aBtsRf4Aut8568e3rR95gnuKIxxQ6OEhl9cTK/a7CErRH6ides8YAWUikCU2WIZcw1i2S7tY5iSUHpchzqE0wpZk49qsNro16BVdTCDPKf94FVDEXdPr2aAgQq81pMdEptWxnvu3lmT9aTBWZoJAI+elRqEPUwZ03BMWY08j4e+rHU7pgwfF0Rzm5tkShHDUyEkfkH/28ImSrd2615dngzZwwEB022u8VkLGKCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLfRBAWq0ehulU/lqnWiuUQVMS8Z1gLNpWFSOfS2I+E=;
 b=BWSsBhPz5JhkVJSpVEmS+ruO6j3qnsHaO1fh99Oz1b7M8MVnfTtB4lUaoWaCa2qBbWJWXc1WYnwHguibBasELBYOOCZ+xsXwiAjalX7BGrAnjLjgfS89/RV0u7FPrd5HJvUIw0T9oy+d0kTJ2x+gL2Q3363fgGyMIv6j5ynL4nGTOVgLeZJDit4wMNn3agnCjnP5WzSKJPamM2kDQzpFMMrKRYjJbkaU1HVA7GsADGBql6yLSua1ji9SXz1/N++RO6S7+zvDVOhoueKuzjm5RrjaLRvUlH+CRfeNO/xaTkdzom/bez4H4wVWznRRSXxUEQPASXLMwWuKOFxvXiduBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLfRBAWq0ehulU/lqnWiuUQVMS8Z1gLNpWFSOfS2I+E=;
 b=r1jodTxLImS2fAH6clce6upezAX88SRUa8kKweFgroYaBYvDkBnsYDA2VrKgg8Piply6uXYfxRIKwETlSuzEb6z2vD63+7LmBqwsmkzW7zwTPgGr7ngMnQ+6eQFkrBfre9hyznGOoJDvvvUIWy3k706GNQVT3/0fPThNnEOAF3k=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB3907.namprd08.prod.outlook.com (52.132.219.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Sun, 17 Nov 2019 16:36:36 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2451.029; Sun, 17 Nov 2019
 16:36:36 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Subhash Jadavani <subhashj@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v5 7/7] scsi: ufs: Fix error handing during hibern8
 enter
Thread-Topic: [EXT] [PATCH v5 7/7] scsi: ufs: Fix error handing during hibern8
 enter
Thread-Index: AQHVm3tmkWEP8THuoky1/8WZU0+PB6ePkwVA
Date:   Sun, 17 Nov 2019 16:36:36 +0000
Message-ID: <BN7PR08MB5684FD70384DD9F0BCEAA969DB720@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1573798172-20534-1-git-send-email-cang@codeaurora.org>
 <1573798172-20534-8-git-send-email-cang@codeaurora.org>
In-Reply-To: <1573798172-20534-8-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTY5MzFmMDRhLTA5NTgtMTFlYS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw2OTMxZjA0Yy0wOTU4LTExZWEtOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjI1NyIgdD0iMTMyMTg0ODIxOTI1MTU2NTQ0IiBoPSJoSzYxVGNCWFcvQ1o5Z2htdFRpRTdUNTdtOVE9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [195.89.176.137]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e02a0fc9-c0f5-4020-ee8b-08d76b7c5073
x-ms-traffictypediagnostic: BN7PR08MB3907:|BN7PR08MB3907:|BN7PR08MB3907:
x-microsoft-antispam-prvs: <BN7PR08MB390771456F405BB0713D6BF4DB720@BN7PR08MB3907.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 02243C58C6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(189003)(199004)(3846002)(558084003)(99286004)(74316002)(7736002)(305945005)(76116006)(6116002)(71200400001)(316002)(110136005)(54906003)(66066001)(86362001)(52536014)(14454004)(7416002)(2201001)(26005)(25786009)(186003)(2501003)(6246003)(33656002)(256004)(229853002)(4326008)(478600001)(486006)(8936002)(81166006)(8676002)(66476007)(55016002)(66556008)(64756008)(66446008)(71190400001)(81156014)(476003)(7696005)(6436002)(11346002)(5660300002)(66946007)(446003)(6506007)(2906002)(76176011)(102836004)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB3907;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xzXsJJX9KHzxEHWN9ebuYfbJnG5LVF8wP733pHTvioILlhBtvlS867d2nwB2cMpuPza/fvqljzpHT79Ydrk9A09yYLNfa1KfJSjaANlBuUa8Jge5AqMJdogU/A3xPVRGkTYp9TRraJAeZ6Wl0AS6rzmG/krEiWFLbdc7j3CpT12yQtMD+ilNNzhP71lYKFwR39/8+csv2y06kJOFcZORI8UsHgtb+3Qoxst2n9G1sPH8S4Zjg6OosL6u6uUQCI+xfKs/Ph8mnoINT6TjyUg1kRvh+VB/yadYt/w7AxS0Qn+GW6mc9cTN6QBaB9xQtFSuv402e7eemtIjicyKZblMrnmKjP8J/t/quB6onULemGNCDTA6t3fBFX6rVHcXVeP0BPMMt24TWPMcfA/GuO1zu2P1Fwh+aLOiFPzn5aV4H2xv+xDlqWUL8YMkm9YJpNSy
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e02a0fc9-c0f5-4020-ee8b-08d76b7c5073
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2019 16:36:36.4427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HInNs6rJHaoYhm7bPqQ8t9SFiY1jly48nt8dVK7lQ5tupBxnZvSpl2u64uh5s2xN9NGx9q45jWyKvP49svoE/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB3907
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBTaWduZWQtb2ZmLWJ5OiBTdWJoYXNoIEphZGF2YW5pIDxzdWJoYXNoakBjb2RlYXVyb3JhLm9y
Zz4NCj4gU2lnbmVkLW9mZi1ieTogQ2FuIEd1byA8Y2FuZ0Bjb2RlYXVyb3JhLm9yZz4NClJldmll
d2VkLWJ5OiBCZWFuIEh1byA8YmVhbmh1b0BtaWNyb24uY29tPg0K
