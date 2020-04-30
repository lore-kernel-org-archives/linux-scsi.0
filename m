Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE35C83006
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 07:44:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4293F2082E
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 07:44:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kjy5psUP";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="h+RiG8sr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgD3Hos (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 03:44:48 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:62850 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgD3Hor (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2020 03:44:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588232687; x=1619768687;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=G062Cwk5QU0GnDIYwWhXQ1/tjyK4hwlKsoaWJILACDA=;
  b=kjy5psUPL2lWtKh4CeidIJuzUIplz/M5EQ0RMJip72bNlkeyTjOq8k0N
   GoAotN8LzdMP4ReiH+ULaJ+ipoJDNUz7a05bWT0jMZQtHKG8Yb5dpObCF
   NXYSUKURfdAnLrY+uJXbAplmRZXnWbfbEBLS8wj/Te5F7T7Fj9AEwQUl5
   eQ0Eb242ypbqL2IvBQiRQCyg0TsdHGD5s8cY9nbado8LzSh+LLRuV1uTe
   5K4OSzJgP/Q8hWnC9R/PRVORzkXbKc5NahfE+uD/uGf5hE6Nixv5vV8UX
   fQHIOjxBav1CIXQc8fzI+mxZj8+Lx1zbCPbNRMPhWZTrwc6mS4Cs+YUhQ
   w==;
IronPort-SDR: qZlwLocpel+zYdEI7DQLv+dj8rFj2fvuU3OwkKdq5I86jQeZK8kn6AHilpUN6w8+Gy5RsIJRLV
 QDhKAJBruzshUs8+bLk77r6V5nbUzdtSLbxmnvVHLhmT+IoKLQIY8lrdP7kkw8OsD7ysbbya0r
 08ru6loI9YKgYDKxrgesJ+kbtlId+WAh9izCx3vFWLlt9aaFAqFdQGRATaydA9/XBjM68e++R0
 2gzRs+U6qQ3XCHaMAcQg3i1s5XHtjbrONb20/qmwIVTBBnGtAlwuJyLsMrN2JApcyzHXs4yso5
 XWo=
X-IronPort-AV: E=Sophos;i="5.73,334,1583164800"; 
   d="scan'208";a="245342953"
Received: from mail-co1nam11lp2173.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.173])
  by ob1.hgst.iphmx.com with ESMTP; 30 Apr 2020 15:44:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X5WT1xSjPuHiRJOc9dp7M3yHE5nD9d7LGK5OgkmWkmhPpWPwOCUVLORG+TTVGrYx7CY0QOYFvX7yB8Aexrto7W+9wrHFJFM3q2ERklK9cATWIW8539lWdJkRpqa1zOLZMUpmmwoFNRK1hZ9aXcEGQMRYtbCZ4Dsrv8GgvNNg0m4ya+jvZkhsDDHxVyJeB3DH2kJcq2ucner89mLkYVy9dJQPmT5DTxVN/TYmVGqMB4rrcodTHiDac2Zct2OlB1z7tiHOkXu0prC2KokboPuqph+XOIdKjntAlQ308OS/lV+scf7zH/PSBegFxsHw7ul1x7WqTzQmX6/Q/b2dFYvnbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G062Cwk5QU0GnDIYwWhXQ1/tjyK4hwlKsoaWJILACDA=;
 b=M2rEpIg1S9o/cJbqwbXVYgjzQnfQ8SJBRW21+aJhccDsrj8mfltKEaTB/vZtoKoF+4rllk1EVela0C8ZYoEXgSD0ZD8GkVxlMvWOcaEWRNW/hxwKVeWuexRWi7t6qGz5WoDGuOkj2g+pwt79efkrWNEUvecXlP8Xm9UN05L77WtZ4t+yubW2VKvMw//uUSG8ngyf/ju6zyz9hsxhz8bZgb/gg8xmA3U3UnSxr6vDg6k7yDJWUd58oeClkfIzR+5ZDg/g0VJ6z+rqyV3/6LrrbYt1VvMr8THo7YcXpd+c3YjXc5QH1s6FJV/7oJxOCRLjJarOJzPupzJgLzRWfoALzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G062Cwk5QU0GnDIYwWhXQ1/tjyK4hwlKsoaWJILACDA=;
 b=h+RiG8srO7JZRnO1K0Kkogt2nw+45MUv6ZD/d0mNKrj8oxPPyytHUG7VQKAAe6skYlBYAHGN9OGfv8EJRgHTBtEHrXG0YWIxfmDbCxxIgn5Scm1pBVTNHkSVRMWRK9lKzLgrsgyFK7LrvfMBSNPRpBC+MVP4D4/9GKLbK0sqvxA=
Received: from BYAPR04MB4629.namprd04.prod.outlook.com (2603:10b6:a03:14::14)
 by BYAPR04MB5400.namprd04.prod.outlook.com (2603:10b6:a03:cb::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Thu, 30 Apr
 2020 07:44:44 +0000
Received: from BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::75ba:5d7d:364c:5ae1]) by BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::75ba:5d7d:364c:5ae1%6]) with mapi id 15.20.2958.019; Thu, 30 Apr 2020
 07:44:44 +0000
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
Subject: RE: [PATCH v2 1/5] scsi: ufs: allow legacy UFS devices to enable
 WriteBooster
