Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359172557D
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jan 2024 21:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705526085; cv=none; b=fFp7wvpd2kb/NOLjMG1r9HLBJ+t77+vBhDoJsd0qhgVGnZDcxquLuaVmUeabJbohkCC+7gv3i2C+dPkFA1pvtWkHuZ2146qPj2ak7yHtsqmR8hQ2Nz8ysAEDHqgRrjNdJHmaviA8SxyIhwKAkpHDyVBoQjaEmbG3iY0UYbAwsEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705526085; c=relaxed/simple;
	bh=EYXqg9NonPHowGDAGulyABT8pjbAK8SGoNi7NuDcic0=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:Content-Language:
	 From:To:Cc:References:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding; b=VJLloie7y/E7UYX6Wt3SMRJTFydo4CN1QXlqg5KDj+wGh6yeFU7tUcwdT8dKARjj8pLdXVCV98E2KnWxVNCVY2evXwATNXREYrge2hp5ALswRwL+UhUnhl5/oxnK6D9Ipz5/2iBfuysF4CQlU1Ozy9y0SEraPJ7St/jlndwmpfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JAgL7V6/; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JAgL7V6/"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-36191ee7be4so2128865ab.0
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jan 2024 13:14:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705526083; x=1706130883; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7NlonM47ZL/DaVG1oQ0pMdWoMVzqK9l5NUiiZ/sWieg=;
        b=JAgL7V6/uetEZ7tKsLA+LT9ZyEfJyG277UpK1E/6e3rohMg/ZbO+1UkuMzcfVf2ZXy
         rEpWV9TWNL+zrtTKprmzt4dNWpckqG5u7S/7QKXuykanu7jScDTNyxS7ZoQ2MDtb15Ke
         YSoEG9Tv0WMewMrvufLKKFeaJel92mwnBCiv50vhXx6QpSAlisXu30/yskicYu8qY1OM
         ghF4Nc6eBiifZ2NUNHMV7Uf+jVahA80PnLAwaNhwv5rOlXiT42yN+zRn1shvjhAHKaEz
         BTW+sJXo+QcwkeJ2x7oiWWL8W0q9X8Eh7evE9ts3XbN3p+2Fjxul/XJJPhNG7Pk3zz7B
         V8uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705526083; x=1706130883;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7NlonM47ZL/DaVG1oQ0pMdWoMVzqK9l5NUiiZ/sWieg=;
        b=DAOGEJOXb/2ZYGAZfs/9pJN2hqbwzxt/lS0jw/petkwHLFIydUDivEXWqOusMFxlto
         nH7z4IV7HuyqPa2urb8YW56uT9wHR4PqVIQYXBli2/qixdDavSWiMescDlU4Lz+J0wMk
         rBFOwP5X7cPYnq6IsuZDr0qnzHdKFG82uYicvwf+y2KLqodrx/iFED0Zyc0kEr7SJViS
         YuxXsSEIq0LwBVRIb8eIAmu7YTWv/1xiRLH4t8AdPcq0C0mujHf0enc5gWeP8Y2zAzgu
         vDPOqWqdKTrnq84fuRYsvGD7NYI9iSLvImtTSqIrlrAHK80CpsZdLUf8uJ4AmSOXJhsK
         t77g==
X-Gm-Message-State: AOJu0Yx5Exw1dOWqyBGQrHGKILCA/0EZAy+q3RZgsJBztOhNMEInXOYH
	z30BosX/Pu9KbhCEzufMmiiNsG7yHXONzA==
X-Google-Smtp-Source: AGHT+IG6Rn34LZJ41NucbqmkdsoUihrlcTuf+Vz+HLae2MAYSroiYFWXViZpyUAv5pBL8ScpZdOEvg==
X-Received: by 2002:a05:6e02:1c0f:b0:361:9b07:be with SMTP id l15-20020a056e021c0f00b003619b0700bemr748987ilh.0.1705526083276;
        Wed, 17 Jan 2024 13:14:43 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g14-20020a056e021a2e00b0035d6f8d02d7sm4308292ile.7.2024.01.17.13.14.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jan 2024 13:14:42 -0800 (PST)
Message-ID: <e8c32676-114b-4aaf-8753-5a6d7b04fc4b@kernel.dk>
Date: Wed, 17 Jan 2024 14:14:42 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Improving Zoned Storage Support
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: Bart Van Assche <bvanassche@acm.org>, Damien Le Moal
 <dlemoal@kernel.org>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 Christoph Hellwig <hch@lst.de>
