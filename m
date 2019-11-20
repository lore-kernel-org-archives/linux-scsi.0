Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D56CFC432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 03:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 798E42245D
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 03:38:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Zyro+GX7";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="RKKmKl/P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfKTDiX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 22:38:23 -0500
Received: from a27-11.smtp-out.us-west-2.amazonses.com ([54.240.27.11]:33856
        "EHLO a27-11.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727298AbfKTDiW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Nov 2019 22:38:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574221101;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=/Y9Jw0eCh6yzP2uhzb/iJV+JpzMOrFLTIRK7IWJCdpk=;
        b=Zyro+GX7RXRCvEnynbsBTc6ex6pfQvD5e57PQsDoXiWriuM2Jo8pdW2oOZ03usPF
        tJB1RIOsTZyspMlD58D9NpvYN0QOEC3AGzrv2GCqd7B9T4AKQzz+0xUpL3cSO/lCrMN
        ieORm/nsuq0Bcy0HWu6mO7yDl1dw5kezUgLsun/w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574221101;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=/Y9Jw0eCh6yzP2uhzb/iJV+JpzMOrFLTIRK7IWJCdpk=;
        b=RKKmKl/P1o+6y4nxhVAGg+eydppdxiWuB2mWqCV3GCBBEc/P2pbTY9JSpqHHfCme
        4zXMDChOC+jlME5qImOIhGKUetgB7aK/dlsEr2I8OlFLnaP/Vwjfi6PKWVkKlGWU1IE
        HZcStWKWLRe/7Zab6dyoBAmJtbc5hPeEASK11HAU=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 20 Nov 2019 03:38:21 +0000
From:   cang@codeaurora.org
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>, stummala@codeaurora.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [EXT] Re: [PATCH v5 4/4] ufs: Simplify the clock scaling
 mechanism implementation
In-Reply-To: <9d680c52-53b3-f57d-a14b-525810148ad2@acm.org>
References: <20191112173743.141503-1-bvanassche@acm.org>
 <20191112173743.141503-5-bvanassche@acm.org>
 <a26c719466edfd2c41eea789a6c908ab@codeaurora.org>
 <8acd9237-7414-5dce-5285-69ed3ce6f28c@acm.org>
 <BN7PR08MB56843E1941F42BEF8239B895DB760@BN7PR08MB5684.namprd08.prod.outlook.com>
 <ca27868b-9d25-36b9-7548-02252c293905@acm.org>
 <e0ab904e1413ae6a89cebbced22a6cf8@codeaurora.org>
 <5659ab82-a087-4cfb-088e-e25d7f5515a3@acm.org>
 <0101016e822696b5-d1c358be-a0a2-4ef6-b04d-627c1fb361f8-000000@us-west-2.amazonses.com>
 <9d680c52-53b3-f57d-a14b-525810148ad2@acm.org>
Message-ID: <0101016e86e3b802-8deea9e8-6467-454b-9100-e4053515fb3e-000000@us-west-2.amazonses.com>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.11.20-54.240.27.11
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-20 07:16, Bart Van Assche wrote:
> On 11/18/19 9:33 PM, cang@codeaurora.org wrote:
>> Aside the functionality, we need to take this change carefully as it 
>> may relate with performance.
>> With the old implementation, when devfreq decides to scale up, we can 
>> make sure that all requests
>> sent to UFS device after this point will go through the highest UFS 
>> Gear. Scaling up will happen
>> right after doorbell is cleared, not even need to wait till the 
>> requests are freed from block layer.
>> And 1 sec is long enough to clean out the doorbell by HW.
>> 
>> In the new implementation of ufshcd_clock_scaling_prepare(), after 
>> blk_freeze_queue_start(), we call
>> blk_mq_freeze_queue_wait_timeout() to wait for 1 sec. In addition to 
>> those requests which have already
>> been queued to HW doorbell, more requests will be dispatched within 1 
>> sec, through the lowest Gear.
>> My first impression is that it might be a bit lazy and I am not sure 
>> how much it may affect the benchmarks.
>> 
>> And if the request queues are heavily loaded(many bios are waiting for 
>> a free tag to become a request),
>> is 1 sec long enough to freeze all these request queues? If no, 
>> performance would be affected if scaling up
>> fails frequently.
>> As per my understanding, the request queue will become frozen only 
>> after all the existing requests and
>> bios(which are already waiting for a free tag on the queue) to be 
>> completed and freed from block layer.
>> Please correct me if I am wrong.
>> 
>> While, in the old implementation, when devfreq decides to scale up, 
>> scaling can always
>> happen for majority chances, except for those unexpected HW issues.
> 
> Hi Can,
> 
> I agree with the description above of the current behavior of the UFS
> driver. But I do not agree with the interpretation of the behavior of
> the changes I proposed. The implementation in the block layer of
> request queue freezing is as follows:
> 
> void blk_freeze_queue_start(struct request_queue *q)
> {
> 	mutex_lock(&q->mq_freeze_lock);
> 	if (++q->mq_freeze_depth == 1) {
> 		percpu_ref_kill(&q->q_usage_counter);
> 		mutex_unlock(&q->mq_freeze_lock);
> 		if (queue_is_mq(q))
> 			blk_mq_run_hw_queues(q, false);
> 	} else {
> 		mutex_unlock(&q->mq_freeze_lock);
> 	}
> }
> 
> As long as calls from other threads to
> blk_mq_freeze_queue()/blk_mq_unfreeze_queue() are balanced, after
> blk_freeze_queue_start() returns it is guaranteed that
> q->q_usage_counter is in __PERCPU_REF_DEAD mode. Calls to
> blk_get_request() etc. block in that mode until the request queue is
> unfrozen. See also blk_queue_enter().
> 
> In other words, calling blk_freeze_queue() from inside
> ufshcd_clock_scaling_prepare() should preserve the current behavior,
> namely that ufshcd_clock_scaling_prepare() waits for ongoing requests
> to finish and also that submission of new requests is postponed until
> clock scaling has finished. Do you agree with this analysis?
> 
> Thanks,
> 
> Bart.

Hi Bart,

I am still not quite clear about the blk_freeze_queue() part.

>> In the new implementation of ufshcd_clock_scaling_prepare(), after 
>> blk_freeze_queue_start(), we call
>> blk_mq_freeze_queue_wait_timeout() to wait for 1 sec. In addition to 
>> those requests which have already
>> been queued to HW doorbell, more requests will be dispatched within 1 
>> sec, through the lowest Gear.
>> My first impression is that it might be a bit lazy and I am not sure 
>> how much it may affect the benchmarks.

First of all, reg above lines, do you agree that there can be latency in 
scaling up/down
comparing with the old implementation?

I can understand that after queue is frozen, all calls to 
blk_get_request()
are blocked, no submission can be made after this point, due to
blk_queue_enter() shall wait on q->mq_freeze_wq.

<--code snippet-->
wait_event(q->mq_freeze_wq,
            (atomic_read(&q->mq_freeze_depth) == 0 &&
<--code snippet-->

>> And if the request queues are heavily loaded(many bios are waiting for 
>> a free tag to become a request),
>> is 1 sec long enough to freeze all these request queue?

But here I meant those bios, before we call blk_freeze_queue_start(), 
sent through
submit_bio() calls which have already entered blk_mq_get_request() and 
already
returned from the blk_queue_enter_live(). These bios are waiting for a 
free tag
(waiting on func blk_mq_get_tag() when queue is full).
Shall the request queue be frozen before these bios are handled?

void blk_mq_freeze_queue_wait(struct request_queue *q)
{
  	wait_event(q->mq_freeze_wq, percpu_ref_is_zero(&q->q_usage_counter));
}
EXPORT_SYMBOL_GPL(blk_mq_freeze_queue_wait);

Per my understanding, these bios have already increased 
&q->q_usage_counter.
And the &q->q_usage_counter will only become 0 when all of the requests 
in the
queue and these bios(after they get free tags and turned into requests) 
are
completed from block layer, meaning after blk_queue_exit() is called in
__blk_mq_free_request() for all of them. Please correct me if I am 
wrong.

Thanks,

Can Guo.
