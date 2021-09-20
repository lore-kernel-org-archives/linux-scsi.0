Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA5AC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 14:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BCD060F46
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 14:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbhITOyC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Sep 2021 10:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233370AbhITOyB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Sep 2021 10:54:01 -0400
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B12C061760
        for <linux-scsi@vger.kernel.org>; Mon, 20 Sep 2021 07:52:34 -0700 (PDT)
Received: from ramsan.of.borg ([84.195.186.194])
        by xavier.telenet-ops.be with bizsmtp
        id wEsX2500R4C55Sk01EsXsB; Mon, 20 Sep 2021 16:52:31 +0200
Received: from geert (helo=localhost)
        by ramsan.of.borg with local-esmtp (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mSKel-007FCD-72; Mon, 20 Sep 2021 16:52:31 +0200
Date:   Mon, 20 Sep 2021 16:52:31 +0200 (CEST)
From:   Geert Uytterhoeven <geert@linux-m68k.org>
X-X-Sender: geert@ramsan.of.borg
To:     linux-kernel@vger.kernel.org
cc:     linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org
Subject: Re: Build regressions/improvements in v5.15-rc2
In-Reply-To: <20210920115603.3455841-1-geert@linux-m68k.org>
Message-ID: <alpine.DEB.2.22.394.2109201639480.1726079@ramsan.of.borg>
References: <20210920115603.3455841-1-geert@linux-m68k.org>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 20 Sep 2021, Geert Uytterhoeven wrote:
> JFYI, when comparing v5.15-rc2[1] to v5.15-rc1[3], the summaries are:
>  - build errors: +9/-49

   + /kisskb/src/arch/sparc/lib/iomap.c: error: redefinition of 'pci_iounmap':  => 22:6

sparc64/sparc64-allnoconfig

   + /kisskb/src/drivers/iio/test/iio-test-format.c: error: the frame size of 2128 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]:  => 98:1

powerpc-gcc{5,9,11}/powerpc-allyesconfig

   + /kisskb/src/drivers/scsi/lpfc/lpfc_init.c: error: 'struct lpfc_sli4_hba' has no member named 'c_stat':  => 8280:28
   + /kisskb/src/drivers/scsi/lpfc/lpfc_scsi.c: error: 'start' undeclared (first use in this function):  => 5587:2

powerpc-gcc5/skiroot_defconfig

   + /kisskb/src/drivers/thunderbolt/test.c: error: the frame size of 3104 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]:  => 2207:1

powerpc-gcc5/powerpc-allyesconfig

   + /kisskb/src/drivers/tty/serial/cpm_uart/cpm_uart_core.c: error: 'udbg_cpm_getc' defined but not used [-Werror=unused-function]:  => 1109:12
   + /kisskb/src/drivers/tty/serial/cpm_uart/cpm_uart_core.c: error: 'udbg_cpm_putc' defined but not used [-Werror=unused-function]:  => 1095:13

powerpc-gcc5/ppc32_allmodconfig

   + /kisskb/src/drivers/usb/gadget/udc/fsl_qe_udc.c: error: cast from pointer to integer of different size [-Werror=pointer-to-int-cast]: 1496:12, 970:13, 842:13 => 842:13, 970:13, 1496:33, 1496:12, 970:41, 842:41
   + /kisskb/src/drivers/usb/gadget/udc/fsl_qe_udc.c: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]: 1497:27, 843:28, 971:28 => 971:28, 843:56, 971:56, 843:28, 1497:27, 1497:48

powerpc-gcc{5,9,11}/ppc64_book3e_allmodconfig

> [1] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/e4e737bb5c170df6135a127739a9e6148ee3da82/ (90 out of 182 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/6880fa6c56601bb8ed59df6c30fd390cc5f6dd8f/ (all 182 configs)

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
