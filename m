Received: from mail-ot1-f65.google.com (mail-ot1-f65.google.com [209.85.210.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AA21E0489
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jan 2025 19:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738091894; cv=none; b=ETkuXSRzPe2/U4lDnzrwDMfN/NeTBFp8LyneJGV2ZX+pLoxWKaK7eMc5sgBk7PFdZPGD5TcXtkFwOjAadEEvh4M1/1bEyX1BJhIesy3s2RsW4MasI6VkO+usvySPNNR3DsdWsuMhzyG4JAPvHEculWJhwZw7NDQOf+6qvnBVsuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738091894; c=relaxed/simple;
	bh=lIi5aGFP2IEAzTwIUSiMFRhWVGEd/L/9CRk+XDjd4tw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CD+iT8907wWbhw+1DNGaxos5aXRBQHNJbdmBeaUwn6SL7sgYz5sCrSAF/s4N+0I30D+pOG4I4jdwnYHC1ZEUfCir0n6nrjFaxdT6rZ/zlVUIAMgjOm17Ewr+QDOngC0MnGJF6v7b8YiuOpfuHQ1A8mKAu/Qri3Ng2VhijXRAv9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=mBGR69cJ; arc=none smtp.client-ip=209.85.210.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="mBGR69cJ"
Received: by mail-ot1-f65.google.com with SMTP id 46e09a7af769-71e17ab806bso3012779a34.2
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jan 2025 11:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1738091891; x=1738696691; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lIi5aGFP2IEAzTwIUSiMFRhWVGEd/L/9CRk+XDjd4tw=;
        b=mBGR69cJAYzDQOCdxwJcXdnwnoSQYTrpDLVASZQJFHP9mM+GQ8vbybf9RvH/QGqonH
         MXt9hDB/wWgM8d2hBKkWdqTmx+jZCCK5GtKg7R6Qgln9Ttt7zV6P9naVYwzNQmU1xQPT
         B5EHi2obkjeRkEOCwQRZoaZNeKdFYqVJm7hYwZb34fC/yZztYAeyDjf4EDfnE8DVJHjb
         BHSHyLFDWFgPS69ZAvX6BGKw8T1Xf2TlKgVjk3H7jKsN1pT55KWodXatl0IN+iAe64GV
         r56hRmhzhhpM51idYcYQRWZcMGTa3kzCzODzHVXuGzp+PHEFCeXHhjuFFZNa5t29pPpD
         jC/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738091891; x=1738696691;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lIi5aGFP2IEAzTwIUSiMFRhWVGEd/L/9CRk+XDjd4tw=;
        b=RnYcJyVnft8yfUnpHb7TtRRPfncgKr/TTrPNfjSmeoUbpA+WMxuEXVGMM6SWRcbaPv
         CysEdS4J6pskg/+BQbIiCXfiLWMMoZp64HOK+TBkstsQy4JILWmD1GjJED36Txr6Mr/9
         sv5lu/hGtSBRmEuuqqz3FJQrwltw0u3um5pW6wbVqjtIHGrjzPdJVsFB1PNsfW55iq/1
         ipIcEzK6y1/oyCmY4M/M4oUr4USY0jnypyGliFO9M8SMQizfvfD0aqC+jNnoBm9Sh8et
         OD1OK0rVnEQpKWs3UCBJjHuq//SBOqesz6AEuOIfp2A9/qSOacWn7+jZe0QVTINl6sdx
         PjJA==
X-Forwarded-Encrypted: i=1; AJvYcCV8zI9XoYKj6zWbApl5bWK9YPloj+HqIJcwAvMhtUHYJu30vxWY9dBPqdMRzOb8QK0yJAzP7OPUw31O@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+kri+bio+K4XQNVgSsGbwucUzNNHlC59cGiAsG9OdasuKF12s
	UIdjlaMOWyJjRd/K0mg+jCZoHpwg492Wr1dVDW3sLMqfTFxK8slDxLZZlDr7CWU=
X-Gm-Gg: ASbGncsPcqeczlgoqWHSX8OQaPoxO0/hpgMOKd6Z1Cvrdv/l1zQsG9MIF46CR3yckf3
	LbTIeYFWBGgXk26Wj8P6lYx+vdrH/Q94kWNTuV8ToblgAH5ZymRGJdNGg0CiECl9S6hVzSwKp8Y
	keDP3BRtveXgtl2MIbizNMZAMzrT0SHZU9JVHagk/vULHIHx/GHIeKJITtZgsyO95AnCOn8UhGB
	TayWZi82HtpHe7Wxw7hzEB68jdcY2Pu3oiEpnWxxuw2DxUmFpG06IRkOJ1GSlSrPx96xAEp0Dri
	oNhe6Q2bOkcr6YKXVsIZu8IqqwU5NsM1gfQksbc=
X-Google-Smtp-Source: AGHT+IEjj2rtRUozTb9q5zkBHOg1wyDd4Rrejwp3BNX/ud35ztXOcJmJGsoflwx7Navl7s/qXjvFqg==
X-Received: by 2002:a05:6830:2785:b0:715:4e38:a181 with SMTP id 46e09a7af769-726568ef39amr124059a34.25.1738091891422;
        Tue, 28 Jan 2025 11:18:11 -0800 (PST)
Received: from ssdfs-test-0060.attlocal.net ([2600:1700:6476:1430:8c93:8016:7aa2:be80])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-724ecf9cfaesm3161965a34.63.2025.01.28.11.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 11:18:10 -0800 (PST)
Message-ID: <0ede6faff6ede40081047ed0397b9f8b3f5977fc.camel@dubeyko.com>
Subject: Re: [LSF/MM/BPF Topic] Energy-Efficient I/O
From: slava@dubeyko.com
To: Bart Van Assche <bvanassche@acm.org>, "linux-block@vger.kernel.org"
	 <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org"
	 <linux-scsi@vger.kernel.org>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
  Jens Axboe <axboe@kernel.dk>, "Martin K . Petersen"
 <martin.petersen@oracle.com>, Christoph Hellwig	 <hch@lst.de>, Qais Yousef
 <qyousef@layalina.io>, Tero Kristo	 <tero.kristo@linux.intel.com>, Can Guo
 <quic_cang@quicinc.com>, Avri Altman	 <avri.altman@wdc.com>, Bean Huo
 <beanhuo@micron.com>, Peter Wang	 <peter.wang@mediatek.com>
Date: Tue, 28 Jan 2025 11:18:09 -0800
In-Reply-To: <ad1018b6-7c0b-4d70-b845-c869287d3cf3@acm.org>
References: <ad1018b6-7c0b-4d70-b845-c869287d3cf3@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2025-01-27 at 14:34 -0800, Bart Van Assche wrote:
> Energy efficiency is very important for battery-powered devices like
> smartphones. In battery-powered devices, CPU cores and peripherals
> support multiple power states. A lower power state is entered if no
> work
> is pending. Typically the more power that is saved, the more time it
> takes to exit the power saving state.
>=20
> Switching to a lower power state if no work is pending works well for
> CPU-intensive tasks but is not optimal for latency-sensitive tasks
> like
> block I/O with a low queue depth. If a CPU core transitions to a
> lower
> power state after each I/O has been submitted and has to be woken up
> every time an I/O completes, this can increase I/O latency
> significantly. The cpu_latency_qos_update_request(..., max_latency)
> function can be used to specify a maximum wakeup latency and hence
> can
> be used to prevent a transition to a lower power state before an I/O
> completes. However, cpu_latency_qos_update_request() is too expensive
> to
> be called from the I/O submission path for every request.
>=20
> In the UFS driver the cpu_latency_qos_update_request() is called from
> the devfreq_dev_profile::target() callback. That callback checks the
> hba->clk_scaling.active_reqs variable, a variable that tracks the
> number
> of outstanding commands. Updates of that variable are protected by a
> spinlock and hence are a contention point. Having to maintain this or
> a
> similar infrastructure in every block driver is not ideal.
>=20
> A possible solution is to tie QoS updates to the runtime-power
> management (RPM) mechanism. The block layer interacts as follows with
> the RPM mechanism:
> * pm_runtime_mark_last_busy(dev) is called by the block layer upon
> =C2=A0=C2=A0 request completion. This call updates dev->power.last_busy. =
The
> RPM
> =C2=A0=C2=A0 mechanism uses this information to decide when to check whet=
her a
> =C2=A0=C2=A0 block device can be suspended.
> * pm_request_resume() is called by the block layer if a block device
> has
> =C2=A0=C2=A0 been runtime suspended and needs to be resumed.
> * If the RPM timer expires, the block driver .runtime_suspend()
> callback
> =C2=A0=C2=A0 is invoked. The .runtime_suspend() callback is expected to c=
all
> =C2=A0=C2=A0 blk_pre_runtime_suspend() and blk_post_runtime_suspend().
> =C2=A0=C2=A0 blk_pre_runtime_suspend() checks whether q->q_usage_counter =
is
> zero.
>=20
> It is not my goal to replace the iowait boost mechanism. This
> mechanism
> boosts the CPU frequency when a task that is in the iowait state
> wakes
> up after the I/O operation completes.
>=20
> The purpose of this session is to discuss the following:
> * A solution that exists in the block layer instead of in block
> drivers.
> * A solution that does not cause contention between block layer
> hardware
> =C2=A0=C2=A0 queues.
> * A solution that does not measurable increase the number of CPU
> cycles
> =C2=A0=C2=A0 per I/O.
> * A solution that does not require users to provide I/O latency
> =C2=A0=C2=A0 estimates.
>=20
> See also:
> * https://www.kernel.org/doc/Documentation/power/pm_qos_interface.txt
> * Tero Kristo, [PATCHv2 0/2] blk-mq: add CPU latency limit control,
> =C2=A0=C2=A0 2024-10-18=20
> (
> https://lore.kernel.org/linux-block/20241018075416.436916-1-tero.kristo@l=
inux.intel.com
> /).
> * The cpu_latency_constraints definition in kernel/power/qos.c.
>=20

Sounds like really interesting problem and topic. Thank you for
suggesting. :) Yeah, we need to do something with power consumption.

Thanks,
Slava.

