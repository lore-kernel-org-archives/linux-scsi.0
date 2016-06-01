From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: BLKZEROOUT not zeroing md dev on VMDK
Date: Wed, 1 Jun 2016 06:04:54 +0100
Message-ID: <CALjAwxgdr1zSgZZzNA9BQ8Ta+UuutJ6iuBnqZfmV-BTCDL2PbA@mail.gmail.com>
References: <20160518223616.GA409@sucs.org>
	<20160527041824.GC9418@birch.djwong.org>
	<CALjAwxgkgPZdXFkOuD-7Dsbxf9oVEGuXTDLnyqu8rTrJio_4mA@mail.gmail.com>
	<CAGnHSEn0ntEw_dwFNqG6CdgwcpHzQie88jgA21uioKhBbcByTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGnHSEn0ntEw_dwFNqG6CdgwcpHzQie88jgA21uioKhBbcByTg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Arvind Kumar <arvindkumar@vmware.com>, VMware PV-Drivers <pv-drivers@vmware.com>, linux-raid@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 27 May 2016 at 10:30, Tom Yan <tom.ty89@gmail.com> wrote:
> There seems to be some sort of race condition between
> blkdev_issue_zeroout() and the scsi disk driver (disabling write same
> after an illegal request). On my UAS drive, sometimes `blkdiscard -z
> /dev/sdX` will return right away, even though if I then check
> `write_same_max_bytes` it has turned 0. Sometimes it will just write
> zero with SCSI WRITE even if `write_same_max_bytes` is 33553920 before
> I issue `blkdiscard -z` (`write_same_max_bytes` also turned 0, as
> expected).
>
> Not sure if it is directly related to the case here though.

I'm not aware of hitting that particular problem myself directly on
the underlying "SCSI" device but the patch on
https://patchwork.kernel.org/patch/9137311/ should be able to resolve
that issue. Could you test it and follow up on
http://permalink.gmane.org/gmane.linux.kernel/2229377 ? I'm hoping
more testing reports will lead to the patch being reviewed and
accepted sooner rather than later as it's currently stalled...

-- 
Sitsofe | http://sucs.org/~sits/
