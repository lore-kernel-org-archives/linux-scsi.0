From: Mikael Pettersson <mikpe@csd.uu.se>
Subject: Re: 2.5.43 IO-APIC bug and spinlock deadlock
Date: Thu, 17 Oct 2002 10:29:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <15790.29928.793212.310557@kim.it.uu.se>
References: <20021017033302.GP8159@redhat.com>
	<20021017042851.GQ8159@redhat.com>
	<3DAE3F38.11C9E4F1@digeo.com>
	<20021017051308.GA10276@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20021017051308.GA10276@redhat.com>
To: Doug Ledford <dledford@redhat.com>
Cc: Andrew Morton <akpm@digeo.com>, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Doug Ledford writes:
 > On Wed, Oct 16, 2002 at 09:40:24PM -0700, Andrew Morton wrote:
 > > Doug Ledford wrote:
 > > > 
 > > > On Wed, Oct 16, 2002 at 11:33:02PM -0400, Doug Ledford wrote:
 > > > > IO-APIC bug: regular kernel, UP, no IO-APIC or APIC on UP enabled, compile
 > > > > fails (does *everyone* run SMP or at least UP + APIC now?)
 > > > 
 > > > OK, this is real.
 > > > 
 > > 
 > > Linus has merged a patch for this.  Does it work for you?  I don't
 > > think you've sent us any error output.
 > > 
 > > 
 > >  include/asm-i386/apic.h |    4 ++--
 > >  include/asm-i386/smp.h  |    2 +-
 > >  2 files changed, 3 insertions(+), 3 deletions(-)
 > 
 > No, tried that, didn't work.  Turn off SMP in your config and also turn 
 > off APIC support entirely, that's when it breaks the compile.

Ah, that rings a bell. Does 'grep MPPARSE' find a match in your .config
even though SMP and *APIC are disabled? That's a scripts/Configure bug:
it enables MPPARSE because CONFIG_X86_LOCAL_APIC was enabled at the start
of this Configure run, even though CONFIG_X86_LOCAL_APIC was disabled later.
Another 'make oldconfig' fixes it.
