Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD04EC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 14:38:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85364207D3
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 14:38:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="Iml6h8F9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgE1Oim (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 10:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728456AbgE1Oik (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 10:38:40 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3590EC08C5C6
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2020 07:38:40 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id e20so831442qvu.0
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2020 07:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QfE8pAAslmAZm/g+FVpU/rH5cvvjl+v/4emKQRP1D+M=;
        b=Iml6h8F9gaQUCmvJsJVHrv40OU06BHY3TAPtvv5wXsJCX1xdyVOxUeSj7zwQLxO9wm
         lkwMDlW2YDlZoJHnptGDvernnbtDWA1iRKI6OyU8loj59yBH/ahh+jKZ5ePTC8haqfZs
         F9M/uSB87ZBx4LaLGSRMmT1fNGmPeuIxAV+P/pLSS9SyvDZri7UD8lL5msqscYHe/OLB
         pEatjQL7Xk7py3qGZj2GxBrzHBvzsvhH2KjnNaPS35BjxIOHSads4u9PfCvXlzYLMjSB
         B730tY6pQQOedwuNGDWuOlyWN70GpylNSwjvy9grt5/s5GR5aLMX3KZpXDeWl9JLv98o
         8+wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QfE8pAAslmAZm/g+FVpU/rH5cvvjl+v/4emKQRP1D+M=;
        b=kcIfpTUTc1EYYVGeioQHCltqCGI/VvFe7IvpJcMiz6F79iZAKdOJQtGT5AUX675GsU
         p5MTd/0Yu9InnxcCfQyDCr92Kd/W65Iv6TrG6TGNmHovRhML0AEw1eZyvnkbdjz767tg
         2NZYlb+AySMyaO8FU6wSGr/9T+tGmWM5MFzGcfMW8CmtFs5NS+4G6oDbwuCsZ5DZxNcb
         rkUx86nsz+I8bhDdIgPod6fCCrN3uU7CNKkegmUvSDr8j8bBbOyTVUNq+QxX/86+z1cZ
         NRnrWzuqq1nR5VpTmQLm9yCNKs9SRQ1TzLlT1ax4QUn725+K7GLtBQiNwOS+RQJfaYWV
         KNiw==
X-Gm-Message-State: AOAM531tUj8Z5PgItEmKdwMsb2KDukLIvqwkDqiWTckPzrVQ87cmkUg4
        vKIvMYtSf5dwGh0kuU4e+QSR9g==
X-Google-Smtp-Source: ABdhPJwjpsuGFrBfNlHTPOEiw5qUtM/7VqWFW5ea5h58fwWf4R+kb32F0Hh28QliHNtILC9HKFW3FQ==
X-Received: by 2002:a0c:f214:: with SMTP id h20mr3452909qvk.200.1590676719301;
        Thu, 28 May 2020 07:38:39 -0700 (PDT)
