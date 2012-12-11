From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2][RFC] scsi_transport_fc: Implement I_T nexus reset
Date: Tue, 11 Dec 2012 15:06:30 +0100
Message-ID: <50C73DE6.4090806@suse.de>
References: <1355214219-17343-1-git-send-email-hare@suse.de> <1355230016.20256.6.camel@br8ggx07.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667Ab2LKOGc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Dec 2012 09:06:32 -0500
In-Reply-To: <1355230016.20256.6.camel@br8ggx07.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

On 12/11/2012 01:46 PM, Martin Peschke wrote:
> Hello Hannes,
>
>> fc_eh_it_nexus_loss_handler() is invoked as the
>> eh_target_reset_handler() callback and the
>> eh_bus_reset_handler() is removed.
>
> lpfc_target_reset_handler(), which is replaced by your patch, used to
> issue a TARGET_RESET task management function over FCP in the
> eh_target_reset_handler() callback. What's wrong with that?
>
Nothing per se.
Only that the TARGET_RESET TMF has been removed from SAM-3/FCP-3=20
onwards, so there might not be any functionality behind it.
But drivers can supply the functionality via ->eh_it_nexus_loss=20
callback.

I didn't want to touch the existing eh_target_reset_handler myself
as I'm not familiar with the firmware specifics.
That is being left as an exercise to the reader :-)

The main point here is that we're emulating REMOVE I_T NEXUS by=20
setting the port state to BLOCKED and invoke dev_loss_tmo.
This will prevent any further I/O to be send down.
With the original handler the port state wasn't modified,
which led to excessive recovery times when no RSCN was received.

And yes, I had several bug reports now where the HBA did not receive=20
RSCNs, either due to a switch malfunction or due to an error injection.

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
