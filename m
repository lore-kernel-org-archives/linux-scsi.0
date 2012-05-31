From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Remove scsi_wait_scan module
Date: Thu, 31 May 2012 18:44:59 +0100
Message-ID: <1338486299.3156.10.camel@dabdike.sthat4.btopenzone.com>
References: <1338110026.2957.5.camel@dabdike.int.hansenpartnership.com>
	 <20120528100015.GB10036@vostochny.stro.at>
	 <1338206866.6330.22.camel@dabdike>
	 <CAA9_cmfh9ZtepX+hjLVRM95u_pAe90kZTkBeVmFPWm8AMaqJ5g@mail.gmail.com>
	 <1338420752.3069.20.camel@dabdike>
	 <CAA9_cmfZFm5+9ARB7tNVwNzwxJh3bPD=h7gMWhByjy00-qZvgg@mail.gmail.com>
	 <4FC7288C.302@gmail.com>
	 <CAA9_cmeU3Lmk6OE=qk0QF99U3Uzku1zf+bL9AsUr3G3Um1jk1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38112 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757174Ab2EaRpD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 May 2012 13:45:03 -0400
In-Reply-To: <CAA9_cmeU3Lmk6OE=qk0QF99U3Uzku1zf+bL9AsUr3G3Um1jk1w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Harald Hoyer <harald.hoyer@gmail.com>, maximilian attems <max@stro.at>, linux-scsi <linux-scsi@vger.kernel.org>, Dave Jones <davej@redhat.com>, Jeff Mahoney <jeffm@suse.de>, Ben Hutchings <ben@decadent.org.uk>, initramfs@vger.kernel.org

On Thu, 2012-05-31 at 09:45 -0700, Dan Williams wrote:
> On Thu, May 31, 2012 at 1:15 AM, Harald Hoyer <harald.hoyer@gmail.com> wrote:
> > For Fedora17 scsi_wait_scan is not used anymore in the normal initramfs. I
> > removed it and raid is only tried to be started in degraded mode after a timeout
> > (several udevadm settle waits plus some extra 10 seconds).
> 
> I'm probably missing something, but that sounds like "sprinkle
> timeouts until it magically works"?  If udevadm settle is being used
> as a discovery barrier shouldn't it be closing the loop with
> wait_for_device_probe() in the kernel?

No, that was pretty much the whole point of booting async.  It only
really matters in huge numbers of devices systems (like san connected
beasts).  What you *really* want is the boot to proceed immediately
after root appears and let the rest of the device probing continue in
parallel.

James


