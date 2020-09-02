Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D2CC433E6
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 06:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C1CB20758
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 06:38:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="FG10l9R0";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="deRGYZ5R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgIBGiO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 02:38:14 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:63429 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgIBGiK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 02:38:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1599028690; x=1630564690;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=F9SRxEVNisZLp4w0W7V8aZrzehyLyrm4c70xSXh8axY=;
  b=FG10l9R0rl7nkfQAWxms3I3fLIX6M4P+dhRL/74ziemvnHUtqPLOQNHq
   Cls8xVC/OQxG+iXgmgghdrMrbk9NoCABL3gFja9iNlPo2EYaJDyY4+aBp
   yA3yxGH2qds5CVDPTIwJJ21NDUr2AeBZt5yFEF/BjOt5V1n+E+E6CE6RL
   a7g7g5lBlhLoaSvp4YvuJz1opdJfnC4B/acNRdo3UgSCljyf05qGQ6TnT
   SakVw74Bonpp9JEnUHLH2vi3ck/S5iATurlQiVOTmlxADi9GzP6HCemcK
   Yk108QHxdi23ps2flyDxKO5NNC3OitaEvLuZ1MT2ZuOG3hbkNkxumzUgm
   g==;
IronPort-SDR: 7jvfpwntM4ZoybtIVs2tOyEWcKq2MQ8F0jCsSZZi2mA/JDfCPRvCysGwg2CnbeWpNEFZ/cvDFW
 ZvpM8heCwHL+w9SsN70W2vrAC60WQouYdMarQvwJzn+xgJFEBRfPRjOMpCPm4mR32nwK/Ps9+v
 jiZsVz2aHa0987IwkAHwIRj7qsYAIlR6SPpWVQa71S+6XoF6XKU03dEC6TQ1cimVMKq9LXO22B
 Iqfoh8opN76Cv7T3tOpRfYMJsQkbRTqFlVZCmyzy5W1rLNehyJh9ThP8lvQu6fJOg3BPuj3UCI
 qek=
X-IronPort-AV: E=Sophos;i="5.76,381,1592895600"; 
   d="scan'208";a="94049603"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Sep 2020 23:38:09 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Sep 2020 23:38:09 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Tue, 1 Sep 2020 23:37:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LZeKa1LM9zJlSlonRGfCwXdOGgJaKyNB8/aI4nEkfCNmQiMsqe1TjWIsI+QzNekAFSoH0O93RPfy/rfAuOc4K2G0K2c6Bq3LmYpZNnhKz1tcpyyn45bw4vOkbHaKv6ctONTYF5KInF9MUkrNRxwDvKyUNemN0T0P2IFn1/lxhCJCFhDOdFAyyi7LH4WffZIruIN9DFb5gOA49SXurRcY3dYhK2ErbOhLRxCDbMyZAbWBOFIDsOqbyEXu6puy46Mv3HPl/jK5THx3ak98ACgU8K3kiUNY4u+ZGbt5mkd0uKuFhB3dITo5FNectAJPIyMHDmvwBRjIYTySpzjNRuvGow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DbjlDCEEfaq7hN5mQyw7o4WmThdcNQlOgNgjRCaRDWg=;
 b=jBe5ZoZd9UiVC7IHMjtIDn8xt7YvUUdpUpUq3JKmmosbqczZeCQzsaPm8nXl1bZUKDtMoKab8N/+mRYbQ1kPmAzke+Ksx90drSMqSSLqnbH+m+6YhknMZW402zOMiNgxvOH+v1RXj/MixCOcI+rz3rWoLxbbA9pyX+wXmgW+9bldG0jkeRtg1N81VFlFfMs35VMUDSty8/ViXwQP7wGlNY6Epz9k8WoA1/1Y/o5rq80swlEpBswxeegm7vT3L4+DPFNjaOZpRn9HSkOfezpYcVZ5aZujaIiCvO2vkCJP5DXUp2N722tY5Ls3J/TsAr+pLPNV1RUw16zho0ERaotcTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DbjlDCEEfaq7hN5mQyw7o4WmThdcNQlOgNgjRCaRDWg=;
 b=deRGYZ5Rg+dNbgEHSYluf9y+oUJGeHyGRV4onHLnpS3IKbn8zUByakgYNQNWzYANljYj+j3iL10qvLw4OVHxzwbRb7Sjfr2iyeIhzthe0p0LJ5zXAHdntXNrOt3X8rTdckZ7LhRjMDuDMG3LyV64iADp2xm+/FdSwm9yqsiYnKE=
