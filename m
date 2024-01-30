Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DF4D26A;
	Tue, 30 Jan 2024 00:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706572996; cv=none; b=ssKT50G0AQrMw173+yrABaKIg+ZTHXOMDiUYKN7xvI2o9M4SGd846jCbXiCAsqI92I0hrOu9oadddST8oZ+zi08D1La7FlrrEc9MboLn+6CfDPPVhHLY2UvQIQb/ydZtT8lXpNM6Q1Dx9d3Mphhz0tY2fOazKjmA3CfBfVXDdIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706572996; c=relaxed/simple;
	bh=YzvajipgNDVEfpV012P54OSNxMk6P5hJCmxp0VDmoG8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DeoplMG3bcZCSkNJMB2RYACgsMyju7SjD3el6FD6u9IC9djb3+53P0LvZhyqAsJrwJ6ncucq3gnseq/Ta9P3E/kzNboDNl2EtITv0YGUlDGdHuNbj7xnTyTLYk2cLybGgeFzGpq1cldzkDp8jMQQMuPBTJgGTpNXhe1wNVSmweQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2901ceb0d33so3284303a91.1;
        Mon, 29 Jan 2024 16:03:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706572995; x=1707177795;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tlYacdDh0BjD03SBQ9Jr1hkagZ9LSai4GApM8/5GKd4=;
        b=A0xMWVEsYzuV5dcM11sxiZ87/Rq6mnqgLGFyqN+W3avoXC+HDgY1rDtmd8i0+Tg0S1
         5F56Gxn2g6tTiBcy+pE+T0RMU+ieWu+zrnbyTOATD/Y/9jrw7EVi0vckLKISYUQvhtL5
         TlzDfcLc3p0L+W8ITI3bs7A3+fru/qs1x5erwpmuckxTT6KAqCiYtERqq68+so7c6YZ7
         n4UYULFG9T36cw5kwMjW73pHXcCpz0VNpzjhgA7Lazfgd6ePjGt1hKNuepWXHxE+wZaX
         EM0b0RfQAl7APUPtfHb+BQZhyVWzrTaybe+o9XXz1pyaGb8ty63cEHvQlmH8d3BLXXj2
         C66Q==
X-Gm-Message-State: AOJu0YwamnoQfyQH9rBsyvismxI1T48Pd9ZN7zDfMm4vNJs7dag6lV2G
	stiPXB9+iKfFWwcfGuforl9icDAIX3oaEnhkLf+snuB1WRoV0at4
X-Google-Smtp-Source: AGHT+IHfpNql38wpyMimcnPMqNnzWLmwZdoT3L7uTwHHV7vRDKz5IUejFZzahrLt6DU2RgGeumEXDA==
X-Received: by 2002:a17:90a:d3d8:b0:290:6de6:5721 with SMTP id d24-20020a17090ad3d800b002906de65721mr122119pjw.32.1706572994472;
        Mon, 29 Jan 2024 16:03:14 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:be5c:5016:50bb:1469? ([2620:0:1000:8411:be5c:5016:50bb:1469])
        by smtp.gmail.com with ESMTPSA id t18-20020a17090a5d9200b002958775b061sm2136639pji.56.2024.01.29.16.03.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jan 2024 16:03:13 -0800 (PST)
Message-ID: <38676388-4c32-414c-a468-5f82a2e9dda4@acm.org>
Date: Mon, 29 Jan 2024 16:03:11 -0800
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
References: <2d83fcb3-06e6-4a7c-9bd7-b8018208b72f@huaweicloud.com>
 <20240115055940.GA745@lst.de>
 <0d23e3d3-1d7a-f76b-307b-7d74b3f91e05@huaweicloud.com>
 <f1cac818-8fc8-4f24-b445-d10aa99c04ba@acm.org>
 <e0305a2c-20c1-7e0f-d25d-003d7a72355f@huaweicloud.com>
 <aedc82bc-ef10-4bc6-b76c-bf239f48450f@acm.org>
 <20240118073151.GA21386@lst.de>
 <434b771a-7873-4c53-9faa-c5dbc4296495@acm.org>
 <20240123091316.GA32130@lst.de>
 <ac240189-d889-448b-b5f7-7d5a13d4316d@acm.org>
 <20240124090843.GA28180@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240124090843.GA28180@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/24/24 01:08, Christoph Hellwig wrote:
> On Tue, Jan 23, 2024 at 07:16:05AM -0800, Bart Van Assche wrote:
>> On 1/23/24 01:13, Christoph Hellwig wrote:
>>> The point is why you think fair sharing is not actually required for
>>> these particular setups only.
>>
>> Do you perhaps want me to move the SCSI host sysfs attribute that controls
>> fair sharing to the /sys/block/${bdev}/queue directory?
> 
> No.  I want an explanation from you why you think your use case is so
> snowflake special that you and just you need to fisable fair sharing.

Hi Christoph,

Would you agree with disabling fair sharing entirely? The use cases that
need fair sharing most are those were different storage types (e.g. hard
disk and SSDs) are connected to the same storage controller. This scenario
often occurs in a cloud computing context. There are better solutions for
cloud computing contexts than fair sharing, e.g. associating different
storage types with different storage controllers. The same approach works
for storage-over-network since storage arrays that have a network connection
usually support to establish multiple connections from a storage initiator
to the storage server.

Thanks,

Bart.


