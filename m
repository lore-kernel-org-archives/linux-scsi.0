Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D841C77B7C
	for <linux-scsi@archiver.kernel.org>; Mon, 22 May 2023 02:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbjEVCBi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 May 2023 22:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjEVCBh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 May 2023 22:01:37 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1941FD2
        for <linux-scsi@vger.kernel.org>; Sun, 21 May 2023 19:01:36 -0700 (PDT)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230522020134epoutp04c4b1f2f2f22b93d0a75f4f4715f7babb~hVLpENMcH3200532005epoutp041
        for <linux-scsi@vger.kernel.org>; Mon, 22 May 2023 02:01:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230522020134epoutp04c4b1f2f2f22b93d0a75f4f4715f7babb~hVLpENMcH3200532005epoutp041
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1684720894;
        bh=BPs5Jj+oGi04hZKz6rk+ltG+OISFuZl7tme3IBalDTs=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=Mzt+6766kEM/XQXvnP8ZPMEsgV5LAETJHakHe0hfMs79/+dzRxsIXkDGIWYK+XQp6
         UMcmXFIRykcpxWhskCoEhSfJ67uUcXcR0DTrnUWfyyrXeos1AEqOM/2uC8baH0KUMU
         AP5GV9KCHnntSfBauKV603VHv5M4f63N0vWG4/jg=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20230522020134epcas2p2412ff95f7940a084f8a0d9e6ab020cb4~hVLomYFIf2026820268epcas2p2i;
        Mon, 22 May 2023 02:01:34 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.68]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4QPgfj1bpPz4x9QK; Mon, 22 May
        2023 02:01:33 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        FA.9F.44220.CFCCA646; Mon, 22 May 2023 11:01:32 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20230522020132epcas2p3a96b693033c9027302dedfc593576e15~hVLnK0w-V2845028450epcas2p3R;
        Mon, 22 May 2023 02:01:32 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230522020132epsmtrp135a78fa422833d3af563d9be3a905da0~hVLnKMOsh2592025920epsmtrp1q;
        Mon, 22 May 2023 02:01:32 +0000 (GMT)
