Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF4CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 02:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2605961002
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 02:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237765AbhJ0C4T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 22:56:19 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:36226 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbhJ0C4T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2021 22:56:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635303234; x=1666839234;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=h7eG2htWBDMdLbPF45sYkFmVrdIJDRf1qabDLK9WtXo=;
  b=Dxi+hBC6gmlKtKfyqdkazHpyGBS1r95R5APyrkCB6BN0RnWJ1NyE9Y4N
   kwDSseEn3cFGPzOD0PCMRZZky+tIMAiMH7qR65PbmLPZ5UVh1T5U3jwLc
   9vzpAGfmH9LwEgPtuH5Q5svSo7yWiY4mlgLrxmhco8Rm3i8/GDls+zrBi
   gnnXCn7B7yy/LlmRk46DDk6i3aCJA7g5yNRNDhL/tI6rCjFfGB8pmh8r2
   ULl2IFuMh91OfUwp/EfqSGVGNa5us5UOGwHQd4sTC1xKUE2IWrZdD+pVn
   JRJalsS87g8X2mFmoigQBorIFY1PoFk2UCe1u5jkGIT7xy4xcqa4vNBo1
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,184,1631548800"; 
   d="scan'208";a="182937425"
Received: from mail-mw2nam12lp2041.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.41])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2021 10:53:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mc0dWWzLKIiluEkFzwTTk6iEQJyxJedCna3sltCXAknvpxN1lcO33OEUlLJrhjx/zoOQPkR9Pati8cFK7UPmrX2a1iLKRo9KeROzA8kF/BVJqkfnDFv9x1p0jEkPciPWgiwsihp+ACD/1QcAZCcfscmtMeASdWKqH9opeCh7HUvSAtYT/hyGUt1QvZ4B8LsiFie/qHFJ2vM+CskG7PDkzcSwVLcS6WIGdM6CdCKEA7Bfg53xEWEUClxxwbjWOvnNXJOG2PhtnuyvI+0/1QE3Av9L/rtEgesNobXdrGaseNg4HjbrykoK2uzlyUBY1Fu1EGilEMkpmRJvRIP7y7sJkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h7eG2htWBDMdLbPF45sYkFmVrdIJDRf1qabDLK9WtXo=;
 b=kfb3IpfZqU/1wqQYo6Vg3BL8pmJjywZveNMDcruHiEwVroASt12x4ca6GHu6JepnlNdQBuuYnqWxrPgnGcHbATd1uAEEmOgMcqPxmD7+Rk3/QayhcKkrD+bvyfuQqWs1byKimRFZgM3R1px2wulw3yokngRFYUHdLMrdzPAV0MZWD0LuFCdQhBcxZkSH1Yt7ZHRbJI+GimthSxx7pJ9AG0GuRAQAtyL54n8AT9gq9vsN5W2ZTwYYiAP38OPnRPYnjl3hQOOoMksZaiJfMx8lcbJp5Lo3FuPEk2EmdPKHvPinkkJlyEe0kRfE6WsjMyP9uuzB7ZttCjcDsDuDkfPUdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h7eG2htWBDMdLbPF45sYkFmVrdIJDRf1qabDLK9WtXo=;
 b=CgYpTU9aiuB/z7txjG98HJJTTLPLxyHocFujiIBbdjw6/RI8U26y6D00KQNLNjAT6YyhkOzIriDAWRmaNHxen+2E8fqP2TZpi2TzxQxT7YKeO5O+xQVSblBWiZpvXfU16IQX5WZOkojmTpKPTnCDVRWT/ewpX/wsrX/yV1ML5jE=
Received: from CH2PR04MB7078.namprd04.prod.outlook.com (2603:10b6:610:98::9)
 by CH2PR04MB6631.namprd04.prod.outlook.com (2603:10b6:610:9f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Wed, 27 Oct
 2021 02:53:52 +0000
Received: from CH2PR04MB7078.namprd04.prod.outlook.com
 ([fe80::a563:b049:4d85:6b35]) by CH2PR04MB7078.namprd04.prod.outlook.com
 ([fe80::a563:b049:4d85:6b35%3]) with mapi id 15.20.4649.014; Wed, 27 Oct 2021
 02:53:52 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v9 0/5] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v9 0/5] Initial support for multi-actuator HDDs
