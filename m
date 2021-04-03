Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24415C433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 14:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D740B61277
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 14:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236697AbhDCOv6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 10:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236380AbhDCOv6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 10:51:58 -0400
Received: from smtp.gentoo.org (mail.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A048C0613E6;
        Sat,  3 Apr 2021 07:51:55 -0700 (PDT)
Date:   Sat, 3 Apr 2021 15:51:48 +0100
From:   Sergei Trofimovich <slyfox@gentoo.org>
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "John Paul Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>,
        Don Brace - C33706 <don.brace@microchip.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "storagedev@microchip.com" <storagedev@microchip.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "jszczype@redhat.com" <jszczype@redhat.com>,
        Scott Benesh <scott.benesh@microchip.com>,
        Scott Teel <scott.teel@microchip.com>,
        "thenzl@redhat.com" <thenzl@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] hpsa: add an assert to prevent from __packed
 reintroduction
Message-ID: <20210403155148.0f5c94ff@sf>
In-Reply-To: <TU4PR8401MB1055C76F16F4D8A2DCF541F8AB7A9@TU4PR8401MB1055.NAMPRD84.PROD.OUTLOOK.COM>
References: <yq1wntpgxxr.fsf@ca-mkp.ca.oracle.com>
        <20210330071958.3788214-1-slyfox@gentoo.org>
        <20210330071958.3788214-3-slyfox@gentoo.org>
        <CAK8P3a2CmQpKynwGbtdWH+1L4=SkX2y4XKggT=8DrnsjxU4hSw@mail.gmail.com>
        <TU4PR8401MB1055C76F16F4D8A2DCF541F8AB7A9@TU4PR8401MB1055.NAMPRD84.PROD.OUTLOOK.COM>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2 Apr 2021 14:40:39 +0000
"Elliott, Robert (Servers)" <elliott@hpe.com> wrote:

> It looks like ia64 implements atomic_t as a 64-bit value and expects atomic_t
> to be 64-bit aligned, but does nothing to ensure that.
> 
> For x86, atomic_t is a 32-bit value and atomic64_t is a 64-bit value, and
> the definition of atomic64_t is overridden in a way that ensures
> 64-bit (8 byte) alignment:
> 
> Generic definitions are in include/linux/types.h:
>     typedef struct {
>             int counter;
>     } atomic_t;
> 
>     #define ATOMIC_INIT(i) { (i) }
> 
>     #ifdef CONFIG_64BIT
>     typedef struct {
>             s64 counter;
>     } atomic64_t;
>     #endif
> 
> Override in arch/x86/include/asm/atomic64_32.h:
>     typedef struct {
>             s64 __aligned(8) counter;
>     } atomic64_t;
> 
> Perhaps ia64 needs to take over the definition of both atomic_t and atomic64_t
> and do the same?

I don't think it's needed. ia64 is a 64-bit arch with expected
natural alignment for s64: alignof(s64)=8.

Also if my understanding is correct adding __aligned(8) would not fix
use case of embedding locks into packed structs even on x86_64 (or i386):

    $ cat a.c
    #include <stdio.h>
    #include <stddef.h>

    typedef struct { unsigned long long __attribute__((aligned(8))) l; } lock_t;
    struct s { char c; lock_t lock; } __attribute__((packed));
    int main() { printf ("offsetof(struct s, lock) = %lu\nsizeof(struct s) = %lu\n", offsetof(struct s, lock), sizeof(struct s)); }

    $ x86_64-pc-linux-gnu-gcc a.c -o a && ./a
    offsetof(struct s, lock) = 1
    sizeof(struct s) = 9

    $ x86_64-pc-linux-gnu-gcc a.c -o a -m32 && ./a
    offsetof(struct s, lock) = 1
    sizeof(struct s) = 9

Note how alignment of 'lock' stays 1 byte in both cases.

8-byte alignment added for i386 in
    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bbf2a330d92c5afccfd17592ba9ccd50f41cf748
is only as a performance optimization (not a correctness fix).

Larger alignment on i386 is preferred because alignof(s64)=4 on
that target which might make atomic op span cache lines that
leads to performance degradation.

-- 

  Sergei
