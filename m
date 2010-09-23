From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC PATCH 6/7] fnic: hook scsi eh into fc_block_scsi_eh
Date: Thu, 23 Sep 2010 00:37:53 -0500
Message-ID: <4C9AE7B1.9030609@cs.wisc.edu>
References: <1285219045-14645-1-git-send-email-michaelc@cs.wisc.edu> <1285219045-14645-7-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48869 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab0IWFcB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Sep 2010 01:32:01 -0400
In-Reply-To: <1285219045-14645-7-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, Abhijeet Joglekar <abjoglek@cisco.com>

On 09/23/2010 12:17 AM, michaelc@cs.wisc.edu wrote:
> From: Mike Christie<michaelc@cs.wisc.edu>
>
> fnic is calling fc_block_scsi_eh, but it is not passing
> up TRANSPORT_FAILED if returned.
>
> Signed-off-by: Mike Christie<michaelc@cs.wisc.edu>

I did not mean to send this patch for fnic.

It does not always work, because because fnic's terminate_rport_io 
callback can fail and then relies on the scsi eh functions to clean up 
the command. However, the fc_block_scsi_eh function relies on the 
terminate_rport_io callback cleaning up the commands.
