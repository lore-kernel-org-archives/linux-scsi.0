From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH 7/9] scsi_dh: Add support for SDEV_PASSIVE
Date: Mon, 4 Feb 2008 12:26:09 -0800
Message-ID: <20080204202609.GA25738@linux.vnet.ibm.com>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
	<20080124003203.18871.52040.sendpatchset@localhost.localdomain>
	<1202151498.3096.84.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1202151498.3096.84.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: michaelc@cs.wisc.edu, dm-devel@redhat.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> On Wed, 2008-01-23 at 16:32 -0800, Chandra Seetharaman wrote:
> > Subject: scsi_dh: Add support for SDEV_PASSIVE
> > 
> > From: Chandra Seetharaman <sekharan@us.ibm.com>
> > 
> > This patch adds a new device state SDEV_PASSIVE, to correspond to the
> > passive side access of an active/passive multipathed device.
> 
> Really, no; this isn't right.  The state field of a SCSI device is for
> the SCSI state model.  Passive might be a valid device mapper state, but
> it's not a valid SCSI state.  If these patches can't work except by
> mucking with the SCSI state model, there's some layering problem
> elsewhere that needs sorting out.
> 

It is actually a valid state for this device and a number of other
devices that have passive / active controller. There are differences in
response capability (i.e., media access commands) on certain sds until a
fail over command is given. The response behavior difference along with
all the partition scanning and other commands that get generated during
the probing of a device are what leads to the long boot times previously
mentioned by Chandra.

Since we have created a policy to remove the vendor specific multipath
drivers that handled the aggregation of the paths into a single device we
need some method to handle devices that are not fully capable, but are
still expose to the upper layers.

The patches are also addressing a long standing issue of sense data
processing, but that is not related to the SDEV_* state comment.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
