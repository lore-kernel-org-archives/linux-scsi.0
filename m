From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH V3 1/4] Encapsulate scsi_do_report_luns
Date: Thu, 7 Mar 2013 17:01:16 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402950DA733C@G9W0745.americas.hpqcorp.net>
References: <1362663515-3476-1-git-send-email-revers@redhat.com>
 <1362663515-3476-2-git-send-email-revers@redhat.com>
 <94D0CD8314A33A4D9D801C0FE68B402950DA726C@G9W0745.americas.hpqcorp.net>
 <5138BB1F.9080904@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:7805 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab3CGRCU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Mar 2013 12:02:20 -0500
In-Reply-To: <5138BB1F.9080904@tributary.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: Rob Evers <revers@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "bvanassche@acm.org" <bvanassche@acm.org>, "emilne@redhat.com" <emilne@redhat.com>

Good point; INQUIRY, REPORT LUNS, REQUEST SENSE, and NOTIFY DATA TRANSFER DEVICE do not report unit attention conditions.

The comment should be changed, since that's not the reason for any retries here:

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


> -----Original Message-----
> From: Jeremy Linton [mailto:jlinton@tributary.com]
> Sent: Thursday, 07 March, 2013 10:07 AM
> To: Elliott, Robert (Server Storage)
> Cc: Rob Evers; linux-scsi@vger.kernel.org; michaelc@cs.wisc.edu;
> bvanassche@acm.org; emilne@redhat.com
> Subject: Re: [PATCH V3 1/4] Encapsulate scsi_do_report_luns
> 
> On 3/7/2013 9:47 AM, Elliott, Robert (Server Storage) wrote:
> 
> >> +int scsi_do_report_luns(struct scsi_device *sdev, int length, +	 * We
> >> can get a UNIT ATTENTION, for example a power on/reset, so +	 *
> retry a
> >> few times (like sd.c does for TEST UNIT READY). +	 * Experience shows
> >> some combinations of adapter/devices get at +	 * least two power
> >> on/resets. +	for (retries = 0; retries < 3; retries++) { +
> >> SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: Sending" +
> 			  "
> >> REPORT LUNS to %s (try %d)\n", devname, +
> retries)); +		result =
> >> scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE, +
> 			  lun_data,
> >> length, &sshdr, +					  SCSI_TIMEOUT + 4 *
> HZ, 3, NULL);
> >
> > There's no guarantee that you'll get no more than two unit attention
> > conditions at any particular time;
> 
> 	Actually, if your getting any unit attentions from a report luns the
> device
> is broken. SAM5 5.14
> 
> "if a REPORT LUNS command enters the enabled command state, the device
> server
> shall process the REPORTS LUNS command and shall not report any unit
> attention
> conditions"
> 
> This is not new behavior either.
> 
> 
> There are a couple other places that say similar things, INQUIRY and REPORT
> LUNS get special status for UA. Which is how you can scan a target/lun
> configuration without interfering with its operation. Personally, I think the
> TUR in the mid layer is incorrect as the TUR functionality needs to be hoisted
> higher up the stack and the mid layer needs to use inquiry to validate device
> communications. (got a patch for that too, but no point in posting it, as it
> will be ignored).
> 

