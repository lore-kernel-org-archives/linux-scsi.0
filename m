Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C744F3EDA
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 19:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790623745; cv=none; b=IMSxSBIctrvQ+u1b9IDb8GLJIZhkziJxuk/2flbRibO3rm9y9r2+jEOnOHrfIbkcURG3g0k8mS8k+KtOSjTkFy+RlzdL4aqSip95o1mOJThoyspkZOOBSjtkjo9ilvvxlec/n2ai63QDqRXL2BjPB5fLbqEhYWoE7r73MzG7vG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790623745; c=relaxed/simple;
	bh=apSiewBdSnqIECPCX3dCAZbDmHDmZloEye0beGRbPNA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=goumQs+IBNixoTyrsww/Zy8VhQZZUFMh/BuOj0z/R491QSzSbKgeWfQIksEkqHujZq9gXHmPTpvglGlyuhs2cUxaPufqI39ROI+6w5YrTw9eooxCBE7RICjoR0xqk2FPRfm0XQvZxksHBpAH5CVcqWdiabUHnsE76qpe0Q9jiV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=L2x/LXrC; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="L2x/LXrC"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4htrvy58Jyzlfdf4;
	Mon, 28 Sep 2026 19:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1790623739; x=1793215740; bh=apSiewBdSnqIECPCX3dCAZbD
	mHDmZloEye0beGRbPNA=; b=L2x/LXrCORdqZbXxsdoU1c8MHtxtfGniy2JIOpso
	hAiYu6dYhL7Ch9hH3YazfLej4C/WHCabSxtW8uC9UwuWMtsl8H5deE0qKg/eE6TC
	I+LhP43IlSL5k4RX+WTES04euc/b61SoQDppgliqOVhkr7XbGGr35QZgSmq0OHH1
	8RFffNdFF+Ho3kDUGXHME5GclSWjB3VCxWtY0dDqXQ6D1bVYzYHrnf7GbMXmgLvL
	o9hakIv8+I3DmRcjXBfk01hYUHaofELtGXPpbJeI35QR6Q1nisd+FXbngGdyZ1FS
	v6rNsDP/bZ1ZoKiW+GLTqfqvmVPbuNXOJp2eF1/CHThQ3A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 76mTgN-4dCcy; Mon, 28 Sep 2026 19:28:59 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4htrvt3dcLzlfl5R;
	Mon, 28 Sep 2026 19:28:57 +0000 (UTC)
Message-ID: <f0c2d0ab-659c-42c4-a8cb-4978dddc29e5@acm.org>
Date: Mon, 28 Sep 2026 12:28:57 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/54] scsi: BusLogic: Pass the host pointer directly
 to several functions
To: Khalid Aziz <khalid@gonehiking.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
References: <cover.1790360262.git.bvanassche@acm.org>
 <09e99ec9c6fa24ee5fe3c47110c88a1be076e01a.1790360262.git.bvanassche@acm.org>
 <argk3DLMl_YSDOsV@gonehiking.org>
 <97ab2119-2067-4c6c-9edf-286666f94e40@acm.org>
 <arq4GHK0OLyusPBh@gonehiking.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <arq4GHK0OLyusPBh@gonehiking.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/28/26 11:55 AM, Khalid Aziz wrote:
> I prefer not to pull in macro definitions from header files into the
> driver code. This opens up possibility for API inconsistencies if
> the macro in header file is ever updated.
The DEF_SCSI_QCMD() macro was introduced in 2010 and there have not
been any changes to its functionality in the 16 years that passed since
its introduction. Hence, I think it's unlikely that it will be changed
in the future.

> Why not extract struct *scsi_host in blogic_qcmd_lck() from
> struct *scsi_cmd instead and continue to use DEF_SCSI_QCMD()?

Because it is the only way to avoid __assume_ctx_lock() in
blogic_qcmd_lck(). __assume_ctx_lock() should be avoided if
possible because it defeats the purpose of compile-time thread-safety
analysis.

The BusLogic driver is one of the few drivers that releases and
reacquires shost->host_lock() from inside blogic_qcmd_lck(). Preventing
that the Clang compiler complains about the spin_unlock_irq() and
spin_lock_irq() calls in blogic_qcmd_lck() requires adding a
__must_hold(&shost->host_lock) annotation to the blogic_qcmd_lck()
function. And adding the __must_hold(&shost->host_lock) annotation
to the blogic_qcmd_lck() function is only possible if 'shost' is one of
the arguments of the blogic_qcmd_lck() function.

Thanks,

Bart.
