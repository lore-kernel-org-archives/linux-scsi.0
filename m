From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCHSET RFC] block/SCSI: implement in-kernel disk event
 handling
Date: Thu, 4 Nov 2010 11:37:57 -0700
Message-ID: <20101104183757.GA3883@linux.vnet.ibm.com>
References: <1288637081-5183-1-git-send-email-tj@kernel.org>
 <4CD2E83A.9020309@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CD2E83A.9020309@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, jack@suse.cz, James.Bottomley@HansenPartnership.com
List-Id: linux-scsi@vger.kernel.org

Douglas Gilbert <dgilbert@interlog.com> wrote:
<snip>
> Ideally I would like to see a way from the user space
> to uncouple a unit from the sd (or sr) driver, in a
> similar way to how an LLD can use
> scsi_device::no_uld_attach . That would restrict user
> space access to the bsg or sg driver. 

I am not sure if this is exactly what you want but you can unbind a
device from the sd driver today.

E.x.

# cd /sys/bus/scsi/drivers/sd
# ls
0:0:0:0  4:0:0:0  4:0:1:0  5:0:0:0  5:0:1:0  bind  unbind
# sg_map
/dev/sg0  /dev/sda
/dev/sg1  /dev/sdb
/dev/sg2  /dev/sdc
/dev/sg3  /dev/sdd
/dev/sg4  /dev/sde
# echo "5:0:1:0" > unbind
# ls
0:0:0:0  4:0:0:0  4:0:1:0  5:0:0:0  bind  unbind
# sg_map
/dev/sg0  /dev/sda
/dev/sg1  /dev/sdb
/dev/sg2  /dev/sdc
/dev/sg3  /dev/sdd
/dev/sg4

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
