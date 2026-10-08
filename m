Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7402C3921D6
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 18:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791485634; cv=none; b=fdQUkhswWr5VphT1alTd4MAn2AHHpxwcga4kTSQVAp1/zopqQl5LNfyRCyy5wU0J30xPavaAj3CjoGFiEbC8rpxm+BZTSFtISsDqlGyCxudTyP3ZrGCFytOLhPddiV58pSvVrVzRNwKf4XIopiUNbkenqtydPmo/dIBFQvUT8Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791485634; c=relaxed/simple;
	bh=fZYQw8+rjubIxurmSbIJIg+FkPvCN0LKgrKlFVWujvw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=oWjYMwdzuWLGlumcuSp0w82qDH77Zc7G/WE8nuGyAIpK80JTdRwQuEGbmMQtxH/8qGlvgfVMBab6N2taXrqKHGvw280yJol/Dce3P6++bNJDE0DlP6jq0lIQmLNz7rXxfuzeWMHtX3vIvcUWXf2/9YKBtiLGDmym1SGfJu5B7DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M0Xz7T3I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M0Xz7T3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB681F000FF;
	Thu,  8 Oct 2026 18:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791485633;
	bh=yEGOsY+W42NCtNfr5utssJHFEShENdaTQA9teVHxRGg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M0Xz7T3ImGm7czU05/+CHsb9Lgb7h4FRfZOI0yLU26G2nwmqEOCRfK5LvAIoHObEg
	 qeLZ+rp8ohApvbrz82NYM+yh0oAYpOPfEmgX9Yt5b5Yl4su1Tt8ZHdhSZqITkULGiK
	 4sjasrNQbf0EhVm/UfJzMJTPJIJSyQWkCBO2HlY7HtAJs2t4OpTevWodbZ+xehlcQv
	 n7KLk12BKqk4cerbVCLOfpHYBeWEqhs9GwI+prki8fskTrdbV4oitDOqV6vEW0LaCg
	 DZEohsGXy5EM1Me44y7tMaRsybFi0h+MfRwlDFCs5Ei9Omfm5tj3UtQkUGGq2jrHTZ
	 aO2/SKjJ5qSvg==
Message-ID: <sashiko-outbox-164482@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.1.y] scsi: lpfc: Fix use-after-free of mboxq in
 lpfc_sli4_driver_resource_setup()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Misiurov" <andrey.misyrov@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261008184328.2857037-1-andrey.misyrov@gmail.com>
References: <20261008184328.2857037-1-andrey.misyrov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 18:53:52 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: lpfc: Double free / UAF of mboxq on mailbox timeout in lpfc_=
get_sli4_parameters()
--

commit 7386b919d763fc6f447906aaee405cec863dac39
Author: Andrey Misiurov <andrey.misyrov@gmail.com>

scsi: lpfc: Fix use-after-free of mboxq in lpfc_sli4_driver_resource_setup()

This commit moves the mempool_free() of mboxq in=20
lpfc_sli4_driver_resource_setup() after the error handling for=20
lpfc_get_sli4_parameters() to fix a previous incorrect backport.

> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 13ebbe4a71c47..fc5a640b7f742 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -8175,7 +8175,6 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *ph=
ba)
>  			}
>  		}
>  	}
> -	mempool_free(mboxq, phba->mbox_mem_pool);
> =20
>  	lpfc_nvme_mod_param_dep(phba);
> =20

[ ... ]

> @@ -8209,6 +8208,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *ph=
ba)
>  			goto out_free_bsmbx;
>  		}
>  	}
> +	mempool_free(mboxq, phba->mbox_mem_pool);

[Severity: High]
Does this unconditionally free mboxq even when lpfc_get_sli4_parameters()
encounters a timeout?

If the mailbox command issued by lpfc_get_sli4_parameters() times out, it
returns MBX_TIMEOUT. On this path, the driver retains the mboxq and=20
delegates cleanup to the asynchronous completion handler:

drivers/scsi/lpfc/lpfc_sli.c:lpfc_sli_issue_mbox_wait() {
    ...
		} else {
			retval =3D MBX_TIMEOUT;
			pmboxq->mbox_cmpl =3D lpfc_sli_def_mbox_cmpl;
		}
    ...
}

Because mboxq is freed unconditionally here on the success path (and also
on the error goto paths above this), could this lead to a double-free and
use-after-free when the async handler later attempts to clean it up?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008184328.2857=
037-1-andrey.misyrov@gmail.com?part=3D1
