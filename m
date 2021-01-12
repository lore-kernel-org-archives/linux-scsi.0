Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCEAC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 09:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C9F222D2A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 09:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405655AbhALJSl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 04:18:41 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:59484 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389926AbhALJSk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 04:18:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610443119; x=1641979119;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bCbj0F3Bh8iVMWL+1h32WT7aLLvVUdJcrLrwHGRyaIY=;
  b=HM/bN6ip2+foO7UoNzmr39zmvZdhFHSoOCWnqFfdux8qZRR468knOnQy
   Koh3S+Umii73I2wqBK/6KaRXgctxa6FRwAyyPOfwbVwkKnu3VqPvxzdKD
   pnnka3lSodyfUSrDSaoXdfYBq0qEua//QQoCQhMYVaI/Iud71hO2aHmpm
   lW0FD5ZG9sFrmQKJfNuWZ74koPrrmt525MYxoP66O9V5VCopdYaS12xb7
   awD6MLVe/hRGUH476FT4Z3UCB9HiiOCRCL/foM+a3BljWJYMDAWqPX9+P
   w1mRtQGDQ1nbD6brH54XlJVhgLEBEqgsUPF7R0omOiNRbBQu5MKuOYaoZ
   g==;
IronPort-SDR: O3k+GvXf/LJk+BbvrgZ+ZBH5hOvYLNwLmMjBF3ck0X7fJdEqxxjNatRl7otqDRYxAsa2sKjYBP
 hymZ/gJymH5cWJH1EMR76L9nnSN/sZ9hoLxKIMXz0T9DI7r3sjv+72TfgV+2RuHDRyYWofte8g
 7jvlGq1lqlVc2fIhuVnbBK0KEjzhkCAcg7mnKqAK5jTAnsP94OCfISrbeDH5o0auYY7jasGVEO
 cecSbpFmhjUoThM1UJsHNmD89UXdWsOSqTqOFbK+QAefoXxE14eukVfq2TB0ygiCa5kfj4oMk4
 F80=
X-IronPort-AV: E=Sophos;i="5.79,341,1602518400"; 
   d="scan'208";a="157229395"
Received: from mail-cys01nam02lp2051.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.51])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jan 2021 17:17:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j3dqw7kXVa1Tdxk16wYq/L4uRrxIcazSHIup5XsH1qWPpvfNYa5eJg2LQPN4gyWRPMrdX3vj/Lj+fW3fGNRjxv3YU1vNeg5vCk4hwmVvuo1QtDomT+duOMrEg1ohVKEiHpa4imokt/RyT6dclqeJTglDCHVg4f6/gDOB0iq/i6iwRNSABpeXDA5TPGOZ1adtfN/NexmGsILucDk81bqGRGlCZlCzOhDmwwh0mnXPAbXZQU7oBqabSYW2vtOO02YPBLE0TuHrLozNokHUjgiMRixRs23q5Wb4onDpG8/7lt8WIw0se40BU1lQ6v9zcOFT3JBhatAgj6CDypUYVqkptg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bCbj0F3Bh8iVMWL+1h32WT7aLLvVUdJcrLrwHGRyaIY=;
 b=WoELj3DvZh+hLWRd+5mQS2NfVe3D0f19idflD4Imv3cUD1IlUy1eDnHXf6TUFeItPKs+HsFQm/lKWNhl6LGFPEhBFTrfqgXHBs2qcQU9DKaYhLgvTrb2i02nTvTYHR2irVk5zhEH/Ua/p20RSohr9EMZb/ZCOTZpzdvl4croVKbiA2tflwwe7GEZqqYJCRRvFrqHsFOCCSt6oran81CEJuL1KmffFbCCfUDuPag4Lo3pLnkO81cQ2tXJUayGiYCpVi4hgQNr918Eoqh2VzpP9lcv/mSkiHXg1X26m1oQgkKOax+VO9h2I+JjkiNwwUJAnmWSFgAz3e5TyOzUVTeUaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bCbj0F3Bh8iVMWL+1h32WT7aLLvVUdJcrLrwHGRyaIY=;
 b=cCrNX9YAPRZ3a9q5r6yuOKcW+oM35jNt9OS4tsWZMKxvqIwA61IX4b8BcgIg/xy20H9L9FDdMNsXH/AIts8gsSKoQi7hN27S3m83PgosWdUVZosZu3iWDfdiGlVLPbm5XKMZkFT14VbBHUauyFMnUTwaUldsTSS5mztL4+J8F/M=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4028.namprd04.prod.outlook.com (2603:10b6:5:b6::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.6; Tue, 12 Jan 2021 09:17:32 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 09:17:32 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Ziqi Chen <ziqichen@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "vinholikatti@gmail.com" <vinholikatti@gmail.com>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>,
        "kwmad.kim@samsung.com" <kwmad.kim@samsung.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 1/2] scsi: ufs: Fix ufs clk specs violation
Thread-Topic: [PATCH v6 1/2] scsi: ufs: Fix ufs clk specs violation
Thread-Index: AQHW5a1LwcAHKIpxKUOUEAR+hemnP6oju/gA
Date:   Tue, 12 Jan 2021 09:17:31 +0000
Message-ID: <DM6PR04MB6575DC8B914C90D3861BF4D8FCAA0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1610103385-45755-1-git-send-email-ziqichen@codeaurora.org>
 <1610103385-45755-2-git-send-email-ziqichen@codeaurora.org>
