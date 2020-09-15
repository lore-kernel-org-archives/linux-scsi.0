Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 160FBC43461
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 09:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5A502080C
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 09:22:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Z7+ej7AO";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="QAJ6vaFT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgIOJWh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 05:22:37 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:19591 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgIOJW2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 05:22:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600161747; x=1631697747;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=WuZqoqt0fIBH0kqeBUZygpxPc/TeQ0yj+HkDP1wOi8A=;
  b=Z7+ej7AONvLJXd2cnOpNl+MFOYamjgwVjnfwSoag2Yp/9kfMZifZ2+i6
   A4I4e7yTp0Nlt76vFNHxzOxYnhoJXOPWU8AE0pkIMQ4ByTa3WwlOWC2EO
   8MnS+PJNhbQPWxvmzY41lOcbFEoVoFyf4W9VuWMInNxUwAl9rlYGgezki
   kzq8a4QuTFZwQW5qZ0omHZ3CMeWbwj5HOdwpF+Powl6pxyI23fHe0R0W5
   wsk4B/lri8OicKp3mmEXmy4z93MDq3lkkezFMIwCyoJRC6gHg+5NDwyT1
   GWhb6BZokEZ1BTzK/+9Omc0xiDURDr5neVI+lkmrw3f1avx0SR87kEnUB
   w==;
IronPort-SDR: XM/g+w8jQeZYkGHcUm+CBrMDHnOuFbAG5W+EBKiZpjTTtMLdxfM5gUxo1GwArLu3Ho8x9H5NOf
 EQPF0TBdKL0ebrA+h6g+Gy3LclAMLU1KPuaSPbP8XOuT95Q2VeV8LAG9gRoY3hjAsodZ6bGDDD
 MTxJZRFcjZTHMKteiG/V/Lz03hZaCGCKVuiUwZDeTOem0nmeEGsENBe9gd+sxy1bZMpezKbzaN
 1uF6MhWytZCEKzZVMlSqSL8hx0lC6316284DhujdHae4LfccgnW6tWHlOVjx1w8NGJgQ7NyVEw
 YTg=
X-IronPort-AV: E=Sophos;i="5.76,429,1592841600"; 
   d="scan'208";a="147328461"
Received: from mail-bn7nam10lp2109.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.109])
  by ob1.hgst.iphmx.com with ESMTP; 15 Sep 2020 17:22:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYjSJ2o96PqrnxCMs2soyYGUl2arX18EUFFwaIf6ovgPFGfo17NEcuUlgIYvSFCiup64c3s8iGD+SebFPyYTsjX5IW1/w2vUWxX8lm6oW/TAS8Rkg1m4vw+4u5LU7OhJLJ5ccbYaRGpuf22v/+kYZNoFFCluSE4KYKWBX54v5mB3sPZek632tbbKuACHz1ISf1b5T2dysJytcGZm/svLKQTEey0QO67E3wHb6KXMiJf365Qi/HN43jVKr6bERRMlO3Q28KymhG6bz6BzDqxh4uGKflmnhw1Jh8A4mDZHAGZEhNk6/hpWIvmbQbzmUfORB9DXcVuRqMGJeyltYyAXzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLsvZYtk7zE2MliRbCqWzAv4dALxHarTMlUYGoq09J0=;
 b=g1lT/maFm5kFZ7tV0O7Wgvtv+FLkPWh0EeWuneI3q8c263baYiZSQz9tXhJeMFtuJJ6vLUdpgu+/nHpl8XnYvl2wcoZ4HMm2Tm77ZCH2R0Of4NjL4uz0+dEEQhXEH+5KAAjuNrjxvXf/7YQHUyvt+/Z8iseGj8weSFK3ZOLdb1sY0KAUx4cc/4DlgRhQP2UcMBLyDpzn4nH3moS9K12FbjPkgbngRBpMnbLoBHJCET+iHs6g3Y/CopEKGcj0ktw/zB5CYEMZuCuMwYrR+3IELRRq9IJTp5qZ5sTBm0uASCGJFHBo0kjT4gcGa+2z6RWFvdabAJV66riCxuyqfygwKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLsvZYtk7zE2MliRbCqWzAv4dALxHarTMlUYGoq09J0=;
 b=QAJ6vaFTXv6NDP+IhzH6IZk9F+/9YWXNpx+jz8RMLbZt2G6GnBNiMzd3CEZK64UMps2eHl6xqdI+DPkjm5NNxRQOqtTVFC91n99cC11fMEzpRsmPlFvoHgRutvcb2RgXuxfnSiu+irUrQV8Ys9yEtIr2Df/S2eAD2XJ84M6L7vs=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0566.namprd04.prod.outlook.com (2603:10b6:903:b5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 15 Sep
 2020 09:22:25 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7%12]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 09:22:25 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Jason Yan <yanaijie@huawei.com>,
        "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>,
        "sumit.saxena@broadcom.com" <sumit.saxena@broadcom.com>,
        "shivasharan.srikanteshwara@broadcom.com" 
        <shivasharan.srikanteshwara@broadcom.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "megaraidlinux.pdl@broadcom.com" <megaraidlinux.pdl@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: megaraid: make smp_affinity_enable static
