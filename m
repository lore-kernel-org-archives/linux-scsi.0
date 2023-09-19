Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E7ECE79A8
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Sep 2023 22:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbjISW2n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Sep 2023 18:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbjISW2n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2023 18:28:43 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B15BE
        for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2023 15:28:36 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 46e09a7af769-6c0f2addaefso3610369a34.2
        for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2023 15:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695162516; x=1695767316; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g8IYApqsSB/CXga5Sm1wUBM6vdIibPiaa50vL3BIxdQ=;
        b=MRJJH/2TYgATx7gBhSX5PbQnRXdm8Nl/5+b7phBRKBf+tME9DTsV74ZroRYVCY5Hju
         JD9BrICUvQpA0/VhXbKF0zpKKmIaZ3GBfVopowlJJPWBPImSugc1YkLHI2gB/l78gUlF
         8Ktr448esI3hGUM/3wXM85D5QS0cjGShGSE/naAVkf4cdgPn6FK3LVRNrgy1wzHyGeau
         2PEGQcTvLu4NirtLteejfhN+dnqULcXOR34xsRn2ybYKQCY+UrnAM4cci6q+MMZi1gGh
         QtPX4X8HDTIJwsgCIBRoac7S7ZdKiA20bDs27nmGgTqiw9UI07Dpr4z1iMYpCUbP7bZu
         34qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695162516; x=1695767316;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g8IYApqsSB/CXga5Sm1wUBM6vdIibPiaa50vL3BIxdQ=;
        b=nQWbrt4E2W0W9RDroVIsIsqRTuy9e3KUGjulLPxzs3yOW98R9lIu7g7BRptUhMcMB2
         lPzseXTdKQpJ6JqNszQYu2Z4FIx+MYL/i4evP8M+JbpBNtFFGKnw31BpJBsj6/IzE5Mq
         8GJ3ML7WpeUREajFWu9qz6TOPx9IgDx804XFW1EI/5aoxk4Hk8B7AUScr6QBXnIo/5a6
         ILGygyEyX7qGZQygCr2Ymu6xSB0owecz706RVgri8rBtqXH4QDskDcEA11Q+6INtueeE
         uplamaMCi0B5zFYAfCWLatHBd32DPL8y+Nk03St63W2k4tyq8yYImPfFHVT3jGKPKLuL
         aroQ==
X-Gm-Message-State: AOJu0YwRSwC7eu7/Tdq/dClDXMPLgaO13U0GdgIQqbiIaC16NQJkV3Nc
        +PhmPyvAsyaG67xfLY9ymvkiwScFDvVCRhVxD5X3wQ==
X-Google-Smtp-Source: AGHT+IE9zc6MpYcpPI/9+oxm4bXEuylvEh/WLbTLVVPxVoxV9WzgfH7OgqyfCfSkzDiDEuX9nU/MuzEh+lvyjDqaT7Y=
X-Received: by 2002:a05:6358:724a:b0:143:63ae:cc76 with SMTP id
 i10-20020a056358724a00b0014363aecc76mr1397023rwa.11.1695162515847; Tue, 19
 Sep 2023 15:28:35 -0700 (PDT)
MIME-Version: 1.0
References: <1694411968-14413-1-git-send-email-quic_cang@quicinc.com>
 <1694411968-14413-3-git-send-email-quic_cang@quicinc.com> <6055cd57-4de7-4b7e-a4f3-68a7de1aef28@linaro.org>
 <6225a132-4b7f-bbb4-e863-4e62b99dd79d@quicinc.com> <31823dc4-6f50-435b-9a20-66471209ec31@linaro.org>
 <d34242f8-6e21-1549-b87d-3db2e825b7d5@quicinc.com> <1413119B-8B9C-4DE4-A086-476B2BAA60AD@linaro.org>
 <20230919120829.GB4732@thinkpad>
In-Reply-To: <20230919120829.GB4732@thinkpad>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date:   Wed, 20 Sep 2023 01:27:59 +0300
Message-ID: <CAA8EJppwjzNDsPHZqUdmgQy3fAbP+AFnOo4+FTDCdpBEZp5S_w@mail.gmail.com>
Subject: Re: [PATCH 2/6] scsi: ufs: ufs-qcom: Add support for UFS device
 version detection
To:     Manivannan Sadhasivam <mani@kernel.org>
Cc:     Can Guo <quic_cang@quicinc.com>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        quic_nguyenb@quicinc.com, quic_nitirawa@quicinc.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER..." 
        <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 19 Sept 2023 at 15:08, Manivannan Sadhasivam <mani@kernel.org> wrot=
