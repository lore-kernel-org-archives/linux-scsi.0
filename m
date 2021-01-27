Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 355BDC433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 17:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F10A664DA3
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 17:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344209AbhA0RsR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 12:48:17 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:35965 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344194AbhA0Rr6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 12:47:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611769677; x=1643305677;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8TiX57+/cOFh9+D9QVidGI2EKDy49nfKaRv8Vk4+KH8=;
  b=H65f7b6a/ypZd/YmbrnujiOOYUTFcy3lGYG0wj2AMB/C8S935T+cFKx0
   +TfGHzqcy3/L1jxNC+RcFICCZA3u5H7ZM3nn6JNFcz+sUk39uYMl/gB5f
   5J0p3mY7fjK3LVavyJF6bgnjY9ulkzWSlQu1RVcz0luwwQv5dwrp0XgLS
   I274p2X1h1vUKSjI3DUExEZ1ctZO8+UqRbYMGYq3BYdz7EmPdzR7DOAmj
   Z1MqqoFpuljKMUBV292FzqiEc4P+jf6lOnhZ8O/GM3NYjUiB/N+8aX6hP
   OZcY58LbKYlq3L0C1kgi6bcA+Z5QClWKgEqjnEJn3eHMdjkZbrWx7r+e0
   A==;
IronPort-SDR: X3IHKXzQ0bwH2r4iNkwCMc9zbZcBf/QX1OxWH4rewHHZG+roilns/3RgksHvdnnXJKRTu7sjCS
 ofTnEp1vgiydiNDLEdEFHup9zmGJqTmPjq/YodFegBrY1Y9MZb7ADOg5zKLnj7qjHhA2ptmSyn
 mo8JnAz+mRTfYgM/INm77U7EvYj+LyjsTRAtjC+WUaXiP3lXOWdrx4bQxdFp1UxxmQaAoeiDIT
 jpIPtiiZ1oCVd4NMwJrWxsM+8T8xbZpbLJ+GQyaogmgrWrRk+MJKpXs8ZOhHtpTvZWNTU2MT9T
 zl8=
X-IronPort-AV: E=Sophos;i="5.79,380,1602572400"; 
   d="scan'208";a="101647281"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2021 10:46:41 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 10:46:41 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Wed, 27 Jan 2021 10:46:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1CY0bt33OYeuTl3iEBnQ/MNN3ocb7qxwb/NNnEYMKwO7vidyIQ9Hxbo5vb1j4rnjVL9qs/0eiG+qi3jzaiyJmJqi3j4Giu/SYmK2SjFoKROd5Mvn4VoNajYCQgqdOdodfcEIZndlVqtFI9aw3pW95a+mDy7v7KZ9ZAU/8AYvdDoP1zfKneX2dzKUJSikX7ni3Sy5iJXZkx0mqZX5rUQtW1O0/DwTnuAARooN+0iFf7+S3C9r48oT1dYt/sbEYJEnSJbwB+1248XfKFzD90xDogvwClOaiy6UEUalXy9gvpc2DAVKBE+refCgC9Vih6jA7En4A3hLPSw60Q5UuPblQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8TiX57+/cOFh9+D9QVidGI2EKDy49nfKaRv8Vk4+KH8=;
 b=SVewi54mraIBIHHZYVGk1MRQATIBCN8cujQz5mgoc4etq0oGnp/1Lo0Mgyz6iigKPjgzQwcdrPy+On651aHEwtZUQ03AagESKwsQaZdwco1zFSax4bNt/SjeuEilun2QVYCmdDEFoQs65hn1sVik1dO7O1570zenil6+BpPIyHUUNdYLrEyzUZVBuIdFTFEU6Y6BC2PqrAflFcDVcQXrNIjtCiIYrLBVDXvysCVlFKkdLKoINIkb5Ycxoed38S9kTSQAuGcxYFfkJQ1v2uz4ozq49rfnzE2J04n0fXXvAix8gpWbFaYOYo4zgzi6IOMpxcUY7Uv+KzcVB25BkPH0eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8TiX57+/cOFh9+D9QVidGI2EKDy49nfKaRv8Vk4+KH8=;
 b=Q+9eAQ1+4CZblXV35FGg5LxlFR9s9M2btfc2+4N4MsxcVAiAtg8gs35HL2mqYhtHuN8g+5MQh71OMf7KpqTzYadPjahE/c8aPyvbCw6ZV1AfXSlZ0CYz/ScSsQvAvKxMbQdbSSAXcyG+s/a0kjojzQaBMtzGZXCUiS0uI9bRIq8=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB3374.namprd11.prod.outlook.com (2603:10b6:805:c5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Wed, 27 Jan
 2021 17:46:38 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3805.017; Wed, 27 Jan 2021
 17:46:38 +0000
From:   <Don.Brace@microchip.com>
To:     <mwilck@suse.com>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH V3 17/25] smartpqi: change timing of release of QRM memory
 during OFA
