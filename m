From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH RFC] yet more struct scsi_lun
Date: Sun, 23 Oct 2005 12:43:06 -0400
Message-ID: <435BBD9A.80603@pobox.com>
References: <20051023043301.GA22615@havoc.gtf.org> <20051023070011.GA26569@havoc.gtf.org> <435B6A62.8070306@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:62146 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750730AbVJWQnO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 12:43:14 -0400
In-Reply-To: <435B6A62.8070306@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Which in turn makes me think of applying the same idea
> to max_sectors
> 
>         shost->max_sectors = MAX_512B_SECTORS_UNLIMITED;


Won't work.  max_sectors is communicated to the block layer, where we 
limit the overall size of the request for practical reasons.

Read the comment in libata-scsi's slave_configure:

                 /* TODO: 1024 is an arbitrary number, not the
                  * hardware maximum.  This should be increased to
                  * 65534 when Jens Axboe's patch for dynamically
                  * determining max_sectors is merged.
                  */

Right now, setting the true hardware / command set maximum would use way 
too much memory, with no way to get feedback from the VM.

This is why SCSI_DEFAULT_MAX_SECTORS is defined to 1024.

	Jeff


