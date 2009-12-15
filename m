From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Remove capping from dev_loss_tmo
Date: Tue, 15 Dec 2009 10:53:33 +0100
Message-ID: <4B275C9D.2060606@suse.de>
References: <20091215082606.A45B037AD2@ochil.suse.de> <4B274EB1.50500@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52586 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbZLOJxf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Dec 2009 04:53:35 -0500
In-Reply-To: <4B274EB1.50500@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@suse.de>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

Mike Christie wrote:
> Hannes Reinecke wrote:
>> diff --git a/drivers/scsi/scsi_transport_fc.c
>> b/drivers/scsi/scsi_transport_fc.c
>> index 573ce21..6f39bf4 100644
>> --- a/drivers/scsi/scsi_transport_fc.c
>> +++ b/drivers/scsi/scsi_transport_fc.c
>> @@ -475,7 +475,8 @@ MODULE_PARM_DESC(dev_loss_tmo,
>>           "Maximum number of seconds that the FC transport should"
>>           " insulate the loss of a remote port. Once this value is"
>>           " exceeded, the scsi target is removed. Value should be"
>> -         " between 1 and SCSI_DEVICE_BLOCK_MAX_TIMEOUT.");
>> +         " between 1 and SCSI_DEVICE_BLOCK_MAX_TIMEOUT if"
>> +         " fast_io_fail_tmo is not set.");
>> =20
>=20
> What was the largest timeout value you tried? I think I am hitting a =
bug
> with iscsi where if you pass queue_delayed_work a large enough value =
it
> will overflow and instead of getting 100 minutes you get 1.

Well, 0x7fffffff works, 0xffffffff is rejected with -EINVAL.
And so should every other value with the top bit set.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
