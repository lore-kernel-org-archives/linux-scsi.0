From: <Shyam_Iyer@Dell.com>
Subject: RE: [LSF/MM Topic] SCSI Unit Attention Handling
Date: Mon, 7 Feb 2011 04:02:00 +0530
Message-ID: <DBFB1B45AF80394ABD1C807E9F28D1570264CAA097@BLRX7MCDC203.AMER.DELL.COM>
References: <AANLkTikARn9U17fVKDo+dgyfz554LV=Dz+_M_xB5dfe+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:22757 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab1BFWd4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Feb 2011 17:33:56 -0500
In-Reply-To: <AANLkTikARn9U17fVKDo+dgyfz554LV=Dz+_M_xB5dfe+@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: realrichardsharpe@gmail.com, lsf-pc@lists.linuxfoundation.org, linux-scsi@vger.kernel.org, hare@suse.de



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Richard Sharpe
> Sent: Sunday, February 06, 2011 3:44 PM
> To: lsf-pc@lists.linuxfoundation.org; linux-scsi; Hannes Reinecke
> Subject: [LSF/MM Topic] SCSI Unit Attention Handling
> 
> I would like to propose a topic around SCSI Unit Attention Handling.
> 
> The current scsi_error.c:scsi_check_sense handling of UNIT ATTENTION
> consists of explicitly printing warnings for for ASC=0x3f events and
> then returning SOFT_ERROR which scsi_error.c:scsi_decide_disposition
> ignores because it returns SUCCESS to SOFT_ERROR being returned from
> scst_check_sense on a CHECK_CONDITION.
> 
> There are a number of cases where we might want to perform further
> processing on a UNIT ATTENTION. For example, ASC/ASCQ 0x3f/0x0e
> REPORTED LUNS DATA HAS CHANGED or 0x2a/0x09 CAPACITY DATA HAS CHANGED,
> 0x28/0x03 IMPORT/EXPORT ELEMENT ACCESSED, MEDIUM CHANGED, etc. When
> the LUNS have changed it would be useful to have a recan performed
> automatically. If capacity data has changed, it would be useful if
> someone could react to that and perhaps resize the file system on that
> LUN if possible, and so forth.
> 
> It is not clear that any of these items should be handled in the
> kernel anyway, and perhaps they should be exported to user-space for
> correct handling, but rather than just the raw SENSE data being
> exported, perhaps some sort of relevant event should be exported.
> 
We spoke about this in the plumbers conf last November as well and the few ideas then was to handle them via scsi netlink.
I see that Hannes is working on a relayfs method to handle them.

Some of the new problems that we can see with handling such events are -

If the thin provisioned LUN is snapshotted or cloned then you can also get a flurry of UNIT attentions for the same data that has been replicated. 


> To avoid having to code all of the relevant combinations in the above
> routine, Hannes and I have been discussing a framework for handling
> this. Hannes suggested a notifier chain of some sort to deal with
> this, and points out that because the above routine is called in a
> softirq context we don't want to be performing lots of processing in
> that context.
> 
I guess my curiosity would be on why the scsi_netlink framework abandoned or possibly not considered..

> It seems that we need to defer processing of these items as well as
> provide some mechanism for drivers (sd.c, st.c, etc, to register the
> UNIT ATTENTIONs they are interested in). The registration seems quite
> straight forward ... each driver can provide a list of the ASC/ASCQ
> pairs they are interested in and a mapping to an event of some sort,
> but the issue then is how to defer this processing. One approach I
> have thought of is to extend the error handler thread to handle these
> sorts of events and on a UNIT ATTENTION give the command to the error
> handling thread. However, others might suggest that the processing
> done in the error handler thread should be moved to work queues
> anyway, and overloading the error handling thread like this is the
> wrong way to do this and that they would rather see the error handling
> thread go away.
> 
> So, I would like to have a discussion around the issues involved in
> providing some sort of a framework for letting drivers indicate what
> UNIT ATTENTIONS they are interested in and how to handle those, either
> by exporting them to userspace or providing a callback or other
> mechanism for handling them. We also need some discussion around
> communicating with user space. Whether to use uevent/udev, use netlink
> (Hannes suggests this has issues in heavy memory use cases), relayfs,
> etc.
I see that the uevent method has been tried in the past.. and I am not currently inclined to anything at the moment but I can think that although the events will follow T10 guidelines, the frequency of the events is vendor dependent and user configurable. So they need to be tied to a thin profile.

In another thread Douglas Gilbert talks about improving efficiency of sparse files and I think that such events can be very closely tied to creating profiles per LUN before formatting them and taking dynamic corrective actions.

-Shyam
> 
> --
> Regards,
> Richard Sharpe
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
