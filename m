From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 12/24] scsi: use 'bool' as return value for
 scsi_normalize_sense()
Date: Fri, 3 Oct 2014 01:15:41 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CCBDB8@G4W3202.americas.hpqcorp.net>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
 <1412144580-72880-13-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:53855 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaJCBRW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 21:17:22 -0400
In-Reply-To: <1412144580-72880-13-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Wednesday, 01 October, 2014 1:23 AM
> To: James Bottomley
> Cc: Christoph Hellwig; linux-scsi@vger.kernel.org; Elliott, Robert (Server
> Storage); Hannes Reinecke
> Subject: [PATCH 12/24] scsi: use 'bool' as return value for
> scsi_normalize_sense()
> 
> Convert scsi_normalize_sense() and frieds to return 'bool'
> instead of an integer.

frieds should be friends

...
> -int scsi_command_normalize_sense(struct scsi_cmnd *cmd,
> +bool scsi_command_normalize_sense(struct scsi_cmnd *cmd,
>  				 struct scsi_sense_hdr *sshdr)

Add const for *cmd since what it points to is not
modified.  (prototype in scsi_eh.h)

...
> -static inline int scsi_sense_valid(struct scsi_sense_hdr *sshdr)
> +static inline bool scsi_sense_valid(struct scsi_sense_hdr *sshdr)
>  {
>  	if (!sshdr)
> -		return 0;
> +		return false;
> 
>  	return (sshdr->response_code & 0x70) == 0x70;
>  }

Add const to the argument, since what it points to is not
changed by this function:
	const struct scsi_sense_hdr *sshdr


> -static inline int scsi_sense_is_deferred(struct scsi_sense_hdr *sshdr)
> +static inline bool scsi_sense_is_deferred(struct scsi_sense_hdr *sshdr)
>  {
>  	return ((sshdr->response_code >= 0x70) && (sshdr->response_code & 1));
>  }

Add const to the argument, since what it points to is not
changed by this function:
	const struct scsi_sense_hdr *sshdr

(also mentioned in reply to PATCH 4)


---
Rob Elliott    HP Server Storage



