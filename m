From: Doug Ledford <dledford@redhat.com>
Subject: Re: Addressing when lun spans disks
Date: Mon, 21 Oct 2002 12:31:38 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021021163138.GD28914@redhat.com>
References: <3DB42408.60E2C71D@patni.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DB42408.60E2C71D@patni.com>
To: MShetty <mranalini.shetty@patni.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 21, 2002 at 09:28:00PM +0530, MShetty wrote:
> Hi,
> 
> What exactly is the value of 'target id' when my lun spans multiple
> disks ?? I am not able to understand how the physical disk address would
> be obtained when a lun spans multiple disks

If you are using an external drive chassis that turns multiple disks into 
a single lun, then the target id is whatever the target id for the lun is.  
The drives that are actually behind the logical lun are *never* exposed to 
the scsi layer.  If you are talking about using the md raid code to map 
several disks into a single md device, then it's the job of the md code to 
remap all incoming requests to point to the proper hard disk, and in the 
process of doing so it rewrites the target id, the lun, and the block 
address to the correct values for the underlying physical disk.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
