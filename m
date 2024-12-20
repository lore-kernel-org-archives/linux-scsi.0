Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089A91A3BC8
	for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2024 22:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734732888; cv=none; b=fcsfsQG1mEPFM3MsYojavQJYWh/aS6hCZ2DqIsfpl3twu/VDa0R6KANCF1eVAK1X0DGBwL92UDaWUnrxhIF0AVAxclAPD29l9bF6QJ4eSoyTUac7EgMEMKLY6JYwMKtxrLBnDvupaB/AQPWgznr03UJqpEb/F62sKRhzH1OxuLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734732888; c=relaxed/simple;
	bh=ElTQ99U8uK+sd9C2TR7fijmpYCALnMpiOdZGqNo0XPY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C/nL7dQrITVILdQ8etXJdFNhxWohQkUTzCjD4qojb0wADK5zUZihQgKVRguyeroVZAqz4GIym7ATyAzmpS0NU85C/RZMuLfdSq2MRxMNK1L+WJ7NnmiZPy0Hs1ZfEepRbyGPfOn7DqpqEC0tOOzhTlSdRwm/CCBuri4fk8uStqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U29nNYXJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U29nNYXJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734732885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VfRf3ZkBN78aE2C9EQHzYxAKyn3cAaUWWTPYbeUWYg8=;
	b=U29nNYXJR8Zi3LLwLf8nm9lDw8uh7l0HM3Bm6NRsvwe3P+k61yI1NOW+PLnqGrbKv9MMIW
	BenuEFIRfcN+DafN10b+3QX05euEXp76Q7X3f0xCI38D+nHOevgGVw6piEwXzI4dNaosXK
	0gTp6spHfNS4uU7OXf0OGvV3Xe98DeE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-391-rA4wfmZNOVeUWPL7jc7S4A-1; Fri,
 20 Dec 2024 17:14:41 -0500
X-MC-Unique: rA4wfmZNOVeUWPL7jc7S4A-1
X-Mimecast-MFC-AGG-ID: rA4wfmZNOVeUWPL7jc7S4A
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 60A4C19560A2;
	Fri, 20 Dec 2024 22:14:40 +0000 (UTC)
Received: from [10.22.89.120] (unknown [10.22.89.120])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9BC7430044C1;
	Fri, 20 Dec 2024 22:14:38 +0000 (UTC)
Message-ID: <b8af1fd1-6f19-4d93-95bf-034baaf4cbec@redhat.com>
Date: Fri, 20 Dec 2024 17:14:37 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] scsi: st: scsi_error: More reset patches
To: =?UTF-8?Q?Kai_M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
 "James.Bottomley@hansenpartnership.com"
 <James.Bottomley@HansenPartnership.com>, loberman@redhat.com,
 Bryan Gurney <bgurney@redhat.com>, Ewan Milne <emilne@redhat.com>
References: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
 <0c6e699b-8f77-411f-b73d-e6762c6ad286@redhat.com>
 <8B3169CC-BD8A-46B5-B9B0-140047A44661@kolumbus.fi>
 <964CF609-B7DB-44CF-80A2-2955E73561EF@kolumbus.fi>
 <ad401bf6-e4a6-4372-8205-22e923900e5e@redhat.com>
 <2201CF73-4795-4D3B-9A79-6EE5215CF58D@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <2201CF73-4795-4D3B-9A79-6EE5215CF58D@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On 12/14/24 08:46, "Kai Mäkisara (Kolumbus)" wrote:
>> On 13. Dec 2024, at 19.32, John Meneghini <jmeneghi@redhat.com> wrote:
>>
>> On 12/13/24 08:09, "Kai Mäkisara (Kolumbus)" wrote:
>>>> On 12. Dec 2024, at 20.27, Kai Mäkisara (Kolumbus) <kai.makisara@kolumbus.fi> wrote:

>>>> Note that this problem has existed since commit 9604eea5bd3ae1fa3c098294f4fc29ad687141ea
>>>> (for version 6.6) that added recognition of POR UA as an additional method to detect
>>>> resets. Nobody seems to have noticed this problem in the "real world". (Using
>>>> was_reset was not problematic because it caught only resets initiated by the midlevel.)
>>
>> Just to be clear. People in the real world did notice this problem. We have multiple customers who have reported "regressions" 
>> in the st driver, all of whom starting using a version of our distribution which had commit 9604eea5bd3a. The changes for
>> 9604eea5bd3a (scsi: st: Add third party poweron reset handling) were necessary to fix a real customer reported problem, but 
>> there were a number of regressions introduced by this change and it looks like we haven't gotten to the bottom of these regressions. 
>> Basically, we had so many customer complaints about this that we reverted commit 9604eea5bd3a in rhel-8.
> 
> This sounds puzzling. The pa9604eea5bd3a (scsi: st: Add third party poweron reset handling)tch 9604eea5bd3a has been signed off by you. Now you say that
> there were a number of regressions, so that you have reverted the commit in rhel-8. Yet, there
> have been no reports of regressions in linux-scsi. Or have I missed something?

