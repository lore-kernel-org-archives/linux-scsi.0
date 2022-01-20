Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B407C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jan 2022 15:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346970AbiATPmw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Jan 2022 10:42:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbiATPmt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Jan 2022 10:42:49 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55878C061574
        for <linux-scsi@vger.kernel.org>; Thu, 20 Jan 2022 07:42:49 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id h30so5279535ila.12
        for <linux-scsi@vger.kernel.org>; Thu, 20 Jan 2022 07:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jMAXp8VnJ+IjrL7hVaglVCWV4wV0hn0vEve751/W+rU=;
        b=nVcSSBaM3ZuKAcRq9/OQDjMZEWp4t4qYoLb0nNSz5P7hfy3qHR4O5y1zGNbNQ+QjBm
         /sFSFDt5hBGrvCD0bz46yTd9Dk+z5GqKlCFPGY4Eq35j2KLMlrt67U9Xd7ZD/INKWj/v
         Cye0DralLEN5qZJETwXDBqEj8+0opAjO5b0nTtfTV1rRG+9222kg3dTRCcTyGYEezj9T
         byfm2mPvBG5ybVgNG9dZrqb/OhfObOZCvJks2t3hgCVmLmqMugMCGKGh4wfoBI+J7eKi
         ZN1Cz3/vfsiCvcF6h7jySlJUF0wDBd8qdWRMPT75qT1f630QKW9xuc3m2NWko29cllZL
         4XPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jMAXp8VnJ+IjrL7hVaglVCWV4wV0hn0vEve751/W+rU=;
        b=gLa6e166jMtgK2Uc/VaZ+n6KPzZ+rx2aeIpFqxRwnajk0qU2nWUuBRwmd0VbsbT3Fb
         mpbTe4/gNaloGJF+Ff6OIMnu9QxClfW8mbomwXoEeJYQ4GL8OfJ53CxaRU7efuOWp174
         YrjZlR8ubA2AQEix8pYdvdTcl6VQJ7xvgifdV9zEEfxa4ojr0OOSMEoTJ1xDIxrkBc6q
         5LkQzHle6qyhkIP7JLwx4/6TzZLgLiKOprtRlXI9xKXPJuTTB7yy19LdPIyxwfWqjBca
         8tIZIv/Tr7SzUiEbgMBR3pl6ySrgQ8ICyYN2HhwChMkNE0QqC9ztL7MOutYt02Xt4FFv
         DdlA==
X-Gm-Message-State: AOAM53224dgPKUATeRfsIDiGDcJi++Sxw4lFLzRS/27FU2UyyQFdDIEj
        VaPXBucazRsd6ePkXnx20+u5I1KvzBWoWGioppU=
X-Google-Smtp-Source: ABdhPJxYhhU0oz7mpWXma6CvAezwScSOA3ZBfX26hz9SACKBna3pXmDNqQiNpDPdWjDGY8O/OHfr8xvDJitgXMUcHPY=
X-Received: by 2002:a92:6406:: with SMTP id y6mr20235826ilb.179.1642693368714;
 Thu, 20 Jan 2022 07:42:48 -0800 (PST)
MIME-Version: 1.0
References: <CAFrqyV4COFCGCRN3bXjoSnudMtr0JhhFviUj8QtEZfJq4ZxinA@mail.gmail.com>
 <yq1tue0mn3l.fsf@ca-mkp.ca.oracle.com> <CAFrqyV59OHp3mWLg87wuymJTBXG2i_QwZjUFNtrB4cpt98tgaw@mail.gmail.com>
 <yq1lezbk7v7.fsf@ca-mkp.ca.oracle.com> <CAFrqyV5O5u3_BsrOY_E2qfSNWfz5CS0-bymMDGPx00y-f5SezA@mail.gmail.com>
 <yq1tudzidng.fsf@ca-mkp.ca.oracle.com> <CAFrqyV6hhTDW9m+azsLGth+Jok=KFc+pkoGnTrsr5qDCazY-Kg@mail.gmail.com>
In-Reply-To: <CAFrqyV6hhTDW9m+azsLGth+Jok=KFc+pkoGnTrsr5qDCazY-Kg@mail.gmail.com>
From:   Sven Hugi <hugi.sven@gmail.com>
Date:   Thu, 20 Jan 2022 16:42:37 +0100
Message-ID: <CAFrqyV4n8r6TwNsETfVTv+F_nn8Hg=HuZ6OHgmG_HxPVcvfPzA@mail.gmail.com>
Subject: Re: Samsung t5 / t3 problem with ncq trim
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

so:

 -> sudo sg_inq sda
