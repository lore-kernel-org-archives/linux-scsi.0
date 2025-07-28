Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887AA28F1;
	Mon, 28 Jul 2025 00:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753664146; cv=none; b=VLiAT4l3iX4UJhIiuIv9cWJHUdL8jp35odsCNZps9DeAP8mcud1o0faiULFghApMihKt6+wDIA5VkKPdYKwccvn6JWNv0u15Jt6LWOpLzOyJ2IfkJis2U+VPMy97HRa+v9XUW56Auff0MDMs2RcwD+swRMQ7fXFeXuMKTfP268I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753664146; c=relaxed/simple;
	bh=zphoKuraYmovTv/n85IwUuVCW9++NyKt9qxZ4Ah9FBM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Da3ctoyA6eTuSfV434cA/b8xxMuMp8W7jUekjSTXSP2J04hC7Mh5CKRw+ZwmQl/+ePg4pL+caQdhn/RWdbz8/+JLe0K5U9CMtyCInazvE4CQXOie5FjjBBFd1zIrfExGSMo4l8SgB4Bm5BaoyGZhwJyJkmCe7Kp8Ti9flH4Hsxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4br0QG6RnczYQv7S;
	Mon, 28 Jul 2025 08:55:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 94BE31A1058;
	Mon, 28 Jul 2025 08:55:33 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgC3MxSDyoZoEJ_gBg--.34876S3;
	Mon, 28 Jul 2025 08:55:33 +0800 (CST)
Subject: Re: Improper io_opt setting for md raid5
To: Damien Le Moal <dlemoal@kernel.org>,
 =?UTF-8?Q?Csord=c3=a1s_Hunor?= <csordas.hunor@gmail.com>,
 Coly Li <colyli@kernel.org>, hch@lst.de
Cc: linux-block@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <ywsfp3lqnijgig6yrlv2ztxram6ohf5z4yfeebswjkvp2dzisd@f5ikoyo3sfq5>
 <bdf20964-e1ee-45a9-bf24-3396e957ff67@gmail.com>
 <2b22f745-bbd5-4071-be9b-de9e4536f2d5@kernel.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6ab1be6e-380b-d4aa-dd71-f53373a66e29@huaweicloud.com>
Date: Mon, 28 Jul 2025 08:55:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <2b22f745-bbd5-4071-be9b-de9e4536f2d5@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgC3MxSDyoZoEJ_gBg--.34876S3
X-Coremail-Antispam: 1UD129KBjvJXoWrZFWkWrW8AF13XFyfZFWDurg_yoW8JrWxpa
	9rW34qqrnaqF4aqw1DZa1xXrZYyFs5G3W8GFyrtrW29r4qgw1jya4xKrZYq3y7Gr4fCw48
	tr4rWrZ8CF1vvrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AK
	xVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU17KsU
	UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/07/28 8:39, Damien Le Moal 写道:
> md setting its io_opt to 64K*number of drives in the array is strange... It
> does not have to be that large since io_opt is an upper bound and not a "issue
> that IO size for optimal performance". io_opt is simply a limit saying: if you
> exceed that IO size, performance may suffer.
> 

At least from Documentation, for raid arrays, multiple of io_opt is the
prefereed io size to the optimal io performance, and for raid5, this is
chunksize * data disks.

> So a default of stride size x number of drives for the io_opt may be OK, but
> that should be bound to some reasonable value. Furthermore, this is likely
> suboptimal. I woulld think that setting the md array io_opt initially to
> min(all drives io_opt) x number of drives would be a better default.

For raid5, this is not ok, the value have to be chunksize * data disks,
regardless of io_opt from member disks, otherwise raid5 have to issue
additional IO from other disks to build xor data.

For example:

  - write aligned chunksize to one disk, actually means read chunksize
old xor data,then write chunksize data and chunksize new xor data.
  - write aligned chunksize * data disks, new xor data can be build
directly without reading old xor data.

Thanks,
Kuai

