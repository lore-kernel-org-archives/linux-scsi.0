From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] tmscsim: INQUIRY always only untagged
Date: 05 Sep 2004 11:42:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094398979.10977.9.camel@mulgrave>
References: <Pine.LNX.4.60.0409040033310.5266@poirot.grange>
	<20040904140102.A15247@infradead.org>
	<Pine.LNX.4.60.0409050022570.3092@poirot.grange>
	<20040904233835.A18659@infradead.org>
	<Pine.LNX.4.60.0409051654460.3039@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:52700 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266808AbUIEPnG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Sep 2004 11:43:06 -0400
In-Reply-To: <Pine.LNX.4.60.0409051654460.3039@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-09-05 at 10:56, Guennadi Liakhovetski wrote:
> Ok, how about the attached version?

Well, it looks like it would cure the symptoms, and I can apply it as a
palliative.

However, the disease in this driver is that it snoops the inquiry data
and gets confused by the double inquiry we now do for certain drives.

What really needs to happen is

1) remove the inquiry snooping and believe the flags in struct
scsi_device instead
2) Don't turn on TCQ until slave_configure()
3) remove it's internal TCQ black list and put it at the mid-layer.

James


