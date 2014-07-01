From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH] cleanup switch in scsi_adjust_queue_depth()
Date: Tue, 1 Jul 2014 20:40:17 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B6CB07@G4W3202.americas.hpqcorp.net>
References: <53AA0881.5000505@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:52196 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaGAUlh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jul 2014 16:41:37 -0400
In-Reply-To: <53AA0881.5000505@interlog.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>, SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Douglas Gilbert
> Sent: Tuesday, 24 June, 2014 6:24 PM
> To: SCSI development list; Christoph Hellwig; James Bottomley
> Subject: [PATCH] cleanup switch in scsi_adjust_queue_depth()
> 
> While checking what scsi_adjust_queue_depth() did I
> thought its switch statement could be clearer.
> 
> ChangeLog:
>    - remove redundant assignment (to sdev->queue_depth)
>    - re-order cases (thus removing the fall-through)
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

I've run tests with tagged set to both 0 and MSG_SIMPLE_TAG 
and they both work like before, so you may add:
Reviewed-by: Robert Elliott <elliott@hp.com>
Tested-by: Robert Elliott <elliott@hp.com>

I did notice that include/scsi/scsi_tcq.h scsi_set_tag_type() 
is another function with a switch statement with fallthroughs 
setting these variables.  It doesn't have default: before 0: 
or involve a print, so reordering is not as necessary.

However, that function doesn't clear ordered_tags in the 
MSG_SIMPLE_TAG case, which seems problematic if the device
is ever changed from ordered to simple.  You might want to 
address that in this patch too.


---
Rob Elliott    HP Server Storage



