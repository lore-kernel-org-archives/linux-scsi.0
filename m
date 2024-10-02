Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF7C199954
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 22:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727908792; cv=none; b=fzmQQSplkanOgIO3HZfd+qvHmRMrWDGp8SU7MjnLBTp0/41z1fMHiSNip/ZWOVE9hZ9p1LFC/CUbRdbYpPnLUihlhj53/PI10YSm4B8WSAoVVaQtvPRt1i58d4/R06RvUkwZzhFebTQmnZ1qpcQ5WPAWPn2bOwzm2nt4Nl2fwPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727908792; c=relaxed/simple;
	bh=QZKoGZh3y6sZfJVuTzq7kxydp6cmBgglYtV1DQ4h9I8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G9/rFzpjLJJb1Qw80mU5JlKTluFXK/mLJbTxSC+9OPwrdNBfAMqitXKzUyn/r65famNfG27hh1ZgZR3U04ImUwtauC7WlsXTIgCE6J7JeRST+oUpUWTNDPinAseSI/yX/kXQPGSRHnet5Cb9GmimQlpOpnTHh2gnb1gPO+PvPic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aId4/bX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aId4/bX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4149FC4CEC5;
	Wed,  2 Oct 2024 22:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727908791;
	bh=QZKoGZh3y6sZfJVuTzq7kxydp6cmBgglYtV1DQ4h9I8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aId4/bX1dtd7cHhelnuC6tW/2Rloe+UR8w1OALbkFnOFFQTJtFWvRKdsvHrpCaX3i
	 wlVHXJzDpeyDmfbHlLg8ary9yfZjrl1L78jPcBil2quVY+sDrqZ3/Dc5QP2ZUeRUpR
	 ecj2IQtM+0pUD8Dq5nEgyrUbfZKZNwguqnA1mOZ7JEPHGHqlSGuW4tXiIm/deFm/LL
	 P/yKevwTyOmCXob+sI35MO9PJat1yJBM8sTRyCOci6GGj7vS2Un7tBGC4dJEijFMI9
	 h0lV/US1iDrG874vRQOtXZKkwmVx70LL+V1Nr2DmpF5sGn1Sob/2mwTYH2wdzxWLE/
	 rZAQM1nKq7W4w==
Message-ID: <7f2ae124-e98c-4360-8ab8-654a197751f9@kernel.org>
Date: Thu, 3 Oct 2024 07:39:43 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/11] scsi: Rename .slave_alloc() and .slave_destroy()
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
 Soumya Negi <soumya.negi97@gmail.com>, Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Avri Altman <avri.altman@wdc.com>, Andrew Halaney <ahalaney@redhat.com>,
 Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
References: <20241002203528.4104996-1-bvanassche@acm.org>
 <20241002203528.4104996-7-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241002203528.4104996-7-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/3/24 05:33, Bart Van Assche wrote:
> Rename .slave_alloc() into .sdev_prep() and .slave_destroy() into

"sdev_init" or "sdev_initialize" may be a better name instead of "sdev_prep",
which does not really convey what the call will be preparing for. Also, "prep"
not being fully spelled out may confuse some people.

Thoughts ?

Other than that, looks good to me.


-- 
Damien Le Moal
Western Digital Research
