Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92BDC433C1
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Mar 2021 07:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADE1561981
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Mar 2021 07:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbhC1H0t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Mar 2021 03:26:49 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:8506 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhC1H0U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Mar 2021 03:26:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1616916380; x=1648452380;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=4l3LUwOQYthAAnXPOlGwmOyXldi62vsC2F29anH8mRw=;
  b=AnXcZJZoK3Jr47OQLD0YIKu5iUp46quPcfR3Do+i0J3Io2wsFy5oajV+
   /rT1Q05SrfF04l0UD1LIO6v/zvVY+ipeZ0aYuFWoHGaqgHegve2inl5gT
   V1Z3NJ9rvTpgpzudKRsYSH0x4n27bcuGm8vBHlUmjk6UMDZ1+KFGFq3uc
   GWkLub/uURxnA4YjXyNWXVv1G5jDZU0lc0roYIIIJ+CQPIdlKGhgmkv5v
   G4UezVGsYRhj3WP+3HLX13WdjcVrujB8cBVv0m3EmCrsFvTnWGPr21evc
   28J1RB77UDnAOGsqiVpVfnyv0w7+UyOA3biAK6FwTpuB4cXbd1fs7nYv0
   A==;
IronPort-SDR: OJ9HEC5+2vPX8PNUztq9/aEcIw8JgARqNMIs5IYYOawpUSepGMkX8CciXw4Vh8EMhTWAOPzR9w
 iGKp6trd3oUvHRAAksonZs4SxeUhssi1aZMvA9b+1nV67/T6UPGFZVlEQDXB9O07LpqCdgHVrg
 tBy17ifaNDZxBW0q+vIK4l35kNgbcqHl2xj4igJkdJQK/hCUsOby2sPA9ihu3k6Pl75LaWaHr0
 8fLwTjrpQQ/3ylZSuD6WpRGGnEQ6TwsMGX0pBhuzHK5uYo33Vuw/8mhaIR2BeYtsajwc8bQWhN
 REo=
X-IronPort-AV: E=Sophos;i="5.81,285,1610380800"; 
   d="scan'208";a="273964373"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
  by ob1.hgst.iphmx.com with ESMTP; 28 Mar 2021 15:26:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PTQtLSaaCFsTT9UC2yKA6rvk2QkqbeJsY72funEHUMju2iaOdAzfZ2iiec+lAj7uToYwJatyf2l66WiH7SSWrv1sF9dfzWZl+A8b0QnQKBknGkzufXErxbpguI1FDY/89fDpjJMiRK1vKVKoEmyiIkAEilemDLHfscBX2M2FnbQDrkkSVqJ56RVg/srfXDXtoNvTwcOcMMDgr4D1agRa/2P616XDHd1S0ChsJW1fwkN74r6XT1WHulXyCLPhhB82neuOuJxFR4VL/e7nhJa+zW9WbWXpJjjrbbbs9Qqc/w7AQ2YVTZaB9SzpOUr2xy4RKKX50eM38Ix9XeCxn9JzRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eJKiX1v7yLMVnjk1fxsWK+HuaGxRHdhIYRS2sDLKgr0=;
 b=FbkXHcD1G+UkCsxX7gj278ZB4mh18kka76y6V7vmGsNzTuhCfw/BaOzYLzpncCxWLBfhkgSc0nTAnNY7c6t9G70kfZS1rQ7HTETHLb9rCy2Eo/1GgCAnAwScUu5tOTj+twDzfaw8eOOKnyYVgw86PhTbtT2rRAQlpfwF1DuKxJgSDwri7DTccInO9XRMeu9JUjaG6hc48H54C1he23E/WhxOMMiqxpxbGef+7xjf4+jc3M/xEgptEcdc7K/Y6QLQF3WPJgPELfVN/yUDSkI3V4aX/kxDbXuyJW9JfPSQq5S8HhsIxHCzwYIEmRmCM2fo0sbHaO7pgTZ/BKrrr4b6eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eJKiX1v7yLMVnjk1fxsWK+HuaGxRHdhIYRS2sDLKgr0=;
 b=qYZotzfOkKUD3GhLrw1cs+lJ+Xzu5ZQEzEn3zqVkvyrlvJcY66kpG9XWHaGbLgoliCovmhblM4t8msc1Z39bAUSgawr8fqMoppAuajFjCwxHOjwIHxmE+5mjcHYQqgm81NVivDRWC+72HccheDRPOEEsyINcddYQrCndr+U0MZQ=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5018.namprd04.prod.outlook.com (2603:10b6:5:1a::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.25; Sun, 28 Mar 2021 07:25:16 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%4]) with mapi id 15.20.3977.032; Sun, 28 Mar 2021
 07:25:15 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Zhen Lei <thunder.leizhen@huawei.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] scsi: ufs: Remove duplicated header file inclusion
