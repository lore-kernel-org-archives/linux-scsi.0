From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 0/2] libata: support SATA devices on SAS HBAs
Date: Tue, 25 Oct 2005 08:59:17 -0400
Message-ID: <435E2C25.10009@adaptec.com>
References: <4341A91A.3020000@us.ibm.com> <434251E0.9060000@pobox.com>	 <58cb370e0510040322q1cb7a13bjfc6c7875140d20a9@mail.gmail.com> <58cb370e0510041356h780e7a5aifda0c232f677471e@mail.gmail.com> <43443E99.4090008@pobox.com> <435D5D83.1060201@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:63437 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751161AbVJYM7f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Oct 2005 08:59:35 -0400
In-Reply-To: <435D5D83.1060201@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: Jeff Garzik <jgarzik@pobox.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On 10/24/05 18:17, Brian King wrote:
> The following patches enhance libata to allow SAS device drivers
> to utilize libata to talk to SATA devices. It introduces some
> new APIs which allow libata to be used without allocating a
> virtual scsi host. In the context of SAS, a struct ata_port
> is not a physical port, but rather becomes a virtual construct.
> 
> Since my last post, I have removed the dependence on the host_set
> struct. The following two patches depend on the qc_transport patch:
> 
> http://marc.theaimsgroup.com/?l=linux-ide&m=112845939215286&w=2
> 
> The API is the same as the last time I posted it to linux-ide,
> but here is the description again:
> 
> New APIs:
> 
> ata_sas_port_alloc - Allocate an ata_port 
> ata_sas_port_init - Initialize an ata_port (probe device, etc)
> ata_sas_port_destroy - Free an ata_port allocated by ata_sas_port_alloc
> ata_sas_slave_configure - configure scsi device
> ata_sas_queuecmd - queue a scsi command, similar to ata_scsi_queuecomand
> 
> These new APIs can be used either directly by a SAS LLDD or could be used
> by the SAS transport class. 
> 
> Possible usage for a SAS LLDD would be:
> 
> scsi_scan_host
> 	slave_alloc
> 		ata_sas_port_alloc
> 		ata_sas_port_init
> 	slave_configure
> 		ata_sas_slave_configure
> 
> Commands received by the LLDD for SATA devices would call ata_sas_queuecmd.
> 
> Device teardown would occur with:
> 
> slave_destroy
> 	ata_sas_port_destroy

Hey Brian,

That's admireable effort.  Is there a git tree I can pull from which has
these patches?  (I don't mind using the patches themselves as well.)

I'll take a look indepth and comment further.

Thanks,
	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
