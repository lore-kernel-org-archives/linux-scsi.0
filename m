From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: NAA identifiers with scsi_id
Date: Tue, 15 Jun 2004 14:54:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040615145421.A23070@beaverton.ibm.com>
References: <40CF0A29.2010308@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:28821 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265983AbUFOVyi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 17:54:38 -0400
Content-Disposition: inline
In-Reply-To: <40CF0A29.2010308@suse.de>; from hare@suse.de on Tue, Jun 15, 2004 at 04:39:37PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: hotplug <linux-hotplug-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

Hannes -

On Tue, Jun 15, 2004 at 04:39:37PM +0200, Hannes Reinecke wrote:
> Hi all,
> 
> having checked scsi_id, I found out that it will always prefer NAA ids 
> in favour of any other types (EUI-64 et.al.).
> 
> This is not very helpful if scsi_id is used to generate meaningful 
> persistent driver ids, as the user might want to check the links created 
> by udev against the device list presented by the system (e.g. via 
> 'dmesg' or 'cat /proc/scsi/scsi' or even by scanning sysfs).
> 
> Can't we just ignore NAA ids and fall back to page 0x80 + inquiry if 
> these are all we will get via page 0x83? Just having an arbitrary number 
> is not very helpful and totally intransparent to the user.

No.

Some reasons we should not do this:

1) No matter what page or method we use there is a rather arbitrary number,
it is just that for page 0x80 or a page 0x83 vendor specific id, scsi_id
prepends the vendor and model before the id, this is done to ensure the
value is unique across all vendors and models, not so users can more
easily match an id to an actual device.

Some (well not your standard desktop pc) systems will be connected to
multiple LUNs that all have the same vendor and model, and having the
vendor model pre-pended does not make finding them any easier.


2) a device might support only page 0x83 NAA, so falling back to page
0x80 could give nothing.


3) For some disk arrays, page 0x80 gives the same result for all LUNs -
generally it's broken, or it is the serial number of the target not of any
particular LUN. In the past, pre page 0x83 support, vendor and model
specific code had to be added to most disk arrays to create a unique id
based on page 0x80, for example by appending the LUN to the page 0x80
value.

I picked the NAA IEEE extended as the highest priority, as I interpreted
the standard to imply it can be extended to support unique naming of LUNs
on a system, where you can create and remove LUNs. And, that is the only
value I see returned by a fastt 200.

