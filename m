Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40189C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Feb 2023 19:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjBITc7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Feb 2023 14:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjBITc5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2023 14:32:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4045410259
        for <linux-scsi@vger.kernel.org>; Thu,  9 Feb 2023 11:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675971136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8jrK2YNir1bgQRN+MIHEWOVTosfuI8LSGbLJCFEU3Ps=;
        b=NFMpOkChL8CDJ7q2e91E3xELPS7CoNscLrYbOeJOUor3WHZEJhHMx91H41r4BENTYsOlgC
        0N0xkxvgvbthmtXNhkqJarZ2AJehgu3CAQlN6t9kLXNYw+lCX407TBqsAaSDHVDRbM7dy1
        Zr21baoPGwj/efXT1k+d0Lv2Y8V9unU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-520-lVfjWezNNWuj9Ctq_aFrZg-1; Thu, 09 Feb 2023 14:32:15 -0500
X-MC-Unique: lVfjWezNNWuj9Ctq_aFrZg-1
Received: by mail-wm1-f69.google.com with SMTP id k17-20020a05600c1c9100b003dd41ad974bso1420950wms.3
        for <linux-scsi@vger.kernel.org>; Thu, 09 Feb 2023 11:32:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8jrK2YNir1bgQRN+MIHEWOVTosfuI8LSGbLJCFEU3Ps=;
        b=tmopdtezWQQ1hVbqrRkKtiMKQqRw28i5buosUUPk9RupdgAP0JY39/mm0hBDR/WuD3
         yIIrb5RZweCBCxS9i5Oa8KvDLAftfpgQ38KoYjeXwN2+P5l9z3WDh/XXBhysSwxbpf/o
         DDavr+kntFabi0oEjCCH6mQGyDp+hdy+15hJ8enRxQ6Ub5MXEnIo3WFLk5dto00LcJyh
         WDBOOpFUI/mKXqrlNwuoICWmfss56HWde4+CVhAwWH9ps4r3loq/renWEzPI/7AmNzi9
         DaLu5JvzkqqD3oUzZsbKnE6c6vQRBvWQvVX4IlutOIyFTMx5oy7XJBm5GatPH3mNSucV
         lZ5g==
X-Gm-Message-State: AO0yUKW5Kwy5EorWIk9HRjmH/HiRSsUU8p+mktJVhqUJlZET5OZlciMp
        6d2VqpRuDqs8OTvoXdTTNJW/NWxgUJucItTY0o4vAuX+tH3sRMPmEriSjIuVt7/swYR4yKt9H5h
        hMDKXTYa5P74waZFP/M+d+VfsqQaVt6mSPh1sdQ==
X-Received: by 2002:a5d:6a84:0:b0:2c3:f0c7:4086 with SMTP id s4-20020a5d6a84000000b002c3f0c74086mr274933wru.284.1675971132628;
        Thu, 09 Feb 2023 11:32:12 -0800 (PST)
X-Google-Smtp-Source: AK7set/u/krXuukexjvQKFkdCIGkQert2OxsqyobVdoIlfcN58f72AnCCaLk7wxWVoUt+SR4NMDx8ESciLi2ad50mqg=
X-Received: by 2002:a5d:6a84:0:b0:2c3:f0c7:4086 with SMTP id
 s4-20020a5d6a84000000b002c3f0c74086mr274928wru.284.1675971132376; Thu, 09 Feb
 2023 11:32:12 -0800 (PST)
MIME-Version: 1.0
References: <20230209034326.882514-1-muneendra.kumar@broadcom.com>
In-Reply-To: <20230209034326.882514-1-muneendra.kumar@broadcom.com>
From:   Ewan Milne <emilne@redhat.com>
Date:   Thu, 9 Feb 2023 14:32:01 -0500
Message-ID: <CAGtn9rkC0dJogzd8EqwushpYf7aSV6Y-zUVYQ+AzcKGNWvf25w@mail.gmail.com>
Subject: Re: [PATCH] scsi:scsi_transport_fc:Add an additional flag to fc_host_fpin_rcv()
To:     Muneendra Kumar <muneendra.kumar@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com, hare@suse.de,
        mkumar@redhat.com, Anil Gurumurthy <agurumurthy@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks fine.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

