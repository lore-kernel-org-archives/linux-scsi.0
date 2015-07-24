From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] iscsi-target: Fix iscsit_start_kthreads failure OOPs
Date: Thu, 23 Jul 2015 20:11:40 -0700
Message-ID: <1437707500.28058.6.camel@haakon3.risingtidesystems.com>
References: <1436259023-1561-1-git-send-email-nab@daterainc.com>
	 <1436259702.23883.38.camel@haakon3.risingtidesystems.com>
	 <559BC048.703@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <559BC048.703@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

Hey Sagi,

Apologies for the extended delay to follow-up on this..

On Tue, 2015-07-07 at 15:04 +0300, Sagi Grimberg wrote:
> On 7/7/2015 12:01 PM, Nicholas A. Bellinger wrote:
> > Hey Sagi,
> >
> > This addresses a regression with traditional iscsi-target that I noticed
> > recently, but has not been tested with iser-target yet.
> >
> > Would you mind taking a quick spin with iser-target to verify, and try
> > to intentionally fail iscsit_start_kthreads() into the two out_bitmap +
> > out_tx error paths..?
> 
> Umm, I hit a BUG() statement while start to test this.
> 
> The easy reproducer is:
> - create 20 iser targets (listen on any 0.0.0.0:3260)
> - discover targets 2 initiator ports ports (40 target instances)
> - run: for i in `seq 100`; do iscsiadm -m node -l && iscsiadm -m node 
> -u; done
> 
> Note: I wasn't able to reproduce this with iscsi/tcp.
> 
> Stack dump:
> kernel: isert: isert_wait4logout: conn ffff8803db5a9800
> kernel: ------------[ cut here ]------------
> kernel: isert: isert_wait4logout: conn ffff8803db5a9800 wait for conn_logout_comp
> kernel: kernel BUG at drivers/target/iscsi/iscsi_target.c:4465!

So the proper resolution for this ended up involving moving the call to
iscsi_start_kthreads() immediately preceding sending the last login
response.

This is to ensure that once the last login response is sent signaling
transition to full-feature-phase, no resource allocation failures should
ever occur.

I've verified this with iscsi/tcp and iser-target, and AFAICT the
failure cases for iscsi_start_kthreads() are now working as expected.

The updated version of this was just sent out as patch #2 in the v4.2-rc
fixes series, and has been pushed to target-pending/master here:

iscsi-target: Fix iscsit_start_kthreads failure OOPs
https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commit/?id=7238eef0914764211a89c069eef569bc83cb3714

Please review.

--nab
