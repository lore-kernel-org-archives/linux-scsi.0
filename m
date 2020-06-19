Return-Path: <SRS0=E1i/=AA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF7CC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 16:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAAF321707
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 16:14:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MnrHb+bh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391338AbgFSQOl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 12:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390422AbgFSPDy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2020 11:03:54 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BD2C06174E;
        Fri, 19 Jun 2020 08:03:54 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id o26so7901835edq.0;
        Fri, 19 Jun 2020 08:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5ADrT7jFFeW309LoBL3RGIrTXmJjwCmJqXAIhYbchGM=;
        b=MnrHb+bhJPIiNHeaCS8a/fPwOI6wld7b4KlPZ/oOMUF1zVfizNxUckSlCB9snRURSK
         XzbrQM04uoK4hVMgFJuCq6xAqaGH9he+9+BmJvbRtPy7JD90CBG0/Ut8Kgszpie4M5fT
         RZJDv+1XgM+fTfk67GkWVuvYpc84l7+E2xupZasgfuHwokTqnMpTmdNGDIMaxaiOhzRq
         xwhEGmNzE8AMGlUD/gDuw8YkDsoFXC8nBY4G62nHezapFTsIECYROvYVuQW2yXWcNpgt
         vsDouCqgOkmOLyP21fqBslVrlg9EJyrRAH9gUt9EXeo13gSdim3xku8UW9kfb4qMPyxH
         8azg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5ADrT7jFFeW309LoBL3RGIrTXmJjwCmJqXAIhYbchGM=;
        b=BVJfp3D5J9H/q5IGUPrkbKsWNtN0qV72NjrqHOYjN6BqgSu/dZ+uz+AxPGoc0W64/n
         DOQtvziWBmopQroSxXa1XnhMZ087tiKtt5qlAIAWs1Y3G5wy/YOErFH2M8NDvli4mxBg
         8vSWJ+SZKMZ0p5f+7THyDA/MFJrYrRjP0+xWtv0VZfGUiHTzLip+sZZftf7VtZUQz0wb
         SPfcG1mTVEUVNTAD5VSrlzvDWtqbgOWFhNeoFs3eLmJvIZ4mhYUQIILsVZRkyQJ3Fxzq
         GlQT2ss9gLPtDcIFVDkbhgJ74GNiX3Y5sJAcWSik+upbeP9Bp87TfQ1l2aTp17ttcy3J
         Gprg==
X-Gm-Message-State: AOAM531H25o0KRHyUuvavk2zjtjL4j96F1rHkeRJkrVML2p31gzEfIKL
        h0Ls5T7ESKtmpYdfAm+sPeg=
X-Google-Smtp-Source: ABdhPJz9sH1kJUPVEXJrf2QSDqlJenKhQdl0OzUME2Zssy3LTJ1qNCFvxtzlOKQSUuWKycy8K6RLMg==
X-Received: by 2002:a50:f289:: with SMTP id f9mr3714154edm.188.1592579033304;
        Fri, 19 Jun 2020 08:03:53 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:9900:aeb5:e489:2676:2097:fdba])
        by smtp.googlemail.com with ESMTPSA id h9sm4929016ejc.96.2020.06.19.08.03.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Jun 2020 08:03:52 -0700 (PDT)
Message-ID: <dc0c3bcf8b77b838316a0c4a53fdddaa476dd0dc.camel@gmail.com>
Subject: Re: [RFC PATCH ] scsi: remove scsi_sdb_cache
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     beanhuo@micron.com
Date:   Fri, 19 Jun 2020 17:03:47 +0200
In-Reply-To: <acdceada-b183-e41a-8645-aa3716b55236@acm.org>
References: <20200619131042.10759-1-huobean@gmail.com>
         <acdceada-b183-e41a-8645-aa3716b55236@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart

Thanks.

On Fri, 2020-06-19 at 07:31 -0700, Bart Van Assche wrote:
> On 2020-06-19 06:10, Bean Huo wrote:
> > @@ -2039,7 +2024,6 @@ scsi_mode_select(struct scsi_device *sdev,
> > int pf, int sp, int modepage,
> >  		real_buffer[1] = data->medium_type;
> >  		real_buffer[2] = data->device_specific;
> >  		real_buffer[3] = data->block_descriptor_length;
> > -	
Here delete a blank line since there are multiple blank lines.
> > 	
> >  
> >  		cmd[0] = MODE_SELECT;
> >  		cmd[4] = len;
> > @@ -2227,7 +2211,7 @@ scsi_device_set_state(struct scsi_device
> > *sdev, enum scsi_device_state state)
> >  			goto illegal;
> >  		}
> >  		break;
> > -			
> > +

Here has trailing whitespace, delete it.

> >  	case SDEV_RUNNING:
> >  		switch (oldstate) {
> >  		case SDEV_CREATED:
> 
> If these whitespace changes are left out, feel free to add:
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Bean

