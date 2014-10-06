From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 21/24] scsi: simplify scsi_log_(send|completion)
Date: Mon, 06 Oct 2014 08:40:57 +0200
Message-ID: <54323979.9080909@suse.de>
References: <1412144580-72880-1-git-send-email-hare@suse.de> <1412144580-72880-22-git-send-email-hare@suse.de> <94D0CD8314A33A4D9D801C0FE68B402958CCBEE9@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbaJFGk7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2014 02:40:59 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958CCBEE9@G4W3202.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 10/03/2014 04:32 AM, Elliott, Robert (Server Storage) wrote:
>=20
>=20
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Wednesday, 01 October, 2014 1:23 AM
>> To: James Bottomley
>> Cc: Christoph Hellwig; linux-scsi@vger.kernel.org; Elliott, Robert (=
Server
>> Storage); Hannes Reinecke
>> Subject: [PATCH 21/24] scsi: simplify scsi_log_(send|completion)
>>
>> Simplify scsi_log_(send|completion) by externalizing
>> scsi_mlreturn_string() and always print the command address.
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/constants.c | 39 ++++++++++++++++++++++++++++++++++++-=
--
>>  drivers/scsi/scsi.c      | 43 ++++++-------------------------------=
------
>>  drivers/scsi/scsi_lib.c  | 13 ++++++++++---
>>  include/scsi/scsi_dbg.h  |  3 ++-
>>  4 files changed, 54 insertions(+), 44 deletions(-)
>>
>> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
>> index b131900..207ebef 100644
>> --- a/drivers/scsi/constants.c
>> +++ b/drivers/scsi/constants.c
>> @@ -1437,19 +1437,52 @@ const char *scsi_driverbyte_string(int resul=
t)
>>  }
>>  EXPORT_SYMBOL(scsi_driverbyte_string);
>>
>> -void scsi_print_result(struct scsi_cmnd *cmd)
>> +#ifdef CONFIG_SCSI_CONSTANTS
>> +#define scsi_mlreturn_name(result)	{ result, #result }
>> +static const struct value_name_pair scsi_mlreturn_arr[] =3D {
>> +	scsi_mlreturn_name(NEEDS_RETRY),
>> +	scsi_mlreturn_name(SUCCESS),
>> +	scsi_mlreturn_name(FAILED),
>> +	scsi_mlreturn_name(QUEUED),
>> +	scsi_mlreturn_name(SOFT_ERROR),
>> +	scsi_mlreturn_name(ADD_TO_MLQUEUE),
>> +	scsi_mlreturn_name(TIMEOUT_ERROR),
>> +	scsi_mlreturn_name(SCSI_RETURN_NOT_HANDLED),
>> +	scsi_mlreturn_name(FAST_IO_FAIL)
>> +};
>=20
> SUCCESS is a misleading name to print on commands that were
> really not successful.  Example:
> [ 5978.573297] sd 2:0:0:8: [sdz] tag#209 Done: SUCCESS Result: hostby=
te=3DDID_OK driverbyte=3DDRIVER_OK
> [ 5978.576335] sd 2:0:0:8: [sdz] tag#209 CDB: Test Unit Ready 00 00 0=
0 00 00 00
> [ 5978.578721] sd 2:0:0:8: [sdz] tag#209 Sense Key : Unit Attention [=
current]
> [ 5978.581177] sd 2:0:0:8: [sdz] tag#209 Add. Sense: Bus device reset=
 function occurred
>=20
> Maybe that mlreturn value should be printed as=20
> "COMPLETE" since it is similar to the SAM service
> responses called COMMAND COMPLETE and FUNCTION COMPLETE.
> That is a more neutral term.
>=20
I do agree that SUCCESS is rather misleading here.
However, the midlayer always used 'SUCCESS' here, and changing that
would be a different patch as it's bound to induce quite some
discussion.
I'm happy to send such a patch, but preferably _after_ this
patchset is in.

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
