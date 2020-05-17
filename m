Return-Path: <SRS0=qdST=67=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD0EC433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 17 May 2020 06:12:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54B18206D5
	for <linux-scsi@archiver.kernel.org>; Sun, 17 May 2020 06:12:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="eip4t4M6";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="gxIqU1++"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgEQGMB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 May 2020 02:12:01 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:25994 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgEQGMB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 May 2020 02:12:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589695920; x=1621231920;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=loiPjoGL/K0GWdoSAvhxQCP3Bl7VF4z2ACC1jHy90MI=;
  b=eip4t4M6oRBOcY/XNyZfM5QTs30VuhsNTnDEd+d6q6mhQcHQ20bPMqeU
   cvZUgIeKN6PM9iQ0dUWZgMgI4AiTDIXDs2QS4Jufg3X7FQFtkkUhFBEc4
   ubMfjhfg6qMtXmhEYdFrJTHVxqXrTTF4TZ1nFYH3w93DMnYI/U6zw9Bzv
   JMi2lOkwkGNl0aAY6wBuU5QK93/J6gNEgs+fNFWf41R5jEwQPi9rLnJYF
   vBSxRvrrYp9800ofACKVMNpUX2s6oT7IxhudGmlK1KLrks0N/SLlG+d/a
   atvJpRcYlm5KlDl+GeHKEckbVsN/5FdhQ5n51QJZsw8qf5xjyJyDG0/c+
   A==;
IronPort-SDR: xE7P8iA3wWJz9JKe/DOGTagiZH8JfRF4p16oRK2SVQk683SLTw+vjwxCn/L1PycdOtWH1r8nd6
 pRSVrxfrkWOhsemaQ3jBcPLpFV0ZLauEs3a27qSek7TEuwCAOrunzVNfscpNLMUVtSVDdLSnTN
 8MGwfvHHWcDdT3DDPxI24B8heszIqyUhzVsJEwHMcnb+I8jDoN2/m3vGZNaAHYVN8RzWMVSdRN
 0vltq9tjSf9dbM3oYRra/OjCseynG0jp3I8/RznenWyoqj+ek5RBZTKo1edeFXHcEepM61I4DD
 V/A=
X-IronPort-AV: E=Sophos;i="5.73,402,1583164800"; 
   d="scan'208";a="137870747"
