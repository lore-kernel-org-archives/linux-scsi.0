From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/22] scsi: stop decoding if scsi_normalize_sense() fails
Date: Mon, 01 Sep 2014 10:06:25 +0200
Message-ID: <54042901.6090403@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de> <1409247216-76074-7-git-send-email-hare@suse.de> <20140831220036.GB16432@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44985 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbaIAIG1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Sep 2014 04:06:27 -0400
In-Reply-To: <20140831220036.GB16432@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

On 09/01/2014 12:00 AM, Christoph Hellwig wrote:
> On Thu, Aug 28, 2014 at 07:33:20PM +0200, Hannes Reinecke wrote:
>> If scsi_normalize_sense() fails we couldn't decode the sense
>> buffer, so we should not try to interpret the result.
>> We should rather dump the sense buffer instead and stop decoding.
>=20
> as far as I can tell the old code doesn't interpret it, it just does =
a
> slightly more convoluted hexdump than your version.  Care to come up
> with a better description for this patch?
>=20
Yep, done.

>>  static void
>> +scsi_dump_sense_buffer(struct scsi_device *sdev, const char *name,
>> +		       const unsigned char *sense_buffer, int sense_len)
>>  {
>> +	char linebuf[128];
>> +	int i, linelen, remaining;
>> =20
>> +	remaining =3D sense_len;
>> +	for (i =3D 0; i < sense_len; i +=3D 16) {
>> +		linelen =3D min(remaining, 16);
>> +		remaining -=3D 16;
>> +
>> +		hex_dump_to_buffer(sense_buffer + i, linelen, 16, 1,
>> +				   linebuf, sizeof(linebuf), false);
>> +		sdev_prefix_printk(KERN_INFO, sdev, name,
>> +				   "Sense: %s\n", linebuf);
>>  	}
>=20
> This would be more readanle without the remaining variable:
>=20
> 	for (i =3D 0; i < sense_len; i +=3D 16) {
> 		linelen =3D min(senselen - i, 16);
> =09
> 		...
> 	}
>=20
Ok, fixed.

>> @@ -1517,8 +1513,13 @@ void __scsi_print_sense(struct scsi_device *s=
dev, const char *name,
>>  			const unsigned char *sense_buffer, int sense_len)
>>  {
>>  	struct scsi_sense_hdr sshdr;
>> +	int res;
>> =20
>> -	scsi_decode_sense_buffer(sense_buffer, sense_len, &sshdr);
>> +	res =3D scsi_normalize_sense(sense_buffer, sense_len, &sshdr);
>> +	if (res =3D=3D 0) {
>> +		scsi_dump_sense_buffer(sdev, name, sense_buffer, sense_len);
>> +		return;
>> +	}
>=20
> no need for the res variable.  In fact due to the boolean-like return
> value of scsi_normalize_sense it would be a lot more readable without
> the variable.
>=20
Ok, fixed.

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
