Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 697EFC433FF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 15:37:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43B2120679
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 15:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfHLPhp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 11:37:45 -0400
Received: from smtp.infotech.no ([82.134.31.41]:37629 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726334AbfHLPhp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Aug 2019 11:37:45 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 20AE220423F;
        Mon, 12 Aug 2019 17:37:43 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RHZPhO4KZTXB; Mon, 12 Aug 2019 17:37:41 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 0C4A6204155;
        Mon, 12 Aug 2019 17:37:39 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v3 17/20] sg: add sg_iosubmit_v3 and sg_ioreceive_v3
 ioctls
To:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, bvanassche@acm.org,
        kbuild test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Tony Battersby <tonyb@cybernetics.com>
References: <20190807114252.2565-1-dgilbert@interlog.com>
 <20190807114252.2565-18-dgilbert@interlog.com>
 <1565392510.17449.18.camel@linux.vnet.ibm.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <048b4ab4-804b-f6ec-c35a-47cd2f8d8cda@interlog.com>
Date:   Mon, 12 Aug 2019 11:37:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1565392510.17449.18.camel@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-08-09 7:15 p.m., James Bottomley wrote:
> On Wed, 2019-08-07 at 13:42 +0200, Douglas Gilbert wrote:
>> Add ioctl(SG_IOSUBMIT_V3) and ioctl(SG_IORECEIVE_V3). These ioctls
>> are meant to be (almost) drop-in replacements for the write()/read()
>> async version 3 interface. They only accept the version 3 interface.
> 
> I don't think we should do this at all.  Anyone who wants to use the
> new async interfaces should use the v4 headers.  As Tony Battersby
> already said, the legacy v3 users aren't going to update, so there's no
> point at all introducing new interfaces for v3.  We simply keep the v3
> only read/write interface until there are no users left and it can be
> eliminated.
Tony Battersby wrote [20190809]:
   "Actually I used the asynchronous write()/read()/poll() sg interface to
   implement RAID-like functionality for tape drives and medium changers,
   in a commercial product that has been around since 2002.  These days our
   products use a lot more disk I/O than tape I/O, so I don't write much
   new code using the sg interface anymore, although that code is still
   there and has to be maintained as needed.  So I don't have any immediate
   plans to use any of the new sgv4 features being introduced, and
   unfortunately I am way too busy to even give it a good review..."

That is quoted in full his post. And here is the only other post from
Tony I can find on this subject, again quoted in full [20190808]:

   "One of the reasons ioctls have a bad reputation is because they can be
   used to implement poorly-thought-out interfaces.  So kernel maintainers
   push back on adding new ioctls.  But the push back isn't about the
   number of ioctls, it is about the poor interfaces.  My advice was that
   in general, to implement a given API, it would be better to add more
   ioctls with a simple interface for each one rather than to add fewer
   extremely complex multiplexing ioctls."

Call me biased but I believe that taken together those posts support
what I am proposing. And I can _not_ see how you deduce: "so there's
no point at all introducing new interfaces for v3" in reference to
Tony's posts.


As I stated in a previous post, I do not consider the sg v3 interface
as legacy. Where simply implemented, I am prepared to implement new
features on both the sg v3 and v4 interfaces. One example of this is
doing command timing in nanoseconds rather than the current default,
which is timing in milliseconds. There is also the new option of not
doing any command timing at all. In my current implementation it would
actually be more code to implement that for the v4 interface but not
for the v3 interface.

Replicating my argument from a previous post:
If the kernel had an API mapping layer that was sensitive to file
descriptors of a "special file" (e.g. "/dev/sg3") then it could map:
     write(sg_fd, &sg_io_v3_obj, sizeof(sg_io_v3_obj))
to
     ioctl(sg_fd, SG_IOSUBMIT_V3, &sg_io_v3_obj)

Plus a similar mapping for read() to ioctl(SG_IORECEIVE_V3). If such
a mapping did exist and was transparent to the user then write()
and read() could be retired from the sg driver.  And I assume that
would get a thumbs up from the kernel security folk.


It was Arnd Bergmann who didn't want ioctl(SG_IOSUBMIT) handling
_both_ the sg v3 and v4 interface objects. That breaks the way
_IOR(W) encodes the object length pointed to by the 3rd argument.
It also makes his 32/64 compatibility ioctl layer more difficult.
Hence SG_IOSUBMIT_V3 was introduced to take the sg v3 interface
leaving ioctl(SG_IOSUBMIT) to handle only the v4 interface. That
change had the added benefit of simplifying and speeding my code
with no further need for this type of ugliness:

         /* copy in rest of sg_io_v4 object */
         if (copy_from_user(hu8arr + SZ_SG_IO_HDR,
                    ((u8 __user *)p) + SZ_SG_IO_HDR,
                    SZ_SG_IO_V4 - SZ_SG_IO_HDR))
             return -EFAULT;

The ioctl(SG_IO) implementation still needs that because it will
accept both the v3 and v4 interfaces for backward compatibility.

Doug Gilbert

