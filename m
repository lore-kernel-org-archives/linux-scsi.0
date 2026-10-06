Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF6B3B2D38
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 09:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791278756; cv=none; b=P7lRCb/6YmfoBEkg0YKDl3qMH94mddCO4PulFrUhO6wY9758Gc6EdreGoRuysdULBWbZOJT9zk+YwJAnJEHgscug6M3tsQ/uwzM54pl9USyn9FZPOHGeCKkcbMkQTwJh2p5LJ1wfHdsrNSvxGP1/fApY66JrwFH+r0mIiGX/TKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791278756; c=relaxed/simple;
	bh=nBFwTaHCoZrvhKEnFDKk/c/uDF8TWWjhz8/V3OQzmEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H2ADIhyhOYyEvf9FCiAi5lN1X6Dor0C0j8IcNScKi7RIJRXcf+N+CVFAQqug+CCbk8vgLOnWD32MYEog0N5koYeYVvg6QQqJ8J4Sy5qBk+BWEkWo/bmtfaBAhcfHmifKtFk5UDsOwY2zh8s0su81kxCX0MKmbF3rDgdlH01ketM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jCzwnzDV; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DOHQrc/6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jCzwnzDV";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DOHQrc/6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791278753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NjoHxY7Tm9jzAn4TDRkj16R8xEG3syAc3zsRYffO2PQ=;
	b=jCzwnzDVOGpNlJGeZv+ppSDOL3lgJOEgfo99co0wmECTGTvejJNFGmOsxyLJr84im0i8nd
	ic/wjzMuhmy7sN189pk1gRA3PET3QoQeqEojDdkNGiUGW6yQU0p3SanQQroYb5DThuRnIZ
	aI4PdSkpwEiMeNCyAP5TFeRjO9bLOFQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-5xnDVs9aNTKBxUvsnVFKOQ-1; Tue, 06 Oct 2026 05:25:52 -0400
X-MC-Unique: 5xnDVs9aNTKBxUvsnVFKOQ-1
X-Mimecast-MFC-AGG-ID: 5xnDVs9aNTKBxUvsnVFKOQ_1791278751
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49e6b5c5f44so43972885e9.2
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 02:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791278751; x=1791883551; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NjoHxY7Tm9jzAn4TDRkj16R8xEG3syAc3zsRYffO2PQ=;
        b=DOHQrc/6Rb7BX6jWr3ZMrNjmRj/ZYV3hWc0amJhCoyd+o51EkVOXUhO4M6Tz9cF6UF
         qgjmSwEb28CyU5pJIr1UFvnGiHhZCdmzcFbxDhTdLlsVsvHAF3ukZS7EG8cRspipQJUR
         5J9QTDUKQnSekTxJbMOFZeomGT9RkCGtmYigK7g/Fs5XeP4r1MXvRCUDbYIPloS0mm+0
         sG8aWhHt71tyTgmUZQK5DkF47vbKW2+fqMW6J3VhXbjzil4aPQSbYS16SfP2YYUIHioB
         mf5ez7SzUAlnRBLll8GMGoIVkWogiztEvk/qt1Il75HEeLWh0Tj1WxRPpuDRUuiDVfhy
         CZ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791278751; x=1791883551;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NjoHxY7Tm9jzAn4TDRkj16R8xEG3syAc3zsRYffO2PQ=;
        b=MUEw4jU0qkPvEZAcLugKIyTwFaSHq+1PMTW8NdcYExUShIqIpLeXCvVlBtKxI8z5HP
         mDWg/tE20iPHSHmwRe0pap0ZoYmr42nGAvujqQsKoYp55qT1+W5As35SN0pIZAhYqGZF
         X/ThEOYGBc+tQaIO/84Bn4EEfKm/Fh4xkXm/1A6VBcE9pcKVW2a8fCD9Hf1Ypb6m2RIN
         ecMWsffnwkNTf7efNlOJPEJiWR+yrDc4lZlSZS6NL+F25OW6lL5PvPhn2iyXuAVxJATe
         MlYZACqiib7d0fcBWUMh6UOrKAcycNEK1a9MBpZOLG0jSqZcGp0IgOEFEQiqSz9pIXbI
         fpeQ==
X-Forwarded-Encrypted: i=1; AKwUvBzaV1o5v6wkaSClUTTw67njDa+HrTE+KGWBOuQKr9p5MIR0Rs/iUL86inH+bA876QM1LTyOkqfwHyeK@vger.kernel.org
X-Gm-Message-State: AFuF++nYyTbh6h6qHbSJN6CkpwIRNhxFHHwXcOUwgtIj2sNfcB1d+N0Z
	fMmZOu0JqADqSq5Jqa3yAjwsMuzEFP59lgUapYxKhxmtI2hJ7mNzC3Cc97/IBwbFfSt/byZy6Jf
	+V6JgfrumrwoeQaZ33jpBum2tsxq6/yakFMg8u3IkpR0GBSnLgzK5B9zhF+2rO38=
