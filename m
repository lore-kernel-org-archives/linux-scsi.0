From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 1/2] libata: Remove dependence on host_set->dev for SAS
Date: Tue, 25 Oct 2005 18:48:54 -0400
Message-ID: <435EB656.1040502@adaptec.com>
References: <4341A91A.3020000@us.ibm.com> <434251E0.9060000@pobox.com>	 <58cb370e0510040322q1cb7a13bjfc6c7875140d20a9@mail.gmail.com> <58cb370e0510041356h780e7a5aifda0c232f677471e@mail.gmail.com> <43443E99.4090008@pobox.com> <435D5D83.1060201@us.ibm.com> <435D5DE5.7010306@us.ibm.com> <435E7105.4010105@pobox.com> <435E87E8.9010506@us.ibm.com> <435E8AC7.1080407@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:59030 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932457AbVJYWtw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Oct 2005 18:49:52 -0400
In-Reply-To: <435E8AC7.1080407@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: brking@us.ibm.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On 10/25/05 15:43, Jeff Garzik wrote:
> Brian King wrote:
> 
>>Or, we just live with the duplication...
> 
> 
> That may be the best practical solution.
> 
> I wonder, additionally, if we need to be getting a reference each time 
> we store the pointer.  Traditionally the struct device object lifetime 
> has always been entirely within the bus device lifetime, but with this 
> new work that may need rethinking.

Would it be a good idea to abstract most of this in
say something like 

	struct satl_device_struct {
		-- data... ;
		
		/* The registering entity calls this for SATL to translate
		   to an ATA task(s) and execute. Filled in by the SATL Layer. */
		int (*execute_scsi_task)(struct satl_device_struct *, struct scsi_cmnd *);
		
		/* SATL layer calls this to send an ata_task to the device.
		   Filled in by the registering entity. */
		int (*execute_ata_task)(struct satl_device_struct *, struct ata_task *);

		-- recovery methods common to SATA-over-anything; filled in by registering
			\ entity
	};

(ata task to be properly constructed: FIS, sg lists, etc.)

Then libata-scsi would only have to export two (2) functions:

int  satl_register_device(struct satl_device_struct *);
void satl_unregister_device(struct satl_device_struct *);

EXPORT_SYMBOL_GPL(satl_register_device);
EXPORT_SYMBOL_GPL(satl_unregister_device);

And the rest are in the struct satl_device_struct for which
translation is being provided.

Thus, error handling can also be "commonalized" as per
the entity registering for the service.

The whole point is to have this at device level as opposed
to libata's port level.  Plus it simplifies the code of entities
registering for this service.

<I was going to draw ascii art, but ran out of time>

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
