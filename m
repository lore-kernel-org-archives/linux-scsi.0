From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: lsscsi-0.09
Date: Fri, 4 Apr 2003 10:48:51 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030404104851.A10484@beaverton.ibm.com>
References: <3E8D1D76.7050203@torque.net> <20030404124617.A24518@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:43442 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S263885AbTDDSmR (for <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Apr 2003 13:42:17 -0500
Content-Disposition: inline
In-Reply-To: <20030404124617.A24518@infradead.org>; from hch@infradead.org on Fri, Apr 04, 2003 at 12:46:17PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

On Fri, Apr 04, 2003 at 12:46:17PM +0100, Christoph Hellwig wrote:

> That reminds me that I wanted to get rid of /proc/scsi/scsi eventually.
> Does someone have an idea for a replacement of it's write routine?
> Some of them don't fit nicely into the sysfs model unfortunatley.

Yes ...

We need a place for scsi driver, and one for scsi_host before we can
replace them. The scsi sysfs stuff Mike A's working on should add both,
though we end up with one "scsi driver" appearing as a scsi_host driver,
though it is both the scsi_host and scsi_device driver (the scsi core
driver).

We also need (ref count) release functions working in order to handle the
scsi_device (or LU) removal - Mike's offline changes include this (correct
me if wrong). That is, the sysfs attribute file is still open after the
scsi_device (LU) is removed.

We have scsi proc writes for:

	adapters
	device_info (bflags, or black/white flags)
	dumping
	logging
	scanning (add/remove scsi_device or a single LU)

IMO scsi_dump_status should go away, or be replaced with a more minimal
version - the one and only time I tried to use it (a while ago), it
oopsed.

Replacement of adapter proc writes has to be handled by adapter driver
code (I'm not sure what that really means) some will probably never be
converted, and we end up with some dead (adapter) code or eventually
adapters that don't compile.

I was thinking we could have add and delete like attributes for the
device_info and scanning, kind of like Doug mentioned we have with
scsi_debug, but without (too much) overloading of the attribute file.

This would be like adding support to sysfs to allow creation and removal
of entries on a list, I thought there was a pci sysfs patch for something
like this for use with PCI ID's or ???, but I haven't found (nor searched
to hard) for it. Too bad we can't just mkdir and touch files under sysfs.

scsi add/remove host is a new interface that could also use an add/delete
sysfs interface. 

For scanning, assuming we have a scsi_host represented as host3 (some
scsi_device attributes deleted to shorten this):

scsi-host/
|-- host3
|   |-- 3:0:10:0
|   |   |-- model
|   |   |-- name
|   |   |-- queue_depth
|   |   |-- rescan
|   |   |-- rev
|   |   |-- scan
|   |   |-- scsi_level
|   |   `-- type
|   |-- 3:0:11:0
|   |   |-- model
|   |   |-- name
|   |   |-- queue_depth
|   |   |-- rescan
|   |   |-- rev
|   |   |-- scan
|   |   |-- scsi_level
|   |   `-- type
|   `-- scan
`-- scan

[names above might not be good, especially rescan vs scan, maybe rescan
can be renamed capacity_changed. Or scan and rescan can handle combined
functions: rescanning a scsi_device could be just an upper level rescan,
but this might also be a good way refresh scsi_device.inquiry, ot to spin
up]

To scan (or rescan?) the host i.e. call scsi_scan_host (3):

	echo "-:-:-" > host3/scan

To scan a target (no kernel function right now):

	echo "2:3:-" > host3/scan

To scan a single LU, i.e. call scsi_add_device (3, 2, 3, 4):

	echo "2:3:4" > host3/scan

[We should really have just one scan function, or at least eventually call
the same function for all scan and rescanning. i.e. scsi_scan (host, chan,
id, lun), and have wild card values or NULL to allow full scanning of a
host, chan, or id. For example, to scan a target, we would call scsi_scan
(1, 2, 3, NULL). Plus we might need a flag that says we are new or
rescanning.]

Remove a LU:

	echo delete > host3/3:0:11:0/scan

To remove a host:

	echo delete > host3/scan

Hopefully, a layout like the above will not impede a move towards complete
user level scanning.

I don't know how to handle adding a host, since we really need to know
what host might be there before we ask to add it - we have to already have
some mapping of a host to a an adapter (we have to know that an adapter is
a scsi_host). scsi_debug handles this OK since it can always add a host.

I'm not sure how to scan (or rescan) all hosts.

For device_info, we could add attributes under scsi-driver, like:

scsi-driver/
`-- bwflags
    |-- add
    `-- vendor
        |-- Aashima
        |   `-- IMAGERY 2400SP
        |       |-- bwflags
        |       `-- del
        |-- MAXTOR
        |   |-- XT-3280
        |   |   |-- bwflags
        |   |   `-- del
        |   `-- XT-4380S
        |       |-- bwflags
        |       `-- del
        `-- SONY
            `-- CD-ROM CDU-8001
                |-- add
                `-- bwflags

To add a new device_info:

	echo "IBM:AuSaV1S2:0x2" > scsi-driver/bwflags/add

To remove one:
	
	echo delete > scsi-driver/bwflags/MAXTORXT-3280/del

The above could be treated more on a per directory basis, i.e. add a
vendor, then add product (model), then set the bwflags for the
vendor/product. Like:
	
	echo IBM > scsi-driver/bwflags/add
	echo AuSaV1S2 > scsi-driver/bwflags/IBM/add
	echo 0x2 scsi-driver/bwflags/IBM/AuSaV1S2/bwflags

To see a bwflag you would use:

	cat scsi-driver/bwflags/vendor/product/bwflags


Logging could also be done via scsi-driver, like:

scsi-driver/logging/
|-- all
|-- error
|-- mlqueue
`-- scan

To turn on all logging (set scsi_logging_level = ~0):

	echo 1 > scsi-driver/logging/all

Turn off all logging:

	echo 0 > scsi-driver/logging/all

Turn on scan logging level 4:

	echo 4 > scsi-driver/logging/scan

-- Patrick Mansfield