Thread-Topic: [PATCH V3 17/25] smartpqi: change timing of release of QRM
 memory during OFA
Thread-Index: AQHWzzSXYEQvmRGc9EK2ES1A2z5d4aodCAIAgB8BtWA=
Date:   Wed, 27 Jan 2021 17:46:37 +0000
Message-ID: <SN6PR11MB284842A8A976C403FDBCCCDCE1BB9@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763255925.26927.7798016026983421676.stgit@brunhilda>
 <bfede3537d824380d9d61172d58643116b7f56dd.camel@suse.com>
In-Reply-To: <bfede3537d824380d9d61172d58643116b7f56dd.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eaeed1a5-b1bf-4a03-0682-08d8c2eb7f50
x-ms-traffictypediagnostic: SN6PR11MB3374:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3374D51536555C70261F5458E1BB9@SN6PR11MB3374.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U09UFI9HMytpqwPO9K6GGL9obJd7AAXhMrm/kJ9LwEV/Ei05o4f3u24abp+QDB7wBHBE+N/jX3VtQ5K6b0wi4l7Hv15psrZjimEPuBQi9Po4lEEdGPAFSTZv5Mb4dAZrGS5Lcmh/Uo2YIWWROIKE3+k+o7OOsxWX6gJ4p/xbR66VSunkGo34V0bTFAdKLTGZNLDqCWsgvVJif9f9D2j2pb3jZzFLNCa/+U8FY1D0uo17/21LxKCo+1ni1zI55T0oKWe4oSdcmiR6F/fjSU+NE7X50USL4Wmq+aJuse8XZNfjKXa2gqAx/UC76m2pL/Fi17vPlAtjjP0PSnoLHAlZFbMMHB6dyrMac+xu/7MwYFe9dh0pBWzSyB0GzHGl1TTCBmh9JC2v3FjxggcErcZCpiQVU9UrmIiueuRMJ95LoTDl1/7M1iGwCoAcKbLQa7aQNrYABiqxaTnTxo2g6pCRSAV8l+/9eACANmlrE21VUy2Sgx6tw/irb4bHf1ntFG3nFuDvoN4pLFY1QN9z5DhmrK1t4Ps4JktdcOo7ToMub3yEaRNhI2jxckzW92dIdhxv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(136003)(366004)(346002)(39860400002)(921005)(86362001)(478600001)(4744005)(110136005)(55016002)(4326008)(5660300002)(66476007)(71200400001)(9686003)(33656002)(7696005)(2906002)(316002)(8936002)(52536014)(66446008)(83380400001)(66556008)(64756008)(8676002)(76116006)(186003)(26005)(66946007)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?y+zwmqGiHEE2KmC+5RN1VI03XbNAPjkgfiUbVKFp6+KmqPJmB9d5dHKnjD1f?=
 =?us-ascii?Q?O7J0m42LKLqeDwVackU/y6W7iNbO+9hGkhSC4gJgvlYIhD56Y7RjbYYcFbs3?=
 =?us-ascii?Q?purN4EbXQ8SY4sPtEtUzNK4iY71eTo5goIYCLj7sFWPgpN6fzPZco9v4WjVp?=
 =?us-ascii?Q?dKTKWgxp6Jnz6YDyvaC2WvnT/w1StXoeSNq+wcRLfDxleQrEjfj7l9+QYaso?=
 =?us-ascii?Q?KaAjJRHNLxlEj95Nw81KaEvTsOz3g87Hp7D8jfEBgOwpEw8MvPu3NtYmWzs/?=
 =?us-ascii?Q?Tlkwlhhfg6hf3jDbPMC+SVhdnkChx8vA1Hq6D3SMqhfeTu+6mUj9rABNMzpA?=
 =?us-ascii?Q?h3ukzVYnugj9rWOL7kNJtdZA2d2NC0br2Cm7lOzVM4SM5vRZMGKS+PvRYJ3t?=
 =?us-ascii?Q?onolSVh4DajMvwEeqYlH88nD14xJ0oyiDl48pl4pGk8J4B+x6sWzLcpp53Gs?=
 =?us-ascii?Q?8fa+0H3EaKTqvo+27htxmZ6CnkPbPBAE1ZEFQUgym1zP1FItAZh9G2nR5HdY?=
 =?us-ascii?Q?CB0wnFQIiBgw4OBHCe76fJjnyqX/QbC9i9G3BsOhWNs4SXacAiJayzC1AGfB?=
 =?us-ascii?Q?YH6x+oznBUx6psmzQllnwIo3O/eOrEkRWT1HD9ZVJtyuLcLtNkeq+lg9YR4S?=
 =?us-ascii?Q?Q2cn5gt7t+DfpxiQ8mxWeVGPjRlYizyyXWxxo1gfuAV9vmh59zy/lYK5E5b0?=
 =?us-ascii?Q?pvERHszAiaqWzp5MtZ5ohMdK+3oOt7+Om2Dd2bsbM5lgkgjzvD9+X//qOCpD?=
 =?us-ascii?Q?QRYF2gtKJKIpoKhqXOmkYn7nmE0RNsqVTLxv22YXvKCLC+VwJllpzTi9poUk?=
 =?us-ascii?Q?v9F4Nqd2H4BSQ7jvFiZnSRcmRsR62oysbtNM1SOd39azJkNXJBNkurjB089O?=
 =?us-ascii?Q?yJXYQQYoMWX+Np5r/TXKJUdDyjA3mGzWTAuOSPWz+DhirBWiZMzZPlYGAG0x?=
 =?us-ascii?Q?3PaIoAjRUlPR4Et9yYyW3tSB+Tu9MBYjXucS2OBXow3aBMeKWlfrMToQl8K+?=
 =?us-ascii?Q?HmKR/3aP8vkRg458EOtNw9fTfrv1La7THBP/5/Pkh7FKnBgCYGaoFcWoY8pX?=
 =?us-ascii?Q?ryCGVMvN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaeed1a5-b1bf-4a03-0682-08d8c2eb7f50
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 17:46:38.0839
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RESzBVcAKAZFOh+fUxiisRGca2r2y3XwjYB0tVJIwyK99MHjTNXAlxMBaL6hGQxsQVgDTA9ff/mhNb7eR727ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3374
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Martin Wilck [mailto:mwilck@suse.com]=20
Subject: Re: [PATCH V3 17/25] smartpqi: change timing of release of QRM mem=
ory during OFA


I don't understand how the patch description relates to the actual change. =
With the patch, the buffers are released just like before, only some instru=
ctions later. So apparently, without this patch, the OFA memory had been re=
leased prematurely?
Don: Yes. So when I broke up patch smartpqi-fix-driver-synchronization-issu=
es, I ended up squashing this patch into a new patch called smartpqi-update=
-ofa-management. Thanks for your review.

Anyway,

Reviewed-by: Martin Wilck <mwilck@suse.com>



