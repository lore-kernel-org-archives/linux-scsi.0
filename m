Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BDE22AE6D;
	Fri,  2 May 2025 08:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.154.21.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746175448; cv=none; b=tEwIoNvw5XvETPLq39oAh+1QYhylMdSnig9rZqgrT4h/AgDzCy8vq5t2pnYdU7XtFHFJ9Fma43qDlf5D5nIjqc0Bsd0Qv0GJ1j/H184LPWCUb8NoJzHiQdhzoVM1uHTwnl9D1hMSUPWiatOhAP3FaCoXI12xAL0qpD9RaYRUzJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746175448; c=relaxed/simple;
	bh=SheY0x0gbNoDFM4PVTpQwRqnRbwOjioKqMfzBcMGfUk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=bMpNbsOP4oV+4IQ+8iY/lZ1oHZInWcq/TfiQwTj6dMRa5fsHcP9TJoZU53/YjHc2Cw7zTvZgXqbSau48KsK/Pdg++Rw2/pk4saI3b+pUEkIZh6wXHZ8SF+SiCYdHuV6SRA/gPj5TwMEShWYQaFPiTDIjKIDfFe9KN9xXc025hU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru; spf=pass smtp.mailfrom=omp.ru; arc=none smtp.client-ip=90.154.21.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omp.ru
Received: from [192.168.2.102] (213.87.139.230) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Fri, 2 May
 2025 11:43:31 +0300
Message-ID: <61fe4e0f-9b33-4338-9fbd-57a85d413346@omp.ru>
Date: Fri, 2 May 2025 11:43:31 +0300
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: remove block layer bounce buffering
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>, "Juergen E. Fischer"
	<fischer@norbit.de>, Alan Stern <stern@rowland.harvard.edu>, Andrew Morton
	<akpm@linux-foundation.org>, <linux-block@vger.kernel.org>,
	<linux-scsi@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	<usb-storage@lists.one-eyed-alien.net>, <linux-mm@kvack.org>
References: <20250502064930.2981820-1-hch@lst.de>
Content-Language: en-US
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
In-Reply-To: <20250502064930.2981820-1-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 6.1.1, Database issued on: 05/02/2025 08:23:12
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 19
X-KSE-AntiSpam-Info: Lua profiles 193072 [May 02 2025]
X-KSE-AntiSpam-Info: Version: 6.1.1.11
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 56 0.3.56
 52db7f275cc9b6820389ba9ab2ac225370e1c244
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_phishing_log_reg_50_60}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: {Found in DNSBL: 213.87.139.230 in (user)
 b.barracudacentral.org}
X-KSE-AntiSpam-Info:
	127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;omp.ru:7.1.1
X-KSE-AntiSpam-Info: {Tracking_ip_hunter}
X-KSE-AntiSpam-Info: FromAlignment: s
X-KSE-AntiSpam-Info: ApMailHostAddress: 213.87.139.230
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 19
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 05/02/2025 08:26:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 5/2/2025 6:29:00 AM
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit

On 5/2/25 9:49 AM, Christoph Hellwig wrote:

[...]

> Diffstat:
>  b/arch/mips/configs/gcw0_defconfig  |    1 
>  b/block/Makefile                    |    1 
>  b/block/blk-map.c                   |    5 
>  b/block/blk-mq.c                    |    2 
>  b/block/blk-settings.c              |    5 
>  b/block/blk.h                       |   17 --
>  b/drivers/base/node.c               |    2 
>  b/drivers/scsi/Kconfig              |    3 
>  b/drivers/scsi/aha152x.c            |    1 
>  b/drivers/scsi/imm.c                |    1 
>  b/drivers/scsi/ppa.c                |    1 
>  b/drivers/scsi/scsi_lib.c           |    3 
>  b/drivers/usb/storage/usb.c         |   14 +
>  b/fs/proc/meminfo.c                 |    3 
>  b/include/linux/blk_types.h         |    1 
>  b/include/linux/blkdev.h            |    5 
>  b/include/linux/mmzone.h            |    1 
>  b/include/scsi/scsi_host.h          |    2 
>  b/include/trace/events/block.h      |   15 --
>  b/include/uapi/linux/blktrace_api.h |    2 
>  b/kernel/trace/blktrace.c           |    9 -
>  b/mm/show_mem.c                     |    4 

   Hm, your diffstat looks borked... :-)

>  block/bounce.c                      |  267 ------------------------------------
>  23 files changed, 19 insertions(+), 346 deletions(-)

MBR, Sergey

