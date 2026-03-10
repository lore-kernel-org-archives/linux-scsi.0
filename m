Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664273C9434
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 17:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773165295; cv=none; b=Om++VPHP46yHQJw/R1i5Av/fcwlBurGTezHM2UmYjE+yBERz2v5SrGstIs6uPoSGYbaNU3/1CZZUNGRmi+tulNI7oC8UAtzyqr4ikUYZxN/+0ZDssPw9lFVmVAAwvIiZf1szlEVYwXyrsh/tzMxji+80NX77ohSPaUMx+klRBS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773165295; c=relaxed/simple;
	bh=SwJIA9MTxdZ8STOa+2dg+eURC0+yijgQo1QtJ+LnHiw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=drbLMmRggvk8PQs/dNLFjd+BEulGFGhSR2uT7IOPjTfhxYzFSJK6a6rD75+LBsktqd988uV0vp4YmvJso8gJKgYRu9AT36wHBB5RUHhPnXHp6XyQEXhy2pD1cqEEoGe2eVB/yYejh1KpsHrhuz2XC4fbcU+4HNuwwHfjNoY+TY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=V3jNy6dv; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V3jNy6dv"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-439ac15f35fso9622704f8f.0
        for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 10:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773165293; x=1773770093; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qEnF/Lg25U18+ZKcj41EcZIOIb03fm6HJ1Ff4fvEotU=;
        b=V3jNy6dvVhKuTYRrpBi9+1OyGzaolT+AR1LXjNHavu87kH5nOzXLwG+fV05yejmWuw
         i8kibIDkgB/o2ixHDqQanQTC9SucE7aObO30M73GszZoSGVjsxVIruZDvsmHHj+Iiv6W
         rmBW4weBJ5yjYd+mGbV1X4o24a9mxNXZIlJizxAb+NwNpAGPEu9TcGuSmExktgPoYrw+
         J6l1exm8q3ZDAvlj9KiuQyQrI6IIymLtGahqfOJhiGsJJZ7augcn35Zc8JoM/JzhBpxg
         +AtLdejy3XWBzj0FsZRzIF/D3aGYfJXOIE3B+kI+mT6YNsyZmT29lz51/KL6z8dV676S
         XKPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773165293; x=1773770093;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qEnF/Lg25U18+ZKcj41EcZIOIb03fm6HJ1Ff4fvEotU=;
        b=KMUl/pQl+kMMqjGtCPiXQ3wJTOTzWjPhEXvM0YXtyZUN4JrXB1dddxk726uCPa0AvI
         txudWhq8k9OQUAtbVL3BRe/B5gYIDPSp9jLbPWwg4mpwJ7kCOK2c4x/m5txZJdzm9SFr
         5Wxn309BTtOtB5JCSOsyg2/YFTqeM/OZ7UMvu2VrKkSrbuqbi+paH2nNJd+xyZWWGLfa
         yjf0u6O+eJYX18QyXEPY2QhFJOp+AMNV7mE3XrSUWpe4Hi/w2U+bB7FIEc8YA+8b3ek6
         rDBziXxzWvj6g7IQ4aLEC1oVeLyOy/JJBKX3tG2C73EDJ7DlUSiPc7agBvRuVJBOPuK8
         pWBw==
X-Forwarded-Encrypted: i=1; AJvYcCWcbVpen0Ol70ahJDLzECD9Zjql4u+sxbTcvq5hS2S5VeYQBnPN2qKEGTcqsQqHvBE8R4/KrhjTAKG9@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9z6MgCyTsi6LSAjVxsGvJXGDGA9CT/Lbk2lPwbt9biMTo6RDB
	XiSkv8jQguQiOOX/KTR2kf9nIKnTfNEofoE+Ui+7t67XqZnvcXYYM86Issjcbw1OHDw=
X-Gm-Gg: ATEYQzzTTuvPb60oz3cL240Ia27rGSg0pwLTSJHLh1ogaDyjG63IkL+7AK0p+FBAEa3
	wCrwPFKmtzCCRv9Bg1WUr8onxPKwub6vNp6UPHPQRZ/qpBx0vjBIdfjTY0EKqjc650evTg13Sut
	PqBlLqsyHOm1OGO09ZrY3AmquBK8qFqYfKaWyw7WpG8B6VmvwQt6qy8MBxgHx6YhDS6efRzn/Fr
	mDA/4tn5TJiyaedPyLNQgZa/p7U5S/zW4BnlRQXq7hLlj0+DoYDMFeKEmuf4HI2RKnsLHFeUOf/
	MJt/U1S1aIMEJW4KsUHaSjnZK5Qb2ajCdlhTTdVlGEKJ2xjj1UqRPC81TDdrgPrnNrElhbiFQn7
	QHJWX4ZhmIUSOh3eB+zbbjJMmWngVEQ2OED891gHukyGj2Ck26pyxHmTwgM5/3+DT/KPCYqA70U
	0QliIlmj3+B1yONrWZYeFmTCQWr6D+bQWB6NBcMT+3wmr5nn31ofH60n4a2T2l
