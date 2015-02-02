From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2 3/5] scsi: Move user-shareable stuff in scsi/scsi.h
	to uapi/linux/scsi.h
Date: Mon, 2 Feb 2015 09:00:49 +0100
Message-ID: <20150202080049.GA9747@lst.de>
References: <1422579397-18696-1-git-send-email-agrover@redhat.com> <1422579397-18696-4-git-send-email-agrover@redhat.com> <1422581053.2091.34.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43173 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932707AbbBBIAw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Feb 2015 03:00:52 -0500
Content-Disposition: inline
In-Reply-To: <1422581053.2091.34.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andy Grover <agrover@redhat.com>, linux-scsi@vger.kernel.org, hch@lst.de

On Thu, Jan 29, 2015 at 05:24:13PM -0800, James Bottomley wrote:
> I think this is too much: lots of things in scsi.h have no meaning to
> the user: our internal definition of scsi_lun for instance, internal
> return codes, mid level queue instructions, our internal markers for
> SCSI levels ...
> 
> What you put in this file becomes a contract for userspace.  The rule
> should be don't put anything in unless we want the user to use it (and
> we're willing to stick by it).
> 
> I really think that nothing that isn't already
> in /usr/include/scsi/scsi.h is a great rule to follow and then, if
> necessary, justify why any additional stuff.

I think basically nothing in scsi.h needs to be exposed to userspace,
only the ioctl defintions moved to scsi_ioctl.h earlier should.  While
userspace can use SCSI opcodes and status codes they are not a kernel
ABI, but a protocol defintion.  It isn't really the kernels job
to export those, epecially as protocols evolve with new versions.
