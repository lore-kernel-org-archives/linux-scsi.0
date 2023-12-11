Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W9lTIU0x"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B12AD2
	for <linux-scsi@vger.kernel.org>; Mon, 11 Dec 2023 11:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702324322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qq03Jo5f/IYnaWG7QuyK0Yjjv5PibXRKmzmjiucs3YU=;
	b=W9lTIU0xtiYiPm/ir8UqKCfin6le872ziEIPOrT5hTxn1fdrKBZ8lmLjzT1PX8Z96Ack8X
	l+K4uocN9bxSEhpTqcOOEHQW7P6WFk7bGWRdfTuuiwo8bWaxon/MsBV24rgUu5ZegQMzWH
	+6jEFeUV23Cvq9MRIgTrTVz/tyBz5wA=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-333-Zur8GxOCP02hHLyDT8JtDA-1; Mon, 11 Dec 2023 14:51:59 -0500
X-MC-Unique: Zur8GxOCP02hHLyDT8JtDA-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-67ab0fa577fso67589026d6.1
        for <linux-scsi@vger.kernel.org>; Mon, 11 Dec 2023 11:51:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702324319; x=1702929119;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qq03Jo5f/IYnaWG7QuyK0Yjjv5PibXRKmzmjiucs3YU=;
        b=pTHkoZ4USdwyTFuFStNtFIeWW/r+VxYYVLO5xmvJaPrx+xo7eX+Lw7vCWRzw+Nz5QZ
         JBkaZKj5sVKjxapdUz0Wry20M+KZb7W3rNjutef32ON05Jw7lkdhMN+RUjd4JGXe4hae
         CDUCwuM4y7fD1Z32ffZLDmbkv4G+db+L1yD3MEkIxoscQ4ZLRFY1i4nCqafA+DuTeezK
         m2Z1TKe9Dz12mfZDZuRor6kmbxXNdRumTx6J5yfLecesoqzqthD7pyz1PMYDVs0NUb4+
         QZOFiKe5QjMMxL/eT3DgNnE24Qoitjl4xl9jjCa7SSHLOAU1ZXZJYgxLXwAurW6jf2lr
         oAxQ==
X-Gm-Message-State: AOJu0YyjQlF/8lZtEcxLxdpspctpCBuFPncqGVCorY2MEWBBR+XqQciN
	gsEiq2+6nyltuJpRjFTnPlh5cEpw/p8zABRcuHHm+hIzbtSG7Pdq3LpaRnPLa9gewi9ToO7rUoa
	2BaU+YrHdTkwjbeilIbaW7g==
X-Received: by 2002:ad4:59d0:0:b0:67a:a721:82e8 with SMTP id el16-20020ad459d0000000b0067aa72182e8mr5502185qvb.66.1702324318984;
        Mon, 11 Dec 2023 11:51:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH4+eOMOzP47aZt+EFlhHkf0eUx1qMFM1Dbo85dg2KxXg+o2VYJKcQRK6XmQpPp0Imc+Fr/KA==
X-Received: by 2002:ad4:59d0:0:b0:67a:a721:82e8 with SMTP id el16-20020ad459d0000000b0067aa72182e8mr5502181qvb.66.1702324318771;
        Mon, 11 Dec 2023 11:51:58 -0800 (PST)
Received: from fedora ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id bo14-20020a05621414ae00b0067aaa7483efsm3533358qvb.6.2023.12.11.11.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 11:51:58 -0800 (PST)
Date: Mon, 11 Dec 2023 13:51:56 -0600
From: Andrew Halaney <ahalaney@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konrad.dybcio@linaro.org>, Manivannan Sadhasivam <mani@kernel.org>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Yaniv Gardi <ygardi@codeaurora.org>, Dov Levenglick <dovl@codeaurora.org>, 
	Will Deacon <will@kernel.org>, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: qcom: Perform read back after writing reset
 bit
Message-ID: <oyjzluv5ldvurqzsqiwxnjtmpvvjavkdxvbetwctq7qentdjbh@r27gvlj62scq>
References: <20231208-ufs-reset-ensure-effect-before-delay-v1-1-8a0f82d7a09e@redhat.com>
 <0d59681d-2d7d-4459-b79c-c5f41f20b7a5@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d59681d-2d7d-4459-b79c-c5f41f20b7a5@acm.org>

On Mon, Dec 11, 2023 at 09:59:25AM -0800, Bart Van Assche wrote:
> 
> On 12/8/23 12:19, Andrew Halaney wrote:
> > The recommendation for ensuring this bit has taken effect on the
> > device is to perform a read back to force it to make it all the way
> > to the device. This is documented in device-io.rst  [... ]
> There are more mb()'s that need to be replaced, namely the mb() calls in
> ufshcd_system_restore() and ufshcd_init().

I'll poke at those in v2 (or in a separate series if this is scooped up
prior).

Thanks,
Andrew