Received: from mail-bn8nam11lp2170.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.170])
  by ob1.hgst.iphmx.com with ESMTP; 17 May 2020 14:11:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RmgIPYipKLLwlZnUefmmr7PGt4oOLmBU1tgg7amz+GRJsIeWlFZC1R5xjtRQSDQak6Q4fTEb+yeJmn2+ocP5ec5R1f7fG1nAZE97LGYFkoM8/EzgP60xvTRjaNBmY69rr5JhEpI9N7wKLeS/WER4z1E6py0cJIvt7hXfDe/xEdvw7O8jSp93kjqnKfJDybfO1vgQe9khnk5ZFJNS86AKzN1PTQNLkBgT4I2tK8wp/ZU5ny7z0srwB+we/+mPf0kuO/YIdUazKSXXe5Ggw0aU6fZ9fPeH4xqeMBh+RlVIJoLcp6K+6PrhnO0o9RyZ5gjL9BsYyQjtTihcgJP24sgVEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=loiPjoGL/K0GWdoSAvhxQCP3Bl7VF4z2ACC1jHy90MI=;
 b=MBzTAc/LBOp10MXVoxA0Z8pkcNe0EENHIaSpuInap6kkTC8JHAkXDeEYjD49TG0FanO95XupYDZqTRH2ViAhyQ1zX1nzknvbrhqe+m4agS3nEqVd0wRqvXJX8GVedcqw0pkFROjyt6SyL4RtoE1XQ5KLxbejmaBMFTawGwKL2rHwAFZO32faaDJxERCTgpjGQ89MuhuROcRJ4SIrHcYmPPb7DYvYHbUWHnf8lSoaKVNvPcVstte/fazo8AtGhcOEJqCW3LkvASOmwzBVxjPFpiVjSu5TxiwQ8LYnYhCfSwsvcKfd9HlOr4CjFU0JrcoG2rA1CkGOzu6kzKkrQzmQ0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=loiPjoGL/K0GWdoSAvhxQCP3Bl7VF4z2ACC1jHy90MI=;
 b=gxIqU1++RFHvHW6ri2IMw2nw51V6bdHR0fza1M4vQVCoMzsaZrw3+7TJ5c2PIZnCmTiqva5Bv2c1FdDXRwxecqokJvgWba+PykfMU48pDUOPrgoX9pICalTuZu+xeJi/dD+gu2bYipZ1brDCw76kZchTtl2vkb2mb+9ThRfUulc=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4445.namprd04.prod.outlook.com (2603:10b6:805:38::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.27; Sun, 17 May
 2020 06:11:55 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3000.022; Sun, 17 May 2020
 06:11:55 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [PATCH v3 1/5] scsi: ufs: Remove unnecessary memset for dev_info
Thread-Topic: [PATCH v3 1/5] scsi: ufs: Remove unnecessary memset for dev_info
Thread-Index: AQHWK6nuXqurl/BcUUuxV/WDX/JmqqirzJRA
Date:   Sun, 17 May 2020 06:11:55 +0000
Message-ID: <SN6PR04MB46404F47B61BDB4EC530056DFCBB0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200516174615.15445-1-stanley.chu@mediatek.com>
 <20200516174615.15445-2-stanley.chu@mediatek.com>
In-Reply-To: <20200516174615.15445-2-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: af92f2c0-9966-4d20-50e9-08d7fa293340
x-ms-traffictypediagnostic: SN6PR04MB4445:
x-microsoft-antispam-prvs: <SN6PR04MB4445F8A3D05B0A51DF55F51EFCBB0@SN6PR04MB4445.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 040655413E
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zlGMLcvPmDCos8bh2PJNp2fQl0WP7TZ1qG4N8PZpzcZhc6HyQ0/KcQWgrj3lqIHEtSjvafhoarn9g4zJR/BUirquExCgX6ZFstQWtBZem8F3JHMYDLFERimr1bCJTEasTmdHCuSKp/PLF8Hm/2iMxb0kLqD0XAYgYKUw+T7PLEF+2IppjqREbJXoEmJmIF9yvmmSqqEfQw8V5ia76SaYvo6E+rpnzrtXBOSSyVVDB9aPmziRIhF41N1U9YCcL7k9hJ/FKuSdr11LbWnuOU2Wnnh5+jcrwQPpPVNG2u7kh7tmUrZsy5d2Hegmn7KF+SHlZBLw4/Z+9f0eENLqotL3x3DVpidL1d7VrIR5c70Se6NTIqzzBv0GR8DubYl3x83oNqNbCIjnecLKetrsYwaWC1SnWb9QQ8YIkGbdZ5FajZOdNKtNzEaaJbDO+PKuS5nf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(366004)(136003)(39850400004)(316002)(110136005)(54906003)(33656002)(55016002)(558084003)(9686003)(4326008)(7416002)(2906002)(478600001)(52536014)(186003)(26005)(66476007)(66556008)(66446008)(64756008)(66946007)(76116006)(7696005)(71200400001)(6506007)(8676002)(8936002)(86362001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: E09WxFdNavSPRfbEMqNT8RpxZjIPPZ4Pbedx+ksoyjfOGm1nvBwYhSKht3xxQTaC8uRhs7N42ZBttb4szoVwpazbOgGJj9X0vgNqC/V8qL9JaFMDr0s8Ac+odCGxklYVHqA8JxmTzP3AMfo4IvzJOm1nmmrL/xzhcE4bhmtjSlmMWObLzgp/CvJhTQRCKT65vtI1Fo/sdY8cmucbUFxr17AD6LuSXYTOhE++VMmjpcHuLHBSpeQrxMNCHJWSGqrkEreKcGOCDarrvYssABn/JsG9Gv7C5j9MG/77wQnDiwDGuZLGOA2ZWhTn8x9XJZKQs72FQq/ilnxytN4q0iq6iwC5WPYCi6OtX7HtJ7fBWDaaSPc7Jk8If2kDL9isPRnP+H0BMGvuuSt2OX6GS+4m654z4SpylxoKGIfzHaAdqoeTDH2EaRqMsTyTQzj+HUYcXoyFsS1ehb5jhIB7I9JAtCYlviBw3+cx28K/Nmc/1sg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af92f2c0-9966-4d20-50e9-08d7fa293340
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2020 06:11:55.5791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nLSuHIIeH9PsmyoACJkQxLJtQyibUi6XzPEppdKP8yL8F+sKiYKrqEEvZw1YMOUNM1jUQAiXfXmGVXVLuKCPGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4445
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> The whole UFS host instance has been zero-initialized by
> scsi_host_alloc(), thus UFS driver does not need to clear
> "dev_info" member specifically in ufshcd_device_params_init().
>=20
> Simply remove the unnecessary code.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
