From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND][PATCH 09/10][SCSI]mpt2sas: Added module parameter 'unblock_io' to unblock IO's during disk addition
Date: Thu, 21 Aug 2014 17:06:15 -0400
Message-ID: <yq1oavdr1rs.fsf@sermon.lab.mkp.net>
References: <20140625103615.GA12959@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140625103615.GA12959@avagotech.com> (Sreekanth Reddy's message
	of "Wed, 25 Jun 2014 16:06:15 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
Cc: jejb@kernel.org, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Reddy, Sreekanth <Sreekanth.Reddy@avagotech.com> writes:

Sreekanth> This is because, when driver receives DELAY_NOT_RESPONDING
Sreekanth> for a disk when it is undergoing addition in the SCSI Mid
Sreekanth> layer, the driver would block the I/O to that disk resulting
Sreekanth> in a deadlock. i.e the disk addition work couldn't be
Sreekanth> completed as it can't send any I/O to the disk as I/Os are
Sreekanth> blocked. Any device removal (TARGET_NOT_RESPONDING) or link
Sreekanth> update(RC_PHY_CHANGED) couldn't be processed as they are in
Sreekanth> the queue to get processed after disk addition.

Sreekanth> An module parameter 'unblock_io' is introduced which needs to
Sreekanth> be set to have this functionality enabled. By default this
Sreekanth> functionality is disabled.

This really sounds like a scenario you should be able to handle in
general (without special "don't-be-broken" module parameters).

Also, shouldn't your internal task management be able to deal with this?
Why does the sdev's state during probe affect your ability to make
forward progress?

-- 
Martin K. Petersen	Oracle Linux Engineering
