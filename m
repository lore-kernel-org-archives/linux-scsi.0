From: Douglas Gilbert <dougg@torque.net>
Subject: Re: block layer sg, bsg
Date: Thu, 05 Aug 2004 09:11:14 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41116D12.9020403@torque.net>
References: <20040804085000.GH10340@suse.de> <20040804075215.155c06ac.davem@redhat.com> <20040804150403.GU10340@suse.de> <20040804084429.7de77cd7.davem@redhat.com> <20040804155643.GA31562@havoc.gtf.org> <20040804155814.GW10340@suse.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub2.uq.edu.au ([130.102.149.128]:46609 "EHLO
	mailhub2.uq.edu.au") by vger.kernel.org with ESMTP id S267494AbUHDXLk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Aug 2004 19:11:40 -0400
In-Reply-To: <20040804155814.GW10340@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, "David S. Miller" <davem@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Wed, Aug 04 2004, Jeff Garzik wrote:
> 
>>On Wed, Aug 04, 2004 at 08:44:29AM -0700, David S. Miller wrote:
>>
>>>Or use a more portable well-defined type which does not change
>>>size nor layout between 32-bit and 64-bit environments.
>>
>>IMO if this (the above) is not done, the interface needs work.
>>
>>For interfaces that replace ioctl(2) with read(2)/write(2), for passing
>>data structures to/from the kernel, Al has rightly suggested that these
>>structures be not only fixed size (as David described above), but also
>>fixed-endian.
> 
> 
> I completely agree with that, we need a different structure for other
> devices as well. Show me what you'd like for libata, for instance.

If a new structure with anything but 'S' (0x53) in the first 4
bytes was chosen then the bsg driver could handle the new
structure and sg_io_hdr.

For example:
struct bsg_io_hdr {
     int8_t interface_id[4];   /* [i] 'B' in each element (required) */
     uint8_t dxfer_direction;
     .............
};

SCSI commands are all big endian and that seems to work
fine. Could pointers be passed as 8 byte big endian
unsigned integers?

Doug Gilbert

