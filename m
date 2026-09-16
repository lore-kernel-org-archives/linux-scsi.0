Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1644B4854E8
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 23:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789601282; cv=none; b=naMWK0j58K8PQjenbBfAxdz41i/LXCSZ0lQdm+UGfh5Ei+d02aI5ojMsObFj1yYc7JV3XvCOVtMpzO43Kxjhxgp177gspycONPKIItFMjBDYipLOu8qa3RzMlU7yqJ/VPbnj83Lkafc2n7MLJRl/abUbR+D2kVxSZkNVzQFXAN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789601282; c=relaxed/simple;
	bh=rFNXhvg4od45RUvljp10Yd9Y6IgfFhUl7yv8fUYBj0w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CY9gCN3O61Q2SSU5BMH2xk0rybxdGz3eGBwNakVEalOFCk1CiMlt8vSvNHXcsEITH2nG1NGWDtQf8VceEh/InkO1XLYFJwhfxlVLkSuaM6vpBHO19kz3aVqrGggK7Yx1H3DuzDkJnmWD9kkvfK3JOh+rsIfNJtVR5ruuYeXYE90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l627rehV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l627rehV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F271F000FF;
	Wed, 16 Sep 2026 23:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789601280;
	bh=SkVai2OW69sbArC7l7VxnCtK1TjTxVWTRscnRW81uY4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l627rehVApGSlrISCvIopU6Y5YM6SSeZBKdVN/L2V53tMdZ4Non8YS6rWnS6QPGwd
	 qACyAagbi1g8Jbd+d3vfleXZ7/KP4DPNIpsRML6DEWMwKvC0kIa/SIA3BAYA6DR2tp
	 9zf4AyGSJTXg3TMa5MecxA4nst7O/Yfhc7BesB8YH9ZHheJ5BivKNGft7eQOdwsO3G
	 eEX29cwKrQx7eSWD/TbOEyV7GzbsIAQ+8mSynSccQqppD5XItgnErbyAkn6OSlz11e
	 QFeSE2Fy9My2mP/F8Md0w19wmD8TVhnI0til+zFC4ZECKNLTUDAeYWPp4BMQVdB4yf
	 3jXa8m1Z99Fuw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 04/20] scsi: ibmvfc: defer NVMe local port registration
 out of atomic context
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260916230921.2204729-5-tyreld@linux.ibm.com>
References: <20260916230921.2204729-1-tyreld@linux.ibm.com>
 <20260916230921.2204729-5-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 23:27:59 +0000
Message-Id: <20260916232800.67F271F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: ibmvfc: TOCTOU race in ibmvfc_do_work() clobbers asynchronou=
s host state
- [Medium] scsi: ibmvfc: do_nvme_register flag leak causes spurious registr=
ations
--

commit 93d3c68da91aa5e986f84439b6fba09a70dc93a4
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

scsi: ibmvfc: defer NVMe local port registration out of atomic context

This commit defers the NVMe local port registration to a kernel thread
context to avoid a scheduling while atomic panic. It accomplishes this
by introducing a do_nvme_register flag to indicate when registration
should occur in the ibmvfc_do_work() routine.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 26a73db662545..420ddb9584660 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -6072,6 +6072,12 @@ static void ibmvfc_do_work(struct ibmvfc_host *vho=
st)
>  			vhost->job_step(vhost);
>  		break;
>  	case IBMVFC_HOST_ACTION_QUERY:
> +		if (vhost->do_nvme_register) {
> +			vhost->do_nvme_register =3D 0;
> +			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> +			ibmvfc_nvme_register(vhost);
> +			spin_lock_irqsave(&vhost->host->host_lock, flags);
> +		}

[Severity: High]
Does dropping the host_lock here open a window for asynchronous state
changes to be clobbered?

If the SCSI error handler triggers a host reset while the lock is dropped
(changing vhost->action to IBMVFC_HOST_ACTION_LOGO), won't reacquiring
the lock and blindly continuing down the IBMVFC_HOST_ACTION_QUERY path
overwrite the reset request?

Could this lead to a wedged SCSI host by permanently stalling error
recovery?

>  		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue)
>  			ibmvfc_init_tgt(tgt, ibmvfc_tgt_query_target);
>  		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue)
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvf=
c.h
> index ca80ceffe53a5..df0775183d726 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.h
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.h
> @@ -1005,6 +1005,7 @@ struct ibmvfc_host {
>  	unsigned int nvme_enabled:1;
>  	unsigned int do_scsi_login:1;
>  	unsigned int do_nvme_login:1;
> +	unsigned int do_nvme_register:1;

[Severity: Medium]
Does this flag need to be explicitly cleared during adapter resets?

Looking at ibmvfc_reset_crq() and ibmvfc_reenable_crq_queue(), the other
state flags are cleared:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_reset_crq() {
    ...
    vhost->do_scsi_login =3D 0;
    vhost->do_nvme_login =3D 0;
    ...
}

If a reset occurs after this flag is set to 1 but before ibmvfc_do_work()
processes it, the stale flag seems to survive. Could this force a spurious
NVMe localport registration on reconnect even if the new fabric login did
not negotiate NVMe capabilities?

>  	unsigned int aborting_passthru:1;
>  	unsigned int scan_complete:1;
>  	int scan_timeout;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916230921.2204=
729-1-tyreld@linux.ibm.com?part=3D4
