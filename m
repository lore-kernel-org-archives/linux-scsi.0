From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: scsi_scan_target and SCSI_2
Date: 27 Nov 2003 09:37:38 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069947459.1837.28.camel@mulgrave>
References: <200311252037.34015.krmurthy@cisco.com>
	<1069773808.2061.6.camel@mulgrave>  <200311271849.15241.krmurthy@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:45316 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262052AbTK0Pht (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Nov 2003 10:37:49 -0500
In-Reply-To: <200311271849.15241.krmurthy@cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Krishna Murthy <krmurthy@cisco.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

On Thu, 2003-11-27 at 07:19, Krishna Murthy wrote:
> scsi_probe_and_add_lun() calls scsi_probe_lun(). In case there is no lun 0
> then the information about scsi_level is lost.

SAM-3 in section 4.9.2 begins "All SCSI devices shall accept LUN 0 as a
valid address...".

This requirement is in SCSI-2 as well.

If your implementation doesn't do this, I suggest you fix it.

If lun 0 responds (as it is required by the standards to do), but shows
only a perfunctory standards conforming response indicating it's not
really present, we scan, and the scsi_level will be recorded for each
correctly scanned lun.

> We now call scsi_sequential_lun_scan() with BLIST_SPARSELUN,SCSI_2 as 
> parameters, which instead should have been bflags,scsi_level as determined by 
> scsi_probe_lun.
> 
> Isn't this is  a bug? Please let me know if I am missing something.

No, it's deliberate.  Whether we should do this is open to debate, but
there's a comment in the code explaining the logic:

		/*
		 * There's a target here, but lun 0 is offline so we
		 * can't use the report_lun scan.  Fall back to a
		 * sequential lun scan with a bflags of SPARSELUN and
		 * a default scsi level of SCSI_2
		 */

James


