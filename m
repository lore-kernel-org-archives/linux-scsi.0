From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 3/8] aacraid: handle AIF hotplug events
Date: Mon, 19 Sep 2005 15:28:20 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F019B0612@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:13202 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932603AbVIST2V convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Sep 2005 15:28:21 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

I retract my statement.

	scsi_remove_device(device);
	scsi_host_put(dev->scsi_host_ptr);
	goto break_out_of_loop;

Should work fine. Using 'break' in a switch statement is not going to
break out of the loop.

Sincerely -- Mark Salyzyn


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Salyzyn, Mark
Sent: Monday, September 19, 2005 2:28 PM
To: Mark Haverkamp
Cc: James Bottomley; Christoph Hellwig; linux-scsi
Subject: RE: [PATCH 3/8] aacraid: handle AIF hotplug events


The problem is, breaking out of the shost_for_each_device requires a put
on the device and we can no longer use it as an argument to
scsi_remove_device.

And if we decided to do so, what other race condition are we going to
trigger?

Sincerely -- Mark Salyzyn


-----Original Message-----
From: Mark Haverkamp [mailto:markh@osdl.org] 
Sent: Monday, September 19, 2005 1:57 PM
To: Salyzyn, Mark
Cc: James Bottomley; Christoph Hellwig; linux-scsi
Subject: RE: [PATCH 3/8] aacraid: handle AIF hotplug events


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
> scsi_remove_device() and can cause a panic in __scsi_iterate_devices 
> () in 1 out of between 100 to 1000 tries.
> 
> Any suggestions? Pulling scsi_remove_device call(s) out of the loop
> only serves to open up a race condition. This patch has yet to migrate

> into scsi-misc-2.6, probably wise to hold off until the root cause can

> be dealt with.

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

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
