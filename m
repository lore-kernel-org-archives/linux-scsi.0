Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A8014D71A
	for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2024 21:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731965816; cv=none; b=LJqMJWPAGHW1aRpVCIaDCPkLJVeiK3Zjq1al0xhDJwTV8mwEDmNKDakJWOcWikYBUi0rr4Vxgx+Vo9AUAA+Txn8W6qG0ee5JZD/eTgv8/C3QZnnWT4v/xbz9/aboiQTAypygqdvr6y6y2dOe03Ki6yH8JdBYUHyGuYh4CYtcGiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731965816; c=relaxed/simple;
	bh=UNBo1Lco0x9WolsiIE3MdUQgXaUCFUO6MXjU8LqmKPc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tnfI882PhJsw5zHykULYVJMjgfuFNpaXohRcpwpkxpLXzNv0U37gnu2ujTlTVjvYOOxlTBEXonY/2pXLTefib4LffbDhCwuebskKwdJlXamIksWRDVezJ9mgwG7hnRqUOo6hu4N+iVyyDCKZxIxtTlr/Uqw/+tb+gP7mxyardPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CQESfNuT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CQESfNuT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731965813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lFrofE59RD6JfbVxlVuEbbexFvRuyekCiVkVuK4I8X8=;
	b=CQESfNuTVfAusqHSxkTNWnt9zabFh2dWdT3aUElHFa+ONl0NW00P1cvStkgvDD1RUITMHO
	7MWp6s4PJuu/KY7Z081Lfkqc9uLP8jm1uLy1pFqAqFFwFtx+XBC7B/BsBq5nvpE/0uSNyj
	MDI/zmzEO7RRLkkZ77bpRnWxIzmnvyY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-ofwY165aMSSRIBamW53XJg-1; Mon,
 18 Nov 2024 16:36:50 -0500
X-MC-Unique: ofwY165aMSSRIBamW53XJg-1
X-Mimecast-MFC-AGG-ID: ofwY165aMSSRIBamW53XJg
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 65A3B1955E75;
	Mon, 18 Nov 2024 21:36:49 +0000 (UTC)
Received: from [10.22.81.39] (unknown [10.22.81.39])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 965791955F49;
	Mon, 18 Nov 2024 21:36:48 +0000 (UTC)
Message-ID: <50e7550c-cfeb-4a14-ac56-58b2a94f0f82@redhat.com>
Date: Mon, 18 Nov 2024 16:36:47 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: st: Remove use of device->was_reset
To: =?UTF-8?Q?Kai_M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org
Cc: loberman@redhat.com
References: <20241115162003.3908-1-Kai.Makisara@kolumbus.fi>
 <20241115162003.3908-2-Kai.Makisara@kolumbus.fi>
 <7E2EA0D1-63ED-44A8-A12B-C9B78C28B0E5@kolumbus.fi>
 <BED6505B-A8FD-4445-B61B-5F43899DAD54@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <BED6505B-A8FD-4445-B61B-5F43899DAD54@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17


On 11/16/24 10:35, Kai Mäkisara (Kolumbus) wrote:
>  
>> On 15. Nov 2024, at 19.45, Kai Mäkisara (Kolumbus) <kai.makisara@kolumbus.fi> wrote:
>>
> ...
>>
>> I still think that UNIT ATTENTIONs (UAs) reach the high level device without
>> problems. The problem is that the device attached to the target first issuing
>> a SCSI command after reset gets the UA. As long as this is st device,
>> there are no problems. But, if it is the sg device attached to the same target,
>> the tape device misses it. > ...
>>
>> And there are cases where the device reset does not originate from the
>> same computer.
>>
>> Does anyone have any suggestions?
> 
> Besides Power on/Reset, the same problem applies to the New Media case.

It seems to me this would apply for any Unit Attention. A hardware device can set a unit attention when ever acted upon by a 
third party.  It is difficult to test this type of event w/out a multi-initiator bus... some kind of configuration that connects 
multiple host to the same SCSI target/lun device.  Large tape library configurations can do this. I don't have a test bed like 
this.

> One solution might be the following: the midlevel maintains counters for
> the Power on/Reset and the Media change UNIT ATTENTIONs. The ULDs
> can read these counters (using wrappers). If the ULD find for a device that
> the counter value has changed, then the event corresponding to the counter
> has occurred. The problem of clearing event flags is avoided,

I'm not sure I understand what problem you are trying to solve... are you trying to get the mid layer to report Unit Attentions 
to all ULDs that are attached?  That is, you want the mid layer to report the UA to all ULDs, not just the last/latest ULD?

> A drawback comes from the counter wrap-arounds. If, e.g., four-bit counters
> are used and there are 16 Power on/Resets between the checks by the ULD,
> the event is missed when the counter is used. 

I don't think that would be a problem. As long as the latest and highest priority UA is reported, older, lower priority UAs can 
be overwritten.  For example, a New Media UA followed by a POR UA - the Power On reset should take precedence.

> The ULDs should also check
> the sense data they do receive. It is possible/probable that the event is
> recognized based on the sense data even if the counter check misses it.)

Yes, definitely. ULDs should check the sense data.

> This solution is easy to implement. I have a test implementation running and
> it seems to be working.

I've tested these patches that you've posted here with my locally attached LTO-5 tape drive.  Everything seems to fine...

You can find the test results at:

https://bugzilla.kernel.org/show_bug.cgi?id=219419#c20

Note that I've added my own instrumentation patch on top of your series as it helps with the debug logging.

linux(tape_test) > git logl -7
177c3f710de4 (HEAD -> tape_test) scsi: st: instrument the pos_unknown code [ John Meneghini / jmeneghi@redhat.com ]
7373d7d717a0 scsi: st: Restore some drive settings after reset [ John Meneghini / Kai.Makisara@kolumbus.fi ]
25be4d26ef58 scsi: st: Remove use of device->was_reset [ John Meneghini / Kai.Makisara@kolumbus.fi ]
c5e0a7687c6b scsi: st: New session only when Unit Attention for new tape [ John Meneghini / Kai.Makisara@kolumbus.fi ]
1ab8b314a34b scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed after device reset [John Meneghini / Kai.Makisara@kolumbus.fi]
0013312311da scsi: st: Don't modify unknown block number in MTIOCGET [ John Meneghini / Kai.Makisara@kolumbus.fi ]
2d5404caa8c7 (tag: v6.12-rc7, branch_v6.12-rc7) Linux 6.12-rc7 [ Linus Torvalds / torvalds@linux-foundation.org ]

> 
> Other solutions that have come into my mind are much more complicated
> than the counters. Here are examples:
> - the UNIT ATTENTIONs would be sent to all ULDs attached to the device
>    when they issue the next SCSI command
> - the ULDs would have possibility to register a callback for UNIT ATTENTIONs

This is actually what the SCSI device is supposed to do.  If you have a truly SCSI compliant tape device, designed to support 
multi-initiator access, unit attentions are supposed to be maintained on an I_T by I_T basis. So a device reset from one I_T 
will set a UA on all I_Ts, and clearing one I_T will clear only that I_T nexus UA.  But I'm sure that some of the older, legacy, 
tape devices don't do this.

Let me know if I can help by testing any further patches.

/John

