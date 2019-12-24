Return-Path: <SRS0=FF7y=2O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2938FC2D0C3
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 21:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5F7B20643
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 21:01:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LI0iWWOx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfLXVB4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Dec 2019 16:01:56 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39097 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbfLXVB4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Dec 2019 16:01:56 -0500
Received: by mail-ot1-f67.google.com with SMTP id 77so27444011oty.6
        for <linux-scsi@vger.kernel.org>; Tue, 24 Dec 2019 13:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jD1vnhyvrCKokVq1oqjGePFro71sw9tabHYUcYzNkIc=;
        b=LI0iWWOxtSaCDPlwnJ9vRxZOtDa4vH1BZwS4Hw/ixfyhNkc+/5vCHc0JrRpFfsrwIT
         8Xl2iHgvzM26wA8N6jeEeLIHnchOwOYjukbYNBu7q4Fv0Ze0mQkiykiL6w5eh6M4fLEX
         bC+eME+7YfkGT+PK1zlYvE+9bn5CZd2fOJsQuZ988Xcz4gtp3e2VSvtnd9/Oi4yW64dn
         xJ72hlpLI9Epidmd6WnqJI6/GUN3NX69fqG6hc6ECPE9NFi3WZfiQ9fbZSmHuZC4zOn9
         IkjJoEoVXkwZ1IiZAevXMENLC6ftHcTBMvT/7sLGTjBtrSmUB+AoJM089DNQ7d9URRRv
         e+hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jD1vnhyvrCKokVq1oqjGePFro71sw9tabHYUcYzNkIc=;
        b=KcrILo9l/f7uSrkRHW/Ad7EF6qMI2oVgkhy1MvBYbHfCDNf9P76x4DT294/j3DiRAU
         xgoGWtCQ0oVQSbBCMkV73fXym+Is3uWEUQ1VQYGBor4Zge32Mrjg8hdmtiaZqD45SkQx
         gxa42EvpWCJXztYbDSTnOJRTV5fURvcG/7ex3gtLIUoODSFpvTOdzp7TDyBpFpPAC6Nk
         wsS3uB5wWtmQ6auOQ1Ohyn70MaJZbbbOeQG0Arod8cbC4XhFH4077MLG9UT+GipOgtpX
         Zq2pwrk1ce/m3TguRzXwb1OVlPRE2m7Gb1tVHIPPfIj5v7gz8KonZUW1+C2J7rjqWk1s
         MRxg==
X-Gm-Message-State: APjAAAWuc5nEzmSu8Nsy44l2Ww5N7u3FL0mhnTLH/sZ61kaZifQwopgq
        fsGnqYRbCwfOElSneZSF0eA=
X-Google-Smtp-Source: APXvYqwVpSMlDD3JILLOm6AXKY/yVBPnZpKUrzI8bofrkLKxC6I0H/HwByZfmo3VIkz50+gTwcENdQ==
X-Received: by 2002:a05:6830:1607:: with SMTP id g7mr40758956otr.320.1577221314552;
        Tue, 24 Dec 2019 13:01:54 -0800 (PST)
Received: from ubuntu-m2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id k26sm2767628oiw.34.2019.12.24.13.01.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 24 Dec 2019 13:01:53 -0800 (PST)
Date:   Tue, 24 Dec 2019 14:01:51 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com, dwagner@suse.de,
        bvanassche@acm.org, Ram Vegesna <ram.vegesna@broadcom.com>,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH v2 32/32] elx: efct: Tie into kernel Kconfig and build
 process
Message-ID: <20191224210151.GA19657@ubuntu-m2-xlarge-x86>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-33-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220223723.26563-33-jsmart2021@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Dec 20, 2019 at 02:37:23PM -0800, James Smart wrote:
> This final patch ties the efct driver into the kernel Kconfig
> and build linkages in the drivers/scsi directory.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>

Hi James,

The 0day bot reported a few new clang warnings with this series. Would
you mind fixing them in the next version? I've attached how I would
resolve them inline, feel free to use them or fix the warnings in a
different way.


