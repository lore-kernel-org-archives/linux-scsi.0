Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1757AC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 17:44:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D504822B3B
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 17:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731128AbhAYRoc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jan 2021 12:44:32 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:60822 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729837AbhAYROa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2021 12:14:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611594870; x=1643130870;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oCCR8ZkUlDupWnQLA8/WWCogsjcNU6q/Y11T1dUwAEc=;
  b=zMSKTv/IvPfOU+t7FfyTOcUmNJHgpEtbWa/yIvX4wCW8ghcwhGlKZD0z
   CICB1SCURDeMwd7zuC8AtLZD1cN+wDVq3+ql6fBNdxK+agbpM4iCiW1SY
   JVOe77ajJ4eL1peiJIQKY/s8v1D2XaA4iUpgiTRX0cau+eBOX2PYXsoUb
   ApFDUxkFKhqoL/MhmoT+1ZZlvhSPDg1/2nY2dyIK1bjjPIBjSajEST7gA
   AMKnBEH4Kn0WvaNupSDTLvYJi39QPeWtn406tJcgNFGmG/7vYFowborIh
   ZYCvZf/tSxvW9PqExXhwrlR5qcpM/Z6NLxRp2QAymre5OPYoQfO0078eH
   Q==;
IronPort-SDR: +GVUewtaAA5bUQzwfz2vBY+SET5p84hICk3LMI3kjvRT+b9EMFFzuR+xkl+EvowE6PpZkzAwd/
 319qfTiQ48Mp7SXvrHva+JNdxzSCKR7VUHL+X2k2iq6zl82iHsDvkXCSdN1xqtkDUyX38muSkr
 bTQkOFFtbCFyupMMSKTNiNsMqRXtX9KJF7TBXa2+lWe4QTeGdD/DvYlUylg6lhufGAXvS3b38X
 9u1Pb0MuXcv6U9Nwkc+RoNtTuxycvlRic92Cqq8Mw84ZiZzInYKfndwEy/Nq3YudBN/zscbQaD
 kg8=
X-IronPort-AV: E=Sophos;i="5.79,374,1602572400"; 
   d="scan'208";a="106696675"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Jan 2021 10:13:15 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 25 Jan 2021 10:13:14 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Mon, 25 Jan 2021 10:13:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UtPB6Jv9eDPTkK4LfpkV9NS0QycUMuscR1kHJtmvkkPGTj6XiMP2neslIPaZcS3jeAT+rn/U9vamkrsjzAozINyS1AOmq8kTtWSF1LcV00dGO2/Ya6Knd+Xffzml2QPXW8Vim0Rpr1nEocteuufcV9/G5VmDI6KVBKp8xYiQxH13kB/66xzpt8pqGCXx19QaGUsm/0bVbgJ5ITKkEeOQeDbq/BVHVm1bhOJclk7q20acDBflLU5nkStW6agnMNc5FLqGJdNZi2j2nEgfW9HW8BknxKYttai8QIjrYAthbZPXZqoVeZnNXaGdR0IANjamJI0dufN0ZDkSzC6N8E5nQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VqczCkk0tNmZGhngKibuZ6tZ5HpKa7vNAdMqwFnPd80=;
 b=WrD0opmq/F7DveryZbqYEeV/PsfbcxfdhIdLbh2BoZi1a4DeILFObw2xDY481yGYu9f/+ZxrYIUY4caoTsmC6/raASQX93tGyOcLxo/en14jkMcW83LtfyR/33L0J4yWthPzZO+fbtOQG95tD1CQjt9eTmh+1KDewMP4/Zm/fzhRcPUH1PZbJvfRq7YvjH5njZ6iqxnTMIq8yjaB03zcObI8HZrWR2O/BEI2Ny1qjVrc1k7lqd54mCqUaaBZTuh6PUpDtpy5cOP893/bNQrb8ApUUrbH/fhhSq0fCZ+28pflo8JAjVzglVHDxD67Ox6nT+XrSdysUrYlzYMxpYxcrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VqczCkk0tNmZGhngKibuZ6tZ5HpKa7vNAdMqwFnPd80=;
 b=fwT5AIOSYtXmw5H8NN71ncOCZYrp6OViN0lhqZI7kOebgU7lumdyZNKVQGe26xN+7bE2K6bTZYcVgcPTtQ5Kz1zoQE4BPeFwPdvP5XxSaaLYh83uUnZ8ikRxe/X4+d4Sna2/ghIOtZxAgLgWarqmY1UffTvIPFmCTGptwXAQm5U=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA2PR11MB4892.namprd11.prod.outlook.com (2603:10b6:806:f9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Mon, 25 Jan
 2021 17:13:13 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 17:13:12 +0000
From:   <Don.Brace@microchip.com>
To:     <mwilck@suse.com>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH V3 22/25] smartpqi: update enclosure identifier in sysf
Thread-Topic: [PATCH V3 22/25] smartpqi: update enclosure identifier in sysf
Thread-Index: AQHWzzRpXOA4VQwuVU6fYV8or1KEiKodDG2AgBvPWBA=
Date:   Mon, 25 Jan 2021 17:13:12 +0000
Message-ID: <SN6PR11MB28485D3332238AD3F0261135E1BD9@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763258826.26927.5141004289781904133.stgit@brunhilda>
 <ff8339afa9f17cf65648f2a9a6ba8b8460f4020e.camel@suse.com>
