Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32494C38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 10:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02401208DB
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 10:42:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fP6bJYdp";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="wNztVOlT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgEHKmk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 06:42:40 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:40344 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbgEHKmk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 06:42:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588934559; x=1620470559;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=qa+iLQCajdfY9Ym5HUfDU3YYMtDKgFhmamI4sCGtw1M=;
  b=fP6bJYdpMJjyzsk1msveLyVm+Ju6mpuaYlOUuJG3xOpMMP+jtDEKHfng
   6q3GL72n8+Siultf98nuZvhGixp6xHcR4ixWUGLCgMfDdBa5msTxBwmoa
   lHehaFXkij4JgiLQ6lsi58GuW1JRTXo0vBr8PjxARDWYHdKBCgvXoPHnj
   tnTEMRMKeBnHoeNHBHAyYMfO2rYJHxm5m4UXzlmpg38dhjk38nWvW9QQb
   WTkHlW7TekcYXVt4vfxiOxGZE68HLQTNg20DTjxKPKr0ko690Mu5w3RjX
   8gKpJ+H4A0EeA1PW6oq5zUDG1DF4EJyiTHAbRs4qGUZFVFObr1+0GwOOw
   A==;
IronPort-SDR: RJwmDl5vWNMhCY3YvyuP7sSD9T+YlYyIn/MqRZW2hFdCF7sY5pX2jPVGUk4lcUQOhu+P1dECRd
 Ru/9qxPHpOg5FcDT/wgS5b77KibXIjS8aduqt1pYNkj9DOySxfD5RNf//z0HQAisCtJGdMGjRN
 RMKxrx8N17OSp/Pf40xdcMPhIwzPNcEDjwR74OCuagkspd2c6SRc2PdUpbz7Nk5NjS8NYdrC/+
 aYEs2J6r2REXOlD+fO37t/fOZdeFJ5XwkPLDP+t/AEWl+oKbmMPuiifzjn+MnEJIAEGJaCXGet
 qEY=
X-IronPort-AV: E=Sophos;i="5.73,367,1583164800"; 
   d="scan'208";a="137556634"
Received: from mail-bn8nam11lp2177.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.177])
  by ob1.hgst.iphmx.com with ESMTP; 08 May 2020 18:42:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nC9TcAKYmKQD0WBMIVf5XjhiRq6EOP4PmxMYTnSeHqfaG5T95Scv8n5d2N17Hj+Jd9HillmuCTzf5aEblB2jUs+dkTidrBrNEfHqysyLcfp0vxG9dTcWf2CHEkCSgpuoJIfeJuBd1OWn4wrKA8YfDgIGL0YOATl3LLHqid3jCTSH/NGH/xOamN7yCc4Bbw7BroY23XitKCJ2ZU1XtWRBAnYQrOp9RQQVsK/LqUP0/eTw2Olu4wohN7VxcYYflo/NWiM57KgcCUErQa6lzGhKkgd7sNJs2GoOOyDANK4ti6EMi2wdXjEC9p+lNu0wz2cK9fKcoU1OyEmAoWiERormGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ue0BlUQxo7re3uquhaK1Rrg2Ay1c9Ig8t6HBFkAyzs=;
 b=AmPDN7E1YTjXonDIpdhsfHfraRpsPMHfDtZ+IqHptaKqLVfj1/sKOhtqTMaryFzlJ0TBgjZesnJfU/31zEb6tFWxPMlv6utANz1ytWDjpdA4ZqyrqZq7xXq3tO7J//GrKtpureDNyJzl1HffW9XQZ4eC/1mmdaMUl2O+Ufy4Ztn8aPybv9RRWpUpvTtAuaYI1AmfuJfK26qYiIGMtsf4CR0qXCk71e+cBdBS7B1VFwH5fEiNqZM4XmSGMil7kqSVhziuXF+cJ4LjO+8HQL3nq+wU4z6kXR1ekFzzd+vbZ0AMQwm65l0awlaF7q7cjBXv5hY5YxQkunuodn2lTuq0+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ue0BlUQxo7re3uquhaK1Rrg2Ay1c9Ig8t6HBFkAyzs=;
 b=wNztVOlTG+JRpDJVkzcGmjGRPejB4ZJQe/BKDMkadMAqfZ4I1zRUn3WQxZb7atSudjfXyqB5N5ieomjkox3DHBTdTnk5i7HMZa0IpyySdI/hhyc/ACvDl6u3OReAwULhrHhfc8Zv08byEe/i28S5fSuk3EX5lWg6kUavU9WKOiY=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3599.namprd04.prod.outlook.com
 (2603:10b6:803:4e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Fri, 8 May
 2020 10:42:37 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::9854:2bc6:1ad2:f655]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::9854:2bc6:1ad2:f655%4]) with mapi id 15.20.2979.028; Fri, 8 May 2020
 10:42:37 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Suganath Prabu S <suganath-prabu.subramani@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "Sathya.Prakash@broadcom.com" <Sathya.Prakash@broadcom.com>,
        "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH] mpt3sas: Fix double free warnings
