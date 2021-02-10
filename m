Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9487FC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 18:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6166A64E15
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 18:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbhBJSN3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 13:13:29 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:41072 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbhBJSKg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 13:10:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612980635; x=1644516635;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AsG3PvdJP3NvU7C5QWyNQbypgSawW3yd8Cr3UG73ZW0=;
  b=PENdFHM4RfhQ/TIuAzC2/ODYb+jvQ+fexoxr7bnIgJYg0YJLl8SHDGgj
   OVBMwyhH2kFkE44BesuHIQkPfpUs5VkEOaiYeNtOUYR5few2ir47cyfgc
   7WE7fCmXuaZ+cRP2zB1fb3d6n/yW2r2M/rSccw7DLpCIsZF4kWFfMSXvZ
   ENggSQhREUl9DF2cFnHyLJzGn5E8rKaQaQXtDK6M65w59HS9CAk/QdhAH
   OCD2Bgo207Um3j8GND14PAr/UDKhlBt6kStOqARBfUDnxUVexzz8581yT
   ndYPdZV0pMhPOqmNcD+rVBmHUru1haCB1nwUcDlC/pK8AQF9jPXAkeDyl
   w==;
IronPort-SDR: 79meIjfThScWvVxK7E4AfGafw1ykuFrcWX46jW+efwXn98KDlKxyDZJPVeYMPUF3fiFbLmQVw6
 1kV1eTHNRl6LcuwehKyjC72QRvGJWSBzgN0EMohrSCqw7yqhe+/5u+VYRFaViEPR8b6wIkFYPR
 IIco+nLwkUMKAhJZDdZ+KNYriw2wOKKhfAjxwxdMa3hGZegGXnk6ZWOKknLykmn3ZPb157Z+Ew
 rC7jsdYFkTI6NH34AVpDbCWt0ulg3EAO6Vohhgh3rddylI2I7flqpkxLNpVQWB5nBMIbb261oh
 y7E=
X-IronPort-AV: E=Sophos;i="5.81,168,1610380800"; 
   d="scan'208";a="159664324"
Received: from mail-bn8nam08lp2045.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.45])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2021 02:09:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QgRahvVUYSpPdQ5dFAKsEGeBTkBWWxnrwmdOqvTF1JIfZi0EOdW7+9fZqbFSfZSGCkGSm2N/otxI0McdOKJ0wgIvDztd/+1n322GwfAF48qRNfQdKL7IC+6oaNV0v6xVgSqmrIW7VKkywOpOWuqJMWqZaIjXUlHpBiQeMcArdej/DtwVpYUGSMNLxBBIJGv96i61jpmte0MynVdswwmVDyfTJePTqxJ2g8hkDQ6GE7phfH7w68wsK8wVHaj9oc8dqBHdXRXipTDajDyL3BIt05Vka9rrEASg6d2cCcG4HSftsa/CaKvBovFJSH2pQ0Z7V4+9oS+wZaklak2MhOEw5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cCyckYohdsywiOXLEbt+n2EkKefkLWtTQZ/r6tT7ZKo=;
 b=A9eh4rpAHR/XTdfgH3lxvPrLAlugHTpDK7x8bVBWB0LxOV4v8f2BXLFOB5yWarwbqR7WrqK/AchEClxkFDFj/UmcCQqd5la46XLXZiaAb+AgUnEBa/gJjBvEG2rj2Aa1Vciuaknekfjyx4r8L1iRT5c2bsWON1F8lZsMVgfw+6LLu/DxkPF1mPaYUcaR5oj3i8UDXlHYJRAL9ij6WBwXrc5lLLM5p2nLrcUWYJOQ7CaiRAiLosn3uquTEOmKT5hCsJnDCiLqCzQwOBJxHuXMx72oKF0ZsCDrcrH/NYOld8RId3WeAoMJuSyVsRyTGKA/H/fXjp8nORtJTZc+Ce58Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cCyckYohdsywiOXLEbt+n2EkKefkLWtTQZ/r6tT7ZKo=;
 b=SiFMDx2C5arKtJlnpbHx6BdBfTzi/YUXI4AmpJ3bJSSSdqmck6V9hdmd+8OyRhvRu5e3p8LSQnl/xQi9XlfnGvCRdTpkDxoF5/tQ9KfcDD8yfLJG5GnvDY63OOCL5vSS/ABTk0TK01J/ZkQ1ZYDWXonybpwRfSZxHDIdrEYi5eA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR0401MB3656.namprd04.prod.outlook.com (2603:10b6:4:7a::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.23; Wed, 10 Feb 2021 18:09:23 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%4]) with mapi id 15.20.3846.025; Wed, 10 Feb 2021
 18:09:23 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: RE: [PATCH V2 1/4] scsi: ufs: Add exception event tracepoint
