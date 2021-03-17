Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC186C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3B6764F42
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhCQJUX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:20:23 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:13624 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhCQJT7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:19:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615972800; x=1647508800;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uyOInxMX590ETuy+GQzZv8CJFxdZh9SlrpvgnSRW4Rw=;
  b=HyDp3FaEVN4aqUFgl6ywtWlLrYhHcsOEEcSagaUEhpgPpDcuuL6/n1qA
   ABK+vzd9x9oxU3bsADSFtvpazY1zAvq8w815f/JEeZTgzwCVsHrJbt0wH
   gUH9V6LNtMBns1mQu9+EZtP3QeZEUp6lwD/+1usbznnsrHuIpCcXkbIhB
   wZECUQUV0H516QRHcCzoDEbaVv3OYAsyWr4VACHWR7Rlei7O2V437k9yY
   L98K0RIGg2bb8HoI23elL/cla9pSFZOCF7SLKhtHeoG08/IW4Pi0hlsOf
   v9K8udmsI6Tn5lHI6FtKRkOzEgueNcwSrzKTzB+hmXdW9W2G5ZQvY2/If
   A==;
IronPort-SDR: WZfzYMq0BVSKN0rAVDJ8ULKl2tilpsYO5Sd/x5JyyiIvBmtTC0VQYlMliY59cZJwMpa4IvDLVj
 JVXO9rLLS4TqyTWesQD7F4y7I5iRD6llLIzOMUspyx7wiF2CBhCInWIxncUVClbjjb2asXtxMV
 +RWzhZeNd5ftiykzlrleDXpB2lNl15KjN7MTG/KRtbN4B0dKFnp8eIT5dv/arILnGsWZ/9Dl7y
 3zXURnDnyOy1r9ox7Td1VhEumbXLCht39O4wWWMSOI2ALuJeazujzXdi0lQC39RJ09qfHCP7em
 rZc=
X-IronPort-AV: E=Sophos;i="5.81,255,1610380800"; 
   d="scan'208";a="163492311"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 17 Mar 2021 17:19:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bhYbbwDgs/AqJjcuTx0iCejLiExUfl2P2ArX/3qLmn0nOYAVOTOGkQ7LB6gxmf78E1dDNmEbcpoVmdrLaLZIX3UVvkYU86HybRXkGWvGUybTr934l91hgMbfC3gDxy3nDpKiSom5SSBklAKHWc8c00xqf2Z4+ffNtyUK47FWbGCVM2lsc+YBGvcMTG826S5Os4muxDACIW4DRkx5xvfQj7ZMgCvntRgBQ9T+u2yh+JR+yI4R43O2H7pw4Oj6cII8l5ZSoqKt5UqSValIsZJ8eHndlyv1ZcCqH2J+gmGbJvJoQw4Wq8B7YZL7IC5Lj7BBVOS4Xmf8OCZQ6xgNGl8q6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2vemDPiFFr2NqJkKkwmAXZlcgc7GYbAe988Mhvr5LoA=;
 b=V8wKb8DALoVHmGp2tdvtcANb6s1cvboTgE2Y+uEZ8FZPNehEkndSOTzpCSebM8Mj9gRzIGxLNeSQW6buykxZxqTo73Nbyna+gq47jUajPVvzSBx/ez+B3JITZaoLm7Ol2QrJNjMLPswfkVbA6ektPX23mX4IP6O9suFaOu2jmQLaY/FygroxbIKkDgDseP6dRNIAq7E34Q172ngzZ79Uds0ZvEoQLvPtpzTFAIHbj1OhpPJXeDdJu+zW7mSs78K/bc5gFUpktmmFv/Fm92w2boi4kgGy4IJms13+cVpi8fd/AgdFLNBNKiHmt3gtrfEvkGuzmEpsxHiqyTaiRuCBcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2vemDPiFFr2NqJkKkwmAXZlcgc7GYbAe988Mhvr5LoA=;
 b=Ft8ELxv2ckdhlvgc1Cj0ck1/lcav9nXuN7vNALdLK5doK+u9jy/yQEF3FPu/DkCorumhPwaVHuHlpVMS0vKXcjZqaKHeCVzm+45IQ2j4bYdgR7HZtaVLeNgpnvnEw8Ac5ZH3vy/PI/PtsnWM01oQE05biKpX+NNaYKBUB80xe6Q=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4156.namprd04.prod.outlook.com (2603:10b6:5:98::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Wed, 17 Mar 2021 09:19:55 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 09:19:55 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v5 03/10] scsi: ufshpb: Add region's reads counter
