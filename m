Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294D020D50C
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 19:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755114280; cv=none; b=c9ZazjE4cysGzp0kbg3bSEmhM1Xe5Sf/gTCpeSmdza0aN1C+rkO0RPUSxR2q4wnalGgar9eRtff2zYH+zfQVTMHesbJgFpsKiRNwyG7cUuppeVkhPT66mTrXX1UnMaqu2H1vAHckxC5K5hE9WyZIOZjhe/rxXsGtEZKl4kg7chk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755114280; c=relaxed/simple;
	bh=mNq6e3TKjX+9irhzMzUq3HpgFzOKAFVgBrl4S9kDa/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ef1CcCWPWU5JEcMzdnuIWWHL7gIPVbV3F9Rvvv8HYxT0qqhsdwO7H2jDK7QlWq9td6e7OcZ2GvskGDat5bhGs7U1ywa7AHmL/wuFr/2TpNOfaxKl1NCAZ34Y80K0Pzk+vk5KREGRXY1BDBzcuBC45+HPRU45gk9kKle4yPm9avg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I2OasAGJ; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I2OasAGJ"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-242d3be5bdfso1575ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 12:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755114278; x=1755719078; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cPsZbTLE4UAWHCh1yPn15rSfmpWaBH3Qa9DtumCPv/Q=;
        b=I2OasAGJ+86bNShDnjyq3oT9hy7AMQHVwAzsa62WwnSA8HZxphrL7H1xcIC4/3P3nZ
         lGItkkbDYoAM2zSK6ChgUbUozs/T0XWCBltxMEs1gg6o/63CYdBd87kQLl903zMB0c49
         1sbAO2xxcPjj/ebItZHdd90zFNkxH6pvMxHRIfokAkkNoWqcyiIsicRNnEOWNv2dv7ZH
         tBs9YOw0keOpFGQ/1CsQJc+fQqELaOgSlb4gKZIHMTWTQuK+dIm47r3f9MMMIkJBrtgO
         86tr2p9xRhHt5INstw1wr9jpZ0xd3ydETixUDKcj3vu58GTLJKVfWDPIHuU2HPXdodQC
         hX3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755114278; x=1755719078;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cPsZbTLE4UAWHCh1yPn15rSfmpWaBH3Qa9DtumCPv/Q=;
        b=drD4dLU+yiq8XKUPaMA9mlMuQ+7uvRWierkZ4v0GdIQRIdPMFvIsdlqErB5kugpmW+
         RI8XJYunHVzYaAeK21y3qaAeTXFhB6nxLlg9GToF1v16h7w7A1k7ePVDVji1d8nwsFA9
         5jus+8jVoJGnNs0dhzjr7qf7xNCPcEgMNe1fxpZe5sUvemBJoguLTHeOQ2efAfaLygnV
         EyuGgBn8JRURQSJuLj/IZXi3jldxd3qriixHWiWo35ohMnsiUSWfHnxf0Y6CunRS58m0
         A9JgDM4VOwoEUScstTReo8ioslH6jZX6jguJFA7ogKCBXeAjDPxdC2+iZlZTaEpRJt2j
         Dmbg==
X-Forwarded-Encrypted: i=1; AJvYcCWB2RAjQDr22qZDyIINXkJOVKLwGJAjp93KVPceqRhODN6WngEp+jS1cVHfqu9FWw10ToiwPcWqLhJx@vger.kernel.org
X-Gm-Message-State: AOJu0YwN2Yho69xLledFYph6CYAjfaNTavnSR8fswR509v3Z/HjTOBFF
	KvLH8ibjRDM6uLZyMbF/4vRZcAl74VLVQDmZ91yD7XnPq9WGEOaBscDXh10r9h2SeQ==
X-Gm-Gg: ASbGncumQ12FWy5Ck7R63jw98uJ3seETvYBrSggYDBQMGxYA6/VvtNVEfIG2vJn0upJ
	NLpRO5ULQKQ0M7hTGEPQRlZSyrLRWrlbtWOgH8BSrEqxHte9jJ6PKj5DGq2xwvHPxjmN2pR3D77
	dJrHduldLl8RY9muL2ZwPK1N5f950cVosZX/wQC5Z+R8rWUF6m9a4mMuF2EMqGhjc8uPU0tV7l2
	d5dLOWNQ6/4h4WcSjzljoxrhYw25ZJjOjdNTJ34uMESh/P7rwFspur91j4AuwD8luPAMi0S/Anr
	bwfYiWDlp3VdPoz7MeZGIK31/PaMZNZazKPMwV4iU+R3+taGAibD7CZPaE0mi/vUcQ6K3XmLhPR
	NqaQl+Q6QLXFQpPtjyZxff9+gO0vZtee1RfMDr/dyVY/3NcESK8M8ow4eb00baX1ztzId
X-Google-Smtp-Source: AGHT+IFYJjwEUmoMEHzxOdtk0VxFXlcSflItY2UyICg/Avp9nijSZZKql2h85XgyKqnnphyVa9cR7w==
X-Received: by 2002:a17:902:ea12:b0:236:7079:fb10 with SMTP id d9443c01a7336-24458ddede5mr237405ad.3.1755114278006;
        Wed, 13 Aug 2025 12:44:38 -0700 (PDT)
Received: from google.com (57.23.105.34.bc.googleusercontent.com. [34.105.23.57])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-323257cb6a7sm858503a91.32.2025.08.13.12.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 12:44:37 -0700 (PDT)
Date: Wed, 13 Aug 2025 12:44:33 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: Niklas Cassel <cassel@kernel.org>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Terrence Adams <tadamsjr@google.com>,
	Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/5] scsi: pm80xx: Add helper function to get the local
 phy id
Message-ID: <aJzrITmXLWp3y2go@google.com>
References: <20250813114107.916919-7-cassel@kernel.org>
 <20250813114107.916919-10-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813114107.916919-10-cassel@kernel.org>

On Wed, Aug 13, 2025 at 01:41:10PM +0200, Niklas Cassel wrote:
> Avoid duplicated code by adding a helper to get the local phy id.
> 
> No functional changes intended.
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: Igor Pylypiv <ipylypiv@google.com>

