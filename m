From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/10] scsi: Do not display buffer pointers in scsi_log_send()
Date: Mon, 17 Nov 2014 10:14:20 +0100
Message-ID: <5469BC6C.3070601@suse.de>
References: <1415262639-121586-1-git-send-email-hare@suse.de> <1415262639-121586-11-git-send-email-hare@suse.de> <94D0CD8314A33A4D9D801C0FE68B4029593A8697@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbaKQJOX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2014 04:14:23 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029593A8697@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 11/14/2014 11:53 PM, Elliott, Robert (Server Storage) wrote:
>=20
>=20
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Thursday, 06 November, 2014 2:31 AM
>> To: James Bottomley
>> Cc: Christoph Hellwig; Ewan Milne; Elliott, Robert (Server Storage);
>> linux-scsi@vger.kernel.org; Hannes Reinecke
>> Subject: [PATCH 10/10] scsi: Do not display buffer pointers in
>> scsi_log_send()
>>
>> scsi_log_send() would display buffer pointer for higher
>> logging levels. This is not only of questionable value
>> but also exposes kernel pointer to userspace, which is
>> discouraged in some setups. So drop this message
>> altogether.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/scsi.c | 9 +--------
>>  1 file changed, 1 insertion(+), 8 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>> index 92d5912..9ec576d 100644
>> --- a/drivers/scsi/scsi.c
>> +++ b/drivers/scsi/scsi.c
>> @@ -531,7 +531,7 @@ void scsi_log_send(struct scsi_cmnd *cmd)
>>  	 *
>>  	 * 3: same as 2
>>  	 *
>> -	 * 4: same as 3 plus dump extra junk
>> +	 * 4: same as 3
>>  	 */
>>  	if (unlikely(scsi_logging_level)) {
>>  		level =3D SCSI_LOG_LEVEL(SCSI_LOG_MLQUEUE_SHIFT,
>> @@ -540,13 +540,6 @@ void scsi_log_send(struct scsi_cmnd *cmd)
>>  			scmd_printk(KERN_INFO, cmd,
>>  				    "Send: scmd 0x%p\n", cmd);
>>  			scsi_print_command(cmd);
>> -			if (level > 3) {
>> -				printk(KERN_INFO "buffer =3D 0x%p, bufflen =3D
>> %d,"
>> -				       " queuecommand 0x%p\n",
>> -					scsi_sglist(cmd), scsi_bufflen(cmd),
>> -					cmd->device->host->hostt-
>>> queuecommand);
>> -
>> -			}
>>  		}
>>  	}
>>  }
>=20
> Reviewed-by: Robert Elliott <elliott@hp.com>
>=20
> One more comment on the series:
>=20
> After the tags, there are still a few scmd %p prints left
> including the one above.  Is this series supposed to get
> rid of the rest of them?
>=20
> drivers/scsi/scsi.c:                                "Send: scmd 0x%p\=
n", cmd);
> drivers/scsi/scsi_error.c:                                  "scmd %p =
eh timeout, not aborting\n",
> drivers/scsi/scsi_error.c:                                  "aborting=
 command %p\n", scmd));
> drivers/scsi/scsi_error.c:                                           =
       "scmd %p eh timeout, "
> drivers/scsi/scsi_error.c:                                           =
       "scmd %p retry "
> drivers/scsi/scsi_error.c:                                           =
       "scmd %p finish "
> drivers/scsi/scsi_error.c:                                          "=
scmd %p abort %s\n", scmd,
> drivers/scsi/scsi_error.c:                                  "scmd %p =
terminate "
> drivers/scsi/scsi_error.c:                                  "scmd %p =
previous abort failed\n", scmd));
> drivers/scsi/scsi_error.c:                                  "scmd %p =
not aborting, host in recovery\n",
> drivers/scsi/scsi_error.c:                          "scmd %p abort sc=
heduled\n", scmd));
> drivers/scsi/scsi_error.c:                      "%s scmd: %p result: =
%x\n",
> drivers/scsi/scsi_error.c:                      "%s: scmd: %p, timele=
ft: %ld\n",
> drivers/scsi/scsi_error.c:                      "sense requested for =
%p result %x\n",
> drivers/scsi/scsi_error.c:              "%s: scmd %p rtn %x\n", __fun=
c__, scmd, rtn));
> drivers/scsi/scsi_error.c:                                           =
"%s: flush retry cmd: %p\n",
> drivers/scsi/scsi_error.c:                                           =
"%s: flush finish cmd: %p\n",
> drivers/scsi/scsi_lib.c:                "Inserting command %p into ml=
queue\n", cmd));
> drivers/scsi/scsi_scan.c:               printk(KERN_WARNING "%s no sl=
ave_alloc function in hostt %p\n", __func__, shost->hostt);
> drivers/scsi/scsi_scan.c:               printk(KERN_WARNING "sdev %p =
scmd %p sending INQUIRY\n", sdev, scsi_cmd);
> drivers/scsi/scsi_scan.c:               printk(KERN_WARNING "%s sdev =
%p from lookup_by_target\n", __func__, sdev);
> drivers/scsi/scsi_scan.c:               printk(KERN_WARNING "%s sdev =
%p from alloc_sdev\n", __func__, sdev);
> drivers/scsi/scsi_scan.c:               printk(KERN_WARNING "%s sdev =
%p from alloc_sdev\n", __func__, sdev);
> drivers/scsi/scsi_scan.c:               printk(KERN_WARNING "%s sdev =
%p from lookup_by_target\n", __func__, sdev);
> drivers/scsi/scsi_scan.c:       printk(KERN_WARNING "%s sdev %p from =
alloc_sdev\n", __func__, sdev);
>=20
Ideally, yes. However, for this to work we need an additional means
of identifying the command uniquely.
With the current infrastructure 'tags' are only ever assigned for
devices using the SCSI TCQ mechanism. Everything else is left in the
dark, even though it might be allowing for a queue depths > 1.
So I'll need to revisit this now that the tag rework from Christoph
Hellwig is in.
But I'd rather have this postponed to a next patch series. That
series would also included the proposed 'SUCCESS' to 'COMPLETE' change.

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
