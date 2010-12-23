From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Boot failure with block/for-next
Date: Thu, 23 Dec 2010 09:27:21 -0600
Message-ID: <1293118041.3029.3.camel@mulgrave.site>
References: <1293038823.3019.89.camel@mulgrave.site>
	 <1293078673.3019.765.camel@mulgrave.site>
	 <20101223100956.GA15625@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101223100956.GA15625@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2010-12-23 at 11:09 +0100, Tejun Heo wrote:
> Hello, James.
> 
> On Wed, Dec 22, 2010 at 10:31:13PM -0600, James Bottomley wrote:
>  > Actually, surprisingly, bisection confirms it's this patch:
>  > 
>  > Author: Tejun Heo <tj@kernel.org>
>  > Date:   Wed Dec 8 20:57:42 2010 +0100
>  > 
>  >     sd: implement sd_check_events()
>  > 
>  > I can't quite see how yet.
> 
> Does the following patch fix the problem?  Thanks.
> 
> Subject: sd: don't clear media presence unless it's removable

No, still the same failure.  Here's an excised log of an unsuccessful
and successful disk probe:

/bin/sh: can't access tty; job control turned off
(initramfs) dmesg|grep sda
sd 2:0:1:0: [sda] 71132960 512-byte logical blocks: (36.4 GB/33.9 GiB)
sd 2:0:1:0: [sda] Write Protect is off
sd 2:0:1:0: [sda] Mode Sense: d3 00 10 08
sd 2:0:1:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
device: 'sda': device_add
PM: Adding info for No Bus:sda
 sda: unable to read partition table
sd 2:0:1:0: [sda] Attached SCSI disk
(initramfs) dmesg|grep sdb
sd 2:0:2:0: [sdb] 17942584 512-byte logical blocks: (9.18 GB/8.55 GiB)
sd 2:0:2:0: [sdb] Write Protect is off
sd 2:0:2:0: [sdb] Mode Sense: e3 00 10 08
sd 2:0:2:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
device: 'sdb': device_add
PM: Adding info for No Bus:sdb
 sdb: sdb1 sdb2
device: 'sdb1': device_add
PM: Adding info for No Bus:sdb1
device: 'sdb2': device_add
PM: Adding info for No Bus:sdb2
sd 2:0:2:0: [sdb] Attached SCSI disk

James
