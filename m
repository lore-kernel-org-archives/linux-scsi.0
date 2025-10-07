Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DAA19AD8B
	for <linux-scsi@vger.kernel.org>; Tue,  7 Oct 2025 01:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759801330; cv=none; b=kMq9APH8zD+8sJphAigaOp8hDFiUx0fp/BmjQRkXwArKCt5ZjR6LqK7JOnGmQd/EyBHF9arwCTKJ4O/Zqto59VvMe95ILt9fD3iSuR8x985ngtIQFPIQaqmHo90wBpSRx5xFSuB+60dYeHSIet7Y3y/3bZFiyfVPP5Booq++Ro4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759801330; c=relaxed/simple;
	bh=dTonZkeP2W8xwq64wKDM7p+9fYOwb5HtyFurNb6VBkA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mXBJWh8iw7vsbpn938WuItb4nAgdZRgtEC441KHZBvlz3Y8P2QoVBwlTJuauTmouN41mkT/9LdJHRLIx+QCYNoZB7aIvOTbBTwiz6OgkTNKu5lH1zRS9LUIMDuBcLaxnA8RuSxPikjqqXmRxz2cZL3PAZ3LH0cg4DpKJnqUlmOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NcLReOUx; arc=none smtp.client-ip=209.85.222.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NcLReOUx"
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-892196f0471so2089392241.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Oct 2025 18:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759801328; x=1760406128; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dTonZkeP2W8xwq64wKDM7p+9fYOwb5HtyFurNb6VBkA=;
        b=NcLReOUxuAHcNn66evN/ubwrP1r+1H4oFCWI37nPALkuwrwJDY54nq+YvWG90SJ2th
         fYeg0rwcPxJxdLcONBipO/zckjQCbmZbSDAOSo7/JTrGV6gi461Fn5g/kz1yYQIJYECS
         /Q3Uy9aeYm3qSM1Fzgy5P4x2INprAcgbu6t2DrjE8+ZgB6jVu7T824l2rau0UEwVth8v
         syHSuYFG+u5Q4z4C1bYT9ho97D0xOmDv/ogRRvlvYWZ6JkJaJIt2anT90LUPdG2otS3S
         ev66T1hyJfcczE3XzldyuxKxQESQqL+kEFLLaNiMtH2xj32DJ+NgVBq6b42kxIHnUbXe
         dDPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759801328; x=1760406128;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dTonZkeP2W8xwq64wKDM7p+9fYOwb5HtyFurNb6VBkA=;
        b=N6pNe31Ac1czQo6+XRlmgQvd9tlAmr7hajNdEsXrWAzERAhFiN1novFyCX/kEotOZn
         jcV5osLFdmMqojGkaVZZv/7oAP9sy5W9Xhlpw47KznxpM7zNHASarYBqQip5NV5i9Urs
         Ud85NKWPWx/MBlrR+je3rq97/1oYSR2cn/DqJa1H0Wbrf+0zjNcytkvfH6Us3igZcGU/
         IRrtMLTXy9mW07bOxjXwnmhscaT7Qgb92529xIzPSnyO9Z1RjTtWs1Emic9jgpW7V5aC
         iv1VHPJJm4VFJ1xy7z3jUsjx4wgbOjcuqSvfv2uTnmdELp3rEhuLd6WXYbrkU9GuICUc
         8XuQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIkPWmGSVeE4WAMuvVxo6rTmaQH1Sdg3zxejJKjH7zDtxcHhrgigLZiHqcJpQXH0LWh3OjJBzf8Dq7@vger.kernel.org
X-Gm-Message-State: AOJu0Yxak1JFYj2k0puwv8aZoTV/hjvZtPFKH7OLp6cUNuX89gG2ZTS6
	Rv7SOntOkEIKYDyf7WPHKlgHDBWx5J7pi7b/IY1cYQ6CX+41K8c4sZ0H
X-Gm-Gg: ASbGnctXiepXXq0sn8oDW2J7ZfRK5PZU6vpC/aMNPpV5T6kI4B2jgSAWYnl1a65D/Q4
	gaZ+epQWZ6bpr9bkTX0RblglpXCJ+BAEB8flT8IhCxLVjpps9pBPBkAEXYDy4KKPRF97hTtph+G
	TMfXnz2JcDDOJ+VLXLVpnmWb1AP5OjWVGmhOXcFf6oIYQKDDBowWreqJ66noF7GtOzrarp1Lp3j
	5Ums/AfA08jnem34WFjLnciBIcZfQYet2nEFcByR3cFKyoNXrm7Q64EnAzI8RJetjoAoup8tCHi
	Us0Tm5z68i2QlQj28GRvXbn8pNqfnq9mgbJ+0Fx/jPdXotSyWiIBzjDFG81ltJs8KoLWDgDWSXQ
	SuUr+hQoMrfArB6eRMEEQwfM/qmwIivj3/SXIS0Dg8ksvqhREKdLQHAbuCt9Ovhc=
X-Google-Smtp-Source: AGHT+IG/CuZVAES3BSHynINML/GYB9ctain2pBZEnoUSZafLAz/JojezFxB/4HIhRy7e/u9iBABY0w==
X-Received: by 2002:a05:6122:3bc9:b0:54a:a874:6e4e with SMTP id 71dfb90a1353d-5524e902014mr4641182e0c.8.1759801327865;
        Mon, 06 Oct 2025 18:42:07 -0700 (PDT)
Received: from [192.168.1.145] ([104.203.11.126])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5523cf64c29sm3436147e0c.20.2025.10.06.18.42.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 18:42:07 -0700 (PDT)
Message-ID: <8135af96-528a-4aca-8e11-7cdf038f1454@gmail.com>
Date: Mon, 6 Oct 2025 21:42:04 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: fix shift out-of-bounds in sg_build_indirect The
 num variable is set to 0. The variable num gets its value from
 scatter_elem_sz. However the minimum value of scatter_elem_sz is PAGE_SHIFT.
 So setting num to PAGE_SIZE when num < PAGE_SIZE.
To: Kshitij Paranjape <kshitijvparanjape@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Doug Gilbert <dgilbert@interlog.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 skhan@linuxfoundation.org, khalid@kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
 stable@vger.kernel.org, syzbot+270f1c719ee7baab9941@syzkaller.appspotmail.com
References: <20251006174658.217497-1-kshitijvparanjape@gmail.com>
Content-Language: en-US
From: David Hunter <david.hunter.linux@gmail.com>
In-Reply-To: <20251006174658.217497-1-kshitijvparanjape@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/6/25 13:46, Kshitij Paranjape wrote:
> Cc: <stable@vger.kernel.org>
> Reported-by: syzbot+270f1c719ee7baab9941@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=270f1c719ee7baab9941
> Signed-off-by: Kshitij Paranjape <kshitijvparanjape@gmail.com>

Hey Kshitij,

the formatting didn't quite work out the way you intended. For the next
version, please try to send it to Shuah and I first.
