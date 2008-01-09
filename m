From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: AHCI finds disks; no /dev/sd inodes bound?
Date: Thu, 10 Jan 2008 00:03:59 +0100
Message-ID: <478552DF.1050203@s5r6.in-berlin.de>
References: <c7bcbd620801082340j46839c22n3081c2f5ad6af0ff@mail.gmail.com> <p738x2zosmd.fsf@bingen.suse.de> <c7bcbd620801090921w1a784417wc8aa42ecb83d589b@mail.gmail.com> <1199899766.3493.20.camel@localhost.localdomain> <20080109174945.GB15346@one.firstfloor.org> <4785138A.4000809@s5r6.in-berlin.de> <4785304A.60109@gmail.com> <20080109205850.GU16309@parisc-linux.org> <47853FA7.9050506@s5r6.in-berlin.de> <20080109222308.GE15612@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:55387 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbYAIXEL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 18:04:11 -0500
In-Reply-To: <20080109222308.GE15612@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Jon Watte <jwatte@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Andi Kleen wrote:
> On Wed, Jan 09, 2008 at 10:41:59PM +0100, Stefan Richter wrote:
>> However, this further obfuscates the fact that libata uses Linux' SCSI
>> midlayer and highlevel.  Which is a bad thing.  For example, there are
> 
> People are not interested in how libata is implemented internally.
> They just want their SATA interfaces to work.
> 
> Kconfig is also not an educational facility or high level
> design description of the code, but a pragmatic tool to get the job
> done.

I did not talk about education or design decription.  I did talk about
appropriately showing what the Kconfig options do.

Kconfig is the tool to configure the Linux build environment before
building the program.

In particular, we are talking about how to present the configuration of
the Linux ATA component, which happens
  - to have a build-time dependence on the Linux SCSI midlayer and
  - to be not very useful at runtime if certain Linux SCSI highlevel
    components aren't present as well.

The Kconfig menu layouts, prompts, and help texts are there to inform/
"educate"/ guide the user when configuring the build environment, with
the goal that he safely and efficiently gets to a working software
configuration.

If some "internals" of the implementation are not entirely invisible to
users at run-time, then we should provide information about them.  Or
change the implementation so that these internals become truly invisible
at runtime use, if that is preferable, all things considered.

Furthermore, people who use Kconfig are _not_ people who "just want
their SATA interfaces to work".  These are specifically people who need
to or want to create an own configuration before build time, for what
ever reason. /These/ are the people to which the Kconfig menus and texts
must be tailored for.

People who just want their SATA interfaces to work _and_ cannot or don't
want to spend time with configuring the kernel build environment can be
served to.  We give them ready-made .config files or kernels.


Or in short:

Setting BLK_DEV_SD=y does not mean "make my disk work".  It means
"enable building one of the program parts which are necessary to make my
disk work".  And however hard you try, you can't transform it to truly
take on the former meaning.  Therefore better stay true to the actual
meaning.
-- 
Stefan Richter
-=====-==--- ---= -=--=
http://arcgraph.de/sr/
