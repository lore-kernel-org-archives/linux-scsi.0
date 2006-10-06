From: Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH] scsi: Scsi_Cmnd convertion in aic7xxx_old.c
Date: Fri, 6 Oct 2006 22:29:13 +0200
Message-ID: <20061006202913.GA7835@aepfle.de>
References: <452363DB.60107@nachtwindheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from natklopstock.rzone.de ([81.169.145.174]:9153 "EHLO
	natklopstock.rzone.de") by vger.kernel.org with ESMTP
	id S1422927AbWJFU31 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Oct 2006 16:29:27 -0400
Content-Disposition: inline
In-Reply-To: <452363DB.60107@nachtwindheim.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Henne <henne@nachtwindheim.de>
Cc: Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Oct 04, Henne wrote:

> -static void
> -aic7xxx_done_cmds_complete(struct aic7xxx_host *p)
> +static void aic7xxx_done_cmds_complete(struct aic7xxx_host *p)
>  {
> -  Scsi_Cmnd *cmd;
> -  
> -  while (p->completeq.head != NULL)
> -  {
> -    cmd = p->completeq.head;
> -    p->completeq.head = (Scsi_Cmnd *)cmd->host_scribble;
> -    cmd->host_scribble = NULL;
> -    cmd->scsi_done(cmd);
> -  }
> +	
> +	struct scsi_cmnd *cmd;
> +	
> +	while (p->completeq.head != NULL) {
> +		cmd = p->completeq.head;
> +		p->completeq.head = (struct scsi_Cmnd *) cmd->host_scribble;

This one should be struct scsi_cmnd * as well?
