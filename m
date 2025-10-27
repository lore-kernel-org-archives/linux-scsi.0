Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3CE30595F
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 13:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761572143; cv=none; b=h3FJd6v6zJ10ghpiD9YVFUAktYw3gtIwyQkt4H+VJ6E+m4P1hcfHlh3XfdFOziZbhsIUE9iTq6OZlabCC7phJsvNV+x6DhvmWfVOtzvRJmMMwFCj3gqWlicSnKY0tPoZ0l2+MPVzvZimJTEGXg8NbmqYfY4IXh2dE+gb46chFJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761572143; c=relaxed/simple;
	bh=q1xHjAi6E4wi3oQoijyEgXm7p5tzOjAHqmVcqhQq0wg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c1rjQ+WoAFcqFzPSEwg4oap6q7bo+5oUSDvQHU6UHLQYI6cUlf1Pt5hhFwSRdoQGHJPrRWUa2HtuhJ4GSK5lKvF+29G8o25qn3IQ8+3V7N97vqXjC6xH8elwfudXG0s7sIosmwAyMMnPT6G6xBA72yMXFUiS9X7hvyZuH1K/IG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=P8vvbycA; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="P8vvbycA"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-475dc6029b6so19762795e9.0
        for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 06:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761572139; x=1762176939; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=coMQJHEII5UHdUF+Ekj+pHGgsN6WEYzWi8tdyRdD9tw=;
        b=P8vvbycAR7YrdLbLsZK9MsF8LIJaG1AUecd4CONxCa9Bm256AZZujM2MjtVUVQwh2L
         wjQw2Ag/XcnrUCu0xW/eCq7E24V2QsqnyvDwPRGhJds5NXMWizxT7liQy3yEsgbR4Ec/
         j9eubyUMw46E0Pvqq7iVHqbXUzUJ3dipvKZjSSHHEJ5n6NWZN/8HX5+topoMXgIOf0lx
         BUO3FgFdVYkKygha3VYXZaoHz2yrqYEBGnzBZeWVKPBxSWfiSp8hoKuvsOmrpctvoXUI
         MFpPyCPhjYLyJRTaaDxdCeieFvXjKWq2vsMV/wJ4FAMFQfPziPMvHN81/W6NEDdRPwvw
         lXGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761572139; x=1762176939;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=coMQJHEII5UHdUF+Ekj+pHGgsN6WEYzWi8tdyRdD9tw=;
        b=LNWoU3t+kLlgRSCoYwFDEE3Eb6VnJ+2lRJGTEMRIozlKlCwduADOiMJUgkUC3yEypG
         Jxfq33t3fbDIru4EHzOJKUgaCHixTFBjSUtbs/sm3NlSccrKBPE+dkaKEvPlxmZNi5kV
         kjUYlWfudV7fY+aLfvsJ40R/tGCWWKmLPk6nOXHEg9NyKtUAuCvjusDDHA5GYn+TSTej
         EdIDGEmnlYVIZKUYb4i04fANOuH8oV6QsPtF99St670iTv2GM6nib3GFgdqHQ0iXSuNa
         ZcZkJKORcGHLRPtcTT+OwO7ZudgTPXqTc5LoGQDR9KUU1d5/F/lNYg1BfuZNzXEhz8D4
         /Csg==
X-Forwarded-Encrypted: i=1; AJvYcCWP6Zvj9KUF30uxfDXLN7BKBgXy9Sz8ezge031SWxPRbslLAiyo604EP0B/cxFqXwNZltQ8W3sbPcbu@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8V/82l0MYU0X6n1E67Xs7YNkSpCGuJCicgfYp+jGQJQY+FgdT
	cHMWb2R6xrVv6xg+EABbytleI1EGkTMZyRoALfqeW5Gpq98XmGOMHW9wE70JS/ewBvM=
