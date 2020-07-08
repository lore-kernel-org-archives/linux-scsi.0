Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2DF5C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 07:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91FB320CC7
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 07:34:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Grc4sIW2";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="LKoNslaS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgGHHeO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 03:34:14 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:3495 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgGHHeN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 03:34:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594193652; x=1625729652;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=AGgSkUfYwzt3EsluhjjqDqCw+DvmwlS596tbTwqa9y4=;
  b=Grc4sIW25m325d/BfofgN6iN8tL7vpCpPEnQZ5023jyIbOxNNAXFFaS6
   pV/eTV5w6tqez1EpjcxA0xpeOTLxybftJBebPIjlYtiaid7Z+tkTzQoBA
   booBi/A9xzYurUe598YIC2Z/N2Xwp2h122Cu04127WuWY5GuMp+4sCU1I
   aAXjotx+kOqSdaI50tPqh0qjdCIupatv06zA6zE/7TNfOlG4QGJGB5MDz
   1sHkfZNDYFzysEKGyMOxWNF9K3QRoyDFMGnMjzX2YnvTesMiKJTpL69yd
   kU5bKdrbq7mXfou8vpEdBIH8iRNIJVXgydy5ZAA3s3dhMAqbZq+hlvB5Q
   g==;
IronPort-SDR: wvpDr6QMqgyAbw8k2/yoQ3dbKJ2IxmxnB/EePJOXsfW38rURNAht70SD1S0+o6AeeVvPcCKJVV
 HMkcG96opmTnTYF/GB2h2ndjgA+Y98Qy6AZwZu6YPw2l6upctpCtjGythmyEdTAA4y+BuEwaSX
 gmVUr1szNX48Ipp2MZ+7gONNYt8SawG3klZrwV1aGHle7nooJhNimK0JTD4VB/8GkGlaamwWg+
 +RgketjjrNBylypi9Ml77lfOIFKRuRVUPyZYHx6oj6iCngycphYGXMwlOhn5R6cWrJaT38wJJX
 Do8=
X-IronPort-AV: E=Sophos;i="5.75,327,1589212800"; 
   d="scan'208";a="143229082"
Received: from mail-bn8nam12lp2176.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.176])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jul 2020 15:34:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XczjV5IvDPb3sW1bwy9WvnIQ0BB9VXb7mV+dKw95fEBnJkYHdMG0YiMLbUSJTQ7B3N71xuu7zRJZSBhDByhe1GBV3FvuDyZNVpIymwE+m0GZsg4ohA5jl897RBEMqQ4/AITZcNuO+0syHXkd/RGf3CHNcZpiKY88/nt36jOXmXv9BvCTUk52ykuO8OaVtGfp3/qB2QAV5HQthkCiy7Z6huX1QExW+VA1saS/4HwjQdlmEjOxhJrGPa0a7y3JwfDV99fFzE8rGuZeZ8KZ5XVTpwQgkDWOpC8BRhLutgQ8FV7qRFE2FC2Y8Xim+AndQRghEOGtrcDauYEocuB0UIdXtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQuZx4cdtMqvXU62Yw0o6nfCidvmKe1SWZqgXgygGzI=;
 b=U6rcF2ZEAVotoNLXrY5D4wiYIKh/FjG6uL+Js4Cp3ouG/zbsWEd8Gk2IDXo1BUUg931Eav3Is48qheoEIWFZIks7Hwal11Md28mnuTQCSmRoYQE7cComBAzlRKXscLd5p8NkBhH6jHjkBaX1ucPCBHxNpkgc3S5UjRA4PYHwTaeKPj5Lo+viEovsMQiUaj9NfmUlHv7iT6eywFBdOX8lTk+Z9hFIsbgdQZ3r7HbY+QUwM/zsOrNdXrX/++Okex15n+PyET/zUAXMxT8er2F6n/7GE7ysX/mkR49CDl73wDNTj+RLxkJO7mTe/HYMdplGhculTAVHaSj33DUD6CypxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQuZx4cdtMqvXU62Yw0o6nfCidvmKe1SWZqgXgygGzI=;
 b=LKoNslaS20jQnmbnTfHi3Om41q8NyvLKL6N97vV/3juuEPAIunfg0yKQgkEPknEqflbHnd0fGX5qt5kPlXrsWcmledUaNsHfnLNQ4l1Zv3eUsH2I30B8mwglAYnJCHunV8eXYiPclz4i/MCD5xXsZWJaS8GpsDFBZezWHM41pAo=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB3805.namprd04.prod.outlook.com
 (2603:10b6:805:4d::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Wed, 8 Jul
 2020 07:34:09 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3153.029; Wed, 8 Jul 2020
 07:34:09 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Lee Jones <lee.jones@linaro.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/10] scsi: libfc: fc_disc: Fix-up some incorrectly
 referenced function parameters