Thread-Index: AQHXytl/ihnWi6nd7EWMcej971tRpg==
Date:   Wed, 27 Oct 2021 02:53:52 +0000
Message-ID: <CH2PR04MB707813D13917A8FFB7691624E7859@CH2PR04MB7078.namprd04.prod.outlook.com>
References: <20211027022223.183838-1-damien.lemoal@wdc.com>
 <cea34b2a-6835-d090-4f0c-3bf456a6ed00@kernel.dk>
 <CH2PR04MB7078125DD9418A4B4410A485E7859@CH2PR04MB7078.namprd04.prod.outlook.com>
 <yq135on2n99.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67f8f2c8-cde4-4797-cfaf-08d998f5023e
x-ms-traffictypediagnostic: CH2PR04MB6631:
x-microsoft-antispam-prvs: <CH2PR04MB6631D3EF237F2645A1198B02E7859@CH2PR04MB6631.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DH+Dl7F2KAXpgFt3fDOqo4uYiPjip6d/G7b4Sl14nQ/yiJxOopxxWYi4jkdvepIU1XgmBol1WWRrlltbUUl5232Xl9PHoL3HOADZaX2Dq7mDOWWygrDWfWFuvZPglnbs/eNezH00a4pqNfkdmxs+biReQOYDss64W3GJNJZJVEJgfQ+00snOfeJRSDhwmAZ0Jo4BrQzE+mPcgUB8XGNC73YG7vSDwG60ws5+lgmfGSGa6ta1B/1r9ve1Fe3dmO8bk9RiI0KuaEIha9LLNAmGtP+fHu8d7bHUGT/y4U4ru7+i9RKuEIqtHwcywm36qTyT9+QuDujl4/OBu6sekWI0WeDR4kry0eclcDqcuGksceRKs0SBTM3cx2vcwJb3ez6qXmscyzGgUh+wSN/ieKWObmPJXwhbg1IjmyaXIdXSEkrEW4yJQXCflz4E80VtvX/uXHPSKvI6/amws3pno9U/UmAPPLp6RNQSv729LgTXhP4ybDjzsYzBjkFcOQ/uYQI+wFJ0Q2whGR47jCea7O3Gqqj/prKCXfCqO8l36zCdoDx5HhOjb6XB/fEoAtXomgr0kWJw2aLirP+bba3SUsgVjYDfuYamo5DQYJulFjMfJBYPk1bbmm23vUL7v0tN08uWcnPB+DVa9iwcqO5BSF7J1Q+HW3HG9DUFVoy0/1CuDZ/iNAe0bbk5R83UAZDI6f1IQxxdwuIckV5jIR3j2m/Z4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR04MB7078.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(186003)(33656002)(6506007)(26005)(55016002)(316002)(7696005)(82960400001)(53546011)(38070700005)(6916009)(83380400001)(8936002)(71200400001)(8676002)(54906003)(86362001)(122000001)(52536014)(508600001)(38100700002)(4326008)(66946007)(64756008)(76116006)(66446008)(91956017)(66556008)(66476007)(4744005)(2906002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Y4TzgwVMy+dhZI7JWgBxZjms+xeyEHBOuBrbSbrj0Ca8Bwq6b+Wn//F5kP7Q?=
 =?us-ascii?Q?6p9UEkh5tt5Ow+pNh/sHcjjHSnMCUE6tGATDazUdb9q3rWmQPF6clqZUBPyc?=
 =?us-ascii?Q?KOMenJGcUSV45byU6mNjqxYGdgiDV5kATyaUjfJu9k0o+yLoHFGrD4HlHzFc?=
 =?us-ascii?Q?4DdRn75TgOuY/jIMsXq/KYNnJB6vbVGJahS4qse3CcAX4Ci1TTtpjHy6QGxh?=
 =?us-ascii?Q?gyYZzXpDkFUznHwmYLcKQWD815yAkSw45m85/qJTBHFlsTODOwTdMx6sx1IH?=
 =?us-ascii?Q?WnHoXvWnZh5xv6AEVcmOVR3BJA1Xig10yyuvib1aNhApDZjnrKITKZUYhsAQ?=
 =?us-ascii?Q?Z75ZDiErR+107Twwi2Op7zD+SXE3dIDkyo3bR9gsnoHnzU3xiHWEWxYq2HmO?=
 =?us-ascii?Q?pyk0r1bpBtzphcE5FB7Bp0LTA6F7IokrZ9DHj2dVq8faeUF5uPxtvN5c607U?=
 =?us-ascii?Q?wk1GDJIkgolpqq7oUYSt+S/eEQgJlTN5a5DlbjlCYrNlQs9HQAVQwbFZ+XFX?=
 =?us-ascii?Q?cDBwxVbMMKUujsR9Ph5YkwacnNr9oWiQb57U14mknbuUZwY3nK8J+PFoOxU9?=
 =?us-ascii?Q?VTEwS/zjIPafDvsxMl81BYh2dtIUY60nchZthlm+OwmbN7moVXzriUpyiAbj?=
 =?us-ascii?Q?dWQXLEWqvS1blEp+B4U7jxSbyhJ+KNgIr/N+UAijNMQEP4+O/zAaOvQIPj4e?=
 =?us-ascii?Q?tuNEUu6AZ9xVndSpZxqyUEJfYfBWPjtCw9aUbZxexHPgkwE1Dd9JUwXk9Me/?=
 =?us-ascii?Q?l+HFkQhmsk33bdHIIDNJS+zyS9R/YKYj2pN0c+WK79b3lE7v6dPImJvVTSu7?=
 =?us-ascii?Q?3IISPlMk9n9INwlEVKFmstMwaw2OCbk7AqK+vDaZwwoEJ6P7ykjNxtEDLy66?=
 =?us-ascii?Q?IzuiXHjxZOStV7Ij2e/NiXP+OimPok3LhUDQfTaFuORzCUYv9irzRFHwJMwK?=
 =?us-ascii?Q?JBOsLy4Nqys4aDSgwusoAFJrlJ3sOryk/U7XHGt08drL3JjXRpCAiiQCPveE?=
 =?us-ascii?Q?oeRKmYdAzmOQYIkQOgN9GPmj8/IzkZLWNE9YVuGbspsEVSbTxA+X2Sc4JzM9?=
 =?us-ascii?Q?y0Moa90XP77QzddVxwaGAlzTyFWsXk+oxas81b4YzWH++2UPSPwK2QgAjnon?=
 =?us-ascii?Q?ErIcChq+fqc6znYoLlw225KnyieYcYSHhauzAADayf74KaxvrDM75N1OY99g?=
 =?us-ascii?Q?ejlH93Dte6aUUE9hwogviiQTKNyqHDRJT8a780+3afyvi9Xuv53ttBoSZuZm?=
 =?us-ascii?Q?+SbExMrG3mEEwCFqs4TDcZAHzo1CKUnH7Ok1O37Mubj66wkJ0jTFG3IWHr5a?=
 =?us-ascii?Q?BiqzX/sKpJFhlh38BbUnA+gJItSGTiBcn9gtgU6CBAUDP3pvdtOOMxO+jWyq?=
 =?us-ascii?Q?3h+SgkRfsEGSQK+7BTfBET7i/lHDdps1DFr1QkPwgrbV+5YjZtfEjwsM+MLk?=
 =?us-ascii?Q?4mCPDbae8VepfplOy8/+RgRBTVp63Ji0UdcgBKRP1CUt0E5kUVuRiA/27lJ+?=
 =?us-ascii?Q?vq/1KMHuLzEm2qtzEIoFwaA21ahJrq7qXP78XSnhy1/fuzZJCSHwYg66eRRW?=
 =?us-ascii?Q?dIoZWLFLR/hw1MB3pnsdowi9WCRusS8SyO+Ur5lHFWeCMHFEUiF9GDk4gdxF?=
 =?us-ascii?Q?xPGXjXYZGPxChwqYgt5TB7yF43n5vdSvt+yYtOzVnIEn?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB7078.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67f8f2c8-cde4-4797-cfaf-08d998f5023e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 02:53:52.0820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jLtkhn2M4Flq0nbi+kUXhR/CKO0eCN0CJX/+s6Vdt4Whrrry9SZHZ215xFx8hiuYUCm/cDIjwUE9/0yxmed2uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6631
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/10/27 11:52, Martin K. Petersen wrote:=0A=
> =0A=
> Damien,=0A=
> =0A=
>> As for patch 2, it applies cleanly to 5.16/scsi-queue so I guess you=0A=
>> can take it too, but I will defer this decision to Martin.=0A=
> =0A=
> Probably easiest if that goes through block too.=0A=
=0A=
Thanks !=0A=
=0A=
Jens,=0A=
=0A=
Can you take everything ? Easier that way I think.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
