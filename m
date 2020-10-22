Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBBC5C4363A
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 06:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4977B2225F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 06:38:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hq8aEBEy";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="vhX7BIua"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504098AbgJVGiB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Oct 2020 02:38:01 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:61639 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502338AbgJVGiA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Oct 2020 02:38:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1603348680; x=1634884680;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i2ApnJ5UTokyh+4AiYffFp54Pcceo2g6w44gVs7Clic=;
  b=hq8aEBEyi6mO3RP74gzW5kmc17fZKr0l2f1PcCl3V/zjJJdYaQLKSaHk
   IawKC54Qwxwd1AHnY1vShAcjj9JBUBTW7HHUBZX/AVko9YQ0nzQf4gWYe
   yPS8jBR24sKe0ofWiBUNY35rz05SuLRCfIq0rqA4Yp3IQ2opR975XO9AR
   xQuPgyCnk4I6/GAL6Oi+vHOiCqJH3+bkbM5nv3W49hfy/8Q2rtSykr4NV
   7i62m2zN5cWnlLhUx0LkFxH9QYjyH6bGBn9h4LinUvhHdjSjntD9qMDGw
   /88nprHUmycQicame6LpEXKa7dA3GF8iVsAqF/41wBXSgfpDQRWqRNFcn
   A==;
IronPort-SDR: xZ3PUamN0ntMVmmDYBZaDTAIijNqgInntGGE+Ig9GZoHE9G3HeTdApNEJS/pr3zpq0jrakkD4E
 IplFDm8SD92GLmVSSTsG6umN0ctJtKqBtBUEiaplA+8a3NIizxKb4RWyRhGECYW76/IVFvZ1Lv
 awjHg7TkXyNhw8peaDT3vjbU8SU+QtKkdWICdt60QIY+2zn+gxsjr7CzT/vubAdi4USLWgHPKw
 83m+PLS2PNhfPjcbqnAyPDwR3/wWKEQNZn3UIwQPFWxNtPu1vdidG9UbJ51kD6LQb1F9CcUnmy
 Hqc=
X-IronPort-AV: E=Sophos;i="5.77,403,1596470400"; 
   d="scan'208";a="151821373"
Received: from mail-bl2nam02lp2058.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.58])
  by ob1.hgst.iphmx.com with ESMTP; 22 Oct 2020 14:37:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FYppETFBy4uByGXsCudpcfverd/fG6twNSQYT5WtPq805oR14tUO4Rd9eh657zu3ljYLSTCnQxBAGl1D1Pb1f2ysQViLhiHQ6onSmdH37ERs+ZmM6DOU7XxxDCqEJ5tV09l2Q9mRTdTC84jSaSo0JKPQoUmjkISAw4+BAh4KdwPonqv7JG7HZ9fmGhjKovoju2lQZWuC5RaK7re5zM70/gU5DwMeb7ObAQccusE/L9smZKzxGDKjV6jG2DVUPyck0iRct33EfdxyrhxygtgOb5QfdGowdEbO/7hjdCgYS7SDgLiHlZ7532nQOFbU0EOxVtGyoHap8lV+tjo9RDpcUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i2ApnJ5UTokyh+4AiYffFp54Pcceo2g6w44gVs7Clic=;
 b=hVSlb/U8ZzoX9hzU/kuc8aHpoDVFxZk2Gl65l12KKSTshjhCBeoshSIcb9a8A2jFT6vXWTaKbwgA4rqedeRSesbrAj/69iRfytC1IPcEzwmhAbT4RhtC/Tx5TO6FI3YWZ+5D5yvxTp0PAgp0KPnBWtzXb91/CWdlASkq9MoCfU5o7EncgRjQtWiyLdBNVYLH0LI9txW2sHB+iF69GoK6P8FH4Y7MQwkm+XrJQbXyiqUmEd0wjtvUVhjcQByBq/wggAqBtzpXJCRPEH2sj8OR5UrjHvguLQyX1iIFJ9rm6ufE8gAlV5OmBpKtzejwJB043H+X3DL3sb8TXdIlujmJ6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i2ApnJ5UTokyh+4AiYffFp54Pcceo2g6w44gVs7Clic=;
 b=vhX7BIuaSM+8ErCTFAUNCduB0UiTlVpCI6RtdaNQqRjhiTjG+8UdiPNgFBZVkvc7kf70+8/4yvL4CATX7DE/XOAsIEv5HXL1LEoiz5t/HF5UH/tFUoOE5FEh/yKR5EJmPqpEMxNbQeHAWKo7dSe6D9P+nYwVAn44kID2QZimpvU=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BYAPR04MB5798.namprd04.prod.outlook.com (2603:10b6:a03:10d::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 22 Oct
 2020 06:37:55 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::709c:ec54:b10b:2d90]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::709c:ec54:b10b:2d90%9]) with mapi id 15.20.3477.029; Thu, 22 Oct 2020
 06:37:55 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
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
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/1] scsi: ufs: Fix unexpected values get from
 ufshcd_read_desc_param()
