Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD560C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 16:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A243020722
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 16:52:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="kObW4YDq";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="kObW4YDq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389721AbgF3Qwr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 12:52:47 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41186 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389698AbgF3Qwr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Jun 2020 12:52:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id A11488EE16A;
        Tue, 30 Jun 2020 09:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1593535966;
        bh=/q1l/DETEEQ6NEwyQ4GIcg7kfuhEPGqB6TCuFiuyl7M=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=kObW4YDqwQrtz8WG5KaQncNPhSuFnA95768PFrEML86kMnfAzW6gwspa4SOyyKek5
         XunK+8Ha2olv/rPBfRT3I4x4+Ug6tP5n0LXRGKJ88uFJ64Q7XG8luPUQEqrZjupA9m
         bAxvIGcSK3GX+Su3CY0CYeQ5+bC6s/uBYDJdhx1o=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aElH3yqf2I_p; Tue, 30 Jun 2020 09:52:46 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 0B78B8EE079;
        Tue, 30 Jun 2020 09:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1593535966;
        bh=/q1l/DETEEQ6NEwyQ4GIcg7kfuhEPGqB6TCuFiuyl7M=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=kObW4YDqwQrtz8WG5KaQncNPhSuFnA95768PFrEML86kMnfAzW6gwspa4SOyyKek5
         XunK+8Ha2olv/rPBfRT3I4x4+Ug6tP5n0LXRGKJ88uFJ64Q7XG8luPUQEqrZjupA9m
         bAxvIGcSK3GX+Su3CY0CYeQ5+bC6s/uBYDJdhx1o=
Message-ID: <1593535964.4124.2.camel@HansenPartnership.com>
Subject: Re: [RFC] scsi: target: tcmu: running 32bit userspace on 64bit
 kernel
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Date:   Tue, 30 Jun 2020 09:52:44 -0700
In-Reply-To: <364c13da-6d4f-c28b-36b3-082db8c3de58@ts.fujitsu.com>
References: <364c13da-6d4f-c28b-36b3-082db8c3de58@ts.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-06-30 at 18:49 +0200, Bodo Stroesser wrote:
> Hi,
> 
> When using tcmu it might happen, that userspace application cannot be
> built as 64 bit program even on a 64 bit host due to existing 32 bit
> libraries that must be used, e.g. for compression, encryption,
> deduplication, ...
> 
> Currently this only works with manual changes in userspace include
> file target_core_user.h due to a missing padding field in
> struct tcmu_cmd_entry.
> 
> Here are field offsets printed by a small program on a 64 bit host,
> compiled as 64 bit program and as 32 bit:
> 
> Devel:~ # gcc -o print_offsets print_offsets.c
> Devel:~ # ./print_offsets
> Offset of tcmu_cmd_entry.hdr.len_op          = 0000
> Offset of tcmu_cmd_entry.hdr.cmd_id          = 0004
> Offset of tcmu_cmd_entry.hdr.kflags          = 0006
> Offset of tcmu_cmd_entry.hdr.uflags          = 0007
> 
> Offset of tcmu_cmd_entry.req.iov_cnt         = 0008
> Offset of tcmu_cmd_entry.req.iov_bidi_cnt    = 000c
> Offset of tcmu_cmd_entry.req.iov_dif_cnt     = 0010
> Offset of tcmu_cmd_entry.req.cdb_off         = 0018
> Offset of tcmu_cmd_entry.req.iov[0]          = 0030
> 
> Offset of tcmu_cmd_entry.rsp.scsi_status     = 0008
> Offset of tcmu_cmd_entry.rsp.read_len        = 000c
> Offset of tcmu_cmd_entry.rsp.sense_buffer[0] = 0010
> 
> Size of struct tcmu_cmd_entry = 0070
> 
> 
> Devel:~ # gcc -m32 -o print_offsets print_offsets.c
> Devel:~ # ./print_offsets
> Offset of tcmu_cmd_entry.hdr.len_op          = 0000
> Offset of tcmu_cmd_entry.hdr.cmd_id          = 0004
> Offset of tcmu_cmd_entry.hdr.kflags          = 0006
> Offset of tcmu_cmd_entry.hdr.uflags          = 0007
> 
> Offset of tcmu_cmd_entry.req.iov_cnt         = 0008
> Offset of tcmu_cmd_entry.req.iov_bidi_cnt    = 000c
> Offset of tcmu_cmd_entry.req.iov_dif_cnt     = 0010
> Offset of tcmu_cmd_entry.req.cdb_off         = 0014
> Offset of tcmu_cmd_entry.req.iov[0]          = 002c
> 
> Offset of tcmu_cmd_entry.rsp.scsi_status     = 0008
> Offset of tcmu_cmd_entry.rsp.read_len        = 000c
> Offset of tcmu_cmd_entry.rsp.sense_buffer[0] = 0010
> 
> Size of struct tcmu_cmd_entry = 0070
> 
> 
> The offset of the fields req.cdb_off and req.iov differ for 64-bit
> and 32-bit compilation.
> 
> That means:
>  - 64-bit application on 64-bit host works well
>  - 32-bit application on 32-bit host works well
>  - 32-bit application on 64-bit host fails.
> 
> Unfortunately I don't see a way to fix this problem such, that
> 32-bit application runs fine on 32-bit and 64-bit host without
> breaking compatibility.
> 
> So I'm wondering whether the following change would be a viable
> solution:
> 
> diff --git a/include/uapi/linux/target_core_user.h
> b/include/uapi/linux/target_core_user.h
> --- a/include/uapi/linux/target_core_user.h
> +++ b/include/uapi/linux/target_core_user.h
> @@ -114,6 +114,9 @@ struct tcmu_cmd_entry {
>  			__u32 iov_cnt;
>  			__u32 iov_bidi_cnt;
>  			__u32 iov_dif_cnt;
> +#ifdef APPL32BIT_ON_KERNEL64BIT
> +			__u32 __pad9;
> +#endif
>  			__u64 cdb_off;
>  			__u64 __pad1;
>  			__u64 __pad2;
> 
> 
> Using this change we can do:
> 
> Devel:~ # gcc -m32 -DAPPL32BIT_ON_KERNEL64BIT -o print_offsets
> print_offsets.c
> Devel:~ # ./print_offsets
> Offset of tcmu_cmd_entry.hdr.len_op          = 0000
> Offset of tcmu_cmd_entry.hdr.cmd_id          = 0004
> Offset of tcmu_cmd_entry.hdr.kflags          = 0006
> Offset of tcmu_cmd_entry.hdr.uflags          = 0007
> 
> Offset of tcmu_cmd_entry.req.iov_cnt         = 0008
> Offset of tcmu_cmd_entry.req.iov_bidi_cnt    = 000c
> Offset of tcmu_cmd_entry.req.iov_dif_cnt     = 0010
> Offset of tcmu_cmd_entry.req.cdb_off         = 0018
> Offset of tcmu_cmd_entry.req.iov[0]          = 0030
> 
> Offset of tcmu_cmd_entry.rsp.scsi_status     = 0008
> Offset of tcmu_cmd_entry.rsp.read_len        = 000c
> Offset of tcmu_cmd_entry.rsp.sense_buffer[0] = 0010
> 
> Size of struct tcmu_cmd_entry = 0070
> 
> 
> So we can compile a 32-bit application that works on 64-bit kernel
> without need to manipulate the include file prepared by the kernel.
> 
> What do you think? Do you know a better solution?

Can you not use something similar to the compat_ioctl mechanism?  the
job of the compat layer is to re-layout the input and output structures
to impedance match between 32 and 64 bit.

James

