From: David Dillow <dave@thedillows.org>
Subject: Re: [PATCH v3 07/13] scsi_transport_srp: Add transport layer error
 handling
Date: Wed, 03 Jul 2013 14:57:41 -0400
Message-ID: <1372877861.24238.64.camel@frustration.ornl.gov>
References: <51D41C03.4020607@acm.org> <51D41F13.6060203@acm.org>
	  <1372864458.24238.32.camel@frustration.ornl.gov>
	 <51D44A86.5050000@acm.org> <1372872474.24238.43.camel@frustration.ornl.gov>
	 <51D46C54.8060101@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta02.ornl.gov ([128.219.177.12]:28053 "EHLO mta02.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933219Ab3GCS5o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jul 2013 14:57:44 -0400
In-Reply-To: <51D46C54.8060101@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@kernel.org>, Vu Pham <vuhuong@mellanox.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, Jinpu Wang <jinpu.wang@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>

On Wed, 2013-07-03 at 20:24 +0200, Bart Van Assche wrote:
> On 07/03/13 19:27, David Dillow wrote:
> > On Wed, 2013-07-03 at 18:00 +0200, Bart Van Assche wrote:
> >> The combination of dev_loss_tmo off and reconnect_delay > 0 worked fine
> >> in my tests. An I/O failure was detected shortly after the cable to the
> >> target was pulled. I/O resumed shortly after the cable to the target was
> >> reinserted.
> >
> > Perhaps I don't understand your answer -- I'm asking about dev_loss_tmo
> > < 0, and fast_io_fail_tmo >= 0. The other transports do not allow this
> > scenario, and I'm asking if it makes sense for SRP to allow it.
> >
> > But now that you mention reconnect_delay, what is the meaning of that
> > when it is negative? That's not in the documentation. And should it be
> > considered in srp_tmo_valid() -- are there values of reconnect_delay
> > that cause problems?
> 
> None of the combinations that can be configured from user space can 
> bring the kernel in trouble. If reconnect_delay <= 0 that means that the 
> time-based reconnect mechanism is disabled.

Then it should use the same semantics as the other attributes, and have
the user store "off" to turn it off.

And I'm getting the strong sense that the answer to my question about
fast_io_fail_tmo >= 0 when dev_loss_tmo is that we should not allow that
combination, even if it doesn't break the kernel. If it doesn't make
sense, there is no reason to create an opportunity for user confusion.
