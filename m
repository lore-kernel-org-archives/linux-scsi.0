Return-Path: <SRS0=uhQV=4K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2AACC35669
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Feb 2020 08:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0FD8214DB
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Feb 2020 08:27:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kVUvlvtm";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="gQnRbp3P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgBVI16 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Feb 2020 03:27:58 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:46968 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbgBVI15 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Feb 2020 03:27:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1582360076; x=1613896076;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=/jT4T5V4+cgku60PUpUkRrO2W29PmR0K3P22PnYs87E=;
  b=kVUvlvtmPF/Zx8DcvVhaj5jBQbef/jIBWZGxFOPZ3C+OSDRMXQddSi5G
   28mRPFCHqdeKU+9A7CD/4k8bcCnNgCK5vEj181xYIL4V+yN81Dp0JVL6E
   2Z9LHT6nKQUCa4h+m6imOAIJXJQw58DXs0rXY4G5xy5JNkO17JzKH2ioT
   pbXdGTyxG3EJT+oW5iWy5qKmTyDhu9pfyD3ftftbwT8ywkHZEWlRZCiG5
   X7sc87pA794z/MMS4qrv0tEqrhpPj7dBHeasstrhBSryqmziD5zhXhlG+
   xDzJYStPy5cmOZ43Jou3NFaMHgpy7G5OO7t2vukmKmkyXs/3IkrXlP4v7
   g==;
IronPort-SDR: tkaNXnFG3btBaabumkIOIs77SjFGTn1mfyYzOcPdMALSTBkHwSbD8MsnQrPxGGclwnhewiBwxi
 V0UsD8cN8WYtItovSHD3fPiy2CSJFGE77RM4nDsrqMno6dnjtnLp2Xf4bz3OtcmWZYpDbup14d
 9QRPyTs/Igw97QZiq5A9Qz9OilJcEqTwdijot8buugJREIwWpKxtQV66FpZwqcr5+FyDxBSHwj
 B16Pri0/4Rjfg1h4g5+jRvLTTsb/KgovBh0zmrSGz57ouaer01YnWqxtIfgCPBjCrt9suIDyap
 xVc=
X-IronPort-AV: E=Sophos;i="5.70,471,1574092800"; 
   d="scan'208";a="238576479"
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
  by ob1.hgst.iphmx.com with ESMTP; 22 Feb 2020 16:27:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZgJHPn/6sThNSTloy2tDgXC8YuHSXkpXnmP4EU2xi7PCe5ukdz7qHtbrett1NAwDQuV1HB2F2doFPvvtkaX/+JUNOY8KSJVjRjVkA4I/dXvoN5P5w5C6sPuKoffOG3WtfYAjPahFv8/w5lNbEjpA7HHHN1e3qP4fUK/cGzYHNGTM6PX6SCI/xV3aTH+MnFv9kMeBKLo0T7BjuYJ7QSAxRsY9aUe94Z4y8sFIy/pJiOMIrsYAN0VY6GIzEapaZgEQLEgY+ghWdd+8LsEQDw9VwiptW6jkVQi2xusj3nSJKlsClr6JlOtMTMbgPrhO7FbEBXvXdR1AR7LpMmS7BrBg8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O29KWjPAoKJQfp72cJ4yblhcEMatdW+Mbl+eFgn4TT4=;
 b=GDRvqtLlOE+zd5ZmbM8Xqh4cem9RyooIVfZNApbjGKL5lSNkgAcc5Q7OAE1XmIpRgiEo0pB8+JkT+/RO20WkW0itcd8uvNQqCMh+P6ibkqeadSpnPinfFACIy6aNGKIQQsvxDX2JinMrLnoLTlAxBPea0YA55OtKBCoL+UcOnOMKUMMQWBXyd9JyzzsABV35jBy/EDWj1MZ8J8TmPmPcHiRpIbyiBYMUU2pya2PVG8H7ByhPydg2TncQNVVjFWtXRK+niaNC39zv01JnCJbIgXxZwJ7d5YZM6lAwanSUNX3C1XKJrH5Zy4ptxZ8ny1XokC1ggjByXismDFDkXreMrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O29KWjPAoKJQfp72cJ4yblhcEMatdW+Mbl+eFgn4TT4=;
 b=gQnRbp3PxxpUy1QPJPN8NwKlvzL57MWNtrbHZw5UT5rARy5UxDD3/ILngusOUA1kdydEB/a6RHMiNtN9itv+CzmLNFPqn56V6dgay8e5pguCZu/FL/U0BpR2QYCbNKwFyX6ME4fkO7ZXo3pwnvHpIwefCq58EAYJWqOmaGXvxaI=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3630.namprd04.prod.outlook.com
 (2603:10b6:803:47::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22; Sat, 22 Feb
 2020 08:27:54 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::e5f5:84d2:cabc:da32]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::e5f5:84d2:cabc:da32%5]) with mapi id 15.20.2750.021; Sat, 22 Feb 2020
 08:27:53 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "dgilbert@interlog.com" <dgilbert@interlog.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "hare@suse.de" <hare@suse.de>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v3 09/15] scsi_debug: zbc module parameter
