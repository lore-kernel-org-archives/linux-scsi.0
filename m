From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] IBM Power RAID driver (ipr) 2.0.6
Date: Tue, 04 May 2004 13:24:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4097DFE6.8080002@us.ibm.com>
References: <4097D863.8040505@us.ibm.com> <20040504185618.A26003@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:3230 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264579AbUEDSYy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 May 2004 14:24:54 -0400
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, May 04, 2004 at 12:52:35PM -0500, Brian King wrote:
> 
>>James,
>>
>>Here is the latest version of the LLD for the IBM Power RAID family of
>>adapters. This includes several IBM iSeries and pSeries SCSI adapters.
>>Please apply.
> 
> 
> BTW, any plans to add support for the older iSeries models supported by
> the binary only ibmsis driver?

No. The older models have several "issues" with them. First of all, while
the firmware interface has similarities, there are enough differences to make
writing a driver to support both somewhat ugly. Yes, ibmsis did both, but it
was also a pretty bulky driver. Secondly, the way RAID is done on the legacy
adapters is completely different. It is done how OS/400 needs it done, which
means data striping is not done in the adapter, but rather by the system, as
each device is exposed to the system. Thirdly, the adapters based on the
Chukar chip have lots of "features" with them. To name a few, BIST does not
work. The only way to reset the card is to assert PCI reset. PCI config space
can come up in either big endian or little endian mode, which requires creative
programming to detect and fixup.

Not supporting the legacy adapters resulted in a *much* cleaner OSS driver.

ibmsis will continue to be supported for bug fixes, etc. for the older adapters,
but all new adapters will be supported only by ipr.

-Brian


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

