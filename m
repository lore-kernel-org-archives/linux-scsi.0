From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Fri, 26 Aug 2005 15:24:06 -0400
Message-ID: <430F6C56.1090801@pobox.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A4B@xbl3.ma.emulex.com> <430B5CDB.9070204@s5r6.in-berlin.de> <430BB91F.7000406@vger.kernel.org> <20050824091230.GB26447@infradead.org> <430F398A.30200@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:15787 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1030214AbVHZTYL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 15:24:11 -0400
In-Reply-To: <430F398A.30200@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>

Luben Tuikov wrote:
> Even simpler: the transport layer, calls SCSI Core, saying: "Hey here is
> a pointer to struct scsi_domain_device.  If you want, you an send REPORT
> LUNS and other things to it."

For the SG_IO ioctl, /dev/sg and request_queue usage, SCSI core must map 
an address (currently HCIL) into a scsi_domain_device pointer.  These 
upper layer kernel elements rely on this "SCSI address", and rely on the 
fact that SCSI core can route from a block device straight to a SCSI 
LLD, using nothing more than this "SCSI address."

That is the heart of the routing/addressing that the SCSI core must perform.

Right now the addressing is hardcoded to HCIL.  But that can be 
changed...  One proposal was to use (host,string) identifiers.

	Jeff


