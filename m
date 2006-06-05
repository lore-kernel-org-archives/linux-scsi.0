From: Roland Dreier <rdreier@cisco.com>
Subject: RFC: Add I/O class enum values to <scsi/srp.h>
Date: Mon, 05 Jun 2006 12:17:59 -0700
Message-ID: <adaodx7o1i0.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-5.cisco.com ([171.68.10.87]:53841 "EHLO
	sj-iport-5.cisco.com") by vger.kernel.org with ESMTP
	id S1751292AbWFETSC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jun 2006 15:18:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: openib-general@openib.org

Does anyone have an objection to me merging the trivial patch below
through my git tree?  This will be used by the IB SRP initiator to
work with SilverStorm targets, which still implement rev. 10 of the
SRP spec.  I could just make these values private to the IB initiator,
but I figured that things directly from the SRP spec belong in
<scsi/srp.h> rather than in a particular driver's private header.

Thanks,
  Roland

diff-tree a13ac0e9f99636a043d197f3349a67303ce4a701 (from bb61dd1fbf59f2291295986bed1f99b48f513fa4)
Author: Ramachandra K <rkuchimanchi@silverstorm.com>
Date:   Mon Jun 5 12:13:52 2006 -0700

    [SCSI] srp.h: Add I/O Class values
    
    Add enum values for I/O Class values from rev. 10 and rev. 16a SRP
    drafts.  The values are used to detect targets that implement obsolete
    revisions of SRP, so that the initiator can use the old format for
    port identifier when connecting to them.
    
    Signed-off-by: Ramachandra K <rkuchimanchi@silverstorm.com>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

diff --git a/include/scsi/srp.h b/include/scsi/srp.h
index 637f77e..ad178fa 100644
--- a/include/scsi/srp.h
+++ b/include/scsi/srp.h
@@ -87,6 +87,11 @@ enum srp_login_rej_reason {
 	SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED		= 0x00010006
 };
 
+enum {
+	SRP_REV10_IB_IO_CLASS	= 0xff00,
+	SRP_REV16A_IB_IO_CLASS	= 0x0100
+};
+
 struct srp_direct_buf {
 	__be64	va;
 	__be32	key;