Thread-Topic: [PATCH v2 1/1] scsi: ufs: Fix unexpected values get from
 ufshcd_read_desc_param()
Thread-Index: AQHWqDiMF/4I9jj2BU+KaBIJftcln6mjKqFA
Date:   Thu, 22 Oct 2020 06:37:55 +0000
Message-ID: <BY5PR04MB6705D719530D5E188ECB724EFC1D0@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <1603346348-14149-1-git-send-email-cang@codeaurora.org>
In-Reply-To: <1603346348-14149-1-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 625357b2-1963-4dcc-ad9d-08d87655025c
x-ms-traffictypediagnostic: BYAPR04MB5798:
x-microsoft-antispam-prvs: <BYAPR04MB57982AB7EB5B6C337709C54FFC1D0@BYAPR04MB5798.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jUkXqP7mUPAPH2Cs6CBWuRfcfwda6A5YLk9HfMbPTii4adhourr6L7OrZKgToAuFmDKFXMMyabgY+drbT+KBJY3l9dhP9On2xnBAsFuTu4m9ZfOSJ4FWiEFeAzyM5mNHluc5gJOIXoNqGx/SatIUo7DuYir87u/7vVOQwoWmkXwlVIAGwanpGNV18G1o7kydyVXCChd/n8Cw8QkiLCviexS9EFbE95CltbunqTDnwqdgQDVyUr9WmmyD3/4x+8wxkLVcs7wAw5uCsfERaRNNMroH7wBT9px8UKu32UcrC1flY0ZKtwuFHj0FStKBlp8j
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(110136005)(8936002)(6506007)(478600001)(76116006)(316002)(71200400001)(26005)(66946007)(4744005)(66556008)(33656002)(66476007)(64756008)(186003)(7416002)(66446008)(9686003)(86362001)(52536014)(7696005)(54906003)(83380400001)(2906002)(5660300002)(4326008)(8676002)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: SBp3Nz3FzCfuHfg8Usjkxbv06DyFSJ+bLqS+7bkxkGOKsCxPITBgJ6OirzZE80zW9OS1iE3gE3yPL67hOqB9UbN4cURoQ6jdn0ePHevOeVGyyTSIu8MC+ty83FlslQ3REiXX87GovU+PVu2h0inDnWT0aY11dK9hlJvddL5/knFL5W6Pij/Nk9k+itH0ZWhUNh+03FBknT1AifH1Q54gjZFcm/T4r1NkG16GIKo1oR+stiWQr1AHZtQHuzAJZ5wyr/4QTsHOJNAmAFkAPkyZq/KijO5ih0wWLDejTH+tfH+Zt1yVlBdPg8pJUYdAGF/0AamTxCb6pWhq9hPRyaaPVq00keQn1c6gerQirkw2kaZ3qsKjNL962dB1OcuybqnEfGUMnKsIf8Yt8xGmC07BGhZdOn+J4SrDteXq3xigOOQJY/UqnXYQ62GAe4KWF00jiq+t8tAIzNqjA6kBEhBYW+s2QauCsx7A1i7IFtHoNCPOsxf1URwiMe1jn67Xd19e0qjlixnrv1LrONBPgAszg4wIHbQ4X9RzEKDRGM2NN/RFVS8B4S/RFLLLAbia8nMNFots+tXF1mb9iCTcE0H133yQi6GF4DoRXtxFD3J6fqcNAv0ouk1yaxleB429VanARR3fZk0M61HpXu54E48wcg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 625357b2-1963-4dcc-ad9d-08d87655025c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2020 06:37:55.4929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A7nk+qMb+vJa0EIOGpJqJKF4P3d/jhPwF4yhl6lSRlvUA9BQMBqVQrWYY0+kw/fodoN+aR23kTyu2EMBPNZ6fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5798
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Since WB feature has been added, WB related sysfs entries can be accessed
> even when an UFS device does not support WB feature. In that case, the
> descriptors which are not supported by the UFS device may be wrongly
> reported when they are accessed from their corrsponding sysfs entries.
> Fix it by adding a sanity check of parameter offset against the actual
> decriptor length.s
This should be a bug fix IMO, and be dealt with similarly like ufshcd_is_wb=
_attrs or ufshcd_is_wb_flag.
Thanks,
Avri
