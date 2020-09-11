Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F39F9C43461
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 16:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CA5F221E7
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 16:43:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U2+bruBi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgIKQnB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Sep 2020 12:43:01 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24355 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726229AbgIKPJd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Sep 2020 11:09:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599836966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VP0KD2ykIvL8aaCBP0kmqyJEn63+UpLpAE1ZkVfgcrE=;
        b=U2+bruBiYSiy/GAllcBpU2ADFdZr6GEuRBxdqPuTQ2qh9S+KztX+lMFKwUFyZFUdqLPCw+
        9qXbeg7c19SUK2OpS4ZRs6R113oRs647ZMAe/658LAAzSOXyiS03E3XfWrhNgi1Jnzy9c+
        jxKXen8HoKa4kj9NJ21MmwfkY4qA8dA=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-TFMNw7kaMP6AkyjDTYhzKg-1; Fri, 11 Sep 2020 11:09:25 -0400
X-MC-Unique: TFMNw7kaMP6AkyjDTYhzKg-1
Received: by mail-qt1-f199.google.com with SMTP id t11so6811183qtn.8
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2020 08:09:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VP0KD2ykIvL8aaCBP0kmqyJEn63+UpLpAE1ZkVfgcrE=;
        b=MEAAaqrGeflOir5gVZf0+8CutG1crhM6Jz5Qg0/yvDUsEgvaplfoplY9bnurDVE2K2
         11QnA5HTpVTTri5U0O601vkm8N+1w3zY6PUDC6WTvsCFMg1ZPGik6ZzA0mGQa911ixhE
         mPsHodjUdZibgdza0DJUMfZiIirWcHvyPXyEl8qeeGAquUcY7/rsfeHX2u62y6X7KsCv
         SkwcP9WQZwMkYEqgz3HGiDC7y8/tBId6Y1fjQGTxVTxWCTCfLvPUHZngQj6lcN2+xuLv
         mibYX82sduDscrSsFCKHqqvqFzGCDhuMBsBMn2WUpw1OsZkDlCYpNQGyb325XQLBHZfM
         OB8w==
X-Gm-Message-State: AOAM533qME68YojpBQxC7dhxMEjcRCAcvDG2XTCc9lRgcYxgTroqkLFe
        dsNbT6qRWwiUF9SVf+7XNrDq1BIrcu1fnr55tvzqU/aa/D4TZRo7RH7RWRf3JbpBG2KzKFlgn3z
        LVcFjUQApEb8iRZXUCB/y7w==
X-Received: by 2002:ac8:53d1:: with SMTP id c17mr2211389qtq.135.1599836963833;
        Fri, 11 Sep 2020 08:09:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdYFYivc4Jm4cZJpRTyd+76I9s3wK0I5qUofAAbYIu4W2SV0rswxb9op1QlNDyA+91g9GOxQ==
X-Received: by 2002:ac8:53d1:: with SMTP id c17mr2211366qtq.135.1599836963426;
        Fri, 11 Sep 2020 08:09:23 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e80:f1:4a17:2cf9:6a8a:f150])
        by smtp.gmail.com with ESMTPSA id k48sm3155730qtk.44.2020.09.11.08.09.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Sep 2020 08:09:21 -0700 (PDT)
Message-ID: <8997efbd16d05d9bf0b3df642f0c08e31f9566a2.camel@redhat.com>
Subject: Re: lpfc on latest 5.9 is very chatty on modprobe
From:   Laurence Oberman <loberman@redhat.com>
To:     linux-scsi <linux-scsi@vger.kernel.org>
Cc:     dick Kennedy <dick.kennedy@broadcom.com>,
        Ewan Milne <emilne@redhat.com>
