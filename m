Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992FD1AACA
	for <linux-scsi@vger.kernel.org>; Mon, 26 Feb 2024 03:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708916852; cv=none; b=ihlSCa92u+UCpRyDxM/PnzS+APzUox++9VO5Z1xI8yMShGMKSmstUrvL6Sl1JEhllADQi+ltS6hjaYcvSrsjUt1EL8S7mZ2Kil58x/3ntzZE8uWGGgU58YxNVl3bbD1yUZWFcBavXEcOwVg0//Zleg3cvLjD+sX6AIuYP3CaIAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708916852; c=relaxed/simple;
	bh=3XiBvgBnwMWprAclPFpE1YqKmbWY+RV1r6goikbZr/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K7i71vZ9CKIhwsoVU7tEHaDgfHWrkkuLObftvA/XvWOL6tPizK7EdUYPE8Qpovpi7weNxvaXsGz2FJLrZqAisIHVxgmIzXMe4ffiabEBdSWQFitr0Kpx7GS9eW0Mo26ujeF1kAcyga/Qyt1Fyx9Rwc0kZaqNJez/l0xjDo2oFmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3bbbc6e51d0so2274538b6e.3
        for <linux-scsi@vger.kernel.org>; Sun, 25 Feb 2024 19:07:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708916849; x=1709521649;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3XiBvgBnwMWprAclPFpE1YqKmbWY+RV1r6goikbZr/Q=;
        b=JAwqM3fX1I+aQfbpuv8y8rtBuwZYd/2qBR4x4gICF7XI8FRAkeQIUz2JZ4FBT9/zKz
         A+QR0Ufw/w3L5wzR/RqY2KYyhlCk93APdAPvn50MRXLoS0uMEYxOhP9wsYRn8FtI/sbE
         vltSpCvRt5TfpQU2noc6SaCokwOs3lZgXCf3C/YmKN/Miobt/5pco7jzo2K0AK71aTo2
         Y89iQdYzQ9ZoobEAYj+6qZc4McdbY9HdFJnRhjbMxiw9i3dEbh3vTdqWxA3bjgkcpPIN
         HnvHd2eTbqmj6q9gZ9dsnXrh4e904TiBfmFukCHMNY7WXthynf6a9WoKPgaibB3VWcW2
         DrRw==
X-Gm-Message-State: AOJu0YxYC2jGq1yfb34Mq9K54UNBw7ksVfF3cla0tE3Z6TlRKPf2T12C
	JN4/dWq/3Fidt/pQ9szAS6OV0XzikYA8624cP7twzaN7Dp++2QhN
X-Google-Smtp-Source: AGHT+IGifIxRh895CxMzceK2kADy5anpEx9TQ8uPqESef2gam6qzRBzNi9rWGu2bZg/oPm/ROJbEtQ==
X-Received: by 2002:a05:6808:1b1f:b0:3c1:944f:2151 with SMTP id bx31-20020a0568081b1f00b003c1944f2151mr5782645oib.56.1708916849537;
        Sun, 25 Feb 2024 19:07:29 -0800 (PST)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id y18-20020a62f252000000b006e52ce4ee2fsm770210pfl.20.2024.02.25.19.07.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Feb 2024 19:07:28 -0800 (PST)
Message-ID: <e338b83b-1bdc-404b-be1a-71e8d2af19ff@acm.org>
Date: Sun, 25 Feb 2024 19:07:25 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/11] Pass data lifetime information to SCSI disk
 devices
Content-Language: en-US
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>,
 Kanchan Joshi <joshi.k@samsung.com>
References: <20240222214508.1630719-1-bvanassche@acm.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240222214508.1630719-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/22/24 13:44, Bart Van Assche wrote:
> UFS vendors need the data lifetime information to achieve good performance.
> Providing data lifetime information to UFS devices can result in up to 40%
> lower write amplification. Hence this patch series that adds support in F2FS
> and also in the block layer for data lifetime information. The SCSI disk (sd)
> driver is modified such that it passes write hint information to SCSI devices
> via the GROUP NUMBER field.

These patches go on top of the vfs.rw branch
(https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/log/?h=vfs.rw).

Bart.

