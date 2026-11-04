Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810797;
	b=GJ9pVn751kvWjeXDaUQt160mXzBQilypy84+qOLZkWJ1l3UP87EM6ucQKyGNbCjoiGah
	 SvImkkyDO6K7ZisxLqSnSOqKdRCjzz+P7tXFKhPfjTX8S8qmkCVSym2ST+wGlFDFmGjAg
	 UcadsH19AkeepZRIvg392Y6pf6+7mOqsq64A84dWCxG6UMBNtsAhjaNwlX4+zawrfa0Qc
	 +ab9dq0oikk3CAAdiFaU2uNg1s6FTsyu7Hb+s8uE8bMfaTn3fpXS3s9r1M3uka3FR3hSl
	 T+G782hB7VXUbIBla1xWtl0g8unwi3EK8LUrFPH7fT3f7nasrZQBHqZlYLphqGmkdRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810797;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=eAaKlrwhgxVSTJYKvS+Mu/JmjMNNY3TaQOKNMaH3oHI=;
	b=wYKPdIpLMeJziy6mUIk19M4foPslWv49Zq+EQwT5KB+A0HT51+lGXHbMXGiaIGk//USR
	 uRMVmsS9DabTXaXzXjF+jZ/TcxHvJGFiVc4IYH4aI9SBSHTd4UaCT9Rk02thaHznwpBR/
	 PfsbL+VuK5ryDfzxqzagtdnRxfgICLpXyt2MbVXAlTC1E44OeE1TIVZ+3W8US8S7+8mk0
	 nM4s5e7IsdeFNwqPrHk+dKYzkFvAjQ40VaroFcgjK48ozMXtLNeinW/VOI32cfo1KPzqr
	 BdHr8o+00aPjiF+fp9x0wIMmufpg+/xFJ915W6jDK278pOHhgLOth5iJxIP9TZ2CpBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chromium.org;
	spf=pass smtp.mailfrom=chromium.org;
	dkim=pass header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=JV7jvcyh;
	arc=none smtp.remote-ip=74.125.82.44
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0C0606A328
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 16:46:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C0C0606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=JV7jvcyh
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1b1ce85287aso835600c88.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 08:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1793810796; x=1794415596; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eAaKlrwhgxVSTJYKvS+Mu/JmjMNNY3TaQOKNMaH3oHI=;
        b=JV7jvcyhDzFZgOzyiXMsrrE96csI3o5reJpHhY1rZC3R+/mUnsqjvCmXEjOL3OVxrJ
         JkdmZ7gnsvz/rc1SGznFGm489hIxWfufBaTe+g/2UZU6OFp6XAoftty8q01wNHobQd8X
         wch1oNFN1YQPF6MTpQuBWXmoCzX1jPassCZJs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793810796; x=1794415596;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eAaKlrwhgxVSTJYKvS+Mu/JmjMNNY3TaQOKNMaH3oHI=;
        b=VLOzqbF89214w137irIXhJ7sCteP73h2ELfaX2cF4uKdz2v43FyrLVrY8fSI8lGPtH
         HM5VelzyY21MV2MY3OlabeiL1FYniiYwxo6csK+2wqZepOF0krSnwSFZEBzRrQws9ieY
         pC3egP9O+PbEG5PgVxfVBXs+MhF1RrAh6xmP7Y/RAnniVF/txnQCEqR4TWrpBq0DGpFb
         /Qo1acyVMAyNmFnn1Dj8xoJxtISTEVwGg1/H3qJhp2iWKyoiQkVrzFmQWDCLp51/mkGi
         pk4qwvpprMOa8MexnVmulmhkwAT5lqhs+1BJDuGqCc79Ib1vq6yxN8tR8d0t4Twl27iz
         Ef2g==
X-Forwarded-Encrypted: i=1; AKwUvBwwWd81AE3j3vvbKBsXKTDAAiZ2VQMm198VvURGIptMAr0+JAMimjPDiw+JAztXtMYHaf2R8CYYhCP4@vger.kernel.org
X-Gm-Message-State: APuU4Z/sKqJBLgg/f9nH86N2bQF1jSbjtRL/cUVj6+IVsSceJVctq1Pm
	52f8aJ79byQDx5l1oh3NK8cSqrFx6jTxNZ7IcJAbmmjQFxwsBpnvg+Lq+tupWv/lqA==
