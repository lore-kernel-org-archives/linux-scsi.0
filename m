From: James.Smart@Emulex.Com
Subject: RE: [PATCH] [Update] suspending I/Os to a device
Date: Sat, 4 Sep 2004 19:15:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F1A5@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:53985 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S264531AbUIDXPw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Sep 2004 19:15:52 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, andmike@us.ibm.com

> lpfc also wants to attach driver private data to sdev_target. 
>  Currently it
> uses sdev->hostdata for per-target data and gets the lifetime 
> rules wrong.

This reply sounds fishy. Don't know what point you're trying to make.

The things I'd expect to be attached to the sdev_target would be things under the fc_transport. For example - Port Attributes from hbaapi, or the consistent binding information. I don't know of anything driver-private that we would put there. Even so, in a long-term design, I would think that a LLDD should be allowed to - just like it can on the sdev.

As for the hostdata - I don't see any api violation. Hostdata is whatever context the driver wants when it receives commands for a lun. In a general sense - yes, this is typically a lun structure. However, it doesn't have to be. The only real rule is that it is a valid context for the lun during the duration between slave_alloc & free. In our case, the adapter interface doesn't track luns - it tracks remote nports (aka targets). Thus the context is a more general target structure.

-- james s

