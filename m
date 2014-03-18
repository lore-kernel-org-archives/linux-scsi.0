From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 6/6] Invalidate VPD page data
Date: Tue, 18 Mar 2014 13:23:59 +0000
Message-ID: <1395149038.2214.2.camel@dabdike.int.hansenpartnership.com>
References: <1394873512-102073-1-git-send-email-hare@suse.de>
	 <1394873512-102073-7-git-send-email-hare@suse.de>
	 <53277311.9000105@tributary.com> <5327ED4A.9020202@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:40169 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbaCRNYJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Mar 2014 09:24:09 -0400
In-Reply-To: <5327ED4A.9020202@suse.de>
Content-Language: en-US
Content-ID: <6FB0BC591F573F48850C7DC98333C173@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jlinton@tributary.com" <jlinton@tributary.com>

On Tue, 2014-03-18 at 07:52 +0100, Hannes Reinecke wrote:
> On 03/17/2014 11:11 PM, Jeremy Linton wrote:
> > On 3/15/2014 3:51 AM, Hannes Reinecke wrote:
> >> Add a flag 'vpd_invalid' to the SCSI device to indicate that
> >> the VPD data needs to be refreshed. This is required if
> >> either a manual rescan is triggered or if the sense code
> >> INQUIRY DATA HAS CHANGED has been received.
> > 
> > 
> >> --- a/drivers/scsi/scsi_error.c +++
> >> b/drivers/scsi/scsi_error.c @@ -393,6 +393,7 @@ static void
> >> scsi_report_sense(struct scsi_device *sdev,
> > 
> >> if (sshdr->sense_key == UNIT_ATTENTION) { if (sshdr->asc ==
> >> 0x3f && sshdr->ascq == 0x03) { +			sdev->vpd_invalid = 1;
> > 
> > 
> > I didn't study the whole code path but does the VPD data get
> > updated on a 6/2900? I suspect it should be. I can imagine a
> > number of cases where the luns changed check condition gets 
> > preempted/lost by a device reset. I guess much of that should
> > be masked by the port login/logout, but its probably better to
> > be safe...
> > 
> Argl.
> 
> I was hoping to avoid that; I've already had a rather lengthy
> discussion with NetApp about handling Power-on-Reset UA.
> 
> We should be discussion that at LSF; Power-on-Reset UA handling
> (and queued UA handling in general) has some implications which
> could do with a proper elaboration. Rumours have it that Fred
> Knight from NetApp will also at LSF, so we'll have someone to ask
> for any technical issues :-).

You don't have to rely on rumour; the attendee list is online:

https://docs.google.com/spreadsheet/pub?key=0ArurRVMVCSnkdHU2Zk1KbFhmeVZFVmFMQ19nakJYaFE&gid=1

I'm not sure there's a full session on power on/reset UA handling.
Right at the moment, we eat any UA after a reset.  Perhaps we should
collect the sense and dump it if it's what we expect.

James


> And that's precisely why I hooked the 'sdev->vpd_invalid' flag
> into the 'rescan' attribute, so that it can be refreshed on demand.
> 
> Cheers,
> 
> Hannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


