Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C1BC4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE80523B26
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgLHVbM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727872AbgLHVbL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 16:31:11 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F6AC0613CF;
        Tue,  8 Dec 2020 13:30:31 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id m19so26677006ejj.11;
        Tue, 08 Dec 2020 13:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MM65uySM3WXetJR81qISn55UyWapPuFerPV8cOsCP3Y=;
        b=cHeJ70V64ZHJ4xM4opuM/N0V7rL6IS4EcQ2CN80+bzY8Dk2st7ZezednvLPv0kZnBB
         9vK8gzF8tf6cL8nTqHoYsSH4DBnibqno/S7tWFruok40FfppcmxsZEJ9I6B9TwrE6KEr
         sStWLHxwaZUgQg4g8qQIgORa3sZrZuaLDf/ozjJrQZl+8KnMqIDW42ORgoSY7ogVVD8e
         87eUIawqVE4cKEBIRsSrG36WJJTnnB0u2yi0eUJNFMbTVpnAgcJqq4C0jbIifHWldkzf
         DwaSddQJTa/rCz3Sqyiv/oJ8E4hCxod9OSzWWCA8pp2SOc9mV/NfILOoQavCe+k//Sxl
         tUwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MM65uySM3WXetJR81qISn55UyWapPuFerPV8cOsCP3Y=;
        b=Kcw2lkXUpQjxcUDrZI+DJ27fLfr9GRnP0jHstni9uLyoEayQQpWgbdonL0rG4oBpap
         ge7WRFY3Nez8Xx+l4tkHFXZC8eKVfygFWXNfjM5sBnZVCf21vbZF8wcGpn9G9ModZ7cr
         6t84S77etpk/OIt1Ls9MRozBVgZG9y1T8BJp+voDPoFK0IuFTFANNOPeQ3oquANNlMka
         1JEGhvaOeQST4LZDAwfogD/MWBPF2tCEWXG312HmWnP0SnMpJbAJ4HfyN9ZdVPaQqExR
         OvBVWB/cdTIPGyRHjM25Y4zo1J7GIpk8RRcj66eb5ym8cQGS3vgP287ZbaYohFxB1YY8
         6Ntg==
X-Gm-Message-State: AOAM5308bCJUXY9B0hiBGJBKDrPJVPPK8Ui7g+k92LmkaCIPXe3AnsUu
        hiE0DV3ylLVtWd38kqwwmDI=
X-Google-Smtp-Source: ABdhPJy/dxJOq2CWQhw2h4ww0meNqYdCSwA4EfvJVKwBEdTMjAa09YlecAyVbecjCfpXaL/e/t2+Og==
X-Received: by 2002:a17:906:ca47:: with SMTP id jx7mr25907646ejb.237.1607463030132;
        Tue, 08 Dec 2020 13:30:30 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id j5sm46682edl.42.2020.12.08.13.30.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 08 Dec 2020 13:30:29 -0800 (PST)
Message-ID: <4fd0591ce84684448e3f7720321f0c90eb3dccba.camel@gmail.com>
Subject: Re: [PATCH v1 1/3] scsi: ufs: Distinguish between query REQ and
 query RSP in query trace
From:   Bean Huo <huobean@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Dec 2020 22:30:28 +0100
In-Reply-To: <20201207102126.66d8e4f7@gandalf.local.home>
References: <20201206164226.6595-1-huobean@gmail.com>
         <20201206164226.6595-2-huobean@gmail.com>
         <20201207102126.66d8e4f7@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-12-07 at 10:21 -0500, Steven Rostedt wrote:
> > @@ -321,9 +321,15 @@ static void ufshcd_add_cmd_upiu_trace(struct
> > ufs_hba *hba, unsigned int tag,
> >   static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba,
> > unsigned int tag,
> >                const char *str)
> >   {
> > -     struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
> > +     struct utp_upiu_req *rq_rsp;
> > +
> 
> I would add:
> 
>         if (!trace_ufshcd_upiu_enabled())
>                 return;
> 
> Why do the work if the trace point is not enabled?
> 
> -- Steve

Steve,

Thanks a lot, I will fix it in the next version.


Thanks,
Bean


