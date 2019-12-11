Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E3A5C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 23:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EDA8222C4
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 23:05:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f33R7rTH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfLKXFP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 18:05:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51944 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726368AbfLKXFO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Dec 2019 18:05:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576105513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sx72Zu8R4y3Ns6A0Elwe6ONN3kNLN0tIVRBIzDH4IQA=;
        b=f33R7rTHeMiaCbaN9YlBB5UWejMrxj+dBl1/h/LVzEmy2u4zDoApnHvl4PvjtZYIt1GEjM
        VtlsIIxUpCdDVTnn3SswSw++bBGFc80RffHVgNWCpz0+MW+guQd2JOvoRp6skJ07wA6gb8
        MSdeCkutOBsA+dJ4hUDF4DiESqQcnUo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-41ZyriFjO8WCdr8Zwyorsw-1; Wed, 11 Dec 2019 18:05:12 -0500
X-MC-Unique: 41ZyriFjO8WCdr8Zwyorsw-1
Received: by mail-wr1-f72.google.com with SMTP id z15so234016wrw.0
        for <linux-scsi@vger.kernel.org>; Wed, 11 Dec 2019 15:05:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sx72Zu8R4y3Ns6A0Elwe6ONN3kNLN0tIVRBIzDH4IQA=;
        b=FQ4YFfU8NAxHWzA/hIwd4BmyNG++tFUVXerf0V1fPBXkyqVfr3xVKm4cXJKTQBBKu7
         WzVZQvHB4uhJFbyHGiSnYtqz9XRLTOiItJ+XdrhnASh+MHCO6l26CJR2nmPIBczMvD8G
         vl92iWrNBKkK9184qfCFNmNMazhvU8Uz7Gqriwf7M9UH/ijjzlnd9pzUs5qAVFlAIH62
         sfLxZU+/Ogjwiubtu4SG/x5UjAbsC2xlXgyqDH32bNxQhRqwJ0yfB01irAP/KVtWWTOe
         /GIM/PWGnwKvICUaVjVYkEjNCzlI70EspcOlYeXEqlIIG44J4fkUPoRP7Me4RynAT9ck
         pb8A==
X-Gm-Message-State: APjAAAVTs+xxDvonFAnYrXpIN5Mpl3m8+OKZFSD790Pi3o62Sw+l6fe+
        cJDzi1SOE5OBsbsKKDuV9ciVxge885ZZXFm+Hc8nZRRkkkc+fO0zbPVQ54aAXUbLGcGlx1d5w5s
        qxh2M+ShBbtkDa4Xwf9u51A==
X-Received: by 2002:a1c:4008:: with SMTP id n8mr2404639wma.121.1576105511576;
        Wed, 11 Dec 2019 15:05:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqxpe9p8ejWiVLiuArWlu3PcE1o950G4BmpoXFY8faxUGRQT/Ci+xtr4RXgpMlISlS8MvrxukA==
X-Received: by 2002:a1c:4008:: with SMTP id n8mr2404621wma.121.1576105511390;
        Wed, 11 Dec 2019 15:05:11 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id g18sm3736144wmh.48.2019.12.11.15.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 15:05:10 -0800 (PST)
Date:   Wed, 11 Dec 2019 18:05:07 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jason Wang <jasowang@redhat.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        John Garry <john.garry@huawei.com>,
        virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 15/24] compat_ioctl: scsi: move ioctl handling into
 drivers
Message-ID: <20191211180155-mutt-send-email-mst@kernel.org>
References: <20191211204306.1207817-1-arnd@arndb.de>
 <20191211204306.1207817-16-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211204306.1207817-16-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 11, 2019 at 09:42:49PM +0100, Arnd Bergmann wrote:
> Each driver calling scsi_ioctl() gets an equivalent compat_ioctl()
> handler that implements the same commands by calling scsi_compat_ioctl().
> 
> The scsi_cmd_ioctl() and scsi_cmd_blk_ioctl() functions are compatible
> at this point, so any driver that calls those can do so for both native
> and compat mode, with the argument passed through compat_ptr().
> 
> With this, we can remove the entries from fs/compat_ioctl.c.  The new
> code is larger, but should be easier to maintain and keep updated with
> newly added commands.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/block/virtio_blk.c |   3 +
>  drivers/scsi/ch.c          |   9 ++-
>  drivers/scsi/sd.c          |  50 ++++++--------
>  drivers/scsi/sg.c          |  44 ++++++++-----
>  drivers/scsi/sr.c          |  57 ++++++++++++++--
>  drivers/scsi/st.c          |  51 ++++++++------
>  fs/compat_ioctl.c          | 132 +------------------------------------
>  7 files changed, 142 insertions(+), 204 deletions(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 7ffd719d89de..fbbf18ac1d5d 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -405,6 +405,9 @@ static int virtblk_getgeo(struct block_device *bd, struct hd_geometry *geo)
>  
>  static const struct block_device_operations virtblk_fops = {
>  	.ioctl  = virtblk_ioctl,
> +#ifdef CONFIG_COMPAT
> +	.compat_ioctl = blkdev_compat_ptr_ioctl,
> +#endif
>  	.owner  = THIS_MODULE,
>  	.getgeo = virtblk_getgeo,
>  };

Hmm - is virtio blk lumped in with scsi things intentionally?

-- 
MST

