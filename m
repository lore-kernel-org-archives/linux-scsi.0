Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F1AFC77B7E
	for <linux-scsi@archiver.kernel.org>; Tue,  2 May 2023 12:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbjEBMwo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 May 2023 08:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234271AbjEBMwj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 May 2023 08:52:39 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1CF1B9
        for <linux-scsi@vger.kernel.org>; Tue,  2 May 2023 05:52:36 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f1738d0d4cso22460325e9.1
        for <linux-scsi@vger.kernel.org>; Tue, 02 May 2023 05:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683031955; x=1685623955;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z5nhvdWhebkMYO4GW1JxCEEWKCb3+y/3CByFzV8Cg/c=;
        b=CxaCtcuzOTNy7f/1wJAHyAIhOYhUOJ0mbsaDVqtncXXmwAROV60TU3lViUssIFHZu2
         Y31y022xEnfx8eiUwsx+QVJP1HHcEr9E7MF9OAEtz+3wjnUoLQ8r4mfsTctwf+iYAq9g
         1EfUl5kzbDGIwguNiog2N1myfzcyrSokUyTkrb+YK3DlXmdsbVNoSgMhYenDhugsIG/7
         ECjfMJHoaogu02mSajg8uaGajCLr/UXPgoopLCfD/CYWJNN871od1JuyqDKPy3R0zXwS
         YybhLrnyrZ4wNSzKFfQfvNX3SwtEMq2Zy4VnJXLnukb8qhR3NnI5b9oRKSgPRb8Xuq8p
         qegA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683031955; x=1685623955;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z5nhvdWhebkMYO4GW1JxCEEWKCb3+y/3CByFzV8Cg/c=;
        b=A/upWtYtHIlunqufHweIDOQCtarHcFCBfygjq+vVD9jZi3NIBmcXno8GhAJjw3c8AT
         KmqHrWtEIkOudHa8xrvC2SPHNoy3KwrBEMHbKkC/o7e4aIORNybMsM4D4YsZk8m+7bNs
         z7omNGjd1cgvvO5QGkfz5jMLTOO5MXHALTXZy12sUpCBAvPxSW3mZ6sKNAisZG79xFMX
         eN4yyLlWWPyvLRUuVISOIgu7KwmDsCx5WpQQO+SxgeHxoLkSXuZz6QMLBr6teKOx+qWL
         smUHftf2wJBdK4w0kW9hQ+fUlTqvWJtX4v6rHOeYTBXUg8fK8KHeXlL4mKIBjq43Q2LX
         ASrg==
X-Gm-Message-State: AC+VfDyZ6EcS/utCCChvDDsbrSC2cQXjqilHe5BlBK0HozrZStaxDfFu
        jWBOfSDLt5tUlNQfRaLr3/uGDA==
X-Google-Smtp-Source: ACHHUZ6l8mKcdy9L6W76xeUt3EbwO1UlAd+EWeiolYIzQNmUagEuLN6MiyY6NL3j25PcHAYCehExSw==
X-Received: by 2002:a05:600c:ac8:b0:3f1:72f8:6a92 with SMTP id c8-20020a05600c0ac800b003f172f86a92mr11860067wmr.20.1683031954701;
        Tue, 02 May 2023 05:52:34 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id t14-20020a05600c450e00b003f0a6a1f969sm39293362wmo.46.2023.05.02.05.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 05:52:33 -0700 (PDT)
Date:   Tue, 2 May 2023 15:52:29 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Jinhong Zhu <jinhongzhu@hust.edu.cn>
Cc:     martin.petersen@oracle.com, GR-QLogic-Storage-Upstream@marvell.com,
        error27@gmail.com, jejb@linux.ibm.com, jhasan@marvell.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        skashyap@marvell.com
Subject: Re: Re: [PATCH] qedf: Fix NULL dereference in error handling
Message-ID: <e5d627aa-5bb4-4b24-bdb2-6cf26195d431@kili.mountain>
References: <yq1fs8ok4v9.fsf@ca-mkp.ca.oracle.com>
 <20230425125823.2325-1-jinhongzhu@hust.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425125823.2325-1-jinhongzhu@hust.edu.cn>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 25, 2023 at 08:58:23PM +0800, Jinhong Zhu wrote:
> >> Fixes: 09e062ce83cb ("qedf: Fix NULL dereference in error handling")
> 
> >This commit does not appear to exist in Linus' tree.
> 
> Sorry for the wrong fixes tag.
> 
> This is the correct one.
> 
> Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")

You need to send a v2 patch.  I have written a blog about this process.

https://staticthinking.wordpress.com/2022/07/27/how-to-send-a-v2-patch/

regards,
dan carpenter

