From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v5 07/13] iscsi-target: Add iSCSI Login Negotiation +
	Parameter logic
Date: Thu, 26 May 2011 14:33:07 -0700
Message-ID: <1306445587.23461.22.camel@haakon2.linux-iscsi.org>
References: <1305862678-30150-8-git-send-email-nab@linux-iscsi.org>
	 <1306428415.4048.22.camel@mulgrave.site>
	 <1306436832.5807.127.camel@haakon2.linux-iscsi.org>
	 <20110527042934U.fujita.tomonori@lab.ntt.co.jp>
	 <1306439399.19113.22.camel@haakon2.linux-iscsi.org>
	 <1306440882.4048.47.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1306440882.4048.47.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, hare@suse.de, agrover@redhat.com, michaelc@cs.wisc.edu, bharrosh@panasas.com, akpm@linux-foundation.org, martin.svec@zoner.cz, Jerome Martin <jxm@risingtidesystems.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-05-26 at 15:14 -0500, James Bottomley wrote:
> On Thu, 2011-05-26 at 12:49 -0700, Nicholas A. Bellinger wrote:
> > On Fri, 2011-05-27 at 04:29 +0900, FUJITA Tomonori wrote:
> > > On Thu, 26 May 2011 12:07:12 -0700
> > > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > > 
> > > > On Thu, 2011-05-26 at 11:46 -0500, James Bottomley wrote:
> > > > > On Thu, 2011-05-19 at 20:37 -0700, Nicholas A. Bellinger wrote:
> > > > > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > > > > > 
> > > > > > This patch adds the princple RFC-3720 compatiable iSCSI Login
> > > > > > phase negotiation for iscsi_target_mod.  This also includes the
> > > > > > target RX/TX thread queue logic which is called directly from iSCSI
> > > > > > login associated code.
> > > > > > 
> > > > > > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org> 
> > > > > 
> > > > > I thought the upshot of the thread with Tomo was that we wouldn't be
> > > > > doing all of this in-kernel.  Where's the userspace upcall for this?
> > > > > 
> > > > 
> > > > The technical reasons why I want to avoid this have not changed for the
> > > > 1) authentication disabled and 2) 'required-to-implement' CHAP
> > > > authentication cases.  These where discussed at the bottom of the thread
> > > > from March with Tomo-san here:
> > > > 
> > > > http://marc.info/?l=linux-scsi&m=130108812405710&w=2
> > > > 
> > > > As mentioned, I am open to adding a userspace upcall for authentication
> > > > payloads post merge in order to support the 'optional-to-implement'
> > > > authentication cases.  However, pushing the above two cases out to
> > > 
> > > We don't need such, passing payloads from kernel to user space. You do the pre
> > > SCSI nexus operations in user space then kernel takes care of established
> > > nexuses.
> > > 
> > 
> > I understand what you have in mind, but I still think this the wrong
> > approach for the default cases.  For an in-kernel iscsi-target capable
> > of changing any aspect of the control plane on the fly, this type of
> > split is problematic to support and maintain and does not actually buy
> > us anything for the default cases.
> 
> Handling the default case separately from the less usual ones is
> actually the bigger recipe for disaster because the less used path
> becomes less well tested.
> 
> I don't really see how a kernel/user split is problematic.  After all,
> it's what we use for a lot of things (udev being the most notable).
> 

The fact is that none of the mainstream initiators support anything
beyond CHAP at this point, so the default cases are realistically what
everyone will be using for 2.8.0 and need to be rock solid for all
cases.

> > > > userspace really does add unnecessary complexity and limitiations that I
> > > > want to avoid for the default iSCSI login cases.
> > > > 
> > > > It also would break existing rtslib/rtsadmin-v2 userspace code, and
> > > 
> > > I don't think breaking the existing code matters.
> > 
> > Sure it does.  It means the difference between if the
> > 'required-to-implement' cases can be exposed via configfs to a native
> > python object library and shell, or if we need to have an external
> > daemon + configuration that has to be kept in sync between the two,
> > parse external configuration files, et al.
> 
>      1. We can always handle this in an ABI shim in userspace
>      2. The current *kernel* code doesn't exist, therefore it has no
>         users.  Maintaining compatibility with the out of tree code is
>         fine, but not at the expense of less optimal design decisions.
> 
> > With the current design, the NodeACLs + authentication are available
> > directly as part of the rtslib python object library, and python code
> > including rtslib can reference all aspects of the initiator
> > configuration directly.  Breaking this up to an external daemon and
> > configuration is a step backwards for the default cases from the
> > perspective of rtslib, and making it work with an external
> > configuration / daemon for the NodeACLs + default authentication case is
> > an hack compared to how iscsi-target functionality is exposed to
> > application level progammers via rtslib today.
> 
> I don't buy this.  It doesn't have to be a daemon (udev isn't).  And
> udev certainly isn't a hack compared to what went before (which was
> fully in-kernel).
> 

To elaborate a bit more with an rtslib example (Jerome CC'ed).

Consider the following python code that uses rtslib to create a iSCSI
target+tpgt, iSCSI Initiator NodeACL, and set+read authentication
information for said NodeACL using native library objects:

#!/usr/bin/python

import rtslib

fabric = rtslib.FabricModule('iscsi')

print("Creating a new iqn.2003-01.org.linux-iscsi.rtslinux.foobar iscsi target")
target = rtslib.Target(fabric, "iqn.2003-01.org.linux-iscsi.rtslinux.foobar")

print
print("Creating a new iscsi TPG, TPG5 in that target")
tpg = rtslib.TPG(target, 5)

print
print("Creating a node ACL for initiator iqn.2003-01.org.linux-iscsi.rtslinux.initiator")
node_acl = tpg.node_acl("iqn.2003-01.org.linux-iscsi.rtslinux.initiator")

print
print("Setting the CHAP password and username to foo/bar for that initiator")
node_acl.chap_username = "foo"
node_acl.chap_password = "bar"

print
print("Reading CHAP password and username for that initiator")
print("Username: %s\n Password: %s" % (node_acl.chap_username, node_acl.chap_password))

print
print("For fun, let's list all of our existing node ACLs paths, accross all fabric/targets/etc.")
acls = [acl.path for acl in rtslib.RTSRoot().node_acls]
print "\n".join(acls)

-----------------------------------------------------------------------

Being able to have access to the complete set of underlying iscsi-target
features in native python library code is very important for target mode
userspace, and the current kernel+user code is solving this elegantly
for the two default iSCSI login cases.

We are open to looking at how to extend the kernel+user code to support
other 'optional-to-implement' iscsi authentication cases, but not at the
expense making drastic changes to kernel code this late, or removing /
breaking python library object functionality for the default
'required-to-implement' cases.

--nab
