Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A0A3A7F5D
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781263224; cv=none; b=X5ZJxsxO/2mXFTPdAUZ5IVQfonoA7KdMzVHratyrSG5UVrpo3Ck/tzjVcOoFUknDVfHB3370Ofln8mE9QWfhOISjp77yM0x54yrQVgPuA2JHCOGSIufm6IaCXEZqhqm839+8uuvM8tWB8q90g5Gdpi6r4Fh8b9XRlyWFbkakSZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781263224; c=relaxed/simple;
	bh=XMLNVnhWBi7p+74vEzkkxOFlzN/z5ncJuRKtUxp3iw4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XlHzMfDjfXlVZS/IIAU46f/xpC20CNLeamiUvR1AyRZBBSnLLfe/ABzwesgH6YViQzTJvMMg8ZQ7C8oikZvGi7KQPueku6bFnblTFPqGJ6NVJcA/A/++jL6HDjWCrEnR39hBp5dQsi6p2/rMmowtrcB9jh8Aibr9ZzLPP7QS5sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FFoCSlE3; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FFoCSlE3"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490cdae130cso4449855e9.0
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 04:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781263217; x=1781868017; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uFQKjWylAEAtaE8lJ5+Jta6x8jdquEmB4dQrdUCRvZ8=;
        b=FFoCSlE3UEvoxaa/CTRGxX5o1pWnPEfxKh2ob7T35/ErNkDsZjIhRWTCMOD1kf9kkZ
         uDok+z2ax3e+oEOOUpHXr/CyLunf4gCa+eIfdZi+uR+mYNWBbBtT0eME8l7qNdCgutOs
         AdUmB4SFJfI5PX6OHTLLtxP6SYd/kTwZlyDfv6sZr7/vmypSytRBM+rH8wPnOFLT5uSF
         Kzr16+jsNLSSYEGYSQBMcgDZt09dzsZ399uKUQYSSbZWJ4GnNSkjllBH6+1wu3ZwDM8R
         bKSPWkvdl6bxu0SodgTwbrqI6uvcLTPxoQ9TfFsWYUIeE3JBBrUgLUrX9U/bZaQNYp34
         LXbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781263217; x=1781868017;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uFQKjWylAEAtaE8lJ5+Jta6x8jdquEmB4dQrdUCRvZ8=;
        b=ky35iCnKgWblJgs8V131GDIl8l95tLVErCg4yrASjn/mQIqhU8qcNlBhPbL4dlkw1i
         Y6kAUF6+JbO9sBdXa4c0JAQPFuL1jxXb2zz4pH930vSVoDr+prrKHgnmAH8fjy1KM2AC
         HXHhQBzWdcEklkDTbjqhd8mvQ4CpwGRGT3s7tx3m8mmZuTHZtVkuAHM8popBx89olq6H
         I3E3mL7PVqsEqX459qwvpHgulH+LQObHsg6lfN/xq7smLvOnnMX0VrmnZSYNkZyJ/ev4
         BWHgZYXRAwNeRyTL9DPSCo9RcZ/5gWsA2GDnx4mtQrd16h2dJ9V844MX5cVxHf+Zj1Xz
         8RNg==
X-Gm-Message-State: AOJu0YzteXqiWRLmRZqUK16bMYR1kGqDolpdycTu1Ce1BXvMyP07EirR
	+B5aWo/DHpCMba2ttJuK6207YTK3jK5rC3KGl3etbJbG7bmo4jb1CCfjN5kXTkBtw8Y=
X-Gm-Gg: Acq92OGtSp2IDcxB4n//YrgFnmBDp3sBM3K+KTahrYQj6bP/a92JcvJrHj8QAUnY0NH
	DfCgYTQ8WJp+5VsqyN9MdivdMP3sQD+kCpvVUXZHDAMTVHzfkIf/vqQQLfbLKmb3OicRphmHuam
	vkIwAuLOM7BZUDTq8AnR9Hea3wc9E/hupIH+j1hWCU0wNFHhCO65W4uESge07kl+3NHJVRWJt89
	mXa09Z7wjjhBhVhoqaRKN8sMajFD1JTw2VHvDZRBjF0vxzMVi5HqGpIWSgwZpxs6i+vKdHWc7l9
	K9q2WXImaGbB25kNgiBXybw0pR4McLI+Bk1CadRGsDwf2+7+qtGUOICPjJE5v/QJJVESmTqxD/S
	ezdQm6sraP+JdSs9KePRzSz8if+RMaEEYgwJFQVzT6X70B9asvg1jy0mddZ9b5dx7T221eVuKuu
	PGl64S2n1ruiah/6nw44U2XhWjNlOCSZV9wos1wFPmNqmlMPGyIT40wGW+
X-Received: by 2002:a7b:cb09:0:b0:490:5466:8576 with SMTP id 5b1f17b1804b1-490ec4b906emr19252375e9.1.1781263217325;
        Fri, 12 Jun 2026 04:20:17 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2b1056sm4927495f8f.18.2026.06.12.04.20.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 04:20:17 -0700 (PDT)
Message-ID: <f7678b0f-38d6-468d-af96-f8f297000899@suse.com>
Date: Fri, 12 Jun 2026 13:20:16 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 22/60] scsi: qla2xxx: Enable set_els_cmds and echo_test
 for 29xx
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-23-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-23-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:52, Nilesh Javali wrote:
> Add IS_QLA29XX() checks to qla25xx_set_els_cmds_supported() and
> qla2x00_echo_test() so that ELS command support and echo test
> diagnostics are available on 29xx series adapters.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_mbx.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
