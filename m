From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/3] scsi: Move user-shareable stuff in scsi/scsi.h to
 uapi/scsi/scsi.h
Date: Fri, 09 Jan 2015 07:27:46 -0800
Message-ID: <1420817266.2064.1.camel@HansenPartnership.com>
References: <1420746479-25949-1-git-send-email-agrover@redhat.com>
	 <1420746479-25949-3-git-send-email-agrover@redhat.com>
	 <20150109101422.GA23804@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45780 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758093AbbAIP1s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2015 10:27:48 -0500
In-Reply-To: <20150109101422.GA23804@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Andy Grover <agrover@redhat.com>, linux-scsi@vger.kernel.org

On Fri, 2015-01-09 at 11:14 +0100, Christoph Hellwig wrote:
> On Thu, Jan 08, 2015 at 11:47:58AM -0800, Andy Grover wrote:
> > A great many SCSI codes and ioctl values can be made available to userspace
> > in a uapi header, while the kernel-only definitions stay in scsi/scsi.h.
> > 
> > scsi/scsi.h also includes uapi/scsi/scsi.h so kernel code need not update
> > includes.
> 
> SCSI opcodes are not a user API/ABI, so they should not be exported.

Actually, they are exported.  If you look at what glibc supplies, it has
it's own copies of scsi.h and scsi_ioctl.h.  If we try to repace those
with uapi, we have to make sure nothing breaks, so the opcodes have to
be in scsi.h somehow.

Now, I agree that the opcodes in our scsi.h shouldn't be the definitive
ones because they're the only the ones the kernel cares about.  However,
the fact is that any userspace programme including scsi.h and
scsi_ioctl.h is expecting to get the opcodes and we can't break that.

Were you thinking of moving opcodes to scsi_opcodes.h and #including
that in scsi.h but not exporting it so glibc supplies its own?

James

> I'm fine with having them in their own header that can be copied
> into other projects, but guaranteeing any sort of stability for these
> defines is a mistake.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


