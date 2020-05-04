Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0752AC3A5A9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 10:39:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D308820721
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 10:39:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="TZCvqpgf";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="SFOqvkZv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgEDKjA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 06:39:00 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:22166 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbgEDKjA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 06:39:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588588739; x=1620124739;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FwXG+TMXpunyUVasdokpmJi7frTG6neYxSD/E/O+P/c=;
  b=TZCvqpgfCNIQBAEIBMQv3yPdVwDtC1REharAhJT4vRvwxDBKCGNMkni6
   TcpkQoPANeglIqEZM5q97U7C/V0LY7zuhXhu42YJHo7+d69VRNgJ9D3+b
   9aFcQyxTpV3S98LKBRml27uk16UA0q4bdz4B0H7C+Iu93s0UaSaDaUnlX
   5s5WqO3YMvlDFKSXjpN10RnSVc9qPWxIOTb+Hojpo+fdEacfkrwifselD
   mSiag9oIaFxrfYNTSv9gGkpUkIt43k1yk3GN2BajZ35nS3ykr4NWY92eY
   eWVTRSF/GEQFv1AD3IKiNbfdClr0lh2LviRmJMJWAUhGfYtpioyn7Ri+Z
   g==;
IronPort-SDR: mAo7J/fFckCqxXpG4f9exYON51t2J6LaW/P/4K+hBGwsQPELkrffUOMUcBcI7gDdM+iUetOkSQ
 yRZ1wr7XJ2F+VsceKK925BHkBtGxYSqxjBVUY+Ovcvl3tMMqMsNvjLy3tt2Nnz6mKTexIx2Anp
 LN3Oyf+uzJWFCrPxpVfcjlbhfP0v7NQEg26b/wxUtmA4fJAG7dEZGk93oHzMwNuL94vvUf2gfq
 UnIX2+pybq+a+Uf/eHRLA9eZHCyQV5F9Zcmi85CdQeG+N6fX5X1me/EGcZTBo3FHowGn54Luyb
 0NM=
X-IronPort-AV: E=Sophos;i="5.73,351,1583164800"; 
   d="scan'208";a="245702817"
Received: from mail-dm6nam12lp2177.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.177])
  by ob1.hgst.iphmx.com with ESMTP; 04 May 2020 18:38:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=loUPuMA8Y7W1e93H41wwCXI8SqCEes4Hv4kIcvVSdvFXbTzhy0lrKUFrCrwgHo+0mtnFqGE2SgC2sB37wDtVKJscshuVpz7WCcYtp7rZqSpqdqlcVGY4OGoAmei4UHhRrSXWPsMQMCZ1vI+25YOGEhpdnd8MgoAHW6P3b9nwtH2wRSpw6D9fl5c6m5Gi1RDTPTH1rC8zNqkgFeG68nEMS5YEqq4GHZe6n9qsttAGSzSXQaDRZZLwno6FAx9udiATqFzg3HBziXxQ9Sl0Bt8gomeCtgCvYVji8hizJ2sD7PSJtDJ8KWZ2HxG2dWlQSTterHVfqOxwCwcvZ0wJuL3KgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TTMP2XBQGRYyLVgiFyEHb2BSzLlGfqhcihiAh4a3UKk=;
 b=lJZOk/pEeKFP9L7GWZkI8V8RP71dnnHngiCXPFJMwRqafYLqSEAqBi5ZBouoWMxfaZbb5RlGOH+UBWpaaw/nh2tuR14l690juEdgkcKcvrIHwlfU+dUNXQ/S7q1hoHO7bWLowdPq6k5ZL9B5lJKR+5tJA0JIRoUp7rifDhLQxDYAF8lk0attNtYk7J5egzEEJ2N/TDcQ9JXxEAHtPXjGTkotcoT8mLMQgh7jiO6YqoDs77rbWD0K/NNNCNolnByXUzKoJrXY937RIX940xbTCYuylh8oOvaaO59OKhn/vuyHNETxnkCyd4I75Gb/RwybH9CwHqsi71dSc9M0YA7AoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TTMP2XBQGRYyLVgiFyEHb2BSzLlGfqhcihiAh4a3UKk=;
 b=SFOqvkZvEUZ3f8mbQyDUyCAfZVjYm/3ePPeGbS9VRzFNvy/9WP2as3WVoZCqNE4xd8FIZp1fEMHg1Rhez2roAs3RlT8Hj1LqRBPMgE6TL3MGR7WlfMUyLNsMdCN7xtji8P1f/xys9cTdf5p/SL7ZBjHRqw9hwZV858VP9KXVGdE=