Received: from SN6PR11MB3488.namprd11.prod.outlook.com (2603:10b6:805:b8::27)
 by SN6PR11MB2733.namprd11.prod.outlook.com (2603:10b6:805:58::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Wed, 2 Sep
 2020 06:38:05 +0000
Received: from SN6PR11MB3488.namprd11.prod.outlook.com
 ([fe80::9464:652:6b4f:12e6]) by SN6PR11MB3488.namprd11.prod.outlook.com
 ([fe80::9464:652:6b4f:12e6%6]) with mapi id 15.20.3326.025; Wed, 2 Sep 2020
 06:38:05 +0000
From:   <Viswas.G@microchip.com>
To:     <martin.petersen@oracle.com>, <Viswas.G@microchip.com.com>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Deepak.Ukey@microchip.com>, <yuuzheng@google.com>,
        <auradkar@google.com>, <vishakhavc@google.com>,
        <bjashnani@google.com>, <radha@google.com>, <akshatzen@google.com>
Subject: RE: [PATCH v8 2/2] pm80xx : Staggered spin up support.
Thread-Topic: [PATCH v8 2/2] pm80xx : Staggered spin up support.
Thread-Index: AQHWdyGWFMJ2LWitWEWbukXdJDG1gKlUoF5sgABYGlA=
Date:   Wed, 2 Sep 2020 06:38:05 +0000
Message-ID: <SN6PR11MB3488B9061999CB58402B936B9D2F0@SN6PR11MB3488.namprd11.prod.outlook.com>
References: <20200820185123.27354-1-Viswas.G@microchip.com.com>
        <20200820185123.27354-3-Viswas.G@microchip.com.com>
 <yq1k0xdf006.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1k0xdf006.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [43.229.88.89]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 822f0919-8223-4c47-8c6c-08d84f0abf5d
x-ms-traffictypediagnostic: SN6PR11MB2733:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2733AB65C7947F76CAEAF4B99D2F0@SN6PR11MB2733.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jWQmln4EaxN4YqVMuyoKkE9LFEoVPnjA03SyS41GpD61rvBxLYwErRHSAFcC5BA6CU1XYPP46eBBseeH3JI9KsJ8bCBVXznqpAGu1ZtGeCPWqy3RQG27qoLV2nyY66NiR16Zyug1gV3fleFAWRHsikaM/sQpauQ99Wud16FbUS45YWR7n+arzncFPRHTfU4A6G/xg072Ulyr1qUXBl/7Wa5RxMfeaNMfTHeYNyQtIAz/cq7olfY25+ugmtZySI4/SF6j0/hiaezpAu3G6bXzdvZVCzrLijaXz1hRCwqUA2XKbrCNLC2SX52XBAfcB5Nu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3488.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(346002)(396003)(376002)(53546011)(6506007)(55236004)(316002)(8936002)(55016002)(33656002)(26005)(2906002)(186003)(9686003)(76116006)(52536014)(66946007)(66446008)(64756008)(66556008)(71200400001)(66476007)(8676002)(5660300002)(4326008)(83380400001)(110136005)(7696005)(478600001)(54906003)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: D/ahKZEVoI6zg8w0boiNCqvydhq/RH01U9ZksuIszLqL4hcZzRM/eF7VHC55ziGeXDMV3JMqORf58usUbLJZhFm8ak/CTcXI4rTGbHhhGedhi2p0jQSa16uOmYK5mqt9f1uCF9cStEdgF2gwOPgmUwQCpUfQ8vEnPssxMcKG5tyNNuMyHJwtYNz50DAEbHzbGPamdChzOlPjY2h5BX6onIGRxiUdIDbUnoWJXs3xNf5cbkn5vlhcYExGN5xZOEjV/wXedL/8MgiU6hGBfE1fatRvSpCU9llWBgpAkVuBGFBxoXJnoKSX1S54c1MFFTAoJS0iPDo032W51oCUmbOlm0H52mnB2xt+uv0k42S/bjzpaVTbWpxoH3wu0qtXtwxJPCIsH7Glbze/i072VsTM7ZQ9jY092wf3qXXtNLXusLoDUmRbtBTrm55Ro54XkOkh4xKJvwMqiCFrhqLNNI/BSQKGQAYpzpX47pg+VPmV2BK78FpCWi2Z0E8uXcfUiK1vLilmxJkgJNXZk3JYvLzcsosaWQWe9WrXe4Serc2WZOMfdWbngk9uUUff9qszacNle7IcK0peOnm8ChdvVm+X1fmpPRTcM44dwn7Q8l01o+SlNtKuQgO6ZCJj1RANCehm4g5Ic/ruX6dBa9TqyrcOsg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3488.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 822f0919-8223-4c47-8c6c-08d84f0abf5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2020 06:38:05.0922
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y86v6gYgv/I1hnA3lVXirJ4ra1l+526L2UcsKwWfpbZMa6F4F0/tlsq3BSoipUGakgaIj2rYU4o8PZo/BqdfBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2733
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks Martin. We will move this to libsas.

Regards,
Viswas G

> -----Original Message-----
> From: Martin K. Petersen <martin.petersen@oracle.com>
> Sent: Wednesday, September 2, 2020 6:51 AM
> To: Viswas G <Viswas.G@microchip.com.com>
> Cc: linux-scsi@vger.kernel.org; Vasanthalakshmi Tharmarajan - I30664
> <Vasanthalakshmi.Tharmarajan@microchip.com>; Viswas G - I30667
> <Viswas.G@microchip.com>; Deepak Ukey - I31172
> <Deepak.Ukey@microchip.com>; martin.petersen@oracle.com;
> yuuzheng@google.com; auradkar@google.com; vishakhavc@google.com;
> bjashnani@google.com; radha@google.com; akshatzen@google.com
> Subject: Re: [PATCH v8 2/2] pm80xx : Staggered spin up support.
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know
> the content is safe
>=20
> Viswas,
>=20
> > As a part of drive discovery, driver will initaite the drive spin up.
> > If all drives do spin up together, it will result in large power
> > consumption. To reduce the power consumption, driver provide an option
> > to make a small group of drives (say 3 or 4 drives together) to do the
> > spin up. The delay between two spin up group and no of drives to spin
> > up (group) can be programmed by the customer in seeprom and driver
> > will use it to control the spinup.
>=20
> Please implement this in libsas as several people have suggested.
> Thanks!
>=20
> --
> Martin K. Petersen      Oracle Linux Engineering
