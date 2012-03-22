From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [libsas PATCH v12 04/11] sysfs: handle 'parent deleted before
 child added'
Date: Thu, 22 Mar 2012 14:47:11 +0000
Message-ID: <1332427631.2946.19.camel@dabdike.int.hansenpartnership.com>
References: <20120322063127.22036.23206.stgit@dwillia2-linux.jf.intel.com>
	 <20120322063214.22036.77957.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120322063214.22036.77957.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-03-21 at 23:32 -0700, Dan Williams wrote:
> In scsi at least two cases of the parent device being deleted before the
> child is added have been observed.
> 
> 1/ scsi is performing async scans and the device is removed prior to the
>    async can thread running.

This doesn't sound right.  We do an explicit get on the sdkp (and the
sdkp holds the sdp) before we schedule an async scan.  That's only
removed after the async scan has completed, so it should be impossible
for the parent to vanish.

> 2/ libsas discovery event running after the parent port has been torn
>    down.

This sounds possible, but should be fixable by referencing and checking
in libsas rather than having to alter sysfs, shouldn't it?

In general, I think any case where the parent is freed before the child
of that parent created is our refcounting cockup rather than a generic
problem in sysfs.

James


