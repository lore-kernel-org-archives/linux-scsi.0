From: Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/1] build modular usb isd200 with modular ide
Date: Tue, 26 Oct 2004 09:12:28 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <16765.34908.93713.977225@cargo.ozlabs.ibm.com>
References: <58cb370e041024054575c09679@mail.gmail.com>
	<200410252255.i9PMto6B024865@falcon10.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:471 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S261942AbUJZBW5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2004 21:22:57 -0400
In-Reply-To: <200410252255.i9PMto6B024865@falcon10.austin.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@austin.ibm.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <greg@kroah.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux IDE Mailing List <linux-ide@vger.kernel.org>, linuxppc64-dev@ozlabs.org

Doug Maxey writes:

> Ok, lets look at those vars.  Both are defined in hdreg.h as bytes.
> No fields in the data from the device are bytes, but are 16 bit.  On big
> endian, the relative positions for an LE u16 are swapped.  If the swap is
> not done on those, then one replaces the other when read.  Probably not
> what was intended.  It appears that another bug is being fixed here.

No.  The only sane way to do things is to transfer data from the
device to memory as a byte stream, in other words, preserving the
ordering of the individual bytes.  That is what we do on PPC and PPC64
platforms.  That ordering is preserved (and must be preserved)
irrespective of whether the transfer is actually done in 8, 16 or 32
bit chunks.

That means that 16-bit quantities might need to be byte-swapped to be
interpreted in host byte order, but single-byte fields should always
be in their correct sequence.

Paul.
