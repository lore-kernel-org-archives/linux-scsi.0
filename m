Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E4A261581
	for <linux-scsi@vger.kernel.org>; Mon, 15 Dec 2025 15:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765811402; cv=none; b=b/9qujl4Amq7HCxy+MhQyGcF6PR3rwd/H66K+xNzVzzELmsyYWt1q57+tE/jR+IrwZEWt325Zv+RoUGEFI2H7i/U0A++ISDnK8vAh1F0iOve0oQdcX95Yp/XA3aQb/xGGWtVTJ8wW4cpvWDEBbHnqI5Ds+RfnOKJrJt4nCt2mYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765811402; c=relaxed/simple;
	bh=7klgUvbjbW/0+9TlIs2uVuPmnKYx68nSN7LSdS4fSbk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TM4hqmu6NtYD8M6dhdmz5BmJkqOX4NcX23yo62shHbNOVCanNa1NQW5WTO+N/arOnEa4AgfAs4csTv/e/Tx7ZnF6rGgIhemYtqvyZC7Ck9ncBmrHV3zCKLyNJDcehAJRxu/klF8mbpqQ6X6bVEwaaL6XrddHV5cSCG6nPsh5n4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OaqzuVeI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gEsPA+Ct; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OaqzuVeI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gEsPA+Ct"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765811399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wn9VmAWiuP+bNrmNxlG6OcbCx7/GyscEMy+WrSiVy3U=;
	b=OaqzuVeIo3GRtKuO5661OQKv3pRf+jFd1NJMF6NpbdIKiopi5FkdvoM9Q0rTGqoCEIJVT1
	+gfSBBg+xMc4ye+i4nD3/dM02Gohom1IQuFkOgxGci/plqPfVsRIqESyQnCHfWfoL61wFE
	COBdRd8++k/as/ZJSq2zXqtkJ6ST22Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-QLtu0yCdNnmTesvnSK3-Aw-1; Mon, 15 Dec 2025 10:09:58 -0500
X-MC-Unique: QLtu0yCdNnmTesvnSK3-Aw-1
X-Mimecast-MFC-AGG-ID: QLtu0yCdNnmTesvnSK3-Aw_1765811397
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-43102ac1da8so334013f8f.2
        for <linux-scsi@vger.kernel.org>; Mon, 15 Dec 2025 07:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765811397; x=1766416197; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wn9VmAWiuP+bNrmNxlG6OcbCx7/GyscEMy+WrSiVy3U=;
        b=gEsPA+CtnUM1dJeov2X9wNrax7DqwURIA9jQeh20yEI8I/Uh5PutunBvgdDLMWMj3Q
         5ZLrEcYZ58LnBG5mgKA9cNTRwonNu1RLeZaZQKxnIOA/azYgH63063gvm81zogJUha1g
         4APucRmifZRM+tSEP5e1Bo1Y4HxS8mmg3jZV2RetNmwSY/bFSQI7kbTFRno/1lCuPKK1
         7r1wfxbzG2bkaEG16xqk8W+0Y8H4y3zBzCkr/bSAazVKjuJhs32I/QPk4NF8BDoK5uHh
         NjgZIqfef0cvGUDYJJuVzbD2k/yyf35qxXXBVX63xaC+0uFjUsqF2ENikA+EtI2rS67e
         M25g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765811397; x=1766416197;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wn9VmAWiuP+bNrmNxlG6OcbCx7/GyscEMy+WrSiVy3U=;
        b=gzhQR0S9FwMiAqDnhH0QzY74WAvFlwKJcl/6d5t0bKPApx8aPJqp/SRFRcUXWvugry
         7SfTQzbbbWxX1MUhHDOKGJ5I3EYimbmJb4JwIXIcML4KJdpRyc7PbWVRvGrIVx6PTzUv
         IEATS4UjS+bXqK4K1MOCKKAye2jV71Q8P/T9zDSu/n4YXQNClBrV6T9WyJlkfJK4mJ6t
         GR7aaEU7ybqrJaITRl2U17nnqiP54B8o4QUzlUU5w0tF73EzV7777/NIIKWnLu85Ij1o
         EBGZyB0Wbt1OvsYgMSMzecKfhJenJCz9TxuS8jM168QD+J/onwQsi0/hwo9qxBr7POgT
         AswQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcu7id03ksbvq8YCypA5s6+/6ZVCYmznH84tMl2fNxh21H+MfzmCzo8voC0dTCTVvFpEbAVGd5ruAI@vger.kernel.org
