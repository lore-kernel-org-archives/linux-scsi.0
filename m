From: Boaz Harrosh <bharrosh@panasas.com>
Subject: isd200.c Has fatal bugs and is probably not used any more
Date: Tue, 21 Aug 2007 22:06:26 +0300
Message-ID: <46CB37B2.404@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:12260 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753266AbXHUTGk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Aug 2007 15:06:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Bj=F6rn_Stenberg?= <bjorn@haxx.se>, support@in-system.com, James Bottomley <James.Bottomley@SteelEye.com>, Greg Kroah-Hartman <gregkh@suse.de>, linux-scsi <linux-scsi@>

Hi!

the driver drivers/usb/storage/isd200.c has code like:

static int isd200_action( struct us_data *us, int action,
              void* pointer, int value )

...

    case ACTION_READ_STATUS:
        US_DEBUGP("   isd200_action(READ_STATUS)\n");
        ata.generic.ActionSelect = ACTION_SELECT_0|ACTION_SELECT_2;
        ata.generic.RegisterSelect =
          REG_CYLINDER_LOW | REG_CYLINDER_HIGH |
          REG_STATUS | REG_ERROR;
        srb->sc_data_direction = DMA_FROM_DEVICE;
        srb->request_buffer = pointer;
        srb->request_bufflen = value;
        break;
...

Now what the hell is that hijacked scsi_cmnd and who said
that the srb->use_sg is Zero. If this is a regular queued
scsi_cmnd, this can easily crash. And at best a memory leak.

The last git recorded real change to this driver was it's insertion
into git by Linus.

Is this an indication that this driver is no longer used and
can be removed?

Boaz Harrosh


