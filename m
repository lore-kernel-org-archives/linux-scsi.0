From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC PATCH 0/3] FC subsystem update
Date: Wed, 12 May 2010 19:41:40 -0700
Message-ID: <1273718500.14962.97.camel@haakon2.linux-iscsi.org>
References: <20100512202003.27512.34851.stgit@localhost.localdomain>
	 <4BEB44A0.8070208@cisco.com> <1273711270.3543.89.camel@fritz>
	 <4BEB4E13.8010802@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp107.sbc.mail.gq1.yahoo.com ([67.195.14.110]:36762 "HELO
	smtp107.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754508Ab0EMClq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 May 2010 22:41:46 -0400
In-Reply-To: <4BEB4E13.8010802@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: Robert Love <robert.w.love@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "james.smart@emulex.com" <james.smart@emulex.com>, "hare@suse.de" <hare@suse.de>, "christof.schmitt@de.ibm.com" <christof.schmitt@de.ibm.com>, "james.bottomley@suse.de" <james.bottomley@suse.de>

On Wed, 2010-05-12 at 17:55 -0700, Joe Eykholt wrote:
> Robert Love wrote:
> > On Wed, 2010-05-12 at 17:15 -0700, Joe Eykholt wrote:
> >> Robert Love wrote:
> >>> This series represents the continuation of the RFC archived here:
> >>> http://marc.info/?l=linux-scsi&m=126463466126962&w=2. The sysfs organization has
> >>> taken shape and object allocations make more sense than the previous RFC. The
> >>> patches have undergone my own developer testing, which has mostly focused on
> >>> NPIV port creation and deletion and some I/O.
> >>>
> >>> This series creates a Fibre Channel subsystem that has an improved sysfs device
> >>> tree (the port's view of the fabric) and begins to abstract itself from SCSI.
> >>>
> >>> This RFC is to solicit any feedback before I continue to refine these patches.
> >>> I've created two diagrams to help people understand the change. The first shows
> >>> the current sysfs device layout and the second shows the allocation scheme for
> >>> libfc and fcoe's primary data structures.
> >>>
> >>> http://open-fcoe.org/rwlove/fc_sysfs.jpg
> >>> http://open-fcoe.org/rwlove/libfc_alloc.jpg
> >>>

<SNIP>

> >>
> >> Here are my suggested name changes:
> >>
> >> 	fcvport becomes fc_vport
> >> 	fcvport/fcvport_0 becomes fc_vport/0
> >> 	fcpinit_4 becomes fcp_init4
> >> 	fcptarg-X:0-1 becomes fcp_targ/1
> >> 	fcrport:xxx-0 becomes fc_rport/0 (or fc_remote_ports/xxx eventually)
> >> 	fcfabric/fcfabric_0 becomes fc_fabric/0
> >> 	fcport/fcport_0 becomes fc_port/0
> >>
> > Sure, that sounds reasonable. I think I've got too much fc_fc* stuff in
> > general- device names, function names, etc...
> > 
> >> When we have local FCP target ports (as opposed to remote ones) how will we
> >> represent that?  You could include that in the diagram.
> >>
> > This is something that I've got to figure out so that I don't lose any
> > existing functionality. I need a way to test whatever scheme is agreed
> > upon and since stgt isn't integrated with libfc/fcoe I'll either need to
> > integrate it or use one of the out-of-tree target infrastructures to
> > create local target ports.
> 
> You wouldn't have to implement it, I just wanted to know what the
> names would be.  Depending on the target module, they each
> have their own management, and if/when they get into the kernel,
> we can add something to this scheme.  scsi_tgt, being all
> in user land, doesn't even show up in /sys.
> 

Hi Joe and Robert,

So for FC capable target fabric modules, one of this things that would
be really useful is a method exposed by libfc to allow the explict
creation/release of local FCP target ports as they are configured on the
fly by TCM_FC with configfs.  Currently when a individual lport WWPN is
created with:

    mkdir -p /sys/kernel/config/target/fc/XX:XX:XX:XX:XX:XX:XX:XX

the internal struct ft_lport_acl gets allocated, but we cannot tell if
the passed lport WWPN contains a reference to a underlying piece of FC
or FCoE capable hardware.  This is of course because the TCM_FC code is
driven by Joe's patched libfc that forwards PLOGI into struct
fc4_prov->ft_prli() that search for a matching struct ft_lport_acl->wwpn
to reference a individual TCM_FC target port.

So for making libfc explictly aware of externally configured FCP target
ports, we would need something like:

*) A function that accepts a TCM_FC provided lport WWPN string and
previously registered struct fc4_prov pointer that returns reference to
a libfc target port descriptor. (eg: looks matching hardware WWPN)

*) A function thats then accepts the above libfc target port descriptor
and creates FCP target port group+attributes in sysfs once the TCM_FC
lport has been successfully configured.

*) And a function to explictly release the FCP target port.  This order
is obviously going to depend a great deal on what target logic that
libfc ends up exposing.

I know that Joe's original patches to provide target mode hooks for
struct fc4_prov for I_T Nexus and I/O path logic still need to be
resolved for upstream, but I think having libfc support some form of
explict FCP target port configuration accessable by fabric modules would
be a reasonable next step.

Best,

--nab

