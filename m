Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B0D1C5788;
	Tue,  6 Aug 2024 13:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722949806; cv=none; b=LiASfrbWIfHic1rWPkSxWlZGJdM/7TnJGzH1W2hXsipijJybkrwqXq0Fn74G4fX/y/DKNGJmwZoRV1sF3GLwwwAQoA/eAEmN7BTR7lvZgIZ9S18DtX8UjtNsF79isLhyVdoyKNxBOPjr9UfiRcl2R+36JKPgHbl4od6CwQB6KEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722949806; c=relaxed/simple;
	bh=KREccnRV9/lcz1AxarrngZjnkiUg2IvSSWsvWfX4xFM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T8VCvEc3LZC865rKHwvFIDguwAuodx7SYGAW70kyQj7NNAExZbeqhUdWV7GSX/zWLkHke0OoQMaoUWQkTWMkShFo6cKjgCM0X74Pae7PVvfk5XMpOCRVGVq80lFRMVKeyUZnr3wNkJvvhgraHU6n8RSIvQ0yIxlIduGUGNwsySk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c0bNVl+6; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c0bNVl+6"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3db14339fb0so348454b6e.2;
        Tue, 06 Aug 2024 06:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722949803; x=1723554603; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KREccnRV9/lcz1AxarrngZjnkiUg2IvSSWsvWfX4xFM=;
        b=c0bNVl+6VAZVmRcyP+mKR7cSyojFuaAPFgxXJeEy2yZAWDQQka8hbxzCqm6V7Lo1lN
         SSUQ1yrQNokWNMSxBKBPZ5qdHGMd85bB/r1C88jq3P/M+eHE38eWhH1XHRG25PaRpEue
         YM2f1uFYl1qJUnhUWL8CWuU8amNC2pCTBiYvVe9MtoQ41mHa07yDSCFA8M+m+x8/AWH3
         IAQvcR1am/yESF4D+fGliAgmoRKP7X0EPY36PefBSTJoHXJERL3uNx14Im4hH4tosTkU
         Mrjp46GLO0Pd1KKzATs/RHC5WWLmIp8IprNMmJebX677uJJbnoKEZRTISrO+9zeXOvrm
         zV1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722949803; x=1723554603;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KREccnRV9/lcz1AxarrngZjnkiUg2IvSSWsvWfX4xFM=;
        b=Y3ZAE/v8Hh359BlxcP17ukNuA0sQd/Zi7oOzo63od4P4NFLGTYdMdzbWEcQffpxStl
         wl0X1Eldbu/HA3oMIlyPOE3PqTD3wQjoFMs0HHygojnZVCtSZF08tbj0kMJQI/0IgfRZ
         GsYwmogrc+83tomZYEpJr0j5/6yoL9rf1SjPzHQhHkrIxG2YwGPYJRlfK84l67Q3e/ZR
         0h64SOYDjg45QI6ljJTgLBNI3D1/xJnNl/duEJEuvKg9T4b0dvzmN505xHWNCxDgyQDo
         2iyKkZnGUvxT3jIh1piUK3N8UVj/WZIBEFlYekVgOJzl4qdlMm4HEbN7tnuH18e8P9EG
         mEBg==
X-Forwarded-Encrypted: i=1; AJvYcCVvE/Oe0fAPZp3MZoY+WFGleSLOmBnGI2p/PSTN01NmkJ0vCsJOFZnTky+E8000Jtxds2N7Dnk0cArZ4jde4LBKSuTdYeY4vOnF2C5fiBdew4DwfUFXwvwM/iAdwVYAfx/DCwQFWf7LcI+vGXFMtyXVC+crcQ+m2bFwQNencEF7GooATDe65IEZNWbVNFKqYs0PJbC5xZ664juiVWmb1nWT
X-Gm-Message-State: AOJu0Ywwi+NeZLD33NxNq/K1HmQl3AnFQZKWV1YRqgT9lacVQxyPXuxs
	k4zy8VsNHLX0x8OWEUaw1ELNkNMcHolJxn1O3jgFaiu3lz/1GOqxno6TfjFymJbI4H9BkUcl/3Z
	5nGCJMpmHl1yCbEJZtukos1EZAvo=
X-Google-Smtp-Source: AGHT+IGVJxX/HbV5Wr6MzBf+fuxb+mIBQRp2TWTznpKDIx+yrOgDwhY5P4ZF8kRUebG9zXa+VAy7m3G1u1r+X9IB2Rg=
X-Received: by 2002:a05:6870:50d:b0:259:8b4e:e71a with SMTP id
 586e51a60fabf-26891ee1b6dmr17272867fac.46.1722949803427; Tue, 06 Aug 2024
 06:10:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
In-Reply-To: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 6 Aug 2024 09:09:50 -0400
Message-ID: <CAJSP0QVod5DA2hdNFrpN+HZcfm6Bg11teRmt5d+MBTB1wH4vZg@mail.gmail.com>
Subject: Re: [PATCH v3 00/15] honor isolcpus configuration
To: Daniel Wagner <dwagner@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, 
	Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, John Garry <john.g.garry@oracle.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, 
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, 
	Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Nilesh Javali <njavali@marvell.com>, 
	GR-QLogic-Storage-Upstream@marvell.com, Jonathan Corbet <corbet@lwn.net>, 
	Frederic Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>, 
	Sridhar Balaraman <sbalaraman@parallelwireless.com>, "brookxu.cn" <brookxu.cn@gmail.com>, 
	Ming Lei <ming.lei@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, virtualization@lists.linux.dev, 
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com, 
	MPT-FusionLinux.pdl@broadcom.com, storagedev@microchip.com, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 6 Aug 2024 at 08:10, Daniel Wagner <dwagner@suse.de> wrote:
> The only stall I was able to trigger
> reliable was with qemu's PCI emulation. It looks like when a CPU is
> offlined, the PCI affinity is reprogrammed but qemu still routes IRQs to
> an offline CPU instead to newly programmed destination CPU. All worked
> fine on real hardware.

Hi Daniel,
Please file a QEMU bug report here (or just reply to this emails with
details on how to reproduce the issue and I'll file the issue on your
behalf):
https://gitlab.com/qemu-project/qemu/-/issues

We can also wait until your Linux patches have landed if that makes it
easier to reproduce the bug.

Thanks!

Stefan
