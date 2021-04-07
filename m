Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 249D1C43460
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 14:13:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B985461107
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 14:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243083AbhDGON1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Apr 2021 10:13:27 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:60847 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233974AbhDGON0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Apr 2021 10:13:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617804797; x=1649340797;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=H1tpktTbyWgCKePi6I2gEq1LMA1NK1vROVDEG1OUqZk=;
  b=JlPDqaJvW3ZPiNJwOyRyrr6n2ZqRBuicSkiIl71xdT6NgmRN5IHDOf4+
   p74KYrwhqJvmlY474lltSKpe0hvbVqroq3QFlo3pi+Om3K0eWIUD9QzFC
   ml+WknS1cgRmAJxzs2k0ur8M19E89ILndrSrVcz1LfGzDcQbblyHjC9YP
   tlZsx/WZFUI8R0pHktR1gnyQRKFdkI8RYDLyvzI6DN/1uF3gxe7cDIMrC
   TP39iJXsrG/NKwpfcIeXB0bC0E/AsOhOJWZMKc5z6D1fViKXmVHlNlW8Q
   /1oWvOaJXfNmxV78Wx0q0rbD8Nxrc1xOjl2ZXxmldsP/zhI3LUTnsyjTc
   w==;
IronPort-SDR: gBfcdPCV4NcJ4B1HzILyiDWywGGtWKfLO7V+AI7rCpKC6TWP6QWbtcTprF/BPJccpzfv1wA8I7
 2yJkpSvjA9Gql66h2Pq5GYy0+jIMHWFYDS9H7o3B4M/kkuJZBOrfRdn+RTvT1EsLP8nQB3X3W+
 cRi6ncBjzPdNI9hfRoRoFFCjwSezLvds0gOVPwd9o4LMhVmmW+LdgM1j45BeRzpDqjSZ0Jdrlv
 /aYweLzdBEeDJh+K3wAznTqpE+0QW/cMiuUG/ffah20lhPbPf2QllwqE4f7vMBW/g5AAPW0r9d
 wYo=
X-IronPort-AV: E=Sophos;i="5.82,203,1613404800"; 
   d="scan'208";a="274921593"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 07 Apr 2021 22:13:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JtN0x7gtAa6sa+Po3t0zuqvdL4qWTjlzw5cAL0pZ5usgNodvkT/SYeN9Q48W6G6EdO6+LC5hZrRvk6CKP3Qffes+Im+9nWKOk7vJn9I9AGSSu/SJ9EmC9eR5f6uB0oTuH1jO6aOBAmY7fmvQvgD65YiOb1TjwbV8HJIVRdvOziKIFWtqViD4dTy7tlClkpBXKyqkD3+sfZ4KOS9ZHs33NvldxOIkpOXs5Azbw7BblKLI6Jzt0qIEOoMolhs5duU8pU/WHv19skM2iDbSQTZjAaKqfrDIBaD5TN+Gnbte9MLjbE1SDc8scU4Adku5fIqG5o1Q5Lxw1d18pjBcVqMCBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhYmlSIzGhe/3DgZcjmtCWaQe6SdQm4OWfaIH2lAUSE=;
 b=JgMp1fWRiRD2Ao8BtDOBEzpv+Jl/c0rfMcXD0Og/+/Zmgi55pGY14mSP1rkYbbHHdXPzgzKManYFzzaklU+Gijq1crjOgSe0Ho5Pxv+D23MlUEG/Hl0UQMa8W0EYwJVVof6PpgNUaxI/bAqOmhaSVctBRJHi5bR90dOj7l8woVI82iMJOTMpLgbu2bzyBdnlbBukqyo/3hD6IXiMhfjtZMsszjigUVOVaZ3NV4cqwBW7Vzh4d9WRe4aQq1hNDXvHdYCqE6DwUguSUNDb3H+lcGN79+hGHNSsSkbWpAQqaE0udQZ9T186DUyBuM09NzmhFWhS/Rv+UcfEdyQAMPX2vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhYmlSIzGhe/3DgZcjmtCWaQe6SdQm4OWfaIH2lAUSE=;
 b=j4L/Y4mounbaSsVlU575f+ddcBypagFJ4HN0SOJd/nbPi9m/JPYuIMgINf6zvEmHFOCcNEAlrWNjavNZ9xv0alyox0J30HMGSrcaCAEeXy5VASfF+QY/CRytHMXAuFsa24XG1YsmD4BOZY6iZrnB+nFa0Qd/wip/HZkwubLYsjI=