Received: from lca.pw (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id 5sm5075895qko.14.2020.05.28.07.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 07:38:38 -0700 (PDT)
Date:   Thu, 28 May 2020 10:38:36 -0400
From:   Qian Cai <cai@lca.pw>
To:     Don.Brace@microchip.com
Cc:     don.brace@microsemi.com, martin.petersen@oracle.com,
        scott.teel@microsemi.com, kevin.barnett@microsemi.com,
        esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: UBSAN: array-index-out-of-bounds in drivers/scsi/hpsa.c:4421:7
Message-ID: <20200528143836.GB2702@lca.pw>
References: <20200526151416.GB991@lca.pw>
 <20200526151926.GC991@lca.pw>
 <SN6PR11MB2848B54B5E6152AA4A7BC261E18E0@SN6PR11MB2848.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR11MB2848B54B5E6152AA4A7BC261E18E0@SN6PR11MB2848.namprd11.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 28, 2020 at 01:46:02PM +0000, Don.Brace@microchip.com wrote:
> Working on this.
> Can you send your configuration?
> ssacli controller all show config detail

https://raw.githubusercontent.com/cailca/linux-mm/master/kcsan.config

# ssacli controller all show

Smart Array P246br in Slot 0 (Embedded)   (sn: PDNLU0ALM8F03U)

> 
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Qian Cai
> Sent: Tuesday, May 26, 2020 10:19 AM
> To: Don Brace <don.brace@microsemi.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>; Scott Teel <scott.teel@microsemi.com>; Kevin Barnett <kevin.barnett@microsemi.com>; esc.storagedev@microsemi.com; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: UBSAN: array-index-out-of-bounds in drivers/scsi/hpsa.c:4421:7
> 
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Sorry, adding a missing subject line.
> 
> On Tue, May 26, 2020 at 11:14:16AM -0400, Qian Cai wrote:
> > The commit 64ce60cab246 ("hpsa: correct skipping masked peripherals") 
> > trigger an UBSAN warning below.
> >
> > When i == 0 in hpsa_update_scsi_devices(),
> >
> > for (i = 0; i < nphysicals + nlogicals + 1; i++) { ...
> >         int phys_dev_index = i - (raid_ctlr_position == 0);
> >
> > It ends up calling LUN[-1].
> >
> > &physdev_list->LUN[phys_dev_index]
> >
> > Should there by a test of underflow to set phys_dev_index == 0 in this case?
> >
> > [  118.395557][   T13] hpsa can't handle SMP requests
> > [  118.444870][   T13] ================================================================================
> > [  118.486725][   T13] UBSAN: array-index-out-of-bounds in drivers/scsi/hpsa.c:4421:7
> > [  118.521606][   T13] index -1 is out of range for type 'struct ext_report_lun_entry [1024]'
> > [  118.559481][   T13] CPU: 0 PID: 13 Comm: kworker/0:1 Not tainted 5.7.0-rc6-next-20200522+ #3
> > [  118.598179][   T13] Hardware name: HP ProLiant BL660c Gen9, BIOS I38 10/17/2018
> > [  118.632882][   T13] Workqueue: events work_for_cpu_fn
> > [  118.656492][   T13] Call Trace:
> > [  118.670899][   T13]  dump_stack+0x10b/0x17f
> > [  118.690216][   T13]  __ubsan_handle_out_of_bounds+0xd2/0x110
> > [  118.712593][  T378] bnx2x 0000:41:00.1: 63.008 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x8 link)
> > [  118.716249][   T13]  hpsa_update_scsi_devices+0x28e3/0x2cc0 [hpsa]
> > [  118.786774][   T13]  hpsa_scan_start+0x228/0x260 [hpsa]
> > [  118.810663][   T13]  ? _raw_spin_unlock_irqrestore+0x6a/0x80
> > [  118.836529][   T13]  do_scsi_scan_host+0x8a/0x110
> > [  118.858104][   T13]  scsi_scan_host+0x222/0x280
> > [  118.879287][   T13]  ? hpsa_scsi_do_inquiry+0xcd/0xe0 [hpsa]
> > [  118.907707][   T13]  hpsa_init_one+0x1b79/0x27c0 [hpsa]
> > [  118.934818][   T13]  ? hpsa_find_device_by_sas_rphy+0xd0/0xd0 [hpsa]
> > [  118.964279][   T13]  local_pci_probe+0x82/0xe0
> > [  118.985405][   T13]  ? pci_name+0x70/0x70
> > [  119.004244][   T13]  work_for_cpu_fn+0x3a/0x60
> > [  119.024672][   T13]  process_one_work+0x49f/0x8f0
> > [  119.046431][   T13]  process_scheduled_works+0x72/0xa0
> > [  119.069906][   T13]  worker_thread+0x463/0x5b0
> > [  119.090347][   T13]  kthread+0x21d/0x240
> > [  119.108531][   T13]  ? pr_cont_work+0xa0/0xa0
> > [  119.128450][   T13]  ? __write_once_size+0x30/0x30
> > [  119.150405][   T13]  ret_from_fork+0x27/0x40