Date:   Fri, 11 Sep 2020 11:09:20 -0400
In-Reply-To: <c6d80c2a2eb4e938c93feb03c4ed8787aa8faf0d.camel@redhat.com>
References: <c6d80c2a2eb4e938c93feb03c4ed8787aa8faf0d.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-5.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-09-10 at 12:36 -0400, Laurence Oberman wrote:
> Hello
> 
> I was testing lpfc on 5.9 and noticed a lot more logging on modprobe.
> Even when lpfc_log_verbose = 0
> 
> root@segstorage3 ~]# cat /sys/class/scsi_host/host*/lpfc_log_verbose
> 0x0
> 0x0
> 0x0
> 0x0
> 
> Wondered if its been there for a while and its just because I now
> started testing.
> 
> [  143.398194] scsi host3: Emulex LPe12000 PCIe Fibre Channel Adapter
> on PCI bus 0e device 00 irq 213
> [  145.598711] scsi host4: Emulex LPe12000 PCIe Fibre Channel Adapter
> on PCI bus 0e device 01 irq 216
> [  147.877559] lpfc 0000:0b:00.0: 2:6101 Disabling NVME support: Not
> supported by firmware (0 0) x3
> [  147.929264] lpfc 0000:0b:00.0: 2:2574 IO channels: hdwQ 64 IRQ 64
> MRQ: 0
> [  147.974727] scsi host5: Emulex LPe16000 16Gb PCIe Fibre Channel
> Adapter on PCI bus 0b device 00 irq 219 PCI resettable
> [  149.156406] lpfc 0000:0b:00.0: 2:3176 Port Name 0 Physical Link is
> functional
> [  149.284537] lpfc 0000:0b:00.1: 3:6101 Disabling NVME support: Not
> supported by firmware (0 0) x3
> [  149.336809] lpfc 0000:0b:00.1: 3:2574 IO channels: hdwQ 64 IRQ 64
> MRQ: 0
> [  149.388033] scsi host6: Emulex LPe16000 16Gb PCIe Fibre Channel
> Adapter on PCI bus 0b device 01 irq 284 PCI resettable
> [  150.848392] lpfc 0000:0b:00.1: 3:3176 Port Name 1 Physical Link is
> functional
> [  151.477690] lpfc 0000:0b:00.0: 2:1303 Link Up Event x1 received
> Data: x1 x0 x20 x0 x0 x0 0
> [  151.526732] lpfc 0000:0b:00.0: start 183 end 182 cnt 256
> [  151.559193] lpfc 0000:0b:00.0: 183: [  148.759023] 2:2593 WQ
> setup:
> wq[35]-id=35 assoc=35, cq[35]-id=35
> [  151.617510] lpfc 0000:0b:00.0: 184: [  148.763089] 2:(0):0356
> Mailbox cmd x9b (x1/xc) Status x0 Data: x1 x44 x0 x0 x0 x10c x0 x4 x4
> x24 xb8000000 x24 x1000 CQ: x0 x0 x0 x90000000
> [  151.715751] lpfc 0000:0b:00.0: 185: [  148.763090] 2:6087 CQ
> setup:
> cq[36]-id=36, parent eq[36]-id=36
> [  151.772034] lpfc 0000:0b:00.0: 186: [  148.767155] 2:(0):0356
> Mailbox cmd x9b (xc/x1) Status x0 Data: x1 x54 x0 x0 x0 xc01 x0 x4 x4
> x240024 x4008504 x0 xcf400000 CQ: x0 x0 x0 x90000000
> [  151.872722] lpfc 0000:0b:00.0: 187: [  148.767156] 2:2593 WQ
> setup:
> wq[36]-id=36 assoc=36, cq[36]-id=36
> [  151.929396] lpfc 0000:0b:00.0: 188: [  148.771220] 2:(0):0356
> Mailbox cmd x9b (x1/xc) Status x0 Data: x1 x44 x0 x0 x0 x10c x0 x4 x4
> x25 xb8000000 x25 x1000 CQ: x0 x0 x0 x90000000
> [  152.030050] lpfc 0000:0b:00.0: 189: [  148.771221] 2:6087 CQ
> setup:
> cq[37]-id=37, parent eq[37]-id=37
> [  152.085622] lpfc 0000:0b:00.0: 190: [  148.775285] 2:(0):0356
> Mailbox cmd x9b (xc/x1) Status x0 Data: x1 x54 x0 x0 x0 xc01 x0 x4 x4
> x250025 x4008504 x0 xbc7e0000 CQ: x0 x0 x0 x90000000
> [  152.185681] lpfc 0000:0b:00.0: 191: [  148.775287] 2:2593 WQ
> setup:
> wq[37]-id=37 assoc=37, cq[37]-id=37
> [  152.243645] lpfc 0000:0b:00.0: 192: [  148.779351] 2:(0):0356
> Mailbox cmd x9b (x1/xc) Status x0 Data: x1 x44 x0 x0 x0 x10c x0 x4 x4
> x26 xb8000000 x26 x1000 CQ: x0 x0 x0 x90000000
> [  152.341442] lpfc 0000:0b:00.0: 193: [  148.779352] 2:6087 CQ
> setup:
> cq[38]-id=38, parent eq[38]-id=38
> [  152.399734] lpfc 0000:0b:00.0: 194: [  148.783416] 2:(0):0356
> Mailbox cmd x9b (xc/x1) Status x0 Data: x1 x54 x0 x0 x0 xc01 x0 x4 x4
> x260026 x4008504 x0 x5ef40000 CQ: x0 x0 x0 x90000000
> [  152.501390] lpfc 0000:0b:00.0: 195: [  148.783417] 2:2593 WQ
> setup:
> wq[38]-id=38 assoc=38, cq[38]-id=38
> [  152.557531] lpfc 0000:0b:00.0: 196: [  148.787481] 2:(0):0356
> Mailbox cmd x9b (x1/xc) Status x0 Data: x1 x44 x0 x0 x0 x10c x0 x4 x4
> x27 xb8000000 x27 x1000 CQ: x0 x0 x0 x90000000
> ..
> ..
> [  190.872503] lpfc 0000:0b:00.0: start 109 end 115 cnt 6
> [  190.872506] lpfc 0000:0b:00.0: 109: [  190.871058] 2:(0):0117 Xmit
> ELS response x1 to remote NPORT x20300 I/O tag: xb92, size: x8
> port_state x20  rpi x10 fc_flag x800110
> [  190.872507] lpfc 0000:0b:00.0: 110: [  190.871060] 2:(0):0129 Xmit
> ELS RJT xb00 response tag xb92 xri xffff, did x20300, nlp_flag
> x80000000, nlp_state x7, rpi x10
> [  190.872509] lpfc 0000:0b:00.0: 111: [  190.871085] 2:(0):0110 ELS
> response tag xb92 completes Data: x0 x0 x0 x20300 x80000000 x7 x10
> [  190.872511] lpfc 0000:0b:00.0: 112: [  190.872497] 2:2538 Received
> frame rctl:x22, type:x1, frame Data:220a0300 00010600 01290000
> 00000000
> 0048ffff 00000000 00000000
> [  190.872512] lpfc 0000:0b:00.0: 113: [  190.872500] 2:(0):0929 FIND
> node DID Data: xffff896e4faf2c00 x10600 x80000000 x7001801 xc
> xffff896e4faf1200
> [  190.872514] lpfc 0000:0b:00.0: 114: [  190.872501] 2:(0):0112 ELS
> command x14001023 received from NPORT x10600 Data: x20 x800110 xa0300
> xa0300
> [  190.872515] lpfc 0000:0b:00.0: 2:(0):0115 Unknown ELS command
> x14001023 received from NPORT x10600
> [  190.873239] lpfc 0000:0b:00.0: start 115 end 121 cnt 6
> [  190.873241] lpfc 0000:0b:00.0: 115: [  190.872517] 2:(0):0117 Xmit
> ELS response x1 to remote NPORT x10600 I/O tag: xb8f, size: x8
> port_state x20  rpi xc fc_flag x800110
> [  190.873243] lpfc 0000:0b:00.0: 116: [  190.872519] 2:(0):0129 Xmit
> ELS RJT xb00 response tag xb8f xri xffff, did x10600, nlp_flag
> x80000000, nlp_state x7, rpi xc
> [  190.873244] lpfc 0000:0b:00.0: 117: [  190.872545] 2:(0):0110 ELS
> response tag xb8f completes Data: x0 x0 x0 x10600 x80000000 x7 xc
> [  190.873246] lpfc 0000:0b:00.0: 118: [  190.873234] 2:2538 Received
> frame rctl:x22, type:x1, frame Data:220a0300 00010700 01290000
> 00000000
> 008cffff 00000000 00000000
> [  190.873249] lpfc 0000:0b:00.0: 119: [  190.873236] 2:(0):0929 FIND
> node DID Data: xffff896e4faf0600 x10700 x80000000 x7001801 xd
> xffff896e4faf3600
> 
> I have not investogated the masking changes yet, decided to first
> ask.
> 
> Thanks
> Laurence

Hi Dick I dont see this when booting 5.5, which was when I last tested,
and before I start the long arduous code review and maybe bisect I
would rather have you look at it.
Can you look at this please and let me know.
Its not happeniong on latest RHEL8 but could happen if we take latest
code in.

Regards
Laurence

