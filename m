Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B12131731
	for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2024 17:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708016870; cv=none; b=ZEoY3V2IdnSwvQLSRVmtrqR8oAMJBPYtxi5ySCkVtucuULj6GgtrZoiVGJ+g2aBasa12zUd0pA5FaRtOENSZFp29NyHApZotVIB7FT+apCbaPG1hsE/q9/hM49pgU5Fi/JGcPQ8cOd+8uMI9jzu5UbwUJWUMscHMcbiKK33XO38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708016870; c=relaxed/simple;
	bh=BqCtoCQHrzAUwiYaaLwqGf982YndP73amvuwOmKCxXw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rmS9Bh1kzb58QExLPNAOjG+pJeWuBgwDS5Ra0XmtU9pCZ3JAWbKjaGem5U/583uK3lsa8OD8YtfCsUEKJyQkHSaOxBktV5AexPmQltBLeNY2rJA8HdORClL0jIflEDirqwd8EmwI0Pk+nUaL9RU0Anrz8pL706Sknl3UQoUFO4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VAuLitYL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VAuLitYL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708016868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BqCtoCQHrzAUwiYaaLwqGf982YndP73amvuwOmKCxXw=;
	b=VAuLitYLLR5lJWkCAymzuCesG++iqc8IsThXRRMTkXCwzRy9JhFXho6B/zIwZNdafvK3+L
	slsvWIdZ3ryVIgDdKk2XZn8Cc7YVliseIcneVwXkelf9485tqe9oF4lJNxE/cAhKfn+ePT
	xZnrcpLdqH2iGG68K8Vfo3QQ2PiDXm8=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530-PM0_pzlTNbSWtO4B8u9J2Q-1; Thu, 15 Feb 2024 12:07:46 -0500
X-MC-Unique: PM0_pzlTNbSWtO4B8u9J2Q-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3c03ab9d0d0so1626932b6e.3
        for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2024 09:07:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708016865; x=1708621665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BqCtoCQHrzAUwiYaaLwqGf982YndP73amvuwOmKCxXw=;
        b=bwC0qQkjmADOZ6NVSKBUmSufeBRZyNP6IpRO29KnAbDLMqu32k18xfsyjb1LYJZ4gZ
         XyyBIT5jaqWzgbkwd60NQMRWg0I9bO/8Tax2Cm65ynBhkSR+Oy7GPVrgQqlibkeiP3bK
         DDolecQ/6Vl7hXXaZoLXtEt3/Pk41YPAcBGjvrY36oA25uj03FVaNgRa2TT6Kn6/AFO1
         XfN8W6CdjxjHXTsOXgxKYivMdUvvqaYolTuUiECcOTVg7Q8r0JnPtPn2nSy92RP3qbu1
         sNCUES5doA7XnNozDk0ClAcieDa9/8GqWnAAunrFl8BqpEoIhrAfWlka+zV+/rGkT2Wh
         8D2w==
X-Forwarded-Encrypted: i=1; AJvYcCX7SfEjKn9uDfCQV3N4Ssoz5BxfNaijBoWhl2wgBO1DsTinr5jXsPt8D7o4jsDDpXtJSJQcqr5QAf2WMoidLFat/WCfafsKI7o+uA==
X-Gm-Message-State: AOJu0Yz4g+gmGzrj9lUme74us5VdPj5qb5197N1QcYzx+jVtkW91Wabp
	J9r+Undc1ane9VWzyWW6W3KvVGpZxpWO/RA4d+ZNhYPaLO1dUW/R1aEjjlPbi8YIhQAjNn4vZv8
	aufjgKvTjX8oxXjXXhcC82oACkIqtEJhU5GIIxXOTGTHmKtXIP7L+z4+hW93t/jtyUXZFd1y74S
	a7rlXIGyMU9vfKt2OxkpDIv4aA5iMGa/6x1kMjNOKVWw==
X-Received: by 2002:a05:6808:10d3:b0:3c0:b3f3:c30f with SMTP id s19-20020a05680810d300b003c0b3f3c30fmr2810395ois.9.1708016865020;
        Thu, 15 Feb 2024 09:07:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IESlgFGH+F95Jh9Jxk2Bvz+hi3v+FJokWREsaOdPcDYPEwsceqiqPlNbNqKY2qZyuKcggGWY/ikrQz3XF/BqR4=
X-Received: by 2002:a05:6808:10d3:b0:3c0:b3f3:c30f with SMTP id
 s19-20020a05680810d300b003c0b3f3c30fmr2810377ois.9.1708016864663; Thu, 15 Feb
 2024 09:07:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240215143944.847184-1-mlombard@redhat.com> <20240215143944.847184-2-mlombard@redhat.com>
 <094cd372-eb90-4738-acce-a3725dd2c0fb@oracle.com>
In-Reply-To: <094cd372-eb90-4738-acce-a3725dd2c0fb@oracle.com>
From: Maurizio Lombardi <mlombard@redhat.com>
Date: Thu, 15 Feb 2024 18:07:33 +0100
Message-ID: <CAFL455mD1XEYqRb80K1REHVeyWVmD2yKEViMY-AYqxhJ8bpQBw@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] target: fix selinux error when systemd-modules
 loads the target module
To: michael.christie@oracle.com
Cc: d.bogdanov@yadro.com, target-devel@vger.kernel.org, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	james.bottomley@hansenpartnership.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=C4=8Dt 15. 2. 2024 v 17:44 odes=C3=ADlatel <michael.christie@oracle.com> n=
apsal:
> Do you need something similar for the pr related dirs/files or how does
> that work but not this?
>

I think that in that case it won't be necessary because the pr code is exec=
uted
by a kernel thread that calls the execute_cmd() callback, not by a
user process in kernel context,
but I will try and eventually I will report back the findings

Maurizio

