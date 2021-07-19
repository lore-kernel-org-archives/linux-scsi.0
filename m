Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974AFC07E95
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 18:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72ECB61164
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 18:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352657AbhGSRcf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Jul 2021 13:32:35 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:49830 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351510AbhGSRaD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jul 2021 13:30:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626718240; x=1658254240;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Vc0o0COV2LhNGLniBrQZCa/SM8Po/LjoplgaEfDuz+M=;
  b=xrM/qY9nCe5C79QzgiS9vFBvKgKRr0PL6gzmplANjwNQIvv9FbFco+CQ
   EowreiXec2prpujIZ04d/TsCQOu67SV0WfTZVuBdJwnG+BYpUnZanHipL
   rbvtp+AD2UZP4XLkUJM3sDtBlKW5pGDnShhb2+v6y26uvCpNW/rBBrAEw
   2nCt3p1PDqOOVaI4Yf+1JzQc5jhCIHpXlHTKVnBpsBwqlztorpiqfUxcV
   hoHM0VajO3PPr21+34sNo32KmrZR9XTmk2NazfHWu4A1CdQhwCHdi4j8k
   3Za5uo8My8jGJnVXGbr9mB1diSxiB8ZsNQTuwjGPnYWqNK260L0CIF//H
   w==;
IronPort-SDR: ns72I9u11//DMp+N8abaVmk0HhY1Hu2p+sUnzvgDGoB+UXAQ8C2v2/Q/orhJNyMBUlcGB49EQy
 S8EhqL7fRiyrgUneDKV25+aw4iqMajrOAnPAePqZ3sGrhN9uvCVPoxr+x5u0a0UqRYR8zee7wj
 xLi/UqSA1uCD5+X8kVDFePWGBIqbyxSPe7KUZWTXv0OVBPuk28cnUs1fQ24/CiPbZHUMqYjUSG
 WVxdxais29tbWwjlwcOTW7KhNP0yCRGGJ+WugrWaGnYne2kRNfWsqZk3t9YU1qZxUCZWJDMXHM
 fJuIvxUI0vhEyKdjIaN5ER9J
X-IronPort-AV: E=Sophos;i="5.84,252,1620716400"; 
   d="scan'208";a="62776699"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jul 2021 11:10:38 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 19 Jul 2021 11:10:38 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2
 via Frontend Transport; Mon, 19 Jul 2021 11:10:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nt3o94F9s57UKcYU3K6ceNHJjdjw9wXWDmy8GnbWEuVjchFQ157wWEjyoMLPvC7KmEz+JOPXMjqrtsp/6br/jMdDUJko3b7LxuxoC6S+rB7fDHrl9rpGLSMpsS4RuH9y6SOW/UcS1YlOLMPttmwHLwNXNwPrviPQrU+FurvxU6vpvZ0XiaslSl7d7GvUZkSqObup28hzyopJ0JtA3pzoV60hZPkALcfo47O8uBDeVcPlZNG0LIHG5JmZHM15+SGfUfIxXSJNxXqncE2gefeRbalwUgzi4pG2xwU4fKc66AEABONnomSwchPAiRrY1SibD1Uz4cTq7tYal5ggkjp1TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vg09tiT66BTruwsqMMqB9QbKTpIM9aFed7vkMGXS/+c=;
 b=oa3jKvHs1Qq7+yri9VJwON2ubTlqqN2OqsZBtz3wggHTaY8m3BqV3HIKD44iig8+wkIWwZWQ48Qhelsa5kvcxa8PX/3mbMb3hyYX7q8LFHEmw6KsZFWraS5K5Oom72WoC6oW6wMexY2ZJsAZzvPB3NrIR6JyUuTpgyaglNeUCvqnlaBDeiQ8TxKWrt9nISw6o6iYbMzMn6Eov/V4t3GBeB8NsnFfRTwICY4np7q/jvWDea9AMcIdIw7z1mkCgt0m9pWZ4b+HVV/U+2G8XzcqUKr+oPeROE8VUVrwhl8ohjTqub3XGIqKho1Xed45ISyDBjMViPIPvW203D/MrE6+PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vg09tiT66BTruwsqMMqB9QbKTpIM9aFed7vkMGXS/+c=;
 b=UazXSi1t7PsT0yuyeCNcPA3PpZxh3jKeYOCZ6k9QY6NEHaZvrM5ejCXI9MoTHHA9Mpyov2cT4DuTYnO1OAJqIgUCiKgSEPuSMpuMrOJECWvAnnmTnBg9pmgzEcj9NoypddtbxxM1hAgqN5MOtNk8cH9UiYZoFKvAf9+2aDGWngA=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB3278.namprd11.prod.outlook.com (2603:10b6:805:ba::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Mon, 19 Jul
 2021 18:10:36 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::e0af:535:1998:c7ac]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::e0af:535:1998:c7ac%3]) with mapi id 15.20.4331.033; Mon, 19 Jul 2021
 18:10:36 +0000
