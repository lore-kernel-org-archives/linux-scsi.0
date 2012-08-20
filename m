From: Olaf Hering <olaf@aepfle.de>
Subject: request size limit in scsi tape driver
Date: Mon, 20 Aug 2012 17:50:32 +0200
Message-ID: <20120820155032.GA14300@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:17255 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab2HTPvA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Aug 2012 11:51:00 -0400
Received: from probook.site
	(dslb-088-065-086-118.pools.arcor-ip.net [88.65.86.118])
	by smtp.strato.de (joses mo85) (RZmta 30.9 DYNA|AUTH)
	with (DHE-RSA-AES256-SHA encrypted) ESMTPA id k02a54o7KF8IFM
	for <linux-scsi@vger.kernel.org>;
	Mon, 20 Aug 2012 17:50:33 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Currently the st driver does not to break up write requests into smaller
chunks to satisfy the ->max_hw_sectors limit of the underlying host driver.

 # modprobe -v scsi_debug ptype=1 opts=1 dev_size_mb=123
 # dd if=/dev/zero of=/dev/st0 bs=$((1024*54321))

This leads to -EBUSY from this call chain:
st_write -> st_do_scsi -> st_scsi_execute -> blk_rq_map_user

What is the reason for this behaviour?
Should st_write write in smaller chunks, or would that break real
hardware because they expect certain block sizes?

The specific issue at hand I have is that the (out-of-tree) Xen pvscsi
has a ->max_hw_sectors limit of 200, which limits the block size in a
guest to 100K.


Olaf
