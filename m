From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v3 0/5] Target sense data handling modifications
Date: Mon, 06 Jul 2015 23:48:56 -0700
Message-ID: <1436251736.23883.31.camel@haakon3.risingtidesystems.com>
References: <1436188508-1539-1-git-send-email-sagig@mellanox.com>
	 <1436223065.6666.7.camel@haakon3.risingtidesystems.com>
	 <559B6F26.7050006@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36606 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbbGGGs5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2015 02:48:57 -0400
In-Reply-To: <559B6F26.7050006@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Sagi Grimberg <sagig@mellanox.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

On Tue, 2015-07-07 at 09:18 +0300, Sagi Grimberg wrote:
> On 7/7/2015 1:51 AM, Nicholas A. Bellinger wrote:
> > On Mon, 2015-07-06 at 16:15 +0300, Sagi Grimberg wrote:
> >> This patch set modifies the target sense data handling.
> >> First, cleanup transport_send_check_condition_and_sense()
> >> by splitting the sense translation to a separate function.
> >> Second, convert sense reason the switch statement to a table
> >> driven code. Third, Use scsi common helpers to correctly set
> >> the sense buffer. Last, Fix wrong setting of t10-pi errors
> >> (non descriptor format).
> >>
> >> Changes from v2:
> >> - Pass sense_reason_t to scsi_translate_sense()
> >> - Split patch 3:
> >>    1) move the helpers to scsi_common.c
> >>    2) use helpers in the target code
> >>    3) always use descriptor-type sense data for PI errors
> >>
> >> Changes from v1:
> >> - Added Reviewed-by tags for patches 1,2
> >> - Fixed compilation error after testing patch #3 on scsi/for-next
> >>    branch. Moved scsi_sense_desc_find() to scsi_common as well (dependency)
> >>    and also moved <asm/unaligned.h> include to scsi_common.h
> >>
> >> Changes from v0:
> >> - Added Bart's patches and converted my patch to apply over his
> >> - Moved scsi sense helpers to scsi_common
> >>
> >> Bart Van Assche (2):
> >>    target: Inline transport_get_sense_codes()
> >>    target: Split transport_send_check_condition_and_sense()
> >>
> >> Sagi Grimberg (3):
> >>    scsi: Move sense handling routines to scsi_common
> >>    target: Use scsi helpers to build the sense data correctly
> >>    target: Fix wrong setting of sense format for PI errors
> >>
> >>   drivers/scsi/scsi_common.c             |  98 ++++++++
> >>   drivers/scsi/scsi_error.c              |  99 +-------
> >>   drivers/target/target_core_spc.c       |  31 +--
> >>   drivers/target/target_core_transport.c | 399 ++++++++++++---------------------
> >>   include/scsi/scsi_common.h             |   5 +
> >>   include/scsi/scsi_eh.h                 |   7 +-
> >>   include/target/target_core_base.h      |   1 +
> >>   7 files changed, 256 insertions(+), 384 deletions(-)
> >>
> >
> > Nice series to make scsi-core and target-core use common code.  ;)
> >
> > Applied to target-pending/for-next.
> >
> > hch + jejb, please let me know if you have any objections to taking this
> > through target-pending.
> 
> Can you please fold into patch #5 this change suggested by Bart:
> 
> diff --git a/drivers/target/target_core_transport.c 
> b/drivers/target/target_core_transport.c
> index 79bb8d1..9c34937 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2625,7 +2625,7 @@ struct sense_info {
>          u8 asc;
>          u8 ascq;
>          bool add_sector_info;
> -   int desc_format;
> + bool desc_format;
>   };
> 
>   static const struct sense_info sense_info_table[] = {
> @@ -2709,21 +2709,21 @@ static const struct sense_info 
> sense_info_table[] = {
>                  .asc = 0x10,
>                  .ascq = 0x01, /* LOGICAL BLOCK GUARD CHECK FAILED */
>                  .add_sector_info = true,
> -           .desc_format = 1,
> +         .desc_format = true,
>          },
>          [TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED] = {
>                  .key = ILLEGAL_REQUEST,
>                  .asc = 0x10,
>                  .ascq = 0x02, /* LOGICAL BLOCK APPLICATION TAG CHECK 
> FAILED */
>                  .add_sector_info = true,
> -           .desc_format = 1,
> +         .desc_format = true,
>          },
>          [TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED] = {
>                  .key = ILLEGAL_REQUEST,
>                  .asc = 0x10,
>                  .ascq = 0x03, /* LOGICAL BLOCK REFERENCE TAG CHECK 
> FAILED */
>                  .add_sector_info = true,
> -           .desc_format = 1,
> +         .desc_format = true,
>          },
>          [TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE] = {
>                  /*
> --
> 

Folded into the original patch.

