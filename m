Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58A0384CE2
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 12:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781267919; cv=none; b=AdTEyVzSeaVIfV0fCL7NyQbojUnA3zNDNeOI6MtNweI18cHVgv9mMLmOw3E1QQ298X7ShzFaAscQ5js5fKa4+tnBBHoDK2xiNSpV99eW0x8c6ypFpboRx1cTS4r+34oEPm697Nf7MN/Myq29T7XIuySLSJwyTwriq2/4GvhmxyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781267919; c=relaxed/simple;
	bh=iKDWa0+iZA9iqiIw5XSZMNkPluaduyEH5tJA0y61uLI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fdJZu03KpBqB9kyi9/CQqm82YaExDCuWB4PEC2YREm1jKSO1YEY/QjGek0L8eTkasYkDOFpok6nCQw30BaAdIz/oag1aFbcsPdir5aqNHnO62jz72SkUwcOMri6s/QTjxV2fgSOuMcWoL1iGO0Rymy1dTtHGLFFx3R84bbWVuO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Z9vSjULB; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Z9vSjULB"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-45ef41adbc1so692859f8f.0
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 05:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781267916; x=1781872716; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ork1ETzTtwfBIKB7qNyimsTgqVStlQ6RsZRTIWVABpU=;
        b=Z9vSjULBOzwfUdpBog3ZdfIPPYYMCMw48vggQLbHg8RSEGDvzniVj6pNHvdLM2oIU+
         wPasw/6i+uBaYfQs5s6IlT+M5nacBrp7xiHqbXPsz7XY1RIVuxPSx8VGy8qdlNLjNIEP
         cz2uz94fFspm9thJaXSYKsdHaT9ZlYoNrexy7l1X7mDYg/ZSPmX6GxIE9mQwUjYjm5Pm
         OaqRofYzluVIE5mTGZSZYOYZjlb9nOoibh9Zp9yjtW+0Ewf3FhFGqaa1nLi7LF70/6+U
         5egnEu4Ecqp59MclrCRnMPMzju6r8GL23ui6laqYTcQGryHRNuusn0Tqm9WkYU5fg1IR
         AJmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781267916; x=1781872716;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ork1ETzTtwfBIKB7qNyimsTgqVStlQ6RsZRTIWVABpU=;
        b=DkjybtIsyvwcAren62lnclRxp2tXrv3wRzV4rOzAXeceFk+ovv9lx3KQ1EqHZWfKzc
         fj7IMPIlLQb5SqRNeAomsn/1VyThL0npWy8+3/ZZo49QmtCw1DZKWADHWXCABN/YfslU
         gg9hDBK+yqB2Oj7eZLXnNO7c4+nug7s9PpPDZg+sSjOY8k+gNtBiLYr+KxqkrQDsP+iy
         GPGQDw64kwME0vk0/Y0733eHYQZHI2H+SP2s3FOMqxqbjop54WW4VKAXtc33xoK5VDB6
         xRJOCcgFLgFF106ZkVoCpJZa3doBUMSi1x7Ohc4wx6gwzjCNWtXOgzB/zNYsUf5oWoi5
         QBxA==
X-Gm-Message-State: AOJu0Ywn/xP/vA717CfPhHkDIJ2Hj7oSWd0ZBV7KN05QdNC+7OYyKmob
	g6k85Gy2/n9iLWTWCBdD11s9IedKn628xE1Yi5WAZX+4OfHHmqrk81v3xhzOdf4hZWA=
