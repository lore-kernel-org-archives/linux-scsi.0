Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5D9C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 04:29:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F5FA22AAA
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 04:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgLUE3c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 23:29:32 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:10323 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbgLUE3b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 23:29:31 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20201221042849epoutp0293900ebc1e0e916dcdb70aea5114a382~SoOaXutLG1620216202epoutp02X
        for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2020 04:28:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20201221042849epoutp0293900ebc1e0e916dcdb70aea5114a382~SoOaXutLG1620216202epoutp02X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608524929;
        bh=SwUijKDfjYh4OxEsEBj7kZhgeXcyWd2CmcYIibNSU8o=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=Q0HkmEzeJrIy/S/ku/txEqS7dY4Y4HTvQtT8QmDjA3Hf1GsWCK5HgTsui3pTtaQ+G
         w2NxOSbXyVUGVSUwt4zKfMlpmkOStKWwuybnit50TtAdoxfE+qrmQpH+ZAMob4AK1R
         YZQATlgnQymYhXq0q05pF9QVZGgsRSTya00RhVDE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20201221042848epcas2p2b01b25d2c1758ff24b6745ce85d635d1~SoOaJKmOv0712207122epcas2p2S;
        Mon, 21 Dec 2020 04:28:48 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.185]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Czmgg55vDz4x9Ps; Mon, 21 Dec
        2020 04:28:47 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        4B.D9.10621.E7420EF5; Mon, 21 Dec 2020 13:28:46 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20201221042845epcas2p1c5ceeb50eef2061b5b78c8eef1e545ea~SoOXLpALy2469524695epcas2p1U;
        Mon, 21 Dec 2020 04:28:45 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201221042845epsmtrp2658d8e5b52277e5626874d7d3c928a37~SoOXK778H1338213382epsmtrp2f;
        Mon, 21 Dec 2020 04:28:45 +0000 (GMT)
X-AuditID: b6c32a45-34dff7000001297d-f6-5fe0247ed1f2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        56.99.08745.D7420EF5; Mon, 21 Dec 2020 13:28:45 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201221042845epsmtip23f2eec195c584742ec90a1e57681a041~SoOXBLWnm1215812158epsmtip22;
        Mon, 21 Dec 2020 04:28:45 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Can Guo'" <cang@codeaurora.org>
Cc:     <linux-scsi@vger.kernel.org>
In-Reply-To: <d2ba958d2e4b20de0b900a9a53ed169d@codeaurora.org>
Subject: RE: [RFC PATCH v1 1/2] ufs: add a vops to configure block parameter
Date:   Mon, 21 Dec 2020 13:28:45 +0900
Message-ID: <002f01d6d751$c545d820$4fd18860$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJSV88zR68BmeN3ioq7FAWPaNUY8QEu0M7UAnS/i2gB4WkXhajdy+tQ
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMKsWRmVeSWpSXmKPExsWy7bCmmW6dyoN4g9XzhSw+rV/GatF9fQeb
        A5PH5b5eJo/Pm+QCmKJybDJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1Nt
        lVx8AnTdMnOAxisplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCgwNC/SKE3OLS/PS
        9ZLzc60MDQyMTIEqE3Iy/jx4z1Kwg7/i/9R2lgbGWTxdjJwcEgImEoduLWfsYuTiEBLYwSix
        Zv1CKOcTo8S5VfvZIZzPjBKX/m9kgmnZuaqBFSKxi1Hi1LqtUFUvGCW6Vq1hB6liE9CWmPZw
        NyuILSKgKvGu9TwbiM0soCDx9ttesEmcAnYSs098BrOFBXwk3j25xQhiswDV7zw8BayXV8BS
        Yu6fHkYIW1Di5MwnLBBzDCTen5vPDGHLS2x/O4cZ4joFiZ9Pl0HtdZOYNmsmI0SNiMTszjZm
        kEMlBC6xS3xddp4RosFFomHhHXYIW1ji1fEtULaUxOd3e9kg7HqJfVMhXpYQ6GGUeLrvH1Sz
        scSsZ+1ANgeQrSxx5BbUcXwSHYf/skOEeSU62oQgqpUlfk2aDNUpKTHz5h32CYxKs5C8NgvJ
        a7OQvDYLyQsLGFlWMYqlFhTnpqcWGxUYIsf3JkZw6tNy3cE4+e0HvUOMTByMhxglOJiVRHjN
        pO7HC/GmJFZWpRblxxeV5qQWH2I0BYb2RGYp0eR8YPLNK4k3NDUyMzOwNLUwNTOyUBLnDV3Z
        Fy8kkJ5YkpqdmlqQWgTTx8TBKdXAxFBgNUE17dqnyobCT1tfLK34L/asSPHeka7J87n1y+a/
        m3tKI23jx+BtGwRvnc6d6rYjtOvXRS6H9knPL+y6dkP7+F5/R5MNp1Oacq9y9Z0KfO/QqDD5
        ++MFWhVf1J4dXf3/6PFdzVHHrt3/XMmibXKhqNZWJF1EYqqqrTrnz2u7uWIy9uYG73pUF1/z
        6nHy6tDu7Xvuzb3/1vtVYHppo7jj5Phbf5PPlq10Lgz0VOWxCn1+Jv5Ebzt72K+MqbVLlm7m
        W3+lY+5kmUVbeLLfzRasFZz36VDLveA9OQtNGmySjvQzSP8MDp+y3/RA+OTt6RLFS23mLFJO
        fzxnR+cpQdebcS2Kp1eHO8t92xj52ESJpTgj0VCLuag4EQACwEHRBgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWy7bCSvG6tyoN4g0PLNSw+rV/GatF9fQeb
        A5PH5b5eJo/Pm+QCmKK4bFJSczLLUov07RK4Mv48eM9SsIO/4v/UdpYGxlk8XYycHBICJhI7
        VzWwdjFycQgJ7GCU+HvtCjtEQlLixM7njBC2sMT9liNQRc8YJfZ9+QdWxCagLTHt4W5WEFtE
        QFXiXet5NhCbWUBB4u23vUwQDT1MEo+2Lwcr4hSwk5h94jMTiC0s4CPx7sktsA0sQM07D08B
        q+EVsJSY+6eHEcIWlDg58wkLxFAjiXOH9kMtkJfY/nYOM8R1ChI/ny6DOsJNYtqsmYwQNSIS
        szvbmCcwCs9CMmoWklGzkIyahaRlASPLKkbJ1ILi3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M
        4AjQ0trBuGfVB71DjEwcjIcYJTiYlUR4zaTuxwvxpiRWVqUW5ccXleakFh9ilOZgURLnvdB1
        Ml5IID2xJDU7NbUgtQgmy8TBKdXANLv1gkdi5wRZ/x22jo0N7ZduhP7v+vhfcu8hkclH9j6v
        EGkM3ZP8SvPoLx3+BRw3fppfP9dz7ZjZi7SVppwruKSeXXKp5O9ZxL9jzbsFRgeZ/vrnCjz1
        f5vBWPzqTeXLozwt6/Z/crRZwCYc2T/J329yh1e5oZXIya+Pm+O6L0kzz/1qb2HztPTBmaMn
        xXMy94ad87otIMe1rrZbJOojT9XZmyePBabb1u1UEjqcduEdj6/2JjmVQx1OBzgj7E77fH29
        ZPJOmau7nZfOedi12nRadeGNQ/YLbrs+Zra+wfpC8ZXb7cSJvSJPOxzrb8/7stR1Vb+6dNdc
        ldQvpWlZvUmSn/Zd+1N8Y9e3tj7ubiWW4oxEQy3mouJEACEzTkHvAgAA
