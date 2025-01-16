Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EB41482F2
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2025 06:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737009002; cv=none; b=e7JPxnmtbidTKmYna8akRv/mWfns0NWa4Vl62UILeX3Bx/3korSfN3Lp6hUsEAFcSwXfrXyoyRqpMXwMx0SK41t/5A5ybz9nGmNiuUltfOdwX/3g2n5z32105uaOtKAWKbeTM/8U60jr2+lkdmVO7CjQSM3xb7W0U0K12b42BzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737009002; c=relaxed/simple;
	bh=y/hhKsXz7+RJHiYxmVckkuEFs2FBoseLN/lUjDPbSvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=on2lIqZZzhD9HMRK6l99oYN2UBkHcuDmdqA1HfF9yv4SJhJXY0nCLu2VbSCcDPxcPJi0o/K/plcj4RY3EeQhxrwsPtH1Q37oVR/J93rANKlq3jbtMvEXczB4XKkStZePZPtcU8EQnKgUCxRHmY38Fkhhmyu1uW43Z8kWsxAzME4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rYLpSDD0; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rYLpSDD0"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aa689a37dd4so121578966b.3
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jan 2025 22:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737008999; x=1737613799; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=20bpVgTSCeDncmudr0CWlsJifis41HaVEEKwTD34AY4=;
        b=rYLpSDD0H1mHN3IK8OzJZ86w5gPahHWnIbQXHzOp9pY10pC7htMi/7oeVjnAeTIlzr
         mSKRe5AaasALwmhx2L5UNmdV1802xq0Pjsg6xH2+F5nCg8oM7U/0+2zMsNe/zQ2lcEsH
         N2tcxHHVZfbNfX8vuI0ZS83O+759Uh9mPS7zZCnl+MH6jiGi2QXWIBlGx9vE5dCzY31y
         njiWefWIr9Q6lbGkSGd5sznnmr4ExbGrl4dyH6KhBqSNdQcm9TYvKnlYpGqe2jvU1ybc
         U3B2de/FN5nez+OC/eVSP0aKRcHFJAwI0uA/7R/tpYXR2olSBi1WeuWAgxvtLF+uImfs
         R+gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737008999; x=1737613799;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=20bpVgTSCeDncmudr0CWlsJifis41HaVEEKwTD34AY4=;
        b=RvXu1YqgvJHp/mGcw52mS8YgaDJoFFNRGosSeIurPKrQ1jX64bqWOsIJMnktdeSo46
         4ISmuk0lHw8O0XDNOXe04pQ9EX3u9hMrM/1FQvVOl2NqR8i9ocelflCAhBoNN7biPNWL
         7GJvhLipE4dexiekR1clLXPtv+9QvijB2wyPbnLXhb/GA39vBuJnEpw3GUW0YkIvzdl7
         OfM22kmZ1m62Hlh+8qDXNNVwSa0RJWXtRyeJQxdloQxXnOcn+UzjyViV9dvflexC0bZv
         pIbVJMjA1OcXbKVEpI0/YMehekJ1s9NyaNrq3FUex49OPqMJtDXNWtACsVgJAFsSCdaB
         9d9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUkClVE7Vc/ORdSHZSzUfMia1x1ZpQpZxJ/zORJwyNI2cZtmLGXiN5v6M6owMJUDc7anO1sYUz5pQSw@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9PDMIs19c/Bx1EmQUtSA4x083GpLhlRamt50aYIi5JtQs/AlG
	3v8HZ0IxlGU3o7bC9y8r0vlKIwJGtlx81uXvbqyrMBFzICUfRsvm+JL/ZH7tvGU=
X-Gm-Gg: ASbGncsPDYZ9ss1BhHv5Y4OQ+04gds1h+nF1+TTz+dO9xN2v+EAsQNd+QeIQsfXGJdp
	VN4yPtiSQ7SZpUORpr4jYwpewFq53yg9PD6HzobhMADz0HmrFpNQWqoyzV6LmXwbjprWU9omp04
	tQTMsbmnm2LMq/ruo6DaaS56aCSoaAMYofnWQHu8m3S9R11u6X0jSrQx5OYlpseC2tsCxWVTjxJ
	hFXDoG2iW2KK0LZEDqGmEm6a4PRtElD9VJGw0gum03uBIvYjobSd3z7sV7JYQ==
X-Google-Smtp-Source: AGHT+IFv4cd1XHDGjCciGJV0nfZgjVHchc8bJSn2YYD/Oz6r9jUt6RA1l+Aw3OEK/UX06Kc5G8CKcg==
X-Received: by 2002:a17:907:724b:b0:aa6:abb2:be12 with SMTP id a640c23a62f3a-ab2abc91b53mr3125542266b.37.1737008998931;
        Wed, 15 Jan 2025 22:29:58 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab337d71352sm324174766b.54.2025.01.15.22.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 22:29:58 -0800 (PST)
Date: Thu, 16 Jan 2025 09:29:54 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: John Meneghini <jmeneghi@redhat.com>
Cc: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com,
	arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com,
	mkai2@cisco.com, satishkh@cisco.com, aeasi@cisco.com,
	jejb@linux.ibm.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v7 07/15] scsi: fnic: Add and integrate support for FDMI
Message-ID: <ab9fdfb5-b9b6-4195-8bce-5b19e8cc17af@stanley.mountain>
References: <20241212020312.4786-1-kartilak@cisco.com>
 <20241212020312.4786-8-kartilak@cisco.com>
 <4141c9ab-c640-4765-a23c-c2f64df687cb@stanley.mountain>
 <d18ed046-0d16-49d6-b666-8ef8ee20f6d2@redhat.com>
 <b3c29afc-c49b-42af-9733-7cf2b934cd90@stanley.mountain>
 <dfa5c473-ef65-4065-b64a-6bcd213a26bc@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfa5c473-ef65-4065-b64a-6bcd213a26bc@redhat.com>

On Tue, Jan 14, 2025 at 10:15:12AM -0500, John Meneghini wrote:
> Hi Dan.
> 
> I absolutely agree with all of your comments and I appreciate your review.
> I agree that all of the issues you've pointed out, with the the exception of
> one, need to be addressed. The issues pointed out - especially the string
> manipulation issues - can turn into CVEs. We don't want to be checking bugs
> like this into Linux. Certainly, nothing should be merged that does not
> pass the static checker, et al, automated tools we have.
> 
> My comment here was only to say that I don't think it's reasonable to
> ask Karan to break this change into a series of 100 small, reviewable changes.

100 small changes is hyperbole.  It would have made this set of 15
patches into probably 23 patches.  A day's work perhaps.

Creating reviewable patches is part of the process because it forces
you to review the code yourself.  It makes reviewing the code easier
and safer and faster.

I feel like if people had asked in Jun last year, you have two options:
Option A: Would you rather do one day's work cleaning this code up to
make it easy to review?  Option B: Would you rather resend it as-is
every month for seven months?  I feel like most people would choose
option A.

But the real problem is that we don't have enough SCSI maintainers...
Even a quite junior maintainer would help.  In drivers/staging, we have
a bunch of random volunteers who chime in on stuff like this.  It is
what it is.

regards,
dan carpenter

