Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99609429004
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 10:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789986266; cv=none; b=nCEvnq9B3GptkcQpHTEnGkgZn1e5oNarNgUWhfLbFfxG3smpC1n4nJeCaURZOekOJtMBMTfhFJ5xOrfsy7wkRe9w5eI+g/unP6L28JOA774dquSMVXXRhwiPxJ/vDIG9mREv/eJmcgZJTXsbEkFEdoMX0mwouQIKGxKiRvnwJeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789986266; c=relaxed/simple;
	bh=V9ZQMYtsWF6PHHbT3BVd8suGs6PpTwwjWqfYWSlw59k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s4tKkv51Uot8BqKyNs9ykoi7dc+k8GgtJYBYAuOKluRXN3OkQq/RoG9jeYGI/LPEf/APN4rszgyr3D51GQIusRBxksLx1DC7GzLoNwAUyLeSoAQTrq5mdVNOrwjPb/fwzH7FeVGs62dIMrFj47Yyl9Q2lqqsgvZ1Ueb+V75QbhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DujUKu1d; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DujUKu1d"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485ac898fa4so2403364f8f.0
        for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 03:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789986263; x=1790591063; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=65UBp7VWzxcN/x+Da75nn/VLL1vSzar334JPrT+AOTA=;
        b=DujUKu1d+YQ+5XCQfAIHyQrseVYgX8NLXur820RklKCrIFiIKKr59uJGDTkMhsPQki
         oJWwMazao/syMjZkSByC+bWZP4kLXHGov8f9aJk8VZNV2/E9aDRZopEB3gsPsPeNfVFi
         m0334+rp5q+gsEYDWVxmdD2eUxIWXjN5raFNq9z+kGqQOO5mMWMJODceL1VKVwzyXPr6
         FHdUrxThUry3WWmwhki390V1v2u7DXYFP6LnwnwjWO5JG9QGivpxLg/wM5aTvd0PlSnZ
         0mADFhH2fq1JcLbEmvk66h+CWejIfhTXW4V7WRTYnoIQfCRxsFaFbbyFmcS3z1MdvItl
         5IfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789986263; x=1790591063;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=65UBp7VWzxcN/x+Da75nn/VLL1vSzar334JPrT+AOTA=;
        b=K3ninJsIxMIwWGHGaN7rwJYGYtwXf3NQ0zsxEfBLcXhm9XKnAJKZcWp7mihZCXLEsR
         Frpd1SNzQHncQJaQfqN40T23Gq+i8vO1YsYBqEoSraLblMHrVHV6zBvLyNKPXndfQqqg
         T1TeH/35YsWzDF4pRHDLOSCt1PJe5HDY0BG9WuTnE+d9L2ByDYXuo7g6GmxsJLA2kvog
         KqfogP3FpReYtJzQwd3dWO1QYmGf6ERnEcfxNwl85GXyylCmixiADdz5BM+NyCu0KiKV
         dLQo3v+SyhSgtvj0OBfmJlW4fvu6QcZntFTC9yKv0qz5ZOXBhJjU7JKsPuL56GkHCrpD
         VmQw==
X-Forwarded-Encrypted: i=1; AKwUvBw0DN+Q6jZbxzFNDYEsT6/nq1Uf0F9CWdJB3EC2YZJAghPkmgvFm0uYARm+2nAn5Q6TSflVI3KFwGQB@vger.kernel.org
X-Gm-Message-State: AFuF++k/TtUX35I5F2z2dYZfeKl4dG0T2u9eW2AXk/7d/abBnEk55JmP
	WjR6fFkJh/WXb7hyQdpv9yRde8hfK2+6ikNHRp4F9EulQvrOgDS8Sz5H2r3xlRmwCYIpJgd0ogY
	UNxqc
X-Gm-Gg: AYBFou3+lisUeTtVlbtGmNRJCtELldyvDH/RFNZzGRmyzbM6F87DyDal+inAAIJkF0o
	QvZr9SCTXPNA0S+0012NE8Fk7mcNkgZwYC+yTvJJEvUSbmzhL1B5kEP94C6zxesYvnaU8/lzC+C
	LbnQHPHClDINGmNOYcJLc/V9rnmkep2+bXSSbLdDPz/kpfDu2q+vxUlu3TezKpPZyyRgPC0Nhp4
	VZ9eLU/ejZnnjERKTUE17bSfXLTdN8nFD3UkqJCEXf1y22oxCz1cxNeYcm9FdXh81pjPgiEiC+f
	JAnCrVCWWT7Ht2lOWgmQrwbz5lpkqZmtij1lu4oRwkYMWKxmdKLPMs2iG4d6xdnfjvY6eEfUd6T
	TvwfqNpA3ewUnV8toWJ6cw9+m5fG0/OhpaUifmDBNi5EqcgDqSNRk3nnUGJmliTVWnF4bIx6ckJ
	mfhitHuoOtAmwykz6d6YlDcPmjVaUhkJVVfm30nFmREbiFDdVTK6XJIyp81fXI6eJzu6ipqfRdv
	oSpaE6q3gtWdnzBMkKT8KSoj97uSxGBeGI90FzUXA==
