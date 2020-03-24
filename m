Return-Path: <SRS0=zrch=5J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE9F7C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Mar 2020 16:14:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AF0F2073E
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Mar 2020 16:14:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mNvn7qc/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgCXQOf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Mar 2020 12:14:35 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:51931 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbgCXQOe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2020 12:14:34 -0400
Received: by mail-wm1-f43.google.com with SMTP id c187so3857239wme.1
        for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2020 09:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=BUhrY4dh32YEGnds8JEHTvS+RvaR3whNTer3n0pgDjE=;
        b=mNvn7qc/WjQ0hqoaMVKTwjrk1psfmHx7xYp4CTrYOxh2WlpRs0bL3nFrl1JItYmVKt
         0noK/P4CP5YNeFk74lyl+dtNwbcQ0IHKZUNyKpSZ/aU5NhTknBbI6pSf5zkT8w0Lr9dC
         hb0deoS0TtXblH4qRFyhdfCcq7tOTery3bSdiquNb8609i64C6SQANuw8vz2r3XyLpdQ
         tbBIVjRE7lbnz1EuG4ZOL5ARlJFRV59e4CBReB7hGZNZsbyPTptKALeb/armzWfK/89h
         S/YAmqH5yMUtTFtzpeBQjDyD9rkIdsNkW7++5t2+YZgadVIojaS8lBKCNyzRzEDbP2a8
         7sLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=BUhrY4dh32YEGnds8JEHTvS+RvaR3whNTer3n0pgDjE=;
        b=UyzHHCir8pe3cnje6pQcAAqtQxxEOJYxN6HtYGeZoFrgKBpFeNABg/dK9zZIC/rHEK
         gUWBbgsv8+GVOOFZ/M/Ycq/R8TmeGxF3IvfBd7lbxXyTTvGaWcitmRIYIEZ4hjdJ/cjb
         mJpCaPtK4DczHV2BSqcRPYx/omMISWHzu3YjKm2UIwu0R+e9WxVJ6rAgOEY4xqS/amzy
         p3AsTHLEuI5pmGGIX2usl4uI4BSkNwtNv64T6hAr1KqkqomT4xHLctgW17uWRnwP1Ajh
         66XHWjhrwUGQObyAJxT2t+fN00Xg7Cq8CqhrHb5r19cHdS0y4otCZCmerJ+sB0TcSSrP
         jL3Q==
X-Gm-Message-State: ANhLgQ3wAi0zUigfSxUl/leNNiRsua7zDBMfqdW1UASerIPSuRFNLTK2
        xRIl5PXaa8amsAx8xqBb+W8=
X-Google-Smtp-Source: ADFU+vu5rmUHHLr+syqhf0bL1Ushq0VYai+ajk70pHXI+9HEqC15fah0rd07QAPXaL2j7yorRTJcyg==
X-Received: by 2002:a1c:5452:: with SMTP id p18mr6686929wmi.102.1585066471391;
        Tue, 24 Mar 2020 09:14:31 -0700 (PDT)
Received: from ?IPv6:2001:871:25b:80aa:d968:6ff0:1ba6:31eb? (dynamic-2jo7hd4gpbva0jmajv-pd01.res.v6.highway.a1.net. [2001:871:25b:80aa:d968:6ff0:1ba6:31eb])
        by smtp.gmail.com with ESMTPSA id i4sm30286342wrm.32.2020.03.24.09.14.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2020 09:14:30 -0700 (PDT)
Subject: Re: Invalid optimal transfer size 33553920 accepted when
 physical_block_size 512
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bryan Gurney <bgurney@redhat.com>
References: <33fb522e-4f61-1b76-914f-c9e6a3553c9b@gmail.com>
 <yq1o8sowfzn.fsf@oracle.com> <accd7d25-ee35-11b9-e49b-76e20d9550f2@gmail.com>
 <yq1pnd4tbxm.fsf@oracle.com> <1eb896cd-2be1-4225-88d8-5ee590fe063b@gmail.com>
 <yq1eetkrtf6.fsf@oracle.com> <58904bc3-4186-7f9c-dc3c-707aa3d92bfb@gmail.com>
 <46035460-9d63-2a9a-d37b-514640f8732f@gmail.com> <yq14kugrou0.fsf@oracle.com>
 <44de25f9-2d57-e90d-7773-b060ccd55358@gmail.com> <yq1v9mwq82t.fsf@oracle.com>
 <4f6eb89d-57e4-a229-2e95-29fe4a691381@gmail.com> <yq1wo79n41a.fsf@oracle.com>
