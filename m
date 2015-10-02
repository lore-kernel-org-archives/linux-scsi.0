From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v5 08/34] cxlflash: Fix to avoid CXL services during EEH
Date: Fri, 2 Oct 2015 15:14:44 +0200
Message-ID: <560E8344.9040608@redhat.com>
References: <1443714773-9176-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1443714926-15545-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbbJBNOs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Oct 2015 09:14:48 -0400
In-Reply-To: <1443714926-15545-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 1.10.2015 17:55, Matthew R. Ochs wrote:
> During an EEH freeze event, certain CXL services should not be
> called until after the hardware reset has taken place. Doing so
> can result in unnecessary failures and possibly cause other ill
> effects by triggering hardware accesses. This translates to a
> requirement to quiesce all threads that may potentially use CXL
> runtime service during this window. In particular, multiple ioctls
> make use of the CXL services when acting on contexts on behalf of
> the user. Thus, it is essential to 'drain' running ioctls _before_
> proceeding with handling the EEH freeze event.
>
> Create the ability to drain ioctls by wrapping the ioctl handler
> call in a read semaphore and then implementing a small routine that
> obtains the write semaphore, effectively creating a wait point for
> all currently executing ioctls.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
> Reviewed-by: Daniel Axtens <dja@axtens.net>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

