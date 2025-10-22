Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFE12D8375;
	Wed, 22 Oct 2025 18:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761157607; cv=none; b=ZZjpZ3lmP/3hp0zWWL/A7hCCaTWxw0KJfAuXIK27V4EqdoTMfYOGXuKKqQkxQLE3FOrZXsxJwf2yY0d1r7PD/jsq6yW0Qg0wCzXGCRyPA/5wUJHOmp6vVCbmUfggXhCkK4RBU9LkA9QmWv8X0Ipc2leWCCqHMYn5L08Qv/qL560=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761157607; c=relaxed/simple;
	bh=CSCZN7ulV5+NOwxCNgk4dEmAyE6vdN9HLvn4abbjaUw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HPDGd0BHHtYG3drPNOQjARGyu21nuH0ojoLwwFLU+aakaUsxT1Onv3ALrDcMz6js9H56PHqIb/xZXbOs+koHfVOAScUwzFWvN8DRpycqYAupWarSeCjdh9sAdshYovnAd+4akAowyw+E4SM5LNiWCtDzKh1MWB1CwTZM713y4gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=GAjsHgao; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="GAjsHgao"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4csHgR5ByDzm0yVW;
	Wed, 22 Oct 2025 18:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761157600; x=1763749601; bh=dUKLA0xDwfcY34m0BcuKhadr
	/WHaBU+NXv8amr/priM=; b=GAjsHgaotaRu8NKgNopJ7al2G6TLmVV+L6/B0+JY
	4cR3/SWLxMi54vvocdTZmm3DZ0gxOJRo7ovmtsjk2UcStKdQGjfJkri01vdu73D8
	n/07qe7bM7+67qbai7duxtQGpDMgZLAq8ICAe8x6ixn7/8r6a1lTzylcvHbAfIFs
	B7vxRnqjpUD61weGXJWepC06Mq6yskd+JLqpMlc7mJDmuSAhuxh+fr4nvokio2Zz
	4vd9Qu/8VujuyGUXOlcKtHnYqNcBt9Ad3IQ7tsw6z/fo/Rg3puq6AF6ghVz/UWJ6
	UtQmmCPQ5xnWVzcghdOfFEmsWVaI4hOMeISXWBTVtebXuA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id aIt_HerxTxiL; Wed, 22 Oct 2025 18:26:40 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4csHgJ1rR0zm0ysj;
	Wed, 22 Oct 2025 18:26:35 +0000 (UTC)
Message-ID: <03dd02cd-6a08-42ce-9b06-f9968038faee@acm.org>
Date: Wed, 22 Oct 2025 11:26:34 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v25 07/20] block/mq-deadline: Enable zoned write
 pipelining
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20251014215428.3686084-1-bvanassche@acm.org>
 <20251014215428.3686084-8-bvanassche@acm.org>
 <08ce89bb-756a-4ce8-9980-ddea8baab1d1@kernel.org>
 <a1850fbc-a699-4e73-9fb7-48d4734c6dd3@acm.org>
 <136efbd2-babc-4f07-871f-f1464a2ec546@kernel.org>
 <f8c1581f-5337-4473-b2a0-b1e1a9ee206e@acm.org>
 <d667eb93-6ced-4b36-963c-e6906413aee9@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d667eb93-6ced-4b36-963c-e6906413aee9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/25 2:01 PM, Damien Le Moal wrote:
> On 10/21/25 03:28, Bart Van Assche wrote:
>> On 10/17/25 10:31 PM, Damien Le Moal wrote:
>>> Maybe we need to rethink this, restarting from your main use case and why
>>> performance is not good. I think that said main use case is f2fs. So what
>>> happens with write throughput with it ? Why doesn't merging of small writes in
>>> the zone write plugs improve performance ? Wouldn't small modifications to f2fs
>>> zone write path improve things ?
>>
>> F2FS typically generates large writes if the I/O bandwidth is high (100
>> MiB or more). Write pipelining improves write performance even for large
>> writes but not by a spectacular percentage. Write pipelining only
>> results in a drastic performance improvement if the write size is kept
>> small (e.g. 4 KiB).
> 
> But you are talking about high queue dpeth 4K write pattern, right ? And if yes,
> BIO merging in the zone write plugs should generate much larger commands anyway.
> Have you verified that this is working as expected ?

