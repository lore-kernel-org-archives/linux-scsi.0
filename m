Received: from mta0.migadu.com (out-242.mta0.migadu.com [91.218.175.242])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E447420479
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 09:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.242
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788513060; cv=none; b=YvY4RXzW+2rWwlY97oqcte2pubHV+YeI8INilvRKKUxfe3t8nriWZNM3KGKbMbaOowb4jE/e6nB9TI+R/FwB4UCFIrK7HJGI9WcvXEHWLY7fVf5GGfPmYUQTHnJQcjp6qNMX/rfWo4DY9Zf4IQ7esZ4ohYCeEjJ1kV3zm3LGakg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788513060; c=relaxed/simple;
	bh=EixJD0FLK8B0+t4s+6rs+lbGcrMhte1W9iamLvJ56yw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rs4xEg4dRrqFkA79mq7QVE/0T1Tsc0l0YgbYHdrC4ufC7Wof4f9zjz+A0xFN5Na4NDF/swJkmAqFjxRuO1JZnGly/3PHFyGuL4npjYeneQ7vb0hwm+TxZRHLd/VQu25L4Pc5u5DM/r1eWRpWLYQXnSr0999BDJt0SP8udq/z0/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hnNNREtU; arc=none smtp.client-ip=91.218.175.242
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hnNNREtU"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=EixJD0FLK8B0+t4s+6rs+lbGcrMhte1W9iamLvJ56yw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788513055; v=1; x=1789117855;
 b=hnNNREtUAsWc++70MWHpCWQ9N094Wh16pO21cNIPbdFrQbJ0riMTSv4k/H8HgPkDIHlQ83bK
 c4QrcZTnDdJbRvwC1/VllqixBTtt5plxBxPkN5DMzADpQ0Yye0NkPGaCDkj4CeiQ2fonE/eBxE7
 R8ydODlV9yQ7jUQ82+hjaFVU=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id df31b10ca0f2cb9b;
	Fri, 04 Sep 2026 09:10:45 +0000
X-Mizu-Trace-ID: df31b10ca0f2cb9b
X-Migadu-Flow: FLOW_OUT
Message-ID: <a547bec0-3600-43f9-bb7b-0a644601a367@linux.dev>
Date: Fri, 4 Sep 2026 10:10:44 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/27] libmultipath: Add delayed removal support
To: sashiko-reviews@lists.linux.dev, John Garry <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
 <20260901104526.3850621-7-john.g.garry@oracle.com>
 <20260901110548.A06911F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260901110548.A06911F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/1/26 12:05, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Setting `delayed_removal_secs` to 0 via sysfs clears the `MPATH_HEAD_QUEUE_IF_NO_PATH` flag but fails to kick the requeue list, leaving already-queued I/Os stranded indefinitely.
