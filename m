From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Sat, 21 May 2005 11:38:25 -0400
Message-ID: <428F55F1.3090006@pobox.com>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk> <1116687698.4999.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:50110 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S261737AbVEUPia (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 May 2005 11:38:30 -0400
In-Reply-To: <1116687698.4999.3.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net

James Bottomley wrote:
> On Mon, 2005-05-16 at 02:59 +0100, Al Viro wrote:
> 
> 
>> static int sbp2scsi_slave_configure (struct scsi_device *sdev)
>> {
>> 	blk_queue_dma_alignment(sdev->request_queue, (512 - 1));
>>-
>>+	sdev->use_10_for_rw = 1;
>>+	sdev->use_10_for_ms = 1;
>> 	return 0;
>> }
> 
> 
> This looks wrong.  The RBC standard only specifies the six byte commands
> to be mandatory ... so shouldn't this be sdev->use_10_for_ms = 0?

That's why its in sbp2-specific code...

The above code certainly applies to real-world cases, at least.  Just 
look at the code that was removed...  MS(10) handling.

	Jeff


