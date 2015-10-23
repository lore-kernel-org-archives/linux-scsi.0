From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v6 25/37] cxlflash: Fix to prevent EEH recovery failure
Date: Fri, 23 Oct 2015 15:54:10 +0200
Message-ID: <562A3C02.7040703@redhat.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1445458496-57625-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbbJWNyO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Oct 2015 09:54:14 -0400
In-Reply-To: <1445458496-57625-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

On 21.10.2015 22:14, Matthew R. Ochs wrote:
> The process_sense() routine can perform a read capacity which
> can take some time to complete. If an EEH occurs while waiting
> on the read capacity, the EEH handler will wait to obtain the
> context's mutex in order to put the context in an error state.
> The EEH handler will sit and wait until the context is free,
> but this wait can potentially last forever (deadlock) if the
> scsi_execute() that performs the read capacity experiences a
> timeout and calls into the reset callback. When that occurs,
> the reset callback sees that the device is already being reset
> and waits for the reset to complete. This leaves two threads
> waiting on the other.
>
> To address this issue, make the context unavailable to new,
> non-system owned threads and release the context while calling
> into process_sense(). After returning from process_sense() the
> context mutex is reacquired and the context is made available
> again. The context can be safely moved to the error state if
> needed during the unavailable window as no other threads will
> hold its reference.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
> Reviewed-by: Daniel Axtens <dja@axtens.net>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

