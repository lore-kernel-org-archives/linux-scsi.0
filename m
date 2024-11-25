Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBE21922E9;
	Mon, 25 Nov 2024 14:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732545057; cv=none; b=oAgxx0n9l05ty5Nf+l9JW45Ygr78t5EqdCFcpjWkq3MGgXczHRxATUFsl3ff2FOpMwoBNrjjeRSle0qSQMUfKIkqIZBeXWo6ix9Qk/n04LcNmJoKGIzqEviTsWLWKRndH+nHwt0ncLisyiMtDeO+uToZ0gWXj1T+3iwa42AKafA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732545057; c=relaxed/simple;
	bh=jjlYlEF3VSNlLImiTd+v25/yYobIAhdJC23Q3KZcxCI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lI8vH/V56Y+Ltu7CuTzwnPC9CPri/I0+9WRuoZbKe9qIPdI/7UDI8DS112FsCGkG0UBlgt30v3ZxIHi++MgTWFvGXwwpV2bkuER/HDg8n+SUoPmf2JiDXb7rdpOz7xoEV30RS4NeTdwmG6dDmBfvUVEPAUWuEugprOKB6YvaZ7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y3AC8aU2; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y3AC8aU2"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-7f8b01bd40dso3145049a12.0;
        Mon, 25 Nov 2024 06:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732545055; x=1733149855; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MqXFbqIyeGY2h3r6ZVQVITO4Q1XyQCzf6ScOHS9hGkY=;
        b=Y3AC8aU2XQXZPJw26CduT0c2g/bgAvjCYT6cPV5I4zbbWGJ8p3lqNeYqOp+BFueQij
         6ST8qnBE0Bh1HDBiJwTJkNJtYfoHtZL8uC6ezr8CnMHk8Yu3xxF/gQSuGc8LZeUOeRQx
         rQlwjwqfE0P2khFHTSieSNmS6wHbpiOKiFem++yaPG7IIKKeo9sfd7O8vluldBcLajls
         oAPgpPXmNgLaoSf4DRb4BrCDaN/qNu4ON9qM6myUuTSZnQOEFHKXWWYMXpUq4b+NVprf
         IGWkRQKooRXS4+DBBPSI69IRVh/IVOC4GcgKhabLL8+kVXUaRNKFnXqjHJhxxCbysaaW
         WLIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732545055; x=1733149855;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MqXFbqIyeGY2h3r6ZVQVITO4Q1XyQCzf6ScOHS9hGkY=;
        b=VpfSZqid6TW+YuSqqBkp6xAHcfqnOLV+w166PMOVCoEXOHgnDuO9Tvd1MN6um390lS
         mImjJ+TYBquShs+8SwYMo1Nz/HbToTltobxL7EZaqIqp1rByKKU42nbpaKmUwEW0xMsu
         zNhHN5WOu+em3wVzTW1S08P7B4nxdina+mf/9fJ8qB+VysWRlR6AX5kBNsvVGGnfrt9U
         KbdD1HUDrawvr54Ja6mkyQQXLOAboFy295mv2VeocQcs/HJ6nNLAooGnxBjWwZqV4Rgk
         YRogPTFnN8EmL+33qBXb72EY33DSRvrZ6AK85FFvyu2KtidDXMp839hBa+FNYSyOfCNs
         U35A==
X-Forwarded-Encrypted: i=1; AJvYcCWmhxd2rxZBDOlONbwfzoakSMyS2bbnhXhkVdMFq2dbWFXQzcdqAQsKU0l/u89N8fzZhewxTQtj9WjQ8hw=@vger.kernel.org, AJvYcCXa6VGI4ygQtzmSHpfK13kSQPUAEJ15M9Y7SsoKoBO9CQ3SjMXLO1IcHeiTn2IOJx7tY5Q+wJJ3+ASmPw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+IAMwkrNquzLb9kXSa7j+uM0M6ZHJZVxoymXV79rhy6nrwh/s
	GIA4pGeGRiCkls2jPsZ1uJ7QVsLAv52C1u1jt72n94tVmsGC1sEX
X-Gm-Gg: ASbGncuYj1CocRoqU2yYZWn926RNsVs/24uMqmkSYAKao4atO2SlZ6WmrzQg+V7uYNA
	LbyTzqVaBe2Q3S1h2+5dTNg3KTT4BhnCN3ygKjWphv3ngGN35EWJpWurmJKqo1nNDIsoUzWEPqp
	3QvvsZdwQpdn3GqBnD06EXcctHysbCWlzd2P5q6pQOriZihWe+AVZoZ6jjRMIKOW37E93GEtE7p
	fh61wxU/5r+BP+c+h3uCmzjQX6oK+uD74gksZNYN4T4kyJtKTr4oVzmwXGVJ2lI
