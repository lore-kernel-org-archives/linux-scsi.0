Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DADF8C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 13:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2C33206E7
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 13:12:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Yfa3cslY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Voc8GssB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbgG0NMU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 09:12:20 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:64008 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728367AbgG0NMT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 09:12:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595855539; x=1627391539;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XmRgpm/+atBseqRgMy+W4ZuD7sWfDNZ4d8XC6vKIdug=;
  b=Yfa3cslYqtT/bdzSclwRnCiMVKD2VVrKAHpjJ1PguKPK/XqKBuuqIyhA
   nPYR7CDKKOvfrXgALodKTj9Vq/4+5DVm2DfZ4Cngz6VjUmKo+441WmHk2
   FEjVM1vgv/ZRBqI67JyFDV6oZQCW4BGSCdP+GBlNdiCXTNixRAowPA6LW
   9dnrdRYHWxJfKjR9tPTZDXSlygR7EXmTWA4OzLJLHkJNftShGK8zi6LsN
   usBfYQbV0KqKAapByU5a+0b/Xk51XxHoiV64rmSoSyz8xcQ6Gby/w/TL4
   veqTYVLyF3EsM+hyeam9/74BopzTQ26u1qv/m7MGIIrUTv0KvXi3asIyM
   A==;
IronPort-SDR: ocfkAAr/C2a8VO0o7mxrJ5qeE3JHIHULxAUTopQb7VbbdnpoGj1hKybgjtOBySbZcM7WLRaucf
 f2ura6gEX7IZley+i9qLm/ghiX/bb0QXY3Rw88D7X8FAEDlaEa2hwlNE5lWPo50hYF/cr3wbz/
 cg+IZPeQL/XrfTyuTwIwFtJ6SuhTBUqvAZKjvxSSDYd12WyrafE3+KpHI7sOkpjJdza52KqS4K
 S86bVWQft0rKP+Qw1wyYm82+1IVu1tI42XpJ69WrWCNMr6t0Pro+BZMVpoEws2tdDGHN6G5eg9
 DyM=
X-IronPort-AV: E=Sophos;i="5.75,402,1589212800"; 
   d="scan'208";a="147770567"
Received: from mail-mw2nam10lp2104.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.104])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2020 21:12:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6OVKgr/v5JhvR8rN/wTFcSDAAKpD2Qx19+DhC2Eks8ixtVK/DHoUzzAz3szTm6mtsWg0WiWIXK6fc08Mz53hLolRK3qvUgyiBGTzfCzwKgpifgHe7YnMD2b1/Qwc68BnJIKDjDToIB6oBFc9zQ4ULcfpbYaTim8K8N3M8dkrWi+euGBfv5wWJ11aG0hx2kUjyjVeJsoPH4rXk/cLvNa85QtAQ/8hY78yO5YdHwGV6gkddvYQZOYRWxYbZb7fobeNPZacqSgMOzTXYYL5UuEni6o/W895iWbNPAuVmhsUwZApSRydPKyoKYaoIGhEJfoIZJb121GZRgY0eQWxTiq/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XmRgpm/+atBseqRgMy+W4ZuD7sWfDNZ4d8XC6vKIdug=;
 b=aGuJJE7RFkTn93Y+mlKGZ/Gx967mAgCI/9fhHjANwNp7rZUIYU8uXDf+hknQ6P7emWvVz0Cme5mpgH7VHE6Y45oSdbKuaY8ImJFeL2aWLLFDvSrpvcC/zcDyFoxWM4FvFyKaEI1eDzEfpJzRS0NoPt+Sxjx+/eV3VfgxVR9cn/UcvFJ8a98y2TKjhtnfcXapw2iYQ0ZDsArPzRf0iCuD3nHKvsA4+Ls9xM+ULefq/3tHAJT79VTE5PQ2/PrhnbMhPLPa9KgNOkN0xZG+9VTKSQZrbAmYvNbM+R50BAUYSmSqToYJGTDnYREh6HhXPDTKAfkKmuCGKFpxBFdJ3x+A/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XmRgpm/+atBseqRgMy+W4ZuD7sWfDNZ4d8XC6vKIdug=;
 b=Voc8GssBUTXRJ6ffp8LveuPPOWBnAbjRm+Yc3oeo1wNbZ9LTCcfzLXmHwBU9TXgiWPaVM5kkup1B2uD85TKJWYcjy2A1DCwEHNV2/Cj/a+jp/4l7M8/EENCuI+NWia4wsjEMkgEwI7PzqWI5fJt/rtMuPlg2lhyY3dTO+CWK96g=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4352.namprd04.prod.outlook.com (2603:10b6:805:32::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Mon, 27 Jul
 2020 13:12:12 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 13:12:12 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 4/8] scsi: ufs: Add some debug infos to
 ufshcd_print_host_state