X-Gm-Message-State: AOJu0YzAFcEog+ntUYZUJf0PXS1GCG+XK/+phRx+MKBrNdshzDVohAP+
	kst/bCaJRAS6axQttuwY+2xu++dJLfkAgCIU26CXTcSUcQrnjznjugiJ51ZmWTkIIxaHFaqFEcG
	La+n0YZdk7Kz3/iNDxzfjazS/XUlqnZv62wR5INKB4WqfiSCBmTqKYh1H8EaQ5yY=
X-Gm-Gg: AY/fxX6BmVg5sc6SNX59tQux3Tz2GcPDm7aXL6E6tJhJ1ug/NxbGas7zK3ZZFTqjqK3
	UOHErf7MF+yh0gVdKqQp0fNUICXrVp3RBc90dGW6HY7vI67ULbCgvtllHbzghNyjTxviC5GfNUy
	UCQ+94hsRbOpo6L6RMxDh8uDoBhn/44FrJ2evDlyCRnpRNSIc/MWO6D4s0kDap5KyxUn4/gL3Lq
	nwRb2QKnD0GCA5be5sG0lqIVjNzCphwOq7n3RoddMkVa29eCFhPkTTKe++ad5kbvTrlBKaXRyYQ
	R47FNtOCb0e/kS73FSIriLftWSGPGBIFHKArBoLdaVJ0EonrspoD0RWhCUljNMyGbMFPsXDZHMv
	uyVafXM+5Xtc=
X-Received: by 2002:a05:6000:2889:b0:430:fd84:315a with SMTP id ffacd0b85a97d-430fd8434d4mr3692307f8f.39.1765811396776;
        Mon, 15 Dec 2025 07:09:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHNod+1KUxfhV95tVPY3QeYMZrI4D3tN8thga8xSN5Jfr6RJbVP1AeldhmdaCtQLbdSZpqMEA==
X-Received: by 2002:a05:6000:2889:b0:430:fd84:315a with SMTP id ffacd0b85a97d-430fd8434d4mr3692260f8f.39.1765811396211;
        Mon, 15 Dec 2025 07:09:56 -0800 (PST)
Received: from [10.202.149.86] ([213.175.37.14])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42fb0fc8d5fsm22127043f8f.2.2025.12.15.07.09.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Dec 2025 07:09:55 -0800 (PST)
Message-ID: <39e41ce3-3fe8-456f-a886-868934b84e5e@redhat.com>
Date: Mon, 15 Dec 2025 16:09:54 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sg: fix occasional bogus elapsed time that exceeds
 timeout
To: =?UTF-8?Q?Michal_R=C3=A1bek?= <mrabek@redhat.com>,
 linux-scsi@vger.kernel.org, dgilbert@interlog.com
Cc: Changhui Zhong <czhong@redhat.com>, "Ewan D. Milne" <emilne@redhat.com>,
 John Meneghini <jmeneghi@redhat.com>
