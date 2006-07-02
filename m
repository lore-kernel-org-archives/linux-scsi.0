From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Receiving a SCSI response after abort task was sent
Date: Sun, 02 Jul 2006 11:54:26 -0400
Message-ID: <44A7EC32.1010904@emulex.com>
References: <44A7A547.6080709@voltaire.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:34443 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932399AbWGBPyg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Jul 2006 11:54:36 -0400
In-Reply-To: <44A7A547.6080709@voltaire.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Erez Zilber <erezz@voltaire.com>
Cc: linux-scsi@vger.kernel.org



Erez Zilber wrote:
> Hi,
> 
> I have a question about aborting tasks: when an initiator sends "abort 
> task" to the target, it is possible that the target will send a SCSI 
> response for the same task before receiving the abort task (I guess that 
> the target won't send a task management response for the abort task). 

Yes - as the 2 may be in flight simultaneously (depending on the SCSI
transport type). And yes, the target will respond to the task management
response, but may tell you it failed or that the task didn't exist.

> What should the initiator do with the SCSI response? Is the host that 
> issued the abort task willing to receive a SCSI response for that task? 
> Is it willing to receive only a task management response for the abort 
> task?

Well, this is macrocosm of other race conditions that can still exist
within the software/driver/adapter.  The recommended approach has been:
if the i/o completes (good or bad) before the task mgmt response,
complete it with whatever response is appropriate (usually ignoring the
fact that there was a request to abort it) - as you are reporting the
true state of the io - which means if it changed media, you have a
chance of knowing that above.  In the abort handler, if the tmf completes
indicating it couldn't find the i/o and the driver no longer has the i/o
in it's queues, you would just return "success" to the request (an abort
of nothing is successful :).   Keep in mind that this has another
implication that should be maintained - that of status from the i/o being
returned prior to status of the tmf - whether the status is returned from
an adapter, or by the driver.

-- james s

