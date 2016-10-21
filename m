From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/6] tcm_fc fixes
Date: Fri, 21 Oct 2016 00:46:00 -0700
Message-ID: <1477035960.8490.148.camel@haakon3.risingtidesystems.com>
References: <1471856051-87398-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41934 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753311AbcJUHqD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2016 03:46:03 -0400
In-Reply-To: <1471856051-87398-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>

Hi Hannes & Martin,

Apologies for the extended delay on this.  Comments below.

On Mon, 2016-08-22 at 10:54 +0200, Hannes Reinecke wrote:
> Hi Nic,
> 
> here's a set of patches and fixes I've found during debugging
> FCoE over virtio.
> The first two fix a race condition I've encountered during starting
> and stopping initiators; they are similar to your prior patches,
> but I still think they should be applied to avoid any race issues.
> The next three are just minor cleanups, but the last one is
> _absolutely_ crucial.
> With the current code tcm_fc will behave _very_ odd if you're
> running in a virtualized environment, as the xid allocator in libfc
> will be thouroughly thrashed by sending frames on _other_ cpus than
> those the originator frame got received on.
> This causes frames to be delayed (by up to several minutes)
> leading to I/O errors on the initiator side.
> 

Thanks for the heads up on #6.  Applied with v4.5+ tag, the earliest
stable where TARGET_SCF_USE_CPUID is available.

> As usual, comments and reviews are welcome.
> 
> Hannes Reinecke (6):
>   target: fix hang in target_wait_for_sess_cmds()
>   target: fix potential race window in target_sess_cmd_list_waiting()
>   target/tcm_fc: print command pointer in debug message
>   target/tcm_fc: return detailed error in ft_sess_create()
>   target/tcm_fc: Update debugging statements to match libfc usage
>   target/tcm_fc: use CPU affinity for responses
> 
>  drivers/target/target_core_transport.c | 28 ++++++++++++++---------
>  drivers/target/tcm_fc/tfc_cmd.c        |  4 ++--
>  drivers/target/tcm_fc/tfc_sess.c       | 42 +++++++++++++++++++++++-----------
>  3 files changed, 48 insertions(+), 26 deletions(-)
> 

Applied #3-6 to target-pending/master.  Comments inline for #1 and #2.

