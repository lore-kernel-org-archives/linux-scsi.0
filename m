From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 00/11] First pass at merging Bart's HA work
Date: Thu, 06 Dec 2012 15:10:52 +0100
Message-ID: <50C0A76C.20500@acm.org>
References: <cover.1353903448.git.dillowda@ornl.gov> <CAL1RGDU+b4GxEoY0TOvkyJjr0yx=5tFNmAVZ27hVjOOx=n=yJg@mail.gmail.com> <1353957308.2681.5.camel@dabdike> <1353989041.28917.24.camel@obelisk.thedillows.org> <CAL1RGDXpdWL_r7sWp=vvvXH4jxFgjDL+XcEGgKo-44=wrOBmtA@mail.gmail.com> <1354242098.3670.3.camel@obelisk.thedillows.org> <CAJZOPZJBTRXftrW5NWEEHnf2QWsni0HMTAV_PKSgDtA7GO=wRw@mail.gmail.com> <50BF9760.2080801@acm.org> <CAJZOPZKPs5Vx5nB3610V+byv9p1KvL7+sRU6G4uMTRQu=4=STw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:57496 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab2LFOLN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Dec 2012 09:11:13 -0500
In-Reply-To: <CAJZOPZKPs5Vx5nB3610V+byv9p1KvL7+sRU6G4uMTRQu=4=STw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Or Gerlitz <or.gerlitz@gmail.com>
Cc: David Dillow <dillowda@ornl.gov>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, fujita.tomonori@lab.ntt.co.jp, rcj@linux.vnet.ibm.com, Alex Turin <alextu@mellanox.com>

On 12/05/12 22:32, Or Gerlitz wrote:
> On Wed, Dec 5, 2012 at 8:50 PM, Bart Van Assche <bvanassche@acm.org> wrote:
> [...]
>> The only way to make I/O work reliably if a failure can occur at the
>> transport layer is to use multipathd on top of ib_srp. If a connection fails
>> for some reason, then the SRP SCSI host will be removed after the SCSI error
>> handler has finished with its error recovery strategy. And once the
>> transport layer is operational again and srp_daemon detects that the
>> initiator is no longer logged in srp_daemon will make ib_srp log in again.
>> multipathd will then cause I/O to continue over the new path.
>
> Claim basically understood and agreed however, does this also hold
> when the link is back again, that is can't SRP login via this single
> path also when there's no multipath on top?

As far as I can remember the behavior of ib_srp has always been to try 
to reconnect once to the SRP target after the SCSI error handler kicked 
in. Other SCSI LLDs, e.g. the iSCSI initiator, can be configured to keep 
trying to reconnect after a transport layer failure. That has the 
advantage that the SCSI host number remains the same after reconnecting 
succeeded as before reconnecting started.

Bart.

