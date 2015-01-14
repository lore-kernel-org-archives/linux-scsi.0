From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm + blk-mq soft lockup complaint
Date: Wed, 14 Jan 2015 13:59:26 -0500
Message-ID: <20150114185926.GB6012@redhat.com>
References: <54B40E8A.6010005@kernel.dk>
 <alpine.LNX.2.00.1501121818510.4026@localhost.lm.intel.com>
 <alpine.LNX.2.00.1501121830010.4026@localhost.lm.intel.com>
 <20150112191138.GC21518@redhat.com>
 <20150112202113.GA23234@redhat.com>
 <54B50F9D.2040000@sandisk.com>
 <20150113141746.GA30411@redhat.com>
 <54B52B73.7040807@sandisk.com>
 <20150113162052.GA30837@redhat.com>
 <54B633DC.4090806@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbbANTAB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2015 14:00:01 -0500
Content-Disposition: inline
In-Reply-To: <54B633DC.4090806@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, linux-scsi@vger.kernel.org

On Wed, Jan 14 2015 at  4:16am -0500,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 01/13/15 17:21, Mike Snitzer wrote:
> > OK, I assume you specified the mpath device for the test that failed.
> 
> Yes, of course ...
> 
> > This test works fine on my 100MB scsi_debug device with 4 paths exported
> > over virtio-blk to a guest that assembles the mpath device.
> > 
> > Could be a hang that is unique to scsi-mq.
> > 
> > Any chance you'd be willing to provide a HOWTO for setting up your
> > SRP/iscsi configuration?
> > 
> > Are you carrying any related changes that are not upstream?  (I can hunt
> > down the email in this thread where you describe your kernel tree...)
> > 
> > I'll try to reproduce but this info could be useful to others that are
> > more scsi-mq inclined who might need to chase this too.
> 
> The four patches I had used in my tests at the initiator side and that
> are not yet in v3.19-rc4 have been attached to this e-mail (I have not
> yet had the time to post all of these patches for review).
> 
> This is how my I had configured the initiator system:
> * If the version of the srptools package supplied by your distro is
> lower than 1.0.2, build and install the latest version from the source
> code available at git://git.openfabrics.org/~bvanassche/srptools.git/.git.
> * Install the latest version of lsscsi
> (http://sg.danny.cz/scsi/lsscsi.html). This version has SRP transport
> support but is not yet in any distro AFAIK.
> * Build and install a kernel >= v3.19-rc4 that includes the dm patches
> at the start of this e-mail thread.
> * Check whether the IB links are up (should display "State: Active"):
> ibstat | grep State:
> * Spread completion interrupts statically over CPU cores, e.g. via the
> attached script (spread-mlx4-ib-interrupts).
> * Check whether the SRP target system is visible from the SRP initiator
> system - the command below should print at least one line:
> ibsrpdm -c
> * Enable blk-mq:
> echo Y > /sys/module/scsi_mod/parameters/use_blk_mq
> * Configure the SRP kernel module parameters as follows:
> echo 'options ib_srp cmd_sg_entries=255 dev_loss_tmo=60 ch_count=6' >
> /etc/modprobe.d/ib_srp.conf
> * Unload and reload the SRP initiator kernel module to apply these
> parameters:
> rmmod ib_srp; modprobe ib_srp
> * Start srpd and wait until SRP login has finished:
> systemctl start srpd
> while ! lsscsi -t | grep -q srp:; do sleep 1; done
> * Start multipathd and check the table it has built:
> systemctl start multipathd
> dmsetup table /dev/dm-0
> * Set the I/O scheduler to noop, disable add_random and set rq_affinity
> to 2 for all SRP and dm block devices.
> * Run the I/O load of your preference.

Thanks for all this info.  But I don't have an IB setup readily
available to test with.  We are setting up an IB testbed in the lab and
can hopefully work through your setup in the coming weeks.

IB aside, I haven't been following along close enough on scsi-mq
developments, but does a regular iscsi initiator have support for
scsi-mq?  I'd like to validate scsi-mq devices with the dm-mpath
changes.

Mike
