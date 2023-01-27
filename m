Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F6BC54EAA
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Jan 2023 20:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbjA0UAb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 15:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjA0UAK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 15:00:10 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841F38D421
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jan 2023 11:58:24 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id v3so3901111pgh.4
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jan 2023 11:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q0ouXMwAwSA4ew0v7a5HC4FOC6lURU3IWi45YzY9INQ=;
        b=Uydkg4reFRCWTTLDdZjJxeJz6sBqQoLu+7INdlUva7LbECLWHhKBGw5Bw2JuaIaJx+
         Oh7CrCDULBTXfyFmytr1xJ4LsaI4Xs8/WJZuwu/8PRMRENNvs2cY3ulWN1NeYu4e39s5
         XAQERR7XhnQymfIe5K/+JardywxJZXQQj6YNLwpZfDwZ0rVFYF9Z8wQZSAZgwBU5tLt+
         j4A0TwL6u5PWe3qp7jd5oEI9039VlfTDK31FaNjS0yx1i9BMYDyCbA0+ZHYa9SQEq+fy
         felBBnKZq2TqYxtsnVdQgHySGeRB6U7TiAv3n4kVrUOwaT2KriXdx00zqOvGrLMu5Z1/
         ZHjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q0ouXMwAwSA4ew0v7a5HC4FOC6lURU3IWi45YzY9INQ=;
        b=xEdqzhwy1s/qeN1asSaMeWTKZBpf6yU3KywvGronxmy6yTTJU7hZFNflFyTuz6FSv1
         l9W4/UEfF7vM1toV3cc0yvOMKCp6D3HdFOsJrW7u+Raoy7s0KiACT6txnYEc9gR0wPTC
         VX9GnBXhAKuoSM4/B3iwMfDCNFv9O+TXjms9gKVzssuQoxLvGxyUkHrp1hE75nFbJV0J
         KsWVAHHu/JNpTHREWkv2kDuqip1ec0a4gv0JQp3WKnAoYCiUJI8j0wrdZiXmUiM8K3wh
         +BO1xHHHqyTHJYCS04FXLki/7W8ZqE7sDbixarRuTEjOSlKHdzqNZNMN1UPgjFO99190
         Zk4g==
X-Gm-Message-State: AO0yUKUvIBrMh8gKX/ctNbdPuaaKB/rRXBDZCl4g1YiQcLz/WCXZ1/gS
        sDvd988R/KTq5MXzfLmGBimTvt5EU4tAMmMu6XgMkdthNTq2WdN24guxpaoPiChb8JywGuGDBkG
        NHBV16VjFk3AiA/SaBfr2uHnct8xMKvEN+9EJ/OTzoLP6aoLIHKnwZvfrMsdkca5vocVy5LPhWg
        /tahQ=
X-Google-Smtp-Source: AK7set92/5WOfrkBnFK85A9GOhfFTFZFky6hBudHY+SAiUNm66di6Nq1IKDOPvQiI7O4Z8bUqNJXDQ==
X-Received: by 2002:a05:6a00:278e:b0:592:52a0:6817 with SMTP id bd14-20020a056a00278e00b0059252a06817mr5019200pfb.6.1674849483246;
        Fri, 27 Jan 2023 11:58:03 -0800 (PST)
Received: from smtpclient.apple ([2600:1700:6970:bea0:98e4:2c9:4b09:d80d])
        by smtp.gmail.com with ESMTPSA id q16-20020aa78430000000b00580a0bb411fsm1101401pfn.174.2023.01.27.11.58.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Jan 2023 11:58:02 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.400.51.1.1\))
Subject: Re: The PQ=1 saga
From:   Brian Bunker <brian@purestorage.com>
In-Reply-To: <9545766a-298d-1358-46f0-64ccfaf30ca0@suse.de>
Date:   Fri, 27 Jan 2023 11:57:51 -0800
Cc:     Martin Wilck <mwilck@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6A8AA317-32B0-48F4-82DC-82B65A221A9F@purestorage.com>
References: <yq1lelrleqr.fsf@ca-mkp.ca.oracle.com>
 <4f9794d2-00ed-22da-2b4b-e8afa424bf17@acm.org>
 <d0ac216445c33e9bf98e8c850f4d900acf0787bd.camel@suse.com>
 <9545766a-298d-1358-46f0-64ccfaf30ca0@suse.de>
To:     linux-scsi@vger.kernel.org
X-Mailer: Apple Mail (2.3731.400.51.1.1)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I was doing some more testing of this since it has been a while since I=20=

ran these tests. It looks like reverting this will make the particular =
situation
that I am worried about even worse. I will put the detail in.

