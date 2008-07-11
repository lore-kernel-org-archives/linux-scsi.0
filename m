From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 02/18] qla2xxx: Add
	dev_loss_tmo_callbk/terminate_rport_io callback support.
Date: Fri, 11 Jul 2008 10:49:31 -0700
Message-ID: <20080711174931.GA55164@plap4-2.local>
References: <20080710235458.GQ29099@plap4-2.local> <1215734163-40825-2-git-send-email-andrew.vasquez@qlogic.com> <48779A51.5070403@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:33691 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbYGKRtd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jul 2008 13:49:33 -0400
Content-Disposition: inline
In-Reply-To: <48779A51.5070403@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Seokmann Ju <seokmann.ju@qlogic.com>

On Fri, 11 Jul 2008, Mike Christie wrote:

> Andrew Vasquez wrote:
>> +static void
>> +qla2x00_terminate_rport_io(struct fc_rport *rport)
>> +{
>> +	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
>> +
>> +	qla2x00_abort_fcport_cmds(fcport);
>
>
> Hey, I was also wondering how we get commands still in the driver at this 
> point? I was doing some testing on my patches and could not hit it. Does it 
> only occur with things like tape commands or what type of errors would 
> block/remove the rport but not end up failing the commands at the time the 
> error is detected? Like with the CS_TIMEOUT case I hit here
> http://marc.info/?l=linux-scsi&m=121263015108620&w=2
> the IO is failed right away, so when I got to where the terminate callback 
> is called there was no IO in the driver.

Yes, typically, the firmware will return all I/Os of a given lost
port.  The exception is FCP2 commands (FC-tape) where additional
recovery (via REC) can be used to recover from short-term link-loss.

--
av
