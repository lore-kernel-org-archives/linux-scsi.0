Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22AA7E;
	Tue, 16 Jan 2024 02:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1d3eae5c1d7so47332185ad.2;
        Mon, 15 Jan 2024 18:59:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705373966; x=1705978766;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=biQN8gb1SqcZn7ynbegjiWp8wLmNcKwUworJ4I5gLpY=;
        b=wCTtBsiCP/yTpdWBPc14sU4ClfZltU5Ickhsp5ikXtaQYqtQ2Bj7Yb6F5//vU+q4o3
         7jiEJN/CiDt+yLsixLx2F3+HecQafhWVUpiyDJQ1cnmY4ZeM0GwlyPo9cnAFUbxTJXoe
         feSjf5aqdF2smqifiXO/URY2PPzQXv9FYE3YyL09QXs/QDK1QLBQcXYZ+EXnAKKMB7h+
         9qcT3X7nMC4DEW5KbITNOqCaA8IlpFUphBJoWbF6Yrh+yszODRG78D9BxEvMJGgSQcAw
         wXdzpD/8zYaNPZ85xD2/Y+CURbWGkVDoypal1+q5O7ZslojEy2RD6NAH72jdQ/SQNfZv
         563Q==
X-Gm-Message-State: AOJu0Yw2zuHbeo1eVCrojkmz71dodhQ7gquyizXHXpqx8XLD26hUjRZ/
	36m1TtNiZWqX4hOAfOcvC2A=
X-Google-Smtp-Source: AGHT+IG7y1+5HQXgbcYTh5ThH26ijPtO9n4Ett5uU/bR56zkh0DHW2WUTAcdigQ/K1/1cowj2teWkQ==
X-Received: by 2002:a05:6a20:d70a:b0:19a:e151:e622 with SMTP id iz10-20020a056a20d70a00b0019ae151e622mr1354323pzb.56.1705373966249;
        Mon, 15 Jan 2024 18:59:26 -0800 (PST)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id nc12-20020a17090b37cc00b0028dbd1f7165sm10521402pjb.47.2024.01.15.18.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jan 2024 18:59:25 -0800 (PST)
Message-ID: <f1cac818-8fc8-4f24-b445-d10aa99c04ba@acm.org>
Date: Mon, 15 Jan 2024 18:59:25 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] block: Make fair tag sharing configurable
Content-Language: en-US
To: Yu Kuai <yukuai1@huaweicloud.com>, Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, Ming Lei <ming.lei@redhat.com>,
 Keith Busch <kbusch@kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Ed Tsai <ed.tsai@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20231130193139.880955-1-bvanassche@acm.org>
 <20231130193139.880955-2-bvanassche@acm.org>
 <58f50403-fcc9-ec11-f52b-f11ced3d2652@huaweicloud.com>
 <8372f2d0-b695-4af4-90e6-e35b86e3b844@acm.org>
 <c1658336-f48e-5688-f0c2-f325fd5696c3@huaweicloud.com>
 <1d3866af-ffca-4f97-914d-8084aca901ab@acm.org>
 <69b17db7-e9c9-df09-1022-ff7a9e5e04dd@huaweicloud.com>
 <20240112043915.GA5664@lst.de>
 <2d83fcb3-06e6-4a7c-9bd7-b8018208b72f@huaweicloud.com>
 <20240115055940.GA745@lst.de>
 <0d23e3d3-1d7a-f76b-307b-7d74b3f91e05@huaweicloud.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0d23e3d3-1d7a-f76b-307b-7d74b3f91e05@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/14/24 22:18, Yu Kuai wrote:
> Can you take a look at my previous patset if you haven't? And it'll
> be great to hear from your comments.
> 
> https://lore.kernel.org/all/20231021154806.4019417-1-yukuai1@huaweicloud.com/

Something is missing from the cover letter of that patch series:
measurements that show the impact of that patch series on the maximum
IOPS that can be achieved with the null_blk driver. I'm afraid that the
performance impact of that patch series will be larger than what is 
acceptable.

Thanks,

Bart.

