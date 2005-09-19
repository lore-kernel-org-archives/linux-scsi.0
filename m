From: Mark Haverkamp <markh@osdl.org>
Subject: RE: [PATCH 3/8] aacraid: handle AIF hotplug events
Date: Mon, 19 Sep 2005 10:57:21 -0700
Message-ID: <1127152642.30684.16.camel@markh1.pdx.osdl.net>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F019B052C@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:35025 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932532AbVISSAk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Sep 2005 14:00:40 -0400
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F019B052C@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@adaptec.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2005-09-19 at 13:28 -0400, Salyzyn, Mark wrote:
> The construct:
> 
> 	shost_for_each_device(device, dev->scsi_host_ptr) {
> 		if (!(the_device_that_is_to_be_changed))
> 			continue;
> 		. . .
> 		switch (device_config_needed) {
> 		. . .
> 		case DELETE:
> 			scsi_remove_device(device);
> 			break;
> 		}
> 	}
> 
> Under intensive testing by an OEM client is proving to be 'unstable'.
> Apparently the expectation of locking/usage count that is part of the
> shost_for_each_device() call is not immune to the call to
> scsi_remove_device() and can cause a panic in __scsi_iterate_devices ()
> in 1 out of between 100 to 1000 tries.
> 
> Any suggestions? Pulling scsi_remove_device call(s) out of the loop only
> serves to open up a race condition. This patch has yet to migrate into
> scsi-misc-2.6, probably wise to hold off until the root cause can be
> dealt with.

It looks like you only want to process one device.  Wouldn't you want to
break out of the shost_for_each_device after processing the
scsi_remove_device?  That way __scsi_iterate_devices() wouldn't get
called again after the device removal.

shost_for_each_device() {
        if ()
               continue;
        switch () {
        case DELETE:
              scsi_remove_device();
              break;
       }
       break;
}



-- 
Mark Haverkamp <markh@osdl.org>

