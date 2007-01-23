From: Aboo Valappil <aboo@aboo.org>
Subject: Re: Linux Virtual SCSI HBAs and Virtual disks
Date: Wed, 24 Jan 2007 00:11:47 +1100
Message-ID: <45B60993.9070508@aboo.org>
References: <1e157f74d8578f24c762571c1016aab3@aboo.org> <b43c8fc9882e65d397a6465e6cb7c998@aboo.org> <45B4EAAC.5000008@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ppp245-155.static.internode.on.net ([59.167.245.155]:42693 "EHLO
	goobu.aboo.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965005AbXAWNMM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2007 08:12:12 -0500
In-Reply-To: <45B4EAAC.5000008@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

Hi Stefan Richter,

Thanks everyone for their advice on this. As per your advice, I did the 
following when the last user space target serving the scsi_host quits, 
the queue command will do the following on the new commands coming through.

                sc->result = DID_NO_CONNECT << 16;
                sc->resid = sc->request_bufflen;
                set_sensedata_commfailure(sc);  --------------------- 
This sets the sense buffer with Device Not ready/Logical Unit 
Commincation failure.
                done(sc);

The scsi_host will remain in the kernel. Let the EH thread handle the 
queued commands (If any). If the user target wants to reconnects to the 
same scsi_host, it can do so (Just re-run the user space target again 
with same command line paramters).  This connection from newly started 
target will make the HBA healthy again and start serving IO.

I implemented a new IOCTL to remove  this  scsi_host  if the user 
process really needs to.  This removal  will first  finish all the SCSI 
commands (With the above status results) queued on the scsi_host  (If at 
all) and then remove the scsi_host.  Also the module unload will delete 
all the scsi_hosts created after finishing all the commands queued with 
the above status and sense information.

I also implemented passing of sense code information from user space to 
sense_buffer. A little more work needs to be done on this.
Also, I need to make sure that all the locking used inside is correctly 
implemented to prevent dead locks and improve efficiency.

The new version is available http://vscsihba.aboo.org/vscsihbav204.gz

Aboo

Stefan Richter wrote:
> aboo wrote:
>   
>> Can I use the following method safely to know if a scsi_device is
>> open or not?
>>
>> if ( atomic_read(&sdev->sdev_gendev.kobj.kref.refcount) > 14 ) {
>>   //sdev is in use
>> }
>>     
>
> No, this too relies far too much on implementation details of upper
> layers. (Besides, what if the device is opened right after that? The
> atomic refcount is not enough, something mutex-like would be necessary
> to do anything useful with the information "open"/"not open".) Ideally,
> your LLD sticks with what the Linux SCSI mid-low API has to offer. Thus
> your LLD is only aware of this API, but *not* of implementation details
> of the SCSI core, let alone SCSI high-level drivers or block I/O
> subsystem or whatever other upper layer.
>
> And in the end, why should vscsihba care whether a scsi_device is in use
> or not? If a userspace device server quits or got killed or crashed,
> "simply" let vscsihba request the removal of the scsi_device (or the
> entire host if there is only one device per host). Whoever opened the
> device cannot do anything useful with it anymore anyway when there is no
> device server.
>
> Of course it is not entirely as "simple" as it sounds. As mentioned, if
> vscsihba becomes aware that a device server quit or crashed, let your
> queuecommand hook finish all newly incoming commands immediately instead
> of enqueueing them. Dequeue and finish all outstanding commands. Make
> sure the eh hooks don't wait for something that can't happen anymore.
> Note that when the removal of a device is requested, shutdown methods of
> high-level drivers like sd become active and may try to issue new
> commands (such as to synchronize disk caches). Therein lies potential
> for deadlocks or, less critically, for minutes and minutes spent in
> futile error recovery attempts.
>
> So, I said you should ignore the in-use state of a scsi_device. Of
> course that way you cannot give the userspace device server a status
> notification from vscsihba which says "keep running for now, somebody is
> using your device", or vice versa: "your last user went away, you can
> safely quit now if you feel like it". But in my opinion you don't really
> need such status notification in foreseeable future. vscsihba would
> primarily or exclusively be used in controlled setups where the
> administrator knows very well when it is safe to terminate a userspace
> device server. Besides, you have to take into account anyway that a
> userspace device server is killed or crashed when its device was in use.
>
> As I wrote before, deal with it like with hot-unplug. A kernel driver
> cannot prevent the user from pulling a cable.
>   

