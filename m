Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C79935293E
	for <linux-scsi@vger.kernel.org>; Tue, 20 Jan 2026 04:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768883964; cv=pass; b=cLIB2h1C+EaBd41WuM8glqu0Nx67phPR53ofH+5elA7JxcmRNN1qoWk3daaOICzSzRD/InuXe0Uz3q6oWqO19EkkTL3LiP3vpXKpf7ejmsUPpJwygx5De7XLMJpPqf7KRQK9c0CWz7Qt+mMrfqIfv0egzG6gvjapZxlcUUjEVDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768883964; c=relaxed/simple;
	bh=zCVFz71yzFQEiUNXAt527QmmS1XgYNzb73rYtTbTHZc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n1lPxQhJSdrHxZXMgpcIcYcquq+g8mehBoe4M1AoxPpYKSOhD83VbISV9YQ9rlCaFTJ1EeHxNI9HvHskmv3gfQ9raY+dieL+2OA9IMeCrducjkbI9Eoke8vWbJE6ctOL82gSeRD40deVT4WaNTUR7liIB7HQGLIKWlb5k6+sS7s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ODbcHH3s; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ODbcHH3s"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64b6f22bc77so869764a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Jan 2026 20:39:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768883961; cv=none;
        d=google.com; s=arc-20240605;
        b=ZnpO5PniusnoB3WSX6J+QHzxWYWU2vvLxgNLFAQVWMs75HLU7x2J6AQeSWqgfMyhOH
         nJnJSXSc/lcfTp6GPRNHRhjyE9F6mrO5c2Alv7P1PUWU56mtVmz5Dfn4CWE6Q5z7ca7B
         fNjtPsGsWgy287k9vm59ARVKkOtRyNzXuMD/AnlrZuycr4Du9UBfzDzme7hykcNMOha3
         GVZShq1jX51ZhBY9wlHtQHqnIf0Nh7CWRbIgc4kamaxE7bEalhhtrGiOwaZiTUg8CVkZ
         XnYb0fDwCdaX/qb34sIuZRsNAi+dSOGDDbtC+gN/OOJGwv2xmSndR/zTWGJ4CQvtOeJz
         MERg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=zCVFz71yzFQEiUNXAt527QmmS1XgYNzb73rYtTbTHZc=;
        fh=pq1Kft+ITWEz54OAaPjTmwg056oxsHRHYQx3o/vqDjI=;
        b=hUlVFVdLB2EA4H5va1fV3KVBuA4TLlz4h3jxk2mrRkUiJFMaXkpyb3fEw99JHIJMC6
         SxuEPk4/9HVWfN+1AOxF+JvdDxWrLN2R6rJrLk3p+wrdq+UBRV8NiJx3Qh083cnY+72k
         CwOZeY5wVMP+L2MPDIHCS+CeztRB9GdRwr2cPw6ynAo0gbnf+JwOyr2VO29aRgAHXx2V
         qoRZI5Ar6mfkx7AVqSDDVtmLNlOYquMU1NgTjvUbzlmGgXCks28O+vM9wO2wR0BYWTSs
         IxCUrlaDDxP030Ab+3or6SiyU+qRTRviWLBTRGjQLIYrvl6Aqm02o8cT3vkq1J4svpfT
         vq5g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768883961; x=1769488761; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zCVFz71yzFQEiUNXAt527QmmS1XgYNzb73rYtTbTHZc=;
        b=ODbcHH3sFo9jKGOx5m4RQ4YQ2+11IiRRCKjFT8/PahU/B1f/JJp7U2E0Kk/kr7U0Y0
         lj3GSK3wrvy2ZOiRtSPHjHS6d5Hd0zM9FLAEXOZCUut0/xcTZCArIG0OOnpmZ6UGW1ET
         SA8XBIt+3hBeU7J8hQfg4Xbnh+xs3IFQUASOpAIx5z7TnWKOgIqaoi6TRsq8r+NH6vg1
         ZyJ9NyoMuYAEaSDDw/p8S74vs4oXGvSG/bXiSsdu8ZGGMEhmTbo3Uzd8Fr1J20oAOVII
         5Py7KW5G1Z+vyiv+7mV23pxdGCnJDkAlhQmfOgo+l4/CmES4qKL9kirWY/BKH9IqJyl/
         tUPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768883961; x=1769488761;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zCVFz71yzFQEiUNXAt527QmmS1XgYNzb73rYtTbTHZc=;
        b=qB+ZItkDm4b0HGYMb+95JNswAF1x2TeOKKkOjCucs5bSHeVSRLioA7YbMaKY9noc06
         A9rhahBlcdkWux0RfvW5dKWJdugdGKkc6mLEDg7QnJbTbIrxQb1ejjdrIlKdhp7vwiJk
         tjbPSqTDQq2RSRArwj3sgNjYC01XnzNaEjyqCTrHsiJU0gNk3EB03zm7tQJ+xTs6Ur80
         xn2vFhw6mhPBJ/CGNr9Yy5ip/+NPfHqfk+BsLugFXTzcqzEXBIEpEjfYlmzzRuLFJ9vv
         l1tizADYJRyClRwKLeDP7V/wpD+e6NNhD7eifupai7OGkWM3Degj0Nr0lwFf2ia1CXxa
         eahQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVfA9yTW0aGEjpDgNqb1oQC97ewxgAgnw/nVaTfnWs+ZWwqgvWr1bgn08V3rF0UQH51+7Ih8IRMCjA@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4I3VN8eOCXBUTsOzQ+DEY57bexw8JsViPb4q6PUSyK7u0FVWC
	mx8dKULvNXV0yhqIKAVf+c2IDBgHTTmVJvqbrege3on3JA3HFr+Icgox8Jek2/b6qEYXeOydfIg
	HgzME/3xe+hsRF4rhoDDQ4kThIKhyU7A=
