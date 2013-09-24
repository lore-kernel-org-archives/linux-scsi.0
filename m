From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [dm-devel] SCSI's heuristics for enabling WRITE SAME still need work [was: dm mpath: disable WRITE SAME if it fails]
Date: Tue, 24 Sep 2013 16:44:37 -0400
Message-ID: <yq14n9aar0q.fsf@sermon.lab.mkp.net>
References: <20130919161043.GA27081@redhat.com>
	<20130920212142.GA17898@redhat.com>
	<alpine.LRH.2.02.1309241415380.31619@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43406 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab3IXUom (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Sep 2013 16:44:42 -0400
In-Reply-To: <alpine.LRH.2.02.1309241415380.31619@file01.intranet.prod.int.rdu2.redhat.com>
	(Mikulas Patocka's message of "Tue, 24 Sep 2013 14:39:45 -0400 (EDT)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Mikulas" == Mikulas Patocka <mpatocka@redhat.com> writes:

Mikulas> Propagating the limits up the tree won't work anyway because of
Mikulas> a race condition. Think of this case:

Mikulas> 1. We test queue limits and find out that the device supports
Mikulas>    WRITE_SAME
Mikulas> 2. We build a WRITE_SAME bio to be submitted.
Mikulas> 3. The user reconfigures a device so that it no longer supports
Mikulas>    WRITE_SAME
Mikulas> (for example, he adds a snapshot or converts linear volume to a
Mikulas> mirror).
Mikulas> 4. We submit the bio that we built in step 2.
Mikulas> 5. The bio fails.

The existing "fall back to writes if write same fails" mechanism isn't
going away. We absolutely need that.

The principal headache is caused by host adapters that perform SCSI-ATA
or SCSI-<internal RAID implementation> translation and which do not
correctly fail a WRITE SAME command that we send down to the disk.

Based on heuristics from querying the target we expect WRITE SAME to
succeed so we enable it. But for whatever reason the controller is not
able to handle the command. Most controllers/drivers will fail the
command correctly and we'll disable WRITE SAME and fall back to manually
zeroing. Some controllers, however, hang or fail the I/O in a way in
which we do not pick up it's a WRITE SAME problem.

The other headache is what happens if a stacking driver gets -EIO or
-EREMOTEIO on a WRITE SAME request. That's what Mike was trying to fix
with his patch. Maybe it would make sense for us to use -EINVAL or
something similar to single out the ILLEGAL REQUEST case. While
-EREMOTEIO specifically calls out for "no retry" it might be helpful to
indicate that we're dealing with an unsupported command. That way DM or
MD can reconfigure themselves accordingly.

-- 
Martin K. Petersen	Oracle Linux Engineering
