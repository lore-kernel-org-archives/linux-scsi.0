From: Oliver Neukum <oneukum@suse.de>
Subject: [PATCH 0/2]error handling in sd_suspend()
Date: Fri, 8 Oct 2010 15:31:25 +0200
Message-ID: <201010081531.25724.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51854 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683Ab0JHNbd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Oct 2010 09:31:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, hare@suse.de, Alan Stern <stern@rowland.harvard.edu>, teheo@suse.de, linux-scsi@vger.kernel.org

Hi,

I've encountered a problem when sd_suspend() races disconnect
handling of SATA. This race can lead to needlessly aborted suspensions.
To avoid this problem. I suggest evaluating the error returns from the lower
layers, to tell us whether a problem is transient or totally unrecoverable.
If a transient problem occurs we should not go to sleep and in some
cases suggest that the upper layer retry. An unrecoverable error, such
as a device going away can be ignored.

	Regards
		Oliver
