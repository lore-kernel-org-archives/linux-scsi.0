From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_debug [was: scsi_debug issues]
Date: Mon, 18 Oct 2004 23:44:59 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4173C8DB.8030009@torque.net>
References: <20041015190154.GA3073@us.ibm.com> 	<4170C505.3000805@torque.net> <1097932370.1962.4.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080704000905070704040507"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub2.uq.edu.au ([130.102.149.128]:52233 "EHLO
	mailhub2.uq.edu.au") by vger.kernel.org with ESMTP id S266511AbUJRNrt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2004 09:47:49 -0400
In-Reply-To: <1097932370.1962.4.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, hch@infradead.org

This is a multi-part message in MIME format.
--------------080704000905070704040507
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

James Bottomley wrote:
> On Sat, 2004-10-16 at 01:51, Douglas Gilbert wrote:
> 
>>So this problem seems related to highmem.
>>
>>The attachment is against the current scsi_debug driver
>>(at least in lk 2.6.9-rc4). It uses dma_map_sg() and friends
>>together with phys_to_virt() which comes highly recommended:
>>"in almost all conceivable cases a device driver should not be
>>using this function" :-) Could you try the patch.
>>
>>Perhaps others my be able to answer this: is setting
>>scsi_host_template::dma_boundary (to some figure other
>>than 0xffffffff) going to help in this case?
> 
> 
> No, the problem is with highmem as you correctly point out, but the
> issue is that your driver cannot see beyond it.  On x86, highmem begins
> at about 900Mb.  The kernel has no page tables for any memory beyond
> this.  In order to see the memory you need to kmap it (i.e. ask the
> kernel to create a temporary page table for it); so the virtual address
> sg uses should be got by kmapping the pages in the sg list:
> 
> kaddr = kmap(sg[i].page) + sg[i].offset
> 
> If you make sure clustering is disabled, you should never get multiple
> pages in the initial sg list.
done

> When you've finished you need to release the mapping with kunmap().
ouch, that requires a re-org

> There are also atomic versions of these depending on where you are.
hopefully not required


The above required a fair few changes to scsi_debug.
Attached is a patch that rolls "kmap" changes with
patches I have sent recently for scsi_debug.
Attachment is gzipped (due to size) and applies against
lk 2.6.8.1 -> lk 2.6.9-rc4 .

Nishanth, could you test this with highmem?

Changelog:
    - use kmap/kunmap to handle normal and highmem cases
        - disable clustering
        - previously could only handle 'use_sg > 1' for
          read and write commands
    - VERIFY (SBC) and REWIND (SSC) command support (dummies)
    - 'dsense' parameter (sysfs + load time) for descriptor
      sense format
    - allow negative 'every_nth' to fail continually after
      |every_nth| commands (or until sysfs intervention)
    - clean up debug messages sent to the log (when opts=1)
        - correct ordering of log messages
    - set scsi_cmnd::resid when underflow on DMA_FROM_DEVICE
      operations
    - clean up std inquiry response; add version descriptors
    - reject mode sense subpage commands since no subpages
      currently supported (i.e. better command filtering)


Doug Gilbert


--------------080704000905070704040507
Content-Type: application/x-gzip;
 name="sdebug269rc4_174.diff.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="sdebug269rc4_174.diff.gz"

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
--------------080704000905070704040507--
