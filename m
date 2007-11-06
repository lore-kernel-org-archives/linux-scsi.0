From: malahal@us.ibm.com
Subject: Re: [PATCH] gdth: scp timeout clean up
Date: Tue, 6 Nov 2007 08:18:26 -0800
Message-ID: <20071106161826.GA1660@us.ibm.com>
References: <20071106065439.GA30397@us.ibm.com> <47301DA7.8000202@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:44981 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbXKFQSh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Nov 2007 11:18:37 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id lA6GIXLO023505
	for <linux-scsi@vger.kernel.org>; Tue, 6 Nov 2007 11:18:33 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id lA6GIWu8109520
	for <linux-scsi@vger.kernel.org>; Tue, 6 Nov 2007 09:18:32 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lA6GIUU1006099
	for <linux-scsi@vger.kernel.org>; Tue, 6 Nov 2007 09:18:31 -0700
Content-Disposition: inline
In-Reply-To: <47301DA7.8000202@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org, Achim_Leubner@adaptec.com, jens.axboe@oracle.com

Boaz Harrosh [bharrosh@panasas.com] wrote:
> > +static enum scsi_eh_timer_return gdth_timed_out(struct scsi_cmnd *scp)
> > +{
> > +	gdth_ha_str *ha = shost_priv(scp->device->host);
> > +	struct gdth_cmndinfo *cmndinfo = gdth_get_cmndinfo(ha);
> 
> a gdth_get_cmndinfo(ha) is for allocating a new cmndinfo out of free
> cmndinfo list, and must be paired by a call to gdth_put_cmndinfo(ha).
> And usually you want to put it on scp->host_scribble, other wise it will
> be lost. 
> To get the cmndinfo associated with a scsi_cmnd use gdth_cmnd_priv(scp) 

Thank you very much. It should be gdth_cmnd_priv(scp). I will fix it.
