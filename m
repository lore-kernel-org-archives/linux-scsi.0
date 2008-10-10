From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE]: ConfigFS enabled Generic Target Mode and	iSCSI	Target
 Stack on v2.6.27-rc7
Date: Fri, 10 Oct 2008 21:48:23 +0400
Message-ID: <48EF9567.5060604@vlnb.net>
References: <1222716101.4296.41.camel@haakon2.linux-iscsi.org>	 <48E3B529.4060406@vlnb.net>	 <1222907050.15764.56.camel@haakon2.linux-iscsi.org>	 <48E4FE3F.2080707@vlnb.net>	 <1222982972.15764.118.camel@haakon2.linux-iscsi.org>	 <48EB325E.6050907@vlnb.net> <1223412658.15764.306.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-04.mailcluster.net ([77.221.130.216]:37199 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750904AbYJJRsV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Oct 2008 13:48:21 -0400
In-Reply-To: <1223412658.15764.306.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-iscsi-target-dev@googlegroups.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, iet-dev <iscsitarget-devel@lists.sourceforge.net>, Greg KH <greg@kroah.com>, Jerome Martin <tramjoe.merin@gmail.com>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, SCST-Devel <scst-devel@lists.sourceforge.net>, Joel Becker <joel.becker@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>

Nicholas A. Bellinger wrote:
>>> Here is what I am thinking wrt /sys/kernel/config/target/iscsi and iSCSI
>>> Initiator Node ACLs to iSCSI Portal Groups and iSCSI LUNs attached to
>>> those Portal Groups.  There are two cases:
>>>
>>> *) The production case with with user creating those ACLs under $FABRIC
>>> (which is what I will focus on now).
>>>
>>> * And "Demo Mode" case where any Initiator logging into
>>> $FABRIC/$ENDPOINT/$PORTAL can have access to all
>>> $FABRIC/$ENDPOINT/lun/lun_*/*my_ports*
>>>
>>> The production ACL case would look like:
>>>
>>> export CONFIGFS=/sys/kernel/config/
>>> export TARGET=/sys/kernel/config/target/core/
>>> export FABRIC=/sys/kernel/config/target/iscsi/
>>>
>>> TARGET_IQN=iqn.2003-01.org.linux-iscsi.ps3-cell.ppc64:sn.f8f651bd5fec
>>> INITIATOR_IQN=iqn.1993-08.org.debian:01.f82074ca555f
>>>
>>> <Setup $STORAGE_OBJECTs under $TARGET>
>>>
>>> # Create the LIO-target endpoint
>>> mkdir -p "$FABRIC/$TARGET_IQN/tpgt_1/np/172.16.201.137:3260"
>>> mkdir -p "$FABRIC/$TARGET_IQN/tpgt_1/lun/lun_0"
>>>
>>> <Setup Port Symlinks from $TARGET to $TARGET_IQN/tpgt_1/lun/lun_0>
>>>
>>> # Create the Initiator ACL under $TARGET_IQN/tpgt_1
>>> mkdir -p $"FABRIC/$TARGET_IQN/tpgt_1/initiators/$INITIATOR_IQN"
>>> # Allow $INITIATOR_IQN access to tpgt_1/lun/lun_0/
>>> ln -s "$FABRIC/$TARGET_IQN/tpgt_1/lun/lun_0" \
>>> 	"$FABRIC/$TARGET_IQN/tpgt_1/initiators/$INITIATOR_IQN/lun_0"
>>>
>>> >From there, you don't have to worry about PAGE_SIZE limitiations w/o, I
>>> can simply use use:
>>>
>>> cat $FABRIC/iqn*/tpgt*/initiators/*/session
>>>
>>> to see which acl'ed iSCSI Initiators are logged in on all iSCSI Target
>>> Ports.
>>>
>>> Also I should add that I am currently using /proc/scsi_target/mib
>>> and /proc/iscsi_target_mib for READ-ONLY data with target_core_mod.ko
>>> and iscsi_target_mod.ko respectively.  For the other "Demo Mode" case
>>> mentioned above, I am currently using /proc/iscsi_target/mib/sess_attr
>>> to see the active sessions for LIO-Target.
>> Sorry for the delay. I didn't have a chance to look at it sufficiently 
>> close.
>>
>> Basically the idea about how to manage ACLs is good, but I don't like, 
>> that with it *ALL* the target drivers would have to implement the 
>> necessary code. It shouldn't be so, management of all security stuff 
>> should be purely duty of the mid-layer.
> 
> By the "mid-layer" I assume you mean the generic target mode engine, and
> not the SCSI mid layer, yes..?

Yes, sure

> Point taken however that $TARGET_MOD could, and probably should have
> some manner of generic ACL infrastructure available through FABRIC <->
> TARGET API.  I will have a look at scst_register() and
> scst_register_session() and see where it should be adapted to
> target_core_mod.
> 
> Btw, saying that "management of all security stuff should be purely duty
> of the mid-layer" is incorrect however.  The generic target engine needs
> to make it *EASIER* for $FABRIC to allow those initiator ports access to
> Mapped LUNs through fabric *DEPENDENT* endpoints, but trying to put all
> fabric depepdent ACL endpoint logic in target_core_mod is IMHO a bad
> idea.  
> 
> Since each SCSI fabric's method of attaching SCSI LUN to Initiator Port
> Endpoints in $FABRIC_MOD to SCSI Device (I have been calling
> this /sys/kernel/config/target/core/$STORAGE_OBJECT for target_core_mod)
> to create the SCSI Target Port is different.  The reference I use for
> iscsi_target_mod (and hence wrt target_core_mod) is proper T10/SCSI
> terminlogy AFAIK.  Lets reference the objects in
> http://www.haifa.il.ibm.com/satran/ips/EddyQuicksall-iSCSI-in-diagrams/portal_groups.pdf 
> for the discussion so we can make sure we are on the same page..
> 
> For example, just because iSCSI uses TargetName + TargetPortalGroupTag
> to attach target_core_mod's $STORAGE_OBJECTs at iSCSI Logical Units to,
> does not mean that SAS, or another SCSI based target fabric know
> anything about TargetName or TargetPortalGroupTag.  In iSCSI, this is
> defined in Section 2.1: 
> 
>      The I_T nexus can be identified by the conjunction of the SCSI port
>      names; that is, the I_T nexus identifier is the tuple (iSCSI
>      Initiator Name + ',i,'+ ISID, iSCSI Target Name + ',t,'+ Portal 
>      Group Tag).
> 
> Obviously the Initiator and Target Ports wrt iSCSI fabric are more
> "symbolic" than devices attached to say a legacy Parallel SCSI bus
> because of IP storage having multiple IP network portals across multiple
> independent backbone providers and subnets (if you are using MC/S or
> SCTP), etc, etc.  This is this reason I think it does not make sense to
> try to locate fabric dependent ACLs
> under /sys/kernel/config/target/core/$STORAGE_OBJECT.  
> 
> The type of things that need to be under $STORAGE_OBJECT, and that do
> have a direct effect for $FABRIC mapped LUN endpoints are things like
> device_type, max_sectors, sector_size, queue_depth and global READ-ONLY.
> Of course, we want to be able to see *ALL* of
> the /sys/kernel/config/target/$FABRIC dependent ACLs that have been
> symlinked to said $STORAGE_OBJECT (this is one of the items on my list,
> but not implemented in my current work).

Nicholas, you think too iSCSI centric. From access control POV only 2 
thing matter:

1. Target name - to assign to it a default access control group (ACL, if 
you like that name), i.e. an ACL for initiators not listed in other ACLs

2. Initiator name - to assign it to the corresponding ACL.

It doesn't matter if those names are IQNs for iSCSI or WWNs for FC, or 
bus:id:lun for parallel SCSI.

For example, consider target "TTT", which has 2 ACLs: "Default" with 
Device1 as LUN 0 and "Group1" with "Device2" as LUN 0. "Group1" 
specified for initiator "III1". Then when initiator "III1" connected to 
target "TTT", it would be assigned to "Group1" and see "Device2". If 
then initiator "III2" connected, it would be assigned to "Default" ACL 
and see "Device1". "Default" group can be empty, if necessary. There's 
nothing transport specific in this approach at all.

I strongly suggest you to look at SCST access control approach and make 
sure you understand it before reply. It would save us a lot of time and 
effort. Note, this approach isn't something theoretical. It's proved by 
4 years of successful usage.

Also, it would be good, if you shift your terminology to be less iSCSI 
specific and use the corresponding terms from SAM, where possible. We 
are discussing a config interface for a generic target engine, aren't 
we? Otherwise sometimes it's quite hard for me to understand you and I 
have strong suspicions that other people are getting or already got lost 
in it.

>> Thus, I believe, all the ACL management should be done not in $FABRIC/, 
>> but in $TARGET/. It would remove all the corresponding configfs 
>> headaches from the target drivers writers.
>>
> 
> I am not sure what "corresponding configfs headaches" you have in mind,
> but please be specific and I will address them. :-)

Creating and managing the necessary configfs entries.

>> But, in fact, I asked about completely different thing. SCSI target 
>> mid-layer in some cases needs to export in user space amount of data, 
>> which doesn't fit one page. /proc/scsi_tgt/sessions is one example. What 
>> should we do for it?
>>
> 
> I did address point above in my work, and my commits
> under /sys/kernel/config/target/iscsi implement how I get around the
> PAGE_SIZE limitiations, which was something that I ran into (moving from
> IOCTL and all, which requires overly complex kernel level information
> code to get lots of output), to using ConfigFS, which has the same as
> procfs and sysfs limits that you need to use seq_file() for > PAGE_SIZE.
> Anyways, I did not end up using seq_file() for iscsi_target_mod current
> configfs code, here is what I am using to address your above example wrt
> getting all of session output:

Hmm, I looked at the code and in lio_target_initiator_nacl_info() saw 
something like:

		rb += sprintf(page+rb, "LIO Session ID: %u   "
			"ISID: 0x%02x %02x %02x %02x %02x %02x  "
			"TSIH: %hu  ", sess->sid,
			sess->isid[0], sess->isid[1], sess->isid[2],
			sess->isid[3], sess->isid[4], sess->isid[5],
			sess->tsih);
		rb += sprintf(page+rb, "SessionType: %s\n",
				(SESS_OPS(sess)->SessionType) ?
				"Discovery" : "Normal");
		rb += sprintf(page+rb, "Cmds in Session Pool: %d  ",
				atomic_read(&sess->pool_count));
		rb += sprintf(page+rb, "Session State: ");

It doesn't look for me like it addresses the PAGE_SIZE limitation issue.

>> >From there, you don't have to worry about PAGE_SIZE limitiations w/o >
>>> I can simply use use:
>>>
>>> cat $FABRIC/iqn*/tpgt*/initiators/*/session
>>>
> 
> This ended up being `cat $FABRIC/iqn*/tpgt*/acls/*/info` to view all of
> the active iSCSI Sessions on all iSCSI Target fabric endpoints..
> 
> The point is that regardless of kernel <-> user information output
> method, it makes sense to break up large pieces of kernel level
> information code and rely upon access through the VFS and cat to obtain
> bulk output.
> 
> However, Joel has discussed removing the > PAGE_SIZE limitation for all
> of the virtual filesystems, so I am sure he would be more than happy to
> take a  patch that addressed your concern if it is really that big of a
> deal for the SCSI control path.  With my current work with
> target_core_mod and iscsi_target_mod wrt configfs I am not running into
> this problem, so me producing this patch is not very high on my list..
> 
>>> I will be implementing this model over the next days..  I will post the
>>> commit once its up and you can have a look..
>>>
> 
> Ok, I ended up using a slightly different model for ACLs
> under /sys/kernel/config/target/iscsi that the one I mentioned from last
> week to get things up and running.  I will be posting the commit and
> info shortly.
> 
> Thanks for your comments Vlad!
> 
> --nab
> 
> 
> 

