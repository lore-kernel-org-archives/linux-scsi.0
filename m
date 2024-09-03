Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F68B18B48B;
	Tue,  3 Sep 2024 16:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725380467; cv=none; b=cYIGg1jWTTRv5Ff0lFSuSTL+/nrj1y2e8tHqzHYnpai0eMR4M19cWDQB5jhzB2NLEpAHEtTIVlz240K3+nZ2DoLQG7ELYHExNJsc3aaGb4gj/tmbfCbsBV841YTMFUb5mnotDYqDfOHalnBK319yuB7qd21l88xaU6rOjq/6nzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725380467; c=relaxed/simple;
	bh=jUEZoOE+I/HL6qmkqpRxBAW840EWU6rM2MCD09k8aQI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YTKzCxHAiaTBK/Bk6TDgJ3eY5sBGP10o7iUsfaEt6xUuIzmM6sacVyeLpPKfw3zM41HMFx7g5fSpU/jS8nLvleZ320kdaiAXTZlKf2PfXi5Z8/nBhtIL/FbB0/Wd/ce1Fod5fQa8yGwEQsWkGhdQF/wxhMmKNXou17/HDv9U5Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CyaJ8SvS; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CyaJ8SvS"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e1a9dc3f0a3so3017148276.0;
        Tue, 03 Sep 2024 09:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725380465; x=1725985265; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jUEZoOE+I/HL6qmkqpRxBAW840EWU6rM2MCD09k8aQI=;
        b=CyaJ8SvSLASfrEs4XyJUjG0CjEj71iVcdvp2GETOpAlv8/LrSZwZmQbr5ctsByqBSU
         qFes4UoBDyN7X2XoA675yFQYzn9ct83W3rlym/+k7Lw0Kfh+xmAa8bPpURQakr5xa3Wt
         FPiLw4NT4BMcsHbRbHLYlBb9uoIRALTPvHrLisfVd/ruR5FH2vS/zu3MyaUhRiLz4kh9
         ycuOirISrNZ3fJ+sg1NbZMPLl75rP2o1TQtJ5FB5ZReNqd8fu3UDjhXmjVB59yqRESjt
         PoWK0C9dWSvLYFuBuHHDOKDoW/upck+8LdQasLVnSCDk8itjjW5DUrIN8S/E57xswofl
         Rhag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725380465; x=1725985265;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jUEZoOE+I/HL6qmkqpRxBAW840EWU6rM2MCD09k8aQI=;
        b=FyuU4ClCoeuj+fdzTmzCWvzNLcadIDai8pKm9Y8kUyktWpAL7Ol8DTQ8qhV/aCiiu4
         0G4xqhXk7rgRd8B/XEqGMGEcFAzH7WtvLfFk6xjucbRm6y3j+hV4J5GDN+QeXgIOJvx0
         9F3/pKxEjuJg7fOIm7NZrjKalg5bT3ZAzyCSbsswUbIKvCz1pbOq9lGgvrGMmRnWh9jC
         AdppnIIBNYYX4EpN01dp6sYXBgyNOksUbXXYFlSN5JeKx5YoOLCkAaQlp95DdzP6la+K
         i6N8rxT/DljtI0T/2zzXI19bx+Nce0dFGRYqd06y6gEBl6JGCUC8nY8pxg9ZFdShAlDR
         SEkQ==
X-Forwarded-Encrypted: i=1; AJvYcCV03duOVYJemoMxp8VDJd24rIaejLSpaLRA5CRv4KEOzRJ8Rj3QBEFBQ7U2DloiWFDnQPmHSGvNLEMPcQ==@vger.kernel.org, AJvYcCWg+bmic62xmct1aM3UDiXcWbxbp/Ibm8kzk+v36SrTuCjDLc5TLRLAiRb9wFtVdiyNdp534WrPeA+hXiYa97o=@vger.kernel.org, AJvYcCXykL1pgER8JNncV/0EE+R5DIPX4UjxGJlEnGf32mC6w6jhE03/uK62uoOEnLvYzw8gYLJ5OvKf8buE42DN@vger.kernel.org
X-Gm-Message-State: AOJu0YwCYCYBaOsQVaYj5TerxgMTXsEpp0sCwTvb7zE5j0hPfLW2zAFk
	m0TxifTBVBtGBx8p4jE4J2x481siI54qkbaAX248YMcgbUlae4qRk4bS5IUMM6mMLjt+1K/gxIJ
	urFWedZhWo6jlVn/tYwhhCBedU50=
X-Google-Smtp-Source: AGHT+IH3K7aSmGRNmayf7gOw2xBLQk9zrPEPAI7vtthdZhos8gwLrYdq9382zWTSKPzYt0jbOqdH73RGE3NAEsVE05w=
X-Received: by 2002:a05:6902:240f:b0:e1a:4082:e8f2 with SMTP id
 3f1490d57ef6-e1a79fb4f4dmr15711611276.4.1725380465248; Tue, 03 Sep 2024
 09:21:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240902150042.311157-1-colin.i.king@gmail.com>
In-Reply-To: <20240902150042.311157-1-colin.i.king@gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Tue, 3 Sep 2024 09:20:53 -0700
Message-ID: <CABPRKS8G52uD9rUVDo883NQ8KGm9zRMoDsJw_kX_Fb6C+zymaA@mail.gmail.com>
Subject: Re: [PATCH][next] scsi: lpfc: Remove trailing space after \n newline
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Justin Tee <justin.tee@broadcom.com>, James Smart <james.smart@broadcom.com>, 
	Dick Kennedy <dick.kennedy@broadcom.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Thanks looks fine.

Regards,
Justin
