Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7EC1ADC74
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jan 2025 09:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736848780; cv=none; b=Q8XmedEaZ9iI9o8PMjfz4Fg9MUVBJbL3/Am+wvqzoPYyJm9girslMoR5tsTs72/mW5MUbn6ngWewPQZkFH+2zcgWnwJtlV6em4jlQ7rhd/bP2OOpGizS1qmd927aJ8WovNAs1NWi9Dmjgm3kvUL6abxDzr6j/11LOLGq8gVSdp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736848780; c=relaxed/simple;
	bh=PZcRmnI2h4F/hhDglgNNNnVq/bsrc/tDx+3g1RD6JOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t4uo8sSAUVAmykVMZ+0UJAlAI5NXwmqSTeAPjhnHOqaaB0JiClpZ2Bpc4AwukvBz2iDYlfKh+Y78IkQeVN3MOVQNxagxyZQBpvKgTpWf5GWADuqPYB8BdGXI0DpvWLXlCzUP3eXp4RrOfKBAtQCJ4w/xH0tEmFdSPODpjw1ww/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=g4K8YWYb; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="g4K8YWYb"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5d414b8af7bso9465889a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jan 2025 01:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736848777; x=1737453577; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qv1jJD+Sb4D1WqjgjJOnNmg7mft9hCw88azA+ajAikc=;
        b=g4K8YWYb4OYy3AyZnwKodSFUluxylV0IaDZfYyxw/DJGIgyPjq6+Ez+NOT7FGeeGLz
         GK2f5U/3FJ9j4OrbtDRyZsjK1OJCFqo+ouz7al1I+RR/eAtdXkx1AWJIlF0KYCzWTvXc
         e/lj4H21ShpQCSy8WeW5VVBG1SDyOUJpSTidSnzbY+H2TmYs0X2zdP8Yv6/aCsJMK32Q
         JU9MBIyF9vELqbPKb3JSQdRRf/yp5DMu73tfSzyLlWbpYbjMzRoGiQBqfp+jYKBnSqI+
         oJ/WguGbQY7MLlerHb3dzctKBJjOxHPKE4IKdJPw3HDZuJkIdlZ/7FCuNjew79jH/7LW
         o0oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736848777; x=1737453577;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qv1jJD+Sb4D1WqjgjJOnNmg7mft9hCw88azA+ajAikc=;
        b=TikYgZjHWo18G62hrXsyrIH6NACPJKH0cMYSzYvrxBbQQEO8F2AvjE+QuFuHhFsKXR
         4BTQ4Xdncr4RSG2Wpu/Gpqo4VO1E2QmCJ9bsPU7Pp8otP7sTSz7zJ7CV/cXtMY8AB1Eu
         o0t/fhpu/RYHDklVE2gJIMsRvbTrAx3xczMR/8jAhhfc0qyuf+YpiHvXOgz7P8//B66g
         dwFQ7CcVqAXQX0dG6kytqUR4JnbyjAr/cRIGlWS2HemUE0J48fWSXPotoNanFojOR5zt
         l+4jpEHVetzCoadAHFdrUTbMYLwnbPUAbMhevwZXUTJQgH8xJYzeGBqOV7c0Q+OXjXJ9
         k1Ew==
X-Forwarded-Encrypted: i=1; AJvYcCXDcUO+2DPgnykDHBNtxD8uIVBa1ElmExfr3EZcmjxSP+odYuogxKcB0myMpPnAsJdeoG3I4FHC6kL7@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/4VrR4wO6Y9kjrZiDmYs1g0+6sfwBrYmv2J9XQ4wThWr+b2HR
	OLrnd5qL7YgASh++JiQrYB3Zh64vqrhzvGSyS9VjdqLE124t5wjHNSetNqawoj8=
