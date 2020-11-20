Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1255AC63798
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 18:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE3DB21D91
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 18:42:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jy2staIP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731595AbgKTSln (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 13:41:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:58460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731581AbgKTSkY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Nov 2020 13:40:24 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9CDA241A6;
        Fri, 20 Nov 2020 18:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897621;
        bh=h0ITouBiiUmCiWBaHMzubSX77FAZ7qI2pCMuYg3OfKE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jy2staIPU7TX96mT3toukkbyoBLKMZW4mQCXy64SrgUyEWdZH/CXV8h3g6t+SQ6G1
         DqPROMIU30E8zzVFHvr6YHXeoSMRaDm9gGV75DmAOLnJINHlkXPH438Xhz3A5wHaGX
         fRU5b9bwHbDJcEuxuxdOosgQiYhCMAEMSEWZgdSk=
Date:   Fri, 20 Nov 2020 12:40:27 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Olav Kongas <ok@artecdesign.ee>, Bin Liu <b-liu@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 133/141] usb: Fix fall-through warnings for Clang
Message-ID: <a76da7ca5b4f41c13d27b298accb8222d0b04e61.1605896060.git.gustavoars@kernel.org>
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
warnings by explicitly adding multiple break/return/fallthrough
statements instead of letting the code fall through to the next
case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c         | 2 ++
 drivers/usb/gadget/function/f_loopback.c   | 2 +-
 drivers/usb/gadget/function/f_sourcesink.c | 1 +
 drivers/usb/gadget/udc/dummy_hcd.c         | 2 ++
 drivers/usb/host/fotg210-hcd.c             | 2 +-
 drivers/usb/host/isp116x-hcd.c             | 1 +
 drivers/usb/host/max3421-hcd.c             | 1 +
 drivers/usb/host/oxu210hp-hcd.c            | 1 +
 drivers/usb/misc/yurex.c                   | 1 +
 drivers/usb/musb/tusb6010.c                | 1 +
 drivers/usb/storage/ene_ub6250.c           | 1 +
 drivers/usb/storage/uas.c                  | 1 +
 12 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 046f770a76da..7f9c4e35d3db 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -678,6 +678,8 @@ static __poll_t ffs_ep0_poll(struct file *file, poll_table *wait)
 			mask |= (EPOLLIN | EPOLLOUT);
 			break;
 		}
+		break;
+
 	case FFS_CLOSING:
 		break;
 	case FFS_DEACTIVATED:
diff --git a/drivers/usb/gadget/function/f_loopback.c b/drivers/usb/gadget/function/f_loopback.c
index 1803646b3678..b56ad7c3838b 100644
--- a/drivers/usb/gadget/function/f_loopback.c
+++ b/drivers/usb/gadget/function/f_loopback.c
@@ -274,7 +274,7 @@ static void loopback_complete(struct usb_ep *ep, struct usb_request *req)
 	default:
 		ERROR(cdev, "%s loop complete --> %d, %d/%d\n", ep->name,
 				status, req->actual, req->length);
-		/* FALLTHROUGH */
+		fallthrough;
 
 	/* NOTE:  since this driver doesn't maintain an explicit record
 	 * of requests it submitted (just maintains qlen count), we
diff --git a/drivers/usb/gadget/function/f_sourcesink.c b/drivers/usb/gadget/function/f_sourcesink.c
index ed68a4860b7d..5a201ba7b155 100644
--- a/drivers/usb/gadget/function/f_sourcesink.c
+++ b/drivers/usb/gadget/function/f_sourcesink.c
@@ -559,6 +559,7 @@ static void source_sink_complete(struct usb_ep *ep, struct usb_request *req)
 #if 1
 		DBG(cdev, "%s complete --> %d, %d/%d\n", ep->name,
 				status, req->actual, req->length);
+		break;
 #endif
 	case -EREMOTEIO:		/* short read */
 		break;
