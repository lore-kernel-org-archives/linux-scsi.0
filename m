From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/6] target: Update UA handling
Date: Wed, 17 Jun 2015 00:01:14 -0700
Message-ID: <1434524474.7916.207.camel@haakon3.risingtidesystems.com>
References: <1434009689-112909-1-git-send-email-hare@suse.de>
	 <1434521449.7916.187.camel@haakon3.risingtidesystems.com>
	 <558112DC.2090306@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <558112DC.2090306@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-06-17 at 08:25 +0200, Hannes Reinecke wrote:
> On 06/17/2015 08:10 AM, Nicholas A. Bellinger wrote:
> > On Thu, 2015-06-11 at 10:01 +0200, Hannes Reinecke wrote:
> >> Hi Nic,
> >>
> >> lio-target is very minimalistic when it comes to generate UAs;
> >> primarily they are generated for persistent reservations, but
> >> generic changes tend to be ignored.
> >>
> >> This patchset updates the UA handling and generates UA for internal
> >> state changes (REPORTED LUNS DATA CHANGED, INQUIRY DATA CHANGED,
> >> and LUN RESET OCCURRED).
> >>
> >> Funnily enough this triggers some issues with the SCSI stack;
> >> I'll be sending out patches for that, too.
> >>
> >> Hannes Reinecke (6):
> >>   target_core_alua: Correct UA handling when switching states
> >>   target: Remove 'ua_nacl' pointer from se_ua structure
> >>   target: use 'se_dev_entry' when allocating UAs
> >>   target: Send UA on ALUA target port group change
> >>   target: Send UA upon LUN RESET tmr completion
> >>   target: Send UA when changing LUN inventory
> >>
> >>  drivers/target/target_core_alua.c      | 56 +++++++++++++++++++++++++---------
> >>  drivers/target/target_core_device.c    | 26 +++++++++++++++-
> >>  drivers/target/target_core_pr.c        | 31 +++++++++++++++----
> >>  drivers/target/target_core_transport.c | 29 ++++++++++++++----
> >>  drivers/target/target_core_ua.c        | 24 ++-------------
> >>  drivers/target/target_core_ua.h        |  5 ++-
> >>  include/target/target_core_base.h      |  1 -
> >>  7 files changed, 121 insertions(+), 51 deletions(-)
> >>
> > 
> > Applied to target-pending/for-next, with the extra incremental patch for
> > a common target_ua_alloc_lun() caller.
> > 
> > Btw, very happy to see REPORTED_LUNS_DATA_HAS_CHANGED support include
> > for v4.2-rc1 code.  8-)
> > 
> Yeah; I needed a quick testbed for my ALUA update, and thought that
> tcm_loop would fit the bill.
> 
> As it turned out, not quite. Hence the patches.
> 
> BTW: the main issue I have with current lio-target is that you can
> only configure it _after_ the target has been enabled.
> 
> IE if you want to add another ALUA state you have to create another
> TPG, and set this to the required ALUA state.
> But you can modify the TPG allegiance only _after_ the LUN has been
> created and is visible to the host.
> Which means that the initiator inevitably sees both states, and it's
> impossible to have the LUN start off with a different than the
> default ALUA state.
> (This is especially important if one would want to test the READ
> CAPACITY support in ALUA standby state).
> 
> Would you be okay with changing that?
> 

Sounds like a reasonable case to support.

No objections to allowing default ALUA access state to be changed, ahead
of actual se_device configfs symlink to fabric se_lun export.