> --
> 
> commit 751b8b804bd2a99a7fc5d0ec1509ae11a6846846
> Author: John Garry <john.garry@linux.dev>
> Subject: libmultipath: Add delayed removal support
> 
> This commit adds support for delayed removal of multipath devices, similar
> to NVMe, to keep the disk and cdev present during intermittent periods with
> no available paths. A delayed work callback is utilized to handle the teardown,
> and sysfs helpers are exposed for the driver to configure the duration.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 6b8f6e846987a..fada92bf9754c 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
> 
> [ ... ]
> 
>> @@ -572,6 +620,47 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
>>   }
>>   EXPORT_SYMBOL_GPL(mpath_device_set_live);
> 
> [ ... ]
> 
>> +ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
>> +			const char *buf, size_t count)
>> +{
>> +	unsigned int sec;
>> +	ssize_t ret;
>> +
>> +	ret = kstrtouint(buf, 0, &sec);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	mutex_lock(&mpath_head->lock);
>> +	mpath_head->delayed_removal_secs = sec;
>> +	if (sec)
>> +		set_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
>> +	else
>> +		clear_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
>> +	mutex_unlock(&mpath_head->lock);
>> +
>> +	/*
>> +	 * Ensure that update to MPATH_HEAD_QUEUE_IF_NO_PATH is seen
>> +	 * by its reader.
>> +	 */
>> +	mpath_synchronize(mpath_head);
>> +
>> +	return count;
> 
> [Severity: High]
> When delayed_removal_secs is set to 0, this clears the
> MPATH_HEAD_QUEUE_IF_NO_PATH flag, but does it also need to kick the requeue
> list (e.g., via mpath_schedule_requeue_work())?
> 
> If there are I/Os already placed in mpath_head->requeue_list during a path
> failure while the delay was active, could they remain stranded indefinitely
> once the delay is disabled?

When we set the delayed time to 0, it would not stop an active delayed 
timer. And when that timer does expire, we call mpath_put_disk() which 
flushes the requeue list and the bio eventually fails.

Here's an experiment illustrating this:

# ./ini_iscsi_setup.sh [    9.211689] scsi host6: iSCSI Initiator over 
TCP/IP
[    9.250165] scsi 6:0:0:0: Direct-Access     LIO-ORG  LUN_3 
4.0  PQ: 0 ANSI: 6
[    9.255395] scsi 6:0:0:0: alua: supports implicit and explicit TPGS
[    9.255455] scsi 6:0:0:0: alua: device 
naa.600140505200a986f0043c9afa1fd077 port group 1 rel port 3
[    9.258003] sd 6:0:0:0: Attached scsi generic sg1 type 0
[    9.264014] sd 6:0:0:0: [sda:0] 1228800 512-byte logical blocks: (629 
MB/600 MiB)
[    9.264831] sd 6:0:0:0: [sda:0] Write Protect is off
[    9.265681] sd 6:0:0:0: [sda:0] Mode Sense: 43 00 10 08
[    9.266647] sd 6:0:0:0: [sda:0] Write cache: enabled, read cache: 
enabled, supports DPO and FUA
[    9.274224] sd 6:0:0:0: [sda:0] Preferred minimum I/O size 512 bytes
[    9.274262] sd 6:0:0:0: [sda:0] Optimal transfer size 33550336 bytes
[    9.296286] scsi host7: iSCSI Initiator over TCP/IP
[    9.299653] block sda: Created multipath sysfs link to sda:0
[    9.300475] sd 6:0:0:0: [sda:0] Attached SCSI disk
[    9.301800]  sda: sda1 sda2
[    9.326216] scsi 7:0:0:0: Direct-Access     LIO-ORG  LUN_3 
4.0  PQ: 0 ANSI: 6
[    9.335443] scsi 7:0:0:0: alua: supports implicit and explicit TPGS
[    9.335502] scsi 7:0:0:0: alua: device 
naa.600140505200a986f0043c9afa1fd077 port group 2 rel port 4
[    9.339158] sd 7:0:0:0: Attached scsi generic sg2 type 0
[    9.348487] sd 7:0:0:0: [sda:1] 1228800 512-byte logical blocks: (629 
MB/600 MiB)
[    9.349297] sd 7:0:0:0: [sda:1] Write Protect is off
[    9.349323] sd 7:0:0:0: [sda:1] Mode Sense: 43 00 10 08
[    9.350482] sd 7:0:0:0: [sda:1] Write cache: enabled, read cache: 
enabled, supports DPO and FUA
[    9.355392] sd 7:0:0:0: [sda:1] Preferred minimum I/O size 512 bytes
[    9.355431] sd 7:0:0:0: [sda:1] Optimal transfer size 33550336 bytes
[    9.387632] block sda: Created multipath sysfs link to sda:1
[    9.387722] sd 7:0:0:0: [sda:1] Attached SCSI disk
[    9.499430] udevd[261]: failed to execute '/usr/bin/systemd-run' 
'/usr/bin/systemd-run --no-block --property Default
# echo 20 > 
/sys/devices/virtual/scsi_mpath_disk/scsi_mpath_disk0/sda/delayed_removal_secs
# ./ini_iscsi_teardown.sh
[   37.578323] sd 6:0:0:0: [sda:0] Synchronizing SCSI cache
[   37.585893] scsi 6:0:0:0: alua: Detached
[   37.651743] sd 7:0:0:0: [sda:1] Synchronizing SCSI cache
[   37.667940] scsi 7:0:0:0: alua: Detached
# xfs_io -d -C "pwrite -b 16k -V 1 -D 0 16k" /dev/sda1 &
# [   40.461542] scsi_mpath_disk scsi_mpath_disk0: no usable path - 
requeuing I/O bio=0xffff88811ff4f860
# echo 0 > 
/sys/devices/virtual/scsi_mpath_disk/scsi_mpath_disk0/sda/delayed_removal_secs
# pwrite: Input/output error

> 
>> +}
>> +EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_store);
> 

