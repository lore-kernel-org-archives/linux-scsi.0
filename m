From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] configfs: Fix race between create_link and
 configfs_rmdir
Date: Fri, 09 Jun 2017 00:05:03 -0700
Message-ID: <1496991903.28997.74.camel@haakon3.risingtidesystems.com>
References: <1496897514-20142-1-git-send-email-nab@linux-iscsi.org>
         <20170608072129.GA13433@lst.de>
         <c76cb2bd-726b-7334-ae74-f2870390efb6@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c76cb2bd-726b-7334-ae74-f2870390efb6@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, target-devel <target-devel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Joel Becker <jlbec@evilplan.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-06-08 at 07:34 -0500, Bryant G. Ly wrote:
> > Thanks Nic,
> >
> > applied to the configfs-for-next tree.  I'm not entirely sure if we
> > should bother adding this to 4.12 or if it hits rarely enough?
> >
> It hits for us pretty often when we have a GPFS setup with 10 hosts and 1k+ vms.
> 
> That is how we discovered the bug in the first place.
> 

Using a DATERA workload with 1K unique multi-tenant backend devices and
1K unique iscsi-target IQNs per node, I've never tripped across this
particular bug..

However, our userspace built atop rtslib is enforcing tenant shutdown of
individual rmdir(2) of /sys/kernel/config/target/$FABRIC/$WWN/$TPGT/,
before rmdir(2) of /sys/kernel/config/target/core/$HBA/$DEV/ occurs.

Based on Bryant's original backtrace with targetcli, it looks like the
Novalink user-space is not enforcing this requirement across user-space
processes doing fabric port symlink and backend device shutdown.

That said it probably doesn't need a special v4.12-rc PULL, but based on
Bryant's feedback it certainly does deserve a stable CC'.
