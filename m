Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DCA4C433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Apr 2022 15:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357934AbiDCPyD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Apr 2022 11:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236415AbiDCPyD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Apr 2022 11:54:03 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492B133E06
        for <linux-scsi@vger.kernel.org>; Sun,  3 Apr 2022 08:52:09 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id u9so3210660edd.11
        for <linux-scsi@vger.kernel.org>; Sun, 03 Apr 2022 08:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=2TaKbzH1ZmcrCu4W9s+auYugviTEaafYEoYzfOQxn6M=;
        b=e80JVu19kvTao91TBYrqcXA1GhKoHDiYJRdfK8TrhExIqQnYdIMUzFcqu1hrshhYSr
         R3djRV78HFwwyw7pbV5dMmWcH230tMbP6ktVY2An8WvykGfmdijI54V8YoKa/cvPbYKJ
         IJ5wY+W7Da+hG0i4bf1UPzhyVokJdteVJyVb49e+TqtW0SUzoYx+qYuow0cKDa3SxwLM
         Ez1XopaUHD8KvPavwOg4IZ8O0p9aUnX89dpm5tPp3YEwpVo4FtmqUZBfCIbacKUjsiUW
         KLAB1bRXpdPeP4GWlFa0cejlvy/CrwEONI47VrkQOoHK2KACEKALtx3zB/lY8dwdOKxW
         3H+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=2TaKbzH1ZmcrCu4W9s+auYugviTEaafYEoYzfOQxn6M=;
        b=oRBD2z73lNY5W5SPAsla+Kuj+mlw47JLuMMD7DQo6FFz6ysgrDAIfnkKONiDC/D7xH
         x7n8hY+qcx6/kSJsVnQNlxNInxZYhmA2mnf+KAHlDqk3Mv5LpfIZygpfND4+vrbBgxzL
         1CJQzfARyb3SvX1DXjxIUDjQUffvlazMIsKyLy3SoOQZciqLT+7yBg7AKGMd3Fi2yorf
         9LxbYFFWgpDEKvaRpjBuZy6UUwk1NJomRbXazzO4bf9knTDzVNsagEIcH1IIgNM34bvx
         lMF34pFgzubcjOAqQ6Tyked1nJjx9/zElU3FEVC+R+Ss/X3kglbXfOOSOP0v52GQlRzU
         4qUA==
X-Gm-Message-State: AOAM533QAv4dGz0tUt266x1+q6KHfW6rOabF5p41Sg9O7fYFUCeYwoIi
        uvY+ozbRFhYv9FQSEY+/2os=
X-Google-Smtp-Source: ABdhPJwQ1cN4rom/lFbKb6WQHKzg9Kq70OKCSBrnOpKUAkSozDYLdzAw5/yEtTSuxU5CqHFt+FBr4Q==
X-Received: by 2002:a05:6402:35c2:b0:419:9383:4123 with SMTP id z2-20020a05640235c200b0041993834123mr29809647edc.28.1649001127808;
        Sun, 03 Apr 2022 08:52:07 -0700 (PDT)
Received: from p200300c5870184372b88b7302efecb4a.dip0.t-ipconnect.de (p200300c5870184372b88b7302efecb4a.dip0.t-ipconnect.de. [2003:c5:8701:8437:2b88:b730:2efe:cb4a])
        by smtp.googlemail.com with ESMTPSA id fx3-20020a170906b74300b006daecedee44sm3336768ejb.220.2022.04.03.08.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 08:52:07 -0700 (PDT)
Message-ID: <4cfc621593f89fac9b80ac7e329d1343bd513cb1.camel@gmail.com>
Subject: Re: [PATCH 15/29] scsi: ufs: Remove the driver version
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Xiaoke Wang <xkernel.wang@foxmail.com>
Date:   Sun, 03 Apr 2022 17:52:06 +0200
In-Reply-To: <20220331223424.1054715-16-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
         <20220331223424.1054715-16-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.0-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2022-03-31 at 15:34 -0700, Bart Van Assche wrote:
> Driver version numbers are not useful in upstream kernel code. Hence
> remove the driver version number from the UFS driver.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>
