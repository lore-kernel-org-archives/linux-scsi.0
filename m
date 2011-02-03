From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 16/32] scsi/be2iscsi,qla2xxx: convert to
 alloc_workqueue()
Date: Thu, 3 Feb 2011 10:31:20 +0100
Message-ID: <20110203093120.GC2570@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-17-git-send-email-tj@kernel.org>
 <4D489B09.9010906@cs.wisc.edu>
 <20110202102521.GA24115@htj.dyndns.org>
 <4D49C172.3040600@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D49C172.3040600@cs.wisc.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-kernel@vger.kernel.org, Jayamohan Kallickal <jayamohank@serverengines.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, Mike.

On Wed, Feb 02, 2011 at 02:41:22PM -0600, Mike Christie wrote:
> On 02/02/2011 04:25 AM, Tejun Heo wrote:
> >usually necessary.  The queue of pending works tend to be short and
> >consumed pretty fast.
> 
> What if we want to do something that could take a while, like doing
> recovery of a device/transport (so you have to send resets and
> logouts/logins and wait for the results but they could take a while
> if they timeout), should we be using something other than a
> workqueue so it does not interfere with other users?

As long as you don't use ordered workqueue, it wouldn't be a problem.
The max concurrency is determined by @max_active parameter to
alloc_workqueue() and workqueue will try to provide concurrency upto
the limit on demand as long as resources are available.

Thanks.

-- 
tejun
