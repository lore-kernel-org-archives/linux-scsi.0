From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Add a 'wait-scan' command to /proc/scsi/scsi.
Date: Wed, 25 Mar 2009 13:26:53 -0600
Message-ID: <20090325192653.GS14127@parisc-linux.org>
References: <1238007647-25752-1-git-send-email-notting@redhat.com> <20090325190137.GA8509@infradead.org> <20090325190321.GB25176@nostromo.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:45497 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbZCYT1L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Mar 2009 15:27:11 -0400
Content-Disposition: inline
In-Reply-To: <20090325190321.GB25176@nostromo.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Mar 25, 2009 at 03:03:21PM -0400, Bill Nottingham wrote:
> Then where is a better place to put this, as scsi_wait_scan.ko is
> a ridiculous interface for userspace?

It would be nice if people would comment on "ridiculous interface"s when
they're asked for feedback, instead of waiting more than two years.

I think you're misunderstanding how to use scsi_wait_scan.  The idea was
that the bit of userspace that probes all the device drivers would do:

modprobe fusion.ko
modprobe aic79xx.ko
modprobe sym53c8xx.ko
modprobe scsi_wait_scan
rmmod scsi_wait_scan

et voila, you're done.  It seems like you want random other bits of
userspace to wait for scsi scanning to be done, and that wasn't the
original intent.


I suppose we could add Yet Another Damn Sysfs File, say
/sys/bus/scsi/wait_scan

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
