From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/6] target: Update UA handling
Date: Tue, 16 Jun 2015 23:10:49 -0700
Message-ID: <1434521449.7916.187.camel@haakon3.risingtidesystems.com>
References: <1434009689-112909-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1434009689-112909-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-06-11 at 10:01 +0200, Hannes Reinecke wrote:
> Hi Nic,
> 
> lio-target is very minimalistic when it comes to generate UAs;
> primarily they are generated for persistent reservations, but
> generic changes tend to be ignored.
> 
> This patchset updates the UA handling and generates UA for internal
> state changes (REPORTED LUNS DATA CHANGED, INQUIRY DATA CHANGED,
> and LUN RESET OCCURRED).
> 
> Funnily enough this triggers some issues with the SCSI stack;
> I'll be sending out patches for that, too.
> 
> Hannes Reinecke (6):
>   target_core_alua: Correct UA handling when switching states
>   target: Remove 'ua_nacl' pointer from se_ua structure
>   target: use 'se_dev_entry' when allocating UAs
>   target: Send UA on ALUA target port group change
>   target: Send UA upon LUN RESET tmr completion
>   target: Send UA when changing LUN inventory
> 
>  drivers/target/target_core_alua.c      | 56 +++++++++++++++++++++++++---------
>  drivers/target/target_core_device.c    | 26 +++++++++++++++-
>  drivers/target/target_core_pr.c        | 31 +++++++++++++++----
>  drivers/target/target_core_transport.c | 29 ++++++++++++++----
>  drivers/target/target_core_ua.c        | 24 ++-------------
>  drivers/target/target_core_ua.h        |  5 ++-
>  include/target/target_core_base.h      |  1 -
>  7 files changed, 121 insertions(+), 51 deletions(-)
> 

Applied to target-pending/for-next, with the extra incremental patch for
a common target_ua_alloc_lun() caller.

Btw, very happy to see REPORTED_LUNS_DATA_HAS_CHANGED support include
for v4.2-rc1 code.  8-)

Thanks Hannes!

--nab
