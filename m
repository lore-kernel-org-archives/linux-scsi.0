Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9206EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Apr 2022 22:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238046AbiD0WHc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Apr 2022 18:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237994AbiD0WHb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2022 18:07:31 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940CC83000
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 15:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651097059; x=1682633059;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=k/KRkqEEeZaWUZZuh+D9DotGgW9vx5Ww0QkxXdpO5fk=;
  b=Cs5oxypjzg9+0bMVa5xiMXBu4WV5SmobWA/dBya8LQo5DlSwWhfJFrhF
   mG45aFYcZ9intWyjKVh5bqc5MKUGAX8fqlBFPu93CuhSB8vXyY4MNM8Mt
   DUTIN8GoKF1CHQMYrQP2aytgldiYrJvbkmQ+szvnOhEpDCdnQff1fXcad
   fVDtAUufrDIkk1nO/xUTZniGoywspR0jXNntb55RuljpA7vdXEiz8YK/D
   g1/coBDPv6J+8MAVv8KXM9w59Nx6Ijj6zaPwImGcQxl8dxRH4qTsJdp4w
   jWxYX+lY7T0Up49hIszqFbEX+xK5bCQw1eEcUsi8kY6dApMq/rKWhNy7x
   g==;
X-IronPort-AV: E=Sophos;i="5.90,294,1643644800"; 
   d="scan'208";a="198996886"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2022 06:04:17 +0800
IronPort-SDR: cZI53RxN0ACvEDVnhMBQE8PWM5Yw8XGudA9YvAMapqzqEVJITJuSk6X7BHYmm7a7mux3Pbhk6G
 baTUrWNNOHcRMS13Kak4hEoFkepq39oqtk1zw4iujO15hgTeKSlIy3Uuy/DuKdiyKoR90pHefx
 XHcaWuh8etvJ6WbKHRVS0hRgFn5AaBtZ1fMNY315dcYQtm6yfCcaH9wIqry7JiZ9FM25464tK+
 EvfXfb1/V5K7rb3XxFKBz7duyu6+BcyG/ZTGxF4g0gjKhuLVMe73IPjJ0gOP2UkAQqE+Cp6J1j
 0078Wy3fnbv2P8NEnsWsLcjB
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Apr 2022 14:34:26 -0700
IronPort-SDR: 7eKlTVe2JkdieTGuMGKW9t5mwndOSbUMgfIBTQG3lGq7IGXZl8D9zawl26Cmd6Rbv15Q7Nrgtb
 p6M95QDx4je+1DFhtGbrd9WJBwETAqMz+2uLb8LPhul6IKVXWGv1smXFWSHtwjvoEOe+aDvMic
 9ASSOHx8fdOzFnZATOx4sO7l0+u/5lPT8eDnKi9oJbpWaAeEXNAYH/RGj8aoefHB+vvBxVvw5w
 EF620pHMzQDHRAxDaPAiFr1VnBX2Q8QNOGRPwVOKNOKE5pne36ebQFdbiAa1IJJ95Bap0bFDhv
 Mfc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Apr 2022 15:04:17 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KpXpS55Sjz1SVp1
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 15:04:16 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1651097056; x=1653689057; bh=k/KRkqEEeZaWUZZuh+D9DotGgW9vx5Ww0Qk
        xXdpO5fk=; b=XJ6wrs+kAobdXM8x1eOJhySaRTWWcgZ8MHdogngNkCG08lI9Ud8
        4jV/F55UL77kWWyBJ/F0ih/b5sWiQEiAardcinBKUXui8BBXpsBVZP9S4kV3KOyq
        R9nSAE+pezCpFFHdRx+SNXX7VTRzWtJa1ZX0kN+AUcbLvKDKyORZcsp+kMH92XVT
        UJ2vnhS3wP6MjI8Ubt1HM19ozkCE/L8NacyVBg0nbqes4wcDjdf0f33VzqKQu1KP
        YP5kIBu1r2GI8ScnByxSm1CYlrupRkVsiqMcbAdof1eMJu17lqOQUeWEo7oEeK/k
        UUoupyjRZbGzCGgpePTAybdhIsy4PI4THyQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id mq94MxevGwaF for <linux-scsi@vger.kernel.org>;
        Wed, 27 Apr 2022 15:04:16 -0700 (PDT)
Received: from [10.225.163.27] (unknown [10.225.163.27])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KpXpQ3gm7z1Rvlc;
        Wed, 27 Apr 2022 15:04:14 -0700 (PDT)
Message-ID: <0d3b0a6b-825d-1b01-094a-911f81f5f354@opensource.wdc.com>
Date:   Thu, 28 Apr 2022 07:04:13 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v4 02/10] block: Add copy offload support infrastructure
Content-Language: en-US
To:     Nitesh Shetty <nj.shetty@samsung.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        dm-devel@redhat.com, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, nitheshshetty@gmail.com,
        linux-kernel@vger.kernel.org
