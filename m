Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB32C433E0
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 20:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C3DE23A9C
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 20:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbhAIUK1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Jan 2021 15:10:27 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:57441 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbhAIUK0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jan 2021 15:10:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610223026; x=1641759026;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Bk9lUQCYupF734/lhgtxpHmXmn1Ziqs2QWxOkWDGMXg=;
  b=HHNjoi4CaXz9lyETj3QN7u8IvT13+P4JADVjjo3Z1EPs0FJHGL0OqK0p
   mSgXsrvrfBBtOGnKoe659Bp7CCVIC3dQCjSsZKbXjFOlBJmEY/rNqWV2A
   wEgpta86o0c8d0iCOjyLiqL+LAL0/pWewc1UYZvnkNG+FQ3AGS7LSxCgB
   H0opfo8fG8EuRREDCzd/yq7sAy4006masWwSCOxha7XjbhOZxjSaczGdD
   HiAeahERrAyU0eK4BlQ2z+VBCfFVZzMhJ/P9bYCKEqTe4guZtojLQSig+
   J6EpfSSCSLx/Mdvlg5LoKYxA5Bsb79WCRHAe4lcR7jLF8Q41S0W5/kayg
   A==;
IronPort-SDR: 2KxUSU2ZIk9iKRgJ5W4NbpdlUpjC/38EHfV1byQ2s797Nn5XpOgszEDRr1LmVPUQGRQ8iwQ4CO
 nK3MfDc4IktvGCLsWAKm/WDasUeCRXnhOoY8H/k2S34jtuuTasSoAMragnMnBaRYveDBJ617tA
 1wp8IT6l/N/8bOld55244reX+HsL1LawN4EVlvNi/lrWwtkBCuLYTDTD0STerR0JcQn+PeMf4v
 LbY4j+96RcmUSApEWZppKng0Q8BZtfT9hzmJBdL25rB/zYJFWPYF0cnw0Yq5UiKpu4xMkT7ha2
 BP8=
X-IronPort-AV: E=Sophos;i="5.79,334,1602518400"; 
   d="scan'208";a="158219453"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jan 2021 04:09:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNBQJl6VPyIvGwPyKfF5mt+WDTpQNpXJ3VlVjnCW4MBWCQm2m5980gKd+I5edNVU6A4YrmqOGYTHX2R8LaVE3xgz1n4DeMUOGsMsqZOEwK7g7N0YYQpbjAgf1/IMTnY+8mrSM4gIJ80knaxDlu2LxbRHPysc6837EcALC+gprFBsiP1Y+mHCg6PmtTq0oKjZ8oJeVci5jJbXVJuaSMk2m34AdyI5BJo0dRnWnJ00v+32fTx2Fo1W9wbFwR/xUbztpqu/EEKayTJp+dXdZIeJfXeAz0xMv8sXI2brBEac4sne94Y/MrupXjdFuIMY4oTe6mO9vfdegu2S2jc/ykdjOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mPcefCLaSKQVGIFgUFg3ZO2Y1j5IklevmWOVMjX6Ic0=;
 b=kJTcapoqpNsh4hQfvtiNTYcjb3S89YTNGw5/Q1YACiix+IkazWgcNKhGdAQ6iOSduMS0zohIf80XZNRUTUxbqw/FAVQmEtLfatE8ZpJujGAhQujTj147T3DSobNsU96etaSbGWK9C//l/hQL/CztAG/430JmFxQGW8Prwf+4iVLUUtt2hSl+ZmzqSIKJuQZZtHucmJjjJyaAOpO2HRe8g/vR8JLOpTqRJHDijqHOic5ICzMgbXT/lcjMV5b+FNBGJdoL03YOc0+HBUwfAlVPETIK/DxAF83UJazwq4A8NWxz52ZoDsoDsIy6BQJdB6C90tFdXoyemNOG0MyJDXi0lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mPcefCLaSKQVGIFgUFg3ZO2Y1j5IklevmWOVMjX6Ic0=;
 b=Kmn5sKWPA3XEJ6EGGnPEn3mZF8YmK/v/xBOORaNu9bCAZNYlMoCd6r06+fSGRxmO7djHMmOOoY9bx2ib+AAAqXa+HIbWIQoP9Q5lixYmUtWYYJPmmp45lVBTBVV4qhBI9A7ru87ShwxmfpjBdk8lutP86uEf2B1NOoe3cNtR0SA=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB4871.namprd04.prod.outlook.com (2603:10b6:a03:4e::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12; Sat, 9 Jan
 2021 20:09:16 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::716c:4e0c:c6d1:298a]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::716c:4e0c:c6d1:298a%6]) with mapi id 15.20.3742.009; Sat, 9 Jan 2021
 20:09:16 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] target/file: don't zero iter before iov_iter_bvec
