From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 1/2] Conversions from kmalloc+memset to k(z|c)alloc
Date: Wed, 19 Jul 2006 08:23:39 +0200
Message-ID: <200607190823.39571.eike-kernel@sf-tec.de>
References: <20060719013113.GF30823@lumumba.uhasselt.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:9155 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S932413AbWGSGWd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jul 2006 02:22:33 -0400
In-Reply-To: <20060719013113.GF30823@lumumba.uhasselt.be>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Panagiotis Issaris <takis@lumumba.uhasselt.be>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-eata@i-connect.net

Added linux-scsi to CC as it touches drivers/scsi/

>  	/* stuff a sense request in front of our current request */
> -	pc = kmalloc (sizeof (idescsi_pc_t), GFP_ATOMIC);
> +	pc = kzalloc (sizeof (idescsi_pc_t), GFP_ATOMIC);

Please remove the space before the arguments.

>  	rq = kmalloc (sizeof (struct request), GFP_ATOMIC);

This and the one before should be "rq = kzalloc(sizeof(*rq),...);" This way 
you will always get the correct buffer size even if the type of rq changes.

Eike
