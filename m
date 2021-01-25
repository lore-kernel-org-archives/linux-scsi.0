Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13152C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 20:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA79B21D94
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 20:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732233AbhAYUiC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jan 2021 15:38:02 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:63898 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731970AbhAYUhz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2021 15:37:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611607074; x=1643143074;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7PEdg31n5AM2TU3zEdc9oyj2dbVzQaByPus85hSM8UY=;
  b=M95sISSn6lgPPVP/XrDgV8rrOcGa6fT/T0a5/MitvMSqbzz9+1d6GbK8
   8QKHZlVkbhK0R40/JkYJ96oDs+qrUqKOklUlzTat0N0KCFp0Wqtj+9sTP
   M76t5sZUK7qVqz6WWf9d559nJG++dt/DilU0wES1tCSxJAr0VBSVgn5yG
   uVWCcuq6BXuUfFpOp6q+/VVsb13Mcqk/hP3OQ9FxmWKpeLFoKUmXC8FIW
   /YNi+nCxoLG/KAOGWkR2tQbjy31NxgjAUFAD6yun9RmSF/kn2xltwPvzf
   zEfdzhQ0znbtEgxdb7GgqYdkNaLCBavPK6fjJsX8MEVX99xTlTHrSsdxy
   g==;
IronPort-SDR: 9ZUAlq7j7u3v7kJCt1O7dFL3u7ZW90oCupQKjb7mPVuu3ZKk0laj3Yyr1WrGgVvjlidNxWo/zr
 4BmGh6pXGq8+LlMR6zXqo/J2IUmjMEu50lmmrYNpbdTZoXZPwGqFx52MFPH48jY7YkFaWmMpSn
 YeUddhMF4I4WrIgqhXPcuctk02gXSMCh2wZHLekjlzETUACHHUcMHYagc//SKnz657Ovt3MDn1
 6nBaun/tShYTrXcpMdBGsQzSssPJEGzAeBJY58KJml4Swe4aYYrOseGMyipYtPVIAqSy+1kdPc
 d3E=
