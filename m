From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] LSF: Multipathing and path checking question
Date: Tue, 21 Apr 2009 09:26:27 +0200
Message-ID: <49ED7523.5080108@suse.de>
References: <49E7B845.70400@cs.wisc.edu> <49E834CD.1090306@suse.de>	<49E89866.50205@cs.wisc.edu> <49E89E92.7070709@cs.wisc.edu>	<49EC3010.5050502@suse.de> <49ECCBAC.70308@cs.wisc.edu> <49ECFF0F.5080003@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbZDUH02 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 03:26:28 -0400
In-Reply-To: <49ECFF0F.5080003@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Mike Christie wrote:
> Mike Christie wrote:
>>> For starters we just should send a netlink event when fast_fail_io =
has
>>> fired. We could easily integrate that one in multipathd and would g=
ain
>>> an instant benefit from that as we can switch paths in advance.
>>> Next step would be to implement an additional sdev state which woul=
d
>>> return 'DID_TRANSPORT_FASTFAIL' for any 'normal' I/O; it would be
>>> inserted between 'RUNNING' and 'CANCEL'.
>>> Transition would be possible between 'RUNNING' and 'FASTFAIL', but
>>> it would only be possible to transition into 'CANCEL' from 'FASTFAI=
L'.
>>>
>>
>>
>> Yeah, a new sdev state might be nice. Right now this state is handle=
d
>> by the classes. For iscsi and FC the port/session will be in
>> blocked/ISCSI_SESSION_FAILED. Then internally the classes are
>> decieding what to do with IO in the *_chkready functions.
>>
>>
>=20
>=20
> How about setting the device to the offline state for this case where
> fast_io_fail has fired but the dev_loss_tmo has not yet fired? As fas=
t
> as failing IO we get the same result. scsi-ml would fail the incoming=
 IO
> instead of it getting to the class _chkready functions, but the scsi
> device state indicates that it cannot execute IO which might be nice =
for
> users.
>=20
Ah, no. OFFLINE is a dead end status out of which we cannot transition
from inside the kernel. I'd prefer a new state here.

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
