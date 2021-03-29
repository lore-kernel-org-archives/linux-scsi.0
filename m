Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 081D3C433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 11:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D24266193B
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 11:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbhC2L0g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 07:26:36 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:55983 "EHLO
        outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232833AbhC2L0H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Mar 2021 07:26:07 -0400
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.94)
          with esmtps (TLS1.2)
          tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1lQq1s-001yIV-6b; Mon, 29 Mar 2021 13:25:56 +0200
Received: from dynamic-077-013-191-101.77.13.pool.telefonica.de ([77.13.191.101] helo=[192.168.1.10])
          by inpost2.zedat.fu-berlin.de (Exim 4.94)
          with esmtpsa (TLS1.2)
          tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1lQq1r-003kLj-VV; Mon, 29 Mar 2021 13:25:56 +0200
Subject: Re: [PATCH] hpsa: fix boot on ia64 (atomic_t alignment)
To:     Don.Brace@microchip.com, slyfox@gentoo.org,
        linux-kernel@vger.kernel.org
Cc:     linux-ia64@vger.kernel.org, storagedev@microchip.com,
        linux-scsi@vger.kernel.org, jszczype@redhat.com,
        Scott.Benesh@microchip.com, Scott.Teel@microchip.com,
        thenzl@redhat.com, martin.petersen@oracle.com
References: <5532f9ab-7555-d51b-f4d5-f9b72a61f248@redhat.com>
 <20210312222718.4117508-1-slyfox@gentoo.org>
 <SN6PR11MB2848C136F6CB4EA66D42FFAEE1639@SN6PR11MB2848.namprd11.prod.outlook.com>
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Message-ID: <ea49071d-d1e1-97b7-6468-501be0b9b195@physik.fu-berlin.de>
Date:   Mon, 29 Mar 2021 13:25:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <SN6PR11MB2848C136F6CB4EA66D42FFAEE1639@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 77.13.191.101
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi!

On 3/24/21 7:37 PM, Don.Brace@microchip.com wrote:
> -----Original Message-----
> From: Sergei Trofimovich [mailto:slyfox@gentoo.org] 
> Subject: [PATCH] hpsa: fix boot on ia64 (atomic_t alignment)
> 
> The failure initially observed as boot failure on rx3600 ia64 machine with RAID bus controller: Hewlett-Packard Company Smart Array P600:
> 
>     kernel unaligned access to 0xe000000105dd8b95, ip=0xa000000100b87551
>     kernel unaligned access to 0xe000000105dd8e95, ip=0xa000000100b87551
>     hpsa 0000:14:01.0: Controller reports max supported commands of 0 Using 16 instead. Ensure that firmware is up to date.
>     swapper/0[1]: error during unaligned kernel access
> 
> Here unaligned access comes from 'struct CommandList' that happens to be packed. The change f749d8b7a ("scsi: hpsa: Correct dev cmds outstanding for retried cmds") introduced unexpected padding and un-aligned atomic_t from natural alignment to something else.
> 
> This change does not remove packing annotation from struct but only restores alignment of atomic variable.
> 
> The change is tested on the same rx3600 machine.
> 
> CC: linux-ia64@vger.kernel.org
> CC: storagedev@microchip.com
> CC: linux-scsi@vger.kernel.org
> CC: Joe Szczypek <jszczype@redhat.com>
> CC: Scott Benesh <scott.benesh@microchip.com>
> CC: Scott Teel <scott.teel@microchip.com>
> CC: Tomas Henzl <thenzl@redhat.com>
> CC: "Martin K. Petersen" <martin.petersen@oracle.com>
> CC: Don Brace <don.brace@microchip.com>
> Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Suggested-by: Don Brace <don.brace@microchip.com>
> Fixes: f749d8b7a "scsi: hpsa: Correct dev cmds outstanding for retried cmds"
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> ---
>  drivers/scsi/hpsa_cmd.h | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h index d126bb877250..617bdae9a7de 100644
> --- a/drivers/scsi/hpsa_cmd.h
> +++ b/drivers/scsi/hpsa_cmd.h
> @@ -20,6 +20,9 @@
>  #ifndef HPSA_CMD_H
>  #define HPSA_CMD_H
> 
> +#include <linux/build_bug.h> /* static_assert */ #include 
> +<linux/stddef.h> /* offsetof */
> +
>  /* general boundary defintions */
>  #define SENSEINFOBYTES          32 /* may vary between hbas */
>  #define SG_ENTRIES_IN_CMD      32 /* Max SG entries excluding chain blocks */
> @@ -448,11 +451,20 @@ struct CommandList {
>          */
>         struct hpsa_scsi_dev_t *phys_disk;
> 
> -       bool retry_pending;
> +       int retry_pending;
>         struct hpsa_scsi_dev_t *device;
>         atomic_t refcount; /* Must be last to avoid memset in hpsa_cmd_init() */  } __aligned(COMMANDLIST_ALIGNMENT);
> 
> +/*
> + * Make sure our embedded atomic variable is aligned. Otherwise we 
> +break atomic
> + * operations on architectures that don't support unaligned atomics like IA64.
> + *
> + * Ideally this header should be cleaned up to only mark individual 
> +structs as
> + * packed.
> + */
> +static_assert(offsetof(struct CommandList, refcount) % 
> +__alignof__(atomic_t) == 0);
> +
>  /* Max S/G elements in I/O accelerator command */
>  #define IOACCEL1_MAXSGENTRIES           24
>  #define IOACCEL2_MAXSGENTRIES          28
> --
> 2.30.2
> 
> 
> Acked-by: Don Brace <don.brace@microchip.com>
> 
> Thanks for your patch and extra effort.

Apologies for being so persistent, but has this patch been queued anywhere?

This should be included for 5.12 if possible as it unbreaks the kernel on alot
of Itanium servers (and potentially other machines with the HPSA controller).

If no one wants to pick the patch up, it could go through Andrew Morton's tree (-mm).

Thanks,
Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer - glaubitz@debian.org
`. `'   Freie Universitaet Berlin - glaubitz@physik.fu-berlin.de
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

