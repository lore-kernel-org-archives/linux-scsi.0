Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 154A8C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 17:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D930F233ED
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 17:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731786AbhATREl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 12:04:41 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:32029 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391078AbhATREZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2021 12:04:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611162264; x=1642698264;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=w0mPFgAYjGolVE6QJOCENHfwYamBUZGCx5XaljyJRD8=;
  b=He7nU3sSrZpZWECN+t+rse/zFRetBx7NdLzgJc8ItxJumP2rW3hsx5bJ
   1FCEtRdsiMLdy5P0Bb3AHl1RAp1W855nuL0pwTCNl3+RWWjVa8ZYOttvS
   gmjH9IrFTvEgbi6kd51rE4KL+UqlPV1q2tSncJx/OBqXDkLv39OZtljdp
   CK3TTknxS8ZfDfl9BWk6KoPdT+SZ5NPf5akqo3Pafq8MKVmj105iNb7Op
   Nho9sM5Ff9AqszBoeqhx5yEerPIRk/1c4T47CAw0c+cH7ctSEZOaisPMG
   92fTWlhNYFr4iJu7qrJEhHWz2fGucQM5xHUf9mDO2ZPPZmRmeB7bgmF3P
   Q==;
IronPort-SDR: C7/A2vUhwWbv1rlP8pQIbhhuRbCj8e/AO2i7cn6cFK7wTk5/WTvmh1YDMj9Nm6/jC2ccKHam7F
 MTkk+5jE4J6UJDZevLelmDXCgXx5CdN5giAutq7k5Lx93UZ99U3EHpCpFeSnCjRvx+UBQ7t2ME
 q8E6l8OvuuxhWjn3bKTaGQIaKhXSdYwK5WYrB7f5eiul43DPWUKIuta4QXRPz8aZcmXbllaMQB
 xLv1ii8ZSzjuE2CBqDDVbX/tlJQmDUvkXE34qYEgf7xuBSNc/qCLY6ELgn2gcVSg69BK5gWSfR
 rwQ=
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="103586357"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2021 10:03:08 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 20 Jan 2021 10:03:08 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Wed, 20 Jan 2021 10:03:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ajx5w8BhXSIp0iUPx813b+bmHUUW3t+Pi2S7VgxVEjgf5XNUQNGRM8GNlSqs+V888wIOzsxQroLvppO16BRQlBb6oEfYwVD9HaZCNvhGCLCvysoJ6gV1AQsUHtYo/CRgEPtbMPj3zPyW+0m8L7Hy015TB7v6far2CfPhFE0vaP6SccWWqhm76+IwbuLIivWT6tDgO5wOcV+6rD7frQMfGBYVKO4xl1PVPs3McguqhO/pRq+TrnOrpC38AekL7UqWSOeSZ3bcnTxQcUV/0IzvRN5ev3DXvPDtFs/cRCuU9Iabtb60MFp7J3bxdvIyfg/jwCTAlIgAn17LHTXpY6ujsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mVgIDyWAEYpeLPe2UsX/izXSTmHCcLttKpwCqS/VQ6c=;
 b=mzIsBIZhvpLet972TKkgFqtx9fACvDPj0iGa/tfAuvAr6ThgUk6ESgmGz7TWu9UbrSzKgoYWahlePPhnceOb40BHjL6yknh6KhLokWJF+w1x46KlUGyTQp8vOVw53Sum207KRPLjsZuTO9YOJzVT/Y7UqTCkD/93LX340JIHv6ovzlmYqYjGVegMhJiMgMfPNa8JiLrh1vr6ZHh+Q+jMGJRZkGNDqOfXk/aUIjX6Rp8McilZEXxh+v/yZ1TFC/LqQZu9tyRqM8LB28ZhyWrzCX/VWLQhG4oCy/Af8VT0mPWxjgsB9oJqcSCAgXq7pSkbTyCctWNW+sXQzHxqmQL7Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mVgIDyWAEYpeLPe2UsX/izXSTmHCcLttKpwCqS/VQ6c=;
 b=oJEZ82o87R3pU02EoP0emZHwj8B0m1fui5Mcby4VQi+QZD9fyi5lATJneAdDXKnnfI7t+rCsb7zcn/h7mT+FwNpKtG/Lw529AThi71C7OyZWvWn8/EByv/C7adqssCzyUxc+8T8e3SefLgx+5UgVRmUON0ahpaScB9p8jeXB15Y=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA2PR11MB4892.namprd11.prod.outlook.com (2603:10b6:806:f9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Wed, 20 Jan
 2021 17:03:07 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3784.011; Wed, 20 Jan 2021
 17:03:07 +0000
From:   <Don.Brace@microchip.com>
To:     <buczek@molgen.mpg.de>, <mwilck@suse.com>, <john.garry@huawei.com>,
        <pmenzel@molgen.mpg.de>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <hch@infradead.org>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <ming.lei@redhat.com>
CC:     <linux-scsi@vger.kernel.org>, <it+linux-scsi@molgen.mpg.de>,
        <gregkh@linuxfoundation.org>
Subject: RE: [PATCH V3 15/25] smartpqi: fix host qdepth limit
Thread-Topic: [PATCH V3 15/25] smartpqi: fix host qdepth limit
Thread-Index: AQHWzzRlWOT1Tjrni0WYgyG85NUWaqn25dQAgAGyXjCAJGc6AIAMaNYwgAWWawCAAD04gIABvBiAgAAFjVA=
Date:   Wed, 20 Jan 2021 17:03:07 +0000
Message-ID: <SN6PR11MB28485BE04049C8078FED8F00E1A29@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
 <160763254769.26927.9249430312259308888.stgit@brunhilda>
 <ddd8bca4-2ae7-a2dc-cca6-0a2ff85a7d35@molgen.mpg.de>
 <SN6PR11MB28487527276CEBC75D36A732E1C60@SN6PR11MB2848.namprd11.prod.outlook.com>
 <85c6e1705c55fb930ac13bc939279f0d1faa526f.camel@suse.com>
 <SN6PR11MB2848C1195C65F87C910E979BE1A70@SN6PR11MB2848.namprd11.prod.outlook.com>
 <b3e4e597-779b-7c1e-0d3c-07bc3dab1bb5@huawei.com>
 <4555695d649afada5d4358485f0a146aa0848f65.camel@suse.com>
 <f97756ca-84fc-9960-80fb-14e65986c880@molgen.mpg.de>
In-Reply-To: <f97756ca-84fc-9960-80fb-14e65986c880@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: molgen.mpg.de; dkim=none (message not signed)
 header.d=none;molgen.mpg.de; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ce513ce-1eb9-4699-4955-08d8bd654269
x-ms-traffictypediagnostic: SA2PR11MB4892:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB489282949A5E2D2ACC1856ACE1A20@SA2PR11MB4892.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tO+J5z1MK2mZPtQCOlAhSHqsWav3RG48aJcuxyOPTKw+O0I/Oc23dGTxhXqSWVrdkP1OsVpCCJKUh4PPNZLk4S3DF42UlXJk/soiiFUWd9/94CZqIs5aVE+CjdiekSYjxJncnJD86MTb6tKwaYKxmHP9XX92uaiTy79ndS/DC18bMirZnWXvXqJ1Orh9Qg1KtnA7EChlCYG+v+iBnTPApCROItzrrYz/n3ZOuAIsN+hPvJiGRUFYOKVUb7jGrOsrobpQ9LFhxbDlfLxuwF/DKnQZvpHkumgFslnvi7wD75E4RwqtteBxap4t2Z8Tnvveb8rzmoZBaYXsqZYtMexYrhNCK6GXm1ouUXCM9K+4IHW5WQMP4884YxpS5ekEFoY0ztrrlpjt8ra73iPsp6i7LLxYYw9OIapN2dCvlf8IOe3/kid5LtBZzXuvrNVGjo+H
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(376002)(366004)(39860400002)(83380400001)(2906002)(71200400001)(76116006)(66446008)(66556008)(110136005)(33656002)(52536014)(54906003)(478600001)(86362001)(186003)(8676002)(921005)(66946007)(64756008)(7416002)(5660300002)(4326008)(26005)(316002)(55016002)(7696005)(66476007)(8936002)(9686003)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?VqlFZ7PKS5IsNrvHo3CPof7QcTY6GpMXQmPN5VANJs6EXL4jv5duEF5MQc+N?=
 =?us-ascii?Q?EjJN0TDo8+6qTaRIL+L8ttn/W628nulfLOD2QtjnHoOFjmS3a92HBbLY4o/g?=
 =?us-ascii?Q?umbgMQzTC3RuxlYvXc0FruoR78oiu4G2+rpmsWeh35jVaniLlGNEXi/nhTNj?=
 =?us-ascii?Q?ag2uwceiGButSygIZFomKpG/zd4ZfjjiQl7yhySOuT28jcl0j1vJrnhQC44/?=
 =?us-ascii?Q?fExV4wvzKuSHFpEXrpuoXwHb9loguZFEJ09ED2QvALdCUdwsoSwr1yadI1wo?=
 =?us-ascii?Q?WOklpxcXN/kIsB224jSw6BfEww9IQcSKVTEFZa8jIvpfUtUjIPZbCxRH2Bbh?=
 =?us-ascii?Q?m2JsS/ovUPVe0lHpv1yDpDlNe6UrAgDMG7/6eir22xBxDCDLxJbg641NcOa5?=
 =?us-ascii?Q?8M8CXQROm9c6i+EcjSCOQwplfJrl8vLcGZw5ROoogdI7QJ1gKGl1UMXABH1G?=
 =?us-ascii?Q?vQ47mCznW+e0Dz3H4hpAuHJABkIojMD5koKpxzS90oBL2Y1ExbS6d4syhkA2?=
 =?us-ascii?Q?XjJ1rWRNOnt/3wcX2GvbSR//PPQ0TeFNpr5HMxAKXIQnf4rfX4z0GP3rEWol?=
 =?us-ascii?Q?16q3eU6zm0nv3Qat5E5Ctd5tY4ER1uVAHgqQ2cx484aL41AK4P4V1zOHXlC5?=
 =?us-ascii?Q?gDP/H389ZuYjTcmM9VmBWn5Ka5c66ur+uh+yhARs/y9gfKnDsOZcKopCf4sK?=
 =?us-ascii?Q?KSn5vEGsmtKpMU0qxvMMENYFZ2H+BTcUZLLsfOELCVLL3vXWS1bwQvVLajGM?=
 =?us-ascii?Q?GD38ldgJIP0vD0JddklZOXeh08lAno+/yGSwoTvq3zBXo4UazlXl1sZvm56D?=
 =?us-ascii?Q?fQAPFvjLcBEzNTYVN9X8FeN4vYakJ69Mt1sJ6xlejhr1ahzQT+EXcXlx9dLk?=
 =?us-ascii?Q?Dv3h74YUXc/GLxcnsMWOi/9S/QopoNXJBft/anFwdx52j4q1iRIbVWr6leKS?=
 =?us-ascii?Q?96f5MZaszFB1b09ZKRNHF6OAN+XvXsWB6z9XmLmZT4k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ce513ce-1eb9-4699-4955-08d8bd654269
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2021 17:03:07.5188
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q9olojDd2PvRYwvZFgANyRjuAzakeB1IUAdwRBDApiiDZcgS+z/8ed5KXocF3s9c0v9h2vj4eLsHnOD7OsxvsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4892
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Donald Buczek [mailto:buczek@molgen.mpg.de]=20
Subject: Re: [PATCH V3 15/25] smartpqi: fix host qdepth limit

>
> It would be good if someone (Paul?) could verify whether that commit=20
> actually caused the regression they saw.

We can reliably trigger the issue with a certain load pattern on a certain =
hardware.

I've compiled 6eb045e092ef  and got (as with other affected kernels) "contr=
oller is offline: status code 0x6100c" after 15 minutes of the test load.
I've compiled 6eb045e092ef^ and the load is running for 3 1/2 hours now.

So you hit it.

Don: good news, I was starting my own testing.
Thanks for your help

> Looking at that 6eb045e092ef, I notice this hunk:
>
>
> -       busy =3D atomic_inc_return(&shost->host_busy) - 1;
>          if (atomic_read(&shost->host_blocked) > 0) {
> -               if (busy)
> +               if (scsi_host_busy(shost) > 0)
>                          goto starved;
>
> Before 6eb045e092ef, the busy count was incremented with membarrier=20
> before looking at "host_blocked". The new code does this instead:
>
> @ -1403,6 +1400,8 @@ static inline int scsi_host_queue_ready(struct reque=
st_queue *q,
>                  spin_unlock_irq(shost->host_lock);
>          }
>
> +       __set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
> +
>
> but it happens *after* the "host_blocked" check. Could that perhaps=20
> have caused the regression?

I'm not into this and can't comment on that. But if you need me to test any=
 patch for verification, I'll certainly can do that.

Best
   Donald

>
>
> Thanks
> Martin
>
