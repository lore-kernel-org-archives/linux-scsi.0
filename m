From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] dpt_i2o changes for 2.6.2 kernel in support of 64 bit and bitrot (part 1)
Date: Mon, 5 Apr 2004 18:23:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F64F24F@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:19845 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S263503AbUDEWXx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Apr 2004 18:23:53 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>


Christoph Hellwig [mailto:hch@infradead.org] writes:
>On Mon, Apr 05, 2004 at 01:56:12PM -0400, Salyzyn, Mark wrote:
>> We need a means for an application to tell if a scsi device is 
>> currently in use; one of in-error or with any I/O still pending or 
>> opened or mounted.
>We had this a few times already.  If your applications wants to remove
a >volume it'll do exactly that, and that's expected behaviour in unix
land >where you have enough rope to shoot yourself in the foot.

You mean Linux land, all other operating systems, other UNIXii included,
offer the ability to determine if a device is in-use in a timely manner.
Does this mean Windoze has a feature that Linux does not have?

What about something more generic than being in scsi LLDD land, pick a
level ... however we do need to know if *any* of the possible slices for
a scsi addressed device object are in use, not just the individual
device exports.

	static int fn(struct device * dev, void * arg)
	{
        busy_arg * busy = (busy_arg *)arg;
        struct scsi_device * sdev = to_scsi_device(dev);

        if ((busy->host_no == sdev->host->host_no)
         && (busy->channel == sdev->channel)
         && (busy->id == sdev->id)
         && (busy->lun == sdev->lun))
		return magic_missing_dev_busy_check_routine(dev);
        return 0;
	}
	. . .
	static scsi_busy(host_no, channel, id, lun)
	{
	  busy_arg busy;
	  busy.host_no = host_no;
	  busy.channel = channel;
	  busy.id = id;
	  busy.lun = lun;
	  return bus_for_each_device(&scsi_bus_type, NULL, &busy, fn);
	}

>> Are there any suggestions, either for the application, or for the
scsi
>> driver to meter disk in-use?
>The simple answer is:  don't do it.

This would be unacceptable to our OEMs and users of our applications.
The fact that an operating system can not tell us that a specific device
is currently in-use would be considered criminal operating system
behavior along the lines of not being able to determine if a network
interface is up or down or a semaphore may, or may not, be taken. We are
not making abstract paintings for a living folks ...

In user land, lsmod tells us how many users of a module exist, what is
so secret about a scsi disk devices that we are afraid of telling them
if any of the access points are being used?

> As for userland tools making the system unsuable, try a simple
>
>	cat /dev/zero > /dev/kmem

Good to know ...

Sincerely -- Mark Salyzyn
