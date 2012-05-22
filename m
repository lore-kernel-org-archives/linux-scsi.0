From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v4 1/4] fcoe: Allocate fcoe_ctlr with fcoe_interface,
 not as a member
Date: Tue, 22 May 2012 22:01:44 +0100
Message-ID: <1337720504.2932.20.camel@dabdike.int.hansenpartnership.com>
References: <20120327222224.7144.6324.stgit@localhost6.localdomain6>
	 <20120327222229.7144.79107.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49488 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138Ab2EVVBt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 May 2012 17:01:49 -0400
In-Reply-To: <20120327222229.7144.79107.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, giridhar.malavali@qlogic.com, james.smart@emulex.com, bprakash@broadcom.com

On Tue, 2012-03-27 at 15:22 -0700, Robert Love wrote:
> Currently the fcoe_ctlr associated with an interface is allocated
> as a member of struct fcoe_interface. This causes problems when
> attempting to use the new fcoe_sysfs APIs which allow us to allocate
> the fcoe_interface as private data to the fcoe_ctlr_device instance.
> The problem is that libfcoe wants to be able use pointer math to find a
> fcoe_ctlr's fcoe_ctlr_device as well as finding a fcoe_ctlr_device's
> assocated fcoe_ctlr. To do this we need to allocate the
> fcoe_ctlr_device, with private data for the LLD. The private data
> contains the fcoe_ctlr and its private data is the fcoe_interface.
> This patch only allocates the fcoe_interface with the fcoe_ctlr, the
> fcoe_ctlr_device will be added in a later patch, which will complete
> the below diagram-
> 
> +------------------+
> | fcoe_ctlr_device |
> +------------------+
> | fcoe_ctlr        |
> +------------------+
> | fcoe_interface   |
> +------------------+
> 
> This prep work will allow us to go from a fcoe_ctlr_device instance
> to its fcoe_ctlr as well as from a fcoe_ctlr to its fcoe_ctlr_device
> once the fcoe_sysfs API is in use (later patches in this series).
> 
> Signed-off-by: Robert Love <robert.w.love@intel.com>
> Tested-by: Ross Brattain <ross.b.brattain@intel.com>
> ---
>  drivers/scsi/fcoe/fcoe.c |  132 ++++++++++++++++++++++++++++++----------------
>  drivers/scsi/fcoe/fcoe.h |    8 ++-
>  include/scsi/libfcoe.h   |    9 +++
>  3 files changed, 99 insertions(+), 50 deletions(-)

This isn't applying against scsi-misc:

patching file drivers/scsi/fcoe/fcoe.c
Hunk #5 succeeded at 422 with fuzz 1.
Hunk #6 FAILED at 462.
Hunk #7 succeeded at 496 (offset 14 lines).
Hunk #8 succeeded at 650 (offset 12 lines).
Hunk #9 succeeded at 683 (offset 12 lines).
Hunk #10 succeeded at 1063 (offset 20 lines).
Hunk #11 succeeded at 1127 (offset 20 lines).
Hunk #12 succeeded at 1394 (offset 20 lines).
Hunk #13 succeeded at 1402 (offset 20 lines).
Hunk #14 succeeded at 1419 (offset 20 lines).
Hunk #15 succeeded at 1554 (offset 20 lines).
Hunk #16 succeeded at 1570 (offset 20 lines).
Hunk #17 succeeded at 1634 (offset 20 lines).
Hunk #18 succeeded at 1688 (offset 20 lines).
Hunk #19 succeeded at 1710 (offset 20 lines).
Hunk #20 succeeded at 1890 (offset 20 lines).
Hunk #21 succeeded at 1908 (offset 20 lines).
Hunk #22 succeeded at 1920 (offset 20 lines).
Hunk #23 succeeded at 1945 (offset 20 lines).
Hunk #24 succeeded at 1955 (offset 20 lines).
Hunk #25 succeeded at 1985 (offset 20 lines).
Hunk #26 succeeded at 2000 (offset 20 lines).
Hunk #27 succeeded at 2021 (offset 20 lines).
Hunk #28 succeeded at 2032 (offset 20 lines).
Hunk #29 succeeded at 2052 (offset 20 lines).
Hunk #30 succeeded at 2061 (offset 20 lines).
Hunk #31 succeeded at 2086 (offset 20 lines).
Hunk #32 succeeded at 2099 (offset 20 lines).
Hunk #33 succeeded at 2155 (offset 20 lines).
Hunk #34 succeeded at 2179 (offset 20 lines).
Hunk #35 succeeded at 2196 (offset 20 lines).
Hunk #36 succeeded at 2215 (offset 20 lines).
Hunk #37 succeeded at 2228 (offset 20 lines).
Hunk #38 FAILED at 2220.
Hunk #39 succeeded at 2353 (offset 23 lines).
Hunk #40 succeeded at 2393 (offset 23 lines).
Hunk #41 succeeded at 2502 (offset 23 lines).
Hunk #42 succeeded at 2514 (offset 23 lines).
Hunk #43 succeeded at 2611 (offset 23 lines).
Hunk #44 succeeded at 2785 (offset 23 lines).
2 out of 44 hunks FAILED -- saving rejects to file
drivers/scsi/fcoe/fcoe.c.rej
patching file drivers/scsi/fcoe/fcoe.h
Hunk #1 succeeded at 68 with fuzz 1.
Hunk #2 FAILED at 78.
1 out of 2 hunks FAILED -- saving rejects to file
drivers/scsi/fcoe/fcoe.h.rej
patching file include/scsi/libfcoe.h

Can you tell me what I'm missing or regenerate it?

Thanks,

James