X-Gm-Gg: AZuq6aLVc/AWimOYR9O4FM5EKYtiNQAZmtRVoUrawahl6V0jAkhRudrzc13sbeV/4XP
	C3GRk7xH6sO4msTs9uatBVqStg5F4AWN7iEfdMm2tYCFKvVhxEw1aKA7xXnjF3hUpiuF3lH1xdR
	nBzQWLdhhIBPhq3vbtrg4FB1VKyMDXooybG0n7gorcoKRIl1MjOcCEwr/nNb0sBrwsHiIO4ZXPY
	YMr28tykhp4njKGEGgBbvUMz/Rsm4qIdaWtCM2n9nNHaWrfC57l8ILJHKH+Hhsqv52QB7M=
X-Received: by 2002:a05:6402:268a:b0:645:7d1b:e151 with SMTP id
 4fb4d7f45d1cf-657f93d5ee1mr841596a12.1.1768883961047; Mon, 19 Jan 2026
 20:39:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260117101948.297411-1-dg573847474@gmail.com>
 <ae5cae8b3c4e71cf23b6f48453797ac48bea5914.camel@HansenPartnership.com>
 <CAAo+4rUkmuOruVVVNYePyfqu5OgxUxWupEBwvJg7Aus3g7WDqA@mail.gmail.com> <d7040eecadcc3557c04c27f0c74ce40b2885c311.camel@HansenPartnership.com>
In-Reply-To: <d7040eecadcc3557c04c27f0c74ce40b2885c311.camel@HansenPartnership.com>
From: Chengfeng Ye <dg573847474@gmail.com>
Date: Tue, 20 Jan 2026 12:39:10 +0800
X-Gm-Features: AZwV_QiUSyJw9EUMIr_YILF_U3MJnzVyEtmH7QKaHzOyP8Ch71lde2vGmtKgxHE
Message-ID: <CAAo+4rX8HT_3zKEQ3vULN-B8StnwsT-7DQPoFCOedZLrMngASQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm8001: Fix potential TOCTOU race in pm8001_find_tag
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Jack Wang <jinpu.wang@cloud.ionos.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> > Sorry that I might miss something as I am not very familiar with the
> > code. But I also notice the find_tag() function is also invoked
> > inside the abort function (and invoked before the completion).
>
> This is part of the problem, though: you're apparently using some tool
> looking for data races in an ancient driver but most of what you find
> isn't significant and costs us review cycles to check.

Sorry indeed for the extra efforts caused. I am implementing an
experimental tool to check for concurrency issues. I didn't mean to
bother you on purpose (but apologize if it did happen), as I just like
to report some potential issues and improve the security of the
codebase by fixing them.

> So the theory now is that in the couple of instruction cycles between
> checking lldd_task and dereferencing it to find the tag, it goes null?
> That's so astronomically unlikely precisely because abort is only
> called on a task that timed out anyway and the completion function sets
> the state done flags, which sas error handling checks, long before it
> begins to free the lldd_task.

That is also the point that bothers me: some races like this one can
only happen under rare scheduling due to the small race windows
(despite not being totally impossible and might be reported by lockdep
one day), and could introduce a security impact (like a crash in this
case) when they happen.
Also like this one:
https://lore.kernel.org/linux-scsi/CAAo+4rVWOzkz+HMc99c2D8tf2ZuwYHq39+jejaXWxD-PvUAuOA@mail.gmail.com/T/#t,
it is a UAF race between device removal and ioctl path (if I did not
miss anything), if measured by CVSS, it could be scored as a
low-severity vulnerability.

Will be more than appreciated if can learn more about the community's
attitude toward this kind of data race issues: do you prefer to fix
them as a preventative measure (especially if the fix is harmless), or
only like to fix them until they are encountered during execution, or
like to fix them if it is in important code like subsystem core
instead of an ancient driver?

Thanks again for your reply.

Best regards,
Chengfeng
