From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] SCSI: userspace cannot use scsi_device_type
Date: Wed, 11 Nov 2009 14:08:54 -0600
Message-ID: <1257970134.11985.20.camel@mulgrave.site>
References: <4AFAFF94.4050500@code.wastedcycles.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49601 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757250AbZKKUIx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Nov 2009 15:08:53 -0500
In-Reply-To: <4AFAFF94.4050500@code.wastedcycles.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lkml.sepix@code.wastedcycles.net
Cc: linux-scsi@vger.kernel.org

On Wed, 2009-11-11 at 18:16 +0000, Jeff Smith wrote:
> The following patch fixes the 'make headers_check' warning:
>     include/scsi/scsi.h:288: userspace cannot call function or variable defined in the kernel
> It is similar to a patch from Jaswinder Singh Rajput back in July, which did not initially compile.
> 
> I have compiled this patch, and as expected it generates the same kernel code with and without,
> modulo the confusion caused by printk pollution that uses __DATE__ and __TIME__ and compressions
> thereof. This indicates that the patch is harmless to apply from the kernel's POV. A search on google
> and google/codesearch indicated that there is no obvious userland use of the scsi_device_type
> identifier in a way that depends on the scsi.h code.
> 
> A similar patch for the scsi_command_size code should be feasible, but a code search reveals some 
> explicit use of the include file for the command_size definitions, in OpenAFS in particular,
> so I figure that should be submitted as a separate patch (or more likely, RFC) after I have 
> worked through the usages I can see (none of which, in theory, should be valid anyway) and 
> after any comment on this patch.

Actually, there are several other problems like this that need
fixing ... and for which we have patches submitted.  The debating point
is whether we actually want to clean scsi.h and the allied headers up
enough so we can ask Ulrich actually to use them for glibc ... and where
the resulting headers should be placed.  So far we have no consensus on
this.

Personally, I think a line by line comparison of the scsi.h in Ulrich's
glibc tree and ours making it identical and shoving all the non kernel
stuff into other headers might be the way to go .. but others have
disagreed in the past.

James


