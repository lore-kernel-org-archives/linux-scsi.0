From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 32/32] cxlflash: Fix to avoid potential deadlock on EEH
Date: Mon, 28 Sep 2015 18:41:49 -0500
Message-ID: <5609D03D.6010709@linux.vnet.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1443223197-10153-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:52293 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbbI1Xlz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2015 19:41:55 -0400
Received: from localhost
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 28 Sep 2015 17:41:55 -0600
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id CBD0C19D8045
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2015 17:32:44 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8SNed1e8388964
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2015 16:40:39 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8SNfoqM000370
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2015 17:41:52 -0600
In-Reply-To: <1443223197-10153-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 09/25/2015 06:19 PM, Matthew R. Ochs wrote:
>  static int write_same16(struct scsi_device *sdev,
> @@ -433,9 +451,20 @@ static int write_same16(struct scsi_device *sdev,
>  		put_unaligned_be32(ws_limit < left ? ws_limit : left,
>  				   &scsi_cmd[10]);
> 
> +		/* Drop the ioctl read semahpore across lengthy call */
> +		up_read(&cfg->ioctl_rwsem);
>  		result = scsi_execute(sdev, scsi_cmd, DMA_TO_DEVICE, cmd_buf,
>  				      CMD_BUFSIZE, sense_buf, to, CMD_RETRIES,
>  				      0, NULL);
> +		down_read(&cfg->ioctl_rwsem);
> +		rc = check_state(cfg);
> +		if (rc) {
> +			dev_err(dev, "%s: Failed state! result=0x08%X\n",
> +				__func__, result);
> +			rc = -ENODEV;

Since check_state only returns 0 or -ENODEV, this is a bit redundant, but not worth redoing the
patch in my mind.

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>




-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

