From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/6] RFC: beiscsi: iscsi hook in and handling code
Date: Fri, 28 Aug 2009 00:00:56 -0500
Message-ID: <4A976488.3020708@cs.wisc.edu>
References: <20090827221905.bf8a1508@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51607 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbZH1FBC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Aug 2009 01:01:02 -0400
In-Reply-To: <20090827221905.bf8a1508@mailhost.serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org

Jayamohan Kalickal wrote:
>   > +
>   > + cls_session =
>   > +  iscsi_session_setup(&beiscsi_iscsi_transport, shost, cmds_max,
>   
>   
>   
>   Was there any limit on the number of commands per session? What about
>   per port/scsi_host?
>      The maximum number of commands is the queuedepth. Yes , we have a limit per port(scsi_host ) as well.  Am I required to specify them here. I haven't understood the comment.
> 

I was actually just asking because I was curious and because I was 
wondering about what was going on below.

The host limit should just get set in scsi_host_template->can_queue (you 
did this already). Then nelow you do not want to set the 
shost->can_queue to cmds_max.

Did the queuedepth comment mean you have a per session limit too? If so 
then you at least want to do a min(cmds_max, your_max_queue_depth) to 
make sure the iscsi layer does not send more commands than you can handle.