References: <5b3e6a01-1039-4b68-8f02-386f3cc9ddd1@acm.org>
 <cc6999c2-2d53-4340-8e2b-c50cae1e5c3a@kernel.org>
 <43cc2e4c-1dce-40ab-b4dc-1aadbeb65371@acm.org>
 <c38ab7b2-63aa-4a0c-9fa6-96be304d8df1@kernel.dk>
 <2955b44a-68c0-4d95-8ff1-da38ef99810f@acm.org>
 <9af03351-a04a-4e61-a6d8-b58236b041a3@kernel.dk>
 <276eedc2-e3d0-40c7-b355-46232ea65662@kernel.dk>
 <39dfcd32-e5fc-45b9-a0ed-082b879a16a4@acm.org>
 <9f4a6b8a-1c17-46b7-8344-cbf4bcb406ab@kernel.dk>
 <207a985d-ad4e-4cad-ac07-961633967bfc@kernel.dk>
In-Reply-To: <207a985d-ad4e-4cad-ac07-961633967bfc@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/17/24 2:02 PM, Jens Axboe wrote:
> On 1/17/24 1:20 PM, Jens Axboe wrote:
>> On 1/17/24 1:18 PM, Bart Van Assche wrote:
>>> On 1/17/24 12:06, Jens Axboe wrote:
>>>> Case in point, I spent 10 min hacking up some smarts on the insertion
>>>> and dispatch side, and then we get:
>>>>
>>>> IOPS=2.54M, BW=1240MiB/s, IOS/call=32/32
>>>>
>>>> or about a 63% improvement when running the _exact same thing_. Looking
>>>> at profiles:
>>>>
>>>> -   13.71%  io_uring  [kernel.kallsyms]  [k] queued_spin_lock_slowpath
>>>>
>>>> reducing the > 70% of locking contention down to ~14%. No change in data
>>>> structures, just an ugly hack that:
>>>>
>>>> - Serializes dispatch, no point having someone hammer on dd->lock for
>>>>    dispatch when already running
>>>> - Serialize insertions, punt to one of N buckets if insertion is already
>>>>    busy. Current insertion will notice someone else did that, and will
>>>>    prune the buckets and re-run insertion.
>>>>
>>>> And while I seriously doubt that my quick hack is 100% fool proof, it
>>>> works as a proof of concept. If we can get that kind of reduction with
>>>> minimal effort, well...
>>>
>>> If nobody else beats me to it then I will look into using separate
>>> locks in the mq-deadline scheduler for insertion and dispatch.
>>
>> That's not going to help by itself, as most of the contention (as I
>> showed in the profile trace in the email) is from dispatch competing
>> with itself, and not necessarily dispatch competing with insertion. And
>> not sure how that would even work, as insert and dispatch are working on
>> the same structures.
>>
>> Do some proper analysis first, then that will show you where the problem
>> is.
> 
> Here's a quick'n dirty that brings it from 1.56M to:
> 
> IOPS=3.50M, BW=1711MiB/s, IOS/call=32/32
> 
> by just doing something stupid - if someone is already dispatching, then
> don't dispatch anything. Clearly shows that this is just dispatch
> contention. But a 160% improvement from looking at the initial profile I

224%, not sure where that math came from...

Anyway, just replying as I sent out the wrong patch. Here's the one I
tested.
 
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index f958e79277b8..133ab4a2673b 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -80,6 +80,13 @@ struct dd_per_prio {
 };
 
 struct deadline_data {
+	struct {
+		spinlock_t lock;
+		spinlock_t zone_lock;
+	} ____cacheline_aligned_in_smp;
+
+	unsigned long dispatch_state;
+
 	/*
 	 * run time data
 	 */
@@ -100,9 +107,6 @@ struct deadline_data {
 	int front_merges;
 	u32 async_depth;
 	int prio_aging_expire;
-
-	spinlock_t lock;
-	spinlock_t zone_lock;
 };
 
 /* Maps an I/O priority class to a deadline scheduler priority. */
@@ -600,6 +604,10 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 	struct request *rq;
 	enum dd_prio prio;
 
+	if (test_bit(0, &dd->dispatch_state) ||
+	    test_and_set_bit(0, &dd->dispatch_state))
+		return NULL;
+
 	spin_lock(&dd->lock);
 	rq = dd_dispatch_prio_aged_requests(dd, now);
 	if (rq)
@@ -616,6 +624,7 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 	}
 
 unlock:
+	clear_bit(0, &dd->dispatch_state);
 	spin_unlock(&dd->lock);
 
 	return rq;

-- 
Jens Axboe

