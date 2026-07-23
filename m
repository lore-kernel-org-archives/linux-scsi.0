Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B1E470423;
	Thu, 23 Jul 2026 15:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784820666; cv=none; b=LxF6bqejE2TfK971e3S7vMQs0YZJJUOVA9QrKX8JY46Fvg7muuYqFZrS9l2dv0AVPsOJbAkU3/bS30eAGW9NnuJ8nwfO2dDWQY7j2iaFSJ3121l9UioiYX8O+2/0VGg9B2a88RdRNRPQG53fUROivkJhDYjrbFnsDsEPc8nztu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784820666; c=relaxed/simple;
	bh=k7EEVa/LSmr2DrsnCA1FyzLvG14ti+YnWWIfOdtQhFc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VNlGlGaKKGDG1QKfY89HlyQA0QahFL1Nmf6qoXzp7Eyi+K7EWXuGw08igpE6AJL9kpXUxO1wa1TlV8+MBm+P6WLPu+j09Qz8iO4sZTfyMirJeTpF7C7Q32gKHUmfd5i2DFZVFPv2OgeSirNNQV7677vL/vlB4CxDZ8+5SXQ71FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lc1DRpOa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lc1DRpOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F911F00A3A;
	Thu, 23 Jul 2026 15:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784820661;
	bh=HS1nLzNZUv2/7T56aK1Rl6chNkfIJi/rM6FtWKvuy7g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Lc1DRpOaoI9VrCz3a8XaiQtGrWfCYUNe826VaHnsQTvCtm94lBN3/XIQu0Ij10GmM
	 cd8FU6D08xWjXq345kzNsh7nY6q4iZwPXTEW4cd9aNBK80Bd/rhU5OtpqSN4llt7bt
	 SBNTe6pdkBRKMQavcTnEFnGMk4DdQIsQMoD8Q6HdwJ2JBy88c/aXjiGzK8xx+fjUqW
	 oXQTji0w6hcdc8RJMhWkvLoIUlMZf949nFFG12MQyL26YFgQxTBsaOUKd7zEPXwKcd
	 nK8Nn9uNgN3cURvEzSDa0TMHGMOzRl9oG6wV0t/UtNY7upqnQJ/A6IB+Md/IYyXYyH
	 Ir8ki8kyrBhpg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: storvsc: Support manual scans for all Hyper-V
 targets
Reply-To: sashiko-reviews@lists.linux.dev
To: "Laurence Oberman" <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260723151458.872265-1-loberman@redhat.com>
References: <20260723151458.872265-1-loberman@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 15:30:54 +0000
Message-Id: <20260723153101.13F911F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Low] The patch calls the unexported internal midlayer function `scsi_sca=
n_host_selected()` and includes the private header `"scsi_priv.h"` from a h=
ardware driver, which will break module builds.

Pre-existing issues:
- [High] Timeouts on targets scanned without an `fc_rport` parent will caus=
e a NULL pointer dereference in the FC transport error handler.
--

--- Patch [1]: [PATCH] scsi: storvsc: Support manual scans for all Hyper-V =
targets ---
commit ce267d7e85b7a51757a8afe1188939d3c5146d27
Author: Laurence Oberman <loberman@redhat.com>

scsi: storvsc: Support manual scans for all Hyper-V targets

This patch provides a storvsc-specific user_scan callback that directly
invokes scsi_scan_host_selected(). This bypasses the single-rport lookup
in fc_user_scan() to allow userspace to explicitly scan any target
supported by storvsc. The goal is to avoid requiring storvsc to create
and manage synthetic fc_rports for every Hyper-V target.

> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index f03dc03a42c35..eb40473a8aad6 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -43,6 +43,7 @@
>  #include <scsi/scsi_dbg.h>
>  #include <scsi/scsi_transport_fc.h>
>  #include <scsi/scsi_transport.h>
> +#include "scsi_priv.h"

[Severity: Low]
Will this cause an architectural layering violation? Including a private
midlayer header like scsi_priv.h from a low-level hardware driver normally
breaks subsystem encapsulation.

[ ... ]

> @@ -550,6 +551,17 @@ static void storvsc_host_scan(struct work_struct *wo=
rk)
>  	scsi_scan_host(host);
>  }
> =20
> +#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> +static int storvsc_user_scan(struct Scsi_Host *host,
> +			     unsigned int channel,
> +			     unsigned int id,
> +			     u64 lun)
> +{
> +	return scsi_scan_host_selected(host, channel, id, lun,
> +				       SCSI_SCAN_MANUAL);
> +}

[Severity: Low]
Does this cause a module build failure during the modpost link stage?

The function scsi_scan_host_selected() in drivers/scsi/scsi_scan.c lacks an
EXPORT_SYMBOL directive. If the kernel is configured to build storvsc as a
module (CONFIG_HYPERV_STORAGE=3Dm), it seems it will fail to link.

[Severity: High]
This is a pre-existing issue, but does creating a topology without an
fc_rport parent lead to a NULL pointer dereference during error handling?

If a SCSI command times out on a target scanned directly under the SCSI host
(which this manual scan facilitates), storvsc_eh_timed_out() delegates to
the FC transport's fc_eh_timed_out(). Because the target was scanned under
the host device instead of an fc_rport, starget_to_rport() evaluates to NUL=
L.

This NULL pointer is then unconditionally dereferenced in
drivers/scsi/scsi_transport_fc.c:fc_eh_timed_out():

fc_eh_timed_out()
{
    ...
    struct fc_rport *rport =3D starget_to_rport(scsi_target(scmd->device));

    if (rport->port_state =3D=3D FC_PORTSTATE_BLOCKED)
    ...
}

Can timeouts under hardware or network load on these targets trigger a
kernel panic?

> +#endif
> +

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723151458.8722=
65-1-loberman@redhat.com?part=3D1
