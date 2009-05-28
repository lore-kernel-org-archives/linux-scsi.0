From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: aic94xx driver very slow / low writing speed on sata-discs
Date: Thu, 28 May 2009 01:58:16 -0700
Message-ID: <20090528015816.8c561ece.akpm@linux-foundation.org>
References: <4A082DA1.9090805@jc-embedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762880AbZE1I6j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 May 2009 04:58:39 -0400
In-Reply-To: <4A082DA1.9090805@jc-embedded.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Lange <lange@jc-embedded.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>

On Mon, 11 May 2009 15:52:33 +0200 Thomas Lange <lange@jc-embedded.com> wrote:

> Hi all,
> 
> this is my second post to LKML regarding the issue with aic94xx driver.
> In the meantime I have some additional information to share:
> We did some more testing and found out that partitions on the discs 
> attached to the controller sometimes are not recognized during boot.
> That leads to the problem that they cannot be mounted at all.
> I would be happy to get some hints on the issue
> as well as provide some of my spare time and our company's hardware to 
> do some testing.
> 
> Here is the description of my first observation of the problem:
> We have a couple of supermicro servers in our company that have adaptec
> aic94xx onboard, and there is the following issue that
> the aic94xx writing speed is very slow for sata disks connected.
> writing speed 5-6MB/s
> (tested with dd if=/dev/zero of=/dev/partition on aic9410w)
> reading speed: above 70MB/s
> (tested with dd if=/dev/partition of=/dev/zero on aic9410w)
> Another observation is that the LED showing disc activity
> continuously glows as soon as the driver has been loaded and that it
> does not stop to glow from then on. Also the hard disks connected to the
> aic9410w are not recognized every time after booting the system. In most
> cases a second boot resolves the issue.
> With other operating sytem there is no such problem i.e. hardware itself 
> is okay.
> 
> I send relevant output information of the aic94xx driver attached with this
> mail. Please CC answers to this post to me (langeATjc-embedded.com) as 
> I'm not
> in the kernel-list.

I don't know what to do about this, sorry.  That driver is basically
unmaintained.

Looking through the boot messages, this:

> sas: DONE DISCOVERY on port 1, pid:1712, result:0
> sas: sas_form_port: phy0 belongs to port0 already(1)!
> sas: sas_form_port: phy1 belongs to port1 already(1)!

is the only thing which stands out to me.  And according to google,
you're basically the only person who ever saw it come out.

ooh, that code has a maintainer.  Darrick, does the above look like
something which could make the driver run all slowly?

Thanks.
