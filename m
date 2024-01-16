Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7A91BDC0
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jan 2024 13:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F+gJfu4z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705410263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EkZSOnIygpbJ+i2FOTNIbQzjiHiHU9Jj+ia6iKy7fds=;
	b=F+gJfu4zIo6UGDEA92mkfyXtcAO2YGFYTmaU0k0ULCxF0yaa3gn6338ARZB7TNX0xCUQf3
	tTDIg+OboFsZhujnfYxkidYfYVUZqaOUhRlmhmxRb8lhBT8Wx8QZCvXZqd1Y+UnzxV9E4h
	ak89IVxQce1fpgCgpV7cG1dir/DogLE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-356-Lz1xhmjkNRef1CWsoAMPMQ-1; Tue, 16 Jan 2024 08:04:21 -0500
X-MC-Unique: Lz1xhmjkNRef1CWsoAMPMQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40e479a51e4so40954725e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 16 Jan 2024 05:04:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705410260; x=1706015060;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EkZSOnIygpbJ+i2FOTNIbQzjiHiHU9Jj+ia6iKy7fds=;
        b=IvW0PNSXlkzHIHoVpqGMtbuJc5Bjf9pwQz8eqJzAb2Y/8PPFJdWwecqUpZRt5g0cTn
         lYBb44t6RzM8+NHt10amdQSgXIOya5J4HLAex4vi7cBCGBL4b521Rn94bf3poZzjPBat
         +WFl4PT0A/Xed5xTti+DjyUb/zBOXKHGfVzDnU/QN4NxvkmUwkUI+6axLrQj8W5nQdFe
         Jt7NtLP6F7oa97JUiO8F3/rBMUhcaPyI4Tt2KGp2+A5+E3UQ+tDSCXDgX0y3+NKjDwdL
         k/fgRlvdvJxZuUBkFtsVUfcS/yfS1Uk6Cy4U0WIxrEO5NuHKbqQLvxD6q5KBAIAi6pWe
         rcXA==
X-Gm-Message-State: AOJu0YzXBg1npwOIkpilVdAidoR1qFD3yTs8ruThVSYqwQeGdCDRLP95
	gJYN4a+L3GVHyzXk50A5ImP5xanvuCMSt9s9qgU2eOqC7g9Z5P9adj7R97K64UI2er+akshDsDy
	BJVzeoPkX9zwaKZ+ChfcVMeuqlHQQHQ==
X-Received: by 2002:a05:600c:4593:b0:40e:4deb:ebb8 with SMTP id r19-20020a05600c459300b0040e4debebb8mr3969358wmo.110.1705410260619;
        Tue, 16 Jan 2024 05:04:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHyZdcsasGz47vtQaNB8csj3bWm95OR3KENXLPC0whD1sH4fuYcQBxPhDpk8+TYhBCKD+yU/Q==
X-Received: by 2002:a05:600c:4593:b0:40e:4deb:ebb8 with SMTP id r19-20020a05600c459300b0040e4debebb8mr3969351wmo.110.1705410260253;
        Tue, 16 Jan 2024 05:04:20 -0800 (PST)
Received: from redhat.com ([2.52.29.192])
        by smtp.gmail.com with ESMTPSA id u21-20020a05600c139500b0040e4a7a7ca3sm19339021wmf.43.2024.01.16.05.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jan 2024 05:04:19 -0800 (PST)
Date: Tue, 16 Jan 2024 08:04:15 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Li RongQing <lirongqing@baidu.com>
Cc: jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com,
	jejb@linux.ibm.com, martin.petersen@oracle.com,
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] virtio_scsi: remove duplicate check if queue is broken
Message-ID: <20240116080403-mutt-send-email-mst@kernel.org>
References: <20240116045836.12475-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240116045836.12475-1-lirongqing@baidu.com>

On Tue, Jan 16, 2024 at 12:58:36PM +0800, Li RongQing wrote:
> virtqueue_enable_cb() will call virtqueue_poll() which will check if
> queue is broken at beginning, so remove the virtqueue_is_broken() call
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>


> ---
>  drivers/scsi/virtio_scsi.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 9d1bdcd..e15b380 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -182,8 +182,6 @@ static void virtscsi_vq_done(struct virtio_scsi *vscsi,
>  		while ((buf = virtqueue_get_buf(vq, &len)) != NULL)
>  			fn(vscsi, buf);
>  
> -		if (unlikely(virtqueue_is_broken(vq)))
> -			break;
>  	} while (!virtqueue_enable_cb(vq));
>  	spin_unlock_irqrestore(&virtscsi_vq->vq_lock, flags);
>  }
> -- 
> 2.9.4