In-Reply-To: <ff8339afa9f17cf65648f2a9a6ba8b8460f4020e.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a765960d-66a7-484b-dbb9-08d8c1547f48
x-ms-traffictypediagnostic: SA2PR11MB4892:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB489262632EA05E1E61C9725DE1BD9@SA2PR11MB4892.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gM6PHPYjlGqYA0bm2Y+1D/SBBqprlYlOXhOfjGoA2AnrXy08ji6sN+A/X4DV8DFLJcRGJZpvpRtxeKMO5rBEUky/ZzSLYMzlPWO/gricdaBskQ81HgXo4NYjn8QzuBxss1E8Awo3GAB9BFFZElQOXmCBGTPfB3V7F134xeN2x8vGe9N83Cbl+6WvdRQ/ki5ThxMXoaU9rkiEctnmqIukPmZ2xMnvpgXcvdBQQeOFLMKmr0HYJGWVgiPwp4bAmxcFaufb79gwBdrD/5xmo9lcJozkCjAWLBFXu9W4Dvt33rbIrXrSLHUJVeHMdMdKJULQcMaQwNAkPoWBSlSPiw1Eu3apAVhlM0nBa1ec2eJpAYk1jWtig6z8Fj3/DWOyq+P/s5zHurGq1vsx9v/w67fIA3quLbCLPzqzNOzcpWDLuA3slrwjUrPk4ZWv3h0Um7qC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(396003)(136003)(366004)(66446008)(66556008)(66946007)(478600001)(83380400001)(2906002)(8676002)(76116006)(8936002)(186003)(33656002)(64756008)(66476007)(55016002)(52536014)(921005)(26005)(9686003)(4326008)(110136005)(86362001)(71200400001)(316002)(7696005)(15650500001)(6506007)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?NYC6/DVGLKXq373zS7fhmT0TfwNyeIuHDYJaNof3UaGIJUTkJjHI4m3IzTYt?=
 =?us-ascii?Q?WXT7pFXt/LlwXj4GmD/Da8ZrWe6PyernZ19tbvlyur6JLz8u2EsGcjBiK/Kt?=
 =?us-ascii?Q?frN3hYj0brNqr4cU6+NvyRsQ7/2GVcT6TeXTLjgoL1+ahhsvw0Md5hRyhozv?=
 =?us-ascii?Q?dsBfd+OWCNRMtBF7jcjKvayJpKKpzrgya/REuvzuAf49CHhwPegasI4b8QWq?=
 =?us-ascii?Q?EYu0KjplGfzsaY17fYH+6dT1WhjT0bXmlocUi5dPeYyagstjnJRbhFtrxgGX?=
 =?us-ascii?Q?ImqsxYcp/SVSr3HU7/7fP5k6PfzfbcE7txSo7fQnTGoPWMRbY+NJkly0vaC3?=
 =?us-ascii?Q?7BUjU7VzPAwh9FuA7irWxa5rhkDLB4W+9S8we1SgQPk1tGpDCNxtNm+P2yVG?=
 =?us-ascii?Q?8ChhdQtszj8OZIvckp3SitjrXSsZIX/UaaSWZvmcnm1z28Yopyc5sdokOB/4?=
 =?us-ascii?Q?+NvWvcb9BhCWzNFNBukBaA+ND9oo3pbYjCiZGXknsrYIO1vWA6GVU4V7w7+D?=
 =?us-ascii?Q?tiZ+ooKzfAEJBx+Pyp8NrYPGox2S1LfBEJmSNibObPIY0hoMDH/HVTKoMZXV?=
 =?us-ascii?Q?Gz8JRcwpfM8DBoVb884OIIrv5ASi6RAe0XMWVP0+2t7AstobcaxmssgixMNP?=
 =?us-ascii?Q?I2ucIClk6NkBKjKpUeOFtZpGP8y3PMQQKvXJwALVaMvvq0Jx1XSvWOby/eYw?=
 =?us-ascii?Q?EG6Vpc50BE6mGEqhXpXXnUXRrVFdy4RKz+8rWF02MsVw7Tlbbn9+vusp5L6v?=
 =?us-ascii?Q?Hd+vb8pdw4uNcgvS4CWn/lnd9RPZGcMa3OFylJzJSwVffisEZuPnzVbR9QCb?=
 =?us-ascii?Q?M+87vkQxMaK85tHQXF+pkqmE1SvvPuflm897j0JrXnZc3jgkU5awulgtFILG?=
 =?us-ascii?Q?Cvlv+1OZvEJ4O/ezUQUrYFt1pXCLWZ7Bqh3j5bs7DumHNyBLOJ6/S9TUF7wj?=
 =?us-ascii?Q?DcIiMnl13LB6NZJ9FNdWoLS15aQZ4RktNuZFSXveKH0sHxuUwePNT0KvhuoA?=
 =?us-ascii?Q?lC0lZHG3GvV0tdda+TXMizo201f2tv1n574KKClDqQ0sQy+VyWMGl7IfYREJ?=
 =?us-ascii?Q?2KAGDfkE?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a765960d-66a7-484b-dbb9-08d8c1547f48
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 17:13:12.8470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vfzj3kC4DYDn2i3p5HtDDZVII4FJzN4P8VfkneEGcn/pIEz1Feo9P7Vo4tQ9LQoINKRpKRYAhmPEtkmCc0kYAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4892
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


From: Martin Wilck [mailto:mwilck@suse.com]=20
Subject: Re: [PATCH V3 22/25] smartpqi: update enclosure identifier in sysf

> @@ -1841,7 +1841,6 @@ static void pqi_dev_info(struct pqi_ctrl_info=20
> *ctrl_info,  static void pqi_scsi_update_device(struct pqi_scsi_dev=20
> *existing_device,
>         struct pqi_scsi_dev *new_device)  {
> -       existing_device->devtype =3D new_device->devtype;
>         existing_device->device_type =3D new_device->device_type;
>         existing_device->bus =3D new_device->bus;
>         if (new_device->target_lun_valid) {
>

I don't get this. Why was it wrong to update the devtype field?

Don: From patch Author...
If we don't remove that statement, following issue will crop up.

During initial device enumeration, the devtype attribute of the device(in c=
urrent case enclosure device) is filled in slave_configure.
But whenever a rescan occurs, the f/w would return zero for this field,  an=
d valid devtype is overwritten by zero, when device attributes are updated =
in pqi_scsi_update_device. Due to this lsscsi output shows wrong values.


