From: Dan Carpenter <error27@gmail.com>
Subject: bug report: sd:  off by one in sd_read_block_limits()
Date: Tue, 2 Mar 2010 11:21:35 +0300
Message-ID: <20100302082135.GA6218@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:62326 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab0CBIV7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2010 03:21:59 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

drivers/scsi/sd.c +1986 sd_read_block_limits(39) warn: buffer overflow 'buffer' 32 <= 32
  1951          const int vpd_len = 32;
  1952          unsigned char *buffer = kmalloc(vpd_len, GFP_KERNEL);

	[snip]

  1984                  if (buffer[32] & 0x80)

	This is past the end of the array.

  1985                          q->limits.discard_alignment =
  1986                                  get_unaligned_be32(&buffer[32]) & ~(1 << 31);
  1987          }

regards,
dan carpenter