e:
>
> On Fri, Sep 15, 2023 at 05:31:45AM +0300, Dmitry Baryshkov wrote:
> > On 11 September 2023 13:02:50 GMT+03:00, Can Guo <quic_cang@quicinc.com=
> wrote:
> > >
> > >On 9/11/2023 5:46 PM, Konrad Dybcio wrote:
> > >> On 11.09.2023 11:42, Can Guo wrote:
> > >>> Hi Konrad,
> > >>>
> > >>> On 9/11/2023 5:17 PM, Konrad Dybcio wrote:
> > >>>> On 11.09.2023 07:59, Can Guo wrote:
> > >>>>> From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
> > >>>>>
> > >>>>> Retrieve UFS device version from UFS host controller's spare regi=
ster
> > >>>>> which is populated by bootloader, and use the UFS device version =
together
> > >>>>> with host controller's HW version to decide the proper power mode=
s which
> > >>>>> should be used to configure the UFS PHY.
> > >>>> That sounds a bit fishy.. is there no bootloader-independent
> > >>>> solution to that? Can't we bring in the code that the bootloader
> > >>>> uses to determine these values?
> > >>>>
> > >>>> Konrad
> > >>>
> > >>> Agree, it is.
> > >>>
> > >>>
> > >>> All these complexities come from one request from PHY design team -=
 power saving.
> > >>>
> > >>> And to achieve power saving, Qualcomm UFS developers are requested =
to use the
> > >>>
> > >>> lowest hanging PHY settings which can sustain the Max agreed HS Gea=
r (btw host
> > >>>
> > >>> and UFS device) during UFS's lifecycle in High Level OS,  whereas t=
he power saving
> > >>>
> > >>> request does not apply to bootloader, which works for only a few se=
conds during
> > >>>
> > >>> bootup. Hence, there is no such version detect code in bootloader -=
  it just uses the
> > >>>
> > >>> highest PHY settings to configure PHY, boot up UFS and put UFS devi=
ce version in this
> > >>>
> > >>> register.
> > >> First of all, your email client seems to be inserting 2 newlines
> > >> instead of 1. If you're using thunderbird, you may want to edit:
> > >>
> > >> mail.identity.(default or your mail identity idx).default.compose_ht=
ml
> > >>
> > >> to `false`
> > >>
> > >> and add that to your internal wiki page, as I see many @quic folks h=
aving
> > >> this issue.
> > >>
> > >>
> > >> Going back to the main topic, I don't think we understood each other=
.
> > >> The commit message states:
> > >>
> > >>
> > >> "Retrieve UFS device version from UFS host controller's spare regist=
er
> > >> which is populated by bootloader"
> > >>
> > >>
> > >> Which means the bootloader is able to somehow determine the value
> > >> that's in the spare register and write it there.
> > >>
> > >> I'm asking whether we can take the logic behind this value and
> > >> move it to Linux so that we don't depend on the bootloader to
> > >> guarantee it (e.g. Chrome or some other devices with more exotic
> > >> fw may not work this way).
> > >>
> > >>
> > >> Konrad
> > >
> > >
> > >There is no logic behind this value at all in bootloader, as I explain=
ed, after bootloader
> > >
> > >initializes UFS, bootloader simply reads UFS's device version (the val=
ue you are referring)
> > >
> > >and write it to the register. But in Linux kernel, we need (or want to=
 know) this value
> > >
> > >BEFORE we initialize UFS host controller (and UFS device).
> >
> > Depending on the bootloader behaviour is not an option. For example the=
 kernel might be started via kexec. Or via u-boot. Or grub. Or any other bo=
otloader. So please duplicate the logic to read the UFS version instead.
> >
>
> As Can said, there is no logic in the bootloader. What it does it, after =
doing
> the UFS initialization, it writes the agreed gear (between host and the d=
evice)
> to this register. And in linux, we use that value to initialize the devic=
e
> (i.e., not doing init based on the min gear).
>
> But the important factor here is that, we use this gear value to program =
the PHY
> init sequence. So if there is no hint from the bootloader, linux will pro=
gram
> the min phy sequence (G3/G4) and then once the gear scaling happens, it w=
ill
> program the max phy sequence (G4/G5).
>
> Now on recent platforms, the init sequences are not compatible with each =
other
> i.e., once the min seq. is programmed, then before programming max seq. t=
he
> registers not common to both seq. should be programmed to default value. =
In
> other words, min seq. specific registers should be reset to the default v=
alue.
> Otherwise, there will be stability issues in the PHY.

I see nothing wrong with adding 'default' register programming to the
gear tables. If we have to reset them to the default values to switch
the PHY settings, these writes must be a part of the corresponding
tables.

>
> So to avoid that, if we get the hint from bootloader (always the max supp=
orted
> gear between host and device), then only one seq. will be programmed.
>
> Other way to solve this issue is to reset the non common registers in the=
 init
> seq. to default value. But that will be an additional overhead.
>
> But... if the bootloader doesn't populate this register (if the boot devi=
ce is
> not UFS, like in compute platforms), then this whole logic won't work. Th=
is
> should also be taken into consideration.

Yep, that's the dependency on the bootloader. Which we should avoid.

>
> - Mani
>
> >
> > P.S. you have been asked to fix your email client. Please do so. Or, if=
 you are inserting these linebreaks manually, please stop.
> >
> > >Thanks,
> > >
> > >Can Guo.
> > >
> >
>
> --
> =E0=AE=AE=E0=AE=A3=E0=AE=BF=E0=AE=B5=E0=AE=A3=E0=AF=8D=E0=AE=A3=E0=AE=A9=
=E0=AF=8D =E0=AE=9A=E0=AE=A4=E0=AE=BE=E0=AE=9A=E0=AE=BF=E0=AE=B5=E0=AE=AE=
=E0=AF=8D



--=20
With best wishes
Dmitry
