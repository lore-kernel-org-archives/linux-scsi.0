Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92D11C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 505D264F1D
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581339AbhCBSuZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:50:25 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:62262 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1836605AbhCBHFP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 02:05:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614668714; x=1646204714;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6/I2AcpIWg+wVFXJYK4Vzg4MTL9+5fMlO0fOvA2MzVA=;
  b=dfYgp8gYHN4PBcmqrn2VMs7nUYq7JTcGn0U+FgHcvi1XSP9wwPtemPpv
   3g8bi25nBY6/CbE9P15TSMLduJHkcg17AMuFImYP2YASR0QpvnyInz+OF
   wB0YKxVeYGHe+AsDGZVwIvEvvrcD1bReoE5FZ8C7+2avdMXWK3Dze6IOh
   mFevYhPicUzsIKkNWKEQeMhX3DHrjIvjRAD4Ns3DU6Z1TlkvrG+G43rPA
   yyYRH8hioAHd/E5e5H4e5Fyhx2bCqr9FI/RkifCNcq0e5VDGHK9oEqkEZ
   5Vv+flNAQIBactgJFAY7Gp0N+a2JFrfRqaTTD209BsIkhEYqKkfn3oXx0
   g==;
IronPort-SDR: rWxhSzw0bFEXRgWzOpzZt4EG/g96JxyPkloOsvFl6mDPzkSVLrFtrEbIQSaVzwDkwVWYQZWDh4
 6lzjjNkIi/XZR3iJgiXW5P/9N6YiB38bsseruO1/0yBK8xyeuDCThXargHL7+rWit1WEzFLcK3
 UfZT84Bu6a4ffhaeNYD1EzU++lFjJdZtfc2AtLBJ/fS6Wvk/lEgvkTsd8aI5ZcjHlZiQ9HRdR/
 uomU2bSI7z/rAAC+fBdSoA9jpps+LjMDjRfpnee9irqlGLwiuoA9TcsX4aSmRItW893jL/CgXT
 saw=
X-IronPort-AV: E=Sophos;i="5.81,216,1610380800"; 
   d="scan'208";a="161148318"
