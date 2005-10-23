From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH RFC] more struct scsi_lun
Date: Sun, 23 Oct 2005 11:47:01 +0200
Message-ID: <435B5C15.5070106@s5r6.in-berlin.de>
References: <20051023043301.GA22615@havoc.gtf.org> <20051023044953.GA23354@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:53674 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751441AbVJWJrM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 05:47:12 -0400
In-Reply-To: <20051023044953.GA23354@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> +static inline char *scsilun_to_str(const struct scsi_lun *lun, char *s)
>  {
> -	sprintf(s, "%d", scsilun_to_int(&sdev->lun));
> +	sprintf(s, "%d", scsilun_to_int(lun));
>  	return s;
>  }

What about an 8-byte representation?

#define SCSILUN_STR_LEN (2*8+1)

static inline char *scsilun_to_str(const struct scsi_lun *lun, char *s)
{
	int i;

	for (i = 0; i < 8; ++i)
		sprintf(s+2*i, %02x, lun[i]);
	return s;
}
-- 
Stefan Richter
-=====-=-=-= =-=- =-===
http://arcgraph.de/sr/
