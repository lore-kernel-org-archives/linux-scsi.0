Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A22CA9ECF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 110D6222CD
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:07:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="1DFvQoJU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfKDJHL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 04:07:11 -0500
Received: from mail-eopbgr770050.outbound.protection.outlook.com ([40.107.77.50]:61760
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726100AbfKDJHL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 04:07:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NfP9IEvedfRANtZ1r6zmH35SdBekBtuvrNK5cTm58ebNnwv2tfW2TN8UFKH/W+d64x2YGJhANM8m+qT+w4hj4ZxoOi3KV2dOzKVgTvckXPzv8YKlV7AJZjoYcKFieWqAG8wcn2rFcLn2iIbrzIXoQ7GtlRxkkYZ+FP910noy5TbmL9ROKvh/wpmblyDuN/7x90hmAEOdOncf6GJM4ZfgJhoSVOdXw+eIZ7qzpNvVYNzwA9pKZJN/eMTEccKK3mzq7HirlD6jyter+6gyK5cAVy55/4CEeSzZPJTFIZIPJ2k/1bM0ry5yWc5S2KxVzQt8/mm0sK0bttwMnGPWW65xUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqVh948d8MxhHofM2DwcqeKoJgTKDhqL2D2PTCguBZU=;
 b=OFM/qOJ5kj4MrbYx+OTRsdWSX1axi6tjaK/F8YmXkL0rIB9SIvPlc/hbaN1h8aXg9iVQhU7mW7JEnf2KGkbYirXXZwMhWnyJaTb9Np6NHnrQ/gUQzb0igYyGNV25GtB1dTgcpbvTJ+dd0sx6eO8o1Lt8K5v/mfOiGBs4dqY96caRzxvNKDZum5lrV0qRYoDQ3wkJ7WU9lhUtZCco5qYQJqEeeeGG1h7nhmuh+f2oFv+pon/ZO8uznTvaSlPDEItQwESCXiJnoqB8AzfKaDVMmUPkKreSKkf0XbmezuSlkTb0TPjUk/4aj+x2rIZOjAHC90yC/KmRE8cY25IPiQ5qBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqVh948d8MxhHofM2DwcqeKoJgTKDhqL2D2PTCguBZU=;
 b=1DFvQoJU6Eo4mje41/4nay5WMNb9q1viUifvLO6prKe+3N1J9xcrVP4g8JJ4g0rSZqLnnKTnvBpyYS1QJ3N8w5UEbOKX5mYi5E1sJW1TsPL49V38E3gra7Wurrvy5BjATJ5bedF9iYOmyVz5bCGShEAh8ZTveYC8h6b7M1JIMgI=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4385.namprd08.prod.outlook.com (52.133.220.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Mon, 4 Nov 2019 09:07:08 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2408.024; Mon, 4 Nov 2019
 09:07:08 +0000
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
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v2 1/7] scsi: ufs: Add device reset in link recovery
 path
Thread-Topic: [EXT] [PATCH v2 1/7] scsi: ufs: Add device reset in link
 recovery path
Thread-Index: AQHVkrBBOZcq0OUUjUKroVOu3na/Dqd6uOXA
Date:   Mon, 4 Nov 2019 09:07:08 +0000
Message-ID: <BN7PR08MB5684C7D3614C7AD052AE9F45DB7F0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1572831362-22779-1-git-send-email-cang@codeaurora.org>
 <1572831362-22779-2-git-send-email-cang@codeaurora.org>
In-Reply-To: <1572831362-22779-2-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTc4NjlkNjI4LWZlZTItMTFlOS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw3ODY5ZDYyYS1mZWUyLTExZTktOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjIwMiIgdD0iMTMyMTczMzIwMjU4MTEwNjc4IiBoPSJFSno1cHNIT3NjRnEyeHNLRVIwWjkxTTY1YVE9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2101e14-6fc7-4eaf-8084-08d761065efa
x-ms-traffictypediagnostic: BN7PR08MB4385:|BN7PR08MB4385:|BN7PR08MB4385:
x-microsoft-antispam-prvs: <BN7PR08MB438501775CE0338BD1E1B060DB7F0@BN7PR08MB4385.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 0211965D06
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(189003)(199004)(14454004)(76176011)(66066001)(305945005)(7736002)(7416002)(74316002)(33656002)(186003)(86362001)(2201001)(446003)(11346002)(6436002)(55016002)(55236004)(102836004)(9686003)(476003)(486006)(229853002)(316002)(478600001)(8676002)(4326008)(8936002)(6116002)(81166006)(81156014)(110136005)(99286004)(54906003)(25786009)(6506007)(26005)(6246003)(7696005)(256004)(66446008)(76116006)(64756008)(66556008)(66946007)(52536014)(558084003)(66476007)(5660300002)(2501003)(2906002)(71200400001)(71190400001)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4385;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ti5zDPdd3dLb0RhhVal+wAB6jwAQ4cqyACOpHtqewXo6OL3ByAgW5CYDC+2DZ4qIQOOjPAEeb6uBLe1ZDVFIPu35cI2m5MEelekipvhSb31HTKOo6diBZwE4VUuAFfcnyQG1n+UsDx0WVWtci3ZtAhPlxWXqypXbnQbyd1qIvDSABQZjdhtWz6QB6ZpDes1Wadw4yUz3KZM1WWzicW2vrWM/cT/42/tZu6dzIqYxOzAiEfNTHyiQh4+Qjy3mfQeJiey1IWCbBe9bvy+k1ujT7NKWS/31szBUdrxr/Y4ZVciwu4yPkd2FjY5Bhn9heqtTa3hCDaQc2fL4H5ZqyDh7M2rQAvs+WIoAFcfmOTky/fbPHY4s+g0pgUmwrvELy5/xsdvaTTPdtbZIvi/XOoKx2bByWy1w1i8LQsLVq7DaRTrqUMTG3I1tc5ovpqEps5IH
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2101e14-6fc7-4eaf-8084-08d761065efa
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2019 09:07:08.5328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U2zPebLI8Esj8yZP/AieawzFpcLqzFecMnWVecfdR0gHhUmFTUlLLXPW8Lno7R0MevoEoBDKHRUfDDOYGBSJyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4385
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
