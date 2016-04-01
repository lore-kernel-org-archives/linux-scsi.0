From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: fnic: Using rport->dd_data to check rport online instead of
 rport_lookup.
Date: Fri, 1 Apr 2016 22:44:45 +0300
Message-ID: <20160401194445.GA21247@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24428 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbcDATox (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2016 15:44:53 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: satishkh@cisco.com
Cc: linux-scsi@vger.kernel.org

Hello Satish Kharat,

This is a semi-automatic email about new static checker warnings.

The patch ce4b9e8980fa: "fnic: Using rport->dd_data to check rport 
online instead of rport_lookup." from Mar 18, 2016, leads to the 
following Smatch complaint:

drivers/scsi/fnic/fnic_scsi.c:457 fnic_queuecommand_lck()
	 warn: variable dereferenced before check 'rport' (see line 449)

drivers/scsi/fnic/fnic_scsi.c
   448		rport = starget_to_rport(scsi_target(sc->device));
   449		ret = fc_remote_port_chkready(rport);
                                              ^^^^^
Old dereference (inside function call).

   450		if (ret) {
   451			atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
   452			sc->result = ret;
   453			done(sc);
   454			return 0;
   455		}
   456	
   457		if (rport) {
                    ^^^^^
The patch adds a check but too late.  Probably just delete the check?

   458			struct fc_rport_libfc_priv *rp = rport->dd_data;
   459	

regards,
dan carpenter
