Return-Path: <SRS0=lSD6=YK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2895FA372A
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 21:44:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0174222C1
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 21:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395408AbfJQVok (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Oct 2019 17:44:40 -0400
Received: from smtp.infotech.no ([82.134.31.41]:53199 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395390AbfJQVok (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Oct 2019 17:44:40 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id E019A204172;
        Thu, 17 Oct 2019 23:44:36 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id iBIv1JiQyBJZ; Thu, 17 Oct 2019 23:44:29 +0200 (CEST)
Received: from [10.200.28.124] (unknown [213.52.86.138])
        by smtp.infotech.no (Postfix) with ESMTPA id 178E6204163;
        Thu, 17 Oct 2019 23:44:28 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [RFC][PATCHES] drivers/scsi/sg.c uaccess cleanups/fixes
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAHk-=wgOWxqwqCFuP_Bw=Hxxf9njeHJs0OLNGNc63peNd=kRqw@mail.gmail.com>
 <20191010195504.GI26530@ZenIV.linux.org.uk>
 <CAHk-=wgWRQo0m7TUCK4T_J-3Vqte+p-FWzvT3CB1jJHgX-KctA@mail.gmail.com>
 <20191011001104.GJ26530@ZenIV.linux.org.uk>
 <CAHk-=wgg3jzkk-jObm1FLVYGS8JCTiKppEnA00_QX7Wsm5ieLQ@mail.gmail.com>
 <20191013181333.GK26530@ZenIV.linux.org.uk>
 <CAHk-=wgrWGyACBM8N8KP7Pu_2VopuzM4A12yQz6Eo=X2Jpwzcw@mail.gmail.com>
 <20191013191050.GL26530@ZenIV.linux.org.uk>
 <CAHk-=wjJNE9hOKuatqh6SFf4nd65LG4ZR3gQSgg+rjSpVxe89w@mail.gmail.com>
 <20191016202540.GQ26530@ZenIV.linux.org.uk>
 <20191017193659.GA18702@ZenIV.linux.org.uk>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <e595be1f-8e7e-7e4b-018d-c2364bd36766@interlog.com>
Date:   Thu, 17 Oct 2019 23:44:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191017193659.GA18702@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-10-17 9:36 p.m., Al Viro wrote:
> On Wed, Oct 16, 2019 at 09:25:40PM +0100, Al Viro wrote:
> 
>> FWIW, callers of __copy_from_user() remaining in the generic code:
> 
>> 6) drivers/scsi/sg.c nest: sg_read() ones are memdup_user() in disguise
>> (i.e. fold with immediately preceding kmalloc()s).  sg_new_write() -
>> fold with access_ok() into copy_from_user() (for both call sites).
>> sg_write() - lose access_ok(), use copy_from_user() (both call sites)
>> and get_user() (instead of the solitary __get_user() there).
> 
> Turns out that there'd been outright redundant access_ok() calls (not
> even warranted by __copy_...) *and* several __put_user()/__get_user()
> with no checking of return value (access_ok() was there, handling of
> unmapped addresses wasn't).  The latter go back at least to 2.1.early...
> 
> I've got a series that presumably fixes and cleans the things up
> in that area; it didn't get any serious testing (the kernel builds
> and boots, smartctl works as well as it used to, but that's not
> worth much - all it says is that SG_IO doesn't fail terribly;
> I don't have any test setup for really working with /dev/sg*).
> 
> IOW, it needs more review and testing - this is _not_ a pull request.
> It's in vfs.git#work.sg; individual patches are in followups.
> Shortlog/diffstat:
> Al Viro (8):
>        sg_ioctl(): fix copyout handling
>        sg_new_write(): replace access_ok() + __copy_from_user() with copy_from_user()
>        sg_write(): __get_user() can fail...
>        sg_read(): simplify reading ->pack_id of userland sg_io_hdr_t
>        sg_new_write(): don't bother with access_ok
>        sg_read(): get rid of access_ok()/__copy_..._user()
>        sg_write(): get rid of access_ok()/__copy_from_user()/__get_user()
>        SG_IO: get rid of access_ok()
> 
>   drivers/scsi/sg.c | 98 ++++++++++++++++++++++++++++++++----------------------------------------------------------------
>   1 file changed, 32 insertions(+), 66 deletions(-)

Al,
I am aware of these and have a 23 part patchset on the linux-scsi list
for review (see https://marc.info/?l=linux-scsi&m=157052102631490&w=2 )
that amongst other things fixes all of these. It also re-adds the
functionality removed from the bsg driver last year. Unfortunately that
review process is going very slowly, so I have no objections if you
apply these now.

It is unlikely that these changes will introduce any bugs (they didn't in
my testing). If you want to do more testing you may find the sg3_utils
package helpful, especially in the testing directory:
     https://github.com/hreinecke/sg3_utils

Doug Gilbert


