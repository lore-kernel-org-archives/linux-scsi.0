Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D9E5FDC1;
	Tue, 23 Jan 2024 15:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706022969; cv=none; b=RXCvwKIw6a6geFLBlWqcpPxq488/Zi2N+ZMm7mCBLe68BLixPU922BqiaDiu5Ga6kLnyNJjMoXWWH0yoeN4OV8Z5QXu6b8JDgE0/hWuUgQV6mUhRqoistatLcP7P2Q99q8F4b0AQXt9pWmyhjDF8890DzJLfXSjAmsSpfy7vSbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706022969; c=relaxed/simple;
	bh=4MN9XPaI8DG5h/Mb5684YL7mALVoD0cvXWChmDz4dxE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n3oZlQM/R+Sr/moi/to1kT33FSOm1Jq2twkZF+2OtsP+R2hKHjVW2p3v989+TD7MGGNh2A/TBt+7XM/Oyvf1fD0vhM5hOGst2j9oqdLKcS+fgZ5DJBRDOQ4dG65zwmXegv+UEmJR6lN5yJQmD61xt3g364y89eyvjsNGc0+xT0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6da4a923b1bso2921201b3a.2;
        Tue, 23 Jan 2024 07:16:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706022968; x=1706627768;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4MN9XPaI8DG5h/Mb5684YL7mALVoD0cvXWChmDz4dxE=;
        b=ewyUShQx9cyMPoIyJ4KSK407ri6hDUuTByaaZtHgmmSefuyraQI6LZAqEgPD6pwScI
         f2T04ofTyZCzdArs/R6xwNPLCTTubJjiyNaW0mNnKpxIzGby0YUedLD4kaBxGF7+grvN
         eW5OtHQP1b08TexsshIi/Cftrj3i8NXjMYBQoOuV0dV/UNspC3s3X2hrgIsLNznBnQwH
         ozr3QgfvZYozYZ1wsQvYtIhQwC29sqMVNjepflYwrNq6yiTHfKxOj1Y1ukTxNH+N7qVY
         VGatJ3PBnbcMxXoNRx4Ob0Y3wpNSd6IrAn7FsGL5JiaH1rwe0jF18wapWHt0XwG3dC4s
         7DNQ==
X-Gm-Message-State: AOJu0YzRnOlYws7lzymiE05qrS4bNI6TeESmqWHAA+Y4G31FwacHHsKk
	liy8uziNqzllzqzkpRf9Qb1XGw2eksj+QLCW4tjI5JgSGVSosWb/
X-Google-Smtp-Source: AGHT+IFp7pMnYH0gktm7QzybFFbhLvtSr7LvguBU3uq+yohXAmjef/mpr/BM6n/KLut6dYDgxALkCQ==
X-Received: by 2002:a05:6a20:7aa1:b0:199:f15e:f8cb with SMTP id u33-20020a056a207aa100b00199f15ef8cbmr2612477pzh.53.1706022967737;
        Tue, 23 Jan 2024 07:16:07 -0800 (PST)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id h10-20020a65638a000000b005c2420fb198sm9026991pgv.37.2024.01.23.07.16.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jan 2024 07:16:07 -0800 (PST)
Message-ID: <ac240189-d889-448b-b5f7-7d5a13d4316d@acm.org>
Date: Tue, 23 Jan 2024 07:16:05 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] block: Make fair tag sharing configurable
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Ed Tsai <ed.tsai@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <69b17db7-e9c9-df09-1022-ff7a9e5e04dd@huaweicloud.com>
 <20240112043915.GA5664@lst.de>
 <2d83fcb3-06e6-4a7c-9bd7-b8018208b72f@huaweicloud.com>
 <20240115055940.GA745@lst.de>
 <0d23e3d3-1d7a-f76b-307b-7d74b3f91e05@huaweicloud.com>
 <f1cac818-8fc8-4f24-b445-d10aa99c04ba@acm.org>
 <e0305a2c-20c1-7e0f-d25d-003d7a72355f@huaweicloud.com>
 <aedc82bc-ef10-4bc6-b76c-bf239f48450f@acm.org>
 <20240118073151.GA21386@lst.de>
 <434b771a-7873-4c53-9faa-c5dbc4296495@acm.org>
 <20240123091316.GA32130@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240123091316.GA32130@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/24 01:13, Christoph Hellwig wrote:
> The point is why you think fair sharing is not actually required for
> these particular setups only.

Hi Christoph,

Do you perhaps want me to move the SCSI host sysfs attribute that controls
fair sharing to the /sys/block/${bdev}/queue directory?

Thanks,

Bart.
