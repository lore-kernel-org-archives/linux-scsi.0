Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE83C2BBC7
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 02:30:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C82B12076B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 02:30:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="L3A+0C9Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404124AbgDNCay (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 22:30:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59813 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728787AbgDNCav (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 22:30:51 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200414023046epoutp04ca6ed0a1048566f76523578389f79b65~FjssYkCSe2609026090epoutp04v
        for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2020 02:30:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200414023046epoutp04ca6ed0a1048566f76523578389f79b65~FjssYkCSe2609026090epoutp04v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1586831446;
        bh=FPE2YSpxOoxpdSqyEDyoO/7BFyhCcE+Q8Io2SIXh5/s=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=L3A+0C9Q+cSRd51m7CNgMcV7x2oJ0KAhaEussHLca1ISXfVDJZOjKfhgo9Ht7k3WO
         BmBGYcLWj1L7/lMZgfhqVBRxviLK87dF91a1M1fsCd6B+GRHWN5R+UL7qSZlon81NL
         oklSjYsZ3vhAyCm4i0rYPCWU5rVJphWcx8wn9kf0=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200414023046epcas5p3023d02fc035744c1ee4a73797f1e09ac~FjsrxnpUf2718427184epcas5p3Q;
        Tue, 14 Apr 2020 02:30:46 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C8.37.04778.550259E5; Tue, 14 Apr 2020 11:30:45 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200414023045epcas5p3b8fdcbe0d52d0b831ca576c9d96dc01a~FjsrEd8nh2718427184epcas5p3O;
        Tue, 14 Apr 2020 02:30:45 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200414023045epsmtrp28093aec96d6f9571cce00cba067afd51~FjsrDNyfP1795517955epsmtrp2T;
        Tue, 14 Apr 2020 02:30:45 +0000 (GMT)
X-AuditID: b6c32a4a-33bff700000012aa-50-5e952055fc4a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A3.3E.04024.550259E5; Tue, 14 Apr 2020 11:30:45 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200414023040epsmtip270a8d27558bd86a4c2e6ce1e423eba35~Fjsm3JoXW1722817228epsmtip2Z;
        Tue, 14 Apr 2020 02:30:40 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Can Guo'" <cang@codeaurora.org>, <asutoshd@codeaurora.org>,
        <nguyenb@codeaurora.org>, <hongwus@codeaurora.org>,
        <rnayak@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <kernel-team@android.com>, <saravanak@google.com>,
        <salyzyn@google.com>
Cc:     "'Avri Altman'" <avri.altman@wdc.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        "'Stanley Chu'" <stanley.chu@mediatek.com>,
        "'Bean Huo'" <beanhuo@micron.com>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Venkat Gopalakrishnan'" <venkatg@codeaurora.org>,
        "'Tomas Winkler'" <tomas.winkler@intel.com>,
        "'open list'" <linux-kernel@vger.kernel.org>
In-Reply-To: <1585362454-5413-1-git-send-email-cang@codeaurora.org>
Subject: RE: [PATCH v1 1/1] scsi: ufs: full reinit upon resume if link was
 off
