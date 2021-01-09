Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7171EC433DB
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 20:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27A6023B01
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 20:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbhAIUx1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Jan 2021 15:53:27 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:15997 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbhAIUx0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jan 2021 15:53:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610226380; x=1641762380;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=a6JK6xLwxXbRs+xrLxYv7QCKvOd7dYs3dfgVMljvLJ4=;
  b=VcE4Q+BHfvS2kb/7Kc+D9asoDBRrgE+7wMCdSeEOt+Bgt+bRNZeJvS9g
   ydp156wwDMJa2HI5J1dbmT1hYzbEfXJf8j+fp23znNIv3CU5cYCmSvezK
   g61BqWnZyr+fmsDjqvvdhznP8ZjdvdXrEueOmiN9lpFg/bCtVv4w/m6U3
   KqcyZ+ZHfzq7TUlxXdxPo9Wf2OsXOT0SA7WgyRYw6O2yGu4G5ZRDeVrkq
   9BAYHbodfXzKFRoFM86CAR+C4YRErnQn4NrKFjf6DYeLNzI9oBHKfjg7I
   LnrIPHT/EC7qSC9CaGb/PABEf9teZJjemCpI9IJHDt1VC8l8y2y30pu/w
   g==;
IronPort-SDR: fEdzt2Z6FGpA5oxeeOII9i+qPS11EIyJi2+k7meZdgPnrM2Y/UUDF1jYQM4QtN6J8pSkn4ewYQ
 jHGlXbBcnPm/XNzo6/fGDVzTVWaE6sW4mzLGtWZVy0zhFeQZWUiUQRTdJGR9grWgimlsEKkapn
 D54vmF4o9hsTy9KUXbrMc/lGKx2N2xMcvE+RKkvjZwbORETT4bDtVjbVrJoREdkJMASfjDvN6T
 JZtAQ3VYXvtAAldJ0Ov27lwbhOh68wMLQq9MXQlFt8YKmSH3uzT3zcZk42CAjfFc8fIbK0umnN
 tS8=
X-IronPort-AV: E=Sophos;i="5.79,334,1602518400"; 
   d="scan'208";a="260925140"
Received: from mail-bn8nam11lp2174.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.174])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jan 2021 05:04:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VgQfIHYoRjjyQdLg/PQNFhlqNV7HSAS0Krq+uaKM/DtfIhnPh6q6SDGPoq2LieWYV1VOmbK9Dc+ksPy4VOe7xcagv5S2PjZXGlziZbcgI3f9CgEf7Icqq2Wl9zZjsDe1Qpg6xz5b/5BB0PO267QDr2QMTTcz799wK24iJrfgDh+CuPbO+/EYscbkUc/gc5FjA/llYkZttxROLctnyqU8xRz+eX/LlEkL+mlxO3XKDUZXIg7CAQEUgnXB/UHWNYNi6DUcb4mFXdH40PqkTexSuhH8ClqvnAkG9l7Ix2R765d5AlIHK7GLGvSB375TpOZK89er/18a84w4PUVAUHvvCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6JK6xLwxXbRs+xrLxYv7QCKvOd7dYs3dfgVMljvLJ4=;
 b=AEuCUswqiaq/RZUxtxCd3n0Cf03mceX17E+4oCMPIzoL0tATz8Uq29cAtO/2ZevEiF3XXkhgkw85ql5FnTbnS0A7ZzNKyTPph1E8xVj2NpONLQ6lGNcWsql2qa6R1Rg1s9BIQ64O2AP0CrGPOLgVLfZk9TTGu5YByazdEjEQyHXPRqR6bOVtf8z1TvnzLPmtpyQIZfb7gAQmFSfJGxJUWQYBlEXitheDuv97xQgsCFU0vqaXxGCnsFNjmGf4oSEguOTBeHNEAzocFCJ2U2EjdZfaIDRjauHNU26232O+R1WclIsfyW/dOYi/GNZqPErtsGPJXiuo9ndbJ8xQ3reSew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6JK6xLwxXbRs+xrLxYv7QCKvOd7dYs3dfgVMljvLJ4=;
 b=FCCAD01X1sB84juKrp/sGHOi0qBlTJAOq0yku/TMfhyz3OX0oSQoG7q18ynMG4J2CrYLqciJmYSs4/9uZy+xfiJPZj2/EezXAEEpOYyF/C+ehqcvyGkiP32aq/X9vl5I5UMBTeeZvhabEXPqfH9TawX6fFTXGAaq64THHik+kqI=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BY5PR04MB6961.namprd04.prod.outlook.com (2603:10b6:a03:22b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.9; Sat, 9 Jan
 2021 20:52:15 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::716c:4e0c:c6d1:298a]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::716c:4e0c:c6d1:298a%6]) with mapi id 15.20.3742.009; Sat, 9 Jan 2021
 20:52:15 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] target/file: don't zero iter before iov_iter_bvec
Thread-Topic: [PATCH] target/file: don't zero iter before iov_iter_bvec
Thread-Index: AQHW5qBkaWm3Wnjfmk+XiYs/GS5+eQ==
Date:   Sat, 9 Jan 2021 20:52:15 +0000
Message-ID: <BYAPR04MB49653C92C7925B8C3EAEF3CE86AD0@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <34cd22d6cec046e3adf402accb1453cc255b9042.1610207523.git.asml.silence@gmail.com>
 <BYAPR04MB4965F4DCF59E5225CF17322D86AD0@BYAPR04MB4965.namprd04.prod.outlook.com>
 <4d063dde-c710-44e3-31b9-8fb6b7e1d952@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 49a88bea-d636-4365-8859-08d8b4e07210
