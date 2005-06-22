From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Fibre Channel related crash
Date: Wed, 22 Jun 2005 10:28:32 -0700
Message-ID: <20050622172832.GA11128@us.ibm.com>
References: <1119361784.24150.47.camel@nalwalovaton>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1119361784.24150.47.camel@nalwalovaton>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

You should really run with a stock kernel before reporting problems to
these lists.

cc-ing linux-scsi, maybe someone there will give you more info about the
HSV110.

On Tue, Jun 21, 2005 at 08:49:44AM -0500, William Alberto Lovaton Tovar wrote:

> Jun 20 13:35:01 dnccor50 kernel:   Vendor: COMPAQ    Model: HSV110 (C)COMPAQ  Rev: 2001
> Jun 20 13:35:01 dnccor50 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
> Jun 20 13:35:01 dnccor50 kernel: qla2300 0000:07:03.0: scsi(0:0:1:2): Enabled tagged queuing, queue depth 32.
> Jun 20 13:35:01 dnccor50 kernel: SCSI device sdb: 167772160 512-byte hdwr sectors (85899 MB)
> Jun 20 13:35:01 dnccor50 kernel: sdb: asking for cache data failed
> Jun 20 13:35:01 dnccor50 kernel: sdb: assuming drive cache: write through
> Jun 20 13:35:01 dnccor50 kernel: SCSI device sdb: 167772160 512-byte hdwr sectors (85899 MB)
> Jun 20 13:35:01 dnccor50 kernel: sdb: asking for cache data failed
> Jun 20 13:35:01 dnccor50 kernel: sdb: assuming drive cache: write through
> Jun 20 13:35:01 dnccor50 kernel:  sdb:<6>Device sdb not ready.
> Jun 20 13:35:01 dnccor50 kernel: end_request: I/O error, dev sdb, sector 0

It isn't a fibre channel crash.

The device is (obviously) not ready. Usually, sd during probe spins up the
device, but the HSV110 is special cased, so we don't spin it up (send a
START STOP command), and it just keeps telling us it is still not ready.

Since it's a disk array, I don't know what a START / spinup means for it,
or why it is not ready. I would guess it has some sort of failure and is
waiting for you to fix it :)

You should check the device: verify its settings, check for failures,
and/or reset it; or maybe send it a START UNIT to the device.

You can try to dynamically modify the scsi_devinfo/bflags so it sends the
START STOP during probe: 

change the devinfo list (won't be reset to the original until you reload
scsi_mod), I don't know if I have this exactly right:

	echo "COMPAQ   :HSV110 (C)COMPAQ:0x0" > /proc/scsi/device_info

remove and re-scan for the device

	echo 1 > /sys/block/sd/device/delete
	echo "0 1 2" > /sys/class/scsi_host/host0/scan

And see what happens ... you should see some "spinning up disk ..."
messages.

-- Patrick Mansfield
