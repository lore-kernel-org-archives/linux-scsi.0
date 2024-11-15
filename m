Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5051D45FB
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 14:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731682727; cv=none; b=clTngfsduG/14NajVg56s/MsG7eiYxfXgiaiER+moMBbpEncFVAAbgfflfOGm/6iouTvwH8axfktJDMOpeP+dmKvOJzYzKS32cbwUyQ02MaFD3LjMdqf5rywIERgdj//7mBEo6TWOmvyIKs50a5xKvjz9xawQl3q9Pc7jT7+LUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731682727; c=relaxed/simple;
	bh=h6FPb6APcZinVuPfA9vqcx7VeGZpXNlSUGLGgaVY24c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C+2qbQKnWIJa+exeqQ1qoF5qPy24W5bonrivcPyicV6ytXECyobcPCyF+PwD+mie3yhESXGhwoVKTOPdtMtbJVZF6SL6NYaqaUYHFU1UI5nrISkADdShKOLpqnkFKkuJjS6vG+3UIvBmjPzOiwsSCw/LJCBFWScadPVlThzi39s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QNwHAah9; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QNwHAah9"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43162cf1eaaso20542715e9.0
        for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 06:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731682724; x=1732287524; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hYkpZrokgShRwnHNQLjF7bON9JaGTh89ekPw+/x3nnU=;
        b=QNwHAah9kVP/sNWU2STq7VkRoxkVXZGamU4WS7yQaeEw0/N8qUQr+JIqDhCJhVZ1id
         9xG79YRtEyqQvAQUIXY5nBdzEYkRQM7AqKu18ysWkT12f+UQG5HSQfpnQc69vndDDPKt
         WeqCCype31IP+ncWSd/jU4WCSBB7aHUcpj/cKpjPHbj3cB3vYypmq3UK3VIu2ZvZiW0p
         zVmgwJ4UG+udSvuWgB/BnDZvqYA4jvVUKQdrgsLY4AXVCjrJ4iNJCKtzJvRF0uMIxg86
         KatdWl/Ue/sa1HJZjauPgrE8pRJQn5QwT0mHSyetNys9nITJDQCeexQf7HGlQJ8STiAZ
         MTiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731682724; x=1732287524;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hYkpZrokgShRwnHNQLjF7bON9JaGTh89ekPw+/x3nnU=;
        b=VLSXlsUo2Gx9g6uwMCbuK46sQwohyACsr6ZHawApUQI2+zTYNuMQ45z3ESk3tC2V8/
         2NO0kv9Sr2t04mjeY0Pfbpos/tMp9Sq6ntnGz+RTvU51a/AhSN9F1rkAmrgBfqKLo5vc
         ObFIeW3gVU13zsrHfagzgit8+IcbGqVXGVVZ8fZlCe+YSzzB57dGF+dc3ZDOvou3fMgq
         wceiKe5cnYNt/wC4FuxOnEaqLMhtWRVG5TBjWMvsGfIe3EqoeB8GlpdnldCGT0p9gh5b
         C30UDKQuw5wv/Ok/5rr49Y2/eo6qJHBS+pemIogt2bHU6NroJleclKJLehFq0/J/orfy
         +5BA==
X-Forwarded-Encrypted: i=1; AJvYcCWLX1tENLD+q7IceV0/uZBYB0ucapfdU/HGTQ6CAkMOnB+8N410o0NBjLxeuOsJ/8gX73cbEMljoNOg@vger.kernel.org
X-Gm-Message-State: AOJu0YwBiEM0zSX2V5MTIUlKTMp6jWLfj9BFLt1S6FPyyzGXP4wzBY4/
	wTLMfJ2UaXE5pXeMKZJamjkZesq1xI/W5WocVai+krFUAWHbKG5kxojFegMCUw==
X-Google-Smtp-Source: AGHT+IF6n8Bg8dTBUu+QXMNFufC2/aYfVxkB6nJmnv7n+YroB5FKTPnPAnvS6Zdh3SLH4VxoPghK5w==
X-Received: by 2002:a05:600c:1ca9:b0:431:557e:b40c with SMTP id 5b1f17b1804b1-432df7937bcmr27028745e9.27.1731682724126;
        Fri, 15 Nov 2024 06:58:44 -0800 (PST)
Received: from localhost (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da27fc8esm60957785e9.21.2024.11.15.06.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 06:58:43 -0800 (PST)
Date: Fri, 15 Nov 2024 14:58:39 +0000
From: Aleksei Vetrov <vvvvvv@google.com>
To: Xiaosen He <quic_xiaosenh@quicinc.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, quic_jianzhou@quicinc.com,
	quic_cang@quicinc.com
Subject: Re: [PATCH v3] scsi: use unsigned int variables to parse partition
 table
Message-ID: <Zzdhn7aIR250WgVr@google.com>
References: <20241115030303.2473414-1-quic_xiaosenh@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241115030303.2473414-1-quic_xiaosenh@quicinc.com>

On Thu, Nov 14, 2024 at 07:03:03PM -0800, Xiaosen He wrote:
> signed integer overflow happened in the following multiplication,
> ext_cyl*(end_head+1)*end_sector = 0x41040*(0xff+1)*0x3f = 0xffffc000,
> the overflow was caught by UBSAN and caused crash to the system,
> use unsigned int instead of signed int to avoid integer overflow.
> 
> Signed-off-by: Xiaosen He <quic_xiaosenh@quicinc.com>
> Signed-off-by: Jian Zhou <quic_jianzhou@quicinc.com>
Reviewed-by: Aleksei Vetrov <vvvvvv@google.com>

