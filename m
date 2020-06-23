Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02299C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 21:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0FEA208C9
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 21:42:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jNM1HgXB";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="IHjZ4iL9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387715AbgFWVmu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 17:42:50 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:11867 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387672AbgFWUE3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2020 16:04:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592942668; x=1624478668;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Np6yWb6YmYOwP601KxKtVBHOHmLBPCihT928Zpgt9yE=;
  b=jNM1HgXBtT6L3aYvSbDUuvWplE+e9YxVf9jdfy6fDDpcKgV8/Tavw1hf
   o0FZ92cBxJuSci9SNKyu2/YQQHU690hAy4olTyw3eqFdoZq/NBzTUdUkO
   unZqQMAmn+WvhFOEdfnILXbtF7EDR6XJl/iOR5n2/jlRUfGlZ4wTYXMFZ
   +nCc0BZNYrEWzn0qCXFmRc6J81lzu9KwJzMAd5Ekj8KbFaj16/aTnX0eV
   zLCVOpspX2C2dhgbybAMQbjLmBHiYREotsTdb8W6eo95gJ9cx9mJP2jTi
   Fm5Xslwo7QcObfvMffxoGOtiebw0DLUppeQc1uuL0WZtfRr9hFDboTHvJ
   A==;
IronPort-SDR: TVWi/azldYgUFItnCvJoVEgKpOeJXX107UXPJG6StlbwRqUeN5E0rWlmbxm1BBnVvE+2h5dVgQ
 XeTuEFRpwXfuu/WU/0+T3ja0eYF16Lz8c0EVuitcFyp3G1EUzuSOQUpbGrc0QoNqDYe1oaayRi
 w0esp+BnIPpf0Q6FiMvKkfw2uhR4SpIZlWJ3XHullZzRbfLAfXqiaadptS4EHEhMWv6i2rTx3c
 b3dV2FMe8xREgOZcEQ2TSGn93p4dkI3moX/2YHtcQTP99hFM+rYEknDaH12ww0qH7Y0noFh8AF
 ebI=
X-IronPort-AV: E=Sophos;i="5.75,272,1589212800"; 
   d="scan'208";a="140736465"
Received: from mail-bn8nam12lp2169.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.169])
  by ob1.hgst.iphmx.com with ESMTP; 24 Jun 2020 04:04:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJny1u+3mJNqHecgnnwu2e9V9NHQ2cs8qRAySfqk+HK0zOKE7g7wzDMzeXjOOQ5ZnfWvz7H+XKutxcAZTnPCoAv8o87FbtsEKme19QLiJnBzFXPl9cnmGrdQYr9pSfzlcueDaBCOAiEAJzAx/IR9yXQv4YF8FLOIUpRZiK00DzHNvvEvJyLCHBmDgKTFBFvthBYQjLmI+wMhFLc+mofxS3CDeB9aZ9xEB3e684XvNNFuV/u2dlW3Y7yTpRq0SGWX9BfqP+bdGRqC2Uf43FYmMC3fyOyCMQZRdFaMd1g/+iBi8RN/kKYuKVgmYqm65HH4V6+rHX08V3IeTGuVmCsiPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AFsM5q5C6S5qHJP5MbkL5vQyjt0FsmZhwl+q8yIHFjc=;
 b=cAH5m9D6hME8jQlicG/roRVuUEhvyOMssVqDbowmo+b2RxHGQySFX5nMWXD44UwpqJax3cbRTOD5yRDIUIvMsdA1+gAd3FLNA8CtFs0/nRalhTyKyYy1dDMBaTJgdZvrdWhiX6wwVveK3O0z+UxLT1Bm8DMJ05hHFf9dURBrHWnS2uAjKgOfJdpVO8NmAyx5glwwp06iFQjTrXBSvhHG6ehUqfDhXzS5O4TU4O8Hwv2wYriJ46+IofbDVNvt4lwoB+VVH1KdLTF0nOjvT9FTrb03aDyvzSsqT8NF+4g7QK95LlJ2JDusQaD7/ZsX9EVvLNoKEJzSAG6/9EG3D36HzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AFsM5q5C6S5qHJP5MbkL5vQyjt0FsmZhwl+q8yIHFjc=;
 b=IHjZ4iL9106SvY4s4mXkIx9f1s9UqsVsAvb2FD8dsflyw4K2gHfuHPTWSb243P/NC+s/1Nb1WyRpA9ApYaXe4wCEjHK36h0haTKwtYJ0U8DyatSb5A8EHtZ35win+z/8LImLWQqUhrXQX68d3wAD3zTFL8SwYT7J6gM6JpD+X4E=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BY5PR04MB6916.namprd04.prod.outlook.com (2603:10b6:a03:229::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 20:04:25 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::4d72:27c:c075:c5e6]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::4d72:27c:c075:c5e6%7]) with mapi id 15.20.3131.020; Tue, 23 Jun 2020
 20:04:25 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Tony Asleson <tasleson@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [RFC PATCH v3 7/8] nvme: Add durable name for dev_printk
