Return-Path: <SRS0=ULGd=EP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82926C2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 13:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2700220731
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 13:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604929800;
	bh=BtHAzOEY1E9w+I8b7s+g9VBLDsLt+n7RSEgJUkES+Ys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=CZzJkwHOoDLX1o5aVS9YjJNX/ho2z5TCws5RhdFcd19J+2VXB4ww9FpPlSuUnc1qe
	 Urs/FvI8AhT4+nQkMdfZg4D5aPecJAeqfvgqJOcwzK9lhgR6MZ4NEzbJJCM45nTcr4
	 ZpFdq2ZSaQDiCGnbZ4TNRY2EFBJrOeBJNnzcCkpQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbgKINt7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Nov 2020 08:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgKINt4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2020 08:49:56 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EC4C0613CF;
        Mon,  9 Nov 2020 05:49:55 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id r12so4016209qvq.13;
        Mon, 09 Nov 2020 05:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b/ROwKmSowuZ8b24Yd7aJ9Hn3G189OMSwVtmsQPyJKQ=;
        b=gtjQ3TKuIrzqO/1qDfFQ1QWwBn2pMpPvBvQgltCE5fjgQfbcBruG2wsk9sqvXKhjJo
         uaC9yquLvHSt97neC6MhCArQWuo5IQy7WDIQvDCTosF+Z2SlNcPUSfdQUuudeJzRm5vn
         e9WnYGvt7PVFtSSn4uYXxY8usl5qgCxpFPhS9PuL2W7OB140iZodbBEIz7PNEamjP8/5
         ChweBAf+LHvLA2KQdnrLnXL9MAZwOQvDlwm8TSQqxNWpDs/E7ZvcnHMAcLhORghL36TP
         9kTA/pU/VVVxpL0lOLMKZu2R6pVVEds6F5HS0oX/GNh2cvIL3R63OB+DKnfLfXuky9e5
         oYGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=b/ROwKmSowuZ8b24Yd7aJ9Hn3G189OMSwVtmsQPyJKQ=;
        b=X5iteUnpZJGItfyc0kQlH999Zuo59U4ycJmZMx0j8xY1H+1ql6RjXD6DVn9Ch93UK2
         XoZRe5R4NoSsS2n4OOLeyzU8Q8h/3M9atN8fQBydPwBYgKqUcHpb+/zRF9zB2z8ELHnE
         TDFtUzIcw8ybSJdtnwpHskj4j+L+5XhUMX8K3p9mqwp8iUiUsBsBPLzavxsPcuYxpC6f
         NNM1TWMD13iFk3Z3LPrnhVn0M+d4f3sjEQvP2I37N9L8BMACZyz6CuUapFZgEFL+KZS5
         GFfchltLWpi7+tiYJZHcleQD/vY6j1k4NUe6VniTih/YlJ+W1+wT3NfzzdTpUXrlandD
         axag==
X-Gm-Message-State: AOAM5331SiyOizyBoQYwFJtmbt/c0py8Bqii0jDt5668OJS+qajJTQKx
        bIkgZ7q7Y+GM7ce6ocfFV35wCnRs+mpHJQ==
X-Google-Smtp-Source: ABdhPJx2CDufxqBncB2CpkALJ5LrGPgbiyWH1thHAs8sP+x3QLK+gBeMSy7lVhZ+zrWZJDaFEblQKw==
X-Received: by 2002:a05:6214:2e1:: with SMTP id h1mr5530026qvu.60.1604929794985;
        Mon, 09 Nov 2020 05:49:54 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:fc2b])
        by smtp.gmail.com with ESMTPSA id l3sm4191873qkj.114.2020.11.09.05.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 05:49:46 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Mon, 9 Nov 2020 08:49:33 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Muneendra <muneendra.kumar@broadcom.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, jsmart2021@gmail.com,
        emilne@redhat.com, mkumar@redhat.com, pbonzini@redhat.com
Subject: Re: [PATCH v3 01/19] cgroup: Added cgroup_get_from_kernfs_id
Message-ID: <20201109134933.GC7496@mtj.duckdns.org>
References: <1604387903-20006-1-git-send-email-muneendra.kumar@broadcom.com>
 <1604387903-20006-2-git-send-email-muneendra.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604387903-20006-2-git-send-email-muneendra.kumar@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

Generally looks good to me. A few nits.

On Tue, Nov 03, 2020 at 12:48:05PM +0530, Muneendra wrote:
> Added a new function cgroup_get_from_kernfs_id  to retrieve the cgroup
> associated with cgroup id.
> It takes cgroupid as an argument and returns cgrp and on failure
> it returns NULL.
> Exported the same as this can be used by blk-cgorup.c

Can you please reflow the above paragraph?

> +struct cgroup *cgroup_get_from_kernfs_id(u64 id);

Let's just name it cgroup_get_from_id(). There's no other id. We can rename
cgroup_path_from_kernfs_id() later.

> +/*

/** starts a function comment.

> + * cgroup_get_from_kernfs_id : get the cgroup associated with cgroup id
> + * @id: cgroup id
> + * On success it returns the cgrp on failure it returns NULL
> + */

With the above nits updated, please feel free to add

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
