Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2929C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 14:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1C63208E4
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 14:57:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LZVWrD6a";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="b6RAozmm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389405AbgE0O56 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 May 2020 10:57:58 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:39434 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388738AbgE0O55 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2020 10:57:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1590591478; x=1622127478;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=szZxuEyOVxReR8hQB1sHPreorUmqqqjG30pbNLVy1xo=;
  b=LZVWrD6aui186ko58wJ9BdojrrmDrjVVL0eOU8WemmAGmhjNi6xBxhwC
   kAzL8t8f+bnFhdJ31iKvIhJa1qNRk//5iJNa7ZrGxEAIeZKeXEKn2UrtX
   jBkD9qmavV3NAcJeGBKBPFEvr/55y76Vrc2MMffyBqyYN/JHJBrigxp1c
   GDaUccdHgVejhcodA0MPdw7dUvvw57LLrg0fkGGQ95SvQBSKD1253PMcF
   axzQmXQmc7yupTUEp9XleHnI+n5u1FYf9uwHWS76hVarp3xLV9aO9/B0m
   Outv0N3RDS5Uzpl3xzXf7oBrD3SsImgCoJ0TDc6I6YqQ9m4kLiFeJ7lXE
   Q==;
IronPort-SDR: suuLwAsnpBdQ2eScKh8lD74ts5KgrLXBR2shDdbXFqiaPpvlmw+ur897EpcwiwK0EQPl8XXBDx
 ks1pYvGLT+94do95N33az9wplb7TVmzvG/rfs+YhxrrqYlUj/Lys3rjGgEAbM19qD9fqxn6ppN
 D6YcxhTLAz8zX3AdfenIhCYpwfbEGVqhOGVIg0eFCZdmMNXoOm8v1I2qpzAFBpncgMahl/6zaA
 6LPcPxljsus49nGpL8rGighBxl3efjrueptIrTNFtds9YytuPkITqVkE91SgKnRhhhgaQhcgQs
 p5w=
X-IronPort-AV: E=Sophos;i="5.73,441,1583164800"; 
   d="scan'208";a="142954101"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 27 May 2020 22:57:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QLohcgrmgcMnmOsPxEdiDKOA8FXA1o6LxNUFFc6s8k3e8MmS4OyvhKndJurNkayxGIiCYvW1zhMAU/OVtwf3mHLfMX6REsukAPTk4bZBPeEVHZ/pRDmUekKzYLn6Ka8WZl3dPwRY5Eu/V9CBJ9pyE9zDLqQPofcR/BLZ/YT9JSMRQ2psX5XpV/nZclWPHwWcxCe0W9l2zm4eDqDhEexyT9dFukYdPSf7EvSK95m+uicD/gs4/vl86NxqQP5FqBbugOb6B3S59GgvhWGVwpxpChAOT6jKXG3Qvx+dPaHrkgJlp9kMe93exxeI3Abyvw+bjHnTxkWODWw33pBRQOmgdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHWaIko3vhWT04yHX4LvEnCx4/BI+O0D7wXgDeGHC8k=;
 b=GykCGk6R/YO+WZKflmRcxqmw5krrSwWJ7m0Iq+X8X9KcDfg3+WaH763Q905rgxnJ1Br/ScSQ5bBk5MaolxmAWj4YhiSiF3Jb56kGSCA/i1jtZLPeWH6QjLpJhYHyLLK1L0rVp/W2RsCdsCaIyb9L3/88f8isEIWHjJogLnf6Oc4JL+ehllZZEj21fCvU7B3eR167k/0YndxVIqHl5AFqxRusRnYtnUvvFBSH7rPJ6HsqRmPdhkPMrBJReW2l8pcO/XOMPpylO4v3IKkysd9S8/e37pG6VLn4q1jjtmRcAsp04RzDmRtAOxI8dkfOH5PrICP1EbUvPEgpP0/gyx7xRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHWaIko3vhWT04yHX4LvEnCx4/BI+O0D7wXgDeGHC8k=;
 b=b6RAozmmDzUBmW45MxqyK1brxXNlPwDG17PtXmqZIvP3obh5b4STYeSbQJEttA1P/hQvJtZcscUE/aFL9J781nmndzFk0pL/e3MgjwPBa+uI2Iv5Nqu7oiNG3qY3zJ7ljpWH78339wa62z7MDZXARObAN2ITqumkn63V89Kklg4=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3565.namprd04.prod.outlook.com
 (2603:10b6:803:47::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.26; Wed, 27 May
 2020 14:57:55 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 14:57:55 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/4] scsi: convert target lookup to xarray
Thread-Topic: [PATCH 1/4] scsi: convert target lookup to xarray
Thread-Index: AQHWNDEejzlcs8n0JUaLQfmA9zjC2A==
Date:   Wed, 27 May 2020 14:57:55 +0000
Message-ID: <SN4PR0401MB3598F8FE6B4221DE4881B7FA9BB10@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200527141400.58087-1-hare@suse.de>
 <20200527141400.58087-2-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5705a9c5-88e8-447b-ee6d-08d8024e5653
