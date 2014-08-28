From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 83391] Oops  on sd_mod
Date: Thu, 28 Aug 2014 07:55:20 +0000
Message-ID: <bug-83391-11613-hjzk9eIGFu@https.bugzilla.kernel.org/>
References: <bug-83391-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54040 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbaH1Hz0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 03:55:26 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A9BA52013A
	for <linux-scsi@vger.kernel.org>; Thu, 28 Aug 2014 07:55:25 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 6FB9A2017E
	for <linux-scsi@vger.kernel.org>; Thu, 28 Aug 2014 07:55:20 +0000 (UTC)
In-Reply-To: <bug-83391-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=83391

--- Comment #2 from tomsun <tomsunchen@gmail.com> ---

static void sd_read_block_limits(struct scsi_disk *sdkp)
{
    unsigned int sector_sz = sdkp->device->sector_size;
    const int vpd_len = 32;
    unsigned char *buffer = kmalloc(vpd_len, GFP_KERNEL);

    if (!buffer ||
        /* Block Limits VPD */
        scsi_get_vpd_page(sdkp->device, 0xb0, buffer, vpd_len))
        goto out;

    blk_queue_io_min(sdkp->disk->queue,
             get_unaligned_be16(&buffer[6]) * sector_sz);
    blk_queue_io_opt(sdkp->disk->queue,
             get_unaligned_be32(&buffer[12]) * sector_sz);

    if (buffer[3] == 0x3c) {
        unsigned int lba_count, desc_count;

        sdkp->max_ws_blocks =
            (u32) min_not_zero(get_unaligned_be64(&buffer[36]),
                       (u64)0xffffffff);

        if (!sdkp->lbpme)
            goto out;

        lba_count = get_unaligned_be32(&buffer[20]);
        desc_count = get_unaligned_be32(&buffer[24]);

        if (lba_count && desc_count)
            sdkp->max_unmap_blocks = lba_count;

        sdkp->unmap_granularity = get_unaligned_be32(&buffer[28]);

        if (buffer[32] & 0x80)
            sdkp->unmap_alignment =
                get_unaligned_be32(&buffer[32]) & ~(1 << 31);

        if (!sdkp->lbpvpd) { /* LBP VPD page not provided */

            if (sdkp->max_unmap_blocks)
                sd_config_discard(sdkp, SD_LBP_UNMAP);
            else
                sd_config_discard(sdkp, SD_LBP_WS16);

        } else {    /* LBP VPD page tells us what to use */

            if (sdkp->lbpu && sdkp->max_unmap_blocks)
                sd_config_discard(sdkp, SD_LBP_UNMAP);
            else if (sdkp->lbpws)
                sd_config_discard(sdkp, SD_LBP_WS16);
            else if (sdkp->lbpws10)
                sd_config_discard(sdkp, SD_LBP_WS10);
            else
                sd_config_discard(sdkp, SD_LBP_DISABLE);
        }
    }

 out:
    kfree(buffer);
}

first, the pointer of buffer is malloced 32 bytes memory, but the buffer be
misused as 64 bytes memory, ex.     sdkp->max_ws_blocks =
            (u32) min_not_zero(get_unaligned_be64(&buffer[36]),
                       (u64)0xffffffff);
I don't know why, is it the bug for this oops?




thank you very much~

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
