Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F2A29C339
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 02:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755225050; cv=none; b=Wwdsc0+wfUgohsvd3D2i11PnNhGTpaH0li6qNeSTdPBem6fLg10zgdIva/CSVT35DBESHtFhUeO4L0GoVUMbVZ7CbuRL1lViHXM6IhRTmtaL0tStWPrAWLtTiQdzGUwOl0h7Wh7cILNDJ9GnfEXOOWZTGVu5M9Ek6RbzfSUdMF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755225050; c=relaxed/simple;
	bh=eQ+fW0Uw8U5CFrVgdRngtCv+oaPN1DTtTAY7/bx8zHc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qLb0T3ON48sW+ag4LAJ6qlWwYZ7l3vwYgMazDdvU1alMNuzSpo1R65SSz9bXe+Odg+FXfzTOzW4+4mNqM7xmjaJi9yr1ERnCMlp8BpTFggV/AjBZL/PY4L2z7vhVbD0kckLhG05UJg0Zs6uwUrsUlIlG58zA2uC7gMUq1ed10qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E5b/zMo2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E5b/zMo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C64C4CEED;
	Fri, 15 Aug 2025 02:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755225049;
	bh=eQ+fW0Uw8U5CFrVgdRngtCv+oaPN1DTtTAY7/bx8zHc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=E5b/zMo2MuU3HYKR5urUUVWxrTYmYx7/4G3ajhiIc4vZFTcM2CC3OPHAXQAO6EvpQ
	 740ugzh6AwzH8mq5rfsFbzv5OEKa99bAUzfkcnERSEBb/+XuZKkUO2Czh5eaYDLYLz
	 D71lpUy5GiPack7zGo8LL5Xn0Ng3x7e7x7ELYIBLBXjpZkN4bzZ/kgUod3KZxFXsMy
	 JdumayVIyR0mPTj5b5WH0xfUEeao6TTc0PIJ7eybU+TYFVliXVs7cTZ3Fr3bE78f4A
	 9l8v8zaxikTunSpBUmledEZbxtlc28dqrXI4y5P+a72UdjBtcthqBW40rokNr3dQam
	 +RxYBL37vYlqg==
Message-ID: <e4bb4705-d2d1-4f46-934e-8fca993e3dd0@kernel.org>
Date: Fri, 15 Aug 2025 11:30:48 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/10] scsi: pm80xx: Fix array-index-out-of-of-bounds
 on rmmod
To: Niklas Cassel <cassel@kernel.org>, Jack Wang
 <jinpu.wang@cloud.ionos.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Igor Pylypiv <ipylypiv@google.com>,
 Salomon Dushimirimana <salomondush@google.com>
Cc: linux-scsi@vger.kernel.org
References: <20250814173215.1765055-12-cassel@kernel.org>
 <20250814173215.1765055-14-cassel@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250814173215.1765055-14-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/15/25 02:32, Niklas Cassel wrote:
> Since commit f7b705c238d1 ("scsi: pm80xx: Set phy_attached to zero when
> device is gone") UBSAN reports:
>   UBSAN: array-index-out-of-bounds in drivers/scsi/pm8001/pm8001_sas.c:786:17
>   index 28 is out of range for type 'pm8001_phy [16]'
> on rmmod when using an expander.
> 
> For a direct attached device, attached_phy contains the local phy id.
> For a device behind an expander, attached_phy contains the remote phy id,
> not the local phy id.
> 
> I.e. while pm8001_ha will have pm8001_ha->chip->n_phy local phys, for a
> device behind an expander, attached_phy can be much larger than
> pm8001_ha->chip->n_phy (depending on the amount of phys of the expander).
> 
> E.g. on my system pm8001_ha has 8 phys with phy ids 0-7.
> One of the ports has an expander connected.
> The expander has 31 phys with phy ids 0-30.
> 
> The pm8001_ha->phy array only contains the phys of the HBA.
> It does not contain the phys of the expander.
> Thus, it is wrong to use attached_phy to index the pm8001_ha->phy array
> for a device behind an expander.
> 
> Thus, we can only clear phy_attached for devices that are directly
> attached.
> 
> Fixes: f7b705c238d1 ("scsi: pm80xx: Set phy_attached to zero when device is gone")
> Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
