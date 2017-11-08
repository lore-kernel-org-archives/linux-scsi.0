From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] SCSI: don't get target/host busy_count in
 scsi_mq_get_budget()
Date: Tue, 7 Nov 2017 20:12:07 -0700
Message-ID: <4626c827-879d-aa02-5d30-4c125c7df7c2@kernel.dk>
References: <20171104015534.32684-1-ming.lei@redhat.com>
 <adb7f6bd-bf0d-8176-808b-32a84ac4273a@kernel.dk>
 <1509997522.2409.58.camel@wdc.com> <20171107101546.GA2848@ming.t460p>
 <1510071472.2656.15.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1510071472.2656.15.camel@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "john.garry@huawei.com" <john.garry@huawei.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 11/07/2017 09:17 AM, Bart Van Assche wrote:
> On Tue, 2017-11-07 at 18:15 +0800, Ming Lei wrote:
>> Last time, you didn't mention the target patch for setting its
>> can_queue as 1, so I think you can't reproduce the issue on upstream
>> kernel without out-of-tree patch. Then looks it is another issue,
>> and we are making progress actually.
> 
> If I don't trust a patch I introduce additional tests. The fact that I
> modified the SRP initiator before this hang occurred does not mean that the
> approach of your patch is fine. What this means is that all your patch does
> is to reduce the race window and that there is still a race window.

I agree, reducing the depth to test that specific case is perfectly
valid, it doesn't make the test invalid. It's perfectly possible that
other use cases out there have exactly that configuration. My null_blk
test case is basically the same. But it would be nice if all of this was
out in the open, so everybody is clear on exactly what is being
run/tested.

However, where my trace is hung off getting a scheduler tag, yours seems
to be waiting on IO completion. So not the same fingerprint, which is
worrisome.

-- 
Jens Axboe
