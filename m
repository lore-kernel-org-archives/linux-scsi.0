From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 9/13] mpt2sas: T10 DIF Support - EEDP
Date: Wed, 15 Apr 2009 22:54:31 -0400
Message-ID: <yq14owpxq8o.fsf@sermon.lab.mkp.net>
References: <660360F4F2570145BD872F298951B17A76B5F27C@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:40206 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZDPCyx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Apr 2009 22:54:53 -0400
In-Reply-To: <660360F4F2570145BD872F298951B17A76B5F27C@cosmail03.lsi.com>
	(Eric Moore's message of "Wed, 15 Apr 2009 15:53:35 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Eric" == Moore, Eric <Eric.Moore@lsi.com> writes:

Eric,

Eric> So what I did is good for type1, which is set the ref tag to the
Eric> lower 32bit of the lba, and the app tag to zero.

That's fine.


Eric> For type 3, I asked others for suggestions from a number of
Eric> co-workers and the software archetic, and they said to set the
Eric> tags the same way I did for type 1.  Due to my limitations with
Eric> controller firmware, what do you suggest for type 3?

Well, so technically you are not supposed to set the reference tag to
the LBA in Type 3.  The 16 bits of the app tag + the 32 bits of the ref
tag are considered opaque storage.

The storage device has no way of checking neither app, nor ref with Type
3.  It can only check the guard tag.

My main concern is if you always expect the ref to be lower 32 bits of
LBA and have the HBA firmware verify that on READ.  Because the ref tag
could conceivably contain anything and the I/O might fail.

I realize this is a bit academic given that with the current setup your
HBA will be doing both writing and reading.  But in a multi-initiator
setup or for future compatibility it might throw a wrench in the
machinery to have the HBA check the ref tag on Type 3.

For Type 1 I expect you to check guard + match ref tag to CDB LBA +
offset.

For Type 2 I expect you to check guard + match ref tag to E.I.LBA in
32-byte CDB + offset.

For Type 3 I expect you to check guard only.

-- 
Martin K. Petersen	Oracle Linux Engineering
