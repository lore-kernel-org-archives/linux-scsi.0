From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH 1/3] 2.6.0 aacraid driver update
Date: Wed, 08 Oct 2003 10:43:08 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065634988.5126.7.camel@markh1.pdx.osdl.net>
References: <1065475266.17021.75.camel@markh1.pdx.osdl.net>
	 <3F81E4D8.20904@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:64708 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261507AbTJHRnO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Oct 2003 13:43:14 -0400
In-Reply-To: <3F81E4D8.20904@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Mon, 2003-10-06 at 14:55, Jeff Garzik wrote:
> Mark Haverkamp wrote:
> 
> > +static void aac_io_done(Scsi_Cmnd * scsicmd)
> > +{
> > +	unsigned long cpu_flags;
> > +	struct Scsi_Host *host = scsicmd->device->host;
> > +	spin_lock_irqsave(host->host_lock, cpu_flags);
> > +	scsicmd->scsi_done(scsicmd);
> > +	spin_unlock_irqrestore(host->host_lock, cpu_flags);
> > +}
> 
> Do you really need the host lock to end an IO?

I ran an experiment and found that the host lock is held when the
aac_queuecommand function is called, which calls aac_scsi_cmd.  This
function calls the __aac_io_done without taking the host lock.  The
functions that call the version that take the lock do not already hold
it.  I'm not sure that totally answers the question though but the code
is being consistent in how scsi_done is being called.  Does anyone else
have some thoughts on this?

> 
> 
> > +static void __aac_io_done(Scsi_Cmnd * scsicmd)
> > +{
> > +	scsicmd->scsi_done(scsicmd);
> > +}
> 
> This stuff should be in scsi_lib.c or a header in include/scsi, don't 
> you think?


> 
-- 
Mark Haverkamp <markh@osdl.org>