Thread-Topic: [PATCH 1/1] scsi: ufs: Remove duplicated header file inclusion
Thread-Index: AQHXIq7xjbnOsIbviE6bc7X8F2vjo6qZAXjg
Date:   Sun, 28 Mar 2021 07:25:15 +0000
Message-ID: <DM6PR04MB6575C67CCD7939C79393320CFC7F9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210327021316.2021-1-thunder.leizhen@huawei.com>
In-Reply-To: <20210327021316.2021-1-thunder.leizhen@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f1623750-4e53-45ab-cd3a-08d8f1baa228
x-ms-traffictypediagnostic: DM6PR04MB5018:
x-microsoft-antispam-prvs: <DM6PR04MB5018C9197A375F4AB84E8F88FC7F9@DM6PR04MB5018.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JpEKTHdRo2j60gsKuLnSfCtN2WA63oHtV+E3BxuJMOWAJYxpdgjJhBFZXdJqR0nHISgy2Mb9YHk1PG12L7oR2LoC7ru6yjLlsLQrFQUzi+QkVdplWmcXi0rZ1A4xvaikZFv/c02YNtOn3ji+hONSMnisL0TWiW3H9ThGxKiGJhUfiecsBwF4mFot6e51NoJF7t51BwH8N7B90GM5xCbplc/sdzsXzdYmMoQJGgshgAw1Z/VSHHB0QpP/00i4nHRqn5JdpnCU0IFJVERN2MT428J8sJGkD5/aKhJsQIUwwVlQiZ8iTSjbisH40eK3CbR04f0mIgmTtiUlgNbMM1cw7huOFgD0pwjm67Ig8Eabu4HHVkdTWO2N+xdoii4xNGj54AkFniDOMHcjxhh83mloEIlAC+mHm8p3EhcJtiXguoCf780C5bA3kOy7TSuTuThSjo/fdlvvQdVYMoC66kT8tvr1/GruC+8AAoBsq3RU6TWRYx2uCb1fk6WvEkiTqui68K+3VJLSj3sKQz/BoMUw07wuCdI73O8qo9OwHVMvlmLmjr4DcS16IiC5Gh4nxFh8d70ykII5qgoD2STa3XAw95JRUQbqq+0LNdJoSNfvs8SpUzKeLQlAXONdyFvDVuOaSNcCNh3T+hZEX164sS5mJ59vBNzCMQ1wa/9aLxwWj4+4wa2KWZai3BxOy7CNVAFR4WVnAJKY19oGCQgBWpXg7++BFiVeUYeMXj4G6zbFmjY02qhp6Jf/nhzgtUZ7a79T
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(136003)(396003)(346002)(376002)(966005)(33656002)(66556008)(86362001)(66476007)(55016002)(8676002)(9686003)(2906002)(7696005)(110136005)(8936002)(5660300002)(478600001)(52536014)(6506007)(4744005)(76116006)(316002)(83380400001)(186003)(66446008)(26005)(64756008)(38100700001)(66946007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?vltRLupVdISIeNfh+BKtv4Awhyvc/FtrL3Gy5KtzmpU0TnjcbNH51svRuBV+?=
 =?us-ascii?Q?eZhabUVacZib7OURdaFVqa/c9pDslFRsvR8t9pmqDkFlyyE+Kd3Rphy74Wdl?=
 =?us-ascii?Q?xRrG0yGTx82TttJWLFlYE2UGZggg8kKm+W2ydMXYcQdKxvp1nE06ZarXLcd5?=
 =?us-ascii?Q?dRbIHYx2o+5LpcKPYjKlVZapCo/5wxcEteMj7qu2eeWCjNBywjhN1yrlhFI2?=
 =?us-ascii?Q?cT9uY3/uMio3YRi+tOewa4eGp+JO+15x1tB56HurPf8bzjR4sgNUt00iNjpG?=
 =?us-ascii?Q?E9hfcxar99Lf8Zviing2KVAnqtGaZQ1Xx6hDW/0bAH0FPwnz3ZReeDpZ2KII?=
 =?us-ascii?Q?ZMYNv5frd2qRlu1oU9O1I6d2xph7Ns2N2/P21BnFU8fvOpnf2z2B9CXpKp1r?=
 =?us-ascii?Q?ANGzi4j4ixuggvIfydXigmA7MZXaTpM5whWDlQ+UrTqthpAZVaBRw/WiJrg1?=
 =?us-ascii?Q?t9jpNW3nIGdEKktkIJ96txZF8G6XERTP9f5aAbCacfi53f7FgvkfzHpira66?=
 =?us-ascii?Q?TegfxcgdRIuBpFjBH1quUz7HkRwZrTNlnYGJEZQpFDOYdjtuqytOpMYzhxVs?=
 =?us-ascii?Q?c3bHqkh5J3uhQFIxu4JdtbVpdD5gMaPQkQXRn2AcF9a41yt9uNBoiQ8avvQi?=
 =?us-ascii?Q?yp5msDwOS7V8QeaqVoQk+pg+rJDtdlEOzoQ3R0GKiggEE+pNdHeeaB7iFtyK?=
 =?us-ascii?Q?b/yOYp6RcogyrywtorCV9w0d4p8DIL/DCQAIb5ZgKpIu8gsMWst9kZYZFBXi?=
 =?us-ascii?Q?yCZUWrM4V+OJuYuBjoIgGQtoFZxpr6JbSzdF/UmDoZUviSPWtShYnEiz5o9t?=
 =?us-ascii?Q?OegsfpfGSW6tOrO3TW2SFr0zeea5T/TbSnS7WjUZvgNeAEYpOdLLr8ZWvnfG?=
 =?us-ascii?Q?K0tLq9DdHG0IkxW7r7KldxxuWVBdflwAi3NTzfOkkhdIPPW/vuapFxwIzHri?=
 =?us-ascii?Q?FjeMXNUaFjFzrd+lO3RbdBCIL84T0vcw77OvcM6d8yJCLOVXqbOifer9JR8J?=
 =?us-ascii?Q?jQQfxTXxkXpuIxKPHB0RNJMTVl15Ony6a/bFu3CZWbYuDt4RnlgC52ErLCjg?=
 =?us-ascii?Q?WsrBMXRWo/WgDCKWISxxghtnFhOXlWoMqqhdQrIPudDahDfTiJXpH9dO+5dr?=
 =?us-ascii?Q?REZQUBoDLcuRGa8nHFzlw/Mgw8NDDXQi5badAjSdmv8AbZNtWgeclGrZePbA?=
 =?us-ascii?Q?rHmPXlH7bsUDkl+3ZJScHo4f4/vn7NFSowjSFSY53dL0UwTF+xRzx37vCv/N?=
 =?us-ascii?Q?LGd5YUvOnWWl6kG/lJ5r79X6dHz4NKf6ERiIQkI1y3Rx9s6V1JVmuHPOkweO?=
 =?us-ascii?Q?fEQ=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1623750-4e53-45ab-cd3a-08d8f1baa228
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2021 07:25:15.9151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N/zq4i6r/bApEnM9yaMsIMqB7O/0as+bVAi86A/WVcEFpNJhf4cWlBR21+slgFzX7C9f272+T3q4XjuibN2P4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> The header file <linux/blkdev.h> is already included above and can be
> removed here.
Already removed, see
https://lore.kernel.org/lkml/20210306114706.217873-1-zhang.yunkai@zte.com.c=
n/

Thanks,
Avri

>=20
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c86760788c72c9a..e8aa7de17d0accd 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -24,7 +24,6 @@
>  #include "ufs_bsg.h"
>  #include "ufshcd-crypto.h"
>  #include <asm/unaligned.h>
> -#include <linux/blkdev.h>
>=20
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/ufs.h>
> --
> 1.8.3
>=20

