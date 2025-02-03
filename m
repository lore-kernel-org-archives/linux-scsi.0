Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAB8212B11
	for <linux-scsi@vger.kernel.org>; Mon,  3 Feb 2025 14:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738592797; cv=none; b=JitQyMuk387JJC1V3ZOHSY7oQpfGCNA1y1fYdIgn+4vHdE/s9OjiRlEaIVOelbgRfPfvNtzQsUBMZL0uKyktEJzFAfBGZD6Q3OOXFptvCAf3gKaE8ej+bBsTZqRPB7m1U+0zkb7m3gsBciEwvcXb5T5hWgLGrhsZMzBFkr41rws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738592797; c=relaxed/simple;
	bh=Tj7tRy4kZnsxFzQuBtc04+Ahrz10XdqH0zrjX5oVM6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bRHnRfRi751IoFETna6CrmTjzQUHv8HpBiweuYPr2xUc+6TU6s9o/GKeZ4WmjaZbENgn/XaHFGNAeuZYQ1NgLfhMt9lBkUOsUyrNqx9u1vkm/TfF9tRixWFrduGuEzgL83YBuSQOqNHYdELaGfEg/8zKn/rFKxdwIds4n1dez+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AhHsSeis; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AhHsSeis"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-aaf900cc7fbso967060766b.3
        for <linux-scsi@vger.kernel.org>; Mon, 03 Feb 2025 06:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1738592793; x=1739197593; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wApwa+Vg7pEhvhJZMOtchLW1Qtniq1LAppbarYJzbvQ=;
        b=AhHsSeisaNRxfF5kpEuWH/NuGkEEpv1vnTj7ov8dvc4SOqrwanUdq0cerpIrAIY5KO
         e0xLN3NncTQKdHp+2y51NgGmv9ulwc6s6YlQvvC8sEwYzXjrmDPfW1P5sJZJVDo2DO7a
         6Lu7iex/hWVl/LNtRHc9nk1a6ySPHTG1l0ZTCGB9wcC1cOHKHvB92C8kPHmpY1ukj9la
         tpeIMaAJAJis7ibRRLXp8njUjDeCMVKXbSKJVW26O/Tr+nSQrg8bmJLV9r5TKEVm9HkD
         0sdyYVw94J5FrQwbw/TXiWME1NugDiPTG57lSyJ2gwt/zJu1Q3tSraQUpYQTCABsq4U6
         osOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738592793; x=1739197593;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wApwa+Vg7pEhvhJZMOtchLW1Qtniq1LAppbarYJzbvQ=;
        b=YkZ6F7GQCkPFnTGEzD0s6ixWF3DUFLQeAMxKl3vH2w8HNAzKo3hLCRhb8Vzzjpp/yl
         F3ksKw0l9Zc+GjCWSf5tt2iST7krWkNRL/G9uvekmK5IENJ7AL9gpZxV94nhVW+0z0Xb
         1Ducgr8Biw/8NimFOQi2f0Q7xki2Xy/4OwNH6urX3paasRAlzNxXkY23N4UC3dP8Gtoa
         VbjWs/2u9IcKiNPvhK4YPlgTsek9FOIg8s8VCIdNeV/1ZbZuH9Hti+RH71P0HE1USG+U
         UYF6L9IQIJcIQmFujcnezOTuvFniyx0EUXxuM5wBwxvNQB+4Jve33qoh+pSB9ri2NJlQ
         zYeA==
X-Gm-Message-State: AOJu0YxZgxxrliZyFpUc9S458bt9nme5FEEyzyJVd0YxvtOCK/ZY8kH3
	uD44Gkv4NIkQNghsWqT+SGVQxGmyLy6zrB4Gifyq9z+R37s/iVJ3oHpeRz5Jl2U=
X-Gm-Gg: ASbGncs+ivVZ3pV3wnIFk11fOULYqu3/F7PNVpkjw/+0yHB3QbK55BBsYBkgSLbbasc
	xbZzm0aESqEv4u2x5APp6FtGZsEUXjJS7pYJbO5W7+kxMPoYek+1Uv0ESCg9rBn3/bBl22l9WfD
	+ex5PIJM1voKuueS9WJ64tsCU/0TVEsWYIUirHpZYesHgTa+HdeSF2dqnYcOBMyhp5qzhy38Xhu
	gcmMpxeZ+mjapLclqp31mkNWPLVNfyhy/nYWwX6Yt9z/OAMlQiUja472mog1h2o/OcVaSBX69Hy
	+/qrzg==
X-Google-Smtp-Source: AGHT+IEMvqFtWMQcGcbew8g5CbtS87OK4kOUrbaUT5fxc6WJnZS+Qe69TNruF9V9SFX0gjEEIeYYSg==
X-Received: by 2002:a17:907:6eab:b0:ab2:ea29:a2 with SMTP id a640c23a62f3a-ab6cfe11e85mr2509321666b.48.1738592793317;
        Mon, 03 Feb 2025 06:26:33 -0800 (PST)
Received: from localhost ([193.86.92.181])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-ab706ce9a53sm509134266b.72.2025.02.03.06.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2025 06:26:33 -0800 (PST)
Date: Mon, 3 Feb 2025 15:26:32 +0100
From: Michal Hocko <mhocko@suse.com>
To: lsf-pc@lists.linuxfoundation.org
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: REMINDER - LSF/MM/BPF: 2025: Call for Proposals
Message-ID: <Z6DSGOsqjw1ahIYi@tiehlicka>
References: <Z4pwZkf3px21OVJm@tiehlicka>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4pwZkf3px21OVJm@tiehlicka>

On Fri 17-01-25 15:59:51, Michal Hocko wrote:
> Hi,
> this is a friendly reminder for LSF/MM/BPF Call for proposals - you can
> find the original announcement here: https://lore.kernel.org/all/Z1wQcKKw14iei0Va@tiehlicka/T/#u.
> 
> Please also note you need to fill out the following Google form to
> request attendance and suggest any topics for discussion:
> 
>           https://forms.gle/xXvQicSFeFKjayxB9
> 
> The deadline to do that is Feb 1st!

The deadline has passed but if you forgot or this slipped through then
no worries you can still apply but please do so ASAP. We are going
through all applications these days and will try to send invitations
ASAP so that people can start planning their travel.

Let me also remind that all the topics that are to be scheduled should
be posted to the mailing list (CCing track specific and lsf-pc mailing
lists). 

Let us know if you have any questions!

Thanks!
-- 
Michal Hocko
SUSE Labs
