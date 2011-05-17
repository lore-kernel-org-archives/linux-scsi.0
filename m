From: "Nicholas A. Bellinger" <nab@risingtidesystems.com>
Subject: Re: rtsadmin-v1.99 BETA packages
Date: Tue, 17 May 2011 00:30:58 -0700
Message-ID: <1305617458.2856.139.camel@haakon2.linux-iscsi.org>
References: <1304121705.14278.196.camel@haakon2.linux-iscsi.org>
	 <1304553788.10072.241.camel@haakon2.linux-iscsi.org>
	 <4DCAC075.5090007@redhat.com>
	 <1305160226.19744.47.camel@haakon2.linux-iscsi.org>
	 <1305337311.7102.88.camel@haakon2.linux-iscsi.org>
	 <4DCF1215.2010406@redhat.com>
Reply-To: nab@risingtidesystems.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49828 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab1EQHjL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2011 03:39:11 -0400
In-Reply-To: <4DCF1215.2010406@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "Patil, Kiran" <kiran.patil@intel.com>, "Love, Robert W" <robert.w.love@intel.com>, Madhu Iyengar <madhu.iyengar@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Jerome Martin <jxm@risingtidesystems.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "J.H." <warthog9@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <matthew@wil.cx>, Stefan Hajnoczi <stefanha@gmail.com>, linux-iscsi-target-dev <linux-iscsi-target-dev@googlegroups.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Paolo Bonzini <pbonzini@redhat.com>, Marc Fleischmann <mwf@risingtidesystems.com>

On Sat, 2011-05-14 at 16:36 -0700, Andy Grover wrote:
> On 05/13/2011 06:41 PM, Nicholas A. Bellinger wrote:
> > This afternoon's updated RHEL6 and Debian Squeeze BETA builds are
> > available here:
> > 
> > http://www.risingtidesystems.com/rtsadmin-v1.99-BETA/rtsadmin-frozen-11.99-20110513091048.3434628.x86_64.rpm
> > http://www.risingtidesystems.com/rtsadmin-v1.99-BETA/rtsadmin-frozen_11.99-20110513161709.3434628_amd64.deb
> > 
> > These contain an important bugfix for v2 device creation where 
> > /sys/kernel/config/target/core/$HBA/$DEV/wwn/vpd_unit_serial
> > was not being automatically generated for newly created virtual devices.
> > There is also a seperate multi-fabric export HBA context 'delete
> > $DEVICE_NAME' that has been fixed as well and pushed into the community
> > repo.
> > 
> > Also, the lio-utils v4.0 packages for RHEL6 and Debian Squeeze have been
> > updated with a few minor improvements to tcm_fabric.py code.
> > 
> > http://www.risingtidesystems.com/rtsadmin-v1.99-BETA/lio-utils-4.0-d2cf595d.x86_64.rpm
> > http://www.risingtidesystems.com/rtsadmin-v1.99-BETA/lio-utils_4.0_amd64.deb
> > 
> > Please let us know if you have any questions.
> 
> Hi nab and Jerome,

Hello Andy,

> 
> Could you explain the versioning of the rtsadmin-frozen packages? I
> think the 2011.. is a datetime stamp, but I don't grok the 11.99 and
> 3434628.
> 

To clarify the 3434628 suffix. The ability to build frozen packages has
not been included into the community edition branch, so these actually
reference commit IDs outside of what's in the public git repos.

Of course these trees are currently in sync with community edition
bugfixes.  Also, wrt to the 11.99 tag, I believe Jerome bumped this to
avoid old versioning issue with rpm -iUf..

> Would it be possible to release src rpms/debs, or even a tar.gz, for
> these as well?
> 

With the necessary python devel packages and dependencies installed, our
public rtslib.git, configshell.git and rtsadmin.git community edition
trees can 'make rpm' and 'make deb' with current code.  We are happy to
add these BETA packages for download as well, but as you can imagine
providing frozen builds is currently a bit easier for us wrt to python
dependencies to allow a larger audience access to current BETA builds.

> Have you looked into putting these into yum or apt repos, for easy
> upgrading?
> 

We are currently considering public community edition packages repos,
but in the end we would really like distro folks to provide our package
in their upstream package repos following our community edition trees
with necessary python2.6 dependencies in place.

> Finally, I notice modified versions of the rpm specfiles I authored are
> now in your rtsadmin[1], rtslib, and configshell repos. There is no
> indication of origin or attribution to me or my employer. I think this
> is technically ok since the files are licensed under the Fedora CLA[2],
> but it is an accepted FOSS practice to say where you got something, at
> least in the checkin notes.
> 
> I'm not sweating it, just letting you know :-)
> 

Sure, adding a copyright in a modified spec file that Jerome used from
your side is obvious overkill..  :)

> But, this becomes a more significant issue when talking about code
> contributions, and a potential non-free version of, or code that builds
> on, rtsadmin. Once you accept outside contributions under the AGPLv3,
> you are required to release the source of derivative works[3]. Could you
> be a little clearer about your plans for a non-free version, and what
> the boundary will be between it and the released code, so that we can
> make contributions that do not end up in non-free code?
> 

So to clarify here.  We intend to keep everything related to single
target management for rtslib/configshell/rtsadmin available under AGPLv3
on http://www.risingtidesystems.com/git/  This currently includes:

*) high level single node management, libs, and docs for target core
*) high level single node management, libs, and docs for fabrics using 
   the mainline target_core_fabric_config.c framework.
*) configshell python library and docs
*) Ability to build rpm/deb source packages with necessary dependecies

Our commerical versions will include a number of integrated features to
complement single node target core/fabric management, along with
allowing rtsadmin-v2 to function in a larger multi-node cluster
environment.

To the question of contributing code to the AGPLv3 licensed community
edition of rtslib/configshell/rtsadmin, we are doing a dual licensing
model like MySQL.   Please feel free to contact Marc directly with
specific questions that you may have wrt to licensing for our python
code.

--nab