X-Gm-Gg: Acq92OFfUDnpMZ8cHbkohHcdUJ2OSJv9HMgXsxksaPzDkyDNKLuuzvo3Qgpyl1HTKsh
	+Dy8SFWMHMWv9qFB+S+0okkvSWvvXOSo3l3n241UHSmCVftU2GZ2Aqq1x4OnJVp8JpRl6+LkA9k
	SyR04lxDRHwsvvKByWk+VSswwMYxjNvwlRWRizsnVAlHz1unv/1L5fnOJOlbBTLzY8EH9yLfY1Q
	67cXFpeGbJMdg5dO62yMjSzhTwJSDp6/n3lgTe6ZGWzJsgVBChfrY71AMM7VTAH7RIfZbLdGd+G
	PbDEyVvaFK9HcAuapHis3aqR/IjN4a6yGBwEg+6Vgh1PIEKAdpGBuJIU84boHfm5jq9AsZ/rhf8
	VTBu7lrCLkHcjvbuRileyKopAEy+LtpIbQlb6gQrh8xBv6AuJAzyMqhD3M6b8apY8UgdMfCnMJv
	TZgCbaTz0kD9FpaR3rZ/ZRTKYSEAF7pG5TilsRbrgFYyCdMQ/Es/6tKDnS
X-Received: by 2002:adf:e010:0:10b0:460:3210:4349 with SMTP id ffacd0b85a97d-4606dbc1619mr3013577f8f.42.1781267916075;
        Fri, 12 Jun 2026 05:38:36 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c473bsm5529626f8f.28.2026.06.12.05.38.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 05:38:35 -0700 (PDT)
Message-ID: <bc577949-bb5d-45be-b1c3-8d38ffbc33f9@suse.com>
Date: Fri, 12 Jun 2026 14:38:35 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 36/60] scsi: qla2xxx: Add abort command handling for
 29xx series
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-37-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-37-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> Extend the abort-IOCB code path to support the 29xx extended
> abort_entry_24xx_ext structure alongside the existing
> abort_entry_24xx.
> 
> The two layouts overlay byte-for-byte through req_que_no
> (offsets 0-17): entry_status (offset 3), the
> nport_handle/comp_status union (offset 8), and options (offset 10)
> sit at identical positions in both.  After that they diverge: the
> 24xx variant carries reserved_1[30], port_id[3], and a u8 vp_index
> at offsets 48-51, while the ext variant places a __le16 vp_index at
> offset 18 and drops port_id.  The drv / fw unions live at offset 56
> in the 24xx layout but offset 24 in ext.
> 
> Leverage this overlap by using a single struct abort_entry_24xx *
> view for the common header writes (entry_type, count, handle,
> nport_handle, handle_to_abort, req_que_no) and completion-status
> reads (entry_status, comp_status), branching on IS_QLA29XX() only
> where the layouts genuinely diverge:
> 
>    - port_id (24xx-only) and vp_index width on the issue path
>      (qla24xx_abort_iocb in qla_iocb.c, qla24xx_abort_command in
>      qla_mbx.c);
>    - drv / fw union access in qla_nvme_abort_set_option /
>      qla_nvme_abort_process_comp_status (qla_nvme.c);
>    - completion comp_status read in qla24xx_abort_iocb_entry
>      (qla_isr.c) is stride-agnostic -- no IS_QLA29XX dispatch
>      needed.
> 
> Function signatures in qla_nvme_abort_set_option(),
> qla_nvme_abort_process_comp_status(), qla24xx_abort_iocb(), and
> qla24xx_abort_iocb_entry() are widened to accept void * so both
> struct variants can be passed through.  memset() uses
> qla_req_entry_size(ha) to match the ring-slot size.  Response
> status checking now reads comp_status instead of nport_handle.  A
> BUILD_BUG_ON verifies abort_entry_24xx_ext is 128 bytes.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_gbl.h  |  6 ++--
>   drivers/scsi/qla2xxx/qla_iocb.c | 52 ++++++++++++++++++++-----------
>   drivers/scsi/qla2xxx/qla_isr.c  | 14 ++++++---
>   drivers/scsi/qla2xxx/qla_mbx.c  | 45 ++++++++++++++++++---------
>   drivers/scsi/qla2xxx/qla_nvme.c | 54 +++++++++++++++++++++++++--------
>   drivers/scsi/qla2xxx/qla_os.c   |  1 +
>   6 files changed, 120 insertions(+), 52 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
