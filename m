Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB21DC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 02:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8963A61279
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 02:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238567AbhI1CVp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 22:21:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61276 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238590AbhI1CVo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 22:21:44 -0400
Received: from epcas3p3.samsung.com (unknown [182.195.41.21])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210928022003epoutp028599cc30ae583e9942a63fb0413a3cb8~o2vNhw-Hv0292102921epoutp02L
        for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2021 02:20:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210928022003epoutp028599cc30ae583e9942a63fb0413a3cb8~o2vNhw-Hv0292102921epoutp02L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632795603;
        bh=4cV1cNC1u5nCvaXo1VkU/P8gEHxGNPcrXraD59LyqqA=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=mEuxxwyIIdrDKSiERv2erdfeHY1cy2zKv11MljinF8Xgv3n6MzEYtTC5C8b2GqTR2
         zfeMboud6CSlPRnpqRp2WluEqSUV6tIBa18JwKkQzKViPlIVlvB3weI1ZvASccuq4e
         lLcrc3UKi5r1+7xc4lg9d911FR7yhhUbEWXgR+Y0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p4.samsung.com (KnoxPortal) with ESMTP id
        20210928022003epcas3p49131eb755461a77ec29e20cfbd975120~o2vNAnu0X1824718247epcas3p4q;
        Tue, 28 Sep 2021 02:20:03 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4HJNWR0WDfz4x9QY; Tue, 28 Sep 2021 02:20:03 +0000
        (GMT)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20210928020736epcas1p38c49d5984bdf5869f1e0f9c57a382f7b~o2kV2EVQe2987929879epcas1p3Y;
        Tue, 28 Sep 2021 02:07:36 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210928020736epsmtrp13cdbb8bc75da2d3e76e64d445c19f341~o2kV1tzIy2914829148epsmtrp1r;
        Tue, 28 Sep 2021 02:07:36 +0000 (GMT)
X-AuditID: b6c32a2a-dcdff7000000222e-4c-615278e86b2e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        21.7A.08750.8E872516; Tue, 28 Sep 2021 11:07:36 +0900 (KST)
Received: from [10.113.221.211] (unknown [10.113.221.211]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210928020736epsmtip297f06ab426492f0ff54f3f05ed269fb9~o2kViaug21321113211epsmtip2A;
        Tue, 28 Sep 2021 02:07:36 +0000 (GMT)
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
Message-ID: <2038148563.21632795603027.JavaMail.epsvc@epcpadp3>
Date:   Tue, 28 Sep 2021 11:18:03 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
        Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <00f401d7b390$017ed1f0$047c75d0$@samsung.com>
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02RfyyUcRzH+z7P4/G4OT3umG+azLVqsRRp+9ZkpNmz1ZRarW6Ki8ePOHRH
        Tm1SzZJiZ5lyJI7q3OLy49D5ffoljUZitopzrTPJj2qoRt2pzX+vz/v9fv31oXBeB+FMxSYk
        s5IEUbyA5BANXQLXbSbZEdEOzbQb6jY+ItFoSQOJJhYHSdQ5dp1ABTOLOJrTPLBCA+0eaEK/
        Fd18Eoh65EoMGTUKHCmHGzBUM7WAoTt9bRi6MdREoocvljB/mhl4e4BRZOSQzEBuDsbUqdyZ
        8pYJjKlVXycZubIDMPOaLJKZ/TRCMLn1asB8q93AXOu4gR22FXJ8I9n42POsZLtfOCfmTn9M
        0qKtrGBiFM8APZxsYENB2gcuvy/DsgGH4tFNAL54oLPOBtTfAsJ6LbWCfNjVJTXPefQUgLlt
        Hmbm08dh2fK4RXWgKzB4ebbIynzg9FcMDlfJyRUjH4cNry6amaQ3wTzVR0vOpf1gzc9iazMT
        f/NnJqOFHemT8MpL7b+NPewuNBJmtqH3wMnnGZYcp7fA3yX9+Ao7wRHjPWyFXeFVbREuBzzF
        Kl2xSlGsUhSrlFJAqME6NkkqjhZLvZK8E9hUT6lILE1JiPaMSBTXAsuT3d2bQIt6xlMPMAro
        AaRwgQP3KHFIxONGitIusJLEMElKPCvVg/UUIXDivsnuDuPR0aJkNo5lk1jJ/xajbJwzsFOX
        vPmqnJGwWtY+bGdv9dDc8e+lr8EuTfG59OLmSHUAc8WxdPBDCE9WLLSb/diWFmS15vv+KZXb
        dOWvbgPeGGsX/I2c5ycXFphUsooxZcWkjtNz+6Keb2MMXPrq8gy3Ryeyhg9vdI7N+2ToxHTz
        ptTyFFN5TdVoZpSjVWr6+NWRStYnfCHUX6PVRe3J338+9O6MY0y4trVuIVdoaBRkuaRHLWd6
        2A/LC/126+I0wohm+vTjW9Ww1XYzqbz/Q+HfMhnc3G54d7cXBeDWfmXClC9npnVTBoXvWe7a
        z3vf33wK7F6F1Bu9mH3+yragZLwnUFzVt0Pm7HDM+mCik4CQxoi83HGJVPQHIWIzd1MDAAA=
X-CMS-MailID: 20210928020736epcas1p38c49d5984bdf5869f1e0f9c57a382f7b
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
        <1891546521.01632738482290.JavaMail.epsvc@epcpadp4>
        <00f401d7b390$017ed1f0$047c75d0$@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



21. 9. 27. 오후 8:08에 Chanho Park 이(가) 쓴 글:
>>>>>  #define PCLK_AVAIL_MIN	70000000
>>>>> -#define PCLK_AVAIL_MAX	133000000
>>>>> +#define PCLK_AVAIL_MAX	167000000
>>>>>
>>>>
>>>> I'm not sure but doesn't the maximum clock frequency depend on a
>>>> given machine? Is it true for all machines using different SoC?
>>>
>>> Regarding pclk(sclk_unipro)of the ufs, it can be defined by
>> mux(MUX_CLK_FSYS2_UFS_EMBD).
>>> It can be either 167MHz or 160MHz. And it can be defined by OSCCLK(26MHz)
>> as well. The value was up to 133Mhz in case of exynos7 but can be extended
>> up to 167MHz for later SoCs, AFAIK.
>>
>> Oscillator clock frequency could be different according to machine. And
>> what if UFS driver is enabled for other machine using Exynos7? Is it true
>> to use a fixed 167MHz frequency for these machines?
>> I think you could get a proper pclk frequency from device tree specific to
>> machine.
> 
> The actual pclk value will be get by CCF's clk_get_rate. PCLK_AVAIL_MAX represents the available maximum value of UFS's pclk to find an optimal value of unipro clock. I just extend the maximum pclk rate from 133MHz to 167MHz. The divider will be calculated according to the actual pclk value :)
>
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/scsi/ufs/ufs-exynos.c?h=v5.15-rc3#n287
>
Thanks for the link. I thought only PCLK_AVAIL_MAX is valid but it means available maximum clock so clock frequency between the min and max would be allowed as well. :)

Reviewed-by : Inki Dae <inki.dae@samsung.com>

Thanks,
Inki Dae

> Best Regards,
> Chanho Park
> 
> 

