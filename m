Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 864F2C5DF63
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 15:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 500C8218AE
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 15:33:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="gWD+xswr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731943AbfKFPdw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Nov 2019 10:33:52 -0500
Received: from mail-eopbgr820078.outbound.protection.outlook.com ([40.107.82.78]:27264
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727345AbfKFPdv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 6 Nov 2019 10:33:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H2oRWWgLrpm1xmg3zc0c4Dpzcn4azM6I+FOhBCKEdhv8CHfjAByl9xHIkS+iqPXo8y0YbDEZr83cztledsnwfXZT1JjUXpvbs+8olfH5lWQGtjCo1G+nakbwzLRkMhAvkXqb+K/ZDrr44EK925ZYK7dILovUPk7zd3Pjm8lRnTS+V2JeB7xbqeFFAreDAuWq0kO6EGM/UKIAGXQEtMPkRHdXu68InthB/K5oFq/0Lcg5NPoPoC9oM8K+oKwu/aG/onAYGFKphH0phouskqjERiO4pycuISfEfmn6Ms+ghEB5EBLRZmT2Sm9n48NOr+WG6NCmUrlQS7bZQQxN/lqGHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIiE3hrVnw2sfogY/lKXgx2oPUFpLvsLPJisbd9oN6k=;
 b=NoWgF7bLFWlbyVax3RskWy/+j/edF8xvTnN2EIOQFMarWYzGrxei3kYTczSZmmw3zCssRp2cDM38BNgYm9pOcU6OwVyuXq0DWqdZ+Vr7SizC6HAm3+b+RdVvsN+oG0t99LkLGtEf+qkvsPTMWqgl4WQeUg7u4leYw/GxYGEDE7xbgaQENyQ3friIEDVIBCE4pV9/jHL3fVzc3Y/9aU4jQk/H24J+7P807Lpj3Yw+XUdz5wg9E0bJJcwB4bxMOnNVa9v759IIPvIW1166IAp/v6YURW1pBpmGGWEmKgmDBVN3bFviT7xEkEm+8ofrr5f0w9kuyGZ3YyqBV7WYnuoFvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIiE3hrVnw2sfogY/lKXgx2oPUFpLvsLPJisbd9oN6k=;
 b=gWD+xswrft/y01g3gKztRBNGspaTLchOxEzp/swgWSEX+o0uCi/Xw3qbOGUu6b4CHX6LLxXSmSLh598iYvDSdSG2i3Yt1Em7p0v0i/RbDereICGb1/9hDLiKNlI0HJ5klhZP27EcPDg3Ar2174vAhrSE3j104AC4jupC7Z1lr4M=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4273.namprd08.prod.outlook.com (52.132.222.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Wed, 6 Nov 2019 15:33:49 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2430.020; Wed, 6 Nov 2019
 15:33:49 +0000
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
Subject: RE: [EXT] [PATCH v3 6/7] scsi: ufs: Abort gating if clock on request
 is pending
Thread-Topic: [EXT] [PATCH v3 6/7] scsi: ufs: Abort gating if clock on request
 is pending
Thread-Index: AQHVk42VXFg7+RwuvUGHe9iPWHp3qKd+NApg
Date:   Wed, 6 Nov 2019 15:33:49 +0000
Message-ID: <BN7PR08MB56847C506ADF9A2960CA6B1ADB790@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1572926236-720-1-git-send-email-cang@codeaurora.org>
 <1572926236-720-7-git-send-email-cang@codeaurora.org>
In-Reply-To: <1572926236-720-7-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWQyMzExMjNhLTAwYWEtMTFlYS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFxkMjMxMTIzYi0wMGFhLTExZWEtOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjI2MyIgdD0iMTMyMTc1MjgwMjY5NzQzNjIzIiBoPSJEVGNQZkNkTmxLamlacHYzcjhWekFwZHVOOU09IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0d472bb-ef31-46db-8e84-08d762ceb86f
x-ms-traffictypediagnostic: BN7PR08MB4273:|BN7PR08MB4273:|BN7PR08MB4273:
x-microsoft-antispam-prvs: <BN7PR08MB4273FF81502B38681AD44C5DDB790@BN7PR08MB4273.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(39860400002)(346002)(366004)(189003)(199004)(76176011)(33656002)(66066001)(2201001)(86362001)(305945005)(446003)(11346002)(6436002)(55236004)(7736002)(74316002)(14454004)(7416002)(476003)(478600001)(486006)(8676002)(229853002)(316002)(6116002)(3846002)(81156014)(81166006)(71190400001)(110136005)(25786009)(71200400001)(6506007)(4326008)(102836004)(7696005)(6246003)(186003)(55016002)(9686003)(66446008)(76116006)(52536014)(66946007)(64756008)(5660300002)(66556008)(2906002)(558084003)(66476007)(8936002)(2501003)(54906003)(99286004)(26005)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4273;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yCX/ipUFkLg4J6RZDsoEPsqwgnldvsh48CwjQcPwoPciWlqB7ZFJsaXZTiMD1u39f7/KLUuAnvpmn5MIkkA2FjIs4yH8d55YhPsQZuSJvVL4w7Xvg1QKCpyYpneXqDTlwwoRWld+p55ocZ89/5sRw9MYm/cWdrcZAR9PAUbCZ7DwF7N9k6A3NEB6dKyLiiyUXz3eDMVJLqLRt+IK0NPH29r6lrx/8AZCFi1hWIzyn/9UXfGMbFWcOMGCK2J7UY+grFeoxkzxUDuHrDNfbg3EyQBRnVvJG/tT7kJ3KIRK1cizj6c+RSonB5LEu9YuaYI18U0+0qpJD37UvIS9caG1rtU53LRfInc8oqw54Jxp7Sve3tOBc681FP7a0aB3BSWCr7AQhleKfsxWJQZp2vsxjutU2B+1iJLew9dDVlqoQk9ik1zIIGlWGuc/w6lK/YSe
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d472bb-ef31-46db-8e84-08d762ceb86f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 15:33:49.0693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A78XF+z2Rx3Zt+1WR5eK3MIPHta/sG1kvdc2qv2Z7zkBZz/m/SU91XVg9CYCj7nSx/7OIMX3nCnzrTpuAqQ+wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4273
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>

