From: Arvind Kumar <arvindkumar@vmware.com>
Subject: Re: BLKZEROOUT not zeroing md dev on VMDK
Date: Wed, 15 Jun 2016 18:17:37 +0000
Message-ID: <1466014718999.6976@vmware.com>
References: <20160518223616.GA409@sucs.org>
	<20160527041824.GC9418@birch.djwong.org>
	<CALjAwxgkgPZdXFkOuD-7Dsbxf9oVEGuXTDLnyqu8rTrJio_4mA@mail.gmail.com>
	<CAGnHSEn0ntEw_dwFNqG6CdgwcpHzQie88jgA21uioKhBbcByTg@mail.gmail.com>,<CALjAwxgdr1zSgZZzNA9BQ8Ta+UuutJ6iuBnqZfmV-BTCDL2PbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALjAwxgdr1zSgZZzNA9BQ8Ta+UuutJ6iuBnqZfmV-BTCDL2PbA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>, Tom Yan <tom.ty89@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, VMware PV-Drivers <pv-drivers@vmware.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Petr Vandrovec <petr@vmware.com>
List-Id: linux-scsi@vger.kernel.org

It is possibly some race. We saw a WRITE SAME related issue in past for which Petr sent out a patch but looks like the patch didn't make it. :(

https://groups.google.com/forum/#!topic/linux.kernel/1WGDSlyY0y0

Thanks!
Arvind
________________________________________
From: Sitsofe Wheeler <sitsofe@gmail.com>
Sent: Tuesday, May 31, 2016 10:04 PM
To: Tom Yan
Cc: Darrick J. Wong; Shaohua Li; Jens Axboe; Arvind Kumar; VMware PV-Drivers; linux-raid@vger.kernel.org; linux-scsi@vger.kernel.org; linux-block@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: BLKZEROOUT not zeroing md dev on VMDK

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
https://urldefense.proofpoint.com/v2/url?u=https-3A__patchwork.kernel.org_patch_9137311_&d=CwIBaQ&c=Sqcl0Ez6M0X8aeM67LKIiDJAXVeAw-YihVMNtXt-uEs&r=bUMaNc7nC9xbXtaMJrOvIIPNpPH0chY2kdRsskQn6GY&m=rx_5ntfhkt2GOpfjpiQjoCb5n4gCY7jKznXO0gKYcVI&s=W1F45VBu8NDxu2ImcbKM5b3d6UnUCLGgH8xEM9e6JQk&e=  should be able to resolve
that issue. Could you test it and follow up on
https://urldefense.proofpoint.com/v2/url?u=http-3A__permalink.gmane.org_gmane.linux.kernel_2229377&d=CwIBaQ&c=Sqcl0Ez6M0X8aeM67LKIiDJAXVeAw-YihVMNtXt-uEs&r=bUMaNc7nC9xbXtaMJrOvIIPNpPH0chY2kdRsskQn6GY&m=rx_5ntfhkt2GOpfjpiQjoCb5n4gCY7jKznXO0gKYcVI&s=9ekqmTk18vzcwcY0SSMF8AZnJ_lWezFIM8tDvQqeDHI&e=  ? I'm hoping
more testing reports will lead to the patch being reviewed and
accepted sooner rather than later as it's currently stalled...

--
Sitsofe | https://urldefense.proofpoint.com/v2/url?u=http-3A__sucs.org_-7Esits_&d=CwIBaQ&c=Sqcl0Ez6M0X8aeM67LKIiDJAXVeAw-YihVMNtXt-uEs&r=bUMaNc7nC9xbXtaMJrOvIIPNpPH0chY2kdRsskQn6GY&m=rx_5ntfhkt2GOpfjpiQjoCb5n4gCY7jKznXO0gKYcVI&s=arwniVbdl5KJZfyreWLhq-WUlgvKAf_eW1i6D2GbFGQ&e=
