From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: sense buffer not cleaned when retrying failed command by the eh
Date: Mon, 12 Jan 2004 23:40:48 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040113074048.GA1280@beaverton.ibm.com>
References: <40028A1A.2030609@il.marvell.com> <20040113002656.GW4339@linnie.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:61918 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S261953AbUAMHgJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2004 02:36:09 -0500
Content-Disposition: inline
In-Reply-To: <20040113002656.GW4339@linnie.riede.org>
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <wrlk@riede.org>
Cc: linux-scsi@vger.kernel.org

Willem Riede [wrlk@riede.org] wrote:
> On 2004.01.12 06:50, Saeed Bishara wrote:
> What about in the 2.6 kernel:
> 
> --- drivers/scsi/scsi_lib.c.orig	2004-01-12 18:40:28.000000000 -0500
> +++ drivers/scsi/scsi_lib.c	2004-01-12 18:50:22.000000000 -0500
> @@ -302,6 +302,7 @@
>  void scsi_setup_cmd_retry(struct scsi_cmnd *cmd)
>  {
>  	memcpy(cmd->cmnd, cmd->data_cmnd, sizeof(cmd->data_cmnd));
> +	memset(cmd->sense_buffer, 0, sizeof(cmd->sense_buffer));
>  	cmd->request_buffer = cmd->buffer;
>  	cmd->request_bufflen = cmd->bufflen;
>  	cmd->use_sg = cmd->old_use_sg;
> 

In the 2.6 kernel this is cleared in scsi_retry_command. The other
callers of scsi_setup_cmd_retry do not want the sense_buffer cleared as
it has been set prior to calling scsi_setup_cmd_retry. To use the
change suggested things would need to be reordered a bit.

-andmike
--
Michael Anderson
andmike@us.ibm.com

