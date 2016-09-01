From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: Block-level access
Date: Thu, 1 Sep 2016 15:16:06 -0700
Message-ID: <6705ed02-0f22-83d0-159a-c9c4a111a933@sandisk.com>
References: <CAGA4w7nO+mrRwY-Rg0i_O8zBcrNeSS0KurLXN34duR2JJqvEmA@mail.gmail.com>
 <CAGA4w7=eM9+sHMNaCXx5tXCEEyeJp0wb7ZqpAiuW35u+PEiSBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0044.outbound.protection.outlook.com ([104.47.41.44]:59704
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751150AbcIAWQQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Sep 2016 18:16:16 -0400
In-Reply-To: <CAGA4w7=eM9+sHMNaCXx5tXCEEyeJp0wb7ZqpAiuW35u+PEiSBw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex Austin <aaustin@oceantechonline.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

On 09/01/2016 02:48 PM, Alex Austin wrote:
> CC'ing linux-scsi and linux-block.
>
> Also, please CC me in replies.
>
> On Thu, Sep 1, 2016 at 4:43 PM, Alex Austin <aaustin@oceantechonline.com> wrote:
>> Hello,
>> What is the most performant way to directly interface with an attached hard
>> drive? I've so far used read()/write() on /dev/sd_ but I find error handling
>> exceedingly difficult, as I don't always even get errors reported, even if the
>> open() call includes O_DIRECT. I've also used ioctl(SG_IO), but find that it's
>> extremely slow due to the lack of queuing support in the API. Is there a
>> mid-level API that will get me decent error handling while allowing command
>> queuing, or do I just need to make multiple threads all doing separate SG_IO
>> ioctls?

What the most efficient way is to interface is with a hard drive depends 
on the I/O pattern. Are you aware that buffered I/O performs read-ahead? 
Have you already tried to tune the read-ahead setting (blockdev --getra 
/ blockdev --setra)?

BTW, if you need an example of how to queue SG_IO, you are welcome to 
have a look at the fio source code. You will probably be interested in 
the bsg API. See e.g. https://lwn.net/Articles/174469/.

Bart.
