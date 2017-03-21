From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sd: use async_probe cookie to avoid deadlocks
Date: Tue, 21 Mar 2017 09:33:58 -0400
Message-ID: <1490103238.2412.17.camel@HansenPartnership.com>
References: <1490098475-21884-1-git-send-email-hare@suse.de>
         <1490101519.2412.13.camel@HansenPartnership.com>
         <1490103027.2602.5.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37082 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757077AbdCUNee (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Mar 2017 09:34:34 -0400
In-Reply-To: <1490103027.2602.5.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hck@suse.de" <hck@suse.de>, "hare@suse.com" <hare@suse.com>

On Tue, 2017-03-21 at 13:30 +0000, Bart Van Assche wrote:
> On Tue, 2017-03-21 at 09:05 -0400, James Bottomley wrote:
> > How does this preserve ordering?  It looks like you have one cookie 
> > per sdkp ... is there some sort of ordering guarantee I'm not
> > seeing?
> 
> Hello James,
> 
> Since the probe order depends on the order in which __async_probe() 
> adds entries to the "pending" list, and since the order of the
> __async_probe() calls is not changed by this patch, shouldn't the 
> probe order be preserved by this patch?

I don't know: that's what I'm asking.  I believe they complete in order
for a single domain.  I thought ordering isn't preserved between
domains?  So moving to multiple domains loses us ordering of disk
appearance.

James