Thread-Topic: [PATCH v3 09/15] scsi_debug: zbc module parameter
Thread-Index: AQHV6CmcSg21fCjsakeEuIqAfzfsJg==
Date:   Sat, 22 Feb 2020 08:27:53 +0000
Message-ID: <SN4PR0401MB3598751D89BA379938090B0A9BEE0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200220200838.15809-1-dgilbert@interlog.com>
 <20200220200838.15809-10-dgilbert@interlog.com>
 <DM5PR0401MB359146F8251034D19365A9909B120@DM5PR0401MB3591.namprd04.prod.outlook.com>
 <4c2b94fe-f573-37b6-3b34-59647eabdd13@interlog.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Johannes.Thumshirn@wdc.com; 
x-originating-ip: [46.244.212.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e87c4e93-8ce4-411c-b499-08d7b7711cb5
x-ms-traffictypediagnostic: SN4PR0401MB3630:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN4PR0401MB3630B085C2E1E3A1BFB3E0AB9BEE0@SN4PR0401MB3630.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 03218BFD9F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(189003)(199004)(478600001)(8936002)(2906002)(81156014)(316002)(54906003)(8676002)(71200400001)(33656002)(6506007)(66446008)(81166006)(52536014)(86362001)(4326008)(110136005)(66556008)(9686003)(7696005)(76116006)(91956017)(53546011)(26005)(66946007)(55016002)(66476007)(64756008)(186003)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN4PR0401MB3630;H:SN4PR0401MB3598.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Kr95k9SraGibjKJsDe8ciKpPNyNX9wjRgHBoibTSYnJoKlw0wUgUwexUo2Ne+kGYwun1+Oq/OL1Fk5fzavPsPhNkdSzLeK+BcZqwvQLjJhLZbYqevWWMMpJa+piLW1LxgpGYcJ7yINcbdPYmQ2fT0k944U2zXE41rcsvm6e0X7892OWCLSWMlbqCd7nmBPuH8YJwWOXML7lP0dS5T6S78N4K25EOl2Apd4cstlDgPg7Sa53jLZD8OjgwIEiCcQcAJKk7nPdB3N2bVtOX5V4pT9SQqm/KCZZ906uiSPyI0/54irMaRhCuCB8Ca2Jz5zNVMo8o7M9GOgmzdGd/4ET7plaEJvSV/fxgpZTr9aIM3UO4K2zP55R7bYopALTue7GXBEvBva0Wx6i9iHjJMIODMWOwErgfC7u43oDIlT7Ywy2nMoamz87JIgV4qkEfy2GX
x-ms-exchange-antispam-messagedata: +o8Z0gUdapJWdRl9RUYGlQkp6enfc4U64f/z21SgRB70KtTDP3mQcI40Zh/DaGIJKxIdWjNqMd4xNALWjUW36pAMYP6kYrYxmCMB5ekQYtdRXx4KPUOsY+Z1AGp8b53iIAC+CyA7vZ7b10+ciSYrgw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e87c4e93-8ce4-411c-b499-08d7b7711cb5
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2020 08:27:53.6252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vObLr2ABztM9Ai3F4uz/E5PjAHWetWyqWkQX24A9QlUR0Fbtjzc4OC26bI27CF5lb0lAMJxjApEu7BKqK5UcgH1FuVO3lQ0DjBRPnzABkP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3630
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/02/2020 16:37, Douglas Gilbert wrote:=0A=
> On 2020-02-21 4:49 a.m., Johannes Thumshirn wrote:=0A=
>> On 20/02/2020 21:09, Douglas Gilbert wrote:=0A=
>>> +MODULE_PARM_DESC(opt_xferlen_exp, "optimal transfer length granularity=
 exponent (def=3Dphysblk_exp)");=0A=
>>>     MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4->timeout, 8->rec=
overed_err... (def=3D0)");=0A=
>>>     MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=3D0)");=
=0A=
>>> -MODULE_PARM_DESC(opt_xferlen_exp, "optimal transfer length granularity=
 exponent (def=3Dphysblk_exp)");=0A=
>>=0A=
>> Unrelated change, isn't it?=0A=
> =0A=
> Yes, it should be in the re-arrange in alphabetical order patch. Do you=
=0A=
> know a one-liner (or two or ...) for pulling a line out of one patch=0A=
> and placing it in another with git :-)=0A=
=0A=
 From the top of my head (haven't tested it right now) I'd do=0A=
=0A=
git rebase -i $BASE_BRANCH=0A=
<mark this patch as 'edit'>=0A=
git reset --soft HEAD^=0A=
git add -p=0A=
<add hunk #1>=0A=
git commit=0A=
git add -p=0A=
<add other hunks>=0A=
git commit=0A=
git rebase --continue=0A=
=0A=
This /should/ do the trick, but someone please speak up if there's an =0A=
error in there.=0A=
=0A=
Byte,=0A=
	Johannes=0A=
