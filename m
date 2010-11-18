From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [dm-devel] [PATCH v5] dm mpath: avoid call to blk_abort_queue by
 default
Date: Thu, 18 Nov 2010 12:39:55 -0800
Message-ID: <20101118203954.GA6241@linux.vnet.ibm.com>
References: <1290107959-17167-1-git-send-email-snitzer@redhat.com>
 <1290110853-17541-1-git-send-email-snitzer@redhat.com>
 <20101118201841.GE30435@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41472 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760322Ab0KRUj7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2010 15:39:59 -0500
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id oAIKf1aS032100
	for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2010 15:41:01 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id oAIKdwqn302158
	for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2010 15:39:58 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id oAIKdwhN013385
	for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2010 15:39:58 -0500
Content-Disposition: inline
In-Reply-To: <20101118201841.GE30435@agk-dp.fab.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

Alasdair G Kergon <agk@redhat.com> wrote:
> On Thu, Nov 18, 2010 at 03:07:33PM -0500, Mike Snitzer wrote:
> > It is expected that this race will be fixed in the near-term so it makes
> > little since to remove all associated code.  Providing control over the
> > call to blk_abort_queue() facilitates continued testing and future
> > flexibility to opt-in to lower latency path deactivation.  Opting to
> > enable this feature will emit a warning for the time being.
> 
> Ah, but then the *feature* keyword - which is only going to be needed
> temporarily until it's fixed - becomes a permanent part of the interface...
> 
> If it's broken, let's just disable it (#define-style) until it gets fixed.
> (And only if it doesn't get fixed in a reasonable amount of time, remove the
> code.)

I understand that if its broken that we could #define it out in dm or we
could #define the code in blk_abort_queue.

I believe the thought was that post addressing the race issue that
others may want control. As there maybe cases where the waking up of the
error_handler and a extra abort may not be wanted in all cases. 

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
