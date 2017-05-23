From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH blktests v2 3/3] sg/001: add regression test for syzcaller
 generated GPF in sg_read path
Date: Tue, 23 May 2017 08:15:26 -0600
Message-ID: <f278026c-42f6-9022-f72a-84439141f5d7@kernel.dk>
References: <cover.1495201975.git.jthumshirn@suse.de>
 <79600648b662bc8b9e701ff6627986887384585b.1495201975.git.jthumshirn@suse.de>
 <20170522175905.GA17738@vader.DHCP.thefacebook.com>
 <b8de93e9-af4b-d0fc-270e-b938f68688b4@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <b8de93e9-af4b-d0fc-270e-b938f68688b4@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Omar Sandoval <osandov@osandov.com>
Cc: Linux Block Layer Mailinglist <linux-block@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 05/23/2017 12:58 AM, Johannes Thumshirn wrote:
> On 05/22/2017 07:59 PM, Omar Sandoval wrote:
>> This looks much better, thanks! One question for you: is there any value
>> in running this on specific test devices (i.e., changing test() to
>> test_device() and using "$TEST_DEV" instead of a scsi-debug device), or
>> would it be a waste of time since it's just exercising generic code?
> 
> That's just generic code. All I need is a SCSI device so I get a /dev/sg
> device node.
> 
> One could do a check if $TEST_DEV is a SCSI device and have a fall-back
> to scsi_debug if it isn't, but I'm not sure if this isn't just a waste
> of time.

Add some code to the framework that allows you to get the corresponding
SG device for a SCSI block device? Make that part of the prepare, skip
the test if the block device isn't a SCSI dev.


-- 
Jens Axboe
