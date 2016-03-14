From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Avoid that long log lines are truncated
Date: Mon, 14 Mar 2016 15:45:32 +0100
Message-ID: <56E6CE8C.5020600@suse.de>
References: <56E6C88B.6010201@sandisk.com>
 <1457966320.4188.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934283AbcCNOpe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2016 10:45:34 -0400
In-Reply-To: <1457966320.4188.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Robert Elliott <Elliott@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/14/2016 03:38 PM, Ewan Milne wrote:
> On Mon, 2016-03-14 at 07:19 -0700, Bart Van Assche wrote:
>> While testing the latest version of the SRP initiator and target
>> drivers I encountered the following message in the kernel log:
>>
>> sd 16:0:0:0: Warning! Received an indication that the LUN assignment=
s on this target have changed. The Linux SCSI layer does not automatica=
l
>>
>> This is a truncated message. Avoid that such truncation happens
>> by increasing the SCSI_LOG_BUFSIZE constant.
>>
>> Fixes: ded85c193a39 (scsi: Implement per-cpu logging buffer)
>> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Robert Elliott <elliott@hp.com>
>> Cc: Ewan D. Milne <emilne@redhat.com>
>> Cc: <stable@vger.kernel.org> # v4.0+
>> ---
>>  include/scsi/scsi_dbg.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
>> index 56710e0..05d36eb 100644
>> --- a/include/scsi/scsi_dbg.h
>> +++ b/include/scsi/scsi_dbg.h
>> @@ -5,7 +5,7 @@ struct scsi_cmnd;
>>  struct scsi_device;
>>  struct scsi_sense_hdr;
>> =20
>> -#define SCSI_LOG_BUFSIZE 128
>> +#define SCSI_LOG_BUFSIZE 256
>> =20
>>  extern void scsi_print_command(struct scsi_cmnd *);
>>  extern size_t __scsi_format_command(char *, size_t,
>=20
> Hmm.  Perhaps we should make the message less verbose instead?
> It looks like if we increase SCSI_LOG_BUFSIZE then we get fewer
> per-message buffers unless we also increase SCSI_LOG_SPOOLSIZE.
>=20
Or just shorten the message itself.
It's really annoying having these really long messages showing up in
the system log ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
