From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/10] scsi: use per-cpu buffer for formatting sense
Date: Thu, 06 Nov 2014 08:37:53 +0100
Message-ID: <545B2551.2030907@suse.de>
References: <1415088409-46590-1-git-send-email-hare@suse.de> <1415088409-46590-6-git-send-email-hare@suse.de> <20141106073313.GA14854@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaKFHhy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2014 02:37:54 -0500
In-Reply-To: <20141106073313.GA14854@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org

On 11/06/2014 08:33 AM, Christoph Hellwig wrote:
>> +#define scmd_format_header(b, l, d, t) \
>> +	sdev_format_header(b, l, (d) ? (d)->disk_name : NULL, t)
>=20
> I'd rather have a
>=20
> static inline const char *scmd_name(struct scsi_cmnd *scmd)
> {
> 	return scmd->request->rq_disk ?
> 		scmd->request->rq_disk->disk_name : NULL;
> }
>=20
> helper and use that directlu, which also gets rid of all the
> local gendisk variables.
>=20
Ok.

>> +	if (scsi_sense_is_deferred(sshdr))
>> +		off +=3D scnprintf(buffer + off, buf_len - off, "[deferred] ");
>> +	else
>> +		off +=3D scnprintf(buffer + off, buf_len - off, "[current] ");
>=20
> 	off +=3D scnprintf(buffer + off, buf_len - off,
> 		scsi_sense_is_deferred(sshdr) ? "[deferred] " : "[current] ");
>=20
>> +{
>> +	struct scsi_sense_hdr sshdr;
>> +
>> +	if (!scsi_normalize_sense(sense_buffer, sense_len, &sshdr)) {
>> +		int i;
>> +
>> +		for (i =3D 0; i < sense_len; i +=3D 16) {
>> +			char *logbuf;
>> +			int len =3D min(sense_len - i, 16);
>> +			size_t off, logbuf_len;
>> +
>> +			logbuf =3D scsi_log_reserve_buffer(&logbuf_len);
>> +			if (!logbuf)
>> +				break;
>> +			off =3D sdev_format_header(logbuf, logbuf_len,
>> +						 name, tag);
>> +			hex_dump_to_buffer(&sense_buffer[i], len, 16, 1,
>> +					   logbuf + off, logbuf_len - off,
>> +					   false);
>> +			dev_printk(KERN_INFO, &sdev->sdev_gendev, logbuf);
>> +			scsi_log_release_buffer(logbuf);
>> +		}
>> +		return;
>=20
> Keeping the code inside the if in a separate helper would probably be=
 a
> lot more readable.
>=20
Ok. Will be doing so.

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
