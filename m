Return-Path: <SRS0=nNaJ=Y3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44757CA9EB0
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Nov 2019 21:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 100132067D
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Nov 2019 21:17:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="w0Dvk2Uy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbfKCVRd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Nov 2019 16:17:33 -0500
Received: from mail-eopbgr820087.outbound.protection.outlook.com ([40.107.82.87]:54270
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728121AbfKCVRd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 3 Nov 2019 16:17:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fW62V4n4+XZxn3l/gWDEtfxGjj3TiDQ4dTLIvhDoZz4Jyjco0OGoC+Z75wXQ+YhOSo9yj7Uz3YoSYb2e9y7uATMa7tfhv3GWrHago0jXjl/gKZUuk0+DeVuMlz0ZYHRk2g9uTwjYXJjzgSTao7OHRGGF8rASUYcr6Ezp57BgDY6PMK9pRUxFH9Aj2PUc+Kt/wUh0UOYjZX6psiPPOaGHOuCv2MhnveDwVRX8Q77arPBJ9LHvqgEVcY4UTAXlX/W7CigSU9XM2UfabRPxFhjRtjh8Csud6bWCzVbgEGmetVuxz6jppnPthpropSPoZAneGvub4fW21jXNgChVD5syGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNXRszWcBuO9G6o+j12hovMvqlVH3GOka9pfOpMOVRI=;
 b=AUNvvCMHgO8Uo2aAIwpZNh22PkaZ5wIy38+PswhnZv8toqcjiBMgGUxZ3itrIFTc5yOlRH2QXtesMyX9Z9tBFoFehsfYgt6mylHkw/XDd6YCJONwOGdn80DRsOTxhBjJTKyX4NaiU7FAcpHf/UMlDVN28C5rFIdQCN3ud6tlhZVyHY0r5Z2hme9AvMt3r57zGg/eDcUxFdqpkgMWCwe6rucovtVwa4d/mMkgifdjjP0nDUVG4k5mmcOb3WuFXiDApFxnza7vNJl66pELVMLTWkVCD8G3y6v8POuFzpQKfI4aY8SyRlAMG1AiHcGU7G0iM1OYlxVOfsi8UzUKyiE+cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNXRszWcBuO9G6o+j12hovMvqlVH3GOka9pfOpMOVRI=;
 b=w0Dvk2UycXDJrRBkRUfZN/2Ldcx+eKXnFkctXWkhPQ0sYuqr4oFWs1FwSRfyc7lqPUiGkSeE/NiwydIlxELC8eULfPpUrWngBN1LfJUYT8n1vKx6rUVJqYeqiZygPf3ee9HVsFPzBKPLJJWUCr6ygouW55zpJ1li+P4MtfOJCTk=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB5235.namprd08.prod.outlook.com (20.176.177.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Sun, 3 Nov 2019 21:17:29 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2408.024; Sun, 3 Nov 2019
 21:17:29 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v3 2/5] scsi: ufs: Set DBD setting in mode sense for
 caching mode page
Thread-Topic: [EXT] [PATCH v3 2/5] scsi: ufs: Set DBD setting in mode sense
 for caching mode page
Thread-Index: AQHVkTqmAlzssTarakGzsHhJVs/oVad59Zmw
Date:   Sun, 3 Nov 2019 21:17:29 +0000
Message-ID: <BN7PR08MB56841B37E7EF0B21DFFBA1AFDB7C0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1572670898-750-1-git-send-email-cang@codeaurora.org>
 <1572670898-750-3-git-send-email-cang@codeaurora.org>
In-Reply-To: <1572670898-750-3-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTU2MTEyZTAwLWZlN2YtMTFlOS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw1NjExMmUwMi1mZTdmLTExZTktOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjIwOSIgdD0iMTMyMTcyODk0NDc5OTA4OTI3IiBoPSJiUHAraG43ZEdmbW9qSlR4RDdjdEtkREVoRjQ9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.80.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad6ec507-30c5-4553-e282-08d760a33bcb
x-ms-traffictypediagnostic: BN7PR08MB5235:|BN7PR08MB5235:|BN7PR08MB5235:
x-microsoft-antispam-prvs: <BN7PR08MB52358F8C63B4B3A6979BCEFBDB7C0@BN7PR08MB5235.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 0210479ED8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(189003)(199004)(8676002)(14454004)(2201001)(229853002)(71190400001)(71200400001)(54906003)(316002)(256004)(6246003)(33656002)(6436002)(110136005)(478600001)(558084003)(2501003)(6116002)(25786009)(3846002)(66066001)(102836004)(4326008)(55236004)(7696005)(81156014)(74316002)(26005)(11346002)(64756008)(66476007)(66556008)(66946007)(99286004)(9686003)(5660300002)(76176011)(55016002)(81166006)(6506007)(86362001)(8936002)(186003)(66446008)(76116006)(305945005)(7416002)(2906002)(52536014)(446003)(7736002)(476003)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5235;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4hF2K12+/y7tJlGKoL+UC0yiN7Y0c5X0w/aUwzsfUEvVP7iFSMbx7Gm82YxEfz2IqINCitm3OqUT+ev2FDimjt4p2oLuqBhFb0UJX5xT8UeR16Imyla1knWK771UVYNPkNtHXOitUdRaLH6IZaYRabKVmfwoH1kSpNteNbbAyISWyFlWMS8FFcGLmdUt20jJlCJEzC2GPc2aWhZKioOAVJglmW0oTfUW9bLPUe20ZF5k910NAd0iqdAWxXol6L30Y7q7MBaVCsQFgaG5RUEQBQgZIHuCWmC8h6aKlQOatuCdIGMcdU9vWAeTgZIHSqsfwdax4B5p4GhpD9xpw7h/pbIpvK8XWJBpWmMlY6MkLk3gNIUyDL+n2Oy9bc2bkoPFhbIExQrUfDLr/8ukqPrheL2o7s009xIOl4kotePNBV18qp/A92o4bkNbBbK158AH
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad6ec507-30c5-4553-e282-08d760a33bcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2019 21:17:29.3279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RRO/x7yflJe+ckGw2utv3RhMxD2CyD+oZ+DsW4riWf7zbLUhoa5fu46qO0WQWkSqqBwX2L5Pu0/1paF6TDj1FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5235
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
