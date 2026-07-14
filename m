Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3E126B973
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 00:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783990230; cv=none; b=l5PsmkCxF2O4UM8lqPjbAIeLoAmAMCymJTluckrxlWpHJxp8Vm82srTNWi/nP2gKuvpWj9BOwUD5oigvWcT9GLz1mvRG7FpaIz017FtOWq68XPNz/xyUddMYmNv8Vsg2y39AHy6g3GuAWPUGHd/NQ71HZGEej4G1jZFD0ehjCLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783990230; c=relaxed/simple;
	bh=UN8xvMKmg9igDVqcgc36F9krbjPMAevqlOjfNt0MA5A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=U55v7QAj3bkmB4kJsqoFiCLNae0DUdLSHoKf1U1sFK6Q4LK5Zz/il51KeIS3KfDLfzbleSHf9ZZEQUQrVP8bt5eDJlXKoQDHIXnp7vpGIr1PnhO3CsNLPhr9eJIbJ4nC+xEPeF/9LQqYnB5Y6dj6v5EBvimURo2N445Zyf+MzNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FczcjBC/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FczcjBC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21F71F000E9;
	Tue, 14 Jul 2026 00:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783990228;
	bh=KHeiczKj1rkTLwyLiYaIMjtY5wPnrLdk0wFfUPXAgoo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FczcjBC/x4f3CuL04sfduwryaPeVyOkzxmp68tSFsm/1/MnWD7YBFtKumgRdcrURX
	 Pmq8zzPottZfDL5S1HTwaAldZiI5n7Kv+BgWEvWRy58FRHa2HPBPEjOURr+QyFwx3O
	 B8PNVNOlQwKJIHdoQqfSrbzrCrOMss4H3/nfw1Hd33wCBJRX3ap0JvW7gMJX75seUS
	 WNI5m0dvAlqngTX0MyNj1SmHk/gDCIHDgkl29SLej3iaPXnMJHz+0FOGzz1I48oTy/
	 3RHGI5EleX3YfmKgx5GXqDTcX/3fH5qCPR62e/xwbwvGLdAoFzPR2ZE+yGDbxlvh72
	 yY+Fz7WOSrIUQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 11/14] lpfc: Put iocbq on phba->txq when ELS WQ is
 full or ELS SGL unavailable
Reply-To: sashiko-reviews@lists.linux.dev
To: "Justin Tee" <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714011812.106753-12-justintee8345@gmail.com>
References: <20260714011812.106753-1-justintee8345@gmail.com>
 <20260714011812.106753-12-justintee8345@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 00:50:28 +0000
Message-Id: <20260714005028.A21F71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Incomplete refactoring of __lpfc_sli_issue_iocb_s4 return codes ca=
uses unpatched callers to leak IOCBs.
- [High] Early returns on IOCB_FAILED_PUT in patched callers bypass critica=
l state machine updates and counter increments.
- [Medium] The logic in lpfc_drain_txq to queue an IOCB to the head of the =
txq when the SGL pool is empty is dead code.
--

--- Patch [11]: [PATCH v3 11/14] lpfc: Put iocbq on phba->txq when ELS WQ i=
s full or ELS SGL unavailable ---
commit e664b47bccd196f6d682ce56b8b0fe9c32e4c4a8
Author: Justin Tee <justintee8345@gmail.com>

lpfc: Put iocbq on phba->txq when ELS WQ is full or ELS SGL unavailable

When ELS/CT commands can't be sent due to ELS WQ full, queue the iocbq on
the phba->txq tail for retrying submission later in lpfc_drain_txq.
lpfc_drain_txq is also updated to queue an iocbq back on to the head of
phba->txq when observing ELS WQ full or SGL unavailable events.

> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -2766,7 +2780,21 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, stru=
ct lpfc_nodelist *ndlp,
>  	}
> =20
>  	rc =3D lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
> -	if (rc =3D=3D IOCB_ERROR) {
> +	if (rc) {
> +		lpfc_vlog_msg(vport, KERN_NOTICE,
> +			      LOG_ELS | LOG_DISCOVERY | LOG_NODE,
> +			      "0155 PRLI WQE Put returned %d\n",
> +			      rc);
> +
> +		/* Under heavy vpi counts, the driver's host_index can catch up
> +		 * to the hba_index causing a put error. Catch this case and
> +		 * put the IO on phba->txq.
> +		 */
> +		if (rc =3D=3D IOCB_FAILED_PUT && phba->sli_rev =3D=3D LPFC_SLI_REV4) {
> +			lpfc_sli4_queue_io_for_retry(phba, elsiocb, false);
> +			return 0;
> +		}

[Severity: High]
Does this early return bypass state machine updates?

By returning 0 here, the function skips setting the NLP_PRLI_SND flag,
incrementing the outstanding PRLI counters (vport->fc_prli_sent and
ndlp->fc4_prli_sent), and looping to send the NVMe PRLI.

When the retried IO eventually completes, the completion handler could decr=
ement
counters that were never incremented, potentially causing an integer underf=
low
that breaks lpfc_scan_finished(). Also, it appears the second PRLI for NVMe
targets would never be sent.

> +
>  		lpfc_els_free_iocb(phba, elsiocb);
>  		lpfc_nlp_put(ndlp);
>  		return 1;
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -10793,12 +10839,18 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba,=
 uint32_t ring_number,
>  			return IOCB_ERROR;
>  	}
> =20
> -	if (lpfc_sli4_wq_put(wq, wqe))
> -		return IOCB_ERROR;
> + retry_io:
> +	piocb->cmd_flag &=3D ~LPFC_IO_IN_RETRY;
> =20
> -	lpfc_sli_ringtxcmpl_put(phba, pring, piocb);
> +	/* Push the wqe to the wq.  If the push fails with -EBUSY it means
> +	 * the WQ is full.  Pass this status back to enable a retry.
> +	 */
> +	rc =3D lpfc_sli4_wq_put(wq, wqe);
> +	if (rc =3D=3D -EBUSY)
> +		return IOCB_FAILED_PUT;
> =20
> -	return 0;
> +	lpfc_sli_ringtxcmpl_put(phba, pring, piocb);
> +	return rc;
>  }

[Severity: High]
Will unpatched callers leak resources by treating IOCB_FAILED_PUT as succes=
s?

Several existing ELS/CT callers, such as lpfc_issue_els_logo() and
lpfc_issue_els_adisc(), explicitly check if the return value is exactly
IOCB_ERROR:

drivers/scsi/lpfc/lpfc_els.c:lpfc_issue_els_logo() {
	...
	rc =3D lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
	if (rc =3D=3D IOCB_ERROR) {
		lpfc_els_free_iocb(phba, elsiocb);
		...
	}
	...
}

Because IOCB_FAILED_PUT (7) is not equal to IOCB_ERROR (1), these functions
might treat the failure as a successful submission. Could this cause the dr=
iver
to permanently leak the IOCB buffer/SGL/DMA mappings and hang the ELS state
machine?

> @@ -21277,7 +21329,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
> =20
>  		ret =3D __lpfc_sli_issue_iocb(phba, pring->ringno, piocbq, 0);

[ ... ]

> +		if (txq_cnt =3D=3D 0 || ret =3D=3D IOCB_BUSY ||
> +		    ret =3D=3D IOCB_FAILED_PUT) {
> +			/* If ELS WQ was full (IOCB_FAILED_PUT), then an SGL has
> +			 * been assigned.  If SGL pool was empty (IOCB_BUSY),
> +			 * then all we need is to put back on phba->txq to try
> +			 * again later.
> +			 */

[ ... ]

> +			switch (ret) {
> +			case IOCB_FAILED_PUT:
> +				piocbq->cmd_flag |=3D LPFC_IO_IN_RETRY;
> +				__lpfc_sli_ringtx_put(phba, pring, piocbq,
> +						      true);
> +				break;
> +			case IOCB_BUSY:
> +				__lpfc_sli_ringtx_put(phba, pring, piocbq,
> +						      true);
> +				break;

[Severity: Medium]
Is this IOCB_BUSY case dead code?

The call to __lpfc_sli_issue_iocb() above passes 0 for the flag argument.
If an SGLQ cannot be allocated, __lpfc_sli_issue_iocb_s4() evaluates:

	if (!(flag & SLI_IOCB_RET_IOCB)) {
		__lpfc_sli_ringtx_put(phba, pring, piocb, false);
		return IOCB_SUCCESS;
	} else {
		return IOCB_BUSY;
	}

Since flag is 0, it silently requeues the IO to the tail of txq and returns
IOCB_SUCCESS (0). Therefore, lpfc_drain_txq() would never receive IOCB_BUSY,
and the intended optimization to queue the IOCB to the head when the SGL po=
ol
is empty would be bypassed.

> +			}
> +			spin_unlock_irqrestore(&pring->ring_lock, iflags);
>  			break;
> +		}
> +
> +		spin_unlock_irqrestore(&pring->ring_lock, iflags);
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714011812.1067=
53-1-justintee8345@gmail.com?part=3D11
