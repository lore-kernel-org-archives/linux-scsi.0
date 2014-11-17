From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/10] scsi: Add SPC-3 command definitions
Date: Mon, 17 Nov 2014 08:56:29 +0100
Message-ID: <5469AA2D.7090903@suse.de>
References: <1415262639-121586-1-git-send-email-hare@suse.de> <1415262639-121586-3-git-send-email-hare@suse.de> <94D0CD8314A33A4D9D801C0FE68B402959398D0C@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48115 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbaKQH4b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2014 02:56:31 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402959398D0C@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 11/12/2014 06:07 PM, Elliott, Robert (Server Storage) wrote:
>=20
>=20
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Thursday, 06 November, 2014 2:31 AM
>> To: James Bottomley
>> Cc: Christoph Hellwig; Ewan Milne; Elliott, Robert (Server Storage);
>> linux-scsi@vger.kernel.org; Hannes Reinecke
>> Subject: [PATCH 02/10] scsi: Add SPC-3 command definitions
>>
>> SPC-3 defines SERVICE ACTION IN(12), SERVICE_ACTION OUT(12),
>> SERVICE ACTION OUT(16), and SERVICE ACTION BIDIRECTIONAL.
>> And READ MEDIA SERIAL NUMBER has long since been deprecated.
>> So update callers to refer to the new cdb name.
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/constants.c           | 4 ----
>>  drivers/target/target_core_pr.c    | 2 +-
>>  include/scsi/scsi.h                | 6 +++++-
>>  tools/lib/traceevent/plugin_scsi.c | 5 ++++-
>>  4 files changed, 10 insertions(+), 7 deletions(-)
>>
> ...
>> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
>> index b354c0d..df00fd1 100644
>> --- a/include/scsi/scsi.h
>> +++ b/include/scsi/scsi.h
>> @@ -128,8 +128,10 @@ enum scsi_timeouts {
>>  #define MOVE_MEDIUM           0xa5
>>  #define EXCHANGE_MEDIUM       0xa6
>>  #define READ_12               0xa8
>> +#define SERVICE_ACTION_OUT_12 0xa9
>>  #define WRITE_12              0xaa
>> -#define READ_MEDIA_SERIAL_NUMBER 0xab
>> +#define READ_MEDIA_SERIAL_NUMBER 0xab /* Obsolete with SPC-2 */
>> +#define SERVICE_ACTION_IN_12 0xab
>=20
> That needs one more space before 0xab to line up with the others.
>=20
> ...
>> diff --git a/tools/lib/traceevent/plugin_scsi.c
>> b/tools/lib/traceevent/plugin_scsi.c
>> index c699f47..63aba97 100644
>> --- a/tools/lib/traceevent/plugin_scsi.c
>> +++ b/tools/lib/traceevent/plugin_scsi.c
>> @@ -85,8 +85,9 @@ typedef unsigned int u32;
>>  #define MOVE_MEDIUM			0xa5
>>  #define EXCHANGE_MEDIUM			0xa6
>>  #define READ_12				0xa8
>> +#define SERVICE_ACTION_out_12		0xa9
> ...
>=20
> out should be capitalized
>=20
=46ixed in my next round of patches.

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
