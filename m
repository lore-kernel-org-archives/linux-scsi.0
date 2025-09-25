Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4D82E62BE
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 15:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758814214; cv=none; b=nwN7JNlpYIv6zSGSsx9veZSkRlTkfqWEMRJKUlPyPbHsS8Rivkw9eSbRcBTMZhScnRVOyO3YxEKP9TZYXAt15RIh9bc2M/hnT5hHTUiBt0CJfEJQPUeJ/dprRCb8L2N6PnQdm71tJOhCppPjPDl7YAkTKKkj422ClxRFTyDKeOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758814214; c=relaxed/simple;
	bh=7embYRPF/5Q9/8iByQGHRwo8kMx6aLILpJkp6lh8BDQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=hYPFZURmOLOrGIqRXD1fmslMixGpC/c1IffzBELxvPBUpuj37spqbm1/YMPqQ6QZXuWLxei9CMF9SsQIzqzE+WJ/md2UJZs3Baz81u2JogcrAHaMdiqTT2oKABmBcNMVbztAw6Mc/DbCvehbZ3cstwd22hJ/j1P0V8TTaY/wocc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f90Q2eyg; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f90Q2eyg"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3f5d2d99b8fso25097f8f.1
        for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 08:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758814211; x=1759419011; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VF1Bqi8k7PXZlzWvyUXBJx9B9dWwFCwidqruMuP4DAw=;
        b=f90Q2eygaG4dc0yryHBMGZQ6RAsDgj/qQVgiqBJg0uemvGk1G1YyRGRLOAbfMUpdJm
         BDs7s6e7VxAbWWzDRwOpYu9HORzi3yPg7qWBHSMIia7wp3bcEvRl54Qd5k3Ol26KF0Iz
         XFMx0v41u4bQrq0PVQrn6t0G8kz8gM0V7BGPkxShESZFW6j+NdHFN4OS4xqsFMRZN1go
         1j0aWZOCGvqZ1DG1aueIzp3qrCMgL9XJqDOKosOnktamH/HVkmuChXLg5fQAAQMo4mcD
         PuihuQ3DyvW+FhF7pXrobXvTv3GVwYpcjJRxVkKbYjWGi9lo69fMf/gHakOqNWaG0dAi
         fw5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758814211; x=1759419011;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VF1Bqi8k7PXZlzWvyUXBJx9B9dWwFCwidqruMuP4DAw=;
        b=qgBumpGiVB0KshxaSDuC1ClzLCAXygjjovQj7WfxFbggLK0oRaJwaB1prXulS1Hfta
         u/ZzNNolcminaKY8UnS2SAju4CyqBt/IikZgA0aUwo+FnyPOdGg0qI8vifrD3nWt7Otq
         GaKSNy45BdCO6riXKCOzI7x79X5TdmDLzD4ssFxU9kt1bBOOjT0HqwgwUXwXEPyuGGzB
         mtpSpfP4gTGBfqBDrbnBhHK6B6l+6C62O/ijzw+ZDiSSGNqh2xgBIAAM+iIk7bnZLMuu
         HdBr/lZnGggxL7P4S5Tk2JeDxUEnZiKGnz6MLFh05ftqt2a/GYRW71qgK54NP8or237k
         y1eA==
X-Gm-Message-State: AOJu0YzBH9/RYGpH2R1nmXnkccVn1mYIgFmQS88lx1OPic0YGf12m750
	/KmQqjPrCvnSDVlh0wgfk3TrDXHrZslOzli+Da4vTMuoYYkbKIL62io=
X-Gm-Gg: ASbGnctRUkzdCBXrJrjhpxZarCBjXAZW+C0PQDON2tUEZ5dTAQ2uqswdERWzFhW7lF5
	/2aLCMaYv0sRlGxSmtey75ra1MY5HXh2a6H5SYnEvVRhXw8MVS1EmK4vNk+VWj/6oEfR9AY8B+9
	U4S7M+65Oi4uaCBT0J3OLZplGEc+0R5V34fkXlyAXH1xGpYmstZlvNsjg4+k3OUiBX++Bf/M9t3
	XhH5ifPpBLdRrzTOlQ0SiAzDSt+k95XPN815m5wyEaUZgjFf3AZoA1pEr1Yv/l3+90QVBw1cc5e
	KqHOkVVuUErt7ufR1N4SHumfSkyR4ULvl7VRqKzQQ+o/Vyk8vJ1k3Vo5WnUPtYFAZlbnrx5XPFs
	aMOyBpt9CqWW74Yy11rH7+HNOmekjVTjqUvVOGuKx4Z8tqh7yS8ntjSxFHVgr
X-Google-Smtp-Source: AGHT+IFqiPDWCPZpM+LXT8lqt7ta4cimw64WrasTX61w6SM4yI70RjOESL5EB0LuI187Xe9we0NonQ==
X-Received: by 2002:a05:6000:2a89:b0:3ec:db87:e8a9 with SMTP id ffacd0b85a97d-40e3ab888bfmr1778010f8f.0.1758814210739;
        Thu, 25 Sep 2025 08:30:10 -0700 (PDT)
Received: from localhost (20.red-80-39-32.staticip.rima-tde.net. [80.39.32.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb9c32734sm3546318f8f.25.2025.09.25.08.30.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 08:30:10 -0700 (PDT)
Message-ID: <8056aa80-7e5a-4cb3-804c-d9c7f8bd6d55@gmail.com>
Date: Thu, 25 Sep 2025 17:30:09 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 14/15] scsi: qla2xxx: add back SRR support
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: Tony Battersby <tonyb@cybernetics.com>,
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net, KERNEL ML <linux-kernel@vger.kernel.org>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
 <2cc10189-6953-428e-b34e-b1c714fc0eae@cybernetics.com>
 <0669b097-0bf1-4895-9c2a-5e953aebbfab@gmail.com>
Content-Language: en-US, en-GB, es-ES
In-Reply-To: <0669b097-0bf1-4895-9c2a-5e953aebbfab@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/25/25 2:49 PM, Xose Vazquez Perez wrote:

> If you want to review the firmware changelog, mainly: FCD-1183 (FCD-371, ER147301), FCD-259, ER146998
> (from 9.00.00 to 9.15.05 [06/10/25]):
> https://www.marvell.com/content/dam/marvell/en/drivers/2025-06-10-release/fw_release_notes/Fibre_Channel_Firmware_Release_Notes.pdf
> 
> It's look like all 2{678}xx devices/chips are affected by this bug.
> Perhaps the Marvel crew could provide more information on this.

267x, or older, is still on 8.08, so apparently it's free of this bug:
https://www.marvell.com/content/dam/marvell/en/drivers/release-matrix/release-matrix-qlogic-fc-sw-posting-by-release-matrix.pdf

2870 / 2770 :        9.15.06 FW
2740 / 2760 / 269x : 9.15.01 FW
267x :               8.08.231 FW
