Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69593C47257
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 11:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 473CF2073B
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 11:04:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rwWAvfyY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="njmdRKcJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgEDLEd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 07:04:33 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:24376 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728578AbgEDLEc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 07:04:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588590271; x=1620126271;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3swNNt7ByUDH4TEmomKLU6LjxC0+j3d+1xoB7kpyRUU=;
  b=rwWAvfyYVoj1/Mxfwl6goEzqyUmetjEHMa9YKWnd/gZuiQ4U9ZNMd0Ug
   5VPdYsVpFH3r0UuZMyvokx8nYqCNx34p5Jobxg8LnDL+RIgJsgFiDkEJR
   gnW+GF5OT5RvOcidOLXCDi9trpae3tE+qfLVZPOZ5fD07S4iwu2wvqy8N
   DYDf5gDbEHGbKKoMjOvTkhcrpYOQ5RMgneuHISqA/zZyTzXMhZOs16WEy
   rrRp+ohDNknn5+O3wDsCRWuHPcBMz9T9vMPbDJN6cwEZlF+Fw/Jcn3tCs
   Rxw56Q5t1fR6OncaKscgO2CJtBbjckFN/KvyI4SlqBviyR6/iPB1irFot
   w==;
IronPort-SDR: eUfu5vOvj3gHGxxVfrKfzFnSfmesF9cJxdB+OvyzkVnEi4Cl70YAwaCKl6geiGTYCTr5HeYaMK
 AgNK36+kaKPTLBNta/AKNQivknWJ2PUrE/96Z+rJk1tiexp9+NiZF6wyK/FVmx0Bts5pIxt98f
 /H1mcctsEWxLZcZlLRbMPUGejOx1zu1ndZcTgucmVQeDfJM3M47uGIUCFfDLsdo6Zc5N1NpNdj
 K+QEZoPuRaoZHDTb0Zt8kwtVU1Sb+oiFO2fI1D4lVCDj0gPQUGPXOfJjsEQk551UOVgTXQAgQp
 Q5c=
X-IronPort-AV: E=Sophos;i="5.73,351,1583164800"; 
   d="scan'208";a="245704408"
Received: from mail-bl2nam02lp2052.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.52])
  by ob1.hgst.iphmx.com with ESMTP; 04 May 2020 19:04:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q/NphUkc7QW45V0m6rg98wnM4FMfjoqwp2GgdUyoawZk/2jJTivDzzY/xeCwb34fJuOIK9WwvZL7mIAra5Eg1B+0ZSIpYANbkmspsB4+7nBRwBvpCMJJh0+/UEsfLMxaNIiV/HGqoLsZTuAvTdYzppj3NwahMnGF2FFBICCpnXvdZ8OpWuykq1Ox3CXwUgxbfnozsbVeJFAP/DoUBBtl6TjMdaW0FCmV83fcsB2vr+pPCSPHcwEZbHTSN0PNrMyUDXpu48oRxJiHr3rs0fJONr8Hu1b3u3O/U882oY7UKduTaM9e2j3teXPXKN6Rilc2j8oWU/tD+xxXWNKI0nLt4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3swNNt7ByUDH4TEmomKLU6LjxC0+j3d+1xoB7kpyRUU=;
 b=SKncE79GPgfQvorVjSxrZ9v1mU0M/xtaLTmOxgr/1FIlnLTQXHMedGyE8vug9QbwBPhekHDFrr04EChCmVmSn6sjAZrhP1tELmhcMh+FTV8qemn2t/MK6RVSvu9avbbjb6h8QW8eCwPYpKimXXDfMqxj7aJLAkiFBJJN8PivyPC8LA21Ux/54dSvhEgEdhlxnVOq1TEM2HqX6Ia8imZoaoEfqILs02F2N+iyqMwIN0X1SJvK/lzm7uj/4zTgrMsHFdcM5yNXbrtB812W8kHFEkmKevG90xp/CiOS2Yc0fAQa6dVcAH80K5y9dHMmO6Lb9HjY3dYV3rc1eGZqqFcGdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3swNNt7ByUDH4TEmomKLU6LjxC0+j3d+1xoB7kpyRUU=;
 b=njmdRKcJM9ftE0//OwkhC9RJ996hXoJfXMkOxlyHGjbxOkbsL0IjtVh63WlZ3J+OWTm5bwPL85IdIYiKjd4oUajuPR62cq/W/trCMvhHScrhMWFWLOYaH5LZbDMirGYFQdexDjXsVCg70IKTcGMEyGy/wmPMwzPnX0ltByO0ifs=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4944.namprd04.prod.outlook.com (2603:10b6:805:97::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Mon, 4 May
 2020 11:04:27 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.2958.030; Mon, 4 May 2020
 11:04:27 +0000
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
Subject: RE: [PATCH v5 4/8] scsi: ufs-mediatek: add fixup_dev_quirks vops
Thread-Topic: [PATCH v5 4/8] scsi: ufs-mediatek: add fixup_dev_quirks vops
Thread-Index: AQHWIT7UcNDlRrxlf0S0WlJUL1qmaqiXxNnw
Date:   Mon, 4 May 2020 11:04:27 +0000
Message-ID: <SN6PR04MB46402768D43F689C00ADDDF1FCA60@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200503113415.21034-1-stanley.chu@mediatek.com>
 <20200503113415.21034-5-stanley.chu@mediatek.com>
