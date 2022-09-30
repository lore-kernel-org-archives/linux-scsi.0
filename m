Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2181C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Sep 2022 12:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbiI3MOl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Sep 2022 08:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbiI3MOh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Sep 2022 08:14:37 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B079BE6
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2022 05:14:32 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 29so5727217edv.7
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2022 05:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date;
        bh=AhQZCclErhQSpww0W0nKUHtggP3rdl6LVzisBlHT4KQ=;
        b=F7AXB/eGEtQCgxhyBXhib7k2IcFbO8TeNMBB/64MPmiw6LyRpTBw0nljnXRx4Wuion
         5puhyZiJPJJnBoLLKQUOJNHW1BDeYj7sn/beGpwRQBCS4Cr8lQl11Hdfgcm4BlIFuLkw
         vUwRZswlaJ0/ZFk3lqgetrocoPvTFbpvMT0/1os9PHBTDMlUlTwiCTP0geZjVhkB/hns
         Ee71xXBCDqNoLwG6kM/oz3RlL+ZPtYaccMbObt2PAyBP/7Qd5q3DrTl4kY+mfdFgYm4N
         FGusJsdNdKiFD+tezzCr5e5MVZUba9vNO7A0QQ7IcNorzSUzUHrG11GYMPfkAeOU3KNJ
         mUIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=AhQZCclErhQSpww0W0nKUHtggP3rdl6LVzisBlHT4KQ=;
        b=SRdthHHC3tbVKvqRcfi8jlLxBqVd967liR8CzAXW2YjVb7hHr/OAvEKQboj6goBtlT
         MZ5o12+qSdwjU8klHlXA8JP5/8DyJQ1hiTtHIKJ/5zdnL1AAOznQ+A/0gpqNFLn4I3pl
         Ee8ErgD5wHtpJbtGe/zHk+28seFrNE6Cg8ouKMvGPPCI1c/oNnAROXoHWaeDP+TjxDuL
         a6sfCD9WP4OIUUWuXyFUxGcfRfdRylw3ZdiaHFtO+pyFDlmWOPPwOo47kqJFpT6eHZMR
         d8Jqgs/op9CCxA5d81up2910GDg8XJI3GxaOx/eCRWBDyDYOudnscSkPdmBaq9K7XLRc
         uj7g==
X-Gm-Message-State: ACrzQf1nf+dEWKre02ZA3AdCqMgKVD151naRLdkEW/uCcJ043sB67LM4
        Wa3htMtWjbCQsmYmQ24C5Dc=
X-Google-Smtp-Source: AMsMyM6xrPH0W1hSwOpAbaO+b/FSl+b5nPn+VCewbOPbGkzt0f6ezcRnmCwej+PQK6lVwzuKVl4zYw==
X-Received: by 2002:a05:6402:35c5:b0:450:4b7d:9c49 with SMTP id z5-20020a05640235c500b004504b7d9c49mr7718322edc.149.1664540071074;
        Fri, 30 Sep 2022 05:14:31 -0700 (PDT)
Received: from [10.176.234.249] ([137.201.254.41])
        by smtp.googlemail.com with ESMTPSA id x13-20020a50d60d000000b004482dd03fe8sm1540935edi.91.2022.09.30.05.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 05:14:30 -0700 (PDT)
Message-ID: <3f511c07618adc5958c1eba474676ca5a5d3826f.camel@gmail.com>
Subject: Re: [PATCH v3 6/8] scsi: ufs: Try harder to change the power mode
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Date:   Fri, 30 Sep 2022 14:14:29 +0200
In-Reply-To: <20220929220021.247097-7-bvanassche@acm.org>
References: <20220929220021.247097-1-bvanassche@acm.org>
         <20220929220021.247097-7-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2022-09-29 at 15:00 -0700, Bart Van Assche wrote:
> Instead of only retrying the START STOP UNIT command if a unit
> attention
> is reported, repeat it if any SCSI error is reported by the device or
> if
> the command timed out.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>
