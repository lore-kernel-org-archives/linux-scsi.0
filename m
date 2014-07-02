From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 3.15 099/139] libiscsi, iser: Adjust data_length to
 include protection information
Date: Wed, 02 Jul 2014 17:19:35 -0600
Message-ID: <1404343175.1862.74.camel@ul30vt.home>
References: <20140628174605.352098823@linuxfoundation.org>
	 <20140628174609.930049472@linuxfoundation.org>
	 <1404339330.1862.69.camel@ul30vt.home> <53B48B37.4000608@cs.wisc.edu>
	 <1404341555.16066.19.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1404341555.16066.19.camel@dabdike>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-07-02 at 15:52 -0700, James Bottomley wrote:
> On Wed, 2014-07-02 at 17:44 -0500, Mike Christie wrote:
> > On 07/02/2014 05:15 PM, Alex Williamson wrote:
> > > On Sat, 2014-06-28 at 10:47 -0700, Greg Kroah-Hartman wrote:
> > >> > 3.15-stable review patch.  If anyone has any objections, please let me know.
> > >> > 
> > >> > ------------------
> > >> > 
> > >> > From: Sagi Grimberg <sagig@mellanox.com>
> > >> > 
> > >> > commit d77e65350f2d82dfa0557707d505711f5a43c8fd upstream.
> > >> > 
> > >> > In case protection information exists over the wire
> > >> > iscsi header data length is required to include it.
> > >> > Use protection information aware scsi helpers to set
> > >> > the correct transfer length.
> > >> > 
> > >> > In order to avoid breakage, remove iser transfer length
> > >> > checks for each task as they are not always true and
> > >> > somewhat redundant anyway.
> > >> > 
> > >> > Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> > >> > Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
> > >> > Acked-by: Mike Christie <michaelc@cs.wisc.edu>
> > >> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > >> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >> > 
> > >> > ---
> > >> >  drivers/infiniband/ulp/iser/iser_initiator.c |   34 +++++++--------------------
> > >> >  drivers/scsi/libiscsi.c                      |   18 +++++++-------
> > >> >  2 files changed, 19 insertions(+), 33 deletions(-)
> > > I'm a bit late to object, but this is causing a regression for me on
> > > 3.15.3 and 3.16-rc.  Using an iscsi_tcp rootfs, I'm seeing the NULL
> > 
> > 
> > A fix for this is in Christoph's tree. Here is the status of the patch.
> > 
> > http://marc.info/?l=linux-kernel&m=140432482527273&w=2
> 
> I assume it's this fix:
> 
> commit 7bafc240e126c37f60b040fa429ae4a710b88ab5
> Author: Martin K. Petersen <martin.petersen@oracle.com>
> Date:   Tue Jun 24 16:59:35 2014 +0200
> 
>     scsi: use the scsi data buffer length to extract transfer size
>  
> In which case it's not marked for stable backport ... I assume it should
> be?

Yes, that's the one.  It definitely needs a 3.15 stable backport.
Thanks,

Alex