diff --git a/drivers/usb/gadget/udc/dummy_hcd.c b/drivers/usb/gadget/udc/dummy_hcd.c
index 53a227217f1c..bb0dc67ecdd3 100644
--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -553,6 +553,7 @@ static int dummy_enable(struct usb_ep *_ep,
 				/* we'll fake any legal size */
 				break;
 			/* save a return statement */
+			fallthrough;
 		default:
 			goto done;
 		}
@@ -595,6 +596,7 @@ static int dummy_enable(struct usb_ep *_ep,
 			if (max <= 1023)
 				break;
 			/* save a return statement */
+			fallthrough;
 		default:
 			goto done;
 		}
diff --git a/drivers/usb/host/fotg210-hcd.c b/drivers/usb/host/fotg210-hcd.c
index 1d94fcfac2c2..0451943f0bc4 100644
--- a/drivers/usb/host/fotg210-hcd.c
+++ b/drivers/usb/host/fotg210-hcd.c
@@ -5276,7 +5276,7 @@ static int fotg210_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 		 */
 		if (urb->transfer_buffer_length > (16 * 1024))
 			return -EMSGSIZE;
-		/* FALLTHROUGH */
+		fallthrough;
 	/* case PIPE_BULK: */
 	default:
 		if (!qh_urb_transaction(fotg210, urb, &qtd_list, mem_flags))
diff --git a/drivers/usb/host/isp116x-hcd.c b/drivers/usb/host/isp116x-hcd.c
index 3055d9abfec3..8544a2a2c1e6 100644
--- a/drivers/usb/host/isp116x-hcd.c
+++ b/drivers/usb/host/isp116x-hcd.c
@@ -1447,6 +1447,7 @@ static int isp116x_bus_resume(struct usb_hcd *hcd)
 		val &= ~HCCONTROL_HCFS;
 		val |= HCCONTROL_USB_RESUME;
 		isp116x_write_reg32(isp116x, HCCONTROL, val);
+		break;
 	case HCCONTROL_USB_RESUME:
 		break;
 	case HCCONTROL_USB_OPER:
diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
index 0894f6caccb2..0b5d47e6aab2 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -1537,6 +1537,7 @@ max3421_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flags)
 				__func__, urb->interval);
 			return -EINVAL;
 		}
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index 27dbbe1b28b1..aa42df39e6a1 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -1365,6 +1365,7 @@ __acquires(oxu->lock)
 	switch (urb->status) {
 	case -EINPROGRESS:		/* success */
 		urb->status = 0;
+		break;
 	default:			/* fault */
 		break;
 	case -EREMOTEIO:		/* fault or normal */
diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index e3165d79b5f6..73ebfa6e9715 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -137,6 +137,7 @@ static void yurex_interrupt(struct urb *urb)
 		dev_err(&dev->interface->dev,
 			"%s - overflow with length %d, actual length is %d\n",
 			__func__, YUREX_BUF_SIZE, dev->urb->actual_length);
+		return;
 	case -ECONNRESET:
 	case -ENOENT:
 	case -ESHUTDOWN:
diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index c26683a2702b..c42937692207 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -467,6 +467,7 @@ static void musb_do_idle(struct timer_list *t)
 		fallthrough;
 	case OTG_STATE_A_IDLE:
 		tusb_musb_set_vbus(musb, 0);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene_ub6250.c
index 98c1aa594e6c..5f7d678502be 100644
--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -861,6 +861,7 @@ static int ms_count_freeblock(struct us_data *us, u16 PhyBlock)
 		case MS_LB_NOT_USED:
 		case MS_LB_NOT_USED_ERASED:
 			Count++;
+			break;
 		default:
 			break;
 		}
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index c8a577309e8f..6bd33c57fdcb 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -690,6 +690,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 		fallthrough;
 	case DMA_TO_DEVICE:
 		cmdinfo->state |= ALLOC_DATA_OUT_URB | SUBMIT_DATA_OUT_URB;
+		break;
 	case DMA_NONE:
 		break;
 	}
-- 
2.27.0

