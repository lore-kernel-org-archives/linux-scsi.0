From: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Subject: CONFIG_SCSI_MQ_DEFAULT cause slow direct write speed to usb stick
Date: Tue, 10 Feb 2015 19:50:36 +0100
Message-ID: <20150210195036.3dce0e9e@bigpc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.HRZ.tu-dortmund.de ([129.217.128.51]:40661 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbbBJT0I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Feb 2015 14:26:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de, martin.petersen@oracle.com, elliott@hp.com

Hi,

i had found a problem with CONFIG_SCSI_MQ_DEFAULT config option. If it
activated, then the write speeds to the /dev/sd* of an usb stick drops
dramatically: it's only about 250 kb/CONFIG_SCSI_MQ_DEFAULTs, but
should be about 7 Mb/s. Git bisect also points to commit
24c20f10583647e30afe87b6f6d5e14bc7b1cbc6 'scsi: add a
CONFIG_SCSI_MQ_DEFAULT option' (i always set CONFIG_SCSI_MQ_DEFAULT to
y, because it sounded interesting). Same problem is also in 3.19
present. Write speeds to a filesystem on that USB-Stick were not so
bad, but as i tried to dd in Live-DVD Ubuntu image it was painfully
slow. After i disabled CONFIG_SCSI_MQ_DEFAULT write speeds are back to
normal.

I created bug report in bugzilla:
https://bugzilla.kernel.org/show_bug.cgi?id=92571

Regards,
Andrej
