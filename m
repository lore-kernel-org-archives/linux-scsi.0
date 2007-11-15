From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: how to handle QUEUE_FULL/SAM_STAT_TASK_SET_FULL in userspace?
Date: Thu, 15 Nov 2007 15:35:46 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D70B34664@NAMAIL4.ad.lsil.com>
References: <1195165080.9519.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:46365 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765414AbXKOWgH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 17:36:07 -0500
Content-class: urn:content-classes:message
In-Reply-To: <1195165080.9519.6.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Chris Friesen <cfriesen@nortel.com>
Cc: "Stephens, Larry" <Larry.Stephens@lsi.com>, linux-scsi@vger.kernel.org, dgilbert@interlog.com, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

> No.  When the command goes via SG_IO it bypasses all return status
> processing (and QUEUE_FULL/BUSY is a return status).  When it's
> submitted in the normal way (i.e. via a ULD) then the mid-layer
> processes these returns to a retry strategy.
> 

James - Today I'm working some other customer issue, and my target
returns SAM_STAT_TASK_SET_FULL when sg_inq is sent.   I see about 10
retries before the data is finally returned.  Who is issuing the retries
to my driver?   Doesn't sg_inq (sg3_utils), use SG_IO ->
scsi_execute_async-> scsi_softirq_done, where SAM_STAT_TASK_SET_FULL is
translated to ADD_TO_MLQUEUE, then retried, regardless the fact that
SG_DEFAULT_RETRIES equal zero.   Maybe I'm missing something, but I'm
seeing retries.

Eric    
