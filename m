Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D723F4DD5
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 12:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781182061; cv=none; b=MGu34061g2DLs3G+v9krzxx/Gj1YOR9oWBdtfSNIx3VneahhCWSCsBefCF4JgQpsLyDyhsN3Fs9+VUQjM8zGAt7q6E8iXIupIj3bGw3mmJ5B5z7ym9pFGyYnUmyowUDzVOq+WhS/TrJrLw7HU9MOsov4GIlyPlvdZ7UlAY+A8Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781182061; c=relaxed/simple;
	bh=r0yn3DB1+8j0onFTFRzTc1O9AI+e42OxgKmT8q2BiaQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oCadGQjsP+g6DEvxd1e4+lLI8fhVaiKZhR6Yvq/by3E4tjCubsWRRrCnnzVeF9+GR+1d122zsxx/6jK5Raxtks2ESUTSg7YqQVPAMnCvmh2KU1yYeRvwDQ79jV3bYH2kli3F7Dbv56tzUP+qT9+7PEV8OtnxA4kLTUNm4BNHhs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PgD12Hff; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PgD12Hff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9DE1F00893;
	Thu, 11 Jun 2026 12:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781182060;
	bh=/3riDP+lCvPsxBREuEDn5aNGehBXwZ4sJuhaEVDM0YA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PgD12HffQcvgMEee0EhF+zVOk3y3c41rBzgCRBSDgXspykZR8l/7SrdLvNUwZfgre
	 G4NU64I11B6MuWUMGtDCIma70HU3FcSNf9Yi/WvWzqBgANw2hKnduBKUg0leslf83d
	 beylpIAqjGMaAAOWlnGjV1pQzauMW7UCrWNVYSyU+D6Je4BLwgsIqYdzaks8NSdsJc
	 CwkxI7LGssOALYpNYtepFmtD+KQvrhedwc2YHdcEWrx72MJN2Bha+RTKUQbzuXt+SS
	 GRWSafjVQ7x/FT9Ft8BkkbIscrx5sV6JHCHuUhrdUv3tg1o/binJ/5kANBy5r6KIPK
	 rkwrXGrGBDx5w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] xen/scsiback: free the command tag on the TMR
 submit-failure path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Bommarito" <michael.bommarito@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260611123046.2323342-3-michael.bommarito@gmail.com>
References: <20260611123046.2323342-3-michael.bommarito@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 11 Jun 2026 12:47:38 +0000
Message-Id: <20260611124739.5C9DE1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] The return value of target_init_cmd() is ignored in scsiback_c=
md_exec(), leading to a percpu_ref underflow, kref underflow, and use-after=
-free if the session is shutting down.
- [High] Callers of target_submit_tmr() in other fabric drivers uncondition=
ally dereference the se_tmr_req pointer on the error path, leading to a UAF=
 or NULL pointer dereference.
--

commit 0671b280117e9d31e5e4fbe8dc07f0a60a155bfb
Author: Michael Bommarito <michael.bommarito@gmail.com>

xen/scsiback: free the command tag on the TMR submit-failure path

This commit addresses a tag leak on the task-management request submit
failure path in scsiback_device_action(). When target_submit_tmr() returns
an error, the code now properly frees the tag by calling
scsiback_resp_and_free().

> diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
> index f324732eba7f8..c7036e0e41bda 100644
> --- a/drivers/xen/xen-scsiback.c
> +++ b/drivers/xen/xen-scsiback.c
> @@ -658,7 +658,7 @@ static void scsiback_device_action(struct vscsibk_pen=
d *pending_req,
>  	return;
> =20
>  err:
> -	scsiback_do_resp_with_sense(NULL, err, 0, pending_req);
> +	scsiback_resp_and_free(pending_req, err);

[Severity: High]
This isn't a bug introduced by this patch, but since we are fixing error
paths for target_submit_tmr() failures here, does this same issue affect
other fabric drivers?

When target_submit_tmr() returns an error, the se_tmr_req pointer is either
left dangling or remains unallocated. However, looking at
srpt_handle_tsk_mgmt() in drivers/infiniband/ulp/srpt/ib_srpt.c, the error
path unconditionally writes to it:

    rc =3D target_submit_tmr(&send_ioctx->cmd, ...);
    if (rc !=3D 0) {
        send_ioctx->cmd.se_tmr_req->response =3D TMR_FUNCTION_REJECTED;
        cmd->se_tfo->queue_tm_rsp(cmd);
    }

The same pattern exists in drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c in
ibmvscsis_parse_task():

    rc =3D target_submit_tmr(&cmd->se_cmd, ...);
    if (rc) {
        cmd->se_cmd.se_tmr_req->response =3D TMR_FUNCTION_REJECTED;
        ...
    }

Could this lead to a use-after-free or null pointer dereference in those
drivers under similar error conditions?

[Severity: Critical]
This is a pre-existing issue, but while looking at command handling in this
file, I noticed a potential problem in scsiback_cmd_exec().

The code calls target_init_cmd() but ignores its return value:

    target_init_cmd(se_cmd, sess, pending_req->sense_buffer,
                    pending_req->v2p->lun, pending_req->data_len, 0,
                    pending_req->sc_data_direction, TARGET_SCF_ACK_KREF);

    if (target_submit_prep(se_cmd, pending_req->cmnd, pending_req->sgl, ...=
))
        return;

    target_submit(se_cmd);

If target_init_cmd() fails, which happens when target_get_sess_cmd()
fails during session teardown, the session's cmd_cnt->refcnt
is never incremented, and cmd_kref is reverted to 1 instead of 2.

Because scsiback_cmd_exec() blindly proceeds to map scatter-gather lists
and submit the command, could this cause a percpu_ref underflow when
scsiback_cmd_done() and transport_generic_free_cmd() both call
target_put_sess_cmd() upon completion?

This would drop cmd_kref to 0 prematurely, triggering
target_release_cmd_kref() and unconditionally invoking percpu_ref_put(),
potentially leading to a kref underflow and use-after-free of the session.

>  }
> =20
>  /*

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260611123046.2323=
342-1-michael.bommarito@gmail.com?part=3D2
