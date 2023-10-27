Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0DF2C25B67
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Oct 2023 12:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345735AbjJ0MEI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Oct 2023 08:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345539AbjJ0MEH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Oct 2023 08:04:07 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090D8C9
        for <linux-scsi@vger.kernel.org>; Fri, 27 Oct 2023 05:04:05 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-40836ea8cbaso15110225e9.0
        for <linux-scsi@vger.kernel.org>; Fri, 27 Oct 2023 05:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698408243; x=1699013043; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=grKXx3+Si1QWec4pqFQzl1xi7UnMm3nGTDQzvPDZFCc=;
        b=QLs10CY7zswLLzG0rT7YiTeSSo9oOHm2bbv6E3WS/5Hf59VXgb7Sum5QlbMEnYfZ1i
         BemLJ0vdV8osWJpwP4d0I6LAJ2NJOVX8BRG/kYHTbyJuPZp3/M5375hS2hK+6zyeG6YE
         SdIDvf0RypoqEv8HP2AdwZsinYTLujseqA2Q9GPRTYtp4VHQgIDnnMZrci+pWAyep8Ok
         AzQBDo16gyh/c/UDRUlTw5/KLIrRlZUwz77V3wgVxqB+Zfcfa0VwykVPYGF+4kRJlzAc
         D0E7AKUGVBkMpJZdx9NxhneAn/sDaFCQdFnTm6HbOyicr1VdYFB8xVuceAG3HHGyp+Si
         BnJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698408243; x=1699013043;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=grKXx3+Si1QWec4pqFQzl1xi7UnMm3nGTDQzvPDZFCc=;
        b=iW/qrYnI6eW5m4K6VQOo+7iFonor/rM6gpa8ji32eAUDnfG8rtIchj1EhCRC66jvFJ
         vJtwZXwJGNONjSw7re5qm1hfkfuj94uV3K+sCg5rCKP7cfPzVGvFX9ErBVmzDQcNs7oQ
         hFoSQrTWp52eEsyKXYpwVvw2SZynDbdFhBBql8o/K5La9Ib1rbWfxQoGK7QjICk+ar7i
         TokjDq4UaCtZdtkn3gcLHUy6SVMXj4/nwTebEFP9yJmEqIxdx94hjx2WC8JHLVK/I2Af
         yJt8dAj6cSytLYmqbblL4VINfRyw5+9x3kMh+tpzbxGgoR6v6waBnSIVrNTTWGzMB/7n
         C8jw==
X-Gm-Message-State: AOJu0YyhZNJqLWg4b3AOpCrFbiqI6mrLKKxZcHwNX/V7tYTtE52MxbAF
        6wYUmAfu5AYRMqXGGOpy7a1RXFoE7V3q7ZMU8rw=
X-Google-Smtp-Source: AGHT+IGi6s6rUlt0qAPEm4ICHhW+qjjTKLNGHmD6HF2SFM/5l2kOCCcazef+CacZZZQMXZuAeHdowA==
X-Received: by 2002:adf:f08f:0:b0:32d:8872:aac8 with SMTP id n15-20020adff08f000000b0032d8872aac8mr2127161wro.31.1698408243245;
        Fri, 27 Oct 2023 05:04:03 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id m3-20020adffe43000000b003196b1bb528sm1628978wrs.64.2023.10.27.05.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Oct 2023 05:04:02 -0700 (PDT)
Date:   Fri, 27 Oct 2023 15:03:58 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     hare@suse.de
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: aic79xx: Fix up NULL command in ahd_done()
Message-ID: <147c0591-f870-49f0-a6a9-8e68fb3f9ad5@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

[ Sorry Hannes, I should have reviewed this one better -dan ]

Hello Hannes Reinecke,

The patch c7f4c5dec651: "scsi: aic79xx: Fix up NULL command in
ahd_done()" from Oct 23, 2023 (linux-next), leads to the following
Smatch static checker warning:

	drivers/scsi/aic7xxx/aic79xx_osm.c:1837 ahd_done()
	warn: variable dereferenced before check 'cmd' (see line 1793)