X-Google-Smtp-Source: AGHT+IFIcwZszMi/Vg8/3dtE3gpAx3lKCraJsEP4/6Ioz7DziT3l4Fb16+gWv0+6iwcwILIUI7piEA==
X-Received: by 2002:a17:903:228d:b0:20f:ae7f:a433 with SMTP id d9443c01a7336-2129fe09467mr175950955ad.2.1732545055030;
        Mon, 25 Nov 2024 06:30:55 -0800 (PST)
Received: from [192.168.0.203] ([14.139.108.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2129dc2a763sm65037285ad.273.2024.11.25.06.30.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2024 06:30:54 -0800 (PST)
Message-ID: <d4695943-51b8-40f2-bf2c-3a6436081887@gmail.com>
Date: Mon, 25 Nov 2024 20:00:48 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sg: fix slab-use-after-free Read in sg_release
To: dgilbert@interlog.com
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com
References: <20241120125944.88095-1-surajsonawane0215@gmail.com>
Content-Language: en-US
From: Suraj Sonawane <surajsonawane0215@gmail.com>
In-Reply-To: <20241120125944.88095-1-surajsonawane0215@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/24 18:29, Suraj Sonawane wrote:
> Fix a use-after-free bug in `sg_release`,
> detected by syzbot with KASAN:
> 
> BUG: KASAN: slab-use-after-free in lock_release+0x151/0xa30
> kernel/locking/lockdep.c:5838
> __mutex_unlock_slowpath+0xe2/0x750 kernel/locking/mutex.c:912
> sg_release+0x1f4/0x2e0 drivers/scsi/sg.c:407
> 
> Root Cause:
> In `sg_release`, the function `kref_put(&sfp->f_ref, sg_remove_sfp)`
> is called before releasing the `open_rel_lock` mutex. The `kref_put`
> call may decrement the reference count of `sfp` to zero, triggering
> its cleanup through `sg_remove_sfp`. This cleanup includes scheduling
> deferred work via `sg_remove_sfp_usercontext`, which ultimately frees
> `sfp`.
> 
> After `kref_put`, `sg_release` continues to unlock `open_rel_lock` and
> may reference `sfp` or `sdp`. If `sfp` has already been freed, this
> results in a slab-use-after-free error.
> 
> Fix:
> The `kref_put(&sfp->f_ref, sg_remove_sfp)` call is moved after unlocking
> the `open_rel_lock` mutex. This ensures:
> - No references to `sfp` or `sdp` occur after the reference count is
>    decremented.
> - Cleanup functions such as sg_remove_sfp and sg_remove_sfp_usercontext
>    can safely execute without impacting the mutex handling in `sg_release`.
> 
> The fix has been tested and validated by syzbot. This patch closes the bug
> reported at the following syzkaller link and ensures proper sequencing of
> resource cleanup and mutex operations, eliminating the risk of
> use-after-free errors in `sg_release`.
> 
> Reported-by: syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=7efb5850a17ba6ce098b
> Tested-by: syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com
> Fixes: cc833acbee9d ("sg: O_EXCL and other lock handling ")
> Signed-off-by: Suraj Sonawane <surajsonawane0215@gmail.com>
> ---
>   drivers/scsi/sg.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index f86be197f..457d54171 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -393,7 +393,6 @@ sg_release(struct inode *inode, struct file *filp)
>   
>   	mutex_lock(&sdp->open_rel_lock);
>   	scsi_autopm_put_device(sdp->device);
> -	kref_put(&sfp->f_ref, sg_remove_sfp);
>   	sdp->open_cnt--;
>   
>   	/* possibly many open()s waiting on exlude clearing, start many;
> @@ -405,6 +404,7 @@ sg_release(struct inode *inode, struct file *filp)
>   		wake_up_interruptible(&sdp->open_wait);
>   	}
>   	mutex_unlock(&sdp->open_rel_lock);
> +	kref_put(&sfp->f_ref, sg_remove_sfp);
>   	return 0;
>   }
>   

Hello!

I wanted to follow up on the patch I submitted. I was wondering if you 
had a chance to review it and if there are any comments or feedback.

Thank you for your time and consideration. I look forward to your response.

Best regards,
Suraj Sonawane
