From: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Oops in megaraid_mbox_dpc(), kernel 2.6.23.9-85.fc8.i686
Date: Thu, 07 Feb 2008 17:03:43 -0500
Message-ID: <47AB803F.7070208@redhat.com>
References: <9738BCBE884FDB42801FAD8A7769C26501EE201D@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756993AbYBGWD6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Feb 2008 17:03:58 -0500
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C26501EE201D@NAMAIL1.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Scott Shambarger <scott-lkml@shambarger.net>, linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@lsi.com>, linux-scsi@vger.kernel.org, DL-MegaRAID Linux <megaraidlinux@lsi.com>, "Kolli, Neela" <Neela.Kolli@lsi.com>

On 02/06/2008 02:38 PM, Yang, Bo wrote:
> Andrew/Scott,
> 
> Can you give me more details about this issue?  Such as: MegaRAID
> Controller name, FW version, RAID configuration, host system info, how
> to reproduce this issue.  Also do you see the issue on other kernel
> versions.  
> 

He has hit the BUG() here in megaraid_mbox_dpc():

                // Make sure f/w has completed a valid command
                if (scb->state != SCB_ISSUED) {
                        con_log(CL_ANN, (KERN_CRIT
                        "megaraid critical err: invalid command %d:%d:%p\n",
                                scb->sno, scb->state, scp));
                        BUG();
                        continue;       // Must never happen!
                }
