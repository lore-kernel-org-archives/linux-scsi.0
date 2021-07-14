Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A8CC11F66
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 03:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 125BE613AA
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 03:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237768AbhGND3O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 23:29:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:52427 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237776AbhGND3L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 23:29:11 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210714032619epoutp042b0d277182d6c2fcf91ce78a00ad0663~RinXM34SA1668716687epoutp04g
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 03:26:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210714032619epoutp042b0d277182d6c2fcf91ce78a00ad0663~RinXM34SA1668716687epoutp04g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626233179;
        bh=qw7RUygM496D3f+YX6kh79ff/o0ffA+JBXMIUCvv7sA=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=EdeeoZt1XiFtTRoBDD9uBP/5ZLYNjiYT2cE7z62f7Lc6MhyI7Kz4EZ1QaVphG76Es
         hE64/hYJ2YCPkMj2NNZzEaDaAdxjiQPX2GKQIzkTbhUZ2kCMUcLCNCeKrgK/DUDLkI
         hFNRPRwliFfpqboA0h1L9Ni+fc5+K4LZR45Fuzyg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210714032618epcas2p46221a455cf854bdb90f7c135e09f2979~RinWmlcAE2606126061epcas2p4d;
        Wed, 14 Jul 2021 03:26:18 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4GPjZx0Lmxz4x9Q5; Wed, 14 Jul
        2021 03:26:17 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        31.75.09921.8595EE06; Wed, 14 Jul 2021 12:26:16 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210714032616epcas2p1931033c767eefdd3267dfc70c7ac6cbc~RinUzxZvy2567625676epcas2p1K;
        Wed, 14 Jul 2021 03:26:16 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210714032616epsmtrp1dd71f5919b24ac98723e5853860951fd~RinUyyhEJ0176901769epsmtrp18;
        Wed, 14 Jul 2021 03:26:16 +0000 (GMT)
X-AuditID: b6c32a45-f9dff700000026c1-0d-60ee5958c7aa
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7C.B8.08394.8595EE06; Wed, 14 Jul 2021 12:26:16 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210714032616epsmtip2ff810f8038459fff14064af5d0c272b1~RinUgUIYu1100011000epsmtip2e;
        Wed, 14 Jul 2021 03:26:16 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'jongmin jeong'" <jjmin.jeong@samsung.com>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>
In-Reply-To: <034701d77812$64a57b30$2df07190$@samsung.com>
Subject: RE: [PATCH 02/15] scsi: ufs: add quirk to enable host controller
 without interface configuration
