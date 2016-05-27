From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: BLKZEROOUT not zeroing md dev on VMDK
Date: Fri, 27 May 2016 17:30:29 +0800
Message-ID: <CAGnHSEn0ntEw_dwFNqG6CdgwcpHzQie88jgA21uioKhBbcByTg@mail.gmail.com>
References: <20160518223616.GA409@sucs.org>
	<20160527041824.GC9418@birch.djwong.org>
	<CALjAwxgkgPZdXFkOuD-7Dsbxf9oVEGuXTDLnyqu8rTrJio_4mA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALjAwxgkgPZdXFkOuD-7Dsbxf9oVEGuXTDLnyqu8rTrJio_4mA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Arvind Kumar <arvindkumar@vmware.com>, VMware PV-Drivers <pv-drivers@vmware.com>, linux-raid@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

There seems to be some sort of race condition between
blkdev_issue_zeroout() and the scsi disk driver (disabling write same
after an illegal request). On my UAS drive, sometimes `blkdiscard -z
/dev/sdX` will return right away, even though if I then check
`write_same_max_bytes` it has turned 0. Sometimes it will just write
zero with SCSI WRITE even if `write_same_max_bytes` is 33553920 before
I issue `blkdiscard -z` (`write_same_max_bytes` also turned 0, as
expected).

Not sure if it is directly related to the case here though.

On 27 May 2016 at 12:45, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> On 27 May 2016 at 05:18, Darrick J. Wong <darrick.wong@oracle.com> wrote:
>>
>> It's possible that the pvscsi device advertised WRITE SAME, but if the device
>> sends back ILLEGAL REQUEST then the SCSI disk driver will set
>> write_same_max_bytes=0.  Subsequent BLKZEROOUT attempts will then issue writes
>> of zeroes to the drive.
>
> Thanks for following up on this but that's not what happens on the md
> device - you can go on to issue as many BLKZEROOUT requests as you
> like but the md disk is never zeroed nor is an error returned.
>
> I filed a bug at https://bugzilla.kernel.org/show_bug.cgi?id=118581
> (see https://bugzilla.kernel.org/show_bug.cgi?id=118581#c6 for
> alternative reproduction steps that use scsi_debug and can be reworked
> to impact device mapper) and Shaohua Li noted that
> blkdev_issue_write_same could return 0 even when the disk didn't
> support write same (see
> https://bugzilla.kernel.org/show_bug.cgi?id=118581#c8 ).
>
> Shaohua went on to create a patch for this ("block: correctly fallback
> for zeroout" - https://patchwork.kernel.org/patch/9137311/ ) which has
> yet to be reviewed.
>
> --
> Sitsofe | http://sucs.org/~sits/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
