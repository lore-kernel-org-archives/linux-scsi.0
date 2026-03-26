Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75A438654A
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2026 10:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774520283; cv=none; b=XW7Yws3a/KxIugBsstlvYDb/T4T9wXKNMRWoMlhFURAIn3bGXTYeq3v+HrwygOzsCUuciCEZD8N3/syF55Mm//4a3NYSIYYDvNrMgyn763BUKY/lLcohql39G8a0hO2WiIk3G+RGixG5AX+eOR6di74PSRe4vZ8wLWoVOFJU/S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774520283; c=relaxed/simple;
	bh=ODLSbBq3jG2GiZ6WeG7pvi+Ik3MjBd10Zn78pA6ONec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qyRi7+OMWCTHfwKn/ENsQfp4Q9jChfpk0GWFxJq4wvvTpbca4LDDcYDKcOoVM0W1VALFQoB8BnZ0CEVzj6ZaWkaRfadz29AsDXB2dN+SCeobUsyJDmsYlQdsLpA6c9kSVgou7WdLa404MP8MLiyvur/YxtIWz+ok/43btF7tNlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EU6PCbZj; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EU6PCbZj"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4853e1ce427so9232775e9.3
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2026 03:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774520280; x=1775125080; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VAYW3jWafk2UzHDDSsl8jJCoKnsgoRuB9g+KcQ0+qII=;
        b=EU6PCbZjb2AicUIJmg2oanOAasDZmyopengrSWHVd63tEW4ZEeUlrERZr9CZ9ULXO/
         KcWAw1WyaM6LfG4qboqo2YO1ArUu4ZvmfI7ubigj9HswG5i2SYWzR8KTPF4jeT621Sng
         G6/9g/8eznhverC8Ux2cR+a82j4oJrVPBW+5KhuI5wu1/mXeP2czCvx8pgmKg5Iw9t5z
         kv4Q2c1zyq2YBJJ7gaPn0sdoUUIzgDxilGEC5/ocjaskIJrdujf+KMCETxICzpJ8gy7z
         efKTst1ZeVM9Qi/M3r0vhV2a09AgjkHl3jTZc5swFsSOsUUKUh1l5YJkLA7CD3I78g5T
         OpGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774520280; x=1775125080;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VAYW3jWafk2UzHDDSsl8jJCoKnsgoRuB9g+KcQ0+qII=;
        b=Ye4oH3/6AQ6T05kPo9PARYPwq4FKWSknnCl0MqgErtJxkMrvya7JJfmp6hG6BuJk0W
         W+b+ayiNAymXW0Zdi6z9ZDD/kB/pQMJbnJrsnoZQzadgevuJwA5Tn1N8rPLod4DO7F/v
         IC+TYTG2WLVsy4VQGl7QEyz8NsWndCKePaQee6Pf1cQ5jhYM/i66Sjp7vVisDnc2nnQO
         /n4areg/k73haXjFBOleiOTSe4CniI4yXGQHBJolCHeFEEL473s66EMwnbKoGy9d1v04
         x/Nr789Zl8e34KPkqir4ljH6X7QTY9ORJynHb//QDzd854AFkr6IbaPgsXaoa8PDfaRZ
         xDJw==
X-Forwarded-Encrypted: i=1; AJvYcCUrwDi/GZXr+VSCf78cr3NE2/9m+XkPxjUtkxEwmCBXSTVd/7nTvLFUVJSDPv/Aw+WDCJe2zH6uKW/m@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2mtdMdCzTJ3y2tTJ0+uup96XPCIQfN/IWzRujAZDsBaPcnoAo
	QK0ZcLkOb7l43h/EwDfRIRpj9rAYRgkw4x8Ic2ahHHzN472yAM5HrTp5CPKRiKxdIgc=
X-Gm-Gg: ATEYQzy/6sxWwuzfQ3ERLYFIyHi7/eD4RsK69W+OLpHN7EYzeQNl+vWtj6ebIDA3r3y
	uFhzOgcTIYiHlD3dvEWS24uEp/CyqN30SjRu834RZurZHBJqw7j5Y9wXIReMniReG0t7idEF6FE
	pO09ksyEiZv7hxofdJMiyCldAXf+nChAFbOhTXivCN00KUGsXLbNiyiHapDteYejoqa4K/ONg9l
	v99gyeJRvxiOBKkm81XnscwkXj2jWQADb3ynDYwA30S/yMR//nzrLfBOHn3E9oy3w0G7R8EYCjG
	OWTBeIVLXgAX16saltFcEeN1QOxG7AQi/APfzgnB6FPIDlkeEP3taafdUaV6e1RZgZ2ShtDQwt5
	6ekIwQc+pDXIJ6zICLAq8XOqQcaiZPx+nHmQgCRazjzebZCxikZ1OjHD1sbDLmASyGFK7kjIQP7
	ZebMGV71hTIx4ViaIP+WFUVvbxrwHbpLl0W8a3J98RZ8QbzcVLQKpXPDy6
