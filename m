Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE0150097D;
	Mon, 12 Jan 2026 14:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768227190; cv=none; b=SqErig+UvvKjBk+Z4a9/a8nC/XIASokkM4W1xzxsnn+sRlVSQuAxTRXRrU6KZ+/faLDj4FIrSlB/rUqR8Dip3Mkd+vFbi9maT5+JF4tGKOQZZLE+00+mwBmDYuwy6711dllo+Rt+EpKq6WGFoUh7ZLFjt5KxLcw9J9NoPyy6GvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768227190; c=relaxed/simple;
	bh=Y5fyxaKBlgUj8V0AbL6GiCrlZD24y6EiFnaI4yjFYsU=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=MphEPVmjpycG1jlXVHgYRFqlTMIwf9EjvCGPmMn2WMB1RFw8pLxXV9Ah18R1vlSMBIiiCnXo1u45IMBfi5qs9DTw6powTc3HXyud1XUr2mfmQZlTtvIh8jKNrviMcM2XebyYlbY7Um5VnfmtN+9W74bDU91Tzui4tvOJxQQ6qps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=miOKhgij; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="miOKhgij"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1768227178; x=1768831978; i=markus.elfring@web.de;
	bh=W4eVRsrhVmlnKF0mTxm77HyHMVwowmNUv2fLAFEXRk0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=miOKhgijAiqduVOo3O7OOcMujxq0zvyK5cet1IKynXUUMmDMgm6hRcG6qxwpG5aR
	 F/pFGrVW9pe6hNdjp1ZybBBpcplj50fur7YpvrJox1ryJrVfhyxapdF4A2SYohEnR
	 eiuCm1oADAkNaliEiKmJvL3po2BNLbQysTqPpLBc+RZBj+uMvqymLT/uMLb0d7aew
	 E/DbMKfMx90kNvvV+XlYcldJNeFE8VqyPqRlYw8nZDNW0qclkiVKEp5zQ3xLIsmm2
	 qdQmajoSB7Cl8/YR3OPe6cPBmtPQffqFwKTvvXmHcnGZvY/PSUcV5Bk7vGQn23Mi0
	 pB1iRT/loScQqVDoFA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.241]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MAtsZ-1vYT1k3i2L-003taS; Mon, 12
 Jan 2026 15:12:57 +0100
Message-ID: <4b22eead-086a-43e5-99f5-f2ce609b1567@web.de>
Date: Mon, 12 Jan 2026 15:12:54 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Thomas Fourier <fourier.thomas@gmail.com>, linux-scsi@vger.kernel.org,
 GR-QLogic-Storage-Upstream@marvell.com,
 Duane Grigsby <duane.grigsby@marvell.com>, Hannes Reinecke <hare@suse.de>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Larry Wisneski <Larry.Wisneski@marvell.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Nilesh Javali <njavali@marvell.com>, Quinn Tran <qutran@marvell.com>
Cc: stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20260112134326.55466-2-fourier.thomas@gmail.com>
Subject: Re: [PATCH] scsi: qla2xxx: edif: Fix dma_free_coherent() size
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260112134326.55466-2-fourier.thomas@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:9Ju6nXsxTxiIy/0TOQidYu60IsIRGqYkmXXrb44rKv27ZLVktYi
 UJsv+/RO4l4QFih54A9mvMWfbt7ZJF6l0lQCryweE9PSa0xb8WQ3vl9Qps8y8DIwLDe28jJ
 m4xNSZxy6xhHy3Hs3NFxwAFk42gG1ssN9NJpR9e8QVmGCx0GTyVMRST9B+nUHyLea/yWx7H
 x+366MDu6ziSBO/Kd4TQQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:+zwocW9R0JM=;oO5dVbW4e5IWQhirtB+yuNoUK8S
 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
 Kg1VRRMHsOYJQJYRpbkbxnNpaODRs

> Earlier in the function, the ha->flt buffer is allocated with size
> sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE but freed in the error
> path with size SFP_DEV_SIZE.

See also once more:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.19-rc4#n94


You should probably not only specify message recipients in the header fiel=
d =E2=80=9CCc=E2=80=9D.


=E2=80=A6
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4489,7 +4489,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t=
 req_len, uint16_t rsp_len,
>  fail_elsrej:
>  	dma_pool_destroy(ha->purex_dma_pool);
>  fail_flt:
> -	dma_free_coherent(&ha->pdev->dev, SFP_DEV_SIZE,
> +	dma_free_coherent(&ha->pdev->dev, sizeof(struct qla_flt_header) + FLT_=
REGIONS_SIZE,
>  	    ha->flt, ha->flt_dma);
=E2=80=A6

How do you think about to adjust the indentation another bit for the passe=
d parameters?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?h=3Dv6.19-rc4#n110

Regards,
Markus
