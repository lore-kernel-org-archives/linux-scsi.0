From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 3.15 099/139] libiscsi, iser: Adjust data_length to
 include protection information
Date: Wed, 02 Jul 2014 16:48:37 -0600
Message-ID: <1404341317.1862.71.camel@ul30vt.home>
References: <20140628174605.352098823@linuxfoundation.org>
	  <20140628174609.930049472@linuxfoundation.org>
	 <1404339330.1862.69.camel@ul30vt.home> <53B48B37.4000608@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <53B48B37.4000608@cs.wisc.edu>
Sender: stable-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-07-02 at 17:44 -0500, Mike Christie wrote:
> On 07/02/2014 05:15 PM, Alex Williamson wrote:
> > On Sat, 2014-06-28 at 10:47 -0700, Greg Kroah-Hartman wrote:
> >> > 3.15-stable review patch.  If anyone has any objections, please let me know.
> >> > 
> >> > ------------------
> >> > 
> >> > From: Sagi Grimberg <sagig@mellanox.com>
> >> > 
> >> > commit d77e65350f2d82dfa0557707d505711f5a43c8fd upstream.
> >> > 
> >> > In case protection information exists over the wire
> >> > iscsi header data length is required to include it.
> >> > Use protection information aware scsi helpers to set
> >> > the correct transfer length.
> >> > 
> >> > In order to avoid breakage, remove iser transfer length
> >> > checks for each task as they are not always true and
> >> > somewhat redundant anyway.
> >> > 
> >> > Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> >> > Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
> >> > Acked-by: Mike Christie <michaelc@cs.wisc.edu>
> >> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> >> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> > 
> >> > ---
> >> >  drivers/infiniband/ulp/iser/iser_initiator.c |   34 +++++++--------------------
> >> >  drivers/scsi/libiscsi.c                      |   18 +++++++-------
> >> >  2 files changed, 19 insertions(+), 33 deletions(-)
> > I'm a bit late to object, but this is causing a regression for me on
> > 3.15.3 and 3.16-rc.  Using an iscsi_tcp rootfs, I'm seeing the NULL
> 
> 
> A fix for this is in Christoph's tree. Here is the status of the patch.
> 
> http://marc.info/?l=linux-kernel&m=140432482527273&w=2

Thanks for the pointer.  It's curious why there was no objection to this
going into stable if it's been known to be broken for a week.