Received: from BYAPR04MB4629.namprd04.prod.outlook.com (2603:10b6:a03:14::14)
 by BYAPR04MB5815.namprd04.prod.outlook.com (2603:10b6:a03:105::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Mon, 4 May
 2020 10:38:56 +0000
Received: from BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::75ba:5d7d:364c:5ae1]) by BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::75ba:5d7d:364c:5ae1%6]) with mapi id 15.20.2958.029; Mon, 4 May 2020
 10:38:56 +0000
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
Subject: RE: [PATCH v5 2/8] scsi: ufs: introduce fixup_dev_quirks vops
Thread-Topic: [PATCH v5 2/8] scsi: ufs: introduce fixup_dev_quirks vops
Thread-Index: AQHWIT7PzG7CXHcWEEulPGYE2+Uu5aiXvauA
Date:   Mon, 4 May 2020 10:38:56 +0000
Message-ID: <BYAPR04MB46294C86DB9BD1A91256F39BFCA60@BYAPR04MB4629.namprd04.prod.outlook.com>
References: <20200503113415.21034-1-stanley.chu@mediatek.com>
 <20200503113415.21034-3-stanley.chu@mediatek.com>
In-Reply-To: <20200503113415.21034-3-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 791adb35-f763-4f3b-d22f-08d7f0175945
x-ms-traffictypediagnostic: BYAPR04MB5815:
x-microsoft-antispam-prvs: <BYAPR04MB581511CE2BFADDCBCB92D3B4FCA60@BYAPR04MB5815.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 03932714EB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o4pChki1X8iMKkpLsr1BzPW50MAko4+Tzc5tYqQpR0h332x7SGEY/WsUGGX9+wIr5HT6KQNnzVMAQexmVZVhcdBnSfwNXogenkSnQF1sDyTEN3Lp4xJuxpLM1aCAIa1svL7wjgeJgHyRJzV9vlvXORFnfRuCpgWWL05u7U1WViBV/aAEy5m+pAWbGHI/mJLTlt5e3QaVIjWLHySlrwhZx5tbmg37zL7ki8lrm9RUfCqDFJTuuXL2JzwnpGJ9ZkLaZjXm+wQ742W7Q8NHcr4LkF9V723iSIkEl6ngCKHHUC8X346eD/K2YwBac9MRmlO/0YsOZrDTlZNbmApdzSd1zkJnD5HtHgls6C8Qu6+sGDDwe2CgE7LtK5Q/PutXRYfyN3PI1vMGSho7/TGhHLx631vpFRIP/58heG54iciy7/hIEmDUaoL7H93Zr7HRFyMs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4629.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(136003)(366004)(396003)(346002)(64756008)(71200400001)(186003)(66946007)(9686003)(76116006)(26005)(52536014)(55016002)(8936002)(54906003)(110136005)(4326008)(558084003)(316002)(478600001)(33656002)(6506007)(7696005)(66556008)(66446008)(66476007)(2906002)(5660300002)(8676002)(7416002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: xw7W/MPdOBlH+5/d/4sdd+ULjm18HsHJhMhEQ0tnPiDbnKS28llL8SrM9t63tgNYwvjQDK1XTNLLb6mHgP1aMqFTMEp+pieJ9zJDxtGK9TI4StdwvEddoaXWVA7Vrtffx2vHRI11TyWQEGRUAx/Qusqq+gfYuM/fqdFkC/6TT0oBpn0WuQSw5JPrRRKl/qyGi1NVCHTf02rhHlc+GNoPrrcx+fs8KLh8F/ss5GYLTos2qSUgynbvjkYD9sEBlHKngZ9iCfijBtPxhzIbbrlesHcncT1S86LM9oCyrxOwY6s1L/ZXN+Jx/oilu/agZbBNAhYv9/xuECITRuQDfm/Fmw+REZR9BAj4wVAm0e7d4CU9eLql4Rg0riEbEFZruzCbBlXaTg0SgzmV6Qw3TV9vE3ICv4nyOxcEDm0h0LVinvzl1JnlwonL30j5DFXXYO43o6eDifTTpui3DAeFnK6i5VUpM65nhc1nmb9EtcWVxQTSqNX6W7lVAtMk2y/Gr5tgb+sqbG57ZpnzqN142BPYs56Ag76GeQDqzMAloWH2cRx2T5H44tS6RnoggQgcxeQFCIkXumXnsLCgG63+/4WJMxYDoNgC8QKOf85M4+p8G/K/9sqyvIpMlZh8yi4EKZ4i0ZXdP08xYONkMOWJf2IDnmrhNt38wu+xJd3e48KVmjIX6deqKih6/K49hDN6ZLSHL7b/0nrJutrBGoBp+bHmyAf9pltXlWbAVeAYm3FdxEV//aFRrw9tY08eCBtR9+riYCK8FFBtgQ//dd1sX1uS7MUm2iRCtDv2t9H1b3fwlBA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 791adb35-f763-4f3b-d22f-08d7f0175945
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2020 10:38:56.7357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lKieLbBUq2Z9wIt92T5B30cBIPOak7cxI9rpD1YfSnoNk11cZPBzVGNA3+9UYgN2dodPp66LXsijAWYulwlcHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5815
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>         ufs_fixup_device_setup(hba);
> +       ufshcd_vops_fixup_dev_quirks(hba);
Maybe call your new ufshcd_vops_fixup_dev_quirks as part of ufs_fixup_devic=
e_setup.

Thanks,
Avri
