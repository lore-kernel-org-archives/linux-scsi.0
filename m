Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7B4C4332B
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 14:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F41C20724
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 14:32:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gktDyyR7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgCVOcn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 10:32:43 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:43730 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbgCVOcn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 10:32:43 -0400
Received: by mail-wr1-f45.google.com with SMTP id b2so13330658wrj.10
        for <linux-scsi@vger.kernel.org>; Sun, 22 Mar 2020 07:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=/MutP32Xbx7TJV11ejWDOHzDAPaWu04aUOlaqhGl2SA=;
        b=gktDyyR7qyoNwse2AgFhpz9e/tsmM08LAOTtCAEFwDznp9hZURalWwYe66pTXuifdD
         nsI0DSvAiiMIKS0zEg8s4N+ncFh7SwyrdwIpihEV0FCB4i22UaqcP4K0kE6Q6R5xnKlL
         lbkUDBZiGmILtRT9bDDTbriCvwWPOd38KD+rB0CngShASF+J0grbEMCcRI2TJZGqo3QI
         4TSMl6rFcpDFY9DHCQEfgaZw8mDMCw3YW77UJAN5yrIw6AMJ+9V1Hm8YzJ4d6KNQ2NH5
         X3iCC67rkeZtHGUQNZNbEYqVIJymbX9J275vaBFDzAwrHqPeMjUXPOi6eHc0TBDhVJuL
         ULqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=/MutP32Xbx7TJV11ejWDOHzDAPaWu04aUOlaqhGl2SA=;
        b=LUEAn0RUl6x0ZP47aYZfMZgow5Ls/1FrNC31lIL+5hZ+gqIa1bufZQIdqx/pzEzVpm
         A2bYHvmhDlJRU+vfbahtmx0oa9tWvvr+D+hx/tiqUXVjkdqrtqWbkQEu/CLYQplQpHX9
         qwv8Ju0RtPUbYhYu8hL3fTI/gzYBtCKvCmHGz/KBHjijIc3CkqAD0wrg8vH7KLycwzjD
         XBIgJeUZKk51YKOjq8TqFr2v85yNVaBMhlStL0LDPPAK2iAt0zDPvLHVT0g/NRBXHn7o
         IXQP77aIO8a2ATY2H1UOwbQWHwyFeN9aTjwKfTc4LnHU4iD9ma+1c1mVZmIqVuBFN1Og
         /m+A==
X-Gm-Message-State: ANhLgQ22qPkPaVinVxC7po7CEG93jjEuAAje9OgW62eVcuVM6YYBSKFz
        jeiTKQJ/TAMooens/OUIffHbKBff
X-Google-Smtp-Source: ADFU+vvIn9evsVCLrOo4G9mMpWtpmkGGS9Fd2gOllUuktZjxBmSi+/I403a3YCGhHPrrw/0Frfc97A==
X-Received: by 2002:a5d:6ac8:: with SMTP id u8mr25238700wrw.53.1584887560380;
        Sun, 22 Mar 2020 07:32:40 -0700 (PDT)
Received: from ?IPv6:2001:871:25b:80aa:d968:6ff0:1ba6:31eb? (dynamic-2jo7hd4gpbva0jmajv-pd01.res.v6.highway.a1.net. [2001:871:25b:80aa:d968:6ff0:1ba6:31eb])
        by smtp.gmail.com with ESMTPSA id c5sm20019002wma.3.2020.03.22.07.32.39
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 07:32:39 -0700 (PDT)
To:     linux-scsi@vger.kernel.org
From:   Bernhard Sulzer <micraft.b@gmail.com>
Subject: Invalid optimal transfer size 33553920 accepted when
 physical_block_size 512
Message-ID: <33fb522e-4f61-1b76-914f-c9e6a3553c9b@gmail.com>
Date:   Sun, 22 Mar 2020 15:32:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

According to the gparted forum 
(http://gparted-forum.surf4.info/viewtopic.php?id=17839) a couple 
sata-usb adapters seem to report an invalid optimal transfer size of 
33553920 (which is 0xFFFF * 512).

This should have been fixed in a83da8a4509d about a year ago by in 
sd_validate_opt_xfer_size by checking whether the optimal transfer size 
opt_xfer_bytes is a multiple of physical_block_size. This works when 
physical block size is 4096, unfortunately it does not when the physical 
block size is 512 (which it is in my case).
Related commit: 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.1&id=a83da8a4509d3ebfe03bb7fffce022e4d5d4764f

This is pretty curious in itself, because lsblk reports 4096 physical 
sector size / 512 logical sector size and I would have thought physical 
sector size and physical block size should be the same. Is this a bug 
that should be reported?

Anyway, maybe 33553920 should always be marked as invalid?


Equipment used:
     # uname -srv
     Linux 5.6.0-rc6-1-git-00137-gb74b991fb8b9 #1 SMP PREEMPT Sat Mar 21 
22:13:06 CET 2020

     # lsblk /dev/sdc -t
     NAME ALIGNMENT MIN-IO   OPT-IO PHY-SEC LOG-SEC ROTA SCHED       
RQ-SIZE  RA WSAME
     sdc          0   4096 33553920    4096     512    1 
mq-deadline      60 128   32M

     # lsblk /dev/sdc -o +KNAME,HCTL,VENDOR,MODEL,SERIAL,REV
     NAME MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT KNAME HCTL VENDOR   
MODEL          SERIAL    REV
     sdc    8:32   0  7.3T  0 disk            sdc   6:0:0:0 Seagate  
Backup+_Hub_BK NA9Q19AM D781

     # cat /proc/scsi/scsi
     Attached devices:
     [...]
     Host: scsi6 Channel: 00 Id: 00 Lun: 00
       Vendor: Seagate  Model: Backup+ Hub BK   Rev: D781
       Type:   Direct-Access                    ANSI  SCSI revision: 06

     # sudo lsusb -tvvv
     /:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/4p, 5000M
         ID 1d6b:0003 Linux Foundation 3.0 root hub
         /sys/bus/usb/devices/usb4  /dev/bus/usb/004/001
         |__ Port 2: Dev 6, If 0, Class=Hub, Driver=hub/3p, 5000M
             ID 0bc2:ab45 Seagate RSS LLC
             /sys/bus/usb/devices/4-2  /dev/bus/usb/004/006
             |__ Port 1: Dev 7, If 0, Class=Mass Storage, Driver=uas, 5000M
                 ID 0bc2:ab38 Seagate RSS LLC Backup Plus Hub
                 /sys/bus/usb/
     [...]


Thanks, and please be easy on me