X-Received: by 2002:a05:600c:8011:b0:485:2ce2:4c8a with SMTP id 5b1f17b1804b1-48715fbf607mr96680495e9.1.1774520280028;
        Thu, 26 Mar 2026 03:18:00 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48722d38a5fsm19972075e9.12.2026.03.26.03.17.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2026 03:17:59 -0700 (PDT)
Message-ID: <554f791d-17c2-48ab-8014-1ef62ba5b85d@suse.com>
Date: Thu, 26 Mar 2026 11:17:58 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/13] scsi: Core ALUA driver
To: Benjamin Marzinski <bmarzins@redhat.com>,
 John Garry <john.g.garry@oracle.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
 jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
 michael.christie@oracle.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <acAo0hr4BxXueQFM@redhat.com>
 <f72bc385-fdc1-4f4b-8567-bee083818400@oracle.com>
 <acFpYuaL-_9g90RI@redhat.com>
 <10aab639-2fe8-47b7-b821-12d21b6af874@oracle.com>
 <acGYbD6X55eA-ynl@redhat.com>
 <43ca92bc-af38-4833-841c-421997ed90fe@oracle.com>
 <acKYbwGlfgWKDxnF@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <acKYbwGlfgWKDxnF@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/24/26 14:58, Benjamin Marzinski wrote:
> On Tue, Mar 24, 2026 at 10:57:20AM +0000, John Garry wrote:
>> On 23/03/2026 19:45, Benjamin Marzinski wrote:
>>>>> I don't
>>>>> think the Native SCSI multipath code would need to actively interface
>>>>> with the device handler code to support IMPLICIT ALUA. IIUC, looking at
>>>>> sdev->access_state should be enough to pick the correct path.
>>>> We also have the functionality from alua_check_sense() to consider.
>>> But the multipath code won't call that directly. Right now, the scsi
>>> device handler will, at least for every scsi device except ones using
>>> the Native Multipath code. My point is that this would just work, except
>>> that the Native Multipath code goes out of its way to break it, by
>>> disabling device handlers, and I don't really see the point of disabling
>>> something that every other scsi device, multipathed or not, has enabled.
>>> It's not like leaving it enabled makes it any harder to move the
>>> implicit ALUA support from the device handler to the generic scsi code,
>>> if that's the goal, since the Native Multipath code doesn't care who is
>>> issuing those rtpgs and updating the state.
>>>
>>> I guess this is more of a question for Hannes. Is the goal to turn off
>>> automatic device handler attachment in general, and go back to making
>>> dm-multipath attach device handlers to the scsi devices it is using?
>>
>> I'm not answering for Hannes, but I don't think that is the goal.
>>
>>> If
>>> not, then I don't see any reason to have the Native Multipath code
>>> disable it.
>>
>> It was just disabled it as we now had another method in the scsi core code
>> to get ALUA info.
>>
>> My plan would be - based on this series - to not attach DH just when using
>> native SCSI multipath for a device.
>>
>>> If it allowed device handlers to get attached, these two
>>> developement efforts (native scsi multipath and refactoring the alua
>>> support) could go on in parallel.
>>>
>>> Or am I missing something here?
>>
>> It just seems to be about this DH stuff is that there is bad history there
>> and no more users are wanted.
> 
> Just to be clear, if the idea was that the Native Multipath code
> shouldn't use include/scsi/scsi_dh.h, I completely agree with that. But
> I don't see why it can't make use of the results of the existing
> implicit ALUA support, since IIUC it doesn't need the scsi_dh interface
> to do that. That shouldn't interfere with any refactoring that people
> want to do of how the scsi layer actually handles ALUA support. Again,
> this is more for Hannes than you, John.
> 
Oh, it's not that it technically cannot use it.
It's just a design thingie: my idea for the native SCSI multipathing
is that it should be _simple_. There really is not point (and, in fact,
was one of the main motivators of this idea) to re-implement every nook
and crannie from dm-multipathing.
SCSI multipathing should only handle implicit ALUA, and leave every
other functionality to dm-multipathing.

And on the other side, I always found it completely irritating that
one had to enable multipathing in order to get ALUA support (ie
being able to figure out the ALUA state). The ALUA state is a property
of the LUN, and the system has to react on that one. It really doesn't
matter whether the system has multipathing enabled; if the LUN is in
ALUA Standby state we cannot send I/O, full stop.

And that's what we're trying to achieve here; move implicit alua support
from SCSI DH into the SCSI core, and leave SCSI DH to handle explicit
ALUA support.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
