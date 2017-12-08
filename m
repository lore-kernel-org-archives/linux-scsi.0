From: Rafael David Tinoco <rafael.tinoco@canonical.com>
Subject: Re: [PATCH] scsi: libiscsi: Allow sd_shutdown on bad transport
Date: Fri, 8 Dec 2017 12:34:46 -0200
Message-ID: <70551D53-945D-488B-81B7-577A386A8257@canonical.com>
References: <1512683953-5959-1-git-send-email-rafael.tinoco@canonical.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43613 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753815AbdLHOez (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Dec 2017 09:34:55 -0500
Received: from mail-qt0-f198.google.com ([209.85.216.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <rafael.tinoco@canonical.com>)
        id 1eNJjp-0000lZ-Vq
        for linux-scsi@vger.kernel.org; Fri, 08 Dec 2017 14:34:54 +0000
Received: by mail-qt0-f198.google.com with SMTP id n32so13359930qtb.5
        for <linux-scsi@vger.kernel.org>; Fri, 08 Dec 2017 06:34:53 -0800 (PST)
In-Reply-To: <1512683953-5959-1-git-send-email-rafael.tinoco@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, Jay Vosburgh <jay.vosburgh@canonical.com>, Daniel Axtens <daniel.axtens@canonical.com>, "dragan.stancevic@canonical.com" <dragan.stancevic@canonical.com>

Lee, Chris,

Some test results.

- Single unmounted disk, with transport connection wiped before final logout:

http://pastebin.ubuntu.com/26139576/

- Multiple mounted disks, multipath dev-mapper, all transport connections were wiped before the final logout, with heavy write workload:

http://pastebin.ubuntu.com/26139620/

Considering sd_shutdown logic - sd_shutdown, sd_sync_cache for each scsi_disk, 3 attempts of scsi_execute with SYNCHRONIZE_CACHE cmd each -  you can see that, because transport was down, first SYNC_CACHE cmd waits for the request timeout and for the abort_timeout. All other cmds fail in the enqueuing phase, because of the transport failure + previous timeout + server shutdown happening simultaneously, so you don't have to wait for timeout on each command again.

This change also suits any pending requests, not only those coming from sd_shutdown, and it allows OS to reboot and shutdown, back again, independently of how bad userland was configured.

Thank you in advance for considering it.

-Rafael

> On 07/12/2017, at 07:59 PM, Rafael David Tinoco <rafael.tinoco@canonical.com> wrote:
> 
> If, for any reason, userland shuts down iscsi transport interfaces
> before proper logouts - like when logging in to LUNs manually,
> without logging out on server shutdown, or when automated scripts
> can't umount/logout from logged LUNs - kernel will hang forever on
> its sd_sync_cache() logic, after issuing the SYNCHRONIZE_CACHE cmd
> to all still existent paths.
> 
> PID: 1 TASK: ffff8801a69b8000 CPU: 1 COMMAND: "systemd-shutdow"
> #0 [ffff8801a69c3a30] __schedule at ffffffff8183e9ee
> #1 [ffff8801a69c3a80] schedule at ffffffff8183f0d5
> #2 [ffff8801a69c3a98] schedule_timeout at ffffffff81842199
> #3 [ffff8801a69c3b40] io_schedule_timeout at ffffffff8183e604
> #4 [ffff8801a69c3b70] wait_for_completion_io_timeout at ffffffff8183fc6c
> #5 [ffff8801a69c3bd0] blk_execute_rq at ffffffff813cfe10
> #6 [ffff8801a69c3c88] scsi_execute at ffffffff815c3fc7
> #7 [ffff8801a69c3cc8] scsi_execute_req_flags at ffffffff815c60fe
> #8 [ffff8801a69c3d30] sd_sync_cache at ffffffff815d37d7
> #9 [ffff8801a69c3da8] sd_shutdown at ffffffff815d3c3c
> 
> This happens because iscsi_eh_cmd_timed_out(), the transport layer
> timeout helper, would tell the queue timeout function (scsi_times_out)
> to reset the request timer over and over, until the session state is
> back to logged in state. Unfortunately, during server shutdown, this
> might never happen again.
> 
> Other option would be "not to handle" the issue in the transport
> layer. That would trigger the error handler logic, which would also
> need the session state to be logged in again.
> 
> Best option, for such case, is to tell upper layers that the command
> was handled during the transport layer error handler helper, marking
> it as DID_NO_CONNECT, which will allow completion and inform about
> the problem.
> 
> After the session was marked as ISCSI_STATE_FAILED, due to the first
> timeout during the server shutdown phase, all subsequent cmds will
> fail to be queued, allowing upper logic to fail faster.
> 
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@canonical.com>
