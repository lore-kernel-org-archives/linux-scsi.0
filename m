From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/10] scsi: Move remaining printk() statement to scmd_printk()
Date: Thu, 06 Nov 2014 08:37:14 +0100
Message-ID: <545B252A.5000504@suse.de>
References: <1415088409-46590-1-git-send-email-hare@suse.de> <1415088409-46590-11-git-send-email-hare@suse.de> <20141106072023.GF19721@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40736 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbaKFHhQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2014 02:37:16 -0500
In-Reply-To: <20141106072023.GF19721@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org

On 11/06/2014 08:20 AM, Christoph Hellwig wrote:
> On Tue, Nov 04, 2014 at 09:06:49AM +0100, Hannes Reinecke wrote:
>> One statement was missing from the conversion to dev_printk().
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/scsi.c | 10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>> index 92d5912..9880b59 100644
>> --- a/drivers/scsi/scsi.c
>> +++ b/drivers/scsi/scsi.c
>> @@ -541,10 +541,12 @@ void scsi_log_send(struct scsi_cmnd *cmd)
>>  				    "Send: scmd 0x%p\n", cmd);
>>  			scsi_print_command(cmd);
>>  			if (level > 3) {
>> -				printk(KERN_INFO "buffer =3D 0x%p, bufflen =3D %d,"
>> -				       " queuecommand 0x%p\n",
>> -					scsi_sglist(cmd), scsi_bufflen(cmd),
>> -					cmd->device->host->hostt->queuecommand);
>> +				struct Scsi_Host *shost =3D cmd->device->host;
>> +				scmd_printk(KERN_INFO, cmd,
>> +					    "buffer =3D 0x%p, bufflen =3D %d,"
>> +					    " queuecommand 0x%p\n",
>> +					    scsi_sglist(cmd), scsi_bufflen(cmd),
>> +					    shost->hostt->queuecommand);
>=20
> This printk doesn't look very useful, I'd rather kill it.
>=20
Be my guest.

I'm planning on removing all the references to command pointers
anyway, but for that I'll need a consistent scsi command
enumeration. Your tcq rework should help for that.

But that will be done in a later patch series.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
