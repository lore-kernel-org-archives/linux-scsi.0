From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fix sector_div use in scsicam.c
Date: Sun, 27 Oct 2002 10:34:09 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210271634.g9RGYAY11441@localhost.localdomain>
References: <hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id IAA10752
	for <linux-scsi@vger.kernel.org>; Sun, 27 Oct 2002 08:34:16 -0800
In-Reply-To: Message from Christoph Hellwig <hch@lst.de>
   of "Sun, 27 Oct 2002 17:23:07 +0100." <20021027172307.A15930@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

> -		ip[2] = sector_div(capacity, ip[0] * ip[1]);
> +		sector_div(capacity, ip[0] * ip[1]);
> +		ip[2] = capacity;

Now you've lost your optimisation.  The second sector_div should be inside the 
if.

James


