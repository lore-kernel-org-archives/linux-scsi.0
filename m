From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Expected payload size for WRITE_SAME_16?
Date: Fri, 06 May 2011 17:58:15 -0700
Message-ID: <1304729895.10072.475.camel@haakon2.linux-iscsi.org>
References: <4DC193C0.8090401@rnanetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:44899 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab1EGBGJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2011 21:06:09 -0400
In-Reply-To: <4DC193C0.8090401@rnanetworks.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Douglas Gilbert <dgilbert@interlog.com>

On Wed, 2011-05-04 at 10:58 -0700, Chris Greiveldinger wrote:
> Hello again,
> 

Hi Chris,

>  From sbc3r25:  "The WRITE SAME (16) command (see table 112) requests 
> that the device server transfer a single logical block from the data-out 
> buffer."  The code for WRITE_SAME_16 in 
> target_core_transport.c:transport_generic_cmd_sequencer() calculates the 
> expected size to be sectors * block size (via transport_get_size), which 
> I expect is too large if sectors is greater than one.

Not exactly..

We use the per CDB 'size = transport_get_size()' assignment with
WRITE_SAME_16+UNMAP=1 in transport_generic_cmd_sequencer() to compare
the SCSI CDB level expected data transfer length (size) against the
fabric dependent expected transfer length (struct se_cmd->data_length)
at the bottom of transport_generic_cmd_sequencer().

The value in se_cmd->data_length is then used to determine the 'range' 
and makes the backend calls via:

   target_core_cdb.c:target_emulate_write_same()  
       dev->transport->do_discard() -> 
         target_core_iblock.c:iblock_do_discard() -> 
              block/blk-lib.c:blkdev_issue_discard()


> Since the sg3_utils sg_write_same utility allows me to specify the the payload 
> size, I can issue a command that has the payload length that 
> transport_generic_cmd_sequencer() expects, but I'm not sure what the 
> correct size should be.
> 

It was my understanding that you need to match the sg_write_same
parameters of --num and --xferlen depending on the SCSI block_size (512)
used for the SCSI devices:

sg_write_same -S --unmap --in=/dev/zero --lba=10 --num=1
--xferlen=512 /dev/sdd

sg_write_same -S --unmap --in=/dev/zero --lba=10 --num=100
--xferlen=51200 /dev/sdd

Note that sg_write_same does check --xferlen against a hardcoded max of
64k, which is obviously somewhat limiting.

> Am I wrong in my interpretation of the WRITE_SAME(16) command, or is 
> this a bug in transport_generic_cmd_sequencer()?
> 

So the above case --num > 0 case things should still be working as
expected with recent upstream LIO code and your last Reported-by: patch,
but there does appear to be an issue with the --num=0 case being
rejected by the write underflow/overflow check inside
transport_generic_cmd_sequencer().

I will send out a patch shortly against lio-4.1 for you to test that
makes the sg_write_same --unmap + --num=0 case work again (Christoph
CC'ed and linux-scsi CC'ed).

Thanks for your review!

--nab

