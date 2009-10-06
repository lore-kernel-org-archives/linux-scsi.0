From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi_lib.c: sleeping function called from invalid
 context
Date: Tue, 06 Oct 2009 13:50:49 +0000
Message-ID: <1254837049.4383.17.camel@mulgrave.site>
References: <200909231758.47612.strakh@ispras.ru>
	 <200910051835.51891.strakh@ispras.ru>
	 <1254755602.3838.5.camel@mulgrave.site>
	 <200910061230.03488.strakh@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757473AbZJFNvk@vger.kernel.org>
In-Reply-To: <200910061230.03488.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: iceberg <strakh@ispras.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, eric@andante.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2009-10-06 at 12:30 +0000, iceberg wrote:
> James, what about code where spin_unlock is called before scsi_device_put, 
> especially for avoiding atomic context?
> In code like 
> 	spin_unlock
> 	scsi_device_put
> 	spin_lock
> Is spin_unlock/spin_lock redundant?

Depends on context ... most of them are actually swapping locks or
providing pre-emption points ... it could be redundant, but doesn't have
to be.

> Why do we need scsi_device_get/scsi_device_put pair in scsi_lib.c at all? If 
> we are sure that scsi_device_put is always not last, for what purpose do we 
> call it together with scsi_device_get in the loop?

We're not sure (and never can be in a hotplug world) that any put isn't
the last one.

James