X-CMS-MailID: 20201221042845epcas2p1c5ceeb50eef2061b5b78c8eef1e545ea
X-Msg-Generator: CA
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201219044916epcas2p16927b09270a3d829520af414dd64d80f
References: <cover.1608352548.git.kwmad.kim@samsung.com>
        <CGME20201219044916epcas2p16927b09270a3d829520af414dd64d80f@epcas2p1.samsung.com>
        <ecc0563a5a48e3339e59760cc8cb73a698061851.1608352548.git.kwmad.kim@samsung.com>
        <d2ba958d2e4b20de0b900a9a53ed169d@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > Thers could be some cases to set block paramters
> 
> s/Thers/There/g
> 
> > per host, because of its own dma structurs or whatever.
> 
> s/structurs/structure/g
> 
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 2 ++
> >  drivers/scsi/ufs/ufshcd.h | 8 ++++++++
> >  2 files changed, 10 insertions(+)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 92d433d..58f9cb6 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -4758,6 +4758,8 @@ static int ufshcd_slave_configure(struct
> > scsi_device *sdev)
> >
> >  	ufshcd_crypto_setup_rq_keyslot_manager(hba, q);
> >
> > +	ufshcd_vops_config_request_queue(hba, sdev);
> 
> How about make it more univeral, like ufshcd_vops_slave_configure()?
> 
> Thanks,
> 
> Can Guo.
> 

Will refer and thanks for all of your comments


Thanks.
Kiwoong Kim
> > +
> >  	return 0;
> >  }
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index 61344c4..657bdbd 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -329,6 +329,7 @@ struct ufs_hba_variant_ops {
> >  					void *data);
> >  	int	(*program_key)(struct ufs_hba *hba,
> >  			       const union ufs_crypto_cfg_entry *cfg, int
slot);
> > +	void	(*config_request_queue)(struct scsi_device *sdev);
> >  };
> >
> >  /* clock gating state  */
> > @@ -1228,6 +1229,13 @@ static inline void
> > ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
> >  		hba->vops->config_scaling_param(hba, profile, data);  }
> >
> > +static inline void ufshcd_vops_config_request_queue(struct ufs_hba
> > *hba,
> > +						    struct scsi_device
*sdev)
> > +{
> > +	if (hba->vops && hba->vops->config_request_queue)
> > +		hba->vops->config_request_queue(sdev);
> > +}
> > +
> >  extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
> >
> >  /*

