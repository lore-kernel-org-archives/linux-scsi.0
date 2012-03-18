From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 2/2] Drivers: scsi: storvsc: Don't pass ATA_16 command
	to the host
Date: Sun, 18 Mar 2012 01:40:51 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B767B28@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1331929448-6838-1-git-send-email-kys@microsoft.com>
	<1331929472-6877-1-git-send-email-kys@microsoft.com>
	<1331929472-6877-2-git-send-email-kys@microsoft.com>
	<4F64A80C.6040206@garzik.org> <4F64DE2C.1030809@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces@linuxdriverproject.org>
In-Reply-To: <4F64DE2C.1030809@interlog.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/devel>,
	<mailto:devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/devel>
List-Post: <mailto:devel@linuxdriverproject.org>
List-Help: <mailto:devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/devel>,
	<mailto:devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: devel-bounces@linuxdriverproject.org
Sender: devel-bounces@linuxdriverproject.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>, Jeff Garzik <jeff@garzik.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Douglas Gilbert [mailto:dgilbert@interlog.com]
> Sent: Saturday, March 17, 2012 2:56 PM
> To: Jeff Garzik
> Cc: KY Srinivasan; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 2/2] Drivers: scsi: storvsc: Don't pass ATA_16 command to
> the host
> 
> On 12-03-17 04:04 PM, Jeff Garzik wrote:
> > On 03/16/2012 04:24 PM, K. Y. Srinivasan wrote:
> >> The current Windows hosts don't handle the ATA_16 command and
> furthermore
> >> return a generic error code after filtering the command on the host side.
> >> For now filter the command on the guest side until the host is modified to
> >> properly handle unsupported commands.
> >>
> >> Signed-off-by: K. Y. Srinivasan<kys@microsoft.com>
> >> Reviewed-by: Haiyang Zhang<haiyangz@microsoft.com>
> >> ---
> >> drivers/scsi/storvsc_drv.c | 9 +++++++++
> >> 1 files changed, 9 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> >> index 8b967c9..783bab8 100644
> >> --- a/drivers/scsi/storvsc_drv.c
> >> +++ b/drivers/scsi/storvsc_drv.c
> >> @@ -1229,8 +1229,17 @@ static bool storvsc_scsi_cmd_ok(struct scsi_cmnd
> *scmnd)
> >> /*
> >> * smartd sends this command and the host does not handle
> >> * this. So, don't send it.
> >> + * The current Windows hosts implement a subset of scsi commands
> >> + * and for the commands that are not implemented, the host filters
> >> + * them and returns a generic failure SRB status. I have been in
> >> + * discussions with the Windows team to return the appropriate SRB
> >> + * status code for unsupported scsi commands and while they have
> >> + * agreed to implement this, it is not clear when this change will be
> >> + * available. Consequently, filtering the command before submitting it
> >> + * to the host is a resonable interim solution.
> >> */
> >> case SET_WINDOW:
> >> + case ATA_16:
> >> scmnd->result = ILLEGAL_REQUEST<< 16;
> >> allowed = false;
> >
> > It would be even nicer to fill out a nice SCSI status for this. For an illegal
> > request such as this, the libata SCSI simulator (drivers/ata/libata-scsi.c) uses
> > a more complete sense buffer setup,
> >
> > static void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk,
> > u8 asc, u8 ascq)
> > {
> > cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
> >
> > scsi_build_sense_buffer(0, cmd->sense_buffer, sk, asc, ascq);
> > }
> >
> > and calls this function for invalid/unknown/unsupported command ops thusly,
> >
> > ata_scsi_set_sense(cmd, ILLEGAL_REQUEST, 0x20, 0x0);
> > /* "Invalid command operation code" */
> >
> > Supplying asc/ascq provides additional information that may be useful in
> > determining whether or not to retry, provide better error diagnostics, etc.
> >
> > The asc/ascq values are found in the SCSI standards documents.
> 
> Jeff,
> I agree with your suggestion and would point out that the
> originally proposed:
>      scmnd->result = ILLEGAL_REQUEST<<  16;
> 
> is just plain wrong. result[23:16] is a Linux invented host byte
> code (they typically start with "DID_") while ILLEGAL_REQUEST is
> a SCSI sense key.
> 
> Doug Gilbert
> 
Jeff, Doug,

Thank you. I will make the suggested changes.

Regards,

K. Y
