From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] SG_SCSI_RESET ioctl: add no_escalate values
Date: Fri, 15 Feb 2013 23:45:43 -0600
Message-ID: <6C2A267D-259E-43B4-A06F-AF09B537F9E6@cs.wisc.edu>
References: <511E8EF7.3010004@interlog.com> <511EAD33.7000901@cs.wisc.edu> <511EC5A2.9080107@interlog.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:32770 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab3BPFpw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Feb 2013 00:45:52 -0500
In-Reply-To: <511EC5A2.9080107@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Jeremy Linton <jlinton@tributary.com>


On Feb 15, 2013, at 5:32 PM, Douglas Gilbert <dgilbert@interlog.com> wrote:

> On 13-02-15 04:48 PM, Mike Christie wrote:
>> On 02/15/2013 01:39 PM, Douglas Gilbert wrote:
>>> Further to the thread titled: "[PATCH] SG_SCSI_RESET ioctl should
>>> only perform requested operation" by Jeremy Linton a patch
>>> is presented that adds "no_escalate" versions to the existing
>>> ioctl. This should not break any existing code.
>>> 
>>> This patches applies to lk 3.7.7 and lk 3.8.0-rc7 . I will extend
>>> sg_reset in the sg3_utils package to use it.
>>> 
>>> ChangeLog:
>>>   - modify SG_SCSI_RESET ioctl so the SG_SCSI_RESET_NO_ESCALATE
>>>     value may be added to the existing values. If so the existing
>>>     device->target->bus->host escalation does not occur.
>>>   - modify scsi_reset_provider() in the scsi_error.c file in a
>>>     similar way to support this new functionality.
>>> 
>>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>> 
>> Some drivers rely on more invasive eh callbacks to be called if they
>> return FAILED in a eh callbacks. Is there a way for drivers to tell
>> scsi-ml it needs the old behavior?
> 
> Mike,
> The old behaviour hasn't changed both at the
> ioctl(SG_SCSI_RESET) level and the underlying kernel
> scsi_reset_provider() function. In both cases extra
> values have been added: to third argument of the ioctl
> and the second argument ('flag') of the
> scsi_reset_provider() function. The existing values
> will do exactly the same thing (i.e. escalate) with
> the same return values.
> 
> The only way it is different is that values that were
> previously errors (precisely 0x101 to 0x104) now cause a
> non-escalating device(LU)/target/bus reset.

Sorry for the confusion. I should have written is there a way for drivers to tell scsi-ml it only supports the old behavior and does not support the new calls? If not then I am guessing this is mandatory to support and we need to fix the drivers right?

If userspace sends a command that performs the non-escalting *reset to some drivers, it is going to leave them in a state where they may not process IO or will crash.