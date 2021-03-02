Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1733EC4332E
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D743364F1E
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377812AbhCBSxV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446130AbhCBNQl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 08:16:41 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDE4C061356;
        Tue,  2 Mar 2021 05:04:40 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id mj10so14994728ejb.5;
        Tue, 02 Mar 2021 05:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OI5tt0sCGttpQoMssZQT9mgbCLmB50Zsl3yw2ts6M60=;
        b=CYAZD6EWLrsXDx9AZXRGjCCOSs9xuqFQve4dZPSRucjJLNwGGAb5XVwo45Db2F7i1j
         9hyavalHcJu+CWOSo05dVMfSXicLOMWSIVU1WYY0h7i/tO62oc7lItFxg66XX6KBRvPq
         p6qJgLsjsLJ62XehG6tfld7ASPnWb3bhIP7U+fvm+C/Z9eZYEAT3jyrX5Q6VHw0se2p0
         I3Er9LzBmsQZcsRpK/6l5kz7exE3ZHrDukDknStuAV1owa65AdiqjqVX8GxxlGAvQTwx
         kMe+wF9Q7DUtQk8E13Bh1GV3inZLw8myiAwnTVp9B6HJuK0YgmG3FhsYWubLts0G+Lwj
         RDIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OI5tt0sCGttpQoMssZQT9mgbCLmB50Zsl3yw2ts6M60=;
        b=PhsDtGH4yeezSO9Z3XlbAdohPNt+Wory9KT2NYCV09Q1oKGIcjsLjXNJ51qhRAcKiL
         dn1JprGBwFMiH1HqEkTBCK28It9xsY09ux98uXBw38V9ltiuLgt/2qivW3qI8NoTW3b4
         poR1j6EYtr7htwOAgwA8jCKOnSRwnG6weWCnj0HCSOt5gZ9QDy0drH7ZfBXQJk0YRjL3
         2HYorQ4y3ipovdGodBT1Ki/lj0P4Im8EJMhwEWarbX/XxxyS0LteW+EEWUfDBjpoG4qc
         cTwuFMmG5b28/vfmPwWMvUy/k97neSoc97/q7TYsKMamtPxiUh8T1B8Fs85yhdmmwFJB
         0C7g==
X-Gm-Message-State: AOAM532nKgPK9UJ4M8Y1jKcgEtFzKflaqsFW6bG3BXpWWIee/lCIpGCM
        9NDLkQt5F/zRoRPB9yXIoAs=
X-Google-Smtp-Source: ABdhPJxYqJWNJZDziQUK42jJR5CVb/F0FU3Sa+r99rOlEcKP1x4a3bDx+NcPbpP28TqSNGQre9qAMQ==
X-Received: by 2002:a17:906:38d2:: with SMTP id r18mr13415620ejd.104.1614690279372;
        Tue, 02 Mar 2021 05:04:39 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id 35sm19304374edp.85.2021.03.02.05.04.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Mar 2021 05:04:38 -0800 (PST)
Message-ID: <58e8dcea7f3567001c807ca9399f191a4bcaea40.camel@gmail.com>
Subject: Re: [PATCH] scsi: ufs: Fix incorrect ufshcd_state after
 ufshcd_reset_and_restore()
From:   Bean Huo <huobean@gmail.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Date:   Tue, 02 Mar 2021 14:04:38 +0100
In-Reply-To: <5fe97f16-406c-c279-b108-d27bb2769ed6@intel.com>
References: <20210301191940.15247-1-adrian.hunter@intel.com>
         <DM6PR04MB65753E738C556F035A56F77CFC999@DM6PR04MB6575.namprd04.prod.outlook.com>
         <5fe97f16-406c-c279-b108-d27bb2769ed6@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-03-02 at 10:14 +0200, Adrian Hunter wrote:
> > > That can result in the state being UFSHCD_STATE_ERROR even though
> > > ufshcd_reset_and_restore() is successful and returns zero.
> > > 
> > > Fix by initializing the state to UFSHCD_STATE_RESET in the start
> > > of each
> > > loop in ufshcd_reset_and_restore().  If there is an error,
> > > ufshcd_reset_and_restore() will change the state to
> > > UFSHCD_STATE_ERROR,
> > > otherwise ufshcd_probe_hba() will have set the state
> > > appropriately.
> > > 
> > > Fixes: 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler
> > > and other
> > > error recovery paths")
> > > Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> > 
> > I think that CanG recent series addressed that issue as well, can
> > you take a look?
> > 
https://lore.kernel.org/lkml/1614145010-36079-2-git-send-email-cang@codeaurora.org/
> 
> Yes, there it is mixed in with other changes.  However it is probably
> better
> as a separate patch.  Can Guo, what do you think?

we can firstly take this fixup patch.


