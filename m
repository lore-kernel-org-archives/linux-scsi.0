From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Persistent Reservations + SCSI Initiator Port TransportIDs
Date: Thu, 27 Aug 2009 04:58:28 -0700
Message-ID: <1251374308.26147.430.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:26983 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751981AbZH0L62 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2009 07:58:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

Hi Guys,

After making the ISID lower case conversion specification commit to
fabric dependent code in iscsi_target_mod.ko earlier this morning:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=c00b09d52bb164a4c420f5ef8697e966c13dbd5e

I started thinking a bit more and thought perhaps doing the lower case
conversion for ISIDs received as part of the iSCSI Initiator Port
TransportID (InitiatorName w/ ISID) when handling PROUT REGISTER
+SPEC_I_PT=1 and PROUT REGISTER_AND_MOVE in generic target_core_mod.ko
PR code might also be in order, here is what I was thinking:

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 252f1af..7715996 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1101,7 +1101,7 @@ static int core_scsi3_decode_spec_i_port(
                                        &dest_iport[0], 64);    
                        spin_unlock(&dest_node_acl->nacl_sess_lock);
                        
-                       if (strcmp(dest_iport, iport_ptr)) {
+                       if (strcmp(dest_iport, tolower(iport_ptr))) {
                                printk(KERN_ERR "SPC-3 SPEC_I_PT: dest_iport:"
                                        " %s and iport_ptr: %s do not match!\n",
                                        dest_iport, iport_ptr);
@@ -2853,7 +2853,7 @@ static int core_scsi3_emulate_pro_register_and_move(
                                        &dest_iport[0], 64);
                spin_unlock(&dest_node_acl->nacl_sess_lock);
 
-               if (strcmp(dest_iport, iport_ptr)) {
+               if (strcmp(dest_iport, tolower(iport_ptr))) {
                        printk(KERN_ERR "SPC-3 PR REGISTER_AND_MOVE:"
                                " dest_iport: %s and iport_ptr: %s do not"
                                " match!\n", dest_iport, iport_ptr);


What this code does for the iSCSI fabric case with a received iSCSI Initiator Port TransportID
(InitiatorName w/ ISID) is compare the extracted ISID (iport_ptr) against the ISID from the
running iSCSI session if one exists (dest_iport) for a Initiator ACL located from the InitiatorName
value in the iSCSI Initiator Port TransportID that is getting processed.

Obviously, I want to keep the target_core_mod PR code as fabric independent as possible
for future fabric module developments, and since there are currently no other SCSI fabric
TransportIDs that function the same way as the iSCSI Initator Port TransportID (see below),
and I think it should be safe to add tolower() for the above case to prevent any potential future
issues with with ISID comparision in the above two PROUT cases where the initiators might not
always be using sg_persist.  ;-)

Also, note that other SCSI fabrics beside iSCSI would have iport_ptr set to NULL and function
in the same manner as if the iSCSI Initiator Device TransportID (InitiatorName w/o ISID) was
received by NOT explictly checking for an existing active I_T Nexus (which is what the iSCSI
Initiator Port TransportID is intended to be used for) before processing the received PROUT
operation.

Any thoughts on this..?

--nab

