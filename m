Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7A9DC432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 12:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9727D2068E
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 12:40:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="UaXmDkhO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfK0Mkx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Nov 2019 07:40:53 -0500
Received: from mail-eopbgr680078.outbound.protection.outlook.com ([40.107.68.78]:53639
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727120AbfK0Mkx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Nov 2019 07:40:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dW/3zbuVFJyiuqWEk26IuaJsQjw5ohJmxcJYz8+3ctNtibMQKtwFyN7RpR23ALC/a33K0X5visSn7NF2ZR/yF6yB8S1DjCz3jAQ2qPOXrWhmjpR3GXHM58sz8ZfIHZPjBgtKu3spOduHmAZRbFtk026FmafM4NMCk2BamC6gs3uFwkMcny8fgU8Rb3J0ZApn5T+WeBGnAYxc23EadfQB9K2gmqFcQ/i9XXP1uUKMuIopGq2SGdalDEAraszBAL/8fCpHGFCQ5/sFSMANDw+ixlcy2rxNDH6kdC3KNCccH4MPBtG4BGEUKAv0rbdq429wM8XOtR68lLH4/LQILITT8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uV4o4EHow+GItamQdsej2Qu4g5bf3/qLJQbezVZgQ7E=;
 b=ENG+qmMR+Q4gNujaZiPBu49SFGpB22ai4EJm5ix86tJViZMau1DWkhqVC8EbzsJgLXqud4KjOht1p292xQi5jG2uOwDaiHdsnr2iQ0g0lQoPOeUqUrBJNrBoc07palglSGDA6bD0Vkl0TR+E8AO2x9N34JKjCvKgbRtHJnwps+kbWbIUPWXvvT4zQE7SH6bY/KtlFlp9ZTGXcfWIKyo6+LJpYr4CYg0EfJdzVzJStLEEzBZvA6qkHIGjrVnUEGtlOxUZIYE4kjWE0T4ppl38Wfu0PSgKtm/VuCW/e9QiL1JM6hfjRdXfVfe9L7hM+wrjEfI55PMA6klrYwEbaE/rjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uV4o4EHow+GItamQdsej2Qu4g5bf3/qLJQbezVZgQ7E=;
 b=UaXmDkhO2KeY6GScxRD79LmfwBRwEeBTeOm/b0gGCA6UmuIq0z6PXJwqmgc/4720H+OJ+sVHgfwLN+F2bMqDhKA171zZtvBYH7o3HOyoFGZ1gbnz9jR1KfHVENH4rrMh1jyB9g7mGIi4ndEhVUQWpQhzqohyLnPzA2ul3Wu9PKw=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4129.namprd08.prod.outlook.com (52.132.221.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18; Wed, 27 Nov 2019 12:40:50 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 12:40:50 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Avri Altman <Avri.Altman@wdc.com>, Can Guo <cang@qti.qualcomm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] RE: [PATCH v3 2/4] scsi: ufs: Update VCCQ2 and VCCQ min/max
 voltage hard codes
Thread-Topic: [EXT] RE: [PATCH v3 2/4] scsi: ufs: Update VCCQ2 and VCCQ
 min/max voltage hard codes
Thread-Index: AQHVpCkFex00fwvZZUiA8Fjkxe5rFaee9g6w
Date:   Wed, 27 Nov 2019 12:40:50 +0000
Message-ID: <BN7PR08MB5684DDB115B1F27D7D98A978DB440@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1574751214-8321-1-git-send-email-cang@qti.qualcomm.com>
 <1574751214-8321-3-git-send-email-cang@qti.qualcomm.com>
 <MN2PR04MB6991F3919641BB0F60BAA03CFC450@MN2PR04MB6991.namprd04.prod.outlook.com>
In-Reply-To: <MN2PR04MB6991F3919641BB0F60BAA03CFC450@MN2PR04MB6991.namprd04.prod.outlook.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTIyYjVkY2NkLTExMTMtMTFlYS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFwyMmI1ZGNjZS0xMTEzLTExZWEtOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjUzOCIgdD0iMTMyMTkzMzIwNDgzNDEwNTc4IiBoPSI0RlowYUxDcVo4ZWlDWnpsUE1GbllIaTg4SXM9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.86.145]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9f1d14b-738b-41cf-d8a5-08d7733708cf
x-ms-traffictypediagnostic: BN7PR08MB4129:|BN7PR08MB4129:|BN7PR08MB4129:
x-microsoft-antispam-prvs: <BN7PR08MB4129389E18A4CA830545AB0CDB440@BN7PR08MB4129.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(189003)(199004)(66066001)(110136005)(9686003)(54906003)(66446008)(7696005)(66556008)(76116006)(66476007)(76176011)(66946007)(186003)(316002)(11346002)(14444005)(256004)(26005)(64756008)(99286004)(2201001)(2501003)(446003)(5660300002)(71190400001)(71200400001)(6506007)(102836004)(52536014)(55236004)(229853002)(74316002)(15650500001)(6436002)(7736002)(305945005)(6246003)(7416002)(4326008)(14454004)(6116002)(81166006)(81156014)(86362001)(3846002)(33656002)(4744005)(478600001)(55016002)(8676002)(2906002)(8936002)(25786009)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4129;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dbcgUFJSyNTnJsTsGuTFd1RmOP3WVcxMWFV55pI63totB5PRbanuruVrb2NubGdExc/0vI919BCith/cJ25BfB53QqD3YtzfMQeLzkBcUYLn6iz+IX46rAYnf3aZvUDQvxaj/AO8q9OnEtMUq7rq3enr71pud6/+/5nlJ+BlxVFwcZYYf9dVHnTQy0PY/BMJ+6Q+b3nPYqBev2JIvfKv5EjYV+PhhpasJ8SX5ItCUWtBLQmkLRxSjUwO/GclIJk8koOiQzBX1GCk34bpsu66v5dh3cJ/R2YRUPE3Z2lYvDlTIcMrozu0ocGqmQGXiuWHhjYlwB0+eliLvjF9Ad06LtYTMuDHjIy9uGtPJocsyUxx5LHBqOzekgb8sx2wMZOil4OLXxcM+5wCpN0Lo80GuWav3X1hxSCaMqkqYqdlhUkn+kout9gxKA3abZkhMgb5
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9f1d14b-738b-41cf-d8a5-08d7733708cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 12:40:50.2770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /04W1knaiwLlW2R75ZlbHrb2nzXIaHp8IMx7uyjGuVa+xgNJnKLzTjxA8O1uGRtXR151wvuBNxEboENGPZ871Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4129
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > voltage range is 1.14v ~ 1.26v. Update their hard codes accordingly to
> > make sure they work in a safe range compliant for ver
> > 1.0/1.1/2.0/2.1/3.0 UFS devices.
> >
> > Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by Avri Altman <avri.altman@wdc.com>
Hi, Avri
Your review tag string missed a colon, which results in cannot mark R in pa=
tchwork.


Reviewed-by: Bean Huo <beanhuo@micron.com>