Thread-Topic: [PATCH v5 03/10] scsi: ufshpb: Add region's reads counter
Thread-Index: AQHXD2ei7j8moNyDbkOuTIbGJCHBHqqEdEEAgABlUmCAAAN7AIADIMEw
Date:   Wed, 17 Mar 2021 09:19:54 +0000
Message-ID: <DM6PR04MB65751E20BCECAF49FB7912ACFC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-4-avri.altman@wdc.com>
 <343d6b0d7802b58bec6e3c06e6f9be57@codeaurora.org>
 <DM6PR04MB6575A58446F1EB9ABDFBB7A6FC6C9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <aa82d7011c102b5d0991cad8908ac9ee@codeaurora.org>
In-Reply-To: <aa82d7011c102b5d0991cad8908ac9ee@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2193903f-2418-4ce4-b032-08d8e925d3d6
x-ms-traffictypediagnostic: DM6PR04MB4156:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB415624427F5FCCE1780EA124FC6A9@DM6PR04MB4156.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 05pA6WGBMeygp5JtHXPel/IMqn2vF1UQZTZ1e8WhAatMYSNkt1tGwz50Qiuvo04wBuLTBqQ7cLVtgkaJ5F2rZo+OgI+6yw0uvqO7KAX2b6uCmtI45G1+YH4t0fLhZTzIumgPHVatJmtqJta/HXakL1z33OCyP//TzQbb2Fj5ptmSbkuoCcXTA+O7JZCiItip+JKYkpGy84eW0arDCUmJ33d3XEYiWuwGQ/XSGT0FEFhgCq0VH5ayfh0gBv9tdMF5Wsr/u8SEnm/0qQ7Vm/NelfIBreT35ifErs8xyNSL6ms0wDqvciRFkQDWkMW+PLp2d00YJC4uE6SyjuI9Ia6dtOvRW/8KqcTlvcmEOmhnUOgYplSmGtr53tSB9IN/OjJ5ZZqUx7ck0ic0x4Mty8WN3Upx02oyFcF1hw9JCR9FtORC8PoyvSWqcSFO3jlR1UB1xYUchb0sWdOL9oQWhTxSW0FvlvNkxf9WwIJBMWZtBJPgHOZ4qTZcqGAVK+1IvNcBeL2sQ/b1UKJYnj4Reli/EO90CgxaJ8LzcsS87AsRlPhBY/+kb+MfaCXmb0/HGZ5r
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(54906003)(66946007)(7696005)(8936002)(33656002)(71200400001)(2906002)(6916009)(26005)(5660300002)(8676002)(55016002)(316002)(52536014)(9686003)(186003)(478600001)(66446008)(66556008)(4744005)(66476007)(64756008)(4326008)(7416002)(86362001)(83380400001)(76116006)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?7b7GOAaEci3Jj2azDBaXjKeoWZ9p5llgMQKhK11VCMMjoxntmtPh+nk1L2SS?=
 =?us-ascii?Q?EcokV9BLQ67MLpwtI+GkkkMAcPaXssTRINkX6S9bciXYd7CRob6eIuEJ5QvC?=
 =?us-ascii?Q?X5m0n3gO2u5OFhQnlSLtiSHAyxmcmLZcZI741eay2CW72G1T2urSfOiz+MqE?=
 =?us-ascii?Q?4u3R6zYk14/eTtGIzJs+jas2N2RGXB8R7feMHYxJuGuxaP/nnO/IIIbu3sFv?=
 =?us-ascii?Q?XYqVrxRQbtjnQCp/s+DOLLih6g0ods+yoMqKvtK4Qi8ExcX1rITfjkvDc5L4?=
 =?us-ascii?Q?Znnnc2xuU7kjaFv255yRDDAEGJf1C+lo0fbcr4FN4Ig071Qj+EYb/rTQzv6C?=
 =?us-ascii?Q?ry2A/Xg7SyFFdfUzD6EKHLhKMFrmFs3nyXYbELP2z8qyWzC8+gyrHBtarnfp?=
 =?us-ascii?Q?+909C/i6noDt4gjQPCmj4QCtJWRCsHAxKk3urc6PqxPHfBauArw+hObfHQAe?=
 =?us-ascii?Q?keAYGgOfEwpk4djQNo4EEdFFw9yVEWRQFlexit1b0+tkF1UrjUHkv7yk/7nB?=
 =?us-ascii?Q?ovXJprp0BId736rPjHK589cxHOsgKlgml0GHg278EEVP8QmCk6Il3zSKn5/J?=
 =?us-ascii?Q?nIyqT30mqbTAXCuNpmI0hBLokdnVYz5ojaBuOjQWTjZV26F+Jc5NqtY1HsRU?=
 =?us-ascii?Q?jyyKuFDgAV0guCTNTpYy+YTuyTGeiN0/4D87ym1wT/vQ7skui5VWaahTeMry?=
 =?us-ascii?Q?XWIHpGFUHtzwZNFKl6ykzq7dNqNZOytFvQlvCJ3KDMCYLeth3oQexd3qYjac?=
 =?us-ascii?Q?IwLxTvLVON6ObQ/xOsTU46RMqlHEE9Lz9C8DscFWP+kHkNWzNsynerbx6Ge1?=
 =?us-ascii?Q?iTBmS23u3+At9rY5EkuQZJEkC55VQfaQx2Wcdx6wagR2J6CG5osaKuj/ikKd?=
 =?us-ascii?Q?gdWlrlFfqrlbhkx0FQFy+HVQ16tw8O59IOSczelPD63ANNJHM84LjnZVQ0Et?=
 =?us-ascii?Q?T+SgPPY7SvG8ihu9QL8a6fPd0ZNeibqCZsrgfNWCxnBFkagNIK/zhcN7PAQX?=
 =?us-ascii?Q?WIyLViHX+fDfKdW0TVYRDN0XV+ByhNLjmFac42RmNo9q2c7ZzYtPTsZNal4T?=
 =?us-ascii?Q?6WZ81c6I0rnZyaQOhS3XAncVUodHulgIjvoQsTuIHatSPJpKsf/5acI7p+Rj?=
 =?us-ascii?Q?+WnUlUlq96tgAI25gcjl3Vuo3XtNVgdl0jy9CS4AXknSmQGhSGUiCimy6Coa?=
 =?us-ascii?Q?iD8zOnkbWdDAUDb6RVF/w0DEl790XVh/aw1Rq3Hxfx6VoB6ZRL3nxobYkT/B?=
 =?us-ascii?Q?1xrXwr6WDSKhydgwzkxjFizGBKScV4J9f+3UHuPvEvIBiK8qZF96a6R6tghe?=
 =?us-ascii?Q?z8t6D6HIH9HKXXAjjOX2A7pR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2193903f-2418-4ce4-b032-08d8e925d3d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2021 09:19:54.8446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VcnTG3ub1IP7p5KhAxYuyn7xB2lo8almZUI5YInokeYLbjzk6hKhGPN9ZL1GiAwHAm/safaL065kIv8q/bziQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4156
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >> > @@ -1079,6 +1113,14 @@ static void __ufshpb_evict_region(struct
> >> > ufshpb_lu *hpb,
> >> >
> >> >       ufshpb_cleanup_lru_info(lru_info, rgn);
> >> >
> >> > +     if (hpb->is_hcm) {
> >> > +             unsigned long flags;
> >> > +
> >> > +             spin_lock_irqsave(&rgn->rgn_lock, flags);
> >> > +             rgn->reads =3D 0;
> >> > +             spin_unlock_irqrestore(&rgn->rgn_lock, flags);
> >> > +     }
> >> > +
While at it, Following your comments concerning the unmap request,
Better move this as well outside of __ufshpb_evict_region while rgn_state_l=
ock is not held.

Thanks,
Avri
