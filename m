From: Andrew de Quincey <adq_dvb@lidskialf.net>
Subject: Re: linux kernel panic when ejecting ieee1394 ipod
Date: Thu, 8 Dec 2005 03:19:19 +0000
Message-ID: <200512080319.19434.adq_dvb@lidskialf.net>
References: <200512072358.15398.adq_dvb@lidskialf.net> <200512080209.17757.adq_dvb@lidskialf.net> <43979E1A.30801@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lidskialf.net ([62.3.233.115]:1968 "EHLO mail.lidskialf.net")
	by vger.kernel.org with ESMTP id S1030423AbVLHDTV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2005 22:19:21 -0500
In-Reply-To: <43979E1A.30801@s5r6.in-berlin.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org


> [in sbp2_create_command_orb]
>
> > +	/* check for duff DMA transfer direction with a zero length buffer */
> > +	if (scsi_request_bufflen == 0)
> > +		dma_dir = DMA_NONE;
>
> What if you replace WRITE by READ in
> drivers/scsi/scsi_ioctl.c::scsi_cmd_ioctl()::case CDROMEJECT ?

Yup, using READ there fixes it too (and I did remember to remove my other 
patch before testing :)

USB storage devices still work with the CDROMEJECT ioctl and this change as 
well.

> And BTW, can/should this latter case block be converted to use
> scsi_execute() or scsi_execute_req()?

Can't comment - don't know enough about the linux SCSI subsystem.
