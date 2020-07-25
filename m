Return-Path: <SRS0=zQak=BE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0599DC433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 10:20:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6AB3206F6
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 10:20:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="spus77cQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgGYKUz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Jul 2020 06:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgGYKUy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Jul 2020 06:20:54 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3EAC0619D3;
        Sat, 25 Jul 2020 03:20:54 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id t11so6577662pfq.11;
        Sat, 25 Jul 2020 03:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yvszqsmZlg6itxeGw8L/x/wm1qBJqQZweDO1j96IDO0=;
        b=spus77cQf8R8Ufv34pZOkS6h7F4RUoF76Uz/b4+1iIACduk0vhcWn7Z1GFX+EFkxLR
         p2CbKkTO2nGKY13+7PRrYsQGa0K1q52eIE++tuolq2MNNnBQy8rI59xZmdFx2mIKvDWW
         aVV7AKxql0j8x8VJ+13Qy+fsPCM3XchTx52vGETEIr8cqIpnWr3xny6JMQpYkN5Nlqkv
         Z9jsXtWyQt9PVdpCBWbpJB7n5LEMmyr0RCmu+IWNoNdgIP2JWoGyDtddDx17yNxs/Vpe
         fzaTmYa0vUODDEeWlFXKB5sx5Rf2ow29Ng2bXLnFMWDukRGjd3zUONvwrsZTzkL6Vbx9
         jcGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yvszqsmZlg6itxeGw8L/x/wm1qBJqQZweDO1j96IDO0=;
        b=byRU5bFLONM3jNjn4v0VTY/BD/zqiaDjfekvJqor6AZ159DjWf97jrN+jmfeUbtpau
         EkXjMtQ+VkZkJLbCB8FxRDt3ZaBUQLjvjjAdIGjmaVLhSXI5DmpB7hZMDk98Py6vTU1b
         tBzU+DJesqtnOzkTP7Orjzr3OwX0A7GKCGO4SnWNyc+/t8AiAjdGR7V0oH3qMXTqGvcz
         KND0gDJ2B2StxX4+lx1ZZdwN6gOcnpeVuxplIDamxu/T+Srzr7DcpwIWvqWKE7eWfJxz
         HNn4rehLpAyXIhy75gGymQpU6Kip6/OeevK5KkbvpItIng0OIWvcQUYUCvi3mywxRDSJ
         lxfA==
X-Gm-Message-State: AOAM533CbKvbA3EDYLPUMwdObZmgcoxiJ0eEeItF08Rtr2nuVBUfdDe/
        6XCIEuZgXT3HdrS4CpXMiYJli9dssH2UdVsEQJ0=
X-Google-Smtp-Source: ABdhPJz0X5iLT59t4opLAqzgWSJH6IM58/2aP6ew7FM7GCnar7T5Pa42WdgNvCCTNvTMOgHHnxLcfpLH49dPCOVMUHI=
X-Received: by 2002:a63:ce41:: with SMTP id r1mr12254644pgi.203.1595672453929;
 Sat, 25 Jul 2020 03:20:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200724171706.1550403-1-tasleson@redhat.com> <20200724171706.1550403-5-tasleson@redhat.com>
In-Reply-To: <20200724171706.1550403-5-tasleson@redhat.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 25 Jul 2020 13:20:37 +0300
Message-ID: <CAHp75VdT8pMzy84J_JGU7xHfuTw1TVX1WCe-PXKyMdzuGh9gyA@mail.gmail.com>
Subject: Re: [v4 04/11] scsi: Add durable_name for dev_printk
To:     Tony Asleson <tasleson@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 24, 2020 at 8:19 PM Tony Asleson <tasleson@redhat.com> wrote:
>
> Add the needed functions to fill out the durable_name function
> call back for scsi based storage devices.  This allows calls
> into dev_printk for scsi devices to have a persistent id
> associated with them.

...

> +int scsi_durable_name(struct scsi_device *sdev, char *buf, size_t len)
> +{
> +       int vpd_len = 0;

What is the purpose of the assignment?

> +       vpd_len = scsi_vpd_lun_id(sdev, buf, len);
> +       if (vpd_len > 0 && vpd_len < len)
> +               vpd_len++;
> +       else
> +               vpd_len = 0;
> +
> +       return vpd_len;

int vpd_len;

vpd_len = ...(...);
if (vpd_len ...)
  return vpd_len + 1;
return 0;

> +}

...

>  };
>
> +

One blank line is enough.

> +int dev_to_scsi_durable_name(const struct device *dev, char *buf, size_t len)
> +{
> +       struct scsi_device *sd_dev = NULL;

Redundant assignment.

> +       // When we go through dev_printk in the scsi layer, dev is embedded
> +       // in a struct scsi_device.  When we go through the block layer,
> +       // dev is embedded in struct genhd, thus we need different paths to
> +       // retrieve the struct scsi_device to call scsi_durable_name.
> +       if (dev->type == &scsi_dev_type) {
> +               sd_dev = to_scsi_device(dev);

This...

> +       } else if (dev->parent && dev->parent->type == &scsi_dev_type) {
> +               sd_dev = to_scsi_device(dev->parent);

...and this along with pieces in scsi_bus_uevent(), scsi_bus_match()
are candidates for a good helper (perhaps with utilization of
scsi_is_sdev_device(), but maybe not necessary).

static struct scsi_device *dev_to_scsi_device(struct device *dev)
{
  return dev->type == &scsi_dev_type ? to_scsi_device(dev) : NULL;
}

sdev = dev_to_scsi_device(dev);
if (!sdev)
  sdev = dev_to_scsi_device(dev->parent);
if (!sdev)
  return 0;

And when introducing a helper change users at the same time.

> +       } else {
> +               // We have a pointer to something else, bail
> +               return 0;
> +       }
> +
> +       return scsi_durable_name(sd_dev, buf, len);
> +}

-- 
With Best Regards,
Andy Shevchenko
