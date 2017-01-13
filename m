From: Sasikumar PC <sasikumar.pc@broadcom.com>
Subject: RE: [bug report] scsi: megaraid_sas: SAS3.5 Generic Megaraid
 Controllers Stream Detection and IO Coalescing
Date: Fri, 13 Jan 2017 14:52:22 -0500
Message-ID: <e04dc3202bbdc189dfd8b4794dac0462@mail.gmail.com>
References: <20170112184934.GA12420@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35685 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750945AbdAMTwZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2017 14:52:25 -0500
Received: by mail-wm0-f53.google.com with SMTP id r126so79607536wmr.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2017 11:52:24 -0800 (PST)
In-Reply-To: <20170112184934.GA12420@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>, Christopher Owens <christopher.owens@broadcom.com>

Hi Dan,

I will fix the static checker warning

Thanks
sasi

-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
Sent: Thursday, January 12, 2017 1:50 PM
To: sasikumar.pc@broadcom.com
Cc: megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org
Subject: [bug report] scsi: megaraid_sas: SAS3.5 Generic Megaraid
Controllers Stream Detection and IO Coalescing

Hello Sasikumar Chandrasekaran,

The patch fdd84e2514b0: "scsi: megaraid_sas: SAS3.5 Generic Megaraid
Controllers Stream Detection and IO Coalescing" from Jan 10, 2017, leads
to the following static checker warning:

	drivers/scsi/megaraid/megaraid_sas_fusion.c:1771
megasas_stream_detect()
	warn: inconsistent indenting

drivers/scsi/megaraid/megaraid_sas_fusion.c
  1747  static void megasas_stream_detect(struct megasas_instance
*instance,
  1748                                  struct megasas_cmd_fusion *cmd,
  1749                                  struct IO_REQUEST_INFO *io_info)
  1750  {
  1751          struct fusion_context *fusion = instance->ctrl_context;
  1752          u32 device_id = io_info->ldTgtId;
  1753          struct LD_STREAM_DETECT *current_ld_sd
  1754                  = fusion->stream_detect_by_ld[device_id];
  1755          u32 *track_stream = &current_ld_sd->mru_bit_map,
stream_num;
  1756          u32 shifted_values, unshifted_values;
  1757          u32 index_value_mask, shifted_values_mask;
  1758          int i;
  1759          bool is_read_ahead = false;
  1760          struct STREAM_DETECT *current_sd;
  1761          /* find possible stream */
  1762          for (i = 0; i < MAX_STREAMS_TRACKED; ++i) {
  1763                  stream_num =
  1764                  (*track_stream >> (i * BITS_PER_INDEX_STREAM)) &
  1765                          STREAM_MASK;
  1766                  current_sd =
&current_ld_sd->stream_track[stream_num];
  1767          /* if we found a stream, update the raid
  1768           *  context and also update the mruBitMap
  1769           */
  1770          /*      boundary condition */
  1771          if ((current_sd->next_seq_lba) &&

We're still inside the for loop.  This isn't indented far enough.

  1772                  (io_info->ldStartBlock >=
current_sd->next_seq_lba) &&
  1773                  (io_info->ldStartBlock <=
(current_sd->next_seq_lba+32)) &&
  1774                  (current_sd->is_read == io_info->isRead)) {
  1775
  1776                  if ((io_info->ldStartBlock !=
current_sd->next_seq_lba)
  1777                          && ((!io_info->isRead) ||
(!is_read_ahead)))
  1778                          /*
  1779                           * Once the API availible we need to
change this.
  1780                           * At this point we are not allowing any
gap
  1781                           */
  1782                          continue;
  1783
  1784
cmd->io_request->RaidContext.raid_context_g35.stream_detected = true;
  1785                  current_sd->next_seq_lba =
  1786                  io_info->ldStartBlock + io_info->numBlocks;
  1787                  /*
  1788                   *      update the mruBitMap LRU
  1789                   */


See also:

drivers/scsi/megaraid/megaraid_sas_base.c:5396 megasas_init_fw() warn:
inconsistent indenting
drivers/scsi/megaraid/megaraid_sas_fusion.c:4060 megasas_reset_fusion()
warn: inconsistent indenting

regards,
dan carpenter
