Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B27CDB474
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 13:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343642AbjJQNim (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 09:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbjJQNil (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 09:38:41 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA33EF0
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 06:38:39 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-32003aae100so4322555f8f.0
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 06:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697549918; x=1698154718; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l/gVPPo7vTjBRivmnr1/j0Xw+P4m6xfcYElEyFBSPD4=;
        b=fndHBqUTfEJKiRKVrvpXHRzSh4H5BMj4oJouKqkuqdNzUmew3388sJPUl4HdekmEwH
         n+2OLXiaUraW/XYZ9GHAO6oQVbiPuM3ylxe3Yns2VYGNNInnT/CBCRlhmoqLG0TaXKjK
         qAJKgQ0KMXiFhb4HJmzh4YGNV+CVfOpch8NZRxQsg2fkr7Le9AU4UKoUAGq6xiDvRomb
         Ps/Bk4lIlqxqMyeqQW9lCAyUxeenXmsIOwIcH57UG34AAp1D5xdpJgGvkET3IMFNe5Fv
         MKdbuWIlo7tQgHkeL7S1PiVPLLVZy7LtdkmYztzY/iUDxy13BiVoGMJm2/DQISn47cTe
         DWhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697549918; x=1698154718;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l/gVPPo7vTjBRivmnr1/j0Xw+P4m6xfcYElEyFBSPD4=;
        b=s3EsfEdSexKmJ2tmhEMDw+cBBI6QD/IRxOQsB4XVzuzynMSVMSPWxZ4jxBdNCEgcCd
         fa5l+7nxZszQCawVUitfbMYUhnKPzT2nXTEuc38rMGPTeitt7vCBA+933ADRoV/6Kyh/
         jGXIyuFqO3689Mb9+uCyeJzSo6KSseG94SJwEyMCPAAsTDO/mazQ86So59h24VdXsSve
         hytmK0kTUoImca1d++igirIk3suw0dw8HIPPfyQPxzpWGPAWPBWjGQHFx3PMF7Sg3Sj5
         m5RfB+FAytQjMfxy4SmfJNckhSJHlw2CRmk0WJttsA7hHhgrT+frt64klWOzAhBPEoOO
         WKHw==
X-Gm-Message-State: AOJu0YxqDl5MXuO2VF0BmBkAoYNzD5J8MkSfn0MbcMop0CI8ih/hCANU
        EmjeuU+JBS9eLoVRmzlPKQDQRg==
X-Google-Smtp-Source: AGHT+IHmdzIr9clJLy2NpQFFZnVZOQ7O74lgAmtMLbdr33Utq2/ic2MVtJLo93BftdbJjWs4haCKmA==
X-Received: by 2002:adf:f092:0:b0:32d:980e:ae7 with SMTP id n18-20020adff092000000b0032d980e0ae7mr1744265wro.2.1697549918223;
        Tue, 17 Oct 2023 06:38:38 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id y2-20020adffa42000000b0032da75af3easm1714219wrr.80.2023.10.17.06.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 06:38:37 -0700 (PDT)
Date:   Tue, 17 Oct 2023 16:38:34 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     hare@suse.de
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: aic79xx: Do not reference SCSI command when
 resetting device
Message-ID: <e0776fce-bf5b-415b-9e17-384b0ead8e32@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Hannes Reinecke,

The patch c67e63800446: "scsi: aic79xx: Do not reference SCSI command
when resetting device" from Oct 2, 2023 (linux-next), leads to the
following Smatch static checker warning:

	drivers/scsi/aic7xxx/aic79xx_osm.c:1793 ahd_done()
	error: we previously assumed 'cmd' could be null (see line 1774)

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
                     ^^^
The patch adds this NULL check

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
--> 1793         cmd->sense_buffer[0] = 0;
                 ^^^^^^^^^^^^^^^^^
But if cmd is NULL we're going to crash anyway

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
    1837         } else if (ahd_get_transaction_status(scb) == CAM_SCSI_STATUS_ERROR) {
    1838                 ahd_linux_handle_scsi_status(ahd, cmd->device, scb);

No check here either

    1839         }
    1840 
    1841         if (dev->openings == 1
    1842          && ahd_get_transaction_status(scb) == CAM_REQ_CMP
    1843          && ahd_get_scsi_status(scb) != SAM_STAT_TASK_SET_FULL)
    1844                 dev->tag_success_count++;
    1845         /*
    1846          * Some devices deal with temporary internal resource
    1847          * shortages by returning queue full.  When the queue
    1848          * full occurrs, we throttle back.  Slowly try to get
    1849          * back to our previous queue depth.
    1850          */
    1851         if ((dev->openings + dev->active) < dev->maxtags
    1852          && dev->tag_success_count > AHD_TAG_SUCCESS_INTERVAL) {
    1853                 dev->tag_success_count = 0;
    1854                 dev->openings++;
    1855         }
    1856 
    1857         if (dev->active == 0)
    1858                 dev->commands_since_idle_or_otag = 0;
    1859 
    1860         if ((scb->flags & SCB_RECOVERY_SCB) != 0) {
    1861                 printk("Recovery SCB completes\n");
    1862                 if (ahd_get_transaction_status(scb) == CAM_BDR_SENT
    1863                  || ahd_get_transaction_status(scb) == CAM_REQ_ABORTED)
    1864                         ahd_set_transaction_status(scb, CAM_CMD_TIMEOUT);
    1865 
    1866                 if (ahd->platform_data->eh_done)
    1867                         complete(ahd->platform_data->eh_done);
    1868         }
    1869 
    1870         ahd_free_scb(ahd, scb);
    1871         ahd_linux_queue_cmd_complete(ahd, cmd);

Or here

    1872 }

regards,
dan carpenter