Thread-Topic: [PATCH] scsi: megaraid: make smp_affinity_enable static
Thread-Index: AQHWizuhmRvIWDHFdUSHQ66WFWtAEQ==
Date:   Tue, 15 Sep 2020 09:22:25 +0000
Message-ID: <CY4PR04MB3751C6672A68014B136A91E9E7200@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200915083948.2826598-1-yanaijie@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:f58c:fb44:b59e:e65e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7474546d-dddf-4396-69a1-08d85958dc08
x-ms-traffictypediagnostic: CY4PR04MB0566:
x-microsoft-antispam-prvs: <CY4PR04MB056625E15B46DC559C088C37E7200@CY4PR04MB0566.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jDVPw/s7BaTBeaEZ2uNi6ceEJttr4jRKcrzCtzo6jkiQEeZM+ziNfWRv25OgJ6TqqlZkA3OPepZEuVhaUT3zi/sDbnUL6DAzUpXvW/hOJPTZ/G2QM7DVRFfzipnmuG7HkA9jjC9KHPIULK4ARCmJwcCzcdItCGQBndf6tUozTxj4Qtl2eJUHK4iOG5ZXWb2dyisuBuI2LdcvXclr4m9e7IzNUrUH7KF9wLBCblB9bSdjm4RvTzbrx6J3JFBal8Qlz/IqJ/lCwww19FPILQ4dNruOTGoRjgLTYfaseScVAXO7TIpJasCnsq8OEIHcd4J2OheKFoRqfHjWV0yHxtDTrRfRmd1ClK7sibHxxaxzmcr+SW8JMAYnGDyrQ8JKd8bn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(71200400001)(2906002)(83380400001)(8936002)(9686003)(186003)(53546011)(316002)(86362001)(478600001)(52536014)(8676002)(4326008)(7696005)(91956017)(55016002)(5660300002)(76116006)(6506007)(66446008)(66556008)(66476007)(33656002)(66946007)(64756008)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: fSr09+kaxh5SU5g2Tk1//9bQ/39O5ElnrGyoM2Ax9RzJT0dn0Nil7NKM24WQ39EUaXKZsUY5ZhzvKRG4fyZIq2wHU0SGWl+ZBhZYmiJ1T44Ipw6P6gUs4Gu8U5OwUwEcKnEuBc8CsAboOj2gtQNIJSusuJNEwurn2NsYyofDqP9h3e5Csm1G03b1RuYaOLqEnbMzvoFHJpGxECdfsTWb9sByY4eGQdUJtJ7gI8OqVrH9nrIUXDmILHK7egIi0JKrVFakSL8puZb7FVVD1EZ6J2la9FjTpAuSdD8E+TCkRY6hKwh8ryaS/YfhUEKuqrDCCWhUAnbkxqq987w4aZFja4KEPnTpISn+fe0SxmMICWIIjs4JvirgxYNzLeBT7cTU3++CFvooRqc36pA8hlx9WBc81jufWjGiAM17Twg8wwunS4f5NLlK1LtEPxUErb/vBG8ThLSRjp1DzF17YSnzKKbRXHjDBbavcjOxWCL0BgF7cbnoWrTbEfD3DGGafXdHu6sDNVmCm92kZV6y2PrYAUF9bfJ9Lrrnmo313o5I9u7stWU7dfA2vAjf/ADsVN3zGRMO5Sw79j9DeVcaOtGQ5UTMbEXZA5wYxbZ0wumcg2SeDfPKNfM+Vj/xsfswFj6+q4bU17jz8FOaxRDE0qZ22urn/+npqYWbGjyk30Vje3xx7gJINbJsxYJZwFqXnHEXeOUquAC4fOo6FmfumO9OFw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7474546d-dddf-4396-69a1-08d85958dc08
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2020 09:22:25.4649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G4olcfaaA6WgCiPoOoiGTTbqWyO39LsC7fKrHXA9SxV/N/NkByffkb0zB848kwOmr1F3jy4FlbXFzAske3gVdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0566
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/09/15 17:38, Jason Yan wrote:=0A=
> This addresses the following sparse warning:=0A=
> =0A=
> drivers/scsi/megaraid/megaraid_sas_base.c:80:5: warning: symbol=0A=
> 'smp_affinity_enable' was not declared. Should it be static?=0A=
> =0A=
> Reported-by: Hulk Robot <hulkci@huawei.com>=0A=
> Signed-off-by: Jason Yan <yanaijie@huawei.com>=0A=
> ---=0A=
>  drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-=0A=
>  1 file changed, 1 insertion(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/meg=
araid/megaraid_sas_base.c=0A=
> index 2b7e7b5f38ed..e158d3d62056 100644=0A=
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c=0A=
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c=0A=
> @@ -77,7 +77,7 @@ unsigned int resetwaittime =3D MEGASAS_RESET_WAIT_TIME;=
=0A=
>  module_param(resetwaittime, int, 0444);=0A=
>  MODULE_PARM_DESC(resetwaittime, "Wait time in (1-180s) after I/O timeout=
 before resetting adapter. Default: 180s");=0A=
>  =0A=
> -int smp_affinity_enable =3D 1;=0A=
> +static int smp_affinity_enable =3D 1;=0A=
>  module_param(smp_affinity_enable, int, 0444);=0A=
>  MODULE_PARM_DESC(smp_affinity_enable, "SMP affinity feature enable/disab=
le Default: enable(1)");=0A=
=0A=
Looks good.=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
