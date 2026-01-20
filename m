Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B5E2BEC30
	for <linux-scsi@vger.kernel.org>; Tue, 20 Jan 2026 12:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768911564; cv=none; b=LDf+AyHEDxOtR1lKo0C12YmfX6DMQGc8078mUZcQkWGf7euk2eVdAAnqWIGRZibUeKdr4sCGyHnQEI0lJSGiXPzmc3T4e+08QKLwpz0t9HtDr1ATCxoqJL3pxFlcEs/elFtjYkhynj4dLxZL2mwPaeZd7Voax4JTvSy4FVZbhbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768911564; c=relaxed/simple;
	bh=2KvCyCocUvhozP0lgfo4QP6VQ+LksXXCA70hLkKAC+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UPgFDBaOR1kzKM27EpXp1eRvWrNXTqImpqicPgQakMs3gSoSu5Qil0k6e0rdo4ZYv7aUrw6s2E6Oyb1TG1Bg6nnM4YTtVcODwo1LZM1uq7IXjLMYhE4yyi6ME8SJSpjvqCTR6yz20iC4w6H7VQ7PWqDQYMiGp8EWQ3sLeiJHGa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hCXhxA1C; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hCXhxA1C"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b876c0d5318so715008466b.0
        for <linux-scsi@vger.kernel.org>; Tue, 20 Jan 2026 04:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768911562; x=1769516362; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bTlH6sfXE1zg5nhlIgaNXQfsuF1mmB4Q6IbEq4Q5plo=;
        b=hCXhxA1C3MO/MGTe9gpm+glp8alCQpzSdH7ovE+HO+kyvOEVjBDQDymhzORRQb/T8g
         ms8LzfRFjTEtlzd2AFmdztgXiTvwQYNGbo4RLWMhxdNMq3S6fPG2agPGFQGql/L4GLFd
         yrt8VObRIlVXy4gbIG1N0mzGk3Fba8hNiaSCLDk64rWV4qgZnoJ7goMIoJrZesTFclul
         6btS1Y4hLNmqLPnLgG68GN9HxT1LlgcPKc535Gyu7AgELvaPQ7JzGqGl265HjC3SSCSR
         OsQfXnXNGCJuSHOJIpzVNsk07mV/p7VCK3LzRotYi+xavHRyeS0LpVYjsjsPk2QrFh+N
         NwBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768911562; x=1769516362;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bTlH6sfXE1zg5nhlIgaNXQfsuF1mmB4Q6IbEq4Q5plo=;
        b=svSdpcGPTX2/tcenXxibVwrqbCQIgWUml/15b2QL+ASAJwtPHapymT8oUJ2ySOqP/s
         YDQns7LpshAsIUmEQ4zgK99XnZlPDGte1HmWIE+qjyeBNn/U5OsyX3LuL1Kj8mhJGO8q
         G6m5gbyTdzXpYBV2rGYfr6vortQeYk/qdk4l515Fqqyl5yG2tPwK6RHlPpVW2EAq4VN1
         Kb/qTvRGDla4tJUFsMYtSVHQh3CwtsuuRV0yv8PFQxNVmQhSw6YtTrSvGQhslE1kToLv
         rGH1HHVdLS9Qa7lryALrfNZfFA6k/4TvENN3qa9P2q1QE6y+D3JF+udtn6afUg0c3I4T
         KPUA==
X-Forwarded-Encrypted: i=1; AJvYcCVqCZmCffvFxqn7ox8S16cxeTt7hb0hv8wtfaSk5ObWQgmFEMcoXkUXIPUQjAWN/jlIYlEFDe33khtj@vger.kernel.org
X-Gm-Message-State: AOJu0YwO/Ye5Nm7vbZ0c9oblIXsr8z2dC+yVL5Gv67QgHs9GL5wUTILK
	wrp+VU1bK0+5U/i4sqHRlKcGosC/K75YgL1gA0ukTGGqWmJuFzYzywrp4RMk6A==
X-Gm-Gg: AZuq6aKMln4x/ichY3yzR9mQG53de9HvLOWmNmfU9APJKT1FrxtAvqv+4CvLVfWvp2o
	GBpq17pHkBqTdmb8uKGaPM+a3VPTewMJXgzZ5hHchHY7n7vMYkCsevXwHn1jjtUZ6scf7EhZ/Cd
	7k+FrajwEx+qlwjBVXVopVXqWzdpiHXBHMb96a5+B4JhdyVva0CBsT9JgAFzdDiLj/sot123xZ5
	tZOwCe98nWq9SqSw933Ii86vREPUVu0/GrJ7xzp1BhsGwQYR89a01fLnuxMdESLxTZFa7LVlALt
	l7rVfyI8mGDM2hz/Km7O2Ih1WQ59kCBLPBYGN7r4u7osHYatbjc0VT02ciSVNXXk1H7dUfNBjel
	GY+lOhVr66aUBZZg23OvPzP6GOOCZmZfvYr+mPxZlAE/6SXtjvUS0RdJv2cUzbAD3/1HnV+qdUH
	b9SxDk7skgfJtbdJU7kqpBmpf+JJW/nWnSOlC29Q==