Received: from mail-bn7nam10lp2105.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.105])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2021 15:04:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6cIhQTeJMjXpcv+gBKhPVoZVm03I18e10y7vEt+F9McozV2TPaKOjX2cw19lirh91cwJSi7KBQRFGgB76v1Bg20tcZbhkdQ72L7rk79UFdhyMcGsFUEU3wrvK3A++3GOdaD9NCB9xlyS63F7eVutsI6vk2UUWOzdF8Td6eYllYJKh5enxb0iUcQJJx07dLSLmGU5kNVxoRC+jJmFNJXxiUhY21TofWiOVaTprOlBcmBQezsaHFTLdSF3PLw4JoLaQJmYy6E8LUjeQOW/WiiKUzBIPDWq6VF5CWgt/Z3T50xlTDQA/33lkEx9nTgZrrL+NqQGOUlNCTudDp7P98t1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=84KkPOlAGqhCL98lZBR4T9O3qsVzfK0cIAZhU9Pz4EE=;
 b=iSpZi465deS1jxcn1c3poPKpf+bj86JX3BOzwFzWxvj02aPIFEYvVrYmGvZGhh+iKlx5VZThHz99A1Wnqf1K0NBd8N+J4Dx64Id16+uNzvl1hgcz5Iuo7ZuhximGM7fY5INPUUuuRB/3jaCGjmSGyTiIXEZQvgB+LlNKgiPy3jpD3EEtYjF6SOy/3clVljByd2FzQlE6FULl+rZh+JkPDX8YQXKv4jy0JjHFRXwcqmydy3Y7QARYZU3EO+d692Lgh1q2zZ4F2dIX/1wDisl+777bM77os+T2LFS31XMNgROICNfFzYVEVOegQBzSE28I/4YDgnkRsIlKvsUHjWfAhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=84KkPOlAGqhCL98lZBR4T9O3qsVzfK0cIAZhU9Pz4EE=;
 b=JS8+9qhjDkT1p/XBmILhioul1pedJcm+Uc6W0vU9cyYUmIlGm3qCPPzvhw5L4AQ4HrgYWIAFTcSjGXy7ujUkTniyOlaY26gu3TGpW4bSXtZOeB1CWZlRwZc2pw4RZI73UkccyGIo4sE/KTjnsvoL7pO0F2D9Vg03+zkiKwwcAvI=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (20.179.166.71) by
 DM6PR04MB4842.namprd04.prod.outlook.com (20.176.107.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.29; Tue, 2 Mar 2021 07:04:05 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3890.028; Tue, 2 Mar 2021
 07:04:05 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>
CC:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: convert sysfs sprintf/snprintf family to
 sysfs_emit
Thread-Topic: [PATCH] scsi: ufs: convert sysfs sprintf/snprintf family to
 sysfs_emit
Thread-Index: AQHXDyp+KdsAkQvzZE2ICiXVQJOZMqpwRe3g
Date:   Tue, 2 Mar 2021 07:04:05 +0000
Message-ID: <DM6PR04MB65758DF8DCE75B782D0A10F0FC999@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1614665298-115183-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1614665298-115183-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c2c578fe-c1fc-4964-b010-08d8dd495e1a
x-ms-traffictypediagnostic: DM6PR04MB4842:
x-microsoft-antispam-prvs: <DM6PR04MB4842E959EA7948B451E525C0FC999@DM6PR04MB4842.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:626;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LU0SSiB+rRczRB3bbKMH3hKhjGgYZPH16ryFcTcIaa4n60u54NVg560qyNMflJR2jJqXze91Bc+x0jgo9rTePA1aV2drGJtQQ6SNGh3kZ9iCra45jrOexDXKb1fbx5yE6N6NhkMemwEDa4wursO8RiMwzd8OqdQxi5/B3nTrYz2tXNf+2rk5T6C1cU5gHtXbtxYMw8odj2sSyvnAC9k6mPrCfIK94nXRUE9/FhcSENDzRycp3BS8ghxhyRNZLeZGcVWbQ1KCn0RxmPCFLIqzM9zkABtyg41S9ct7EuIAIuggfET/srhk8KyTCKN/bq3iwE4wdD+7Hir0/m2uESmeND2kDyiFAdZVg8S2TVqLSr7IXlpl3sGRs2PMbe5MT+E90Nt3su96SNVzKlbreM5t8hOb2wUQ+3ugUourZgfY0IhYXo9/rMltUTtZUl137BfM+BQiQh5qEz9tU9qy533C3CQxg5ibBHaN9A/el022EIS/6/HczQOfJPXUO4wKz4kDxwXG+6jz2W8RGDQuwe5tHA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(136003)(376002)(39860400002)(86362001)(66556008)(66446008)(76116006)(64756008)(7696005)(66476007)(66946007)(71200400001)(186003)(8936002)(54906003)(8676002)(110136005)(83380400001)(316002)(9686003)(2906002)(33656002)(52536014)(26005)(55016002)(5660300002)(4326008)(478600001)(4744005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?lXc5VD6ED0HKqCBklyv1FXSgIafLpnmREW11+CPbtYYCyVV5HxvL/puHX2zQ?=
 =?us-ascii?Q?EGCMfqOEAIkZmy32zAgtmKUHzXlwwa28LoIQNVq9i7b6pjGhb3U6ioU65nDR?=
 =?us-ascii?Q?+KW6hjVTHzmNT4mEtf/7L9aMH0zwcMGtpZrS5p2Ow0slYrTBhfKL+UIdVYuS?=
 =?us-ascii?Q?KLnwueY3eWmyl+4IoXr+nlNQxch7C4dgPo5yAeMc5prIaeOGV7VaofZDXAKI?=
 =?us-ascii?Q?PK3PAaJBzgsVYECPxcK5U0DPTCREWZebojyGGM7j93usAke7OYyymPE1xjY4?=
 =?us-ascii?Q?WCHYQXMdQ1XadG3yZhtjSTSwmLt/cP3fvJl9vSy/AazGww+iNoQc0Ip4vzUl?=
 =?us-ascii?Q?TpjGRDCEqi/4Ta9T3sP0Y/PneSDiroLz9YXoy9O1f53ZP+PQik+SBxVWqw/H?=
 =?us-ascii?Q?IMxqmtMJqj+izTeiaZXiaxua1s7KHQh5FfSQrISQ1ObvwwAM1v1XgWYYcLae?=
 =?us-ascii?Q?NppcYaXXQ3opHUGmbnKKWRzddJBZlMHKHdb/ElObfUrbHjJ/tGCOkAQiXNAb?=
 =?us-ascii?Q?rf7S+eGCLbpw/qnzastiEz0HdckKXz56c2s/Ny6VUuepOU+I9h1CqpaJw+LQ?=
 =?us-ascii?Q?j+TKd6kRQ3kUdYWApQu2pCf8GnXlrhNsvEhyVTzdSQGBUGfbdX6bc7geYzPb?=
 =?us-ascii?Q?KP5OsDQ8M9zQxks38uOHag2WE7X3LoifzDgYwx71qKaSOfu5gxxGfmbfY+8I?=
 =?us-ascii?Q?/rdHOVM+ravoz9WIz1kOYtVFmRw10eu/SvZb6OH418iP0sx69cQVACElmeip?=
 =?us-ascii?Q?NU9cKeXl2fKa2jM/jpaY0pS3lk+9UwkQw+uOjJmbRMEdVMpgWoJ5ER3qCdio?=
 =?us-ascii?Q?erMkmbpQkvJfsgBLqr8i5/U/Twh5MWM6mTJcIXXuDpCtPyPJL5S8PxEV+7eG?=
 =?us-ascii?Q?Uak01yo7rpYxb8VI7BceKJ1e8KrdA5q/wYfQGg5FJZGXFFPJLOOVZ1Lf2OU+?=
 =?us-ascii?Q?dAUevPcvoUwnqnTETVJoNH1TBFo+Dm1XbsL1txPiYzi0QIP3UasqAk/yTULn?=
 =?us-ascii?Q?uaiN8JUluyBj0oSEpQ5Pd4dxabJVDmAy1ySo/9H/Xtex16BXArJ64NmAKR2I?=
 =?us-ascii?Q?Hxmv/TzjH1/BXWmi+rP5j3UZsfQoimdXfZzGc+g41WkyKKywZO/MgrCE9whU?=
 =?us-ascii?Q?hRdu7ZSlgw0adBxzd0VMKJA6d32btrmJFM8PDw+Rb/1ql1hk6nkp6MOy+K3j?=
 =?us-ascii?Q?bG5UF9laewGyB9zzLT9HIasTxXpsF9MmDa4DxxfI4gDdoKgdNhZYWsE1w4w1?=
 =?us-ascii?Q?yMgUcE3hmEHoO/F1bJFI5ZRyoBs330prwbNxorE6hEawZ2+7DX4muOPDyqM0?=
 =?us-ascii?Q?pd96FP8JSM4T417+hEAc/Rox?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2c578fe-c1fc-4964-b010-08d8dd495e1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2021 07:04:05.2948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jbwnuPE1GaaCWuvTjMwWEydDq4RnL87nMSG1+SdJPdSGK97aEv5cD3/3j3/1KwEez4jv0GfIwjX3QTpe6I4Ycw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4842
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> Fix the following coccicheck warning:
>=20
> ./drivers/scsi/ufs/ufshcd.c:1538:8-16: WARNING: use scnprintf or
> sprintf.
>=20
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/scsi/ufs/ufshcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 7716175..7fb94d7 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1535,7 +1535,7 @@ static ssize_t ufshcd_clkscale_enable_show(struct
> device *dev,
>  {
>         struct ufs_hba *hba =3D dev_get_drvdata(dev);
>=20
> -       return snprintf(buf, PAGE_SIZE, "%d\n", hba->clk_scaling.is_enabl=
ed);
> +       return sysfs_emit(buf, "%d\n", hba->clk_scaling.is_enabled);
>  }
>=20
>  static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
> --
> 1.8.3.1