X-Gm-Gg: AYBFou13FT8DkHDbNpZgHzK9CjGOaelSXqbgUUl8tLVhOmpqqc7UlFbcvc5piBCj3kj
	k04HHn1npxV+QvE60/OkhIdtpVks5BlOtFXOrpEJU+YrCckFN+ULnXhr7xOmGYAbC1teL1lt5+Z
	DuRGiFIHEgWuSiVHgEU24j5hsfzFd6Np1MKZ8h8QuJt20oIU2vwnjHZoR5B7HiyFRWRHjbs1BuI
	nnO2RWh4XE2XTF08JxgP1dXO7Ag9TBD65W8YdDJf2+ir10iEOOoSPiKgrxYCqOYPQClAUp+9xOO
	oRjgn3gFyzlT+Bk5toDmht/ylc+La+lnzHl2PZlmEGYPhRVP0aAjT5q7TJ93LgiXFNuuTVlTZUd
	LSejNdq9zYZSJgU38N6NtpfBRBTMXFPx3xJuI2DzmKQL3DfMgrCvIWQv4ZksTTg2/WNIQdKActC
	3l9KJNK4XEFX8OGy526iz4uV5cs/DfrC3dSFA6p7c6RBmDfIZZKnmsT4VIva9XlYhl2lTkcejyE
	TT07YoDEQaKBGjLYjGd7hngPt8h+yNFhRvCdSyebAFMx3LdqMSqGuZ62oG1/meUy7DTkr8UY2F7
	AHYApiwNnfjQFco8CzMXTW9Tzf60RGY5LQIAIJToWBCyQdZli3k3ALUYUa1ccDn1gnY=
X-Received: by 2002:a05:701b:42c3:20b0:1b2:366a:e7d1 with SMTP id a92af1059eb24-1b2366ae854mr11976510c88.32.1793810795926;
        Wed, 04 Nov 2026 08:46:35 -0800 (PST)
Received: from localhost ([2a00:79e0:2e7c:8:ab71:b3df:693a:fbf2])
        by smtp.gmail.com with UTF8SMTPSA id a92af1059eb24-1b245c2de58sm8522268c88.12.2026.11.04.08.46.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 08:46:35 -0800 (PST)
Date: Wed, 4 Nov 2026 08:46:33 -0800
From: Brian Norris <briannorris@chromium.org>
To: Stanley Jhu <stanleyjhu@google.com>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Praveen Talari <praveen.talari@oss.qualcomm.com>,
	Jonathan Corbet <corbet@lwn.net>, Mark Brown <broonie@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
	linux-pm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] PM: runtime: Update runtime_pm.rst for non-fatal
 resume errors
Message-ID: <authaS5a_NrY-NLd@google.com>
References: <20261104151651.3035537-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104151651.3035537-1-stanleyjhu@google.com>

On Wed, Nov 04, 2026 at 11:16:51PM +0800, Stanley Jhu wrote:
> Since commit eef1d74bf88f ("PM: runtime: Only set runtime_error on
> suspend callback failures"), rpm_callback() no longer sets
> dev->power.runtime_error when ->runtime_resume() returns an error.
> However, Documentation/power/runtime_pm.rst still states in both the
> resume callback rules and the ->runtime_idle() comparison that the PM
> core treats ->runtime_resume() errors as fatal device errors and blocks
> runtime PM helper functions until the status is manually reset.
> 
> Update the resume callback semantics bullet to state that on error the
> PM core resets the runtime PM status to 'suspended', returns the error
> code from synchronous resume helpers, and unlike with the suspend
> callback never treats resume failures as fatal, leaving the Section 4
> runtime PM helpers unblocked so a subsequent resume request can run
> ->runtime_resume() again. Also drop ->runtime_resume() from the
> ->runtime_idle() fatal-error comparison.
> 
> Fixes: eef1d74bf88f ("PM: runtime: Only set runtime_error on suspend callback failures")
> Fixes: aedc51762a0d ("PM: runtime: Clarify ->runtime_idle() callback return value handling")
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>

Reviewed-by: Brian Norris <briannorris@chromium.org>

Thanks for fixing this!
