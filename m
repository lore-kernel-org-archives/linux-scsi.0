Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375F975801
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784766145; cv=none; b=nAjw83S4QFZiBlkyFaBCoadLc3+4xTnHpH16tA1YKKvZmiwGV1QyoJZBG3ikOjgOifWjnsPtIrDBf8zC5XjUJiMiilPLr3GNW7bkO8guRCSJNkIUxVp904PoRcmx+0W1WUl81sQQ0AIPtj0fiAQ9kajrIXA+f8/2oFjX8lIdEks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784766145; c=relaxed/simple;
	bh=pwhtheE34hQuSoKofa9xczDxPblpXvIXuqAK0akW65c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rTSSoNX0GbktE9Xlp7hC+Fij3qt2dVWkZ83hIy7fM8HOQLv2xPwjmhOSLjcv71w6MxL8KKT6oM4H9aeUumTAJC2Jh27RmEO9kptDVxEvogJOlBM8GL9zLacTgt2ZGHr0iniKcUp93yhpFs0ukIW7F4dLMAuxVi5TaIJP1iiIIXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c8IuSHdO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c8IuSHdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61401F000E9;
	Thu, 23 Jul 2026 00:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784766143;
	bh=HjIiJTP2LCkW3GTEdSS0M9NIm9ol8W8vWtI+17Hy6Mk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c8IuSHdO0Jc6x693/2OXZu/aDsstOOzvLXXiVC0z8JJ2odUoEuTHzZfHscjLKq861
	 QWX068CWl6ulX9KRFnMFg3Fj8QH2LAHybOLow4IzB2sgObjDX8D5/mGu77tv2MCXKL
	 KgsPNlLDycDJYbXk9NP0pVTcdnD96bJcUqQ4NuxYWxiQqJXLGiDKiVyvypWLmKBLqr
	 h14Qjdy4tYcC/XclNnbfTZoDu5iKcvKnw/SwRe/z0whas+OVIgx++194iN87TSsm97
	 QWnvITdO60AsfcdgiKM6faSQVC7jyscEKKgGAr+yFdVp8oFXReJqufKefGee5qPCx6
	 z6ZPrx2pYU0dQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 07/33] ibmvfc: split NVMe support into separate
 source file and add transport stubs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-8-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-8-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:22:23 +0000
Message-Id: <20260723002223.B61401F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Uninitialized pointer dereference in `ibmvfc_send_event` error=
 handling for SCSI Task Management Functions (TMFs).
- [Low] The static variable `ibmvfc_nvme_fc_transport` is defined but never=
 used, triggering a `-Wunused-variable` compiler warning.
--

--- Patch [7]: [PATCH v2 07/33] ibmvfc: split NVMe support into separate so=
urce file and add transport stubs ---
commit 98e0f82a0d3f6f97d6d1d88906eb468378039a58
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: split NVMe support into separate source file and add transport stubs

This patch renames ibmvfc.c to ibmvfc-core.c to begin decoupling protocols
from the core driver logic. It also introduces ibmvfc-nvme.c and
ibmvfc-nvme.h with empty callback stubs and an nvme_fc_port_template. No
functional NVMe/FC support is enabled yet.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c-core.c
> similarity index 99%
> rename from drivers/scsi/ibmvscsi/ibmvfc.c
> rename to drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

Looking at ibmvfc_send_event() in the newly renamed ibmvfc-core.c:

        } else {
                evt->xfer_iu->mad_common.status =3D cpu_to_be16(IBMVFC_MAD_=
CRQ_ERROR);
                evt->done =3D evt->_done;
        }

        evt->done(evt);

[Severity: Critical]
Could the error path here overwrite a properly initialized done callback wi=
th
an uninitialized _done callback?

If ibmvfc_send_event() encounters an error sending a SCSI Task Management
Function (TMF) command (where rc !=3D H_CLOSED and rc !=3D 0), this else br=
anch
is taken because TMFs are initialized with a NULL evt->cmnd.

Since IBMVFC_CMD_FORMAT does not initialize evt->_done in ibmvfc_init_event=
(),
can this copy an uninitialized or stale pointer into evt->done and immediat=
ely
execute it?

TMF operations like Abort Task Set or Target Reset are typically triggered
during SCSI error recovery, so this might lead to a wild function pointer
dereference under SAN error conditions.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/=
ibmvfc-nvme.c
> new file mode 100644
> index 0000000000000..2ee1c64665d9c
> --- /dev/null
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c

[ ... ]

> +static void ibmvfc_nvme_fcp_abort(struct nvme_fc_local_port *lport,
> +				  struct nvme_fc_remote_port *rport,
> +				  void *hw_queue_handle,
> +				  struct nvmefc_fcp_req *abort_req)
> +{
> +}
> +
> +static struct nvme_fc_port_template ibmvfc_nvme_fc_transport =3D {
> +	.localport_delete	=3D ibmvfc_nvme_localport_delete,
> +	.remoteport_delete	=3D ibmvfc_nvme_remoteport_delete,
> +	.create_queue		=3D NULL,
> +	.delete_queue		=3D NULL,
> +	.ls_req			=3D ibmvfc_nvme_ls_req,
> +	.ls_abort		=3D ibmvfc_nvme_ls_abort,
> +	.fcp_io			=3D ibmvfc_nvme_fcp_io,
> +	.fcp_abort		=3D ibmvfc_nvme_fcp_abort,
> +	.map_queues		=3D NULL,
> +	.max_hw_queues		=3D IBMVFC_NVME_HW_QUEUES,
> +	.max_sgl_segments	=3D 1024,
> +	.max_dif_sgl_segments	=3D 64,
> +	.dma_boundary		=3D 0xFFFFFFFF,
> +	.local_priv_sz		=3D sizeof(struct ibmvfc_host *),
> +	.remote_priv_sz		=3D sizeof(struct ibmvfc_target *),
> +	.lsrqst_priv_sz		=3D sizeof(struct ibmvfc_event *),
> +	.fcprqst_priv_sz	=3D sizeof(struct ibmvfc_event *),
> +};

[Severity: Low]
Is this static struct unused?

It appears ibmvfc_nvme_fc_transport is defined here but never referenced
anywhere in the file, which might trigger a compiler warning for an unused
variable.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D7
