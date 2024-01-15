Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28652522B;
	Mon, 15 Jan 2024 06:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4TD25b4JR0z4f3lgS;
	Mon, 15 Jan 2024 14:18:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 9FEEA1A0C4C;
	Mon, 15 Jan 2024 14:18:49 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBHZQ5GzqRltzeMAw--.18333S3;
	Mon, 15 Jan 2024 14:18:48 +0800 (CST)
Subject: Re: [PATCH v6 1/4] block: Make fair tag sharing configurable
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>,
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
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <0d23e3d3-1d7a-f76b-307b-7d74b3f91e05@huaweicloud.com>
Date: Mon, 15 Jan 2024 14:18:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240115055940.GA745@lst.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHZQ5GzqRltzeMAw--.18333S3
X-Coremail-Antispam: 1UD129KBjvdXoWrZrykur1kZF4UXw48JryDAwb_yoWktFcE9F
	ZYgr95KwnFvrn2qa1xGrySvrZ7Kay5XFykJa4SqFZ2934fXa13G3ykGr93Z3WxXw4rtF1f
	Gas8J3W7ZrsFqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb3AFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq
	3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/01/15 13:59, Christoph Hellwig Ð´µÀ:
> On Sun, Jan 14, 2024 at 11:22:01AM +0800, Yu Kuai wrote:
>> As you might noticed, Bart and I both met the performance problem in
>> production due to fair tag sharing in the environment that total driver
>> tags is not sufficient. Disable fair tag sharing is a straight way to
>> fix the problem, of course this is not the ideal solution, but make tag
>> sharing configurable and let drivers make the decision if they want to
>> disable it really solve the dilemma, and won't have any influence
>> outside the driver.
> 
> How can the driver make any sensible decision here?  This really looks
> like a horrible band aid.  You'll need to figure out a way to make
> the fair sharing less costly or adaptic.  That might involve making it
> a little less fair, which is probably ok as long a the original goals
> are met.
> 

Yes, I totally agree that make fair sharing adaptic is better, and
actually I tried once but looks like I can't push forward.

Can you take a look at my previous patset if you haven't? And it'll
be great to hear from your comments.

https://lore.kernel.org/all/20231021154806.4019417-1-yukuai1@huaweicloud.com/

Thanks,
Kuai

> 
> .
> 

