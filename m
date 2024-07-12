Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D9E143C5D
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jul 2024 09:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720778327; cv=none; b=hiUm2W1fZ0CgVokBiRD+b1mA4udbBAbVGgzXC8awB8fAzpUQIVWY3BgbgVxJ6pFrwHpSmARUKWP91BTPW20bS6C3aEqIj0Pj7wfNnrshjtUqVRKhRMMbzXne4ECasIHa3kyfvIr0/EhnGN0qMdZjGMwnm28LBFafhOToUMVZLeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720778327; c=relaxed/simple;
	bh=yIVNhiC49pu3LQQuucdZLz/ASyKjQzHX04ThHbZ/y7U=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J4X85xOVdByMkRzeTy27LYcBhH/qwYYuhMGX22cL/RE+QP45C/WBbhGNcO+UktdpEpO2Ut48eCaoBwWvgHppKCEtLkh6chJ91JLj7B8pQZSxLoBHDO9IXRGChvUnsb6LV9Uebu9R7TgkpEur0M/aT/5+6trusKH+FOy4NlnhUS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e8lJRqUY; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e8lJRqUY"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-58b447c513aso2217459a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jul 2024 02:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720778324; x=1721383124; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yIVNhiC49pu3LQQuucdZLz/ASyKjQzHX04ThHbZ/y7U=;
        b=e8lJRqUYmx0iVIL9B0AcHEwGNGDPzAGmDHHEJvmyZ/fjv4Su2aMu2eZbPNyTDoN3rz
         C2LriVnOd1fxMudkl7ofP4qNIbusNxIK8u8qm5dUEqZuLCfXssmV96AiKvoAh2nPNqVX
         JrrWvb/jXh90yva3t78JYirJddAnuH0V/rC6UrpLkjcIw42z/JqzItMgA7MXaYgGgp7u
         UM+eOG82jbqNjIF3avwvy0weeZQgRQB2pSzfrSVUWAjfxBnbifDum8q53FqXZ4nKLyYE
         HGU3tlBeFQLU/TV1k4Je19jy/QGiriNxygJ6QRX+sFGP2XYA8q7L19fef/DbCeELm8Ap
         ifnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720778324; x=1721383124;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yIVNhiC49pu3LQQuucdZLz/ASyKjQzHX04ThHbZ/y7U=;
        b=kygsmeteTCmQ+TwmqtRQVUrZdABlaAuBmPqkmj9l2vA18zaPShdA/OaXYTaAtE7yzL
         OQ8taaZaBMIuCyYM2FZvUnkzAjG6d4tES0SzwQiylVS79Vn8v1Cmzh7xwUJZYxViobV0
         UkY8n1wE+4JGXF4PcIH7ZwDvguhpWHbnzFJWT7Ps0pbrwql3jeKYdOURJIb1DgNjxrLe
         lhK+3Cw6fAm3+OJbQ/BNnGEPSc/D0v615e7UejWnJg5FGPaGe2eZhURvU/PGRFNT2RlT
         uFRrYsnCU8ur35xtc0DaofuYVIcVjdRqc3B83QlsA8SzLAwE1pNhy+oyZvJSnjn5sWIB
         RGfg==
X-Forwarded-Encrypted: i=1; AJvYcCXMuOo8F13C4sOfz55qe1Z+ASIuyH104k0oPUIXG2tRA4xBr77Zji0jFVv3JbNS+9OnIjSC6TtheN/kie8XpOEQ5BVyU6Sq1BqHuQ==
X-Gm-Message-State: AOJu0YzOTOvg2dttV6Pkl5oOj44HzTzssZkhLWR1iC7UAGliRzPFDHtS
	rHD7LO5D0IxL6GdHIGIr5y716TozGhv9wNr7NRqLakFiy5XiSg1j
X-Google-Smtp-Source: AGHT+IEA4JLouBYbEof5XDgc9pdOPBBaJQGzudP9LKkHrWF5+7if+TPu0tYuBrZL/Pq9KIShzs66nA==
X-Received: by 2002:a17:907:9809:b0:a77:c314:d621 with SMTP id a640c23a62f3a-a780b68a2f8mr961761866b.13.1720778324447;
        Fri, 12 Jul 2024 02:58:44 -0700 (PDT)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a780a7ff0b0sm328472966b.120.2024.07.12.02.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 02:58:44 -0700 (PDT)
Message-ID: <7d628f0aa3e5607fcea80085f65d9bfa6b94d563.camel@gmail.com>
Subject: Re: [PATCH v1] ufs: core: bypass quick recovery if need force reset
From: Bean Huo <huobean@gmail.com>
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com, 
	jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org, 
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com, 
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 powen.kao@mediatek.com,  qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com,  eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 chu.stanley@gmail.com
Date: Fri, 12 Jul 2024 11:58:42 +0200
In-Reply-To: <20240712094506.11284-1-peter.wang@mediatek.com>
References: <20240712094506.11284-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2024-07-12 at 17:45 +0800, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
>=20
> If force_reset is true, bypass quick recovery.
> This will shorten error recovery time.
Reviewed-by: Bean Huo <beanhuo@micron.com>
