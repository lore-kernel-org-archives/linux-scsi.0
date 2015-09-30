From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH v4 25/32] cxlflash: Fix to prevent EEH recovery failure
Date: Thu, 01 Oct 2015 09:53:06 +1000
Message-ID: <87mvw3sbvh.fsf@gamma.ozlabs.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443223134-9886-1-git-send-email-mrochs@linux.vnet.ibm.com> <87612uuich.fsf@gamma.ozlabs.ibm.com> <F4D4C09B-DEF2-485E-9453-671DF867AE37@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36051 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbbI3XxM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Sep 2015 19:53:12 -0400
Received: by pablk4 with SMTP id lk4so54074903pab.3
        for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2015 16:53:11 -0700 (PDT)
In-Reply-To: <F4D4C09B-DEF2-485E-9453-671DF867AE37@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>, Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

"Matthew R. Ochs" <mrochs@linux.vnet.ibm.com> writes:

>>> The process_sense() routine can perform a read capacity which
>>> can take some time to complete. If an EEH occurs while waiting
>>> on the read capacity, the EEH handler is unable to obtain the
>>> context's mutex in order to put the context in an error state.
>>> The EEH handler will sit and wait until the context is free,
>>> but this wait can last longer than the EEH handler tolerates,
>>> leading to a failed recovery.
>> 
>> I'm not quite clear on what you mean by the EEH handler timing
>> out. AFAIK there's nothing in eehd and the EEH core that times out if a
>> driver doesn't respond - indeed, it's pretty easy to hang eehd with a
>> misbehaving driver.
>> 
>> Are you referring to your own internal timeouts?
>> cxlflash_wait_for_pci_err_recovery and anything else that uses
>> CXLFLASH_PCI_ERROR_RECOVERY_TIMEOUT?
>
> Reading through this again I can see how this is misleading. This is
> actually similar and related to the deadlock scenario described in
> "Fix to avoid potential deadlock on EEH". Without this fix, you'd end
> up in a similar situation but deadlocked on the context mutex instead
> of the ioctl semaphore.

That makes _much_ more sense. If you could please revise the commit
message to explain that, you can include this in the next version:
Reviewed-by: Daniel Axtens <dja@axtens.net>

Regards,
Daniel

