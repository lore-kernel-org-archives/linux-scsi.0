From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [Patch RFC ver2] Add FC transport host statistics
Date: Mon, 18 Oct 2004 09:24:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0DD05AE@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch01.qlogic.com ([198.70.193.200]:20890 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S266835AbUJRQVw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2004 12:21:52 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Sunday, October 17, 2004 5:56 AM, James.Smart@Emulex.Com wrote:
> Christoph,
> 
> I've updated the patch relative to the following comments:
> 
> - Kill the "host_port" prefix. This has been done. See below.
> The "port" prefix remains in a couple of cases where I think
> it clarifies the attribute.
> 
> - uint64_t's converted to u64. Also, assuming this applies to
> other types, converted uint32_t's to u32's, and uint8_t's to u8's.
>

This looks really good.  I do have a couple of questions on how 
the sysfs tree handles multi-value values for entries.  For example:

	active_fc4s :  hex: 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f

The closest multi-value reprentation of a sysfs entry I could find 
was /sys/block/loop.*/stat, where the data appears to be space 
delimited with no base prefix (i.e. 'hex:').  Perhaps for 
consistency, we could represent the string similarly to what is done
for all hex-base values, prefix with '0x'?  i.e:

	active_fc4s :  0x40 0x41 0x42 0x43 0x44 0x45 0x46 0x47 0x48 0x49 0x4a 0x4b 0x4c 0x4d 0x4e 0x4f 0x50 0x51 0x52 0x53 0x54 0x55 0x56 0x57 0x58 0x59 0x5a 0x5b 0x5c 0x5d 0x5e 0x5f

Thanks,
Andrew
