From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 02/18] qla2xxx: Add dev_loss_tmo_callbk/terminate_rport_io
 callback support.
Date: Fri, 11 Jul 2008 12:32:36 -0500
Message-ID: <48779934.8020000@cs.wisc.edu>
References: <20080710235458.GQ29099@plap4-2.local> <1215734163-40825-2-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48734 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554AbYGKRcq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2008 13:32:46 -0400
In-Reply-To: <1215734163-40825-2-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Andrew Vasquez wrote:
> +
> +static void
> +qla2x00_terminate_rport_io(struct fc_rport *rport)
> +{
> +	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
> +
> +	qla2x00_abort_fcport_cmds(fcport);
> +	scsi_target_unblock(&rport->dev);

I sent a patch so the unblock is always done by the fc class.
http://marc.info/?l=linux-scsi&m=121263015008613&w=2

Could we do that instead so qlogic and emulex and all other drivers 
behave the same?

Here are the other patches in that patchset:

http://marc.info/?l=linux-scsi&m=121263014908607&w=2
http://marc.info/?l=linux-scsi&m=121263014908610&w=2
http://marc.info/?l=linux-scsi&m=121263015008613&w=2
http://marc.info/?l=linux-scsi&m=121263015008616&w=2
http://marc.info/?l=linux-scsi&m=121263015108620&w=2
http://marc.info/?l=linux-scsi&m=121263015108623&w=2
http://marc.info/?l=linux-scsi&m=121263015208626&w=2
