From: Arjan van de Ven <arjan@fenrus.demon.nl>
Subject: Re: lockdep warning looks scsi related
Date: Fri, 06 Oct 2006 15:22:43 +0200
Message-ID: <1160140963.3000.106.camel@laptopd505.fenrus.org>
References: <20061005100853.4d65dc90@dxpl.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from a222036.upc-a.chello.nl ([62.163.222.36]:12471 "EHLO
	laptopd505.fenrus.org") by vger.kernel.org with ESMTP
	id S932317AbWJFNWy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Oct 2006 09:22:54 -0400
In-Reply-To: <20061005100853.4d65dc90@dxpl.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Hemminger <shemminger@osdl.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>

On Thu, 2006-10-05 at 10:08 -0700, Stephen Hemminger wrote:
> This is current main linux-2.6 (git pulled yesterday).
> Running on 2 CPU Opteron
> Happened during overnight (beagle cronjob?)

hmm lots of changes in cfq, and to be honest the
cfq_exit_single_io_context() change makes me nervous.
The comment says it's called with interrupts disabled, what the comment
does NOT say is that this function ENABLES interrupts!
(the entire cfq change has many places where interrupts now get enabled
where previously they remained as is... )

