Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D39C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 22:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A14264D9C
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 22:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhBAWtR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Feb 2021 17:49:17 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:6375 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbhBAWtQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2021 17:49:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612219755; x=1643755755;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pb2f0V4OHDp9hoPAijRwCSPj4bDufTgQ5VtLiUaSAiY=;
  b=t/Cy9LiMAm7CAEjKNkE7JB5kBkNRMILtguzoJOZlg4My9bVr7CPFe1H+
   tw44siwCB+9OVjshsFapfNyA46u2PtoIHskXk67EnYZrdrfZ2/zMx+jZu
   Y32Kb2Rw0WXQVjaz5XTOXSE1vCjUcphMKS+/Ob5yIXUk7jleOx2XFY09v
   zsC4Lt3oxsWEffSX1rjT8F53WNn7WuYFgkXiy3848RGeQE0CIWcfbRyOT
   dBnRV0ecV9w7TYaRIcrNYPzCAbuUMiCulPHvTDPoGIW9BDCjjRLbowZs4
   IaLpE3xBXs/t1osRwwrvYtT7S2jHFyDSpZTjt3ZbhyZTHynnXgyGGffJ+
   Q==;
IronPort-SDR: veP9PcBQ1VRZrgxlc36MximSX1l6HND0nks8kQ6Hm1GEk6zM1ajYLd0sGgqh2nZE/6eE9RjHof
 1lSUduyM9X8UNbB1FnXcVEYTG5tWsXsSKDN2e3+MDXUDHGV13mYF/0NRvvE4p2eGaXC0Vrkp/s
 n2kjlKh109bTaRyPCv2VoPhY1Udioztr+GXKVTT/MVET583stjkYC8tWdOnsXofymUQAHgTfb+
 C88FUu6uQfoxu5piwunouhaixoyux4NsJ1iMOhVN5TikxYuZUgFttK+3WLlGysKjuDTlksDtVK
 W7M=
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="107585908"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2021 15:48:00 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 1 Feb 2021 15:47:59 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Mon, 1 Feb 2021 15:47:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MbMwzGnl9qvxQUglGLCMRG8CCeT8hOZCn0JeYh+K/2BqvwTnPO64AV9I0VpBvpIAUErwUUzn1Ieha9qtc2ua9tGsS3/ePZ7jQywOwZpcGSr5bVsGqajkOuBybNizog7+bpvEpDpXddRDdSd38zvM3NdNid8s0fLQXpw1iqBptJTn+mAwykqlpYdULy/efnp/C3SMaCk2w3yE4K3UkUJnTltVyhyE1FnGhvMFYXDJClcvqsFXswbB+meA28D/F9+Xmj4Yh4MUEwJhnWi347BtKKY5WSOSdazZYzwYskVu3KGy/i2bNY+aWMuNYd1jBxFDGb/oz+YQ8BLbNNf8bQUphQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pb2f0V4OHDp9hoPAijRwCSPj4bDufTgQ5VtLiUaSAiY=;
 b=kkPdTMqtU4dFUfBMcXzlG5wgVgFYcp0pAlkoavBckrmvQRwPe4j7ueeSmZIILtryOQC0XoNNohom8wCQR4gfss6iyB//DrPc0zAOiE81jmaHDcmhapULctbqkZa1QpaM9aoC8l0t9XGGCW7gRzGyczJm+QQUGJ1AKaUE8SWcWzcKVkSH6ziB+mOMADS08GolSLM00f/FjpV4PwANkvBMX+5zidvB31y8Ah6yadC9sPDacS/cXCJwc986uACSJLstbJ2QVqHXfehqFwC9ez+5yzticEEqb71Y3+gN2L+vhP7Gn/5401qMbvcSClIeVObPji4dvwU5RCRX8taxjBOM4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pb2f0V4OHDp9hoPAijRwCSPj4bDufTgQ5VtLiUaSAiY=;
 b=Jp/MBquD1tB7Q/xEXprz0pB3quC7bu1EYhLbSvSn63UpiEvyyV4eNI0f5ny0hDLBQ9T4gIjKbkKq+2uPv9bUU9f0Sg8jFup4JYQweB+xqLdROHN0yhauKir1NBFE9dYvqdqTy2hfzpghtaEwh33iT4KhTjd6bhvaod94KpPphvw=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB3005.namprd11.prod.outlook.com (2603:10b6:805:d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.23; Mon, 1 Feb
 2021 22:47:57 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3805.027; Mon, 1 Feb 2021
 22:47:57 +0000
From:   <Don.Brace@microchip.com>
To:     <mwilck@suse.com>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>, <john.garry@huawei.com>
Subject: RE: [PATCH V3 14/25] smartpqi: fix driver synchronization issues
Thread-Topic: [PATCH V3 14/25] smartpqi: fix driver synchronization issues
Thread-Index: AQHWzzSSsdBsRT4A0ESvA1E3btB71qoc/EEAgB8oiRCAAtR/AIAFQD/w
Date:   Mon, 1 Feb 2021 22:47:57 +0000
Message-ID: <SN6PR11MB284854146A2A85F5E70CFDA9E1B69@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763254176.26927.18089060465751833560.stgit@brunhilda>
         <76f8c5cbdd1722eecdda017c46c0d617f5086e1d.camel@suse.com>
         <SN6PR11MB2848C1C9B0F446E2D8F30F00E1BB9@SN6PR11MB2848.namprd11.prod.outlook.com>
 <c1e6b199f5ccda5ccec5223dfcbd1fba22171c86.camel@suse.com>
In-Reply-To: <c1e6b199f5ccda5ccec5223dfcbd1fba22171c86.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3893de4e-db59-45fd-75db-08d8c7036b9e
x-ms-traffictypediagnostic: SN6PR11MB3005:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB300531203CD4CB3CC19F32F1E1B69@SN6PR11MB3005.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ju/xLVXqaHVZQZhrw1cIBtrYYCbGVMT/MgtjGdnNWKXOjx/Ipgt+P8VS4t1bPK3d9etKMhLhcFK2kmkRMxa41SGBahngryYW+qE4ubjcV39wK++GxQaDDuKgnKp6kKl9j/UwA0RnlpL0tq2DXVOhHD3Bg9D+hFOerxSdchNUT7mm4DO5oRybR4zm5hkdTYoGwgDUHZ+DqZW/cI4/G5BjgAChVxiVepDuojplaNYdanRYYysf180594tV2zj4xk4n74j+7cF1Y/3RtqEFFj0TFwREcMOQgXdQ/TaiynZtO0+6iKN/OTC0NJ4E6eu0zDizrowo0v2gZOWbbIsCGiFgoZSfbDR0t54Cv34LkQ/s+HRWZLcsoq32JOiqm+bIIfYc8tS8d1rd4qAvx4Fpr4aiQRlwHHkTn6ya8M2YNdIwl8xc8exPOFkUR2fb0FVvHMZQJpNSdacRS8LoXe1cL9/muhvzIb/xGacp4XRAVQLQ8nm++sZS3X6AQZ16Pnf1Dqwx714++FSRJjIxnzUsTXuVLti97tqxvUZfS6wk2KqQpqemkPNZJ6vAOz9w/WLp0Ssb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(346002)(396003)(39860400002)(52536014)(66946007)(64756008)(66476007)(66556008)(186003)(4744005)(86362001)(26005)(76116006)(66446008)(83380400001)(6506007)(7696005)(921005)(8936002)(8676002)(110136005)(33656002)(2906002)(5660300002)(9686003)(54906003)(55016002)(478600001)(71200400001)(4326008)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?dCTCa8gRlA2Om2TUXcsmdYrgk9ezUfZFBRPnJqBe3bU5e9w8nU3sm7S9D8Vk?=
 =?us-ascii?Q?5Yz04KgWd4Z/6PmhFrk2dqEtmy9foe5km5Nt5m2Y880eWLKOGXHlzTl4eavc?=
 =?us-ascii?Q?r9olkTHfuodZCfmrY3Eo9/LPIj2/BiKhct2HHG3dulaf1VSM6ju6yxIr+9qk?=
 =?us-ascii?Q?wv9t+WFlR+X7Czipisv6EJsKHnzQC0p6+CKH2598h6kC267hjExvCTjyhhDu?=
 =?us-ascii?Q?o2/IydlbtyTqKHAjA9nKh4L8YQ60UGQXT2U9joCzFiebLN2jfe1a0+YNK32K?=
 =?us-ascii?Q?4GJwY4HSO+wJAMBBZ3Ld+HlSrWWOwZk9Lqm5y20Qz7x+IBVgvWDDx+vr7HBh?=
 =?us-ascii?Q?apEkOBv/RH/k1eZM8xEhwlKk9gn36gg9VADLnI4VVq+r6MbAgPCK5jaRi6NQ?=
 =?us-ascii?Q?henjEgjWexryCoQiNZBv1Gln2hApN8Mrj7+No0xri3iYRrMU+zKolndTj0jN?=
 =?us-ascii?Q?Q0y7X6DC/HuJqPiFfkG9H4XqZzYmeabEXo1pH7/aKN9SMQghmBQXa7N5WsFL?=
 =?us-ascii?Q?PSrtBMcdW7Qi9YvyvwZhFJLR2djRA+oqELwe4N+uBBnCntIoJpfkcNO+CWe1?=
 =?us-ascii?Q?Qm+Glu6VoJhED9GLkizJE6k+n0fsptVJvQf5WFlXmW6JUCWm7mVGA549Ex8f?=
 =?us-ascii?Q?32EmBDcfNCKsGvyy6lyHPisABhVTKz8loht7Ks1rfc0f4qe+xHtQNi3wW5Hd?=
 =?us-ascii?Q?H2uzY4U92ThYD50QuAV+Y3FAe9uIqphJYD6s57OvUGt723soNHRQq9u6/cZV?=
 =?us-ascii?Q?EmbpxzsetPZ7ClB36HHYFc8WZ8vSY+3XpZ1u/hlfVV1jVSSxTz5nMUfyV5Jl?=
 =?us-ascii?Q?keaJ3vfsWJa8X83/PoGkKZq3jiWu/rrBLfRkeHND9VLSqsEIoIqvDigo1q7J?=
 =?us-ascii?Q?5Y7KO7ljiY+kQAg6KB6IByIhvsgzwuTOulK0nQ8JLnc11Zralj/Rnb9xqISO?=
 =?us-ascii?Q?BwPe3YmfF7ChNj8WpujyiXiwJ0JLlDhKvfHPo0zIQCq+PRpsMiPQCzH0NOvB?=
 =?us-ascii?Q?mwQzTVsKKRQL/19mx5lKP98T+8AC4CZKym9g0QSMS+hVlR4VzX7cxdFXOABw?=
 =?us-ascii?Q?1W+dR/5u?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3893de4e-db59-45fd-75db-08d8c7036b9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2021 22:47:57.5422
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bnMmn+ZaD3q/zzd6zxZjXIvX0SIVrAsv9963CJY7pjW5LV2bnRMN8nAP1mVDCdfCkMbDwRMe5f+J7Zva3x6n9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3005
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Martin Wilck [mailto:mwilck@suse.com]=20
Subject: Re: [PATCH V3 14/25] smartpqi: fix driver synchronization issues


I would still like to figure out if "smartpqi_fix_host_qdepth_limit" is rea=
lly necessary. It duplicates functionality that's already in the block and =
SCSI layers. I tend to think that John Garry is right, and that all that is=
 needed to fix the queue overflow would be setting host_tagset to 1. Someon=
e would need to verify that, though. If yes, it'd be preferrable to "smartp=
qi_fix_host_qdepth_limit", and we'd need to figure out a different fix for =
the above.

Don: I have been testing with setting host_tagset =3D 1. Seems to be workin=
g.
I answered John Gary's e-mail. Thanks for your suggestion. However I want t=
o test this some more before calling it good.
Thanks,
Don Brace=20


Regards
Martin



