From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: PATCH [3/5]  qla2xxx: TCQ fixes
Date: 13 Jul 2004 12:43:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1089740604.1798.54.camel@mulgrave>
References: <B179AE41C1147041AA1121F44614F0B0DD02FD@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:42727 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265668AbUGMRnp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2004 13:43:45 -0400
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0DD02FD@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-07-13 at 12:24, Andrew Vasquez wrote:
> Ok, I'll bite.  What did you have in mind? I've taken a quick peek
> through the scsi code, the per-hba tag stuff must still be in your
> head...

Well, it exsits in the block layer (the ability to specify an existing
tag map to blk_queue_init_tags().  Jens is going to expose a bit more of
the tag map machinary to make that useful, then for host global tags,
we'll generate a single tag map and share it amongst all the queues.

> Just a small comment, isn't the scsi_populate_tag_msg() function
> quietly truncating the request->tag value?

Not for SPI, no.  However, we probably need a different API for the
sixteen bit tag values FC can use?

James


