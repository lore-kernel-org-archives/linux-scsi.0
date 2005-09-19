From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 3/8] aacraid: handle AIF hotplug events
Date: Mon, 19 Sep 2005 13:28:21 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F019B052C@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:46308 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932515AbVISR20 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Sep 2005 13:28:26 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

The construct:

	shost_for_each_device(device, dev->scsi_host_ptr) {
		if (!(the_device_that_is_to_be_changed))
			continue;
		. . .
		switch (device_config_needed) {
		. . .
		case DELETE:
			scsi_remove_device(device);
			break;
		}
	}

Under intensive testing by an OEM client is proving to be 'unstable'.
Apparently the expectation of locking/usage count that is part of the
shost_for_each_device() call is not immune to the call to
scsi_remove_device() and can cause a panic in __scsi_iterate_devices ()
in 1 out of between 100 to 1000 tries.

Any suggestions? Pulling scsi_remove_device call(s) out of the loop only
serves to open up a race condition. This patch has yet to migrate into
scsi-misc-2.6, probably wise to hold off until the root cause can be
dealt with.

Sincerely -- Mark Salyzyn
