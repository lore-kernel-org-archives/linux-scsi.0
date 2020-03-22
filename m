Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C27E5C1975A
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 21:20:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91D45206F9
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 21:20:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WVA6tn8H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgCVVUw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 17:20:52 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:40400 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgCVVUw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 17:20:52 -0400
Received: by mail-wm1-f53.google.com with SMTP id a81so6792841wmf.5
        for <linux-scsi@vger.kernel.org>; Sun, 22 Mar 2020 14:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=DQkYb3YZS/GqJ3cU6YFNac6y2hl7yXUSsRsORnwWnco=;
        b=WVA6tn8Hjc+xDcloaKV31wpxZynHMUUdmuInpwxUBaRtr4oANryrma1iY0kKiwihjs
         4GZY4088QaJh4ALgt3+QLPMn24wrMYka/lW8qdSI94E0kaGjvS+/4i0T2QyenuAHFVkp
         9MjsXrLIfuSwESwUMqhDlRONX7rxq1tC9rC2kc0mv1UwlXT0qgPJO3G/pmy0eWVCN7i8
         ZmYOticq3/gKZl30QnU9Nf4Nfzy6cSVPZHjoRsTLJvnokWK2yo07Hy5guCVg3JFVslPQ
         0Ux9ukmPrx36D8ZVQ+TpFVhQ9GIr5w2EJIqdQctE9uz82SKxvDf4yAwwgGVkObmy/QIH
         nZ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=DQkYb3YZS/GqJ3cU6YFNac6y2hl7yXUSsRsORnwWnco=;
        b=Axfcgr68UHG2orPZPttbP+ksQOLC8jo/tfJpH3Oo5ED37ESBBQIdt2TFsSJjdfbaPh
         Zk94ZCtauHAl2pyh+bboNgw/zbssGfsx86YJSubEAWws5+7W4B3p+8/sn2VMeiGQGNq4
         Z8bVqIqchP68G3Wl5J0/sG4R+Kuz8a1rlfWv1mYhuozcDw6QFXUq9cvlDxiyVkfGG+TH
         kJREqzbRAaYuuzrFwlLkAgQ5thI5fkRRqRJdLYGkSxx+vVDien8rGfl8rgeiy7XB77od
         pvorZbcOj4WPo/dG6s1tV6IT3G3smX0Va8P6WJhVemPSzA8n9bt5+KIDbL8Tpz3/tEBU
         xQxQ==
X-Gm-Message-State: ANhLgQ0xKbT3JoVdnmJ+1+G9O4K/CC71flMtYlt0tKHaj9BdWCbqPwTy
        a3bmQrPh5KifY9sDpw4EtNGGHbxw
X-Google-Smtp-Source: ADFU+vsvi6TC3HhUUNhdU6Rw8fjFiD6ZjH9sQ1++XJ+8H/Pv1+w4eVi2ewtoBN0ODfd3DnTFSrsX7g==
X-Received: by 2002:a1c:1904:: with SMTP id 4mr18650789wmz.21.1584912048417;
        Sun, 22 Mar 2020 14:20:48 -0700 (PDT)
Received: from ?IPv6:2001:871:25b:80aa:d968:6ff0:1ba6:31eb? (dynamic-2jo7hd4gpbva0jmajv-pd01.res.v6.highway.a1.net. [2001:871:25b:80aa:d968:6ff0:1ba6:31eb])
        by smtp.gmail.com with ESMTPSA id f12sm11751890wmf.24.2020.03.22.14.20.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 14:20:47 -0700 (PDT)
Subject: Re: Invalid optimal transfer size 33553920 accepted when
 physical_block_size 512
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <33fb522e-4f61-1b76-914f-c9e6a3553c9b@gmail.com>
 <yq1o8sowfzn.fsf@oracle.com> <accd7d25-ee35-11b9-e49b-76e20d9550f2@gmail.com>
 <yq1pnd4tbxm.fsf@oracle.com> <1eb896cd-2be1-4225-88d8-5ee590fe063b@gmail.com>
 <yq1eetkrtf6.fsf@oracle.com>