drivers/scsi/aic7xxx/aic79xx_osm.c
    1758 void
    1759 ahd_done(struct ahd_softc *ahd, struct scb *scb)
    1760 {
    1761         struct scsi_cmnd *cmd;
    1762         struct          ahd_linux_device *dev;
    1763 
    1764         if ((scb->flags & SCB_ACTIVE) == 0) {
    1765                 printk("SCB %d done'd twice\n", SCB_GET_TAG(scb));
    1766                 ahd_dump_card_state(ahd);
    1767                 panic("Stopping for safety");
    1768         }
    1769         LIST_REMOVE(scb, pending_links);
    1770         cmd = scb->io_ctx;
    1771         dev = scb->platform_data->dev;
    1772         dev->active--;
    1773         dev->openings++;
    1774         if (cmd) {

The rest of the function checks for NULL

    1775                 if ((cmd->result & (CAM_DEV_QFRZN << 16)) != 0) {
    1776                         cmd->result &= ~(CAM_DEV_QFRZN << 16);
    1777                         dev->qfrozen--;
    1778                 }
    1779         } else if (scb->flags & SCB_DEVICE_RESET) {
    1780                 if (ahd->platform_data->eh_done)
    1781                         complete(ahd->platform_data->eh_done);
    1782                 ahd_free_scb(ahd, scb);
    1783                 return;
    1784         }
    1785         ahd_linux_unmap_scb(ahd, scb);
    1786 
    1787         /*
    1788          * Guard against stale sense data.
    1789          * The Linux mid-layer assumes that sense
    1790          * was retrieved anytime the first byte of
    1791          * the sense buffer looks "sane".
    1792          */
    1793         cmd->sense_buffer[0] = 0;
                 ^^^^^^^^^^^^^^^^^^^^^^^^^
There is an unchecked dereference here

    1794         if (ahd_get_transaction_status(scb) == CAM_REQ_INPROG) {
    1795 #ifdef AHD_REPORT_UNDERFLOWS
    1796                 uint32_t amount_xferred;
    1797 
    1798                 amount_xferred =
    1799                     ahd_get_transfer_length(scb) - ahd_get_residual(scb);
    1800 #endif
    1801                 if ((scb->flags & SCB_TRANSMISSION_ERROR) != 0) {
    1802 #ifdef AHD_DEBUG
    1803                         if ((ahd_debug & AHD_SHOW_MISC) != 0) {
    1804                                 ahd_print_path(ahd, scb);
    1805                                 printk("Set CAM_UNCOR_PARITY\n");
    1806                         }
    1807 #endif
    1808                         ahd_set_transaction_status(scb, CAM_UNCOR_PARITY);
    1809 #ifdef AHD_REPORT_UNDERFLOWS
    1810                 /*
    1811                  * This code is disabled by default as some
    1812                  * clients of the SCSI system do not properly
    1813                  * initialize the underflow parameter.  This
    1814                  * results in spurious termination of commands
    1815                  * that complete as expected (e.g. underflow is
    1816                  * allowed as command can return variable amounts
    1817                  * of data.
    1818                  */
    1819                 } else if (amount_xferred < scb->io_ctx->underflow) {
    1820                         u_int i;
    1821 
    1822                         ahd_print_path(ahd, scb);
    1823                         printk("CDB:");
    1824                         for (i = 0; i < scb->io_ctx->cmd_len; i++)
    1825                                 printk(" 0x%x", scb->io_ctx->cmnd[i]);
    1826                         printk("\n");
    1827                         ahd_print_path(ahd, scb);
    1828                         printk("Saw underflow (%ld of %ld bytes). "
    1829                                "Treated as error\n",
    1830                                 ahd_get_residual(scb),
    1831                                 ahd_get_transfer_length(scb));
    1832                         ahd_set_transaction_status(scb, CAM_DATA_RUN_ERR);
    1833 #endif
    1834                 } else {
    1835                         ahd_set_transaction_status(scb, CAM_REQ_CMP);
    1836                 }
--> 1837         } else if (cmd &&
    1838                    ahd_get_transaction_status(scb) == CAM_SCSI_STATUS_ERROR) {
    1839                 ahd_linux_handle_scsi_status(ahd, cmd->device, scb);
    1840         }
    1841 
    1842         if (dev->openings == 1
    1843          && ahd_get_transaction_status(scb) == CAM_REQ_CMP
    1844          && ahd_get_scsi_status(scb) != SAM_STAT_TASK_SET_FULL)
    1845                 dev->tag_success_count++;
    1846         /*
    1847          * Some devices deal with temporary internal resource
    1848          * shortages by returning queue full.  When the queue
    1849          * full occurrs, we throttle back.  Slowly try to get
    1850          * back to our previous queue depth.
    1851          */
    1852         if ((dev->openings + dev->active) < dev->maxtags
    1853          && dev->tag_success_count > AHD_TAG_SUCCESS_INTERVAL) {
    1854                 dev->tag_success_count = 0;
    1855                 dev->openings++;
    1856         }
    1857 
    1858         if (dev->active == 0)
    1859                 dev->commands_since_idle_or_otag = 0;
    1860 
    1861         if ((scb->flags & SCB_RECOVERY_SCB) != 0) {
    1862                 printk("Recovery SCB completes\n");
    1863                 if (ahd_get_transaction_status(scb) == CAM_BDR_SENT
    1864                  || ahd_get_transaction_status(scb) == CAM_REQ_ABORTED)
    1865                         ahd_set_transaction_status(scb, CAM_CMD_TIMEOUT);
    1866 
    1867                 if (ahd->platform_data->eh_done)
    1868                         complete(ahd->platform_data->eh_done);
    1869         }
    1870 
    1871         ahd_free_scb(ahd, scb);
    1872         if (cmd)
    1873                 ahd_linux_queue_cmd_complete(ahd, cmd);
    1874 }

regards,
dan carpenter
