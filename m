Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 835BAC10F27
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 05:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6784A208C4
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 05:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgCKFMs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 01:12:48 -0400
Received: from smtp.infotech.no ([82.134.31.41]:40643 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbgCKFMr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Mar 2020 01:12:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id A451C204237;
        Wed, 11 Mar 2020 06:12:44 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id NECRFvxzq774; Wed, 11 Mar 2020 06:12:37 +0100 (CET)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 0F862204153;
        Wed, 11 Mar 2020 06:12:36 +0100 (CET)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi: avoid repetitive logging of device offline messages
To:     Bart Van Assche <bvanassche@acm.org>,
        "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
References: <20200309181416.10665-1-emilne@redhat.com>
 <b7f3c0d1-0f08-83e2-6df5-8b6a02201ba6@acm.org>
 <c9ebe5ecaff898c848402413d9404b23dfe999e6.camel@redhat.com>
 <ccbaa97a-c946-f235-c7c3-3d9d6bf319c0@acm.org>
 <e13d0e51e83fd2fc5d653633a9cfb74e2b24b5a6.camel@redhat.com>
 <789f1dc7-38bf-eced-85b1-ad22e7d69757@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <70f8c1ab-878c-3574-da10-7b488a772e64@interlog.com>
Date:   Wed, 11 Mar 2020 01:12:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <789f1dc7-38bf-eced-85b1-ad22e7d69757@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-11 12:01 a.m., Bart Van Assche wrote:
> On 2020-03-10 09:44, Ewan D. Milne wrote:
>> On Mon, 2020-03-09 at 19:02 -0700, Bart Van Assche wrote:
>>> On 2020-03-09 13:54, Ewan D. Milne wrote:
>>>> The only purpose of the flag is to try to suppress duplicate messages,
>>>> in the common case it is a single thread submitting the queued I/O which
>>>> is going to get rejected.  If multiple threads submit I/O there might
>>>> be duplicated messages but that is not all that critical.  Hence the
>>>> lack of locking on the flag.
>>>
>>> My concern is that scsi_prep_state_check() may be called from more than
>>> one thread at the same time and that bitfield changes are not thread-safe.
>>
>> Yes, I agree that the flag is not thread-safe, but I don't think that
>> is a concern.  Because if we get multiple rejecting I/O messages until
>> the other threads see the flag change we are no worse off than before,
>> and once the sdev state changes back to SDEV_RUNNING we won't call
>> scsi_prep_state_check() and examine the flag.
> 
> Hi Ewan,
> 
> This is the entire list of bitfields in struct scsi_device:
> 
> 	unsigned removable:1;
> 	unsigned changed:1;
> 	unsigned busy:1;
> 	unsigned lockable:1;
> 	unsigned locked:1;
> 	unsigned borken:1;
> 	unsigned disconnect:1;
> 	unsigned soft_reset:1;
> 	unsigned sdtr:1;
> 	unsigned wdtr:1;
> 	unsigned ppr:1;
> 	unsigned tagged_supported:1;
> 	unsigned simple_tags:1;
> 	unsigned was_reset:1;
> 	unsigned expecting_cc_ua:1;
> 	unsigned use_10_for_rw:1;
> 	unsigned use_10_for_ms:1;
> 	unsigned set_dbd_for_ms:1;
> 	unsigned no_report_opcodes:1;
> 	unsigned no_write_same:1;
> 	unsigned use_16_for_rw:1;
> 	unsigned skip_ms_page_8:1;
> 	unsigned skip_ms_page_3f:1;
> 	unsigned skip_vpd_pages:1;
> 	unsigned try_vpd_pages:1;
> 	unsigned use_192_bytes_for_3f:1;
> 	unsigned no_start_on_add:1;
> 	unsigned allow_restart:1;
> 	unsigned manage_start_stop:1;
> 	unsigned start_stop_pwr_cond:1;
> 	unsigned no_uld_attach:1;
> 	unsigned select_no_atn:1;
> 	unsigned fix_capacity:1;
> 	unsigned guess_capacity:1;
> 	unsigned retry_hwerror:1;
> 	unsigned last_sector_bug:1;
> 	unsigned no_read_disc_info:1;
> 	unsigned no_read_capacity_16:1;
> 	unsigned try_rc_10_first:1;
> 	unsigned security_supported:1;
> 	unsigned is_visible:1;
> 	unsigned wce_default_on:1;
> 	unsigned no_dif:1;
> 	unsigned broken_fua:1;
> 	unsigned lun_in_cdb:1;
> 	unsigned unmap_limit_for_ws:1;
> 	unsigned rpm_autosuspend:1;
> 
> If any thread modifies any of these existing bitfields concurrently with
> scsi_prep_state_check(), one of the two modifications will be lost. That
> is because compilers implement bitfield changes as follows:
> 
> new_value = (old_value & ~(1 << ...)) | (1 << ...);
> 
> If two such assignment statements are executed concurrently, both start
> from the same 'old_value' and only one of the two changes will happen.
> I'm concerned that this patch introduces a maintenance problem in the
> long term. Has it been considered to make 'offline_already' a 32-bits
> integer variable or a boolean instead of a bitfield? I think such
> variables can be modified without discarding values written from another
> thread.

Most of the stuff there is slow moving data, typically set once at device
creation time. The design predates atomic bitops. I can't see why the
addition of an extra bitfield, whose overwriting is not going to cause
a calamity ***, warrants the proposer having the rewrite this patch.

Doug Gilbert


*** setting offline_already effectively invalidates a lot of other bitfields.
     Still, if the offline_already fails to be set, due to a clash
     (with what?), then at worst the warning message is repeated and the
     patch code tries again to set that bitfield.


