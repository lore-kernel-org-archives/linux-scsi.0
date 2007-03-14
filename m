From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/4] scsi: add transport host byte errors
Date: Wed, 14 Mar 2007 16:14:58 -0500
Message-ID: <45F865D2.9020201@cs.wisc.edu>
References: <11739019681346-git-send-email-michaelc@cs.wisc.edu> <11739019693216-git-send-email-michaelc@cs.wisc.edu> <11739019703157-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39874 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964781AbXCNVPX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Mar 2007 17:15:23 -0400
Received: from [20.15.0.7] (c-75-73-64-90.hsd1.mn.comcast.net [75.73.64.90])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id l2ELFAZ1021534
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2007 16:15:22 -0500
In-Reply-To: <11739019703157-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

michaelc@cs.wisc.edu wrote:
> When using multipath and the fast_io_fail_tmo fires then the class
> can fail commands with DID_TRANSPORT_FAILFAST or drivers can use

Bah, that is going to be wrong or ugly for tape commands.

We would want to add another new value, DID_TRANSPORT_ABORTED which
would check the retries or device type. Drivers would use this when
failing IO that was possibly running on the device.

> -
> +	case DID_TRANSPORT_BLOCKED:
> +		/*
> +		 * LLD/transport was disrupted during processing the IO.
> +		 * The transport is now blocked and attempting to recover,
> +		 * and the transport will decide what to do with the IO
> +		 * based on its timers and recovery capablilities.
> +		 */
> +		return NEEDS_RETRY;
> +	case DID_TRANSPORT_FAILFAST:
> +		/*
> +		 * The transport decided to failfast the IO (most likely
> +		 * the fast io fail tmo fired), so send IO directly upwards.
> +		 */
> +		return SUCCESS;
>  	case DID_ERROR:
>  		if (msg_byte(scmd->result) == COMMAND_COMPLETE &&
>  		    status_byte(scmd->result) == RESERVATION_CONFLICT)

