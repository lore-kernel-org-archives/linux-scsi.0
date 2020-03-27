Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBEF4C2D0E8
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 09:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5C0C20716
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 09:24:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gRMjhPzt";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="gtilrnv7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgC0JYF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 05:24:05 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:46398 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbgC0JYF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2020 05:24:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585301045; x=1616837045;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lDo/TSlkBXUgR3cgb8CY95Hs7rhKZIA0K1QveVkZAcY=;
  b=gRMjhPzt3m+YAIjPkQyWY55asU94nXPcD67Yt7hKscoX68gFBWMPSNBR
   mU2JovR2QGCqTBWMPlmRCLuoZai785p7Vtt/eTA0xLH7wk/TrOShFtsZX
   LaZu7u41xxaXAa60o/X3oSi5ER6k1GRJ3fPDhVJP/TtAoDv77/6GBBTta
   dXvWVyeHhRiqE0k9Lnall5Z8y+w+1b2C4iQ7WPzTUnLy5IGx2c3OUePMR
   rFz1R+MEUNy9QpjP6kNVjVJezIh2F9CBRCidprhSwUbCTPDani0QwkS5u
   J8VVsag1LQaJvfJQaK5MhDlsP+FiIHJppojx7XT6lhryxbKXW5isd84B9
   w==;
IronPort-SDR: TZfSMZhkqogl972qsRXk5w2y5PEqUeP/6Ap+7G/P4ovh6W+qFg+8AqjHscwY8NjNxDq3h0uM5P
 Bj3XA9QVc9nPp7KgsFWISKfpJwLJevgqeNxmXBAuYjB6gnRFFU3C/uh46VFsx8trdqsZMpaHIf
 RodDiiAzC/oWOX2kiueTJzQex0dEt8gZ3EUaZLdpTyW65llRDCGqNXSjgG641YoeT+NPYdlpvu
 4w4jLjoji7qQ7QouACsqjPn+rfy1vMTCfouf0P9cb7xlVp6dcgNK6kOyI/r3OrZmsE43Z/XUKP
 Axw=
X-IronPort-AV: E=Sophos;i="5.72,311,1580745600"; 
   d="scan'208";a="138050358"
