From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: virtio_scsi: SCSI host lock push-down
Date: Fri, 02 Dec 2011 13:45:43 -0800
Message-ID: <1322862343.25673.0.camel@haakon2.linux-iscsi.org>
References: <1322860424-21640-1-git-send-email-bigeasy@linutronix.de>
	 <1322862236.23492.10.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1322862236.23492.10.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2011-12-02 at 13:43 -0800, Nicholas A. Bellinger wrote:
> On Fri, 2011-12-02 at 22:13 +0100, Sebastian Andrzej Siewior wrote:
> > Commit f281233d aka ("SCSI host lock push-down") was converting all
> > drivers in tree. It looks to me that those two were not omitted on
> > purpose. tcm_loop joined the tree after the conversion and virtio_scsi
> > lives only in Nicholas' lio tree. So here is an equivalent change for
> > those two.
> > 
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > ---
> > Having a differnt callback name for converted and not converted users
> > would probably make it easier to tell them apart.
> > 
> >  drivers/scsi/virtio_scsi.c         |    4 +++-
> >  drivers/target/loopback/tcm_loop.c |    4 +++-
> >  2 files changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> > index 7946f40..4c577fa 100644
> > --- a/drivers/scsi/virtio_scsi.c
> > +++ b/drivers/scsi/virtio_scsi.c
> > @@ -151,7 +151,7 @@ static void virtscsi_map_cmd(struct virtio_scsi *vscsi, struct scsi_cmnd *sc,
> >  	sg_set_buf(&sg[idx++], &cmd->footer, sizeof(cmd->footer));
> >  }
> >  
> > -static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
> > +static int virtscsi_queuecommand_lck(struct Scsi_Host *sh, struct scsi_cmnd *sc)
> >  {
> >  	struct virtio_scsi *vscsi = shost_priv(sh);
> >  	struct virtio_scsi_cmd *cmd;
> > @@ -190,6 +190,8 @@ static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
> >  	return ret;
> >  }
> >  
> > +static DEF_SCSI_QCMD(virtscsi_queuecommand);
> > +
> >  static struct scsi_host_template virtscsi_host_template = {
> >  	.module = THIS_MODULE,
> >  	.name = "Virtio SCSI HBA",
> > diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> > index 5f69594..92ef58a 100644
> > --- a/drivers/target/loopback/tcm_loop.c
> > +++ b/drivers/target/loopback/tcm_loop.c
> > @@ -266,7 +266,7 @@ static int tcm_loop_change_queue_depth(
> >   * Main entry point from struct scsi_host_template for incoming SCSI CDB+Data
> >   * from Linux/SCSI subsystem for SCSI low level device drivers (LLDs)
> >   */
> > -static int tcm_loop_queuecommand(
> > +static int tcm_loop_queuecommand_lck(
> >  	struct Scsi_Host *sh,
> >  	struct scsi_cmnd *sc)
> >  {
> > @@ -310,6 +310,8 @@ static int tcm_loop_queuecommand(
> >  	return 0;
> >  }
> >  
> > +static DEF_SCSI_QCMD(tcm_loop_queuecommand)
> > +
> >  /*
> >   * Called from SCSI EH process context to issue a LUN_RESET TMR
> >   * to struct scsi_device
> 
> Both of these are already running in 'hock_lock-less' mode as they
> should be, and there is no reason why it should be using DEF_SCSI_QCMD()
> in order to revert to holding hock_lock.

Or host_lock even..

--nab