From:   Bernhard Sulzer <micraft.b@gmail.com>
Message-ID: <729da4d4-2bda-2330-dc3b-01f09973f9bd@gmail.com>
Date:   Tue, 24 Mar 2020 17:14:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <yq1wo79n41a.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>>> And I am guessing your device does not trigger a Unit Attention as a
>>> result. You don't see something like "Inquiry data has changed" or
>>> "Capacity data has changed" in the log, do you?
> I have been working on a set of patches that will address devices like
> this that change their tune halfway through discovery. Your case is
> really just the tip of the iceberg, more changes are needed to handle
> this gracefully.
>
> I'll try to get these changes completed in time for 5.7. However, we
> need a smaller fix for 5.6 and stable. Can you please try the patch I
> just sent?
>
> Thanks!
>
The patch seems to work great.

# dmesg -wH

[  +0.005956] scsi host6: uas
[  +0.000153] usbcore: registered new interface driver uas
[  +0.000392] scsi 6:0:0:0: Direct-Access     Seagate  Backup+ Hub BK   
D781 PQ: 0 ANSI: 6
[  +0.000577] sd 6:0:0:0: Attached scsi generic sg3 type 0
[  +0.000199] sd 6:0:0:0: [sdc] Spinning up disk...
[  +0.059686] usb 2-2-port2: Cannot enable. Maybe the USB cable is bad?
[  +0.957465] .............ready
[ +12.207661] sd 6:0:0:0: [sdc] sd_read_capacity: rc10_first 0, 
rc16_first: 1
[  +0.000108] sd 6:0:0:0: [sdc] read_capacity_16: result 0, retries 2
[  +0.000005] sd 6:0:0:0: [sdc] read_capacity_16: lbs 512, pbs 512, last 
LBA 3a3812aae
[  +0.000278] sd 6:0:0:0: [sdc] 15628053167 512-byte logical blocks: 
(8.00 TB/7.28 TiB)
[  +0.031496] sd 6:0:0:0: [sdc] Write Protect is off
[  +0.000014] sd 6:0:0:0: [sdc] Mode Sense: 4f 00 00 00
[  +0.000160] sd 6:0:0:0: [sdc] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[  +0.000200] sd 6:0:0:0: [sdc] Preferred minimum I/O size 512 bytes
[  +0.000003] sd 6:0:0:0: [sdc] Optimal transfer size 33553920 bytes
[  +0.020620] sd 6:0:0:0: [sdc] sd_read_capacity: rc10_first 0, 
rc16_first: 1
[  +0.000075] sd 6:0:0:0: [sdc] read_capacity_16: result 0, retries 2
[  +0.000003] sd 6:0:0:0: [sdc] read_capacity_16: lbs 512, pbs 4096, 
last LBA 3a3812aae
[  +0.021509] sd 6:0:0:0: [sdc] sd_read_capacity: rc10_first 0, 
rc16_first: 1
[  +0.000077] sd 6:0:0:0: [sdc] read_capacity_16: result 0, retries 2
[  +0.000003] sd 6:0:0:0: [sdc] read_capacity_16: lbs 512, pbs 4096, 
last LBA 3a3812aae
[  +0.000595] sd 6:0:0:0: [sdc] Attached SCSI disk

dmesg does not seem too different, but lsblk's reporting is now correct:

# lsblk -t /dev/sdc
NAME ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE  RA WSAME
sdc          0   4096      0    4096     512    1 mq-deadline 60 128   32M


As you can see I have left the other two patches in too, not sure if I 
was supposed to do that.

Thank you so much. Any chance any of this could be backported?

