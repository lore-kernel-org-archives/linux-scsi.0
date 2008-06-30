From: "Love, Robert W" <robert.w.love@intel.com>
Subject: RE: fcoe cleanups and fcoe TODO
Date: Mon, 30 Jun 2008 13:33:52 -0700
Message-ID: <10A7D0016239E24092DEF05CCC582E4303FE4B55@fmsmsx411.amr.corp.intel.com>
References: <1214763843-5548-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62897 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbYF3Udz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jun 2008 16:33:55 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1214763843-5548-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, devel@open-fcoe.org

>Hey,
>
>Following are some cleanup patches for things I found while trying
>to get setup. I did not get to test the patches well, because
>the rearch code does not seem to work every well the software
>target. I basically loaded the driver and made sure I could login
>and find storage. Trying to do heavy READ and WRITE IO lead to
problems.
>
>The patches are made over the re-arch git tree.
>
Awesome, I've reviewed a few and will get them in shortly.

>Below are some notes for things I am working on and that we may want to
>talk about or you may want to hack on. It is not a complete list. Just
>some stuff I noticed on the first pass.
>
>My TODO:
>
>- Replace fc_scsi.c's outstanding array with scsi host shared tag map
>(scsi_init_shared_tag_map).
>
I'll have to read about this a bit more.

>- Fix locking and document it:
>        fc_scsi.c: The fc_scsi_pkt done function can be called with
spin
>        locks held so at first glance we should not call del_timer_sync
>        because it can sleep.
>
>        Other libfc code's fl_lock, rp_lock and em_lock and ex_lock is
>        really complicated. It needs some documentation. I hit the
>        locking bug fixed with
>        0003-libfc-fix-locking-in-tt.rport_lookup_create-paths.patch
>        and it turns out we can call functions with different locks
held.
>        For example we call the frame_send callout with the fl_lock
>        sometimes and other times with another lock. And sometimes bhs
>        are disabled and sometimes they are not.
>
Most of the locking problems are due to the convergence of previous
structures. We do need a comprehensive review of all of our locking and
reference counting.

>        Will libfc code be used by drivers that work more like
>        traditional drivers where they have a interrupt handler and
>        do not hook into the network layer? If so then it seems
>        like we want to the irq spin locks instead of the bh ones.
>
>        Also remove fl_lock and rp_lock wrappers.
>
>        The per scsi packet locking looks a little too complicated.
>        How much of a performance boost do we get from this?
>
>- Some of the host lib re-arch seems akward (maybe it was like this
>before).
>The LLD allocates and adds the scsi host, but fc_lport_destroy removes
>the host and the driver only does the last put. We should probably
>make this more symmetrical. Was this done to fix the sync cache
>command and logout processing?
>
No, this is simply a result of the big transitions we've made and yes, I
agree, the creation/deletion needs to be symmetrical.

>- I am not sure if the setup functions like fc_lport_init are nice
>in how it sets the transport functions pointers for you or if it will
lead
>to problems for drivers that want to partially hook in, but find
>out that the lib has set some functions it did not want. Maybe we want
>to set the libfc functions in the LLD like is done for the
>scsi_host_template.
>
Yeah, we've debated whether we should have the lib init the pointers and
then have the LLD override them or have the LLD set them first and have
the lib fill in the un-initialized ones. The current design allows a LLD
to override the default functions with its own. Is your suggestion to
expose all of the functions that could satisfy the tt
(fc_transport_template) pointers through the libfc API and have the LLD
set them all? 

Throughout this re-architecture the tt and libfc API have grown and
shrunk. Lately we've bloated the tt to expose functions that were
previously called directly from one UL system (fc_scsi, fc_lport,
fc_rport or fc_disc) to another. The number of functions needed in the
tt and also required in the libfc API seemed like too much and having a
little _init() function for each UL system seemed cleaner. We're getting
closer to having a cleaner API between each UL system so maybe we can
move the assignment of tt pointers back to the LLD.

>I think we need to see more hardware in the end. For now since there is
>only
>software fcoe that is out, this could probably be ok and as we see more
>drivers we can evolve the split for the hardware like was done with
iscsi.
>For iscsi we ended up with 4 different offload modules so there was no
way
>we could have designed for all of them and the hardware/firmware
>guys's quirks :)
>
We definitely expect this library to evolve as more LLDs use it. 

