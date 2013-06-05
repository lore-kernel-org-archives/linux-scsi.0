From: "Shergill, Gurinder" <gurinder.shergill@hp.com>
Subject: RE: [PATCH] make dev_loss_tmo checks uniform across drivers
Date: Wed, 5 Jun 2013 22:29:14 +0000
Message-ID: <A591B01B4B9C42438AD944169026EEDC0158303A@G1W3776.americas.hpqcorp.net>
References: <1370283919-11884-1-git-send-email-gurinder.shergill@hp.com>
 <51AD8F0A.9050007@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:17745 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757840Ab3FEWbT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jun 2013 18:31:19 -0400
In-Reply-To: <51AD8F0A.9050007@acm.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Bart Van Assche
> Sent: Monday, June 03, 2013 11:54 PM
> To: Shergill, Gurinder
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: [PATCH] make dev_loss_tmo checks uniform across drivers
> 
> On 06/03/13 20:25, gurinder.shergill@hp.com wrote:
> > The dev_loss_tmo parameter controls how long the FC transport layer
> > insulates a loss of a remote port. It is defined to be between 1 and
> > SCSI_DEVICE_BLOCK_MAX_TIMEOUT (600). Different drivers do slightly
> > different checks when passed this parameter. This patch makes the
> > dev_loss_tmo setting uniform across all the drivers by pulling the
> > common logic into the transport layer function which is responsible
> > for invoking the driver provided callouts.
> >
> > In addition, this patch also fixes a issue (see below), where
> > dev_loss_tmo could end up with a value more than
> > SCSI_DEVICE_BLOCK_MAX_TIMEOUT when fast_io_fail_tmo is enabled and
> > then disabled.  The change is to never allow dev_loss_tmo to be out of
> > its defined range. And, once that is a given, then fast_io_fail_tmo can
> be capped by dev_loss_tmo.
> 
> Hello Sunny,
> 
> As far as I know some users set fast_io_fail_tmo such that dev_loss_tmo
> can be set to a very large value in order to prevent that the SCSI host
> number changes. Sorry but I'm not sure it's a good idea to remove that
> functionality.

Fair enough. I wasn't aware of such usage of fast_io_fail_tmo. I'll take that part out of the patch.

Thanks for the feedback,
Sunny

