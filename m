Return-Path: <SRS0=CpYn=AB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAFC6C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 08:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 976A823A5B
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 08:28:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mamtz3lx";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="0H5mm/AH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgFTI2h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Jun 2020 04:28:37 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:63303 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgFTI2g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Jun 2020 04:28:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592641722; x=1624177722;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=M8Ta3WnTF3Un/HvitwpXnn/iJe/l+AONdSyJYFxHhA8=;
  b=mamtz3lxjFgWRnnw5JDH1VSyMY5og3efE+3xxxtueGlyQh9r9bJ9/8BD
   V+NvWopnpD/CdYvwGtlVRAZl32DcILQzWtA8SFJrscoJLqUGbEexinEyY
   HOwhsWR7igVOVpwXmKjIP8EWHTtg6Ih7B+jAxfwwbjCVYQloXfv/UMLp1
   Q2uvLwJ8YEpHVczCKX7lSVIHxDc9Lnw0HT+5uMxN4vymYPxpdiVr//bND
   Y0XDbEMVc2jiajPQMx/PvP4Onic6Xm61EPXrGsZ17tCksyQdaAX0nza1O
   9Hgkcj5yhskZ4j8x7a+lA8M8u1hwPQ6cOehuQpCpkjyMC0dlpbXLMTGJJ
   A==;
IronPort-SDR: UnT/EeDd1qp6XzdncRr/F2BGg50oRwuBqT1rE8SzzNsBCVtF4NrHt17S/DIBT3YXzV8lO3Ky71
 y4nQAMPkHtz7T0/YuzPrl5A6yBhqTUmltv9fPYXC+OdbOaw6Y0WFtilAnsVXJdplgj7I5pWTnB
 fBNWTSyswPL9qO3+tplE69PTDykVnXiJPi5/CacRgIpg3MSxkrryTU4nzAzr0G5gcamicdEiji
 fgcYfh22rkplQwyf6O/ocvbqczHJzLnmi18G/mpanzfDZXqMEdPBcPtdGVVRfpL6ojLjcTQZQl
 zXo=
X-IronPort-AV: E=Sophos;i="5.75,258,1589212800"; 
   d="scan'208";a="243462425"
