Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDA476096;
	Mon, 18 Dec 2023 23:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=interlog.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=interlog.com
Received: from mailpool-fe-01.fibernetics.ca (mailpool-fe-01.fibernetics.ca [208.85.217.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id 5EBFD77124;
	Mon, 18 Dec 2023 23:09:05 +0000 (UTC)
Received: from localhost (mailpool-mx-01.fibernetics.ca [208.85.217.140])
	by mailpool-fe-01.fibernetics.ca (Postfix) with ESMTP id 52B4F244AC;
	Mon, 18 Dec 2023 23:09:05 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
X-Spam-Flag: NO
X-Spam-Score: -0.2
X-Spam-Level:
Received: from mailpool-fe-01.fibernetics.ca ([208.85.217.144])
	by localhost (mail-mx-01.fibernetics.ca [208.85.217.140]) (amavisd-new, port 10024)
	with ESMTP id a7M5-P5R72sS; Mon, 18 Dec 2023 23:09:05 +0000 (UTC)
Received: from [192.168.48.17] (host-104-157-209-188.dyn.295.ca [104.157.209.188])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dgilbert@interlog.com)
	by mail.ca.inter.net (Postfix) with ESMTPSA id 4C1CA244A9;
	Mon, 18 Dec 2023 23:09:04 +0000 (UTC)
Message-ID: <dbfe9ac0-d432-4911-8a47-23d3d6f3811a@interlog.com>
Date: Mon, 18 Dec 2023 18:08:58 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v7 00/19] Pass data lifetime information to SCSI disk
 devices
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Daejun Park <daejun7.park@samsung.com>,
 Kanchan Joshi <joshi.k@samsung.com>
References: <20231218185705.2002516-1-bvanassche@acm.org>
Content-Language: en-CA
From: Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <20231218185705.2002516-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/18/23 13:56, Bart Van Assche wrote:
> Hi Martin,
> 
> UFS vendors need the data lifetime information to achieve good performance.
> Providing data lifetime information to UFS devices can result in up to 40%
> lower write amplification. Hence this patch series that adds support in F2FS
> and also in the block layer for data lifetime information. The SCSI disk (sd)
> driver is modified such that it passes write hint information to SCSI devices
> via the GROUP NUMBER field.
> 
> Please consider this patch series for the next merge window.
> 
> Thank you,
> 
> Bart.
> 
> Changes compared to v6:
>   - Dropped patch "fs: Restore F_[GS]ET_FILE_RW_HINT support".

That leaves us with F_SET_RW_HINT and F_GET_RW_HINT ioctls. Could you please
explain, perhaps with an example, what functionality is lost and what we still
have?


I built the v6 patchset atop Martin's 6.8/scsi-queue branch and it built clean.
My experience with "rc1" branches on my working laptop has been a bit less than
ideal. So also built the v6 patchset atop linux_stable around last Monday and
have been running that without issues on my laptop for a week. Haven't updated
my  linux-stable to lk 6.7.0-rc6 yet but don't expect issues with the v7
patchset.

Doug Gilbert


<snip>
