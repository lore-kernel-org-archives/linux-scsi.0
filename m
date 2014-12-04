From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH] scsi_scan: Send TEST UNIT READY to LUN0 before LUN
 scanning
Date: Thu, 4 Dec 2014 20:00:23 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593F57E4@G4W3202.americas.hpqcorp.net>
References: <1417711162-102950-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:43949 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaLDUCc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2014 15:02:32 -0500
In-Reply-To: <1417711162-102950-1-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Martthias Roessler <Matthias.Roessler@ts.fujitsu.com>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Hannes Reinecke
> Sent: Thursday, 04 December, 2014 10:39 AM
...
>  /**
> + * scsi_test_lun - waiting for a LUN to become ready
> + * @sdev:	scsi_device to test
> + *
> + * Description:
> + *     Wait for the lun associated with @sdev to become ready
> + *
> + *     Send a TEST UNIT READY to detect any unit attention conditions.
> + *     Retry TEST UNIT READY for up to @scsi_scan_timeout if the
> + *     returned sense key is 02/04/01 (Not ready, Logical Unit is
> + *     in process of becoming ready)
> + **/
> +static int
> +scsi_test_lun(struct scsi_device *sdev)
> +{
> +	struct scsi_sense_hdr sshdr;
> +	int res = SCSI_SCAN_TARGET_PRESENT;
> +	int tur_result;
> +	unsigned long tur_timeout = jiffies + scsi_scan_timeout * HZ;
> +
> +	/* Skip for older devices */
> +	if (sdev->scsi_level <= SCSI_3)
> +		return SCSI_SCAN_LUN_PRESENT;
> +
> +	/*
> +	 * Wait for the device to become ready.
> +	 *
> +	 * Some targets take some time before the firmware is
> +	 * fully initialized, during which time they might not
> +	 * be able to fill out any REPORT_LUN command correctly.
> +	 * And as we're not capable of handling the
> +	 * INQUIRY DATA CHANGED unit attention correctly we'd
> +	 * rather wait here.
> +	 */
> +	do {
> +		tur_result = scsi_test_unit_ready(sdev, SCSI_TIMEOUT,
> +							  3, &sshdr);
> +		if (!tur_result) {
> +			res = SCSI_SCAN_LUN_PRESENT;
> +			break;
> +		}
> +		if ((driver_byte(tur_result) & DRIVER_SENSE) &&
> +		    scsi_sense_valid(&sshdr)) {
> +			SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
> +				"scsi_scan: tur returned %02x/%02x/%02x\n",
> +				sshdr.sense_key, sshdr.asc, sshdr.ascq));
> +			if (sshdr.sense_key == NOT_READY &&
> +			    sshdr.asc == 0x04 && sshdr.ascq == 0x01) {
> +				/* Logical Unit is in process
> +				 * of becoming ready */
> +				msleep(100);
> +				continue;
> +			}
> +		}

In SAS, you may see these after power on or after sending a
START STOP UNIT command with START=1, as the controller or 
expander is performing staggered spinup:
04h/11h LOGICAL UNIT NOT READY, NOTIFY (ENABLE SPINUP) REQUIRED

Once the drive receives NOTIFY (ENABLE SPINUP), then it starts
reporting this until spinup is done:
04h/01h LOGICAL UNIT IS IN PROCESS OF BECOMING READY

If this function is intended for general "wait for ready" use, 
then it should sit through both codes.

If this function is only intended for drives that violate the
rule to always be capable of returning REPORT LUNS data 
indicating LUN 0, it's hard to guess if 04h/11h could also
appear.  

---
Rob Elliott    HP Server Storage



