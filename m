Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB23D18C792;
	Mon, 25 Mar 2024 07:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711351623; cv=none; b=Z4GuFBuhB6fmZrwR+6IAm9TtTm/abURittgAJPDEbvNmCTZsnYZ/Vlaw2HCrD0sjs9of4piZLNcNdYfAH/d7wzuthIdQpq3x1Y3U0PL7xTSOhAzQmF1UkTD8BTiQkE9pY66ml03OzGOzRCHZlmk8SBrrRbvBTb6CbvYD29SKM+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711351623; c=relaxed/simple;
	bh=0tzakfE76KWoDDiUjOG1vag1jOkRfq3q7Ivpq8ckM2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i/Jp+71aF+UQqovkjF9EaIzBRmKQxrVohN3z2fS0/03lW0VZqvREKT0LVDMLpyCzjyX3uAVbwYoaCUEow5NcSI3aYUc2SAPb0a9Jh1RUFORGrI3dRFACNgIhfEBrnLNBdtgCi2ZiAgEYX3h4ylD24QZ+uF8e/A9Pt9GT8YSPbek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=knq/N6Eb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="knq/N6Eb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25CBC433F1;
	Mon, 25 Mar 2024 07:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711351623;
	bh=0tzakfE76KWoDDiUjOG1vag1jOkRfq3q7Ivpq8ckM2k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=knq/N6EbC4cBc3ZbKDtVEqKBHHsXJIUUVvhNlFrKkOal7b4LG60CIzqWqWVMvl3VJ
	 rB3KsKHE8MSzpW1nqGZXX7ImBiflU2ngEb1KlUiBvCRbnwSUhAVDozAmJSZVyU+K4o
	 18UvviO6JaxM+Kq3DBzKAtE7moyDqQ9cNzmgvn/g+MK0mjXnUmYf9U9Cz+7+vqegNN
	 yPcG1baS+ESupeRJyvZzLf/SljDrDuRvoG0gayCS6tqbpPzttUe+klaQY6w6LI1VPJ
	 sJuzeQ+/rQ8wBiVbfrsTrpn6rV+cpZx2HfD769unSN1GAEX2QjXXG8nH90XCbDtQNn
	 hLFrM0TEefc1g==
Message-ID: <80162a6e-12d1-4fd4-ac74-dc5388853323@kernel.org>
Date: Mon, 25 Mar 2024 16:26:55 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/23] scsi: add a no_highmem flag to struct Scsi_Host
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Niklas Cassel <cassel@kernel.org>,
 Takashi Sakamoto <o-takashi@sakamocchi.jp>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 "Juergen E. Fischer" <fischer@norbit.de>,
 Xiang Chen <chenxiang66@hisilicon.com>,
 HighPoint Linux Team <linux@highpoint-tech.com>,
 Tyrel Datwyler <tyreld@linux.ibm.com>, Brian King <brking@us.ibm.com>,
 Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
 Mike Christie <michael.christie@oracle.com>,
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Jack Wang <jinpu.wang@cloud.ionos.com>, Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Bart Van Assche <bvanassche@acm.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
 MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com,
 mpi3mr-linuxdrv.pdl@broadcom.com, linux-samsung-soc@vger.kernel.org,
 linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20240324235448.2039074-1-hch@lst.de>
 <20240324235448.2039074-7-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240324235448.2039074-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/25/24 08:54, Christoph Hellwig wrote:
> While we really should be killing the block layer bounce buffering ASAP,
> I even more urgently need to stop the drivers to fiddle with the limits
> from ->slave_configure.  Add a no_highmem flag to the Scsi_Host to
> centralize this setting and switch the remaining four drivers that use
> block layer bounce buffering to it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

The USB hunks could probably be moved to their own patch following this one ?
But otherwise, looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

