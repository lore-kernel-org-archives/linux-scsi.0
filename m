Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80840C433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 15:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29D3B2231B
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 15:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603120780;
	bh=ckFunxs/0OeORT4phPZvDETLD0+wkI6jZ9ElhPr6JW8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=PLUPvwQlMooDMhB5gFXHtEq0wc0sGUz+z/AmGWlqmdUQrYnfypVVfVn3VsHqfv8HF
	 qhpFSSM2CXSvVEvIbFaxCNVQxhR3kRluRS3zpDEeoPrDj39xBndbCYums356vJkluM
	 c/0AgWrxLRUeuakmuV/5SZVCgaPnRur/ETKUVUoE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729910AbgJSPTj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 11:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729844AbgJSPTj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2020 11:19:39 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D928AC0613CE;
        Mon, 19 Oct 2020 08:19:38 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id q25so34286ioh.4;
        Mon, 19 Oct 2020 08:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=epI/NmqDDFPd2x6NTLconypoymsJp/Js2lA8+8iN1vw=;
        b=rWA1jIE72D+TxJOf19M66XpVkM2rqeqbHdlfiiOP04TJy59RyiyNpW7h9ScTDLNUWv
         fSpik8/0e0wQbdZgnUD5n+0qC2iSlq4ENeGGJYDRe0Tgi5zDsY+c/VgkzxRu54BUcPp9
         x4yrTK8Nv+GLROAe1KIGOCSs8EO5S6kDtGDa37KaMz3OkIbtOpue+LGPeVfK8G8iuACC
         Sws9LPx83dpCwqcEeNgzzM3fRplMeL2jGn6LDokPaUj6xlo49a5WCO7lqpagPqWusOSV
         rvaEtdoY5ORR/ckcVuHOUJZsMTved9EYzumuGuDQ2KLxgJn+f1nd5+8/AndzS7xER1a+
         rP5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=epI/NmqDDFPd2x6NTLconypoymsJp/Js2lA8+8iN1vw=;
        b=uQ0nIDyKj74ImV/6YW3W2fyXvEwUWvXryCd51XtOynZ7PbfhpvgKTk+ZWpaTntJuB+
         2kVYCyha3bjQZwXULtA0C5RIXtsQOPOwId4aDwMGUZ987rHytfr6oZQWHROaB7ioW7xz
         5dss8WkGqRRGyhMV0ACf0/gde09dcrvTADyoZi0+CrZcmAasmVQZ3UTSnVGetPtWN8iX
         6gsHvXjZ5PJFJUTDIAhR22+sxmudTwaTChXY1HDzPAFdhcbklvHmbtwDa/Nbj5RR5yjU
         bL0e3ajeobXYBW5MPjJbrRfSfY//juh76A3qrlLaSOBYVxTh3Fy6hlRYtgcX6Jcs6hcP
         oAXw==
X-Gm-Message-State: AOAM530ZmiwDca/0IFGGSCRDomL1NwQevE9X6OhU/O30EOSOw1bGOJBF
        ewPzVOFB25UIg0hwPVvnylE2IFJcDutPwA==
X-Google-Smtp-Source: ABdhPJwBtDJT5N42PRiolkfYjIPnzv33d5gH/hjFA9FBKJzMqw+8pbIY26pYv8OZwfoo8LRUcFYmbw==
X-Received: by 2002:a02:731e:: with SMTP id y30mr374641jab.78.1603120777982;
        Mon, 19 Oct 2020 08:19:37 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:b34d])
        by smtp.gmail.com with ESMTPSA id z200sm32428iof.47.2020.10.19.08.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 08:19:37 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Mon, 19 Oct 2020 11:19:35 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Muneendra Kumar M <muneendra.kumar@broadcom.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, jsmart2021@gmail.com,
        emilne@redhat.com, mkumar@redhat.com, pbonzini@redhat.com
Subject: Re: [RFC v2 02/18] blkcg: Added a app identifier support for blkcg
Message-ID: <20201019151935.GD4418@mtj.thefacebook.com>
References: <1603093393-12875-1-git-send-email-muneendra.kumar@broadcom.com>
 <1603093393-12875-3-git-send-email-muneendra.kumar@broadcom.com>
 <20201019144619.GC4418@mtj.thefacebook.com>
 <ab237522d9110888aaaa538519f3af7d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab237522d9110888aaaa538519f3af7d@mail.gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 19, 2020 at 08:43:05PM +0530, Muneendra Kumar M wrote:
> Hi Tejun,
> Thanks for the input.
> >> +     cgrp = cgroup_get_from_kernfs_id(id);
> >> +     if (!cgrp)
> >> +             return -ENOENT;
> >> +
> > >+     css = cgroup_get_e_css(cgrp, &io_cgrp_subsys);
> >> +     if (!css)
> >> +             return -ENOENT;
> >> +
> >> +     blkcg = css_to_blkcg(css);
> >> +     if (!blkcg)
> >> +             return -ENOENT;
> > >+		return -EINVAL;
> > >+	strlcpy(blkcg->app_id, buf, len);
> 
> >Shouldn't the cgrp and css be put before exit?
> [Muneendra]Correct me if iam wrong.
> You mean to add cgroup_put(cgrp) and css_put(css) before exit ?

Yeah, as-is it'd leak references each time the function is called.

Thanks.

-- 
tejun
