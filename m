From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: FCP target reset
Date: Mon, 3 Aug 2009 18:23:03 +0200
Message-ID: <20090803162302.GA9872@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:41681 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398AbZHCQXP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2009 12:23:15 -0400
Received: from d06nrmr1707.portsmouth.uk.ibm.com (d06nrmr1707.portsmouth.uk.ibm.com [9.149.39.225])
	by mtagate4.uk.ibm.com (8.14.3/8.13.8) with ESMTP id n73GN3ZU074324
	for <linux-scsi@vger.kernel.org>; Mon, 3 Aug 2009 16:23:03 GMT
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1707.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n73GN3jU1523760
	for <linux-scsi@vger.kernel.org>; Mon, 3 Aug 2009 17:23:03 +0100
Received: from d06av03.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n73GN3Ma008658
	for <linux-scsi@vger.kernel.org>; Mon, 3 Aug 2009 17:23:03 +0100
Received: from schmichrtp.de.ibm.com (dyn-9-155-23-82.mainz.de.ibm.com [9.155.23.82] (may be forged))
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.12.11) with SMTP id n73GN3Ih008651
	for <linux-scsi@vger.kernel.org>; Mon, 3 Aug 2009 17:23:03 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

While trying to replace the Fibre Channel protocol definitions in
zfcp with the definitions in include/scsi/fc i came across the FCP
target reset flag.

>From what i understand, older versions of the FCP standard defined the
target reset flag, but newer versions do not. Adhering to the newer
standard, the file include/scsi/fc/fc_fcp.h does not define the target
reset.

Does this mean that FC device drivers should not issue target resets
any more?

Some FC device drivers in Linux define the flag:

grep -r FCP_TARGET_RESET *
drivers/s390/scsi/zfcp_dbf.h:	zfcp_scsi_dbf_event(flag == FCP_TARGET_RESET ? "trst" : "lrst", tag, 1,
drivers/s390/scsi/zfcp_def.h:#define FCP_TARGET_RESET	0x20
drivers/s390/scsi/zfcp_scsi.c:	return zfcp_task_mgmt_function(scpnt, FCP_TARGET_RESET);
drivers/scsi/lpfc/lpfc_scsi.c: FCP_TARGET_RESET);
drivers/scsi/lpfc/lpfc_scsi.c: FCP_TARGET_RESET);
drivers/scsi/lpfc/lpfc_scsi.h:#define  FCP_TARGET_RESET    0x20	/* bit 5 */

If the target reset is not required, i would remove it from zfcp. If
it is still required, would adding it to include/scsi/fc/fc_fcp.h make
sense, probably flagged as "obsolete"?

--
Christof Schmitt
