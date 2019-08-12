Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7514C433FF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 16:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF14020679
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 16:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbfHLQdU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 12:33:20 -0400
Received: from mail.cybernetics.com ([173.71.130.66]:48724 "EHLO
        mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfHLQdU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 12:33:20 -0400
X-Greylist: delayed 1123 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Aug 2019 12:33:20 EDT
X-ASG-Debug-ID: 1565626471-0fb3b01884585240001-ziuLRu
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id T1yEvYMmatpCrpxq (version=SSLv3 cipher=DES-CBC3-SHA bits=112 verify=NO); Mon, 12 Aug 2019 12:14:31 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-ASG-Whitelist: Client
Received: from [10.157.2.224] (account tonyb HELO [192.168.200.1])
  by cybernetics.com (CommuniGate Pro SMTP 5.1.14)
  with ESMTPSA id 9049890; Mon, 12 Aug 2019 12:14:31 -0400
Subject: Re: [PATCH v3 17/20] sg: add sg_iosubmit_v3 and sg_ioreceive_v3
 ioctls
To:     dgilbert@interlog.com, James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
X-ASG-Orig-Subj: Re: [PATCH v3 17/20] sg: add sg_iosubmit_v3 and sg_ioreceive_v3
 ioctls
Cc:     martin.petersen@oracle.com, hare@suse.de, bvanassche@acm.org,
        kbuild test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>
References: <20190807114252.2565-1-dgilbert@interlog.com>
 <20190807114252.2565-18-dgilbert@interlog.com>
 <1565392510.17449.18.camel@linux.vnet.ibm.com>
 <048b4ab4-804b-f6ec-c35a-47cd2f8d8cda@interlog.com>
From:   Tony Battersby <tonyb@cybernetics.com>
Message-ID: <500183f3-fb16-77b7-90e0-5c8bb2a021c3@cybernetics.com>
Date:   Mon, 12 Aug 2019 12:14:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <048b4ab4-804b-f6ec-c35a-47cd2f8d8cda@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1565626471
X-Barracuda-Encrypted: DES-CBC3-SHA
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 4046
X-Barracuda-BRTS-Status: 1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/12/19 11:37 AM, Douglas Gilbert wrote:
> On 2019-08-09 7:15 p.m., James Bottomley wrote:
>> On Wed, 2019-08-07 at 13:42 +0200, Douglas Gilbert wrote:
>>> Add ioctl(SG_IOSUBMIT_V3) and ioctl(SG_IORECEIVE_V3). These ioctls
>>> are meant to be (almost) drop-in replacements for the write()/read()
>>> async version 3 interface. They only accept the version 3 interface.
>> I don't think we should do this at all.  Anyone who wants to use the
>> new async interfaces should use the v4 headers.  As Tony Battersby
>> already said, the legacy v3 users aren't going to update, so there's no
>> point at all introducing new interfaces for v3.  We simply keep the v3
>> only read/write interface until there are no users left and it can be
>> eliminated.
> Tony Battersby wrote [20190809]:
>    "Actually I used the asynchronous write()/read()/poll() sg interface to
>    implement RAID-like functionality for tape drives and medium changers,
>    in a commercial product that has been around since 2002.  These days our
>    products use a lot more disk I/O than tape I/O, so I don't write much
>    new code using the sg interface anymore, although that code is still
>    there and has to be maintained as needed.  So I don't have any immediate
>    plans to use any of the new sgv4 features being introduced, and
>    unfortunately I am way too busy to even give it a good review..."
>
> That is quoted in full his post. And here is the only other post from
> Tony I can find on this subject, again quoted in full [20190808]:
>
>    "One of the reasons ioctls have a bad reputation is because they can be
>    used to implement poorly-thought-out interfaces.  So kernel maintainers
>    push back on adding new ioctls.  But the push back isn't about the
>    number of ioctls, it is about the poor interfaces.  My advice was that
>    in general, to implement a given API, it would be better to add more
>    ioctls with a simple interface for each one rather than to add fewer
>    extremely complex multiplexing ioctls."
>
> Call me biased but I believe that taken together those posts support
> what I am proposing. And I can _not_ see how you deduce: "so there's
> no point at all introducing new interfaces for v3" in reference to
> Tony's posts.
>
>
> As I stated in a previous post, I do not consider the sg v3 interface
> as legacy. Where simply implemented, I am prepared to implement new
> features on both the sg v3 and v4 interfaces. One example of this is
> doing command timing in nanoseconds rather than the current default,
> which is timing in milliseconds. There is also the new option of not
> doing any command timing at all. In my current implementation it would
> actually be more code to implement that for the v4 interface but not
> for the v3 interface.
>
> Replicating my argument from a previous post:
> If the kernel had an API mapping layer that was sensitive to file
> descriptors of a "special file" (e.g. "/dev/sg3") then it could map:
>      write(sg_fd, &sg_io_v3_obj, sizeof(sg_io_v3_obj))
> to
>      ioctl(sg_fd, SG_IOSUBMIT_V3, &sg_io_v3_obj)
>
> Plus a similar mapping for read() to ioctl(SG_IORECEIVE_V3). If such
> a mapping did exist and was transparent to the user then write()
> and read() could be retired from the sg driver.  And I assume that
> would get a thumbs up from the kernel security folk.
>
FWIW, my employer will probably continue to use the async sg v3
interface for a long time.  If the read/write syscalls are a security
problem, and if we had ioctl()s that are mostly a drop-in replacement
for them, then we could convert our products over to the new ioctl()s on
our next kernel upgrade without too much work (our products are embedded
devices, so we control the whole software stack).  So if you plan to
deprecate the read/write syscall interface anytime soon, then having
drop-in replacement ioctl()s would be beneficial, even if it can't be
done transparently as Doug suggests.

Tony Battersby
Cybernetics