On Thu, Feb 9, 2023 at 5:32 AM Muneendra Kumar
<muneendra.kumar@broadcom.com> wrote:
>
> From: Muneendra <muneendra.kumar@broadcom.com>
>
> The LLDD and the stack currently process FPINs received from the fabric,
> but the stack is not aware of any action taken by the driver to alleviate
> congestion. The current interface between the driver and the SCSI stack is
> limited to passing the notification mainly for statistics and heuristics.
>
> The reaction to an FPIN could be handled either by the driver or by the
> stack (marginal path and failover). This patch enhances the interface to
> indicate if action on an FPIN has already been reacted to by the
> LLDDs or not.Add an additional flag to fc_host_fpin_rcv() to indicate
> if the FPIN has been acknowledged/reacted to by the driver.
>
> Also added a new event code FCH_EVT_LINK_FPIN_ACK to notify to the user
> that the event has been acknowledged/reacted by the LLDD driver
>
> Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_els.c     |  2 +-
>  drivers/scsi/qla2xxx/qla_isr.c   |  2 +-
>  drivers/scsi/scsi_transport_fc.c | 10 +++++++---
>  include/scsi/scsi_transport_fc.h |  4 +++-
>  4 files changed, 12 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 569639dc8b2c..aee5d0d1187d 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -10287,7 +10287,7 @@ lpfc_els_rcv_fpin(struct lpfc_vport *vport, void *p, u32 fpin_length)
>                 /* Send every descriptor individually to the upper layer */
>                 if (deliver)
>                         fc_host_fpin_rcv(lpfc_shost_from_vport(vport),
> -                                        fpin_length, (char *)fpin);
> +                                        fpin_length, (char *)fpin, 0);
>                 desc_cnt++;
>         }
>  }
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index 46e8b38603f0..030625ebb4e6 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -45,7 +45,7 @@ qla27xx_process_purex_fpin(struct scsi_qla_host *vha, struct purex_item *item)
>         ql_dump_buffer(ql_dbg_init + ql_dbg_verbose, vha, 0x508f,
>                        pkt, pkt_size);
>
> -       fc_host_fpin_rcv(vha->host, pkt_size, (char *)pkt);
> +       fc_host_fpin_rcv(vha->host, pkt_size, (char *)pkt, 0);
>  }
>
>  const char *const port_state_str[] = {
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 0965f8a7134f..f12e9467ebb4 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -137,6 +137,7 @@ static const struct {
>         { FCH_EVT_PORT_FABRIC,          "port_fabric" },
>         { FCH_EVT_LINK_UNKNOWN,         "link_unknown" },
>         { FCH_EVT_LINK_FPIN,            "link_FPIN" },
> +       { FCH_EVT_LINK_FPIN_ACK,        "link_FPIN_ACK" },
>         { FCH_EVT_VENDOR_UNIQUE,        "vendor_unique" },
>  };
>  fc_enum_name_search(host_event_code, fc_host_event_code,
> @@ -894,17 +895,20 @@ fc_fpin_congn_stats_update(struct Scsi_Host *shost,
>   * @shost:             host the FPIN was received on
>   * @fpin_len:          length of FPIN payload, in bytes
>   * @fpin_buf:          pointer to FPIN payload
> - *
> + * @event_acknowledge: 1, if LLDD handles this event.
>   * Notes:
>   *     This routine assumes no locks are held on entry.
>   */
>  void
> -fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf)
> +fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf,
> +               u8 event_acknowledge)
>  {
>         struct fc_els_fpin *fpin = (struct fc_els_fpin *)fpin_buf;
>         struct fc_tlv_desc *tlv;
>         u32 desc_cnt = 0, bytes_remain;
>         u32 dtag;
> +       enum fc_host_event_code event_code =
> +               event_acknowledge ? FCH_EVT_LINK_FPIN_ACK : FCH_EVT_LINK_FPIN;
>
>         /* Update Statistics */
>         tlv = (struct fc_tlv_desc *)&fpin->fpin_desc[0];
> @@ -934,7 +938,7 @@ fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf)
>         }
>
>         fc_host_post_fc_event(shost, fc_get_event_number(),
> -                               FCH_EVT_LINK_FPIN, fpin_len, fpin_buf, 0);
> +                               event_code, fpin_len, fpin_buf, 0);
>  }
>  EXPORT_SYMBOL(fc_host_fpin_rcv);
>
> diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
> index 3dcda19d3520..483513c57597 100644
> --- a/include/scsi/scsi_transport_fc.h
> +++ b/include/scsi/scsi_transport_fc.h
> @@ -496,6 +496,7 @@ enum fc_host_event_code  {
>         FCH_EVT_PORT_FABRIC             = 0x204,
>         FCH_EVT_LINK_UNKNOWN            = 0x500,
>         FCH_EVT_LINK_FPIN               = 0x501,
> +       FCH_EVT_LINK_FPIN_ACK           = 0x502,
>         FCH_EVT_VENDOR_UNIQUE           = 0xffff,
>  };
>
> @@ -856,7 +857,8 @@ void fc_host_post_fc_event(struct Scsi_Host *shost, u32 event_number,
>          * Note: when calling fc_host_post_fc_event(), vendor_id may be
>          *   specified as 0.
>          */
> -void fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf);
> +void fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf,
> +               u8 event_acknowledge);
>  struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
>                 struct fc_vport_identifiers *);
>  int fc_vport_terminate(struct fc_vport *vport);
> --
> 2.26.2
>

