From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 1/2] libata: Remove dependence on host_set->dev for SAS
Date: Thu, 27 Oct 2005 16:15:49 -0400
Message-ID: <43613575.6000804@adaptec.com>
References: <4341A91A.3020000@us.ibm.com> <434251E0.9060000@pobox.com>	 <58cb370e0510040322q1cb7a13bjfc6c7875140d20a9@mail.gmail.com> <58cb370e0510041356h780e7a5aifda0c232f677471e@mail.gmail.com> <43443E99.4090008@pobox.com> <435D5D83.1060201@us.ibm.com> <435D5DE5.7010306@us.ibm.com> <435E7105.4010105@pobox.com> <435E87E8.9010506@us.ibm.com> <435E8AC7.1080407@pobox.com> <435EB656.1040502@adaptec.com> <4360FAC1.8020409@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4360FAC1.8020409@us.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: brking@us.ibm.com
Cc: Jeff Garzik <jgarzik@pobox.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/27/05 12:05, Brian King wrote:
> Luben Tuikov wrote:
> 
>>Would it be a good idea to abstract most of this in
>>say something like 
>>
>>	struct satl_device_struct {
>>		-- data... ;
>>		
>>		/* The registering entity calls this for SATL to translate
>>		   to an ATA task(s) and execute. Filled in by the SATL Layer. */
>>		int (*execute_scsi_task)(struct satl_device_struct *, struct scsi_cmnd *);
>>		
>>		/* SATL layer calls this to send an ata_task to the device.
>>		   Filled in by the registering entity. */
>>		int (*execute_ata_task)(struct satl_device_struct *, struct ata_task *);
>>
>>		-- recovery methods common to SATA-over-anything; filled in by registering
>>			\ entity
>>	};
>>
>>(ata task to be properly constructed: FIS, sg lists, etc.)
>>
>>Then libata-scsi would only have to export two (2) functions:
>>
>>int  satl_register_device(struct satl_device_struct *);
>>void satl_unregister_device(struct satl_device_struct *);
>>
>>EXPORT_SYMBOL_GPL(satl_register_device);
>>EXPORT_SYMBOL_GPL(satl_unregister_device);
> 
> 
> Where would you be calling satl_register_device in your SAS class?

Just before you register the device with SCSI Core.

> It looks like this would force libata to be the one to attach the ULD,
> which would also force it to create a separate scsi_host for each
> device, which is something I wanted to avoid. I think you really need a

The opposite.  The service provided by SATL would be just translation,
similarly to the SAT spec.  It happens at device level, not port level
as it is done in libata.  It doesn't care about hosts, etc.

There will be only one host.

The whole point of all this is that neither SATL nor the entity
registering for service care about hosts or what-not.  Translation
is done at device level.  It goes like this:
	"Here is a scsi command to be executed, and here is how
	you send tasks to the ATA device.  Translate for me please."

> libata API that the LLDD can call from its queuecommand function
> to translate and send a command, which then calls back into the LLDD
> to send the FIS to the hardware. This allows for all SAS/SATA devices
> under the same HBA to show up under the same scsi_host.

You'd also be able to do the same thing using this infrastructure,
since translation happens at device level.  How and where it is
represented "above" is the caller's (the one who registers with
the service) responsibility.

So, for example, using the SAS Transport Layer/Stack, when SCSI
Core calls the queuecommand() method, we check if it is a SATA
device and if it is we call execute_scsi_task() which was filled in
by SATL upon registration (satl_register_device()).  SATL does
whatever is necessary to simulate this command, calling
execute_ata_task() one or more times.  execute_ata_task() was filled
in by the entity registering for this service (say, the SAS Transport
Layer).  Like so:

	struct satl_device_struct *satl_dev = xalloc(one);
	satl_dev->execute_ata_task = our_execute_ata_task_func;
	satl_dev->... = ...;
	satl_register_device(satl_dev);
	/* Now satl_dev->execute_scsi_task was filled in by SATL,
	   and points to a SATL function which would do translation
	   for the device regsitered.*/

In queuecommand():
	if (dev->dev_type == SATA_DEV)
		dev->satl_dev->execute_scsi_task(dev->satl_dev, scsi_cmnd);
	else
		/* dispatch to SAS layer -- current code */

One thing which may change is that execute_scsi_task() may want to take
something more abstracted like say satl_scsi_task, whereby the completion
method is in the struct -- similarly to the way it is done in
struct sas_task in include/scsi/sas/sas_task.h::178.

Notice how object oriented this is.  Other function stubs which would
live in struct satl_device_struct is the two device resets (depending on
the type of device) and a few more, so that recovery is abstracted away
similarly.  Then the entity registering for the service fills those in
if it has them or if it can implement them.

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
