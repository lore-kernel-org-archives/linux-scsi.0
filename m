Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A76C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:58:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11DDA64E2E
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235245AbhCAM6U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 07:58:20 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:9386 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235233AbhCAM6P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 07:58:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614603961; x=1646139961;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=MDZbTlgQDNcGIwp/rOZvm2c0nxdspQvqEFZnasqncKM=;
  b=GSOQY/hs7c/beoK/WABxlAFd89v3LC12GG5T+opCJEpqKLbFhEJ9TdQ+
   uopv0aKP8gSE6iCn1NmPjPg0D+c1oKbanw8/TVRGpZB3ulFtrt9ZCJFsM
   vBWnGYU6oYp8RDHuzcgWVU9xGPd8XlC6p6bru6oWX3dTh/Rd7wWHj65EC
   qYuydDHIZzvzRfv9ca/hMapIS40AgzkFXg0JNN7Fbrq6Pe5XGDP6ZDrVu
   xwrnGIDd1yKxne+JW3AAh3Kp5z44LouXbMc5fUiAxGqK7tMRIkacwUzBD
   yE4ueTi09aJKIh3omgNezr3ZBOpzvfkx7SRnLXq9EfwY9IPkof5dLBq1n
   A==;
IronPort-SDR: hgNmEovyLWManG0ceSk/fyr0FICCMYmrxoO1ollpByzIQD/KrTOhjtIVUSw5sG0XvShaqmD77u
 fZqS294V4Q2eQcfyEkChrAQcPko+0rxA4YBTIdzBzcmHuFR3PGtsYLjsPIQxWZAOPNNsRIRLTl
 WfAEHeXXXtANVwBRFzQIesfQ243nSgLf7+ZD0JeCU60VwJz9NDszqhHpZ1nE9NoteyWfqDO3Em
 R9PRJtpYEvf7mj2JkH0lyhROU4zAulL3AL4yQSW4VRY+TxetDRn52O6tCoKj1ldlPUhTne7pSX
 X6Y=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="265332479"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 21:04:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h75Pm6xOdahuWA0/pJpPg3poajpoIHMoHpaN/uMyfcAOq7/bpKTdU6YrvfcXQtS2UEV1/KrKtH9xlC8HG8C3Pv6nzbkT7jxfb5NBcdKGPq/7PgG9E1DCBMCQgYW0kvbSZSdfxGAV6G45qashjG8KhTu+RVfVQg4RlYv1BTYjhmconEqrRLNewg+/LDDCeWHYrlRjGuNrr0W6Lj/ryg0ARROZRveHeTcsKypLep6bvDvCGEutir25pKDWOZ20gpmEflppgJtv3W9J0E/tq5EOWjKxjfXsUhyBlKEK4FhOTO1DZzMYZVqrtMcD5MZJeYEe9gI1XBB7veEz/olkdWohfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MDZbTlgQDNcGIwp/rOZvm2c0nxdspQvqEFZnasqncKM=;
 b=SrgB6sdOYUcR7xVtgPh0Mq3E9UB6a19IfN4XcQpaZ37c0Ur0n9qMnG/TeErahuNxf+O/Z0U465jCGOAd2TmNvCe+AO4oH5BTXnFjkAYJeizOUFXQKrRWxjexg/8Lgd7fQiNdMD065WkzKERh7vYiQM4oxfl6S9X/DclhBd+UkS5B4dDVVoCC1wPQc9ThLsegNsbFpQAVAe8WJHQdHs4NvWfD5Ju8UfRCp8g0MFBlo2Dme+tKpmH+v6rTNHBSt6pP05wTEgkThIF3s/1Cn5DvjcIdbOc1m/PpLFIeCjRe8wlM/N+HbxTcHc+HYYAagr26UrRrL9gXEILe2rDGcuGgbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MDZbTlgQDNcGIwp/rOZvm2c0nxdspQvqEFZnasqncKM=;
 b=kWtj2OHJPqW6yujTmzu+nGwMR7qIG6DU1HwIdbwZq5vdoFhffmfjSYVCvLVbOM4A1bq6QPVCl6WunQYHrgiB+fULLp1GsRvr78pIdS7NIo1NCOOf1XDDbxYUV7D7IlDa8WvEDGG7MyWhESnKEhw0yCGovDgpXyAxXWTZfYn2l6k=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by BL0PR04MB4452.namprd04.prod.outlook.com (2603:10b6:208:41::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Mon, 1 Mar
 2021 12:57:05 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::e9c5:588:89e:6887]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::e9c5:588:89e:6887%3]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 12:57:05 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Guido Trentalancia <guido@trentalancia.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH RESEND v2] scsi: ignore Synchronize Cache command failures
 to keep using drives not supporting it
Thread-Topic: [PATCH RESEND v2] scsi: ignore Synchronize Cache command
 failures to keep using drives not supporting it