Received: from mail-cys01nam02lp2053.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.53])
  by ob1.hgst.iphmx.com with ESMTP; 27 Mar 2020 17:24:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YjVqbucOBoFFR3M51SeypvF6HEKTEDyU5Jr26GUSnpF2GjTYZdukDJbLH0ru7oFPwj0s+q1b8sjVj/sVR4ABwupT7Z6FuZnUyTRi6Zj9r2LIq2JMC0JtYQ9JPl/hsSX3v7jhXoww+UXPNcTyBj21nwdT7gMyjBKz2jfAgHcHKXjLjKzerF6qeiHyl4EeTS17o6RkvHZTdhA4+Zva4c29TUy+/1n+KYmM6n0kL0qNxjqH67ZiilbC8pFtqqZ0ig13kKop6iygQ5teMK7Yd5WDDZt80QydlaC8mTZ0O02sOnAr+bU5GTRsnLbFYRPNidn6uF2o3ENjfflfYFiGnEVP4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDo/TSlkBXUgR3cgb8CY95Hs7rhKZIA0K1QveVkZAcY=;
 b=S+W7Bl2k9nwdNU4FFCrlrlQnF5MapRvyUzU9vKD+68bjD5spvVONfz3RAq3mYZc1+Z0n6/9RogMjcApJzbA1V8ZN+osYRIhq9mxgsZLW819tOLCfh+J2+jUSoIL8pFyqT3Dl0G1vsvRY+NVDZ+gRhQ30ZX5pYDsUQLrFGHvVNgQAIOxe8YAYcQ2Pn2s0vqepHqOVx5/ID2QcpW4ORSUc4Rr1gAN2v/eI4ClXHge0oci6t4J57gKPxK4k0unDm3nQs+3VwTgnIeCJlAa+s7Jx5gJEpp38dkrgSs+jwIfVVLtsc+Y3B7GdnVIYjNOnuE/EUhMn2y8RH58gd2+RvY+Hwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDo/TSlkBXUgR3cgb8CY95Hs7rhKZIA0K1QveVkZAcY=;
 b=gtilrnv7bgbOXem8Dlc2pbYHtGwn61pXTQtXt6eSSTWo3QKwBwhmBjDLo7g3SUtvvUerqTKfwyrAgh0wZ2MsIaG88hyXdsoGCx6v1j0+nv7YSMDwQqe0bs8BqoplkN3/UESvuFkUjKeZQLQ7hGPmdm4mbMxx+5u0MsjSyCi0Ps4=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4061.namprd04.prod.outlook.com (2603:10b6:805:47::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.22; Fri, 27 Mar
 2020 09:24:03 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2856.019; Fri, 27 Mar 2020
 09:24:03 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
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
Subject: RE: [PATCH v2 1/2] scsi: ufs: export ufshcd_link_recovery for
 vendor's error recovery
Thread-Topic: [PATCH v2 1/2] scsi: ufs: export ufshcd_link_recovery for
 vendor's error recovery
Thread-Index: AQHWA4BerP2CIkNwMUiOubR0qnVvTqhcK6kg
Date:   Fri, 27 Mar 2020 09:24:03 +0000
Message-ID: <SN6PR04MB4640DF2D1EA1B3D6AF6C804CFCCC0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200326150747.11426-1-stanley.chu@mediatek.com>
 <20200326150747.11426-2-stanley.chu@mediatek.com>
In-Reply-To: <20200326150747.11426-2-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [2a00:a040:188:9054:d519:d5ac:475d:740a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f1afb3aa-26f6-423f-27fb-08d7d2309715
x-ms-traffictypediagnostic: SN6PR04MB4061:
x-microsoft-antispam-prvs: <SN6PR04MB40616EB2B8B4221BA8D84555FCCC0@SN6PR04MB4061.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-forefront-prvs: 0355F3A3AE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(6506007)(66476007)(9686003)(66946007)(66446008)(558084003)(86362001)(110136005)(52536014)(66556008)(186003)(64756008)(7696005)(316002)(5660300002)(76116006)(4326008)(2906002)(54906003)(55016002)(478600001)(8676002)(33656002)(81166006)(71200400001)(8936002)(7416002)(81156014);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wmyWZtH0CrmrsJwPIYvOblcQazCjJ1ACTRHmreSRkEZbDdOL8Pq10NRnKrWftlYE90yYyUddGHynhudfOECi9UjauLRcGTR3YvzmKZar7xadmNXOX6INTAJ188+53lO9HGh+lrZlFRz+scwxqmnTUTEiQ6PtjOJdS7/t8VPiKM/OI3YM9PuQ9zYPyRuRc8uW4qzPGtbo3jCbEmNJzx2Z2I0se6noFA97EKiczBKk8C/4fK3f8lipMcFQZXW76/TpHT9WTXHGyn1+C8uHPNNtDl2T1DcZS5yuFe299o/uYhxCjhHjfVjKejvRmbbvi1oNauj1M6InwpE0mznSKIQ2R5jnypOeSKCrWS/0Azb4+Q/TifO4mAb7LAzrHO4m51UpELGbPehwciGTlil/EZ3TN4eZ0hNFcAZoCWDC3yOumP56P4fS5oyEr4N880ya/iwn
x-ms-exchange-antispam-messagedata: A6vVVzeczgErC+z0TsrQbbTXQ85Y2tUlToYOP1pvRogQkwV1jQRMNeXeLM4ohC3u01TnaT5RcaVcFohjzQZlAAIXCrTXR5EBW6XzAh0P563aPjS1n3b4RSykJ5VXvo6siWzDMyT8YjkLVleuYNhin9yxk93j65hGvZFB+01pAqtqt8YDHdXNPcC40MZ7EWNhdk2SmmAo2vHeoiH3t0bn7w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1afb3aa-26f6-423f-27fb-08d7d2309715
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2020 09:24:03.0384
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ffeGwl3cYM/qg0WVq0HENWD+B309QI3fBqPJqsNOG7pR5qOvKofoCamJ7fEdOwomz3C1qUozTZvOz+yiQsELUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4061
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> export ufshcd_link_recovery to allow vendors to recover failed link
> in vendor's callbacks.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
