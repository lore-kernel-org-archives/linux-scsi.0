Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F827C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 14:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C62D2075F
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 14:58:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="IDRJir4z";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="E0HIZurX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403821AbgE1O61 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 10:58:27 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:37414 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403770AbgE1O6Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 10:58:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1590677905; x=1622213905;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7Rbg+fpxveZyYmBJCf2fzaHoUltLb5FDdPTSlCWwK/U=;
  b=IDRJir4zUurARgNyaWWj+LVEBqRdgeBOvFe8aoxpeAjMWkM+ZhCxa+7d
   S7Ak+LKU9JnXvyQFsTMp8nUM01kHSq8U3z8Z0YTxhCQh9M8ypxzLQDO9F
   44lwISL6FOW5mfM44SC9AS9ok1Oc+UPdWOO1Yn9IrpCYFYPW7Vl89dz8l
   KEZFdfnifVGtxgX3xL+g9g0lQG9UiWpmGX11QMMB6IEZHOo7qLtLc2KqY
   Pu5/ksUdHgk0jHVjwrA0kd6KqmTYDituJXJ5azoOeNUCeGkK26W8WsBwM
   5jyamd7OXZwYP/RywUaz6XlH6+YiKp4VzB6jbL8y1EaQEoxkOte8e35V2
   Q==;
IronPort-SDR: 00Ai3wkTbUDxmrkH4dhmlHIZbUlcINxTRtiRQuBsXpnY2QdQ1wLiJgPwir8H0TjySgf8ffAFY4
 0/6VMhR8BZ0POfTL1+d2jAOv8FcUUxvNw6YXvlgamYVWQKKcXGx0TFCNSrx8qPmaGaYYWXYrfB
 Eit67PO9E7NgXFapHOO+DB0HRSc5DU1w/OlsBkKzec7CK5ZHh7bogEFqzITxHGnOWVnhx48kIr
 U6LfWSuWN1mBnG4bhahaFCBA8zzORm5OcFHj+Y8COTloFL4BpfG7vvWJZ5uWCxpY/9Qaqzdiu2
 EdA=
X-IronPort-AV: E=Sophos;i="5.73,445,1583164800"; 
   d="scan'208";a="143042279"
Received: from mail-sn1nam04lp2052.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.52])
  by ob1.hgst.iphmx.com with ESMTP; 28 May 2020 22:58:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1Yn/9mwO+//PY/4XJ7WJSm3kG0mZDserOTW0B8o8novydSWqsfnhdiKdvvUL/nCUIsH0wLuxESrtRaDtJyKBVJS4SdDBDFzlNPjIoUG3k7lPmB5Tb6ANXu2MUkaEWhqyl2K8sLa72v+zH/uV/Iq9Uc/ND7B4XX8mz4aSh63AjjiivOEVI2QDOvG+H0hi4JxMncfCAbOdBMoHictt2U59LBmXYpxX6TXKAIW1aMLl1KTyWBycD3oRDnis4DTrie2fYfSyU2liUKIP5aLpvik5AQd/jupauE0XeKUUPAI7sGf/3I7CuPjniy54sJshiq1K6bGmUQlcS6t4VeKo8dOAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLXjBbCuD8rQJ8nfOKVhEvGVQxvceGsvOBLoEwbdkLE=;
 b=jlsbIFH7Ir8Mi1Z6jTPGcNNn7GSNwlgFuQjLbj9+2SmEsiLQzYbiuL9o9Uis+YM6q68wEqxrlxjC4MogB/uQLPqZDKbGD7sYwhkkzAEMSWpN1K7/1ziVFNKW8BREc3nHEO4L0kgEiWPRFgbwNPmt3BZ0aYlWti9JFSY+T0+pwX1MnT6LOYgHMmUk/vLWEyScK+SXeKrUHIOK2JZe+awTedID0M1N4R/aRQ/XG6J5vqkTDn+LZes4KuROTqFzt8sMQURUE7cfqITcwOcms5IE41SvJTs1T9sdA1nuGqN7q7qedYtMnylxDXgeEEmY/kHbSIwmdEC8GHWGpsVyIPVUag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLXjBbCuD8rQJ8nfOKVhEvGVQxvceGsvOBLoEwbdkLE=;
 b=E0HIZurXUZDmrwLb48TEo7NPFbnaYx7+r9GxBcIrnXm0zQmdJix8KgvTIoqTL9PquHiPmxcxucVPRhCeHkHDHVsYHg4TDryLLqPXpxlO2PxUsQ62X3r3f5O4DzYBhu/5hdb2wcrhroSl6MiP+KeS3GZz6UY7k4thaayNwmZPZ8o=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5213.namprd04.prod.outlook.com (2603:10b6:805:fa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Thu, 28 May
 2020 14:58:22 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3045.016; Thu, 28 May 2020
 14:58:22 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 3/3] scsi: ufs: cleanup ufs initialization path
Thread-Topic: [PATCH v2 3/3] scsi: ufs: cleanup ufs initialization path
Thread-Index: AQHWNOcS9knWlNkkEEihSjLjCZj2TKi9j3+Q
Date:   Thu, 28 May 2020 14:58:22 +0000
Message-ID: <SN6PR04MB4640F8F4B293E6D3980952D5FC8E0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200528115616.9949-1-huobean@gmail.com>
 <20200528115616.9949-4-huobean@gmail.com>