X-Gm-Gg: AYBFou1sI5FU08xm601RIRhEslKY2o8GPD2oS1r8XEU2Jrh8Tkd3Zv6ifKqufxOqNul
	uHUqn1m4n0gb8BwOWwNlyrekYoKD/SG92tKp0Wxb5n3B15T7wTAqfPWowgJlbUpKe8NvfhXSMns
	HXv8O7DPwzEy/HsqhTjhYu6fRTW6ZD3BEaoE+ffar7LP49A8yfpUXBdGhRjsLS3ExEQYGW2cBxO
	Kq2sGkQMdms229RVOr9IwE2aW01yfss3+4BEK+vX2QtgVbAZ5bjtuRoLjD551l1DJrKqqPjx+A4
	I9Hfb3/BePTRYGm/RKT58EIv42vlQV9+e19BsM5AaHXr7Gp17vEsLSk/rKaSIRy05mUQoJA=
X-Received: by 2002:a05:600d:82c2:b0:49c:cee0:f383 with SMTP id 5b1f17b1804b1-4a17b54978cmr17121775e9.16.1791278750648;
        Tue, 06 Oct 2026 02:25:50 -0700 (PDT)
X-Received: by 2002:a05:600d:82c2:b0:49c:cee0:f383 with SMTP id 5b1f17b1804b1-4a17b54978cmr17121435e9.16.1791278750157;
        Tue, 06 Oct 2026 02:25:50 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:3fd7:5300:3d6b:52a4:a23f:9d0b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c62eda863sm8233454f8f.43.2026.10.06.02.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 02:25:49 -0700 (PDT)
Date: Tue, 6 Oct 2026 05:25:46 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: sungbyeongchan <tjdqudcks0424@naver.com>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Jason Wang <jasowangio@gmail.com>, linux-scsi@vger.kernel.org,
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: Re: [BUG] scsi: short virtio-scsi VPD response exposes stale heap
 data
Message-ID: <20261006052300-mutt-send-email-mst@kernel.org>
References: <20261006091138.827988-1-tjdqudcks0424@naver.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006091138.827988-1-tjdqudcks0424@naver.com>

On Tue, Oct 06, 2026 at 06:11:36PM +0900, sungbyeongchan wrote:
> Hello,
> 
> I found a stale heap information disclosure in the SCSI VPD cache path
> when a virtio-scsi backend completes a short data-in response as
> successful.
> 
> The backend first declares a 256-byte VPD page, then writes only the
> four-byte VPD header.  virtscsi_vq_done() obtains the used length from
> virtqueue_get_buf(), but that length is not propagated to
> virtscsi_complete_cmd().  With good status and resid=0, the SCSI core
> accepts the device-declared page size.  scsi_get_vpd_buf() allocates the
> cache with kmalloc(), and the mode-0444 vpd_pg80 sysfs attribute later
> copies the unwritten tail to an unprivileged reader.
> 
> I reproduced this twice on commit
> ff47652a4b66c067c765a7ad464d930b5a9367cc with a local
> vhost-user-scsi backend.  In both runs, uid 65534 read 252 stale bytes
> from a reused same-size heap object after the four valid VPD bytes.  A
> normal full response returned only its valid data.  Reporting the short
> transfer through resid prevented the stale marker from being returned.
> 
> The demonstrated impact is a bounded guest-kernel heap disclosure to an
> unprivileged sysfs reader.  I did not demonstrate arbitrary read/write,
> code execution, host compromise, guest escape, or privilege escalation.
> 
> As a minimal disclosure mitigation I tested changing the cached VPD
> allocation to kzalloc().  The malicious fixed A/B returned a zero tail,
> and the normal VPD control was unchanged.  This mitigation prevents the
> disclosure but does not make virtio-scsi reject every inconsistent
> used-length/residual pair; maintainers may prefer to propagate and
> validate the actual transfer length instead.
> 
> I performed a best-effort public duplicate search through 2026-10-06
> and found no exact public report for this short virtio-scsi VPD response
> and sysfs disclosure path.
> 
> This report was prepared with AI assistance and is being treated as
> public under Documentation/process/security-bugs.rst.  A tested source
> reproducer, backend, logs, configuration, and proposed mitigation are
> available to the maintainers on request; the reproducer is intentionally
> not attached to this public report.
> 
> Assisted-by: LLM
> 
> Regards,
> sungbyeongchan

So a broken device makes guest kernel leak some uninitialized heap
data to guest userspace? Is that a fair summary?

-- 
MST

