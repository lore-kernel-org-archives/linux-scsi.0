From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: lsscsi is broken
Date: Sat, 10 May 2008 15:19:04 -0600
Message-ID: <20080510211904.GN19219@parisc-linux.org>
References: <86802c440805091638q59031edbifa439344acf0c971@mail.gmail.com> <4825EAA0.5030305@torque.net> <86802c440805101306w64b5c72dn4dbfea74a6557c2f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42253 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbYEJVTV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 May 2008 17:19:21 -0400
Content-Disposition: inline
In-Reply-To: <86802c440805101306w64b5c72dn4dbfea74a6557c2f@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: dougg@torque.net, James Bottomley <James.Bottomley@hansenpartnership.com>, Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>

On Sat, May 10, 2008 at 01:06:36PM -0700, Yinghai Lu wrote:
> On Sat, May 10, 2008 at 11:34 AM, Douglas Gilbert <dougg@torque.net> wrote:
> > Which version of lsscsi?
> > [For example what is the output of 'lsscsi --version'.]
> >
> > If it is not version 0.20 beta could you try it.
> > See: http://sg.torque.net/scsi/lsscsi.html
> 
> it is the one in Opensuse 10.3

OK, can you do:

strace -e trace=file lsscsi

on my system, it looks at:

open("/sys/bus/scsi/devices", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|0x80000) = 3
open("/sys/bus/scsi/devices/0:0:0:0/type", O_RDONLY) = 3
open("/sys/bus/scsi/devices/0:0:0:0/vendor", O_RDONLY) = 3
open("/sys/bus/scsi/devices/0:0:0:0/model", O_RDONLY) = 3
open("/sys/bus/scsi/devices/0:0:0:0/rev", O_RDONLY) = 3
open("/sys/bus/scsi/devices/0:0:0:0", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|0x80000) = 3
[0:0:0:0]    disk    Sony     MSC-U03          1.00  -       

Is it trying to access the same files on your system?  How do the
contents of those files differ between a working and a non-working
kernel?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