Date:   Wed, 14 Jul 2021 12:26:16 +0900
Message-ID: <012001d77860$01220800$03661800$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEgh/xhOfR89Em7SpyJUmGCKeOVGQH8s41uAjAZoGIB3qsjT6x/U8WQ
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfUwTZxzOe3e0VwLkaDt907jR3LIwiEDb9eAg0Jkg2ASjxP2haFy5lOMj
        9iu94nBbFvwYFmGKQGRW0mGngMWkofLp1HSFgcjIYpg6P5j7QFcERHFBq46t7WHGf8/9nufJ
        8/zee18cFV8XyPAKk421mhgDKYjG+oaSqJQdRY+LFU9rs+ix6fMC+jdnn4CeCd4Q0CeeBFF6
        0dMeRdcP5tLjDS6EnvY4UNr1Sx9Cn7tJ07d7fsDor3+6gtB1twYEdMfoMrIhTjv5c4F28uhX
        iPZCZ7L220sziNbrrhVoG1w+oH364A6mPdrjBtpn3ne0h311SGH0TkN2OcuUsFY5a9KbSypM
        ZTlkwUe6XB2VrlCmKDPpDFJuYoxsDrlxc2FKfoUhVJ+U72UMlaFRIcNxZJom22qutLHycjNn
        yyFZS4nBolRaUjnGyFWaylL1ZmOWUqFQUSFlsaF84e7fmCWAVHXcngDVwIEcASIcEmp4zP0c
        PQKicTExAKB7rA0LE2JiEcCp32meWALwsncu6o2j8UQn4InLAB50+gS8IwDg4VuSMBYQaXDG
        3hcVFkmJFgAH619g4Q+UuIrC0y+b0bBKRGRBn2c5UkRC7IHLY8FIBEa8B7uu9kZ6xBKZsPn1
        gJDH8XDs5HRkjhIJsH++FeUryWHwQXvEKyXy4dT1EcBrpPBUbU1kOUgEcNj0p3/FsBF+47m7
        giXw0WiPkMcyOHOsRsgb6gD88o9/V4guAGv3b+bxh/BlS08oDQ8lJEHPxbQwhMS7cPjOSrc4
        aB/6R8iPY6G9RswbE6GvvwXj8duwrvVZVAMgHas2c6zazLFqA8f/WW0Ac4M1rIUzlrGcyqJc
        /be9IHK3k/MGQNP8k1Q/QHDgBxBHSWnsWdV8sTi2hNn3KWs166yVBpbzAyp01sdR2Vt6c+hx
        mGw6JaVKT1dkUjSVrqLJtbG40F8sJsoYG7uHZS2s9Y0PwUWyaiT3Ppxn609/1//+pueXlj6T
        N0RnufMDeYNDOTf3ZhRptg8EJK/z7YeCMQa2XKL+RFQT79TPJX5+X/3jofPTO0pTMlRJZzTY
        aJU6Zq5nTfQVl3Mhd6Lpiw9ozdS6hLyunBsH4j33uiVMS6Lm3MO23vnhAw+XRs4idR9X/eoO
        OncttW9vWpgcMd77qyJu6+huXetsY5FmyG4yv9Lrmrs3bHtBbXu0dfR70IJ1nMpda3wli/Gv
        9+ThUqflWsW+FMWmYVGiVzG+e0rPlXbv6t9yJv/abG+32lqcICzIPkiJHo9fbOssDBxnFvEo
        37pZrMoycVKFIdVOxrXYWNq5f45aT2JcOaNMRq0c8x9p+09gZAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsWy7bCSvG5E5LsEg1+b+S1OPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBY9O50tTk9YxGTxZP0sZotFN7YxWay8ZmFxc8tRFosZ5/cxWXRf
        38Fmsfz4PyYHPo/LV7w9Lvf1MnlsXqHlsXjPSyaPTas62TwmLDrA6PHx6S0Wj74tqxg9Pm+S
        82g/0M0UwBXFZZOSmpNZllqkb5fAlfH+9heWghdMFctvnmVsYJzF1MXIySEhYCIxadoKxi5G
        Lg4hgd2MEqdOrWKGSMhKPHu3gx3CFpa433KEFaLoGaPE5N77jCAJNgF9iZcd21hBbBGBmYwS
        y1+WghQxC1xglrj+/ycbRMdHRonOF7PBqjgFrCQOrP8HtltYIFOiadk+MJtFQFVi9YmtLCA2
        r4ClxJQ/EKt5BQQlTs58AhZnFtCWeHrzKZQtL7H97RyoUxUkfj5dBnWFm8Tdi8cYIWpEJGZ3
        tjFPYBSehWTULCSjZiEZNQtJywJGllWMkqkFxbnpucWGBYZ5qeV6xYm5xaV56XrJ+bmbGMEx
        rKW5g3H7qg96hxiZOBgPMUpwMCuJ8C41epsgxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4
        IYH0xJLU7NTUgtQimCwTB6dUA9MOL/3nr4S5Duw8t+VDsoHbqYnH5PMED+6dJzexriPPX1rY
        JnTSgWbxK9tqF6rOM7DbZq7wfJYta//BB3wlm/mezjT28Ju7fkN449aX748p1Xw0sLiS5/5B
        t3XDe56/EmXCYfefLsna8dFPd+XysmcbssLzdle0inws/eYlf2bNG7Prdz/d0b68L66AKS29
        TirSsSXKpXVucsc3T6bPYhPSuvhmcAQ+XtTEme7jJJC/MYbv45ffH4LrLh19sF591ttPPK3J
        M5jniqQ6ek1uv+Q5KW2Z/YlpTZmlZ0saZ9ov+KJadmJpXKq3xN05V0/6PDGwi1gzYf1+1tv7
        Xl9PtWtLcX9noutpuOzA+++shSJKLMUZiYZazEXFiQA5WX3YUAMAAA==
X-CMS-MailID: 20210714032616epcas2p1931033c767eefdd3267dfc70c7ac6cbc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065746epcas2p2f353983bbc64c1a21571fda2be59df34
References: <20210709065711.25195-1-chanho61.park@samsung.com>
        <CGME20210709065746epcas2p2f353983bbc64c1a21571fda2be59df34@epcas2p2.samsung.com>
        <20210709065711.25195-3-chanho61.park@samsung.com>
        <034701d77812$64a57b30$2df07190$@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +	/*
> > +	 * This quirk needs to be enabled if the host controller cannot
> > +	 * support interface configuration.
> > +	 */
> > +	UFSHCD_QUIRK_SKIP_INTERFACE_CONFIGURATION	= 1 << 16,
> May be UFSHCD_QUIRK_SKIP_PH_CONFIGURATION

This can explain more specific meaning. I'll apply your review v2 patchset.
Thanks.

Best Regards,
Chanho Park

