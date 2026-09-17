Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947E42FFF89
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 01:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789607965; cv=none; b=FDm8P9Y+YLfgBEt/8v6o+ie1TYGFCg+OKslOtD4fUr4b0gu5hmkPAHCjQ4un6eN0MCahQOdAuEcm8tcTSjNp6C+D7FtG+c+YYrlsArLuCCOfg5MH7FDZSuJ3EHn6IztnpFp5S9BBHxtiqI9iLuwGhORH+SFNbGwE7J3tAdXS7pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789607965; c=relaxed/simple;
	bh=8PR57m17k8g/hbwemCfPS71tANZEucnppZ2zp5rHRdM=;
	h=MIME-Version:In-Reply-To:References:Message-ID:Date:Subject:From:
	 To:Cc:Content-Type; b=dzb04Aarv1krQ9hheSvV6l3hjI2WBCq8Kp4o3AA1ITm6lOGIBCaumssA+FcyQeNs3rUGni/tCFaxleJISJhTsEHydRDyo2Q7/muU5rAD8m2UGRZ04gudwjnSGxHiwE8amarc8eyjuU8SevUAam1bmm9Scq5gGc0GEiK62ms9ygA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tp0BSybk; arc=none smtp.client-ip=209.85.215.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tp0BSybk"
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cbb20f82a0eso260464a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 18:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789607964; x=1790212764; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:date:message-id:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=eHNUights9kZeR0sRyl3ZnZ2YOkzdWXXjZmyIf5x86w=;
        b=Tp0BSybkaxbK/sCaKKQy8/4Fl5WDaYSiVt6UB60sF6SN6457UIqPC/gL2MKaqReZdK
         +13Yodio1o0A4EqsoD4L6gqfouppn/Su9qvluHHez3jk0O3sIjU3ir/xjIjtOZHHlN2c
         sXNuSeiRx0oj03mvrPguda3wZCj8K9OUc0Syjlpnw6qXVwRxxslg+0RK+Jws9CHwndqH
         vulDwPqLuM/WWzgaTLu/Bt2RIR97YvTCHuCee2pi+1OwoZkkMPqg1zl8oW+LkJVUOPfG
         4WMTOmEDfRksagYlti6j34Wze/TMYKMqcVdY0MYP7DHBJxvpAefBoRW+XqGSnpTlrBeA
         GOXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789607964; x=1790212764;
        h=content-type:cc:to:from:subject:date:message-id:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eHNUights9kZeR0sRyl3ZnZ2YOkzdWXXjZmyIf5x86w=;
        b=wV54oqylRudnFt0HPDIdLH/nlZtbLDVB8mm2qN8cmTczCvSEcGhClDds7yBZ9RjgnZ
         1K0seBCBB/DwcgA70ox1ltU/LhfO0mLGhvrAydjCODLahCBXwuKmRvKZ67OCJ6IT8eLx
         bjTjHkYt2RuKvoUt0Ni7z/cvSPvTvGLqZwhYNIbFp9fyNWP/93I5Xhzu/posnCAORJIL
         Kh3hAaHTQSik+udANldEQZVrfyMigNLG2istNmqm7I/M6hZtc+PkKNun5BLytAK0MqZJ
         1Mt6vD7KuHVmeAC3ITl/JfEgHOzpIKfxKiI94sLVdXLEsT5X/eaBPduCwnrhCnFRoMhC
         HiOA==
X-Forwarded-Encrypted: i=1; AKwUvBy6VHcSg/Msoj33v+spU+vHXpUfn5b9Q6l3FWDxBJSJSAwn0qr2nHaMwcErrIlkV828qEWU55S0Vt0+@vger.kernel.org
X-Gm-Message-State: AFuF++mVp5BVW1H4ZIDAYRR+r4lbuJxmFakBMLAcSoD+Gelv4gPB/E0Q
	StRVDXR1k7/Rn4fqh2UtdtfKLtPt3VgoFDXgQcIx0rdo7r5i6a1PCdGxns0ixZsF/Y7g1dh2kn/
	qXiXfgauZYUONd8BnLdHaSQ==
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: from pjwo24.prod.google.com ([2002:a17:90a:d258:b0:39d:93fb:c298])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2744:b0:398:ba56:b926 with SMTP id 98e67ed59e1d1-39e1e5770b9mr14456676a91.25.1789607963681;
 Wed, 16 Sep 2026 18:19:23 -0700 (PDT)
In-Reply-To: <74786683eadc0a32ab335373ead8dd76a9d5a342.1789157339.git.bvanassche@acm.org>
References: <74786683eadc0a32ab335373ead8dd76a9d5a342.1789157339.git.bvanassche@acm.org>
Message-ID: <18d5f6f60e9c36fd.3137322e31362e3131332e313435.397753.0000sendgmr@google.com>
Date: Thu, 17 Sep 2026 01:19:23 +0000
Subject: Re: [PATCH] scsi: core: Make SCSI host scan interruptible
From: Stanley Jhu <stanleyjhu@google.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	syzbot+1f678bd2872aefb11d8a@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

On 9/11/26 1:11 PM, Bart Van Assche wrote:
> Writing to the sysfs "scan" attribute serializes SCSI host scans via
> shost->scan_mutex.

> -	mutex_lock(&shost->scan_mutex);
> +	ret = mutex_lock_interruptible(&shost->scan_mutex);
> +	if (ret)
> +		return ret;

You noted earlier on the thread that transport scans not initiated from
user space are out of scope. A write to the sysfs "scan" attribute is
always synchronous in the caller's task context, and on SAS, FC and
iSCSI hosts it keeps sleeping in TASK_UNINTERRUPTIBLE after this change:

- store_scan() -> scsi_scan() in scsi_sysfs.c reaches
   scsi_scan_host_selected() only when shost->transportt->user_scan is
   NULL.
- Those three transports each install one, and storvsc overrides the FC
   template with its own. All four reach scsi_scan_target(), which still
   takes scan_mutex with plain mutex_lock() and returns void.

> +	if (!signal_pending(current) && scsi_host_scan_allowed(shost) &&
> +	    scsi_autopm_get_host(shost) == 0) {

Conversely, initial host enumeration during driver probe should not be
aborted by user signals, yet this change makes it abortable whenever it
runs synchronously rather than on a kworker:

- scsi_prep_async_scan() returns NULL when scsi_scan_type is "sync",
   which is the built-in default when CONFIG_SCSI_SCAN_ASYNC=n.
- scsi_scan_host() then calls do_scsi_scan_host() synchronously in the
   caller's own task context, modprobe or a sysfs bind writer.
- do_scsi_scan_host() is void, so the return value is dropped and a
   signal on that task truncates enumeration with nothing surfacing it.

Both issues arise because signal_pending(current) cannot distinguish a
user-initiated rescan from driver probe enumeration. Would passing an
explicit flag or scan mode from user-initiated entry points
(store_scan() and procfs) be cleaner than inspecting current?
