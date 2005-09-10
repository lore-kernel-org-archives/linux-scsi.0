From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: scsi device refcounting in sbp2 (was Re: [PATCH 3/8] aacraid:
 handle AIF hotplug events)
Date: Sat, 10 Sep 2005 23:16:52 +0200 (CEST)
Message-ID: <200509102116.j8ALGqt8011874@einhorn.in-berlin.de>
References: <1126374650.4813.56.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:59018 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932314AbVIJVRL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Sep 2005 17:17:11 -0400
In-Reply-To: <1126374650.4813.56.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Ben Collins <bcollins@debian.org>

James Bottomley wrote:
>> > scsi_add_device() returns an sdev on
>> > success with the refcount bumped up for you.  If you don't do a put,
>> > you'll be stuck with a device you can't get rid of.
>> > 
>> > However, all other users of scsi_add_device() make the same mistake ...
[...]
>> > I'll apply this patch and fix the API to return zero or error and not
>> > bump the sdev refcount.
[...]
> I've cc'd you on the patch (and it fixes sbp2 as it currently stands in
> the Linus tree, but it would conflict with the fix you have pending).

I was just trying to adapt that fix and stumbled upon potential problems
of my code. Two questions:

1. Is the following sequence safe?
[connect to device]
	sdev = __scsi_add_device();
	scsi_device_put(sdev);
	store sdev in sbp2's private data for later use
[sbp2 .remove hook]
	scsi_remove_device(sdev);

2. Is this safe?
[connect to device]
	sdev = __scsi_add_device();
	scsi_device_put(sdev);
[sbp2 .remove hook]
	scsi_remove_host(shost);
I ask because scsi_remove_host will implicitly remove the device too.

BTW, the following won't work:
[connect to device]
	sdev = __scsi_add_device();
	store sdev for later use
[sbp2 .remove hook]
	scsi_remove_device(sdev);
	scsi_device_put(sdev);
That way, "modprobe -r sbp2" would fail because sbp2 is "in use" until
scsi_device_put.

Thanks for advice,
-- 
Stefan Richter
-=====-=-=-= =--= -=-=-
http://arcgraph.de/sr/

