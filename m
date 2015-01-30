From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCHv2 3/5] scsi: Move user-shareable stuff in scsi/scsi.h to
 uapi/linux/scsi.h
Date: Thu, 29 Jan 2015 17:24:13 -0800
Message-ID: <1422581053.2091.34.camel@HansenPartnership.com>
References: <1422579397-18696-1-git-send-email-agrover@redhat.com>
	 <1422579397-18696-4-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38352 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517AbbA3BYR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2015 20:24:17 -0500
In-Reply-To: <1422579397-18696-4-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: linux-scsi@vger.kernel.org, hch@lst.de

On Thu, 2015-01-29 at 16:56 -0800, Andy Grover wrote:
> A great many SCSI codes can be made available to userspace in a uapi
> header, while the kernel-only definitions stay in scsi/scsi.h.
> 
> This will permit userspace apps to stop using the antiquated definitions
> available in glibc's scsi/scsi.h, which are very old and incomplete.
> 
> scsi/scsi.h also includes uapi/scsi/scsi.h so kernel code need not update
> includes.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  include/scsi/scsi.h       | 497 +--------------------------------------------
>  include/uapi/linux/Kbuild |   1 +
>  include/uapi/linux/scsi.h | 506 ++++++++++++++++++++++++++++++++++++++++++++++

I think this is too much: lots of things in scsi.h have no meaning to
the user: our internal definition of scsi_lun for instance, internal
return codes, mid level queue instructions, our internal markers for
SCSI levels ...

What you put in this file becomes a contract for userspace.  The rule
should be don't put anything in unless we want the user to use it (and
we're willing to stick by it).

I really think that nothing that isn't already
in /usr/include/scsi/scsi.h is a great rule to follow and then, if
necessary, justify why any additional stuff.

James


