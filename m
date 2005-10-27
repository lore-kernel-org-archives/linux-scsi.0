From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/2] libata: Remove dependence on host_set->dev for SAS
Date: Thu, 27 Oct 2005 11:05:21 -0500
Message-ID: <4360FAC1.8020409@us.ibm.com>
References: <4341A91A.3020000@us.ibm.com> <434251E0.9060000@pobox.com>	 <58cb370e0510040322q1cb7a13bjfc6c7875140d20a9@mail.gmail.com> <58cb370e0510041356h780e7a5aifda0c232f677471e@mail.gmail.com> <43443E99.4090008@pobox.com> <435D5D83.1060201@us.ibm.com> <435D5DE5.7010306@us.ibm.com> <435E7105.4010105@pobox.com> <435E87E8.9010506@us.ibm.com> <435E8AC7.1080407@pobox.com> <435EB656.1040502@adaptec.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <435EB656.1040502@adaptec.com>
Sender: linux-ide-owner@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> Would it be a good idea to abstract most of this in
> say something like 
> 
> 	struct satl_device_struct {
> 		-- data... ;
> 		
> 		/* The registering entity calls this for SATL to translate
> 		   to an ATA task(s) and execute. Filled in by the SATL Layer. */
> 		int (*execute_scsi_task)(struct satl_device_struct *, struct scsi_cmnd *);
> 		
> 		/* SATL layer calls this to send an ata_task to the device.
> 		   Filled in by the registering entity. */
> 		int (*execute_ata_task)(struct satl_device_struct *, struct ata_task *);
> 
> 		-- recovery methods common to SATA-over-anything; filled in by registering
> 			\ entity
> 	};
> 
> (ata task to be properly constructed: FIS, sg lists, etc.)
> 
> Then libata-scsi would only have to export two (2) functions:
> 
> int  satl_register_device(struct satl_device_struct *);
> void satl_unregister_device(struct satl_device_struct *);
> 
> EXPORT_SYMBOL_GPL(satl_register_device);
> EXPORT_SYMBOL_GPL(satl_unregister_device);

Where would you be calling satl_register_device in your SAS class?

It looks like this would force libata to be the one to attach the ULD,
which would also force it to create a separate scsi_host for each
device, which is something I wanted to avoid. I think you really need a
libata API that the LLDD can call from its queuecommand function
to translate and send a command, which then calls back into the LLDD
to send the FIS to the hardware. This allows for all SAS/SATA devices
under the same HBA to show up under the same scsi_host.


Brian


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center




