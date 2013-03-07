From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH V3 1/4] Encapsulate scsi_do_report_luns
Date: Thu, 7 Mar 2013 15:47:56 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402950DA726C@G9W0745.americas.hpqcorp.net>
References: <1362663515-3476-1-git-send-email-revers@redhat.com>
 <1362663515-3476-2-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:30081 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933050Ab3CGPss convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Mar 2013 10:48:48 -0500
In-Reply-To: <1362663515-3476-2-git-send-email-revers@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "bvanassche@acm.org" <bvanassche@acm.org>, "emilne@redhat.com" <emilne@redhat.com>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Rob Evers
> Sent: Thursday, 07 March, 2013 7:39 AM
> To: linux-scsi@vger.kernel.org
> Cc: revers@redhat.com; michaelc@cs.wisc.edu; bvanassche@acm.org;
> emilne@redhat.com
> Subject: [PATCH V3 1/4] Encapsulate scsi_do_report_luns
> 
> ---
>  drivers/scsi/scsi_scan.c | 109 +++++++++++++++++++++++++----------------------
>  1 file changed, 59 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 3e58b22..b2abf22 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> +int scsi_do_report_luns(struct scsi_device *sdev, int length,
> +			struct scsi_lun *lun_data, char *devname)
> +{
> +	unsigned int retries;
> +	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
> +	struct scsi_sense_hdr sshdr;
> +	int result;
> +
> +	scsi_cmd[0] = REPORT_LUNS;
> +
...
> +	/*
> +	 * We can get a UNIT ATTENTION, for example a power on/reset, so
> +	 * retry a few times (like sd.c does for TEST UNIT READY).
> +	 * Experience shows some combinations of adapter/devices get at
> +	 * least two power on/resets.
> +	 *
> +	 * Illegal requests (for devices that do not support REPORT LUNS)
> +	 * should come through as a check condition, and will not generate
> +	 * a retry.
> +	 */
> +	for (retries = 0; retries < 3; retries++) {
> +		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: Sending"
> +				  " REPORT LUNS to %s (try %d)\n", devname,
> +				  retries));
> +		result = scsi_execute_req(sdev, scsi_cmd,
> DMA_FROM_DEVICE,
> +					  lun_data, length, &sshdr,
> +					  SCSI_TIMEOUT + 4 * HZ, 3, NULL);

There's no guarantee that you'll get no more than two unit attention conditions at any particular time; a magic number of 3 retries isn't very robust.  Could this code retry until it stops getting CHECK CONDITION/UNIT ATTENTION?  It should include a much larger worst case number to avoid hangs if the device is truly stuck - maybe 20 times.  For CHECK CONDITION with other sense keys, an early exit is fine.

This may apply to other code too, since the comment mentions it is modeled after sd.c TEST UNIT READY handling.

---
Rob Elliott    HP Server Storage