Thread-Topic: [PATCH v6 4/8] scsi: ufs: Add some debug infos to
 ufshcd_print_host_state
Thread-Index: AQHWYObw8XCitwnNBEKgLEP/NmbTA6kbbRfQ
Date:   Mon, 27 Jul 2020 13:12:12 +0000
Message-ID: <SN6PR04MB46408A41A942DA03F8A7BD5BFC720@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <1595504787-19429-1-git-send-email-cang@codeaurora.org>
 <1595504787-19429-5-git-send-email-cang@codeaurora.org>
In-Reply-To: <1595504787-19429-5-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dc9a3004-8fb8-42d2-11dc-08d8322ead0b
x-ms-traffictypediagnostic: SN6PR04MB4352:
x-microsoft-antispam-prvs: <SN6PR04MB4352434624A02E10080B1547FC720@SN6PR04MB4352.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: II8Z/jCAH3HygC08P/NcJqSKP5qEzdl1nJkWa4Us3oBmhbhFVMdGBKeonv1X5VtPldq4TEFh9hxKwtaUyP5DY83gVyz6wdNcDudsMwgir9wNz/fJ5m1hVr4gJzTGdJhUCfGuG6G0bkc31SAqKgLdvaTH5iSHpaaZFBuoqwr+dqaW6RKXIVveBAC+VOlLSX3kENJ4Qf/zS7OmJiJk9G2sHysO6Ehrd56aINJmrTyYkRrAVyt3PM5D77DD8AY7rTTpLizJhZEX/uVyoeno73FtGcceRy9/omU2Zvj3PGu4WyHejHOm17teYdbod5eJoH5Fsv5pldeN8Mr+RDcPetdHJbOc49yj20qKFh65TJ+VrQJZcDASJ2cQ3Dus6+iTg1cd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(86362001)(6506007)(110136005)(54906003)(316002)(33656002)(4326008)(71200400001)(5660300002)(66446008)(26005)(66946007)(8936002)(66556008)(66476007)(64756008)(7416002)(52536014)(4744005)(2906002)(9686003)(7696005)(55016002)(478600001)(186003)(8676002)(76116006)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 1k2wc+sAm40n2+oFJ6SvQpJketlNmaI2M2cbAHa5qnj2t/95SeXV+Y5837/VQWifWubxfs9S1Lq3QLDoVg75IwKugD5//HgvBf5EFNWGZCaPYwUleA0f7jVY5jROgC7LWT0c4WkO6lLZ2O4NWATw9o6U2R5+tXMFAnMYLBtk35uVJU4naV4Fz1lkrMDphR4ypg5d6mOmRCuljt++iylvhIdLdmVIHqz3wUGrtmyP+qlrq9cYvIth/7VSfENEN3pxRkcWlse3B8HNDwMdqnCZBjmrCcget3AvZ6XlOlACcfqTJP29HAF8NI/XHkCJLv6Rz0Sz8x+WbT2pMLXV69oOHhNL5C94yhbZQbc6R2fYsXtzbwLCbamuebbt5gjyI4vMpr78ysCpibjFafBJOxc9iu7GF7/solb0hdc3q6V7+8X+zY25XClZawoA0yPKy4GGktHlYGWK27tA6KmbhY/op7kMQMZ+c/rA7o9QIhWGbswMDB9/SI3NC+CLzwo7ZaTH
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc9a3004-8fb8-42d2-11dc-08d8322ead0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2020 13:12:12.4564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ijqu/1qAqS3Ab9/We7wxMh2fIjQzAZG99RoiUiTLY/QBxJu709fLids5W7gQQWKb4aLxLyc/gg5Tej0+6o0kSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4352
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> The infos of the last interrupt status and its timestamp are very helpful
> when debug system stability issues, e.g. IRQ starvation, so add them to
> ufshcd_print_host_state. Meanwhile, UFS device infos like model name and
> its FW version also come in handy during debug. In addition, this change
> makes cleanup to some prints in ufshcd_print_host_regs as similar prints
> are already available in ufshcd_print_host_state.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