References: <20220426101241.30100-1-nj.shetty@samsung.com>
 <CGME20220426101921epcas5p341707619b5e836490284a42c92762083@epcas5p3.samsung.com>
 <20220426101241.30100-3-nj.shetty@samsung.com>
 <7d1fdd1e-c854-4744-8bec-7d222fb9be76@opensource.wdc.com>
 <20220427151535.GC9558@test-zns>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220427151535.GC9558@test-zns>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/28/22 00:15, Nitesh Shetty wrote:
> On Wed, Apr 27, 2022 at 11:45:26AM +0900, Damien Le Moal wrote:
>> On 4/26/22 19:12, Nitesh Shetty wrote:
>>> Introduce blkdev_issue_copy which supports source and destination bdevs,
>>> and an array of (source, destination and copy length) tuples.
>>> Introduce REQ_COPY copy offload operation flag. Create a read-write
>>> bio pair with a token as payload and submitted to the device in order.
>>> Read request populates token with source specific information which
>>> is then passed with write request.
>>> This design is courtesy Mikulas Patocka's token based copy
>>>
>>> Larger copy will be divided, based on max_copy_sectors,
>>> max_copy_range_sector limits.
>>>
>>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>>> Signed-off-by: Arnav Dawn <arnav.dawn@samsung.com>
>>> ---
>>>  block/blk-lib.c           | 232 ++++++++++++++++++++++++++++++++++++++
>>>  block/blk.h               |   2 +
>>>  include/linux/blk_types.h |  21 ++++
>>>  include/linux/blkdev.h    |   2 +
>>>  include/uapi/linux/fs.h   |  14 +++
>>>  5 files changed, 271 insertions(+)
>>>
>>> diff --git a/block/blk-lib.c b/block/blk-lib.c
>>> index 09b7e1200c0f..ba9da2d2f429 100644
>>> --- a/block/blk-lib.c
>>> +++ b/block/blk-lib.c
>>> @@ -117,6 +117,238 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>>>  }
>>>  EXPORT_SYMBOL(blkdev_issue_discard);
>>>  
>>> +/*
>>> + * Wait on and process all in-flight BIOs.  This must only be called once
>>> + * all bios have been issued so that the refcount can only decrease.
>>> + * This just waits for all bios to make it through bio_copy_end_io. IO
>>> + * errors are propagated through cio->io_error.
>>> + */
>>> +static int cio_await_completion(struct cio *cio)
>>> +{
>>> +	int ret = 0;
>>> +	unsigned long flags;
>>> +
>>> +	spin_lock_irqsave(&cio->lock, flags);
>>> +	if (cio->refcount) {
>>> +		cio->waiter = current;
>>> +		__set_current_state(TASK_UNINTERRUPTIBLE);
>>> +		spin_unlock_irqrestore(&cio->lock, flags);
>>> +		blk_io_schedule();
>>> +		/* wake up sets us TASK_RUNNING */
>>> +		spin_lock_irqsave(&cio->lock, flags);
>>> +		cio->waiter = NULL;
>>> +		ret = cio->io_err;
>>> +	}
>>> +	spin_unlock_irqrestore(&cio->lock, flags);
>>> +	kvfree(cio);
>>
>> cio is allocated with kzalloc() == kmalloc(). So why the kvfree() here ?
>>
> 
> acked.
> 
>>> +
>>> +	return ret;
>>> +}
>>> +
>>> +static void bio_copy_end_io(struct bio *bio)
>>> +{
>>> +	struct copy_ctx *ctx = bio->bi_private;
>>> +	struct cio *cio = ctx->cio;
>>> +	sector_t clen;
>>> +	int ri = ctx->range_idx;
>>> +	unsigned long flags;
>>> +	bool wake = false;
>>> +
>>> +	if (bio->bi_status) {
>>> +		cio->io_err = bio->bi_status;
>>> +		clen = (bio->bi_iter.bi_sector << SECTOR_SHIFT) - ctx->start_sec;
>>> +		cio->rlist[ri].comp_len = min_t(sector_t, clen, cio->rlist[ri].comp_len);
>>
>> long line.
> 
> Is it because line is more than 80 character, I thought limit is 100 now, so
> went with longer lines ?

When it is easy to wrap the lines without readability loss, please do to
keep things under 80 char per line.


>>> +{
>>> +	struct request_queue *src_q = bdev_get_queue(src_bdev);
>>> +	struct request_queue *dest_q = bdev_get_queue(dest_bdev);
>>> +	int ret = -EINVAL;
>>> +
>>> +	if (!src_q || !dest_q)
>>> +		return -ENXIO;
>>> +
>>> +	if (!nr)
>>> +		return -EINVAL;
>>> +
>>> +	if (nr >= MAX_COPY_NR_RANGE)
>>> +		return -EINVAL;
>>
>> Where do you check the number of ranges against what the device can do ?
>>
> 
> The present implementation submits only one range at a time. This was done to 
> make copy offload generic, so that other types of copy implementation such as
> XCOPY should be able to use same infrastructure. Downside at present being
> NVMe copy offload is not optimal.

If you issue one range at a time without checking the number of ranges,
what is the point of the nr ranges queue limit ? The user can submit a
copy ioctl request exceeding it. Please use that limit and enforce it or
remove it entirely.


-- 
Damien Le Moal
Western Digital Research
