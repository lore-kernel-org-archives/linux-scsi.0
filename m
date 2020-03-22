Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05ECAC1975A
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 23:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1CFA20736
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 23:40:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BKKFjjD8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgCVXko (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 19:40:44 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:39746 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbgCVXko (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 19:40:44 -0400
Received: by mail-wr1-f45.google.com with SMTP id p10so2386473wrt.6
        for <linux-scsi@vger.kernel.org>; Sun, 22 Mar 2020 16:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=nM3Z9D1IWRzZQSihRCcUNhJmYuiO02s0CQnLWmV/SkI=;
        b=BKKFjjD8RR8GOuZYBlLYUhXg3XSnTrAenFSvkkDliJNXp+T166mpKcADxvBkB3L3rC
         t/8ujnIfaOMKpm1xTJRqeM2BsbLUxkiTBhDzp5ny63KuaY6nChZbQar8N9lxoN/O9qpn
         UN51cKA0v5/SS5kBl61qBz3o1zarmWYMrPdPpym+GhYPCepBEA+86V0UFGmkHv/RTAJH
         ppg7UqAlFZD4dbKcI7U7OXQIbvGqgtKZw7oqPbECH5dnkM6oWbA8OswsnMdfOuysTkVa
         34m0HLJP+/TS0tPWnMDBERJi8w5Tq3wxZCtlu8l+oRkvxpOthCYjKDaF5oouQcfThvBA
         Sr6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=nM3Z9D1IWRzZQSihRCcUNhJmYuiO02s0CQnLWmV/SkI=;
        b=Df8Muh0rtdmiFsN6o5Y7WbGyO9vHXeWfOPZm3CFSXVBCUCXKO7SyMaCCGLTfuNpfgf
         3W2I6cmnPGUKIsH42wVOzHCRS4hPbEzPuGzymhNKDs18EEDOTdVVKeJxbMCle23paWok
         TuJUvGn4VJ8C7H1RtGaGc3G7kjsQ0rTJd6WwbPFu5HBUwIMnXFVUWnCZo4QKhuDPAJ2E
         Bt5tSzi0hfAWstn1I7LJC1c833itVUqzUAmA3sjJXNEZdV8Vhy3SdpkdZIWkZSWttYiz
         wD0+oxdxEBSmbI98SQNX5Wxt7l9j5QuNigeOlNrQRW1khXd58PKro/DYPzIYEGXbQFKP
         m3Xg==
X-Gm-Message-State: ANhLgQ1bdJOHMXQ8K4pyNItxehwAfXmEYhoSMCNEWKf3RxxH3JCjvPYz
        7QZUvJoWNlmoF83r/l7j0KcNNSO+
X-Google-Smtp-Source: ADFU+vvsXUMQCoB8wYK5w1neNp6oaqcGe/jX2h6A1JwDs9uy5hX9qYjtA+2Z4+oCwY2ZEURys1o8Bw==
X-Received: by 2002:a5d:54cb:: with SMTP id x11mr15310778wrv.179.1584920440797;
        Sun, 22 Mar 2020 16:40:40 -0700 (PDT)
Received: from ?IPv6:2001:871:25b:80aa:d968:6ff0:1ba6:31eb? (dynamic-2jo7hd4gpbva0jmajv-pd01.res.v6.highway.a1.net. [2001:871:25b:80aa:d968:6ff0:1ba6:31eb])
        by smtp.gmail.com with ESMTPSA id v10sm18425174wml.44.2020.03.22.16.40.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 16:40:40 -0700 (PDT)
Subject: Re: Invalid optimal transfer size 33553920 accepted when
 physical_block_size 512
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <33fb522e-4f61-1b76-914f-c9e6a3553c9b@gmail.com>
 <yq1o8sowfzn.fsf@oracle.com> <accd7d25-ee35-11b9-e49b-76e20d9550f2@gmail.com>
 <yq1pnd4tbxm.fsf@oracle.com> <1eb896cd-2be1-4225-88d8-5ee590fe063b@gmail.com>
 <yq1eetkrtf6.fsf@oracle.com> <58904bc3-4186-7f9c-dc3c-707aa3d92bfb@gmail.com>
 <46035460-9d63-2a9a-d37b-514640f8732f@gmail.com> <yq14kugrou0.fsf@oracle.com>
 <44de25f9-2d57-e90d-7773-b060ccd55358@gmail.com> <yq1v9mwq82t.fsf@oracle.com>
From:   Bernhard Sulzer <micraft.b@gmail.com>
Message-ID: <4f6eb89d-57e4-a229-2e95-29fe4a691381@gmail.com>
Date:   Mon, 23 Mar 2020 00:40:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <yq1v9mwq82t.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23.03.20 00:32, Martin K. Petersen wrote:
> Bernhard,
>
> Ugh, it *does* change on the fly:
>
>> sd 6:0:0:0: [sdc] read_capacity_16: lbs 512, pbs 512, last LBA 3a3812aae
> [...]
>> sd 6:0:0:0: [sdc] read_capacity_16: lbs 512, pbs 4096, last LBA 3a3812aae
> [...]
>> sd 6:0:0:0: [sdc] read_capacity_16: lbs 512, pbs 4096, last LBA 3a3812aae
> And I am guessing your device does not trigger a Unit Attention as a
> result. You don't see something like "Inquiry data has changed" or
> "Capacity data has changed" in the log, do you?
>
There does not seem to be a change in capaticy detected - you got a 
almost complete section of dmesg from me. Anyway, here's the whole thing 
after plugging in:

[  +8.214282] usb 4-2: new SuperSpeed Gen 1 USB device number 2 using 
xhci_hcd
[  +0.021643] usb 4-2: New USB device found, idVendor=0bc2, 
idProduct=ab45, bcdDevice=48.85
[  +0.000002] usb 4-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  +0.000001] usb 4-2: Product: Backup+ Hub
[  +0.000002] usb 4-2: Manufacturer: Seagate
[  +0.000000] usb 4-2: SerialNumber: 01CB8213B6KJ
[  +0.002367] hub 4-2:1.0: USB hub found
[  +0.000277] hub 4-2:1.0: 3 ports detected
[  +0.115567] usb 2-2: new high-speed USB device number 2 using xhci_hcd
[  +0.019555] usb 2-2: New USB device found, idVendor=0bc2, 
idProduct=ab44, bcdDevice=48.85
[  +0.000002] usb 2-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  +0.000001] usb 2-2: Product: Backup+ Hub
[  +0.000001] usb 2-2: Manufacturer: Seagate
[  +0.000001] usb 2-2: SerialNumber: 01CB8213B6KJ
[  +0.000618] hub 2-2:1.0: USB hub found
[  +0.000261] hub 2-2:1.0: 3 ports detected
[  +0.146258] usb 4-2.1: new SuperSpeed Gen 1 USB device number 3 using 
xhci_hcd
[  +0.017416] usb 4-2.1: New USB device found, idVendor=0bc2, 
idProduct=ab38, bcdDevice= 1.00
[  +0.000062] usb 4-2.1: New USB device strings: Mfr=2, Product=3, 
SerialNumber=1
[  +0.000002] usb 4-2.1: Product: Backup+ Hub BK
[  +0.000001] usb 4-2.1: Manufacturer: Seagate
[  +0.000001] usb 4-2.1: SerialNumber: NA9Q19AM
[  +0.854292] usbcore: registered new interface driver usb-storage
[  +0.006271] scsi host6: uas
[  +0.000099] usbcore: registered new interface driver uas
[  +0.000690] scsi 6:0:0:0: Direct-Access     Seagate  Backup+ Hub BK   
D781 PQ: 0 ANSI: 6
[  +0.001009] sd 6:0:0:0: Attached scsi generic sg3 type 0
[  +0.000199] sd 6:0:0:0: [sdc] Spinning up disk...
[  +0.043686] usb 2-2-port2: Cannot enable. Maybe the USB cable is bad?
[  +0.982900] ..
[  +1.648526] audit: type=1131 audit(1584919133.626:206): pid=1 uid=0 
auid=4294967295 ses=4294967295 msg='unit=systemd-hostnamed 
comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? 
terminal=? res=success'
[  +0.092344] audit: type=1334 audit(1584919133.721:207): prog-id=28 
op=UNLOAD
[  +0.000007] audit: type=1334 audit(1584919133.721:208): prog-id=27 
op=UNLOAD
[  +0.300907] ..........ready
[Mar23 00:19] sd 6:0:0:0: [sdc] sd_read_capacity: rc10_first 0, 
rc16_first: 1
[  +0.000068] sd 6:0:0:0: [sdc] read_capacity_16: result 0, retries 2
[  +0.000002] sd 6:0:0:0: [sdc] read_capacity_16: lbs 512, pbs 512, last 
LBA 3a3812aae
[  +0.000236] sd 6:0:0:0: [sdc] 15628053167 512-byte logical blocks: 
(8.00 TB/7.28 TiB)
[  +0.070974] sd 6:0:0:0: [sdc] Write Protect is off
[  +0.000002] sd 6:0:0:0: [sdc] Mode Sense: 4f 00 00 00
[  +0.000153] sd 6:0:0:0: [sdc] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[  +0.000200] sd 6:0:0:0: [sdc] Preferred minimum I/O size 512 bytes
[  +0.000001] sd 6:0:0:0: [sdc] Optimal transfer size 33553920 bytes
[  +0.020349] sd 6:0:0:0: [sdc] sd_read_capacity: rc10_first 0, 
rc16_first: 1
[  +0.000094] sd 6:0:0:0: [sdc] read_capacity_16: result 0, retries 2
[  +0.000002] sd 6:0:0:0: [sdc] read_capacity_16: lbs 512, pbs 4096, 
last LBA 3a3812aae
[  +0.021930] sd 6:0:0:0: [sdc] sd_read_capacity: rc10_first 0, 
rc16_first: 1
[  +0.000079] sd 6:0:0:0: [sdc] read_capacity_16: result 0, retries 2
[  +0.000002] sd 6:0:0:0: [sdc] read_capacity_16: lbs 512, pbs 4096, 
last LBA 3a3812aae
[  +0.000567] sd 6:0:0:0: [sdc] Attached SCSI disk
[  +0.130848] audit: type=1130 audit(1584919143.380:209): pid=1 uid=0 
auid=4294967295 ses=4294967295 msg='unit=lvm2-pvscan@8:32 comm="systemd" 
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[  +8.838420] sd 6:0:0:0: [sdc] sd_read_capacity: rc10_first 0, 
rc16_first: 1
[  +0.000104] sd 6:0:0:0: [sdc] read_capacity_16: result 0, retries 2
[  +0.000003] sd 6:0:0:0: [sdc] read_capacity_16: lbs 512, pbs 4096, 
last LBA 3a3812aae
[ +43.549880] psmouse serio1: Touchpad at isa0060/serio1/input0 lost 
sync at byte 6
[  +0.035220] psmouse serio1: Touchpad at isa0060/serio1/input0 - driver 
resynced.
[Mar23 00:21] sd 6:0:0:0: [sdc] sd_read_capacity: rc10_first 0, 
rc16_first: 1
[  +0.000093] sd 6:0:0:0: [sdc] read_capacity_16: result 0, retries 2
[  +0.000005] sd 6:0:0:0: [sdc] read_capacity_16: lbs 512, pbs 4096, 
last LBA 3a3812aae

