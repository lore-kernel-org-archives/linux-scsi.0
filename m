From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: rep lun scan if LUN 0 not connected
Date: Mon, 20 Sep 2004 09:19:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040920161901.GA3355@beaverton.ibm.com>
References: <20040917220558.GA5764@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-218-173.dsl.aracnet.com ([216.99.218.173]:1923 "EHLO
	palm2") by vger.kernel.org with ESMTP id S266793AbUITQTR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Sep 2004 12:19:17 -0400
Content-Disposition: inline
In-Reply-To: <20040917220558.GA5764@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Sat, Sep 18, 2004 at 12:05:58AM +0200, Kurt Garloff wrote:
> Hi,
> 
> is there any special reason for this code in scsi_scan_target() ?
> 
> 	/*
> 	 * Scan LUN 0, if there is some response, scan further. Ideally, we
> 	 * would not configure LUN 0 until all LUNs are scanned.
> 	 */
> 	res = scsi_probe_and_add_lun(shost, channel, id, 0, &bflags, &sdev,
> 				     rescan);
> 	if (res == SCSI_SCAN_LUN_PRESENT) {
> 		if (scsi_report_lun_scan(sdev, bflags, rescan) != 0)
> 			/*
> 			 * The REPORT LUN did not scan the target,
> 			 * do a sequential scan.
> 			 */
> 			scsi_sequential_lun_scan(shost, channel, id, bflags,
> 				       	res, sdev->scsi_level, rescan);
> 	} else if (res == SCSI_SCAN_TARGET_PRESENT) {
> 		/*
> 		 * There's a target here, but lun 0 is offline so we
> 		 * can't use the report_lun scan.  Fall back to a
> 		 * sequential lun scan with a bflags of SPARSELUN and
> 		 * a default scsi level of SCSI_2
> 		 */
> 		scsi_sequential_lun_scan(shost, channel, id, BLIST_SPARSELUN,
> 				SCSI_SCAN_TARGET_PRESENT, SCSI_2, rescan);
> 	}
> 
> The return values from scsi_probe_and_add_lun() are
>  *     SCSI_SCAN_NO_RESPONSE: could not allocate or setup a Scsi_Device
>  *     SCSI_SCAN_TARGET_PRESENT: target responded, but no device is
>  *         attached at the LUN
>  *     SCSI_SCAN_LUN_PRESENT: a new Scsi_Device was allocated and initialized
> 
> I don't see a reason not to try scsi_report_lun_scan() if the target
> is present, but does not report to support a unit at LUN number 0. 
> 
> Is there anything I overlooked in SPC3? Or any devices which behave
> in strange ways?

Normal.

> I have come across a device recently (HITACHI F500F) that does report
> PQ/PDevTp 3/0x1f on LUN 0, and does return a perfectly sensible answer
> (*) on REPORT_LUNS sent down to the target LUN 0. Actually, the raid 
> storage devs I came across all react reasonably to REPORT_LUNS despite 
> their behaviour on LUN 0 was varying. PQ/PDevTp = 0/3, 1/3 were the 
> other popular answers. 
> 
> (*) Some devs sent strange LUN formats that Linux does not reasonably
>  convert to a 32bit integer. We should move on to using opaque 8byte
>  LUN handles some day.
> 
> So I would suggest to remove the special case for
> SCSI_SCAN_TARGET_PRESENT and just use
> 	if (res != SCSI_SCAN_NO_RESPONSE) {
> 		if (scsi_report_lun_scan(sdev, bflags, rescan) != 0)
> 
> 
> Flames? Patch wanted?

Patch. Older code always did the REPORT LUNS if there was any target
response at all.

The sdev is deleted if SCSI_SCAN_TARGET_PRESENT, so some hack is required
to keep LUN 0 or ???.
