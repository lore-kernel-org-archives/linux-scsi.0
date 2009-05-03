From: Jeff Garzik <jeff@garzik.org>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
Date: Sun, 03 May 2009 18:54:06 -0400
Message-ID: <49FE208E.7070001@garzik.org>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com> <20090503071619.GP8822@parisc-linux.org> <Pine.LNX.4.64.0905031346350.29671@blonde.anvils> <20090503144847.GR8822@parisc-linux.org> <49FDB21B.3080301@panasas.com> <20090503154216.GU8822@parisc-linux.org> <49FDC786.6070309@panasas.com> <49FDE3BB.505@garzik.org> <20090503214836.GV8822@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090503214836.GV8822@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Hugh Dickins <hugh@veritas.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <lkml@rtr.ca>, David Woodhouse <dwmw2@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
>> (3) when creating a discard request, use block helpers w/ queue-specific  
>> knowledge to create either
>> 	(a) one request, REQ_TYPE_FS, with discard flag or
>> 	(b) two requests, REQ_TYPE_FS followed by REQ_TYPE_DISCARD
> 
> I'm not sure we need option 3b.


Well -- it is a hard requirement to map 1:1 struct request with the 
underlying hardware device's command set.

If a device command set lacks a READ-and-DISCARD operation, then you 
_must_ create two struct request.  Otherwise you break block layer 
tagging and other 1:1-based assumptions that exist today.	

Thus, given that all of ATA|SCSI|NVMHCI have a DISCARD operation 
distinct from other commands...

option 3b is the overwhelming common case.

	Jeff