From:   Bernhard Sulzer <micraft.b@gmail.com>
Message-ID: <58904bc3-4186-7f9c-dc3c-707aa3d92bfb@gmail.com>
Date:   Sun, 22 Mar 2020 22:20:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <yq1eetkrtf6.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> I sent a patch that I would like you to test. It adds some additional
> sanity checking to the block limits handling. Given the VPD output you
> sent earlier, I am hoping it will work around the issue.
>
> I still can't explain how the physical block size can be unset given
> that it is reported by the device and the capacity is > 0xffffffff. I
> even tried to tweak scsi_debug to see if somehow the no_read_capacity_16
> flag for card readers happened to be set in your case and caused us to
> go down the wrong path. But no. I'm stumped.
>
> Do you have any READ CAPACITY errors or messages in your log? There were
> none in the output you sent.
>

Currently compiling...


# dmesg | grep -i capacity

... returns empty. Are there other tests I should run?

Meanwhile, this is everything dmesg gives me when plugging in the drive, 
running lsblk and launching gparted:

# dmesg -wH

[Mar22 22:18] usb 3-2: new SuperSpeed Gen 1 USB device number 8 using 
xhci_hcd
[  +0.033073] usb 3-2: New USB device found, idVendor=0bc2, 
idProduct=ab45, bcdDevice=48.85
[  +0.000004] usb 3-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  +0.000001] usb 3-2: Product: Backup+ Hub
[  +0.000001] usb 3-2: Manufacturer: Seagate
[  +0.000001] usb 3-2: SerialNumber: 01CB8213B6KJ
[  +0.002245] hub 3-2:1.0: USB hub found
[  +0.000314] hub 3-2:1.0: 3 ports detected
[  +0.334402] usb 3-2.1: new SuperSpeed Gen 1 USB device number 9 using 
xhci_hcd
[  +0.030705] usb 3-2.1: New USB device found, idVendor=0bc2, 
idProduct=ab38, bcdDevice= 1.00
[  +0.000003] usb 3-2.1: New USB device strings: Mfr=2, Product=3, 
SerialNumber=1
[  +0.000001] usb 3-2.1: Product: Backup+ Hub BK
[  +0.000001] usb 3-2.1: Manufacturer: Seagate
[  +0.000001] usb 3-2.1: SerialNumber: NA9Q19AM
[  +0.003609] scsi host6: uas
[  +0.000551] scsi 6:0:0:0: Direct-Access     Seagate  Backup+ Hub BK   
D781 PQ: 0 ANSI: 6
[  +0.000554] sd 6:0:0:0: Attached scsi generic sg3 type 0
[  +0.000177] sd 6:0:0:0: [sdc] Spinning up disk...
[  +1.054179] ...........ready
[ +10.400840] sd 6:0:0:0: [sdc] 15628053167 512-byte logical blocks: 
(8.00 TB/7.28 TiB)
[  +0.038524] sd 6:0:0:0: [sdc] Write Protect is off
[  +0.000002] sd 6:0:0:0: [sdc] Mode Sense: 4f 00 00 00
[  +0.000156] sd 6:0:0:0: [sdc] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[  +0.000243] sd 6:0:0:0: [sdc] Optimal transfer size 33553920 bytes
[  +0.086311] sd 6:0:0:0: [sdc] Attached SCSI disk
[  +0.235116] audit: type=1130 audit(1584911910.652:444): pid=1 uid=0 
auid=4294967295 ses=4294967295 msg='unit=lvm2-pvscan@8:32 comm="systemd" 
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[ +20.268639] audit: type=1100 audit(1584911930.923:445): pid=17078 
uid=1000 auid=1000 ses=3 msg='op=PAM:authentication 
grantors=pam_unix,pam_permit acct="bernhard" 
exe="/usr/lib/polkit-1/polkit-agent-helper-1" hostname=? addr=? 
terminal=? res=success'
[  +0.000213] audit: type=1101 audit(1584911930.923:446): pid=17078 
uid=1000 auid=1000 ses=3 msg='op=PAM:accounting 
grantors=pam_unix,pam_permit,pam_time acct="bernhard" 
exe="/usr/lib/polkit-1/polkit-agent-helper-1" hostname=? addr=? 
terminal=? res=success'
[  +0.019962] audit: type=1105 audit(1584911930.943:447): pid=17071 
uid=1000 auid=1000 ses=3 msg='op=PAM:session_open 
grantors=pam_limits,pam_unix,pam_permit acct="root" 
exe="/usr/bin/pkexec" hostname=? addr=? terminal=? res=success'
[  +0.418886] JFS: nTxBlock = 8192, nTxLock = 65536
[  +0.120146] SGI XFS with ACLs, security attributes, realtime, scrub, 
repair, no debug enabled


