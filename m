From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4 of 8] sd: Physical block size and alignment support
Date: Thu, 23 Apr 2009 15:02:23 -0400
Message-ID: <yq1y6tr9osg.fsf@sermon.lab.mkp.net>
References: <patchbomb.1240464567@sermon.lab.mkp.net>
	<fc4cc94aa1e2612b3489.1240464571@sermon.lab.mkp.net>
	<20090423163700.GB8350@mars.virtualiron.com>
	<yq1ab67b51p.fsf@sermon.lab.mkp.net>
	<20090423184421.GB9104@mars.virtualiron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet13.oracle.com ([148.87.113.125]:24934 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbZDWTDx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2009 15:03:53 -0400
In-Reply-To: <20090423184421.GB9104@mars.virtualiron.com> (Konrad Rzeszutek's
	message of "Thu, 23 Apr 2009 14:44:21 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konrad Rzeszutek <konrad@virtualiron.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "Konrad" == Konrad Rzeszutek <konrad@virtualiron.com> writes:

Konrad> The read_capacity_16 sets the sdkp->hw_sector_size to
Konrad> sector_size:

> @@ -1402,6 +1413,7 @@ static int read_capacity_10(struct scsi_
                                   ^^^^^^^^^^^^^^^^
That's the fallback setting for devices that only respond to READ
CAPACITY(10).


Konrad> That function also returns that value, which sd_read_capacity
Konrad> assigns to the sector_size variable. So when the check for
Konrad> sdkp->hw_sector_size inequality is reached, it is skiped as
Konrad> sdkp->hw_sector_size == sector_size. No?

For devices that support READ CAPACITY(16) (and are thus capable of
reporting physical block size) the two values may differ and the message
is printed.


Konrad> Is that doing a read_capacity_16 or _10?

16.


>> The protocols have been referring to logical blocks for ages.

Konrad> Do they refer to physical blocks as well?

Yep.

-- 
Martin K. Petersen	Oracle Linux Engineering