X-Received: by 2002:a17:907:94c8:b0:b87:28f7:d3b6 with SMTP id a640c23a62f3a-b8800260af7mr140708966b.19.1768911561198;
        Tue, 20 Jan 2026 04:19:21 -0800 (PST)
Received: from [172.16.40.202] ([193.207.183.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8795168e6asm1466245466b.22.2026.01.20.04.19.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jan 2026 04:19:20 -0800 (PST)
Message-ID: <04811e0b-efc5-47ff-ac16-a97f49280bb7@gmail.com>
Date: Tue, 20 Jan 2026 13:19:18 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Sd card race on resume with filesystem errors (possible data
 loss?)
To: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
References: <3bb03946-eb11-4e28-a72b-e958833bb5cc@gmail.com>
 <fe070d43-f9b2-45b2-95d8-477154b28dea@acm.org>
From: Sergio Callegari <sergio.callegari@gmail.com>
Content-Language: en-US
In-Reply-To: <fe070d43-f9b2-45b2-95d8-477154b28dea@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 09/01/2026 21:57, Bart Van Assche wrote:
> 
> Please post the patch on the linux-scsi mailing list if you want it
> included in the upstream kernel.
> 

Hi and thanks.
Before posting the patch, I would like to provide more info about the 
situation. This is what I am experiencing after resume from sleep (as 
seen on the system logs):

These are the lines that follow "PM: suspend exit"

Jan 19 11:56:43 coccobill kernel: sd 2:0:0:0: [sda] tag#0 device offline 
or changed
Jan 19 11:56:43 coccobill kernel: I/O error, dev sda, sector 2470304 op 
0x1:(WRITE) flags 0x1800 phys_seg 2 prio class 1
Jan 19 11:56:43 coccobill kernel: BTRFS error (device dm-0): bdev 
/dev/mapper/luks-7223e129-f73a-4877-98fc-bc00384ce937 errs: wr 1, rd 0, 
flush 0, corrupt 0, gen 0
Jan 19 11:56:43 coccobill kernel: BTRFS error (device dm-0): bdev 
/dev/mapper/luks-7223e129-f73a-4877-98fc-bc00384ce937 errs: wr 2, rd 0, 
flush 0, corrupt 0, gen 0
Jan 19 11:56:43 coccobill kernel: sd 2:0:0:0: [sda] tag#0 device offline 
or changed
Jan 19 11:56:43 coccobill kernel: I/O error, dev sda, sector 337600 op 
0x1:(WRITE) flags 0x1800 phys_seg 3 prio class 1
Jan 19 11:56:43 coccobill kernel: BTRFS error (device dm-0): bdev 
/dev/mapper/luks-7223e129-f73a-4877-98fc-bc00384ce937 errs: wr 3, rd 0, 
flush 0, corrupt 0, gen 0
Jan 19 11:56:43 coccobill kernel: BTRFS error (device dm-0): bdev 
/dev/mapper/luks-7223e129-f73a-4877-98fc-bc00384ce937 errs: wr 4, rd 0, 
flush 0, corrupt 0, gen 0
Jan 19 11:56:43 coccobill kernel: BTRFS error (device dm-0): bdev 
/dev/mapper/luks-7223e129-f73a-4877-98fc-bc00384ce937 errs: wr 5, rd 0, 
flush 0, corrupt 0, gen 0
Jan 19 11:56:43 coccobill kernel: sd 2:0:0:0: [sda] tag#0 device offline 
or changed
Jan 19 11:56:43 coccobill kernel: I/O error, dev sda, sector 346752 op 
0x1:(WRITE) flags 0x1800 phys_seg 3 prio class 1
Jan 19 11:56:43 coccobill kernel: BTRFS error (device dm-0): bdev 
/dev/mapper/luks-7223e129-f73a-4877-98fc-bc00384ce937 errs: wr 6, rd 0, 
flush 0, corrupt 0, gen 0
Jan 19 11:56:43 coccobill kernel: BTRFS error (device dm-0): bdev 
/dev/mapper/luks-7223e129-f73a-4877-98fc-bc00384ce937 errs: wr 7, rd 0, 
flush 0, corrupt 0, gen 0
Jan 19 11:56:43 coccobill kernel: BTRFS error (device dm-0): bdev 
/dev/mapper/luks-7223e129-f73a-4877-98fc-bc00384ce937 errs: wr 8, rd 0, 
flush 0, corrupt 0, gen 0
Jan 19 11:56:43 coccobill kernel: sd 2:0:0:0: [sda] tag#0 device offline 
or changed
Jan 19 11:56:43 coccobill kernel: I/O error, dev sda, sector 373120 op 
0x1:(WRITE) flags 0x1800 phys_seg 1 prio class 1
Jan 19 11:56:43 coccobill kernel: BTRFS error (device dm-0): bdev 
/dev/mapper/luks-7223e129-f73a-4877-98fc-bc00384ce937 errs: wr 9, rd 0, 
flush 0, corrupt 0, gen 0
Jan 19 11:56:43 coccobill kernel: sd 2:0:0:0: [sda] tag#0 device offline 
or changed
Jan 19 11:56:43 coccobill kernel: I/O error, dev sda, sector 378528 op 
0x1:(WRITE) flags 0x1800 phys_seg 3 prio class 1
Jan 19 11:56:43 coccobill kernel: BTRFS error (device dm-0): bdev 
/dev/mapper/luks-7223e129-f73a-4877-98fc-bc00384ce937 errs: wr 10, rd 0, 
flush 0, corrupt 0, gen 0
Jan 19 11:56:43 coccobill kernel: sd 2:0:0:0: [sda] tag#0 device offline 
or changed
Jan 19 11:56:43 coccobill kernel: I/O error, dev sda, sector 378848 op 
0x1:(WRITE) flags 0x1800 phys_seg 4 prio class 1
Jan 19 11:56:43 coccobill kernel: sd 2:0:0:0: [sda] tag#0 device offline 
or changed
Jan 19 11:56:43 coccobill kernel: I/O error, dev sda, sector 389600 op 
0x1:(WRITE) flags 0x1800 phys_seg 3 prio class 1
Jan 19 11:56:43 coccobill kernel: sd 2:0:0:0: [sda] tag#0 device offline 
or changed
Jan 19 11:56:43 coccobill kernel: I/O error, dev sda, sector 390016 op 
0x1:(WRITE) flags 0x1800 phys_seg 6 prio class 1
Jan 19 11:56:43 coccobill kernel: sd 2:0:0:0: [sda] tag#0 device offline 
or changed
Jan 19 11:56:43 coccobill kernel: I/O error, dev sda, sector 2434752 op 
0x1:(WRITE) flags 0x1800 phys_seg 3 prio class 1
Jan 19 11:56:43 coccobill kernel: sd 2:0:0:0: [sda] tag#0 device offline 
or changed
Jan 19 11:56:43 coccobill kernel: I/O error, dev sda, sector 2443904 op 
0x1:(WRITE) flags 0x1800 phys_seg 3 prio class 1
Jan 19 11:56:43 coccobill kernel: sd 2:0:0:0: [sda] tag#0 device offline 
or changed
Jan 19 11:56:43 coccobill kernel: sd 2:0:0:0: [sda] tag#0 device offline 
or changed
Jan 19 11:56:43 coccobill kernel: sd 2:0:0:0: [sda] tag#0 device offline 
or changed
Jan 19 11:56:43 coccobill kernel: sd 2:0:0:0: [sda] tag#0 device offline 
or changed
Jan 19 11:56:43 coccobill kernel: sd 2:0:0:0: [sda] tag#0 device offline 
or changed
Jan 19 11:56:43 coccobill kernel: BTRFS: error (device dm-0) in 
btrfs_commit_transaction:2535: errno=-5 IO failure (Error while writing 
out transaction)
Jan 19 11:56:43 coccobill kernel: BTRFS info (device dm-0 state E): 
forced readonly

In this case the errors are serious enough to cause btrfs to get to RO mode.

Let me recall that sda is my sd-card that works with the usb-storage 
module, and that I have layered btrfs over luks encryption on it.

The errors are related to the resume from sleep as they come out *only* 
after "PM: suspend exit". There are no errors for the device in normal 
operation.

Before getting to the patch, I have also made more experiments:

- Trying to modify the usb-storage delay_use parameter has no effect on 
the issue.

This looks strange to me since this parameter should specifically 
control how much time the kernel waits before using the sd-card on my 
system.

Trying to modify the /sys/block/sda/events_poll_msecs also makes no 
difference at all (normally it is -1, I have tried to change that from 
100 ms to 2 s).

Thanks for the attention,

Best
Sergio

