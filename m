From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Mon, 31 May 2010 10:20:44 -0400
Message-ID: <yq1iq64kv9f.fsf@sermon.lab.mkp.net>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:41557 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab0EaOW1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2010 10:22:27 -0400
In-Reply-To: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com> (Christof
	Schmitt's message of "Mon, 31 May 2010 13:28:18 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

>>>>> "Christof" == Christof Schmitt <christof.schmitt@de.ibm.com> writes:

Christof> Since the guard tags are created in Linux, it seems that the
Christof> data attached to the write request changes between the
Christof> generation in bio_integrity_generate and the call to
Christof> sd_prep_fn.

Yep, known bug.  Page writeback locking is messed up for buffer_head
users.  The extNfs folks volunteered to look into this a while back but
I don't think they have found the time yet.


Christof> Using ext3 or ext4 instead of ext2 does not show the problem.

Last I looked there were still code paths in ext3 and ext4 that
permitted pages to be changed during flight.  I guess you've just been
lucky.

-- 
Martin K. Petersen	Oracle Linux Engineering