In-Reply-To: <20200528115616.9949-4-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2a00:a040:188:8f6c:a5cd:360c:eac5:60d4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0ef18296-6ed1-4cc9-f85e-08d803179119
x-ms-traffictypediagnostic: SN6PR04MB5213:
x-microsoft-antispam-prvs: <SN6PR04MB5213138190C992079FC2BB67FC8E0@SN6PR04MB5213.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:330;
x-forefront-prvs: 0417A3FFD2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xyfv1lUWxXxkvasQVLSe2rjXaQcDPJf56oNCiw6M7ZB14bCV5LqS3ApnmgF6i6srxaAy3DpmlgK5LbxqTiA5B+tqaKh7GPwP11HaheQAJABm5DyR0WZlIoUVfW+sMvSYBMFMYaXO8A230YCRdMpqEvjdFr8pCzFZvXC9mqwVNU1BYvXfdhucNuQwBHwCWiIUGuVaw9KtG0IB/AAlPGn61DAkcn0txD8ukcFluFWbSFDC0eI3QjWotpEaVbDfubGB+VOFfWtbNmpHqjJFnus150BHVbakD1gNWfGAHpexZBpKmdgFK8WhRKwjQFDa6bWY+dHoaGQK7ONPs0yR8sIIQLVRzJk2UnGGrqgsWKefu6C7XtSFAuChMetaiq0WeLVn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(366004)(39860400002)(396003)(136003)(71200400001)(54906003)(478600001)(110136005)(66556008)(66476007)(66446008)(76116006)(52536014)(5660300002)(66946007)(64756008)(6506007)(8676002)(186003)(83380400001)(7696005)(33656002)(4326008)(9686003)(86362001)(55016002)(8936002)(2906002)(7416002)(316002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: LkoWfdp3GeqEvgOzHMZTKxJRT7mQGO7CIffQ/b6z9J8u081pSvy81x95AerEizbwL6fdcqsbDbnN3VaRd79JtCAFCeIGG5qRMi41ePT/N2vstEQMcx6VPxGdbT5NwnJ4kswmV80pNi6dc+TtgD/Cb6t7x637IUuyJxJPXJJkI3AdJbkmn/28VB02c0EymaaUqcvErVGutHj0DpZFAngF6itQGb0V24jeHYHOoWEcdj3pGQ29mX6Lev/Q+5SREjEEHwt4MWpJEPfuuIdVqYEkuw4n2Uax+vlNcXn8WjuIyyRdXtMzqTDpE4y1ApQzDkdvkcnZ9IdwJMQqrDGFi+QGlKW0Dk8wg004AaUnozZLeBvVH8rH98HR7UrFI2h/8pSPGllLHFWVCA1lS/b5WS35RAOQg55YrKeJ96HoMwAFdNOwBOWU9BLDrlBuw4d0MZazGetLkBEXqotr4lzTbRYBhjfJugpAq+QqNNLA5Am0lJbQHy6XwHTnx437vqAXbtTEFt1JbJCJDXPmcsn2WxB5ZTznE/D0K6hOBzJlTLrw7gX4WRz9HdLh7f50IEBD9Ehg
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ef18296-6ed1-4cc9-f85e-08d803179119
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2020 14:58:22.5025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lvhL3Sspv8uG2Xr6e6oVYlLGCURGdVNSJN8KzNXDBwfCs8+2hEU6F3sxOF0v8xzEHP5aSG9k7qd5l8KiYLUiuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5213
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

> From: Bean Huo <beanhuo@micron.com>
>=20
> At UFS initialization stage, to get the length of the descriptor,
> ufshcd_read_desc_length() being called 6 times.
May I suggest one more clarifying sentence to your commit log:
"Instead, we will capture the descriptor size the first time we'll read it.=
"

>This patch is to
> delete unnecessary reduntant code, remove ufshcd_read_desc_length()
typo: redundant

> and boost UFS initialization.
>=20
> Signed-off-by: Bean Huo <beanhuo@micron.com>

> +       if (desc_id >=3D QUERY_DESC_IDN_MAX) {
>                 *desc_len =3D 0;
>                 return -EINVAL;
>         }
if (desc_id =3D=3D QUERY_DESC_IDN_RFU_0 || desc_id =3D=3D QUERY_DESC_IDN_RF=
U_1)
	*desc_len =3D 0;
else
> +
> +       *desc_len =3D hba->desc_size[desc_id];
>         return 0;
>  }
>  EXPORT_SYMBOL(ufshcd_map_desc_id_to_length);
>=20
> +static void ufshcd_update_desc_length(struct ufs_hba *hba,
> +                                     enum desc_idn desc_id, int desc_len=
)
desc_len is at most 255 so maybe u8?

> +{
> +       if (hba->desc_size[desc_id] =3D=3D QUERY_DESC_MAX_SIZE &&
> +           desc_id !=3D QUERY_DESC_IDN_STRING)
> +               hba->desc_size[desc_id] =3D desc_len;
> +}
> +


Thanks,
Avri
