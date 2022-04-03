Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3799EC433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Apr 2022 09:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbiDCJrT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Apr 2022 05:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbiDCJrS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Apr 2022 05:47:18 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206882FE52
        for <linux-scsi@vger.kernel.org>; Sun,  3 Apr 2022 02:45:24 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id dr20so14245342ejc.6
        for <linux-scsi@vger.kernel.org>; Sun, 03 Apr 2022 02:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=Z7eGOIVhcX2AnfezLqLtjXmMZJ5RzK45kuvd+Xjc16I=;
        b=DScJDOvPtApjL9GFiLL1KUttl0YgV7Spz95trS7FObs155t0yopteZnaMcp0CCP7G2
         c7QYwQ9ocAVq0A7nu0SrNp7xdXvLzEQBWn3F1JfKrcTBSdbJZ313gshiiQZ34EULxUgA
         DMAn1yIN4lui3R6j26tBgiPR+jxOmQzGiSU4f4lEJBBRcJunlk2yDBW4tzp7CFx8wOVF
         LktUMydn15l9tS9A0aaCMkfAi35t6/aeIqKlWQG481bwu6mATMnW4pQVH2pVAusm9XsU
         z/3zv/JOoi1JAxr3ADofFJwj36PWGyQhkyoGDra3kKtH6PoIYCLCy2TUPE+4vhTOqJ6X
         0I0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=Z7eGOIVhcX2AnfezLqLtjXmMZJ5RzK45kuvd+Xjc16I=;
        b=QiJZpLhn1sXisiNXIs1kO9VL2v1OXswU5kNsMZiWpRM6GtRJLVQzpj/e4gz/PHSb0N
         hWPK3XOY2dw4oSB9ZUhlvTEDr17smkorUm29bR52KTpacwQlt7beN/nbj/ah0mxTdBTh
         +TnQtpExUlzCCjF7JVp9dvfKRIe2EE1TzQiKMzq5rnCV3NuOCMxjrIoTmPM8oc1bGmV8
         yQgjOnlYTQ1WCX6wC1g+S2s0FHZ//BirH1fz8JaAYNuoLh+Ymk+S6CXEReReiWxhMjSb
         9ja/2KHyaemv1+yPUmuQ5Uhlq6ASHiYmL9OxDuxl1nRtRglnH72NamsI8WqK42Z6Lwiw
         hCPg==
X-Gm-Message-State: AOAM530WtDZ+1kJBpXYq6UtZ/0fbLwR+SqnGnETSHlk2SjFd/Cd4qDtB
        1J/u6h8so3qXxIDuhgCwVL4=
X-Google-Smtp-Source: ABdhPJysMIc4ArjnIyVm23MIe+bkS+/DYHg4dM2wGWlAXC9W2OVXoEOqo5iwuCDttFcJIElWPAqoHA==
X-Received: by 2002:a17:907:7815:b0:6ce:5242:1280 with SMTP id la21-20020a170907781500b006ce52421280mr6594611ejc.217.1648979122595;
        Sun, 03 Apr 2022 02:45:22 -0700 (PDT)
Received: from p200300c5870184372b88b7302efecb4a.dip0.t-ipconnect.de (p200300c5870184372b88b7302efecb4a.dip0.t-ipconnect.de. [2003:c5:8701:8437:2b88:b730:2efe:cb4a])
        by smtp.googlemail.com with ESMTPSA id f23-20020a170906139700b006e758e94972sm1005424ejc.171.2022.04.03.02.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 02:45:22 -0700 (PDT)
Message-ID: <f31c2b15e46584412f5ccca7c54863e67eb93c78.camel@gmail.com>
Subject: Re: [PATCH 01/29] scsi: ufs: Declare ufshcd_wait_for_register()
 static
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Date:   Sun, 03 Apr 2022 11:45:21 +0200
In-Reply-To: <20220331223424.1054715-2-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
         <20220331223424.1054715-2-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.0-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2022-03-31 at 15:33 -0700, Bart Van Assche wrote:
> Declare this function static since it is only used inside the
> ufshcd.c
> source file.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