For example, I have a system with one fastt 200 and 32 LUNs, the page 0x80
for each is identical (I don't know why it has T05078426, I also have some
serveraid storage attached that can't handle page 0x80 or 0x83):

0:0:0:0: Invalid page 0x80
./foo.sh failed for device sda
3:0:0:24: SIBM     3542           1T05078426      
3:0:0:25: SIBM     3542           1T05078426      
3:0:0:26: SIBM     3542           1T05078426      
3:0:0:27: SIBM     3542           1T05078426      
3:0:0:28: SIBM     3542           1T05078426      
3:0:0:29: SIBM     3542           1T05078426      
3:0:0:30: SIBM     3542           1T05078426      
3:0:0:31: SIBM     Universal Xport1T05078426      
0:0:1:0: Invalid page 0x80
./foo.sh failed for device sdb
3:0:0:0: SIBM     3542           1T05078426      
3:0:0:1: SIBM     3542           1T05078426      
3:0:0:2: SIBM     3542           1T05078426      
3:0:0:3: SIBM     3542           1T05078426      
3:0:0:4: SIBM     3542           1T05078426      
3:0:0:5: SIBM     3542           1T05078426      
3:0:0:6: SIBM     3542           1T05078426      
3:0:0:7: SIBM     3542           1T05078426      
3:0:0:8: SIBM     3542           1T05078426      
3:0:0:9: SIBM     3542           1T05078426      
3:0:0:10: SIBM     3542           1T05078426      
3:0:0:11: SIBM     3542           1T05078426      
3:0:0:12: SIBM     3542           1T05078426      
3:0:0:13: SIBM     3542           1T05078426      
3:0:0:14: SIBM     3542           1T05078426      
3:0:0:15: SIBM     3542           1T05078426      
3:0:0:16: SIBM     3542           1T05078426      
3:0:0:17: SIBM     3542           1T05078426      
3:0:0:18: SIBM     3542           1T05078426      
3:0:0:19: SIBM     3542           1T05078426      
3:0:0:20: SIBM     3542           1T05078426      
3:0:0:21: SIBM     3542           1T05078426      
3:0:0:22: SIBM     3542           1T05078426      
3:0:0:23: SIBM     3542           1T05078426      


Page 0x83 for all of the above gives (weird that LUNs 1, 3 and 31 have a
different prefix, that is they start with 3600a0b80000b18a5000000 rather
than with 3600a0b80000b1b7f000000):

0:0:0:0: Invalid page 0x83
./foo.sh failed for device sda
3:0:0:24: 3600a0b80000b1b7f0000009b3fd5f394
3:0:0:25: 3600a0b80000b1b7f0000009c3fd5f39c
3:0:0:26: 3600a0b80000b1b7f0000009d3fd5f3a6
3:0:0:27: 3600a0b80000b1b7f0000009e3fd5f3ae
3:0:0:28: 3600a0b80000b1b7f0000009f3fd5f3b8
3:0:0:29: 3600a0b80000b1b7f000000a03fd5f3c0
3:0:0:30: 3600a0b80000b1b7f000000a13fd5f3ca
3:0:0:31: 3600a0b80000b18a50000001d00000000
0:0:1:0: Invalid page 0x83
./foo.sh failed for device sdb
3:0:0:0: 3600a0b80000b1b7f000000853fd5f2bc
3:0:0:1: 3600a0b80000b18a50000001b3fd5f387
3:0:0:2: 3600a0b80000b1b7f000000863fd5f2ce
3:0:0:3: 3600a0b80000b18a50000001c3fd5f399
3:0:0:4: 3600a0b80000b1b7f000000873fd5f2de
3:0:0:5: 3600a0b80000b1b7f000000883fd5f2e8
3:0:0:6: 3600a0b80000b1b7f000000893fd5f2f0
3:0:0:7: 3600a0b80000b1b7f0000008a3fd5f2f8
3:0:0:8: 3600a0b80000b1b7f0000008b3fd5f302
3:0:0:9: 3600a0b80000b1b7f0000008c3fd5f30a
3:0:0:10: 3600a0b80000b1b7f0000008d3fd5f312
3:0:0:11: 3600a0b80000b1b7f0000008e3fd5f31c
3:0:0:12: 3600a0b80000b1b7f0000008f3fd5f324
3:0:0:13: 3600a0b80000b1b7f000000903fd5f32c
3:0:0:14: 3600a0b80000b1b7f000000913fd5f336
3:0:0:15: 3600a0b80000b1b7f000000923fd5f33e
3:0:0:16: 3600a0b80000b1b7f000000933fd5f348
3:0:0:17: 3600a0b80000b1b7f000000943fd5f350
3:0:0:18: 3600a0b80000b1b7f000000953fd5f35a
3:0:0:19: 3600a0b80000b1b7f000000963fd5f364
3:0:0:20: 3600a0b80000b1b7f000000973fd5f36c
3:0:0:21: 3600a0b80000b1b7f000000983fd5f376
3:0:0:22: 3600a0b80000b1b7f000000993fd5f382
3:0:0:23: 3600a0b80000b1b7f0000009a3fd5f38a

Here's the script I used to generate the above, I ran it with:

sh ./foo.sh -g -i -p 0x80

And:

sh ./foo.sh -g -i -p 0x83

-------------- cut here ---------------
#! /bin/sh

scsi_id=/sbin/scsi_id
opts=$*

sysfs_dir=$(mount | awk '$5 == "sysfs" {print $3}')
if [ "$sysfs_dir" = "" ]
then
        sysfs_dir="/sys"
        echo "Using sysfs mount point \"$sysfs_dir\"" >&2
fi

c=$(ls /${sysfs_dir}/block/sd* 2>/dev/null | wc -l)
if [ $c = 0 ]
then
        echo $0 no block devices present >&2
        exit 1
fi

cd ${sysfs_dir}/block
for name in sd*
do
        id=$($scsi_id ${opts} -s /block/$name)
        if [ $? != 0 ]
        then
                echo $0 failed for device $name >&2
        else
                echo ${id}
        fi
done

-- Patrick Mansfield
