From: Jos van der Ende <seraph@xs4all.nl>
Subject: Re: [Bugme-new] [Bug 10374] New: sym53c8xx: weird behavior with
 udev
Date: Wed, 2 Apr 2008 18:06:51 +0200
Message-ID: <20080402180651.6b3e0247.seraph@xs4all.nl>
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
	<1207151359.3082.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <1207151359.3082.36.camel@localhost.localdomain>
Sender: sparclinux-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 02 Apr 2008 10:49:19 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> Reading the code for this, it seems that something fiddled with the
> IRQ_DISABLED or IRQ_PENDING flags when it came time for the ->eoi() so
> the gem interrupt is always held pending (because it's never ended).

So Andrew's first hunch that interrupts were somehow involved is right.

> Since the sym2 is on interrupts 16 and 17 and gem on 11 (and the
> descriptors are separate entities in the irq_desc array) I can't really
> see how sym2 would be doing this.

Yeah, that has me baffled too. Still, the fact is that I can only trigger the bug by loading sym53c8xx before sungem. I have yet to find any other conditions that trigger it. Loading sungem before sym53c8xx on an affected kernel gives no trouble at all.


-- 
Jos van der Ende <seraph@xs4all.nl>