Thread-Topic: [PATCH] target/file: don't zero iter before iov_iter_bvec
Thread-Index: AQHW5qBkaWm3Wnjfmk+XiYs/GS5+eQ==
Date:   Sat, 9 Jan 2021 20:09:15 +0000
Message-ID: <BYAPR04MB4965F4DCF59E5225CF17322D86AD0@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <34cd22d6cec046e3adf402accb1453cc255b9042.1610207523.git.asml.silence@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7233df04-2f24-48b9-1efb-08d8b4da70c7
x-ms-traffictypediagnostic: BYAPR04MB4871:
x-microsoft-antispam-prvs: <BYAPR04MB4871CC108DBF68A86BB02B2086AD0@BYAPR04MB4871.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H45skPl+S03Koge4SshfddwlakZjek0PXEsDXJ2yNyxy41U4S/zuyBYbZFeVApShypd0FPu+YX/hVkEoqRC4YDCBiSIhiemF3ldpwPbEqRJuZV3erg9iYIJvIO+R1oVe0SBoHQv1rN1q8uho8pdG/GteeloQHHaRfOMtg863k/0o2dnrVzR5mz14JOcfVX2mWWdI51o3fP2ciFz2hz/7Ec/qpOGy/qVnRqkw1jcK7d5dAD9tMhtYgVThOiq328KJk34NpuUtXzK9n3rOc6NNytOK8hjSFIAGYG4rei582B6p8q6MDx9QHXoh87PQNLDMmPe5ikbwYuVvvgiHuoXyg8kOBjt2yWQy5GTbFfwqwAe1ncL6FgL/WtFwgjjVYLp/csU8tv2PZS5lRZwzQ17dxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(39860400002)(366004)(52536014)(8676002)(2906002)(316002)(110136005)(66556008)(66446008)(66476007)(54906003)(64756008)(66946007)(83380400001)(5660300002)(478600001)(9686003)(7696005)(26005)(6506007)(4326008)(53546011)(76116006)(8936002)(33656002)(55016002)(86362001)(71200400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?0o8ZchHg/cU7s3PeoV4KLo5jz6jjmT0UIK055g6WeQ9cqwkhQhzEcyJMdDyp?=
 =?us-ascii?Q?WMHLk/KHXqd0iJkoWWKEY0t0KwD0jEewhQkA6KnBAMTCYut5ACOWtmsviwma?=
 =?us-ascii?Q?IW4r6WoPPmavVT9120pdc0mgLLwcSHtr3MfwdVyOo5Ph9Mv+O6HRhFGPJGvD?=
 =?us-ascii?Q?XGSJDFXajYC7/ivnc6GF6Kplvdstf6yJSDZzXV90ocS691AWmx4LHK7JIlU2?=
 =?us-ascii?Q?eB0e9+ZvQ3rmIeAqq+qc9mE98GEbicpUKzc+s9ibEX6OCC3tdgY7j62r5Qha?=
 =?us-ascii?Q?Uay0I/5f0K0FhvmFkMI4pTQuPxtrkXMgvO0waA+C2ed2qd+YbbWqT9i6Mzcu?=
 =?us-ascii?Q?I4ZCniw793HFL+cJ1OeicagVHMLAEFLZJWNBfUIJVRngC3YKGFliEdE15SgU?=
 =?us-ascii?Q?LQuz+/xYgCwz6d9WPOJ/aPdHcBYOHfATOgsCA/hza/WiPuL86XM+UgQ8+1J8?=
 =?us-ascii?Q?LQIyyicWQP/0Fgppdx2jzF6uClaUQaBvfTDL+wuLUXKdFoWgBNjMXX1PFcqZ?=
 =?us-ascii?Q?/XcB6j4cGqxrqg3KWJ6c+yAMH1RRFetX0NcOsdWnzVWRveNKx34SwD7RMPxU?=
 =?us-ascii?Q?OO6C9FbVN5JemW146AuN8YTeBLNQRkl8jdebrCHFHZ2Ne+hbyDsANeOvYDXa?=
 =?us-ascii?Q?rY2mVbZpIzHhPguJL2OsGy5VE03LOhzRSAIRlBy0xR26/1nfcvU8dMv04VDm?=
 =?us-ascii?Q?UYHwASNospGOr2/dVBrvuBf34RuKkfGhKbVTUYvquAEUguuYrkkhTyN8Zlzl?=
 =?us-ascii?Q?ovlqZ4+gnwdXegD2MagDxX9mTHq8Mwopk4pMn9cWo2nu9s1peWdnSAnPAWYz?=
 =?us-ascii?Q?afoOaWhaRj54QGznn4Fyi7yJ+Ne4aD6J9l+ucxNhvR7GTodwGJQX0gW1kSp2?=
 =?us-ascii?Q?fmppw3SqMEXqQHxkXbkXdjVjHepKeIgxmBQ0wZ7B9NxLsHecJ7/ynwAcaDZI?=
 =?us-ascii?Q?P7QZyV3+ypnvjpFiMybj1dpVHKlZss1vtmSY6RVdZas+qo7vbAGju9/HQGg1?=
 =?us-ascii?Q?uYCW?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7233df04-2f24-48b9-1efb-08d8b4da70c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2021 20:09:15.9645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E9hJwFVATk8GPm8tBhApZ/WqnBjCEfPVasMz+iY8CmGqhHz4y/DB2GTtrL1LsG2cathB60aIV2+Thd8UvhuwVB93M4baDNnhi9JDTBt5DsM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4871
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/9/21 07:59, Pavel Begunkov wrote:=0A=
> iov_iter_bvec() initialises iterators well, no need to pre-zero it=0A=
> beforehand as done in fd_execute_rw_aio(). Compilers can't optimise it=0A=
> out and generate extra code for that (confirmed with assembly).=0A=
It will be great if we can quantify this optimization with the actual=0A=
performance=0A=
numbers.=0A=
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>=0A=
> ---=0A=
>  drivers/target/target_core_file.c | 2 +-=0A=
>  1 file changed, 1 insertion(+), 1 deletion(-)=0A=
>=0A=
> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_co=
re_file.c=0A=
> index cce455929778..5a66854def95 100644=0A=
> --- a/drivers/target/target_core_file.c=0A=
> +++ b/drivers/target/target_core_file.c=0A=
> @@ -267,7 +267,7 @@ fd_execute_rw_aio(struct se_cmd *cmd, struct scatterl=
ist *sgl, u32 sgl_nents,=0A=
>  	struct fd_dev *fd_dev =3D FD_DEV(dev);=0A=
>  	struct file *file =3D fd_dev->fd_file;=0A=
>  	struct target_core_file_cmd *aio_cmd;=0A=
> -	struct iov_iter iter =3D {};=0A=
> +	struct iov_iter iter;=0A=
>  	struct scatterlist *sg;=0A=
>  	ssize_t len =3D 0;=0A=
>  	int ret =3D 0, i;=0A=
=0A=
