Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6147FC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 14:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 381B92072C
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 14:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732577AbhASOhZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 09:37:25 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:24455 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387439AbhASJ3p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2021 04:29:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611048584; x=1642584584;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VYb0BXiQJtOAiOfaabg+I0DtkW8uo5nju/KrgjCFAvM=;
  b=J5tIuBJwAwoI7OLe7xrK52+C8O1T8raT/FrnMQHMTO3uccnCJfkhbyPD
   pqVTLigYa7iyH5em9wotjDWHxwWXlxZqHEn08eE1KRHLe/b0jtXPR4udX
   PsvxpZieltCa9WHUUk4+ve3TI321MqdUmIKKnFfMDABKVv1odexlVDxPx
   b+c2j+pX2Kl8z5RbKAgWZA04AWtWOPmeVQDHQtWM/COGUOOZ+JoX6ock6
   id9/3Owf4ZvsMw1s2XiWqjhK1lwmzeXM494IWNchnX8zyeRlOOaxPPjyS
   aysXOoZDS9cBo2IvrQ2Dqp4B2+MUqETtfhj6swl/VAt/gJC7PzpWStzQD
   Q==;
IronPort-SDR: 9xM3qGmvA0EmL7oVd/Z71JOr1PMGvJnCeOkNLovnt3vszkf7qkAyKRO/zeWhX7DEq7nG5oUgGm
 9UoNHDOwyVYlNk/kQyu8ZaaU5a97vxxNnu28zCLABJOTEu+m9wAKGDvVUiEUgvgLfStvQPg21o
 DIOun/+vOb6VTFA1RaOnWT6llRYk3AOEtF46oETrcuAVOWdlRlFt66mW3Q4wScMZnYHsvE8aHQ
 MlDyMpRKVi5nMoxXlF0Cw4CDGwqQz/0lj5Ei9G3LuzzuCeM44xF3qvMdiNktnImgzDWaiVa84/
 pJQ=
X-IronPort-AV: E=Sophos;i="5.79,358,1602518400"; 
   d="scan'208";a="158960680"
