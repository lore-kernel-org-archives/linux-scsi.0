From: Or Gerlitz <or.gerlitz@gmail.com>
Subject: Re: [PATCH 00/11] First pass at merging Bart's HA work
Date: Wed, 5 Dec 2012 20:23:02 +0200
Message-ID: <CAJZOPZJBTRXftrW5NWEEHnf2QWsni0HMTAV_PKSgDtA7GO=wRw@mail.gmail.com>
References: <cover.1353903448.git.dillowda@ornl.gov>
	<CAL1RGDU+b4GxEoY0TOvkyJjr0yx=5tFNmAVZ27hVjOOx=n=yJg@mail.gmail.com>
	<1353957308.2681.5.camel@dabdike>
	<1353989041.28917.24.camel@obelisk.thedillows.org>
	<CAL1RGDXpdWL_r7sWp=vvvXH4jxFgjDL+XcEGgKo-44=wrOBmtA@mail.gmail.com>
	<1354242098.3670.3.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53226 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab2LESXD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Dec 2012 13:23:03 -0500
In-Reply-To: <1354242098.3670.3.camel@obelisk.thedillows.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Dillow <dillowda@ornl.gov>, Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, fujita.tomonori@lab.ntt.co.jp, rcj@linux.vnet.ibm.com, Alex Turin <alextu@mellanox.com>

On Fri, Nov 30, 2012 at 4:21 AM, David Dillow <dillowda@ornl.gov> wrote:
[...]
> Modulo a few style issues (braces around one line if branches, etc.) and
> having three state variables vs one, I can live with everything up to
> aabfa852acd27962 at git://github.com/bvanassche/linux.git#srp-ha. Those
> two are small things that can be fixed later and are not worth holding
> things up any further.
>
> I'll try to spend some time on the final four patches tomorrow afternoon.

Dave, Bart

My colleague Alex Turin <alextu@mellanox.com> tried  today the bits as
they appear in Roland's kernel.org tree / for-next branch up to commit
 fb57e1dbbd4 and here's some feedback

Basically, what he did was connecting  to a target, next take down the
IB port on the initiator side, and issue some IOs (dd if=/dev/sdb
of=/dev/null count=1)

Our recollection of events from the logs (below) is the following

1. queued command get completion status 5

2. as part of error handling srp_reset_host() was called,

3. srp_reset_host() calls to srp_reconnect_target() which fails cause
port is down.

4. srp_reconnect_target() on failure calls to srp_queue_remove_work()
which sets
target->status to SRP_TARGET_REMOVED.

5.srp_reset_host() called second time. it calls to
srp_reconnect_target() but target->state == SRP_TARGET_REMOVED.
srp_reconnect_target() checks if target->state != SRP_TARGET_LIVE and
return -EAGAIN.

This probably means that even after enabling port it will still fail
to reconnect?

Or.


Dec  5 16:19:13 rsws42 kernel: scsi host7: ib_srp: failed send status 5
Dec  5 16:19:42 rsws42 kernel: scsi host7: SRP abort called
Dec  5 16:19:42 rsws42 kernel: scsi host7: SRP reset_device called
Dec  5 16:19:42 rsws42 kernel: scsi host7: ib_srp: SRP reset_host called
Dec  5 16:19:43 rsws42 kernel: scsi host7: ib_srp: Got failed path rec
status -110
Dec  5 16:19:43 rsws42 kernel: scsi host7: ib_srp: Path record query failed
Dec  5 16:19:43 rsws42 kernel: scsi host7: ib_srp: reconnect failed
(-110), removing target port.
Dec  5 16:19:43 rsws42 kernel: sd 7:0:0:11: Device offlined - not
ready after error recovery
Dec  5 16:19:43 rsws42 kernel: sd 7:0:0:11: [sdb] Synchronizing SCSI cache
Dec  5 16:20:45 rsws42 kernel: scsi host7: SRP abort called
Dec  5 16:20:50 rsws42 kernel: scsi host7: SRP abort called
Dec  5 16:21:05 rsws42 kernel: scsi host7: SRP abort called
Dec  5 16:21:10 rsws42 kernel: scsi host7: SRP reset_device called
Dec  5 16:21:15 rsws42 kernel: scsi host7: ib_srp: SRP reset_host called
Dec  5 16:21:15 rsws42 kernel: sd 7:0:0:11: Device offlined - not
ready after error recovery
Dec  5 16:21:15 rsws42 kernel: sd 7:0:0:11: Device offlined - not
ready after error recovery

repeating part:

Dec  5 16:22:17 rsws42 kernel: scsi host7: SRP abort called
Dec  5 16:22:22 rsws42 kernel: scsi host7: SRP abort called
Dec  5 16:22:37 rsws42 kernel: scsi host7: SRP abort called
Dec  5 16:22:42 rsws42 kernel: scsi host7: SRP reset_device called
Dec  5 16:22:47 rsws42 kernel: scsi host7: ib_srp: SRP reset_host called
Dec  5 16:22:47 rsws42 kernel: sd 7:0:0:11: Device offlined - not
ready after error recovery
Dec  5 16:22:47 rsws42 kernel: sd 7:0:0:11: Device offlined - not
ready after error recovery
