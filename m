Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF3ECC4CEC6
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 20:22:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A70C208C2
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 20:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfILUWL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 16:22:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10394 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbfILUWL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Sep 2019 16:22:11 -0400
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0E25E50F45
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2019 20:22:11 +0000 (UTC)
Received: by mail-qt1-f199.google.com with SMTP id z4so28997316qts.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2019 13:22:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bZGa36lMTeQ6+gkb3vneaTbj21ra598sAeIAWacC180=;
        b=WsGsBekhlky7MuztsQKL1DvU5z/IAARiyHEYCAOuF9b/h60Bkfig//n7KIXSuxbtZr
         nSElO/T9Z0DKkyxMLCwEsMfIgoUUZ4ZsN5YZ+NIvWN1Nh+ivz1M80fvtiE/M+Uq47ExA
         gHELWas7mI+VWCw517L65EdSwAX4Ap3BorJ4FFcsapRiN5XSgBp4B/x98w0Shh14LVSl
         suPx1FHZiJxby6O7VlTi/epYTID5c49j2EyyYYnexKJNHF4kPcOMNhdTtUi149VPVmyR
         sN9f4pKWxvveHdEFx2bs5oaAUTbAd2lfs+HaUlzIl/72DgkytAAKYy1eKS48aSO+Bho8
         zT7g==
X-Gm-Message-State: APjAAAUmKPFZY6pAz+/cuHWri9Y3MDQuQw/fmRiPGk8uYVz+TDrqox8I
        4ehhN1XrKuuH0QWu3TtKgAY6zTjqmg5n11+bIimT0OVD0aiWg7jxaJAjguSHsT1araxzSOerMFR
        ywEhYP4bn/KRK3CINEonpag==
X-Received: by 2002:ac8:7601:: with SMTP id t1mr42450542qtq.342.1568319730084;
        Thu, 12 Sep 2019 13:22:10 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzbcQMa0MXP5H2vRiNV5hd113aJWrMde2iEnqC1mvRiCx+y9IjRZysZP4hNUH06ib45d4dVKA==
X-Received: by 2002:ac8:7601:: with SMTP id t1mr42450499qtq.342.1568319729671;
        Thu, 12 Sep 2019 13:22:09 -0700 (PDT)
Received: from dhcp-49-30.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id t199sm12326418qke.36.2019.09.12.13.22.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2019 13:22:09 -0700 (PDT)
Message-ID: <2b190236d26b4d769ca5d4dedc748f1abf2a276d.camel@redhat.com>
Subject: Re: [PATCH v2 11/14] qla2xxx: Check for MB timeout while capturing
 ISP27/28xx FW dump
From:   Laurence Oberman <loberman@redhat.com>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Date:   Thu, 12 Sep 2019 16:22:08 -0400
In-Reply-To: <20190912180918.6436-12-hmadhani@marvell.com>
References: <20190912180918.6436-1-hmadhani@marvell.com>
         <20190912180918.6436-12-hmadhani@marvell.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2019-09-12 at 11:09 -0700, Himanshu Madhani wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> Add mailbox timeout checkout for ISP 27xx/28xx during FW dump
> procedure. Without the timeout check, hardware lock can
> be held for long period. This patch would shorten the dump
> procedure, if a timeout condition is encountered.
> 
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_tmpl.c | 25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c
> b/drivers/scsi/qla2xxx/qla_tmpl.c
> index 294d77c02cdf..b948d94c8b3c 100644
> --- a/drivers/scsi/qla2xxx/qla_tmpl.c
> +++ b/drivers/scsi/qla2xxx/qla_tmpl.c
> @@ -10,6 +10,7 @@
>  #define ISPREG(vha)	(&(vha)->hw->iobase->isp24)
>  #define IOBAR(reg)	offsetof(typeof(*(reg)), iobase_addr)
>  #define IOBASE(vha)	IOBAR(ISPREG(vha))
> +#define INVALID_ENTRY ((struct qla27xx_fwdt_entry
> *)0xffffffffffffffffUL)
>  
>  static inline void
>  qla27xx_insert16(uint16_t value, void *buf, ulong *len)
> @@ -261,6 +262,7 @@ qla27xx_fwdt_entry_t262(struct scsi_qla_host
> *vha,
>  	ulong start = le32_to_cpu(ent->t262.start_addr);
>  	ulong end = le32_to_cpu(ent->t262.end_addr);
>  	ulong dwords;
> +	int rc;
>  
>  	ql_dbg(ql_dbg_misc, vha, 0xd206,
>  	    "%s: rdram(%x) [%lx]\n", __func__, ent->t262.ram_area,
> *len);
> @@ -308,7 +310,13 @@ qla27xx_fwdt_entry_t262(struct scsi_qla_host
> *vha,
>  	dwords = end - start + 1;
>  	if (buf) {
>  		buf += *len;
> -		qla24xx_dump_ram(vha->hw, start, buf, dwords, &buf);
> +		rc = qla24xx_dump_ram(vha->hw, start, buf, dwords,
> &buf);
> +		if (rc != QLA_SUCCESS) {
> +			ql_dbg(ql_dbg_async, vha, 0xffff,
> +			    "%s: dump ram MB failed. Area %xh start
> %lxh end %lxh\n",
> +			    __func__, area, start, end);
> +			return INVALID_ENTRY;
> +		}
>  	}
>  	*len += dwords * sizeof(uint32_t);
>  done:
> @@ -838,6 +846,13 @@ qla27xx_walk_template(struct scsi_qla_host *vha,
>  		ent = qla27xx_find_entry(type)(vha, ent, buf, len);
>  		if (!ent)
>  			break;
> +
> +		if (ent == INVALID_ENTRY) {
> +			*len = 0;
> +			ql_dbg(ql_dbg_async, vha, 0xffff,
> +			    "Unable to capture FW dump");
> +			goto bailout;
> +		}
>  	}
>  
>  	if (tmp->count)
> @@ -847,6 +862,9 @@ qla27xx_walk_template(struct scsi_qla_host *vha,
>  	if (ent)
>  		ql_dbg(ql_dbg_misc, vha, 0xd019,
>  		    "%s: missing end entry\n", __func__);
> +
> +bailout:
> +	cpu_to_le32s(&tmp->count);	/* endianize residual count
> */
>  }
>  
>  static void
> @@ -1010,7 +1028,9 @@ qla27xx_fwdump(scsi_qla_host_t *vha, int
> hardware_locked)
>  			}
>  			len = qla27xx_execute_fwdt_template(vha,
>  			    fwdt->template, buf);
> -			if (len != fwdt->dump_size) {
> +			if (len == 0) {
> +				goto bailout;
> +			} else if (len != fwdt->dump_size) {
>  				ql_log(ql_log_warn, vha, 0xd013,
>  				    "-> fwdt%u fwdump residual=%+ld\n",
>  				    j, fwdt->dump_size - len);
> @@ -1025,6 +1045,7 @@ qla27xx_fwdump(scsi_qla_host_t *vha, int
> hardware_locked)
>  		qla2x00_post_uevent_work(vha, QLA_UEVENT_CODE_FW_DUMP);
>  	}
>  
> +bailout:
>  #ifndef __CHECKER__
>  	if (!hardware_locked)
>  		spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);

Being aware of this issue I reviewed it for sanity and code. I cant
speak to functions that interract with the firmware though.
Looks good otherwise

Reviewed-by: Laurence Oberman <loberman@redhat.com>

