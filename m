From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] SMR: Disrupting recording technology
 meriting a new class of storage device
Date: Thu, 13 Feb 2014 17:18:08 -0500
Message-ID: <20140213221808.GE11480@thunk.org>
References: <DDA2008BD25F9046BFFC83788E83AF7E8167D4D0@wdscexmb03>
 <20140207130014.GA5078@localhost.localdomain>
 <52F4E3AC.9060309@suse.de>
 <7DD506441A4CF644AAC1628B9A9C5EBC647EAC9E@wdscexmb06.sc.wdc.com>
 <20140211115739.GD5903@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140211115739.GD5903@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Jim Malina <Jim.Malina@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Albert Chen <Albert.Chen@wdc.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, James Borden <James.Borden@wdc.com>, Curtis Stevens <curtis.stevens@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 11, 2014 at 09:57:40AM -0200, Carlos Maiolino wrote:
> 
> Thanks for clarification, and, this just enforce my concept that ZBC protocol
> should be integrated in the generic block layer not make it device-mapper
> dependent. So, make this available to any device that supports it with or
> without the help of DM.

The kernel interface which I have proposed[1] on the linux-fsdevel
list is indeed something that would be integrated in the generic block
device layer.  My hope is that in the near future (I'm waiting for ZBC
prototypes to show up in Mountain View ;-) we will have a patches that
will allow Linux to recognize ZBC drives, and export the ZBC
functionality via the this interface.

[1] http://thread.gmane.org/gmane.linux.file-systems/81970/focus=82309

I also hope that in the near-term future we will have at least one
device-mapper "SMR simulator" which take a standard block device, and
add write-pointer tracking, and then export the same interface.  This
would allow file systems (perhaps btrfs) to experiment with working
with SMR drives, without having to wait for getting a hold of one of
the ZBC drives.  It would also allow people who are interested in
writing a device mapper shim layer which takes a SMR drive, and
exports a host-assisted block device.

Of course, the stacking of the device mapper layers:

	HDD <-> SMR_SIMULATOR <-> SMR_ADAPTER 

is basically a no-op except for introducing performance delays.  But
the idea here is not performance, but allow people to debug their
code.  So the use cases:

	HDD <-> SMR_SIMULATOR <-> SMR_ADAPTER <-> stock linux file system
	HDD <-> SMR_SIMULATOR <-> SMR_ADAPTER <-> ext4 modified to be SMR-friendly
	HDD <-> SMR_SIMULATOR <-> modified btrfs that supports ZBC

would eventually become:

	SMR HDD <-> SMR_ADAPTER <-> stock linux file system
	SMR_HDD <-> SMR_ADAPTER <-> ext4 modified to be SMR-friendly
	SMR_HDD <-> modified btrfs that supports ZBC

And while we wait for SMR_HDD's to become generally available to all
kernel developers, the existence of the device-mapper smr simulator
will enable us to start work on the device-mapper smr adapter, and
file systems that are either modified to be SMR-friendly, or modified
to work directly w/o any adapter layers with SMR drives.

Regards,

						- Ted
