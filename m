Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA057CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 15:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C30C521D82
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 15:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395550AbfJYPzb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 11:55:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:51246 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388136AbfJYPzb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Oct 2019 11:55:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6EDBDB54D;
        Fri, 25 Oct 2019 15:55:29 +0000 (UTC)
Date:   Fri, 25 Oct 2019 17:55:29 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH 31/32] elx: efct: Add Makefile and Kconfig for efct driver
Message-ID: <20191025155529.xglrsp3tmctvvguw@beryllium.lan>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
 <20191023215557.12581-32-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023215557.12581-32-jsmart2021@gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On Wed, Oct 23, 2019 at 02:55:56PM -0700, James Smart wrote:
> This patch completes the efct driver population.
> 
> This patch adds driver definitions for:
> Adds the efct driver Kconfig and Makefiles
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/elx/Kconfig  |  8 ++++++++
>  drivers/scsi/elx/Makefile | 30 ++++++++++++++++++++++++++++++
>  2 files changed, 38 insertions(+)
>  create mode 100644 drivers/scsi/elx/Kconfig
>  create mode 100644 drivers/scsi/elx/Makefile
> 
> diff --git a/drivers/scsi/elx/Kconfig b/drivers/scsi/elx/Kconfig
> new file mode 100644
> index 000000000000..3d25d8463c48
> --- /dev/null
> +++ b/drivers/scsi/elx/Kconfig
> @@ -0,0 +1,8 @@
> +config SCSI_EFCT
> +	tristate "Emulex Fibre Channel Target"
> +	depends on PCI && SCSI
> +	depends on SCSI_FC_ATTRS

Is TARGET_ISCSI missing?

: drivers/scsi/elx/efct/efct_lio.o: in function `efct_lio_npiv_drop_tpg':
efct_lio.c:(.text+0xa35): undefined reference to `core_tpg_deregister'
ld: drivers/scsi/elx/efct/efct_lio.o: in function `efct_lio_drop_tpg':
efct_lio.c:(.text+0xa6e): undefined reference to `core_tpg_deregister'
ld: drivers/scsi/elx/efct/efct_lio.o: in function `efct_lio_tmf_done':
efct_lio.c:(.text+0xceb): undefined reference to `transport_generic_free_cmd'
ld: drivers/scsi/elx/efct/efct_lio.o: in function `efct_lio_async_worker':
efct_lio.c:(.text+0x1136): undefined reference to `target_submit_tmr'
ld: efct_lio.c:(.text+0x12b5): undefined reference to `target_setup_session'
ld: efct_lio.c:(.text+0x133c): undefined reference to `target_sess_cmd_list_set_waiting'
ld: efct_lio.c:(.text+0x1344): undefined reference to `target_wait_for_sess_cmds'
ld: efct_lio.c:(.text+0x134c): undefined reference to `target_remove_session'
ld: efct_lio.c:(.text+0x1464): undefined reference to `target_submit_cmd'
ld: drivers/scsi/elx/efct/efct_lio.o: in function `efct_lio_status_done':
efct_lio.c:(.text+0x1579): undefined reference to `transport_generic_free_cmd'
ld: drivers/scsi/elx/efct/efct_lio.o: in function `efct_lio_datamove_done':
efct_lio.c:(.text+0x1a01): undefined reference to `transport_generic_request_failure'
ld: efct_lio.c:(.text+0x1a6c): undefined reference to `transport_generic_free_cmd'
ld: efct_lio.c:(.text+0x1a87): undefined reference to `target_execute_cmd'
ld: drivers/scsi/elx/efct/efct_lio.o: in function `efct_lio_make_tpg':
efct_lio.c:(.text+0x1ba4): undefined reference to `core_tpg_register'
ld: drivers/scsi/elx/efct/efct_lio.o: in function `efct_lio_npiv_make_tpg':
efct_lio.c:(.text+0x2078): undefined reference to `core_tpg_register'
ld: drivers/scsi/elx/efct/efct_lio.o: in function `efct_scsi_tgt_driver_init':
efct_lio.c:(.text+0x2eba): undefined reference to `target_register_template'
ld: efct_lio.c:(.text+0x2ece): undefined reference to `target_register_template'
ld: drivers/scsi/elx/efct/efct_lio.o: in function `efct_scsi_tgt_driver_exit':
efct_lio.c:(.text+0x2ef8): undefined reference to `target_unregister_template'
ld: efct_lio.c:(.text+0x2f04): undefined reference to `target_unregister_template'
ld: drivers/scsi/elx/efct/efct_lio.o: in function `efct_lio_check_stop_free':
efct_lio.c:(.text+0xdf8): undefined reference to `target_put_sess_cmd'
ld: drivers/scsi/elx/efct/efct_lio.o: in function `efct_scsi_tgt_driver_init.cold':
efct_lio.c:(.text.unlikely+0x323): undefined reference to `target_unregister_template'
make[1]: *** [/home/wagi/work/linux/Makefile:1094: vmlinux] Error 1
make[1]: Leaving directory '/home/wagi/work/build/efct'

Thanks,
Daniel
