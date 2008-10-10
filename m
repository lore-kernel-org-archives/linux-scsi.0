From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [ANNOUNCE]: ConfigFS enabled Generic Target Mode
	and	iSCSI	Target Stack on v2.6.27-rc7
Date: Fri, 10 Oct 2008 13:41:56 -0700
Message-ID: <1223671316.15764.607.camel@haakon2.linux-iscsi.org>
References: <1222716101.4296.41.camel@haakon2.linux-iscsi.org>
	 <48E3B529.4060406@vlnb.net>
	 <1222907050.15764.56.camel@haakon2.linux-iscsi.org>
	 <48E4FE3F.2080707@vlnb.net>
	 <1222982972.15764.118.camel@haakon2.linux-iscsi.org>
	 <48EB325E.6050907@vlnb.net>
	 <1223412658.15764.306.camel@haakon2.linux-iscsi.org>
	 <48EF9567.5060604@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:27236 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759757AbYJJUmA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Oct 2008 16:42:00 -0400
In-Reply-To: <48EF9567.5060604@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, iet-dev <iscsitarget-devel@lists.sourceforge.net>, Greg KH <greg@kroah.com>, Jerome Martin <tramjoe.merin@gmail.com>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, SCST-Devel <scst-devel@lists.sourceforge.net>, Joel Becker <joel.becker@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>

On Fri, 2008-10-10 at 21:48 +0400, Vladislav Bolkhovitin wrote:
> > Point taken however that $TARGET_MOD could, and probably should have
> > some manner of generic ACL infrastructure available through FABRIC <->
> > TARGET API.  I will have a look at scst_register() and
> > scst_register_session() and see where it should be adapted to
> > target_core_mod.
> > 
> > Btw, saying that "management of all security stuff should be purely duty
> > of the mid-layer" is incorrect however.  The generic target engine needs
> > to make it *EASIER* for $FABRIC to allow those initiator ports access to
> > Mapped LUNs through fabric *DEPENDENT* endpoints, but trying to put all
> > fabric depepdent ACL endpoint logic in target_core_mod is IMHO a bad
> > idea.  
> > 
> > Since each SCSI fabric's method of attaching SCSI LUN to Initiator Port
> > Endpoints in $FABRIC_MOD to SCSI Device (I have been calling
> > this /sys/kernel/config/target/core/$STORAGE_OBJECT for target_core_mod)
> > to create the SCSI Target Port is different.  The reference I use for
> > iscsi_target_mod (and hence wrt target_core_mod) is proper T10/SCSI
> > terminlogy AFAIK.  Lets reference the objects in
> > http://www.haifa.il.ibm.com/satran/ips/EddyQuicksall-iSCSI-in-diagrams/portal_groups.pdf 
> > for the discussion so we can make sure we are on the same page..
> > 
> > For example, just because iSCSI uses TargetName + TargetPortalGroupTag
> > to attach target_core_mod's $STORAGE_OBJECTs at iSCSI Logical Units to,
> > does not mean that SAS, or another SCSI based target fabric know
> > anything about TargetName or TargetPortalGroupTag.  In iSCSI, this is
> > defined in Section 2.1: 
> > 
> >      The I_T nexus can be identified by the conjunction of the SCSI port
> >      names; that is, the I_T nexus identifier is the tuple (iSCSI
> >      Initiator Name + ',i,'+ ISID, iSCSI Target Name + ',t,'+ Portal 
> >      Group Tag).
> > 
> > Obviously the Initiator and Target Ports wrt iSCSI fabric are more
> > "symbolic" than devices attached to say a legacy Parallel SCSI bus
> > because of IP storage having multiple IP network portals across multiple
> > independent backbone providers and subnets (if you are using MC/S or
> > SCTP), etc, etc.  This is this reason I think it does not make sense to
> > try to locate fabric dependent ACLs
> > under /sys/kernel/config/target/core/$STORAGE_OBJECT.  
> > 
> > The type of things that need to be under $STORAGE_OBJECT, and that do
> > have a direct effect for $FABRIC mapped LUN endpoints are things like
> > device_type, max_sectors, sector_size, queue_depth and global READ-ONLY.
> > Of course, we want to be able to see *ALL* of
> > the /sys/kernel/config/target/$FABRIC dependent ACLs that have been
> > symlinked to said $STORAGE_OBJECT (this is one of the items on my list,
> > but not implemented in my current work).
> 
> Nicholas, you think too iSCSI centric. From access control POV only 2 
> thing matter:
> 

