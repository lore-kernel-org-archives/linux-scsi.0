From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 06/11] qla4xxx: added srb referance counter
Date: Mon, 01 Feb 2010 12:22:52 -0600
Message-ID: <4B671BFC.90107@cs.wisc.edu>
References: <20100130062856.GG10274@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51493 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351Ab0BASXO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2010 13:23:14 -0500
In-Reply-To: <20100130062856.GG10274@linux-qf4p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Karen Higgins <karen.higgins@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

On 01/30/2010 12:28 AM, Ravi Anand wrote:
>
> -		msleep(2000);
> -	} while (max_wait_time--);
> +		if (got_ref&&  (atomic_read(&rp->ref_count) == 1)) {
> +			done++;
> +			break;
> +		}
> +
> +		msleep(ABORT_POLLING_PERIOD);


Did you want to use krefs for the refcounting?

And why is this so funky (got_ref arg and refcount peak) compared to the 
qla2xxx one?

