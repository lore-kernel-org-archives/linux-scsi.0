Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FEBEC25B4F
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Aug 2023 20:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346196AbjHPUjr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Aug 2023 16:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346193AbjHPUjd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2023 16:39:33 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1401E74
        for <linux-scsi@vger.kernel.org>; Wed, 16 Aug 2023 13:39:32 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1bdeb022738so1858875ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Aug 2023 13:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1692218372; x=1692823172;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M/VlrpLaLonWwvLdMHTbKBLWS+0ZwHTAviVzHTRR32g=;
        b=b8C7A3fSaauDeX1Uma32OORq+lCiJhxdLrG3qjzQPV4bzX8r9TZ+BlQLwV8DkRl7g8
         rOwidredzXHeJ/K7i7plM3yCqTPibNGdAO+aWx7ICPfAOm0vx/l2oGhIgC+QWVD9/mzy
         XPyTkIHMldPIr/2pJWGhBYBVOcf2ZxZCPFUV0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692218372; x=1692823172;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M/VlrpLaLonWwvLdMHTbKBLWS+0ZwHTAviVzHTRR32g=;
        b=MxlUV+xlDIbL2HJImTlQUNmdUP9IJBtmKhEAEUvTGWeWDQ4UE4wRJ/kvVVFZ5cEGGF
         PEZHOiRYDPmFreZNgP0zzFSVI7QZRIy/Q/FwRRAn52D/vBmDhqya8LD1FWDyCn/0gkzI
         wbsKh3tZ8lZQUVyhYSkUgPxde6dqKA/XNKKFS0NjqA0azFGTz4bBW/SJphiPgZSkBYWQ
         h8IqXcFJsEo8eEah73BMaHYAQbau8tTqAsItiCvazPcbVCt7K92iL8GO5ZKpB2H6u9qP
         ZdjIHHvH/HMMC8Zpk99XXxSfLDB7VgqUjMHqN5bFaHG3XbMfH3YS3y/4xVUDBx2Nkufj
         8fUA==
X-Gm-Message-State: AOJu0YzyelVml+pv8iocuwMpQMmN/8p67GCzL6jbZqNsSxeVMNaSf6s3
        RZh1tK/bB3XkqxCK1QODEAUJJw==
X-Google-Smtp-Source: AGHT+IFH3p8cu/k6sO/6dJ0jNC4lS5Gy9QpuuFjew2rQXbw+Jnrz4Trg8GNoh8Zj8AEI5qs6r8bbSg==
X-Received: by 2002:a17:90a:e7c1:b0:268:808:8e82 with SMTP id kb1-20020a17090ae7c100b0026808088e82mr863439pjb.1.1692218372471;
        Wed, 16 Aug 2023 13:39:32 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id a4-20020a17090acb8400b0025bd4db25f0sm142476pju.53.2023.08.16.13.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 13:39:32 -0700 (PDT)
Date:   Wed, 16 Aug 2023 13:39:31 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: bfa: Replace one-element array with
 flexible-array member in struct fc_rscn_pl_s
Message-ID: <202308161339.C68DC815C@keescook>
References: <ZN0VTpDBOSVHGayb@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZN0VTpDBOSVHGayb@work>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 16, 2023 at 12:28:30PM -0600, Gustavo A. R. Silva wrote:
> One-element and zero-length arrays are deprecated. So, replace
> one-element array in struct fc_rscn_pl_s with flexible-array member.
> 
> This results in no differences in binary output.
> 
> Link: https://github.com/KSPP/linux/issues/339
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
