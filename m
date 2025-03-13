Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B835153801
	for <linux-scsi@vger.kernel.org>; Thu, 13 Mar 2025 17:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741885529; cv=none; b=B0VBcqhJDhFkpfOyKD7ZFP85I/U5f9PWJI+f3LPHWLzbE+UU0zpnLkhe87oM8ZMl3Gzayy5+HtiALg6cud2QWnXdL6rEgRuinJR3jZ78yJ2VVc0K70FJrLXpMhd4JZL/xKBwRFwdSsbbeCLWEpTN2LqvyrXaoKHmcwex637Scnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741885529; c=relaxed/simple;
	bh=0tdzNBsSfj25tqpXiCEQFRH4wScl08lGPpx+Tet1suA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=WvhLvohJ0tB+c/RJWbKICI6e0J3sCUJPi89utl5AFJBmdjbwLVzteZsFTJcnuGPNGksvZKG2DXSijsFV7lpdB/2PI0l61+BYcXafknePx1JU5FThlMw6uukkW5dI5TYSwA0vLYYVZhawtf9xAsi40vHz6B1g4a3F3RxJ1wtQN0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IhPf2L9/; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IhPf2L9/"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741885521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aE8hTDMYccjYYSsyTRm8RFsJjGaSnHNKcMncoeQgE20=;
	b=IhPf2L9/KpHbFHjav7YwIgUmKanxHv2LFY0JAsO4Ldtb8KYr4Yms0f1Zoo0EG+vYcKSVm8
	xDYgQMDV6RCJJCQmiDnukdwzQbRUFXrSDftOyvtjFnn9aoeFdK8H3jtGorMTyM5LvzD1mX
	VdWdsvciPzmWizGhHR1bjeuIGZj5A4s=
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51.11.1\))
Subject: Re: [RESEND PATCH] scsi: sd: Use str_on_off() helper in
 sd_read_write_protect_flag()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <3c32eb12-6879-48cf-9ef6-bd04e759025f@acm.org>
Date: Thu, 13 Mar 2025 18:05:07 +0100
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <9EE4EEC5-52D9-4159-A3B4-4865DA11C6FF@linux.dev>
References: <20250313142557.36936-2-thorsten.blum@linux.dev>
 <3c32eb12-6879-48cf-9ef6-bd04e759025f@acm.org>
To: Bart Van Assche <bvanassche@acm.org>
X-Migadu-Flow: FLOW_OUT

Hi Bart,

On 13. Mar 2025, at 17:25, Bart Van Assche wrote:
> On 3/13/25 7:25 AM, Thorsten Blum wrote:
>> Remove hard-coded strings by using the str_on_off() helper function.
> 
> Shouldn't a patch description explain two things: what has been changed
> and also why a change has been made? I don't see an explanation of why
> this change has been made.

The benefits are explained in linux/string_choices.h and I didn't think
it would be necessary to repeat them in the commit message:

/*
 * Here provide a series of helpers in the str_$TRUE_$FALSE format (you can
 * also expand some helpers as needed), where $TRUE and $FALSE are their
 * corresponding literal strings. These helpers can be used in the printing
 * and also in other places where constant strings are required. Using these
 * helpers offers the following benefits:
 *  1) Reducing the hardcoding of strings, which makes the code more elegant
 *     through these simple literal-meaning helpers.
 *  2) Unifying the output, which prevents the same string from being printed
 *     in various forms, such as enable/disable, enabled/disabled, en/dis.
 *  3) Deduping by the linker, which results in a smaller binary file.
 */

Thanks,
Thorsten
