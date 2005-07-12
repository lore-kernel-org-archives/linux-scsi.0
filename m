From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Use device_for_each_child() to unregister devices in scsi_remove_target().
Date: Mon, 11 Jul 2005 17:20:12 -0700
Message-ID: <20050712002011.GA9331@kroah.com>
References: <11193083662356@kroah.com> <11193083663269@kroah.com> <20050706003850.GA11542@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262306AbVGLAVK@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050706003850.GA11542@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, mochel@digitalimplant.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 05, 2005 at 05:38:50PM -0700, Patrick Mansfield wrote:
> Hi Greg / Patrick -
> 
> I'm getting an oops with current (pulled today) 2.6 git, the
> device_for_each_child() does not seem to be deletion safe.
> 
> We hold the klist in place via the n_ref, but the kobj (in the struct
> device for the struct scsi_target) containing it is freed when the
> kref->refcount goes to zero.

But we grab a reference to that object right before we call
device_for_each_child(), right?  Or am I missing something here?

thanks,

greg k-h
