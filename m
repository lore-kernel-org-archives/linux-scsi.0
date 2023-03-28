Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15CE9C77B60
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Mar 2023 07:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbjC1Haq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Mar 2023 03:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjC1Hap (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Mar 2023 03:30:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07262C1
        for <linux-scsi@vger.kernel.org>; Tue, 28 Mar 2023 00:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679988601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3F0JJUm569bsUq4mHBIO2XFcPjBDYPeARg32QzDeJXo=;
        b=SSQHSQawqJeSd1TrEAs5chAuPrE1YltjuTLHGXkogy1YKky1lhwcwO3Z9+gQGXzfx9G13c
        HJ5PoE+Om3U4LT7JgQTecvhYEU3KyB0DB3vnCMmzIvMdosqFpzeu+5qa6mVxx0B6K0YhOg
        R8vmlII6zNJkFLZJOm6/blgF/vDuwpo=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-bjnmahDaMsyDQpBeNV2XwA-1; Tue, 28 Mar 2023 03:29:59 -0400
X-MC-Unique: bjnmahDaMsyDQpBeNV2XwA-1
Received: by mail-pj1-f71.google.com with SMTP id pm10-20020a17090b3c4a00b0023ff02aced2so503346pjb.1
        for <linux-scsi@vger.kernel.org>; Tue, 28 Mar 2023 00:29:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679988598;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3F0JJUm569bsUq4mHBIO2XFcPjBDYPeARg32QzDeJXo=;
        b=kSKxoW9E1SA3IquX6+y/revCqPc/ohaHwbeRN8TcURY1av5YgMRuUu+Tz9z+5ip8Wx
         qNL0FaUy6W0NKeCrigVJJrUavUjCFPxG6tuNMAYo4yqeTr7ItTEhCf2DO3VJJ/Hs35B3
         xZwosLkowRlgVCjlQ1/QR9RSV9gR98vMa5jD1GFBW0mLw+Lkn7n9eX5p4bzThZgOy0v4
         zp4Nr1CFWd/HoBYRkXjs/Gy6/C7UsRF+OOm2dPFSYNsHN+VduxSdKLixoF4oxPY/a2Mj
         Nk1Drcz7jRx43eHNBaHXLxUG+tCwjoXnFtWhF2Cjtkqpmiqi9iokCGJTbrzvV42BGgae
         w7ww==
X-Gm-Message-State: AAQBX9d3a0Zdm6ran4VXnyvaV7oQNahIVOhuUNDeGrvCI0QHsaUTL3W3
        OVpqNnMT9E84MuAhQI7QxOiNw3VgzKXXw14K9dxruwx3eKg5e/sFqjBPIH7VLe2PmLtfJehgd+j
        LccZJ42+9jvyyb2uHV4iig001KK1CAjR8lid7dw==
X-Received: by 2002:a17:902:a507:b0:1a1:cd69:d2ea with SMTP id s7-20020a170902a50700b001a1cd69d2eamr5295724plq.10.1679988598457;
        Tue, 28 Mar 2023 00:29:58 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZFeI6WR1BDu8ysRlMZHO9EYs8SiFneGMvl6U8PBrRz8SkXDQcipzn0JkOvG9CKaxqJ+l4fXOriYS+sc/sNE/E=
X-Received: by 2002:a17:902:a507:b0:1a1:cd69:d2ea with SMTP id
 s7-20020a170902a50700b001a1cd69d2eamr5295717plq.10.1679988598204; Tue, 28 Mar
 2023 00:29:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAHj4cs_RuqDeoZhbqZgMTx1oQBN+mwFgTpuwE4h0PV0LHYQCpw@mail.gmail.com>
 <c359daa5-e282-bb82-7ef4-a3826e06675c@oracle.com>
In-Reply-To: <c359daa5-e282-bb82-7ef4-a3826e06675c@oracle.com>
From:   Yi Zhang <yi.zhang@redhat.com>
Date:   Tue, 28 Mar 2023 15:29:46 +0800
Message-ID: <CAHj4cs_6DjuZ3Ght4WZU8DeFeYyVPoRjW5Em30y+5KqNnvphrg@mail.gmail.com>
Subject: Re: [regression][bisected] blktests scsi/004 failed
To:     John Garry <john.g.garry@oracle.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 28, 2023 at 3:00=E2=80=AFPM John Garry <john.g.garry@oracle.com=
> wrote:
>
> On 28/03/2023 03:53, Yi Zhang wrote:
> > Hello
> >
> > I found blktests scsi/004 failed[2] on the latest linux-scsi/for-next,
> > bisecting shows it was introduced from[1], pls help check it and let
> > me know if you need any testing for it, thanks.
>
> Thanks for the report. I have sent a fix in
> https://lore.kernel.org/linux-scsi/20230327074310.1862889-1-john.g.garry@=
oracle.com/T/#ma8b4e8856df99139ae4879fa0f49befbf69f1a57
>

Yeah, the issue was fixed by the patch, thanks for the update.

> Please check it.
>
> >
> > [1]
> > 151f0ec9ddb5 (HEAD) scsi: scsi_debug: Drop sdebug_dev_info.num_in_q
> > [2]
> > + ./check scsi/004
> > scsi/004 (ensure repeated TASK SET FULL results in EIO on timing out
> > command) [failed]
> >      runtime  1.889s  ...  1.851s
> >      --- tests/scsi/004.out 2023-03-27 02:51:16.755636763 -0400
> >      +++ /root/blktests/results/nodev/scsi/004.out.bad 2023-03-27
> > 22:49:53.511526901 -0400
> >      @@ -1,3 +1,2 @@
> >       Running scsi/004
> >      -Input/output error
> >       Test complete
> > dmesg:
> > [  268.314709] run blktests scsi/004 at 2023-03-27 22:49:51
> > [  268.325391] scsi_debug:sdebug_driver_probe: scsi_debug: trim
> > poll_queues to 0. poll_q/nr_hw =3D (0/1)
> > [  268.325398] scsi host0: scsi_debug: version 0191 [20210520]
> >                   dev_size_mb=3D8, opts=3D0x0, submit_queues=3D1, stati=
stics=3D1
> > [  268.325575] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug
> >    0191 PQ: 0 ANSI: 7
> > [  268.325693] sd 0:0:0:0: Attached scsi generic sg0 type 0
> > [  268.325775] sd 0:0:0:0: Power-on or device reset occurred
> > [  268.345884] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39
> > MB/8.00 MiB)
> > [  268.355905] sd 0:0:0:0: [sda] Write Protect is off
> > [  268.355909] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
> > [  268.375943] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> > enabled, supports DPO and FUA
> > [  268.406011] sd 0:0:0:0: [sda] Preferred minimum I/O size 512 bytes
> > [  268.406016] sd 0:0:0:0: [sda] Optimal transfer size 524288 bytes
> > [  268.537442] sd 0:0:0:0: [sda] Attached SCSI disk
> > [  270.067115] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> >
> >
>


--=20
Best Regards,
  Yi Zhang

