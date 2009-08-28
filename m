From: "Jayamohan Kalickal" <jayamohank@serverengines.com>
Subject: Re: [PATCH 4/6] RFC: beiscsi: iscsi hook in and handling code
Date: Thu, 27 Aug 2009 22:19:05 -0700
Message-ID: <20090828051905.950e3bfc@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail142.messagelabs.com ([216.82.249.99]:36712 "EHLO
	mail142.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZH1FX2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2009 01:23:28 -0400
In-Reply-To: 4A976488.3020708@cs.wisc.edu
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org


Yes, there is a per session limit but it is not a hard one.
It is only used to limit memory usage for the send ring
and can be increased to shost->can_queue.

Currently, I have set the sendring to 256 depth.
--
----- Original Message -----
From: Mike Christie
[mailto:michaelc@cs.wisc.edu]
To: Jayamohan Kalickal
[mailto:jayamohank@serverengines.com]
Cc: linux-scsi@vger.kernel.org
Sent:
Thu, 27 Aug 2009 22:00:56 -0700
Subject: Re: [PATCH 4/6] RFC: beiscsi: iscsi
hook in and handling code


> Jayamohan Kalickal wrote:
> >   > +
> >   > + cls_session =
> >   > +  iscsi_session_setup(&beiscsi_iscsi_transport, shost, cmds_max,
> >   
> >   
> >   
> >   Was there any limit on the number of commands per session? What about
> >   per port/scsi_host?
> >      The maximum number of commands is the queuedepth. Yes , we have a
> limit per port(scsi_host ) as well.  Am I required to specify them here. I
> haven't understood the comment.
> > 
> 
> I was actually just asking because I was curious and because I was 
> wondering about what was going on below.
> 
> The host limit should just get set in scsi_host_template->can_queue (you 
> did this already). Then nelow you do not want to set the 
> shost->can_queue to cmds_max.
> 
> Did the queuedepth comment mean you have a per session limit too? If so 
> then you at least want to do a min(cmds_max, your_max_queue_depth) to 
> make sure the iscsi layer does not send more commands than you can handle.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

___________________________________________________________________________________
This message, together with any attachment(s), contains confidential and proprietary information of
ServerEngines Corporation and is intended only for the designated recipient(s) named above. Any unauthorized
review, printing, retention, copying, disclosure or distribution is strictly prohibited.  If you are not the
intended recipient of this message, please immediately advise the sender by reply email message and
delete all copies of this message and any attachment(s). Thank you.

