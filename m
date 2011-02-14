From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Erroneous handling of sense status in SCSI EH commands
Date: Mon, 14 Feb 2011 08:26:00 +0100
Message-ID: <4D58D908.7070306@suse.de>
References: <1295597274-5844-1-git-send-email-hare@suse.de> <1297528206.3026.7.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab1BNHRV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Feb 2011 02:17:21 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id 0DE475FC9F
	for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2011 08:17:21 +0100 (CET)
In-Reply-To: <1297528206.3026.7.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

On 02/12/2011 05:30 PM, James Bottomley wrote:
> On Fri, 2011-01-21 at 09:07 +0100, Hannes Reinecke wrote:
>> Consider a scenario where a SCSI EH command like TUR fails with a NO=
T READY
>> status - MANUAL INTERVENTION REQUIRED (02/04/03). As evident in the =
ASC/ASCQ
>> description, manual intervention is required in this case i.e. the t=
arget wants
>> TUR to fail here so that the host administrator can take corrective =
action.
>>
>> But this particular ASC/ASCQ is not handled in the scsi_check_sense,=
 which
>> ultimately causes scsi_eh_tur to erroneously report a SUCCESS (devic=
e ready)
>> instead of the actual FAILURE state (device not ready).
>>
>> This patch converts scsi_check_sense() to return SOFT_ERROR in
>> cases where an error has been signalled via the sense code, but
>> we should not wake the error handler. This error code will be
>> reverted back to SUCCESS for normal command handling, but
>> scsi_eh_completed_normally() will convert it to FAILED.
>=20
> I can't reconcile this patch with the detailed error handling ones: y=
ou
> change a lot of call sites to TARGET_ERROR in that patch and SOFT_ERR=
OR
> in this one.  Since the detailed error handling seems the more
> important, I'll drop this one ... can you work out a reconciliation,
> please?
>=20
Yes. I'm in discussion with NetApp (as the original reporter)
about details about this patch anyway.

I'll be sending an update.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