Thread-Topic: [PATCH 09/10] scsi: libfc: fc_disc: Fix-up some incorrectly
 referenced function parameters
Thread-Index: AQHWVGcaFlao3ybuAEWR5PVLrgawJA==
Date:   Wed, 8 Jul 2020 07:34:09 +0000
Message-ID: <SN4PR0401MB359847D89233CFB550531B259B670@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200707140055.2956235-1-lee.jones@linaro.org>
 <20200707140055.2956235-10-lee.jones@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 01f5986d-2f44-4da6-c72c-08d823114d6e
x-ms-traffictypediagnostic: SN6PR04MB3805:
x-microsoft-antispam-prvs: <SN6PR04MB3805D0F418F489E4CA95554A9B670@SN6PR04MB3805.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kd5QJcpxdr5x5vs1PTayik0rguVhqUgdkP05QdUghCzNcXLjiJGHP/Ak/ijcfKiZo7nqhyQDkymTSGmcrDBd3gsqe4LtGh4cNKOePqbVFOlxOvXPVmWuFBXdsFe9plctD63WJg7UYFMpvSKXP6s8mlOyQMr+gNEJXWrydHHdSO1G2qBhcCauZ1+hFybptrDxBfddc61yJP3fMgDdOkHkGAsCcq3KziGijGxclLSIQbIeBa+XuGB1rdkRtonFGnBFKMmN3s7+TnVGFeyM077QGTjI32Osx1kc6m8EJHpnQ8w0KlYcQo01IwABkhorGj9LlhAzcV+oAA6aEEonI7H8uA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(366004)(39860400002)(376002)(136003)(7696005)(8676002)(316002)(52536014)(55016002)(9686003)(26005)(110136005)(54906003)(8936002)(186003)(71200400001)(2906002)(64756008)(66446008)(53546011)(478600001)(4326008)(5660300002)(66556008)(66946007)(76116006)(66476007)(86362001)(558084003)(91956017)(33656002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: bDGPo/KcXjpVilZKcE3WrWyq70v9RamyJSn7DDDV1bcGBwqci9wZBzZBvbR9BFsEdOAtl7CbwqC2IyBDe7NigzumNx5Cfp+lCVb7vTEB/8zxobl5QG4h8xZS/ux5OikW4KxC6f28GHaL8iDjOXn504cirpX+3VfYu+7i3B8kJRZQcbdYyLzYdzjrJxDa2k3wagHFr5LOlQoO3XyrwDjBUJ86c/0G0t8twvKMwWmTN1fEjEmaG2mmK7dx+wQiKNjUC6DdyiCKPku+CwarCgp4YkmBg1Z1pbI+tqNjlN8/9pKJmoz6F2J8g/yEPrSoM5AxtSNtNz3pn2kl8856R6q0nTDi2JM5sqiP/0Y7iuZsqPTX21LGXXT0RYIcO3CL//UJwJ302OOcZt8LzByWaQad3KNvVMXMlHJffToAe9CXIT8r9KDCVh+1md0rxWAogturlmTi/QP6z3h+5iM+GproigQ8CWmfO9GYx+KkQqOMczh5wRm4lFOS541JSpQtit/N
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01f5986d-2f44-4da6-c72c-08d823114d6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 07:34:09.2344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iB7UgZ4PgCp2yeYV793iY9LNnnv2X3zD2OBEX5vZJKdllp4jGi0CumnGv+0Np9RoyTPXtweR6daNMG7f2PND2kYQYCK1VMbhk3VKLW3S448=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3805
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 07/07/2020 16:01, Lee Jones wrote:=0A=
> + * @disc:  The descovery context=0A=
=0A=
s/descovery/discovery=0A=
