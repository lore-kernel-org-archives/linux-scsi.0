From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bugme-new] [Bug 11045] New: Bug in MPT Fusion 2.6.26-rc7
	unbootable
Date: Tue, 08 Jul 2008 09:08:46 -0500
Message-ID: <1215526126.3214.8.camel@localhost.localdomain>
References: <bug-11045-10286@http.bugzilla.kernel.org/>
	 <20080706123417.c1e2bebc.akpm@linux-foundation.org>
	 <C5679C710E19AF4C8D9C02FF5C72E3C133C9C76A@cosmail01.lsi.com>
	 <20080708015756.baec287c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20080708015756.baec287c.akpm@linux-foundation.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Support, Software" <support@lsi.com>, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, "Moore, Eric Dean" <Eric.Moore@lsi.com>, kurk@shiftmail.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2008-07-08 at 01:57 -0700, Andrew Morton wrote:
> You removed everyone from cc.  Please don't do that - there's not much
> point in asking me to do things - this bug is reported by
> kurk@shiftmail.org.
> 
> I don't know what "we do not assist with compiling drivers" can possibly
> mean.  Eric, can you please help here?

heh, well, cc'ing a support line on a technical bug report isn't
necessarily conducive to producing useful results ... what we're
discussing is probably already at level 4 or 5 (the real engineering
problems).  Support calls go in at levels 1-3 (as in consult manual and
spit out canned response before triaging for escalation).

That said, this line:

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000009!

is absolutely characteristic of a lost interrupt.

With the current LSI driver, we have two possible causes for this.  One
is the usual ACPI screw up that we never seem to be able to fix.  The
other is that the driver recently enabled MSI (commit
23a274c8a5adafc74a66f16988776fc7dd6f6e51 in v2.6.26-rc1).  For the
former, just follow the usual ACPI screw up recipe.  For the latter, you
should see this message in the boot up:

mptbase: ioc0: PCI-MSI enabled

MSI can be turned off again by using the module parameter
mpt_msi_enable=0.

Unfortunately, the true fix is to find out if the motherboard really has
a global MSI problem (and I know MSI works with the LSI because I have a
1030 in an ia64 system here working just fine) and add it to the PCI
quirks file as unable to use MSI.

James


