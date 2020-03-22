Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F7DC4332B
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 17:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59D2320732
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 17:41:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PfWXQeRQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgCVRla (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 13:41:30 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:38875 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbgCVRla (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 13:41:30 -0400
Received: by mail-wm1-f43.google.com with SMTP id l20so12017220wmi.3
        for <linux-scsi@vger.kernel.org>; Sun, 22 Mar 2020 10:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=lMKCFHMs4dWEUftFXEH6eabusm0yN0G7VN6/dDVXmRI=;
        b=PfWXQeRQWlcViujSaypVoRmXVNYPhiqQzbZvCWLx3iHyip27X1BjfQYN/UElok7dLs
         3AVGhZ5Qc0eDutdgBD8DKWU8asmtLz+XwN+NFTTvfEpBC0Ga7fyUO9WkUZ63F1s1Vb56
         uVAoYVbX9xF7WiWW2ft63ofdOeoQ4m90qfwuUljX4/r1JWyss1U88DTJi67EyYrMLHB5
         0sVFiRYLNlA1GZMA4jhjhBxUBczC1i/XRl/mkJBgFHItW4wCMJpghj45RABzWzJdC0JF
         JYthJZwFBSRH/bCkPyocKxLrhRy9Ho175lZVUo6ZEqC61QH1IY6rujiuPyIGg/kyG/9O
         /Sgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=lMKCFHMs4dWEUftFXEH6eabusm0yN0G7VN6/dDVXmRI=;
        b=RH+Xi9vszj07G9xiZO6ZKXWRX53D45Ie6IHN2AX9CD+SnfRzsGhBa3ddlYtVKy5cLk
         fx/Q/FU81NObcErqig7WoIcmfvmo3ptDrk7lsXB38GUCKdYazdhE9BXARHFHjmvLLBE7
         2jCI5ATCWsCKCcz8RGqsmZCttrU8rVB3AGQ8nMP//3DKlkGUZgyQBhvls6B/u2Wx1Ddu
         imRGB9NRPbpCw6i4dlHA0FUYz4GDW/UymTyPjiUQggfxyMptPVhyofYTwT5I4IAz2Gyp
         a0DHZ7XeXX+oOfioTAvnI8SqarJZxhZ9k17bJtTunRm+/1buSL3dw9GoQNW4tEq1TUCw
         OtOQ==
X-Gm-Message-State: ANhLgQ1pXefFTq8u6xHWhEIBIS9ucIe3kxRfmDj2KZiJ2+BtAXOp56jd
        HmV+WHO7kuPMB3/BE0ZYUSsGkNzm
X-Google-Smtp-Source: ADFU+vtNDiVaGbGY8OG3UpSkLH4WVswbY1Z2+sXoQ36JxppKgHmc0YuWwOPqrkk3iGr1xKbf7ddrFA==
X-Received: by 2002:a1c:2c85:: with SMTP id s127mr22710492wms.18.1584898886491;
        Sun, 22 Mar 2020 10:41:26 -0700 (PDT)
Received: from ?IPv6:2001:871:25b:80aa:d968:6ff0:1ba6:31eb? (dynamic-2jo7hd4gpbva0jmajv-pd01.res.v6.highway.a1.net. [2001:871:25b:80aa:d968:6ff0:1ba6:31eb])
        by smtp.gmail.com with ESMTPSA id a13sm19869157wrh.80.2020.03.22.10.41.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 10:41:25 -0700 (PDT)
Subject: Re: Invalid optimal transfer size 33553920 accepted when
 physical_block_size 512
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
References: <33fb522e-4f61-1b76-914f-c9e6a3553c9b@gmail.com>
 <yq1o8sowfzn.fsf@oracle.com> <accd7d25-ee35-11b9-e49b-76e20d9550f2@gmail.com>
 <yq1pnd4uxof.fsf@oracle.com>
Cc:     linux-scsi@vger.kernel.org
From:   Bernhard Sulzer <micraft.b@gmail.com>
Message-ID: <5591753c-dacd-6ab3-c6a7-2d794097aec5@gmail.com>
Date:   Sun, 22 Mar 2020 18:41:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <yq1pnd4uxof.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Can you send me the output of:
> # dmesg | grep "sd 2:0:0:0"
>
> and
>
> # sg_inq /dev/sdc
>
> Thanks!

Relevant section from dmesg:

     [11987.820542] scsi host6: uas
[11987.821278] scsi 6:0:0:0: Direct-Access     Seagate  Backup+ Hub BK   
D781 PQ: 0 ANSI: 6
[11987.822003] sd 6:0:0:0: Attached scsi generic sg3 type 0
[11987.822117] sd 6:0:0:0: [sdc] Spinning up disk...
[11988.874931] .............ready
[12001.355881] sd 6:0:0:0: [sdc] 15628053167 512-byte logical blocks: 
(8.00 TB/7.28 TiB)
[12001.388502] sd 6:0:0:0: [sdc] Write Protect is off
[12001.388511] sd 6:0:0:0: [sdc] Mode Sense: 4f 00 00 00
[12001.388843] sd 6:0:0:0: [sdc] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[12001.389144] sd 6:0:0:0: [sdc] Optimal transfer size 33553920 bytes
[12001.475091] sd 6:0:0:0: [sdc] Attached SCSI disk

# sg_inq /dev/sdc
standard INQUIRY:
   PQual=0  Device_type=0  RMB=0  LU_CONG=0 version=0x06  [SPC-4]
   [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0 Resp_data_format=2
   SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0 [BQue=0]
   EncServ=0  MultiP=0  [MChngr=0] [ACKREQQ=0]  Addr16=0
   [RelAdr=0]  WBus16=0  Sync=0  [Linked=0] [TranDis=0]  CmdQue=1
   [SPI: Clocking=0x0  QAS=0  IUS=0]
     length=76 (0x4c)   Peripheral device type: disk
Vendor identification: Seagate
Product identification: Backup+ Hub BK
Product revision level: D781
Unit serial number: NA9Q19AM

Hope this helps

