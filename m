Received: from omta014.uswest2.a.cloudfilter.net (omta014.uswest2.a.cloudfilter.net [35.164.127.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B3F2FE0F
	for <linux-scsi@vger.kernel.org>; Sat,  6 Apr 2024 20:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.164.127.237
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712436398; cv=none; b=tvr5YRDXRQQEJeQTehZHciJbeqkp0s1PjxN0EZFMPEO3FsQK8eNUIqfBj+/ajeeYzWbIk0iz1OI4oiNU0kIbOsH6vPOa8b17gBV0BpdttTa7CmDvvqpHFkH8cU0AU/u6GVZBQsPkfyNx/zJsH3N5uSAfg6KvOCKPElMqEanX77M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712436398; c=relaxed/simple;
	bh=YAoZMY1Kl53VBez4kLRz0rgvzlfo5X75+a8lnUf0h4s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QwewasThEm7J3at+7P7f6PkspvOrLWdXkPnWCRUYgBlWjXphgptVshuUOXUiVpirDbWZ/vmrDHAln0wjrPUCOzet19PYNjqY4vH7C/5s1Ut0s84cswwd0QAbfAP1guPTYC0QxcWJENV+lpu5bTtscc4HmQC/eKXFZ1smAo5Ddoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cox.net; spf=pass smtp.mailfrom=cox.net; dkim=pass (2048-bit key) header.d=cox.net header.i=@cox.net header.b=Y55Si1bk; arc=none smtp.client-ip=35.164.127.237
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cox.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cox.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cox.net header.i=@cox.net header.b="Y55Si1bk"
Received: from cxr.smtp.a.cloudfilter.net ([10.0.16.209])
	by cmsmtp with ESMTP
	id t9WPrqm8CsremtCs3rwCwv; Sat, 06 Apr 2024 20:42:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cox.net; s=c20240122;
	t=1712436159; bh=YAoZMY1Kl53VBez4kLRz0rgvzlfo5X75+a8lnUf0h4s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Y55Si1bkuLq/Ii8I/CU4XiWH7v5vFE7kzL4aGtgt+tlSQLCjC6txcZNi9JbWEMN9o
	 b7mQhwLSa+DA4EKUPCqzoxY83F2uGfnvLiyDlBMFinBksO68Flq24NQpDXrAzPQCy4
	 4Hc/i6hk4ow3MyvBYY3Dafdklg7PNpJlFn84iqyv0D3yUKtOMdo8WPSA1e3gO6JVX1
	 jqaTVXtZ0o+qVsINXbg6nUUbJ0dAcsQwsV8N6paGCHSvc+gJbIvlhBqnYCXBFxahyr
	 PddaUs/9N0s+RRwfDEYnOUiy0rV3uhx/BNdpJAnAV2h03Ru/D6ZodL4mjl2lBtGFwW
	 dLS4eq5jFo8OQ==
Received: from [192.168.33.113] ([70.190.229.154])
	by cmsmtp with ESMTPSA
	id tCrtrnzp9zE7NtCs2rhKNo; Sat, 06 Apr 2024 20:42:39 +0000
Authentication-Results: ; auth=pass (PLAIN) smtp.auth=cbertsch@cox.net
X-Authority-Analysis: v=2.4 cv=I7rGR8gg c=1 sm=1 tr=0 ts=6611b3bf
 a=sEpYCS07hqR8Zql/TXGVUg==:117 a=sEpYCS07hqR8Zql/TXGVUg==:17
 a=IkcTkHD0fZMA:10 a=kviXuzpPAAAA:8 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8
 a=rA7Xx0hBsMC6VWdTO2UA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=tGC-xRNVTheUzgyygdW5:22
Message-ID: <d45631ac-3ee6-45cc-8b5a-fab130ce39d7@cox.net>
Date: Sat, 6 Apr 2024 13:42:29 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: startup BUG at lib/string_helpers.c from scsi fusion mptsas
To: Justin Stitt <justinstitt@google.com>
Cc: linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com
References: <5445ba0f-3e27-4d43-a9ba-0cc22ada2fce@cox.net>
 <CAFhGd8pTAKGcu2uLzUDDxto1sk5-9zQevsrXp-xL0cdPcGYaGg@mail.gmail.com>
Content-Language: en-US
From: Charles Bertsch <cbertsch@cox.net>
In-Reply-To: <CAFhGd8pTAKGcu2uLzUDDxto1sk5-9zQevsrXp-xL0cdPcGYaGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfDZjBNzgqHgh5B5IOh3MGoswXloEhi5B33syTYBFRyLnOSuLH6Yl/hmIVezKrTUccbaTMa3Q+c3er6yfT7IK9YYF8/cf9fD/4768egvN/6Pp1ObYjBX9
 GQZ3wakyHpYAbcsMU776nWnRk7cf8PpRMXWsdcEhlwFefa1UHdfDOZXdRXF8s70yjAsMpwhzpluqzsR92ZclyO7uxSefle1vWQvmecaHG1l4rnYf/ZuRKHtd
 TvG4DOlooHFGGDFuFnCCq8Qlzm7BUwUcqXXCs7Npz2ESrP1dnQrLJC9DiHI/K27n+MhXJYcVcVgJcHDq/uCFlw==

On 4/4/24 14:38, Justin Stitt wrote:
> Hi,
> 
> On Mon, Apr 1, 2024 at 3:43 PM Charles Bertsch <cbertsch@cox.net> wrote:
>>
>> I have hit a kernel BUG at lib/string_helpers.c:1046, apparently invoked
>> from module mptsas.
>>
>> I use kernels compiled from source from kernel.org.  I hit this when
>> trying to step up to linux-6.7.11, after skipping some number of
>> versions. Doing git bisect on the steps from 6.6.0 to 6.7.0, I ended with --
>>
>> 45e833f0e5bb1985721d4a52380db47c5dad2d49 is the first bad commit
>> commit 45e833f0e5bb1985721d4a52380db47c5dad2d49
>> Author: Justin Stitt <justinstitt@google.com>
>> Date:   Tue Oct 3 22:15:45 2023 +0000
>>
>>       scsi: message: fusion: Replace deprecated strncpy() with strscpy()
>>
>>       strncpy() is deprecated for use on NUL-terminated destination
>> strings [1]
>>       and as such we should prefer more robust and less ambiguous string
>>       interfaces.
>>
>> The failure occurs during system startup, the six scsi disks are not
>> found, apparently one of the udev tasks is near death holding an open
>> file within the /dev directory.
>>
>> The apparently relevant part of the startup log is attached.
>>
>> The result of running lspci -v is also attached, as run by an
>> unprivileged user, in which the relevant part may be --
>>
>> 04:00.0 SCSI storage controller: Broadcom / LSI SAS1064ET PCI-Express
>> Fusion-MPT SAS (rev 04)
>>          Subsystem: Intel Corporation Device 3478
>>          Flags: bus master, fast devsel, latency 0, IRQ 17
>>          I/O ports at 4000 [size=256]
>>          Memory at b8910000 (64-bit, non-prefetchable) [size=16K]
>>          Memory at b8900000 (64-bit, non-prefetchable) [size=64K]
>>          Expansion ROM at <ignored> [disabled]
>>          Capabilities: <access denied>
>>          Kernel driver in use: mptsas
>>          Kernel modules: mptsas
>>
>> Only one of the systems I use for testing has this hardware, and has
>> this problem.
>>
>> Trying to follow advice from Documentation/admin-guide/, I built a
>> kernel with more recent (most recent?) code, identified as 6.9.0-rc2_64.
>>    The problem remains, with a similar start-up log, attached, but now
>> with two "cut here" entries, buffer overflow at
>> lib/string_helpers.c:1029, noted as "Not tainted", and invalid opcode at
>> lib/string_helpers.c:1037, and now listed as "Tainted", presumably from
>> the immediately earlier error.
>>
>> Please let me know what I can do to help.
> 
> Interestingly, after viewing the stack trace you provided, the last
> line before a fortify panic is
> 
> 2024-04-01T19:18:28.000000+00:00 zGMT kernel - - -
> mptsas_probe_one_phy.constprop.0.isra.0+0x7ff/0x850 [mptsas]
> 
> looking at this object file at that offset in gdb we see:
> 
> $ gdb $BUILD_DIR/drivers/message/fusion/mptsas.o
> (gdb) list *(mptsas_probe_one_phy+0x7ff)
> 0x2f4f is in mptsas_exp_repmanufacture_info
> (../drivers/message/fusion/mptsas.c:2984).
> 2979                            edev->component_id = tmp[0] << 8 | tmp[1];
> 2980                            edev->component_revision_id =
> 2981
> manufacture_reply->component_revision_id;
> 2982                    }
> 2983            } else {
> 2984                    printk(MYIOC_s_ERR_FMT
> 2985                            "%s: smp passthru reply failed to be
> returned\n",
> 2986                            ioc->name, __func__);
> 2987                    ret = -ENXIO;
> 2988            }
> 
> with the offending line (+2984) being a printk invocation.
> 
> I am not sure how my patch [1] is triggering this fortify panic. I
> didn't modify this printk or the string arguments (ioc->name), also
> the change from strncpy to strscpy did not introduce any strnlen()'s
> which seems to be the thing fortify is upset about:
> "2024-04-01T19:18:28.000000+00:00 zGMT kernel - - - detected buffer
> overflow in strnlen"
> or
> "2024-04-01T22:23:45.000000+00:00 zGMT kernel - - - strnlen: detected
> buffer overflow: 9 byte read of buffer size 8"
> 
> Charles, does reverting my patch fix the problems you're seeing?
> 
>>
>> Charles Bertsch
>> 1-480-395-2620
>> Phoenix AZ US
> 
> [1] https://lore.kernel.org/all/20231003-strncpy-drivers-message-fusion-mptsas-c-v2-1-5ce07e60bd21@google.com/
> 
> Thanks
> Justin

Justin,
Yes, undo of that patch does fix the problem, the scsi controller and 
all disks are visible.

So did changing .config so that FORTIFY would not be used.

Given other messages on this subject, there seems a basic conflict 
between using strscpy() to mean -- copy however much will fit, and leave 
a proper NUL-terminated string, versus FORTIFY trying to signal that 
something has been lost. Is there a strscpy variation (_pad maybe?) that 
FORTIFY will remain calm about truncation?

Charles Bertsch