With this in place (before you revert it). When SCSI devices are =
discovered
and some have a PQ=3D1 because they are in an unavailable ALUA state:

Jan 27 12:05:29 localhost kernel: scsi 7:0:0:1: scsi scan: peripheral =
device type of 31, no device added

I don=E2=80=99t know if this intentional with the patch or not but any =
devices with PQ=3D1
will not create SCSI devices. The logging is deceptive too since the =
device type
Is 0 and not 31. In my case I have two paths to LUN 1. One is ALUA AO =
and the=20
other in ALUA unavailable.

With this patch in I only get an sd device and an sg device for the AO =
path.=20
The other path to LUN 1 gets no devices created because it is caught in =
the
If condition logged above.

Because there are no SCSI devices created, when the ALUA state returns
to an active state, a SCSI rescan, which I can trigger from the target =
will result
in the devices getting created since the initial scan never created =
devices.

Jan 27 12:26:04 localhost kernel: scsi 7:0:0:1: scsi scan: INQUIRY pass =
1 length 36
Jan 27 12:26:04 localhost kernel: scsi 7:0:0:1: scsi scan: INQUIRY =
successful with code 0x0
Jan 27 12:26:04 localhost kernel: scsi 7:0:0:1: scsi scan: INQUIRY pass =
2 length 96
Jan 27 12:26:04 localhost kernel: scsi 7:0:0:1: scsi scan: INQUIRY =
successful with code 0x0
Jan 27 12:26:04 localhost kernel: scsi 7:0:0:1: Direct-Access     PURE   =
  FlashArray       8888 PQ: 0 ANSI: 6

Things are good with both paths to LUN 1 showing up. It is not optimal =
since the
target has to trigger a LUN scan on the initiator affecting all paths to =
those target
ports.

With the revert of this, things are a little different, but the way they =
had been in
the past.

Jan 27 13:41:19 localhost kernel: sd 7:0:1:1: Asymmetric access state =
changed
Jan 27 13:41:56 localhost kernel: scsi 7:0:1:1: alua: Detached
Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: scsi scan: INQUIRY pass =
1 length 36
Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: scsi scan: INQUIRY =
successful with code 0x0
Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: scsi scan: INQUIRY pass =
2 length 96
Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: scsi scan: INQUIRY =
successful with code 0x0
Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: Direct-Access     PURE   =
  FlashArray       8888 PQ: 1 ANSI: 6
Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: alua: supports implicit =
TPGS
Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: alua: device =
naa.624a9370acc31b042de141460001141c port group 0 rel port a
Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: Attached scsi generic =
sg7 type 0

Now an sg device is created but not an sd device. This means that there =
will be
no way for this device to get an sd device created once the ALUA state =
goes into
an active state.

The same thing done on the target that worked above no longer does:

Jan 27 13:47:48 localhost kernel: scsi 7:0:1:1: scsi scan: device exists =
on 7:0:1:1

To get around this, the existing disk must be deleted so it is not =
caught in the rescan
check. This cannot be controlled on the target, but it will require =
manual intervention
on the initiator.

So the question becomes how should initial scan work when a LUN has a =
PQ=3D1 set.
It is a valid, by spec with ALUA state unavailable but doesn=E2=80=99t =
seem to be
handled. Why allow an sg device but not an sd one on initial scan in =
this case? There
are probably many ways to fix this. I think the simplest is to allow sd =
device creation
on LUNs were PQ=3D1, and only restrict PQ=3D3. I am not sure the side =
effect of this on other
targets. The other approach which will no longer work after the revert =
is to trigger a
rescan from the target. This is sub-optimal since it is disruptive. Any =
approach involving
the ALUA device handler will not help since there is no device to =
transition if it is
discovered with PQ=3D1.

Thanks,
Brian


> On Jan 26, 2023, at 1:01 AM, Hannes Reinecke <hare@suse.de> wrote:
>=20
> On 1/25/23 09:33, Martin Wilck wrote:
>> On Tue, 2023-01-24 at 17:41 -0800, Bart Van Assche wrote:
>>> On 1/24/23 16:01, Martin K. Petersen wrote:
>>>> I would like to revert commit 948e922fc446 ("scsi: core: map PQ=3D1,
>>>> PDT=3Dother values to SCSI_SCAN_TARGET_PRESENT").
>>>=20
>>> That sounds good to me.
>>>=20
>>> Bart.
>>>=20
>> I agree.
> Yep.
>=20
> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke                Kernel Storage Architect
> hare@suse.de                              +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Ivo Totev, =
Andrew
> Myers, Andrew McDonald, Martje Boudien Moerman
>=20

