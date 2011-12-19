From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 13/14] ib_srp: Implement transport layer ping
Date: Mon, 19 Dec 2011 10:16:03 +0000
Message-ID: <CAO+b5-o+-JF61a+8vFWj1rxMuVWuG-CVLQKorr5cKzi-Kc44Ag@mail.gmail.com>
References: <201112011954.25811.bvanassche@acm.org>
	<201112012011.45444.bvanassche@acm.org>
	<1324255806.17849.68.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64987 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1LSKQE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2011 05:16:04 -0500
In-Reply-To: <1324255806.17849.68.camel@obelisk.thedillows.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Dillow <dillowda@ornl.gov>
Cc: linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>

On Mon, Dec 19, 2011 at 12:50 AM, David Dillow <dillowda@ornl.gov> wrote:
> On Thu, 2011-12-01 at 20:11 +0100, Bart Van Assche wrote:
>> Add a time-based transport layer test such that fail-over in a multipath
>> setup can happen quickly.
>
> Why should this be done in the kernel? multipathd already verifies all
> paths to a SCSI device are up and that the device is reachable.

I'm afraid it's impossible to make a transport layer check work
reliably from user space. As an example, srp_reset_host() blocks the
SCSI host before reconnecting. Before starting to attempt to
reconnect, that action does block the SCSI host and hence also all
transport layer checks issued from user space. I doubt it's possible
to fix the resulting race between a transport layer reconnect issued
from srp_reset_host() and a transport layer reconnect triggered from
user space.

Bart.