standard INQUIRY:
  PQual=0  Device_type=0  RMB=0  LU_CONG=0  version=0x06  [SPC-4]
  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
  SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  [BQue=0]
  EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  [Linked=0]  [TranDis=0]  CmdQue=1
  [SPI: Clocking=0x0  QAS=0  IUS=0]
    length=76 (0x4c)   Peripheral device type: disk
 Vendor identification: Samsung
 Product identification: Portable SSD T5
 Product revision level: 0
 Unit serial number: D3A3D7654321

 -> sudo sg_readcap -l sda
Read Capacity results:
   Protection: prot_en=0, p_type=0, p_i_exponent=0
   Logical block provisioning: lbpme=0, lbprz=0
   Last LBA=976773167 (0x3a38602f), Number of logical blocks=976773168
   Logical block length=512 bytes


   Logical blocks per physical block exponent=0
   Lowest aligned LBA=0
Hence:
   Device size: 500107862016 bytes, 476940.0 MiB, 500.11 GB

 -> sudo sg_vpd -p bl sda
Block limits VPD page (SBC):
  Write same non-zero (WSNZ): 0
  Maximum compare and write length: 0 blocks [Command not implemented]
  Optimal transfer length granularity: 1 blocks
  Maximum transfer length: 65535 blocks
  Optimal transfer length: 65535 blocks
  Maximum prefetch transfer length: 65535 blocks
  Maximum unmap LBA count: 4194240
  Maximum unmap block descriptor count: 1
  Optimal unmap granularity: 1 blocks
  Unmap granularity alignment valid: false
  Unmap granularity alignment: 0 [invalid]
  Maximum write same length: 0 blocks [not reported]
  Maximum atomic transfer length: 0 blocks [not reported]
  Atomic alignment: 0 [unaligned atomic writes permitted]
  Atomic transfer length granularity: 0 [no granularity requirement
  Maximum atomic transfer length with atomic boundary: 0 blocks [not reported]
  Maximum atomic boundary size: 0 blocks [can only write atomic 1 block]

 -> sudo sg_vpd -p lbpv sda
Logical block provisioning VPD page (SBC):
  Unmap command supported (LBPU): 1
  Write same (16) with unmap bit supported (LBPWS): 0
  Write same (10) with unmap bit supported (LBPWS10): 0
  Logical block provisioning read zeros (LBPRZ): 0
  Anchored LBAs supported (ANC_SUP): 0
  Threshold exponent: 0 [threshold sets not supported]
  Descriptor present (DP): 0
  Minimum percentage: 0 [not reported]
  Provisioning type: 0 (not known or fully provisioned)
  Threshold percentage: 0 [percentages not supported]

lbpme=0...
so, i guess it's not because of trim...

Am Do., 20. Jan. 2022 um 00:02 Uhr schrieb Sven Hugi <hugi.sven@gmail.com>:
>
> Hello Martin
>
> Thx, i will test that tomorow and send you the result.
> Best case would be, that i got 2 bad SSDs and there is nothing to patch.
> But 2 bad SSDs, in this case i should play in the lottery...
>
> Anyways, we know that the t3 definitely does not have this issue...
>
> Best regards
>
> Sven Hugi
>
> Am Mi., 19. Jan. 2022 um 23:38 Uhr schrieb Martin K. Petersen
> <martin.petersen@oracle.com>:
> >
> >
> > Sven,
> >
> > > The 850 had a problem with ncq trim, disks randomly died and got slow
> > > af with linux.
> >
> > The NCQ quirk does not apply in your case since the drive is attached to
> > Linux via UAS. The UAS-SATA bridge drive may or may not be using NCQ
> > when talking to the drive; we have no way of knowing or influencing that
> > decision, that's all internal to the drive. We only see what is
> > presented on its external USB interface.
> >
> > I don't have a T5 so I don't know about that. But I do have a T3 and it
> > does not report LBPME which is the SCSI way of saying the drive supports
> > TRIM. So Linux isn't even going to attempt to TRIM the drive in this
> > configuration.
> >
> > You are welcome to send the output of the following commands:
> >
> > # sg_inq /dev/sdN
> >
> > # sg_readcap -l /dev/sdN
> >
> > # sg_vpd -p bl /dev/sdN
> >
> > # sg_vpd -p lbpv /dev/sdN
> >
> > for your T5 so we can see what it reports. But with respect to the
> > queued TRIM issue, there isn't really anything that can be done from the
> > Linux side since this is all internal to the device.
> >
> > Had the mSATA drive been directly attached to a SATA controller and not
> > a UAS-to-SATA bridge things would have been different. The special
> > handling of the 850 in libata is meant to address the scenario where
> > Linux is talking to the SATA drive directly. In that configuration the
> > decision about whether to queue or not queue the DSM TRIM operation lies
> > with Linux.
> >
> > --
> > Martin K. Petersen      Oracle Linux Engineering
>
>
>
> --
> Sven Hugi
>
> github.com/ExtraTNT



-- 
Sven Hugi

github.com/ExtraTNT
