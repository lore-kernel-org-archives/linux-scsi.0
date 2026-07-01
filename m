Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA0332B118
	for <linux-scsi@vger.kernel.org>; Wed,  1 Jul 2026 05:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782885441; cv=none; b=p/HvDQIQJ20I6+cCyUfAr+JgkddPmiZk7/v7ONM8NiDasqYsSLhvh/ayIKGiQ7YD1D5wnyoi+6Mb4DDOjMzJXXEplvmFo5Mn+BlW/AX88YM6uOlSKKvFfRGVf2SkZQPs3bZgHwbn+FQG7ntjgK35YBrfJ3nhkcIkVNrfRftFbBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782885441; c=relaxed/simple;
	bh=dedmJf9ZwxVmJPcQxh2RgOyzOdeRZYVhevEZ+/28HFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RX1Xd+J7F0HOjPgj/vQZNu3pRYmHQiirBheQkrMZcxzqwaWGEIGy7KaUCunlmbOd1XJfmtK4hv2HqzG70B9fpwVWYVVhSMDQYWI+u+UjQ73DI/6M/3zTB3EdrC9uUtdno51kUPDAwL271cnkrzcnDjaO1ciXjylnUNvX25dmYtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=jkz1jXrs; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jkz1jXrs"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8471013fac2so141115b3a.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2026 22:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1782885440; x=1783490240; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p9mAbfnZQOnSuCsDelXEzDCKH4tcY1XBG1BHwxBvnCQ=;
        b=jkz1jXrsxR+s1qn2TJt4F9RoNZVUS8ezS08PKT68CSVSl7kTxWBDzDUSZPRaVxXe14
         7zZMG/9HsWdGVHmotmjDohtQLHjnk7L1ua4pKEPjnK667AOghYV9boxLOhkjah2k5pLy
         OWb5HZ77G47Tc1if7UZK8CjcXNtsvrEqYTess=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782885440; x=1783490240;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p9mAbfnZQOnSuCsDelXEzDCKH4tcY1XBG1BHwxBvnCQ=;
        b=VPA41cUQoDyWMmeUe+i7Rsho3CxWNPVxrzfB0eFQFSqSzOb0T1FItjDCzNvzEBF3Jo
         MsS+wHgCR07W6Kg73QyCmN4nHTS3RV5kjlwGI73JzKmZY4+eyQEkcmlQmjsO45mXF/dG
         atzAayuH17Q4lXx6SFeHoirRwrskhJs1PMAczHe5U8Eo4vQfj5KXkmqUJWqwi4rFoFTq
         aQ7yFVVCteOyan3YTOg0GpkivpvCZVl5n0DaH5gf11aLjToVdntSsn3meeelG1r67XCi
         we2ege6al/AmacDywx0zRTPYWuezUZy7/l+E4+uNLNOQ4Gl9qOdKcjIwEUQajT4Wurb0
         XhOg==
X-Forwarded-Encrypted: i=1; AFNElJ+FBc57EVHleldweU92A+CkgSjj9mChJMUrGuKkdYDOH++WGejyA2hvI3BH+/HIL/oAvLjFQ4GYucQF@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8bTtss+zcat/J4l4ZIrQDoPGosxLb5npDHXf4CWy3WifjM21c
	A0i4sW5bRrM7HqZ86SAjWmJz6hNn7fc3N6mDZ91GQNjenvrvtmo6WmhrD3HqfyCciA==
X-Gm-Gg: AfdE7cm5HOXRl+/gTrAGhtv4Io4DWGgX6nQvYd1IHJcBinV0+Lijcv4inGDXs8gG2E9
	+DBdruLoJaQgEke4Xa4d500W0rValtqIB4kyVtfw9NjiXz6EDS10LeYJ3HAdA4GoGyazzHwFedH
	0HKImU8dVAPyHDHGDXHl1erjRLh5q/P7Oj54jvFK9CctYi2UrAW+1o815+i7XpsqsiRcGFT+jCd
	ZRKESZ3HfhjQbYZ61G6k2Y72jXPE3pk3nngeT7XtcHA1w2UPh+vwWp7iVPdMbj0aZfEny9ZJirx
	SsvDl/dS0iX6SP3QVVvITr5CZUL3u5htKM1E5HlfPgk+IvzlZg/2bXcGJiZuZK5W64MnGXI+bja
	Av//9hpBHmVRUc9wkjSfGCc5q3o8PE1HQgFtYzvwH6/1EJenfpIKUr8anY6ec3BQq2Ci+aJ81gl
	FIHgdvgyY1pEf/qXpi8GHi2oYDgIFKjRYtCOYgp8IrfboyctlnME5K
