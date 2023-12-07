Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HnFVJREz"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1203110CB
	for <linux-scsi@vger.kernel.org>; Thu,  7 Dec 2023 05:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701956782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MayE2jstjV8R9mQ7ezeMnZEaKl2NQz8vMG8UW7Z3nRs=;
	b=HnFVJREzmV0+5B+WRfsa3Auj1wBsxEz2bPLl3/fI/LP7zdXHX50b86t3ZV+zkSbUBQ03vl
	DKdbFJeXnMAktHe5bhIStoVzemF9lHkK3wGoM7R6+ZNCgjfnLi5UsuJPUMBRjMXH/DV7Q0
	f+jsH8UUO0nW09h3oX/VKGSLdbC4+ZA=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-LwDH6GSyPlObGqpFSVth0A-1; Thu, 07 Dec 2023 08:46:21 -0500
X-MC-Unique: LwDH6GSyPlObGqpFSVth0A-1
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-58d53348a03so771787eaf.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 Dec 2023 05:46:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701956780; x=1702561580;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MayE2jstjV8R9mQ7ezeMnZEaKl2NQz8vMG8UW7Z3nRs=;
        b=F+nBn3antBkWT2LLz/I1POps0x7sEc2VXkDpFL5Q1VgOU8ni1NjcG/ec5xO3qEzb7o
         qpISqZCvgHuONznLfq6q3E286Cpt5BGrcikhAcX/V4qX22SxxLMO4YMoHcQzLaOWvBNj
         cCokpoHVtJoBDvnJ/SBZ3AI6ubwngHvAd4doPm8qngeyza6no1eYtxFd7rInmdsZrnpf
         169ANvZc5Yf5xMYFZHkcI2u0v3rR0H91Hw28FsgDhT5k26o6qT4vrkoqGfkeA4LtyMrk
         oHfz3Q9qVX0IiEawbzK1wNhYaiGqDos9trazNxEQvMNmw/wSDZ9vLnE7OJ5Gm4oe74vb
         OGjQ==
X-Gm-Message-State: AOJu0YzovLmjYz5YJUsrJHWImtorvgrBP1xticqcv3gy5M/ZAiMdd2ne
	C4WcEyk+1Hqyj6St/n7fpG0ugD4VKiWaNCw5vA8rZseF3qdgGDgvirPKvHa+xBhhLWjKBOwIA5O
	qk8sybhsj1KTaYY1Lkxf3cg==
X-Received: by 2002:a05:6358:7244:b0:170:2cff:b57e with SMTP id i4-20020a056358724400b001702cffb57emr3149553rwa.28.1701956780350;
        Thu, 07 Dec 2023 05:46:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEkleS9nA9h1C/ufo8zCGD9PAxaOCQltjexOMuG5X9Zhtpyj8pooXqvLS0Uxwdd3bswk+SUxQ==
X-Received: by 2002:a05:6358:7244:b0:170:2cff:b57e with SMTP id i4-20020a056358724400b001702cffb57emr3149542rwa.28.1701956780083;
        Thu, 07 Dec 2023 05:46:20 -0800 (PST)
Received: from fedora ([2600:1700:1ff0:d0e0::47])
        by smtp.gmail.com with ESMTPSA id cx11-20020a056214188b00b0067ac01d39bdsm496309qvb.47.2023.12.07.05.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Dec 2023 05:46:19 -0800 (PST)
Date: Thu, 7 Dec 2023 07:46:17 -0600
From: Andrew Halaney <ahalaney@redhat.com>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: martin.petersen@oracle.com, jejb@linux.ibm.com, andersson@kernel.org, 
	konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, quic_cang@quicinc.com
Subject: Re: [PATCH 11/13] scsi: ufs: qcom: Remove unused ufs_qcom_hosts
 struct array
Message-ID: <ca4ag4xrnw3cegbfqjcjf4ejidi2oblabcrkxadpgv6yda26a4@2khffdooqvlj>
References: <20231201151417.65500-1-manivannan.sadhasivam@linaro.org>
 <20231201151417.65500-12-manivannan.sadhasivam@linaro.org>
 <sqdgnfedt5j3epypmsvb7lv6gvmjrymtuieji3yhqsfvniiodl@f3aj73mlshxy>
 <20231207053159.GC2932@thinkpad>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231207053159.GC2932@thinkpad>

On Thu, Dec 07, 2023 at 11:01:59AM +0530, Manivannan Sadhasivam wrote:
> On Wed, Dec 06, 2023 at 12:54:43PM -0600, Andrew Halaney wrote:
> > On Fri, Dec 01, 2023 at 08:44:15PM +0530, Manivannan Sadhasivam wrote:
> > > ufs_qcom_hosts array is assigned, but not used anywhere. So let's remove
> > > it.
> > > 
> > > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > > ---
> > >  drivers/ufs/host/ufs-qcom.c | 5 -----
> > >  1 file changed, 5 deletions(-)
> > > 
> > > diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> > > index a86f6620abc8..824c006be093 100644
> > > --- a/drivers/ufs/host/ufs-qcom.c
> > > +++ b/drivers/ufs/host/ufs-qcom.c
> > > @@ -90,8 +90,6 @@ static const struct __ufs_qcom_bw_table {
> > >  	[MODE_MAX][0][0]		    = { 7643136,	307200 },
> > >  };
> > >  
> > > -static struct ufs_qcom_host *ufs_qcom_hosts[MAX_UFS_QCOM_HOSTS];
> > > -
> > 
> > I think we can get rid of MAX_UFS_QCOM_HOSTS as well with this change in
> > place?
> > 
> 
> Yes, thanks for spotting.

With that in place please add:

    Reviewed-by: Andrew Halaney <ahalaney@redhat.com>

> 
> - Mani
> 
> > >  static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host);
> > >  static int ufs_qcom_set_core_clk_ctrl(struct ufs_hba *hba, bool is_scale_up);
> > >  
> > > @@ -1192,9 +1190,6 @@ static int ufs_qcom_init(struct ufs_hba *hba)
> > >  
> > >  	ufs_qcom_setup_clocks(hba, true, POST_CHANGE);
> > >  
> > > -	if (hba->dev->id < MAX_UFS_QCOM_HOSTS)
> > > -		ufs_qcom_hosts[hba->dev->id] = host;
> > > -
> > >  	ufs_qcom_get_default_testbus_cfg(host);
> > >  	err = ufs_qcom_testbus_config(host);
> > >  	if (err)
> > > -- 
> > > 2.25.1
> > > 
> > > 
> > 
> > 
> 
> -- 
> மணிவண்ணன் சதாசிவம்
> 

