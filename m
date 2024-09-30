Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCAC17BB38
	for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2024 20:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727729905; cv=none; b=cCOwYNb4ZZZKfEuCdLL08cy/2AQNCrtmPsSlv25VYfykyEi1XDOllD3HOMHzUxzbbc4GxzGgDM+dTgmnEPKPoDgPItmtkEGwLx9hY4pPVeCIoUxpP7FJ+CIBNvQJDX67NQoFT6KMK2vliQcLV2T+AVmkHkGIuRDFEg46kd+Jsd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727729905; c=relaxed/simple;
	bh=J6ccCBWIyjdyTl0mkEFGnR+CHm7lTq7XSi2yruHsZ2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WDLX6t16f3S6lKfhAoqKtR5SBJfhkyMlywMgShK+HTQuxf04HGOJ4FVkfftc3oYglWf3GKJSArC+Iqk3ZPAjwuFMYzy9EeQdU/8zeXFtO35fSlnFq28EuYjM14ls6+ib0m7li5ZhJdDGEr96P0FFp8kxysJhvP9fGB7V3EbJ4l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vUsaq2oG; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vUsaq2oG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d7C975T9l9gNibvMBWp3qelCUAuXtGvNAjtKMjgMlT0=; b=vUsaq2oG2U1XVkPLt2t+RY0UW5
	1ugoP+zv5jdS1rWhixemWgV0LGt8sR0UpDVCn99/CaFbV6kzabLGO43ZvPU9I+PuPEq00U/35yuJ5
	Pb/EPkbj7DNa3NEiof5qtWjiiNDZgZbhm+vTQPC6EnP96BUWAz5e0eiXdPJ1IOBK59suFnmMw4117
	nxQOp6TFPtNNeGVZN/jyxno7z6jxek60Ai81k1xPLvsWlYbg43zSSxeGdhxGowOMUMpCtmvbwHaOI
	AuDf/PmTba6aPTaahJfHkcTCry6tz9BkkYrFV2MjuhQYdRTk1vW3OZjOGtyGqnO5p9flkSUDl6woM
	Xi7uxn+A==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svNT5-00000000cWt-3wfu;
	Mon, 30 Sep 2024 20:58:07 +0000
Date: Mon, 30 Sep 2024 21:58:07 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Niklas Cassel <cassel@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Steffen Maier <maier@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Hannes Reinecke <hare@suse.com>,
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>,
	Jamie Lenehan <lenehan@twibble.org>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Yihang Li <liyihang9@huawei.com>,
	Don Brace <don.brace@microchip.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Brian King <brking@us.ibm.com>,
	James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Randy Dunlap <rdunlap@infradead.org>,
	John Garry <john.g.garry@oracle.com>,
	Soumya Negi <soumya.negi97@gmail.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH 1/4] scsi: Rename .slave_alloc() and .slave_destroy()
Message-ID: <ZvsQ310JHWHJAv7l@casper.infradead.org>
References: <20240930201937.2020129-1-bvanassche@acm.org>
 <20240930201937.2020129-2-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240930201937.2020129-2-bvanassche@acm.org>

On Mon, Sep 30, 2024 at 01:18:47PM -0700, Bart Van Assche wrote:
> There is agreement that the word "slave" should not be used in Linux
> kernel source code. Hence this patch that renames .slave_alloc() into
> .device_alloc() and .slave_destroy() into .device_destroy() in the SCSI
> core, SCSI drivers, ATA drivers and also in the SCSI documentation.
> Do not modify Documentation/scsi/ChangeLog.lpfc. No functionality has
> been changed.
> 
> This patch has been created as follows:
> * Change the text "slave_alloc" into "device_alloc" in all source files
>   except in the LPFC driver changelog.
> * Change the text "slave_destroy" into "device_destroy" in all source
>   files except in the LPFC driver changelog.

I still like my names better:

https://lore.kernel.org/linux-scsi/20200706193920.6897-1-willy@infradead.org/