Thread-Index: AQHXDbGOoQvSctH05k2iblGBdDcQpA==
Date:   Mon, 1 Mar 2021 12:57:05 +0000
Message-ID: <BL0PR04MB65140D17E1F922C72902D107E79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <1614502908.6594.6.camel@trentalancia.com>
 <443d92dd844e329bcd40a1e59b7cc3784ed3db94.camel@HansenPartnership.com>
 <1614582394.13266.11.camel@trentalancia.com>
 <BL0PR04MB65146856C07649917652E540E79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
 <1614598394.4338.18.camel@trentalancia.com>
 <BL0PR04MB651420859C04C068419711FDE79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
 <BL0PR04MB6514DA80936D19A42FC9073AE79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
 <1614603122.6918.14.camel@trentalancia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: trentalancia.com; dkim=none (message not signed)
 header.d=none;trentalancia.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:347a:bb00:3286:307b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 72e01a7c-64f0-4578-13b4-08d8dcb18429
x-ms-traffictypediagnostic: BL0PR04MB4452:
x-microsoft-antispam-prvs: <BL0PR04MB4452CED4A4DF805224A4CF7EE79A9@BL0PR04MB4452.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6c6xYHqCout8Y1s38ZlQUbynfTzKvufyQR3C9OwXGUqKxXQz5yTYVGuyGLkMgY9LALvF03bOyXOptjnGfd7bk/aabY3FWSFS9ujdqAVxiLXcmx7EiGGKx/sUAPJcdk6eO+9OLUuu7MoPGIU3QvzsMqAqGaCt8KMZlDNoRo1h6FnuGEX2uevdCJwuCU06XmVfHb5822eGckgZkcay1Xazd2ckt3Fa5ebsjmGWuHada8HElr1XkfJ5t9IE9Gm87FdrQxDw3c4y8RI3FYS2LpEz6ZardDvIoA/dXcLFZTUR+1G10LQ6kitCtcGpy+dWfLE2K/5XoQRF6W3vEJULl6x8f+hjVhtLAbt9m1nv88qNeS2n5lj0OUZG6YEa+ppgSXE+vd+za8Ahu/w4JZYtJlS9Dy14Cd/nPaOP5QGMOLUuF/diB+8hbZEb6skEMZmiFGtn3qnpBio1AY5HEu1XBvdnds/HG80v32zTBQqvjq9gIUcWvw11wshkfHlZtOaabCNDCRH49qCSPeJHSO6d+5gzyA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(366004)(136003)(2906002)(66446008)(5660300002)(52536014)(66946007)(66556008)(86362001)(64756008)(66476007)(76116006)(83380400001)(71200400001)(91956017)(9686003)(55016002)(53546011)(110136005)(7696005)(33656002)(186003)(8676002)(8936002)(478600001)(316002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?j8MrPaSpQ42nJB8dHc9f/ZmphxWQPIWCUhlQp5gLtysfWuon06Hl22MhD2VU?=
 =?us-ascii?Q?Em/P2dNNkXUgjp5scpXfkEuN7gXL63Y7ncd0ON2WrOmxonkN5W9uOGvosDrw?=
 =?us-ascii?Q?yr+xrKQBua687C8MsYd8sRb4uhX4nVRKJee+js2czKlqOYT+qlETfdmhCA7a?=
 =?us-ascii?Q?6SlNiL2JUACCtqKxHpBz+dXA2h+2GhqmiWtUgVhmUMQHe43nvMPDtVgI80UG?=
 =?us-ascii?Q?oMBIkSA+4ARsyJqGmutMIrpU2e9VMQs508Qv998JBMMkvuNpLbKr+e67ccZM?=
 =?us-ascii?Q?KIgWzRz0qGDF6VEKmlL0akDkja+MC5608svkORTVO7k6uCQlu4H+ZE2tcI0R?=
 =?us-ascii?Q?lF70xO8uQoQYzqNG2JbR0VntSJRwSqSXUjCZvr8mETFxwziowNeIh7wvtqBW?=
 =?us-ascii?Q?19ywfc1pnpeO2yGSUYMYYAlyTw7zYUTrLs5laPhwZ/m7mKo7vl/TjcYOzcoo?=
 =?us-ascii?Q?TT2pGOlV7dcq+6ppsb0mTCzv4LMa9AgKagyKsRyxtpWq3xkt7qNSzLIgFGve?=
 =?us-ascii?Q?EsWq4J7YNRGhpH/Jsb5XaNmCk4QfnbhSCCU2J2I7IVXfyuTcD83H/FeTsuAg?=
 =?us-ascii?Q?BzJ7U2NYdwD056nl8UXDxtSEAZ3YS+BGst3eYICL8CggEHywHx6FOOjX5oF6?=
 =?us-ascii?Q?Ml9foYZpqEJk4FCBOI0ztou8WWbxBCcxS+hIf8FA6Aw1Nx0VKPBfv4xVQsDZ?=
 =?us-ascii?Q?cOYDeFGKHKgpbK7XxOhh/U0g4cFzk5am4MyxkzKJ435imWGxRL/bi6l73D7R?=
 =?us-ascii?Q?BssAcZ9OiEfXq5hR0xuLhNxZP+71UHl69gh+WgrCzJHVfMU4THOZ/uozRaG5?=
 =?us-ascii?Q?u7dTnZFKj46IybGET6dYC4N2R4gjICxWTACCkLV5zQheePJCZzQspd8oMm0p?=
 =?us-ascii?Q?feS/TKQJO+h8gkHzesHq9n1gzEV976OQEpOPvgtLRmW1t9u1s6KB9BrUTlxm?=
 =?us-ascii?Q?M/NqDN81kkiD7kUvpBn7IBFlGJKTWh9VM0oRZ+tvammNs0v0D3+V4EXhEl6B?=
 =?us-ascii?Q?XaVj3OKycTH5Sj+wEbX3qx1km3dXOcDXa11zmcCywCJKSKffN3I4mM7vbwX8?=
 =?us-ascii?Q?kPWvxLHIkQTArgLIHTX0P5LZJl9OzyCRlNE83zjA/fOeluL80pPTPqUQDoRv?=
 =?us-ascii?Q?PxsFoez/hfhpyEOT35DQ4s0OCUWoPLh/ey+wMQeHd7hMh/E7I4Jj1kLvmJiB?=
 =?us-ascii?Q?MycvP1tPA7ESWJ7mGnv/NRiPjrCrsfKQuq7FZjWwD4K7iId8mtEc0lNvypxY?=
 =?us-ascii?Q?5A+oEhrgF40LBUwaSpuocppGUPTyV3xI5dSYdkSBdyKpICxyR17SDUMJKGaF?=
 =?us-ascii?Q?tF2yBkeiNjtdKR7xiZRjpUO/i6GLBGoQNVoYdJM3pBIWTt78ABfqLeyCOzmE?=
 =?us-ascii?Q?TvQR3xssIVdK5VdJutflei/oh0uM3UwKa5DFxfL0nf2K8Trmqw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72e01a7c-64f0-4578-13b4-08d8dcb18429
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 12:57:05.6556
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r5zTW7Pu8QPe4dTbzmpw4Ukc3eSlcJ8DdxdGEubjxAebIW0aIlNOqUl1H3+jy4wQu7J2/PlgddP8j5PaEguOtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4452
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/03/01 21:52, Guido Trentalancia wrote:=0A=
> On Mon, 01/03/2021 at 12.42 +0000, Damien Le Moal wrote:=0A=
>> I checked the standards again. It turns out that SYNCHRONIZE CACHE=0A=
>> command is=0A=
>> optional in SBC... Aouch. Got so used to have that one on any drive=0A=
>> that I=0A=
>> thought it was mandatory.=0A=
>>=0A=
>> Well, it certainly is mandatory if the drive has a write cache, which=0A=
>> seems to=0A=
>> be the case for you.=0A=
>>=0A=
>> The problem with your patch though is that you disable write caching=0A=
>> when you=0A=
>> see an ILLEGAL REQUEST/INVALID OPCODE termination of synchronize=0A=
>> cache. Which=0A=
>> means that the drive was already used, written too and the cache has=0A=
>> likely=0A=
>> dirty data and I do not see any method to guarantee that that data=0A=
>> makes it to=0A=
>> persistent media before shutdown. Imagine if that was the synchronize=0A=
>> cache sent=0A=
>> before shutdown.=0A=
> =0A=
> As already said, I have tested the patch for over a year now and I have=
=0A=
> never experienced the problem that you are foreseeing !=0A=
=0A=
That may be true for your specific drive, but since we are in uncharted=0A=
(non-standard) territory here, we cannot say that this will hold for all su=
ch=0A=
weird drives out there.=0A=
=0A=
> The current alternative is data corruption each time that the drive is=0A=
> mounted and the inability to use it.=0A=
> =0A=
> So, the patch is the way forward for using such drives plug and play=0A=
> without cumbersome configuration such as disabling the write cache,=0A=
> which advanced users can always make.=0A=
> =0A=
>> So the only reasonable solution for such drive is to use it with=0A=
>> write cache=0A=
>> disabled from the start.=0A=
>> down.=0A=
> =0A=
> It works well even with write caching enabled.=0A=
> =0A=
> If you have an alternative patch to propose, go ahead otherwise I would=
=0A=
> push for getting this merged and sorting out the issue for good.=0A=
=0A=
As mentioned, the alternative is a udev rule to disable write cache. Or if =
the=0A=
drive supports that, permanently save WCE=3D0 setting in the drive config s=
o that=0A=
it always come up with write cache disabled. No kernel patch needed, and yo=
u=0A=
will note that this is also exactly the same as what your patch does, witho=
ut=0A=
waiting for an error.=0A=
=0A=
> =0A=
> Guido=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