On Wed, Dec 25, 2019 at 04:31:56AM +0800, kbuild test robot wrote:
> CC: kbuild-all@lists.01.org
> In-Reply-To: <20191220223723.26563-33-jsmart2021@gmail.com>
> References: <20191220223723.26563-33-jsmart2021@gmail.com>
> TO: James Smart <jsmart2021@gmail.com>
> CC: linux-scsi@vger.kernel.org
> CC: maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org, James Smart <jsmart2021@gmail.com>, Ram Vegesna <ram.vegesna@broadcom.com>
> 
> Hi James,
> 
> I love your patch! Perhaps something to improve:
> 
> [auto build test WARNING on mkp-scsi/for-next]
> [also build test WARNING on scsi/for-next linus/master v5.5-rc3 next-20191219]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> 
> url:    https://github.com/0day-ci/linux/commits/James-Smart/efct-Broadcom-Emulex-FC-Target-driver/20191224-054519
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
> config: x86_64-allyesconfig (attached as .config)
> compiler: clang version 10.0.0 (git://gitmirror/llvm_project e5a743c4f6e3639ba3bee778c894a996ef96391a)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
> >> drivers/scsi/elx/efct/efct_els.c:1736:32: warning: implicit conversion from enumeration type 'enum efct_els_role' to different enumeration type 'enum efct_scsi_io_role' [-Wenum-conversion]
>            io = efct_scsi_io_alloc(node, EFCT_ELS_ROLE_RESPONDER);
>                 ~~~~~~~~~~~~~~~~~~       ^~~~~~~~~~~~~~~~~~~~~~~
>    1 warning generated.


diff --git a/drivers/scsi/elx/efct/efct_els.c b/drivers/scsi/elx/efct/efct_els.c
index 9c964302505b..10e60128a527 100644
--- a/drivers/scsi/elx/efct/efct_els.c
+++ b/drivers/scsi/elx/efct/efct_els.c
@@ -1733,7 +1733,7 @@ efct_bls_send_acc_hdr(struct efc *efc, struct efc_node *node,
 	u16 rx_id = be16_to_cpu(hdr->fh_rx_id);
 	u32 d_id = ntoh24(hdr->fh_d_id);
 
-	io = efct_scsi_io_alloc(node, EFCT_ELS_ROLE_RESPONDER);
+	io = efct_scsi_io_alloc(node, EFCT_SCSI_IO_ROLE_RESPONDER);
 	if (!io) {
 		efc_log_err(efc, "els IO alloc failed\n");
 		return io;

> >> drivers/scsi/elx/efct/efct_hw.c:5270:6: warning: logical not is only applied to the left hand side of this comparison [-Wlogical-not-parentheses]
>            if (!sli_cmd_common_nop(&hw->sli, ctx->cmd,
>                ^
>    drivers/scsi/elx/efct/efct_hw.c:5270:6: note: add parentheses after the '!' to evaluate the comparison first
>            if (!sli_cmd_common_nop(&hw->sli, ctx->cmd,
>                ^
>                 (
>    drivers/scsi/elx/efct/efct_hw.c:5270:6: note: add parentheses around left hand side expression to silence this warning
>            if (!sli_cmd_common_nop(&hw->sli, ctx->cmd,
>                ^
>                (
>    drivers/scsi/elx/efct/efct_hw.c:5619:6: warning: logical not is only applied to the left hand side of this comparison [-Wlogical-not-parentheses]
>            if (!sli_cmd_reg_vpi(&hw->sli, data, SLI4_BMBX_SIZE,
>                ^
>    drivers/scsi/elx/efct/efct_hw.c:5619:6: note: add parentheses after the '!' to evaluate the comparison first
>            if (!sli_cmd_reg_vpi(&hw->sli, data, SLI4_BMBX_SIZE,
>                ^
>                 (
>    drivers/scsi/elx/efct/efct_hw.c:5619:6: note: add parentheses around left hand side expression to silence this warning
>            if (!sli_cmd_reg_vpi(&hw->sli, data, SLI4_BMBX_SIZE,
>                ^
>                (
>    drivers/scsi/elx/efct/efct_hw.c:5962:6: warning: logical not is only applied to the left hand side of this comparison [-Wlogical-not-parentheses]
>            if (!sli_cmd_reg_vfi(&hw->sli, data, SLI4_BMBX_SIZE,
>                ^
>    drivers/scsi/elx/efct/efct_hw.c:5962:6: note: add parentheses after the '!' to evaluate the comparison first
>            if (!sli_cmd_reg_vfi(&hw->sli, data, SLI4_BMBX_SIZE,
>                ^
>                 (
>    drivers/scsi/elx/efct/efct_hw.c:5962:6: note: add parentheses around left hand side expression to silence this warning
>            if (!sli_cmd_reg_vfi(&hw->sli, data, SLI4_BMBX_SIZE,
>                ^
>                (
>    3 warnings generated.

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 23d55d0d26c3..8428c7ff9d72 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -5267,8 +5267,8 @@ efct_hw_async_call(struct efct_hw *hw,
 	ctx->arg = arg;
 
 	/* Build and send a NOP mailbox command */
-	if (!sli_cmd_common_nop(&hw->sli, ctx->cmd,
-			       sizeof(ctx->cmd), 0) == 0) {
+	if (sli_cmd_common_nop(&hw->sli, ctx->cmd,
+			       sizeof(ctx->cmd), 0)) {
 		efc_log_err(hw->os, "COMMON_NOP format failure\n");
 		kfree(ctx);
 		rc = -1;
@@ -5616,10 +5616,10 @@ efct_hw_port_attach_reg_vpi(struct efc_sli_port *sport, void *data)
 	struct efct_hw *hw = sport->hw;
 	int rc;
 
-	if (!sli_cmd_reg_vpi(&hw->sli, data, SLI4_BMBX_SIZE,
+	if (sli_cmd_reg_vpi(&hw->sli, data, SLI4_BMBX_SIZE,
 			    sport->fc_id, sport->sli_wwpn,
 			sport->indicator, sport->domain->indicator,
-			false) == 0) {
+			false)) {
 		efc_log_err(hw->os, "REG_VPI format failure\n");
 		efct_hw_port_free_resources(sport,
 					    EFC_HW_PORT_ATTACH_FAIL, data);
@@ -5959,11 +5959,11 @@ efct_hw_domain_attach_reg_vfi(struct efc_domain *domain, void *data)
 	struct efct_hw *hw = domain->hw;
 	int rc;
 
-	if (!sli_cmd_reg_vfi(&hw->sli, data, SLI4_BMBX_SIZE,
+	if (sli_cmd_reg_vfi(&hw->sli, data, SLI4_BMBX_SIZE,
 			    domain->indicator, domain->fcf_indicator,
 			domain->dma, domain->sport->indicator,
 			domain->sport->sli_wwpn,
-			domain->sport->fc_id) == 0) {
+			domain->sport->fc_id)) {
 		efc_log_err(hw->os, "REG_VFI format failure\n");
 		goto cleanup;
 	}

> >> drivers/scsi/elx/libefc_sli/sli4.c:202:6: warning: variable 'ver' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
>            if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
>                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    drivers/scsi/elx/libefc_sli/sli4.c:206:5: note: uninitialized use occurs here
>                             ver, CFG_RQST_PYLD_LEN(cmn_create_eq));
>                             ^~~
>    drivers/scsi/elx/libefc_sli/sli4.c:202:2: note: remove the 'if' if its condition is always true
>            if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
>            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    drivers/scsi/elx/libefc_sli/sli4.c:195:24: note: initialize the variable 'ver' to silence this warning
>            u32 dw6_flags = 0, ver;
>                                  ^
>                                   = 0
>    1 warning generated.

Presumably, ver should be initialized to either CMD_V0 or CMD_V1 but I
cannot tell.

Cheers,
Nathan
