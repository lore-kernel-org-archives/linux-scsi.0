Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB74E1E86E
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 02:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759716132; cv=none; b=PAAIZ8I1XmzcWJA/3i7h2zGZnU0uy5IHgSQk3Fsg6SL3Ldso3qHfBMN5GnXKvdKgV1N0cGhLRrhFKu4O06JiRavV66k41hobubKmD0MuURSniVHn/MagxlPrPSR5hxLGgq3MB57laUyeZ4utRUYrVtzcb99p6MeZ9NrZGYfOisE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759716132; c=relaxed/simple;
	bh=/I1jrmgI3fD1HLAUZ9ymT3W6rmFEPipe2dLEOvaFS7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lVY9uNpQdwvM3KzVv4qEgREih7gJ9EcS3NS6Q5aZASIJ8OjGbT+8k/LzFQ8Ye1dv8emYqH+XrUfiDTM7MdcpFVPLzci6soG4jNEWffVoOa8kMVdNuSPyUnVzWMRslLHlZf0C/2yTLJGwcoJbpSsHlCRFwcPfRR0iZHQlkSn2NCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=redlOk/r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="redlOk/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93297C4CEF4;
	Mon,  6 Oct 2025 02:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759716131;
	bh=/I1jrmgI3fD1HLAUZ9ymT3W6rmFEPipe2dLEOvaFS7k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=redlOk/rnrA/1qVC95X6h0QZAGDzj8yhY7DYiXep+kt8RoBHwTOHQZ4PtZgiXDXXQ
	 S384nDJe8jXGk5Vo3KY6H/tCU95CvGiIG4NeCOYjW8Fq+0PBvnbylLALxOkP2PSWY2
	 7zD0/ugV6PJuDNIPTd7W+GVDxvXgDMnpIKj4foL5HwkrTM5FhEeBfIZo47lARomWdP
	 YhvH1izKQDYTNzq602Bdg/LU21tjnrzcz2EIODN4iVao3woSYxjfSvsspIg4XSaBgO
	 zWd49RCU8IrRN/zGjLfRSvDjuRqlMaFMpBGIBkui927wBQXOZ1ae3u5PZeyRgfcYug
	 g4/+Ew57OmE2w==
Message-ID: <45a94d0c-89fd-4e39-9c50-a43d5c2a0df1@kernel.org>
Date: Mon, 6 Oct 2025 11:02:09 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/9] scsi: sd: Avoid passing potentially uninitialized
 "sense_valid" to read_capacity_error()
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 hare@suse.de
References: <20251002192510.1922731-1-emilne@redhat.com>
 <20251002192510.1922731-5-emilne@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251002192510.1922731-5-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/3/25 04:25, Ewan D. Milne wrote:
> read_capacity_10() sets "sense_valid" in a different conditional statement prior to
> calling read_capacity_error(), and does not use this value otherwise.  Move the call
> to scsi_sense_valid() to read_capacity_error() instead of passing it as a parameter
> from read_capacity_16() and read_capacity_10().
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
