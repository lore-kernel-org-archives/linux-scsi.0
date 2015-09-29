From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 25/32] cxlflash: Fix to prevent EEH recovery failure
Date: Tue, 29 Sep 2015 15:11:15 -0500
Message-ID: <F4D4C09B-DEF2-485E-9453-671DF867AE37@linux.vnet.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443223134-9886-1-git-send-email-mrochs@linux.vnet.ibm.com> <87612uuich.fsf@gamma.ozlabs.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:49450 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbbI2ULW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2015 16:11:22 -0400
Received: from localhost
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 29 Sep 2015 14:11:21 -0600
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id AA66738C804F
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 16:11:19 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8TKBJGU54984842
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 20:11:19 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8TKBHZb021704
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 16:11:19 -0400
In-Reply-To: <87612uuich.fsf@gamma.ozlabs.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Axtens <dja@axtens.net>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>, Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> On Sep 28, 2015, at 8:25 PM, Daniel Axtens <dja@axtens.net> wrote:
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com> writes:
> 
> 
>> The process_sense() routine can perform a read capacity which
>> can take some time to complete. If an EEH occurs while waiting
>> on the read capacity, the EEH handler is unable to obtain the
>> context's mutex in order to put the context in an error state.
>> The EEH handler will sit and wait until the context is free,
>> but this wait can last longer than the EEH handler tolerates,
>> leading to a failed recovery.
> 
> I'm not quite clear on what you mean by the EEH handler timing
> out. AFAIK there's nothing in eehd and the EEH core that times out if a
> driver doesn't respond - indeed, it's pretty easy to hang eehd with a
> misbehaving driver.
> 
> Are you referring to your own internal timeouts?
> cxlflash_wait_for_pci_err_recovery and anything else that uses
> CXLFLASH_PCI_ERROR_RECOVERY_TIMEOUT?

Reading through this again I can see how this is misleading. This is
actually similar and related to the deadlock scenario described in
"Fix to avoid potential deadlock on EEH". Without this fix, you'd end
up in a similar situation but deadlocked on the context mutex instead
of the ioctl semaphore.

