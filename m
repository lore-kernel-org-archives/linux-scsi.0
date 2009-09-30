From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: qla2xxx: Conditionally disable automatic queue full tracking
Date: Wed, 30 Sep 2009 13:23:27 -0500
Message-ID: <4AC3A21F.8070705@cs.wisc.edu>
References: <5355D915-9CAE-41CD-846B-F816FE914E1B@qlogic.com> <4ABB8572.5050902@sgi.com> <67E59C8B-0E12-44EA-983C-38634993DF5A@qlogic.com> <4ABBC53F.9090203@sgi.com> <3E1B3796-029F-4DBE-A414-0358AB257E93@qlogic.com> <4ABBDE68.2020903@sgi.com> <ABA38BF9-3910-45E9-8C2B-C860FD862D59@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36989 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbZI3SXk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Sep 2009 14:23:40 -0400
In-Reply-To: <ABA38BF9-3910-45E9-8C2B-C860FD862D59@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Michael Reed <mdr@sgi.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, LinuxSCSI <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "vasu.dev@intel.com" <vasu.dev@intel.com>

On 09/29/2009 08:34 PM, Giridhar Malavali wrote:
> 3) From your previous mail, I understand that you don't require a
> combined limit per target. Say the total queue depth for all LUN's on a
> particular target should not exceed some threshold.
>

James Smart had done this patch
http://marc.info/?l=linux-scsi&m=121070114018354&w=2
where it sets the starget->can_queue based on info we get from vendors. 
The patch did not get merged. JamesB does not want the 
starget->can_queue to be static, and wants code like the queue full 
tracking code which dynamically ramps the device queue depth up and down.

I am not sure if JamesB meant that he wants to ramp down the 
starget->can_queue based on getting a QEUEU_FULL though. I thought he 
just meant he wants it to be dynamic. If I am right, then I think we 
could use JamesS's patch to set an initial starget->can_queue and add 
another field for a max value. Then we could add some code that ramps 
down/up based on something like command completion time or throughput or 
some other value.

If JamesS did mean that he wanted to ramp down the starget->can_queue 
based on QUEUE_FULLs then JamesS and JamesB do not agree on that and we 
are stuck.
