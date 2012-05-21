From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/4] SCSI: add new SDEV_TRANSPORT_OFFLINE state
Date: Mon, 21 May 2012 13:50:50 +0200
Message-ID: <4FBA2C1A.5060101@suse.de>
References: <1337317019-12001-1-git-send-email-michaelc@cs.wisc.edu> <1337317019-12001-2-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158Ab2EULuv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 May 2012 07:50:51 -0400
In-Reply-To: <1337317019-12001-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On 05/18/2012 06:56 AM, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
>=20
> This patch adds a new state SDEV_TRANSPORT_OFFLINE. It will
> be used by transport classes to offline devices for cases like
> when the fast_io_fail/recovery_tmo fires. In those cases we
> want all IO to fail, and we have not yet escalated to dev_loss_tmo
> behavior where we are removing the devices.
>=20
> Currently to handle this state, transport classes are setting
> the scsi_device's state to running, setting their internal
> session/port structs state to something that indicates failed,
> and then failing IO from some transport check in the queuecommand.
>=20
> The reason for the new value is so that users can distinguish
> between a device failure that is a result of a transport problem
> vs the wide range of errors that devices get offlined for
> when a scsi command times out and we offline the devices there.
> It also fixes the confusion as to why the transport class is
> failing IO, but has set the device state from blocked to running.
>=20
Very neat.

Acked-by: Hannes Reinecke <hare@suse.de>

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
