From: Matthew Wilcox <willy@debian.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Fri, 21 Nov 2003 17:32:36 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031121173236.GX30485@parcelfarce.linux.theplanet.co.uk>
References: <200310231734.10263.krmurthy@cisco.com> <20031027153932.A16679@infradead.org> <yqujvfpdwu4f.fsf@chaapala-lnx2.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:51348 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264383AbTKURch
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2003 12:32:37 -0500
Content-Disposition: inline
In-Reply-To: <yqujvfpdwu4f.fsf@chaapala-lnx2.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Clay Haapala <chaapala@cisco.com>
Cc: Christoph Hellwig <hch@infradead.org>, Krishna Murthy <krmurthy@cisco.com>, linux-scsi@vger.kernel.org, davmyers@cisco.com

On Fri, Nov 21, 2003 at 10:42:40AM -0600, Clay Haapala wrote:
> On Mon, 27 Oct 2003, Christoph Hellwig said:
> > 
> > highlevel:
> > 	- kill md5.c and iscsi-crc.c and use common cryptoapi
> > 	md5 / common crc code instead.
> 
> md5: That appears straight-forward, and has been implemented, subject
>      to testing.  SELECT CRYPTO and SELECT MD5 makes it available
>      in the kernel.
> 
> crc32: Ah, the iSCSI crc32 uses a different polynomial (stronger) than
>      Ethernet and the rest.  We argued during the RFC process for just
>      using Ethernet's as good enough, but were voted down.  So we are
>      stuck with a separate implementation in this case.

OK, but please convert it to live in the crypto/ directory and use
the crypto interfaces.  That way if some unrelated project decides to
implement the same algorithm, we don't end up with two copies of it.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
