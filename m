From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bugme-new] [Bug 10374] New: sym53c8xx: weird behavior with
	udev
Date: Wed, 02 Apr 2008 10:49:19 -0500
Message-ID: <1207151359.3082.36.camel@localhost.localdomain>
References: <bug-10374-10286@http.bugzilla.kernel.org/>
	 <20080401011518.eb683cff.akpm@linux-foundation.org>
	 <1207059115.3100.9.camel@localhost.localdomain>
	 <20080401210521.abbb443c.seraph@xs4all.nl>
	 <1207081169.3100.20.camel@localhost.localdomain>
	 <20080401225717.7d936f91.seraph@xs4all.nl>
	 <1207084454.3100.31.camel@localhost.localdomain>
	 <20080402122944.7fe8e924.seraph@xs4all.nl>
	 <20080402120651.GS16451@parisc-linux.org>
	 <20080402160920.dc219007.seraph@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48510 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753439AbYDBPtZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2008 11:49:25 -0400
In-Reply-To: <20080402160920.dc219007.seraph@xs4all.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jos van der Ende <seraph@xs4all.nl>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, bugme-daemon@bugzilla.kernel.org

On Wed, 2008-04-02 at 16:09 +0200, Jos van der Ende wrote:
> Finally, bisecting is done. :-)

Thanks for doing this ... we'd never have found it by looking at the
driver code ...

> Well, it took more reboots than a typical Windows XP installation (and
> thank the heavens for my Sparc64 cross compiler on my Core 2 Duo), but
> this seems to be the culprit:
> 
> 5a606b72a4309a656cd1a19ad137dc5557c4b8ea is first bad commit

Reading the code for this, it seems that something fiddled with the
IRQ_DISABLED or IRQ_PENDING flags when it came time for the ->eoi() so
the gem interrupt is always held pending (because it's never ended).

Since the sym2 is on interrupts 16 and 17 and gem on 11 (and the
descriptors are separate entities in the irq_desc array) I can't really
see how sym2 would be doing this.

James


