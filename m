From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: BLKZEROOUT not zeroing md dev on VMDK
Date: Fri, 27 May 2016 05:45:46 +0100
Message-ID: <CALjAwxgkgPZdXFkOuD-7Dsbxf9oVEGuXTDLnyqu8rTrJio_4mA@mail.gmail.com>
References: <20160518223616.GA409@sucs.org>
	<20160527041824.GC9418@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160527041824.GC9418@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Arvind Kumar <arvindkumar@vmware.com>, VMware PV-Drivers <pv-drivers@vmware.com>, linux-raid@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 27 May 2016 at 05:18, Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> It's possible that the pvscsi device advertised WRITE SAME, but if the device
> sends back ILLEGAL REQUEST then the SCSI disk driver will set
> write_same_max_bytes=0.  Subsequent BLKZEROOUT attempts will then issue writes
> of zeroes to the drive.

Thanks for following up on this but that's not what happens on the md
device - you can go on to issue as many BLKZEROOUT requests as you
like but the md disk is never zeroed nor is an error returned.

I filed a bug at https://bugzilla.kernel.org/show_bug.cgi?id=118581
(see https://bugzilla.kernel.org/show_bug.cgi?id=118581#c6 for
alternative reproduction steps that use scsi_debug and can be reworked
to impact device mapper) and Shaohua Li noted that
blkdev_issue_write_same could return 0 even when the disk didn't
support write same (see
https://bugzilla.kernel.org/show_bug.cgi?id=118581#c8 ).

Shaohua went on to create a patch for this ("block: correctly fallback
for zeroout" - https://patchwork.kernel.org/patch/9137311/ ) which has
yet to be reviewed.

-- 
Sitsofe | http://sucs.org/~sits/