In-Reply-To: <1610103385-45755-2-git-send-email-ziqichen@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 59f50863-3ec0-43bc-d2eb-08d8b6dae42b
x-ms-traffictypediagnostic: DM6PR04MB4028:
x-microsoft-antispam-prvs: <DM6PR04MB40283FE256726DB93147D0EDFCAA0@DM6PR04MB4028.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1002;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8JY8GHmlGjxI8Z5uJs+fXUUGUyj8q52I+j2QMKcVnNcV4bfPF7siYSPMio2Dx7yYMwULZD17eigF69p/gt+XHlhjMKjKS5BjKT7z2Gg72/k/9B+j4GSbbBICMallodhfUFQr871Npk1hs6xFuSDVI7OCdXn45UplW3TrUADUoQqwdxRhcXPW8JHg7X1gZrsidaH3ELCcl0Cq3Fzz/ItrQ41C3Fqdae2ECp8OGSA6ijEhm9nUJKvzPDbPOayv/DC8hNem5Yys0Gq9NrV6JXPpRrEunQurvBruQuEEs6aQOg8whRSUt+xwbxVAQ2nN7iwAn3kKQh0qKa/0rXISI/3Rz2CwuJb6yBZzLL1LyfRubtxQw8JiRUOcejwOBN0Ht4omqw25JFzOnjL1jrw5siJnFhxvaPuCAxQ+ISXeOQQlY8u7mrin7t2Q97Wp5loTx4U6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(558084003)(9686003)(71200400001)(26005)(33656002)(76116006)(7416002)(64756008)(6506007)(4326008)(498600001)(66556008)(110136005)(2906002)(7696005)(921005)(186003)(5660300002)(8676002)(66946007)(52536014)(86362001)(66446008)(66476007)(54906003)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?nuYPAyZIF0DtBla/ojMtoYrwnMdntcjKFsQ3xXqu3lRbqtR+2EeBj7fWTk9y?=
 =?us-ascii?Q?j0Lyq4/0HI9HJ6M6oNKHj3Sa1yT7HCz+sakbih+kKEiiuJj5bkoiXVGpCVpb?=
 =?us-ascii?Q?5hvOA9LZ0G90l1tOziIIAJaXhypb2ZdUZOae4SvdAO+MuTqI+NZJmFAcu0C7?=
 =?us-ascii?Q?k0sP2moJhb/pVaQEocGD1/3VymClZPKc+uW+udmzjSL1oucnwEzvnv4SVC3l?=
 =?us-ascii?Q?yTBzDSzmOFJWXKbKN/PsaqP4yBWHB4FqgXKqSR3z+WIA96FHlmfpy2UtkHrE?=
 =?us-ascii?Q?2QO8OVxWAb7DTT2KSYeiz1SNWyKEO5RM6eavyO3ufjL9xW0yGKyXZTUjg6SL?=
 =?us-ascii?Q?oxOowME6wO5c6kb7GJYiGmxFuDei8yPK/VRlZevXgNgp4NBzFXyVzR8JEypt?=
 =?us-ascii?Q?sIaA38mM+0iVbzn5358vZHDCQTZf/rOquCQjLbqY3SZDUn2HCUQDCqSLZMyp?=
 =?us-ascii?Q?R+d358ESxeXjO9E2XDjJcLrn15cWS9Wpht6yRnBbwFUU8RrWDNWYGz3xOY7L?=
 =?us-ascii?Q?yFsiAvWzYxy2cB40kYoAWERsPBpMrHOmEJn9pesCwS4+fYYOdvOi0O5HBnjh?=
 =?us-ascii?Q?EtFC00S4yqu9G49HQotOlbl80yZZeTylNeLTV23Ej/la5ZrNs16xJvrbSNxj?=
 =?us-ascii?Q?G3YfB9AdTmVNAEOJVwv9KyONCAvvTr0QTEZuUcJfb6Dg4uBWVumMOVinKauc?=
 =?us-ascii?Q?DeQ/1GokDMG1UsgmXSoGUI6p0wYl+Bc0HBT7D6wEsTngnGRcIr6D0GdHc3gu?=
 =?us-ascii?Q?vrsOKrYtTY3rP0xMjI4Xhm/HOXcr5KPABglU3SwK366NjwK/nGJAVHrF99XT?=
 =?us-ascii?Q?7JGPXmcl/8p092zossQ1FN/P68K1Zc9ICm/XUQk1v1SqOkZOVe/mK7Atw9Vc?=
 =?us-ascii?Q?So2cgaFSGUKx3IH83UeGZCffn822qXPF6NPeUdd9sLZiVMGZ8TW1YHuZI0CK?=
 =?us-ascii?Q?YbJRrEdaXL14suROb+h7GdURnq3/BryG9j986mWiLzA=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59f50863-3ec0-43bc-d2eb-08d8b6dae42b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2021 09:17:31.8734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8hH4fCIhZnRjnnftthirURzjRPpp+dKt5k3PlsW6oCNhv5sniWSYVEQ6y9bvUKH1Qenjq/numfwxmM7QqXmlVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4028
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> As per specs, e.g, JESD220E chapter 7.2, while powering
> off/on the ufs device, REF_CLK signal should be between
> VSS(Ground) and VCCQ/VCCQ2.
>=20
> Reviewed-by: Can Guo <cang@codeaurora.org>
> Signed-off-by: Ziqi Chen <ziqichen@codeaurora.org>
Aked-by: Avri Altman <avri.altman@wdc.com>
