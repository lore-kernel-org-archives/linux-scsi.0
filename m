Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3323A3D47BB
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781264051; cv=none; b=jM2MCXGQ++9u7EYa+GdsThr7oi6cPkRciX+O353R0PFUTtE4rFthM7C0P1AatjvqZR5kQCT2CdVj/+uI678u0SRxnyXj6juF18sd1hqxp92VDvh2MyY5HEuEcI0nmh/2eLK7FFLcfRT+uJOheVHQ6XKtjh7QauYsr+Gzq43IfMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781264051; c=relaxed/simple;
	bh=P2+0QX3/bc36qw9+sbZ1xUaLEuFJTiM5NoCslb37JrA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r20qBfV9TA3QnnAHRiGbEhDENxutJn7QI9V/hesSUuE9CJR9eJnfdcMyKaqyozi5yZeUSoW15ihzENSQzZqs4S8erPDUQXhZOiWcDkWHMGibNZRcsQxc8078xX5u0P8Js0NT91Wx/nLifDIgOe08gvrFOjCrk1/O2Jq4YWz6WzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H39B3xk/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H39B3xk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2A11F000E9;
	Fri, 12 Jun 2026 11:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781264046;
	bh=Tq42IaVBNS3J/IlDmk/yuwE2jVxsRWnBZD0RNXv5hYY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H39B3xk/IHnqfmNZuognNJXEm7yADgM/uwj8Gg34RUUVWy8XAU+HtRHcIBGBqh8qz
	 i6aGSTOXPc73vZFL3lbi/2yH6eGCdKsP9xaMD6WaoTZSlX/ox/anzRE7r+1PFOcctX
	 BUj3a9oozvedbA4NZGuwmCJHs9pEHv5LTBTWAPdz/8N7I6y3dBqwGdXa+CQ/2AaOJ9
	 xoCKuZWc+MwnGMEeeUoPIs5LYjDYailE8sQzhj0g+Jv+Y4LCbg3HjN6uDs+FA4/qKS
	 R/z5k0r1dNKKmdwd1BWTJ2U+M8Nt7hN1N5lHD+R9KAQJdGODFNWPkw7ebyZEubVZVn
	 oMnXOxsIZJWwQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 56/60] scsi: qla2xxx: Initialize NVMe abort_work once
 at submission
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-57-njavali@marvell.com>
References: <20260612095333.1666592-57-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 11:34:05 +0000
Message-Id: <20260612113406.6D2A11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Unbalanced kref increment when schedule_work() returns false, lead=
ing to a permanent command resource leak and NVMe FC transport hang.
--

commit d400422c8159891ac0e43b19f4d841502d8f3491
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Initialize NVMe abort_work once at submission

This commit initializes NVMe abort_work once at command submission
instead of immediately before schedule_work(). This prevents workqueue
corruption when an abort is issued multiple times for the same command.

> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 0038b6274d444..3b2f255a5d7d4 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -463,7 +463,6 @@ static void qla_nvme_ls_abort(struct nvme_fc_local_po=
rt *lport,
>  	}
>  	spin_unlock_irqrestore(&priv->cmd_lock, flags);
> =20
> -	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
>  	schedule_work(&priv->abort_work);

[Severity: High]
Does this code leak the kref when schedule_work() returns false?

Because INIT_WORK() was removed, schedule_work() will now correctly return
false if the work item is already pending (for instance, during concurrent
aborts).

However, qla_nvme_ls_abort() calls kref_get_unless_zero(&priv->sp->cmd_kref)
before schedule_work(). If schedule_work() returns false, the work function
qla_nvme_abort_work() will only execute once and therefore call kref_put()
only once.=20

Doesn't this leave the extra kref leaked, preventing the command from ever
completing and potentially hanging the NVMe FC transport?

[ ... ]

> @@ -545,7 +545,6 @@ static void qla_nvme_fcp_abort(struct nvme_fc_local_p=
ort *lport,
>  	}
>  	spin_unlock_irqrestore(&priv->cmd_lock, flags);
> =20
> -	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
>  	schedule_work(&priv->abort_work);

[Severity: High]
Similarly in qla_nvme_fcp_abort(), does this code also leak the kref if
schedule_work() returns false?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D56