Not true.  Thre is *NOTHING* in target_core_mod's configfs layout that
is "iSCSI centric", or $FABRIC centric at all.  We are talking about
configfs symbolic links with /bin/ls from target_core_mod storage
objects and $FABRIC_MOD portal group ports for $FABRIC LUNs.  How
Initiators logging into those $FABRIC_MOD endpoints (Node ACLs) and
accessing those $FABRIC LUNs (LUN ACLs) is still $FABRIC dependent.  

There is nothing iSCSI, SCSI, ATA or NBD centric about it, it is UNIX
centric and works generically across any fabric, that is the whole point
of having target_core_mod.  Why would we want to limit the generic
target engine to having Parallel SCSI (see below) centric ACLs..?  

>
> 1. Target name - to assign to it a default access control group (ACL, if 
> you like that name), i.e. an ACL for initiators not listed in other ACLs
> 

Wrong.  For iSCSI, Section 2.1 of RFC-3720 defines it as TargetName +
TargetPortalGroupTag, and this is the method that all of my upstream
work and any proper implemention of target node endpoint and target
portal group assignement.

> 2. Initiator name - to assign it to the corresponding ACL.
> 
> It doesn't matter if those names are IQNs for iSCSI or WWNs for FC, or 
> bus:id:lun for parallel SCSI.
> 
> For example, consider target "TTT", which has 2 ACLs: "Default" with 
> Device1 as LUN 0 and "Group1" with "Device2" as LUN 0. "Group1" 
> specified for initiator "III1". Then when initiator "III1" connected to 
> target "TTT", it would be assigned to "Group1" and see "Device2". If 
> then initiator "III2" connected, it would be assigned to "Default" ACL 
> and see "Device1". "Default" group can be empty, if necessary. There's 
> nothing transport specific in this approach at all.
>

Your example limits all iSCSI ACLs to TargetName, instead of TargetName
+TargetPortalGroupTag.

That is why everything related to iscsi_target_mod operation is
below /sys/kernel/config/target/iscsi/$IQN/$TPGT and
not /sys/kernel/config/target/iscsi/$IQN.  

Obviously I am not going to limit my upstream iscsi_target_mod to an ACL
structure that does not take into account a complete RFC-3720
implementation, but I would be more than happy to see you update your
ACL code to reflect proper TargetName+TargetPortalGroupTag that RFC-3720
lays out for the iSCSI Target Port <-> SCSI Target Port mapping.

> I strongly suggest you to look at SCST access control approach and make 
> sure you understand it before reply. It would save us a lot of time and 
> effort. Note, this approach isn't something theoretical. It's proved by 
> 4 years of successful usage.

I don't really care about history, I care about code.  Why don't you
start breaking out which code you want to go upstream so that it makes
my job easier or start integrating your own ACL control model into
drivers/lio-core/target_core_configfs.c and post a patch and then we can
discuss!

In all honesty however, the ACL code is a small nit-pick compared to how
we are going to merge your $FABRIC <-> $TARGET API with
drivers/lio-core.  Why don't you start there first while I consider what
can be made generic for ACL code for the target_core_mod configfs
upstream work.  


> Also, it would be good, if you shift your terminology to be less iSCSI 
> specific and use the corresponding terms from SAM, where possible. We 
> are discussing a config interface for a generic target engine, aren't 
> we? Otherwise sometimes it's quite hard for me to understand you and I 
> have strong suspicions that other people are getting or already got lost 
> in it.
> 

