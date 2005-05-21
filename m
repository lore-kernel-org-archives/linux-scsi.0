From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Sat, 21 May 2005 10:01:38 -0500
Message-ID: <1116687698.4999.3.camel@mulgrave>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:50127 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261591AbVEUPBy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 May 2005 11:01:54 -0400
In-Reply-To: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net

On Mon, 2005-05-16 at 02:59 +0100, Al Viro wrote:

>  static int sbp2scsi_slave_configure (struct scsi_device *sdev)
>  {
>  	blk_queue_dma_alignment(sdev->request_queue, (512 - 1));
> -
> +	sdev->use_10_for_rw = 1;
> +	sdev->use_10_for_ms = 1;
>  	return 0;
>  }

This looks wrong.  The RBC standard only specifies the six byte commands
to be mandatory ... so shouldn't this be sdev->use_10_for_ms = 0?

James