Yes, I signed-off on a patch that introduced a regression.  Of course, I was unaware of this at the time.

Laurence and I worked on commit 9604eea5bd3a (scsi: st: Add third party poweron reset handling) and tested it extensively with a 
scsi gateway using third party resets. The patch fixed the problem. The customer tested it. We told the customer they needed to 
reposition/rewind the tape with mt rewind following any third party poweron/reset event - which apparently happens not 
infrequently in their environment. This worked for the customer so we thought it was good. The st driver had never correctly 
handled a POR UA before so we didn't think the fact that MTIOGET returned EIO following a third party reset was a problem.

However, the part that we were not aware of was: tape drives set a poweron/reset UA when the machine reboots. So we started 
getting complaints from different customers about the fact that MTIOCGET suddenly fails with EIO after upgrade. The work around 
was simple (issue an 'mt rewind') but customers did not like this, and when more than one or two customers started calling and 
complaining about this, we reverted the patch to avoid generating more calls. This is when I opened Bug 219419 - Can not query 
tape status - MTIOCGET fails with EIO.

   https://bugzilla.kernel.org/show_bug.cgi?id=219419

We have fixed that problem now and the fix, including commit 9604eea5bd3a, is being disseminated in rhel-8 and rhel-9.

I see now that stinit and dd, and possibly other IOCTLS, are unexpectedly failing too. I'm not sure if we can call these 
regressions or not. From what I can see the st driver never really handled POR UA's correctly. It only worked with sg_reset 
(first party reset)... but I agree that customers probably will not like this.

> I have made some experiments with st.c from v6.4 (before the commit) and v6.7 after the
> commit. My (slightly tuned) scsi_debug was started with option 'scsi_level=6'. The
> test used the stinit tool that can be used to set st parameters after a drive has been
> detected (using, e.g., udev). (And I think  that any decently configured Linux system
> with tape drives should set the proper parameters for the drives.)

Agreed.

> The test uses modprobe to load scsi_debug (and this loads also st). After that
> the tools mentioned above were tried:

If you want to share the details of exactly what your tests are doing (privately if you'd like) I will try to reproduce your 
results.  Obviously, one problem here is that our tape tests here at RH (and everywhere) are inadequate - at least w.r.t. 
resets. I'm working to improve this.

> st.c from v6.4:
> - stinit succeeds
> - 'dd if=/dev/nst0 of=/dev/null bs=10240 count=10' succeeds
 >
> st.c from v6.7:
> - stinit fails
> - dd fails

This is simple enough... I'll add this to my tests.

> So, there is are clear regressions caused by commit 9604eea5bd3ae1fa3c098294f4fc29ad687141ea
> and this must be fixed. One method is, of course, to revert the commit. Another alternative is to do
> something to solve the problems created by the commit.

I really don't want to revert commit 9604eea5bd3ae1. It actually fixes a real problem where the tape drive behind a gateway 
device crashes and resets itself.  Then, because the st driver ignores the POR/UA, it writes a file mark at the BOT.  This 
destroys the customer's backup.  It is a serious problem and a day-one bug.

> Modifying st to accept what stinit uses even is pos_unknown is true fixes the stinit problem,
> but dd still fails. 

OK, shouldn't dd fail if the pos_unknown is true?  Basically, anytime the tape device reports that it has been reset the 
application NEEDS to reposition the tape.  And, for that matter, the application should also check and set any options that 
might be wanted.  The application can't just ignore these POR Unit Attentions.

> Not setting pos_unknown after the initial POR UA fixes both problems.

That's fine with me... I just don't understand how you can distinguish "the initial POR UA" from any POR UA.  If you have a 
patch that can figure out how to do this... that's great... let's try.

Thanks for all of your work on this Kai. I will continue to help as much as I can by testing any further patches you have.

However, that will have to be after Christmas.  Things are shutting down here at RH until January 2.

Thanks again,

/John

