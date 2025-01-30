Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3451E1BD9DB
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 23:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738280974; cv=none; b=hS27zIk4Yz0dPO8T0LqUHGoGkt12jnrXaXxualleVMjZwO2ThkwBjyy4uxd1H6Dw9mJBUGm87OGGNWb67Od9VKblRal36cuz3dhVh+kza9fD2jdkk/tV8SvojHCISffhZQGDwbsHF0rPkPPgapVBrQ5KUvxGtwwY5zv6Jb55xVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738280974; c=relaxed/simple;
	bh=TzE9p6vJK+kd/vqvGJmfvujwjKdd4YQm02mAUDjLSdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Txp1v7awZeIHN78FxrpmXEtvqT0RcUuT8XFw9QT9/T6TqWM1Q2lrOq/+Kxmb2owSMyx2skatbWnWuDHsoGlQ6PaRZEEBi7et3tsY1lABDWdKWCd7scWtUYjVBZZSjeytMIJdnfKF2h3lHLZVnsRWwZXGMlltSL+aqJ08b2mwa8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SySEY6CO; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SySEY6CO"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-21625b4f978so49425ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 15:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738280972; x=1738885772; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=woR0BNMl78Ng0EToVcH0CgI8K44IMNq5Bk4is7GN/hg=;
        b=SySEY6COjD4FqJI4tzAbiwElHcf5Xa6PKMgT+6P/AVvXsOrm3ADrThiPXgszAr70Vm
         e7EqqEIcdSwXwPooX9coOZeEsjaCw7nzcRHsyI5BAvvS3ccctZOSGRHijBjWVO1slvb6
         z2DNalttMV3LlkDnQbOUvHaEzVchlDvQdFgq8Ta8plL0V5WLKDZjATzxhymy/8dYCEH/
         /ISZSmf0LAKfbeE7CB2zh5oiGWUS9e3odulhE0GnzKrNvgsAWkjJG3T4aCyinbI6Xr1C
         qdG6UDdtD8+HvW1QlnBu7dCdPiX9azs/HCazdZry4IYoYg/TYU5OpH4xNa42GDzSfYs7
         lQvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738280972; x=1738885772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=woR0BNMl78Ng0EToVcH0CgI8K44IMNq5Bk4is7GN/hg=;
        b=reNU3FjvizPkK/BfBbt/NFNMOwfu+BbP4i2s9NZCJ+OGG+VmqZ8+hSu4Yym1esf3XY
         VK/sOS6IoNrPQgZdWoJ7t66z1lOl0V1joVwJCZCBGGKDTjmnFOYyledAKibS1m4IYZK+
         XXHfpkwX0dSRVKA8Gb4YFTQSCTpSSRo7FGA0CwB+Xk2s3R8UpiejWILHdeo9N3iYloAX
         3Vt0xtKQvOj9nukkCRD7ZzeqzjzkGyTgTJwjVmZF3sx21iHwGX3PloYRoFA7J1atZjUn
         n8Z7XR8BN17rb4JcwGSIb3NNsAyVkZj0LRUqPGuDiqeVhE4aOemrzh7JaTCsLdKK9TDS
         CjnA==
X-Forwarded-Encrypted: i=1; AJvYcCWn680ODeRD5A1rEj5SQPNgEK8/fNSmYAhc1duYis3g5wlktpr0vcnBDnmB0TcLMv72duEFuOIreNxW@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5zDqZFEP8xesyQDy1HQzsFn9v2ZRmyd8pMmsrnsf49XLh7U+d
	MlMy/2TqM5/MkaROQYMclx4uV7cOBFS0OoEb1FmcHEdezboUXnY9nXGLbSffeQ==
X-Gm-Gg: ASbGncvJGY1H53NX3XWTb0sjQHvKxfd+zIFh67MNrsTrR3+OqrgLyz3v6Oyu7rLKtdx
	9jfOi5lxj2oLhpSYp1UVIIQr3DlxsjPEZQmjHRNTdBMgW2RH7HxDnkj/y/nNjfoHcbaepnGXnZh
	2hyV0wba++6xCNss2dmsQdoe9/MAY3ZPQvsgRbZFJdrKWPpilKTpgoTeBXjfS75OXItlTu7mGkT
	hH5sJDcF7aipzuVORLCumy7Qs78NF44P1mgtVW6kEkbFqTrwqpaM3+Cc0FlKZRE4BZswV3zY7d/
	bv3a/Ef4gGHATqprFdAMRW7lIaf5m1i3Kt4b5uDsShUtkdA7WoM=
X-Google-Smtp-Source: AGHT+IHOufC20z0nBQdOAecFf+23+39ZXOhYBxxAPbHAguO9mLeDxQV7tuiyPYnMVpf16VDWJ/sFyQ==
X-Received: by 2002:a17:902:6908:b0:21d:dba1:dd72 with SMTP id d9443c01a7336-21edf044ffdmr405375ad.15.1738280972066;
        Thu, 30 Jan 2025 15:49:32 -0800 (PST)
Received: from google.com (59.50.105.34.bc.googleusercontent.com. [34.105.50.59])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72fe631bfdasm2070744b3a.16.2025.01.30.15.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jan 2025 15:49:31 -0800 (PST)
Date: Thu, 30 Jan 2025 15:49:27 -0800
From: Igor Pylypiv <ipylypiv@google.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: core: Do not retry I/Os during depopulation
Message-ID: <Z5wQBzQIYH1iw6gQ@google.com>
References: <20250130222632.1462218-1-ipylypiv@google.com>
 <00557746-b7c6-4b34-ada7-0b4b8a21d98a@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00557746-b7c6-4b34-ada7-0b4b8a21d98a@acm.org>

On Thu, Jan 30, 2025 at 02:36:35PM -0800, Bart Van Assche wrote:
> On 1/30/25 2:26 PM, Igor Pylypiv wrote:
> > Fail I/Os instead of retry to prevent user space processes from being
> > blocked on the I/O completion for several minutes.
> > 
> > Retrying I/Os during "depopulation in progress" or "depopulation restore
> > in progress" results in a continuous retry loop until the depopulation
> > completes or until the I/O retry loop is aborted due to a timeout by
> > the scsi_cmd_runtime_exceeced().
> > 
> > Depopulation is slow and can take 24+ hours to complete on 20+ TB HDDs.
> > Most I/Os in the depopulation retry loop end up taking several minutes
> > before returning the failure to user space.
> 
> Since this patch is a bug fix, please add Fixes: and Cc: stable tags.

Thank you, Bart. I'll add the following tags to v2:

    Cc: <stable@vger.kernel.org> # 4.18.x: 2bbeb8d scsi: core: Handle depopulation and restoration in progress"
    Cc: <stable@vger.kernel.org> # 4.18.x
    Fixes: e37c7d9a0341 ("scsi: core: sanitize++ in progress")

Thanks,
Igor

> 
> Thanks,
> 
> Bart.