X-Gm-Gg: ASbGncvqdUhQ7lkvn3rMCrgAFrN1Ak0BKC2EjMJdlmrHbPkZ4iyd9q/JKhGTyQ+RXEM
	21yEp21isrwyQc7CEZr6hR7+9CSi7rBn1XRpLI+bzqJ8symTAFpKYtLkOYtmLAV4lDbMPFEkPVs
	hI4/yfFqxC3n36vLj84T6yZcflzsj8BC3wFTyit7vDTc4dvssFsyNU0OdmeHrixYP6CasRHnNlr
	dPP9So5+/GZ/iLjSvfKCKP5kGJ3s7LpnPHgKIy7zHcYnTQrc6ASpp/iI6Ht1w==
X-Google-Smtp-Source: AGHT+IGQwGV+OCJyZcmr85VT1IKTszmeQgkTPCcj7NQDW10pvZs1NvQF9hL554XdKRbEnnfnUmfYWg==
X-Received: by 2002:a17:906:f44:b0:ab3:ed0:ce7 with SMTP id a640c23a62f3a-ab30ed00de2mr777849966b.55.1736848777178;
        Tue, 14 Jan 2025 01:59:37 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c90d6a4csm608709566b.71.2025.01.14.01.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 01:59:36 -0800 (PST)
Date: Tue, 14 Jan 2025 12:59:33 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: John Meneghini <jmeneghi@redhat.com>
Cc: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com,
	arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com,
	mkai2@cisco.com, satishkh@cisco.com, aeasi@cisco.com,
	jejb@linux.ibm.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v7 07/15] scsi: fnic: Add and integrate support for FDMI
Message-ID: <b3c29afc-c49b-42af-9733-7cf2b934cd90@stanley.mountain>
References: <20241212020312.4786-1-kartilak@cisco.com>
 <20241212020312.4786-8-kartilak@cisco.com>
 <4141c9ab-c640-4765-a23c-c2f64df687cb@stanley.mountain>
 <d18ed046-0d16-49d6-b666-8ef8ee20f6d2@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d18ed046-0d16-49d6-b666-8ef8ee20f6d2@redhat.com>

On Mon, Jan 13, 2025 at 12:35:03PM -0500, John Meneghini wrote:
> Just a note to say that these patches are important to Red Hat and we
> are actively engaged in back porting and testing these patches in to
> RHEL-9 and RHEL-10.
> 
> I think these issues that Dan has pointed out are all issues which
> can be addressed in a follow up patch.

I mean we already merged this.  I only got involved because of static
checker issues in linux-next.

What I'm complaining about is not so much any specific issue but just
that the process was not followed.  Normally this patch would not
be merged.  If anyone sent a patch like this to drivers/staging it
would have triggered Greg's patch-bot automated response:

- Your patch did many different things all at once, making it difficult
  to review.  All Linux kernel patches need to only do one thing at a
  time.  If you need to do multiple things (such as clean up all coding
  style issues in a file/driver), do it in a sequence of patches, each
  one doing only one thing.  This will make it easier to review the
  patches to ensure that they are correct, and to help alleviate any
  merge issues that larger patches can cause.

This rule is the same in every subsystem.  No one wants to merge a patch
like this.  But what happened is the patch sat on the list and only
Hannes and Martin were doing any review.  Karan was left doing all the
work with no help or guidance.  Eventually Martin has to give up right?
The patchset isn't up to normal standards but it's basically okay and
Martin can't do every single thing by himself and eventually it's pretty
clear no one else is coming to help.  It is what it is etc.

Please understand this in the gentlest way.  Next time if something is
important then assign an engineer to help out.  It would have taken a day
to prepare this patchset for merging.  You had seven months.  It's not
fair to show up five days before the merge window asking for special
exemptions from the review process.  Maintainers and reviewers are
already overworked, they shouldn't have to work around your deadlines.

From what I've seen Karan is absolutely doing a good job addressing the
problems I reported so it's fine.  But normally this is not how it works.

regards,
dan carpenter

