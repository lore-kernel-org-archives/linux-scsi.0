From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: [RFC] Deprecate, modify, or do nothing to SCSI_IOCTL_GET_IDLUN
Date: Mon, 24 Nov 2014 00:15:37 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB3BF09579@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:46458 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaKXAQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Nov 2014 19:16:16 -0500
Received: from G4W6310.americas.hpqcorp.net (g4w6310.houston.hp.com [16.210.26.217])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by g4t3426.houston.hp.com (Postfix) with ESMTPS id 71C9E161
	for <linux-scsi@vger.kernel.org>; Mon, 24 Nov 2014 00:16:15 +0000 (UTC)
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

I'd like to ask if SCSI_IOCTL_GET_IDLUN should be deprecated? This is in response to [Bug 88591] SCSI_IOCTL_GET_IDLUN only returns 8 bits for the SCSI Target value of which has been seen on the mailing list.

It only returns one byte of id, lun, channel, and host number but we have SG_GET_SCSI_ID which fills a structure with a separate int for each of those 4 values.

There's two choices in terms of deprecation. The first is immediately deprecating it by moving it in scsi_ioctl() the other deprecated ioctls so it no longer works ad issues a warning or the second keep it working for the time being and add the following before it returns 0 from that function:

	if (printk_ratelimit())
		printk (KERN_WARNING "program %s is using a deprecated SCSI "
			"ioctl SCSI_IOCTL_GET_IDLUN, please convert it to use SG_GET_SCSI_ID \n",
			 current->comm);

After some suitable period of time move it to the other deprecated ioctls scsi_ioctl() where it will stop working and print the same deprecation message as other deprecated ioctls. 

Alternative 3 is to look at the values being compacted into the 4 bytes and if any of id, lun, channel or host overflow their single byte compacted value return -EOVERFLOW if any do and then provide a hint to the caller that they should be using SG_GET_SCSI_ID instead. That would instead change the return 0 in scsi_ioctl() for SCSI_IOCTL_GET_IDLUN to be something like:

		if ((sdev->id > 0xff) || (sdev->lun > 0xff) || (sdev->channel > 0xff)
			|| (sdev->host->host_no > 0xff)) {
			printk(KERN_WARNING "program %s - overflow in ioctl SCSI_IOCTL_GET_IDLUN, "
				"please convert it to use SG_GET_SCSI_ID\n", current->comm);
			return -EOVERFLOW;
		} else {
			return 0;
		}

It allows backwards compatibility (it will still overflow in exactly the same way) and for a lot of systems it will still work for most uses but provides an indication that something has gone wrong and the data returned shouldn't be relied upon to be valid when any of the information has overflowed what it's been stored in. 

Alternative 4 is do nothing people should understand the limitations of what ioctls they use (they have the source) and TLDP documents SG_GET_SCSI_ID so anyone using SCSI_IOCTL_GET_IDLUN should be aware of the fact that there are alternative SG ioctls with wider values for id, lun, channel, and host number.

There may be other possibilities that I've overlooked. After some consensus about what should be done I'm happy to put together a patch for review.