Thread-Topic: [PATCH] mpt3sas: Fix double free warnings
Thread-Index: AQHWJRnAjvZPSpAkXk+40A/zfTDflA==
Date:   Fri, 8 May 2020 10:42:37 +0000
Message-ID: <SN4PR0401MB3598B386756414F233EC44799BA20@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200508091854.32748-1-suganath-prabu.subramani@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [46.244.194.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9119139e-4b16-44ce-7619-08d7f33c866f
x-ms-traffictypediagnostic: SN4PR0401MB3599:
x-microsoft-antispam-prvs: <SN4PR0401MB359963A5478BD13EC4AE38CF9BA20@SN4PR0401MB3599.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 039735BC4E
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3Hfg6vOjwPJjabNdyIp0gX4nduR196d7DASJ677EM+vnrYcPSERHuRcE/+x2IZyYoIWcOoWiRGFukL4/g5//un+CpubZaRsa5RGzLKoaBBwd6VfX5UiCz67240CXT6tUtG3PoWY/7tS/BYVqSWJDyN+Voze9QCa3QsrUZTWDJdUqDFHuRG74lIBReyf1uv/QY//TxjbKKDK/fjqatfmHkDfrzYcbBrFZbpLtnq5mcm8f34FXdfxjFORQDl+4muXfxp/q9U6Qotc4+Q/Ph4aLuRlMxulYtEINUqHvf3W14WrpCGsU2vGV1i3w/VtGCJFnJsRz/HjhNxBKHxwzKg70W3jqQXpmr8V6aMMgGetcgUcYYJqzVuTilnolnmdkOIuMJ086qCXSsoVsVux1a6N5FHzfCZyj9X3R9Wj2q1FCwI4+6/UZU+kxU8fDFZEkTtxxsrkC95QEzDLhiwjOyrwzVfuAHm12x+nfbw8X5hlI8sk+SJX1LK7+7PYVfrfifURnw4PRjDNLv6imFeng0XOo5wmE7J3T9BSBaAzqMbF5zW+FucsOwlcVaIScMKTa+kQ7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(33430700001)(7696005)(66946007)(33440700001)(64756008)(66476007)(316002)(71200400001)(66556008)(53546011)(83300400001)(54906003)(4744005)(5660300002)(6506007)(110136005)(83320400001)(83290400001)(83310400001)(66446008)(83280400001)(9686003)(478600001)(55016002)(33656002)(26005)(186003)(76116006)(91956017)(4326008)(52536014)(86362001)(8936002)(2906002)(8676002)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: t4gD9DXeLxChmbaNUb/63Q2OR4DpOUA+uLW6z9iqFIHgBPcfa/GTDzCXPhA7HmVp4UOdsWfZGZuUh46dnqjpXrMA0mexCGgyTa5fsLkgp5VyKkooW0qR5xQiEleTKiKmBVYJhol3BAzJCUETE+di23fccCI/X4T4BZRMNMX7JamCJ0pV8qybOEt49etHciyfjQ4CW1q+89V8geULd1C4w5FzXq1ob4GCn8K7KXHpM2MX5RCl5LIRksv/bJ62SjyOdLMe90vxmO7UuKTvMdCyIkPigW5yfAVBF5HsBUuenu9crZHzDexrkYSrKGYNaDfvv+gIW6DhmXPdMRrZcf4sgmpuw6ePeZd/mbxMHB/3/hr7yCuB/+hBfk4DDTcG6WDNYzlEY3FVkul4nWNhRaVPRYr3CpzACtjdbHaABcVVdkXUEg+lpweOvEk+FD7otd+jM5K6QfBzpRGr1lwMNTXjjZLClyHDAd9snKho4mfrQ1Y=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9119139e-4b16-44ce-7619-08d7f33c866f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2020 10:42:37.3624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 44dTWkmnHpG+KKX4XYsKHfbgsWfkzUGdExeDaE8sN4keoq2R+RM7cb/wLvOEovAWZCFcSO59cI+ivbqBnZETWWHj4tR6lHg8L16OIlhTlyU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3599
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/05/2020 11:19, Suganath Prabu S wrote:=0A=
> -	kfree(ioc->hpr_lookup);=0A=
> -	kfree(ioc->internal_lookup);=0A=
> +	if (ioc->hpr_lookup) {=0A=
> +		kfree(ioc->hpr_lookup);=0A=
> +		ioc->hpr_lookup =3D NULL;=0A=
> +	}=0A=
> +	if (ioc->internal_lookup) {=0A=
> +		kfree(ioc->internal_lookup);=0A=
> +		ioc->internal_lookup =3D NULL;=0A=
> +	}=0A=
=0A=
The check before kfree() isn't needed, you could simplify this to:=0A=
=0A=
	kfree(ioc->hpr_lookup);=0A=
	ioc->hpr_lookup =3D NULL;=0A=
	kfree(ioc->internal_lookup);=0A=
	ioc->internal_lookup =3D NULL;=0A=
