From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH RFC 0/9] [SCSI] Enhanced sense and Unit Attention handling
Date: Mon, 28 Jan 2013 09:05:02 -0600
Message-ID: <5106939E.1010301@tributary.com>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com> <CAO+b5-oKyPoSdKJPcyaf4FkDUNH25Cwwz=_C4WiwvpfauNqStQ@mail.gmail.com> <51011D2E.305@suse.de> <CAO+b5-ptjPEbCrKEpdCEZBCh5Xs7ycXQA5V+iohAL4TSfbUzFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.58]:47392 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3A1PKV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jan 2013 10:10:21 -0500
In-Reply-To: <CAO+b5-ptjPEbCrKEpdCEZBCh5Xs7ycXQA5V+iohAL4TSfbUzFg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>, "Ewan D. Milne" <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/24/2013 8:38 AM, Bart Van Assche wrote:

> Let me ask this another way. SAN users expect that the LUN list at the 
> initiator side gets updated automatically after a SAN configuration change.
> How should a SAN system communicate to a SCSI initiator that the LUN list
> has been changed ? Some FC SAN systems send a LIP after a configuration
> change to force the initiator to rescan LUNs. But how to

	What I think your looking for is RSCN (Registered State Change notification)
. Hook that, and then check the name server. This will tell you when ports get
added/removed. You can then report luns against lun 0 of all the known target
ports. This allows you to transparently detect changes.

	Otherwise, you run the risk of trapping UA's in the lower level portions of
the stack that _REALLY_ need to be propagated to the controlling driver or
application.



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRBpOeAAoJEL5i86xrzcy765gH/AnG1TPJ5Y3RGx00TiLP5shb
+yS384FoIis4XuWijUdofsAcnZzUFaMgH7lPBr5TkT1yYDgyXtzvpjV/2rvWlvzA
PfHPU4vPFmpF1XO7IX2PJCpHAYheHXhucnMkXVLI9GA5nR9+BPQjjvav24ixGKPc
b2889zju7Z7KUb0R4SXWtSCbRZZtYuBj0Rckh8a/ra9wJXHuMpsg7+7OzrLqbSqH
OcAmcb5Q8T/5D6Rj4rJVF3d1Fzr5+P2qrMhS+eb98I6phZ5UvHs66nY/pHjCGpbA
SShQlGOg7+nIjxsf9jjl2/sgx0jJH40koyW8Xv9WERE75eQ9bVBpBX3BeosvlJs=
=isBF
-----END PGP SIGNATURE-----
