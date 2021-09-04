Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-24.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 982E2C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Sep 2021 22:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E16D601FD
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Sep 2021 22:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbhIDWXb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Sep 2021 18:23:31 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:57862 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbhIDWXb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Sep 2021 18:23:31 -0400
Received: from mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 543612EA04F;
        Sat,  4 Sep 2021 18:22:28 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19]) (amavisd-new, port 10024)
        with ESMTP id D-KM6agztMpk; Sat,  4 Sep 2021 18:22:27 -0400 (EDT)
Received: from [192.168.48.23] (host-45-78-207-107.dyn.295.ca [45.78.207.107])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 918862EA00A;
        Sat,  4 Sep 2021 18:22:27 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH sg3_utils] sg_xcopy: Improve the code for building a CSCD
 descriptor
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org, Eitan Cohen <eitancohen456@gmail.com>,
        Hannes Reinecke <hare@suse.com>
References: <20210902041247.15958-1-bvanassche@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <4e565958-fbb4-22d4-7cd9-bbf2eaa2fcbe@interlog.com>
Date:   Sat, 4 Sep 2021 18:22:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210902041247.15958-1-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-09-02 12:12 a.m., Bart Van Assche wrote:
> Since the maximum length of the designator field in an identification CSCD
> descriptor is 20 bytes, accept designators with a length of up to 20 bytes.
> 
> Since the upper four bits of byte 4 in a CSCD descriptor are reserved, use
> mask 0x0f instead of 0x1f for that byte.
> 
> Since the upper two bits of byte 5 in a CSCD descriptor are reserved, use
> mask 0x3f for that byte.
> 
> Compile-tested only.

Looks good and Hannes didn't object so it has been applied to my upstream
version which is mirrored at: https://github.com/doug-gilbert/sg3_utils

My ddpt package tries to be an "all-in-one" copy using pass-through
solution. The "all-in-one" utility has the same name as the package plus
there are two helpers: ddptctl and ddpt_sgl. It also does the same "LID1"
Extended Copy as sg_xcopy plus the Microsoft inspired ODX which relies on
the Populate Token and Write Using Token (SBC-3,4,5) SCSI commands. It
shares the same CSCD identification descriptor code as sg_xcopy so it needs
the same fix. That is now done, see: https://github.com/doug-gilbert/ddpt
Recent extensions to ddpt include generalizing skip= and seek= operands to
take scatter gather lists (i.e. gather on the IFILE side, scatter on the
OFILE side). Also invocations like this:
    ddpt iflag=pt if=/dev/nvme0n1 bs=512 of=img.bin
issue NVME commands to that IFILE (via a SNTL).

BTW FreeNAS has a decent ODX (server side) implementation and probably
parts of Extended Copy as well.

Doug Gilbert

> Cc: Eitan Cohen <eitancohen456@gmail.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   src/sg_xcopy.c | 17 +++++++++--------
>   1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/src/sg_xcopy.c b/src/sg_xcopy.c
> index e691a73ef4c9..dff565a2eab8 100644
> --- a/src/sg_xcopy.c
> +++ b/src/sg_xcopy.c
> @@ -1075,27 +1075,27 @@ desc_from_vpd_id(int sg_fd, uint8_t *desc, int desc_len,
>           if (verbose > 2)
>               pr2serr("    Desc %d: assoc %u desig %u len %d\n", off, assoc,
>                       desig, i_len);
> -        /* Descriptor must be less than 16 bytes */
> -        if (i_len > 16)
> +        /* Designator length must be <= 20. */
> +        if (i_len > 20)
>               continue;
> -        if (desig == 3) {
> +        if (desig == /*NAA=*/3) {
>               best = bp;
>               best_len = i_len;
>               break;
>           }
> -        if (desig == 2) {
> +        if (desig == /*EUI64=*/2) {
>               if (!best || f_desig < 2) {
>                   best = bp;
>                   best_len = i_len;
>                   f_desig = 2;
>               }
> -        } else if (desig == 1) {
> +        } else if (desig == /*T10*/1) {
>               if (!best || f_desig == 0) {
>                   best = bp;
>                   best_len = i_len;
>                   f_desig = desig;
>               }
> -        } else if (desig == 0) {
> +        } else if (desig == /*vend.spec.=*/0) {
>               if (!best) {
>                   best = bp;
>                   best_len = i_len;
> @@ -1108,9 +1108,10 @@ desc_from_vpd_id(int sg_fd, uint8_t *desc, int desc_len,
>               decode_designation_descriptor(best, best_len);
>           if (best_len + 4 < desc_len) {
>               memset(desc, 0, 32);
> -            desc[0] = 0xe4;
> +            desc[0] = 0xe4; /* Identification Descriptor */
>               memcpy(desc + 4, best, best_len + 4);
> -            desc[4] &= 0x1f;
> +            desc[4] &= 0x0f; /* code set */
> +	    desc[5] &= 0x3f; /* association and designator type */
>               if (pad)
>                   desc[28] = 0x4;
>               sg_put_unaligned_be24((uint32_t)block_size, desc + 29);
> 