References: <20251212160900.64924-1-mrabek@redhat.com>
Content-Language: en-US
From: Tomas Henzl <thenzl@redhat.com>
In-Reply-To: <20251212160900.64924-1-mrabek@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 12/12/25 5:08 PM, Michal Rábek wrote:
> A race condition was found in sg_proc_debug_helper(). It was observed on
> a system using an IBM LTO-9 SAS Tape Drive (ULTRIUM-TD9) and monitoring
> /proc/scsi/sg/debug every second. A very large elapsed time would
> sometimes appear. This is caused by two race conditions.
> 
> We reproduced the issue with an IBM ULTRIUM-HH9 tape drive on an x86_64
> architecture. A patched kernel was built, and the race condition could
> not be observed anymore after the application of this patch. A reproducer
> C program utilising the scsi_debug module was also built by
> Changhui Zhong and can be viewed here:
> 
> https://github.com/MichaelRabek/linux-tests/blob/master/drivers/scsi/sg/sg_race_trigger.c
> 
> The first race happens between the reading of hp->duration in
> sg_proc_debug_helper() and request completion in sg_rq_end_io().
> The hp->duration member variable may hold either of two types of
> information:
>  #1 - The start time of the request. This value is present while
>       the request is not yet finished.
> 
>  #2 - The total execution time of the request (end_time - start_time).
> 
> If sg_proc_debug_helper() executes *after* the value of hp->duration
> was changed from #1 to #2, but *before* srp->done is set to 1 in
> sg_rq_end_io(), a fresh timestamp is taken in the else branch, and the
> elapsed time (value type #2) is subtracted from a timestamp, which
> cannot yield a valid elapsed time (which is a type #2 value as well).
> 
> To fix this issue, the value of hp->duration must change under the
> protection of the sfp->rq_list_lock in sg_rq_end_io().
> Since sg_proc_debug_helper() takes this read lock, the change to
> srp->done and srp->header.duration will happen atomically from the
> perspective of sg_proc_debug_helper() and the race condition is thus
> eliminated.
> 
> The second race condition happens between sg_proc_debug_helper() and
> sg_new_write(). Even though hp->duration is set to the current time
> stamp in sg_add_request() under the write lock's protection, it gets
> overwritten by a call to get_sg_io_hdr(), which calls copy_from_user() to
> copy struct sg_io_hdr from userspace into kernel space. hp->duration is
> set to the start time again in sg_common_write(). If
> sg_proc_debug_helper() is called between these two calls, an arbitrary
> value set by userspace (usually zero) is used to compute the elapsed time.
> 
> To fix this issue, hp->duration must be set to the current timestamp again
> after get_sg_io_hdr() returns successfully. A small race window still
> exists between get_sg_io_hdr() and setting hp->duration, but this window
> is only a few instructions wide and does not result in observable issues
> in practice, as confirmed by testing.
> 
> Additionally, we fix the format specifier from %d to %u for printing
> unsigned int values in sg_proc_debug_helper().
> 
> Signed-off-by: Michal Rábek <mrabek@redhat.com>
> Suggested-by: Tomas Henzl <thenzl@redhat.com>
> Tested-by: Changhui Zhong <czhong@redhat.com>
> Reviewed-by: Ewan D. Milne <emilne@redhat.com>
> Reviewed-by: John Meneghini <jmeneghi@redhat.com>

Looks good, thanks.
tomash
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

> ---
>  drivers/scsi/sg.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index b3af9b78fa12..57fba34832ad 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -731,6 +731,8 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
>  		sg_remove_request(sfp, srp);
>  		return -EFAULT;
>  	}
> +	hp->duration = jiffies_to_msecs(jiffies);
> +
>  	if (hp->interface_id != 'S') {
>  		sg_remove_request(sfp, srp);
>  		return -ENOSYS;
> @@ -815,7 +817,6 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
>  		return -ENODEV;
>  	}
>  
> -	hp->duration = jiffies_to_msecs(jiffies);
>  	if (hp->interface_id != '\0' &&	/* v3 (or later) interface */
>  	    (SG_FLAG_Q_AT_TAIL & hp->flags))
>  		at_head = 0;
> @@ -1338,9 +1339,6 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
>  				      "sg_cmd_done: pack_id=%d, res=0x%x\n",
>  				      srp->header.pack_id, result));
>  	srp->header.resid = resid;
> -	ms = jiffies_to_msecs(jiffies);
> -	srp->header.duration = (ms > srp->header.duration) ?
> -				(ms - srp->header.duration) : 0;
>  	if (0 != result) {
>  		struct scsi_sense_hdr sshdr;
>  
> @@ -1389,6 +1387,9 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
>  			done = 0;
>  	}
>  	srp->done = done;
> +	ms = jiffies_to_msecs(jiffies);
> +	srp->header.duration = (ms > srp->header.duration) ?
> +				(ms - srp->header.duration) : 0;
>  	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
>  
>  	if (likely(done)) {
> @@ -2533,6 +2534,7 @@ static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
>  	const sg_io_hdr_t *hp;
>  	const char * cp;
>  	unsigned int ms;
> +	unsigned int duration;
>  
>  	k = 0;
>  	list_for_each_entry(fp, &sdp->sfds, sfd_siblings) {
> @@ -2570,13 +2572,17 @@ static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
>  			seq_printf(s, " id=%d blen=%d",
>  				   srp->header.pack_id, blen);
>  			if (srp->done)
> -				seq_printf(s, " dur=%d", hp->duration);
> +				seq_printf(s, " dur=%u", hp->duration);
>  			else {
>  				ms = jiffies_to_msecs(jiffies);
> -				seq_printf(s, " t_o/elap=%d/%d",
> +				duration = READ_ONCE(hp->duration);
> +				if (duration)
> +					duration = (ms > duration ?
> +						    ms - duration : 0);
> +				seq_printf(s, " t_o/elap=%u/%u",
>  					(new_interface ? hp->timeout :
>  						  jiffies_to_msecs(fp->timeout)),
> -					(ms > hp->duration ? ms - hp->duration : 0));
> +					duration);
>  			}
>  			seq_printf(s, "ms sgat=%d op=0x%02x\n", usg,
>  				   (int) srp->data.cmd_opcode);

