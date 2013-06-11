From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 8/9] mpt2sas: Enable new EH timeout handler
Date: Tue, 11 Jun 2013 07:41:31 +0200
Message-ID: <51B6B88B.1030005@suse.de>
References: <1370850058-27613-1-git-send-email-hare@suse.de> <1370850058-27613-9-git-send-email-hare@suse.de> <20130610153111.GB18076@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56015 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab3FKFlg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jun 2013 01:41:36 -0400
In-Reply-To: <20130610153111.GB18076@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

On 06/10/2013 05:31 PM, J=C3=B6rn Engel wrote:
> On Mon, 10 June 2013 09:40:57 +0200, Hannes Reinecke wrote:
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/mpt2sas/mpt2sas_scsih.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt=
2sas/mpt2sas_scsih.c
>> index c6bdc92..47fc66c 100644
>> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
>> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
>> @@ -2565,6 +2565,16 @@ _scsih_tm_display_info(struct MPT2SAS_ADAPTER=
 *ioc, struct scsi_cmnd *scmd)
>>  }
>> =20
>>  /**
>> + * _scsih_timed_out - eh timeout handler
>> + * @scmd: pointer to scsi command object
>> + */
>> +static enum blk_eh_timer_return
>> +_scsih_timed_out(struct scsi_cmnd *scmd)
>> +{
>> +	return scsi_abort_command(scmd);
>> +}
>=20
> Why did you create this function and not do the following?
> +	.eh_timed_out			=3D scsi_abort_command,
>=20
Good point.

That function was required for an earlier version (where
I had 'void scsi_abort_command()').
So yeah, that function isn't required.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
