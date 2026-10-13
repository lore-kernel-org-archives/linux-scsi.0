Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A214BFE79
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 10:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791888529; cv=none; b=IwO6ygT/0ouiaynPeE9kPI++oE7chm1I4D40g4lrd0MGeYn4VNCFJgKeJslmZR6vVxi+asXEDy025fgIItIunkJSUmJE5hWt35+to7oTQEndiY+iPB3sU51aruFfbxBwUSoUPF2bWs7criSb/aABikJdFcljIB8FrBa52AzPTtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791888529; c=relaxed/simple;
	bh=blZGy86/tJF6uJSjt1YR2dARHGOLe9KOwjGX1wHxbaI=;
	h=MIME-Version:In-Reply-To:References:Message-ID:Date:Subject:From:
	 To:Cc:Content-Type; b=IIJDg0B6q88GkUs2migNGTymNSCoKxjNpmupqf8FOQ4sr/RlnkpzJaNjaxeCbBEjpcorvRmbCqs1u5YDIUKMIMs2Hmihes6lHu1GNFYni1y+eHF3jf3MvNNycswtkjxszwU7vnduNwdibQzQXvFOnhezWhYb04h56H4kb9Vdw5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mNjBAThC; arc=none smtp.client-ip=209.85.216.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mNjBAThC"
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39b77130a7fso3449001a91.2
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 03:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791888527; x=1792493327; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:date:message-id:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=eh3oVBp5pc+Gpi2M/YFtufxKkUQ8W6gcP5pdEKdraOs=;
        b=mNjBAThCcPjnet8JvE0xHriGjjC4cOA58CiNQDE7PMfhE0m60Bzo6GOcKb0+bh8eJC
         Uf9eYUOg9DrWyAnw5GmbbXBy5R8CbqSIe7qO9rW+Oaxi1EoupwgcKkpuojT908qJkk/U
         7umXRrSQdATV0uvRs5ce6WQ7nJ8wVWm6Ss3MG09IMJC6XWNjucoCKGleqQw09AFU0Psg
         NIgXBrQ1ttO0K7mh0y1YUqqKm+QaieA8LOY2jZzYUn8ppeR75kx3c8kaqzdtMFjljeO1
         E2WzC2Db+mDG5pEG94HfYchqpITz2EyW/5dHH35pZco399hD6OuRqgClQgaxtYRjE6ty
         tAeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791888527; x=1792493327;
        h=content-type:cc:to:from:subject:date:message-id:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eh3oVBp5pc+Gpi2M/YFtufxKkUQ8W6gcP5pdEKdraOs=;
        b=o0rhrxw00tcjhOlTa79sNGPSmV8DJ1ekQIdrwf7incKVCUe+oi6Ld9GOi40hujO6C2
         +IAC6xQkJu1P9Ft+U6z4Mbli5hRHWJVuL7VrUtY+dT6vFGOPdgEJcgKfBYl4AhCqm27b
         Ngzv77Ct1P+yb0r55cTLWSGqvUrZw8kl7Nxqi4ooGlCcn5eD8qpHpoypg6S8/VzvslCZ
         fLOu9Yk5pu2n/VCNHlGK95sxQnj4a9ZSutfPDruCD/P9AS3rOHc4L4Oo0UbptD5INduy
         TH6a8xzYMahARD9n4boz6XSZnyIqlSfavpCDyNd3cP2Ym0ApCwL5OpW0+b0tnhHvwQsA
         byOw==
X-Gm-Message-State: AFq9FYKtk2OOVPKzwtK0BveIsy3b3YTfOPhBZ3tpqT5cGMDDci1DUfBe
	AhTtVPCjpKfptlvbUvNbNiDVWurNQ7lmI0OnAiCp9xs9X5A5qSzihN3MymFIpFrT8INtjWx7Nfy
	QrhAAKXqC86GAyk0W5Ungyg==
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: from plbbg3.prod.google.com ([2002:a17:902:8e83:b0:2e5:c07f:b4c2])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:38e3:b0:3ab:a188:b8ab with SMTP id 98e67ed59e1d1-3aba188be6emr4223136a91.1.1791888526738;
 Tue, 13 Oct 2026 03:48:46 -0700 (PDT)
In-Reply-To: <sashiko-outbox-169530@kernel.org>
References: <20261013102913.948718-1-stanleyjhu@google.com>
 <20261013102913.948718-4-stanleyjhu@google.com> <sashiko-outbox-169530@kernel.org>
Message-ID: <20261013-ufs-dme-retry-arg3-reply-1-stanleyjhu@google.com>
Date: Tue, 13 Oct 2026 10:48:46 +0000
Subject: Re: [PATCH 3/3] scsi: ufs: core: Clear stale UIC result byte before
 peer DME retries
From: Stanley Jhu <stanleyjhu@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

On Tue, Oct 13, 2026 at 10:41:55AM +0000, sashiko-bot@kernel.org wrote:
> Since uic_cmd.argument3 is initialized to mib_val only once outside the
> retry loop in ufshcd_dme_set_attr(), can this regression cause a  
> subsequent
> retry to write whatever value the hardware left in the register during the
> failure?

> Should uic_cmd.argument3 be restored to mib_val before retrying, similar
> to how argument2 is cleared here?

Good point. ufshcd_uic_cmd_compl() always overwrites argument3, so
the DME_SET retry should restore mib_val as well. I'll fold that into
v2.