Heh, why do you think I moved my upstream work to ConfigFS..?  Being
able to use two 'mkdir -p' and two 'ln -s' to create two iSCSI Initiator
Node ACLs and four iSCSI Initiator Node ACLs is as easy as it gets!?

Being able to call a *SINGLE* mkdir -p to create Network Portal on an
iSCSI Target Portal Group, and from an unloaded iscsi_target_mod preform
four different iSCSI target mod ops is a simple as it gets

target_core_mod is a generic target engine that uses the most advanced
and complete iscsi_target_mod, so one must put effort into understanding
the drivers/lio-core/*configfs* to understand the simplicity of the
code.  

> >> Thus, I believe, all the ACL management should be done not in $FABRIC/, 
> >> but in $TARGET/. It would remove all the corresponding configfs 
> >> headaches from the target drivers writers.
> >>
> > 
> >
> >> But, in fact, I asked about completely different thing. SCSI target 
> >> mid-layer in some cases needs to export in user space amount of data, 
> >> which doesn't fit one page. /proc/scsi_tgt/sessions is one example. What 
> >> should we do for it?
> >>
> > 
> > I did address point above in my work, and my commits
> > under /sys/kernel/config/target/iscsi implement how I get around the
> > PAGE_SIZE limitiations, which was something that I ran into (moving from
> > IOCTL and all, which requires overly complex kernel level information
> > code to get lots of output), to using ConfigFS, which has the same as
> > procfs and sysfs limits that you need to use seq_file() for > PAGE_SIZE.
> > Anyways, I did not end up using seq_file() for iscsi_target_mod current
> > configfs code, here is what I am using to address your above example wrt
> > getting all of session output:
> 
> Hmm, I looked at the code and in lio_target_initiator_nacl_info() saw 
> something like:
> 
> 		rb += sprintf(page+rb, "LIO Session ID: %u   "
> 			"ISID: 0x%02x %02x %02x %02x %02x %02x  "
> 			"TSIH: %hu  ", sess->sid,
> 			sess->isid[0], sess->isid[1], sess->isid[2],
> 			sess->isid[3], sess->isid[4], sess->isid[5],
> 			sess->tsih);
> 		rb += sprintf(page+rb, "SessionType: %s\n",
> 				(SESS_OPS(sess)->SessionType) ?
> 				"Discovery" : "Normal");
> 		rb += sprintf(page+rb, "Cmds in Session Pool: %d  ",
> 				atomic_read(&sess->pool_count));
> 		rb += sprintf(page+rb, "Session State: ");
> 
> It doesn't look for me like it addresses the PAGE_SIZE limitation issue.
> 

You are still completely missing the point here..  Because I broke out
my projects *LEGACY* information code (just like every other upstream
project is required to do) I do not have gigantic nested loops in my
target_core_mod and iscsi_target_mod code that can only dump output
using seq_file() out of procfs or through god awful IOCTL code.

Every other upstream project that *HAS* broken out its legacy
informational code into sysfs (which again, has the same limitiation) or
another sane virtual FS control interface (like configfs) is working
just fine.  Sysfs is used by people on many many millions of Linux
boxes, and all existing upstream projects that use sysfs have no problem
getting lots and lots and lots of info using /bin/cat even with the
PAGE_SIZE limitiation in place.  

So this means you have two choices:

*) Fix your legacy code to use a sane informational output interface for
your upstream branch.  

*) Produce a patch to solve the limitiation and produce an API and post
it to linuxfs-devel.

Again, for my upstream work with iscsi_target_mod, everyone will just be
using '/bin/cat' and wildcards (*) to grok the thousands
of /sys/kernel/config/target/iscsi/$IQNs configfs objects running on the
production systems.  Because of this reason, I am not pained by this
limitiation (as some of your code appears to be) so please don't expect
me to produce this patch.

--nab