x-ms-traffictypediagnostic: SN4PR0401MB3565:
x-microsoft-antispam-prvs: <SN4PR0401MB3565F9E4B9A4A4E27B6A359F9BB10@SN4PR0401MB3565.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 04163EF38A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L94PwnN+dYjGVVA+oHRBr09gYDCzNwHtQEHdM5lWWfOv/N5FodDfj8bmnfil1zW9SqejVdWPT0yZey6+acZ7uX+J/qGZFUfjW9j+MuUcwlNq+BgdAmwTBbu5NQqHGY4q5bEV8s2BZvyo8Fht6BCltQ4ea/s08QF73PuRETyc91edj2vb441vDZ5uVxhIlOcmzyxpF9Y49+IohtnEguFqgBatu7fSGQhISJPlw+tStV45u5BSk1YCKwOGUxzJQ8NoXEDUl8GN4cqci8iYWWh1nSwRzMbBTPuuVn+wdL8tewhkF/5PTpMwPLQO7BNqu+Js
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(52536014)(55016002)(2906002)(8676002)(5660300002)(26005)(8936002)(33656002)(186003)(53546011)(4326008)(7696005)(6506007)(86362001)(76116006)(66446008)(91956017)(316002)(110136005)(64756008)(66946007)(66476007)(54906003)(9686003)(71200400001)(83380400001)(66556008)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: j2TaC3dHnImiAVcR7h9z9Ti46pn2lS8HwYRYXRn2OiO24EkHAvK4V5oIbh8qaIGszPNOBHz2hZp+XlChs8pIcffPi11ge4dGu12CDIK8E6WgblG9V3VsuIiAawL5kmeoHbVSQsiL7/4B/pa9PxJlJ8w53rFYdDlmpauGzPfeJj1IvyS+hcpH3ygcogc4fgKANhe3m6xXSukALEuljirkQdsEa1MeH5qG13yd3qxX48QbstR0wt3hzPfma+Q5EbBiCNXDN5kjbIYeI4O8JU61/URmdaYUtM3xqDG6E8wOFuga79NxwQx0Chz3G0cPzSGGY5TMHX0Xe7hjc4bZm0opYQyLhuw5rzDSrBHc1Olh6czqJYpc6m/tlkadZkH0Ij1fS1gNbYKhWvjeV9pJVesFMGwmZIBWkmtctWGXPSDa9kw7m2LsNFw03VtY+OCe1BQq8hbOUBJmJ2hbjLHtQgRtQWbRGzlaFjNvRJiQCI2tB1NVIRNo4jWfBul5uDa6xFXr
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5705a9c5-88e8-447b-ee6d-08d8024e5653
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2020 14:57:55.0501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SD082XQxA2bLvkQ0b7iMHWigYpu1i3ziBgX1qSJnOCB9vJhrIw/tVf4f0EK69iNKmGE1DNq4waD512MfZUgThDq9+IO0dZ/fXdtIObfMovU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3565
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/05/2020 16:14, Hannes Reinecke wrote:=0A=
[...]=0A=
> @@ -670,8 +683,8 @@ EXPORT_SYMBOL(__scsi_device_lookup_by_target);=0A=
>  struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *sta=
rget,=0A=
>  						 u64 lun)=0A=
>  {=0A=
> -	struct scsi_device *sdev;=0A=
>  	struct Scsi_Host *shost =3D dev_to_shost(starget->dev.parent);=0A=
> +	struct scsi_device *sdev;=0A=
>  	unsigned long flags;=0A=
=0A=
This looks unrelated.=0A=
=0A=
>  =0A=
>  	spin_lock_irqsave(shost->host_lock, flags);=0A=
> @@ -701,19 +714,19 @@ EXPORT_SYMBOL(scsi_device_lookup_by_target);=0A=
>   * really want to use scsi_device_lookup instead.=0A=
>   **/=0A=
>  struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,=0A=
> -		uint channel, uint id, u64 lun)=0A=
> +		u16 channel, u16 id, u64 lun)=0A=
>  {=0A=
> +	struct scsi_target *starget;=0A=
>  	struct scsi_device *sdev;=0A=
>  =0A=
> -	list_for_each_entry(sdev, &shost->__devices, siblings) {=0A=
> -		if (sdev->sdev_state =3D=3D SDEV_DEL)=0A=
> -			continue;=0A=
> -		if (sdev->channel =3D=3D channel && sdev->id =3D=3D id &&=0A=
> -				sdev->lun =3D=3Dlun)=0A=
> -			return sdev;=0A=
> -	}=0A=
> +	starget =3D __scsi_target_lookup(shost, channel, id);=0A=
> +	if (!starget)=0A=
> +		return NULL;=0A=
> +	sdev =3D __scsi_device_lookup_by_target(starget, lun);=0A=
> +	if (sdev && sdev->sdev_state =3D=3D SDEV_DEL)=0A=
> +		sdev =3D NULL;=0A=
>  =0A=
=0A=
I think the above if is unneeded as __scsi_device_lookup_by_target() does:=
=0A=
	list_for_each_entry(sdev, &starget->devices, same_target_siblings) {=0A=
		if (sdev->sdev_state =3D=3D SDEV_DEL)=0A=
			continue;=0A=
=0A=
So 'sdev !=3D NULL && sdev->sdev_state =3D=3D SDEV_DEL' would never evaluat=
e to true,=0A=
wouldn't it?=0A=
=0A=
