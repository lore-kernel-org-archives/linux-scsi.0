From: Johann Lombardi <johann.lombardi@bull.net>
Subject: Re: [RFC] scsi: allow to increase the maximum number of sg entries
Date: Thu, 19 Apr 2007 08:30:36 +0200
Message-ID: <20070419063036.GG13565@lombardij>
References: <20070418082114.GE13565@lombardij> <1176895924.3671.100.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:60260 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031155AbXDSGbF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Apr 2007 02:31:05 -0400
In-Reply-To: <1176895924.3671.100.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Apr 18, 2007 at 07:32:03AM -0400, James Bottomley wrote:
> I don't think so: simply increasing the phys segments has no effect on a
> fully fragmented sg list if the hw segments doesn't go up to match it.

Yes, of course. It is then up to each scsi lld to increase max_hw_segments
accordingly. Increasing the phys segments seemed to me to be the first logical
step.
FYI, I tested the patch with lpfc and LPFC_SG_SEG_CNT set to 1024.

> Since changing the hw segments necessitates driver work, I'd really like
> to see justification in terms of throughput figures versus transfer size
> rather than vague assertions that bigger is better.

Sure. A full survey (done with sgp_dd) of DDN S2A9550 was posted on the
lustre-discuss mailing list in January:
https://mail.clusterfs.com/pipermail/lustre-discuss/2007-January/002795.html
http://mail.clusterfs.com/pipermail/lustre-discuss/attachments/20070118/8d6a4e79/9500-sgp_dd-0001.xls

For instance, here are the results obtained with 32 threads / 32 regions and
write-back caching disabled:

Transfer size     Throughput (Write)   Throughput (Read)  
512KB             36MB/s               108MB/s
1MB               60MB/s               108MB/s
2MB               96MB/s               165MB/s
4MB               144MB/s              228MB/s

Johann
