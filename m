Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD65F13FEE;
	Fri, 15 Aug 2025 19:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755287802; cv=none; b=eAfHw+InSzfDhMq0m1R9o9BtxtYBhPGQvuFjBieinsk87AYT2T5Jxhw2yZdsNPYUzzn3Z1BbXym314EID68dL8pNIDk8lRWMlvICAg9I78UXEKGgLrAUU1C9SI3rDNUQ57AbdKbDQWNd/FzAvUsnHQCbzZJaq4B4jiPOfRsazUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755287802; c=relaxed/simple;
	bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p6FEduYASaxqU+M0/jrA6M0oEFQkFdlsLyNIFuvEXM2DicCn6XqX/jphoklxVCV+hvzw/dX4HwZhLYjfiPREghawHGjb9aAssx2CehuC736Cl6cwFS+h/daYfmYIkUlYh8+EXQKA23UN2G99FLm6rSJKD8jwPZgfis1KEOLiuvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A7erk76N; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A7erk76N"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-71d6051aeafso21060547b3.2;
        Fri, 15 Aug 2025 12:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755287800; x=1755892600; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=A7erk76NkiwcB2JB29gNffYzLpN4Y4NCadUAjnf9Spnq3l9ZPMrCAqbSUF+8GGsDuK
         CpSDonncWpunsv6kXACJF9EddSCjBofE2hs8KEfF/yAdk3jG33otYYlqOyopAnauxPr5
         k7rJe4iETsykRoONQHWqteBF11Ymwq7CVrjmvKFbNxzGJ58H4pWb79IbLtFflQ+IeeKm
         VXiHerQgVj25mwpGsp6xx5KH1f8bZvqyA8BkC1uaDgKbBOSnVBrLrJrHXDf4ZXYjBAgm
         IRz0K9vN64182/JGx5mGHDboQD0dyI3ed71Ci9t9/QS4gKok+qoLLFRv0XnLD2bDisTT
         Ad/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755287800; x=1755892600;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=LFTHkH/5YRsDFPvoE9yhwWvFNTYcEzDeeavq5WyCPmDF5h452mJlm46W70VOiWolre
         VfFl1BLn6LH+yvM7lE9SOP2BdtXsYp6Oh0MA8gHeZZUeGCK1M+dBwo9k2b9uj2V6PYp0
         kek2SVnYgk/i5jNFsVL/krYWA7yBEtlye6Mxcp6PEdJM8D4XTCJk5YN2liWNW2Puarf0
         6ifeK3+8OGZ3/s1fq8Isg4sXtLnqJRib70swDdSvodVD4F3ygPJDeCPZFa1eGPtmZ1ii
         SaZJ4SZ8ukCQocitNFck8VOLYHye3xq5ZGzVUUTK7JVWbLWgrjLCFCSTAKiwCkkpiEPx
         ftXg==
X-Forwarded-Encrypted: i=1; AJvYcCUoIiKHv9MMNycRO0nmF1/1jazG0ljziYZ8rD4u0T5C+c09wPLn538zDKexnpePefczIZxmZFfzGQXbusE=@vger.kernel.org, AJvYcCWza7iiPgCLJVufNxECYakcXTA5UVlxXYa7uu8XBLLbqu6Zj6DsfF/6/Wt1bIQfSgdM2IvaaHrRhHnYNg==@vger.kernel.org
X-Gm-Message-State: AOJu0YytQgsLfv0Ff6xiQobDCgTwlR6B/IBYwcOdc9LrrJ7szStSQISm
	ZMv/hq5oaeQW7xFi4qZChBwWtiDSuvg3Vl8zugXF6Ql7o/V4SF1zrU35LgHLj5FFZ3zHe208OcS
	FfybA18cX/YB3PjlgFmBm1/Q430etU3A=
X-Gm-Gg: ASbGncvCG7//L6nO4+o/lF2r8YBergDspOhA+dWYB3ciUA1yf/ACV9awcDZumLgOB29
	J8eOfrWPUlPRnbDtBfPJJ5HxoWjKfi7Va2Q+fq0wiznrtSS+WiC9XhrWgHkQ2Mpi4RO311W9pVZ
	L4AVtZAaWRRVZQCLnj3SoqmUlKR0uV/vym4sO67+tAbNXMkJXKZ/L9zpMOyGarpm7ituixRfooE
	4qzI51Q
X-Google-Smtp-Source: AGHT+IEFXxcqlBAJL6vaU1cBgHHAKk9gkL6r6bLlGoscT9UDTXY5wMmMAYqjPr4e3RFROjnRvuHDueAAiB9+GdEpbvo=
X-Received: by 2002:a05:690c:4a07:b0:6ef:6d61:c254 with SMTP id
 00721157ae682-71e6de4bd81mr39950517b3.38.1755287799626; Fri, 15 Aug 2025
 12:56:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250815121609.384914-1-rongqianfeng@vivo.com> <20250815121609.384914-4-rongqianfeng@vivo.com>
In-Reply-To: <20250815121609.384914-4-rongqianfeng@vivo.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Fri, 15 Aug 2025 12:55:03 -0700
X-Gm-Features: Ac12FXxLZDtB44HcJ0Dc_YMV3ySdkhBv9r3N5rK6Ca3xI5bxctGD_LqL5q8wAPc
Message-ID: <CABPRKS_W9vK9sKN13FXTha9EBrVH8auTh8SGih9JJ2W1_Jwd4w@mail.gmail.com>
Subject: Re: [PATCH 3/6] scsi: lpfc: use min() to improve code
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: Justin Tee <justin.tee@broadcom.com>, James Smart <james.smart@broadcom.com>, 
	Dick Kennedy <dick.kennedy@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, 
	"open list:EMULEX/BROADCOM LPFC FC/FCOE SCSI DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Regards,
Justin
