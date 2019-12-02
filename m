Return-Path: <SRS0=lopX=ZY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E8ADC432C0
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 07:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A166215F1
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 07:44:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iTnuWDHf";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="kIUfdlWM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfLBHoE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Dec 2019 02:44:04 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:21490 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfLBHoD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2019 02:44:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1575272696; x=1606808696;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vAgUmA4OpOQAlsw3GcFrud6/8ONddjz2C4MYkVcD28Q=;
  b=iTnuWDHfOStZXU08o31dn/CNn6vFGoq9keOifBNNvNkgEsptxv2j+nw+
   wY1SO5pRsFAPG4WEXHuqrSYtcJRFCXitXeoQrOKDETgI8J5HOyea16blb
   XntZbMk/giH1OdcCbqngy+T4YK6WzEiUEVnbloVuuK9NnzDS6DIUkbI8F
   aH8cRvdGF1JOxHRMQe2zfQwxwfwSZltwjsa/k9SBtkISll4NeFI/Q8Y8X
   iEuvTaS51qNvWPzho5EU5CzgtFyA+0P3DQ4NY1M0cSVdDTYa29WIzgEb0
   99VjqJ7jB+b9e+LDPqJVTz/7eg2Z71ofBeWE0fjQIi6S52jfkQpW1Jz7E
   g==;
IronPort-SDR: 9BqpK6+WLl5fkFqJ/WgYmfF4a+zt55x012qvQsFr1BBWDLRcr7wESbYWzClRw1ezSvZ0rkG05i
 Rqi59nUoQpYhxFkbd3ziBacpp43HgdIMPicg1EvpPjTpZvUqkeGC5jwkGCGialWTFSGYy4N/om
 ydut8JKDVLzTCD9sNon1Ce2bZPgx1wOm1+mDCz0GUfW0U5OTYlxCrKzwIJhX0poRd+dyLgC2FE
 XulghAfDENNTF9EbMKM0BYNr1dzSVfs5TkPAAGYvDGcTuC/b5WlU5nU8YjA8hoqkk8jWnUhLSR
 h/E=
X-IronPort-AV: E=Sophos;i="5.69,268,1571673600"; 
   d="scan'208";a="225827260"
Received: from mail-co1nam04lp2055.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.55])
  by ob1.hgst.iphmx.com with ESMTP; 02 Dec 2019 15:44:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nLONDm/FGVuL2LdaWRt0uY2s+COYyxwS0iwuXFStLCLCxljirc5eUFz8KqAX2862zma0v7FmCF07yb6/f0pF5dlgUZndTgSeg0vWqVwhgDE1gVG5++RAUEKX1PD3po/6kFnR+h8AdnWBeOoq6hDEOAp53yt14DNfYgh6fW4HIkzVVEiUX5D/9Fs/TjSbpODmv8HY7i42axZmUBbgOm3E0sDdssbE4Ou6JoU+MKUDmE2hN+7RXIX2SdQ0HrI0VtX4/QPvjXbogR1tbGkEPjzdgaJpivmofeFiiw7RysYd+OAUZxv/7IE+J6BR3YGxwvPPXDY8beLbnkF7of+u+ZfS3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAgUmA4OpOQAlsw3GcFrud6/8ONddjz2C4MYkVcD28Q=;
 b=U1Zm6F2zq/GuCUi877mFzY21Yspl/+cAsZNCVuUmt5XmCmywhYssIPtHvXRgDqbNOZ7uAnCAvRu1ilNvWk3tf4J5IXa0PL043FBmy3cm/GQ9ihH62RIKkR13N8x3MDmz95PNgx+2qJ+Bjejzalacdk62jzG3gpgTVxhxcLgTKdxSabbgq4HBkVfQ0K3euYDqowraC6s3gEwSMlZqBeSlfUPY0/kH9afBr8RSbMpWi/yR5zNz6RLszTIbzdCjUEG64rvAs7i+U30X84ro15pcLy48kXEJfW419XsFE/94iZOFWLb8LRjv2tlKEJZpqwst7hyJM8pmW6k4V5xxgWCxbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAgUmA4OpOQAlsw3GcFrud6/8ONddjz2C4MYkVcD28Q=;
 b=kIUfdlWMd2gJvYw5mWAfXD+Gjyl21L7c8advkTFoQ6rlT6Ix4dUMTKIMfU3voollKKubh7J3pp/UrMSBhDYOabqlqTdzZc3iReuDijlEidbJSNi4xrd/D3TDPTu5N1V+KGDLh0E47cLQESG/ZhVrVXd0LBCP+DzA9GNwhSSb1iQ=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6765.namprd04.prod.outlook.com (10.141.117.71) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.21; Mon, 2 Dec 2019 07:44:00 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866%3]) with mapi id 15.20.2495.014; Mon, 2 Dec 2019
 07:44:00 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 2/4] scsi: ufs: Update VCCQ2 and VCCQ min/max voltage
 hard codes
