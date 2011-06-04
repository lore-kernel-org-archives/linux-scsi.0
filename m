From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/2] target/iscsi: Convert to RX context task mapping+queueing
Date: Fri,  3 Jun 2011 23:01:28 -0700
Message-ID: <1307167290-24832-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm20-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.29]:39999
	"HELO nm20-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751063Ab1FDGBq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Jun 2011 02:01:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi again Andy and Christoph,

These are two additional patches I am pushing into lio-core-2.6.git/master
for LIO v4.1 to properly enable the RX side direct queueing optimization with
iSCSI READs and non immediate iSCSI WRITE payloads.  Note the logic to enable
this for all cases was not merged originally in Patch #39 from Andy's series.

So for the moment in Patch #1, the optimization has been added as a seperate
new caller: transport_handle_cdb_direct(), and transport_generic_handle_cdb() has
been left as-is for existing fabric code (namely tcm_fc, ib_srpt and ibmvscsis)
that have not tested with these changes so far.

The other changes in Patch #2 are specific to iscsi-target for enabling
transport_handle_cdb_direct() usage.  This involves converting to a sleeping
sess->cmdsn_mutex for protecting the session wide CmdSN list in the path:

	iscsit_sequence_cmd() ->
		iscsit_execute_cmd() ->
			transport_handle_cdb_direct() ->
				transport_generic_new_cmd()

This is required because iscsit_execute_cmd() is being called with the CmdSN
lock held, and spinning here was causing issues during testing as we may
end up sleeping inside of transport_generic_new_cmd() while performing
allocations in transport_new_cmd_obj() -> transport_allocate_tasks().

Please have a look,

Thanks!

--nab

Nicholas Bellinger (2):
  target: Add transport_handle_cdb_direct optimization
  iscsi-target: Convert to cmdsn_mutex and transport_handle_cdb_direct
    usage

 drivers/target/iscsi/iscsi_target_core.h   |    2 +-
 drivers/target/iscsi/iscsi_target_device.c |    4 ++--
 drivers/target/iscsi/iscsi_target_erl1.c   |   18 +++++++++---------
 drivers/target/iscsi/iscsi_target_erl2.c   |    4 ++--
 drivers/target/iscsi/iscsi_target_login.c  |    2 +-
 drivers/target/iscsi/iscsi_target_nego.c   |    4 ++--
 drivers/target/iscsi/iscsi_target_util.c   |    4 ++--
 drivers/target/target_core_transport.c     |   24 ++++++++++++++++++++++++
 include/target/target_core_transport.h     |    1 +
 9 files changed, 44 insertions(+), 19 deletions(-)

-- 
1.7.2.5

