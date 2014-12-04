From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/12] advansys: use shared host tag map for command lookup
Date: Thu, 04 Dec 2014 10:25:41 +0100
Message-ID: <54802895.5010900@suse.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de> <1417607105-85455-3-git-send-email-hare@suse.de> <20141204092043.GD23891@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbaLDJZm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2014 04:25:42 -0500
In-Reply-To: <20141204092043.GD23891@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

On 12/04/2014 10:20 AM, Christoph Hellwig wrote:
>>  typedef struct asc_scsiq_2 {
>> -	ASC_VADDR srb_ptr;
>> +	__le32 srb_tag;
>=20
> Given that the tag has no meaning for the hardware why do you
> want to endian switch it?  Keeping the ASC_VADDR for now makes
> it easier to verify the hardware structures don't change.
>=20
Mhm. See the patch I've just sent to Ondrej.
=46or the narrow board it actually _has_ a meaning.
But okay, the endian switch is probably pointless here.

>> @@ -6132,6 +6077,13 @@ static void adv_async_callback(ADV_DVC_VAR *a=
dv_dvc_varp, uchar code)
>>  		AdvResetChipAndSB(adv_dvc_varp);
>>  		break;
>> =20
>> +	case ADV_ASYNC_CARRIER_READY_FAILURE:
>> +		/*
>> +		 * Carrier not ready; abort the command.
>> +		 */
>> +		ASC_DBG(0, "ADV_ASYNC_CARRIER_READY_FAILURE\n");
>> +		break;
>> +
>=20
> Where does this one come from?
>=20
Encountered during debugging, I just thought to have it printed.
But okay, I can move it into a separate patch.

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