x-ms-traffictypediagnostic: BY5PR04MB6961:
x-microsoft-antispam-prvs: <BY5PR04MB6961D1EA9DBE711BCB39D9DF86AD0@BY5PR04MB6961.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:605;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dG8X2Fatk7XQ9kvdZfzXeBdR00HJVZI/9V4vcv8HXUBlIqodAnbgd5poHvZah4nIuzil2wzBdZ0EpXdg7BsO2bIpecSbZ/ufYqVPiSMwqTpbNQse2ODdfh7Ac8spf5sjwYpFa42cXZmkirskrb8akJeLJERvNfC8alnaX2LkB73cfMeW4FTzty2BGxGfS9BlheJiOISPfA8MMKXCWif7gOb1eJjsPqwbB53VGeQ8Y6Q/Q135s2X8UA3MPBxufh/xgNvyHHWeISP4rA9fDCSWdhVHYkr38K5CjAQOKUP2hJ5dmBtyp5Nuj0c+9LcN4Akbr953sIJ4VUChSVZ0/MMmm/N3ukHRnl7Ek3mJI0RFMlzh1HXj8bbOae0WqeoZG15jhpyoFfaXhQDVhNgmuFme3Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(66556008)(478600001)(2906002)(8936002)(53546011)(6506007)(186003)(26005)(110136005)(54906003)(316002)(86362001)(55016002)(71200400001)(33656002)(9686003)(8676002)(7696005)(52536014)(76116006)(66446008)(4326008)(4744005)(5660300002)(66476007)(64756008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?qHRr21L76EIwma8ShmYdd2OGjagterdg5Ry5br/mmxEQFLQjoQd3Zp1OkVvs?=
 =?us-ascii?Q?iwM4F88P/H0THUYcgK1G8DRyHO+3ejHHhPF2ADpBzv88vii1lP+afdCOCX2/?=
 =?us-ascii?Q?jHV3pbSkvrSjvUuA9rmuQlzjYwcmlgyNazYbZ7L/6PZXSjCS2XrtF/KeiBQh?=
 =?us-ascii?Q?IQ5U17rNBjhSfJUA5QMCBfI+zDJVMRVB8ScMysBgAtwi2TFQJ4Qyomadfc8j?=
 =?us-ascii?Q?KIjlWHQy2rgL9NCiZEtgM2L0U+QrWQEAt35n7ys60s95lB87sdMB71mnkX1/?=
 =?us-ascii?Q?mVf4g7Ydal4Ka5TzrujE+n2J+hzxTDg2bbT0eoNOzyiw0RtyrGTWpaEBd2Xy?=
 =?us-ascii?Q?F3odfqAXKaaZw6UZQTjH3b6wUX++7Jz5T0mRH7ggmsriRatHJps6KtyB0AsJ?=
 =?us-ascii?Q?YYwBUiuDMY0zuwo1TG6n0RoktYP+EuhGJct/+iIh29FSQyUiRdHKNdVeVYMc?=
 =?us-ascii?Q?mr/ELMM2H4cqdqjCn1H7UMxWKEySNhRYvLW1zpCl5B83CE30yds6Q+17gnj+?=
 =?us-ascii?Q?XU7fVpvSQ0VEPiAzw+4gRuiXwj7OiHjEfhaeBY0vvrX0tUmuaRSGAt9kiAfY?=
 =?us-ascii?Q?P6gbkrlPvmfYBnzhYrxxbBzRkn/0OU+SMT0BF4NDniPzxz5eJhkSZA3oP3OM?=
 =?us-ascii?Q?U+zZC9zzAl93rCp96xGfdcIyzRo4xrCG6AZhkx9kUV8iRsIfMZBYGOwoIwcL?=
 =?us-ascii?Q?yoQBbrC+3oK3xBf6CX4OkR+ndc/cqvNxr+Q/EsmY1DH9IEH+u+BWhLEY+28x?=
 =?us-ascii?Q?51Va5jmiJ/84Ekzn0fhygcQzt121mB+o4NaKtjHTNpXorzpRAbgHo6Ic/Kwv?=
 =?us-ascii?Q?SbD1s26XqNOp3INUkaizHmb9NpJCpCDJRGuB3bOwoW1TRPA44+oZFLGQlpGO?=
 =?us-ascii?Q?fKIH/nFK79f22BQ0EMt6HCGXaWj/Z1FPJbYhDGCEvTpr4gHtMKZf2w2WlnFP?=
 =?us-ascii?Q?DcREeakoqrR5QqGLjEotDg3dAjQDA8ZdSZ0ZOVFk8yeRQKs23tl07wGrWz/Z?=
 =?us-ascii?Q?CdYg?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49a88bea-d636-4365-8859-08d8b4e07210
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2021 20:52:15.0718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IpeMAOA1WsGK1j6erhKN3dJdNkO5/zXW+CcfUK9S4Ev9mm2AY4r7sy1ShUAL7hz3P1yLVvD2ZniomyJbEQ47Tr9Uj22/qEPbaaoi4+tajjc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6961
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/9/21 12:40, Pavel Begunkov wrote:=0A=
> I expect you won't find any, but such little things can pile up=0A=
> into a not-easy-to-spot overhead over time.=0A=
=0A=
That is what I suspected with the resulting assembly. The commit log=0A=
needs to document that there is no direct impact on the performance=0A=
which can be seen with this patch, but this is nice to have=0A=
micro-optimization in the long run.=0A=
=0A=
=0A=
