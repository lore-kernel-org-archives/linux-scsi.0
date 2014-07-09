From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V2] scsi_lib: removes ambiguous "Unhandled error code"
 messages.
Date: Wed, 09 Jul 2014 12:49:09 +0200
Message-ID: <53BD1E25.8040807@suse.de>
References: <1402042235-7246-1-git-send-email-mlombard@redhat.com> <20140625110632.GE19181@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062AbaGIKtL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2014 06:49:11 -0400
In-Reply-To: <20140625110632.GE19181@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Maurizio Lombardi <mlombard@redhat.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On 06/25/2014 01:06 PM, Christoph Hellwig wrote:
> Can I get another review for this one?
>
> On Fri, Jun 06, 2014 at 10:10:35AM +0200, Maurizio Lombardi wrote:
>> During IO with fabric faults, one generally sees several "Unhandled =
error
>> code" messages in the syslog as shown below:
>>
>> sd 4:0:6:2: [sdbw] Unhandled error code
>> sd 4:0:6:2: [sdbw] Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDR=
IVER_OK
>> sd 4:0:6:2: [sdbw] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
>> end_request: I/O error, dev sdbw, sector 0
>>
>> This comes from scsi_io_completion (in scsi_lib.c) while handling er=
ror
>> codes other than DID_RESET or not deferred sense keys i.e. this is
>> actually handled by the SCSI mid layer. But what gets displayed here=
 is
>> "Unhandled error code" which is quite misleading as it indicates
>> something that is not addressed by the mid layer.
>>
>> This patch removes "Unhandled error code" and replaces "Unhandled se=
nse code"
>> with "Failing command with sense code:".
>>
>>
>> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
>> ---
>>   drivers/scsi/scsi_lib.c | 6 ++----
>>   1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 9db097a..b3c25cd 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -955,14 +955,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd,=
 unsigned int good_bytes)
>>   			action =3D ACTION_FAIL;
>>   			break;
>>   		default:
>> -			description =3D "Unhandled sense code";
>> +			description =3D "Failing command with sense code:";
>>   			action =3D ACTION_FAIL;
>>   			break;
>>   		}
>> -	} else {
>> -		description =3D "Unhandled error code";
>> +	} else
>>   		action =3D ACTION_FAIL;
>> -	}
>>
>>   	if (action !=3D ACTION_FAIL &&
>>   	    time_before(cmd->jiffies_at_alloc + wait_for, jiffies)) {
>> --
>> Maurizio Lombardi
>>
Good to see it finally went in.
We're carrying the same patch in our tree for ages as the original=20
attempt to push it upstream failed.

Reviewed-by: Hannes Reinecke <hare@suse.de>

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
