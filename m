From: Joe Scsi <joe.scsi@gmail.com>
Subject: LUN discovery by SCSI midlayer?
Date: Mon, 14 Feb 2005 20:35:25 -0800
Message-ID: <7526e30505021420354e6a1707@mail.gmail.com>
Reply-To: Joe Scsi <joe.scsi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from wproxy.gmail.com ([64.233.184.198]:34518 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261622AbVBOEf3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Feb 2005 23:35:29 -0500
Received: by wproxy.gmail.com with SMTP id 68so859362wri
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2005 20:35:26 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm working on a driver for a SCSI protocol that is transported over a network.
My basic plan is that when the driver is loaded, it will create a SCSI
host structure
for its initiator port.  Then target ports will be discovered
asynchronously (and
may appear/disappear as target devices come and go on the network).

I'm wondering what the best way to handle LUN discovery is.  Unfortunately it
seems that scsi_add_device() can only add a single LUN at a time.  However,
for my protocol, I see target ports and then need to find the LUNs.  So far I've
come up with a couple of ideas but I'm not totally happy with either:

  (ugly) Do all the REPORT_LUNs stuff in my driver every time I find a new
  target port, or

  (ab)use the "channel" index and call scsi_scan_single_target() every time
  I connect to a new target port.  This seems OK but I'm a little put off by the
  fact that a quick grep shows no callers of scsi_scan_single_target in the
  current kernel tree.

So what is the correct way to handle this?  I'm sure the FC and iSCSI people
must have dealt with a similar issue.

Thanks,
  Joe
