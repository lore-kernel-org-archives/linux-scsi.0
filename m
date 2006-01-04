From: Mike Christie <michaelc@cs.wisc.edu>
Subject: scsi scan bug when peripheral qualifier of 3 is returned
Date: Wed, 04 Jan 2006 01:11:06 -0600
Message-ID: <43BB750A.5050000@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60035 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S964861AbWADHLN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2006 02:11:13 -0500
Received: from [192.168.0.5] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id k047BCnU007978
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 4 Jan 2006 01:11:12 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

It looks like in previous kernels scsi_scan_target would pass 
scsi_sequential_lun_scan BLIST_SPARSELUN.

         } else if (res == SCSI_SCAN_TARGET_PRESENT) {
                 /*
                  * There's a target here, but lun 0 is offline so we
                  * can't use the report_lun scan.  Fall back to a
                  * sequential lun scan with a bflags of SPARSELUN and
                  * a default scsi level of SCSI_2
                  */
                 scsi_sequential_lun_scan(starget, BLIST_SPARSELUN,


And in the current kernel we pass it bflags.

                         /*
                          * The REPORT LUN did not scan the target,
                          * do a sequential scan.
                          */
                         scsi_sequential_lun_scan(starget, bflags,


But for SCSI_SCAN_TARGET_PRESENT bflags is not set. Is the correct fix 
to move where bflagsp gets set in scsi_probe_and_add_lun so that it gets 
set for the SCSI_SCAN_TARGET_PRESENT case, or should __scsi_scan_target 
be passing scsi_sequential_lun_scan and possibly scsi_report_lun_scan 
some default bflags values?