Thread-Topic: [PATCH v3 2/4] scsi: ufs: Update VCCQ2 and VCCQ min/max voltage
 hard codes
Thread-Index: AQHVpCZIZTJgFdv/r0O4vZ8y+z7ltKedCXxggAk6IYCAADxtEA==
Date:   Mon, 2 Dec 2019 07:44:00 +0000
Message-ID: <MN2PR04MB6991D119205D95E43677036AFC430@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1574751214-8321-1-git-send-email-cang@qti.qualcomm.com>
 <1574751214-8321-3-git-send-email-cang@qti.qualcomm.com>
 <MN2PR04MB6991F3919641BB0F60BAA03CFC450@MN2PR04MB6991.namprd04.prod.outlook.com>
 <0101016ec4ca5743-ec27a8f4-b0cd-427b-a65e-e6a26b10d45a-000000@us-west-2.amazonses.com>
In-Reply-To: <0101016ec4ca5743-ec27a8f4-b0cd-427b-a65e-e6a26b10d45a-000000@us-west-2.amazonses.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 58580ee5-ed3a-4577-ca1f-08d776fb652f
x-ms-traffictypediagnostic: MN2PR04MB6765:
x-microsoft-antispam-prvs: <MN2PR04MB67659F9E13BE6BAEBB69E8F6FC430@MN2PR04MB6765.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0239D46DB6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(39860400002)(376002)(396003)(136003)(346002)(199004)(189003)(25786009)(6116002)(15650500001)(6246003)(76176011)(2501003)(8676002)(33656002)(71200400001)(71190400001)(102836004)(1730700003)(6506007)(55016002)(54906003)(74316002)(9686003)(229853002)(6436002)(305945005)(7736002)(2351001)(81156014)(7696005)(26005)(14444005)(7416002)(66066001)(5640700003)(256004)(52536014)(446003)(11346002)(186003)(99286004)(14454004)(4326008)(8936002)(316002)(81166006)(4744005)(5660300002)(6916009)(86362001)(66946007)(66476007)(66556008)(64756008)(76116006)(2906002)(478600001)(66446008)(3846002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6765;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mfeJKGKOaVFTVXwg9OkA+roXOz0b0D409pIw0zZW2KBEDkQ7Rd2C3npBp8aUS9RA6SJ5IaZE/Q9gTstA9Af7jIqfk3MwRYe+7y/+IWEYNYM7GuJy3Q+4UGDOXb6CGf5TDtJ23vmsG6UWVMrQ9SQn3uiS1n4MnmMF6PwzmAfoPpx5M5wqubKSU71dt7eShM+zWw+Yf40kxySlt6+lkXKG7/F9LjwWxe8aSPwJwMFXkEoupkfseE5frSr4u8GqPqpo1XiPyw7LFiyNl8jwMVzgwdDdMbsk/1v+s42C1TVbJdyOqCMwtlCLoUOiozbPk8G+aYrM/guAJRDjZU7e3wEPcMaacSeY8dJAO2IYOWo0LgU8SwyqcdeMTxlEivg77r7EZu2wIYUx7wdkUoGkOoudMMvaFW5ty9xO1SfMG5tNOIZIvo++mUjxTGjyC5lAta+Q
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58580ee5-ed3a-4577-ca1f-08d776fb652f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2019 07:44:00.0842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3SAqfbMZnA630aAWnCvf13D+KGXbEEfrjYBnLM7k1nxKTOzwyvnSYy1hSaAQRg29L9bXRuPoPtZ3swcb8WbE2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6765
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> >> Per UFS 3.0 JEDEC standard, the VCCQ2 min voltage is 1.7v and the
> >> VCCQ voltage range is 1.14v ~ 1.26v. Update their hard codes
> >> accordingly to make sure they work in a safe range compliant for ver
> >> 1.0/1.1/2.0/2.1/3.0 UFS devices.
> >>
> >> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
