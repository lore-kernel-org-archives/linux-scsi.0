Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899A4231849
	for <linux-scsi@vger.kernel.org>; Thu, 22 May 2025 09:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747905091; cv=none; b=Uejv91+L3HSsWHbk4EJXz+QbCKsjdqr0AjO5H3GPkHD6EDkKD4Yn3kJw0+0d15N/MjTNnXYzztSx2e5jRaUrYD4Vx3E/Oc0I24bo0kdK761msTQhILhne9I+h9GyQQbiZZK+xGFEf8c6XJEaHSgKuhLUEUTiQZ3MJxCZCuDHcb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747905091; c=relaxed/simple;
	bh=ZDC9x4MYunxqEojxt2QMnAUa/sa1GbM7hsgeW5aenQ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RtO1eicSM/Od79eD2ikX9UKBZ9dqHpx7W26/kS7Mu1S9CC3UwXk1THPd5GaZIibfeKHs5Zj5JqQMNGJVjHRGVadm14B/zvDjVqBBTFtHYqCKOnlD2+mIShd6MD95p3a6qPjCZh+iZDVZDEsOIdi5xfs3QP8oGQVnMgwlyEFo9PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d0RkTwnL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d0RkTwnL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747905088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Efw/xOoBR5JtsAGWTbkGb39F5QrJRSJy0Aiy1rPkylA=;
	b=d0RkTwnLqSfj3Fchi08koiFF1bUS0ZYlIgM/GNhR1Y13qYukU1EOmapWj7fQLJqamI8sRj
	RvbS366oTj1FIHYXBTkgj+d8E0MEoHGXeUTAyIQoaDilumkmo5HNl0lnXIOCWkCHOkbeJD
	z8fNqrXBRtlmXpR+IU57searNgtoRvU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-0yjYrtl2MCeIo7B62sbyow-1; Thu, 22 May 2025 05:11:24 -0400
X-MC-Unique: 0yjYrtl2MCeIo7B62sbyow-1
X-Mimecast-MFC-AGG-ID: 0yjYrtl2MCeIo7B62sbyow_1747905084
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43e9a3d2977so58128345e9.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 May 2025 02:11:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747905083; x=1748509883;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Efw/xOoBR5JtsAGWTbkGb39F5QrJRSJy0Aiy1rPkylA=;
        b=flGbUkNS+CYZtM4SW4tA3jOlwRlUXFH+dzuP4aU1yHQcNr4lsrabryR7pxN9n907/Y
         HyN6+MMVL6URxP3HIHfwuiJZrQymzTruYj7Nn0uRoEorMXROBRXYHwXccSW3Y4Idtusq
         OCjSV1C2bhcRF5duc4r1TcI3eDmrT+3K3/1eIA4ygwjebR52SXygF4m5hc8naxsiE6cc
         /ArVtQ+3U/2AdIFnrZj1PCy+cL9G3uuw+P+8B/1zmGekY3btye3bkR0wfijE/68BZsqj
         wDPm5L/AeMZsxNNQv1sIz/no4bsTl14rCVcG0DVFhF7/nyPMlpuqfw7eZdyXCzO9UMhz
         fE6A==
X-Forwarded-Encrypted: i=1; AJvYcCXV/tB2LY9nRZP46YfnzaN4jhRaXNVesprWo7eXHUNvWbW/C0vrSUxNn53H69VWCwHFRSju3tje4585@vger.kernel.org
X-Gm-Message-State: AOJu0YwSvlKKLhOmTxMFYYMG8amYPeUKVjl05gaAQMiKOeu/hcRaFaw9
	0oMqA984SucKbAfa1j0ZDRV8pJqhV1+vNaCElDERoWx5YX00vbUo5jvS7OWYbQF6o0jciXyBgrz
	H+FSnc8LEyyaIT34PI9pJ1ogk9FYF5FEDurV6CKwZlKUE+DZ27P0olCbzoNHgH+A=
X-Gm-Gg: ASbGncuMZcCMU4gWCcDffIJ5xy+uZL85rGJVrJ+LO8Z0yanrMIFvMdOwSG4RA065qjh
	Q+JDKw8wtUmQMyPVMwt9/ljUp/bGRWlbaCOiNCHXgK3qaOBkRUs2muy2N8RpgMfK+eeJtMEmlfu
	V98FoYYzFrhxfyPQY0FvoM7epHsI9onjqUXjRHyqnCvVJxiwMk8JpxiKsX10GDQtA1Scbyh/Naw
	sb1DjLP6wGuY5u1AOAIJuupSejpIXZzBSSrP4GwtDqWxJ7iTHIp1lzcbafP+a9PA6xv6D8gxgCd
	MYtFduILgpeytOlHgFk=
X-Received: by 2002:a05:600c:a016:b0:441:d2d8:bd8b with SMTP id 5b1f17b1804b1-442fd622c81mr247895305e9.8.1747905083661;
        Thu, 22 May 2025 02:11:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEciTJ/zcRf4AXElu0pqBhYj5jKqeehae3NT83Gy64LvlkBARBipL5idMvjE3WFf06oe/P65g==
X-Received: by 2002:a05:600c:a016:b0:441:d2d8:bd8b with SMTP id 5b1f17b1804b1-442fd622c81mr247894945e9.8.1747905083275;
        Thu, 22 May 2025 02:11:23 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:247a:1010::f39? ([2a0d:3344:247a:1010::f39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f6f05581sm97329145e9.13.2025.05.22.02.11.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 May 2025 02:11:22 -0700 (PDT)
Message-ID: <f8640da1-c442-4704-8f0a-8d498e1b7e16@redhat.com>
Date: Thu, 22 May 2025 11:11:20 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 net-next 5/6] socket: Replace most sock_create() calls
 with sock_create_kern().
To: Kuniyuki Iwashima <kuniyu@amazon.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Willem de Bruijn <willemb@google.com>
Cc: Simon Horman <horms@kernel.org>, Kuniyuki Iwashima <kuni1840@gmail.com>,
 netdev@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>, xen-devel@lists.xenproject.org,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev
References: <20250517035120.55560-1-kuniyu@amazon.com>
 <20250517035120.55560-6-kuniyu@amazon.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250517035120.55560-6-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/17/25 5:50 AM, Kuniyuki Iwashima wrote:
> Except for only one user, sctp_do_peeloff(), all sockets created
> by drivers and fs are not tied to userspace processes nor exposed
> via file descriptors.
> 
> Let's use sock_create_kern() for such in-kernel use cases as CIFS
> client and NFS.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

The change makes sense to me, but it has a semantic change, let's add
more CCs.

Link to the full series:

https://lore.kernel.org/all/20250517035120.55560-1-kuniyu@amazon.com/

/P

