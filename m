From: Krishna Murthy <krmurthy@cisco.com>
Subject: scsi_scan_target and SCSI_2
Date: Thu, 27 Nov 2003 18:49:15 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200311271849.15241.krmurthy@cisco.com>
References: <200311252037.34015.krmurthy@cisco.com> <1069773808.2061.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:52100 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S264512AbTK0NUf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Nov 2003 08:20:35 -0500
Received: from krmurthy1-lnx.cisco.com (krmurthy1-lnx.cisco.com [10.77.7.60])
	by india-msg-core-1.cisco.com (8.12.9/8.12.6) with ESMTP id hARIm70s014532
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2003 18:48:08 GMT
In-Reply-To: <1069773808.2061.6.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: davmyers@cisco.com

Hi,

scsi_probe_lun() does find out whether a target is SCSI_2 or SCSI_3.
The follg is the code from the function which does that.

-------------------------------------------
sdev->scsi_level = inq_result[2] & 0x07;
        if (sdev->scsi_level >= 2 ||
            (sdev->scsi_level == 1 && (inq_result[3] & 0x0f) == 1))
                sdev->scsi_level++;
---------------------------------------------
Looks like this information is not preserved long enough to be used properly
in case LUN 0 is offline.

The follg is the call sequence

scsi_scan_host_selected()
	|
scsi_scan_channel()
	|
scsi_scan_target()  ->
			
			res = scsi_probe_and_add_lun ( lun 0)
			if res == SCSI_SCAN_TARGET_PRESENT
				scsi_sequential_lun_scan

scsi_probe_and_add_lun() calls scsi_probe_lun(). In case there is no lun 0
then the information about scsi_level is lost.
----------------------------------------------------------------------
/*
         * result contains valid SCSI INQUIRY data.
         */
        if ((result[0] >> 5) == 3) {
                /*
                 * For a Peripheral qualifier 3 (011b), the SCSI
                 * spec says: The device server is not capable of
                 * supporting a physical device on this logical
                 * unit.
                 *
                 * For disks, this implies that there is no
                 * logical disk configured at sdev->lun, but there
                 * is a target id responding.
                 */
                SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
                                        "scsi scan: peripheral qualifier of 
3,"
                                        " no device added\n"));
                res = SCSI_SCAN_TARGET_PRESENT;
                goto out_free_result;
        }
------------------------------------------------------------------------------
We now call scsi_sequential_lun_scan() with BLIST_SPARSELUN,SCSI_2 as 
parameters, which instead should have been bflags,scsi_level as determined by 
scsi_probe_lun.

Isn't this is  a bug? Please let me know if I am missing something.

Thanx
N.C.Krishna Murthy










