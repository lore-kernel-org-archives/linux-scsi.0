Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859767E;
	Tue, 16 Jan 2024 02:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3606f3f2f37so52512965ab.0;
        Mon, 15 Jan 2024 18:52:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705373522; x=1705978322;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N7tvR1Q3RHzMzulD4bSpj5U1m5n+nzH5DyagAiJzppc=;
        b=Tc8KFy4T2009IpQim9qBsjJtYEuH+YOlVzdvdpaFIK2AgY/gs3TVncOEVhQeeUsT7V
         Mm/rUjNJ5q9DxqJn8bGx3RL3WwPfj1DDjq/LVb3hWJ5jvFMGI+WjY6rBuF485B+z4++Q
         355tW/QOPwheJjxsHtigTzRgWxq0m5BJN9bNu8SJyuQzdIr3R08Tcs51tAIY3dvgq4iQ
         OMxrshRY02mGd+oDR3W2/q/y5rqZoaAGOzeYn/6P92Zjpzu/jqi3+4xA68iJH/wtxHIM
         5LuVsZXn6XuXuUJ0qaTWf+luE1RXYUF6syg2I3L6YyfUYAyD83kAHjMz7R56N78tEZam
         ezlw==
X-Gm-Message-State: AOJu0YxLuxf1tjyRlw4yNi08Dc+KYTl1x7GW9q5r8uvgu3YZDgTqlYc1
	QFuvGxuZaiKBFHxnDFCiT1M=
X-Google-Smtp-Source: AGHT+IH2ulFNV/X86qIXqrj6LDvxmJN202EmbQ3K382+iWvWNaI/psgZFiaN9tsvQyGQWVly1XKYfQ==
X-Received: by 2002:a92:d0c5:0:b0:35f:ced5:5555 with SMTP id y5-20020a92d0c5000000b0035fced55555mr5465170ila.25.1705373522456;
        Mon, 15 Jan 2024 18:52:02 -0800 (PST)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id n9-20020a6563c9000000b005c21c23180bsm7748540pgv.76.2024.01.15.18.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jan 2024 18:52:01 -0800 (PST)
Message-ID: <af8517a6-f4cf-4a5d-92b5-4764d3e5db38@acm.org>
Date: Mon, 15 Jan 2024 18:52:00 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] block: Make fair tag sharing configurable
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
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
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240115055940.GA745@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/14/24 21:59, Christoph Hellwig wrote:
> How can the driver make any sensible decision here?  This really looks
> like a horrible band aid.

(just returned from a four day trip)

Hi Christoph,

I agree that in general it is not up to the driver to decide whether or
not fair tag sharing should be disabled. The UFS driver is an exception
because we know that for all UFS use cases the latency for all logical 
units is similar.

> You'll need to figure out a way to make the fair sharing less costly
> or adaptic.  That might involve making it a little less fair, which
> is probably ok as long a the original goals are met.
I disagree. Fair tag sharing is something that should be implemented in
hardware (e.g. in an NVMe controller) rather than in software.
Additionally, I'm convinced that it is impossible to come up with a
better algorithm than the current without slowing down the hot path in
the block layer, something that nobody wants.

Bart.

