Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0185FC1975A
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 23:22:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5CD42072D
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 23:22:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t788amIN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgCVXWb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 19:22:31 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:39787 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgCVXWb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 19:22:31 -0400
Received: by mail-wm1-f51.google.com with SMTP id a9so9724295wmj.4
        for <linux-scsi@vger.kernel.org>; Sun, 22 Mar 2020 16:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=gHf7d7V8UN/TlDE1b3/LPcoVMy5QYbXlDaxfMKHQtfU=;
        b=t788amINpr+JqeisoOslGWKaceBN1giw5MRM4N2eMlHwlm1ds2sUsT/I1+h6xH+OQB
         NtvRhSqIAS/ep9s/i58PLWGlklg+gqs3mqSEzVkcuIZnpJc674ZmPpNZeAMlUDUdyztv
         NzOCfYqZP5z70a1KIfR/MNzIu5mG5SvmcC/RoCcjWGouCic1ze7gs9fyqj7IjjX3JRvz
         tBkUWIYeN67fcP+E7KlCrWd4hFeAgZWgMYqujivjOBnhuMl3IeuiRr6TOMqanoorSxE7
         jFylldeJ8bO/3Gc+oCShp6xf5eU27DqKEzfKXXNiZkHHOylyp/o/Dlcqd4LvC2OjG/Al
         MZwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=gHf7d7V8UN/TlDE1b3/LPcoVMy5QYbXlDaxfMKHQtfU=;
        b=Ax4G4AP/G0r8f3FdCX/rQnlnLyddU9aynMIN4rZpIAiN2/bFn2c0TZNVes45jSLZrH
         GDKmx7U4m+iRnrN1Mc1Kdbq84wOjMtAm98kAZyGI5c4eSi94XZdDlitJ+MSmyHZZYPvy
         vwRHAbEdL/cQJ6b2YB2KMUx16Q+XSL2WD/cdB++UNfgSL0cAa863/dVLf9Fd9AUICPOp
         m3JxD4G7Wf0PEJFv8HV9MOC1/OP6X0gf5FE6ouOM0TeaJxNwTslww9U8rtZ0lv+3y2Pv
         eNqIVXmo5otZ0W8pkKQcbMfZKp8F1uqjNaSCYbWW8zhgxJ2K8shuCL64iZKM5kTJffTt
         hlOA==
X-Gm-Message-State: ANhLgQ0T8rw3v3dJFsIziFx1pkI6NRQiATETxO+TqVgys2wMKdmLjlik
        TGm6m4indKXX8WX7iOytJ5FtO14Y
X-Google-Smtp-Source: ADFU+vuZ5n57CVk4e3EnhdsH1sjRZu6sRlHN3Dl3X+hop+JPIZCQLhqkW3bNLZd7XTVdu2nW751JDQ==
X-Received: by 2002:a1c:3105:: with SMTP id x5mr24402864wmx.51.1584919348784;
        Sun, 22 Mar 2020 16:22:28 -0700 (PDT)
Received: from ?IPv6:2001:871:25b:80aa:d968:6ff0:1ba6:31eb? (dynamic-2jo7hd4gpbva0jmajv-pd01.res.v6.highway.a1.net. [2001:871:25b:80aa:d968:6ff0:1ba6:31eb])
        by smtp.gmail.com with ESMTPSA id z6sm19496537wrp.95.2020.03.22.16.22.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 16:22:28 -0700 (PDT)
Subject: Re: Invalid optimal transfer size 33553920 accepted when
 physical_block_size 512
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <33fb522e-4f61-1b76-914f-c9e6a3553c9b@gmail.com>
 <yq1o8sowfzn.fsf@oracle.com> <accd7d25-ee35-11b9-e49b-76e20d9550f2@gmail.com>
 <yq1pnd4tbxm.fsf@oracle.com> <1eb896cd-2be1-4225-88d8-5ee590fe063b@gmail.com>
 <yq1eetkrtf6.fsf@oracle.com> <58904bc3-4186-7f9c-dc3c-707aa3d92bfb@gmail.com>
 <46035460-9d63-2a9a-d37b-514640f8732f@gmail.com> <yq14kugrou0.fsf@oracle.com>
From:   Bernhard Sulzer <micraft.b@gmail.com>
Message-ID: <44de25f9-2d57-e90d-7773-b060ccd55358@gmail.com>
Date:   Mon, 23 Mar 2020 00:22:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <yq14kugrou0.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> I also attached a quick debug patch for capturing some more info.

This is, what I am getting now with both patches applied in order:

[  +0.000690] scsi 6:0:0:0: Direct-Access     Seagate Backup+ Hub BK   
D781 PQ: 0 ANSI: 6
[  +0.001009] sd 6:0:0:0: Attached scsi generic sg3 type 0
[  +0.000199] sd 6:0:0:0: [sdc] Spinning up disk...
[  +0.982900] ..
[  +0.300907] ..........ready
[Mär23 00:19] sd 6:0:0:0: [sdc] sd_read_capacity: rc10_first 0, 
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

