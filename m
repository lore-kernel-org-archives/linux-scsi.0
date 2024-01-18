Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A471DFC2;
	Thu, 18 Jan 2024 18:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705603230; cv=none; b=aOzFaiXpAHpoLfZmybruSYkyCQki842siYBaJ/qrAz8EmprV/OeJ11meHmzj0QoQr2Nx1fNQnhkr9HOeedEKfK0GbKkR1/V+rCR3OXQaRXh/C0wAaq5JiC1+d2vA5PCY/fHYcfiXp1k/D0JziRj1K1zmGsWREoQtbludQWKE39A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705603230; c=relaxed/simple;
	bh=R+qXdiiWp2IDGceImUHkpInR05UJDNVs+WU06srsRdc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=StX6YT7TgAhFxiRxPTF4EHi9CwzmfWlZjNKmBXgtzKRSFgBYO5SXQhmSiWWqucNx8i4hTESRvktxpwZLTJejtgSxhh4zeMW9cwXkg39G9+WF6vb/zZRzSvMOUO2hFzvtcUGzv4/rHkcg4hEzYZU/IK4CBZNADSZsg9OFXM8NH9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6dbb003be79so491758b3a.0;
        Thu, 18 Jan 2024 10:40:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705603228; x=1706208028;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+MCLp+tJNO+etgZgVlXIoBK5XGWALOsHRdh/oS9zFfk=;
        b=HJigZ2biG1JF1TYE9M/T9+KDHJY9IVAmV0zO22KECcA+ZPJ7tQI/zVQi5hkoO5UejA
         QDG5shUzZnoJPg3qY+4Ca8VGNOPxGZal4/qMc5uIUzFJ0oKpcQycJOqp9ltFxAVy49F5
         O4+bcJ0jzP7ZOLQJM0CzSAMSrx5q8O6/Wc3b2cvkvdYMoEE97tvtRDQH0+BV84fnttBs
         ZLbwfritylthSER9RvZ5M54yjszxcE+OQ2wUYNBCjtUCSu1UasBQa+9sOWEkDGQXTO/+
         9VbTzhXP8wdIWp0Asew9J67WOLCq8a2ZM7zDSRD29eRsZZMaROPY1nQVE2IDwSui8Ysx
         P2ng==
X-Gm-Message-State: AOJu0Yy10k5lmimVJ8LFvDHCqOD2XDz+mGKEglisRaeDgT535PxvyhEE
	xfoPvLqQPIApt9HJlH/ZaLffaiFG7b/rmhe7XbgupJqGEMiXMONA
X-Google-Smtp-Source: AGHT+IFFbdqddGbUMGL/psSILR5HML69qSIrd0fLtezJ/Wh8vNQFJPKRCGHup2ka7EbMAKOwoe4opA==
X-Received: by 2002:a05:6a21:9187:b0:19a:8770:9944 with SMTP id tp7-20020a056a21918700b0019a87709944mr3613133pzb.31.1705603228535;
        Thu, 18 Jan 2024 10:40:28 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:718b:ab80:1dc2:cbee? ([2620:0:1000:8411:718b:ab80:1dc2:cbee])
        by smtp.gmail.com with ESMTPSA id 13-20020a63194d000000b005cdb499acd0sm1905982pgz.42.2024.01.18.10.40.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jan 2024 10:40:27 -0800 (PST)
Message-ID: <434b771a-7873-4c53-9faa-c5dbc4296495@acm.org>
Date: Thu, 18 Jan 2024 10:40:26 -0800
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
References: <c1658336-f48e-5688-f0c2-f325fd5696c3@huaweicloud.com>
 <1d3866af-ffca-4f97-914d-8084aca901ab@acm.org>
 <69b17db7-e9c9-df09-1022-ff7a9e5e04dd@huaweicloud.com>
 <20240112043915.GA5664@lst.de>
 <2d83fcb3-06e6-4a7c-9bd7-b8018208b72f@huaweicloud.com>
 <20240115055940.GA745@lst.de>
 <0d23e3d3-1d7a-f76b-307b-7d74b3f91e05@huaweicloud.com>
 <f1cac818-8fc8-4f24-b445-d10aa99c04ba@acm.org>
 <e0305a2c-20c1-7e0f-d25d-003d7a72355f@huaweicloud.com>
 <aedc82bc-ef10-4bc6-b76c-bf239f48450f@acm.org>
 <20240118073151.GA21386@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240118073151.GA21386@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/17/24 23:31, Christoph Hellwig wrote:
> On Tue, Jan 16, 2024 at 09:36:27AM -0800, Bart Van Assche wrote:
>> My concern is that the complexity of the algorithm introduced by that patch
>> series is significant. I prefer code that is easy to understand. This is why
>> I haven't started yet with a detailed review. If anyone else wants to review
>> that patch series that's fine with me.
> 
> Given that simply disabling fair sharing isn't going to fly we'll need
> something more complex than that.
> 
> The question is how much complexity do we need, and for that it would
> be good to collect the use cases first.

Hi Christoph,

Patch "[PATCH v6 2/4] scsi: core: Make fair tag sharing configurable in
the host template" of this series can be dropped by making the UFS
driver call blk_mq_update_fair_sharing() directly.

So far two use cases have been identified: setups with an UFSHCI 3.0
host controller and ATA controllers for which all storage devices have
similar latency characteristics. Both storage controllers have a queue
depth limit of 32 commands.

It seems to me that disabling fair sharing will always result in better
performance than any algorithm that realizes fair sharing (including the
current algorithm). Only a single boolean needs to be tested to 
determine whether or not fair sharing should be disabled. Any fair 
sharing algorithm that we can come up with will be significantly more 
complex than testing a single boolean. I think this is a strong argument 
for adding support for disabling fair sharing.

If anyone wants to improve the fair sharing algorithm that's fine with 
me. However, I do not plan to work on this myself.

Thanks,

Bart.