Received: from mail-dm6nam12lp2177.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.177])
  by ob1.hgst.iphmx.com with ESMTP; 20 Jun 2020 16:28:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2ClmyQCcTuoz6mA3lHA+dzISsW6Llmjt51tNJYmoQA7hjR/kEttQmm5XaLhDCSTWukapO4iOvMLDkPNVQU9QwoL27FUN58QVyCbLCICvi8XRCVnVBq9HatyNnsCZIEMc3A5ng9LifikFWEna91DCAjC/gEwkXSQG18mzYE80gOn/yfYOfNnW0ipHTyTp1XKmtuSMcN2kc+d6KEvUvltHs5nMl5JxBsCcnS74DqW+iqafKRcvt8eRT+VA+bB22z7nTh27cvGi99oQmmc3AFqHv16B/BDpDzhlRu+pEtC2MEwqUm7jJbWnQxBk0eGW9iRJSS0zGBbKSXRY2IrBS6ylQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IofQSUMh5rafRReoPIlY5gruUHe+nM9wdfrAYkU60O4=;
 b=iDsFjkJFJm6pKMqyhoDnX2dUj52IC4Tws/89R/NcHfMhSqG+OtAw3nWm4EDmozLDZLgH/vzauyYg/eL6BEzs402BWNB6JfCvn9F1b4GmR9rWlFrmCpTJ7mGOf6Lo9e/uJn0sP1ZzMZeSDnb5S4ujSk2sFuVmFFi389+0cUC8V0ET/mHzOxkmPt9BYVPc61n/4wQpJFol+BQFnZI1oR7G+lfYyZzGo/l/yJjnldia6O/g9AkUr+28BXqHVwOvnumMrvlT5plGtmAmpDZnNb0BSVW+jae3ajxTRaLY4jF5KZXZ8aJvIvBoFzE7856eZCdQr22W/ubpZdabXvVdHzVOYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IofQSUMh5rafRReoPIlY5gruUHe+nM9wdfrAYkU60O4=;
 b=0H5mm/AH8QZfv3LNXNDG7tDIN5iEEjNQYpT+7MS7Ap33xsDD6zBUXtdNkV29gr9wtr/aKo8JtRr+AfWGI9TCCxc788paEB1Pse9UNEqjpUjW7kRkzWdpCCGNvp349eYkqCjV5zNPrKBx+WFM79FVgEkxopc66BxhMF3xgBcUSE8=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB3917.namprd04.prod.outlook.com (2603:10b6:805:45::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Sat, 20 Jun
 2020 08:28:32 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3109.023; Sat, 20 Jun 2020
 08:28:32 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>
Subject: RE: [PATCH v2 0/3] Inline Encryption support for UFS
Thread-Topic: [PATCH v2 0/3] Inline Encryption support for UFS
Thread-Index: AQHWRrYXnkxifjeS80qrV/YqWlM3YqjhK+Xg
Date:   Sat, 20 Jun 2020 08:28:32 +0000
Message-ID: <SN6PR04MB46402AFB00B8DF77570A643EFC990@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200618024736.97207-1-satyat@google.com>
 <yq1a70yh1f3.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1a70yh1f3.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f6c44fd8-76b3-404b-1157-08d814f3ead3
x-ms-traffictypediagnostic: SN6PR04MB3917:
x-microsoft-antispam-prvs: <SN6PR04MB39172B8FD5DA5FFD8F30B1E3FC990@SN6PR04MB3917.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0440AC9990
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TbC926F+EqNvWUyvvdj129y4YSnk2Y5R/vatisNfzIhY9RxldjRh9Yihx4xHdZGzGzMSfzJdv/WCCeC6/tbi9P9s1MhxvSLngeAH/MicdnTXJs2Kf+dVST7wBk8AScwYAQpe61kS5gkic3ZGx1rPWC6LsuSAjnwQ7Bi6HpYU2fOqneboGYVtxiRvz08yeYkHm0NhJUXiIdo0pc6zw4EoghS0hw3CGNlkyKx+XRDMn+yvBpFHM2TudIMRQ1cJEimS16L8IBitYvPA7qK5BuPKo5j8JsZDkH0SQbtvAv1iXfQPY8xa1SzUE9iCksFEYsfkuCqZAAiY/tvrLeWfcRiZxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(478600001)(186003)(7696005)(26005)(33656002)(6506007)(66946007)(76116006)(4744005)(66446008)(66556008)(64756008)(66476007)(9686003)(55016002)(316002)(54906003)(86362001)(5660300002)(52536014)(4326008)(8936002)(6916009)(71200400001)(8676002)(2906002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: meOT7YVhoR44qnmD/QLE1Xo+6D01nDgZFn+p6M7XeDsegC7XWFt16V9unJWVilPtfiOLGugV2YqnDCXJ7AfI2WZpBGLDB+2/4oQlyDTgz0oBzRtFU7E8aADkpU9n/6RzHcym0OHzncjvHfqb87s8hmHj2j2J5tEnvChEJNzU14QO7f7SKs6hk7Zd3MK6c6YrK4tHnjEJAz9nalqHVlRy/jC14z3qr2vVcDLFQuzGSs8ezHlYYg8gDRBzn4l5cqYFlKpQQ3lFQlXFGD1BqLS4Bah65Kh32BI6KxQv7/k+80msug3CV7ygLf4SRMdvPRzBggZv/SVl8lGkH25aAIcUsvZrwTauxecGKfrJPqwoMPB8H0geztnmV6s2SnC12TtOAzANl0aXJml1yamqMT99VIZnFdkNmybbKJ2fBvIpHJktGY8n0xtzUhrbhgL0wMuN0lm2UrWPjmE3CoRpXjE/dKWUjro1qpjbWD7Z64ypQIY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6c44fd8-76b3-404b-1157-08d814f3ead3
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2020 08:28:32.0535
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3MmsEb+dM6FrNUB/ozURYb6xp1CyAK2Aqkczj0cMCxuzFqN+VQOsRevXj/D0AkhCosGR46Tm/EwBGECZxo0EFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3917
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Avri,
>=20
> > This patch series adds support for inline encryption to UFS using
> > the inline encryption support in the block layer. It follows the JEDEC
> > UFSHCI v2.1 specification, which defines inline encryption for UFS.
>=20
> I'd appreciate it if you could review this series.
I need help doing it.  I will ask around.
Thanks,
Avri
