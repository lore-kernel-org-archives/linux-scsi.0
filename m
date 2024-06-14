Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0191178CE2
	for <linux-scsi@vger.kernel.org>; Fri, 14 Jun 2024 21:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718401322; cv=none; b=uXB2OLc2PKL31hT5ep5Frlk7BrosjlDs8WZJgu5SUyH2ViQVhxm4qY0LMs8n2HnJmJA016TVhlkMP8Fotz72puEeNeTh685e2+K2mAAbKkZj7rpJExQZkzMiS9sh50ijS+DIqxDwtT5kqKdhpm5M0rR8kbdkNWvup3FG6W3cFIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718401322; c=relaxed/simple;
	bh=AzGIarMleTpdGZihUvHwAVhm55vxoLoAj283uw9kuqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jQaxPTVfXndxzNqwgOppM0G7TmvYxNUQEkjiKCZ/tc6ncCj7Qd+5UPQV7eLJLw0SfPUJ6Uz4B2qdxKmJHJs6jZe69K8f+O24z4ON+0nlz8N9oMIHTlOyC8Yd+0XJJXKiCOuxLgnBJrgzRvMgTr97P/+9smDNAlaG02Ozg9TUfX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Dsh9sCMW; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Dsh9sCMW"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-70599522368so2007529b3a.2
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jun 2024 14:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718401320; x=1719006120; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V5i3hkPFht64X0kscOL28fDTdIk9eB2a/QctdKtDct0=;
        b=Dsh9sCMW0qeh2amAOnlP24C5aMawHm0MrCnT/sIiGoRB5zpiy5/xGl4Phri1az544k
         2L2pM8VKime18Znxw3kAVukg+haYLf/j8mu8MGNb7JsjB19cPvpKS1O+hvee+Q4paY/z
         Ed4T1eZ0EZezxUXheQ80HwUALxk2U3ncCyweYh4q+npqjMGhL1J2owSC6uUIHFEM3TcO
         N1mvC+WhdH7nEK6A6g4uSqrtIdgRpdquLyrkAYezJrHwcFJ9KCQAtShQ91mjt2hA8gXg
         /1yVZw9+GabgERkAzFZFy8IVvWLLONZGcr03bxMQJxYVewTNb9UGMU2EixuRgQxK2BHm
         V7Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718401320; x=1719006120;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V5i3hkPFht64X0kscOL28fDTdIk9eB2a/QctdKtDct0=;
        b=jV8rNEzUKs171j2Y8nryBwTcGA5LCFIgztb1tgNAv5Kw9ingw+4vsJj2gPdD9redxb
         SqVFRADLIes8rYaIuHhwXBcp2wztSK1Jfp+pA7mFo5X51K0W2NPNWtVtW0kSmkHImSTz
         rpoWPtrcdd30FjaGJPy/O8RtgftAdVEjoYjoMvhtIjO9T6hj2flLlHKfHTKoZm78Mxc+
         6PPghg2RzGTF5bLbcfgqtAtRct8sspjcUR42zOTqBGGEfUpR7adXAmH5WycgFiB61hH8
         edAi3Fqf43reRr5YeBFlGqMflAnoJ1Dvy/Odk34SlO/5t7u/MpRv1KmYESqXgBJVTg/z
         N1FQ==
X-Forwarded-Encrypted: i=1; AJvYcCWog1du1IkqA9CdFiW845L/kfIM2nkOFJhLPfWMKee1uwDPxbInIQ+sTUiPvlJUnn35pGLwpYn/mk7kXg2lCw67YCUW3CedLMM73Q==
X-Gm-Message-State: AOJu0YxoO1NTu2n6Ff2j6kehbCtX/C1j6wlbkToDytuUo4aljX8J7n8o
	roRMWyjLudMgcj3+pEXbo56VaPB0Jd0aQ++L3pvPNAYexU0oPgstELxmXN2gIw==
X-Google-Smtp-Source: AGHT+IFaxZtG5Ckd+erUa5z27h4gIx3Ud+kjcBQl8pojZr5zoiZr+mZXpQ0ckmtGLLPRywzuGJn9Ag==
X-Received: by 2002:a05:6a00:21d1:b0:705:d730:1b8 with SMTP id d2e1a72fcca58-705d7300d48mr4186134b3a.19.1718401319849;
        Fri, 14 Jun 2024 14:41:59 -0700 (PDT)
