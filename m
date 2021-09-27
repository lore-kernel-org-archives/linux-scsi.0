Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 026F1C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 10:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB7A7610E8
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 10:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbhI0K3o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 06:29:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45805 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbhI0K3n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 06:29:43 -0400
Received: from epcas3p3.samsung.com (unknown [182.195.41.21])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210927102803epoutp0444dc5c2a7dc2af19fc75fca30384ba33~opv-uPqmZ1328613286epoutp04j
        for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2021 10:28:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210927102803epoutp0444dc5c2a7dc2af19fc75fca30384ba33~opv-uPqmZ1328613286epoutp04j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632738483;
        bh=g6jph51DvljsJEGDzc0mYrm9RldFly+bcqC78F61+HU=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=hphXSJfmL2RDmvds+L0zO100mpiYHfHdsE7QVN5HXONzEmX/8u1zdVGlQCV/NilS2
         +0RDyetyffXoAkBV7HQy4K9U+XFMUhHM0Of5iIusEJnAzT1+LQ6VDKoPjICAkjnATV
         pOT0iThQvydLUVdyWIpkxZVPJqvC5tvBKVcgOb1c=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas3p4.samsung.com (KnoxPortal) with ESMTP id
        20210927102802epcas3p495877e5af59b6c3902c6e953d25428a7~opv-MPcwc2905429054epcas3p4Q;
        Mon, 27 Sep 2021 10:28:02 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp3.localdomain
        (Postfix) with ESMTP id 4HHzNy3DvZz4x9Q9; Mon, 27 Sep 2021 10:28:02 +0000
        (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210927070056epcas1p1d6509ff1d206e655732d2a161b201b58~om7Kg8_8q1438014380epcas1p1_;
        Mon, 27 Sep 2021 07:00:56 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210927070056epsmtrp28d8b8cea5a28abfb50c9cb8bfac12f30~om7Kfx6uJ1565415654epsmtrp2G;
        Mon, 27 Sep 2021 07:00:56 +0000 (GMT)
X-AuditID: b6c32a2a-dcdff7000000222e-42-61516c28f88a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        9D.B8.08750.82C61516; Mon, 27 Sep 2021 16:00:56 +0900 (KST)
Received: from [10.113.221.211] (unknown [10.113.221.211]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210927070056epsmtip1a46986d1f5001007b2c513d566f31184~om7KIehWj2648426484epsmtip1d;
        Mon, 27 Sep 2021 07:00:56 +0000 (GMT)
Subject: Re: [PATCH v3 03/17] scsi: ufs: ufs-exynos: change pclk available
 max value
To:     Chanho Park <chanho61.park@samsung.com>,
        'Alim Akhtar' <alim.akhtar@samsung.com>,
        'Avri Altman' <avri.altman@wdc.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>,
        'Krzysztof Kozlowski' <krzysztof.kozlowski@canonical.com>
Cc:     'Bean Huo' <beanhuo@micron.com>,
        'Bart Van Assche' <bvanassche@acm.org>,
        'Adrian Hunter' <adrian.hunter@intel.com>,
        'Christoph Hellwig' <hch@infradead.org>,
        'Can Guo' <cang@codeaurora.org>,
        'Jaegeuk Kim' <jaegeuk@kernel.org>,
        'Gyunghoon Kwon' <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        cpgs@samsung.com
From:   Inki Dae <inki.dae@samsung.com>
Message-ID: <1891546521.01632738482290.JavaMail.epsvc@epcpadp4>
Date:   Mon, 27 Sep 2021 16:11:22 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
        Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <000001d7b36b$5a8817e0$0f9847a0$@samsung.com>
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsWy7bCSnK5GTmCiQUs3n8XJJ2vYLB7M28Zm
        8fLnVTaLgw87WSymffjJbPFp/TJWi8v7tS1eHtK06NnpbHF6wiImiyfrZzFbLLqxjcli49sf
        TBYzzu9jsui+voPNYvnxf0wOAh6Xr3h7zGroZfO43NfL5LF5hZbH4j0vmTw2repk85iw6ACj
        x/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAE8UVw2Kak5mWWpRfp2CVwZ2xZeYSzYw15x8PIF
        5gbGf6xdjJwcEgImEr9f3mHqYuTiEBLYwSix8HATkMMBlJCQ2LKVA8IUljh8uBii5C2jxNX3
        M1hAeoUFwiQW/n8M1isisIRJovHjbFYQh1ngHZPEjbUT2CBa1jFJ/F//mwmkhU1AVWLiivts
        IDavgJ3Eh22zGUFWsADFu2eYgoRFBSIlmk5shSoRlDg58wnYNk4BK4lXq9eD2cwC6hJ/5l1i
        hrDFJW49mc8EYctLNG+dzTyBUWgWkvZZSFpmIWmZhaRlASPLKkbJ1ILi3PTcYsMCo7zUcr3i
        xNzi0rx0veT83E2M4GjW0trBuGfVB71DjEwcjIcYJTiYlUR4g1n8E4V4UxIrq1KL8uOLSnNS
        iw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLglGpgWiDtybhA1m++3/QViy5oR+YtXLwk
        U7pVt8LeIv9spErzxkf28XuLP9Ym65sqTbt5TJazfpHO7cRI+1z/48leE7Ntznd/aFoxfzHT
        4/819jzhM72+CHSt2vpT/q3MOkF5rz0iFtyf+TYE/tnL/V34bGPYtFUzPht/+r2GZ9FVQQPJ
        MCf+rQVVm3vaFMqVCms5xVmfcrsLXTu/S12y5e+c0mw3zsLzK7WkTQ6vLl6z8HyH8z5HlnVH
        9x7P03wxr29HRs4Xfwv/sy0eEYu6jLcnrNp68DfDL85D242/b5C782c9s129xprlnJsTUhYt
        aRPIy1Hv/pr96q41l+Vs5dKT/HLN33qPbN2s03Vi+bcZSizFGYmGWsxFxYkAeZioW1UDAAA=
X-CMS-MailID: 20210927070056epcas1p1d6509ff1d206e655732d2a161b201b58
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210917065522epcas2p26f56b37c3f7505b9d0e34bc2162fdbbd
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065522epcas2p26f56b37c3f7505b9d0e34bc2162fdbbd@epcas2p2.samsung.com>
        <20210917065436.145629-4-chanho61.park@samsung.com>
        <878274034.81632720182984.JavaMail.epsvc@epcpadp4>
        <000001d7b36b$5a8817e0$0f9847a0$@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



21. 9. 27. 오후 3:46에 Chanho Park 이(가) 쓴 글:
>>>  #define PCLK_AVAIL_MIN	70000000
>>> -#define PCLK_AVAIL_MAX	133000000
>>> +#define PCLK_AVAIL_MAX	167000000
>>>
>>
>> I'm not sure but doesn't the maximum clock frequency depend on a given
>> machine? Is it true for all machines using different SoC?
> 
> Regarding pclk(sclk_unipro)of the ufs, it can be defined by mux(MUX_CLK_FSYS2_UFS_EMBD).
> It can be either 167MHz or 160MHz. And it can be defined by OSCCLK(26MHz) as well. The value was up to 133Mhz in case of exynos7 but can be extended up to 167MHz for later SoCs, AFAIK.

Oscillator clock frequency could be different according to machine. And what if UFS driver is enabled for other machine using Exynos7? Is it true to use a fixed 167MHz frequency for these machines?
I think you could get a proper pclk frequency from device tree specific to machine.

Thanks,
Inki Dae

> 
> Best Regards,
> Chanho Park
> 
> 

