Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C19499F2F
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 11:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790162298; cv=pass; b=GXfuKbYRxgWyGaiSQkCkIxX4o4aqZ/S9Ep2UtKH54slh/5pOLTPT4qpbKj+Neo4hVdHbbhQ4jl+c7eXunckTjtJGZO5o5btCtxXXBGWfba2D0vtXqzxQn5mj3WIIaljod79t1JkAeBkxZ/ih98PC/xZpygUkRRD2pGkkB/FO/Tc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790162298; c=relaxed/simple;
	bh=qk2sZpx9RYrwI6NuwK4VrGrXEs+u3rRuQTeWDZutfsc=;
	h=In-Reply-To:References:MIME-Version:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zhs7GAWEXA6/+brMuXJTG/LXurkaqTOfs6sxratchd+eQ0mMk4QDlQ5aabGFQvrqkPXu9LOMltT2vvIGpsSfpgKrRPRCch077PAmmAt7hlNCDbw+24qh/FxRoyfJmxSnJPB18VpB5OlQfzUtikSJUwhchP+d5YAEFYIkuu3oDqc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uvF9J53O; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uvF9J53O"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-53113d72966so195291cf.1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 04:18:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790162295; cv=none;
        d=google.com; s=arc-20260327;
        b=fDtDNhkImtHhptWnide7EiVPs/EtpIY8QttXw2zOAd3XGz4RrXrKpu0EKOnw/gUPaW
         GOzH9N9Y7t0KG0rzl8cACFzYFKhzAXt/33RNpMNriDQ1TY5px1UUTws2ROuWJTIV6gvl
         1sm7mCqhzucyiiFQqokiw++Zm1PDDEro/O7k0SN4SxTMS3fLdsyoR/z2Ep076ooMxWNT
         jtqFn+jnugiLLWGWpQEFvwxtF5qWggxPBZWfxpJpa6jJChopAjFwlsT82yXUnMyA4/D5
         uqN7VEUJ39nbxUfYSMd6PWEK9WcEybKTKUGLmJeIAvGU0BNe5SWPdW5gJcWQsFxoNBNY
         i5LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:dkim-signature;
        bh=qk2sZpx9RYrwI6NuwK4VrGrXEs+u3rRuQTeWDZutfsc=;
        fh=vU0Rx5tYYu4MrlrkHBX0npCljbCKUX0rQRdi4U2wY98=;
        b=JEL6/MDpoGrdPv1Xgk9WfqAKNt5EtuThX7jJsZ4Dknymf9gj8S/uBCSBaKFzB1elnK
         cItnDZ2BMdPynNZbTF7hIjpb8MgkLuoDU05hPcTa+fDSGeOUvuFsITJII7bWG7XKA21u
         cDso3rD/Lirmb7CZux73QY74ViDKcDGaVzTsx/uBp2Xe1M3FVuAQylKM2IuaBO7O491U
         hFrXgjnuZuto3j6dRgXAg+TsqNQxGL30FFX54zFU9Hhmbc4MzcPzCWppm+B2OB3ddIX0
         AEH9SOrJ+2WnxJsxUxOvhjN5FwDkWG9LqliYlQdlHC5I/BALmWWwgiThS648T5QTSHk5
         94MQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790162295; x=1790767095; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qk2sZpx9RYrwI6NuwK4VrGrXEs+u3rRuQTeWDZutfsc=;
        b=uvF9J53O6Uvy1FfxWq+92G0MgazCa+d0wdXeG/UtyycDKUeL7hW52bPAddMJ+TDfr/
         vK0halXhUOZ/d1annicCVyj3te3ECetY8M7NjuNF8KiLfnroipl85OsLSeO0xMEd3CIt
         c1bJFRHDpZNXbZTrjlvK4ZEQX35PzCDV5OJcSFdW8TzeQeXmsKBwnJ61QzVX/blueRLb
         Bx9jl8n0GvL9H9nDdbzcryO7YF1YMNY+XdOoy2/h4vVy1vyApuueb068++sJdOhqO6kQ
         ajjN0ki25Zd0qKpH4OCA/+qF5ibfTTWMe2s+J9PwlYbduwMTZz9e6/+LkoO+v5TVPtRk
         hhyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790162295; x=1790767095;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qk2sZpx9RYrwI6NuwK4VrGrXEs+u3rRuQTeWDZutfsc=;
        b=evXqe4VqdmPCY/UNJyg8GitEYFLIHWORAlA6QVi0tuovDVShSPqCobNZQxnFBRxKrR
         KOTCMnsPCkTuOwSnlup7Ny2kLZJG5mpFKjuVpoLuHTVl3W/3w/Uz34i++NdfUCmkFMHZ
         uGz6T1JHeEjpbaZwvwW8s4hJBTHpAs/sYFyGPZY7O03Iu2F/3uFdwdirQNsBsR1nLt15
         nB9ZC/rTS9K5XDpmr/rMHlF+qMwuBZWZARvpOwn9iSsm8hCQnHwJQ+JITDHrvtw0EMnh
         VauD8kWWoZ3nmqf8C46+0h02HzF3mfxcjdvO7r7GVnCpe7l1hb99r16y+gWtJF8BGwAc
         TUVw==
