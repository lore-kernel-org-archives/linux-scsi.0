Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F9119478
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 08:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708590469; cv=none; b=RmonQZLLqoyCRyJZbXVpTzURwyiTvtxaXJpwijwLiV4xWzdesXPwlhRUyMLPfaACu/a7sRRqSmOyxR+gS84Z+Z7/J9FmrZRDkYotnN74Moi80OerjJwFZAn0Z+vJLm/GskmyXH78R8BQUG4n9pNHyJsXTF8iFZT7ASf3LHNX3r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708590469; c=relaxed/simple;
	bh=42vLzQafvh0kEIFCeD5IElVY0TCzlGFSo3aibC2pLlI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hHlkOru38TPSWMlc3lPtJYVa2ZanweFEWq78i47MQYcgRyw1OwZbOfLdBGDS4lXQYu88cBgdKboXutf2mldHVA6FH8Qhldl3no1KwG1GS5ul2EJzggLIc9JsbE5P4+5U3F8v0uqWgTaK8hvEQbbeN1d6fciJVDeC6AK/6pyvpqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BKY0nMrB; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BKY0nMrB"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5654a367f53so371a12.0
        for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 00:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708590466; x=1709195266; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=42vLzQafvh0kEIFCeD5IElVY0TCzlGFSo3aibC2pLlI=;
        b=BKY0nMrB4sGhgG78QvHYlyf5iNFHcRbWTzkYKDB7n+RmI9gYYgcsHSkH9BpQjeieXa
         /rESupUjD1Uk84ppypU0FO53lrSmBD+eO3KkOgDvkUQOhBHHWCPn1RqrUc0omm5NYGtJ
         KoJ2L7Nx7MVYlTlqaRzBYoO/rnHVsR63bWmXQ+3Lvh3wK22OiT11NEblS/WVoQ7o30Eu
         aStw7LWuc/8zUh6ciWDt0scw5jJwh8Gc8mVS3GSVyEF52CDGLyKFIqQb57TwWa2F3+Ha
         BADqifFo6EulQVLI6Ra43tx3nA0sAeTQph5u+a5zL9G9OksESGHoO5kzyzwN/j9GlEfb
         5xlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708590466; x=1709195266;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=42vLzQafvh0kEIFCeD5IElVY0TCzlGFSo3aibC2pLlI=;
        b=WpEz5jYIb7SVtZE/8U55I++OXyNbnE5nI940NquZUr8QqfzsvzWu6JYn41NcZd9xya
         XLwRy5CBgZjcfV/Z6mfGE7r87CkqidU7nvoHIfVcCIaMrpgVTnLTl9q5am3Xp2Opn+JO
         AY9I8d70/7Huyju3vFy9ZRUwqTrn+1SPF/6v0HG4yo7hYdG9Btxwp0XTlYmC6gM/9H98
         dUIBxAO9i1B42iYcH5ut62qUpCnyeTLz/KIoG8z+RAL68bA++UB6YFfPR8OdGfU/19A7
         FDX9BU2hG09WWAIqSmVE2Tong2NwXTnvYxiQIpyuxZwFSwqgL8tPpTunnNdfoa5Q+29n
         6M+w==
X-Forwarded-Encrypted: i=1; AJvYcCXEHh6FXwTGTIUTPsCFXUc8ho6qwllWEkN4bUDyv5ExRWeSnJFVIBuKQXnXq1jdqx3WZKfjno9XTGbOsQvUU0V9R3NAuNeEKlPdbg==
X-Gm-Message-State: AOJu0Yz+iIIJf9TakxAn2ZrK6gKOS4Dw1MQgWhwDzP4ABZ1/WDyMILh7
	qWe0D6BUjxKSnXf6nYkScAMp0/pBOP1vkdnsfhYitOxQVjMaqai6dKI0IWZ7x6mz0dHQpFph5NW
	q40YRGDyWR/OfpANDUbKtZaVEw/huHaiAIyUR
X-Google-Smtp-Source: AGHT+IF9Pslsp2Wk+JCCeyDyiuzYmQpUnrU/YDwfVaY7TIOceUDD/8XPiAnUfH8BKWm+574Wzkl/1hnxv4RUVkMsyGk=
X-Received: by 2002:a50:9feb:0:b0:562:a438:47ff with SMTP id
 c98-20020a509feb000000b00562a43847ffmr375785edf.6.1708590465698; Thu, 22 Feb
 2024 00:27:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240220090805.2886914-1-rohitner@google.com> <1920a2f6-e398-47af-a5d7-9dad9c70e03d@acm.org>
 <c7635c10-1724-4db5-9568-d554e1c64f72@quicinc.com>
In-Reply-To: <c7635c10-1724-4db5-9568-d554e1c64f72@quicinc.com>
From: Rohit Ner <rohitner@google.com>
Date: Thu, 22 Feb 2024 13:57:33 +0530
Message-ID: <CAGt9f=T5352bo=K2OAa7QRMds=tQC1JspN+zQ2aYxNRDWGSVnA@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix setup_xfer_req invocation
To: Can Guo <quic_cang@quicinc.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>, 
	Stanley Chu <stanley.chu@mediatek.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On 2/21/24 01:13, Can Guo wrote:
> I am going to push some BUG fixes for Qualcomm UFSHCI MCQ engine, one of
> which would count on a vops in ufshcd_send_command(). My original plan
> was to add a new vops.mcq_setup_xfer_req() to differentiate from the
> existing one used in legacy mode. But if Rohit moves the existing
> .setup_xfer_req() up, I can use it instead of introducing the new one.

Hi Can,

Can we stick to the current approach of moving the .setup_xfer_req()
up, keeping in mind the following pros?
1. Avoid redundant callbacks for setting up transfers
2. Trim the duration for which hba->outstanding_lock is acquired unnecessarily

Thanks,
Rohit.
