From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: kconfig: When possible, compile drivers with
 COMPILE_TEST
Date: Wed, 14 Oct 2015 16:39:05 -0700
Message-ID: <1444865945.2220.90.camel@HansenPartnership.com>
References: <1444857220-26595-1-git-send-email-luisbg@osg.samsung.com>
	 <1444862561.2220.81.camel@HansenPartnership.com>
	 <561EE5B1.40402@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <561EE5B1.40402@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-10-15 at 00:30 +0100, Luis de Bethencourt wrote:
> On 14/10/15 23:42, James Bottomley wrote:
> > On Wed, 2015-10-14 at 22:13 +0100, Luis de Bethencourt wrote:
> >> These drivers only have runtime but no build time dependencies, so they can
> >> be built for testing purposes if the Kconfig COMPILE_TEST option is enabled.
> >>
> >> This is useful to have more build coverage and make sure that drivers are
> >> not affected by changes that could cause build regressions.
> > 
> > I don't think I understand the purpose.  If the object is to build a
> > load of old ISA drivers, why not just turn on CONFIG_ISA in the test
> > build? That's how I build test SCSI on my systems.
> > 
> > James
> > 
> > 
> 
> Hi James,
> 
> The idea is that the more drivers are built with make allyesconfig, the better.
> 
> I added COMPILE_TEST to all the drivers that can be built without having ISA,
> since they depend on runtime and not in build time. I understand your point,
> which raises the question of why isn't CONFIG_ISA set to Y in make allyesconfig.
> 
> Would this be possible?

It happens today, but it depends on architecture.  An allyesconfig on
ia32 should have it set and possibly a few others.  There's no reason an
x86-64 couldn't have it set, it's just that x86-64 was the architecture
break where ISA was discontinued, so there's no real point building that
configuration.

James
