From: Krishna Murthy <krmurthy@cisco.com>
Subject: Peripheral qualifier 1 not considered in scsi_probe_and_add_lun
Date: Thu, 27 Nov 2003 20:26:11 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200311272026.11922.krmurthy@cisco.com>
References: <200311252037.34015.krmurthy@cisco.com> <1069773808.2061.6.camel@mulgrave> <200311271849.15241.krmurthy@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:63376 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S264530AbTK0O5c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Nov 2003 09:57:32 -0500
Received: from krmurthy1-lnx.cisco.com (krmurthy1-lnx.cisco.com [10.77.7.60])
	by india-msg-core-1.cisco.com (8.12.9/8.12.6) with ESMTP id hARKP30s019958
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2003 20:25:04 GMT
In-Reply-To: <200311271849.15241.krmurthy@cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: davmyers@cisco.com

Hi,
In scsi_probe_and_add_lun  we check for Peripheral qualifier 3 (011b).
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
Shouldn't the same apply for peripheral qualifier 1. This is what the SCSI 
spec has to say about 1:
The device server is capable of supporting specified peripheral device type
on this logical unit. However the physical device is currently not connected 
to this logical unit.

Thanx
N.C.Krishna Murthy