Thread-Topic: [PATCH v2 1/5] scsi: ufs: allow legacy UFS devices to enable
 WriteBooster
Thread-Index: AQHWHi34Hoh3MU907kyUtpkKOgDgW6iRSO9Q
Date:   Thu, 30 Apr 2020 07:44:44 +0000
Message-ID: <BYAPR04MB4629B87143D7BD7693141D39FCAA0@BYAPR04MB4629.namprd04.prod.outlook.com>
References: <20200429135610.23750-1-stanley.chu@mediatek.com>
 <20200429135610.23750-2-stanley.chu@mediatek.com>
In-Reply-To: <20200429135610.23750-2-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fb71eb94-5929-40ab-d267-08d7ecda59bc
x-ms-traffictypediagnostic: BYAPR04MB5400:
x-microsoft-antispam-prvs: <BYAPR04MB540039BE08BE8AC42D4829E4FCAA0@BYAPR04MB5400.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0389EDA07F
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4629.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(66556008)(7696005)(478600001)(9686003)(55016002)(186003)(8936002)(316002)(6506007)(110136005)(7416002)(26005)(54906003)(4744005)(86362001)(33656002)(64756008)(66446008)(2906002)(8676002)(66946007)(5660300002)(76116006)(4326008)(66476007)(52536014)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u/xhfbRD/0jajxKw7N1aVpTe7RJ0Lpr+HueiojA0mHja12h/18ks/yFq3HDg1fJ4vo0UKn7IQkqMGSE8dBwvgk5HYiAIKlOqIxV9jxLunS2Y31LVvYnYt7HX3Pd9fbL7fFACtVZ/CROd/Ar7HiF81eQw6RrtPILKUm6/uoxSkAlO8bCfEl4O7QZB9eeRDRsaZiBYj1BznzXQ56uVpPn8dxgT3DJfZTmAqvvI3Mis26XtR30N5l2uxsOAyUs1nsMeAkL3C7jl2G+hW88o1W3mArNHS4eiRbtXwnnYpJsKumdkGfJIECYDdqkQbl6A+fqno3WO5+qjtWuHTOjb2Y+TLtrhD5NkhW0btHbWolOMt5caSXpoaGl2dTtaN8vSw5h2TslLZTjn91Am6hEoTZtrzvlCn4ddmUnA932S3Dn6VSksYW7uBVxva4ZN6z3Q72xr
x-ms-exchange-antispam-messagedata: xRXZbVt2/C+BZhg7RPNxGd9gsphyyQwU/W0b0objQj3sfrniwidZBODF7MwpO9rHCIZEBtHc8iSjhaNi3eL7vVyDQNNZU5ZYEcd9AQgqJ5wgW8Oo9qOruXsvymKh/XcgoG2eIqd7VuEPqOi29h48r8TcUni9GJX5mbkhDyOyQhcw/pmNDBXKlUUEL/BL1yXaZCEwHbO+v0cmu4hRCUE2RsapxeENXU+ArQZu5xvMxWY5ZcYjXIPz9C5OXY1rmVKIif1ylq3+3kRN3pct/Dmf9eoLs7ZbW/mM0D4AIcffJWYD8mHmAkDuW0I2Dr8ESbaP5oecVc3A4UN1fW5ZtlNE5tYpkHVahj9WmXxVPZOVOmF91kOZX0h4eCuuqWadz5m/MQI/23Qaiax4jDcc2H4UT3OewSyxOawKjBGWucro2TFbR+sfdlcQH7cONcT+wFUlStzI3ZVrM/VfqHLyjRpoSQaYGUqn69jVqYGpwijvyELUKsOWkq/g5emP/uerF896I3cUqpXwTWo+ldDA/9aW/CzxlaJNjEvdkMe357wgx3Prg35gvJXro02TkjEET4pErqho/innqT3R89gwLr5jG2ko+KIzepefIEaizYxw5OG3fCLepOXAI1FVfuIPFwWNBSo8ng0dp+qbQEoLTNbRy2e6x9ExYzBPuAPgRmDhbzeKcfpZ2XstsRULdw/8huThAt6BcepLfJ5Po3653DBnS/xS/eD7MXpji5V0Wq+TZSXiLiCKATImjiHTQk1IFqPn4RnwHa+SdSxhGpHV/vnYmy74Kry10La9wSXY6uL5WNI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb71eb94-5929-40ab-d267-08d7ecda59bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2020 07:44:44.7727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8I7C21HjbXvoA5J4J4JMZzc6lxZ2mp1sRwXRFAVcNXOAXKGkZ7FnyUX33n1NWIhcMsJ9VcTxkumOcq+IIyCZBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5400
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley,
=20
>=20
> WriteBooster feature may be supported by some legacy UFS devices
> (i.e., < 3.1) by upgrading firmware.
>=20
> To enable WriteBooster feature in such devices, relax the entrance
> condition of ufshcd_wb_probe() to allow host driver to check those
> devices' WriteBooster capability.
>=20
> WriteBooster feature can be available if below both conditions are
> satisfied,
>=20
> 1. Device descriptor has dExtendedUFSFeaturesSupport field.
> 2. WriteBooster support is specified in above field.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> Reviewed-by: Bean Huo <beanhuo@micron.com>
WB was first introduced as part of UFS3.1, and lately as part of UFS2.2.
Any non-standard behavior should be classified as a quirk.

Thanks,
Avri
