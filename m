Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F14A0C64EBC
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 18:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 928492416E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 18:27:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pm4C+zOq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730136AbgKTS10 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 13:27:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:48056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730130AbgKTS1Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Nov 2020 13:27:25 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B1A42224C;
        Fri, 20 Nov 2020 18:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605896845;
        bh=If0qQ61dzdqslYDbaW8NHfhoLDyPAWQ4qzC18ToYedY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pm4C+zOqjrRT4mNzdLrmTlZXhOvoIwt1fdiVLv7zAtbZBjXtwlkhXY+lvMTWJkhdw
         kRH/ZoSpd4fdBfrJsoZby8FRDCnJSABLH9c2+6Al/2uqntUC53rDe0aH0vHoAsbJzb
         8ObXGmNCovxosVDef488ULTICoxxT06pnACM3uBY=
Date:   Fri, 20 Nov 2020 12:27:30 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 022/141] scsi: bfa: Fix fall-through warnings for Clang
Message-ID: <2ae1cafd858238b85fc5e7fe5cc183843e21ec9f.1605896059.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding a couple break statements and replacing
/* fall through */ comments with the new pseudo-keyword macro
fallthrough; instead of just letting the code fall through to the next
case.

Notice that Clang doesn't recognize /* fall through */ comments as
implicit fall-through markings.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/bfa/bfa_fcs_lport.c | 2 +-
 drivers/scsi/bfa/bfa_ioc.c       | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 3486e402bfc1..49a14157f123 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -5671,7 +5671,7 @@ bfa_fcs_lport_scn_process_rscn(struct bfa_fcs_lport_s *port,
 				bfa_fcs_lport_ms_fabric_rscn(port);
 				break;
 			}
-			/* !!!!!!!!! Fall Through !!!!!!!!!!!!! */
+			fallthrough;
 
 		case FC_RSCN_FORMAT_AREA:
 		case FC_RSCN_FORMAT_DOMAIN:
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 325ad8a592bb..5740302d83ac 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -387,7 +387,7 @@ bfa_ioc_sm_getattr(struct bfa_ioc_s *ioc, enum ioc_event event)
 	case IOC_E_PFFAILED:
 	case IOC_E_HWERROR:
 		bfa_ioc_timer_stop(ioc);
-		/* !!! fall through !!! */
+		fallthrough;
 	case IOC_E_TIMEOUT:
 		ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_IOC_FAILURE);
 		bfa_fsm_set_state(ioc, bfa_ioc_sm_fail);
@@ -437,7 +437,7 @@ bfa_ioc_sm_op(struct bfa_ioc_s *ioc, enum ioc_event event)
 	case IOC_E_PFFAILED:
 	case IOC_E_HWERROR:
 		bfa_hb_timer_stop(ioc);
-		/* !!! fall through !!! */
+		fallthrough;
 	case IOC_E_HBFAIL:
 		if (ioc->iocpf.auto_recover)
 			bfa_fsm_set_state(ioc, bfa_ioc_sm_fail_retry);
@@ -3299,6 +3299,7 @@ bfa_ablk_isr(void *cbarg, struct bfi_mbmsg_s *msg)
 	case BFI_ABLK_I2H_PORT_CONFIG:
 		/* update config port mode */
 		ablk->ioc->port_mode_cfg = rsp->port_mode;
+		break;
 
 	case BFI_ABLK_I2H_PF_DELETE:
 	case BFI_ABLK_I2H_PF_UPDATE:
@@ -5871,6 +5872,7 @@ bfa_dconf_sm_uninit(struct bfa_dconf_mod_s *dconf, enum bfa_dconf_event event)
 		break;
 	case BFA_DCONF_SM_EXIT:
 		bfa_fsm_send_event(&dconf->bfa->iocfc, IOCFC_E_DCONF_DONE);
+		break;
 	case BFA_DCONF_SM_IOCDISABLE:
 	case BFA_DCONF_SM_WR:
 	case BFA_DCONF_SM_FLASH_COMP:
-- 
2.27.0

