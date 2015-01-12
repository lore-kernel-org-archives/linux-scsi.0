From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion
Date: Mon, 12 Jan 2015 13:56:30 +0100
Message-ID: <54B3C47E.6010109@sandisk.com>
References: <54AD5DDD.2090808@dev.mellanox.co.il> <54AD6563.4040603@suse.de> <54ADA777.6090801@cs.wisc.edu> <54AE36CE.8020509@acm.org> <1420755361.2842.16.camel@haakon3.risingtidesystems.com> <1420756142.11310.9.camel@HansenPartnership.com> <1420757822.2842.39.camel@haakon3.risingtidesystems.com> <1420759360.11310.13.camel@HansenPartnership.com> <1420779808.21830.21.camel@haakon3.risingtidesystems.com> <38CE4ECA-D155-4BF9-9D6D-E1A01ADA05E4@cs.wisc.edu> <54B01DBD.5020707@suse.de> <54B037BF.1010903@cs.wisc.edu> <54B24501.7090801@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf2.bxl.stone.is ([5.134.1.239]:40309 "EHLO sf2.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbbALNQA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2015 08:16:00 -0500
In-Reply-To: <54B24501.7090801@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com, Mike Christie <michaelc@cs.wisc.edu>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, lsf-pc@lists.linux-foundation.org, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

On 01/11/15 10:40, Sagi Grimberg wrote:
> I would say there is no need for specific coordination from iSCSI PoV.
> This is exactly what flow steering is designed for. As I see it, in
> order to get the TX/RX to match rings, the user can attach 5-tuple rules
> (using standard ethtool) to steer packets to the right rings.

Hello Sagi,

Can the 5-tuple rules be chosen such that it is guaranteed that the
sockets used to implement per-CPU queues are spread evenly over MSI-X
completion vectors ? If not, would it help to add a socket option to the
Linux network stack that allows to select the TX ring explicitly, just
like ib_create_cq() in the Linux RDMA stack allows to select a
completion vector explicitly ? My concerns are as follows:
- If the number of queues exceeds the number of MSI-X vectors then I
  expect that it will be much easier to guarantee even spreading by
  selecting tx queues explicitly instead of relying on a hashing scheme.
- On multi-socket systems it is important to process completion
  interrupts on the CPU socket from where the I/O was initiated. I'm
  not sure it is possible to guarantee this when using a hashing
  algorithm to select the TX ring.

Bart.

