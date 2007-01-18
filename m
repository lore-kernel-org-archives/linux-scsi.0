From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Linux Virtual SCSI HBAs and Virtual disks
Date: Thu, 18 Jan 2007 01:38:55 +0100
Message-ID: <45AEC19F.3010203@s5r6.in-berlin.de>
References: <45AEA118.5030608@torque.net> <4ca60b48a895ce4b50ba227197649f1b@aboo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:41480 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbXARAjN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jan 2007 19:39:13 -0500
In-Reply-To: <4ca60b48a895ce4b50ba227197649f1b@aboo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aboo <aboo@aboo.org>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

aboo wrote:
> Also, I am facing another challenge which I wanted to ask. If the kernel or
> user space opens  a scsi device, there is no healthy way of identifying if a
> scsi device is open or not. The struct scsi_device does not have a field. I
> can see a openers field in the scsi_disk structure inside sd.c. I can see it
> incrimenting in sd_open(). What is the best to way to identify if a
> scsi_device id open by kernel (mount or volumes manager) or use application
> (fsck or dd)? When a destroy a scsi_host, it kills all the scsi_devices
> associated with it irrespective of those devices are open or not. Any
> thoughts?

I thought about this myself too while working on the sbp2 driver. This
is a low-level driver from the SCSI perspective and a high-level driver
from the FireWire perspective. It was possible to unload a FireWire
low-level driver which provided the interconnect to a SBP-2 LU while
that LU's device file was in use --- with the obvious result of sudden
loss of connection. As a simple solution, sbp2 now blocks unloading of
the FireWire low-level driver as long as it is logged in into a SBP-2
target (i.e. independent of actual usage of the device; longer than
actually necessary).

My idea for a more fine-grained solution was:

  - Add something like .slave_get(sdev) and .slave_put(sdev) to the
    scsi_host_template.
  - Let scsi_device_get() call shost->hostt->slave_get() if it exists.
    Let scsi_device_put() call shost->hostt->slave_put() if it exists.
  - In the two new hooks, an LLD can get and put whatever transport- or
    interconnect-related resources it needs, per LU.

However I never found this matter pressing enough to post a respective
patch here. From my perspective, it would have only been justified if
other LLDs besides sbp2 would have profited from it, and I was too busy
elsewhere to research that.
-- 
Stefan Richter
-=====-=-=== ---= =--=-
http://arcgraph.de/sr/
