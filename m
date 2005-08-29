From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Mon, 29 Aug 2005 13:20:50 -0400
Message-ID: <431343F2.5060805@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A4B@xbl3.ma.emulex.com> <430B5CDB.9070204@s5r6.in-berlin.de> <430BB91F.7000406@vger.kernel.org> <20050824091230.GB26447@infradead.org> <430F398A.30200@adaptec.com> <430F6C56.1090801@pobox.com> <20050829171152.GA7875@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:6864 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1750982AbVH2RU7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 13:20:59 -0400
In-Reply-To: <20050829171152.GA7875@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>

On 08/29/05 13:11, Christoph Hellwig wrote:
> On Fri, Aug 26, 2005 at 03:24:06PM -0400, Jeff Garzik wrote:
> 
>>Luben Tuikov wrote:
>>
>>>Even simpler: the transport layer, calls SCSI Core, saying: "Hey here is
>>>a pointer to struct scsi_domain_device.  If you want, you an send REPORT
>>>LUNS and other things to it."
>>
>>For the SG_IO ioctl, /dev/sg and request_queue usage, SCSI core must map 
>>an address (currently HCIL) into a scsi_domain_device pointer.  These 
>>upper layer kernel elements rely on this "SCSI address", and rely on the 
>>fact that SCSI core can route from a block device straight to a SCSI 
>>LLD, using nothing more than this "SCSI address."
> 
> 
> What's a scsi_domain_device?  Anyway, we don't need any HCIL tuple for
> all of the above.  SG_IO is done on a blockdevice node, /dev/sg is done
> on a chardevice node.  Each of them are attached to a request_queue that's
> known at the time their ->probe routine is setup - no need for HCIL here
> _at all_.  There's actually only few userland interfaces that use HCIL
> addressing:  the scanning through /sys/.../scan (or the old /proc/scsi/scsi
> variant), using WWNs for FC and SAS here would be much nicer, but there's

WWNs *must not* be visible _at_all_ to anyone above the SAS layer, in the
kernel.  That is, the transport addressing method *must not* be visible to
SCSI Core or anyone above it, in the kernel.

Else you'll end up with another "HCIL"... (if you get the irony).

> a huge backwards-compatiblity issue - we'll probably have to support the
> old variant forever.  Besides that there's probably only SCSI_IOCTL_GET_IDLUN,

If there's no userspace dependency, the kernel can do anything it wants.

Since HCIL is SCSI Core crud, let SCSI Core invent HCIL tuples and support them.

	Luben

> which is superceeded by sysfs but probably still has tons of users in
> hardware probing, managment utilities and all kinds of userland.

