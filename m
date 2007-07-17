From: Matthew Wilcox <matthew@wil.cx>
Subject: sim710_device_remove seems buggy
Date: Tue, 17 Jul 2007 10:55:21 -0600
Message-ID: <20070717165521.GE14791@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58805 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542AbXGQQzW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 12:55:22 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Hirst <rhirst@levanta.com>
Cc: linux-scsi@vger.kernel.org


Hi Richard,

I was looking for inspiration in sim710 when I found what appears to me
to be a bug.  Your implementation of sim710_device_remove does:

sim710_device_remove(struct device *dev)
{
        struct Scsi_Host *host = dev_to_shost(dev);

Now, this is going to be called with the struct device corresponding to
either the MCA or EISA device which is the *parent* of the shost.
dev_to_shost only looks upwards in the tree, so it will never find the
shost.

Unfortunately, I don't have a good idea about how to solve this.  The
least lame perhaps is to have separate routines for EISA and MCA
devices, each of which passes the shost to this routine.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