Thread-Topic: [RFC PATCH v3 7/8] nvme: Add durable name for dev_printk
Thread-Index: AQHWSZMHUF+C0LyjzEmzp/5FmQjokw==
Date:   Tue, 23 Jun 2020 20:04:25 +0000
Message-ID: <BYAPR04MB496553DF4EB78924AAEC1F2B86940@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20200623191749.115200-1-tasleson@redhat.com>
 <20200623191749.115200-8-tasleson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 157cfe63-9e32-4aea-ac36-08d817b0a130
x-ms-traffictypediagnostic: BY5PR04MB6916:
x-microsoft-antispam-prvs: <BY5PR04MB69161950F89D628D1F57647186940@BY5PR04MB6916.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:37;
x-forefront-prvs: 04433051BF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RhnX4W2PKFVHg66Ihp+K1ITM8va6H5/MB1CpHiZCKjghaVlMZqi+hzTIZMhXmPyXl763j/VCrt9t2ILL4+dviJGvD2/VNunRafnUbalQyseMbAvO2Tnpwd5E8qIib46nSddXSN0MdjbGCLxlgshGJ1AA/Mwx+SQ2RpizKFBESu3P5gvzLIi6bxUM/ruGOqOyBfqjXyl7DHB38HC4lN/GXj1WDSnMJKNSSuyjdc0mFKj3xJl0CrEQRfFEJJItaBqeRIL4HH2EaCDbMXOuesG2ffty5mzp9xUdgGcp+tpCfyYiTQmjhFRKQd8k/5t5iuo2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(396003)(39850400004)(376002)(110136005)(71200400001)(9686003)(558084003)(5660300002)(76116006)(2906002)(33656002)(66556008)(64756008)(66446008)(66946007)(66476007)(52536014)(86362001)(55016002)(8676002)(26005)(7696005)(6506007)(478600001)(316002)(53546011)(186003)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: MOisWXdEWakvnJ/SnhhOhzPpqTFo4789ngUs9KJ5wo1Bi/3HHSo2DTWyk4K4pLnqTqwIUn4aHuAT//RaT1kw+zh8YOSyVZJMXGc7pK6/bH5Ia1spbE35uFR8lLThsD/yVRgk/fnkQc4nPLBMqhcaRi2mU8CvKDvW55tEi3nU9UicJU49mZmTX1oq5bpW4lQg8mva3b9vrCuZUWTf9px4p8/3KbnfVv6uLzdQ5YfbWujoM5mSLe5+Q4f2RAJOLzlryyjIzJL2ZlXNrgkBdjvXJN6k4FLRhS00n6EV7zp/JbcDsSRW0/cvxUZNiZ/aKP/sq+Nn296G3yCSfadbWTGHToWtnAnt7KQtY4/lTE7gRDhm4ql9WmTJ03upuWsTCYeVHo/bqSC0zl0P5P1Fh7VdpNN3OgyXiFEtvSoivJz6eRCKDeZhZ0RUscwzObq/D6udlXin/Xr24LyaoYeQWlrwNfXmPPX/g0T16Qb3qiQFUho=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 157cfe63-9e32-4aea-ac36-08d817b0a130
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2020 20:04:25.7750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gmkGvYBXQEVZgGhXyLhRKkBxSgbG8R9AUIhJD+TjQ70xw12oilNqQvIMbtJpPVeUkaWsgJixSlzigvLi2Q8b56aY3/m5ha7YbUZjutwA7XU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6916
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/23/20 12:18 PM, Tony Asleson wrote:=0A=
> Corrections from Keith Busch review comments.=0A=
> =0A=
> Signed-off-by: Tony Asleson<tasleson@redhat.com>=0A=
> ---=0A=
>   drivers/nvme/host/core.c | 18 ++++++++++++++++++=0A=
>   1 file changed, 18 insertions(+)=0A=
This looks useful me, but why you still have an RFC fag ?=0A=
