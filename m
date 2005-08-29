From: "Frank Borich" <Frank_Borich@us.xyratex.com>
Subject: Possible bug in qla2xxx rev. 8.00.02
Date: Mon, 29 Aug 2005 11:44:38 -0700
Message-ID: <47F3C2BE74738E4683574107469DFA203B97D8@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratexus12.xyratex.com ([65.203.33.12]:5400 "EHLO
	XYUSEX02.xyus.xyratex.com") by vger.kernel.org with ESMTP
	id S1751295AbVH2SpJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Aug 2005 14:45:09 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have a controller with a firmware bug that mishandles 
underrun situations for inquiry commands. It correctly
sets the FCP_RESID_UNDER flag however it miscalculates
the FCP_RESID count.  The 7.05.00 Qlogic driver for 2.4.x
kernels thinks frame(s) were lost and retries the command
20 times with no success:


 if (!(scsi_status & SS_RESIDUAL_UNDER)) {
                                        ha->dropped_frame_error_cnt++;
                                        CMD_RESULT(cp) = DID_BUS_BUSY <<
16;
                                        DEBUG2(printk(KERN_INFO
"scsi(%ld): Dropped "
                                                "frame(s) detected (%x
of %x "
                                                "bytes)...retrying
command.\n",
                                                ha->host_no,
                                                resid,
                                                CMD_XFRLEN(cp));)
                                        break;
                                }

Just wondering why the 8.00.02 driver for 2.6.x kernels did not
detect this transport error ?  Latest Emulex and LSI drivers did
not detect this either ???

Thanks,
Frank

 
