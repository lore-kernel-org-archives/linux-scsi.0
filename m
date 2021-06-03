Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 935A5C47096
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 17:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B920613BA
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 17:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhFCRUv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 13:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234335AbhFCRTk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 13:19:40 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2752FC061345;
        Thu,  3 Jun 2021 10:13:32 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id c124so6670993qkd.8;
        Thu, 03 Jun 2021 10:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dV2nvNFqWCItqaPHOOaQlyC8Sahyat7unUPVc/qQTb0=;
        b=q/uyctJuVSawxJTjQwcklgDmZWijiqGU5hk4GnWdbpHEAYWCz6RTkJIQg90XNjURQY
         oVpatxMEP/WTlxM9UeL1Tw1YQG1KYPwR8rVMCXxLcL15oiJAbWpidYzyApW+Q3FMtwjz
         gGLKoDU9wZFdzKnn/ddV4JYOaM9exAl9nX9+Erp60Y+kqpQSB22TbleIWAOqUJ2nYYHM
         QGpOBTVEG45Ej4ACHWIm3Ugc6esxig+3CyJfUgRSiGxy6AO7cCgi0mvCHKsDCfVUN7kz
         /wOFZE1wCfyUvE+YRh6NZdDf4S/tOkwgfz9qONhNEssVB+UbYhKoxCjzyTP7HPipjvED
         /uww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=dV2nvNFqWCItqaPHOOaQlyC8Sahyat7unUPVc/qQTb0=;
        b=BEfYh0yh/z7OTGgEogzSaP1lSI7wXgk5vbBQALWTWDm6wHY9Vu+yK6oNSirP2bEFVq
         arjogHP0HnIb+PIHEQXzgcTsKglGb1zIvqjFbGXQpGIcRc1VPqUjtY9v4eajUHXc6rLC
         oNSp1j6nOux5VxFuerN1MHZKUvbWZ+JK3EtVcUWrwB4h2ByyAjQzr7jZFK3Gvgs0CfdI
         1gBIrQ6cpv1adj62E9nRNnx+k1Qf7+6f07E11DUgYpWCqh6j9YBODhoafQoQ4Fkp+4IZ
         n2+BZJ/KGuNToQI2SKNMQF+llVGqM5JJahaJqSwCie7PMwIao0TqI25peeoWx7CTCYvU
         B+XA==
X-Gm-Message-State: AOAM533kH48GqWq73ydqAGaSj/CXmo/X5WdelGEJnD8QpOTRUQA0nsmL
        zISmWAbkezgCqvu1ZyYCils=
X-Google-Smtp-Source: ABdhPJzg1+W24yf1MiTVbm2XpyVW6BbFpyPinuEE2R4B5bav57ttUworCcoTkXayBkYZIpOqoOwucw==
X-Received: by 2002:a05:620a:1198:: with SMTP id b24mr263594qkk.212.1622740411182;
        Thu, 03 Jun 2021 10:13:31 -0700 (PDT)
Received: from localhost ([199.192.137.73])
        by smtp.gmail.com with ESMTPSA id m4sm2050209qtg.21.2021.06.03.10.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 10:13:30 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 3 Jun 2021 13:13:29 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Muneendra <muneendra.kumar@broadcom.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, hare@suse.de, jsmart2021@gmail.com,
        emilne@redhat.com, mkumar@redhat.com
Subject: Re: [PATCH v10 01/13] cgroup: Added cgroup_get_from_id
Message-ID: <YLkNufxDIv3Mlle6@slm.duckdns.org>
References: <1619562897-14062-1-git-send-email-muneendra.kumar@broadcom.com>
 <1619562897-14062-2-git-send-email-muneendra.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1619562897-14062-2-git-send-email-muneendra.kumar@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 28, 2021 at 04:04:45AM +0530, Muneendra wrote:
> Added a new function cgroup_get_from_id  to retrieve the cgroup
> associated with cgroup id.
> Exported the same as this can be used by blk-cgorup.c
> 
> Added function declaration of cgroup_get_from_id in cgorup.h
> 
> This patch also exported the function cgroup_get_e_css
> as this is getting used in blk-cgroup.h
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