Write pipelining improves performance even if bio merging is enabled
because with write pipelining enabled the Linux kernel doesn't wait for
a prior write to complete before the next write is sent to the storage
device.

>>> If the answers to all of the above is "no/does not work", what about a different
>>> approach: zone write plugging v2 with a single thread per CPU that does the
>>> pipelining without to force changes to other layers/change the API all over the
>>> block layer ?
>>
>> The block layer changes that I'm proposing are small, easy to maintain
>> and not invasive. Using a mutex when pipelining writes only as I
>> proposed in a previous email is a solution that will yield better
>> performance than delegating work to another thread. Obtaining an
>> uncontended mutex takes less than a microsecond. Delegating work to
>> another thread introduces a delay of 10 to 100 microseconds.
>>
>>> Unless you have a neat way to recreate the problem without Zoned UFS devices ?
>>
>> This patch series adds support in both the scsi_debug and null_blk
>> drivers for write pipelining. If the mq-deadline patches from this
>> series are reverted then the attached shell script sporadically reports
>> a write error on my test setup for the mq-deadline test cases.
> 
> I am not trying to check the correctness of your patches. I was wondering if
> there is an easy way to recreate the performance difference you are seeing with
> zoned UFS device easily. E.g. the 4 K write case you are describing above.

Yes, there is an easy way to recreate the performance difference. The
shell script attached to my previous email tests multiple combinations
of I/O schedulers, queue depths and write pipelining enabled/disabled.
The script that I shared disables I/O merging. Even if make the
following changes in that shell script:

--- a/test-pipelining-zoned-writes
+++ b/test-pipelining-zoned-writes
@@ -147,11 +147,11 @@ for mode in "none 0" "none 1" "mq-deadline 0" 
"mq-deadline 1"; do
         # Disable block layer request merging.
         dev="/dev/block/${basename}"
      fi
-    run_cmd "echo 4096 > /sys/class/block/${basename}/queue/max_sectors_kb"
+    #run_cmd "echo 4096 > 
/sys/class/block/${basename}/queue/max_sectors_kb"
      # 0: disable I/O statistics
      run_cmd "echo 0 > /sys/class/block/${basename}/queue/iostats"
      # 2: do not attempt any merges
-    run_cmd "echo 2 > /sys/class/block/${basename}/queue/nomerges"
+    #run_cmd "echo 2 > /sys/class/block/${basename}/queue/nomerges"
      # 2: complete on the requesting CPU
      run_cmd "echo 2 > /sys/class/block/${basename}/queue/rq_affinity"
      for iopattern in write randwrite; do

then I still see a significant performance improvement for the null_blk
driver (command-line option -n):

==== iosched=none preserves_write_order=0 iopattern=write qd=1
   write: IOPS=6503, BW=25.4MiB/s (26.6MB/s)(762MiB/30003msec); 762 zone 
resets
==== iosched=none preserves_write_order=0 iopattern=randwrite qd=1
   write: IOPS=6469, BW=25.3MiB/s (26.5MB/s)(758MiB/30003msec); 758 zone 
resets
==== iosched=none preserves_write_order=1 iopattern=write qd=1
   write: IOPS=5566, BW=21.7MiB/s (22.8MB/s)(652MiB/30010msec); 652 zone 
resets
==== iosched=none preserves_write_order=1 iopattern=write qd=64
   write: IOPS=15.3k, BW=59.9MiB/s (62.8MB/s)(1797MiB/30001msec); 1796 
zone resets
==== iosched=none preserves_write_order=1 iopattern=randwrite qd=1
   write: IOPS=5575, BW=21.8MiB/s (22.8MB/s)(653MiB/30005msec); 653 zone 
resets
==== iosched=none preserves_write_order=1 iopattern=randwrite qd=64
   write: IOPS=15.5k, BW=60.7MiB/s (63.7MB/s)(1821MiB/30001msec); 1821 
zone resets

As one can see above, if the queue depth equals 64 and with write
pipelining enabled, IOPS are about 2.5x higher compared to
queue depth 1 and write pipelining disabled.

Thanks,

Bart.