Thread-Topic: [PATCH V2 1/4] scsi: ufs: Add exception event tracepoint
Thread-Index: AQHW/qxDGTHS29mllEOWiXxyvmFw/6pRsiFw
Date:   Wed, 10 Feb 2021 18:09:23 +0000
Message-ID: <DM6PR04MB6575634DC857C1E0154CFE08FC8D9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210209062437.6954-1-adrian.hunter@intel.com>
 <20210209062437.6954-2-adrian.hunter@intel.com>
In-Reply-To: <20210209062437.6954-2-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ce7020f0-e6eb-4974-2f23-08d8cdeefefd
x-ms-traffictypediagnostic: DM5PR0401MB3656:
x-microsoft-antispam-prvs: <DM5PR0401MB3656B4B78BCE7A72553C6207FC8D9@DM5PR0401MB3656.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 91E4UJutA9hvRycsS5pvKZwysP+H12WkCvFhXAhrth1iN2xdDfVmG9/ih5CtHOELaGqGLlckTZdu2aFuCdmcG5cvxCi27J57DFJJmbEm0r1FtmRRLkMpqWTgruKJCdG0c4CGFY68p5PtVAa83ATP+bHWc5pEHI5+JYgVJ1ToFnmL2bxrzOAeUNf+2dFb+SkBeVgN1Alh8s1LkgAPf+uC5n6tp6nEA8qGFthN17mqs+3edU5JDjXSEnxkqt3gF4YJ3XPYr9R9EnDJOJdkCULf+EFYxljxeC8X6TooJ1p5O3gJQvS/7/ZA1U2Ps8i1W5sgFRZo0X4TXsM1IVpG/DtabiIVNUtf9RqTXpk1brWaK9hXenmzWQn6v2dlpA8elkn4mEaBEKqbtrStx6bPdrJdnWiLQZHhkO40Mkr5AN5MTmtiibcKwTeOao+GQO6V2HDgm20W7grfComYFbHe/o7oG1YJGXlczk3i2SrFmQzvGKFvdCH7u67GDN0RsR1fy/32u9bDEEHfEjPBOayfqj6CDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(376002)(366004)(136003)(86362001)(76116006)(478600001)(66476007)(66556008)(66446008)(66946007)(64756008)(55016002)(6506007)(8936002)(186003)(8676002)(26005)(71200400001)(9686003)(316002)(52536014)(5660300002)(2906002)(110136005)(4326008)(7696005)(33656002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?g/oylF5DDW9dKQUaK40DbtwRJvxfQf06ZDAEzhfBHxHfcTpKkh8Pr/b/bYG5?=
 =?us-ascii?Q?en/HqDle4KvT0fGWudztf6IuiJmexcTUefjRqfXVeq9HbnDXgZvvRtFtl9+k?=
 =?us-ascii?Q?QdhfszjuU4vuIGe9HjGa9x0gCrJTnMsLsDPRWaULfcgII/8TnrJui7IUbdeY?=
 =?us-ascii?Q?I4vEWUis7cACNXdUuZB7OD1RuTeeEhvUF6gmE5Uk5yccAXrGVec6RC5heWiB?=
 =?us-ascii?Q?gAxV+aNaM+RSCD7yKNbGTLCtIez8Xz2OugX9o/D07vv/mPd46+3AzrC/6C3q?=
 =?us-ascii?Q?K/+H/KhcwWKHuVT09g+nu54rKwxbBFtoYZTr8FyvfPllHs6wBjt952w2dTM5?=
 =?us-ascii?Q?bejwckfP4c5uH7oVemBHpDOnz/4/OhgQRTVEUJ0GFnTgzhALK7fnOUlsrU9U?=
 =?us-ascii?Q?UYKZLvW+enCCiBbk42r9U73goK2bzmaNoVBQwG5glaJolsx0vlk1/wgar24H?=
 =?us-ascii?Q?7exiuhQO01+4l+0Y2X4GfMH9qt4Ox4772bnEYo/rbnsjkdrA8TZS4nSAyhiQ?=
 =?us-ascii?Q?zUso7e/goI5y6WJKzqamr33T4/9Ep6nDXbdYwv/mvC64AtDvGJmAefoYWxO4?=
 =?us-ascii?Q?0YUp+I4TYaKVVNNPGfQKM3B91f7DBUcBbKQEiIuAkuoLbtvdX145PEufJDGM?=
 =?us-ascii?Q?mKfY1LSbN0cEALZN90UHnFQBJGgcW0srplvlciR2oqp6eMB50a+5FAoc8yqv?=
 =?us-ascii?Q?9MZszg5eRmq8UKPVpkHeaju/KWRhH4jGmmAsY6rxgrptXbiK6A5tYLy/ayMC?=
 =?us-ascii?Q?k2L+QuN7JnSqWlH38D4uMeRvJkEyPz8IFptqMc0N9ms6DeiGrDi2R1+ZgJ1I?=
 =?us-ascii?Q?Htrys739OyOQfhpOKarFTOkB22q6y6i+UxxyqxMS4R28dCj/vU5pp548w1EY?=
 =?us-ascii?Q?iT5yFfhkXHUdiV3CacWvTKudlgpJVZgHZA4TtgbIhG3cIieZtY66+7BTkYX4?=
 =?us-ascii?Q?e4IsL3UhYqfphJ1QIeCO/KdoqeLWK6yY+FxYa6izKImSYbufrEYx5aBlDAGA?=
 =?us-ascii?Q?BR7PnlFI6LugLuqfmSQVdNhWPUcNlolkXCuraOVtmhQgVGYFYxL9Br6P6Rcp?=
 =?us-ascii?Q?J/j4vxyTyeSKGrxWCZknVjjCwFB97LUkdwu+ZLiR7zYxheY15CVoCiSgyw5L?=
 =?us-ascii?Q?h2jswupuZskZP44eFkyLhiWh7caMotea+hdUj5tpictGusrVX0pRAuogRTle?=
 =?us-ascii?Q?yhA1nMV5iNwXyCukwtokQKq1zVjMBdgA3kzaVOP8usD0QkBrArpprC/5zvI3?=
 =?us-ascii?Q?tES5E5Fkm7M0Ht3qM9/rmlYLNJ2EKT1gIod6h+lOyMiynytHXZabwHU69+BU?=
 =?us-ascii?Q?xXhwoMj0XV0qIAwXl6PKUsOC?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce7020f0-e6eb-4974-2f23-08d8cdeefefd
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2021 18:09:23.5636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZRjv7PlUhNCpvUCwmZ8x6AfZ9/YM5kK07cuw01TFxWzpRgHAa0QjE28UJrg12y4lhl1oZYvwvHru3ZKA9EuRXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0401MB3656
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Currently, exception event status can be read from wExceptionEventStatus
> attribute (sysfs file attributes/exception_event_status under the UFS hos=
t
> controller device directory). Polling that attribute to track UFS excepti=
on
> events is impractical, so add a tracepoint to track exception events for
> testing and debugging purposes.
>=20
> Note, by the time the exception event status is read, the exception event
> may have cleared, so the value can be zero - see example below.
>=20
> Note also, only enabled exception events can be reported. A subsequent
> patch adds the ability for users to enable selected exception events via
> debugfs.
>=20
> Example with driver instrumented to enable all exception events:
>=20
>   # echo 1 >
> /sys/kernel/debug/tracing/events/ufs/ufshcd_exception_event/enable
>=20
>   ... do some I/O ...
>=20
>   # cat /sys/kernel/debug/tracing/trace
>   # tracer: nop
>   #
>   # entries-in-buffer/entries-written: 3/3   #P:5
>   #
>   #                                _-----=3D> irqs-off
>   #                               / _----=3D> need-resched
>   #                              | / _---=3D> hardirq/softirq
>   #                              || / _--=3D> preempt-depth
>   #                              ||| /     delay
>   #           TASK-PID     CPU#  ||||   TIMESTAMP  FUNCTION
>   #              | |         |   ||||      |         |
>        kworker/2:2-173     [002] ....   731.486419: ufshcd_exception_even=
t:
> 0000:00:12.5: status 0x0
>        kworker/2:2-173     [002] ....   732.608918: ufshcd_exception_even=
t:
> 0000:00:12.5: status 0x4
>        kworker/2:2-173     [002] ....   732.609312: ufshcd_exception_even=
t:
> 0000:00:12.5: status 0x4
>=20
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
