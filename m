From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Disk Errors
Date: Wed, 2 Feb 2005 09:12:57 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458BBD5E44@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from magic.adaptec.com ([216.52.22.17]:58842 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262658AbVBBONA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Feb 2005 09:13:00 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Bryan Henderson <hbryan@us.ibm.com>, Kit Gerrits <kit@gerritsacc.nl>, linux-scsi@vger.kernel.org

From: Douglas Gilbert [mailto:dougg@torque.net] writes:
> All may not be lost. If a medium error occurs and the ASC and
> ASCQ imply the sector could be read but
> failed ECC then the READ LONG SCSI command should fetch the
> block (plus ECC and other data). For example a Fujitsu MAM3184
> returns 576 bytes. It is probably too much to expect that all
> the damage will be in the last 64 bytes.

However, the drive has taken whatever action it could to reconstruct the
data, the failure to report the block for a standard read means that the
data is in fact `lost'. The data+ECC combination must be in a state
where there are more bits of damage than the error correction can deal
with; 64 bytes of ECC deals with single bit errors thus we know that we
have more than 1 bit of damage to the disk. We could have 4096 bits of
damage in the worst case :-) and never know that fact.

If I wanted in desperation to recover whatever data I could, this would
be grand, but as it stands, from the Linux File System Driver
perspective, it would be dangerous to accept this block as anything more
than it is.

If the data is of the form to permit some loss, for example video, audio
content or an error correcting stream of data, someone can make a case
where READ_LONG is an appropriate action to take to help fill in missing
content. 

A fun thought ...
