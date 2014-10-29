From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 25/27] scsi: check for correct return code in scsi_eh_abort_cmds()
Date: Wed, 29 Oct 2014 08:29:26 +0100
Message-ID: <54509756.5030504@suse.de>
References: <1414153627-2863-1-git-send-email-hare@suse.de> <1414153627-2863-26-git-send-email-hare@suse.de> <94D0CD8314A33A4D9D801C0FE68B402959345AB7@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbaJ2H32 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2014 03:29:28 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402959345AB7@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 10/28/2014 08:04 PM, Elliott, Robert (Server Storage) wrote:
>=20
>=20
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Friday, 24 October, 2014 7:27 AM
>> To: James Bottomley
>> Cc: Christoph Hellwig; Elliott, Robert (Server Storage); linux-
>> scsi@vger.kernel.org; Hannes Reinecke
>> Subject: [PATCH 25/27] scsi: check for correct return code in
>> scsi_eh_abort_cmds()
>>
>> scsi_try_to_abort_cmd() might return SUCCESS, FAILED, or
>> FAST_IO_FAIL. So just checking for FAILED will treat
>> FAST_IO_FAIL as SUCCESS, which is wrong.
>>
>> Cc: Robert Elliott <elliott@hp.com>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/scsi_error.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index fa7b5ec..e94baf1 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -1345,7 +1345,7 @@ static int scsi_eh_abort_cmds(struct list_head
>> *work_q,
>>  			scmd_printk(KERN_INFO, scmd,
>>  				     "%s: aborting cmd\n", current->comm));
>>  		rtn =3D scsi_try_to_abort_cmd(shost->hostt, scmd);
>> -		if (rtn =3D=3D FAILED) {
>> +		if (rtn !=3D SUCCESS) {
>>  			SCSI_LOG_ERROR_RECOVERY(3,
>>  				scmd_printk(KERN_INFO, scmd,
>>  					    "%s: aborting cmd failed\n",
>=20
> The rest of the code in that function is:
> 						current->comm));
> 			list_splice_init(&check_list, work_q);
> 			 return list_empty(work_q);
> 		}	[closing the rtn !=3D SUCCESS block]
> 		scmd->eh_eflags &=3D ~SCSI_EH_CANCEL_CMD;
> 		if (rtn =3D=3D FAST_IO_FAIL)
> 			scsi_eh_finish_cmd(scmd, done_q);
> 		else
> 			list_move_tail(&scmd->eh_entry, &check_list);
> 	}
>=20
> 	return scsi_eh_test_devices(&check_list, work_q, done_q, 0);
> }
>=20
> With this change, if rtn is FAST_IO_FAIL, the=20
> 	return list_empty(work_q);
> will be taken and it'll never get to
> 	if (rtn =3D=3D FAST_IO_FAIL)
>=20
Gnaa. You are correct.

Christoph, please drop this patch.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
