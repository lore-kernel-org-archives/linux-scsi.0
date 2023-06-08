Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E53DC77B7A
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jun 2023 02:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbjFHCiX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 22:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbjFHCiW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 22:38:22 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD38D13D
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jun 2023 19:38:20 -0700 (PDT)
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230608023818epoutp04c8ac6a26530b5e1d4cb1c5a62a6bcf65~mjpj-vDkg0873208732epoutp04L
        for <linux-scsi@vger.kernel.org>; Thu,  8 Jun 2023 02:38:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230608023818epoutp04c8ac6a26530b5e1d4cb1c5a62a6bcf65~mjpj-vDkg0873208732epoutp04L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1686191898;
        bh=3DyFFtxrpUkzU/eI1KW/GlEgiQlUFIZ39OVglRyTE+k=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=kixLxJQVYIqt0YqVgIXtmaA61JEW5MDRBXpD4j+isvJxOyMgLXgHUo2BsLE4nC21+
         QI52CcbMc5+jrO2lSZY361I6rKIgFn6Ftq1ZYgeggLKnY3RndK4iVC2xUpVoJMjyBd
         asf0WvO4mgnfUGcup7QwpOByXy8CIhBrj/pAFkpw=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20230608023817epcas2p2f711c7abb011231fc01c907bd8cfb8d7~mjpjlDCjl1333113331epcas2p2s;
        Thu,  8 Jun 2023 02:38:17 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.90]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Qc7gF0nj4z4x9Pt; Thu,  8 Jun
        2023 02:38:17 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        C9.1D.44220.81F31846; Thu,  8 Jun 2023 11:38:16 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20230608023816epcas2p3a5c9b6abd4923ac79361acc893b3826c~mjpiV_8Ba0405104051epcas2p3M;
        Thu,  8 Jun 2023 02:38:16 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230608023816epsmtrp15bdb5347b556bfb939d46e1239b0e3e7~mjpiU-gsZ0470404704epsmtrp1B;
        Thu,  8 Jun 2023 02:38:16 +0000 (GMT)
