Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C54F1E7C23
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784765853; cv=none; b=JWwRe945nJd4qY4RhWOl7GhdG7+LwFopck/ovoANpkPnGyuq2HStrxEHmDJfJZXOKaW2vJs/tK++43VBewSgZYEdD2Itux/6NQ3iEtiFd4G1P+pHCu+UzTwUPbtesRN5LNHAbz267el5ISwfQDF+4HUSU6o2qOyme8KNSYWq9xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784765853; c=relaxed/simple;
	bh=ZbMhiTpjouzyxdqSjb3D0UHLMtH1rcssZUySf6vO4jo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MXukZq87BjnGj6XY0I8T/7775H6YVsC5eAv/Tum/mSax/1i74DtgIIHrK9KCZejlQxOB/WMeCSeZmkdl851bDRpqPSm4VIXyZxrPyusfhkOP2uOtlNCPrpkm5sLW/ohwaEa8UKLmunxJcReSela8MmSb0ICmUr1hdf4eUhV9gCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iYS7k0Ze; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iYS7k0Ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94291F000E9;
	Thu, 23 Jul 2026 00:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784765852;
	bh=gpF2ZZY+WmozZ0tOzbAmgyrk4OnqLCKTiAfgkn1djjc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iYS7k0ZeZW8GUcjJlWIgH7UHeh0IuoIY7rUYsvLngbcZxGBprNPJfLcY0sKCZ2dm9
	 fwkvN7WZnkBiZXQYiSoF4mL5RKs3mi9NMhgtLhhurqF22E9qxDa8Y6s6qObkNZsUIN
	 2JhGcbsm/QA/J33Quu2wYnGBRcE5Lr80RQ+WDaTMvTN3sWuPax4Izv9RyfCpXcU4yF
	 kXUmvP2HpQIaRFlOKThB3bJObWahZVjOxzbq0rNXPQjMFq6JVktHalhD00EBiVNlTL
	 66DbArpd+HCxEwvMeYg6h+B8q/gnxfqrYFroRP133cyLzeev3l/eYrsV4g3OQUDF47
	 ru8Os/LM6/vaA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 13/33] ibmvfc: add helper to check NVMe/FC support
 with active channels
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-14-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-14-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:17:31 +0000
Message-Id: <20260723001731.D94291F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The patch introduces a new static function `ibmvfc_nvme_active` but=
 does not add any callers for it, resulting in a `-Wunused-function` compil=
er warning.
--

--- Patch [13]: [PATCH v2 13/33] ibmvfc: add helper to check NVMe/FC suppor=
t with active channels ---
commit b0d2f58cb79cae1f9014312c2de6b5f52ab4b38e
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: add helper to check NVMe/FC support with active channels

This commit adds a new helper function to check if NVMe over Fibre Channel
is supported and whether it has active configured queues, aiming to bypass
unnecessary NVMe target discovery when no queues are present.

> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -207,6 +207,12 @@ static int ibmvfc_check_caps(struct ibmvfc_host *vho=
st, unsigned long cap_flags)
>  	return (host_caps & cap_flags) ? 1 : 0;
>  }
> =20
> +static int ibmvfc_nvme_active(struct ibmvfc_host *vhost)

[Severity: Low]
Is this new static function used anywhere in this patch?

Adding a static function without any callers introduces a -Wunused-function
compiler warning. This can break builds that have CONFIG_WERROR enabled and
negatively impact bisectability. Should the usage of this helper be included
in this commit, or perhaps dropped if it is no longer needed?

> +{
> +	return (ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NVMEOF) &&
> +		vhost->nvme_scrqs.active_queues);
> +}
> +
>  static struct ibmvfc_fcp_cmd_iu *ibmvfc_get_fcp_iu(struct ibmvfc_host *v=
host,
>  						   struct ibmvfc_cmd *vfc_cmd)
>  {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D13
