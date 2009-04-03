From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] osdblk: a Linux block device for OSD objects
Date: Fri, 03 Apr 2009 06:14:02 -0400
Message-ID: <49D5E16A.80104@garzik.org>
References: <20090402015455.GA14087@havoc.gtf.org> <1238722324.13399.25.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:36687 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787AbZDCKOH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Apr 2009 06:14:07 -0400
In-Reply-To: <1238722324.13399.25.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, Andrew Morton <akpm@linux-foundation.org>

James Bottomley wrote:
>> +   1) Map a Linux block device to an existing OSD object.
>> +
>> +      In this example, we will use partition id 1234, object id 5678,
>> +      OSD device /dev/osd1.
>> +
>> +      $ echo "1234 5678 /dev/osd1" > /sys/class/osdblk/add
>> +
>> +
>> +   2) List all active blkdev<->object mappings.
>> +
>> +      In this example, we have performed step #1 twice, creating two blkdevs,
>> +      mapped to two separate OSD objects.
>> +
>> +      $ cat /sys/class/osdblk/list
>> +      0 174 1234 5678 /dev/osd1
>> +      1 179 1994 897123 /dev/osd0
> 
> This is a slight violation of the one piece of data per sysfs file
> rule ... might it not be better as a file named <partid>-<objid> linking
> to the osd device location in sysfs?

Yeah...   I leaned more towards a consolidated table, as it was 
elegantly implemented in just a few lines of code, including locking :)


>> +      The columns, in order, are:
>> +      - blkdev unique id
>> +      - blkdev assigned major
>> +      - OSD object partition id
>> +      - OSD object id
>> +      - OSD device
>> +
>> +
>> +   3) Remove an active blkdev<->object mapping.
>> +


>> +	unsigned long		obj_id;
>> +	char			osd_path[0];
>> +};
>> +
>> +static struct class *class_osdblk;		/* /sys/class/osdblk */
>> +static struct mutex ctl_mutex;	/* Serialize open/close/setup/teardown */
>> +static struct osdblk_device *osdblk_devs[OSDBLK_MAX_DEVS];
> 
> Might it not be better to do this as a linked list on the private dev
> structure instead?  This only works if you have one entry
> in /sys/class/osdblock per device because now you have a device private
> pointer to hang it off

converted to list



>> +static int osdblk_get_free_req(struct osdblk_device *osdev)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < OSDBLK_MAX_REQ; i++) {
>> +		if (!osdev->req[i].rq)
>> +			return i;
>> +	}
> 
> Rather than using a static list of outstanding requests, I think you
> could probably use the block tag handling infrastructure for all of this

converted to use blk-tag.c gadgetry

Thanks for the review!

	Jeff


