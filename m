Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42429CDB474
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 15:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344404AbjJQPch (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344402AbjJQPcg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 11:32:36 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C5210D
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 08:32:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3F8F81F88C;
        Tue, 17 Oct 2023 15:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1697556752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SuEpEYO/n91S8ReKzIqb093LMvok4UzKMVUOlbqTJis=;
        b=lXsgYSkxv4c6VVg8WGHYRiFFXZz/pl53ye4CvQDb5BFRHrQZAANvhiHWd5vgOZA52vQdHX
        DI64Fr/fq6Tr1RdJ3UN/os4QLi3npsBFvnDJL0wKUprtRxIfefehcZn5gTJTUkhVQElFG2
        Gdl/4gvrnF+lzc0WtE47FuBtq94L0nE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1697556752;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SuEpEYO/n91S8ReKzIqb093LMvok4UzKMVUOlbqTJis=;
        b=C8koSVlmEXLPcRWZ6iLgXiYGBl+VHekrHnDpBD3bhe3BdxFmmb1I0ux54/KmKT5bRBDc5z
        722JghlNMrs5b1DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2679013584;
        Tue, 17 Oct 2023 15:32:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /sciCBCpLmW8PAAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 17 Oct 2023 15:32:32 +0000
Message-ID: <6cb9b294-1a43-4db3-95b8-99c7dc941768@suse.de>
Date:   Tue, 17 Oct 2023 17:32:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] scsi: aic79xx: Do not reference SCSI command when
 resetting device
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     linux-scsi@vger.kernel.org
References: <e0776fce-bf5b-415b-9e17-384b0ead8e32@moroto.mountain>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <e0776fce-bf5b-415b-9e17-384b0ead8e32@moroto.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp-out2.suse.de;
        none
