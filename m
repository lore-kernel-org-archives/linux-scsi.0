From: "Love, Robert W" <robert.w.love@intel.com>
Subject: RE: [PATCH 0/8] Open-FCoE fixes for 2.6.30 RC
Date: Thu, 28 May 2009 15:22:43 -0700
Message-ID: <273D38FBE7C6FE46A1689FCD014A0B8B55417A17@azsmsx505.amr.corp.intel.com>
References: <20090506175206.26695.19457.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:42575 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbZE1WW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2009 18:22:56 -0400
In-Reply-To: <20090506175206.26695.19457.stgit@fritz>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Love, Robert W" <robert.w.love@intel.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Robert Love wrote:
> The following series implements general fixes to libfc, libfcoe and
> fcoe. 
> 
> Note: One patch adds the FIP ehtertype to if_ether.h. As discussed on
> netdev, this change was pre-acked and it was requested that the
> change go through 
> the SCSI tree.
> 
James, aside of the two patches that weren't appropriate for -rc will
the other 6 in this set be pushed upstream for -rc?

The two bad ones were:

fcoe: removes fcoe_watchdog
fcoe: reduces lock cost when adding a new skb to fcoe_pending_queue

The other 6 are good fixes and I tested them after removing the two
bad ones from the set, so they should be fine to push.

If you need a repost, I'd be glad to provide one.

> ---
> 
> Chris Leech (1):
>       fcoe: use ETH_P_FIP for skb->protocol of FIP frames
> 
> Joe Eykholt (2):
>       net, libfcoe: Add the FCoE Initialization Protocol ethertype
>       libfcoe: fip: fix non-FIP-mode FLOGI state after reset.
> 
> Mike Christie (1):
>       libfc: use DID_ERROR when we have internall aborted command
> 
> Steve Ma (1):
>       libfc: Check if exchange is completed when receiving a sequence
> 
> Vasu Dev (3):
>       fcoe: removes reserving memory for vlan_ethdr on tx path
>       fcoe: removes fcoe_watchdog
>       fcoe: reduces lock cost when adding a new skb to
> fcoe_pending_queue 
> 
> 
>  drivers/scsi/fcoe/fcoe.c     |   90
>  +++++++++++++++--------------------------- drivers/scsi/fcoe/fcoe.h 
>  |    1 drivers/scsi/fcoe/libfcoe.c  |   21 ++++++----
>  drivers/scsi/libfc/fc_exch.c |    4 ++
>  drivers/scsi/libfc/fc_fcp.c  |    2 -
>  include/linux/if_ether.h     |    1
>  include/scsi/fc/fc_fip.h     |    7 ---
>  7 files changed, 53 insertions(+), 73 deletions(-)
> 
> --
> //Rob

