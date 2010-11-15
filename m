From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Mon, 15 Nov 2010 12:19:30 -0800
Message-ID: <1289852370.22107.104.camel@haakon2.linux-iscsi.org>
References: <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net>
	 <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net>
	 <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net>
	 <20101112012315.GE17097@core.coreip.homeip.net> <4CDEC8D2.8080101@vlnb.net>
	 <20101113235938.GA1827@kroah.com> <4CE1017E.4090409@panasas.com>
	 <20101115161620.GB5981@kroah.com> <4CE16B8E.1000300@panasas.com>
	 <AANLkTikPVXGJ5-5YDk1uqfqrqxGLpSiSdaX3h7qxo-ie@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:42743 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932737Ab0KOUYn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2010 15:24:43 -0500
In-Reply-To: <AANLkTikPVXGJ5-5YDk1uqfqrqxGLpSiSdaX3h7qxo-ie@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Greg KH <greg@kroah.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>

<Trimming CC list>

On Mon, 2010-11-15 at 18:49 +0100, Bart Van Assche wrote:
> On Mon, Nov 15, 2010 at 6:19 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> > [ ... ]
> > Perhaps consider a new alternative like the device tree as Greg suggested
> > or maybe finally accept the harsh realities of ConfigFS.
> 
> I think that Vlad has already explained several times why ConfigFS is
> not suited for the needs of a storage target: a storage target must
> not only be able to accept configuration information from userspace
> but must also be able to create new directories and file nodes itself.
> See e.g. this message from October 6:
> http://kerneltrap.org/mailarchive/linux-kernel/2010/10/6/4628664.
> 

Sorry, but this post explains nothing but a single misguided and
uninformed opinion, with no hard facts on the actual usage of a native
configfs control plane within target mode infrastructure.  

The hard facts are:

Using configfs works to drive the generation/release, real time
configuration, dependancy relationships because:

*) configfs represents the individual target data structures who's
creation/deletion are driven from enterily userspace.

*) The parent/child relationships of dependant data structures is
handled transparently to the configfs consumer (eg: no hard requirement
internal reference counting)

*) The module reference counting of target core -> fabric module is
handled transparently to configfs consumers *and* TCM fabric modules

*) The current implementation of TCM/ConfigFS contains no global locks.
Each /sys/kernel/config/target/$FABRIC_1 operates independently of
/sys/kernel/config/target/$FABRIC_2

*) Expecting target fabric module developers to (by-hand) add struct
config_groups, struct kobjects or anything else directly to their fabric
module code is really clumsy and stupid.  This problem was solved
earlier this year in TCM v4.0 with the advent of:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/target_core_fabric_configfs.c;hb=refs/heads/lio-4.0

What this code means is that target fabric module developers no longer
has to duplicate complex control path code, and all of the interesting
port attributes (like ALUA secondary access state for example) are
transparent to new fabric modules, and 'just work'.  We can even
generate *functional* configfs skeletons for new fabric modules using
tcm_mod_builder.py discussed here:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=Documentation/target/tcm_mod_builder.txt;hb=refs/heads/lio-4.0

For the specific case of the target control path, until someone from
SCST can present some hard facts *and* running code about the target
mode configfs vs. sysfs debate, the discussion is like comparing oil and
water. 

Again, please do not take this as the LIO maintainer saying 'you should
stop working on SCST code XYZ', because that is *not* what I am saying.
We are simply stating that we already have a fully functional configfs
backend and generic target fabric independent infrastrucutre that has
not only been reviewed no less than five times this year on
linux-scsi/LKML, it has actually been developed *on* linux-scsi, patch
by patch in full view of the configfs maintainer and other interested
parties.

This is the reason why the v4.0 code has progressed as fast as it has; a
constant feedback loop from upstream developers who have been involved
since the start of the development process.  By virtue of this fact, we
where able to make some early design decisions based on feedback from
the community from the original proposed design and running prototype
code.

So, while I can very much apperciate Boaz's desire to attempt to
reconcile the relationship between myself + other TCM/LIO developers
with the SCST development community, but I don't think this will happen
without a definate change to the SCST development workflow and
interaction with 'outside of project' developers.

--nab