X-IronPort-AV: E=Sophos;i="5.79,374,1602572400"; 
   d="scan'208";a="104153642"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Jan 2021 13:36:33 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 25 Jan 2021 13:36:32 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Mon, 25 Jan 2021 13:36:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h2HDI8f6HuRejGIGd7foLh1uEkDHQQD8topsPKVwG6cj/En0YiN6q/hsL3J/HENBEt0qZ3wK4FNH9UqQQBOPJwXhVQ3kOVajcnCUWmC5AjzdgtSJO/Sy6VGpH6B5j2YZkqCIvMZCNfL9jWEBnZyPLut3RuUynh8GDPlqR1Ht/UtgIbFvZJ3MCqN+XWEZ81wVT+A5PSAfjXChkrxBv77D6Z1wsLyVaxlhTfDVYD3lQBVRiW6677W5gwEWEmhFUfKDbQxSobRE8cHdefmoixAMzpv0luDdkC5vr009n0smSApaVuUqSw4j8+dnb9FWGsl7tW4s4qCzaxbF7cLHUSU0Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/E+CySynge47fMq3VpIdvHVPQswNYPzwDP66k1RIjHE=;
 b=lYtWSKntWDqx9mxCdRuBaWWNxu788QLsZ4M5DI6QW6+biuCat5uzQaq/xBQpFUA11pgLqtuvXwnXCf/OPAlDn3S7eGRWpFRVRLHsgX5P3eS4SJb1MQOobBFT/2MIDBISSBja3hzsAuVEknF0FpwvfCCGhv0w6ieR8wxzUAUUiGhjuX7dTeCmotTJttcbK7qn5OxfBt5ejbEE/beAUqooTbkUsiZ5XFZW3KrYra4EmkUD+Hl3+E77n0/o6ZndtsiXKcvOmV1sapjT2DxI1HhdFT6/JQZhDq48Ljum7ji7cP5hihy3qM+U5fTmSKFwr7AALYKC82Rpi8tukkeXk4KvDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/E+CySynge47fMq3VpIdvHVPQswNYPzwDP66k1RIjHE=;
 b=ho8HBCcI5Q4sIq7oLMRK87awkJAmykb9Dj6XO0iWAstxDdNZx/WVr1QpesaTe3nv3wlrHEpR3bUazPS5KM7++vmeOBWkk704VvY47XwVxntJeyrndhRC5m1O1bbkcbDQ0Jb1eVXooyOQepootfRC24ooW/5SXiLKhdzpNp71pes=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB3181.namprd11.prod.outlook.com (2603:10b6:805:c3::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Mon, 25 Jan
 2021 20:36:31 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 20:36:31 +0000
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
Thread-Index: AQHWzzRpXOA4VQwuVU6fYV8or1KEiKodDG2AgBvPWBCAACqsAIAADlsg
Date:   Mon, 25 Jan 2021 20:36:31 +0000
Message-ID: <SN6PR11MB284864EE372CF10B6844E385E1BD9@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763258826.26927.5141004289781904133.stgit@brunhilda>
         <ff8339afa9f17cf65648f2a9a6ba8b8460f4020e.camel@suse.com>
         <SN6PR11MB28485D3332238AD3F0261135E1BD9@SN6PR11MB2848.namprd11.prod.outlook.com>
 <5b88ceb1164f5cf4bc31690b6a15a040ed0f1605.camel@suse.com>
In-Reply-To: <5b88ceb1164f5cf4bc31690b6a15a040ed0f1605.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a97a84bb-9d14-4fee-0594-08d8c170e641
x-ms-traffictypediagnostic: SN6PR11MB3181:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB318199F29F81E55F86BD82FFE1BD9@SN6PR11MB3181.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F+WOT64pxu33YCYkoYYaCtNDMrTlMrnqKw3D5K7nrTjz3xi8zps3UnIUkwRmZOSBq1+JNExfVvFYZXwR4WUo8fRX+eOVsP61UKGS3U1gVU+tjQee5BlohgKl7NseIYwvkNRrtqq6gAh/7lvDgy/2G/D3AvlLGjqABg33b8DpaqZJmD8k80npIdLlIxoFt6GE8U3uqLd0Et8Xw32dlDSzhIcxEHUFZ4SeZ7L65PQ5TT6Zvg3gpK3vUfoI43mD0efcGKI2qCXv8FqmXt9yAZ2lfW01yr+zS4YLORUO+6grOZrm9NM7KfUOv594fm2WAotQuW3fyU8WU2i8iaZgmFtDizuFjV1q+nMsKQUOUcK3ilqSNdEkvQofK68qEkSEHinMCkPtEZZ0fhMxIfL2qe8xSHaIiUyQCVdB061MtCw5T78fvUt1+HYjtF+121HiyTPH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(346002)(396003)(136003)(8936002)(55016002)(9686003)(26005)(7696005)(4326008)(8676002)(6506007)(921005)(66446008)(5660300002)(316002)(83380400001)(15650500001)(66476007)(186003)(66556008)(64756008)(66946007)(110136005)(33656002)(86362001)(71200400001)(76116006)(52536014)(2906002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?t8RFZtS/F2CfnTDpGGxu8Z3v7423JZ4BDsoJhH9vFn1xrjpYKs08xNTtxb4J?=
 =?us-ascii?Q?3ZGb04Hhd+MbocVnCm/nExHgC0HSEBnXT1fzPau6jJ37pj1jIBx7mv4jp2T+?=
 =?us-ascii?Q?vrRVOFK5YRREHKtO9XkMY/jbpSGsbQqAaB83bsS13mzeU4wqpxrNXDFhw5kk?=
 =?us-ascii?Q?L0u6B1Hf/O/6587ZWPdtnLmyoUa64ctmktugmeD6tNczEondaOZ38fLOSTvO?=
 =?us-ascii?Q?6Ryz1ED4iDa5Kc28MQqRwnb4fuGrZi+TqFL034roZy5QxaiVk0E77x7Yx5nB?=
 =?us-ascii?Q?DZ2EDvaHONrkv27qN6EIzPejjVb7DMo6NymRB+GnZ7XFI9VHcOA6r10ZUm++?=
 =?us-ascii?Q?XG4lw0hzbae31qLMj7yI+GzCY9dte7EaQEZKZuJdI0p0Itk+nAjJE5j7CLjF?=
 =?us-ascii?Q?geeWjmseJumeSGUdZYSvxrCRs6DuU+PwsUMrgWoxJuU+aynk5wIS7O0buQWx?=
 =?us-ascii?Q?6fU6CUXS/TAzRH6YHq6IylGMEMcDbhDc9GltU2hmXkm1D80mD25pOjVwzRyF?=
 =?us-ascii?Q?s46mG2xiYRSrPN+8kbq2bLZXbEqV0ODYTdu/FbumQTCgaJyloCWSFCSsxhxE?=
 =?us-ascii?Q?RUnY+ItKipW2VyUeQACpmJpuoea5MWgDXvhFSSyLq+fZ6mSkW3WWE1SO+ONW?=
 =?us-ascii?Q?cMPCbEK3KF/ymNaer9IlNOPLT6y5JKo8wekS3TLtpZOIkO5Hln+k+1TR97MT?=
 =?us-ascii?Q?C5OjOi5R9vRL75y4TGMQbbYOfrIlvbpELBgSICD+2B4y+EzwSdrb/KkQ0QNO?=
 =?us-ascii?Q?I16yG8KoQ7FVpuUJyYJRWv5lTNLiq+b4yDJPiG9cr9Umydln8W5VLFIcRTss?=
 =?us-ascii?Q?BxcqLTG+fikELTjgREsI8p83zbuzUmUQS4XiXlpI9gcML0wom5RfQZ0Shxs4?=
 =?us-ascii?Q?3j7hfJSpob2Q+Uj+vDtvPmNWmfxXKu1eOnxPTbseQ17uoXaSZ79bICEG/Nr4?=
 =?us-ascii?Q?9Gqg051R1cK6LA0kxqBIpebK/fGY+h1xiciT4g3YGtsbY3Jh7ntRcag3aYQ6?=
 =?us-ascii?Q?L0E9cb2fYyH5L+W3Rc0d4FHWg5EX90uqhaxlBJtdhq9x4XdWl/YGHVXZhG8Q?=
 =?us-ascii?Q?0TU/vGO1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a97a84bb-9d14-4fee-0594-08d8c170e641
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 20:36:31.4675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2fkdWGS4C5bBfucNflUHBvQ21kI5LL/qEfkw7BNHveSKfFYzlFNiUu/LkDsxII7kOZWMTUzhs967LZPIx2f65Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3181
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Martin Wilck [mailto:mwilck@suse.com]=20
Subject: Re: [PATCH V3 22/25] smartpqi: update enclosure identifier in sysf

> From: Martin Wilck [mailto:mwilck@suse.com]
> Subject: Re: [PATCH V3 22/25] smartpqi: update enclosure identifier in=20
> sysf
>
> > @@ -1841,7 +1841,6 @@ static void pqi_dev_info(struct pqi_ctrl_info=20
> > *ctrl_info,  static void pqi_scsi_update_device(struct pqi_scsi_dev=20
> > *existing_device,
> >         struct pqi_scsi_dev *new_device)  {
> > -       existing_device->devtype =3D new_device->devtype;
> >         existing_device->device_type =3D new_device->device_type;
> >         existing_device->bus =3D new_device->bus;
> >         if (new_device->target_lun_valid) {
> >
>
> I don't get this. Why was it wrong to update the devtype field?
>
> Don: From patch Author...
> If we don't remove that statement, following issue will crop up.
>
> During initial device enumeration, the devtype attribute of the=20
> device(in current case enclosure device) is filled in slave_configure.
> But whenever a rescan occurs, the f/w would return zero for this=20
> field,  and valid devtype is overwritten by zero, when device=20
> attributes are updated in pqi_scsi_update_device. Due to this lsscsi=20
> output shows wrong values.

Thanks. It would be very helpful for reviewers to add comments in cases lik=
e this.

Regards,
Martin

Don: I updated the patch description accordingly
Thanks for all your hard-work.
>
>