X-AuditID: b6c32a48-c3ff87000000acbc-00-646accfce158
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E9.14.27706.CFCCA646; Mon, 22 May 2023 11:01:32 +0900 (KST)
Received: from KORCO011456 (unknown [10.229.38.105]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20230522020132epsmtip207d941f4654e616ef9952a767eb7f99c~hVLm98HMt1940019400epsmtip2g;
        Mon, 22 May 2023 02:01:32 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>,
        <kwangwon.min@samsung.com>
In-Reply-To: <a7296997-89a1-2fb6-3bb4-1fc60d50a132@acm.org>
Subject: RE: [PATCH v2] ufs: poll HCS.UCRDY before issuing a UIC command
Date:   Mon, 22 May 2023 11:01:32 +0900
Message-ID: <000e01d98c51$549b16f0$fdd144d0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQH0ib+DsCxNotQ9hUL0678dsLFaoQE8qpioAYau79GvGXP9YA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnk+LIzCtJLcpLzFFi42LZdljTTPfPmawUg897LCymffjJbLF68QMW
        i603drJYdF/fwWbRdfcGo8XSf29ZHNg8Ll/x9ujbsorR4/MmuQDmqGybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07m6L8
        0pJUhYz84hJbpdSClJwC8wK94sTc4tK8dL281BIrQwMDI1OgwoTsjAebZ7MXPBeo+PHnJ2sD
        4yreLkZODgkBE4kPx1rYuxi5OIQEdjBK9K28wgzhfGKUOHPwDQuE841RYv7KHnaYlp71n9gg
        EnsZJbZMa4NyXjJKfO7uYwapYhPQlpj2cDcrSEJEYCOjxMoH3WDtnALWEuvPtbGA2MICHhKf
        51xgA7FZBFQlJjzZzQRi8wpYSrx+coAZwhaUODnzCVg9s4C8xPa3c5ghzlCQ+Pl0GSuILSLg
        JPFj5Vp2iBoRidmdbWBPSAh8ZJc4t/wLI0SDi8Sm5Z+YIGxhiVfHt0D9IyXxsr8NyOYAsrMl
        9iwUgwhXSCye9pYFwjaWmPWsnRGkhFlAU2L9Ln2IamWJI7egLuOT6Dj8F2oIr0RHmxBEo7LE
        r0mTofZLSsy8eQdqp4fEvbePWCYwKs5C8uMsJD/OQvLLLIS9CxhZVjGKpRYU56anFhsVmMAj
        Ozk/dxMjOEVqeexgnP32g94hRiYOxkOMEhzMSiK8gX3JKUK8KYmVValF+fFFpTmpxYcYTYGh
        PpFZSjQ5H5ik80riDU0sDUzMzAzNjUwNzJXEeT92KKcICaQnlqRmp6YWpBbB9DFxcEo1MLWe
        0nTexzGn6E2wwRbnE/fXbFke/s13S57I+UKV9qDqh1PeB9y/WN261XiO4XKTHRZP793L1pzO
        +iqiaiFvVIa3zPM3nY8sy7mT1DU/lyoLupX9nmUalSbgr6G/gT9pxZMDF6ujD98xiol4Gsy3
        JXbG6l/KMg2X3h+ovia1cW7dt0oGz/mO6R7T/321ilxusz/59VTFwvi9Fi/vJ3DLfVe2PnXG
        Y5LDlSmy31y4dt6YcuDFveMbBf7prdsamvT1j/421hPnX4tWTn1y51vr8a1lt6fcz3p653SA
        ysMF1VeXzeS7W7H7dpv29sxmd1HZCMtp199+eG1nsLTFS6FFLJRZ4tK1fTUuS+Zfu7hoxs49
        SizFGYmGWsxFxYkA0olechoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsWy7bCSvO6fM1kpBs1HpS2mffjJbLF68QMW
        i603drJYdF/fwWbRdfcGo8XSf29ZHNg8Ll/x9ujbsorR4/MmuQDmKC6blNSczLLUIn27BK6M
        B5tnsxc8F6j48ecnawPjKt4uRk4OCQETiZ71n9i6GLk4hAR2M0o8+viGCSIhKXFi53NGCFtY
        4n7LEVaIoueMEk+eLwVLsAloS0x7uBssISKwnVHiws4fUKOOM0oseb+cFaSKU8BaYv25NhYQ
        W1jAQ+LznAtsIDaLgKrEhCe7wdbxClhKvH5ygBnCFpQ4OfMJWD0z0Ibeh62MELa8xPa3c5gh
        TlKQ+Pl0Gdh8EQEniR8r17JD1IhIzO5sY57AKDQLyahZSEbNQjJqFpKWBYwsqxglUwuKc9Nz
        iw0LDPNSy/WKE3OLS/PS9ZLzczcxgmNDS3MH4/ZVH/QOMTJxMB5ilOBgVhLhDexLThHiTUms
        rEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampBahFMlomDU6qBSSfj77ZPWxqF5x5o
        MF0evf30ubdb50rNqKh1yE9njfk+I9gz1t/e+Gv9fNF/0tMVF9hsect094lB3MZvhqdyZVsU
        DLoYeLdqnT/1/ZKj1+5H6QufRR5qOuFjyb9duunVd+3Y9fXFsxb29/7Vz2J+zNTw7ktf1dnU
        v6nN+Ssi+uu/5V3rWD67QpPh5343e42abYcjXjLU7f67e9EWwQ3fyk2Fp6oHq6+7wPZx8tm4
        rIOGDWFMb3wWVzLVbt+b2XdlofO+OW0sT5Zo6PwP/bnOc2beNZXWqjuT3fc6ClTWbQ58HF08
        JcBTJUZXzrvrfNqRHOPpybIPm7+x/LI0ei0VcS+j9qKwdcapqDlnityKlViKMxINtZiLihMB
        YY5jwvwCAAA=
X-CMS-MailID: 20230522020132epcas2p3a96b693033c9027302dedfc593576e15
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230516034218epcas2p297e9c5a33d370c8c45a40ab58f500ae0
References: <CGME20230516034218epcas2p297e9c5a33d370c8c45a40ab58f500ae0@epcas2p2.samsung.com>
        <1684208012-114324-1-git-send-email-kwmad.kim@samsung.com>
        <a7296997-89a1-2fb6-3bb4-1fc60d50a132@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >   static inline bool ufshcd_ready_for_uic_cmd(struct ufs_hba *hba)
> >   {
> > -	return ufshcd_readl(hba, REG_CONTROLLER_STATUS) & UIC_COMMAND_READY;
> > +	ktime_t timeout = ktime_add_ms(ktime_get(), UIC_CMD_TIMEOUT);
> > +	u32 val = 0;
> > +
> > +	do {
> > +		val = ufshcd_readl(hba, REG_CONTROLLER_STATUS) &
> > +			UIC_COMMAND_READY;
> > +		if (val)
> > +			break;
> > +		udelay(500);
> > +	} while (ktime_before(ktime_get(), timeout));
> > +
> > +	return val ? true : false;
> >   }
> 
> Sleeping during up to 500 ms while holding a spin lock is not acceptable.
> Has it been considered to modify the UFS core such that the host_lock is
> not held around calls of the above function, e.g. via the (untested) patch
> below?
> 
> Thanks,
> 
> Bart.

Let me consider it.

> 
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> 9736b2b4120e..394283b04d7c 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2416,7 +2416,6 @@ __ufshcd_send_uic_cmd(struct ufs_hba *hba, struct
> uic_command *uic_cmd,
>   		      bool completion)
>   {
>   	lockdep_assert_held(&hba->uic_cmd_mutex);
> -	lockdep_assert_held(hba->host->host_lock);
> 
>   	if (!ufshcd_ready_for_uic_cmd(hba)) {
>   		dev_err(hba->dev,
> @@ -2452,9 +2451,7 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct
> uic_command *uic_cmd)
>   	mutex_lock(&hba->uic_cmd_mutex);
>   	ufshcd_add_delay_before_dme_cmd(hba);
> 
> -	spin_lock_irqsave(hba->host->host_lock, flags);
>   	ret = __ufshcd_send_uic_cmd(hba, uic_cmd, true);
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
>   	if (!ret)
>   		ret = ufshcd_wait_for_uic_cmd(hba, uic_cmd);
> 
> @@ -4122,8 +4119,8 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba,
> struct uic_command *cmd)
>   		wmb();
>   		reenable_intr = true;
>   	}
> -	ret = __ufshcd_send_uic_cmd(hba, cmd, false);
>   	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +	ret = __ufshcd_send_uic_cmd(hba, cmd, false);
>   	if (ret) {
>   		dev_err(hba->dev,
>   			"pwr ctrl cmd 0x%x with mode 0x%x uic error %d\n",


