From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [RFC] Normalizing byteorder/unaligned access API
Date: Tue, 07 Oct 2008 16:39:48 -0700
Message-ID: <1223422788.8195.45.camel@brick>
References: <1223416391.8195.22.camel@brick>
	 <1223417543.7484.7.camel@localhost.localdomain>
	 <1223419166.8195.37.camel@brick>  <20081007233315.GM25780@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:27407 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758029AbYJGXjv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2008 19:39:51 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3698210wfd.4
        for <linux-scsi@vger.kernel.org>; Tue, 07 Oct 2008 16:39:50 -0700 (PDT)
In-Reply-To: <20081007233315.GM25780@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>

On Tue, 2008-10-07 at 17:33 -0600, Matthew Wilcox wrote:
> On Tue, Oct 07, 2008 at 03:39:25PM -0700, Harvey Harrison wrote:
> > As an example, in the write command handling in achba.c, a patch similar to the following
> > (assumes the existence of a __be24 type somewhere):
> 
> What type could be defined to be '__be24'?  Would
> 
> typedef struct {
> 	unsigned char data[3];
> } __be24;

__packed

> 
> do the trick?  It's not an integral type, but I'm not sure if that matters.
> 
> > +				cmnd_lba = unaligned_be24_to_cpup(&tmp->lba) & 0x001FFFFF;
> 
> That might be easier to read if you're using a 500-column terminal.  For
> the rest of us,
> 				cmnd_lba = scsi_get_u24(cmnd + 2) & 0x1FFFFF;
> is much easier to read.

Suggestions welcome on shorter common names for the unaligned helpers.

Cheers,

Harvey



