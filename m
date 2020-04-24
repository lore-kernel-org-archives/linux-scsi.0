Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC308C54FCB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8291120736
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:08:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="SigemGgj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgDXMIl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 08:08:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:64428 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbgDXMIj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2020 08:08:39 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200424120836epoutp04ced134145995a302cf644141d4afb195~IwCD5O7Qq2603226032epoutp04D
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2020 12:08:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200424120836epoutp04ced134145995a302cf644141d4afb195~IwCD5O7Qq2603226032epoutp04D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587730116;
        bh=o1x/o0p5cvyo45FmR0LMyR4pPuLuODzDC+UZIaiwx+E=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=SigemGgjqFrsZJj+ae53HYfpBTMnpCXnwHVvOK73JS8LgFM4eOPCboVyPxmtaqzwf
         ZEl1wIaeo2FZxVC9dOlBPS+dSWUE3eZNCaH5mgTk4d7p+2DJxr7Q/ZiEv+CfmbarM1
         eTm+8Qxfq2PwUGqyKf1jjBPeJKbmgpop6YoU9PZ4=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200424120835epcas5p33b278b327be39a86415aead0e725f1f8~IwCDGCcZo2936429364epcas5p3_;
        Fri, 24 Apr 2020 12:08:35 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DC.1A.10083.3C6D2AE5; Fri, 24 Apr 2020 21:08:35 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200424120834epcas5p1b4c375c70425bc4079bb315c446e9a75~IwCCQbf9_2514025140epcas5p1S;
        Fri, 24 Apr 2020 12:08:34 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200424120834epsmtrp2d2981f23801ee38612ae82ddd43cad33~IwCCPhDbO1612216122epsmtrp2P;
        Fri, 24 Apr 2020 12:08:34 +0000 (GMT)
