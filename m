Return-Path: <SRS0=HoCN=7I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5392FC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 15:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3100820776
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 15:19:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="ew3v7vK1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbgEZPTb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 11:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgEZPTa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 11:19:30 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74441C03E96D
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2020 08:19:30 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id a23so16414206qto.1
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2020 08:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hDH2DFAglXWP9IvsKwaFfTJwRoZ4ZUxT5xU4AOWlNtc=;
        b=ew3v7vK1IiRYKmBo4BlEfAQV0X7Vle4ysiILIAaUadDtUs9RZVZjCFWeVNxUuxzqjw
         V3J53Ve4+4oHwHSttgYhLJOjAlcixkAfLhcM9hafOeetwThu/J10+z15s9Zh2drODxq2
         +46Z1+jn0AXkV/K1D7KAjt8B+tqWuySU5D3GWW/Ao+PnsXgFhIJBGYMIRPnZlfmsw2gs
         KEfuSHDeMej4tQyV3a4FqvPTyUvSP0+1C0Qu61/wsa0bG5PbrORM9tQ9lH8lKzXR2kA5
         tuztnNH/+5eqraX3pXjo20jap70rt8AW9cVFHkUtD4EwCBzgii229NXnLkzIhnamct60
         ve5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hDH2DFAglXWP9IvsKwaFfTJwRoZ4ZUxT5xU4AOWlNtc=;
        b=KEZipTode9FkoJZt/q8ia+nuwkcosfSKA5Dv6zRvXF5VZdRcBXl2OLbptQ31uia3nN
         f6sWkmXSH6I+Dv2bAX35pN88wATKRRE8ohu69pUgptTqqPRvh4URX9OIyz7GPxr3XUt5
         4sKD0FaUJm7vUPIeTidSn1Vjr/sqxrB1Lu7wSmtRTeIZI4IKBsaUYBx9ENZxHxe7fOnr
         WlJAWs4iwUd9pu4e8oz2/KG4JyxaCrROaIDPW6sEz1EXMFoo8V79HaZiNksH3RUHGxuq
         QlhRNZrFUr/6xNcSHrEQqVA58sdjD6yzwnRXIkHTAftGYwhk0sUEtkGd+KEDawuy7KMj
         fQ0w==
X-Gm-Message-State: AOAM530/MPC9G0WUvZmcGYSDXb3e+64qq271GDGG+9Zb4T9aj6O/Toxa
        O/rHUtGRh/2eBarF4fCWHtGSdg==
X-Google-Smtp-Source: ABdhPJwhJhErE+oCuvfF7C1a9gRtveLbj48wq2YUhRCdsjoG2NGVY4fhqnkQCC2jFoUae1lHzjzsdw==
X-Received: by 2002:ac8:2bc4:: with SMTP id n4mr1823482qtn.222.1590506369531;
        Tue, 26 May 2020 08:19:29 -0700 (PDT)
Received: from lca.pw (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id 10sm11741905qkv.136.2020.05.26.08.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 08:19:28 -0700 (PDT)
Date:   Tue, 26 May 2020 11:19:26 -0400
From:   Qian Cai <cai@lca.pw>
To:     Don Brace <don.brace@microsemi.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Scott Teel <scott.teel@microsemi.com>,
        Kevin Barnett <kevin.barnett@microsemi.com>,
        esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: UBSAN: array-index-out-of-bounds in drivers/scsi/hpsa.c:4421:7
Message-ID: <20200526151926.GC991@lca.pw>
References: <20200526151416.GB991@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526151416.GB991@lca.pw>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sorry, adding a missing subject line.

On Tue, May 26, 2020 at 11:14:16AM -0400, Qian Cai wrote:
> The commit 64ce60cab246 ("hpsa: correct skipping masked peripherals")
> trigger an UBSAN warning below.
> 
> When i == 0 in hpsa_update_scsi_devices(),
> 
> for (i = 0; i < nphysicals + nlogicals + 1; i++) {
> ...
>         int phys_dev_index = i - (raid_ctlr_position == 0);
> 
> It ends up calling LUN[-1].
> 
> &physdev_list->LUN[phys_dev_index]
> 
> Should there by a test of underflow to set phys_dev_index == 0 in this case?
> 
> [  118.395557][   T13] hpsa can't handle SMP requests
> [  118.444870][   T13] ================================================================================
> [  118.486725][   T13] UBSAN: array-index-out-of-bounds in drivers/scsi/hpsa.c:4421:7
> [  118.521606][   T13] index -1 is out of range for type 'struct ext_report_lun_entry [1024]'
> [  118.559481][   T13] CPU: 0 PID: 13 Comm: kworker/0:1 Not tainted 5.7.0-rc6-next-20200522+ #3
> [  118.598179][   T13] Hardware name: HP ProLiant BL660c Gen9, BIOS I38 10/17/2018
> [  118.632882][   T13] Workqueue: events work_for_cpu_fn
> [  118.656492][   T13] Call Trace:
> [  118.670899][   T13]  dump_stack+0x10b/0x17f
> [  118.690216][   T13]  __ubsan_handle_out_of_bounds+0xd2/0x110
> [  118.712593][  T378] bnx2x 0000:41:00.1: 63.008 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x8 link)
> [  118.716249][   T13]  hpsa_update_scsi_devices+0x28e3/0x2cc0 [hpsa]
> [  118.786774][   T13]  hpsa_scan_start+0x228/0x260 [hpsa]
> [  118.810663][   T13]  ? _raw_spin_unlock_irqrestore+0x6a/0x80
> [  118.836529][   T13]  do_scsi_scan_host+0x8a/0x110
> [  118.858104][   T13]  scsi_scan_host+0x222/0x280
> [  118.879287][   T13]  ? hpsa_scsi_do_inquiry+0xcd/0xe0 [hpsa]
> [  118.907707][   T13]  hpsa_init_one+0x1b79/0x27c0 [hpsa]
> [  118.934818][   T13]  ? hpsa_find_device_by_sas_rphy+0xd0/0xd0 [hpsa]
> [  118.964279][   T13]  local_pci_probe+0x82/0xe0
> [  118.985405][   T13]  ? pci_name+0x70/0x70
> [  119.004244][   T13]  work_for_cpu_fn+0x3a/0x60
> [  119.024672][   T13]  process_one_work+0x49f/0x8f0
> [  119.046431][   T13]  process_scheduled_works+0x72/0xa0
> [  119.069906][   T13]  worker_thread+0x463/0x5b0
> [  119.090347][   T13]  kthread+0x21d/0x240
> [  119.108531][   T13]  ? pr_cont_work+0xa0/0xa0
> [  119.128450][   T13]  ? __write_once_size+0x30/0x30
> [  119.150405][   T13]  ret_from_fork+0x27/0x40