X-Received: by 2002:a05:6a21:50e:b0:3bf:a4c9:b054 with SMTP id adf61e73a8af0-3bfed567c73mr276613637.46.1782885439597;
        Tue, 30 Jun 2026 22:57:19 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:faee:2436:3347:c0a2])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9bbf95b8a4sm2538629a12.18.2026.06.30.22.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 22:57:18 -0700 (PDT)
Date: Wed, 1 Jul 2026 14:57:15 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>, 
	linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, 
	linux-kernel@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>
Subject: Re: [RFC PATCH] usb: storage: uas: limit consecutive device resets
 in error handling
Message-ID: <akSqd7HkrZI78_L_@google.com>
References: <20260701040335.810297-1-senozhatsky@chromium.org>
 <2026070157-stench-shabby-2519@gregkh>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026070157-stench-shabby-2519@gregkh>

On (26/07/01 07:38), Greg KH wrote:
> > +static int uas_reset_limit = 3;

This obviously wanted to be 0 by default (just a side note).

> > +module_param_named(reset_limit, uas_reset_limit, int, 0644);
> > +MODULE_PARM_DESC(reset_limit, "Maximum number of consecutive device resets during error handling before failing");
> 
> This is not the 1990's, we do not add module parameters for issues that
> should be properly solved either automatically, or on a per-device
> basis.
> 
> There's no way that ChromeOs wants to attempt to track this module
> parameter as a bootline config option, right?

Can you please elaborate on "properly solved either automatically,
or on a per-device basis".  I don't know how to break that endless
reset loop otherwise.  I'm open to any suggestions, the patch is RFC
for a reason.

That reset loop essentially panics the system (we have hung-task watchdog
and hung-task panic enabled).  The kernel does uas_eh_device_reset_handler()
every 30 seconds (which succeeds), while the block layer doesn't make progress
and keeps the tasks blocked, which eventually triggers the watchdog:

[..]
<6>[ 917.070222] sd 0:0:0:0: [sda] tag#3 uas_eh_abort_handler 0 uas-tag 3 inflight: CMD IN
<6>[ 917.070318] sd 0:0:0:0: [sda] tag#3 CDB: Read(10) 28 00 00 00 00 00 00 00 20 00
<6>[ 917.079434] scsi host0: uas_eh_device_reset_handler start
<6>[ 917.079994] sd 0:0:0:0: [sda] tag#1 uas_zap_pending 0 uas-tag 1 inflight: CMD
<6>[ 917.080046] sd 0:0:0:0: [sda] tag#1 CDB: Write(10) 2a 00 00 d3 98 08 00 04 00 00
<6>[ 917.080072] sd 0:0:0:0: [sda] tag#2 uas_zap_pending 0 uas-tag 2 inflight: CMD
<6>[ 917.080118] sd 0:0:0:0: [sda] tag#2 CDB: Write(10) 2a 00 00 d3 9c 08 00 04 00 00
<6>[ 917.145714] usb 2-1.3: reset SuperSpeed Plus Gen 2x1 USB device number 4 using xhci_hcd
<6>[ 917.164988] scsi host0: uas_eh_device_reset_handler success
<6>[ 917.165155] sd 0:0:0:0: [sda] tag#3 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=30s
<6>[ 917.165210] sd 0:0:0:0: [sda] tag#3 CDB: Read(10) 28 00 00 00 00 00 00 00 20 00
<3>[ 917.165239] I/O error, dev sda, sector 0 op 0x0:(READ) flags 0x80700 phys_seg 4 prio class 3
<4>[ 934.971114] rq: tag=0 hctx=0 op=WRITE sector=13867016 len=524288 age=78231 ms pid=11900 comm=image_burner state=D
<4>[ 934.971169] rq: tag=1 hctx=0 op=WRITE sector=13868040 len=524288 age=78230 ms pid=11900 comm=image_burner state=D
<4>[ 934.971217] blk: queue stall on sda: 3 inflight, 2 stalled (threshold 60000 ms)
<6>[ 947.276222] sd 0:0:0:0: [sda] tag#3 uas_eh_abort_handler 0 uas-tag 3 inflight: CMD IN
<6>[ 947.276282] sd 0:0:0:0: [sda] tag#3 CDB: Read(10) 28 00 00 00 00 00 00 00 08 00
<6>[ 947.280489] scsi host0: uas_eh_device_reset_handler start
<6>[ 947.281255] sd 0:0:0:0: [sda] tag#0 uas_zap_pending 0 uas-tag 1 inflight: CMD
<6>[ 947.281309] sd 0:0:0:0: [sda] tag#0 CDB: Write(10) 2a 00 00 d3 98 08 00 04 00 00
<6>[ 947.281391] sd 0:0:0:0: [sda] tag#1 uas_zap_pending 0 uas-tag 2 inflight: CMD
<6>[ 947.281468] sd 0:0:0:0: [sda] tag#1 CDB: Write(10) 2a 00 00 d3 9c 08 00 04 00 00
<6>[ 947.346666] usb 2-1.3: reset SuperSpeed Plus Gen 2x1 USB device number 4 using xhci_hcd
<6>[ 947.365031] scsi host0: uas_eh_device_reset_handler success
<6>[ 977.479406] scsi host0: uas_eh_device_reset_handler start
<6>[ 977.479963] sd 0:0:0:0: [sda] tag#2 uas_zap_pending 0 uas-tag 1 inflight: CMD
<6>[ 977.480015] sd 0:0:0:0: [sda] tag#2 CDB: Write(10) 2a 00 00 d3 98 08 00 04 00 00
<6>[ 977.480042] sd 0:0:0:0: [sda] tag#3 uas_zap_pending 0 uas-tag 2 inflight: CMD
<6>[ 977.480089] sd 0:0:0:0: [sda] tag#3 CDB: Write(10) 2a 00 00 d3 9c 08 00 04 00 00
<6>[ 977.480137] sd 0:0:0:0: [sda] tag#4 uas_zap_pending 0 uas-tag 3 inflight: CMD
<6>[ 977.480166] sd 0:0:0:0: [sda] tag#4 CDB: Read(10) 28 00 00 00 00 00 00 00 08 00
<6>[ 977.545653] usb 2-1.3: reset SuperSpeed Plus Gen 2x1 USB device number 4 using xhci_hcd
<6>[ 977.565338] scsi host0: uas_eh_device_reset_handler success
<3>[ 984.123394] INFO: task image_burner:11900 blocked for more than 122 seconds.
<3>[ 984.123501] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
<6>[ 984.123517] task:image_burner state:D stack:0 pid:11900 ppid:11893 flags:0x00004002
<6>[ 984.123577] Call Trace:
<6>[ 984.123603] <TASK>
<6>[ 984.123659] __schedule+0x5e8/0x14c0
<6>[ 984.123688] ? free_unref_page_list+0x25d/0x290
<6>[ 984.123715] ? lru_gen_update_size+0x1e3/0x220
<6>[ 984.123763] schedule+0x5e/0xa0
<6>[ 984.123788] io_schedule+0x47/0x70
<6>[ 984.123814] folio_wait_bit_common+0x18a/0x270
<6>[ 984.123863] ? __pfx_wake_page_function+0x10/0x10
<6>[ 984.123889] folio_wait_writeback+0x35/0x90
<6>[ 984.123937] __filemap_fdatawait_range+0x162/0x190
<6>[ 984.123965] file_write_and_wait_range+0xa3/0x120
<6>[ 984.124013] blkdev_fsync+0x39/0x60
<6>[ 984.124040] __x64_sys_fdatasync+0x4c/0x90
<6>[ 984.124067] do_syscall_64+0x6b/0xa0
