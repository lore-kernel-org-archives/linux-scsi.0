From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 2/2] brd: Fix brd_direct_access with partitions
Date: Wed, 30 Jul 2014 11:34:02 -0400
Message-ID: <20140730153402.GP6754@linux.intel.com>
References: <53D7CDDD.1000302@gmail.com>
 <1406654379.2767.1.camel@rzwisler-mobl1.amr.corp.intel.com>
 <53D8D2C4.1030101@gmail.com>
 <53D8FE1F.1060009@plexistor.com>
 <53D8FEC7.8020804@plexistor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53D8FEC7.8020804@plexistor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, Nick Piggin <npiggin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 30, 2014 at 05:18:47PM +0300, Boaz Harrosh wrote:
> When brd_direct_access() is called on a partition-bdev
> it would access the wrong sector. And caller would then
> corrupt the device's data.
> 
> This is a preliminary fix, Matthew Wilcox has a patch
> in his DAX patchset which will define a global wrapper
> to bdev->bd_disk->fops->direct_access that will do the
> proper checks and translations before calling a driver
> global member. (The way it is done at the rest of the
> block stack)

Uh, no, let's just focus on getting the DAX code in instead of putting
in interim patches that will conflict.  Patch 4/22 is uncontroversial,
fixes this problem, has no dependencies, and is key to the rest of the DAX
patchset.  If this problem wants to be fixed, then put 4/22 in instead.
