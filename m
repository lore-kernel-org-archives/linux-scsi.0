From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 1/4] scsi: ufs: Add Configuration Descriptor to sysfs
Date: Sat, 16 Jun 2018 09:16:32 +0200
Message-ID: <20180616071632.GD30558@kroah.com>
References: <20180615210049.126123-1-evgreen@chromium.org>
 <20180615210049.126123-2-evgreen@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180615210049.126123-2-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 15, 2018 at 02:00:46PM -0700, Evan Green wrote:
> This change adds the configuration descriptor to the UFS
> sysfs interface. This is done in preparation for making the
> interface writable, which will enable provisioning UFS devices
> via Linux.
> 
> The configuration descriptor is laid out as a header, then a set of
> (usually 8) copies of the same descriptor for each unit.
> 
> Signed-off-by: Evan Green <evgreen@chromium.org>
> ---
> Changes since v1:
> 	- Squashed documentation changes into this change.
> 	- Reworked sysfs layout so that instead of a sysfs file for a
> unit selector and then a common set of unit attributes, each unit in
> the config descriptor has its own directory. This required a little
> bit of kobject magic. Alternatively I could use standard device
> attributes and simply allocate N*M of them from a template. I have
> that coded up, and can go with that if preferred, but I thought
> this was a little nicer since it wasted less memory.

Ick, don't use "raw" kobjects please, as userspace will not see them
correctly in the libraries that track devices and attributes, like
libudev.

And what is wrong with using configfs?  I thought that was the better
way to go for something like this.  You are configuring the device,
which is exactly what configfs was created for, to keep people from
having to do this type of mess in sysfs.

thanks,

greg k-h
