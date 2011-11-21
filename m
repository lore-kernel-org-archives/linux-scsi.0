From: Petr Tesarik <ptesarik@suse.cz>
Subject: Locking scheme of /proc/scsi/scsi
Date: Mon, 21 Nov 2011 18:32:35 +0100
Message-ID: <201111211832.35865.ptesarik@suse.cz>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384Ab1KURci (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Nov 2011 12:32:38 -0500
Received: from relay2.suse.de (nat.nue.novell.com [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 8C9FF8C061
	for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2011 18:32:37 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi folks,

I've been working on a kernel crash dump of an ancient kernel recently, and I 
have come to the conculsion that walking the scsi devices via 
bus_find_device() is completely flawed. While looking for an upstream fix, I 
didn't find any, so the same flaw is probably still there. However, let me ask 
here to check how this is supposed to work.

First, this is how I understand the issue. The "/proc/scsi/scsi" file is 
handled as a pretty standard seqfile, iterating over the devices with the 
following function:

static inline struct device *next_scsi_device(struct device *start)
{
	struct device *next = bus_find_device(&scsi_bus_type, start, NULL,
					      always_match);
	put_device(start);
	return next;
}

The returned value is used for the next iteration. Now, bus_find_device() 
assumes that the device is still attached to the knode_bus klist, because 
that's how it initializes the klist iterator. When it finds the next device, 
it increments the reference count on the device with get_device(), but it 
doesn't do anything about the knode_bus field. So, when somebody calls 
scsi_remove_device() on the current device between two calls to 
next_scsi_device, then it does:

	if (sdev->is_visible) {
[...]
		device_del(dev);

which in turn calls:

	bus_remove_device(dev);

which does:

		if (klist_node_attached(&dev->p->knode_bus))
			klist_del(&dev->p->knode_bus);

So, even though the struct device has a non-zero refcount, the code in 
next_scsi_device cannot continue, because it only has a stale pointer to an 
already detached klist, right?

At least that's what I saw in 2.6.16, and I can still see the same thing 
possible in 3.1.

Please, include my mail in your replies, because I'm not subscribed to linux-
scsi.

Petr Tesarik
SUSE LINUX
