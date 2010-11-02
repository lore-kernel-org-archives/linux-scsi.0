From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 4/4] libosd: write/read_sg_kern API
Date: Tue, 02 Nov 2010 10:33:31 +0200
Message-ID: <4CCFCCDB.8060406@panasas.com>
References: <4CBD8CAB.2030207@panasas.com> <1287490962-24013-1-git-send-email-bharrosh@panasas.com> <20101101161329.GA24836@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:59979 "HELO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751657Ab0KBIde (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2010 04:33:34 -0400
In-Reply-To: <20101101161329.GA24836@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@suse.de>, John Chandy <john.chandy@uconn.edu>, open-osd <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 11/01/2010 06:13 PM, Christoph Hellwig wrote:
> On Tue, Oct 19, 2010 at 02:22:42PM +0200, Boaz Harrosh wrote:
>> From: John A. Chandy <john.chandy@uconn.edu>
>>
>> This is a trivial addition to the SG API that can receive kernel
>> pointers. It is only used by the out-of-tree test module. So
>> it's immediate need is questionable. For maintenance ease it might
>> just get in, as it's very small.
>>
>> John.
>> do you need this in the Kernel, or is it only for osd_ktest.ko?
> 
> It really shouldn't be in the tree at all. s/g lists are not something
> that should be passed to a logical I/O layer.
> 

Please read the patch ;-)
It has been asked before, these are not Linux Kernel sg(s). These are
OSD scatter-gather. Osd scatter-gather are an array of extents
[offset, length] to which to write/read to/from in the object. The
memory buffer information is the same as a simple write/read. Only
that the target will random-seek+fetch bytes in a single on-the-wire
IO. There exist the same command for SCSI-disk targets as well.

I know that the conceptual name means something else, and I should have
perhaps chosen a new name. But the STD calls it Scatter-Gather and I have
not yet invented any new names, and always used the STD names for things.
It is not until people got mixed up that I realized it might have been
a mistake to call it that.

Should I submit a patch that renames anything "sg" to "extents", or some
other name? (Please note, there is no name collision it is all osd_sg_xxx)

Thanks
Boaz
