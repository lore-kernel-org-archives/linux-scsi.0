From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v4 00/12] iSCSI target v4.1.0-rc1 series for .39-rc1
Date: Mon, 21 Mar 2011 13:54:27 -0700
Message-ID: <1300740867.21880.12.camel@haakon2.linux-iscsi.org>
References: <1300613497-2091-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:46665 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab1CUVBr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2011 17:01:47 -0400
In-Reply-To: <1300613497-2091-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, Douglas Gilbert <dgilbert@interlog.com>, Jesper Juhl <jj@chaosbits.net>

On Sun, 2011-03-20 at 02:31 -0700, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Greetings all,
> 
> This is the forth RFC series of the RisingTide Systems iSCSI target fabric
> module compatible with mainline target core v4 -> for-39 target infrastructure.
> 
> More information about iscsi_target_mod is available here:
> 
> http://linux-iscsi.org/wiki/ISCSI/configFS
> 
> This series contains the updated drivers/target/iscsi/ source tree for modern
> mainline code based on feedback from Christoph Hellwig that has been recently
> pushed into the lio-core-2.6.git/lio-4.1 development branch.  This includes
> another round of iSCSI network portal changes to use proper Linux/Net code
> w/ IPv6/IPv4 iscsi_np->np_sockaddr, conversion of iSCSI TX thread context
> to use schedule_timeout_interruptible(), and the renaming the majority of
> functions to use the 'iscsit_*' function prefix based upon hch's feedback.
> 
> This series is currently rebased against .38-FINAL using target core v4.0.0-rc7-ml.
> 
> The full RFC-v4 series for iscsi-target is available here:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-39-iscsi-target-v4
> 
> The changes from RFC-v3 -> RFC-v4 include:
> 
> *) Make iscsit_[free,stop]_session take conn_tmp reference first
> *) Convert NPF_NET_IPV* flags to AF_INET*
> *) Add missing unlock for iscsi_get_np
> *) Convert iscsi_target_tpg.c to use 'iscsit_' function prefixe
> *) Convert iscsi_target_device.c to use 'iscsit_' function pref
> *) Convert iscsi_target_seq_pdu_list.c to use 'iscsit_' functio
> *) Convert iscsi_target_datain_values.c to use 'iscsit_' functi
> *) Convert iscsi_target_tmr.c to use 'iscsit_' function prefixe
> *) Convert iscsi_target_nodeattrib.c to use 'iscsit_' function 
> *) Convert iscsi_target_erl*.c to use 'iscsit_' function prefix
> *) Convert iscsi_target_util.c to use 'iscsit_' function prefix
> *) Convert iscsi_target.c to use 'iscsit_' function prefixes
> *) Move iscsi_add_nopin into iscsi_target_util.c
> *) Move iscsi_ack_from_expstatsn into iscsi_target.c
> *) Drop needless iscsi_target_util.c wrappers
> *) Move extern target_core_fabric_ops functions into iscsi_targ
> *) Add comments for RX/TX nice usage and iscsi_release_commands
> *) Convert TX thread to use schedule_timeout_interruptible
> *) Fix potential NULL deference in iscsi_[free,stop]_session
> *) Fix iscsi_np shutdown race
> *) Drop iscsi_np->np_shutdown and ->np_state_lock
> *) Remove dead iscsi_tpg_free_network_portals code
> *) Remove remaining comment stubs
> *) Convert cases to wait_for_completion*_timeout
> *) Remove ad-hod debugging code
> 
> The changes from RFC-v2 -> RFC-v3 include:
> 
> *) Remove dead tpg shutdown code
> *) Remove dead struct iscsi_np_ex logic
> *) Fix up network portal handling
> *) Rename core_* prefixed functions to iscsit_*
> *) Convert semaphores to completion and mutex
> *) Convert iscsi_global members to global variables
> *) Cleanups for iscsi_target_login_thread logic
> *) Use SIGINT in iscsi_handle_login_thread_timeout()
> *) Cleanups for iscsi_thread_queue.c logic
> *) Drop MOD_TIMER and SETUP_TIMER macros
> *) Convert iscsi_index_t to use idr.h
> *) Remove CONN* and SESS* deference macros
> *) Update copyright and vendor
> *) Fix up remaining struct semaphore callbacks
> *) Renaming renaming non iscsi_target_* source files
> 
> The changes from RFC-v1 -> RFC-v2 include:
> 
> *) Drop extra crc32c_intel libcrypto magic from iscsi_login_setup_crypto()
> *) Fix padded login response payload breakage from initial iscsi_proto.h
>    conversion
> *) Cleanups for iscsi_target_core.h and conversion a number of definitions
>    to enums and inline defs
> *) Removal of '__' prefix around u32 and friends
> *) Other miscellanous checkpatch.pl cleanups
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> 

Hi Christoph, James and Co,

At this point I have no further changes beyond RFC-v4 for the initial
merge of iscsi-target.  Please let me know if anything was missed from
your review for the above changes, and I will get any remaining items
addressed ASAP.

Also James, how do you prefer this series be sent out for the initial
merge in order avoid the vger lists max character limit..?

Thank you,

--nab