X-AuditID: b6c32a4a-875ff70000002763-38-5ea2d6c3f2f1
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CD.3C.18461.2C6D2AE5; Fri, 24 Apr 2020 21:08:34 +0900 (KST)
Received: from alimakhtar02 (unknown [107.111.84.49]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200424120833epsmtip21c2f1f8c0a5ba202b3d368ef22d10be2~IwCA9uyT31554615546epsmtip2T;
        Fri, 24 Apr 2020 12:08:33 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Jose Abreu'" <Jose.Abreu@synopsys.com>,
        <linux-scsi@vger.kernel.org>
Cc:     "'Joao Pinto'" <Joao.Pinto@synopsys.com>,
        "'Joao Lima'" <Joao.Lima@synopsys.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <5c4281080538b74ca39cedb9112ffe71bf7a80b5.1587727756.git.Jose.Abreu@synopsys.com>
Subject: RE: [PATCH 1/5] scsi: ufs: Allow UFS 3.0 as a valid version
Date:   Fri, 24 Apr 2020 17:38:31 +0530
Message-ID: <000601d61a31$13fe2230$3bfa6690$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQE+XL6e14367+A9KP/ZE9gmmc/2FgMEZj+1AnyNmNCpi6BGEA==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsWy7bCmhu7ha4viDG4vVLR4+fMqm8WiG9uY
        LLZclbX48egos8W9Px9YLS7vmsNm0X19B5vF8uP/mBw4PCYsOsDo8fHpLRaPLfs/M3p83iTn
        0X6gmymANYrLJiU1J7MstUjfLoErY/71M8wF/cIV919uZ2tg/MDfxcjJISFgIvHl2GS2LkYu
        DiGB3YwSHVumsEA4nxglZj9fwgrhfGOUWPr5GwtMy+M985lBbCGBvYwSzzfKQBS9YpQ4eeIS
        E0iCTUBXYsfiNjYQW0TAS+LehYmMIEXMAq1MEhOXHgUay8HBKRAn0bfLC6RGWMBF4s3pyawg
        NouAqsTyI/fAFvAKWEpsm/KeFcIWlDg58wnYEcwC8hLb385hhjhIQeLn02VgI0UEnCQ27oiG
        KBGXOPqzhxlkrYTAQg6Js192skPUu0j83/Ia6hlhiVfHt0DFpSQ+v9vLBjJHQiBbomeXMUS4
        RmLpvGNQ5fYSB67MYQEpYRbQlFi/Sx9iFZ9E7+8nTBCdvBIdbUIQ1aoSze+uQnVKS0zs7maF
        sD0kbszZyzaBUXEWkr9mIflrFpIHZiEsW8DIsopRMrWgODc9tdi0wCgvtVyvODG3uDQvXS85
        P3cTIzgVaXntYFx2zucQowAHoxIPL8OhRXFCrIllxZW5hxglOJiVRHhjSoBCvCmJlVWpRfnx
        RaU5qcWHGKU5WJTEeSexXo0REkhPLEnNTk0tSC2CyTJxcEo1MNaz9XZ6StR0hE7WWt+jw63J
        utb20qXd+U12yrI/PrPtYQ+4Mal+ioTL5ABmY45rxeo3k+4lBtasbRTcpdxzO802JMt/k+b7
        G5e1NE9U8JXyaHybvlzX8LtX0qm3UsEft0aFbtmy1aZDbFvQgcXrwxky5uQUJirfEDO9tnfG
        9SO/s36wn884qcRSnJFoqMVcVJwIANPxW4xBAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42LZdlhJXvfQtUVxBrOaNSxe/rzKZrHoxjYm
        iy1XZS1+PDrKbHHvzwdWi8u75rBZdF/fwWax/Pg/JgcOjwmLDjB6fHx6i8Vjy/7PjB6fN8l5
        tB/oZgpgjeKySUnNySxLLdK3S+DKmH/9DHNBv3DF/Zfb2RoYP/B3MXJySAiYSDzeM5+5i5GL
        Q0hgN6PEjO4zrBAJaYnrGyewQ9jCEiv/PWeHKHrBKNH8cDdYgk1AV2LH4jY2EFtEwEdi2fuL
        YJOYBTqZJF7OmQQ19h6jxLN1n4E6ODg4BeIk+nZ5gTQIC7hIvDk9GWwbi4CqxPIj95hBbF4B
        S4ltU96zQtiCEidnPmEBaWUW0JNo28gIEmYWkJfY/nYOM8RxChI/ny5jBSkREXCS2LgjGqJE
        XOLozx7mCYzCs5AMmoUwaBaSQbOQdCxgZFnFKJlaUJybnltsWGCYl1quV5yYW1yal66XnJ+7
        iREcU1qaOxi3r/qgd4iRiYPxEKMEB7OSCG9MyaI4Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rw3
        ChfGCQmkJ5akZqemFqQWwWSZODilGpiqWdbMUluhlz3h8yfNq+byGQV/rTMnK+3UX6YRL18Z
        Yllr+l13zYNHSSvUppx+yrRBo2iNxBaL/UXb/AMup3+r89u6PsNBvExs7T1lrfhdheavFpWe
        eWC52kLMeOG5GUZzni61+/Et7VuWSO2Tc6vYlrHlKh+8dfyU/91za8W5328Juff2kK8yu5yj
        9L6UrJA13r1Sfcsf7piezO0+fc/EzsoJTZ85n9sbaf6XvlfEvfr5Y61ZuaekWVy8pxu9jMmP
        0tVY+muitgLDkUfFf0p/7qorP7pnvbfaB/8zHI6lvZnCrrYGYdd0+NkemWjLlfxOy9CqjFa7
        njBpw7odS4rUb6y1nnXoyIJn7Kn3VTcpsRRnJBpqMRcVJwIAUGAlMhgDAAA=
X-CMS-MailID: 20200424120834epcas5p1b4c375c70425bc4079bb315c446e9a75
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200424113726epcas5p2fe5c92ba9ad04d909e45c4a600ead28e
References: <cover.1587727756.git.Jose.Abreu@synopsys.com>
        <CGME20200424113726epcas5p2fe5c92ba9ad04d909e45c4a600ead28e@epcas5p2.samsung.com>
        <5c4281080538b74ca39cedb9112ffe71bf7a80b5.1587727756.git.Jose.Abreu@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Jose,

> -----Original Message-----
> From: Jose Abreu <Jose.Abreu@synopsys.com>
> Sent: 24 April 2020 17:07
> To: linux-scsi@vger.kernel.org
> Cc: Joao Pinto <Joao.Pinto@synopsys.com>; Jose Abreu
> <Jose.Abreu@synopsys.com>; Joao Lima <Joao.Lima@synopsys.com>; Alim
> Akhtar <alim.akhtar@samsung.com>; Avri Altman <avri.altman@wdc.com>;
> James E.J. Bottomley <jejb@linux.ibm.com>; Martin K. Petersen
> <martin.petersen@oracle.com>; linux-kernel@vger.kernel.org
> Subject: [PATCH 1/5] scsi: ufs: Allow UFS 3.0 as a valid version
> 
> Add a define for UFS version 3.0 and do not print an error message upon
probe
> when using this version.
> 
> Signed-off-by: Joao Lima <Joao.Lima@synopsys.com>
> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
> 
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

> ---
> Cc: Joao Lima <Joao.Lima@synopsys.com>
> Cc: Jose Abreu <Jose.Abreu@synopsys.com>
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/scsi/ufs/ufshcd.c | 3 ++-
>  drivers/scsi/ufs/ufshci.h | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 7d1fa1349d40..2e5c200e915b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8441,7 +8441,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem
> *mmio_base, unsigned int irq)
>  	if ((hba->ufs_version != UFSHCI_VERSION_10) &&
>  	    (hba->ufs_version != UFSHCI_VERSION_11) &&
>  	    (hba->ufs_version != UFSHCI_VERSION_20) &&
> -	    (hba->ufs_version != UFSHCI_VERSION_21))
> +	    (hba->ufs_version != UFSHCI_VERSION_21) &&
> +	    (hba->ufs_version != UFSHCI_VERSION_30))
>  		dev_err(hba->dev, "invalid UFS version 0x%x\n",
>  			hba->ufs_version);
> 
> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h index
> c2961d37cc1c..f2ee81669b00 100644
> --- a/drivers/scsi/ufs/ufshci.h
> +++ b/drivers/scsi/ufs/ufshci.h
> @@ -104,6 +104,7 @@ enum {
>  	UFSHCI_VERSION_11 = 0x00010100, /* 1.1 */
>  	UFSHCI_VERSION_20 = 0x00000200, /* 2.0 */
>  	UFSHCI_VERSION_21 = 0x00000210, /* 2.1 */
> +	UFSHCI_VERSION_30 = 0x00000300, /* 3.0 */
>  };
> 
>  /*
> --
> 2.7.4


