From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: target: problems with Persistent reservations, iscsi
Date: Wed, 05 Jan 2011 16:13:13 -0800
Message-ID: <1294272793.14650.172.camel@haakon2.linux-iscsi.org>
References: <a17263ef-dd96-468e-ad85-0f987cdacb4f@j25g2000yqa.googlegroups.com>
	 <1294184625.29002.29.camel@haakon2.linux-iscsi.org>
	 <20110105162720.GA4494@omega17.zumbi.com.ar>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54896 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab1AFATN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2011 19:19:13 -0500
In-Reply-To: <20110105162720.GA4494@omega17.zumbi.com.ar>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gustavo panizzo <gfaraway@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>

On Wed, 2011-01-05 at 13:27 -0300, gustavo panizzo wrote:
> Hi Nicholas,
> 
> 
> > 
> > First lets verify that the PROUT Register into target_core_pr.c:
> > core_scsi3_emulate_pro_register() w/ ignore_key=1 is the SCSI packet
> > that is actually triggering the OOPs.  Please send along a wireshark
> > capture from the LIO target side and provide a brief layout of which IP
> > addresses correspond to which nodes, etc.
> > 
> 
> cluster1 192.168.0.201
> cluster2 192.168.0.202
> cluster3 192.168.0.203 (not in use during this test)
> lio node 192.168.0.1
> 
> i ran the command from cluster2, the tests involved cluster1 &
> cluster2
> 
> i've attached 2 files
> capture.lcap.bz2 -> wireshark capture from the lio node
> dmesg -> dmesg from lio node, starting after run /etc/init.d/target
> start 
> 

Hi Gustavo,

Ok, following the output from the provided dmesg it appears that you are
making three explict NodeACLS for the initiator side IQNs:

[211170.246482] iSCSI_TPG[1] - Added ACL with TCQ Depth: 16 for iSCSI Initiator Node: iqn.1994-05.com.redhat.cluster1
[211170.255635] iSCSI_TPG[1]_LUN[0->0] - Added RW ACL for  InitiatorNode: iqn.1994-05.com.redhat.cluster1
[211170.396664] iSCSI_TPG[1] - Added ACL with TCQ Depth: 16 for iSCSI Initiator Node: iqn.1994-05.com.redhat.cluster2
[211170.404372] iSCSI_TPG[1]_LUN[0->0] - Added RW ACL for  InitiatorNode: iqn.1994-05.com.redhat.cluster2
[211170.645394] iSCSI_TPG[1] - Added ACL with TCQ Depth: 16 for iSCSI Initiator Node: iqn.1994-05.com.redhat.cluster3
[211170.653920] iSCSI_TPG[1]_LUN[0->0] - Added RW ACL for  InitiatorNode: iqn.1994-05.com.redhat.cluster3

but also still enabling 'demo mode' on the TargetName
+TargetPortalGroupTag endpoint with:

[211169.875750] iSCSI_TPG[1] - Generate Initiator Portal Group ACLs: Enabled

and then further below the initiators login using DYNAMIC demo mode ACLS
with the 'real' initiator side IQNs: (notice the missing :$UUID from the
above NodeACLs)

[211285.856884] TARGET_CORE[iSCSI]->TPG[1]_LUN[0] - Adding READ-WRITE access for LUN in Demo Mode
[211285.857028] iSCSI_TPG[1] - Added DYNAMIC ACL with TCQ Depth: 16 for iSCSI Initiator Node: iqn.1994-05.com.redhat.cluster2:b8a10d027e1

...

[211290.164798] TARGET_CORE[iSCSI]->TPG[1]_LUN[0] - Adding READ-WRITE access for LUN in Demo Mode
[211290.164816] iSCSI_TPG[1] - Added DYNAMIC ACL with TCQ Depth: 16 for iSCSI Initiator Node: iqn.1994-05.com.redhat.cluster1:7f3715a3da22


For proper production PR usage you really, *really* want to use explict NodeACLs with the
correct Initiator IQN names and disable demo mode all together.  However, it is possible to use
demo-mode with PR ops for non production (eg: testing) purposes, but it is not as nearly well
tested as using Explict Node ACLs.

So that said, there are two more tests I would like you to run to help isolate this particular
issue wrt to PR operation with demo mode (eg: generate_node_acls=1)

*) Please go ahead and enable 'cache_dynamic_acls' for the TargetName+TargetPortalGroupTag endpoint
with the following and retest using the Vertias test suite.

echo 1 > /sys/kernel/config/target/iscsi/iqn.2010.ar.com.zumbi:disk0/tpgt_1/attrib/cache_dynamic_acls

This will keep around the dynamically generated struct se_node_acls
which does have an effect on certain PR operations, but thus far you are
the first to the NULL pointer deference issue with demo mode PR
operation.

*) From there, go ahead and disable demo mode all together for the TargetName+TargetPortalGroupTag
endpoint with:

echo 0 > /sys/kernel/config/target/iscsi/iqn.2010.ar.com.zumbi:disk0/tpgt_1/attrib/generate_node_acls

and fix the NodeACLs to match the actual initiator side IQNs and retest again.

I am quite certain the proper Explict NodeACLs will work fine, but what is more interesting
is to see if generate_node_nacls and cache_dynamic_acls=1 has an effect on the NULL pointer
deference.

Please let me know both test results and I should be able to come up with a patch from there..

Thanks!

--nab