In-Reply-To: <20200503113415.21034-5-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a23452cb-9cd0-4252-594d-08d7f01ae9b5
x-ms-traffictypediagnostic: SN6PR04MB4944:
x-microsoft-antispam-prvs: <SN6PR04MB4944577424D71F3BAEECBB89FCA60@SN6PR04MB4944.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-forefront-prvs: 03932714EB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9ZYItufUsDj8bk4tAn5UuDLaJCMWE22tW1cTEhjYBzjCJG9mL2DnlyOBCukPA22eD8VLy3bmDjxFNh+ah+rPDJKW/t87iOHnCIXPV+n3bZcrRrG9QpilV4hqaenkHsN1cVrGy5VuZa/L/yKZYYUoC1LVDNCT2qr9ob2oWR2sU5tQrA02kXacd3wXiaEXbnQNHEeHkHD/CyCs0viCLTTIc96jrnXjjosQr9zgo7fU1CMgl57PSbJZXLKL0oHxPc0DIQMAAUmAG7oANgajza8yLlX2kgpCzUdCqZH7yQb+usiECscPyAHzXnTYlF4g4XwQCc4pGxPpAY8FUsvghSfO58zQ9SWDuCyTRz+KZZhpWVMhvVZ3k/6kSeZl+nwmsIVfHqdHj/jW56aWikC21ETu5qiZZZgU0jKjz/zEjL+rzg9p/UEou+CsPjZ6NnzH626q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(136003)(376002)(39860400002)(396003)(26005)(52536014)(186003)(7696005)(6506007)(316002)(86362001)(7416002)(110136005)(54906003)(2906002)(8676002)(558084003)(71200400001)(9686003)(4326008)(5660300002)(55016002)(66446008)(66556008)(64756008)(66946007)(66476007)(76116006)(478600001)(33656002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: PhR/TzSmtaNByZUC+wApRh9Xn2/R1YXrG4bW5rIdj4OKk2lRsx8gDPY1/48oz0yZPr1HkL/x0RS13wOFKKjnrM+9iMqO2rzPwLLNyKSjLPtq+ahx4NjdbQyCqjNl75TbDD92+c3UErxK39PLubC02i0du/wcSXQfx0B2zoNctWVMMucInUxPF0i2gDwUpKVQVTXuBv7qUKugrnO/kVTos+Ws9JVg+jldjcRIEQ3/f7RzXuE10YDKPMjmgf6QEtNtyb9dWQFIjQNsqMUXkrCyejaDEnMXJLsbg1v9GOFhHeUU2mHKHAhRAXXYoR5yFnyKvSjFWcwM354xbYarNIyfoJ1asSJxASXCZDfMmoZoZQP5FmRveNIIXnRPQUqPFv6yVyJGeGE7+759Jp2xa5Ahm89S72OeGcrBTNQvKha7j8FzxMrk4unRlK/ve8AFKC+TALsx6N8ifOt6KRRV7YJ6FBuASO6v3+/TlWv4FOkTKFKVROGzAeeTEnmUnESUtG8tKWCY79lI/swXalLEC8KsCOJADT4b7eTMNLNDw7Kv6RNdI4tnM+LbJtA6tdRfXIOJW9dgHmOY1ki8B1ecNF2vq6RBHSMArH1yml8MNRPWIKnNljf4EqsHnInmRADKvBiVms9ESkIUW036VV7g0BMGWu+CjFJZg82TqYQJRVyG5N+TTZ5SdUGKZJLKX6wYO0/s1cvauUe4K80ctCj48sDs7/cbHeZ1jRfciFigmHqoB2UrIq+qCacBhEAlMfwOKKuj3QMs/1PjEIokcKHY7fRcEB8qPt8hH9+yAfYkTncrZeE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a23452cb-9cd0-4252-594d-08d7f01ae9b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2020 11:04:27.5497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cHU8lvnzqS3OXw308NpBB207jEFHYbAQOVCN0gLr2Q0DTJl6hdE8i9d7TDl+OSmPlbCkEFUzd53HJ5Q8XW1Adg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4944
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> Add fixup_dev_quirk vops in MediaTek UFS platforms and provide
> an initial vendor-specific device quirk table.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

