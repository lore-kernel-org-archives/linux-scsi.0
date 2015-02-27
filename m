From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH for kernel 4.1] Split SCSI header files
Date: Fri, 27 Feb 2015 12:17:04 -0800
Message-ID: <1425068224.30923.32.camel@haakon3.risingtidesystems.com>
References: <54ED8A71.3050701@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <54ED8A71.3050701@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-02-25 at 09:40 +0100, Bart Van Assche wrote:
> Move the constants and functions that are used by both initiator and
> target drivers into new header files. This change will allow to modify
> the SCSI target code such that the initiator SCSI header files are no
> longer included. Note: the SCSI target driver patch is available for
> review at https://github.com/bvanassche/linux/commit/092c3cf236ae35a460dead9423fae8f210ee2345.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> ---
>  include/scsi/scsi.h               | 291 +----------------------------------
>  include/scsi/scsi_cmnd.h          |  17 ---
>  include/scsi/scsi_device.h        |   2 -
>  include/scsi/scsi_lun.h           |  23 +++
>  include/scsi/scsi_proto.h         | 311 ++++++++++++++++++++++++++++++++++++++
>  include/target/target_core_base.h |   5 +-
>  6 files changed, 339 insertions(+), 310 deletions(-)
>  create mode 100644 include/scsi/scsi_lun.h
>  create mode 100644 include/scsi/scsi_proto.h
> 

It doesn't make sense to post a patch that shuffles headers around and
changes one target comment right after the merge window closes, when
there are other bugfixes in your tree that need to be included in the
next v4.0-rc target fixes PULL request.

As previously mentioned, it's important that bugfixes go ahead of
improvements so they can be easily CC'ed to stable, and not cause
conflicts with any preceding improvements for the stable team.

So I've gone ahead and cherry-picked three of your commits here:

target: Fix incorrect use of __transport_register_session
https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commit/?id=71a1cb19ad05da95a3cd200bced7d84adcd4fca8

target: Fix a reference leak in the target_get_sess_cmd() error path
https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commit/?id=2d48ecdb1067d072bdd84b90ad51fda922197707

target/file: explicit check for WRITE SAME scatterlist
https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commit/?id=25484454c219671200bbe060da1c8faa9839bb21

I'm not sure the last one is necessary anymore with v4.0-rc1 commit
8e575c50 in place to fail when attempting to WRITE_SAME past the end of
device.  AFAICT from Ronnie's test suite, this is should address the
original OOPsen you reported.

It would be helpful if you can verify with commit 8e575c50 + without
patch #3 on your test setup.

--nab
