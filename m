Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35714A43F0
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 22:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789683662; cv=none; b=fGuQPy4k3yhPAcWrksKnnsesh+et4tmmCAjmiOu7+31+H2ISUdDO2v16aBZ2oHi0pDfnHWnAssypyTZXnyV+6UNpoZGTelp3Qy3FUhUK4C+KQfPTps37sjo4d3OTpBGowK2BTGNhH4k3QSEYkeL9l/F0w1qkoVwQyNNi/OnLeu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789683662; c=relaxed/simple;
	bh=VKJ4bjDGSb5MIlpGUAtbnYAZVDwEyLMfSg8HsFWK3w0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hLSzOMDKMcCztCiod38AR77I0Qa7nqPfYzUFQQckP0o4Eh7Fusf4MrerNoOxWk6GCf8AuWWw6VedERyUKqafWntYvCSEYiXd9X6d1IcQ0s20ch6sJIVcv/P7xkZkCCkM/2Lm6bP84eK8ckkfIvCYCi9Nso/+Iu4ZJCckbh/mZRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=edja3S+N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="edja3S+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABEB1F000FF;
	Thu, 17 Sep 2026 22:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789683660;
	bh=mzSrjEojcG5lae/9bgd2Z8U48LXLw5EI3A42C78T7V0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=edja3S+NlkbJKd/PQpIMli71GAbAK+cWlRYlmjR+4EvZXwSHhSqpR0VjPXp9eitHy
	 /3tIzHdBqMz8eARsL1uboABuD27Rs3lYqeP/fhH5fh2GPCWjjsugj9J9Zj+UG2CmUY
	 M9h/5qTjD2Xu8C6tInIcjR57PdMTLX+QMQoY2ocEP0fc9JbDUU3x5GNQt/70sOyRK/
	 Djgrt6qvKF5XnrAL87wFdHZCMmx6Fa/x0tnPCMOSIiaEHMuHnjrG3q+PSkvg8Me4jx
	 DDce2chL6M1Mjp/Cqo0ODflXvPX6Q7f0Wo9yHfPJlAFy44MIe/sfsowTeTNYpQzv4u
	 gM2sU+w2+Z+FQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 10/14] lpfc: Remove slowpath cqe process limiter in
 slow ring event handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nigel Kirkland" <nkirkland2304@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260917222015.61053-11-nkirkland2304@gmail.com>
References: <20260917222015.61053-1-nkirkland2304@gmail.com>
 <20260917222015.61053-11-nkirkland2304@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 22:20:59 +0000
Message-Id: <20260917222100.5ABEB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: lpfc: CPU soft lockup in lpfc_sli_handle_slow_ring_event_s4()
--

commit 2c325e87e41c5052e2704f826b9f808f153d5397
Author: Nigel Kirkland <nkirkland2304@gmail.com>

lpfc: Remove slowpath cqe process limiter in slow ring event handler

This commit removes the 64 CQE limit in the slow path event handler
to ensure the slow path CQ is drained completely. It also adds logging=20
when the CQE count reaches a full ELS WQ wrap.

> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 10d9030a1e883..06dc01c9539ed 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c

[ ... ]

> @@ -4562,22 +4562,39 @@ lpfc_sli_handle_slow_ring_event_s4(struct lpfc_hb=
a *phba,
>  			if (irspiocbq)
>  				lpfc_sli_sp_handle_rspiocb(phba, pring,
>  							   irspiocbq);
> -			count++;
>  			break;
>  		case CQE_CODE_RECEIVE:
>  		case CQE_CODE_RECEIVE_V1:
>  			dmabuf =3D container_of(cq_event, struct hbq_dmabuf,
>  					      cq_event);
>  			lpfc_sli4_handle_received_buffer(phba, dmabuf);
> -			count++;
>  			break;
>  		default:
> +			lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> +					"7771 Unknown WCQE completion code "
> +					"x%x, ignoring.\n",
> +					bf_get(lpfc_wcqe_c_code,
> +					       &cq_event->cqe.wcqe_cmpl));
>  			break;
>  		}
> =20
> -		/* Limit the number of events to 64 to avoid soft lockups */
> -		if (count =3D=3D 64)
> -			break;

[Severity: High]
Could removing this limit cause a CPU soft lockup under certain failure
conditions?

When an MDS loopback or unsolicited data frame is received (CQE_CODE_RECEIV=
E),
and the driver's IOCBQ pool is momentarily empty,
lpfc_sli4_handle_mds_loopback() fails to allocate an iocbq via
lpfc_sli_get_iocbq() and adds the event back to the sp_queue_event list:

lpfc_sli4_handle_mds_loopback() {
    ...
    list_add_tail(&dmabuf->cq_event.list,
                  &phba->sli4_hba.sp_queue_event);
    ...
}

Since this patch removes the 64-iteration limit, this while loop no
longer yields. It will immediately dequeue the same event and retry the
allocation in a tight spin loop. Without the loop break, the worker
thread can no longer reach wait_event_interruptible() to yield the CPU,
resulting in a 100% CPU lockup.

Is there another mechanism to prevent the loop from spinning infinitely=20
when events are requeued?

> +		/* This loop runs until the ELS/CT CQ is empty.  Post a one
> +		 * time message for debug support when ELS WQ ecount
> +		 * completions are processed - this represent 1 full ELS WQ
> +		 * wrap.
> +		 */
> +		if (++count =3D=3D LPFC_WQE_DEF_COUNT) {
> +			lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> +					"7772 %s SP CQE count %d\n",
> +					__func__, count);
> +		}
> +	}
> +
> +	/* Log a final message to note how many CQEs were processed. */
> +	if (count > LPFC_WQE_DEF_COUNT) {
> +		lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
> +				"7773 %s SP CQEs complete, count %d\n",
> +				__func__, count);
>  	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917222015.6105=
3-1-nkirkland2304@gmail.com?part=3D10
