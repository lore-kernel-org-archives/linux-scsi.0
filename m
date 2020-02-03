Return-Path: <SRS0=0hmW=3X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C8EC35247
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 22:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6928620674
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 22:14:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="YcgGWmjx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgBCWO0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Feb 2020 17:14:26 -0500
Received: from mail-co1nam11on2057.outbound.protection.outlook.com ([40.107.220.57]:11776
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726278AbgBCWOZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 Feb 2020 17:14:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SFhwPI8+SUvaUbZwzbhSK0I8nrjmr01kG0xfkQ26/j6Ffg8jJ6nZOp6ZucUT2xUWvTx8SlZwlCN5GgmDRzD7mVcnVxPBmmMOmwSB0KwTleKw2Ef8xWgWvLOkCPAkofisI9oYO2Ed7RL3/jTO2qbK3pVD3qxgyRwwuPBAyxX4BVE9jFR0kW01LaB5g4fTks0qBdhknBaXkbW0mcW+9Uk+qMxIxknJv82mgAb3wJLlcBL5Xut/Li5UsDwMwaHhRarYB+DUSkc/DI2bI9c7xEnVSTaYTQ8jttcrAY28lvz1l337GnF7CN1JWBw4dhvFue46FlIEOH2jYU+QDrILDyxUKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNXRszWcBuO9G6o+j12hovMvqlVH3GOka9pfOpMOVRI=;
 b=FFBNp32pSFxDW8R51GpjnqbmpQUHplJ3VRcrL9XV7SUvlUyfH3rPH/82YMdm/EmMXTV/FDy3zRcxeNXA+5L/f4Am2RuwYqs/g3H4S/ijvFApgEnqK2NG0eme3udOMbe87lYTDtWQiEtS3pqpfQy+o02HvEoLZ83Dt7SWjtzgv9RlUW/HMP2O0qfHCs1q5+F3rH3Sd1Si7Kb6tniOYYYc5ya221l2OG/lHXvRnSz7dBF02QXUBGQ/MAcZ6i6Bdar17T3VbIsVLC8U19ip/Qtw8x10ub/gL3RqCIoCEQqUEVxOylbr69oKo2joN9rhQICzs0aWFm8zhIbOFagtdwOgNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNXRszWcBuO9G6o+j12hovMvqlVH3GOka9pfOpMOVRI=;
 b=YcgGWmjxaucjd0YPKzHdmnLkhCE/W9WBs6eqdW8puN51iSmAVx1Ngy7N6/QcgP21xp+aPu96o8XOvKw7DGSyQOC72/uZ54bKmEj+gEKSEWNX2fh0S4Bei3XGbomxxzR8vGwCmtDqTai9w/xwFNjmnPWbPxZVpFu8ui1NNK9TtwY=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4371.namprd08.prod.outlook.com (52.132.222.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.27; Mon, 3 Feb 2020 22:14:20 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2686.028; Mon, 3 Feb 2020
 22:14:20 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v5 3/8] scsi: ufs: Remove the check before call
 setup clock notify vops
Thread-Topic: [EXT] [PATCH v5 3/8] scsi: ufs: Remove the check before call
 setup clock notify vops
Thread-Index: AQHV2nLj8VkRi6xe0Ue1eptQ6PQ7ZqgKCX8w
Date:   Mon, 3 Feb 2020 22:14:20 +0000
Message-ID: <BN7PR08MB5684846EF1094E0A6B2F6108DB000@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1580721472-10784-1-git-send-email-cang@codeaurora.org>
 <1580721472-10784-4-git-send-email-cang@codeaurora.org>
In-Reply-To: <1580721472-10784-4-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTg0YWQ1MDE4LTQ2ZDItMTFlYS04YjhhLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw4NGFkNTAxYS00NmQyLTExZWEtOGI4YS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjIxMCIgdD0iMTMyMjUyNDE2NTgxNTU1MzIxIiBoPSJZSDVqSi8zRGdxRWhQMWNkY1E2SHEvZGpPL2c9IiBpZD0iIiBibD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIQUFBQUI1MUFkSDM5clZBZE9uWmlTWnRJdW4wNmRtSkptMGk2Y0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFCQUFBQTRxMWltZ0FBQUFBQUFBQUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.86.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e6106905-9d9b-41e1-04e8-08d7a8f66b18
x-ms-traffictypediagnostic: BN7PR08MB4371:|BN7PR08MB4371:|BN7PR08MB4371:
x-microsoft-antispam-prvs: <BN7PR08MB43715E4BC4EC4AA970063265DB000@BN7PR08MB4371.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 0302D4F392
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(39860400002)(366004)(396003)(189003)(199004)(66476007)(7416002)(33656002)(316002)(55016002)(9686003)(110136005)(54906003)(5660300002)(478600001)(64756008)(558084003)(52536014)(66446008)(8936002)(81166006)(81156014)(2906002)(8676002)(76116006)(66946007)(186003)(71200400001)(7696005)(66556008)(6506007)(55236004)(4326008)(86362001)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4371;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dmAGZep2Progy8cfNcWhzX2Gz9uu6tXipFmC/amy7wZdOjirbRQHP9JoWntd2zaVo3CWYIFeAHZQnHoyti+4u5f+Zqq4U1emcEhrmL7v6KT+LR3883B9uaTcGOzs8H9HwkE32L+83F2fSXkyCK+MlmJB5upgy/ZHTQw57Ra8eBA7abr9izPwH9wuZCrReEhEmJRY+aSlz5TAnp+u6VdbdcrWyH8ygq1kBDSvaUUu/mJzFiA7fj8ib8UVIK1A0CRi92iJ78SOzTECJdup9kr0wjaAqxtRJKmZjoN4oFAV6P/Bsatr1y4p/FwQOCIME3L8Adk2uU2iEfPE4QPG1Qi0uhCtbYNirJDW3TrAQsvyaJVWoN7vCFoCSYh0EtbALf+6u29pznhPWridJoPCqsGMhCk2OZ1eMPq4XjpCdrKz4RALTb7bnXa52FTnWKldXGon
x-ms-exchange-antispam-messagedata: 7i1wUN5h94CCOVyqtCu1W3owJOclKTiOi9zViN/z8WAxEVYlpRdWKvHYXoSScD9wFyJXnSaS7EbOks3RX+wrMUwJIbRWbipgS9SMicDoglDi7BoF4jyzgEYJhuxNPj3Qb6e/3w8/I41AaQC04lUsQg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6106905-9d9b-41e1-04e8-08d7a8f66b18
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2020 22:14:20.8057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NZNbBEn+Ppnj+Hjva/3THm2TwWuEFFnG5QKvOYvjEwADwNyQCnXUj4tmu7yoxs7ytAfCvmPY4/Y+YYMblrB7Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4371
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
