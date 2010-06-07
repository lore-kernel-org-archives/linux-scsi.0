From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Mon, 07 Jun 2010 13:40:21 -0400
Message-ID: <yq1sk4yvj0a.fsf@sermon.lab.mkp.net>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
	<yq1iq64kv9f.fsf@sermon.lab.mkp.net>
	<20100531144648.GA19068@schmichrtp.mainz.de.ibm.com>
	<yq11vcqlwp8.fsf@sermon.lab.mkp.net>
	<20100602133748.GA11196@schmichrtp.mainz.de.ibm.com>
	<20100602232039.GA8287@dastard> <yq139x3y411.fsf@sermon.lab.mkp.net>
	<20100604023253.GF19651@dastard> <yq1zkz6vmpu.fsf@sermon.lab.mkp.net>
	<4C0D2AD4.2020303@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4C0D2AD4.2020303@panasas.com> (Boaz Harrosh's message of "Mon,
	07 Jun 2010 20:22:28 +0300")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Dave Chinner <david@fromorbit.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:

Boaz> Do you remember some performance numbers that show degradation /
Boaz> sameness?

Boaz> What type of work loads?

I haven't been using XFS much for over a year.  I'm using an internal
async I/O tool and btrfs for most of my DIX/DIF testing these days.

But my original changes were along the lines of what Jan mentioned
earlier (hooking into page_mkwrite and waiting for writeback.  I could
have sworn that I only did it for ext[23] and that XFS waited out of the
box but git proves me wrong).  Anyway, I'll try to get some benchmarking
happening later this week.

This won't fix things completely, though.  ext2fs, for instance,
frequently changes metadata buffers in flight so it trips the guard
check in no time.

-- 
Martin K. Petersen	Oracle Linux Engineering
