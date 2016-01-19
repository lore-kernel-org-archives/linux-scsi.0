From: Hannes Reinecke <hare@suse.de>
Subject: Re: Device is not becoming offline on failed TUR
Date: Tue, 19 Jan 2016 13:46:11 +0100
Message-ID: <569E3013.9050407@suse.de>
References: <B653F0B7F68442D997F563AE5C6D634D@levpc2>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbcASMqP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jan 2016 07:46:15 -0500
In-Reply-To: <B653F0B7F68442D997F563AE5C6D634D@levpc2>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lev Vainblat <lev@zadarastorage.com>, linux-scsi@vger.kernel.org
Cc: Yaron Presente <yaron@zadarastorage.com>, Alex Lyakas <alex@zadarastorage.com>

On 01/17/2016 11:54 AM, Lev Vainblat wrote:
> Hello,
>=20
> We have a virtual target that under some circumstances returns
> HARDWARE_ERROR (4/44) on TUR. Previously on initiator side
> scsi_check_sense() returned TARGET_ERROR, that in scsi_eh_tur() was
> converted to 1 (device not ready). And then scsi_eh_ready_devs()
> called scsi_eh_offline_sdevs to move device to the OFFLINE state.
>=20
> In commit
> http://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/c=
ommit/?id=3D87f14e6
> this logic has been changed. Now on HARDWARE_ERROR
> scsi_check_sense() only sets DID_TARGET_FAILURE and returns SUCCESS.
> As a result device remains "running", and scsi_eh_flush_done_q()
> doesn't finish the command but retries it. So in this case it takes
> for the stuck command much more time to finish.
>=20
> Am I missing something? Is it a bug or intentional new behavior?
>=20
That is intentional.
We should only ever set the device to 'offline' is we cannot
communicate with it.
If we can (and that is the case here, as the drive returns a sense
code) the communication is okay, and the device should not be set to
offline.

It's up to the driver/calling application to correctly handle the
sense code.
As usual.

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