X-Gm-Message-State: AFuF++mE7XLE0meVGQ+w6H1uf/nR/feGkYPu1KJgQfzkybF+AG6Sogwp
	CV15ukPRN1mpsvv7rVzDxLau9jA82y0DUhtbvpfh5dCRcMOg15ikcjGs5O0XzFXN3q0j3EveXKu
	cah8NpkbM4+NWcymzxSs8rCzBsRE6Yeqp+ayWWY/5
X-Gm-Gg: AYBFou3SlLICUEjuxIRtlChwtGzXfF6aO/fKSzO2GGjZgUqW3l+3DfJSSNYXJspmg7+
	Qff/KF6bJX1X6GZh8fqE3PhBOhUoB2Gmrmyz1WYazHMekBcM+5vmQt1kB8hHexL+SGof4NxaOlU
	iMWrKFEgdGy2A0xxfL747w5frA/mtt0HRm3Qfh5cmV35JC4w723raoQf97MswmpGhf1EYQWKp4m
	TUyaxW2zHEhExOSIIbMI9C+ND76GJcQ0WvPgxXH37+l8CZLet+tjnpAH4mceROyMHH5YW5Ygd8e
	liS33B0qhfNyZvwOXvGrH232wTIZwYhdAsYYVGNyNLuP9Uzrkn2llwb4kQxOrYfiBpl1Xx5UpZ0
	MAEwfCR6eji3l2Fjm9g==
X-Received: by 2002:ac8:7f43:0:b0:532:ad75:e432 with SMTP id
 d75a77b69052e-532ebc71886mr13957151cf.8.1790162294906; Wed, 23 Sep 2026
 04:18:14 -0700 (PDT)
Received: from 913411032810 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 23 Sep 2026 06:18:13 -0500
Received: from 913411032810 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 23 Sep 2026 06:17:37 -0500
In-Reply-To: <f116f82d28f7af4cfca76adf5cff6093fdf393a2.camel@mediatek.com>
References: <CAE14pdek6ynze+muDZrK+yNX-3ioe3vprxOA4W22qokg352tJQ@mail.gmail.com>
	 <20260918143809.3034592-1-stanleyjhu@google.com>	 <20260918143809.3034592-3-stanleyjhu@google.com>
	 <1ddc5181-f547-465c-bfbe-dbf14a91493e@acm.org>	 <20260920135014.3528082-1-stanleyjhu@google.com>
	 <e3538f10-fb9e-48ce-b48f-bca25c8f3d6c@acm.org>	 <bab059b9a2dfed258db23993b5a6b4aceca2da49.camel@mediatek.com>
	 <df31eb82-7211-415a-9ec1-53ecbc3e39b0@acm.org> <f116f82d28f7af4cfca76adf5cff6093fdf393a2.camel@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Stanley Jhu <stanleyjhu@google.com>
Date: Wed, 23 Sep 2026 06:18:13 -0500
X-Gm-Features: AclHuK-6ho36_C1Sg9BCmEpNNLnNvOF2XVJp_zWaIWQyCkMLe1H3gFqG08qznC0
Message-ID: <CAE14pdfbxX7BWzKg9z7ytB9rZPAp40ipXk8NPOdAp2Jv7eq6Xw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Decouple CQ sweep from request
 iterator in MCQ
To: Peter Wang <peter.wang@mediatek.com>, Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, Manivannan Sadhasivam <mani@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 2026-09-23 at 14:09 +0800, Peter Wang wrote:
> SCSI reset
> (ufshcd_eh_host_reset_handler) does indeed abort all commands
> by trigger ufshcd_err_handler and call ufshcd_abort_all.
> This shouldn't violate the SCSI API contract. But whether the
> subsequent re-queue (DID_REQUEUE) violates, I haven't seen any
> prohibition?

One detail in ufshcd_err_handler(): ufshcd_eh_host_reset_handler()
sets hba->force_reset, which jumps directly to do_reset and skips
ufshcd_abort_all() (which only aborts commands when no reset is
needed).

On the reset paths, the DID_REQUEUE after ufshcd_hba_stop() does
not describe what happened to those commands. In SDB it is just
the untouched OCS_INVALID_COMMAND_STATUS placeholder from
ufshcd_prepare_req_desc_hdr() that MCQ later mirrored.

Would DID_RESET be a better fit after a controller reset (including
ufshcd_eh_timed_out() right after ufshcd_link_recovery()), similar
to mpi3mr_flush_scmd() and mpt3sas's _scsih_flush_running_cmds()?
It reports what the driver actually knows at that point without
pulling the command into the SCSI error handler.

Thanks,
Stanley
