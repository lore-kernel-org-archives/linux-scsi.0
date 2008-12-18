From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: READ CAPACITY 16
Date: Thu, 18 Dec 2008 07:49:47 -0700
Message-ID: <20081218144946.GK19967@parisc-linux.org>
References: <20081217164210.GC19967@parisc-linux.org> <da824cf30812170950p393be2fq729e98e93edef5dc@mail.gmail.com> <20081217180640.GE19967@parisc-linux.org> <494A1272.8040008@panasas.com> <20081218140851.GI19967@parisc-linux.org> <494A6064.70601@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:50073 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbYLROuD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Dec 2008 09:50:03 -0500
Content-Disposition: inline
In-Reply-To: <494A6064.70601@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Grant Grundler <grundler@google.com>, linux-scsi@vger.kernel.org

On Thu, Dec 18, 2008 at 04:38:28PM +0200, Boaz Harrosh wrote:
> OK Then I say D, go to T10, while white list the (0) devices that currently
> report !SCSI_3 but do support UNMAP. These are only USB right?

I'm not sure I've explained myself correctly.

 - There are new features from T10 (UNMAP being one of them) that are
   reported only through the RC16 command.
 - We don't currently use RC16 unless:
   - The device claims to have more than 4 billion sectors (~= 2TB with
     512-byte sectors) OR
   - The device claims to support protection information

We need a way to be able to use RC16, or we need to persuade T10 that
using RC16 is basically impossible in the real world, so they should
stop putting features in it.

James and I seem to have come to a conclusion -- that we'll try RC16
for drives which claim SCSI_3 compliance (which excludes all the current
USB devices).  It's then up to the USB people to implement a whitelist
for not mangling USB devices down to SCSI_2.

> Your tested devices report SCSI_3? Do all devices that are scsi_level > SCSI_2
> suppose to support RC16?

My tested devices are all libata which claims SCSI_SPC_2 compliance.
Obviously, this is faked.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
