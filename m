Received: from mta0.migadu.com (out-61.mta0.migadu.com [91.218.175.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98BB4BB27D
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 17:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791825523; cv=none; b=nSeS+WqF5qJK00Hb2l5FBCV9havbLtiTmXDwwq5IBZ6h0LpClyTyzOIoTr/PaPGqL9oa8ViuflhFGYE0v/QXk3VwTPJDAUh4Kve/JlPWknm+mb38owhqxQpqjpbTb84akYAnGJQR/gvZhxyEElujJph1x+Bs/DDY/lddWAKdwiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791825523; c=relaxed/simple;
	bh=d03eP187xGbSWIbPy6HH+MeqnuZDuNm3f6i9EOgmTgA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cu1yuKm6N4Nuc9/i0Zr6w5XjaFeY4oPQuIUt3RoFWyTyKL2ZRugLfiIEcRMb6FLhiE9jBrVkzyUidZEJXsLCVLQhUq3JFbrCRIL+Opaj3i2olorYALG6EMNRk0/qWBmlpncmy8b0C1c72Yc8E7yw1ZD367aaIqwy/1iNy0dx1ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xa2F7wlu; arc=none smtp.client-ip=91.218.175.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xa2F7wlu"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=d03eP187xGbSWIbPy6HH+MeqnuZDuNm3f6i9EOgmTgA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791825517; v=1; x=1792430317;
 b=xa2F7wlu0dez0FxvKeuv5fhgf7w+rfPwN70Sb44LskrkEg2LR7zeWpxnMzI48k4NzBFQE2fL
 Y+4Hf4QzVilD7JAXFxrp0XTLqimsYo6Wsh3G1/z2QxFaxND3AyMd2R1jTKDo7n9Ocd3gtI1gWke
 BjWTuNMaRkhSr7IN1LbJD1cc=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id fb79791e952d74ed;
	Mon, 12 Oct 2026 17:18:37 +0000
X-Mizu-Trace-ID: fb79791e952d74ed
X-Migadu-Flow: FLOW_OUT
Message-ID: <6bd7fafe-23b0-41f5-bfa8-5cbfd1ce38a6@linux.dev>
Date: Mon, 12 Oct 2026 18:18:32 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/8] scsi: scsi_debug: Split resp_read_dt0()
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <cover.1791499174.git.bvanassche@acm.org>
 <5336162520371fc22ebde7bd4080a9465908dd2a.1791499174.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <5336162520371fc22ebde7bd4080a9465908dd2a.1791499174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/8/26 23:42, Bart Van Assche wrote:

Reviewed-by: John Garry <john.garry@linux.dev>

> +		ret = __resp_read_dt0(scp, sip, lba, num, ei_lba, &scsi_status);
> +		sdeb_meta_read_unlock(sip);
> +	} else {
> +		ret = __resp_read_dt0(scp, sip, lba, num, ei_lba, &scsi_status);
>   	}
>   
> -	ret = do_device_access(sip, scp, 0, lba, num, 0, false, false);
> -	if (meta_data_locked)
> -		sdeb_meta_read_unlock(sip);
>   	if (unlikely(ret == -1))

I think that ret < 0 is a better check, but this is pre-existing code 
and this is not too important.

> -		return DID_ERROR << 16;
> +		return scsi_status;