X-Spamd-Result: default: False [-4.97 / 50.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         XM_UA_NO_VERSION(0.01)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         BAYES_HAM(-0.88)[85.76%];
         MIME_GOOD(-0.10)[text/plain];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         RCPT_COUNT_TWO(0.00)[2];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         MID_RHS_MATCH_FROM(0.00)[]
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/17/23 15:38, Dan Carpenter wrote:
> Hello Hannes Reinecke,
> 
> The patch c67e63800446: "scsi: aic79xx: Do not reference SCSI command
> when resetting device" from Oct 2, 2023 (linux-next), leads to the
> following Smatch static checker warning:
> 
> 	drivers/scsi/aic7xxx/aic79xx_osm.c:1793 ahd_done()
> 	error: we previously assumed 'cmd' could be null (see line 1774)
> 
> drivers/scsi/aic7xxx/aic79xx_osm.c
>      1758 void
>      1759 ahd_done(struct ahd_softc *ahd, struct scb *scb)
>      1760 {
>      1761         struct scsi_cmnd *cmd;
>      1762         struct          ahd_linux_device *dev;
>      1763
>      1764         if ((scb->flags & SCB_ACTIVE) == 0) {
>      1765                 printk("SCB %d done'd twice\n", SCB_GET_TAG(scb));
>      1766                 ahd_dump_card_state(ahd);
>      1767                 panic("Stopping for safety");
>      1768         }
>      1769         LIST_REMOVE(scb, pending_links);
>      1770         cmd = scb->io_ctx;
>      1771         dev = scb->platform_data->dev;
>      1772         dev->active--;
>      1773         dev->openings++;
>      1774         if (cmd) {
>                       ^^^
> The patch adds this NULL check
> 
>      1775                 if ((cmd->result & (CAM_DEV_QFRZN << 16)) != 0) {
>      1776                         cmd->result &= ~(CAM_DEV_QFRZN << 16);
>      1777                         dev->qfrozen--;
>      1778                 }
>      1779         } else if (scb->flags & SCB_DEVICE_RESET) {
>      1780                 if (ahd->platform_data->eh_done)
>      1781                         complete(ahd->platform_data->eh_done);
>      1782                 ahd_free_scb(ahd, scb);
>      1783                 return;
>      1784         }
>      1785         ahd_linux_unmap_scb(ahd, scb);
>      1786
>      1787         /*
>      1788          * Guard against stale sense data.
>      1789          * The Linux mid-layer assumes that sense
>      1790          * was retrieved anytime the first byte of
>      1791          * the sense buffer looks "sane".
>      1792          */
> --> 1793         cmd->sense_buffer[0] = 0;
>                   ^^^^^^^^^^^^^^^^^
> But if cmd is NULL we're going to crash anyway
> 
This has been fixed with the latest version.

>      1794         if (ahd_get_transaction_status(scb) == CAM_REQ_INPROG) {
>      1795 #ifdef AHD_REPORT_UNDERFLOWS
>      1796                 uint32_t amount_xferred;
>      1797
>      1798                 amount_xferred =
>      1799                     ahd_get_transfer_length(scb) - ahd_get_residual(scb);
>      1800 #endif
>      1801                 if ((scb->flags & SCB_TRANSMISSION_ERROR) != 0) {
>      1802 #ifdef AHD_DEBUG
>      1803                         if ((ahd_debug & AHD_SHOW_MISC) != 0) {
>      1804                                 ahd_print_path(ahd, scb);
>      1805                                 printk("Set CAM_UNCOR_PARITY\n");
>      1806                         }
>      1807 #endif
>      1808                         ahd_set_transaction_status(scb, CAM_UNCOR_PARITY);
>      1809 #ifdef AHD_REPORT_UNDERFLOWS
>      1810                 /*
>      1811                  * This code is disabled by default as some
>      1812                  * clients of the SCSI system do not properly
>      1813                  * initialize the underflow parameter.  This
>      1814                  * results in spurious termination of commands
>      1815                  * that complete as expected (e.g. underflow is
>      1816                  * allowed as command can return variable amounts
>      1817                  * of data.
>      1818                  */
>      1819                 } else if (amount_xferred < scb->io_ctx->underflow) {
>      1820                         u_int i;
>      1821
>      1822                         ahd_print_path(ahd, scb);
>      1823                         printk("CDB:");
>      1824                         for (i = 0; i < scb->io_ctx->cmd_len; i++)
>      1825                                 printk(" 0x%x", scb->io_ctx->cmnd[i]);
>      1826                         printk("\n");
>      1827                         ahd_print_path(ahd, scb);
>      1828                         printk("Saw underflow (%ld of %ld bytes). "
>      1829                                "Treated as error\n",
>      1830                                 ahd_get_residual(scb),
>      1831                                 ahd_get_transfer_length(scb));
>      1832                         ahd_set_transaction_status(scb, CAM_DATA_RUN_ERR);
>      1833 #endif
>      1834                 } else {
>      1835                         ahd_set_transaction_status(scb, CAM_REQ_CMP);
>      1836                 }
>      1837         } else if (ahd_get_transaction_status(scb) == CAM_SCSI_STATUS_ERROR) {
>      1838                 ahd_linux_handle_scsi_status(ahd, cmd->device, scb);
> 
> No check here either
> 
Correct, needs to be fixed.

>      1839         }
>      1840
>      1841         if (dev->openings == 1
>      1842          && ahd_get_transaction_status(scb) == CAM_REQ_CMP
>      1843          && ahd_get_scsi_status(scb) != SAM_STAT_TASK_SET_FULL)
>      1844                 dev->tag_success_count++;
>      1845         /*
>      1846          * Some devices deal with temporary internal resource
>      1847          * shortages by returning queue full.  When the queue
>      1848          * full occurrs, we throttle back.  Slowly try to get
>      1849          * back to our previous queue depth.
>      1850          */
>      1851         if ((dev->openings + dev->active) < dev->maxtags
>      1852          && dev->tag_success_count > AHD_TAG_SUCCESS_INTERVAL) {
>      1853                 dev->tag_success_count = 0;
>      1854                 dev->openings++;
>      1855         }
>      1856
>      1857         if (dev->active == 0)
>      1858                 dev->commands_since_idle_or_otag = 0;
>      1859
>      1860         if ((scb->flags & SCB_RECOVERY_SCB) != 0) {
>      1861                 printk("Recovery SCB completes\n");
>      1862                 if (ahd_get_transaction_status(scb) == CAM_BDR_SENT
>      1863                  || ahd_get_transaction_status(scb) == CAM_REQ_ABORTED)
>      1864                         ahd_set_transaction_status(scb, CAM_CMD_TIMEOUT);
>      1865
>      1866                 if (ahd->platform_data->eh_done)
>      1867                         complete(ahd->platform_data->eh_done);
>      1868         }
>      1869
>      1870         ahd_free_scb(ahd, scb);
>      1871         ahd_linux_queue_cmd_complete(ahd, cmd);
> 
> Or here
> 
Needs to be fixed, too.

Will be sending a patch.

Cheers,

Hannes

