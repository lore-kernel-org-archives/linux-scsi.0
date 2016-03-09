From: Hans de Goede <hdegoede@redhat.com>
Subject: "scsi: use host wide tags by default" causes uas regression
Date: Wed, 9 Mar 2016 18:58:48 +0100
Message-ID: <56E06458.7040101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933805AbcCIR6x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Mar 2016 12:58:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, funnybutton@mailinator.com

Hi Christoph,

I've received a bug report that uas is causing a 2-disk enclosure to
lookup with 4.4 and later:

https://bugzilla.redhat.com/show_bug.cgi?id=1315013

Looking at the dmesg this stands out:

Mar 09 01:55:21 larry kernel: sd 2:0:0:1: [sdc] tag#31 uas_eh_abort_handler 0 uas-tag 32 inflight: CMD OUT
Mar 09 01:55:21 larry kernel: sd 2:0:0:1: [sdc] tag#31 CDB: Write(10) 2a 00 e8 10 f4 00 00 04 00 00

Specifically the uas-tag 32, technically that is correct, but we have been avoiding
actually submitting commands with that tag because bulk-streams are numbered 1-x
and I was afraid that actually using the full-range would trigger off-by-one
errors in devices and it looks I was right.

Before your patch uas was doing:

@@ -929,10 +928,6 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
  	if (result)
  		goto set_alt0;

-	result = scsi_init_shared_tag_map(shost, devinfo->qdepth - 2);
-	if (result)
-		goto free_streams;
-
  	usb_set_intfdata(intf, shost);
  	result = scsi_add_host(shost, &intf->dev);
  	if (result)

With devinfo->qdepth being 32 in this case, so the end-result would be passing
30 to scsi_init_shared_tag_map, reserving one tag for untagged commands and one
tag for the off-by-one thingie.

We also have:

static int uas_slave_configure(struct scsi_device *sdev)
{
	...
         scsi_change_queue_depth(sdev, devinfo->qdepth - 2);
	...
}

But that only helps with single lun enclosures, so I guess that once we fix the issue that
line can actually go.

So my question is how do I tell the scsi layer to not submit more then X commands with
scsi_init_shared_tag_map() gone ?

Regards,

Hans