X-Received: by 2002:a05:600c:4f07:b0:485:3171:7845 with SMTP id 5b1f17b1804b1-48531717a94mr200528055e9.4.1773165292732;
        Tue, 10 Mar 2026 10:54:52 -0700 (PDT)
Received: from ?IPV6:2001:a61:2a16:da01:fd99:79eb:2f5d:d346? ([2001:a61:2a16:da01:fd99:79eb:2f5d:d346])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48541b6f708sm126141845e9.11.2026.03.10.10.54.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 10:54:52 -0700 (PDT)
Message-ID: <6b6a822c-4e49-4e80-ba57-57704e3c1307@suse.com>
Date: Tue, 10 Mar 2026 18:54:51 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] scsi: scsi-multipath: Add basic ALUA support
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
 martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
 bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org, sagi@grimberg.me,
 axboe@fb.com, linux-scsi@vger.kernel.org, michael.christie@oracle.com,
 snitzer@kernel.org, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 nilay@linux.ibm.com
References: <20260310114925.1222263-1-john.g.garry@oracle.com>
 <20260310114925.1222263-6-john.g.garry@oracle.com>
 <f46807c2-0266-4143-9caa-ff938293f7b4@suse.com>
 <3178d371-7a4c-4d07-885c-42496190f242@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <3178d371-7a4c-4d07-885c-42496190f242@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/10/26 16:52, John Garry wrote:
> On 10/03/2026 13:23, Hannes Reinecke wrote:
>>>       sdev->scsi_mpath_dev->index = ida_alloc(&scsi_mpath_head->ida, 
>>> GFP_KERNEL);
>>>       if (sdev->scsi_mpath_dev->index < 0) {
>>>           ret = sdev->scsi_mpath_dev->index;
>>> diff --git a/include/scsi/scsi_multipath.h b/include/scsi/ 
>>> scsi_multipath.h
>>> index 2011447f482d6..7c7ee2fb7def7 100644
>>> --- a/include/scsi/scsi_multipath.h
>>> +++ b/include/scsi/scsi_multipath.h
>>> @@ -38,6 +38,9 @@ struct scsi_mpath_device {
>>>       int            index;
>>>       atomic_t        nr_active;
>>>       struct scsi_mpath_head    *scsi_mpath_head;
>>> +    int            alua_state;
>>> +    int            alua_pref;
>>> +    int            alua_valid_states;
>>>       char            device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
>>>   };
>>
>> Is there a specific reason why this cannot be in the generic code?
> 
> Sure, it's possible....
> 
>> After all, if the device reports anything else than ALUA_STATE_OPTIMAL
>> or ALUA_STATE_ACTIVE I/O will fail, irrespective of multipath being
>> active.
>>
>> I would love to see that in the generic SCSI code, independent on this 
>> patchset. It would allow us to simplify the device handler code, too,
>> as then device handler really would only be required for explicit
>> ALUA. (And could be ignored for scsi-multipathing).
> 
> Right, so you would like to see alua_port_group management in a core 
> ALUA driver as well, right?
> 
> If yes, to repeat, it is hard to separate the DH stuff out...but I can 
> try. Examples I would need to deal with (and associated handling):
> 
> - alua_port_group members like dh_list
> - alua_dh_data memebers like init_error
> - everything in alua_queue_data
> 
While the port group handling looks nice (and there certainly is
a certain neatness to it), it kinda assumes too much about the
internal layout of the hierarchy within the target.
Technically, a target is only required to provide a device
identifier, and a group id (such that you can match with
RTPG output). However, you have no idea which of the various
device IDs are part of the same enclosure; that information
is not required to be present.
So you cannot assume that group ID A reported from device X
is the same group as group ID A reported from device Y.
The only reliable way is to check with the RTPG output, as
that contains all device identifiers for the defined group
IDs.
But: caching RTPG output is problematic (as it'll change
whenever a path state change happens), and it'll need to
contain references to the SCSI devices, introducing all
sorts of locking issues and race conditions.
So probably I would not go down that way (at least initially),
but rather read RTPG during scanning, and set the values
directly in the scsi device.

We then need to re-read that information whenever we hit
a relevant sense code, but arguably we'll need to do that
anyway.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
