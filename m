Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A536D43AAE
	for <linux-scsi@vger.kernel.org>; Wed,  9 Oct 2024 04:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728447135; cv=none; b=TnQHyz+BEczif1TWcFZfp9ntPWWZUDvGMQ2EY5t/9CFS6SfP32qx4kNFU1TCM+2fjhQpLGedMUgnI/VK3gA4XzNXiBHdYIHQeb/BRDWFvqsEB9oU9jrCvaiifTJuXXB2+tqDDxqNwn4OJVvZgybb5Cp70t6E0GzK1Kav1iXwrXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728447135; c=relaxed/simple;
	bh=eTXYDOrBO+hgzzWNfOkhGnnbzMab+NygjPEMRZqosOQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NxDAMcK7/xOIVM9j2bLS5eGJoA5t+Aa/rG+4tC6gs74YSBuIx7WiIl7GeVzXzaf9GLSLsLHdhIevf0C4CcPvKxxXEsJF3ZuvRZXC3n+vX6MyN/4AUauZL+0M4tXwZ0x5TUe4JRsx3wIJGZZPZ8FFZTh5vuyKsy41w/bvgFjRii8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e9WNbDi7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e9WNbDi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C056C4CEC5;
	Wed,  9 Oct 2024 04:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728447135;
	bh=eTXYDOrBO+hgzzWNfOkhGnnbzMab+NygjPEMRZqosOQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=e9WNbDi7rnrYX/FU9bc9kvPWqFpv5Tekf2UdH1ZeCIQB3FOPjN6av42FnoskM2zoJ
	 /eF3XRpDn3wlnurV+WmvqzbbSqrSXU8Y4P77CJXzkRnbWKS0yFA0pVZrmaITyBB8Vr
	 TeYrI9YaBFw6tK8GWNJRu0POb6hcUAXvgTfFDbXRq34/9OIwyhkA958HLkz3ar3bFo
	 pbHrXtk49uiudz6nvFEeQ+KyZI8HWnx/ENQ1ZWWy18ZXkNnomroH8QCjKJtW/lsb98
	 lU2fgbv3esyD5UV6NapWDf8IvUJQJso9Piw492Aq6Dv2Z/Vlah5jGbziIexaEZ47ae
	 Vrxw037BjUicg==
Message-ID: <82b37c35-e17e-4cc8-9066-d06d9f073e13@kernel.org>
Date: Wed, 9 Oct 2024 13:12:06 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] scsi: Rename .slave_alloc() and .slave_destroy()
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 Takashi Sakamoto <o-takashi@sakamocchi.jp>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 Steffen Maier <maier@linux.ibm.com>, Benjamin Block <bblock@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Hannes Reinecke <hare@suse.com>, Anil Gurumurthy
 <anil.gurumurthy@qlogic.com>,
 Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
 Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com, Oliver Neukum <oliver@neukum.org>,
 Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>,
 Satish Kharat <satishkh@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>,
 Karan Tilak Kumar <kartilak@cisco.com>, Yihang Li <liyihang9@huawei.com>,
 Don Brace <don.brace@microchip.com>, Tyrel Datwyler <tyreld@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Brian King <brking@us.ibm.com>,
 James Smart <james.smart@broadcom.com>,
 Dick Kennedy <dick.kennedy@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Nilesh Javali <njavali@marvell.com>,
 Manish Rangankar <mrangankar@marvell.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Matthew Wilcox <willy@infradead.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alan Stern <stern@rowland.harvard.edu>, Geoff Levand <geoff@infradead.org>,
 Khalid Aziz <khalid@gonehiking.org>, John Garry <john.g.garry@oracle.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Soumya Negi <soumya.negi97@gmail.com>, Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Avri Altman <avri.altman@wdc.com>, Andrew Halaney <ahalaney@redhat.com>,
 Bean Huo <beanhuo@micron.com>
References: <20241008205139.3743722-1-bvanassche@acm.org>
 <20241008205139.3743722-2-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241008205139.3743722-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/9/24 05:50, Bart Van Assche wrote:
> Rename .slave_alloc() into .sdev_init() and .slave_destroy() into
> .sdev_destroy(). The new names make it clear that these are actions on
> SCSI devices. Make this change in the SCSI core, SCSI drivers and also
> in the ATA drivers. No functionality has been changed.
> 
> This patch has been created as follows:
> * Change the text "slave_alloc" into "sdev_init" in all source files
>   except those in drivers/net/ and Documentation/.
> * Change the text "slave_destroy" into "sdev_destroy" in all source
>   files except those in drivers/net/ and Documentation/.
> * Rename lpfc_no_slave() into lpfc_no_sdev().
> * Manually adjust whitespace where necessary to restore vertical
>   alignment (dc395x driver and include/linux/libata.h).
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Acked-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
