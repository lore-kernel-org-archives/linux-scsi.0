Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1B42BEC3A
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 13:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744122; cv=none; b=EsKzVpYimCSfi5hpnMUQHZzKX8jAPs28QnusQTZ+3bUx4H5Yn6EoI5GefwWMeebRkYaS2cd1yeFhLIJEysDMw7ZkJqDfdWwkUDAd5bzpPi6xtC4DXQeCa0xWfolIYObQ0CDtsztkZhJz0C7yprfbW2dmJattyrOKehUphQ9W9N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744122; c=relaxed/simple;
	bh=neA+qO4N+Fv2P3BmyaerIj9k0QPdvSqu0t4ScQkQZ28=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E4hO7W+BVANWKb+AVAkAFJuFzB0+GYhKSD9IkDF3uUkJYOswoC9i5aAXDALvIjBfKSi4KcAXIwXWQ3CCwLV9DZlTdGyg0DkG7NZKXrkDoOuQjRbPKe4tb5CDwLNucMh6SeWoOIiw27gZjA/z8eYoSm0MYAS9Zt+H8E5p3LSSHlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Yw9/53pt; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Yw9/53pt"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cxSZZ6k5Hzm0ySQ;
	Wed, 29 Oct 2025 13:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761744114; x=1764336115; bh=4PC7c8hnWofSH+RPPSnBGwJS
	rif7cfjQY+0egzrh2U4=; b=Yw9/53ptc0RgmP4PjJN98Pt2zH0ofECp/05+Vnm2
	w8AoFJdolluY6KuOMVo7/Q88po7Zj4U9nk5hNSpWFDcqWSX82zVZZrrgJxSUFNLb
	qUJi3eC1O+VZFVceqmxKCMgFR/FPgud31ReFVPIu7WwVJ+HLH8cwiVe1F+p/8wru
	OsAd4dMoD4B+O8v2PQbHxcxJmVQRgsshdsuGqAZq5v8tKrsuJG0k60ZfsEPP8ttg
	75ta10CMii72MUvpoxDuxlr2jCfJd14PVEQDJzmg9NWesi81A354aqp0oe5lHubJ
	xCU8h0+jQ7DNXntJyAT0hY/2BxKSVXblFOqmMXr6d7Ertg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lsR9_DqPQVWd; Wed, 29 Oct 2025 13:21:54 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cxSZ71dFxzm0yVS;
	Wed, 29 Oct 2025 13:21:34 +0000 (UTC)
Message-ID: <9fca8aae-53ec-4509-a728-7c57dba7a549@acm.org>
Date: Wed, 29 Oct 2025 06:21:32 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Revert "Make HID attributes visible"
To: Neil Armstrong <neil.armstrong@linaro.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Daniel Lee <chullee@google.com>,
 Peter Wang <peter.wang@mediatek.com>, Bjorn Andersson
 <andersson@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Huan Tang <tanghuan@vivo.com>, Avri Altman <avri.altman@wdc.com>,
 Liu Song <liu.song13@zte.com.cn>,
 Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Bean Huo <huobean@gmail.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Manivannan Sadhasivam <mani@kernel.org>,
 Gwendal Grignou <gwendal@chromium.org>
References: <20251028222433.1108299-1-bvanassche@acm.org>
 <f596d776-173d-4a04-b005-0d1bb09f7903@linaro.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f596d776-173d-4a04-b005-0d1bb09f7903@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/25 2:43 AM, Neil Armstrong wrote:
>> Fixes: bb7663dec67b ("scsi: ufs: sysfs: Make HID attributes visible")
> 
> Duplicate fixes, but perhaps you could specify this revert is only for 
> v6.18 and the original commit should be backported ?

I think this patch should be backported to all kernels that include
commit bb7663dec67b because that commit may cause UFS attribute creation
to fail for any kernel version.

> Anyway:
> Acked-by: Neil Armstrong <neil.armstrong@linaro.org>

Thanks!

Bart.
