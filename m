From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4 of 7] block: bio data integrity support
Date: Mon, 09 Jun 2008 11:05:13 -0400
Message-ID: <yq1wskyk5sm.fsf@sermon.lab.mkp.net>
References: <f2ae9d5bce4c33e12083.1212814537@sermon.lab.mkp.net>
	<m3od6duwwg.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:14378 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbYFIPFl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2008 11:05:41 -0400
In-Reply-To: <m3od6duwwg.fsf@dmon-lap.sw.ru> (Monakhov Dmitri's message of "Sat\, 07 Jun 2008 18\:45\:03 +0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Monakhov Dmitri <dmonakhov@openvz.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "DM" == Monakhov Dmitri <dmonakhov@openvz.org> writes:

>> + nr_sectors = len / bi->tag_size;
>> +
>> + if (len % 2) + nr_sectors++;
DM> Seems i've missing something. What is purpose of this black magic?
DM> do you want just express following?  nr_sectors = (len +
DM> bi->tag_size - 1) / bi->tag_size;

Yep.  In the original DIF spec, only 2-byte tags were supported so the
check for an odd length was a fast and elegant solution.  But now that
I implemented Type 3 which has 6 bytes of tag space that's an invalid
assumption.  Fixed.


>> +
>> + if (bi->sector_size == 4096) + nr_sectors >>= 3;

DM> Why here and later sector_size == 4096 is so special, what about
DM> 1k and 2k sect_sz? Do you want just transform value from 512 to
DM> bi->sectors_size?

Well, so only 512-byte DIF storage devices are currently available.
The whole industry is in the process of transitioning to 4KB sectors.
There will be no DIF devices with 1KB or 2KB sectors.

And even as it stands it's unclear that 4KB sectors are going to look
like they do in the current version of the spec.  It's going to be an
interoperability nightmare as it is now as the tag is attached to the
hardware sector size.  This means that it's still only 8 bytes of DIF
for a device with 4KB sectors (IOW, 4104 bytes and not 4160).  That
means that *two* protection buffers would have to be generated for -
say - a mirror with heterogeneous sector sizes.  And tagging won't
work as there's not the same space available for both drives of the
mirror.

The tag space problem also causes issues with RAID arrays exporting
512 byte sectors to the host but using drives with 4KB sectors in the
back.  Where is the array going to store the tags for the last 7 512
byte sectors?

So 4KB vs. DIF is up in the air at this point.  The current checks are
there because I've been messing with 4KB sector devices for other
reasons.  And technically they are in accordance with the current
spec.

-- 
Martin K. Petersen	Oracle Linux Engineering

