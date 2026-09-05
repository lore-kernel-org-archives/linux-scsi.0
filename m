Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8C52D94B5;
	Sat,  5 Sep 2026 03:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579470; cv=none; b=aWOHblboe0BypYketE1uFZJuRQTQEMNUWkCqZyfy0QVS/9Cn4ZrMecHnzM3nbN2lAW/OddY/Phvt5gwPU7QZykbjaqvtHJnPk8W2mG3L5HBrsAMHwWnu6d+jO3NWBN4MRtrnys+f1KFtYoeGDh/e5kWpeTT1bfA0lRirTip04fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579470; c=relaxed/simple;
	bh=Wi0Nk5BqqzfdBMCy3XDN1buKJ7w5kBS7xhB9p2dc7Js=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fbao5t6xOuoQ7Aehr/j/wBJzTjfb11gPLJGDLD+Oz3wCc0EsxnP567u5IzsXG1us9VRCZGM3Kjtl7xEREUp6MkAK/UUXXx7T5WCrOyJiuhrNUsWscwRx6PS3olrzlR7d4Qm8NVKgoHPHGedorZ/igPXRBt6x3VYLMew7o0jf44s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K3bgTCA1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K3bgTCA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DDD1F00A3D;
	Sat,  5 Sep 2026 03:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579468;
	bh=xqR41W9j5tBGjQWTGFXAIKDfw6DymEl7tt1zse8DbHQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K3bgTCA13HlPsV7TGDGEReVhgfRABgqS8t1ha0Y8tn0oU7JM2pEmBbYXdiW8snmil
	 0yZOOTVr8mAYmhp1Nmlm8BRrL9FKCHu/r/2sQ9WwzN/9OLLtzEfKVvrEvL4tMfXCQW
	 3lx+/UTWQilmgL4eC4ow8+j8usD1waUAu1gkRlKBLzF59P63r39A2JQz2EiTbtb9mD
	 9xS0/WFGhvnnr+zJj56WEAVwEPiz2mzovxzuSnAdA2qyrs+UVGlt8Pghc006ksODPU
	 tczGON4Z/lnwqE/WGI+E8jdlCBIGtMqWtWybDw6uJ0GDnt/qwzA+w62QKSxW+ey60s
	 wRmHAeX5fO7Wg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 22/40] scsi: myrX: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org
In-Reply-To: <20260905032224.509860-23-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-23-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:37:47 +0000
Message-Id: <20260905033748.38DDD1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the missing scsi=
_done() call for emulated REQUEST_SENSE commands causes a command timeout.
--

commit f3ff7cfa5745e4930586f17ede3cb83961872a54
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: myrX: use 16-bits defined sense codes

Refactor the Mylex RAID controller driver to use scsi_set_sense() and the
16-bits sense_code field of struct scsi_sense_hdr and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

> diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
> index 3678b66310ed0..e7d796add9864 100644
> --- a/drivers/scsi/myrb.c
> +++ b/drivers/scsi/myrb.c

[ ... ]

> @@ -1493,8 +1495,8 @@ static enum scsi_qc_status myrb_ldev_queuecommand(s=
truct Scsi_Host *shost,
>  		return 0;

[Severity: High]
This isn't a bug introduced by this patch, but is the REQUEST_SENSE
case in myrb_ldev_queuecommand() missing a call to scsi_done() before
returning?

Looking at the preceding lines in myrb_ldev_queuecommand():

	case REQUEST_SENSE:
		myrb_request_sense(cb, scmd);
		scmd->result =3D (DID_OK << 16);
		return 0;

It appears the SCSI command never completes. Without calling scsi_done(),
wouldn't the command time out and trigger SCSI error handler escalation?

Could this allow a user issuing a REQUEST_SENSE command via the SG_IO
ioctl to cause a local denial of service via adapter reset?

>  	case SEND_DIAGNOSTIC:
>  		if (scmd->cmnd[1] !=3D 0x04) {
> -			/* Illegal request, invalid field in CDB */
> -			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
> +			scsi_set_sense(scmd, 0, ILLEGAL_REQUEST,
> +				       INVALID_FIELD_IN_CDB);
>  		} else {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D22
