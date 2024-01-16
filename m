Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC361BC3D
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jan 2024 13:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F49Sni/2"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-2044ecf7035so6761444fac.0
        for <linux-scsi@vger.kernel.org>; Tue, 16 Jan 2024 05:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705410191; x=1706014991; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4QQOhcOxcHjrsKEhSRn9wdD7VWLozw48zKxCYRXjRUc=;
        b=F49Sni/294QWoEtTECij27GBxANwFobhJ91TrVZoraeaoGPJzG8FmINmGDy7Fg9KFZ
         rqAo4SlOLAjlWl9O3Daw4gT4OuBfPMrZnXQ/mMDxhOW3Q41trxlSz0ZXQ5oQy6/fzosI
         1Wz0jJEMqknPQ9C6v+Yv8UXA7xrdJv/2XRIROaPLqYQ4s9ctdlvntahffMOHKpIb9uvj
         /3UvH2nB76jCXxCjzU+lHWtyE7WCOqcSXmNkYfhXKt9GeYryAWWNqOnDJupd/T/DT4R5
         2pXfgZqy+fI/ZI4H+HFsgLlqP09aaPnayUCDyK+yHJzpDFAYGgJ5xVm6BWlXhDgVJ2Xe
         6R6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705410191; x=1706014991;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4QQOhcOxcHjrsKEhSRn9wdD7VWLozw48zKxCYRXjRUc=;
        b=g7rPXWjCTStXsgap4g+HkxnF4xWqMPW5OIKEBpyMeVtvXKdP/e6a8YMsS/vyKSWJCj
         /QuvbmEyB3EWGHlzgHmJmrUMb+6fa0lXNPAuxcFPjP8X0vQDLP6twLHXnAS3wNBqeJp2
         gXLwqZkQLbEQPTlDX3nyOQ/Ks3vWaeQB5qIZ1LgAIY1NTUHCF9qaKntamak0larQERBN
         unpG9IMAYHgzJdiXdNuEOVAl3gjxVBbrHHSrtqAJfv7x3Z9WS9PHBxqV3wS2G1aCxDDn
         XBt8G1ShTmkl+5qN5knVO4HEr+KzRus/gRE5VLHNH1Amwl+KvcIPkXa9XZv828i/f7QC
         D+RQ==
X-Gm-Message-State: AOJu0Yww6vK98VPURchLmR5g5+nRrN03zZlBHlnIsAudHmCRERSKyrqC
	w+lxs9yU/edMHvUyrya09dyQDpVBFQj7rnwZCJA=
X-Google-Smtp-Source: AGHT+IEHc8iWJOABWb8fxWWKi1I7C0y5nyBYocs11//L/21/CMkE8JCF7CFkbjKQLWYfmDj4McbiFoPeIgaenKNGk9Y=
X-Received: by 2002:a05:6871:48f:b0:206:bbc9:be01 with SMTP id
 f15-20020a056871048f00b00206bbc9be01mr9750039oaj.41.1705410190989; Tue, 16
 Jan 2024 05:03:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240116045836.12475-1-lirongqing@baidu.com>
In-Reply-To: <20240116045836.12475-1-lirongqing@baidu.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 16 Jan 2024 08:02:58 -0500
Message-ID: <CAJSP0QWgn9PPTH=Hc=Znt8eWrVbdjwzPb_iOsmRTYKEdMSqzVA@mail.gmail.com>
Subject: Re: [PATCH] virtio_scsi: remove duplicate check if queue is broken
To: Li RongQing <lirongqing@baidu.com>
Cc: mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, 
	stefanha@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com, 
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 16 Jan 2024 at 00:07, Li RongQing <lirongqing@baidu.com> wrote:
>
> virtqueue_enable_cb() will call virtqueue_poll() which will check if
> queue is broken at beginning, so remove the virtqueue_is_broken() call
>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  drivers/scsi/virtio_scsi.c | 2 --
>  1 file changed, 2 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 9d1bdcd..e15b380 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -182,8 +182,6 @@ static void virtscsi_vq_done(struct virtio_scsi *vscsi,
>                 while ((buf = virtqueue_get_buf(vq, &len)) != NULL)
>                         fn(vscsi, buf);
>
> -               if (unlikely(virtqueue_is_broken(vq)))
> -                       break;
>         } while (!virtqueue_enable_cb(vq));
>         spin_unlock_irqrestore(&virtscsi_vq->vq_lock, flags);
>  }
> --
> 2.9.4
>
>
