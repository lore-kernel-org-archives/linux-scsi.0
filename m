From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] Don't export scsi kernel variables in userspace	headers.
Date: Mon, 27 Jul 2009 11:37:20 +0300
Message-ID: <4A6D6740.5040005@panasas.com>
References: <20090725021026.GA6942@redhat.com> <20090727074418.GA14765@infradead.org> <20090727082623.GA18747@merkur.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:17382
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750767AbZG0IhW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jul 2009 04:37:22 -0400
In-Reply-To: <20090727082623.GA18747@merkur.ravnborg.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On 07/27/2009 11:26 AM, Sam Ravnborg wrote:
> On Mon, Jul 27, 2009 at 03:44:18AM -0400, Christoph Hellwig wrote:
>> On Fri, Jul 24, 2009 at 10:10:26PM -0400, Dave Jones wrote:
>>> Found with make headers_check
>>>
>>> /usr/include/scsi/scsi.h:159: userspace cannot call function or variable defined in the kernel
>>> /usr/include/scsi/scsi.h:285: userspace cannot call function or variable defined in the kernel
>> The headers shouldn't be exported at all because scsi/ headers are
>> exported from glibc.
> Where does glibc get these headers from?
> 
> If glibc have their own private copy then the headers should indeed be exported
> so we avoid such mess.
> 
> 	Sam

We never had a Kbuild file in include/scsi. It was only added recently by the fcoe patchset.
scsi.h is not the only problem. All of /usr/include/scsi/* come from glibc private snapshot.

I agree with Sam that this is a complete mess, and that Kernel should take control back.
But someone should do it in an orderly manner. Clean up all the headers to be safe for
user mode and send notifications/patches to glibc, and the distributions must know that
they might be geting same files from two packages for a while.

Would we want a Kconfig option for a while, like SCSI_EXPORT_HEADERS so it can be turned
off?

Boaz
