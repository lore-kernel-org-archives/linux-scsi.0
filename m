From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Possible performance regression?
Date: Mon, 02 Jan 2006 10:19:06 -0600
Message-ID: <1136218746.3531.31.camel@mulgrave>
References: <43B94DB9.5040505@hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:44188 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750799AbWABQTN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jan 2006 11:19:13 -0500
In-Reply-To: <43B94DB9.5040505@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2006-01-02 at 10:58 -0500, Alan D. Brunelle wrote:
> As part of HP's Open Source and Linux Organization's Performance and 
> Scalability Group, I've noticed what looks to be a regression in U320 
> SCSI performance coming down the pike. Background: These measurements 
> were performed on Red Hat RHEL4 update 2 (2.6.9-based) and a "generic" 
> 2.6.14-based kernel; I used an HP RX4640 with 4 dual-U320 LSI Logic / 
> Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 08) 
> adapters, each with two buses containing 5 72GB/15k U320 drives (for a 
> total of 40 drives). The runs were done in single-user mode (to minimize 
> effects from other tasks), and report results in megabytes per second. I 
> ran tests for various block sized IOs (1KB, 2KB, 4, ...256KB per IO).

This data doesn't seem to be mirrored by tiobench tests on other
drivers, so it's probably fusion specific.

When a similar problem was found in the adaptec driver a while back, it
was due to a bug which set the TCQ depth to 1, which looks very
consistent with your results, so you might try starting there.

James


