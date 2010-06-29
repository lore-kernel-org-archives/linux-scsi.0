From: shailesh parulekar <shailesh.parulekar@gmail.com>
Subject: struct scsi_cmnd --> underflow
Date: Tue, 29 Jun 2010 18:27:34 +0530
Message-ID: <AANLkTilsQ_VMArZPCOnWge2gjxRrJbcwq0FxTsaRamxx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37923 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab0F2M5i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jun 2010 08:57:38 -0400
Received: by gxk23 with SMTP id 23so550688gxk.19
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jun 2010 05:57:35 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I am writing a SCSI LLD and have a query regarding handling of underflow errors.

In function sd_prep_fn (sd.c) the code populates scsi command pointer
(SCpnt) and it's cmnd.
Going ahead it also sets the total length to be transferred in the
scsi data buffer (SCpnt->sdb.length = this_count * sdp->sector_size).
Here 'this_count' looks to be the nr_sectors. This assignment looks
fine too.
But later when assigning the 'underflow' field of SCpnt, the
assignment uses a hard-coded bit shift (SCpnt->underflow = this_count
<< 9). Is this valid? OR
should it be: SCpnt->underflow = this_count <<  sdp->sector_size?

So, if the sector size exported by the target device is greater than
512 (4K in our case), the SCpnt->underflow is not same as
SCpnt->sdb.length. The later is 8 times bigger. So if I get a read of
say 8K the 'underflow' is set only to 1K. Now, if the target say
returns only 2K of data for this read, the amount of data transferred
is not less than residual (1K in this case). So is the LLD not
supposed to return (DID_ERROR << 16) in 'result' for this case
(assuming target returns result == GOOD)?

Please let me know.

thanks,
--shailesh