Received: from SA0PR04MB7418.namprd04.prod.outlook.com (2603:10b6:806:e7::18)
 by SN6PR04MB5248.namprd04.prod.outlook.com (2603:10b6:805:fc::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Wed, 7 Apr
 2021 14:13:14 +0000
Received: from SA0PR04MB7418.namprd04.prod.outlook.com
 ([fe80::d5c:2f7d:eadc:f630]) by SA0PR04MB7418.namprd04.prod.outlook.com
 ([fe80::d5c:2f7d:eadc:f630%6]) with mapi id 15.20.4020.018; Wed, 7 Apr 2021
 14:13:14 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Colin King <colin.king@canonical.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Viswas G <Viswas.G@microchip.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] scsi: pm80xx: Fix potential infinite loop
Thread-Topic: [PATCH][next] scsi: pm80xx: Fix potential infinite loop
Thread-Index: AQHXK7YnadGL/gWZ8kqiWYxYHHEnig==
Date:   Wed, 7 Apr 2021 14:13:14 +0000
Message-ID: <SA0PR04MB7418E3D24D75000E5FB5D5699B759@SA0PR04MB7418.namprd04.prod.outlook.com>
References: <20210407135840.494747-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e65e5eba-3e84-44f0-db00-08d8f9cf48d7
x-ms-traffictypediagnostic: SN6PR04MB5248:
x-microsoft-antispam-prvs: <SN6PR04MB5248C38987866D424005B9229B759@SN6PR04MB5248.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PYx7ew3v+FaxcsNFiBpNpzGQfrrRJX+P0HGcyzoCY05eTQxTqgDC668tjCLix+AiSjvh98+RV3IvSDdZkTmoBaR+u5xfYSVq3p/XfiACdV6eNwXNmQeq7Y+NaNkcP1IjxFGJ1rFgFJYFmpCwlzuQA49quG1L9XgNorj5pVsmvW2RobWQqWMSkrLLC+BXPenplIb1ZJfXJ0Lo7oIIo/wD4h2f6Hv5j1W4gfDigsRaj24L57iVmMt7acN/Y5QjZyVDM+oM8sWMlhYIGR8+Y+zqeq/Nr2DaJrEZvsHX/DNIp9mmyV6mEE77nas0SKJe9jcxI0hEDQg7fEIGlfYJuzri4Leb/Zc7HEogalpm3dXgcxgKZLa5NLZzG4si5ADhKb3GiQrBPGK+5S2PEntjHe8vmger/NVVH1H8+l8PmbUgOfV8Gr6hLBP7LQdg6TUZNmURUBEUh7NaQ4+/p8XqmaAEW5K5fLrNMex+EsRLrszmBEZ4Rc/Go4rDCS4Oa/hLXCk8Y3PZyrHE+qhiS6TQkCUQczwFAY78MJCeupQ7T9Fu5hNPS6huqwSwhhs9/V7p2eDupDwDNSH2yoVHW8fCJvSoSRgmDpbmG/UF1jNN4tJTVQb6a4lOdXHUJ6udN4dAGYee7dzVki6bXd+DWzTEb33Zv8MrTTePV2CwiSXZdPXCV6k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR04MB7418.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(33656002)(8936002)(110136005)(38100700001)(2906002)(54906003)(9686003)(86362001)(7696005)(71200400001)(83380400001)(4326008)(26005)(8676002)(186003)(316002)(53546011)(6506007)(4744005)(55016002)(52536014)(5660300002)(64756008)(66946007)(66556008)(66476007)(91956017)(66446008)(478600001)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?KtaSXN4aW8v8YjM2UFYpqtj1UhoP6evYu2Dw/Wpxt/v1Q1U2yArAiaklm4mK?=
 =?us-ascii?Q?XpwuVDrcyXrMmgogpKe467XAAEBZjEd0AclwCqTu/pE7kv3cUBOm5fDBrfK1?=
 =?us-ascii?Q?Os7vjL5zx1vMggD6l5i2X3ZwZp599+ZD2q8kenbdsW2Ib2uCGDy/vscZ9sA4?=
 =?us-ascii?Q?Ig/1QhuZPrucggpqwt0Y+imEuEiYladzsIJeZH/ltc5yr20tgH5UScx25HDs?=
 =?us-ascii?Q?5gY5kir1JSonyq1Jlp6sci8xrWe3wuaOhtDyyhslwYPbIAP5/D7x1tU8QBiW?=
 =?us-ascii?Q?liL5zvJK9rVIlQW38N/ryFAuspwJzocOmM+2v5mU3XTAcQa3ot2uOPtrqk28?=
 =?us-ascii?Q?I5/W/31WqxlN6vRYOi/XIo+NMXZAjbzurnKGA4Q344eW7Vq9P5b+tnuOjBjo?=
 =?us-ascii?Q?YLfEhU+eQY7iqr11MsxGVsEObYsmaXcvnX04P1SIholjatadAyv8IX66Wmyu?=
 =?us-ascii?Q?70ou6aHrsPRsD5eqIBhGmrD+5p2atKwIjoxs5uu4/CG+JduCV4Qwwd+THyXD?=
 =?us-ascii?Q?Bsn6w7eUCCbApHCr3LDFaT+1QT6NBTaX2H5zfryYcSwUMRIU5+Zkq1mr4hn2?=
 =?us-ascii?Q?oB8SdzfMFquzGOQ7Iwr1cOWw/z3Pypzh29UzuTBM5lpveAqE7GEs/JFoyOtS?=
 =?us-ascii?Q?XNKcK5twAiN1tSLVfAY4l36Gy/RtwWqg7MwEiXEDQJOh2GrLC0IwM+zVRPBE?=
 =?us-ascii?Q?6JAWpsEkK7Ew2nue3vtnuhs8lofwG32lmKrnlUCvzNKVfH9+qv4QA3qDcuAJ?=
 =?us-ascii?Q?eqMLVxN26UoZ2OeVlztRWVdtKIjJvBrb6BBnNcEZOK8n11i9caKAvETx7TiS?=
 =?us-ascii?Q?Xn6mlkfhaDh+xWYTlXm/PUtAOwKQup5WfSfQ/tCFY069msul7m5yRRX2Lyqi?=
 =?us-ascii?Q?jf9j6jIcFbTW11y76Gw5k2KG1Kogqz+ZrJtU5xiaBfBds9XK9O8hVAfJbyk0?=
 =?us-ascii?Q?dpAEIUQn6GjuK1S+q+7qFPwXuUVP71ErhsOXHG9NzC7Vt7JhNo1qxYetFy1V?=
 =?us-ascii?Q?gk+Fi9kuyiGSC0y7V5P1EeXfuO5I4NrJ0iR94e0ysj+JIsvGSm+i7YqaIqSO?=
 =?us-ascii?Q?CSAFrKzh2pTH7tJabTMSAv4qLpsb+oujFtnjNxmFMXjhIxxn7eiym8F34v4a?=
 =?us-ascii?Q?gebIe5yRKEU5lSjDGdDBMr5rIh61eQDzzSXyFaplpETj2zs5MLzMSJ3dXfKb?=
 =?us-ascii?Q?Vg/jCm3dsb1PfyLQwk6hS+YOrb97CAZ41Sk9mErxFRfjQWfKb05B04wzuKWY?=
 =?us-ascii?Q?CzuA2iip4IeUXrsq5scOH70wnuxIXLwkT9T5y5wJX3fYvLiilQA64/0WmdUA?=
 =?us-ascii?Q?J7s18qP2pjC8vZZ3XoSV1xPCUuBNgZ+QPDlwbpgiss12jw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR04MB7418.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e65e5eba-3e84-44f0-db00-08d8f9cf48d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2021 14:13:14.7183
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5ItogsB+/gyngJCuqO6//iWRNQPBSiAvdqO4zCmnzdkNPdOcEXh0jWFaFRnRIu+ThKgZqi+Kwm9N9TmT6jo81w/k22rPxf4brB711cNZdUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5248
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 07/04/2021 15:58, Colin King wrote:=0A=
> From: Colin Ian King <colin.king@canonical.com>=0A=
> =0A=
> The for-loop iterates with a u8 loop counter i and compares this=0A=
> with the loop upper limit of pm8001_ha->max_q_num which is a u32=0A=
> type.  There is a potential infinite loop if pm8001_ha->max_q_num=0A=
> is larger than the u8 loop counter. Fix this by making the loop=0A=
> counter the same type as pm8001_ha->max_q_num.=0A=
=0A=
Heh, coincidentally I've read your blog post on this issue today.=0A=
=0A=
> Addresses-Coverity: ("Infinite loop")=0A=
> Fixes: 65df7d1986a1 ("scsi: pm80xx: Fix chip initialization failure")=0A=
=0A=
AFAICS this still is in Martin's tree and not yet in Linus' tree. =0A=
=0A=
Anyways, looks good.=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
