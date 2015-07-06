From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCHv2] sd: retry READ CAPACITY for ALUA state transition
Date: Mon, 06 Jul 2015 21:57:24 +0100
Message-ID: <1436216244.6241.7.camel@HansenPartnership.com>
References: <1436181130-82905-1-git-send-email-hare@suse.de>
	 <559A9B23.4020705@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46621 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754388AbbGFU5c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2015 16:57:32 -0400
In-Reply-To: <559A9B23.4020705@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Mon, 2015-07-06 at 08:13 -0700, Bart Van Assche wrote:
> On 07/06/2015 04:12 AM, Hannes Reinecke wrote:
> > During ALUA state transitions the device might return
> > a sense code 02/04/0a (Logical unit not accessible, asymmetric
> > access state transition). As this is a transient error
> > we should just retry the READ CAPACITY call after 1 second
> > until the state transition finishes and the correct
> > capacity can be returned.
> > At the same time we should break out of the loop after
> > 2 minutes to avoid unbounded retries.
> >
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> > ---
> >   drivers/scsi/sd.c | 21 +++++++++++++++++++++
> >   1 file changed, 21 insertions(+)
> >
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index 3b2fcb4..f45b8fe 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -1934,6 +1934,7 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
> >   #endif
> >
> >   #define READ_CAPACITY_RETRIES_ON_RESET	10
> > +#define READ_CAPACITY_RETRIES_ON_TRANSITION 120
> >
> >   static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
> >   						unsigned char *buffer)
> > @@ -1943,6 +1944,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
> >   	int sense_valid = 0;
> >   	int the_result;
> >   	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
> > +	int transition_retries = READ_CAPACITY_RETRIES_ON_TRANSITION;
> >   	unsigned int alignment;
> >   	unsigned long long lba;
> >   	unsigned sector_size;
> > @@ -1981,6 +1983,15 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
> >   				 * give it one more chance */
> >   				if (--reset_retries > 0)
> >   					continue;
> > +			if (sense_valid &&
> > +			    sshdr.sense_key == NOT_READY &&
> > +			    sshdr.asc == 0x04 && sshdr.ascq == 0x0A) {
> > +				/* ALUA state transition; retry after delay */
> > +				if (--transition_retries > 0) {
> > +					msleep(1000);
> > +					continue;
> > +				}
> > +			}
> >   		}
> >   		retries--;
> >
> > @@ -2039,6 +2050,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
> >   	int sense_valid = 0;
> >   	int the_result;
> >   	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
> > +	int transition_retries = READ_CAPACITY_RETRIES_ON_TRANSITION;
> >   	sector_t lba;
> >   	unsigned sector_size;
> >
> > @@ -2063,6 +2075,15 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
> >   				 * give it one more chance */
> >   				if (--reset_retries > 0)
> >   					continue;
> > +			if (sense_valid &&
> > +			    sshdr.sense_key == NOT_READY &&
> > +			    sshdr.asc == 0x04 && sshdr.ascq == 0x0A) {
> > +				/* ALUA state transition; retry after delay */
> > +				if (--transition_retries > 0) {
> > +					msleep(1000);
> > +					continue;
> > +				}
> > +			}
> >   		}
> >   		retries--;
> 
> Hello Hannes,
> 
> Although I agree that multipathd should handle arrays correctly that 
> fail READ CAPACITY commands while transitioning, seeing that a new 
> hard-coded timeout is added in the SCSI initiator code does not make me 
> enthusiast. The READ_CAPACITY_RETRIES_ON_TRANSITION timeout added 
> through this patch is independent of the IMPLICIT TRANSITION TIME in the 
> REPORT TARGET PORT GROUPS response. Has the following already been 
> considered ?
> - If the capacity is not known, let the scsi_dh_alua handler submit a 
> READ CAPACITY command asynchronously after certain target port group 
> state transitions. Also let the scsi_dh_alua handler submit a 
> notification to user space after the capacity changes from "unknown" to 
> "known".
> - Let multipathd ignore paths for which READ CAPACITY failed until the 
> capacity becomes known.

Yes, I'm with something like this.  The patch you propose will be a busy
wait for userspace which they may not want.

James


