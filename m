From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] retry HARDWARE ERROR for IBM ESS
Date: Fri, 19 Nov 2004 19:10:12 +0000
Message-ID: <20041119191012.GB7936@infradead.org>
References: <OFEBA9F7AA.4CED279D-ONC1256F51.00512489-C1256F51.0062A4A4@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:30984 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261538AbUKSTKN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 14:10:13 -0500
Content-Disposition: inline
In-Reply-To: <OFEBA9F7AA.4CED279D-ONC1256F51.00512489-C1256F51.0062A4A4@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

> +     case HARDWARE_ERROR:
> +           if ((strncmp(SCpnt->device->vendor, "IBM", 3) == 0) &&
> +               (strncmp(SCpnt->device->model, "2105", 4) == 0))
> +                 return NEEDS_RETRY;
> +           else
> +                 return SUCCESS;
> +

please don't hardcode models deep inside the scsu layer.  Add a new
blacklist flags and set it from the table in scsi_devinfo.c