X-Received: by 2002:a5d:6f03:0:b0:487:11c2:3448 with SMTP id ffacd0b85a97d-4871e211a9bmr13123418f8f.1.1789986262663;
        Mon, 21 Sep 2026 03:24:22 -0700 (PDT)
Received: from ?IPV6:2001:a61:13e6:1501:f824:c061:b4c4:4b11? ([2001:a61:13e6:1501:f824:c061:b4c4:4b11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-487243cede9sm24010410f8f.0.2026.09.21.03.24.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 03:24:21 -0700 (PDT)
Message-ID: <cbe40a79-0c4e-4aa8-b908-27db3a0f507d@suse.com>
Date: Mon, 21 Sep 2026 12:24:21 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] usb: uas: quiesce SCSI before stopping endpoints on
 driver unbind
To: Jiayi Li <lijiayi@kylinos.cn>, Oliver Neukum <oneukum@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
 linux-kernel@vger.kernel.org
References: <20260920012358.3362053-1-lijiayi@kylinos.cn>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20260920012358.3362053-1-lijiayi@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.09.26 03:23, Jiayi Li wrote:

Hi,

thank you for the patch.

> A driver-only unbind of uas while reads are in flight can leave the
> storage device unusable after the driver is rebound.
> 
> Test environment:
> 
>    - Device: VIA Labs USB storage bridge, VID:PID 2109:0715, product SO1,
>      with a ZX1 512 GB SSD
>    - Link: SuperSpeed 5 Gbit/s, UAS interface 2-4:1.0
>    - System: Ubuntu 24.04.3 LTS
>    - Kernel: 7.0.0-31-generic
> 
> Reproduction steps:
> 
>    1. Unmount every mounted partition on the test disk.  In this setup
>       only /dev/sda1 was mounted:
> 
>         udisksctl unmount -b /dev/sda1
> 
>    2. Start 32 concurrent O_DIRECT readers at different offsets:
> 
>         disk=/dev/sda
>         pids=
>         for i in $(seq 0 31); do
>                 while dd if="$disk" of=/dev/null bs=1M \
>                         skip=$((i * 4096)) count=4096 iflag=direct \
>                         status=none 2>/dev/null; do :; done &
>                 pids="$pids $!"
>         done
> 
>    3. Wait until at least eight reads are in flight:
> 
>         while :; do
>                 read -r reads writes < /sys/class/block/sda/inflight
>                 [ "$reads" -ge 8 ] && break
>                 sleep 0.005
>         done
> 
>    4. Unbind uas, wait two seconds, and bind it again:
> 
>         intf=2-4:1.0
>         echo "$intf" > /sys/bus/usb/drivers/uas/unbind
>         sleep 2
>         echo "$intf" > /sys/bus/usb/drivers/uas/bind
>         kill $pids 2>/dev/null || true
> 
>    5. Check dmesg and lsblk for UAS/SCSI errors and disk recovery.
> The two-second delay deliberately separates teardown from reprobe.  It
> did not prevent the failure.  Additional recovery checks on the same
> bridge showed that waiting alone does not clear the failed state:
> 
>    - the failed device remained unusable after more than 12 minutes;
>    - UAS unbind/reset followed by a 5-second wait did not recover it;
>    - unbinding xHCI, waiting 10 seconds and binding it again did not
>      recover it;
>    - USB device reset and authorized 0 -> 1 did not recover it.
> 
> The device recovered only after it was physically unplugged and reconnected.
> 
> Observed failure:
> 
>    - 30 READ commands were in flight when unbind started;
>    - the old commands completed with DID_NO_CONNECT during teardown;
>    - after the two-second delay, the new UAS instance created a SCSI
>      host, but the first INQUIRY Data IN completed with -EOVERFLOW;
>    - error handling initially reported a successful USB device reset, but
>      the following READ(10) still timed out;
>    - xHCI reported completion events for unknown stream rings, a later
>      device reset failed with -ENODEV, and SCSI offlined the device;
>    - the USB device then disconnected and re-enumerated, but the new UAS
>      instance again timed out on INQUIRY and TEST UNIT READY and was
>      offlined.
> 
> Representative log from the steps above:
> 
>    [ 5138.886447] sd 0:0:0:0: [sda] tag#0 uas_zap_pending 0 uas-tag 1 inflight: CMD
>    [ 5138.886674] sd 0:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK cmd_age=0s
>    [ 5138.886682] I/O error, dev sda, sector 75497472 op 0x0:(READ) flags 0x4800 phys_seg 128 prio class 2
>    [ 5139.077259] sd 0:0:0:0: [sda] Synchronize Cache(10) failed: Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
>    [ 5141.100631] scsi host0: uas
>    [ 5141.103134] scsi 0:0:0:0: tag#12 data cmplt err -75 uas-tag 1 inflight: CMD
>    [ 5141.103160] scsi 0:0:0:0: tag#12 CDB: Inquiry 12 00 00 00 24 00
>    [ 5161.649075] scsi 0:0:0:0: tag#12 uas_eh_abort_handler 0 uas-tag 1 inflight: CMD
>    [ 5161.653963] xhci_hcd 0000:00:12.0: Transfer event 26 for unknown stream ring slot 4 ep 14
>    [ 5162.682379] scsi host0: uas_eh_device_reset_handler success
>    [ 5192.884624] sd 0:0:0:0: [sda] tag#16 uas_eh_abort_handler 0 uas-tag 1 inflight: CMD IN
>    [ 5192.884659] sd 0:0:0:0: [sda] tag#16 CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
>    [ 5193.023329] scsi host0: uas_eh_device_reset_handler success
>    [ 5223.084816] xhci_hcd 0000:00:12.0: Transfer event 26 for unknown stream ring slot 4 ep 10
>    [ 5227.160590] usb usb2-port4: Cannot enable. Maybe the USB cable is bad?
>    [ 5227.160712] scsi host0: uas_eh_device_reset_handler FAILED err -19
>    [ 5227.160732] sd 0:0:0:0: Device offlined - not ready after error recovery
>    [ 5227.627367] usb 2-4: USB disconnect, device number 5
>    [ 5232.135739] usb 2-4: new SuperSpeed USB device number 6 using xhci_hcd
>    [ 5232.157674] scsi host0: uas
>    [ 5252.783442] scsi 0:0:0:0: tag#16 CDB: Inquiry 12 00 00 00 24 00
>    [ 5252.783644] xhci_hcd 0000:00:12.0: Transfer event 26 for unknown stream ring slot 4 ep 10
>    [ 5253.815690] scsi 0:0:0:0: tag#16 CDB: Test Unit Ready 00 00 00 00 00 00
>    [ 5254.841412] scsi 0:0:0:0: Device offlined - not ready after error recovery
> Why it fails:
> 
>    - usbcore disables an interface's endpoints before ->disconnect unless
>      the driver sets soft_unbind;
>    - the command URB may already have delivered a SCSI command when the
>      data and status URBs are killed;
>    - uas_disconnect() removes the SCSI host only after killing its anchored
>      URBs, so SCSI teardown cannot first quiesce those accepted commands;
>    - the new UAS instance can then encounter residual transport state.
> 
> The failure survived xHCI unbind/rebind and a USB device reset.  Since only
> physically unplugging and reconnecting the device recovered it, the residual
> state is most likely retained by the storage bridge rather than the host
> controller, and is not cleared by a USB reset.
> 
> What this patch does:
> 
>    - set soft_unbind so endpoints remain available during driver-only
>      unbind;
>    - cancel pending scanning before removing the SCSI host;
>    - for driver-only unbind, remove the SCSI host before setting resetting,
>      killing the anchored URBs and freeing streams;
>    - for physical disconnect, retain the existing kill-first order because
>      the endpoints are no longer usable.

We do not want different orders in the driver. Can you resubmit with
a unified order?

[..]
>    1. Is enabling soft_unbind and moving scsi_remove_host() ahead of URB
>       teardown acceptable for driver-only unbind?

Sort of. The order should be unified.

>    2. Is there a more appropriate way to quiesce SCSI commands and UAS
>       streams before endpoint teardown?

This is complicated. I believe that this boils down to abort handling.
Unfortunately the way contained in the spec is clunky and does not work
on real hardware. It is probably necessary to implement the trick
Windows uses.

>    3. If this ordering is acceptable, does the driver-only unbind path need
>       a bounded fallback when scsi_remove_host() encounters a nonresponsive
>       device or ongoing SCSI error handling?

No. scsi_remove_host() needs to be able to deal with that.

	Regards
		Oliver