Received: from mail-dm6nam11lp2172.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.172])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 17:28:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fbQwdhhGzX4wxbyG4nR34WkEZ8m/hNAD4RKvUGkZ7lB8DQmvURZAmpv+Y48Vc+vrH5Uj7xTF/xy7OJB5wdam2FGwAaX0aw69uo1KT13VZ0KnBkM4ZdjbM9v85oNvwQt9ZlPp46owotsFebf7VjA3brlHR5NdXUwdpeeM7EIJpNsGtN5S+PS9c8pouTA7FYLGZXqd+V3nZhKkKd6RV2I+APV6/nOedRakkthMozsszj2rTJE5Ls1TkFVOfcO7Zv7QCDblnVN6j2xYT3yV6rSgniHIkwnD1G2xx+ZZn6ndrW0DzNZkqgv9U3kWxSfZR54l02sX0g6+ki1yGS+hBkIxUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VYb0BXiQJtOAiOfaabg+I0DtkW8uo5nju/KrgjCFAvM=;
 b=B3MPFZF5PzIJlGsO2kLQxVwdz41aZS3xaAvZFCb3x5iL5hXWCgCaXCsiyzqEajBH1Z3gtUI+3xTFLD4oWdnJE4609CI+gjzB6tX3d4F7XX/K3fV4OftNkJV0f3CiDyWjioD2n58n4Cm+ekpTA41DLWPvqTCCSvKt6EYmyBQeju1zyHTHmraqUj1eYRNFV8jAiEHGYr5UYgVRNZUEe1IYE+EWbn71466IwoX3iq3OJvV94buVhDKvW0Csy4voFJmWD/VEetO96Yo2IbVK6KpcQuV4gB0Gjd1W+u/iwSjjRZ7ZSZzO9I+8TTniyrF4x8gFlmcIuIt3FUxhOgDhQlS9RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VYb0BXiQJtOAiOfaabg+I0DtkW8uo5nju/KrgjCFAvM=;
 b=f1f9VSqBn+02xOKyGYxXxPfI7IyT61+yDsW6ReN0o38Qdb3zHLpYX3r7F5usrqagfCLn2TTr+dbMuW5hZXa6kfsK+hxiuSMii2mZZxE/AYRVE5onbji0blYO/j/eTFWGi4i7DgMRe3U5MUbeMUd4wjJRPHz1LRXs69eQQESRrig=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB7132.namprd04.prod.outlook.com (2603:10b6:5:247::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.10; Tue, 19 Jan 2021 09:28:14 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 09:28:14 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: delete redundant if statement in ufshcd_intr()
Thread-Topic: [PATCH] scsi: ufs: delete redundant if statement in
 ufshcd_intr()
Thread-Index: AQHW7dZaW0JuPmYTxkCI7jZkMz323KourvEg
Date:   Tue, 19 Jan 2021 09:28:13 +0000
Message-ID: <DM6PR04MB6575BA0870E0C2DEA03119BEFCA30@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210118201233.3043-1-huobean@gmail.com>
In-Reply-To: <20210118201233.3043-1-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c830018a-171f-4ac0-db09-08d8bc5c8bc3
x-ms-traffictypediagnostic: DM6PR04MB7132:
x-microsoft-antispam-prvs: <DM6PR04MB7132089660CBDFCA2C16C863FCA30@DM6PR04MB7132.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:644;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FmQsyOJbVVPRvWaWF5YM9HJzqG/NZ9c08cjHgkKuWvkabpqOiwfkn5n7MjuVWEIYu77ETKGSy8oQT5iKkG5ZaScUfgtxAefiTKQliw+vaO+jQ+hNmBxP5g0vnB3aTIbaTu6UAMgUPnQhY1RjoHhXD2Sj6SrcSerK8RiE/zOVJ3+UitWpZHmi5N3UVKWJLoOPV+o0OJeV5CaP3MiPuBF+bLA7ujzm3efqVind8O0uu0LPkhK06DHhxtUISLxSs4pdNMlXrJso/a7ElHodrVf/j6fo1IEVP877W6lUWmHFyApDGnEDzV0uhAi1auC/M8s9IvIAm6pJvshjtF7iQ5EXzHekjjOG9ZJNf/hL65w9eZubqXH4Yn3Yymt7nKfWRhEkLajB84PgQEmdxEwXu8s70LMGEwO6iM98GkyAl0i+6B3IHsmHIuYW1yyXXoGRW6t4lj1kRdyVNDkDZJuYfAHk/KokWzAusMz/VYgIkcS+04d6FdO+fRgcnc0Y5/1fu7Fzg6jVwARMW37+N2MRtwTto9ph3t3z1/IUrVpHM0tbvSpcH46xgE75hxQDgOrurHmm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(9686003)(55016002)(558084003)(2906002)(7416002)(110136005)(8936002)(71200400001)(33656002)(186003)(54906003)(7696005)(316002)(86362001)(6506007)(921005)(4326008)(26005)(66556008)(52536014)(478600001)(5660300002)(64756008)(66946007)(66446008)(76116006)(8676002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ZHy+i+PsTPcMaqknreTA7ltriGiqRmkWDypVHUuZk4ViHsOA2DPEQH1et4Y7?=
 =?us-ascii?Q?8NwKr8pDtHQbfry2Ca0pcyGi162WtW88T+ntdLuKMY8WoMg2j2Sk1Pf44xH5?=
 =?us-ascii?Q?k3wgtPDgb4MtZwtha29tmsAegiKFGEsah703ePvIPT8MoJ8LvVnPts/pgWCY?=
 =?us-ascii?Q?ROIjZ4ciKBWb1TgBOeFI+CbSMJvcQik+qKmDse+IMKWHKhDByI+rGXWoXbxu?=
 =?us-ascii?Q?MChV7f3GtSgWtHTbMk9tFAW+G+hEUa8JQTgfWdqd+kgqYAvF8AaIk7pqiU8a?=
 =?us-ascii?Q?UysB7RX3SJQ1/4sji/MS93L8wzV3uDMQ8mD3pcDQCml2LGvVQSbiuP6vDv04?=
 =?us-ascii?Q?Ss4sgUysA+NmMgh7rvtWyCfda1lZK33CQPxlmEdX5gdLZuahqPsuBfNyKUoV?=
 =?us-ascii?Q?DeM/B5EVPy9o2JQd6aUH0vXXiDXKA9azkrXu+oAOT2N5W25WbWapoGqcV0Hc?=
 =?us-ascii?Q?rOxQXodNPMsAwWHsRYjxJZfXYdmrQAw+00FbvQaOMdYZ70bP33RLjNBM857p?=
 =?us-ascii?Q?Qd+JWiLCx4ZCOKo2aVNgZZtYwudpe0RA1gcnT1w8vWSPJMQv4HxuNFEG5AjT?=
 =?us-ascii?Q?C4BvEtjNSEwMeGMkPBFfFtj0hBLwG+ArgIH6n2RBBJHIqdTjQukQZdZwpqZO?=
 =?us-ascii?Q?fmaElnatnZoNs+XzBP+Tz0GwSGwTGIzG4PRm/lG+nmjNx6r3S6s0aYaxah0T?=
 =?us-ascii?Q?7qzt9dn/T6R4O6la/znGIXsxOvrr3SutSKppxukHNyEKEV+9eA5VkWNqYhQ2?=
 =?us-ascii?Q?fTwd67BuIyaWxCpXeNHyn1kZ+MnPTh+i9zz04/7aL7ejL4egsQrXjXLMr9no?=
 =?us-ascii?Q?ETzEzfO1NGagQ/o1+Dn08ylkdCOipwNRNcClPQqkp9OWeY3srthvwExgsrop?=
 =?us-ascii?Q?P1UiE9ZBY2PYoD92MDdXcFopFF3E4xj+pmbvjjTrFfcEFpkGFUNMD83g0MUb?=
 =?us-ascii?Q?Ff+a8JqUcUx0vy+baCqvsXzYjyoJnq3nB8bfhHHNQMg=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c830018a-171f-4ac0-db09-08d8bc5c8bc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2021 09:28:14.0199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xXkyRjNpzeBjaHMawVOvQK4Bd5sFEqA0tpL4LAnV7mJyPUtOXo2ArCvULNmphwapE0SPPTZqGj4+JfsaX4UOdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7132
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> Once going into while-do loop, intr_status is already true,
> this if-statement is redundant, remove it.
>=20
> Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
