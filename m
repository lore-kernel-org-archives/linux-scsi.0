Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C62DAC433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 09:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F2CB206F0
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 09:24:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jqjOU+yG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgGMJYC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 05:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbgGMJYC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 05:24:02 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15072C061755;
        Mon, 13 Jul 2020 02:24:02 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id p20so15820393ejd.13;
        Mon, 13 Jul 2020 02:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sofQEr77nb5Ely19uo5I4O8yF49URxlzQJXvD20UsaM=;
        b=jqjOU+yGnniOCBRAVDqOKYRcKSkWuB5y2Mg2AReSnpmzCReczYmKiwpFjTQJS4MKCz
         KTMyOnKxP8KqW/CdAKR/oIgNhgysH4RUeCQZ61SPYzJkqk3N/3S4KGefN8MyyCIvdP04
         tOWPtPS6h+hXvFVbo97jkUj/xLdU6++lLAXqJCelAHgxVZk9/WGggx41DKh97u8KoCzg
         enRUqaaNoKe9lcGGVQk0UGbLlHSdRruopDzvLvGoQuhGDuuj1U855oBDxmtKDSJtrzkb
         R2qqf82jRmJEUyCjXgipsQ/psyciOeuo3/q1HhNugvp/cggah0XPnmwoA8pQ41B6UwQb
         sliw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sofQEr77nb5Ely19uo5I4O8yF49URxlzQJXvD20UsaM=;
        b=Wov0RJDsWTUo57r4E7I5yWwmiFvMgo+jLo5K4LbXLOHYO/Nn5uLrP1iooyJmj3EB9J
         pbnukd3g26AGGhrUojCMccMVsgJampI6xo5p6ftuO4lzw7YZFgFYoKHHwSyt4RAbD/9l
         +1zl1bn6u7eE5sxr7DEaO0XBK9IEM2x0gUedb1LBt1ILpfe5O2zVxtkQG03jhLf4lNIH
         ZxXqY9LPHDrnHr77LlIBjVUqREhslGftujs7jSzS4KIXg8GlQcIQZS4w/9o+Jl9WAqfy
         iF0IOPy7+5cc/zaE8JPPgKpN4rXzWA+WM9tTk06Tf89sjvJKW8N6B/WeoXe7esMFYjT0
         mmpA==
X-Gm-Message-State: AOAM530KvDqE8YYcCqKfeJOg23ySSYZefwMrcgOUBCVglh1zwOM/M3kg
        aSgfrkIHMmjjpTDC8seN5yo=
X-Google-Smtp-Source: ABdhPJxXvnR2RE6nAjCq0int+k3+MO50374W4zcpVHBgcH2ksNPYtLBLUQPJ/5A2CdO9k4XT3K/wcA==
X-Received: by 2002:a17:906:6a4f:: with SMTP id n15mr71246081ejs.378.1594632240598;
        Mon, 13 Jul 2020 02:24:00 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:b890:27f4:19a2:9a9c:4216:daf1])
        by smtp.googlemail.com with ESMTPSA id o17sm9366918ejb.105.2020.07.13.02.23.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 13 Jul 2020 02:24:00 -0700 (PDT)
Message-ID: <65b3b5bb56d2be8e365aae2163227aac7a71e600.camel@gmail.com>
Subject: Re: [PATCH v5 0/5] scsi: ufs: Add Host Performance Booster Support
From:   Bean Huo <huobean@gmail.com>
To:     daejun7.park@samsung.com, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <Avri.Altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Date:   Mon, 13 Jul 2020 11:23:52 +0200
In-Reply-To: <963815509.21594603681971.JavaMail.epsvc@epcpadp2>
References: <91dcecde-dd0d-c930-7c45-56ba144e748c@acm.org>
         <SN6PR04MB464097E646395C000C2DCAC3FC640@SN6PR04MB4640.namprd04.prod.outlook.com>
         <963815509.21593732182531.JavaMail.epsvc@epcpadp2>
         <231786897.01594251001808.JavaMail.epsvc@epcpadp1>
         <336371513.41594280882718.JavaMail.epsvc@epcpadp2>
         <SN6PR04MB464021F98E8EDF7C79D6CB4FFC640@SN6PR04MB4640.namprd04.prod.outlook.com>
         <CGME20200702231936epcms2p81557f83504ef1c1e81bfc81a0143a5b4@epcms2p7>
         <963815509.21594603681971.JavaMail.epsvc@epcpadp2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-07-13 at 10:27 +0900, Daejun Park wrote:
> Hi Bart,
> 
> > > Bart - how do you want to proceed?
> > 
> > Hi Avri and Daejun,
> > 
> > As far as I can see none of the five patches have Reviewed-by tags
> > yet. I
> > think that Martin expects formal reviews for this patch series from
> > one or
> > more reviewers who are not colleagues of the author of this patch
> > series.
> > 
> > Note: recently I have been more busy than usual, hence the delayed
> > reply.
> 
> Thank you for replying to the email even though you are busy.
> 
> Arvi, Bean - if patches looks ok, can this series have your reviewed-
> by tag?
> 
> Thanks,
> Daejun

Hi Daejun


I only can give my tested-by tag since I preliminary tested it and it
works. However, as I said in the previous email, there is performance
downgrade comparing to the direct submission approach, also, we should
think about HPB 2.0.

Anyway, if Avri wants firstly make this series patch mainlined,
performance fixup later, this is fine to me. I can add and fix it
later.

BTW, you should rebase your this series set patch since there are
conflicts with latest Martin' git repo, after that, you can add my
tested-by tag.


Tested-by: Bean Huo <beanhuo@micron.com>


Thanks,
Bean



