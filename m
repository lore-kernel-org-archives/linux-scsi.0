From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH 06/16] scsi_dh_alua: use local buffer for VPD inquiry
Date: Thu, 13 Feb 2014 10:51:13 +0100
Message-ID: <52FC9591.6020206@redhat.com>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaBMJvT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Feb 2014 04:51:19 -0500
In-Reply-To: <1391160600-19652-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

Hi,

On 01/31/2014 10:29 AM, Hannes Reinecke wrote:
>  static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
>  {
> +	unsigned char *buff;
> +	unsigned char bufflen = 36;
> 	int len, timeout = ALUA_FAILOVER_TIMEOUT;
[...]
>+	len = (buff[2] << 8) + buff[3] + 4;
>+	if (len > bufflen) {
[...]
>+		bufflen = len;

just a nit: is it safe to use char as the type of bufflen? Isn't better
to declare it as int just in case len is > than 255 ?

Regards,
Maurizio Lombardi