From:   <Don.Brace@microchip.com>
To:     <martin.petersen@oracle.com>
CC:     <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <Mike.McGowen@microchip.com>,
        <Murthy.Bhat@microchip.com>, <Balsundar.P@microchip.com>,
        <joseph.szczypek@hpe.com>, <jeff@canonical.com>,
        <POSWALD@suse.com>, <john.p.donnelly@oracle.com>,
        <mwilck@suse.com>, <pmenzel@molgen.mpg.de>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [smartpqi updates V3 PATCH 0/9] smartpqi updates
Thread-Topic: [smartpqi updates V3 PATCH 0/9] smartpqi updates
Thread-Index: AQHXeN4wxw1zrsodRU2cw33w+02XLKtJnpv1gADLuOA=
Date:   Mon, 19 Jul 2021 18:10:36 +0000
Message-ID: <SN6PR11MB284825637C72EF8A5E8B2418E1E19@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20210714182847.50360-1-don.brace@microchip.com>
 <yq1mtqjyqgz.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1mtqjyqgz.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b3f6eaa6-0f31-4d23-1ada-08d94ae0822a
x-ms-traffictypediagnostic: SN6PR11MB3278:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB32787DD28F8305208EA46AADE1E19@SN6PR11MB3278.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0NVEIkjhAX3tY6Wert0yLUjaAC3aZSIzFmAtHzrcwgV/Z383ILBNRNvXCM/mUHyD2YSUnksjjHZ4y4uZ+/CbihsbXF0gUWYcpok9RARRCsRiaXy1E2BvXK/DYztdtNcGQyFgSZ9oEIV9IaAWojLMobcgJo8zq7GBWn+MDzpQ5ziyb5ltWRCbpKaQMF+fdeSqj48PLgKPHl1eSzc1r81RibUAoO3wx3UD/oOeLcygoU487ZwPlb1cceAAquEmBSH9sua3zEFTBQ6OZNSkSqpTZ99LS09ezCDUPC8zMcoxxtaBaOCUyIp06L9TgcKHsXn6kSnKJW25lHwtUiTjznST7jklUnbSO+ot6XYbzc3tnYHDzXjDCvCaasO439E6cjuc87baZ86Tf2+S0AuKgzeOY0yNegBIAPKbU0wLU9JkpVQnuN1IVvzFpTsPL+ONgyWcyY61iZmPNVwNFl7ru6vnGIsQbz5UgkzpKmrtnyWNBNtzAKKaVPd+8fYgXf+pHlRlob/W97p/xa8sQQzv/5ZvEGoGKDLk8asS8DJpw1YksPe3VygXVBGTP+zr8uJfYehV5ICQapM2TZzIr6bSWhBiD/YNZmoJthSLiIOECt0O8mI5zs66P9P0FTJh6VzEZqFoE5o9NIstqgEuU/l+ZtQ7qHI73L6muTnFFyuJTTTbWIoUQoLatVZ6hRx8VFyQ6F1XIfJ+pcqOhzBuQ3g6cKYxxg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(396003)(39860400002)(376002)(86362001)(83380400001)(26005)(2906002)(55016002)(316002)(76116006)(5660300002)(4326008)(6506007)(6916009)(71200400001)(66556008)(9686003)(8676002)(38100700002)(66476007)(7696005)(66946007)(54906003)(186003)(122000001)(64756008)(66446008)(7416002)(4744005)(52536014)(478600001)(15650500001)(8936002)(33656002)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HGtx4Wxboatma2znCX2OcntRfHUPAIFnW/5LIlNqcKmXAK7TZdIAr3Yn3iyS?=
 =?us-ascii?Q?vfjMguZWZlPzQzQUG4bk8GfRr9NlzRIOJsyVZrPBm/fEFnLSPVLwlQ/3aSIQ?=
 =?us-ascii?Q?DQkCBKV370psBK7eO0HsqtcTUYAdZw7Z2mCrwRZIKwScQTE+RERyS09h50ET?=
 =?us-ascii?Q?SX/pAxBza0G1+owAva2ynp9kMo4ygXNKajMHbs9vilgy5BXuWDep4viMmI2m?=
 =?us-ascii?Q?77QuRmSeOfXgXY9HX6srjgt1mVkvvh7+Hv3EMxOIJ3BZI4sOYDuCYSSzCPCO?=
 =?us-ascii?Q?TdZ8cAzQHild+P22MK5NrugQqD3XsuN0OFBHEGp9RjfDoBmdA2PUXS23j1s6?=
 =?us-ascii?Q?sBs8xTFAISkc4lOcwmiJX3RXoz/Ro+MyIfk4srwF3BgAyyK8Ac/IEiyTa1Vl?=
 =?us-ascii?Q?Mo2t4l6h4d74mXbk5+c5ShS7SCXrbrJ5Z4n4JHw2/pYXe6a9wMpBahfCatxb?=
 =?us-ascii?Q?XKBFdygZGZB9nimmhtmnQLKRawonNVikC3k9rETB5Jm4TbXA5r3G5tqAlZeF?=
 =?us-ascii?Q?o08oR6Logrq1Xd5wdAMSYJZztv6bmrvbMhyCJrnb5KI9kN3vIQlXPwpKYXf7?=
 =?us-ascii?Q?lmWirBu1nyiQmfYLae5zyY2fvCU2lvlyQmaKNq/q57nSZMrUxJl7f7JCkC/k?=
 =?us-ascii?Q?mRyWuN/fnOibtj3sRaKATTA7yPHa1FccrrdK3M1Jg6C76oqkD45mCsv85feA?=
 =?us-ascii?Q?w4+5sBILqVpUn5hr1E7osOLlxpZmaFajsIpSL5ABK6Woi4fdtsjfpGO6qk58?=
 =?us-ascii?Q?3gvL6A06VTQtXcQtJoJdmZL3T4pYFEpYR5r4aXUM0t0LutxD8VF9mMVMKuny?=
 =?us-ascii?Q?/0vmpN6nX2YXxpT++MU47LlcWGvNn++P0oCYqYC/Uie3dPahOHQsF+9nu451?=
 =?us-ascii?Q?G1UlWXhcBFVhy9DJgLi+Z2OddFcuwMVY46OvEKTL7sJbjHF2kPdgXHm9pbYp?=
 =?us-ascii?Q?fURU+2KaBTqlu2ICYSiKN+L3bifcrO0rsNoSLq+0lFCR55ksWgFPaGVXF8Nt?=
 =?us-ascii?Q?tczjG9j4t2yOWGJgabkN4xYnlojgqLD5sA+VoZHsT0jXHoXQqJP28/T2VmsG?=
 =?us-ascii?Q?K1VveTVjzhn33oPEnjEL1fw6SGtXW7gyUaKv7TDEqW46LGneCRlYTHY/gkPR?=
 =?us-ascii?Q?rGr6thUGjdIDFb3jPELrTaDc0YahCWhgDjN6TIcTaSler2g8lDvVJK15ARcR?=
 =?us-ascii?Q?wo8wyBFuMPckMs+GTy0f5yhxzwG++cPYrqA1v32+YROl4O54buRPoVy4+OOo?=
 =?us-ascii?Q?/MsOwFPzUjSxOJt8UGkiPI9Z9ueZ4o9+7RzIgV2Vdv0ALOhgM9buWzGy1a5y?=
 =?us-ascii?Q?P9soeGS6X5wvecdIUTJ4651X?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3f6eaa6-0f31-4d23-1ada-08d94ae0822a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2021 18:10:36.2365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h8BC1FOIYbrYelnhXHtiC13A1G7kgvRsW5OvFks5n5VVCzKc01TpPECRqhJezHbYqJUKXp3wdvSNeDzev5eFYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3278
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Martin K. Petersen Subject: Re: [smartpqi updates V3 PATCH 0/9] smart=
pqi updates

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

Don,

> Most of these patches consist of adding new PCI devices. The remainder=20
> are simple updates to correct some rare issues and clean up some=20
> driver messages.

Patches #3 and #4 are missing Signed-off-by: tags.

I can amend if you provide the relevant signoff chains for the patches in q=
uestion.

Don:=20
Sorry about that.=20
#3 and #4
 Signed-off-by: Don Brace <don.brace@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Gerry Morong <gerry.morong@microchip.com>
Reviewed-by: Justin Lindley <Justin.lindley@microchip.com>

Thank-you for doing this.
Don

--
Martin K. Petersen      Oracle Linux Engineering