X-AuditID: b6c32a48-9f1ff7000000acbc-c9-64813f18679f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        14.BD.28392.81F31846; Thu,  8 Jun 2023 11:38:16 +0900 (KST)
Received: from KORCO011456 (unknown [10.229.38.105]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230608023816epsmtip1ede5ad893161b3512844ba5b6cc0228d~mjph-jyZx0560505605epsmtip1f;
        Thu,  8 Jun 2023 02:38:16 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>,
        <kwangwon.min@samsung.com>, <junwoo80.lee@samsung.com>
In-Reply-To: <DM6PR04MB6575F26AC01FD6C9D4D5ED3DFC4DA@DM6PR04MB6575.namprd04.prod.outlook.com>
Subject: RE: [PATCH v2 2/3] ufs: poll HCS.UCRDY before issuing a UIC command
Date:   Thu, 8 Jun 2023 11:38:16 +0900
Message-ID: <005701d999b2$47390d50$d5ab27f0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQCI4sX3LzJ4oopUDLnE0XsEPfF6SAG6syEEAjbuRfYBOYAdXbH4Rb2Q
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupik+LIzCtJLcpLzFFi42LZdljTTFfCvjHFYNJjG4uXP6+yWaxe/IDF
        YtffZiaLrTd2slh0X9/BZtF19wajxdJ/b1kc2D36tqxi9Pi8Sc6j/UA3UwBzVLZNRmpiSmqR
        Qmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtByJYWyxJxSoFBAYnGx
        kr6dTVF+aUmqQkZ+cYmtUmpBSk6BeYFecWJucWleul5eaomVoYGBkSlQYUJ2xq5vfawFB1kr
        Dr7rY2pgPMLcxcjBISFgIrHjj2YXIxeHkMAORolndw6yQjifGCX+fd3HBOF8ZpTYuXsLSxcj
        J1jHtQmT2SESuxgl9q2bywzhvGSUOP/xMCtIFZuAtsS0h7vBbBGBU4wS19ZKgOzjFIiV6N1n
        AhIWFvCRWPl4OthQFgEViZ6W42DlvAKWElv2vWaBsAUlTs58AmYzC8hLbH87hxniCAWJn0+X
        QY13k3j6/BUbRI2IxOzONrB7JAR+skvMedUIdbWLRNuMx1DNwhKvjm9hh7ClJF72t7FDwiJb
        Ys9CMYhwhcTiaW+hWo0lZj1rZwQpYRbQlFi/Sx+iWlniyC2oy/gkOg7/hRrCK9HRJgTRqCzx
        a9JkRghbUmLmzTtQOz0kHm+6wzyBUXEWkh9nIflxFpJfZiHsXcDIsopRLLWgODc9tdiowAQe
        08n5uZsYwYlSy2MH4+y3H/QOMTJxMB5ilOBgVhLhzbKvTxHiTUmsrEotyo8vKs1JLT7EaAoM
        9YnMUqLJ+cBUnVcSb2hiaWBiZmZobmRqYK4kzvuxQzlFSCA9sSQ1OzW1ILUIpo+Jg1OqgalL
        TcxTxHVXf9a19Y+fH1ojr3HzqHcK38r9dY+jJlVF83LKWBTt+P7BT5vn6KrX2/TaN/T4ii4M
        WqAke+IC76G+ZXLnbaJWa117r3pEYvfPyNg7f6fNTV4/dU+m6+dX517VeT81itDM2vNcScM7
        9LDojX9vPrHsdNpTVhIYMKVB/VhIsfi+jDIz/pUbTE5XF6hHsgQ8uxKR3Rcu0NnPmy7OZfLb
        4InEkbshk7wzJx83PaBTLhy3Onx2YXnzzlXrn3zhrYxJuFwRuHrpntT47lPvmH7OfGDJtOx1
        3iP3YP+FLUvn750qcaX+f9elpJWMp7I5PpeqFzZq5E5x117wInsek1ir48k992OXK+19z6DE
        UpyRaKjFXFScCABDQX3tHQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsWy7bCSnK6EfWOKwY9ufouXP6+yWaxe/IDF
        YtffZiaLrTd2slh0X9/BZtF19wajxdJ/b1kc2D36tqxi9Pi8Sc6j/UA3UwBzFJdNSmpOZllq
        kb5dAlfGrm99rAUHWSsOvutjamA8wtzFyMkhIWAicW3CZPYuRi4OIYEdjBJHXjYyQSQkJU7s
        fM4IYQtL3G85wgpR9JxR4nLnRFaQBJuAtsS0h7vBEiIClxglHqxqhhq1mkni2IxdQDs4ODgF
        YiV695mANAgL+EisfDydBcRmEVCR6Gk5DjaIV8BSYsu+1ywQtqDEyZlPwGxmoAW9D1sZIWx5
        ie1v50CdrSDx8+kysF4RATeJp89fsUHUiEjM7mxjnsAoNAvJqFlIRs1CMmoWkpYFjCyrGCVT
        C4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCo0RLawfjnlUf9A4xMnEwHmKU4GBWEuHNsq9P
        EeJNSaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFqEUyWiYNTqoEptempwjTT
        8/PUhN/tdXzIZRexnLshWPbIJ8X58WuXZC/dVdcRXrWtYal5yPPk6igP5Ys3EwX2W3jvjdd7
        PDUuacrueUq7wn+KvT1r/YxNRTNSNWX1sh0PsoRManM8s7RzVqtn87mwnH548ofUF8fglld7
        r+v51kn3rv7Fpnb3mv2RnMBYnnkdlQ8zfG/yxr7vucqSsGnZo1APj5+JvLGbP4k940uYZDJL
        b3HQjXWRE4zWX5md3fnQZeXPjde4TR2jNv0q9ebcmZZRzdV/9a/mt+bN0WJn9c2ne06SK1uj
        lPqblbNAJfnclOO5UalRGgql7h1uDdedZp7JfrPt9tspWpNML9tacv4WeSBndUeJpTgj0VCL
        uag4EQAADJo/AQMAAA==
X-CMS-MailID: 20230608023816epcas2p3a5c9b6abd4923ac79361acc893b3826c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230605012507epcas2p3ecc0a358b558fe09d74a56b67b6477d2
References: <cover.1685927620.git.kwmad.kim@samsung.com>
        <CGME20230605012507epcas2p3ecc0a358b558fe09d74a56b67b6477d2@epcas2p3.samsung.com>
        <40006660eaece22f76b9532c70479d719655b33f.1685927620.git.kwmad.kim@samsung.com>
        <DM6PR04MB6575F26AC01FD6C9D4D5ED3DFC4DA@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >  static inline bool ufshcd_ready_for_uic_cmd(struct ufs_hba *hba)  {
> > -       return ufshcd_readl(hba, REG_CONTROLLER_STATUS) &
> > UIC_COMMAND_READY;
> > +       ktime_t timeout = ktime_add_ms(ktime_get(), UIC_CMD_TIMEOUT);
> > +       u32 val = 0;
> > +
> > +       do {
> > +               val = ufshcd_readl(hba, REG_CONTROLLER_STATUS) &
> > +                       UIC_COMMAND_READY;
> > +               if (val)
> > +                       break;
> > +               udelay(500);
> > +       } while (ktime_before(ktime_get(), timeout));
> > +
> > +       return val ? true : false;
> >  }
> Can you use read_poll_timeout() instead?
> 
> Thanks,
> Avri

Okay, thanks.