X-Gm-Gg: ASbGncsq8GxVMNu+V3ppXCuDGs65yZ5CKTlJilgK0gs9w67RnJJiLXWSY8L0e3ERs5K
	S9fdhaEp38fmAfd/LIME6hFuXuUeMXAtl4LOQ9Ibmv1torcq6DvLrsi/Jt5Vv9/FdOvnz3HsUaG
	U7A6Pazg2HBLzc5wNgRyo6HSFKb1RyGZVv/8vi0Ti+i3mvyqPkk6OxPR5cmEK+7kcptWvKtG6cc
	R6nH49Ue2woz3gImWNBVFya2L+lL7x/dcsRxmW2vmEk028dFjBvEEY8sTMvtHg+UqO0l05aWNIM
	tTZaoe//aJRwlRe7X3I1KQ5KMj58i9fvlXJoUuoEov9+qu1XTAH5sJByVND6t6K5DYRsG6ifFGz
	JVfvFgH0uVMLceHAYclrMrtKXzNZ66hBOaW/0Vffjfl+GASHHrLVFC807nZtdGb3Ieqs6VmKh3q
	+440n2PbNX0pSfE4E5LVe9wpKO8LM/tOMMsJdkpZ7g3Up1cL06RuSLJs2jaGaENm47HQ==
X-Google-Smtp-Source: AGHT+IHqAIVjFyYDoJjqcp/dMd7ZvxXUjRECSaszUpt0012U8VY/hZ9NeJngEtVEdLXk+JU1qrULHQ==
X-Received: by 2002:a05:600c:3b82:b0:475:daa7:ec60 with SMTP id 5b1f17b1804b1-475daa7ee4amr74939795e9.21.1761572139493;
        Mon, 27 Oct 2025 06:35:39 -0700 (PDT)
Received: from ?IPV6:2a02:3033:263:99eb:3ee8:c1a0:6fbf:4510? ([2a02:3033:263:99eb:3ee8:c1a0:6fbf:4510])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952cbc16sm13967859f8f.15.2025.10.27.06.35.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 06:35:38 -0700 (PDT)
Message-ID: <8de18ee2-ccdd-4cdd-ae49-48600ad30ed4@suse.com>
Date: Mon, 27 Oct 2025 14:35:37 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] usb: uas: fix urb unmapping issue when the uas device
 is remove during ongoing data transfer
To: Owen Gu <guhuinan@xiaomi.com>, Oliver Neukum <oneukum@suse.com>,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org,
 Yu Chen <chenyu45@xiaomi.com>, Michal Pecio <michal.pecio@gmail.com>
References: <20251015153157.11870-1-guhuinan@xiaomi.com>
 <aP8Llz04UH8Sbq5Q@oa-guhuinan-2.localdomain>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <aP8Llz04UH8Sbq5Q@oa-guhuinan-2.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I think I was unclear the first time.
Sorry for that.

On 27.10.25 07:05, Owen Gu wrote:
> Hi Oliver,
> 

>> This patch modifies the error condition check in the uas_submit_urbs()
>> function. When a UAS device is removed but one or more URBs have already
>> been successfully submitted to USB, it avoids immediately invoking
>> scsi_done() and save the cmnd to devinfo->cmnd array. If the successfully
>> submitted URBs is completed before devinfo->resetting being set, then
>> the scsi_done() function will be called within uas_try_complete() after

This requires that uas_try_complete() is called.

And I am afraid uas_stat_cmplt() cannot guarantee that in the error case.
I think the following sequence of events is possible:

CPU A						CPU B

uas_queuecommand_lck() calls uas_submit_urbs()
COMMAND_INFLIGHT is set and URB submitted
						URB gets an error
						status = -EBABBLE (just an example)
						uas_stat_cmplt is called
						resetting is not set
						if (status)
							goto out;

						uas_try_complete _not_ called

The scsi command runs for indeterminate amount of time.
It seems to me that if you want to use your approach you also
need to change error handling in uas_stat_cmplt()

	Regards
		Oliver