Received: from google.com (148.98.83.34.bc.googleusercontent.com. [34.83.98.148])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705cc925fe7sm3643989b3a.19.2024.06.14.14.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 14:41:59 -0700 (PDT)
Date: Fri, 14 Jun 2024 21:41:55 +0000
From: Igor Pylypiv <ipylypiv@google.com>
To: Niklas Cassel <cassel@kernel.org>
Cc: TJ Adams <tadamsjr@google.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] scsi: pm80xx: Do not issue hard reset before NCQ EH
Message-ID: <Zmy5I-XNK5bffSe3@google.com>
References: <20240607175743.3986625-1-tadamsjr@google.com>
 <20240607175743.3986625-3-tadamsjr@google.com>
 <ZmgNkK8haUisJ5-b@ryzen.lan>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmgNkK8haUisJ5-b@ryzen.lan>

On Tue, Jun 11, 2024 at 10:40:48AM +0200, Niklas Cassel wrote:
> Hello Igor, TJ,
> 
Hi Niklas,

Thank you for the feedback!

> On Fri, Jun 07, 2024 at 05:57:42PM +0000, TJ Adams wrote:
> > From: Igor Pylypiv <ipylypiv@google.com>
> > 
> > v6.2 commit 811be570a9a8 ("scsi: pm8001: Use sas_ata_device_link_abort()
> 
> Do not specify kernel version (it is irrelevant), SHA1 is enough.
> 
Noted.

> 
> > to handle NCQ errors") removed duplicate NCQ EH from the pm80xx driver
> > and started relying on libata to handle the NCQ errors. The PM8006
> > controller has a special EH sequence that was added in v4.15 commit
> > 869ddbdcae3b ("scsi: pm80xx: corrected SATA abort handling sequence.").
> 
> Do not specify kernel version (it is irrelevant), SHA1 is enough.
> 
> Since the code added in 869ddbdcae3b still exists in the pm80xx driver,
> I think that you should mention the commits in chronological order.
> (Right now you mention the oldest still existing code last, which seems
> a bit backwards.)
>
Noted. I wanted to emphasise that newer commit 811be570a9a8 broke the NCQ EH
for pm8006 so I put it first. I should have added a Fixes tag to make it
clear. 

> 
> > The special EH sequence issues a hard reset to a drive before libata EH
> > has a chance to read the NCQ log page. Libata EH gets confused by empty
> > NCQ log page which results in HSM violation. The failed command gets
> > retried a few times and each time fails with the same HSM violation.
> > Finally, libata decides to disable NCQ due to subsequent HSM vioaltions.
> 
> s/vioaltions/violations/
> 
> I'm not an expert in libsas EH, but I think that your commit message fails
> to explain why this change actually fixes anything. You do not mention the
> relationship between the code that you add pm8001_work_fn() and the
> existing code in pm8001_abort_task(), and the order in which the functions
> get executed.
> 
Noted, will update with more details.

> Does calling sas_execute_internal_abort_dev() from pm8001_work_fn() ensure
> that the libsas EH is never invoked? Or does it cancel the hard reset that
> is part of the "special EH sequence" in pm8001_abort_task() ?
> 
It ensures that all I/Os are aborted before libsas EH kicks in. Since all
I/Os are aborted by the controller the pm8001_abort_task() will not be called.
Going to add that to commit message as well.

> Wouldn't it be better if this was fixed in pm8001_abort_task() or similar
> instead? It appears that the code you add to pm8001_work_fn() (that has a
> very ugly if (pm8006)) is only there to undo or avoid the hard reset that
> is done in pm8001_abort_task() (which also has a very ugly if (pm8006)).
>

It would definetely be better to fix this in pm8001_abort_task(), if possible.
One way would be to add a flag that will be set when NCQ error happens (when
IO_XFER_ERROR_ABORTED_NCQ_MODE event is received) and then check that flag
in pm8001_abort_task() to skip hard reset. This approach adds another type
of ugliness to the code and I'm not sure which of these ugly approaches is
less ugly.

> Now we have this ugly if (pm8006) in two different functions... which
> makes my "this could be solved in a nicer way" detector go off.
> 

I would be very happy if we can drop those ugly if (pm8006) checks and have
a generic nice solution.

> If this patch (as is) is really the way to go, then I think there should
> be a more detailed reasoning why this change is the most sensible one.
> 

Let me investigate this issue more to see if there is a way to drop 
the ugly pm8006 checks.

Any ideas/suggestions on how to fix this nicely are very welcomed.

> 
> Kind regards,
> Niklas

Thank you,
Igor