>- In general without knowing how hardware is really going to hook into
>the lib it is hard to say how the rearch is going :) If we cannot
>move more of the fc_remote_port to the rport (or if we just do not
>want to move it all there because other drivers like lpfc and qla2xxx
>will never use it) then we might want to rename the fc_remote_port
>to avoid confusion with the rport and make it clear that the libfc
remote
>port is only needed for libfc operations.
>
We'd like to reduce fc_remote_port to nothing and only use fc_rport.
We're still not sure we can completely achieve this without either
having some private data or adding fields to the fc_rport.

>Should the fc_transport_template be merged with the
fc_function_template?
>The function callouts to do things lke abort IO or cleanup commands
look
>similar. But in general should the fc_function_template be common for
all
>fc drivers and should the fc_transport_template be just for the ones
that
>are
>going to hook into the libfc? If the latter maybe we want to rename
this to
>make the visibility clear.
>
So something like libfc_transport_template?

>- How much of the drivers/scsi/fcoe driver should be common? The start
and
>stop interface seems like it should be common for all fc drivers. But
will
>some things like passing in the network device to use be fcoe module
>specific?
>Will other drivers load like a more traditional driver with a
pci_driver,
>or will this be a mess like iscsi where some do, but others bind to
>network devices (netdevs) that also have fcoe engines. The pci_driver
>case would mean that we do not need a common interface for this,
>but for the netdev with fcoe engine then it seems like we want a common
>inteface like we have with iscsi.
>
>Do we want a common userspace interface for the setup like we have with
>iscsi for the initial merge? If so, we can say the interface is
unstable
>for now, because we just do not know how the hardware is going to work
or
>we can try and design a interface based on what we learned from iscsi.
The
>latter will probably result in a incorrct design since we are only
>lowly driver engineers and do not know the fun the firmware guys
>have for us :) However breaking userspace interfaces is a real pain
>for users. When we did the latter for iscsi it was a tremendous pain
for
>users and distro integrators.
>
>- Should discovery be done in userspace? For iscsi we put things like
iSNS
>in userspace and even sendtargets which is not that big. iSNS is big
and
>clunky. It looks like 10 thousand lines from doing a wc on some of the
>open-isns code, but could be smaller if we limit the features (the
native
>iSNS code in open-iscsi's userspace daemon is only a couple thousand
lines
>but that only does discovery). Are we going to have something similar
for
>fcoe? If so then we might want to keep all discovery in userspace and
>create a interface similar to iscsi where discovery is done in
userspace
>and then tells the kernel to create objects like rports for only the
>targets.
>
There are really two types of discovery related to fcoe- target
discovery using the name server and FIP (FCoE Initialization Protocol)
which allows various devices connected to a FCF fabric to discover each
other. So far we only have an implementation for the prior, in-kernel. 

Loosely related, I was planning on renaming fc_disc.c to fc_dns.c to
reflect that it was interaction with the name server. Even less related
I plan to rename fc_scsi.c to fc_fcp.c as it's really doing FCP.

>Going to userspace on the other hand is a major pain in the butt when
>it comes to distro integration and error handling. For an RCSN would
>we have to kick back out to userspace then come back to the kernel?
>If so for iscsi it turns out to be a lot more complicated to do the
>equivalent when you move discovery to userspace. And for boot it gets
messy
>to get this all to work right.
>
>- For storage drivers are we using the be/le cpu functions instead
>of the hton/ntoh? I think Christoph asked us to do that for iscsi.
>
>- A lot of the goto error paths are broken. The fcoe module init for
>example leaks when some functions fail (probably due to rearch and this
>being more temp code).
>
Yes, that needs to be fixed. We've really spent a lot of time
simplifying and consolidating. There has been fallout as a result,
broken p2p, messy locking, and bad error handling. It took quite a bit
to get the code to where it is now and we're getting closer to a place
where we can review the code more comprehensively, work on known bad
spots and start fixing defects. 

>- Add some mempools or reserve just enough scsi pkt and em resources so
we
>can make forward progress on at least one command per host.
>

Thanks for the patches and feedback!
>
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi"
in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
