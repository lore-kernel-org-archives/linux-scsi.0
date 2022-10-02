Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA0FBC433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Oct 2022 21:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiJBVVk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Oct 2022 17:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiJBVVj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Oct 2022 17:21:39 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3250D360B6
        for <linux-scsi@vger.kernel.org>; Sun,  2 Oct 2022 14:21:38 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id s2so1628624edd.2
        for <linux-scsi@vger.kernel.org>; Sun, 02 Oct 2022 14:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date;
        bh=Qav1UbQj4K/40HDBj0h8dUca0Pd31wpiYJpsff6IXWw=;
        b=inWtio3KK0uQdajOJh0LCEC+oGCa/p1l+iMCXcNc7i0m5eGwcJIBRHd1E/RKMHRyF5
         SfDQozJ6/jQfWx8cb74iAAHs7TmIKow7xXlrEdNLvu//yuNJCirTvhkAkqb7tooDWcXl
         Um605sqbTSraKcUaMdzgFphy2BTyaYmmSXpU64UIpwGMC9uJhZ6LZpkqDxGkI5+NWZ5E
         W7zEnf4/wZtsI+wbvWkrzWdTufzlLoU6POAlKhHGF+gzLRxxG9iSuQCeEoIoOm60UnoB
         i5QB4mMd2sf42Rfzr/1FRyvIzXTRYrRnyI0piCKT5/NhM3wLcXb/LHZBEdK2AU48M/zI
         bmkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=Qav1UbQj4K/40HDBj0h8dUca0Pd31wpiYJpsff6IXWw=;
        b=2EOn0oAYizfczwvSrjorX4VhobrzN6mejOiN7Wx5XoJwDNaWNTbI+PUF1+dOFO8Gl3
         bhD+v+CEZbg+xxj+8kJuWTvKmerVKQ7Hnhl5cG7qWJ7aAKpT5e1OiKcsbNPYDGbArGjw
         ppY2YlA50AANOCMe2eMoq6NIP0oS2Mca8oQoD4TzxzwMC7BeETJc8p7Y0Z85nb36Nd8l
         +8nScG/54Nn6EWns5eyRbR0sH5pZcqwIMAuMs2GJuqh9hsVVJusmaieEmo6DkIsEwxue
         wfNXQtlig6+sYDRY8vYqsMu9A/dWtj/T/ObxLC42IDF4kUOz4hbHjbhUy+AD8S5mXmQc
         /QAA==
X-Gm-Message-State: ACrzQf0kRQLALSztx0qtPbNHDLvHvtgBLfVXrWEOxAaoHTQDUYXeDT3k
        bqTgPiboHxtGfbaBcS0jbyg=
X-Google-Smtp-Source: AMsMyM4Ew1VzTfsI2TUEM5xD3J8iHTrHjOZtW144nJHWx9JsdktmHjCCrLISnqACZF+5sdlhiIqcag==
X-Received: by 2002:aa7:d392:0:b0:458:800a:c47 with SMTP id x18-20020aa7d392000000b00458800a0c47mr10953920edq.5.1664745696699;
        Sun, 02 Oct 2022 14:21:36 -0700 (PDT)
Received: from p200300c5872283a57e3dfef7e307be58.dip0.t-ipconnect.de (p200300c5872283a57e3dfef7e307be58.dip0.t-ipconnect.de. [2003:c5:8722:83a5:7e3d:fef7:e307:be58])
        by smtp.googlemail.com with ESMTPSA id w13-20020a1709060a0d00b0078b83968ad4sm773737ejf.24.2022.10.02.14.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Oct 2022 14:21:36 -0700 (PDT)
Message-ID: <27eaae3fe2b3eb715091f09b38e8d500bc9def52.camel@gmail.com>
Subject: Re: [PATCH v3 8/8] scsi: ufs: Fix a deadlock between PM and the
 SCSI error handler
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Date:   Sun, 02 Oct 2022 23:21:35 +0200
In-Reply-To: <af357394-7329-b218-ccf9-65944a35fc6e@acm.org>
References: <20220929220021.247097-1-bvanassche@acm.org>
         <20220929220021.247097-9-bvanassche@acm.org>
         <67bfe4a2175da74b686a4990a6ebe0b91017599f.camel@gmail.com>
         <af357394-7329-b218-ccf9-65944a35fc6e@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2022-09-30 at 10:15 -0700, Bart Van Assche wrote:
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ufshcd_link_recovery(hba);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0dev_info(hba->dev, "%s() f=
inished; outstanding_tasks =3D
> > > %#lx.\n",
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 __func__, hba->outstanding_tasks);
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return hba->outstanding_ta=
sks ? SCSI_EH_RESET_TIMER :
> > > SCSI_EH_DONE;
> >=20
> > Bart,
> >=20
> > you have reset the device and host,=C2=A0 in the case, there are pendin=
g
> > TMs, Should be cleared locally, just like ufshcd_err_handler()
> > does?
>=20
> Hi Bean,
>=20
> Do you agree with the following?
> * SCSI task management functions are only submitted by the SCSI error
> =C2=A0=C2=A0 handler.
> * The ufshcd_link_recovery() call added by this patch can only be
> =C2=A0=C2=A0 invoked during system suspend.
> * System suspend only happens after processes and kernel threads have
> =C2=A0=C2=A0 been frozen and after sync() finished. Hence, no I/O should =
be in
> =C2=A0=C2=A0 progress when ufshcd_wl_suspend() is called and the SCSI err=
or
> handler
> =C2=A0=C2=A0 should not be running either.
> * Hence, no SCSI commands other than START STOP UNIT should be in
> =C2=A0=C2=A0 progress when the ufshcd_link_recovery() call added by this
> =C2=A0=C2=A0 patch is invoked. No TMFs should be in progress either.
>=20
> Thanks,
>=20
> Bart.

Hi Bart,

Yes, install the whole series of changes, ufshcd_link_recovery() will
be called during the system is in suspending in the case of SSU
timeouts. in this case, outstanding_tasks should be 0?=20

Kind regards,
Bean