Date:   Tue, 14 Apr 2020 08:00:38 +0530
Message-ID: <019601d61204$b303ace0$190b06a0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQI91G1Bx+ilc5rRFLRaLxyPo/0a0gHKpnZsp5oJSqA=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0hTcRTmd1+7WqtfU/Kk0WNQkGCWFfyUrCirW0bYH0EvVqNuM3w0dn1k
        RNjLatOa9sJlJZkrLBPM1liu1CiLwsL56AlF09KWOgfVtBfbNfK/73znfOd8HxyeVv1kI/ld
        mVmiIVObruZCGduDWdEx66ed0czpdCUQZ8FjBenxt3Ok8cNxhpwd8NNksMbKkqfdfQpy+aWN
        IvY74cTlKOOIqdPOkavNvyniNZ5HxNp2iyWVB2wcMTb94kjl7VeIDBTuJ5ZmL7dEJbjakgXb
        XRsruE4UUUJ5bbZQUd9DCebLDUg4/OQ+I3yvOcYJ3q7XjOCrnSIcbTBRKWM2hS7cIabvyhEN
        sYu2haaee2tF+pqwPf03Grh89H28EYXwgOeDucWJjCiUV+G7CH66bZxcDCLweLpYufiG4OAV
        H/dP8uekK4hV2IngQ3+8PORB8G7Iqgg0OBwD9oqC4KpwPITA19kZXEXjSzS4zI2UEfF8CF4G
        re5NAUEYToGrAweZAM3gGVD8Ji5AK3E81DnrKRlPgCelbiaAaTwV7nwto2VD08DfZWUDOBwn
        gLneopBnIuChv5AOnAX8VQFfXJ9YWZAEF47kj4jDoLe5TiHjSPD1ObmAB8BpUOiYJ9P7oPLi
        I0bGi6GhrSxok8azoMYRK58aB0XDbkpWKuFYgUqengGH+tpHlFFQbDKNGBCg6LOdNaPpllHB
        LKOCWUYFsPw/Vo6YKjRJ1EsZOlFaoI/LFHNnS9oMKTtTN3v77oxaFPzJ6NV2ZG1Z04Qwj9Rj
        lZ/XndaoWG2OlJfRhICn1eFKd26xRqXcoc3bKxp2bzVkp4tSE4riGXWEsoRt36LCOm2WmCaK
        etHwr0vxIZH5KLnXVL1ZH53kq161RlyaeioxaW7iymstuRuHekLiSi9ptFH3Ft8+N7PkS4uR
        XfvKbReeD+in6jasWpanG69OWRLf0xFV6Fm+oqr1BSlBHcURdTe3OerN/inejuvPvsWe7a7e
        LpVkXY94915f0HjxV9XEe+U/3sQszfEO7/xYceNZ92Q1I6Vq50bTBkn7F2dmkOGPAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsWy7bCSvG6owtQ4g/aVLBZ7206wW7z8eZXN
        4uDDThaLaR9+Mlt8Wr+M1eL0s3fsFotubGOy2LFdxOLyrjlsFt3Xd7BZLD/+j8niY9dsRotl
        VzazWixt3MZm0XXoL5vF0q03GS0+9NRZzDr+kc1ByOPyFW+Pbbu3sXpc7utl8liwqdRj8Z6X
        TB4TFh1g9Gg5uZ/F4/v6DjaPj09vsXh83iTn0X6gmymAO4rLJiU1J7MstUjfLoErY/qdZYwF
        64Ur3q85wNbA+J2/i5GTQ0LAROJ//2W2LkYuDiGB3YwSS6deZoVISEtc3ziBHcIWllj57zk7
        RNErRonl/yYxgSTYBHQldixuA+sWEWhhkvi3Zg0LiMMssJRZomPHCVaIlimMElOe3ALKcHBw
        CjhLXHoSBdItLOAncWLGezaQMIuAqsTE20YgYV4BS4kte/cwQdiCEidnPgHrZBbQk2jbyAgS
        ZhaQl9j+dg4zxHEKEj+fLgM7WkTASmLCnlnsEDXiEkd/9jBPYBSehWTSLIRJs5BMmoWkYwEj
        yypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjOB419LcwXh5SfwhRgEORiUe3gn+U+KE
        WBPLiitzDzFKcDArifA+KZ8YJ8SbklhZlVqUH19UmpNafIhRmoNFSZz3ad6xSCGB9MSS1OzU
        1ILUIpgsEwenVAOj7ATbbcyiHFMmXnS0LnrM2fZiw9dKDV2eaZmZEgstVMo/MfoK8vl1fNiu
        8f6rh2KgUtrz+6xyj0JlmFnDd7n6vDO79XGBJ89/2Rvpx/y8mr8KamVkiXy6dPKbmvLJ9psq
        7nFFvLk7Eo+tOtHxTUb7xrK3UrOfrlomYnz/fGnW2vfVTGKZDnJKLMUZiYZazEXFiQDvOER7
        8wIAAA==
X-CMS-MailID: 20200414023045epcas5p3b8fdcbe0d52d0b831ca576c9d96dc01a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200328022740epcas5p1e97777d3e2dacfbee89fed75d6b36e99
References: <CGME20200328022740epcas5p1e97777d3e2dacfbee89fed75d6b36e99@epcas5p1.samsung.com>
        <1585362454-5413-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Can,

> -----Original Message-----
> From: Can Guo <cang@codeaurora.org>
> Sent: 28 March 2020 07:58
> To: asutoshd@codeaurora.org; nguyenb@codeaurora.org;
> hongwus@codeaurora.org; rnayak@codeaurora.org; linux-
> scsi@vger.kernel.org; kernel-team@android.com; saravanak@google.com;
> salyzyn@google.com; cang@codeaurora.org
> Cc: Alim Akhtar <alim.akhtar@samsung.com>; Avri Altman
> <avri.altman@wdc.com>; James E.J. Bottomley <jejb@linux.ibm.com>; Martin
> K. Petersen <martin.petersen@oracle.com>; Stanley Chu
> <stanley.chu@mediatek.com>; Bean Huo <beanhuo@micron.com>; Bart Van
> Assche <bvanassche@acm.org>; Venkat Gopalakrishnan
> <venkatg@codeaurora.org>; Tomas Winkler <tomas.winkler@intel.com>; open
> list <linux-kernel@vger.kernel.org>
> Subject: [PATCH v1 1/1] scsi: ufs: full reinit upon resume if link was off
> 
> From: Asutosh Das <asutoshd@codeaurora.org>
> 
> During suspend, if the link is put to off, it would require a full
initialization during
> resume. This patch resets and restores both the hba and the card during
> initialization.
> 
In case you have faced issues by not doing what this patch does, it is worth
mentioning that in the commit mesg.

> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
I don't have a way to test this path as of now, changes looks ok though.
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/ufshcd.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> f19a11e..21e41e5 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8007,9 +8007,13 @@ static int ufshcd_resume(struct ufs_hba *hba, enum
> ufs_pm_op pm_op)
>  		else
>  			goto vendor_suspend;
>  	} else if (ufshcd_is_link_off(hba)) {
> -		ret = ufshcd_host_reset_and_restore(hba);
>  		/*
> -		 * ufshcd_host_reset_and_restore() should have already
> +		 * A full initialization of the host and the device is
required
> +		 * since the link was put to off during suspend.
> +		 */
> +		ret = ufshcd_reset_and_restore(hba);
> +		/*
> +		 * ufshcd_reset_and_restore() should have already
>  		 * set the link state as active
>  		 */
>  		if (ret || !ufshcd_is_link_active(hba))
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux
> Foundation Collaborative Project.


